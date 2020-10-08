/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.posmaster;

import com.project.admin.User;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy Andika
 */
public class CmdCashCashier extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    
    private int start;
    private String msgString;
    private CashCashier cashCashier;
    private DbCashCashier dbCashCashier;
    private JspCashCashier jspCashCashier;
    int language = LANGUAGE_DEFAULT;

    public CmdCashCashier(HttpServletRequest request) {
        msgString = "";
        cashCashier = new CashCashier();
        try {
            dbCashCashier = new DbCashCashier(0);
        } catch (Exception e) {
            ;
        }
        jspCashCashier = new JspCashCashier(request, cashCashier);
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

    public CashCashier getCashCashier() {
        return cashCashier;
    }

    public JspCashCashier getForm() {
        return jspCashCashier;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidCashCashier, User user, boolean stillOpen) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        CashCashier cashC = new CashCashier();
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidCashCashier != 0) {
                    try {
                        cashCashier = DbCashCashier.fetchExc(oidCashCashier);
                        cashC = DbCashCashier.fetchExc(oidCashCashier);
                    } catch (Exception exc) {
                    }
                }

                jspCashCashier.requestEntityObject(cashCashier);
                cashCashier.setUserId(user.getOID());
                
                
                
                if (jspCashCashier.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                if(stillOpen){
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_IN_USED);
                    return RSLT_EST_CODE_EXIST;
                }

                if (cashCashier.getOID() == 0) {
                    try {
                        Date date = new Date();
                        cashCashier.setDateOpen(date);
                        cashCashier.setStatus(DbCashCashier.status_opening);
                        long oid = dbCashCashier.insertExc(this.cashCashier);
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
                        Date date = new Date();
                        cashCashier.setDateClosing(date);
                        //untuk update closing
                        cashCashier.setAmountOpen(cashC.getAmountOpen());
                        cashCashier.setCashMasterId(cashC.getCashMasterId());
                        cashCashier.setCurrencyIdOpen(cashC.getCurrencyIdOpen());
                        cashCashier.setDateOpen(cashC.getDateOpen());
                        cashCashier.setRateOpen(cashC.getRateOpen());
                        cashCashier.setShiftId(cashC.getShiftId());
                        cashCashier.setStatus(DbCashCashier.status_closing);
                        long oid = dbCashCashier.updateExc(this.cashCashier);
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

            case JSPCommand.SUBMIT:
                jspCashCashier.requestEntityObject(cashCashier);

                if (jspCashCashier.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.EDIT:
                if (oidCashCashier != 0) {
                    try {
                        cashCashier = DbCashCashier.fetchExc(oidCashCashier);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidCashCashier != 0) {
                    try {
                        cashCashier = DbCashCashier.fetchExc(oidCashCashier);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidCashCashier != 0) {
                    try {
                        long oid = DbCashCashier.deleteExc(oidCashCashier);
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
