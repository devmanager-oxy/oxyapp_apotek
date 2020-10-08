package com.project.fms.transaction;

import com.project.I_Project;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;

public class CmdAkrualSetup extends Control {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private AkrualSetup akrualSetup;
    private DbAkrualSetup pstAkrualSetup;
    private JspAkrualSetup jspAkrualSetup;
    int language = 0;
    public CmdAkrualSetup(HttpServletRequest request) {
        msgString = "";
        akrualSetup = new AkrualSetup();
        try {
            pstAkrualSetup = new DbAkrualSetup(0);
        } catch (Exception e) {}
        jspAkrualSetup = new JspAkrualSetup(request, akrualSetup);
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

    public AkrualSetup getAkrualSetup() {
        return akrualSetup;
    }

    public JspAkrualSetup getForm() {
        return jspAkrualSetup;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidAkrualSetup) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidAkrualSetup != 0) {
                    try {
                        akrualSetup = DbAkrualSetup.fetchExc(oidAkrualSetup);
                    } catch (Exception exc) {
                    }
                }

                jspAkrualSetup.requestEntityObject(akrualSetup);                
                
                Coa coa = new Coa();
                
                try {
                    coa = DbCoa.fetchExc(akrualSetup.getCreditCoaId());
                } catch (Exception e) {}

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspAkrualSetup.addError(jspAkrualSetup.JSP_FIELD_CREDIT_COA_ID, "postable account type required");
                }
                
                try {
                    coa = DbCoa.fetchExc(akrualSetup.getDebetCoaId());
                } catch (Exception e) {}

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspAkrualSetup.addError(jspAkrualSetup.JSP_FIELD_DEBET_COA_ID, "postable account type required");
                }

                if (jspAkrualSetup.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (akrualSetup.getOID() == 0) {
                    try {
                        akrualSetup.setRegDate(new Date());
                        akrualSetup.setLastUpdate(new Date());
                        long oid = pstAkrualSetup.insertExc(this.akrualSetup);
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
                        akrualSetup.setLastUpdate(new Date());
                        long oid = pstAkrualSetup.updateExc(this.akrualSetup);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidAkrualSetup != 0) {
                    try {
                        akrualSetup = DbAkrualSetup.fetchExc(oidAkrualSetup);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidAkrualSetup != 0) {
                    try {
                        akrualSetup = DbAkrualSetup.fetchExc(oidAkrualSetup);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidAkrualSetup != 0) {
                    try {
                        long oid = DbAkrualSetup.deleteExc(oidAkrualSetup);
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
