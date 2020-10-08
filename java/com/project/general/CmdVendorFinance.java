/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.admin.User;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy
 */
public class CmdVendorFinance extends Control {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    
    public static String[][] resultText = {
        {"Succes", "Duplicate entry for vendor code", "Duplicate entry for vendor code", "Data incomplete"},//{"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private Vendor vendor;
    private DbVendor dbVendor;
    private JspVendorFinance jspVendorFinance;
    private int language = 0;
    private long userId = 0;

    public CmdVendorFinance(HttpServletRequest request) {
        msgString = "";
        vendor = new Vendor();
        try {
            dbVendor = new DbVendor(0);
        } catch (Exception e) {}
        
        jspVendorFinance = new JspVendorFinance(request, vendor);
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

    public Vendor getVendorFinance() {
        return vendor;
    }

    public JspVendorFinance getForm() {
        return jspVendorFinance;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidVendor) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;
      
            case JSPCommand.SAVE:
                Vendor oldVendor = new Vendor();
                if (oidVendor != 0) {
                    try {
                        vendor = DbVendor.fetchExc(oidVendor);
                        oldVendor = DbVendor.fetchExc(oidVendor);
                    } catch (Exception exc) {
                    }
                }

                jspVendorFinance.requestEntityObject(vendor);

                if (jspVendorFinance.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (vendor.getOID() == 0) {
                    try {
                        long oid = dbVendor.insertExc(this.vendor);
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
                        String logs = "";
                        if(oldVendor.getContact() == null || oldVendor.getContact().length() <= 0){
                            if(vendor.getContact() != null && vendor.getContact().length() > 0){
                                if(logs.length() > 0){logs = logs+",";}
                                logs = logs+"Contact : "+vendor.getContact();
                            }
                        }else{
                            if(oldVendor.getContact().compareToIgnoreCase(vendor.getContact())!=0){
                                if(logs.length() > 0){logs = logs+",";}
                                logs = logs+"Contact : "+oldVendor.getContact()+" -> "+vendor.getContact();                            
                            }
                        }
                        
                        if(oldVendor.getNoRek() == null || oldVendor.getNoRek().length() <= 0){
                            if(vendor.getNoRek() != null && vendor.getNoRek().length() > 0){
                                if(logs.length() > 0){logs = logs+",";}
                                logs = logs+"No Rekening : "+vendor.getNoRek();
                            }
                        }else{
                            if(oldVendor.getNoRek().compareToIgnoreCase(vendor.getNoRek()) != 0){
                                if(logs.length() > 0){logs = logs+",";}
                                logs = logs+"No Rekening : "+oldVendor.getNoRek()+" -> "+vendor.getNoRek();                            
                            }
                        }
                        
                        if(oldVendor.getBankId() != vendor.getBankId()){
                            String strBank = "";
                            
                            if(oldVendor.getBankId()!=0){
                                Bank bankOld = new Bank();
                                try{
                                    bankOld = DbBank.fetchExc(oldVendor.getBankId());
                                    strBank = bankOld.getName();
                                }catch(Exception e){}
                            }
                            
                            if(vendor.getBankId() != 0){
                                Bank bankNew = new Bank();
                                try{
                                    bankNew = DbBank.fetchExc(vendor.getBankId());
                                    if(strBank.length()>0){
                                        strBank = strBank +"->";
                                    }
                                    strBank = strBank + bankNew.getName();
                                }catch(Exception e){}
                            }
                            
                            if(strBank.length() > 0){
                                strBank = "Bank :"+strBank;
                                if(logs.length() > 0){logs = logs+",";}
                                logs = logs + strBank;
                            }
                        }
                        
                        if(oldVendor.getPaymentType() != vendor.getPaymentType()){
                            if(logs.length() > 0){logs = logs+",";}
                                logs = logs + "Payment Type:"+DbVendor.keyPayment[oldVendor.getPaymentType()]+"->"+DbVendor.keyPayment[vendor.getPaymentType()];
                        }
                        
                        long oid = dbVendor.updateExc(this.vendor);
                        if(oid != 0){
                            if(logs != null && logs.length() > 0){
                                
                                HistoryUser historyUser = new HistoryUser();
                                historyUser.setType(DbHistoryUser.TYPE_VENDOR_FINANCE);
                                historyUser.setDate(new Date());
                                historyUser.setRefId(oid);                                
                                historyUser.setDescription(logs);
                                try {
                                    User u = DbUser.fetch(userId);
                                    historyUser.setUserId(userId);
                                    historyUser.setEmployeeId(u.getEmployeeId());
                                } catch (Exception e) {}
                            
                                try{
                                    DbHistoryUser.insertExc(historyUser);
                                }catch(Exception e){}
                            }
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidVendor != 0) {
                    try {
                        vendor = DbVendor.fetchExc(oidVendor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidVendor != 0) {
                    try {
                        vendor = DbVendor.fetchExc(oidVendor);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidVendor != 0) {
                    try {
                        long oid = DbVendor.deleteExc(oidVendor);
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

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
}
