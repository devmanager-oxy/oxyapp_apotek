package com.project.ccs.postransaction.purchase;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;


public class CmdPurchase extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private Purchase purchase;
    private DbPurchase dbPurchase;
    private JspPurchase jspPurchase;
    int language = LANGUAGE_DEFAULT;

    public CmdPurchase(HttpServletRequest request) {
        msgString = "";
        purchase = new Purchase();
        try {
            dbPurchase = new DbPurchase(0);
        } catch (Exception e) {
            
        }
        jspPurchase = new JspPurchase(request, purchase);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspPurchase.addError(jspPurchase.JSP_FIELD_purchase_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public Purchase getPurchase() {
        return purchase;
    }

    public JspPurchase getForm() {
        return jspPurchase;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    synchronized public int action(int cmd, long oidPurchase) {
        
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                if (oidPurchase != 0) {
                    try {
                        purchase = DbPurchase.fetchExc(oidPurchase);
                    } catch (Exception exc) {
                    }
                }
                jspPurchase.requestEntityObject(purchase);
                break;
            
            case JSPCommand.BACK:
                if (oidPurchase != 0) {
                    try {
                        purchase = DbPurchase.fetchExc(oidPurchase);
                    } catch (Exception exc) {
                    }
                }
                break;    

            case JSPCommand.SAVE:
                
                if (oidPurchase != 0) {
                    try {
                        purchase = DbPurchase.fetchExc(oidPurchase);                        
                    } catch (Exception exc) {
                    }
                }

                jspPurchase.requestEntityObject(purchase);
                
                if(purchase.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){
                    if(purchase.getClosedReason()==null || purchase.getClosedReason().length()<1){
                        jspPurchase.addError(jspPurchase.JSP_CLOSED_REASON, "Entry Required");
                    }
                }
                
                if (jspPurchase.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (purchase.getOID() == 0) {
                    try {
                        
                        int ctr = DbPurchase.getNextCounter();
                        purchase.setCounter(ctr);
                        purchase.setPrefixNumber(DbPurchase.getNumberPrefix());
                        purchase.setNumber(DbPurchase.getNextNumber(ctr));
                        purchase.setStatus(I_Project.DOC_STATUS_DRAFT);
                        
                        long oid = dbPurchase.insertExc(this.purchase);
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
                        long oid = dbPurchase.updateExc(this.purchase);
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
                
                if (oidPurchase != 0) {
                    try {
                        purchase = DbPurchase.fetchExc(oidPurchase);
                        
                        userId = purchase.getUserId();
                        app1Id = purchase.getApproval1();
                        app2Id = purchase.getApproval2();
                        app3Id = purchase.getApproval3();
                        
                    } catch (Exception exc) {
                    }
                }

                jspPurchase.requestEntityObject(purchase);
                
                //approval check ----------------
                if(purchase.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){
                    //approved status
                    purchase.setApproval1(0);
                    //check status
                    purchase.setApproval2(0);
                    //close status
                    purchase.setApproval3(0);
                }
                else if(purchase.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                    //approved status
                    purchase.setApproval1(purchase.getUserId());
                    purchase.setApproval1Date(new Date());
                    //draft status
                    purchase.setUserId(userId);
                    //check status
                    purchase.setApproval2(0);
                    //close status
                    purchase.setApproval3(0);
                }
                else if(purchase.getStatus().equals(I_Project.DOC_STATUS_CHECKED)){                                        
                    //close statusc
                    purchase.setApproval2(purchase.getUserId());
                    purchase.setApproval2Date(new Date());
                    //draft status
                    purchase.setUserId(userId);
                    //close
                    purchase.setApproval3(0);
                }
                else if(purchase.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){                                        
                    //close status
                    purchase.setApproval3(purchase.getUserId());
                    purchase.setApproval3Date(new Date());
                    //draft status
                    purchase.setUserId(userId);
                }
                //--------------------------------
                
                if(purchase.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){
                    if(purchase.getClosedReason()==null || purchase.getClosedReason().length()<1){
                        jspPurchase.addError(jspPurchase.JSP_CLOSED_REASON, "Entry Required");
                    }
                }
                
                if (jspPurchase.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (purchase.getOID() == 0) {
                    try {
                        
                        int ctr = DbPurchase.getNextCounter();
                        purchase.setCounter(ctr);
                        purchase.setPrefixNumber(DbPurchase.getNumberPrefix());
                        purchase.setNumber(DbPurchase.getNextNumber(ctr));
                        
                        long oid = dbPurchase.insertExc(this.purchase);
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
                        long oid = dbPurchase.updateExc(this.purchase);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;    

            case JSPCommand.EDIT:
                if (oidPurchase != 0) {
                    try {
                        purchase = DbPurchase.fetchExc(oidPurchase);
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
                if (oidPurchase != 0) {
                    try {
                        purchase = DbPurchase.fetchExc(oidPurchase);
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
                if (oidPurchase != 0) {
                    try {
                        purchase = DbPurchase.fetchExc(oidPurchase);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;     
            
            case JSPCommand.LOAD:
                if (oidPurchase != 0) {
                    try {
                        purchase = DbPurchase.fetchExc(oidPurchase);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                
                jspPurchase.requestEntityObject(purchase);
                
                int count = DbPurchaseItem.getCount(DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+"="+purchase.getOID());
                
                if (oidPurchase != 0) {
                    DbPurchase.validatePurchaseItem(purchase); 
                    //setelah diupdate- save purchse
                    try{
                        DbPurchase.updateExc(purchase);
                    }
                    catch(Exception e){
                        
                    }
                    //update total amount
                    DbPurchase.fixGrandTotalAmount(oidPurchase);
                }
                        
                break;    

            case JSPCommand.SUBMIT:
                if (oidPurchase != 0) {
                    try {
                        purchase = DbPurchase.fetchExc(oidPurchase);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                

            case JSPCommand.CONFIRM:
                if (oidPurchase != 0) {
                    try {
                        DbPurchaseItem.deleteAllItem(oidPurchase);
                        long oid = DbPurchase.deleteExc(oidPurchase);
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
