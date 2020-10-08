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
import com.project.util.lang.*;

/**
 *
 * @author Roy
 */
public class CmdBudgetRequestDetail extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "No Perkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Can not save duplicate entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private BudgetRequestDetail budgetRequestDetail;
    private DbBudgetRequestDetail pstBudgetRequestDetail;
    private JspBudgetRequestDetail jspBudgetRequestDetail;
    private long budgetRequestId = 0;    
    private long userId = 0;    
    int language = LANGUAGE_DEFAULT;

    public CmdBudgetRequestDetail(HttpServletRequest request) {
        msgString = "";
        budgetRequestDetail = new BudgetRequestDetail();
        try {
            pstBudgetRequestDetail = new DbBudgetRequestDetail(0);
        } catch (Exception e) {}
        jspBudgetRequestDetail = new JspBudgetRequestDetail(request, budgetRequestDetail);
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

    public BudgetRequestDetail getBudgetRequestDetail() {
        return budgetRequestDetail;
    }

    public JspBudgetRequestDetail getForm() {
        return jspBudgetRequestDetail;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidBudgetRequestDetail) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                BudgetRequestDetail brdOld = new BudgetRequestDetail();
                if (oidBudgetRequestDetail != 0) {
                    try {
                        budgetRequestDetail = DbBudgetRequestDetail.fetchExc(oidBudgetRequestDetail);
                        brdOld = DbBudgetRequestDetail.fetchExc(oidBudgetRequestDetail);
                    } catch (Exception exc) {
                    }
                }

                jspBudgetRequestDetail.requestEntityObject(budgetRequestDetail);
                
                if(budgetRequestId==0){
                    jspBudgetRequestDetail.addError(jspBudgetRequestDetail.JSP_BUDGET_REQUEST_ID, "Pengisian data form belum lengkap");                    
                }                
                if(budgetRequestDetail.getMemo() == null || budgetRequestDetail.getMemo().length() <= 0){
                    jspBudgetRequestDetail.addError(jspBudgetRequestDetail.JSP_MEMO, "Data harus diisi");                    
                }
                
                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(budgetRequestDetail.getCoaId());
                    if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        jspBudgetRequestDetail.addError(jspBudgetRequestDetail.JSP_COA_ID, "Postable account required");
                    }
                } catch (Exception ex) {
                    System.out.println("[exception] " + ex.toString());
                }
                String where = DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID]+" = "+budgetRequestId+
                        " and "+DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_COA_ID]+" = "+budgetRequestDetail.getCoaId()+
                        " and "+DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_MEMO]+"='"+budgetRequestDetail.getMemo()+"' "+
                        " and "+DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_REQUEST]+"='"+budgetRequestDetail.getRequest()+"' ";
                int tot = DbBudgetRequestDetail.getCount(where);
                if(tot > 0){
                    jspBudgetRequestDetail.addError(jspBudgetRequestDetail.JSP_COA_ID, "Akun already exist");                    
                }
                
                boolean openRequest = false;
                BudgetRequest bRequest = new BudgetRequest();
                try{                    
                    bRequest = DbBudgetRequest.fetchExc(budgetRequestId);
                    openRequest = DbBudgetRequestDetail.getOpenBudgetRequest(bRequest.getTransDate(),budgetRequestDetail.getCoaId(),bRequest.getSegment1Id(),budgetRequestDetail.getRequest(),budgetRequestDetail.getOID());
                }catch(Exception e){}
                
                if(budgetRequestDetail.getRequest() <= 0){
                    jspBudgetRequestDetail.addError(jspBudgetRequestDetail.JSP_REQUEST, "Nilai request harus diisi");  
                }else{                
                    if(openRequest == false && budgetRequestId != 0){
                        jspBudgetRequestDetail.addError(jspBudgetRequestDetail.JSP_REQUEST, "Request melebihi ketentuan budget");  
                    }
                }
                
                if (jspBudgetRequestDetail.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (budgetRequestDetail.getOID() == 0) {
                    try {       
                        budgetRequestDetail.setBudgetRequestId(budgetRequestId);
                        budgetRequestDetail.setDate(new Date());                        
                        long oid = pstBudgetRequestDetail.insertExc(this.budgetRequestDetail);
                        if(oid != 0){
                            HistoryBudget historyBudget = new HistoryBudget();
                            historyBudget.setType(DbHistoryBudget.TYPE_BUDGET_REQUEST);
                            historyBudget.setDate(new Date());                            
                            historyBudget.setUserId(userId); 
                            historyBudget.setRefId(bRequest.getOID());
                            User u = new User();
                            try{
                                u = DbUser.fetch(userId);
                            }catch(Exception e){}
                            historyBudget.setFullName(u.getFullName());
                            historyBudget.setEmployeeId(u.getEmployeeId());
                            historyBudget.setPeriodId(bRequest.getPeriodeId());
                            historyBudget.setMonth(bRequest.getTransDate().getMonth());
                            historyBudget.setYear((bRequest.getTransDate().getYear()+1900));
                            historyBudget.setSegment1Id(bRequest.getSegment1Id());
                            String keterangan = "Pembuatan request budget ( Akun "+coa.getCode()+"-"+coa.getName()+"), nilai "+JSPFormater.formatNumber(budgetRequestDetail.getRequest(),"###,###.##")+
                                    " dengan keterangan :"+budgetRequestDetail.getMemo();
                            historyBudget.setDescription(keterangan);
                            try{
                                DbHistoryBudget.insertExc(historyBudget);
                            }catch(Exception e){}                            
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
                        long oid = pstBudgetRequestDetail.updateExc(this.budgetRequestDetail);
                        
                        if(oid != 0){
                            String keterangan = "";
                            
                            if(brdOld.getCoaId() != budgetRequestDetail.getCoaId()){
                                if(keterangan != null && keterangan.length() > 0){
                                    keterangan = keterangan + ", ";
                                }
                                Coa cOld = new Coa();
                                try{
                                    cOld = DbCoa.fetchExc(brdOld.getCoaId());
                                }catch(Exception e){}
                                
                                Coa cNew = new Coa();
                                try{
                                    cNew = DbCoa.fetchExc(budgetRequestDetail.getCoaId());
                                }catch(Exception e){}
                                keterangan = keterangan +" Akun perkiraan dari ("+cOld.getCode()+"-"+cOld.getName()+") menjadi ("+cNew.getCode()+"-"+cNew.getName()+") ";                                
                            }
                            
                            if(brdOld.getMemo().compareTo(budgetRequestDetail.getMemo()) != 0){
                                if(keterangan != null && keterangan.length() > 0){
                                    keterangan = keterangan + ", ";
                                }
                                keterangan = keterangan +" Keterangan request dari ("+brdOld.getMemo()+") menjadi ("+budgetRequestDetail.getMemo()+") ";                                
                            }
                            
                            if(brdOld.getRequest() != budgetRequestDetail.getRequest()){
                                if(keterangan != null && keterangan.length() > 0){
                                    keterangan = keterangan + ", ";
                                }
                                keterangan = keterangan +" Nilai request dari ( "+JSPFormater.formatNumber(brdOld.getRequest(),"###,###.##")+" ) menjadi ("+JSPFormater.formatNumber(budgetRequestDetail.getRequest(),"###,###.##")+") ";                                
                            }
                            
                            if(keterangan != null && keterangan.length() > 0){                                
                                HistoryBudget historyBudget = new HistoryBudget();
                                historyBudget.setType(DbHistoryBudget.TYPE_BUDGET_REQUEST);
                                historyBudget.setDate(new Date());
                                historyBudget.setRefId(bRequest.getOID());
                                historyBudget.setUserId(userId); 
                                User u = new User();
                                try{
                                    u = DbUser.fetch(userId);
                                }catch(Exception e){}
                                historyBudget.setFullName(u.getFullName());
                                historyBudget.setEmployeeId(u.getEmployeeId());
                                historyBudget.setPeriodId(bRequest.getPeriodeId());
                                historyBudget.setMonth(bRequest.getTransDate().getMonth());
                                historyBudget.setYear((bRequest.getTransDate().getYear()+1900));
                                historyBudget.setSegment1Id(bRequest.getSegment1Id());                                
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
                
                if (oidBudgetRequestDetail != 0) {
                    try {
                        budgetRequestDetail = DbBudgetRequestDetail.fetchExc(oidBudgetRequestDetail);
                    } catch (Exception exc) {
                    }
                }

                jspBudgetRequestDetail.requestEntityObject(budgetRequestDetail);
                break;
                
            case JSPCommand.LOAD:    
                
                if (oidBudgetRequestDetail != 0) {
                    try {
                        budgetRequestDetail = DbBudgetRequestDetail.fetchExc(oidBudgetRequestDetail);
                    } catch (Exception exc) {
                    }
                }

                jspBudgetRequestDetail.requestEntityObject(budgetRequestDetail);
                break;
                
            case JSPCommand.EDIT:
                if (oidBudgetRequestDetail != 0) {
                    try {
                        budgetRequestDetail = DbBudgetRequestDetail.fetchExc(oidBudgetRequestDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidBudgetRequestDetail != 0) {
                    try {
                        budgetRequestDetail = DbBudgetRequestDetail.fetchExc(oidBudgetRequestDetail);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidBudgetRequestDetail != 0) {
                    try {
                        brdOld = DbBudgetRequestDetail.fetchExc(oidBudgetRequestDetail);                 
                        long oid = DbBudgetRequestDetail.deleteExc(oidBudgetRequestDetail);
                        if (oid != 0){ 
                            coa = new Coa();
                            try{
                                coa = DbCoa.fetchExc(brdOld.getCoaId());
                            }catch(Exception e){}
                            bRequest = new BudgetRequest();
                            try{
                                bRequest = DbBudgetRequest.fetchExc(budgetRequestId);
                            }catch(Exception e){}
                            HistoryBudget historyBudget = new HistoryBudget();
                            historyBudget.setType(DbHistoryBudget.TYPE_BUDGET_REQUEST);
                            historyBudget.setDate(new Date());
                            historyBudget.setRefId(bRequest.getOID());
                            historyBudget.setUserId(userId); 
                            User u = new User();
                            try{
                                u = DbUser.fetch(userId);
                            }catch(Exception e){}
                            historyBudget.setFullName(u.getFullName());
                            historyBudget.setEmployeeId(u.getEmployeeId());
                            historyBudget.setPeriodId(bRequest.getPeriodeId());
                            historyBudget.setMonth(bRequest.getTransDate().getMonth());
                            historyBudget.setYear((bRequest.getTransDate().getYear()+1900));
                            historyBudget.setSegment1Id(bRequest.getSegment1Id());
                            String keterangan = "Penghapusan request budget ( Akun "+coa.getCode()+"-"+coa.getName()+"), nilai "+JSPFormater.formatNumber(brdOld.getRequest(),"###,###.##")+
                                    " dengan keterangan :"+brdOld.getMemo();
                            historyBudget.setDescription(keterangan);
                            try{
                                DbHistoryBudget.insertExc(historyBudget);
                            }catch(Exception e){} 
                            
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

    public long getBudgetRequestId() {
        return budgetRequestId;
    }

    public void setBudgetRequestId(long budgetRequestId) {
        this.budgetRequestId = budgetRequestId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
}
