/* 
 * Ctrl Name  		:  CtrlBankpoPayment.java 
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
import com.project.fms.transaction.*;
import com.project.fms.master.*;

public class CmdBankpoPayment extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private BankpoPayment bankpoPayment;
    private DbBankpoPayment dbBankpoPayment;
    private JspBankpoPayment jspBankpoPayment;
    int language = LANGUAGE_DEFAULT;

    public CmdBankpoPayment(HttpServletRequest request) {
        msgString = "";
        bankpoPayment = new BankpoPayment();
        try {
            dbBankpoPayment = new DbBankpoPayment(0);
        } catch (Exception e) {
            ;
        }
        jspBankpoPayment = new JspBankpoPayment(request, bankpoPayment);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspBankpoPayment.addError(jspBankpoPayment.JSP_BANKPO_PAYMENT_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public BankpoPayment getBankpoPayment() {
        return bankpoPayment;
    }

    public JspBankpoPayment getForm() {
        return jspBankpoPayment;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidBankpoPayment) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                jspBankpoPayment.requestEntityObject(bankpoPayment);

                if (jspBankpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;

            case JSPCommand.PRINT:
                
                jspBankpoPayment.requestEntityObject(bankpoPayment);
                
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                String where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankpoPayment.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankpoPayment.addError(jspBankpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;
            case JSPCommand.BACK:
                jspBankpoPayment.requestEntityObject(bankpoPayment);

                if (jspBankpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;

            case JSPCommand.SAVE:
                if (oidBankpoPayment != 0) {
                    try {
                        bankpoPayment = DbBankpoPayment.fetchExc(oidBankpoPayment);
                    } catch (Exception exc) {
                        System.out.println("[exception] " + exc.toString());
                    }
                }

                jspBankpoPayment.requestEntityObject(bankpoPayment);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankpoPayment.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankpoPayment.addError(jspBankpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }
                
                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankpoPayment.getCoaId());
                } catch (Exception e){}

                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankpoPayment.addError(jspBankpoPayment.JSP_COA_ID, "postable account type required");
                }
            
                if (jspBankpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (bankpoPayment.getOID() == 0) {
                    try {
                        
                        bankpoPayment.setDate(new Date());
                        bankpoPayment.setStatus(I_Project.STATUS_NOT_POSTED);
                        
                        Date dt = new Date();
                        Periode opnPeriode = new Periode();                        
                        try{                            
                            opnPeriode = DbPeriode.fetchExc(bankpoPayment.getPeriodeId());                            
                        }catch(Exception e){}

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
                        String formatDocCode = DbSystemDocNumber.getNumberPrefixTT(opnPeriode.getOID());
                        int counter = DbSystemDocNumber.getNextCounterTT(opnPeriode.getOID());

                        /* konsep baru */
                        bankpoPayment.setJournalCounter(counter);
                        bankpoPayment.setJournalPrefix(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_TT]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        formatDocCode = DbSystemDocNumber.getNextNumberTT(bankpoPayment.getJournalCounter(), opnPeriode.getOID());
                        
                        systemDocNumber.setDocNumber(formatDocCode);                        
                        bankpoPayment.setJournalNumber(formatDocCode);
                        
                        long oid = dbBankpoPayment.insertExc(this.bankpoPayment);
                        
                        if(oid != 0){ // jika proses penyimpanan dilakukan dengan sukses dan itu termasuk proses iner baru
                            try{
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            }catch(Exception E){
                                System.out.println("[exception] "+E.toString());
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
                        long oid = dbBankpoPayment.updateExc(this.bankpoPayment);
                        bankpoPayment.setStatus(I_Project.STATUS_NOT_POSTED);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SUBMIT:
                if (oidBankpoPayment != 0) {
                    try {
                        bankpoPayment = DbBankpoPayment.fetchExc(oidBankpoPayment);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.POST:

                jspBankpoPayment.requestEntityObject(bankpoPayment);

                where = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankpoPayment.addError(jspBankpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;
            
            case JSPCommand.EDIT:

                jspBankpoPayment.requestEntityObject(bankpoPayment);

                where = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankpoPayment.addError(jspBankpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.ASK:

                jspBankpoPayment.requestEntityObject(bankpoPayment);

                where = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankpoPayment.addError(jspBankpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.DELETE:

                jspBankpoPayment.requestEntityObject(bankpoPayment);

                where = "'" + JSPFormater.formatDate(bankpoPayment.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankpoPayment.addError(jspBankpoPayment.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankpoPayment.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

        }
        return rsCode;
    }
}
