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
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.stock.*;
import com.project.system.DbSystemProperty;

/**
 *
 * @author Roy Andika
 */
public class CmdReceiveItemMemo extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Duplicate Entry", "Data incomplete"}};
    private int start;
    private String msgString;
    private ReceiveItem receiveItem;
    private DbReceiveItem dbReceiveItem;
    private JspReceiveItemMemo jspReceiveItemMemo;
    int language = LANGUAGE_DEFAULT;

    public CmdReceiveItemMemo(HttpServletRequest request) {
        msgString = "";
        receiveItem = new ReceiveItem();
        try {
            dbReceiveItem = new DbReceiveItem(0);
        } catch (Exception e) {
        }
        jspReceiveItemMemo = new JspReceiveItemMemo(request, receiveItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspReceiveItemMemo.addError(jspReceiveItemMemo.JSP_FIELD_receiveItem_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public ReceiveItem getReceiveItem() {
        return receiveItem;
    }

    public JspReceiveItemMemo getForm() {
        return jspReceiveItemMemo;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidReceiveItem, long oidReceive) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.VIEW:

                if (oidReceiveItem != 0) {
                    try {
                        receiveItem = DbReceiveItem.fetchExc(oidReceiveItem);
                    } catch (Exception exc) {
                    }
                }

                jspReceiveItemMemo.requestEntityObject(receiveItem);

                break;

            case JSPCommand.SAVE:

                if (oidReceiveItem != 0) {
                    try {
                        receiveItem = DbReceiveItem.fetchExc(oidReceiveItem);
                    } catch (Exception exc) {
                    }
                }

                jspReceiveItemMemo.requestEntityObject(receiveItem);

                receiveItem.setReceiveId(oidReceive);

                ItemMaster im = new ItemMaster();
                try {
                    im = DbItemMaster.fetchExc(receiveItem.getItemMasterId());
                    receiveItem.setUomId(im.getUomPurchaseId());
                } catch (Exception e) {
                }
                
                if(receiveItem.getAmount() ==0){
                    jspReceiveItemMemo.addError(jspReceiveItemMemo.JSP_AMOUNT, "Amount can't empty");
                }

                if (jspReceiveItemMemo.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (receiveItem.getOID() == 0) {
                    try {
                        
                        long oid = dbReceiveItem.insertExc(this.receiveItem);
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
                        long oid = dbReceiveItem.updateExc(this.receiveItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidReceiveItem != 0) {
                    try {
                        receiveItem = DbReceiveItem.fetchExc(oidReceiveItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.REFRESH:

                if (oidReceiveItem != 0) {

                    try {

                        receiveItem = DbReceiveItem.fetchExc(oidReceiveItem);

                        jspReceiveItemMemo.requestEntityObject(receiveItem);

                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                } else {

                    jspReceiveItemMemo.requestEntityObject(receiveItem);
                }
                break;

            case JSPCommand.ASK:
                if (oidReceiveItem != 0) {
                    try {
                        receiveItem = DbReceiveItem.fetchExc(oidReceiveItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidReceiveItem != 0) {
                    try {
                        long oid = DbReceiveItem.deleteExc(oidReceiveItem);
                        if (oid != 0) {

                            //untuk menghapus stock jika di bypass
                            if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                                DbStock.delete(DbStock.colNames[DbStock.COL_RECEIVE_ITEM_ID] + " = " + oidReceiveItem);
                            }

                            //Penghapusan stock code
                            DbStockCode.deleteStockCode(oidReceiveItem);

                            //fixing grand total amount - karena di delete
                            DbReceive.fixGrandTotalAmount(oidReceive);

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
