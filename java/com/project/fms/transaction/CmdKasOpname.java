/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.transaction;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy Andika
 */
public class CmdKasOpname extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private KasOpname kasOpname;
    private DbKasOpname pstKasOpname;
    private JspKasOpname jspKasOpname;
    int language = LANGUAGE_DEFAULT;

    public CmdKasOpname(HttpServletRequest request) {
        msgString = "";
        kasOpname = new KasOpname();
        try {
            pstKasOpname = new DbKasOpname(0);
        } catch (Exception e) {
            ;
        }
        jspKasOpname = new JspKasOpname(request, kasOpname);
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

    public KasOpname getKasOpname() {
        return kasOpname;
    }

    public JspKasOpname getForm() {
        return jspKasOpname;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidKasOpname) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidKasOpname != 0) {
                    try {
                        kasOpname = DbKasOpname.fetchExc(oidKasOpname);
                    } catch (Exception exc) {
                    }
                }

                jspKasOpname.requestEntityObject(kasOpname);

                if (jspKasOpname.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (kasOpname.getOID() == 0) {
                    try {
                        long oid = pstKasOpname.insertExc(this.kasOpname);
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
                        long oid = pstKasOpname.updateExc(this.kasOpname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidKasOpname != 0) {
                    try {
                        kasOpname = DbKasOpname.fetchExc(oidKasOpname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidKasOpname != 0) {
                    try {
                        kasOpname = DbKasOpname.fetchExc(oidKasOpname);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidKasOpname != 0) {
                    try {
                        long oid = DbKasOpname.deleteExc(oidKasOpname);
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
