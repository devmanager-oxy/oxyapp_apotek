package com.project.ccs.postransaction.request;

import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.*; 
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.ccs.posmaster.*;

public class CmdPurchaseRequestItem extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private PurchaseRequestItem purchaseRequestItem;
    private DbPurchaseRequestItem pstPurchaseRequestItem;
    private JspPurchaseRequestItem jspPurchaseRequestItem;
    int language = LANGUAGE_DEFAULT;

    public CmdPurchaseRequestItem(HttpServletRequest request) {
        msgString = "";
        purchaseRequestItem = new PurchaseRequestItem();
        try {
            pstPurchaseRequestItem = new DbPurchaseRequestItem(0);
        } catch (Exception e) {
            ;
        }
        jspPurchaseRequestItem = new JspPurchaseRequestItem(request, purchaseRequestItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspPurchaseRequestItem.addError(jspPurchaseRequestItem.JSP_FIELD_purchaseRequestItem_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public PurchaseRequestItem getPurchaseRequestItem() {
        return purchaseRequestItem;
    }

    public JspPurchaseRequestItem getForm() {
        return jspPurchaseRequestItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPurchaseRequestItem, long oidPurchaseRequest) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidPurchaseRequestItem != 0) {
                    try {
                        purchaseRequestItem = DbPurchaseRequestItem.fetchExc(oidPurchaseRequestItem);
                    } catch (Exception exc) {
                    }
                }

                jspPurchaseRequestItem.requestEntityObject(purchaseRequestItem);
                
                purchaseRequestItem.setPurchaseRequestId(oidPurchaseRequest);                                
                
                if(oidPurchaseRequestItem==0){
                    String where = DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_ITEM_MASTER_ID]+"="+purchaseRequestItem.getItemMasterId()+
                            " and "+DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID]+"="+oidPurchaseRequest;
                    
                    Vector v = DbPurchaseRequestItem.list(0,0, where, "");
                    
                    if(v!=null && v.size()>0){
                        PurchaseRequestItem pri = (PurchaseRequestItem)v.get(0);
                        purchaseRequestItem.setQty(pri.getQty()+purchaseRequestItem.getQty());
                        purchaseRequestItem.setOID(pri.getOID());
                        oidPurchaseRequestItem = pri.getOID();
                    }
                }
                
                if(oidPurchaseRequest==0){
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (jspPurchaseRequestItem.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                ItemMaster im = new ItemMaster();
                try{
                    im = DbItemMaster.fetchExc(purchaseRequestItem.getItemMasterId());
                    purchaseRequestItem.setUomId(im.getUomPurchaseId());
                }
                catch(Exception e){
                    
                }

                if (purchaseRequestItem.getOID() == 0) {
                    try {
                        long oid = pstPurchaseRequestItem.insertExc(this.purchaseRequestItem);
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
                        long oid = pstPurchaseRequestItem.updateExc(this.purchaseRequestItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidPurchaseRequestItem != 0) {
                    try {
                        purchaseRequestItem = DbPurchaseRequestItem.fetchExc(oidPurchaseRequestItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidPurchaseRequestItem != 0) {
                    try {
                        purchaseRequestItem = DbPurchaseRequestItem.fetchExc(oidPurchaseRequestItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidPurchaseRequestItem != 0) {
                    try {
                        long oid = DbPurchaseRequestItem.deleteExc(oidPurchaseRequestItem);
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
