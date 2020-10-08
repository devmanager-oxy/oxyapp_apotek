package com.project.ccs.postransaction.request;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;

public class CmdPurchaseRequest extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private PurchaseRequest purchaseRequest;
    private DbPurchaseRequest pstPurchaseRequest;
    private JspPurchaseRequest jspPurchaseRequest;
    int language = LANGUAGE_DEFAULT;

    public CmdPurchaseRequest(HttpServletRequest request) {
        msgString = "";
        purchaseRequest = new PurchaseRequest();
        try {
            pstPurchaseRequest = new DbPurchaseRequest(0);
        } catch (Exception e) {
            
        }
        jspPurchaseRequest = new JspPurchaseRequest(request, purchaseRequest);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspPurchaseRequest.addError(jspPurchaseRequest.JSP_FIELD_purchaseRequest_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public PurchaseRequest getPurchaseRequest() {
        return purchaseRequest;
    }

    public JspPurchaseRequest getForm() {
        return jspPurchaseRequest;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPurchaseRequest) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                jspPurchaseRequest.requestEntityObject(purchaseRequest);
                if (oidPurchaseRequest != 0) {
                    try {
                        purchaseRequest = DbPurchaseRequest.fetchExc(oidPurchaseRequest);
                    } catch (Exception exc) {
                    }
                }
                break;
            
            case JSPCommand.BACK:
                if (oidPurchaseRequest != 0) {
                    try {
                        purchaseRequest = DbPurchaseRequest.fetchExc(oidPurchaseRequest);
                    } catch (Exception exc) {
                    }
                }
                break;    

            case JSPCommand.SAVE:
                if (oidPurchaseRequest != 0) {
                    try {
                        purchaseRequest = DbPurchaseRequest.fetchExc(oidPurchaseRequest);
                    } catch (Exception exc) {
                    }
                }

                jspPurchaseRequest.requestEntityObject(purchaseRequest);
                
                if(purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){
                    if(purchaseRequest.getClosedReason()==null || purchaseRequest.getClosedReason().length()<1){
                        jspPurchaseRequest.addError(jspPurchaseRequest.JSP_CLOSED_REASON, "Entry Required");
                    }
                }
                
                if (jspPurchaseRequest.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (purchaseRequest.getOID() == 0) {
                    try {
                        
                        int ctr = DbPurchaseRequest.getNextCounter();
                        purchaseRequest.setCounter(ctr);
                        purchaseRequest.setPrefixNumber(DbPurchaseRequest.getNumberPrefix());
                        purchaseRequest.setNumber(DbPurchaseRequest.getNextNumber(ctr));
                        
                        purchaseRequest.setStatus(I_Project.DOC_STATUS_DRAFT);
                        
                        long oid = pstPurchaseRequest.insertExc(this.purchaseRequest);
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
                        
                        long oid = pstPurchaseRequest.updateExc(this.purchaseRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.POST:
                
                long userId = 0;
                long app1Id = 0;
                long app2Id = 0;
                
                if (oidPurchaseRequest != 0) {
                    try {
                        purchaseRequest = DbPurchaseRequest.fetchExc(oidPurchaseRequest);
                        userId = purchaseRequest.getUserId();
                        app1Id = purchaseRequest.getApproval1();
                        app2Id = purchaseRequest.getApproval2();
                    } catch (Exception exc) {
                    }
                }

                jspPurchaseRequest.requestEntityObject(purchaseRequest);
                
                //approval check ----------------
                if(purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){
                    //approved status
                    purchaseRequest.setApproval1(0);
                    //close status
                    purchaseRequest.setApproval2(0);
                }
                else if(purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                    //approved status
                    purchaseRequest.setApproval1(purchaseRequest.getUserId());
                    purchaseRequest.setApproval1Date(new Date());
                    //draft status
                    purchaseRequest.setUserId(userId);
                    //close status
                    purchaseRequest.setApproval2(0);
                }
                else if(purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){                                        
                    //close status
                    purchaseRequest.setApproval2(purchaseRequest.getUserId());
                    purchaseRequest.setApproval2Date(new Date());
                    //draft status
                    purchaseRequest.setUserId(userId);
                }
                //--------------------------------
                
                if(purchaseRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE)){
                    if(purchaseRequest.getClosedReason()==null || purchaseRequest.getClosedReason().length()<1){
                        jspPurchaseRequest.addError(jspPurchaseRequest.JSP_CLOSED_REASON, "Entry Required");
                    }
                }
                
                if (jspPurchaseRequest.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (purchaseRequest.getOID() == 0) {
                    try {
                        
                        int ctr = DbPurchaseRequest.getNextCounter();
                        purchaseRequest.setCounter(ctr);
                        purchaseRequest.setPrefixNumber(DbPurchaseRequest.getNumberPrefix());
                        purchaseRequest.setNumber(DbPurchaseRequest.getNextNumber(ctr));
                        
                        purchaseRequest.setStatus(I_Project.DOC_STATUS_DRAFT);
                        
                        long oid = pstPurchaseRequest.insertExc(this.purchaseRequest);
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
                        
                        long oid = pstPurchaseRequest.updateExc(this.purchaseRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;    

            case JSPCommand.EDIT:
                if (oidPurchaseRequest != 0) {
                    try {
                        purchaseRequest = DbPurchaseRequest.fetchExc(oidPurchaseRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            //pengganti ask    
            case JSPCommand.SUBMIT:
                jspPurchaseRequest.requestEntityObject(purchaseRequest);
                if (oidPurchaseRequest != 0) {
                    try {
                        purchaseRequest = DbPurchaseRequest.fetchExc(oidPurchaseRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            //pengganti delete    
            case JSPCommand.CONFIRM:
                if (oidPurchaseRequest != 0) {
                    try {
                        DbPurchaseRequestItem.deleteAllItem(oidPurchaseRequest);
                        long oid = DbPurchaseRequest.deleteExc(oidPurchaseRequest);
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
