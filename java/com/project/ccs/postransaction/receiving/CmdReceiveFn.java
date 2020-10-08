/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.receiving;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*; 
import com.project.main.db.*;
import com.project.*;
import com.project.ccs.postransaction.stock.*;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;

/**
 *
 * @author Roy
 */
public class CmdReceiveFn extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private Receive receive;
    private DbReceive dbReceive;
    private JspReceiveFn jspReceive;
    int language = LANGUAGE_DEFAULT;
    private String status = "";
    private long periodeId = 0;
    private long userId = 0;

    public CmdReceiveFn(HttpServletRequest request) {
        msgString = "";
        receive = new Receive();
        try {
            dbReceive = new DbReceive(0);
        } catch (Exception e) {
            
        }
        jspReceive = new JspReceiveFn(request, receive);
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

    public Receive getReceive() {
        return receive;
    }

    public JspReceiveFn getForm() {
        return jspReceive;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    synchronized  public int action(int cmd, long oidReceive) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {          
            case JSPCommand.ADD:
                jspReceive.requestEntityObject(receive);
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (Exception exc) {
                    }
                }
                break;
            
            case JSPCommand.EDIT:
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.ACTIVATE:
                
                if (oidReceive != 0) {
                    try {
                        receive = DbReceive.fetchExc(oidReceive);                                                
                    } catch (Exception exc) {}
                }

                jspReceive.requestEntityObject(receive);
                
                if(status.equals(I_Project.DOC_STATUS_CHECKED)){   
                    receive.setStatus(status);
                    receive.setApproval2(userId);
                    receive.setApproval2Date(new Date());                                        
                }
                
                Periode p = new Periode();
                if(periodeId == 0){                 
                    p = DbPeriode.getPeriodByTransDate(receive.getApproval1Date());                                        
                }else{
                    try{
                        p = DbPeriode.fetchExc(periodeId);
                    }catch(Exception e){}
                }
                
                if(p.getOID() == 0 || p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0){
                    jspReceive.addError(jspReceive.JSP_PERIOD_ID, "Please chose open period");                    
                }
                
                if (jspReceive.errorSize() > 0) {
                    msgString = "Please check the data";
                    return RSLT_FORM_INCOMPLETE;
                }
                
                receive.setPeriodId(p.getOID());

                if (receive.getOID() == 0) {
                    try {
                        long oid = dbReceive.insertExc(this.receive);
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
                        long oid = dbReceive.updateExc(this.receive);                        
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getPeriodeId() {
        return periodeId;
    }

    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
}
