/* 
 * Ctrl Name  		:  CtrlBankDeposit.java 
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
/* project package */
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
import com.project.*;
import com.project.util.*;

public class CmdBankDeposit extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private BankDeposit bankDeposit;
    private DbBankDeposit dbBankDeposit;
    private JspBankDeposit jspBankDeposit;
    int language = LANGUAGE_DEFAULT;

    public CmdBankDeposit(HttpServletRequest request) {
        msgString = "";
        bankDeposit = new BankDeposit();
        try {
            dbBankDeposit = new DbBankDeposit(0);
        } catch (Exception e) {
            ;
        }
        jspBankDeposit = new JspBankDeposit(request, bankDeposit);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspBankDeposit.addError(jspBankDeposit.JSP_BANK_DEPOSIT_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public BankDeposit getBankDeposit() {
        return bankDeposit;
    }

    public JspBankDeposit getForm() {
        return jspBankDeposit;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidBankDeposit) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                
                jspBankDeposit.requestEntityObject(bankDeposit);                
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                String where = "";                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankDeposit.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                } catch (Exception e) {
                }
                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_COA_ID, "postable account type required");
                }


                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankDeposit.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.BACK:
                jspBankDeposit.requestEntityObject(bankDeposit);

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                } catch (Exception e) {
                }
                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_COA_ID, "postable account type required");
                }
                
                preClosedPeriod = DbPeriode.getPreClosedPeriod();   

                where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankDeposit.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
           
                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankDeposit.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.SAVE:
                long oldBankCoa = 0;
                if (oidBankDeposit != 0) {
                    try {
                        bankDeposit = DbBankDeposit.fetchExc(oidBankDeposit);
                        oldBankCoa = bankDeposit.getCoaId();
                    } catch (Exception exc) {
                    }
                }

                jspBankDeposit.requestEntityObject(bankDeposit);

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                } catch (Exception e) {
                }
                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_COA_ID, "postable account type required");
                }

                preClosedPeriod = DbPeriode.getPreClosedPeriod();   

                where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankDeposit.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankDeposit.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (bankDeposit.getOID() == 0) {

                    try {
                        Date dt = new Date();
                        
                        Periode opnPeriode = new Periode();                        
                        try {                            
                            opnPeriode = DbPeriode.fetchExc(bankDeposit.getPeriodeId());   
                        } catch (Exception e){}
                        
                        int periodeTaken = 0;
                        
                        try {
                            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                        } catch (Exception e){}
                        
                        if (periodeTaken == 0){
                            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
                        } else if (periodeTaken == 1) {
                            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif}
                        }    

                        String formatDocCode = DbSystemDocNumber.getNumberPrefixBbm(opnPeriode.getOID());                        
                        int counter = DbSystemDocNumber.getNextCounterBbm(opnPeriode.getOID());
                        
                        bankDeposit.setDate(new Date());
                        bankDeposit.setJournalCounter(counter);
                        bankDeposit.setJournalPrefix(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BBM]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        
                        formatDocCode = DbSystemDocNumber.getNextNumberBbm(bankDeposit.getJournalCounter(),opnPeriode.getOID());
                        systemDocNumber.setDocNumber(formatDocCode);
                                                                  
                        bankDeposit.setJournalNumber(formatDocCode);
                        long oid = dbBankDeposit.insertExc(this.bankDeposit);

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
                        //jika banknya diupdate, update nomor
                        //if (oldBankCoa != bankDeposit.getCoaId()) {
                        //    bankDeposit.setDate(new Date());
                        //    bankDeposit.setJournalCounter(DbBankDeposit.getNextCounter(bankDeposit.getCoaId()));
                        //    bankDeposit.setJournalPrefix(DbBankDeposit.getNumberPrefix(bankDeposit.getCoaId()));
                        //    bankDeposit.setJournalNumber(DbBankDeposit.getNextNumber(bankDeposit.getJournalCounter(), bankDeposit.getCoaId()));
                        //}
                        long oid = dbBankDeposit.updateExc(this.bankDeposit);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            /*case JSPCommand.EDIT :
            if (oidBankDeposit != 0) {
            try {
            bankDeposit = DbBankDeposit.fetchExc(oidBankDeposit);
            } catch (CONException dbexc){
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
            } catch (Exception exc){ 
            msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
            }
            }
            break;
            case JSPCommand.ASK :
            if (oidBankDeposit != 0) {
            try {
            bankDeposit = DbBankDeposit.fetchExc(oidBankDeposit);
            } catch (CONException dbexc){
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
            } catch (Exception exc){ 
            msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
            }
            }
            break;
            case JSPCommand.DELETE :
            if (oidBankDeposit != 0){
            try{
            long oid = DbBankDeposit.deleteExc(oidBankDeposit);
            if(oid!=0){
            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
            excCode = RSLT_OK;
            }else{
            msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
            excCode = RSLT_FORM_INCOMPLETE;
            }
            }catch(CONException dbexc){
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
            }catch(Exception exc){	
            msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
            }
            }
            break;
             */
            case JSPCommand.SUBMIT:

                jspBankDeposit.requestEntityObject(bankDeposit);

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                } catch (Exception e) {
                }
                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_COA_ID, "postable account type required");
                }
                
                preClosedPeriod = DbPeriode.getPreClosedPeriod();   

                where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankDeposit.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankDeposit.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.POST:

                jspBankDeposit.requestEntityObject(bankDeposit);

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                } catch (Exception e) {
                }
                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_COA_ID, "postable account type required");
                }

                preClosedPeriod = DbPeriode.getPreClosedPeriod();   

                where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankDeposit.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
         
                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankDeposit.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;


            case JSPCommand.EDIT:
                /*if (oidBankDeposit != 0) {
                try {
                bankDeposit = DbBankDeposit.fetchExc(oidBankDeposit);
                } catch (CONException dbexc){
                excCode = dbexc.getErrorCode();
                msgString = getSystemMessage(excCode);
                } catch (Exception exc){ 
                msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                }
                }
                 */

                jspBankDeposit.requestEntityObject(bankDeposit);

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                } catch (Exception e) {
                }
                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_COA_ID, "postable account type required");
                }

                preClosedPeriod = DbPeriode.getPreClosedPeriod();   

                where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankDeposit.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
               
                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankDeposit.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.ASK:
                /*if (oidBankDeposit != 0) {
                try {
                bankDeposit = DbBankDeposit.fetchExc(oidBankDeposit);
                } catch (CONException dbexc){
                excCode = dbexc.getErrorCode();
                msgString = getSystemMessage(excCode);
                } catch (Exception exc){ 
                msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                }
                }
                 */

                jspBankDeposit.requestEntityObject(bankDeposit);

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                } catch (Exception e) {
                }
                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_COA_ID, "postable account type required");
                }

                preClosedPeriod = DbPeriode.getPreClosedPeriod();   

                where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankDeposit.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
      
                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankDeposit.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.DELETE:
                /*if (oidBankDeposit != 0){
                try{
                long oid = DbBankDeposit.deleteExc(oidBankDeposit);
                if(oid!=0){
                msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                excCode = RSLT_OK;
                }else{
                msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
                excCode = RSLT_FORM_INCOMPLETE;
                }
                }catch(CONException dbexc){
                excCode = dbexc.getErrorCode();
                msgString = getSystemMessage(excCode);
                }catch(Exception exc){	
                msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                }
                }
                 */

                jspBankDeposit.requestEntityObject(bankDeposit);

                coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                } catch (Exception e) {
                }
                //jika tidak postable tidak boleh
                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_COA_ID, "postable account type required");
                }

                preClosedPeriod = DbPeriode.getPreClosedPeriod();   

                where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+bankDeposit.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(bankDeposit.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
               
                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspBankDeposit.addError(jspBankDeposit.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspBankDeposit.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.RESET:

                if (oidBankDeposit != 0) {

                    try {
                        long oid = DbBankDeposit.deleteExc(oidBankDeposit);

                        if (oid != 0) {
                            DbBankDepositDetail.deleteAllDetail(oid);
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