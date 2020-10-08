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
import com.project.ccs.postransaction.stock.DbStock;


public class CmdDirectRetur extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private Retur retur;
    private DbRetur dbRetur;
    private JspDirectRetur jspRetur;
    int language = LANGUAGE_DEFAULT;

    public CmdDirectRetur(HttpServletRequest request) {
        msgString = "";
        retur = new Retur();
        try {
            dbRetur = new DbRetur(0);
        } catch (Exception e) {
            
        }
        jspRetur = new JspDirectRetur(request, retur);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspRetur.addError(jspRetur.JSP_FIELD_retur_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public Retur getRetur() {
        return retur;
    }

    public JspDirectRetur getForm() {
        return jspRetur;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidRetur) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                if (oidRetur != 0) {
                    try {
                        retur = DbRetur.fetchExc(oidRetur);
                    } catch (Exception exc) {
                    }
                }
                jspRetur.requestEntityObject(retur);
                break;
                
                
                
            
            case JSPCommand.BACK:
                if (oidRetur != 0) {
                    try {
                        retur = DbRetur.fetchExc(oidRetur);
                    } catch (Exception exc) {
                    }
                }
                break;    

            case JSPCommand.SAVE:
                
                if (oidRetur != 0) {
                    try {
                        retur = DbRetur.fetchExc(oidRetur);                        
                    } catch (Exception exc) {
                    }
                }

                jspRetur.requestEntityObject(retur);
                
                if(retur.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){
                    if(retur.getClosedReason()==null || retur.getClosedReason().length()<1){
                        jspRetur.addError(jspRetur.JSP_CLOSED_REASON, "Entry Required");
                    }
                }
                
                /*if(retur.getPurchaseId()!=0){
                    if(retur.getDoNumber().length()==0){
                        jspRetur.addError(jspRetur.JSP_DO_NUMBER, "Entry Required");
                    }
                    
                    if(retur.getInvoiceNumber().length()==0){
                        jspRetur.addError(jspRetur.JSP_INVOICE_NUMBER, "Entry Required");
                    }
                }
                 */
                
                if (jspRetur.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (retur.getOID() == 0) {
                    try {
                        
                        int ctr = DbRetur.getNextCounter();
                        retur.setCounter(ctr);
                        retur.setPrefixNumber(DbRetur.getNumberPrefix());
                        retur.setNumber(DbRetur.getNextNumber(ctr));
                        retur.setStatus(I_Project.DOC_STATUS_DRAFT);
                        
                        long oid = dbRetur.insertExc(this.retur);
                        
                        //proses penambahan stock
                        if(oid!=0 && retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                            DbReturItem.proceedStock(retur);
                        }
                        
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
                        long oid = dbRetur.updateExc(this.retur);
                        
                        //proses penambahan stock
                        if(oid!=0 && retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                            DbReturItem.proceedStock(retur);
                        }
                        
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
                
                if (oidRetur != 0) {
                    try {
                        retur = DbRetur.fetchExc(oidRetur);
                        
                        userId = retur.getUserId();
                        app1Id = retur.getApproval1();
                        app2Id = retur.getApproval2();
                        app3Id = retur.getApproval3();
                        
                    } catch (Exception exc) {
                    }
                }

                jspRetur.requestEntityObject(retur);
                
                //approval check ----------------
                if(retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){
                    //approved status
                    retur.setApproval1(0);
                    //check status
                    retur.setApproval2(0);
                    //close status
                    retur.setApproval3(0);
                }
                else if(retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                    //approved status
                    retur.setApproval1(retur.getUserId());
                    retur.setApproval1Date(new Date());
                    //draft status
                    retur.setUserId(userId);
                    //check status
                    retur.setApproval2(0);
                    //close status
                    retur.setApproval3(0);
                }
                else if(retur.getStatus().equals(I_Project.DOC_STATUS_CHECKED)){                                        
                    //close statusc
                    retur.setApproval2(retur.getUserId());
                    retur.setApproval2Date(new Date());
                    //draft status
                    retur.setUserId(userId);
                    //close
                    retur.setApproval3(0);
                }
                else if(retur.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){                                        
                    //close status
                    retur.setApproval3(retur.getUserId());
                    retur.setApproval3Date(new Date());
                    //draft status
                    retur.setUserId(userId);
                }
                //--------------------------------
                
                if(retur.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){
                    if(retur.getClosedReason()==null || retur.getClosedReason().length()<1){
                        jspRetur.addError(jspRetur.JSP_CLOSED_REASON, "Entry Required");
                    }
                }
                
                /*if(retur.getPurchaseId()!=0){
                    if(retur.getDoNumber().length()==0){
                        jspRetur.addError(jspRetur.JSP_DO_NUMBER, "Entry Required");
                    }
                    
                    if(retur.getInvoiceNumber().length()==0){
                        jspRetur.addError(jspRetur.JSP_INVOICE_NUMBER, "Entry Required");
                    }
                }
                 */
                
                if (jspRetur.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (retur.getOID() == 0) {
                    try {
                        
                        int ctr = DbRetur.getNextCounter();
                        retur.setCounter(ctr);
                        retur.setPrefixNumber(DbRetur.getNumberPrefix());
                        retur.setNumber(DbRetur.getNextNumber(ctr));
                        retur.setStatus(I_Project.DOC_STATUS_DRAFT);
                        
                        long oid = dbRetur.insertExc(this.retur);
                        
                        //proses penambahan stock
                        if(oid!=0 && retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                            //DbReturItem.proceedStock(retur);
                            DbStock.updateStockRetur(retur);
                        }
                        
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
                        long oid = dbRetur.updateExc(this.retur);
                        
                        //proses penambahan stock
                       /* if(oid!=0 && retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                            //DbReturItem.proceedStock(retur);
                            DbStock.updateStockRetur(retur);
                        }*/
                        
                        if(retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                            if(DbStock.getCount(DbStock.colNames[DbStock.COL_RETUR_ID]+"="+retur.getOID())==0 && oid!=0 ){
                                DbStock.delete(DbStock.colNames[DbStock.COL_RETUR_ID]+"="+ retur.getOID());
                                DbReturItem.proceedStock(retur);//tambah stock

                            }else{
                                DbStock.updateStockRetur(retur); //update stock
                            }
                        }
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;    

            case JSPCommand.EDIT:
                if (oidRetur != 0) {
                    try {
                        retur = DbRetur.fetchExc(oidRetur);
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
                if (oidRetur != 0) {
                    try {
                        retur = DbRetur.fetchExc(oidRetur);
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
                if (oidRetur != 0) {
                    try {
                        retur = DbRetur.fetchExc(oidRetur);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;     
            
            case JSPCommand.LOAD:
                if (oidRetur != 0) {
                    try {
                        retur = DbRetur.fetchExc(oidRetur);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                
                jspRetur.requestEntityObject(retur);
                
                int count = DbReturItem.getCount(DbReturItem.colNames[DbReturItem.COL_RETUR_ID]+"="+retur.getOID());
                
                if (oidRetur != 0) {
                    //DbRetur.validateReturItem(retur); 
                    //setelah diupdate- save purchse
                    try{
                        DbRetur.updateExc(retur);
                    }
                    catch(Exception e){
                        
                    }
                    //update total amount
                    DbRetur.fixGrandTotalAmount(oidRetur);
                }
                        
                break;    

            case JSPCommand.SUBMIT:
                if (oidRetur != 0) {
                    try {
                        retur = DbRetur.fetchExc(oidRetur);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                

            case JSPCommand.CONFIRM:
                if (oidRetur != 0) {
                    try {
                        DbReturItem.deleteAllItem(oidRetur);
                        long oid = DbRetur.deleteExc(oidRetur);
                        DbStock.delete(DbStock.colNames[DbStock.COL_RETUR_ID]+"="+ oidRetur);
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
