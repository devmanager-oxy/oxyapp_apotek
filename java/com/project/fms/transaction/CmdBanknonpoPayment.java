/* 
 * Ctrl Name  		:  CtrlBanknonpoPayment.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */
/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/
package com.project.fms.transaction;

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

public class CmdBanknonpoPayment extends Control implements I_Language {

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
    int language = LANGUAGE_DEFAULT;

    public CmdBanknonpoPayment(HttpServletRequest request) {
        msgString = "";
        banknonpoPayment = new BanknonpoPayment();
        try {
            dbBanknonpoPayment = new DbBanknonpoPayment(0);
        } catch (Exception e) {
            ;
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
            case JSPCommand.RECONFIRM:
                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;
            
            case JSPCommand.ADD:
                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;

            case JSPCommand.PRINT:
                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                String where = "'" + JSPFormater.formatDate(banknonpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";

                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;

            case JSPCommand.BACK:
                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;

            case JSPCommand.SAVE:
                
                if (oidBanknonpoPayment != 0) {
                    try {
                        banknonpoPayment = DbBanknonpoPayment.fetchExc(oidBanknonpoPayment);
                    } catch (Exception exc) {}
                }

                jspBanknonpoPayment.requestEntityObject(banknonpoPayment);

                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();

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
                
                Coa coa = new Coa();
                
                try {
                    coa = DbCoa.fetchExc(banknonpoPayment.getCoaId());
                } catch (Exception e) {}
                
                 //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_COA_ID, "postable account type required");
                }

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (banknonpoPayment.getOID() == 0) {
                    try {

                        banknonpoPayment.setDate(new Date());

                        //Untuk pemrosesan nomor jurnal BBK
                        Date dt = new Date();

                        Periode opnPeriode = new Periode();

                        try {
                            //opnPeriode = DbPeriode.getOpenPeriod();
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

            case JSPCommand.SUBMIT:

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
                
                coa = new Coa();
                
                try {
                    coa = DbCoa.fetchExc(banknonpoPayment.getCoaId());
                } catch (Exception e) {}
                
                 //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBanknonpoPayment.addError(jspBanknonpoPayment.JSP_COA_ID, "postable account type required");
                }

                if (jspBanknonpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
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
}
