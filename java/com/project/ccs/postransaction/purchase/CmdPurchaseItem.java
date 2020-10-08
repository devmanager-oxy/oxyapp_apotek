package com.project.ccs.postransaction.purchase;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.ccs.posmaster.*;
import java.sql.ResultSet;

public class CmdPurchaseItem extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private PurchaseItem purchaseItem;
    private DbPurchaseItem dbPurchaseItem;
    private JspPurchaseItem jspPurchaseItem;
    int language = LANGUAGE_DEFAULT;

    public CmdPurchaseItem(HttpServletRequest request) {
        msgString = "";
        purchaseItem = new PurchaseItem();
        try {
            dbPurchaseItem = new DbPurchaseItem(0);
        } catch (Exception e) {
            ;
        }
        jspPurchaseItem = new JspPurchaseItem(request, purchaseItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspPurchaseItem.addError(jspPurchaseItem.JSP_FIELD_purchaseItem_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public PurchaseItem getPurchaseItem() {
        return purchaseItem;
    }

    public JspPurchaseItem getForm() {
        return jspPurchaseItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPurchaseItem, long oidPurchase) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidPurchaseItem != 0) {
                    try {
                        purchaseItem = DbPurchaseItem.fetchExc(oidPurchaseItem);
                    } catch (Exception exc) {
                    }
                }

                jspPurchaseItem.requestEntityObject(purchaseItem);
                
                purchaseItem.setPurchaseId(oidPurchase);
                
                ItemMaster im = new ItemMaster();
                try{
                    im = DbItemMaster.fetchExc(purchaseItem.getItemMasterId());
                    purchaseItem.setUomId(im.getUomPurchaseId());
                }
                catch(Exception e){
                    
                }

                if (jspPurchaseItem.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (purchaseItem.getOID() == 0) {
                    try {
                        if(CheckItemId(purchaseItem.getItemMasterId(),oidPurchase)){
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DATA_EXIST);
                            return RSLT_EST_CODE_EXIST;
                        } 
                        long oid = dbPurchaseItem.insertExc(this.purchaseItem);
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
                         if(CheckItemIdEdit(purchaseItem.getItemMasterId(),oidPurchaseItem,oidPurchase)){
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DATA_EXIST);
                            return RSLT_EST_CODE_EXIST;
                        } 
                        long oid = dbPurchaseItem.updateExc(this.purchaseItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidPurchaseItem != 0) {
                    try {
                        purchaseItem = DbPurchaseItem.fetchExc(oidPurchaseItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidPurchaseItem != 0) {
                    try {
                        purchaseItem = DbPurchaseItem.fetchExc(oidPurchaseItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidPurchaseItem != 0) {
                    try {
                        long oid = DbPurchaseItem.deleteExc(oidPurchaseItem);
                        if (oid != 0) {
                            
                            //fixing grand total amount - karena di delete
                            DbPurchase.fixGrandTotalAmount(oidPurchase); 
                            
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
    public static boolean CheckItemId(long itemMasterId, long purchaseId){
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "select count(*) as tot from pos_purchase_item where " +
                    "  item_master_id="  + itemMasterId + " and purchase_id=" + purchaseId;
                    
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                int tot = rs.getInt("tot");
                if(tot>0){
                    result = true;
                }
                
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }
    public static boolean CheckItemIdEdit(long itemMasterId, long purchaseItemId, long purchaseId){
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "select count(*) as tot from pos_purchase_item where " +
                    "  item_master_id=" + itemMasterId + " and purchase_id="+purchaseId+ " and purchase_item_id <> " + purchaseItemId;
                    
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                int tot =  rs.getInt("tot");
                if(tot>0){
                    result = true;
                }
                
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }
}
