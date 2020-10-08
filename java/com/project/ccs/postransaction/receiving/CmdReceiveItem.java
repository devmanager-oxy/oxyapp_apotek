package com.project.ccs.postransaction.receiving;

import com.project.I_Project;
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
import java.sql.ResultSet;
public class CmdReceiveItem extends Control implements I_Language {

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
    private JspReceiveItem jspReceiveItem;
    int language = LANGUAGE_DEFAULT;

    public CmdReceiveItem(HttpServletRequest request) {
        msgString = "";
        receiveItem = new ReceiveItem();
        try {
            dbReceiveItem = new DbReceiveItem(0);
        } catch (Exception e) {
            ;
        }
        jspReceiveItem = new JspReceiveItem(request, receiveItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspReceiveItem.addError(jspReceiveItem.JSP_FIELD_receiveItem_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public JspReceiveItem getForm() {
        return jspReceiveItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }    

    public int action(int cmd, long oidReceiveItem, long oidReceive, boolean isStockCodeEmpty, boolean isStockSame) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;
            
            case JSPCommand.VIEW:
                
                if (oidReceiveItem != 0){
                    try {
                        receiveItem = DbReceiveItem.fetchExc(oidReceiveItem);
                    } catch (Exception exc) {}
                }
                
                jspReceiveItem.requestEntityObject(receiveItem);
                
                break;
                
            case JSPCommand.SAVE:
                
                if (oidReceiveItem != 0) {
                    try {
                        receiveItem = DbReceiveItem.fetchExc(oidReceiveItem);
                    } catch (Exception exc) {
                    }
                }
                
                Receive receive = new Receive();
                if(oidReceive!=0){
                    try {
                        receive = DbReceive.fetchExc(oidReceive);  
                    } catch (Exception exc) {
                    }
                }

                jspReceiveItem.requestEntityObject(receiveItem);
                
                //add update item hanya boleh saat draft
                if(!receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){
                    jspReceiveItem.addError(jspReceiveItem.JSP_QTY, "Error, document have been locked for update");
                }
                
                receiveItem.setReceiveId(oidReceive);
                
                ItemMaster im = new ItemMaster();
                try{
                    im = DbItemMaster.fetchExc(receiveItem.getItemMasterId());
                    receiveItem.setUomId(im.getUomPurchaseId());
                }
                catch(Exception e){}

                if (jspReceiveItem.errorSize() > 0){
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                if(isStockCodeEmpty == true){
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                    
                }
                if(isStockSame==true){
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_IN_USED);
                    return RSLT_EST_CODE_EXIST;
                }

                if (receiveItem.getOID() == 0){
                    try {
                         if(CheckItemId(receiveItem.getItemMasterId(),oidReceive)){
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DATA_EXIST);
                            return RSLT_EST_CODE_EXIST;
                        } 
                        long oid = dbReceiveItem.insertExc(this.receiveItem);
                        Receive rec = new Receive();
                        try{
                            rec= DbReceive.fetchExc(oidReceive);
                        }catch(Exception ex){
                            
                        }
                        //DbStock.delete(DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID] + "=" + oid);
                       // DbStock.insertReceiveGoods(rec, receiveItem);
                       
                                     
                    } catch (CONException dbexc){
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }

                } else {
                    try {
                        if(CheckItemIdEdit(receiveItem.getItemMasterId(),oidReceiveItem,oidReceive)){
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DATA_EXIST);
                            return RSLT_EST_CODE_EXIST;
                        } 
                        long oid = dbReceiveItem.updateExc(this.receiveItem);
                        Receive rec = new Receive();
                        try{
                            rec= DbReceive.fetchExc(oidReceive);
                        }catch(Exception ex){
                            
                        }
                        //DbStock.delete(DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID] + "=" + oid);
                        //DbStock.insertReceiveGoods(rec, receiveItem);
                        
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
                        
                        jspReceiveItem.requestEntityObject(receiveItem);
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }else{
                    
                    jspReceiveItem.requestEntityObject(receiveItem);
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
                        if (oid != 0){
                            
                            //untuk menghapus stock jika di bypass
                            if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                                DbStock.delete(DbStock.colNames[DbStock.COL_RECEIVE_ITEM_ID]+ " = " + oidReceiveItem);
                            }
                            
                            //Penghapusan stock code
                            DbStockCode.deleteStockCode(oidReceiveItem);
                            
                            //fixing grand total amount - karena di delete
                            DbReceive.fixGrandTotalAmount(oidReceive); 
                            //delete di stock
                            DbStock.delete(DbStock.colNames[DbStock.COL_RECEIVE_ITEM_ID]+ " = " + oidReceiveItem);
                            
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
    public static boolean CheckItemId(long itemMasterId, long receiveId){
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "select count(*) as tot from pos_receive_item where " +
                    "  item_master_id="  + itemMasterId + " and receive_id=" + receiveId;
                    
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
    public static boolean CheckItemIdEdit(long itemMasterId, long receiveItemId, long receiveId){
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "select count(*) as tot from pos_receive_item where " +
                    "  item_master_id=" + itemMasterId + " and receive_id="+receiveId+ " and receive_item_id <> " + receiveItemId;
                    
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
