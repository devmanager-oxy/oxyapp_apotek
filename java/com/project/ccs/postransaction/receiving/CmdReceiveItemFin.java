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

public class CmdReceiveItemFin extends Control implements I_Language {

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
    private JspReceiveItemFin jspReceiveItemFin;
    int language = LANGUAGE_DEFAULT;

    public CmdReceiveItemFin(HttpServletRequest request) {
        msgString = "";
        receiveItem = new ReceiveItem();
        try {
            dbReceiveItem = new DbReceiveItem(0);
        } catch (Exception e) {
            ;
        }
        jspReceiveItemFin = new JspReceiveItemFin(request, receiveItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspReceiveItemFin.addError(jspReceiveItemFin.JSP_FIELD_receiveItem_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public JspReceiveItemFin getForm() {
        return jspReceiveItemFin;
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

            case JSPCommand.SAVE:
                if (oidReceiveItem != 0) {
                    try {
                        receiveItem = DbReceiveItem.fetchExc(oidReceiveItem);
                    } catch (Exception exc) {
                    }
                }

                jspReceiveItemFin.requestEntityObject(receiveItem);
                
                receiveItem.setReceiveId(oidReceive);
                
                ItemMaster im = new ItemMaster();
                try{
                    im = DbItemMaster.fetchExc(receiveItem.getItemMasterId());
                    receiveItem.setUomId(im.getUomPurchaseId());
                }
                catch(Exception e){
                    
                }

                if (jspReceiveItemFin.errorSize() > 0) {
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
