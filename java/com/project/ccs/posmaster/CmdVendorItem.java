package com.project.ccs.posmaster;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.general.DbHistoryUser;
import com.project.general.DbVendor;
import com.project.general.HistoryUser;
import com.project.general.Vendor;
import java.util.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

public class CmdVendorItem extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
    };
    private int start;
    private String msgString;
    private VendorItem vendorItem;
    private DbVendorItem pstVendorItem;
    private JspVendorItem jspVendorItem;
    int language = LANGUAGE_DEFAULT;
    private long userId = 0;

    public CmdVendorItem(HttpServletRequest request) {
        msgString = "";
        vendorItem = new VendorItem();
        try {
            pstVendorItem = new DbVendorItem(0);
        } catch (Exception e) {
        }
        jspVendorItem = new JspVendorItem(request, vendorItem);
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

    public VendorItem getVendorItem() {
        return vendorItem;
    }

    public JspVendorItem getForm() {
        return jspVendorItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidVendorItem) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                VendorItem old = new VendorItem();
                if (oidVendorItem != 0) {
                    try {
                        vendorItem = DbVendorItem.fetchExc(oidVendorItem);
                        old = DbVendorItem.fetchExc(oidVendorItem);
                    } catch (Exception exc) {
                    }
                }

                jspVendorItem.requestEntityObject(vendorItem);

                if (jspVendorItem.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (vendorItem.getOID() == 0) {
                    try {
                        vendorItem.setUpdateDate(new Date());
                        long oid = pstVendorItem.insertExc(this.vendorItem);
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_VENDOR_ITEM);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(this.vendorItem.getItemMasterId());
                            Vendor v = new Vendor();
                            try{
                                v = DbVendor.fetchExc(vendorItem.getVendorId());
                            }catch(Exception e){}
                            historyUser.setDescription("Pembuatan Harga suplier Baru : " + v.getName());
                            try {
                                User u = DbUser.fetch(getUserId());
                                historyUser.setUserId(getUserId());
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }
                            try{
                                DbHistoryUser.insertExc(historyUser);
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
                        vendorItem.setUpdateDate(new Date());
                        long oid = pstVendorItem.updateExc(this.vendorItem);  
                        if(oid != 0){
                            String str = "";
                            Vendor vOld = new Vendor();
                            try{
                                vOld = DbVendor.fetchExc(old.getVendorId());
                            }catch(Exception e){}
                            
                            if (old.getVendorId() != vendorItem.getVendorId()) {
                                if (str != null && str.length() > 0) {
                                    str = str + ",";
                                }                                                                
                                Vendor vNew = new Vendor();                                
                                try{
                                    vNew = DbVendor.fetchExc(vendorItem.getVendorId());
                                }catch(Exception e){}
                                
                                str = str + "Suplier :" + vOld.getName() + "->" +vNew.getName();
                            }
                            
                            if (old.getRealPrice() != vendorItem.getRealPrice()){
                                if (str != null && str.length() > 0) {
                                    str = str + ",";
                                }
                                str = str + "Real Price :" + JSPFormater.formatNumber(old.getRealPrice(), "###,###.##")+" -> "+JSPFormater.formatNumber(vendorItem.getRealPrice(), "###,###.##");
                            }
                            
                            if (old.getLastPrice() != vendorItem.getLastPrice()){
                                if (str != null && str.length() > 0) {
                                    str = str + ",";
                                }
                                str = str + "Last Price :" + JSPFormater.formatNumber(old.getLastPrice(), "###,###.##")+" -> "+JSPFormater.formatNumber(vendorItem.getLastPrice(), "###,###.##");
                            }
                            
                             if (old.getLastDiscount() != vendorItem.getLastDiscount()){
                                if (str != null && str.length() > 0) {
                                    str = str + ",";
                                }
                                str = str + "Last Discount :" + JSPFormater.formatNumber(old.getLastDiscount(), "###,###.##")+" -> "+JSPFormater.formatNumber(vendorItem.getLastDiscount(), "###,###.##");
                            }
                            
                             if(str != null && str.length() > 0){
                                str = "Perubahan data Harga Supplier "+vOld.getName()+": "+str;
                                HistoryUser historyUser = new HistoryUser();
                                historyUser.setType(DbHistoryUser.TYPE_VENDOR_ITEM);
                                historyUser.setDate(new Date());
                                historyUser.setRefId(this.vendorItem.getItemMasterId());                                
                                historyUser.setDescription(str);
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
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.EDIT:
                if (oidVendorItem != 0) {
                    try {
                        vendorItem = DbVendorItem.fetchExc(oidVendorItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidVendorItem != 0) {
                    try {
                        vendorItem = DbVendorItem.fetchExc(oidVendorItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidVendorItem != 0) {
                    try {
                        old = new VendorItem();
                        Vendor vOld = new Vendor();
                        try{
                            old = DbVendorItem.fetchExc(oidVendorItem);                            
                            try{
                                vOld = DbVendor.fetchExc(old.getVendorId());
                            }catch(Exception e){}
                        }catch(Exception e){}
                        long oid = DbVendorItem.deleteExc(oidVendorItem);
                        
                        if (oid != 0) {
                            HistoryUser historyUser = new HistoryUser();
                            historyUser.setType(DbHistoryUser.TYPE_VENDOR_ITEM);
                            historyUser.setDate(new Date());
                            historyUser.setRefId(old.getItemMasterId());                            
                            historyUser.setDescription("Penghapusan data Harga Suplier : " + vOld.getName());
                            try {
                                User u = DbUser.fetch(userId);
                                historyUser.setUserId(userId);
                                historyUser.setEmployeeId(u.getEmployeeId());
                            } catch (Exception e) {
                            }                            
                            try{
                                DbHistoryUser.insertExc(historyUser);
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

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
}
