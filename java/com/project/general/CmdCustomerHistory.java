package com.project.general;

import com.project.main.db.CONException;
import com.project.main.entity.I_CONExceptionInfo;
import com.project.util.JSPCommand;
import com.project.util.jsp.Control;
import com.project.util.jsp.JSPMessage;
import com.project.util.lang.I_Language;
import javax.servlet.http.HttpServletRequest;

public class CmdCustomerHistory extends Control implements I_Language {

    public static int RSLT_OK               = 0;
    public static int RSLT_UNKNOWN_ERROR    = 1;
    public static int RSLT_EST_CODE_EXIST   = 2;
    public static int RSLT_FORM_INCOMPLETE  = 3;

    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private CustomerHistory customerHistory;
    private JspCustomerHistory jspCustomerHistory;
    int language = LANGUAGE_DEFAULT;

    public CmdCustomerHistory(HttpServletRequest request) {
        msgString = "";
        customerHistory = new CustomerHistory();
        jspCustomerHistory = new JspCustomerHistory(request, customerHistory);
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

    public CustomerHistory getCustomerHistory() {
        return customerHistory;
    }

    public JspCustomerHistory getForm() {
        return jspCustomerHistory;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidCustomerHistory) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;
    
            case JSPCommand.SAVE:
                if (oidCustomerHistory != 0) {
                    try {
                        customerHistory = DbCustomerHistory.fetchExc(oidCustomerHistory);
                    } catch (Exception e) {
                        System.out.println("[Exception] " + e.toString());
                    }
                }

                jspCustomerHistory.requestEntityObject(customerHistory);

                if (jspCustomerHistory.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
    
                if (customerHistory.getOID() == 0) {
                    try {
                        long oid = DbCustomerHistory.insertExc(this.customerHistory);
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
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
                        long oid = DbCustomerHistory.updateExc(this.customerHistory);
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
    
            case JSPCommand.EDIT:
                if (oidCustomerHistory != 0) {
                    try {
                        customerHistory = DbCustomerHistory.fetchExc(oidCustomerHistory);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
    
            case JSPCommand.ASK:
                if (oidCustomerHistory!= 0) {
                    try {
                        customerHistory = DbCustomerHistory.fetchExc(oidCustomerHistory);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
    
            case JSPCommand.DELETE:
                if (oidCustomerHistory != 0) {
                    try {
                        long oid = DbCustomerHistory.deleteExc(oidCustomerHistory);
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
