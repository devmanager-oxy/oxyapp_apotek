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
import com.project.ccs.posmaster.DbStockCode;
import com.project.ccs.postransaction.stock.*;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.system.DbSystemProperty;


public class CmdReceive extends Control implements I_Language {

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

    public CmdReceive(HttpServletRequest request) {
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
            
            case JSPCommand.BACK:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (Exception exc) {
                    }
                }
                break;    
                
            case JSPCommand.VIEW:
                
                jspReceive.requestEntityObject(receive);
                break;
            
            case JSPCommand.REFRESH:
                
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);                        
                    } catch (Exception exc) {}
                }
                
                jspReceive.requestEntityObject(receive);
                break;    
                
                
            case JSPCommand.SAVE:
                
                Date docDate = new Date();
                String oldStatus = "";
                
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                        docDate = receive.getDate();
                        oldStatus = receive.getStatus();
                    } catch (Exception exc) {
                    }
                }

                jspReceive.requestEntityObject(receive);
                
                //set back doc date
                if (oidReceive != 0) {
                    receive.setDate(docDate);
                }
                
                //jika status tidak draft tidak boleh update
                if(!oldStatus.equals(I_Project.DOC_STATUS_DRAFT) && !oldStatus.equals("") ){
                    jspReceive.addError(jspReceive.JSP_APPROVAL_1, "Document have been locked for update - current status "+oldStatus);
                    receive.setStatus(oldStatus);
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
                
                if (jspReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (receive.getOID() == 0) {
                    try {                        
                        int ctr = DbReceive.getNextCounter();
                        receive.setCounter(ctr);
                        receive.setPrefixNumber(DbReceive.getNumberPrefix());
                        receive.setNumber(DbReceive.getNextNumber(ctr));                        
                        receive.setStatus("DRAFT");
                        //receive.setDate(new Date());
                        
                        long oid = dbReceive.insertExc(this.receive);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                } else {
                    try {
                        long oid = dbReceive.updateExc(this.receive);                        
                        //proses penambahan stock                        
                        //if(DbStock.getCount(DbStock.colNames[DbStock.COL_INCOMING_ID]+"="+receive.getOID())==0 && oid!=0 && receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                        //    DbReceiveItem.proceedStock(receive);
                        //} 
                        
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
                long app1Id = 0;
                long app2Id = 0;
                long app3Id = 0;
                docDate = new Date();
                oldStatus = "";
                
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                        docDate = receive.getDate();
                        oldStatus = receive.getStatus();
                        userId = receive.getUserId();
                        app1Id = receive.getApproval1();
                        app2Id = receive.getApproval2();
                        app3Id = receive.getApproval3();
                        
                        
                    } catch (Exception exc) {
                    }
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
                }
                else if(receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){                    
                    receive.setApproval1(receive.getUserId());
                    receive.setApproval1Date(new Date());                    
                    receive.setUserId(userId);                    
                    receive.setApproval2(0);                    
                    receive.setApproval3(0);
                }
                else if(receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)){                                                            
                    receive.setApproval2(receive.getUserId());
                    receive.setApproval2Date(new Date());                    
                    receive.setUserId(userId);                    
                    receive.setApproval3(0);
                }
                else if(receive.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){                                                            
                    receive.setApproval3(receive.getUserId());
                    receive.setApproval3Date(new Date());                    
                    receive.setUserId(userId);
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
                
            case JSPCommand.ACTIVATE:
                
                userId = 0;
                app1Id = 0;
                app2Id = 0;
                app3Id = 0;
                
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);                        
                        userId = receive.getUserId();
                        app1Id = receive.getApproval1();
                        app2Id = receive.getApproval2();
                        app3Id = receive.getApproval3();
                        
                    } catch (Exception exc) {}
                }

                jspReceive.requestEntityObject(receive);
                
                if(receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){                    
                    receive.setApproval1(0);                    
                    receive.setApproval2(0);                    
                    receive.setApproval3(0);
                }
                else if(receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){                    
                    receive.setApproval1(receive.getUserId());
                    receive.setApproval1Date(receive.getApproval1Date());                    
                    receive.setUserId(userId);                    
                    receive.setApproval2(0);                    
                    receive.setApproval3(0);
                }
                else if(receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)){                                                            
                    receive.setApproval2(receive.getUserId());
                    receive.setApproval2Date(new Date());                    
                    receive.setUserId(userId);                    
                    receive.setApproval3(0);
                }
                else if(receive.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){                                                            
                    receive.setApproval3(receive.getUserId());
                    receive.setApproval3Date(new Date());                    
                    receive.setUserId(userId);
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
                
                Periode p = new Periode();
                if(receive.getPeriodId() == 0){                 
                    p = DbPeriode.getPeriodByTransDate(receive.getApproval1Date());                                        
                }else{
                    try{
                        p = DbPeriode.fetchExc(receive.getPeriodId());
                    }catch(Exception e){}
                }
                
                if(p.getOID() == 0 || p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0){
                    jspReceive.addError(jspReceive.JSP_PERIOD_ID, "Please chose open period");                    
                }
                
                if (jspReceive.errorSize() > 0) {
                    msgString = "Please check the data";
                    return RSLT_FORM_INCOMPLETE;
                }
                
                receive.setPeriodId(p.getOID());

                if (receive.getOID() == 0) {
                    try {
                        
                        int ctr = DbReceive.getNextCounter();
                        receive.setCounter(ctr);
                        receive.setPrefixNumber(DbReceive.getNumberPrefix());
                        receive.setNumber(DbReceive.getNextNumber(ctr));
                        
                        long oid = dbReceive.insertExc(this.receive);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                } else {
                    try {
                        long oid = dbReceive.updateExc(this.receive);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
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
            
            //hanya untuk loading    
            case JSPCommand.ASK:
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
            
            //hanya untuk loading
            case JSPCommand.DELETE:
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
            
            case JSPCommand.LOAD:
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
                
                jspReceive.requestEntityObject(receive);
                
                int count = DbReceiveItem.getCount(DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+"="+receive.getOID());
                
                if (oidReceive != 0) {
                    DbReceive.validateReceiveItem(receive); 
                    //setelah diupdate- save purchse
                    try{
                        DbReceive.updateExc(receive);
                    }
                    catch(Exception e){
                        
                    }
                    //update total amount
                    DbReceive.fixGrandTotalAmount(oidReceive);
                }
                        
                break;    

            case JSPCommand.SUBMIT:
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
                

            case JSPCommand.CONFIRM:
                if (oidReceive != 0) {
                    try {
                        DbStockCode.deleteAllItem(oidReceive);
                        DbReceiveItem.deleteAllItem(oidReceive);
                        long oid = DbReceive.deleteExc(oidReceive);
                        if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                            DbStock.delete(DbStock.colNames[DbStock.COL_INCOMING_ID]+ " = " + oidReceive);
                        }
                        DbStock.delete(DbStock.colNames[DbStock.COL_INCOMING_ID]+ " = " + oidReceive);
                        
                        if (oid != 0) {
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
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
}
