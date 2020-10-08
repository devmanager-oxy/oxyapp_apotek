package com.project.ccs.posmaster;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.general.DbHistoryUser;
import com.project.general.HistoryUser;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.ccs.session.SessItemMaster;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

public class CmdItemMaster extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private ItemMaster itemMaster;
    private DbItemMaster pstItemMaster;
    private JspItemMaster jspItemMaster;
    int language = LANGUAGE_DEFAULT;
    private long userId = 0;
    private String userName = "";

    public CmdItemMaster(HttpServletRequest request) {
        msgString = "";
        itemMaster = new ItemMaster();
        try {
            pstItemMaster = new DbItemMaster(0);
        } catch (Exception e) {
            ;
        }
        jspItemMaster = new JspItemMaster(request, itemMaster);
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

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public ItemMaster getItemMaster() {
        return itemMaster;
    }

    public JspItemMaster getForm() {
        return jspItemMaster;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidItemMaster) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                if (oidItemMaster != 0) {
                    jspItemMaster.requestEntityObject(itemMaster);
                }
                break;

            case JSPCommand.SAVE:

                ItemMaster oldItemMaster = new ItemMaster();                
                if (oidItemMaster != 0) {
                    try {
                        itemMaster = DbItemMaster.fetchExc(oidItemMaster);
                        oldItemMaster = DbItemMaster.fetchExc(oidItemMaster);
                    } catch (Exception exc) {
                    }
                }

                jspItemMaster.requestEntityObject(itemMaster);
                
                if (SessItemMaster.checkBarcode(itemMaster.getBarcode(), itemMaster.getOID())){
                    msgString = "barcode is already exist";
                    return RSLT_EST_CODE_EXIST;
                }
                
                //jika product dijual
                if (itemMaster.getForSale() == 1) {
                    if (itemMaster.getUomSalesId() == 0) {
                        jspItemMaster.addError(jspItemMaster.JSP_UOM_SALES_ID, "Data required");
                    }
                }

                //jika product di beli untuk stock
                if (itemMaster.getForBuy() == 1) {
                    if (itemMaster.getUomPurchaseId() == 0) {
                        jspItemMaster.addError(jspItemMaster.JSP_UOM_PURCHASE_ID, "Data required");
                    }
                    if (itemMaster.getUomPurchaseStockQty() == 0) {
                        jspItemMaster.addError(jspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY, "Data required");
                    }
                    if (itemMaster.getUomStockId() == 0) {
                        jspItemMaster.addError(jspItemMaster.JSP_UOM_STOCK_ID, "Data required");
                    }
                    //jika for sales juga, cek qty item sales
                    if (itemMaster.getForSale() == 1 && itemMaster.getUomStockSalesQty() == 0) {
                        jspItemMaster.addError(jspItemMaster.JSP_UOM_STOCK_SALES_QTY, "Data required");
                    }
                }

                //jika include di resep masakan
                if (itemMaster.getRecipeItem() == 1) {
                    if (itemMaster.getUomRecipeId() == 0) {
                        jspItemMaster.addError(jspItemMaster.JSP_UOM_RECIPE_ID, "Data required");
                    }

                    if (itemMaster.getUomStockRecipeQty() == 0) {
                        jspItemMaster.addError(jspItemMaster.JSP_UOM_STOCK_RECIPE_QTY, "Data required");
                    }
                }

                ItemCategory icat = new ItemCategory();
                try {
                    icat = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
                } catch (Exception e) {
                }

                itemMaster.setItemGroupId(icat.getItemGroupId());
                itemMaster.setType(icat.getGroupType());

                if (jspItemMaster.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }


                if (itemMaster.getOID() == 0) {
                    try {
                        itemMaster.setCounterSku(DbItemMaster.getNextCounter(itemMaster.getItemGroupId()));
                        itemMaster.setRegisterDate(new Date());
                        itemMaster.setName(itemMaster.getName().toUpperCase());
                        long oid = pstItemMaster.insertExc(this.itemMaster);

                        if (oid != 0) {
                            DbItemMaster.insertOperationLog(oid, userId, userName, itemMaster);
                            String memo = "Pembuatan item baru dengan cogs = "+JSPFormater.formatNumber(itemMaster.getCogs(),"###,###.##");
                            HistoryUser hisUser = new HistoryUser();
                            hisUser.setUserId(userId);
                            User suser = new User();
                            try{
                                suser = DbUser.fetch(userId);
                            }catch(Exception e){}
                            hisUser.setEmployeeId(suser.getEmployeeId());
                            hisUser.setRefId(itemMaster.getOID());
                            hisUser.setDescription(memo);
                            hisUser.setType(DbHistoryUser.TYPE_COGS_MASTER);
                            hisUser.setDate(new Date());
                            try {
                                DbHistoryUser.insertExc(hisUser);
                            } catch (Exception e) {}
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
                        if(oldItemMaster.getItemCategoryId() != itemMaster.getItemCategoryId() || oldItemMaster.getItemGroupId() != itemMaster.getItemGroupId()){
                            itemMaster.setCounterSku(DbItemMaster.getNextCounter(itemMaster.getItemGroupId()));
                        }
                        long oid = pstItemMaster.updateExc(this.itemMaster);
                        if (oid != 0) {

                            DbItemMaster.insertOperationLog(oid, userId, userName, oldItemMaster, itemMaster);
                            if(oldItemMaster.getCogs() != itemMaster.getCogs()){
                                String memo = "Perubahan item dengan cogs sebelumnya = "+JSPFormater.formatNumber(oldItemMaster.getCogs(),"###,###.##")+" menjadi "+JSPFormater.formatNumber(itemMaster.getCogs(),"###,###.##");
                                HistoryUser hisUser = new HistoryUser();
                                hisUser.setUserId(userId);
                                User suser = new User();
                                try{
                                    suser = DbUser.fetch(userId);
                                }catch(Exception e){}
                                hisUser.setEmployeeId(suser.getEmployeeId());
                                hisUser.setRefId(itemMaster.getOID());
                                hisUser.setDescription(memo);
                                hisUser.setType(DbHistoryUser.TYPE_COGS_MASTER);
                                hisUser.setDate(new Date());
                                try {
                                    DbHistoryUser.insertExc(hisUser);
                                } catch (Exception e) {}
                            }

                            msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
                            rsCode = RSLT_OK;
                        } else {
                            msgString = JSPMessage.getMessage(JSPMessage.ERR_SAVED);
                            rsCode = RSLT_FORM_INCOMPLETE;
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
                if (oidItemMaster != 0) {
                    try {
                        itemMaster = DbItemMaster.fetchExc(oidItemMaster);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidItemMaster != 0) {
                    try {
                        itemMaster = DbItemMaster.fetchExc(oidItemMaster);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidItemMaster != 0) {
                    try {
                        ItemMaster im = new ItemMaster();
                        try{
                            im = DbItemMaster.fetchExc(oidItemMaster);
                        }catch(Exception e){}
                        long oid = DbItemMaster.deleteExc(oidItemMaster);
                        if (oid != 0) {
                            String memo = "Delete item dengan nama = "+im.getName()+", code ="+im.getCode()+" dan cogs = "+JSPFormater.formatNumber(im.getCogs(),"###,###.##");
                            HistoryUser hisUser = new HistoryUser();
                            hisUser.setUserId(userId);
                            User suser = new User();
                            try{
                                suser = DbUser.fetch(userId);
                            }catch(Exception e){}
                            hisUser.setEmployeeId(suser.getEmployeeId());
                            hisUser.setRefId(im.getOID());
                            hisUser.setDescription(memo);
                            hisUser.setType(DbHistoryUser.TYPE_COGS_MASTER);
                            hisUser.setDate(new Date());
                            try {
                                DbHistoryUser.insertExc(hisUser);
                            } catch (Exception e) {}
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
