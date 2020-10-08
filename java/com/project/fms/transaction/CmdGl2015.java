/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

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
import com.project.util.*;
import com.project.*;
import com.project.fms.master.*;
/**
 *
 * @author Roy
 */

public class CmdGl2015 extends Control implements I_Language {
    
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    
    private int start;
    private String msgString;
    private Gl2015 gl2015;
    private DbGl2015 dbGl2015;
    private JspGl2015 jspGl2015;
    int language = LANGUAGE_DEFAULT;

    public CmdGl2015(HttpServletRequest request) {
        msgString = "";
        gl2015 = new Gl2015();
        try {
            dbGl2015 = new DbGl2015(0);
        } catch (Exception e) {
        }
        jspGl2015 = new JspGl2015(request, gl2015);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspGl2015.addError(jspGl2015.JSP_GL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public Gl2015 getGl2015() {
        return gl2015;
    }

    public JspGl2015 getForm() {
        return jspGl2015;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidGl) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                jspGl2015.requestEntityObject(gl2015);
                if (oidGl != 0) {
                    try {
                        Gl2015 tmpGl = DbGl2015.fetchExc(oidGl);
                        gl2015.setOID(tmpGl.getOID());
                        gl2015.setJournalCounter(tmpGl.getJournalCounter());
                        gl2015.setJournalNumber(tmpGl.getJournalNumber());
                        gl2015.setJournalPrefix(tmpGl.getJournalPrefix());

                    } catch (Exception e){}
                }
                
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                String where = "";
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl2015.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }

                Vector v = DbPeriode.list(0, 0, where, "");
                
                if (v == null || v.size() == 0) {
                    jspGl2015.addError(jspGl2015.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl2015.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.BACK:

                if (oidGl != 0) {
                    try {
                        gl2015 = DbGl2015.fetchExc(oidGl);
                    } catch (Exception exc) { }
                }
                
                jspGl2015.requestEntityObject(gl2015);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl2015.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl2015.addError(jspGl2015.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl2015.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.SAVE:

                if (oidGl != 0) {
                    try {
                        gl2015 = DbGl2015.fetchExc(oidGl);
                    } catch (Exception exc) { }
                }

                jspGl2015.requestEntityObject(gl2015);
                
                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl2015.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl2015.addError(jspGl2015.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl2015.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (gl2015.getOID() == 0) {
                    
                    try {
                        
                        Periode p = DbPeriode.getOpenPeriod();
                        
                        try{                            
                            if(gl2015.getPeriodId() != 0){
                                p = DbPeriode.fetchExc(gl2015.getPeriodId());
                            }else{
                                p = DbPeriode.getOpenPeriod();
                            }
                        }catch(Exception e){}
                        
                        Date dt = new Date();
                        int periodeTaken = 0;
                        
                        try{
                            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                        }catch(Exception e){}
                        
                        if(periodeTaken == 0){
                            dt = p.getStartDate();  // untuk mendapatkan periode yang aktif
                        }else if(periodeTaken == 1){
                            dt = p.getEndDate();  // untuk mendapatkan periode yang aktif
                        }
                        
                        Date dtx = (Date) dt.clone();
                        dtx.setDate(1);

                        String formatDocCode = DbSystemDocNumber.getNumberPrefixGl(p.getOID());                        
                        int counter = DbSystemDocNumber.getNextCounterGl(p.getOID());
                        
                        //insert ke table stock code

                        gl2015.setDate(new Date());
                        gl2015.setJournalCounter(counter);
                        gl2015.setJournalPrefix(formatDocCode);
                        
                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        
                        formatDocCode = DbSystemDocNumber.getNextNumberGl(gl2015.getJournalCounter(),p.getOID());
                        systemDocNumber.setDocNumber(formatDocCode);                        
                        
                        gl2015.setJournalNumber(formatDocCode);
                        gl2015.setPeriodId(p.getOID());
                        gl2015.setActivityStatus(I_Project.STATUS_NOT_POSTED);

                        if (!(DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y")) {
                            gl2015.setActivityStatus(I_Project.STATUS_POSTED);
                        }

                        long oid = dbGl2015.insertExc(this.gl2015);
                        
                        if (oid != 0) {
                            try {
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception E) { System.out.println("[exception] " + E.toString()); }
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
                        if (!(DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y")) {
                            gl2015.setActivityStatus(I_Project.STATUS_POSTED);
                        }

                        long oid = dbGl2015.updateExc(this.gl2015);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.SUBMIT:

                jspGl2015.requestEntityObject(gl2015);

                if (oidGl != 0) {
                    try {
                        Gl2015 tmpGl = DbGl2015.fetchExc(oidGl);
                        gl2015.setOID(tmpGl.getOID());
                        gl2015.setJournalCounter(tmpGl.getJournalCounter());
                        gl2015.setJournalNumber(tmpGl.getJournalNumber());
                        gl2015.setJournalPrefix(tmpGl.getJournalPrefix());
                    } catch (Exception e) {}
                }

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl2015.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");

                if (v == null || v.size() == 0) {
                    jspGl2015.addError(jspGl2015.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl2015.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.POST:

                jspGl2015.requestEntityObject(gl2015);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl2015.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl2015.addError(jspGl2015.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl2015.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;


            case JSPCommand.EDIT:
                if (oidGl != 0) {
                    try {
                        gl2015 = DbGl2015.fetchExc(oidGl);
                    } catch (CONException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){ 
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspGl2015.requestEntityObject(gl2015);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl2015.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl2015.addError(jspGl2015.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl2015.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.ASK:
                if (oidGl != 0) {
                    try {
                        gl2015 = DbGl2015.fetchExc(oidGl);
                    } catch (CONException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){ 
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspGl2015.requestEntityObject(gl2015);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl2015.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                
                
                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl2015.addError(jspGl2015.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl2015.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.DELETE:
                
                if (oidGl != 0) {
                    try {
                        gl2015 = DbGl2015.fetchExc(oidGl);
                    } catch (CONException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){ 
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspGl2015.requestEntityObject(gl2015);
                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl2015.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl2015.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl2015.addError(jspGl2015.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl2015.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.RESET:

                if (oidGl != 0) {

                    try {
                        long oid = DbGl2015.deleteExc(oidGl);

                        if (oid != 0) {
                            DbGlDetail.deleteAllDetail(oid);
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
