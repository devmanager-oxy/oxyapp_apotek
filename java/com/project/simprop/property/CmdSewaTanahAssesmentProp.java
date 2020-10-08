/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import com.project.crm.transaction.*;
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
public class CmdSewaTanahAssesmentProp extends Control implements I_Language {

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
    private SewaTanahAssesmentProp sewaTanahAssesmentProp;
    private DbSewaTanahAssesmentProp pstSewaTanahAssesmentProp;
    private JspSewaTanahAssesmentProp jspSewaTanahAssesmentProp;
    int language = LANGUAGE_DEFAULT;

    public CmdSewaTanahAssesmentProp(HttpServletRequest request) {
        msgString = "";
        sewaTanahAssesmentProp = new SewaTanahAssesmentProp();
        try {
            pstSewaTanahAssesmentProp = new DbSewaTanahAssesmentProp(0);
        } catch (Exception e) {
            ;
        }
        jspSewaTanahAssesmentProp = new JspSewaTanahAssesmentProp(request, sewaTanahAssesmentProp);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //	this.jspSewaTanahAssesmentProp.addError(jspSewaTanahAssesmentProp.JSP_sewa_tanah_assesment_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public SewaTanahAssesmentProp getSewaTanahAssesment() {
        return sewaTanahAssesmentProp;
    }

    public JspSewaTanahAssesmentProp getForm() {
        return jspSewaTanahAssesmentProp;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSewaTanahAssesmentProp) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidSewaTanahAssesmentProp != 0) {
                    try {
                        sewaTanahAssesmentProp = DbSewaTanahAssesmentProp.fetchExc(oidSewaTanahAssesmentProp);
                    } catch (Exception exc) {
                    }
                }

                jspSewaTanahAssesmentProp.requestEntityObject(sewaTanahAssesmentProp);

                if (jspSewaTanahAssesmentProp.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (sewaTanahAssesmentProp.getOID() == 0) {
                    try {
                        long oid = pstSewaTanahAssesmentProp.insertExc(this.sewaTanahAssesmentProp);
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
                        long oid = pstSewaTanahAssesmentProp.updateExc(this.sewaTanahAssesmentProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidSewaTanahAssesmentProp != 0) {
                    try {
                        sewaTanahAssesmentProp = DbSewaTanahAssesmentProp.fetchExc(oidSewaTanahAssesmentProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidSewaTanahAssesmentProp != 0) {
                    try {
                        sewaTanahAssesmentProp = DbSewaTanahAssesmentProp.fetchExc(oidSewaTanahAssesmentProp);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidSewaTanahAssesmentProp != 0) {
                    try {
                        long oid = DbSewaTanahAssesmentProp.deleteExc(oidSewaTanahAssesmentProp);
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
