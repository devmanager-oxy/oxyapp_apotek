package com.project.ccs.postransaction.adjusment;

import com.project.I_Project;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*; 
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.stock.*;
import com.project.system.DbSystemProperty;

public class CmdAdjusmentItem extends Control implements I_Language {

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
    private AdjusmentItem adjusmentItem;
    private DbAdjusmentItem pstAdjusmentItem;
    private JspAdjusmentItem jspAdjusmentItem;
    int language = LANGUAGE_DEFAULT;

    public CmdAdjusmentItem(HttpServletRequest request) {
        msgString = "";
        adjusmentItem = new AdjusmentItem();
        try {
            pstAdjusmentItem = new DbAdjusmentItem(0);
        } catch (Exception e) {
            
        }
        jspAdjusmentItem = new JspAdjusmentItem(request, adjusmentItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspAdjusmentItem.addError(jspAdjusmentItem.JSP_FIELD_adjusment_item_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public AdjusmentItem getAdjusmentItem() {
        return adjusmentItem;
    }

    public JspAdjusmentItem getForm() {
        return jspAdjusmentItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidAdjusmentItem, long adjusmentId) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;
            
            case JSPCommand.ACTIVATE:
                break;    

            case JSPCommand.SAVE:
                if (oidAdjusmentItem != 0) {
                    try {
                        adjusmentItem = DbAdjusmentItem.fetchExc(oidAdjusmentItem);
                    } catch (Exception exc) {
                    }
                }
                
                Adjusment adjusment = new Adjusment();
                if(adjusmentId!=0){
                    try {
                        adjusment = DbAdjusment.fetchExc(adjusmentId);  
                    } catch (Exception exc) {
                    }
                }

                jspAdjusmentItem.requestEntityObject(adjusmentItem);
                
                //add update item hanya boleh saat draft
                if(!adjusment.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && !adjusment.getStatus().equals("")){
                    jspAdjusmentItem.addError(jspAdjusmentItem.JSP_QTY_BALANCE, "Error, document have been locked for update");
                }
                
                adjusmentItem.setAdjusmentId(adjusmentId);

                if (jspAdjusmentItem.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                                
                //adjusmentItem.setQtyBalance(adjusmentItem.getQtyReal()-adjusmentItem.getQtySystem());
                
               // if(adjusmentItem.getPrice()==0){
                    ItemMaster imx = new ItemMaster();
                    try{
                        imx = DbItemMaster.fetchExc(adjusmentItem.getItemMasterId());
                        adjusmentItem.setPrice(imx.getCogs());
                        adjusmentItem.setAmount(imx.getCogs() * (adjusmentItem.getQtyReal()-adjusmentItem.getQtySystem()));
                    }
                    catch(Exception e){
                    }
               // }
                //ItemMaster im = new ItemMaster();
                

                if (adjusmentItem.getOID() == 0) {
                    try {
                        long oid = pstAdjusmentItem.insertExc(this.adjusmentItem);
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
                        long oid = pstAdjusmentItem.updateExc(this.adjusmentItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidAdjusmentItem != 0) {
                    try {
                        adjusmentItem = DbAdjusmentItem.fetchExc(oidAdjusmentItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidAdjusmentItem != 0) {
                    try {
                        adjusmentItem = DbAdjusmentItem.fetchExc(oidAdjusmentItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidAdjusmentItem != 0) {
                    try {
                        long oid = DbAdjusmentItem.deleteExc(oidAdjusmentItem);
                        if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                            DbStock.delete(DbStock.colNames[DbStock.COL_ADJUSTMENT_ITEM_ID] + " = " + oidAdjusmentItem);
                        }
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
