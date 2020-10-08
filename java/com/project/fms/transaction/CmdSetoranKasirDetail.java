/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.transaction;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.system.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.fms.master.*;
import com.project.payroll.*;

/**
 *
 * @author Roy
 */

public class CmdSetoranKasirDetail extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private SetoranKasirDetail setoranKasirDetail;
    private DbSetoranKasirDetail dbSetoranKasirDetail;
    private JspSetoranKasirDetail jspSetoranKasirDetail;
    int language = LANGUAGE_DEFAULT;

    public CmdSetoranKasirDetail(HttpServletRequest request) {
        msgString = "";
        setoranKasirDetail = new SetoranKasirDetail();
        try {
            dbSetoranKasirDetail = new DbSetoranKasirDetail(0);
        } catch (Exception e) {}
        jspSetoranKasirDetail = new JspSetoranKasirDetail(request, setoranKasirDetail);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspSetoranKasirDetail.addError(jspSetoranKasirDetail.JSP_SETORAN_KASIR_DETAIL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public SetoranKasirDetail getSetoranKasirDetail() {
        return setoranKasirDetail;
    }

    public JspSetoranKasirDetail getForm() {
        return jspSetoranKasirDetail;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSetoranKasirDetail) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SEARCH:
                if (oidSetoranKasirDetail != 0) {
                    try {
                        setoranKasirDetail = DbSetoranKasirDetail.fetchExc(oidSetoranKasirDetail);
                    } catch (Exception exc) {
                    }
                }

                jspSetoranKasirDetail.requestEntityObject(setoranKasirDetail);

                if (jspSetoranKasirDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (setoranKasirDetail.getOID() == 0) {
                    try {
                        long oid = dbSetoranKasirDetail.insertExc(this.setoranKasirDetail);
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
                        long oid = dbSetoranKasirDetail.updateExc(this.setoranKasirDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SUBMIT:

                jspSetoranKasirDetail.requestEntityObject(setoranKasirDetail);

                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(setoranKasirDetail.getCoaId());
                } catch (Exception e) {

                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspSetoranKasirDetail.addError(jspSetoranKasirDetail.JSP_COA_ID, "postable account type required");
                }

                if (jspSetoranKasirDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.EDIT:
                if (oidSetoranKasirDetail != 0) {
                    try {
                        setoranKasirDetail = DbSetoranKasirDetail.fetchExc(oidSetoranKasirDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidSetoranKasirDetail != 0) {
                    try {
                        setoranKasirDetail = DbSetoranKasirDetail.fetchExc(oidSetoranKasirDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidSetoranKasirDetail != 0) {
                    try {
                        long oid = DbSetoranKasirDetail.deleteExc(oidSetoranKasirDetail);
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
