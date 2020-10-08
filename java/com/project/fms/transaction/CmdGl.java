/* 
 * Ctrl Name  		:  CtrlGl.java 
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
import com.project.util.*;
import com.project.*;
import com.project.fms.master.*;

public class CmdGl extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Gl gl;
    private DbGl dbGl;
    private JspGl jspGl;
    int language = LANGUAGE_DEFAULT;

    public CmdGl(HttpServletRequest request) {
        msgString = "";
        gl = new Gl();
        try {
            dbGl = new DbGl(0);
        } catch (Exception e) {
            ;
        }
        jspGl = new JspGl(request, gl);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                this.jspGl.addError(jspGl.JSP_GL_ID, resultText[language][RSLT_EST_CODE_EXIST]);
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

    public Gl getGl() {
        return gl;
    }

    public JspGl getForm() {
        return jspGl;
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

                jspGl.requestEntityObject(gl);

                if (oidGl != 0) {
                    try {
                        Gl tmpGl = DbGl.fetchExc(oidGl);
                        gl.setOID(tmpGl.getOID());
                        gl.setJournalCounter(tmpGl.getJournalCounter());
                        gl.setJournalNumber(tmpGl.getJournalNumber());
                        gl.setJournalPrefix(tmpGl.getJournalPrefix());

                    } catch (Exception e){}
                }
                
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                String where = "";
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }

                Vector v = DbPeriode.list(0, 0, where, "");
                
                if (v == null || v.size() == 0) {
                    jspGl.addError(jspGl.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.BACK:

                if (oidGl != 0) {
                    try {
                        gl = DbGl.fetchExc(oidGl);
                    } catch (Exception exc) { }
                }
                
                jspGl.requestEntityObject(gl);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl.addError(jspGl.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.SAVE:

                if (oidGl != 0) {
                    try {
                        gl = DbGl.fetchExc(oidGl);
                    } catch (Exception exc) { }
                }

                jspGl.requestEntityObject(gl);
                
                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl.addError(jspGl.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (gl.getOID() == 0) {
                    
                    try {
                        
                        Periode p = DbPeriode.getOpenPeriod();
                        
                        try{                            
                            if(gl.getPeriodId() != 0){
                                p = DbPeriode.fetchExc(gl.getPeriodId());
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

                        gl.setDate(new Date());
                        gl.setJournalCounter(counter);
                        gl.setJournalPrefix(formatDocCode);
                        
                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        
                        formatDocCode = DbSystemDocNumber.getNextNumberGl(gl.getJournalCounter(),p.getOID());
                        systemDocNumber.setDocNumber(formatDocCode);                        
                        
                        gl.setJournalNumber(formatDocCode);
                        
                        /*gl.setDate(new Date());
                        gl.setJournalCounter(DbGl.getNextCounter());
                        gl.setJournalPrefix(DbGl.getNumberPrefix());
                        gl.setJournalNumber(DbGl.getNextNumber(gl.getJournalCounter()));
                        */
                        gl.setPeriodId(p.getOID());
                        gl.setActivityStatus(I_Project.STATUS_NOT_POSTED);

                        if (!(DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y")) {
                            gl.setActivityStatus(I_Project.STATUS_POSTED);
                        }

                        long oid = dbGl.insertExc(this.gl);
                        
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
                            gl.setActivityStatus(I_Project.STATUS_POSTED);
                        }

                        long oid = dbGl.updateExc(this.gl);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.START:
                if (oidGl != 0) {
                    try {
                        gl = DbGl.fetchExc(oidGl);
                    } catch (Exception exc){}
                }

                jspGl.requestEntityObject(gl);
                
                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl.addError(jspGl.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (gl.getOID() == 0) {
                    try {
                        
                        Periode p = DbPeriode.getOpenPeriod();
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

                        String formatDocCode = DbSystemDocNumber.getNumberPrefixGl();
                        
                        int counter = DbSystemDocNumber.getNextCounterGl();
                        
                        //insert ke table stock code

                        gl.setDate(new Date());
                        gl.setJournalCounter(counter);
                        gl.setJournalPrefix(formatDocCode);
                        
                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        
                        formatDocCode = DbSystemDocNumber.getNextNumberGl(gl.getJournalCounter());
                        systemDocNumber.setDocNumber(formatDocCode);                        
                        
                        gl.setJournalNumber(formatDocCode);
                        
                        /*
                        gl.setDate(new Date());
                        gl.setJournalCounter(DbGl.getNextCounter());
                        gl.setJournalPrefix(DbGl.getNumberPrefix());
                        gl.setJournalNumber(DbGl.getNextNumber(gl.getJournalCounter()));
                        */
                        
                        gl.setPeriodId(p.getOID());
                        gl.setActivityStatus(I_Project.STATUS_NOT_POSTED);

                        if (!(DbSystemProperty.getValueByName("APPLY_ACTIVITY")).equals("Y")) {
                            gl.setActivityStatus(I_Project.STATUS_POSTED);
                        }

                        long oid = dbGl.insertExc(this.gl);
                        
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
                            gl.setActivityStatus(I_Project.STATUS_POSTED);
                        }

                        long oid = dbGl.updateExc(this.gl);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            /*case JSPCommand.EDIT :
            if (oidGl != 0) {
            try {
            gl = DbGl.fetchExc(oidGl);
            } catch (CONException dbexc){
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
            } catch (Exception exc){ 
            msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
            }
            }
            break;
            case JSPCommand.ASK :
            if (oidGl != 0) {
            try {
            gl = DbGl.fetchExc(oidGl);
            } catch (CONException dbexc){
            excCode = dbexc.getErrorCode();
            msgString = getSystemMessage(excCode);
            } catch (Exception exc){ 
            msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
            }
            }
            break;
            case JSPCommand.DELETE :
            if (oidGl != 0){
            try{
            long oid = DbGl.deleteExc(oidGl);
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

                jspGl.requestEntityObject(gl);

                if (oidGl != 0) {
                    try {
                        Gl tmpGl = DbGl.fetchExc(oidGl);
                        gl.setOID(tmpGl.getOID());
                        gl.setJournalCounter(tmpGl.getJournalCounter());
                        gl.setJournalNumber(tmpGl.getJournalNumber());
                        gl.setJournalPrefix(tmpGl.getJournalPrefix());
                    } catch (Exception e) {}
                }

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");

                if (v == null || v.size() == 0) {
                    jspGl.addError(jspGl.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.POST:

                jspGl.requestEntityObject(gl);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl.addError(jspGl.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;


            case JSPCommand.EDIT:
                if (oidGl != 0) {
                    try {
                        gl = DbGl.fetchExc(oidGl);
                    } catch (CONException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){ 
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspGl.requestEntityObject(gl);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl.addError(jspGl.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.ASK:
                if (oidGl != 0) {
                    try {
                        gl = DbGl.fetchExc(oidGl);
                    } catch (CONException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){ 
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspGl.requestEntityObject(gl);

                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                
                
                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl.addError(jspGl.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.DELETE:

                /*if (oidGl != 0){
                    try{
                        long oid = DbGl.deleteExc(oidGl);
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
                }*/
                
                if (oidGl != 0) {
                    try {
                        gl = DbGl.fetchExc(oidGl);
                    } catch (CONException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc){ 
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }

                jspGl.requestEntityObject(gl);
                preClosedPeriod = DbPeriode.getPreClosedPeriod();                    
                
                if(preClosedPeriod.getOID() != 0){                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' ) and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR+
                        " and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+gl.getPeriodId();                    
                }else{                    
                    where = "'" + JSPFormater.formatDate(gl.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "' and " + DbPeriode.colNames[DbPeriode.COL_TYPE] + "=" + DbPeriode.TYPE_PERIOD_REGULAR;                    
                }                

                v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspGl.addError(jspGl.JSP_TRANS_DATE, "<br>transaction date out of open period range");
                }

                if (jspGl.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;

            case JSPCommand.RESET:

                if (oidGl != 0) {

                    try {
                        long oid = DbGl.deleteExc(oidGl);

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
