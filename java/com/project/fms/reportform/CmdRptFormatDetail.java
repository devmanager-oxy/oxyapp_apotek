package com.project.fms.reportform;

import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.system.*;
import com.project.util.lang.*;

public class CmdRptFormatDetail extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private RptFormatDetail rptFormatDetail;
    private DbRptFormatDetail dbRptFormatDetail;
    private JspRptFormatDetail jspRptFormatDetail;
    int language = LANGUAGE_DEFAULT;

    public CmdRptFormatDetail(HttpServletRequest request) {
        msgString = "";
        rptFormatDetail = new RptFormatDetail();
        try {
            dbRptFormatDetail = new DbRptFormatDetail(0);
        } catch (Exception e) {
            ;
        }
        jspRptFormatDetail = new JspRptFormatDetail(request, rptFormatDetail);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.rptFormatDetail.addError(rptFormatDetail.JSP_FIELD_rpt_format_detail_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public RptFormatDetail getRptFormatDetail() {
        return rptFormatDetail;
    }

    public JspRptFormatDetail getForm() {
        return jspRptFormatDetail;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidRptFormatDetail) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                Vector listEdit = null;
                int squenceOld = 0;
                long refIdOld = 0;
                long oidOld = 0;
                if (oidRptFormatDetail != 0) {
                    try {

                        rptFormatDetail = DbRptFormatDetail.fetchExc(oidRptFormatDetail);
                        oidOld = rptFormatDetail.getOID();
                        squenceOld = rptFormatDetail.getSquence();
                        refIdOld = rptFormatDetail.getRefId();
                    } catch (Exception exc) {
                    }
                }

                jspRptFormatDetail.requestEntityObject(rptFormatDetail);

                if (rptFormatDetail.getRefId() != 0) {
                    try {
                        RptFormatDetail rpd = DbRptFormatDetail.fetchExc(rptFormatDetail.getRefId());
                        rptFormatDetail.setLevel(rpd.getLevel() + 1);
                    } catch (Exception e) {


                    }
                }

                if (jspRptFormatDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (rptFormatDetail.getOID() == 0) {
                    try {
                        long oid = dbRptFormatDetail.insertExc(this.rptFormatDetail);

                        /** Update Sequence gwawan */
                        int newSequence = this.rptFormatDetail.getSquence();

                        if (squenceOld != this.rptFormatDetail.getSquence()) {
                            String where = DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE] + ">=" + newSequence +
                                    " AND " + DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + this.rptFormatDetail.getRptFormatId();
                            Vector vRptFormatDetail = DbRptFormatDetail.list(0, 0, where, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);

                            for (int i = 0; i < vRptFormatDetail.size(); i++) {
                                RptFormatDetail objRptFormatDetail = (RptFormatDetail) vRptFormatDetail.get(i);
                                objRptFormatDetail.setSquence(newSequence + i);
                                if (objRptFormatDetail.getOID() != oid) {
                                    dbRptFormatDetail.updateExc(objRptFormatDetail);
                                } //update sequence hanya utk baris selanjutnya
                            }
                        }

                        //KHUSUS update level
                        if (refIdOld != this.rptFormatDetail.getRefId()) {
                            String where = DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE] + ">=" + newSequence +
                                    " AND " + DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + this.rptFormatDetail.getRptFormatId();
                            Vector vRptFormatDetail = DbRptFormatDetail.list(0, 0, where, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);

                            for (int i = 0; i < vRptFormatDetail.size(); i++) {
                                RptFormatDetail objRptFormatDetail = (RptFormatDetail) vRptFormatDetail.get(i);

                                if (objRptFormatDetail.getRefId() == 0) {
                                    objRptFormatDetail.setLevel(0);
                                } else {
                                    objRptFormatDetail.setLevel(DbRptFormatDetail.getParentLevel(objRptFormatDetail.getRefId()) + 1);
                                }

                                DbRptFormatDetail.updateExc(objRptFormatDetail);
                            }
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
                        long oid = dbRptFormatDetail.updateExc(this.rptFormatDetail);

                        /** Update Sequence gwawan */
                        int newSequence = this.rptFormatDetail.getSquence();

                        if (squenceOld != this.rptFormatDetail.getSquence()) {
                            String where = DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE] + ">=" + newSequence +
                                    " AND " + DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + this.rptFormatDetail.getRptFormatId();
                            Vector vRptFormatDetail = DbRptFormatDetail.list(0, 0, where, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);

                            for (int i = 0; i < vRptFormatDetail.size(); i++) {
                                RptFormatDetail objRptFormatDetail = (RptFormatDetail) vRptFormatDetail.get(i);
                                objRptFormatDetail.setSquence(newSequence + i);
                                if (objRptFormatDetail.getOID() != oid) {
                                    dbRptFormatDetail.updateExc(objRptFormatDetail);
                                } //update sequence hanya utk baris selanjutnya
                            }
                        }

                        //KHUSUS update level
                        if (refIdOld != this.rptFormatDetail.getRefId()) {
                            String where = DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE] + ">=" + newSequence +
                                    " AND " + DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + this.rptFormatDetail.getRptFormatId();
                            Vector vRptFormatDetail = DbRptFormatDetail.list(0, 0, where, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);

                            for (int i = 0; i < vRptFormatDetail.size(); i++) {
                                RptFormatDetail objRptFormatDetail = (RptFormatDetail) vRptFormatDetail.get(i);

                                if (objRptFormatDetail.getRefId() == 0) {
                                    objRptFormatDetail.setLevel(0);
                                } else {
                                    objRptFormatDetail.setLevel(DbRptFormatDetail.getParentLevel(objRptFormatDetail.getRefId()) + 1);
                                }

                                DbRptFormatDetail.updateExc(objRptFormatDetail);
                            }
                        }

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidRptFormatDetail != 0) {
                    try {
                        rptFormatDetail = DbRptFormatDetail.fetchExc(oidRptFormatDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidRptFormatDetail != 0) {
                    try {
                        rptFormatDetail = DbRptFormatDetail.fetchExc(oidRptFormatDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidRptFormatDetail != 0) {
                    try {
                        long oid = DbRptFormatDetail.deleteExc(oidRptFormatDetail);

                        if (oid != 0) {
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                        } else {
                            msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }

                        /** Update Sequence gwawan */
                        this.rptFormatDetail = DbRptFormatDetail.fetchExc(oidRptFormatDetail);
                        int delSquence = this.rptFormatDetail.getSquence();

                        String where = DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE] + ">=" + delSquence +
                                " AND " + DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + this.rptFormatDetail.getRptFormatId();
                        Vector vRptFormatDetail = DbRptFormatDetail.list(0, 0, where, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);

                        for (int i = 0; i < vRptFormatDetail.size(); i++) {
                            RptFormatDetail objRptFormatDetail = (RptFormatDetail) vRptFormatDetail.get(i);
                            this.rptFormatDetail = DbRptFormatDetail.fetchExc(objRptFormatDetail.getOID());
                            this.rptFormatDetail.setSquence(delSquence + i);
                            if (oid != this.rptFormatDetail.getOID()) {
                                dbRptFormatDetail.updateExc(this.rptFormatDetail);
                            }
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
