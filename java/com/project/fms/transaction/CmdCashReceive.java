package com.project.fms.transaction;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.journal.*;
import com.project.*;
import com.project.util.lang.*;
import com.project.fms.master.*;
import com.project.general.DbSystemDocCode;
import com.project.general.DbSystemDocNumber;
import com.project.general.SystemDocNumber;
import com.project.general.*;
import com.project.system.DbSystemProperty;

public class CmdCashReceive extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private CashReceive cashReceive;
    private DbCashReceive pstCashReceive;
    private JspCashReceive jspCashReceive;
    int language = LANGUAGE_DEFAULT;

    public CmdCashReceive(HttpServletRequest request) {
        msgString = "";
        cashReceive = new CashReceive();
        try {
            pstCashReceive = new DbCashReceive(0);
        } catch (Exception e) {
            ;
        }
        jspCashReceive = new JspCashReceive(request, cashReceive);
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

    public CashReceive getCashReceive() {
        return cashReceive;
    }

    public JspCashReceive getForm() {
        return jspCashReceive;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidCashReceive) {
        
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd){
            
            case JSPCommand.ADD:
                
                jspCashReceive.requestEntityObject(cashReceive);
                
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                String where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+cashReceive.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspCashReceive.addError(jspCashReceive.JSP_TRANS_DATE, "transaction date out of open period range");
                }

                Coa coa = new Coa();
                
                try {
                    coa = DbCoa.fetchExc(cashReceive.getCoaId());
                } catch (Exception e) {}

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspCashReceive.addError(jspCashReceive.JSP_COA_ID, "postable account type required");
                }

                if (jspCashReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.BACK:
                
                jspCashReceive.requestEntityObject(cashReceive);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+cashReceive.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspCashReceive.addError(jspCashReceive.JSP_TRANS_DATE, "transaction date out of open period range");
                }

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(cashReceive.getCoaId());
                } catch (Exception e) {

                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspCashReceive.addError(jspCashReceive.JSP_COA_ID, "postable account type required");
                }

                if (jspCashReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.SAVE:
                if (oidCashReceive != 0) {
                    try {
                        cashReceive = DbCashReceive.fetchExc(oidCashReceive);
                    }catch (Exception exc) {System.out.println("[exception] "+exc.toString());}
                }

                jspCashReceive.requestEntityObject(cashReceive);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+cashReceive.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                
                if (v == null || v.size() == 0) {
                    jspCashReceive.addError(jspCashReceive.JSP_TRANS_DATE, "transaction date out of open period range");
                }

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(cashReceive.getCoaId());
                } catch (Exception e){}

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspCashReceive.addError(jspCashReceive.JSP_COA_ID, "postable account type required");
                }

                if (jspCashReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (cashReceive.getOID() == 0){
                    try {
                        
                        cashReceive.setDate(new Date());                        
                        Date dt = new Date();
                        Periode opnPeriode = new Periode();                        
                        try{                            
                            opnPeriode = DbPeriode.fetchExc(cashReceive.getPeriodeId());                            
                        }catch(Exception e){}
                        
                        int periodeTaken = 0;
                        
                        try{
                            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                        }catch(Exception e){}
                        
                        if(periodeTaken == 0){
                            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
                        }else if(periodeTaken == 1){
                            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
                        }
                        
                        String formatDocCode = DbSystemDocNumber.getNumberPrefixBkm(opnPeriode.getOID());                        
                        int counter = DbSystemDocNumber.getNextCounterBkm(opnPeriode.getOID());

                        cashReceive.setJournalCounter(counter);
                        cashReceive.setJournalPrefix(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKM]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
            
                        formatDocCode = DbSystemDocNumber.getNextNumberBkm(cashReceive.getJournalCounter(),opnPeriode.getOID());
                        systemDocNumber.setDocNumber(formatDocCode);
                        cashReceive.setJournalNumber(formatDocCode);

                        //kalau titipan set pengali adalah 1
                        if (cashReceive.getType() == DbCashReceive.TYPE_CASH_LIABILITY || cashReceive.getType() == DbCashReceive.TYPE_CASH_INCOME || cashReceive.getType() == DbCashReceive.TYPE_BYMHD_NEW || cashReceive.getType() == DbCashReceive.TYPE_DP) {
                            cashReceive.setInOut(1);
                        } else if (cashReceive.getType() == DbCashReceive.TYPE_CASH_LIABILITY_PAYMENT || cashReceive.getType() == DbCashReceive.TYPE_BYMHD || cashReceive.getType() == DbCashReceive.TYPE_DP_RETURN) {
                            cashReceive.setInOut(-1);
                        }

                        long oid = pstCashReceive.insertExc(this.cashReceive);

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
                        long oid = pstCashReceive.updateExc(this.cashReceive);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SUBMIT:

                jspCashReceive.requestEntityObject(cashReceive);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+cashReceive.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspCashReceive.addError(jspCashReceive.JSP_TRANS_DATE, "transaction date out of open period range");
                }

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(cashReceive.getCoaId());
                } catch (Exception e){}

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspCashReceive.addError(jspCashReceive.JSP_COA_ID, "postable account type required");
                }

                if (jspCashReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.POST:

                jspCashReceive.requestEntityObject(cashReceive);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+cashReceive.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspCashReceive.addError(jspCashReceive.JSP_TRANS_DATE, "transaction date out of open period range");
                }

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(cashReceive.getCoaId());
                } catch (Exception e) {

                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspCashReceive.addError(jspCashReceive.JSP_COA_ID, "postable account type required");
                }

                if (jspCashReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;


            case JSPCommand.EDIT:
                if (oidCashReceive != 0) {
                    try {
                        cashReceive = DbCashReceive.fetchExc(oidCashReceive);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspCashReceive.requestEntityObject(cashReceive);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+cashReceive.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspCashReceive.addError(jspCashReceive.JSP_TRANS_DATE, "transaction date out of open period range");
                }

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(cashReceive.getCoaId());
                } catch (Exception e){}

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspCashReceive.addError(jspCashReceive.JSP_COA_ID, "postable account type required");
                }

                if (jspCashReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.ASK:

                jspCashReceive.requestEntityObject(cashReceive);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+cashReceive.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspCashReceive.addError(jspCashReceive.JSP_TRANS_DATE, "transaction date out of open period range");
                }

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(cashReceive.getCoaId());
                } catch (Exception e) {

                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspCashReceive.addError(jspCashReceive.JSP_COA_ID, "postable account type required");
                }

                if (jspCashReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.DELETE:

                jspCashReceive.requestEntityObject(cashReceive);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+cashReceive.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(cashReceive.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
               
                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspCashReceive.addError(jspCashReceive.JSP_TRANS_DATE, "transaction date out of open period range");
                }

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(cashReceive.getCoaId());
                } catch (Exception e) {

                }

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspCashReceive.addError(jspCashReceive.JSP_COA_ID, "postable account type required");
                }

                if (jspCashReceive.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.RESET:

                if (oidCashReceive != 0) {
                    try {
                        
                        long oid = DbCashReceive.deleteExc(oidCashReceive);
                        
                        if(oid != 0){
                            try{
                                DbCashReceiveDetail.deleteAllDetail(oidCashReceive);
                                DbApprovalDoc.deleteApprovalByDocId(oidCashReceive);
                            }catch(Exception e){}
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
