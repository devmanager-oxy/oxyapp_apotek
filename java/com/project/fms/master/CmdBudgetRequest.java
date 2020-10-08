/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.master;

import com.project.I_Project;
import com.project.admin.DbUser;
import com.project.admin.User;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.payroll.DbDepartment;
import com.project.payroll.Department;
import com.project.system.DbSystemProperty;
import com.project.util.lang.*;

/**
 *
 * @author Roy
 */
public class CmdBudgetRequest extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Can not save duplicate entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private BudgetRequest budgetRequest;
    private DbBudgetRequest pstBudgetRequest;
    private JspBudgetRequest jspBudgetRequest;
    private long userId = 0;
    private long uniqKeyId=0;
    int language = LANGUAGE_DEFAULT;

    public CmdBudgetRequest(HttpServletRequest request) {
        msgString = "";
        budgetRequest = new BudgetRequest();
        try {
            pstBudgetRequest = new DbBudgetRequest(0);
        } catch (Exception e) {            
        }
        jspBudgetRequest = new JspBudgetRequest(request, budgetRequest);
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

    public BudgetRequest getBudgetRequest() {
        return budgetRequest;
    }

    public JspBudgetRequest getForm() {
        return jspBudgetRequest;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidBudgetRequest) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                BudgetRequest budgetRequestOld = new BudgetRequest();
                if (oidBudgetRequest != 0) {
                    try {
                        budgetRequest = DbBudgetRequest.fetchExc(oidBudgetRequest);
                        budgetRequestOld = DbBudgetRequest.fetchExc(oidBudgetRequest);;
                    } catch (Exception exc) {
                    }
                }

                jspBudgetRequest.requestEntityObject(budgetRequest);
                budgetRequest.setUniqKeyId(uniqKeyId);
                Periode preClosedPeriod = DbPeriode.getPreClosedPeriod();    
                String where = "";
                
                if(preClosedPeriod.getOID() != 0){
                    where = "'" + JSPFormater.formatDate(budgetRequest.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and ( status='" + I_Project.STATUS_PERIOD_OPEN + "' OR status='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"') and "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" = "+budgetRequest.getPeriodeId();
                }else{
                    where = "'" + JSPFormater.formatDate(budgetRequest.getTransDate(), "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and status='" + I_Project.STATUS_PERIOD_OPEN + "'";
                }

                Vector v = DbPeriode.list(0, 0, where, "");
                
                if (v == null || v.size() == 0) {
                    jspBudgetRequest.addError(jspBudgetRequest.JSP_TRANS_DATE, "transaction date out of open period range");
                }                

                if (jspBudgetRequest.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (budgetRequest.getOID() == 0) {
                    try {
                        budgetRequest.setDate(new Date());       
                        budgetRequest.setUserId(userId);                        
                        Date dt = new Date();
                        Periode opnPeriode = new Periode();                        
                        try{                            
                            opnPeriode = DbPeriode.fetchExc(budgetRequest.getPeriodeId());                            
                        }catch(Exception e){}
                        
                        int periodeTaken = 0;
                        
                        try{
                            periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                        }catch(Exception e){}
                        
                        if(periodeTaken == 0){
                            dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
                        }else if(periodeTaken == 1){
                            dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
                        }
                        
                        String formatDocCode = DbSystemDocNumber.getNumberPrefix(opnPeriode.getOID(),DbSystemDocCode.TYPE_DOCUMENT_BUDGET);                        
                        int counter = DbSystemDocNumber.getNextCounterSynch(opnPeriode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_BUDGET);

                        budgetRequest.setJournalCounter(counter);
                        budgetRequest.setJournalPrefix(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(new Date());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_BUDGET]);
                        systemDocNumber.setYear(dt.getYear() + 1900);
                        formatDocCode = DbSystemDocNumber.getNextNumber(budgetRequest.getJournalCounter(), opnPeriode.getOID(), DbSystemDocCode.TYPE_DOCUMENT_BUDGET);                        
                        systemDocNumber.setDocNumber(formatDocCode);
                        budgetRequest.setJournalNumber(formatDocCode);
                        
                        long oid = pstBudgetRequest.insertExc(this.budgetRequest);
                        
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
                        if(budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_APPROVED){
                            budgetRequest.setApproval1Date(new Date());
                            budgetRequest.setApproval1Id(userId);
                        }
                        
                        if(budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_CHECKED){
                            budgetRequest.setApproval2Date(new Date());
                            budgetRequest.setApproval2Id(userId);
                        }
                        
                        long oid = pstBudgetRequest.updateExc(this.budgetRequest);
                        if(oid != 0){
                            String keterangan = "";
                            if(JSPFormater.formatDate(budgetRequestOld.getTransDate(),"dd/MM/yyyy").compareTo(JSPFormater.formatDate(this.budgetRequest.getTransDate(),"dd/MM/yyyy")) != 0){
                                if(keterangan != null && keterangan.length() > 0){
                                    keterangan = keterangan + ", ";
                                }
                                keterangan = keterangan + " Tanggal transaksi dari "+JSPFormater.formatDate(budgetRequestOld.getTransDate(),"dd/MM/yyyy")+" menjadi "+JSPFormater.formatDate(this.budgetRequest.getTransDate(),"dd/MM/yyyy");
                            }  
                            
                            if(budgetRequestOld.getDepartmentId() != this.budgetRequest.getDepartmentId()){
                                if(keterangan != null && keterangan.length() > 0){
                                    keterangan = keterangan + ", ";
                                }
                                
                                Department depOld = new Department();
                                Department dep = new Department();
                                
                                try{
                                    depOld = DbDepartment.fetchExc(budgetRequestOld.getDepartmentId());
                                }catch(Exception e){}
                                
                                try{
                                    dep = DbDepartment.fetchExc(budgetRequest.getDepartmentId());
                                }catch(Exception e){}
                                
                                keterangan = keterangan + " Department dari "+depOld.getName()+" menjadi "+dep.getName();
                            }
                            
                            if(budgetRequestOld.getStatus() != this.budgetRequest.getStatus()){
                                if(keterangan != null && keterangan.length() > 0){
                                    keterangan = keterangan + ", ";
                                }
                                keterangan = keterangan + " status dokumen dari "+DbBudgetRequest.strStatusDocument[budgetRequestOld.getStatus()]+" menjadi "+DbBudgetRequest.strStatusDocument[this.budgetRequest.getStatus()];
                            }
                            
                            if(keterangan != null && keterangan.length() > 0){                                
                                HistoryBudget historyBudget = new HistoryBudget();
                                historyBudget.setType(DbHistoryBudget.TYPE_BUDGET_REQUEST_MAIN);
                                historyBudget.setDate(new Date());
                                historyBudget.setRefId(oid);                                
                                historyBudget.setUserId(userId); 
                                User u = new User();
                                try{
                                    u = DbUser.fetch(userId);
                                }catch(Exception e){}
                                historyBudget.setFullName(u.getFullName());
                                historyBudget.setEmployeeId(u.getEmployeeId());
                                historyBudget.setPeriodId(budgetRequest.getPeriodeId());
                                historyBudget.setMonth(budgetRequest.getTransDate().getMonth());
                                historyBudget.setYear((budgetRequest.getTransDate().getYear()+1900));
                                historyBudget.setSegment1Id(budgetRequest.getSegment1Id());                                
                                historyBudget.setDescription("Perubahan data : "+keterangan);
                                try{
                                    DbHistoryBudget.insertExc(historyBudget);
                                }catch(Exception e){} 
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

                }
                break;

            case JSPCommand.REFRESH:    
                if (oidBudgetRequest != 0) {
                    try {
                        budgetRequest = DbBudgetRequest.fetchExc(oidBudgetRequest);
                    } catch (Exception exc) {
                    }
                }

                jspBudgetRequest.requestEntityObject(budgetRequest);
                
                break;
                
           case JSPCommand.LOAD:    
                if (oidBudgetRequest != 0) {
                    try {
                        budgetRequest = DbBudgetRequest.fetchExc(oidBudgetRequest);
                    } catch (Exception exc) {
                    }
                }

                jspBudgetRequest.requestEntityObject(budgetRequest);
                
                break;     
                
            case JSPCommand.EDIT:
                if (oidBudgetRequest != 0) {
                    try {
                        budgetRequest = DbBudgetRequest.fetchExc(oidBudgetRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.BACK:
                if (oidBudgetRequest != 0) {
                    try {
                        budgetRequest = DbBudgetRequest.fetchExc(oidBudgetRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;    

            case JSPCommand.ASK:
                if (oidBudgetRequest != 0) {
                    try {
                        budgetRequest = DbBudgetRequest.fetchExc(oidBudgetRequest);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidBudgetRequest != 0) {
                    try {
                        budgetRequest = DbBudgetRequest.fetchExc(oidBudgetRequest);
                    } catch (Exception exc) {
                    }
                }

                jspBudgetRequest.requestEntityObject(budgetRequest);
                break;

            default:

        }
        return rsCode;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getUniqKeyId() {
        return uniqKeyId;
    }

    public void setUniqKeyId(long uniqKeyId) {
        this.uniqKeyId = uniqKeyId;
    }
}
