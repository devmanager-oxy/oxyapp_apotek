/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.crm.master.limbah;

/**
 *
 * @author Tu Roy
 */
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

public class CmdLimbah extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    
    public static String[][] resultText = {
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"},
        {"Succes", "Can not process duplicate entry", "Can not process duplicate entry on code or account name", "Data incomplete"}};
    
    private int start;
    private String msgString;
    private Limbah limbah;
    private DbLimbah dbLimbah;
    private JspLimbah jspLimbah;

    public CmdLimbah(HttpServletRequest request) {
        msgString = "";
        limbah = new Limbah();
        try {
            dbLimbah = new DbLimbah(0);
        } catch (Exception e) {
            ;
        }
        jspLimbah = new JspLimbah(request, limbah);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:                
                return resultText[1][RSLT_EST_CODE_EXIST];
            default:
                return resultText[1][RSLT_UNKNOWN_ERROR];
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

    public Limbah getLimbah() {
        return limbah;
    }

    public JspLimbah getForm() {
        return jspLimbah;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidLimbah) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidLimbah != 0) {
                    try {
                        limbah = DbLimbah.fetchExc(oidLimbah);
                    } catch (Exception exc) {
                    }
                } 

                jspLimbah.requestEntityObject(limbah);
				boolean exist = DbLimbah.checkPeriodExist(oidLimbah, limbah.getPeriodeId(), limbah.getPriceType());
				if(exist){
					jspLimbah.addError(JspLimbah.JSP_PERIODE_ID,"Periode sudah ada");
					msgString = "Error, harga pada periode sudah disetup";
                    return RSLT_FORM_INCOMPLETE;
				}
				
                if (jspLimbah.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (oidLimbah == 0) {
                    try {
                        long oid = dbLimbah.insertExc(this.limbah);
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
                        long oid = dbLimbah.updateExc(this.limbah);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidLimbah != 0) {
                    try {
                        limbah = DbLimbah.fetchExc(oidLimbah);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidLimbah != 0) {
                    try {
                        limbah = DbLimbah.fetchExc(oidLimbah);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.SUBMIT:
                jspLimbah.requestEntityObject(limbah);
                break;

            case JSPCommand.DELETE:
                if (oidLimbah != 0) {
                    try {
                        long oid = DbLimbah.deleteExc(oidLimbah);
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
