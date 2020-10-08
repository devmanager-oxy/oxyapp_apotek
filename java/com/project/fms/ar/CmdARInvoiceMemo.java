/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.ar;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.system.DbSystemProperty;
import com.project.util.lang.I_Language;

/**
 *
 * @author Roy Andika
 */
public class CmdARInvoiceMemo extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private ARInvoice aRInvoice;
    private DbARInvoice pstARInvoice;
    private JspARInvoiceMemo jspARInvoiceMemo;
    int language = LANGUAGE_DEFAULT;

    public CmdARInvoiceMemo(HttpServletRequest request) {
        msgString = "";
        aRInvoice = new ARInvoice();
        try {
            pstARInvoice = new DbARInvoice(0);
        } catch (Exception e) {
            ;
        }
        jspARInvoiceMemo = new JspARInvoiceMemo(request, aRInvoice);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspARInvoiceMemo.addError(jspARInvoiceMemo.JSP_FIELD_ar_invoice_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public ARInvoice getARInvoice() {
        return aRInvoice;
    }

    public JspARInvoiceMemo getForm() {
        return jspARInvoiceMemo;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidARInvoice, long companyOID) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidARInvoice != 0) {
                    try {
                        aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
                    } catch (Exception exc) {
                    }
                }

                jspARInvoiceMemo.requestEntityObject(aRInvoice);
                
                String where = "";
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(aRInvoice.getDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+aRInvoice.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(aRInvoice.getDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                Vector v = DbPeriode.list(0, 0, where, "");
                if (v == null || v.size() == 0) {
                    jspARInvoiceMemo.addError(jspARInvoiceMemo.JSP_DATE, "transaction date out of open period range");
                }
                
                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(aRInvoice.getCoaARId());
                } catch (Exception e) {}

                if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                    jspARInvoiceMemo.addError(jspARInvoiceMemo.JSP_COA_AR_ID, "postable account type required");
                }
                
                aRInvoice.setCompanyId(companyOID);

                if (jspARInvoiceMemo.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (aRInvoice.getOID() == 0) {
                    try {                        
                        aRInvoice.setTransDate(aRInvoice.getDate());
                        Date dt = new Date();
                        Periode opnPeriode = new Periode();
                        try {
                            opnPeriode = DbPeriode.fetchExc(aRInvoice.getPeriodeId());
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

                        String formatDocCode = "";
                        int counter = 0;

                        formatDocCode = DbSystemDocNumber.getNumberPrefixArMemo(opnPeriode.getOID());
                        counter = DbSystemDocNumber.getNextCounterArMemo(opnPeriode.getOID());
                        
                        aRInvoice.setJournalCounter(counter);
                        aRInvoice.setJournalPrefix(formatDocCode);
                        
                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AR_MEMO]);

                        systemDocNumber.setYear(dt.getYear() + 1900);
                        formatDocCode = DbSystemDocNumber.getNextNumberArMemo(aRInvoice.getJournalCounter(), opnPeriode.getOID());

                        systemDocNumber.setDocNumber(formatDocCode);
                        aRInvoice.setJournalNumber(formatDocCode);   
                        
                        if (aRInvoice.getDocStatus() == DbARInvoice.TYPE_STATUS_DRAFT) {
                            aRInvoice.setCreateId(aRInvoice.getCreateId());
                            aRInvoice.setCreateDate(new Date());                            
                            aRInvoice.setApproval1Id(0);
                            aRInvoice.setApproval1Date(null);
                        }                        
                        
                        if (aRInvoice.getDocStatus() == DbARInvoice.TYPE_STATUS_APPROVED){                         
                            aRInvoice.setCreateId(aRInvoice.getCreateId());
                            aRInvoice.setCreateDate(new Date());                       
                            aRInvoice.setApproval1Id(aRInvoice.getCreateId());
                            aRInvoice.setApproval1Date(new Date());
                        }

                        long oid = pstARInvoice.insertExc(this.aRInvoice);
                        
                        if (oid != 0) {
                            try {
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception E) {
                                System.out.println("[exception] " + E.toString());
                            }
                        }

                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);

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
                        
                        if (aRInvoice.getDocStatus() == DbARInvoice.TYPE_STATUS_DRAFT) {
                            aRInvoice.setCreateId(aRInvoice.getCreateId());
                            aRInvoice.setCreateDate(new Date());                            
                            aRInvoice.setApproval1Id(0);
                            aRInvoice.setApproval1Date(null);
                        }

                        if (aRInvoice.getDocStatus() == DbARInvoice.TYPE_STATUS_APPROVED){
                            if (aRInvoice.getCreateId() == 0) {
                                aRInvoice.setCreateId(aRInvoice.getCreateId());
                                aRInvoice.setCreateDate(new Date());                            
                            }
                            aRInvoice.setApproval1Id(aRInvoice.getCreateId());
                            aRInvoice.setApproval1Date(new Date());
                        }
                        long oid = pstARInvoice.updateExc(this.aRInvoice);

                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;
                
            case JSPCommand.SUBMIT:

                if (oidARInvoice != 0) {
                    try {
                        aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
                    } catch (Exception exc) {
                    }
                }
                jspARInvoiceMemo.requestEntityObject(aRInvoice);

                if (jspARInvoiceMemo.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                break;                   

            case JSPCommand.EDIT:
                if (oidARInvoice != 0) {
                    try {                        
                        aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
                        if(aRInvoice.getTotal() != 0){
                            double amount = aRInvoice.getTotal() * -1;
                            aRInvoice.setTotal(amount);
                        } 
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASSIGN:
                if (oidARInvoice != 0) {
                    try {                        
                        aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
                        if(aRInvoice.getTotal() != 0){
                            double amount = aRInvoice.getTotal() * -1;
                            aRInvoice.setTotal(amount);
                        } 
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;     
                
            case JSPCommand.ASK:
                if (oidARInvoice != 0) {
                    try {
                        aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
                        if(aRInvoice.getTotal() != 0){
                            double amount = aRInvoice.getTotal() * -1;
                            aRInvoice.setTotal(amount);
                        } 
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
            
           case JSPCommand.ACTIVATE:
                if (oidARInvoice != 0) {
                    try {
                        aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
                        if(aRInvoice.getTotal() != 0){
                            double amount = aRInvoice.getTotal() * -1;
                            aRInvoice.setTotal(amount);
                        } 
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                

            case JSPCommand.DELETE:
                if (oidARInvoice != 0) {
                    try {
                        aRInvoice = DbARInvoice.fetchExc(oidARInvoice);
                        if(aRInvoice.getTotal() != 0){
                            double amount = aRInvoice.getTotal() * -1;
                            aRInvoice.setTotal(amount);
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
