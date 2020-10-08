/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

/**
 *
 * @author Roy
 */
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


public class CmdSetoranKasir extends Control implements I_Language {
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private SetoranKasir setoranKasir;
    private DbSetoranKasir dbSetoranKasir;
    private JspSetoranKasir jspSetoranKasir;
    int language = LANGUAGE_DEFAULT;

    public CmdSetoranKasir(HttpServletRequest request) {
        msgString = "";
        setoranKasir = new SetoranKasir();
        try {
            dbSetoranKasir = new DbSetoranKasir(0);
        } catch (Exception e) {
        }
        jspSetoranKasir = new JspSetoranKasir(request, setoranKasir);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspSetoranKasir.addError(JspSetoranKasir.JSP_SETORAN_KASIR_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public SetoranKasir getSetoranKasir() {
        return setoranKasir;
    }

    public JspSetoranKasir getForm() {
        return jspSetoranKasir;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidSetoranKasir) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {

            case JSPCommand.ADD:

                jspSetoranKasir.requestEntityObject(setoranKasir);

                break;

            case JSPCommand.BACK:

                jspSetoranKasir.requestEntityObject(setoranKasir);
                
                if (jspSetoranKasir.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                break;

            case JSPCommand.SAVE:
                
                if (oidSetoranKasir != 0){
                    try {
                        setoranKasir = DbSetoranKasir.fetchExc(oidSetoranKasir);
                    } catch (Exception exc) {
                        System.out.println("[exception] " + exc.toString());
                    }
                }

                jspSetoranKasir.requestEntityObject(setoranKasir);
                
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                String where = "";
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(setoranKasir.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + setoranKasir.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(setoranKasir.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
                
                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspSetoranKasir.addError(jspSetoranKasir.JSP_TRANSACTION_DATE, "<br>transaction date out of open period range");
                }
                
                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(setoranKasir.getCoaId());
                    if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        jspSetoranKasir.addError(jspSetoranKasir.JSP_COA_ID, "postable account required");
                    }
                } catch (Exception ex) {
                    System.out.println("[exception] " + ex.toString());
                }

                if (jspSetoranKasir.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (setoranKasir.getOID() == 0) {
                    try {
                        setoranKasir.setDate(new Date());

                        //Untuk pemrosesan nomor jurnal Setoran Kasir
                        Date dt = new Date();

                        Periode opnPeriode = new Periode();

                        try {
                            //opnPeriode = DbPeriode.getOpenPeriod();
                            opnPeriode = DbPeriode.fetchExc(setoranKasir.getPeriodeId());
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

                        String formatDocCode = "";
                        int counter = 0;
                        formatDocCode = DbSystemDocNumber.getNumberPrefix(opnPeriode.getOID(),DbSystemDocCode.TYPE_DOCUMENT_SETORAN_KASIR);
                        counter = DbSystemDocNumber.getNextCounter(opnPeriode.getOID(),DbSystemDocCode.TYPE_DOCUMENT_SETORAN_KASIR);  

                        /* konsep baru */
                        setoranKasir.setJournalCounter(counter);
                        setoranKasir.setJournalPrefix(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_SETORAN_KASIR]);                        
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        formatDocCode = DbSystemDocNumber.getNextNumber(setoranKasir.getJournalCounter(),opnPeriode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_SETORAN_KASIR);                        
                        systemDocNumber.setDocNumber(formatDocCode);
                        setoranKasir.setJournalNumber(formatDocCode);                       

                        long oid = DbSetoranKasir.insertExc(this.setoranKasir);

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
                        long oid = DbSetoranKasir.updateExc(this.setoranKasir);
                        msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SUBMIT:

                jspSetoranKasir.requestEntityObject(setoranKasir);
                
                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                String wherex = "";
                
                if(preClosedPeriod.getOID() != 0){                    
                    wherex = "'" + JSPFormater.formatDate(setoranKasir.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + setoranKasir.getPeriodeId();
                }else{
                    wherex = "'" + JSPFormater.formatDate(setoranKasir.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
                
                Vector vx = DbPeriode.list(0, 0, wherex, "");
                if (vx == null || vx.size() == 0) {
                    jspSetoranKasir.addError(jspSetoranKasir.JSP_TRANSACTION_DATE, "<br>transaction date out of open period range");
                }

                Coa objCoa = new Coa();

                try {
                    objCoa = DbCoa.fetchExc(setoranKasir.getCoaId());

                    if (!objCoa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        jspSetoranKasir.addError(jspSetoranKasir.JSP_COA_ID, "postable account required");
                    }
                } catch (Exception ex) {
                    System.out.println("[exception] " + ex.toString());
                }

                if (jspSetoranKasir.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.EDIT:
                if (oidSetoranKasir != 0) {
                    try {
                        setoranKasir = DbSetoranKasir.fetchExc(oidSetoranKasir);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspSetoranKasir.requestEntityObject(setoranKasir);

                if (jspSetoranKasir.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;
            case JSPCommand.SEARCH:
                if (oidSetoranKasir != 0) {
                    try {
                        setoranKasir = DbSetoranKasir.fetchExc(oidSetoranKasir);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspSetoranKasir.requestEntityObject(setoranKasir);

                if (jspSetoranKasir.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;    

            case JSPCommand.ASK:

                jspSetoranKasir.requestEntityObject(setoranKasir);

                if (jspSetoranKasir.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.DELETE:

                jspSetoranKasir.requestEntityObject(setoranKasir);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                String wherev = "";
                
                if(preClosedPeriod.getOID() != 0){                    
                    wherev = "'" + JSPFormater.formatDate(setoranKasir.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "')  and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + setoranKasir.getPeriodeId();
                }else{
                    wherev = "'" + JSPFormater.formatDate(setoranKasir.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }
                
                Vector vv = DbPeriode.list(0, 0, wherev, "");
                
                if (vv == null || vv.size() == 0) {
                    jspSetoranKasir.addError(jspSetoranKasir.JSP_TRANSACTION_DATE, "<br>transaction date out of open period range");
                }

                if (jspSetoranKasir.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            default:

        }
        return rsCode;
    }

}
