/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

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
public class CmdSewaTanahKominProp extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static int RSLT_PERIODE_DATE_EXIST = 4;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private SewaTanahKominProp sewaTanahKominProp;
    private DbSewaTanahKominProp pstSewaTanahKominProp;
    private JspSewaTanahKominProp jspSewaTanahKominProp;
    int language = LANGUAGE_DEFAULT;

    public CmdSewaTanahKominProp(HttpServletRequest request) {
        msgString = "";
        sewaTanahKominProp = new SewaTanahKominProp();
        try {
            pstSewaTanahKominProp = new DbSewaTanahKominProp(0);
        } catch (Exception e) {
            ;
        }
        jspSewaTanahKominProp = new JspSewaTanahKominProp(request, sewaTanahKominProp);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //	this.jspSewaTanahKominProp.addError(jspSewaTanahKominProp.JSP_sewa_tanah_komin_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public SewaTanahKominProp getSewaTanahKomin() {
        return sewaTanahKominProp;
    }

    public JspSewaTanahKominProp getForm() {
        return jspSewaTanahKominProp;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSewaTanahKominProp) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidSewaTanahKominProp != 0) {
                    try {
                        sewaTanahKominProp = DbSewaTanahKominProp.fetchExc(oidSewaTanahKominProp);
                    } catch (Exception exc) {
                    }
                }

                jspSewaTanahKominProp.requestEntityObject(sewaTanahKominProp);

                if (jspSewaTanahKominProp.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (sewaTanahKominProp.getOID() == 0) {
                    try {
                        long oid = pstSewaTanahKominProp.insertExc(this.sewaTanahKominProp);
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
                        long oid = pstSewaTanahKominProp.updateExc(this.sewaTanahKominProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidSewaTanahKominProp != 0) {
                    try {
                        sewaTanahKominProp = DbSewaTanahKominProp.fetchExc(oidSewaTanahKominProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidSewaTanahKominProp != 0) {
                    try {
                        sewaTanahKominProp = DbSewaTanahKominProp.fetchExc(oidSewaTanahKominProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidSewaTanahKominProp != 0) {
                    try {
                        long oid = DbSewaTanahKominProp.deleteExc(oidSewaTanahKominProp);
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
