package com.project.fms.ar;

import com.project.I_Project;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.fms.master.*;
import com.project.system.DbSystemProperty;

public class CmdArapMemo extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private ArapMemo arapMemo;
    private DbArapMemo pstArapMemo;
    private JspArapMemo frmArapMemo;
    int language = LANGUAGE_DEFAULT;

    public CmdArapMemo(HttpServletRequest request) {
        msgString = "";
        arapMemo = new ArapMemo();
        try {
            pstArapMemo = new DbArapMemo(0);
        } catch (Exception e) {
            ;
        }
        frmArapMemo = new JspArapMemo(request, arapMemo);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.frmArapMemo.addError(frmArapMemo.JSP_ARAP_MEMO_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public ArapMemo getArapMemo() {
        return arapMemo;
    }

    public JspArapMemo getForm() {
        return frmArapMemo;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidArapMemo) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidArapMemo != 0) {
                    try {
                        arapMemo = DbArapMemo.fetchExc(oidArapMemo);
                    } catch (Exception exc) {
                    }
                }

                frmArapMemo.requestEntityObject(arapMemo);
                
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                String where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(arapMemo.getDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+arapMemo.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(arapMemo.getDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
                                
                Coa coa = new Coa();                
                try {
                    coa = DbCoa.fetchExc(arapMemo.getCoaId());
                } catch (Exception e) {}
                
                Coa coaAp = new Coa();                
                try {
                    coaAp = DbCoa.fetchExc(arapMemo.getCoaApId());
                } catch (Exception e) {}
                
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    frmArapMemo.addError(frmArapMemo.JSP_COA_ID, "postable account type required");
                }
                
                if (!coaAp.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    frmArapMemo.addError(frmArapMemo.JSP_COA_AP_ID, "postable account type required");
                }

                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    frmArapMemo.addError(frmArapMemo.JSP_DATE, "Date out of open period range");
                }

                if (frmArapMemo.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (arapMemo.getOID() == 0) {
                    try {

                        arapMemo.setDate(new Date());
                        Date dt = new Date();
                        Periode opnPeriode = new Periode();
                        try {
                            opnPeriode = DbPeriode.fetchExc(arapMemo.getPeriodeId());
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

                        if(arapMemo.getType() == DbArapMemo.TYPE_AP){
                            formatDocCode = DbSystemDocNumber.getNumberPrefixApMemo(opnPeriode.getOID());
                            counter = DbSystemDocNumber.getNextCounterApMemo(opnPeriode.getOID());
                        }else{
                            formatDocCode = DbSystemDocNumber.getNumberPrefixArMemo(opnPeriode.getOID());
                            counter = DbSystemDocNumber.getNextCounterArMemo(opnPeriode.getOID());
                        }
                        
                        arapMemo.setCounter(counter);
                        arapMemo.setPrefixNumber(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        if(arapMemo.getType() == DbArapMemo.TYPE_AP){
                            systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AP_MEMO]);
                        }else{
                            systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AR_MEMO]);
                        }
                        
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        
                        if(arapMemo.getType() == DbArapMemo.TYPE_AP){
                            formatDocCode = DbSystemDocNumber.getNextNumberApMemo(arapMemo.getCounter(), opnPeriode.getOID());
                        }else{
                            formatDocCode = DbSystemDocNumber.getNextNumberArMemo(arapMemo.getCounter(), opnPeriode.getOID());
                        }
                        systemDocNumber.setDocNumber(formatDocCode);
                        arapMemo.setNumber(formatDocCode);
                        
                        if(arapMemo.getStatus() == DbArapMemo.TYPE_STATUS_DRAFT){
                            arapMemo.setApproval1(arapMemo.getUserId());
                            arapMemo.setDateApp1(new Date());
                            arapMemo.setApproval2(0);
                            arapMemo.setDateApp2(null);
                        }
                        
                        if(arapMemo.getStatus() == DbArapMemo.TYPE_STATUS_APPROVED){
                            if(arapMemo.getApproval1() == 0){
                                arapMemo.setApproval1(arapMemo.getUserId());
                                arapMemo.setDateApp1(new Date());
                            }
                            arapMemo.setApproval2(arapMemo.getUserId());
                            arapMemo.setDateApp2(new Date());
                        }
                        
                        long oid = pstArapMemo.insertExc(this.arapMemo);
                        
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
                        
                        if(arapMemo.getStatus() == DbArapMemo.TYPE_STATUS_DRAFT){
                            arapMemo.setApproval1(arapMemo.getUserId());
                            arapMemo.setDateApp1(new Date());
                            arapMemo.setApproval2(0);
                            arapMemo.setDateApp2(null);
                        }
                        
                        if(arapMemo.getStatus() == DbArapMemo.TYPE_STATUS_APPROVED){
                            if(arapMemo.getApproval1() == 0){
                                arapMemo.setApproval1(arapMemo.getUserId());
                                arapMemo.setDateApp1(new Date());
                            }
                            arapMemo.setApproval2(arapMemo.getUserId());
                            arapMemo.setDateApp2(new Date());
                        }
                        
                        long oid = pstArapMemo.updateExc(this.arapMemo);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidArapMemo != 0) {
                    try {
                        arapMemo = DbArapMemo.fetchExc(oidArapMemo);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.REFRESH:
                if (oidArapMemo != 0) {
                    try {
                        arapMemo = DbArapMemo.fetchExc(oidArapMemo);
                    } catch (Exception exc) {
                    }
                }
                frmArapMemo.requestEntityObject(arapMemo);
                break;

            case JSPCommand.ASK:
                if (oidArapMemo != 0) {
                    try {
                        arapMemo = DbArapMemo.fetchExc(oidArapMemo);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidArapMemo != 0) {
                    try {
                        long oid = DbArapMemo.deleteExc(oidArapMemo);
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
