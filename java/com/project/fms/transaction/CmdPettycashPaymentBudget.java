/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

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
import com.project.general.*;

public class CmdPettycashPaymentBudget extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private PettycashPayment pettycashPayment;
    private DbPettycashPayment dbPettycashPayment;
    private JspPettycashPayment jspPettycashPayment;
    private long budgetRequestId = 0;
    int language = LANGUAGE_DEFAULT;

    public CmdPettycashPaymentBudget(HttpServletRequest request) {
        msgString = "";
        pettycashPayment = new PettycashPayment();
        try {
            dbPettycashPayment = new DbPettycashPayment(0);
        } catch (Exception e) {
        }
        jspPettycashPayment = new JspPettycashPayment(request, pettycashPayment);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspPettycashPayment.addError(JspPettycashPayment.JSP_PETTYCASH_PAYMENT_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public PettycashPayment getPettycashPayment() {
        return pettycashPayment;
    }

    public JspPettycashPayment getForm() {
        return jspPettycashPayment;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPettycashPayment) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {

            case JSPCommand.ADD:
                
                jspPettycashPayment.requestEntityObject(pettycashPayment);
                
                break;

            case JSPCommand.BACK:

                jspPettycashPayment.requestEntityObject(pettycashPayment);
                
                if (jspPettycashPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;

            case JSPCommand.SAVE:
                
                if (oidPettycashPayment != 0){
                    try {
                        pettycashPayment = DbPettycashPayment.fetchExc(oidPettycashPayment);
                    } catch (Exception exc) {
                        System.out.println("[exception] " + exc.toString());
                    }
                }

                jspPettycashPayment.requestEntityObject(pettycashPayment);

                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                String where = "";
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(pettycashPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + pettycashPayment.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(pettycashPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
                
                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspPettycashPayment.addError(jspPettycashPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                Coa coa = new Coa();

                try {
                    coa = DbCoa.fetchExc(pettycashPayment.getCoaId());
                    if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        jspPettycashPayment.addError(JspPettycashPayment.JSP_COA_ID, "postable account required");
                    }
                } catch (Exception ex) {
                    System.out.println("[exception] " + ex.toString());
                }
                
                
                if (pettycashPayment.getOID() == 0) {
                    BudgetRequest bRequest = new BudgetRequest();
                    try{
                        bRequest = DbBudgetRequest.fetchExc(getBudgetRequestId());
                    }catch(Exception e){}
                    if(bRequest.getOID() == 0 || bRequest.getRefId() != 0){
                        jspPettycashPayment.addError(JspPettycashPayment.JSP_COA_ID, "Account already exsist");
                    }                    
                }

                if (jspPettycashPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (pettycashPayment.getOID() == 0) {
                    try {
                        
                        pettycashPayment.setDate(new Date());

                        //Untuk pemrosesan nomor jurnal BKK
                        Date dt = new Date();
                        Periode opnPeriode = new Periode();

                        try {                            
                            opnPeriode = DbPeriode.fetchExc(pettycashPayment.getPeriodeId());
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

                        Date dtx = (Date) dt.clone();
                        dtx.setDate(1);

                        String formatDocCode = DbSystemDocNumber.getNumberPrefixBkk(opnPeriode.getOID());
                        int counter = DbSystemDocNumber.getNextCounterBkk(opnPeriode.getOID());  

                        /* konsep baru */
                        pettycashPayment.setJournalCounter(counter);
                        pettycashPayment.setJournalPrefix(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BKK]);
                        
                        systemDocNumber.setYear(dt.getYear() + 1900);                        
                        formatDocCode = DbSystemDocNumber.getNextNumberBkk(pettycashPayment.getJournalCounter(), opnPeriode.getOID());                                                
                        
                        systemDocNumber.setDocNumber(formatDocCode);

                        pettycashPayment.setJournalNumber(formatDocCode);
                        pettycashPayment.setActivityStatus(I_Project.STATUS_NOT_POSTED);

                        if (!(DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y")) {
                            pettycashPayment.setActivityStatus(I_Project.STATUS_POSTED);
                        }

                        long oid = DbPettycashPayment.insertExc(this.pettycashPayment);

                        if (oid != 0) {
                            try {
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                        }
                        msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
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
                        long oid = DbPettycashPayment.updateExc(this.pettycashPayment);
                        msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidPettycashPayment != 0) {
                    try {
                        pettycashPayment = DbPettycashPayment.fetchExc(oidPettycashPayment);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspPettycashPayment.requestEntityObject(pettycashPayment);

                if (jspPettycashPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.ASK:

                jspPettycashPayment.requestEntityObject(pettycashPayment);

                if (jspPettycashPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.DELETE:

                jspPettycashPayment.requestEntityObject(pettycashPayment);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                String wherev = "";
                
                if(preClosedPeriod.getOID() != 0){                    
                    wherev = "'" + JSPFormater.formatDate(pettycashPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + pettycashPayment.getPeriodeId();
                }else{
                    wherev = "'" + JSPFormater.formatDate(pettycashPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
                
                Vector vv = DbPeriode.list(0, 0, wherev, "");
                
                if (vv == null || vv.size() == 0) {
                    jspPettycashPayment.addError(jspPettycashPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspPettycashPayment.errorSize() > 0) {
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
}
