/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.ga;

import com.project.I_Project;
import com.project.ccs.I_Ccs;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.ccs.postransaction.stock.DbStock;

/**
 *
 * @author Roy
 */
public class CmdGeneralAffairDetail extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private GeneralAffairDetail generalAffairDetail;
    private DbGeneralAffairDetail pstGeneralAffairDetail;
    private JspGeneralAffairDetail jspCostingItem;
    private long oidGeneralAffair = 0;
    private String status = "";
    int language = LANGUAGE_DEFAULT;

    public CmdGeneralAffairDetail(HttpServletRequest request) {
        msgString = "";
        generalAffairDetail = new GeneralAffairDetail();
        try {
            pstGeneralAffairDetail = new DbGeneralAffairDetail(0);
        } catch (Exception e) {
        }
        jspCostingItem = new JspGeneralAffairDetail(request, generalAffairDetail);
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

    public GeneralAffairDetail getGeneralAffairDetail() {
        return generalAffairDetail;
    }

    public JspGeneralAffairDetail getForm() {
        return jspCostingItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidGeneralAffairDetail) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.ACTIVATE:
                break;

            case JSPCommand.SAVE:

                if (oidGeneralAffairDetail != 0) {
                    try {
                        generalAffairDetail = DbGeneralAffairDetail.fetchExc(oidGeneralAffairDetail);
                    } catch (Exception exc) {
                    }
                }

                jspCostingItem.requestEntityObject(generalAffairDetail);
                generalAffairDetail.setGeneralAffairId(oidGeneralAffair);

                if (generalAffairDetail.getGeneralAffairId() == 0) {
                    jspCostingItem.addError(jspCostingItem.JSP_QTY, "failed to save main data");
                }

                //add update item hanya boleh saat draft
                if (!status.equals(I_Project.DOC_STATUS_DRAFT)) {
                    jspCostingItem.addError(jspCostingItem.JSP_QTY, "Error, document have been locked for update");
                }

                if (jspCostingItem.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (generalAffairDetail.getOID() == 0) {
                    try {
                        long oid = DbGeneralAffairDetail.insertExc(this.generalAffairDetail);
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
                        long oid = pstGeneralAffairDetail.updateExc(this.generalAffairDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.ASSIGN:
                break;

            case JSPCommand.EDIT:
                if (oidGeneralAffairDetail != 0) {
                    try {
                        generalAffairDetail = DbGeneralAffairDetail.fetchExc(oidGeneralAffairDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidGeneralAffairDetail != 0) {
                    try {
                        generalAffairDetail = DbGeneralAffairDetail.fetchExc(oidGeneralAffairDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;


            case JSPCommand.DELETE:
                if (oidGeneralAffairDetail != 0) {
                    try {
                        long oid = DbGeneralAffairDetail.deleteExc(oidGeneralAffairDetail);
                        DbGeneralAffairDetail.deleteStock(DbStock.colNames[DbStock.COL_TYPE] + " = " + I_Ccs.TYPE_GA + " and " + DbStock.colNames[DbStock.COL_COSTING_ITEM_ID] + "=" + oid);
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

    public long getOidGeneralAffair() {
        return oidGeneralAffair;
    }

    public void setOidGeneralAffair(long oidGeneralAffair) {
        this.oidGeneralAffair = oidGeneralAffair;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
