/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.receiving;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.*;
import com.project.ccs.posmaster.DbStockCode;
import com.project.ccs.postransaction.stock.*;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.SystemDocNumber;
import com.project.system.DbSystemProperty;

/**
 *
 * @author Roy Andika
 */
public class CmdReceiveMemo extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private Receive receive;
    private DbReceive dbReceive;
    private JspReceiveMemo jspReceiveMemo;
    int language = LANGUAGE_DEFAULT;

    public CmdReceiveMemo(HttpServletRequest request) {
        msgString = "";
        receive = new Receive();
        try {
            dbReceive = new DbReceive(0);
        } catch (Exception e) {

        }
        jspReceiveMemo = new JspReceiveMemo(request, receive);
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

    public Receive getReceiveMemo() {
        return receive;
    }

    public JspReceiveMemo getForm() {
        return jspReceiveMemo;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidReceive,int err) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (Exception exc) {
                    }
                }
                break;

            case JSPCommand.BACK:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (Exception exc) {
                    }
                }
                break;

            case JSPCommand.SUBMIT:

                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (Exception exc) {
                    }
                }

                jspReceiveMemo.requestEntityObject(receive);

                if (jspReceiveMemo.errorSize() > 0 || err > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (receive.getOID() == 0) {

                    try {
                        if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                            receive.setApproval1(receive.getUserId());
                            receive.setApproval1Date(new Date());
                            receive.setApproval2(0);
                            receive.setApproval2Date(null);
                        }
                        
                        long oid = dbReceive.insertExc(this.receive);
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
                        if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                            receive.setApproval1(receive.getUserId());
                            receive.setApproval1Date(new Date());
                            receive.setApproval2(0);
                            receive.setApproval2Date(null);
                        }
                        
                        long oid = dbReceive.updateExc(this.receive);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                break;

            case JSPCommand.SAVE:

                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (Exception exc) {
                    }
                }

                jspReceiveMemo.requestEntityObject(receive);
                
                String where = "";
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(receive.getDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+receive.getPeriodId();
                }else{
                    where = "'" + JSPFormater.formatDate(receive.getDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspReceiveMemo.addError(jspReceiveMemo.JSP_DATE, "transaction date out of open period range");
                }
                
                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(receive.getCoaId());
                } catch (Exception e) {}

                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspReceiveMemo.addError(jspReceiveMemo.JSP_COA_ID, "postable account type required");
                }
                
                if (jspReceiveMemo.errorSize() > 0 || err > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (receive.getOID() == 0) {
                    try {

                        receive.setDate(new Date());
                        Date dt = new Date();
                        Periode opnPeriode = new Periode();
                        try {
                            opnPeriode = DbPeriode.fetchExc(receive.getPeriodId());
                        } catch (Exception e) {
                        }

                        int periodeTaken = 0;

                        try {
                            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                        } catch (Exception e) {
                        }

                        if (periodeTaken == 0) {
                            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
                        } else if (periodeTaken == 1) {
                            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
                        }

                        String formatDocCode = "";
                        int counter = 0;

                        formatDocCode = DbSystemDocNumber.getNumberPrefixApMemo(opnPeriode.getOID());
                        counter = DbSystemDocNumber.getNextCounterApMemo(opnPeriode.getOID());

                        receive.setCounter(counter);
                        receive.setPrefixNumber(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AP_MEMO]);

                        systemDocNumber.setYear(dt.getYear() + 1900);
                        formatDocCode = DbSystemDocNumber.getNextNumberApMemo(receive.getCounter(), opnPeriode.getOID());

                        systemDocNumber.setDocNumber(formatDocCode);
                        receive.setNumber(formatDocCode);

                        if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                            receive.setApproval1(receive.getUserId());
                            receive.setApproval1Date(new Date());
                            receive.setApproval2(0);
                            receive.setApproval2Date(null);
                        }

                        long oid = dbReceive.insertExc(this.receive);

                        if (oid != 0) {
                            try {
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception E) {
                                System.out.println("[exception] " + E.toString());
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
                        if (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                            receive.setApproval1(receive.getUserId());
                            receive.setApproval1Date(new Date());
                            receive.setApproval2(0);
                            receive.setApproval2Date(null);
                        }

                        if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                            if (receive.getApproval1() == 0) {
                                receive.setApproval1(receive.getUserId());
                                receive.setApproval1Date(new Date());
                            }
                            receive.setApproval2(receive.getUserId());
                            receive.setApproval2Date(new Date());
                        }
                        long oid = dbReceive.updateExc(this.receive);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.EDIT:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                        if(receive.getTotalAmount() != 0){
                            double amount = receive.getTotalAmount() * -1;
                            receive.setTotalAmount(amount);
                        }                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASSIGN:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                        if(receive.getTotalAmount() != 0){
                            double amount = receive.getTotalAmount() * -1;
                            receive.setTotalAmount(amount);
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ACTIVATE:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            //hanya untuk loading    
            case JSPCommand.ASK:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            //hanya untuk loading
            case JSPCommand.DELETE:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

           

            case JSPCommand.CONFIRM:
                if (oidReceive != 0) {
                    try {
                        DbStockCode.deleteAllItem(oidReceive);
                        DbReceiveItem.deleteAllItem(oidReceive);
                        long oid = DbReceive.deleteExc(oidReceive);
                        if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                            DbStock.delete(DbStock.colNames[DbStock.COL_INCOMING_ID] + " = " + oidReceive);
                        }

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
