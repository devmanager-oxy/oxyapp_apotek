/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;


/**
 *
 * @author Roy
 */


/* java package */
/* java package */
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
import com.project.util.*;
import com.project.system.*;

public class CmdBanknonpoPaymentBudget extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private BanknonpoPayment banknonpoPayment;
    private DbBanknonpoPayment dbBanknonpoPayment;
    private JspBanknonpoPayment jspBanknonpoPayment;
    private long budgetRequestId = 0;
    
    //========untuk component Bg
    private String noBg = "";
    private long coaId = 0;
    private Date dueDate;
    private double amountDetail = 0;
    
    int language = LANGUAGE_DEFAULT;

    public CmdBanknonpoPaymentBudget(HttpServletRequest request) {
        msgString = "";
        banknonpoPayment = new BanknonpoPayment();
        try {
            dbBanknonpoPayment = new DbBanknonpoPayment(0);
        } catch (Exception e) {            
        }
        jspBanknonpoPayment = new JspBanknonpoPayment(request, banknonpoPayment);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_BANKNONPO_PAYMENT_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public BanknonpoPayment getBanknonpoPayment() {
        return banknonpoPayment;
    }

    public JspBanknonpoPayment getForm() {
        return jspBanknonpoPayment;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidBanknonpoPayment) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {

            case JSPCommand.BACK:
                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;
                
             case JSPCommand.REFRESH:
                if (oidBanknonpoPayment != 0) {
                    try {
                        banknonpoPayment = DbBanknonpoPayment.fetchExc(oidBanknonpoPayment);
                    } catch (Exception exc) {}
                } 
                 
                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);
                break;    

            case JSPCommand.SAVE:
                
                if (oidBanknonpoPayment != 0) {
                    try {
                        banknonpoPayment = DbBanknonpoPayment.fetchExc(oidBanknonpoPayment);
                    } catch (Exception exc) {}
                }

                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();

                String where = "";
                
                if (preClosedPeriod.getOID() != 0) {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + banknonpoPayment.getPeriodeId();
                } else {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }
                
                Coa coa = new Coa();
                
                try {
                    coa = DbCoa.fetchExc(banknonpoPayment.getCoaId());
                } catch (Exception e) {}
                
                 //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_COA_ID, "postable account type required");
                }
                long oidBG = 0;
                long oidCheckPending = 0;
                try {
                    oidBG = Long.parseLong(DbSystemProperty.getValueByName("OID_PAYMENT_BG"));
                } catch (Exception e) {}
                
                try {
                    oidCheckPending = Long.parseLong(DbSystemProperty.getValueByName("OID_PAYMENT_CHECK_PENDING"));
                } catch (Exception e) {
                }
                
                if (banknonpoPayment.getOID() == 0) {
                    BudgetRequest bRequest = new BudgetRequest();
                    try{
                        bRequest = DbBudgetRequest.fetchExc(budgetRequestId);
                    }catch(Exception e){}
                    if(bRequest.getOID() == 0 || bRequest.getRefId() != 0){
                        jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_COA_ID, "Account already exsist");
                    }         
                    
                    if(banknonpoPayment.getPaymentMethodId() == oidBG || banknonpoPayment.getPaymentMethodId() == oidCheckPending){ 
                        if(!(banknonpoPayment.getRefNumber().length() > 0 && banknonpoPayment.getRefNumber().compareToIgnoreCase("0") !=0 && coaId != 0 && amountDetail != 0)){
                            jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_PAYMENT_METHOD_ID, "Data tidak lengkap");                            
                        }
                    }
                }
                
                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (banknonpoPayment.getOID() == 0) {
                    try {

                        banknonpoPayment.setDate(new Date());
                        banknonpoPayment.setAmount(getAmountDetail());
                        //Untuk pemrosesan nomor jurnal BBK
                        Date dt = new Date();
                        Periode opnPeriode = new Periode();
                        try {                            
                            opnPeriode = DbPeriode.fetchExc(banknonpoPayment.getPeriodeId());
                        } catch (Exception e) {}

                        int periodeTaken = 0;

                        try {
                            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                        } catch (Exception e) {}

                        if (periodeTaken == 0) {
                            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
                        } else if (periodeTaken == 1) {
                            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
                        }

                        Date dtx = (Date) dt.clone();
                        dtx.setDate(1);

                        String formatDocCode = DbSystemDocNumber.getNumberPrefixBbk(opnPeriode.getOID());
                        int counter = DbSystemDocNumber.getNextCounterBbk(opnPeriode.getOID());

                        /* konsep baru */
                        banknonpoPayment.setJournalCounter(counter);
                        banknonpoPayment.setJournalPrefix(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBK]);
                        systemDocNumber.setYear(dt.getYear() + 1900);

                        formatDocCode = DbSystemDocNumber.getNextNumberBbk(banknonpoPayment.getJournalCounter(), opnPeriode.getOID());
                        systemDocNumber.setDocNumber(formatDocCode);

                        banknonpoPayment.setJournalNumber(formatDocCode);
                        banknonpoPayment.setActivityStatus(I_Project.STATUS_NOT_POSTED);

                        if (!(DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y")) {
                            banknonpoPayment.setActivityStatus(I_Project.STATUS_POSTED);
                        }

                        //jika advance tidak mengecek activity
                        if (banknonpoPayment.getType() == I_Project.TYPE_INT_EMPLOYEE_ADVANCE) {
                            banknonpoPayment.setActivityStatus(I_Project.STATUS_POSTED);
                        } else {
                            banknonpoPayment.setActivityStatus(I_Project.STATUS_NOT_POSTED);
                        }

                        long oid = dbBanknonpoPayment.insertExc(this.banknonpoPayment);
                        
                        if (oid != 0) {                            
                            try {
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                            try{
                                if(banknonpoPayment.getPaymentMethodId() == oidBG || banknonpoPayment.getPaymentMethodId() == oidCheckPending){
                                    long oidRp = 0;
                                    try{
                                        oidRp = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                    }catch(Exception e){}
                                    BankPayment bp = new BankPayment();
                                    bp.setReferensiId(oid);
                                    bp.setAmount(banknonpoPayment.getAmount());
                                    if (banknonpoPayment.getPaymentMethodId() == oidBG){
                                        bp.setType(DbBankPayment.TYPE_BANK_NONPO);
                                    }else if(banknonpoPayment.getPaymentMethodId() == oidCheckPending){
                                        bp.setType(DbBankPayment.TYPE_BANK_NONPO_CHECK);
                                    }
                            
                                    bp.setNumber(banknonpoPayment.getRefNumber());
                                    bp.setCreateDate(new Date());
                                    bp.setCoaId(banknonpoPayment.getCoaId());
                                    bp.setCoaPaymentId(getCoaId());
                                    bp.setCurrencyId(oidRp);
                                    bp.setDueDate(getDueDate());
                                    bp.setStatus(DbBankPayment.STATUS_NOT_PAID);
                                    bp.setCreateId(banknonpoPayment.getOperatorId());
                                    bp.setSegment1Id(banknonpoPayment.getSegment1Id());
                                    bp.setSegment2Id(banknonpoPayment.getSegment2Id());
                                    bp.setSegment3Id(banknonpoPayment.getSegment3Id());
                                    bp.setSegment4Id(banknonpoPayment.getSegment4Id());
                                    bp.setSegment5Id(banknonpoPayment.getSegment5Id());
                                    bp.setSegment6Id(banknonpoPayment.getSegment6Id());
                                    bp.setSegment7Id(banknonpoPayment.getSegment7Id());
                                    bp.setSegment8Id(banknonpoPayment.getSegment8Id());
                                    bp.setSegment9Id(banknonpoPayment.getSegment9Id());
                                    bp.setSegment10Id(banknonpoPayment.getSegment10Id());
                                    bp.setSegment11Id(banknonpoPayment.getSegment11Id());
                                    bp.setSegment12Id(banknonpoPayment.getSegment12Id());
                                    bp.setSegment13Id(banknonpoPayment.getSegment13Id());
                                    bp.setSegment14Id(banknonpoPayment.getSegment14Id());
                                    bp.setSegment15Id(banknonpoPayment.getSegment15Id());
                                    bp.setTransactionDate(banknonpoPayment.getTransDate());
                                    bp.setVendorId(banknonpoPayment.getVendorId());
                                    bp.setJournalCounter(banknonpoPayment.getJournalCounter());
                                    bp.setJournalPrefix(banknonpoPayment.getJournalPrefix());
                                    if (banknonpoPayment.getPaymentMethodId() == oidBG){
                                        bp.setJournalNumber(banknonpoPayment.getJournalNumber() + "-BG");
                                    }else if(banknonpoPayment.getPaymentMethodId() == oidCheckPending){
                                        bp.setJournalNumber(banknonpoPayment.getJournalNumber() + "-CHEQUE");
                                    }

                                    try {
                                        DbBankPayment.insertExc(bp);
                                    } catch (Exception e) {
                                    }
                                    
                                    long oidBGNumber = DbBgMaster.getId(banknonpoPayment.getRefNumber(),getCoaId());
                                    DbBgMaster.updateRefId(oidBGNumber,oid,getDueDate(),getAmountDetail());
                                }
                            }catch(Exception e){}
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
                        long oid = dbBanknonpoPayment.updateExc(this.banknonpoPayment);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.POST:

                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();
                if (preClosedPeriod.getOID() != 0) {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + banknonpoPayment.getPeriodeId();
                } else {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;
            
            case JSPCommand.EDIT:

                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();
                if (preClosedPeriod.getOID() != 0) {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + banknonpoPayment.getPeriodeId();
                } else {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.ASK:              

                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();
                if (preClosedPeriod.getOID() != 0) {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + banknonpoPayment.getPeriodeId();
                } else {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.DELETE:

                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();
                if (preClosedPeriod.getOID() != 0) {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + banknonpoPayment.getPeriodeId();
                } else {
                    where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                            " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            default:

        }
        return rsCode;
    }

    public long getBudgetRequestId() {
        return budgetRequestId;
    }

    public void setBudgetRequestId(long budgetRequestId) {
        this.budgetRequestId = budgetRequestId;
    }

    public String getNoBg() {
        return noBg;
    }

    public void setNoBg(String noBg) {
        this.noBg = noBg;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public double getAmountDetail() {
        return amountDetail;
    }

    public void setAmountDetail(double amountDetail) {
        this.amountDetail = amountDetail;
    }
}