/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.receiving;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;
import com.project.ccs.postransaction.stock.*;

/**
 *
 * @author Roy
 */
public class CmdReceiveAdjusment extends Control implements I_Language {
    
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private Receive receive;
    private DbReceive dbReceive;
    private JspReceive jspReceive;
    int language = LANGUAGE_DEFAULT;
    private Date dueDate = new Date();
    
    public CmdReceiveAdjusment(HttpServletRequest request) {
        msgString = "";
        receive = new Receive();
        try {
            dbReceive = new DbReceive(0);
        } catch (Exception e) {
            
        }
        jspReceive = new JspReceive(request, receive);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:                
                return resultText[language][RSLT_EST_CODE_EXIST];
            default:
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }

    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                return RSLT_EST_CODE_EXIST;
            default:
                return RSLT_UNKNOWN_ERROR;
        }
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public Receive getReceive() {
        return receive;
    }

    public JspReceive getForm() {
        return jspReceive;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    synchronized public int action(int cmd, long oidReceive) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                jspReceive.requestEntityObject(receive);
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (Exception exc) {
                    }
                }
                break;
                
            case JSPCommand.EDIT:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
            
            case JSPCommand.POST:
                
                long userId = 0;                
                Date docDate = new Date();
                String oldStatus = "DRAFT";
                
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                        docDate = receive.getDate();
                        oldStatus = receive.getStatus();
                        userId = receive.getUserId();                        
                    } catch (Exception exc) {}
                }

                jspReceive.requestEntityObject(receive);
                
                //kembalikan tanggal - jam - menit membuat ke awal
                receive.setDate(docDate);
                
                //approval check ----------------
                if(receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){                    
                    receive.setApproval1(0);                    
                    receive.setApproval2(0);                    
                    receive.setApproval3(0);
                    //jika status tidak draft tidak boleh update
                    if(!oldStatus.equals(I_Project.DOC_STATUS_DRAFT)){
                        jspReceive.addError(jspReceive.JSP_APPROVAL_1, "Document have been locked for update - current status "+oldStatus);
                        receive.setStatus(oldStatus);
                    }
                } else if(receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){                    
                    receive.setDueDate(dueDate);
                    receive.setApproval1(receive.getUserId());
                    receive.setApproval1Date(dueDate);                    
                    receive.setUserId(userId);                    
                    receive.setApproval2(0);                    
                    receive.setApproval3(0);
                }
                
                if(receive.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){
                    if(receive.getClosedReason()==null || receive.getClosedReason().length()<1){
                        jspReceive.addError(jspReceive.JSP_CLOSED_REASON, "Entry Required");
                    }
                }
                
                if(receive.getPurchaseId()!=0){
                    if(receive.getDoNumber().length()==0){
                        jspReceive.addError(jspReceive.JSP_DO_NUMBER, "Entry Required");
                    }
                    
                    if(receive.getInvoiceNumber().length()==0){
                        jspReceive.addError(jspReceive.JSP_INVOICE_NUMBER, "Entry Required");
                    }
                }
                
                if(oidReceive==0){
                    jspReceive.addError(jspReceive.JSP_INVOICE_NUMBER, "Please select an incoming document");
                }
                
                if (jspReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (receive.getOID() != 0) {
                
                    try {
                        System.out.println("Date "+JSPFormater.formatDate(receive.getDate()));
                        System.out.println("Due date "+JSPFormater.formatDate(receive.getDueDate()));
                        long oid = dbReceive.updateExc(this.receive);
                             
                        if(oid!=0 && receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                            DbStock.delete(DbStock.colNames[DbStock.COL_INCOMING_ID]+"="+ receive.getOID());
                            DbReceiveItem.proceedStock(receive);//tambah stock dan update cogs                            
                        }
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;    
            
            default:

        }
        return rsCode;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

}
