/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.ga;

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
import com.project.system.DbSystemProperty;

/**
 *
 * @author Roy
 */
public class CmdGeneralAffair extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    
    private int start;
    private String msgString;
    private GeneralAffair generalAffair;
    private DbGeneralAffair pstGeneralAffair;
    private JspGeneralAffair jspGeneralAffair;
    int language = LANGUAGE_DEFAULT;
    private long userId = 0;

    public CmdGeneralAffair(HttpServletRequest request) {
        msgString = "";
        generalAffair = new GeneralAffair();
        try {
            pstGeneralAffair = new DbGeneralAffair(0);
        } catch (Exception e) {}
        jspGeneralAffair = new JspGeneralAffair(request, generalAffair);
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

    public GeneralAffair getGeneralAffair() {
        return generalAffair;
    }

    public JspGeneralAffair getForm() {
        return jspGeneralAffair;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    synchronized public int action(int cmd, long oidGeneralAffair) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.ACTIVATE:
                if (oidGeneralAffair != 0) {
                    try {
                        generalAffair = DbGeneralAffair.fetchExc(oidGeneralAffair);
                    } catch (Exception exc) {}
                }
                break;

            case JSPCommand.SAVE:

                String oldStatus = "";

                if (oidGeneralAffair != 0) {
                    try {
                        generalAffair = DbGeneralAffair.fetchExc(oidGeneralAffair);
                        oldStatus = generalAffair.getStatus();
                    } catch (Exception exc) {
                    }
                }

                jspGeneralAffair.requestEntityObject(generalAffair);

                //jika status tidak draft tidak boleh update
                if (!oldStatus.equals(I_Project.DOC_STATUS_DRAFT) && !oldStatus.equals("")) {
                    jspGeneralAffair.addError(jspGeneralAffair.JSP_APPROVAL_1, "Document have been locked for update - current status " + oldStatus);
                }

                if (jspGeneralAffair.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if(generalAffair.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                    generalAffair.setApproval1(getUserId());
                    generalAffair.setApproval1Date(new Date());
                }
                
                if (generalAffair.getOID() == 0) {
                    try {
                        generalAffair.setDate(new Date());
                        int ctr = DbGeneralAffair.getNextCounter();
                        generalAffair.setCounter(ctr);
                        generalAffair.setPrefixNumber(DbGeneralAffair.getNumberPrefix());
                        generalAffair.setNumber(DbGeneralAffair.getNextNumber(ctr));                        
                        long oid = pstGeneralAffair.insertExc(this.generalAffair);

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

                        long oid = pstGeneralAffair.updateExc(this.generalAffair);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;
                
            case JSPCommand.ASSIGN:

                oldStatus = "";                
                if (oidGeneralAffair != 0) {
                    try {
                        generalAffair = DbGeneralAffair.fetchExc(oidGeneralAffair);
                        oldStatus = generalAffair.getStatus();
                    } catch (Exception exc) {
                    }
                }

                jspGeneralAffair.requestEntityObject(generalAffair);

                //jika status tidak draft tidak boleh update
                if (!oldStatus.equals(I_Project.DOC_STATUS_DRAFT) && !oldStatus.equals("")) {
                    jspGeneralAffair.addError(jspGeneralAffair.JSP_APPROVAL_1, "Document have been locked for update - current status " + oldStatus);
                }

                if (jspGeneralAffair.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if(generalAffair.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                    generalAffair.setApproval1(getUserId());
                    generalAffair.setApproval1Date(new Date());
                }

                if (generalAffair.getOID() == 0) {
                    try {
                        generalAffair.setDate(new Date());
                        int ctr = DbGeneralAffair.getNextCounter();
                        generalAffair.setCounter(ctr);
                        generalAffair.setPrefixNumber(DbGeneralAffair.getNumberPrefix());
                        generalAffair.setNumber(DbGeneralAffair.getNextNumber(ctr));
                        long oid = pstGeneralAffair.insertExc(this.generalAffair);
                        
                        if(oid != 0 && generalAffair.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){ // insert stock
                            
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
                        long oid = pstGeneralAffair.updateExc(this.generalAffair);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;    

            case JSPCommand.EDIT:
                if (oidGeneralAffair != 0) {
                    try {
                        generalAffair = DbGeneralAffair.fetchExc(oidGeneralAffair);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.LOAD:
                if (oidGeneralAffair != 0) {
                    try {
                        generalAffair = DbGeneralAffair.fetchExc(oidGeneralAffair);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                
                jspGeneralAffair.requestEntityObject(generalAffair);
                
                break;    

            case JSPCommand.ASK:
                if (oidGeneralAffair != 0) {
                    try {
                        generalAffair = DbGeneralAffair.fetchExc(oidGeneralAffair);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.SUBMIT:
                if (oidGeneralAffair != 0) {
                    try {
                        generalAffair = DbGeneralAffair.fetchExc(oidGeneralAffair);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);                        
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;


            case JSPCommand.CONFIRM:
                if (oidGeneralAffair != 0) {
                    int rslt = DbGeneralAffairDetail.deleteAllItem(oidGeneralAffair);
                    try {
                        long oid = DbGeneralAffair.deleteExc(oidGeneralAffair);
                        if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                            DbStock.delete(DbStock.colNames[DbStock.COL_COSTING_ID] + "=" + oidGeneralAffair);
                        }

                        if (rslt == 0) {
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }

                        DbStock.delete(DbStock.colNames[DbStock.COL_COSTING_ID] + "=" + oidGeneralAffair);

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

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
}
