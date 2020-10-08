package com.project.ccs.postransaction.transfer;

import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbStockCode;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.order.DbOrder;
import com.project.ccs.postransaction.stock.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.system.DbSystemProperty;
import java.sql.ResultSet;

public class CmdTransferItem extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private TransferItem transferItem;
    private DbTransferItem pstTransferItem;
    private JspTransferItem jspTransferItem;
    int language = LANGUAGE_DEFAULT;    

    public CmdTransferItem(HttpServletRequest request) {
        msgString = "";
        transferItem = new TransferItem();
        try {
            pstTransferItem = new DbTransferItem(0);
        } catch (Exception e) {
            ;
        }
        jspTransferItem = new JspTransferItem(request, transferItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspTransferItem.addError(jspTransferItem.JSP_FIELD_transfer_item_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public TransferItem getTransferItem() {
        return transferItem;
    }

    public JspTransferItem getForm() {
        return jspTransferItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidTransferItem, long oidTransfer, int qtyStockCode) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.VIEW:

                if (oidTransferItem != 0) {
                    try {
                        transferItem = DbTransferItem.fetchExc(oidTransferItem);
                    } catch (Exception exc) {}
                }
                jspTransferItem.requestEntityObject(transferItem);

                break;

            case JSPCommand.SAVE:
                if (oidTransferItem != 0){
                    try {
                        transferItem = DbTransferItem.fetchExc(oidTransferItem);
                    }catch (Exception exc) {
                    }
                }
               // System.out.println("err >>> : masuk");
                
                jspTransferItem.requestEntityObject(transferItem);
                
                boolean useStockCode    = false;
                
                if(transferItem.getItemMasterId() != 0){
                    
                    try{
                        
                        ItemMaster im = new ItemMaster();
                        im = DbItemMaster.fetchExc(transferItem.getItemMasterId());
                        
                        //update harga dan total karena di jsp nya di hide
                        transferItem.setPrice(im.getCogs());
                        transferItem.setAmount((im.getCogs()*transferItem.getQty()));
                        if(im.getApplyStockCode() == DbItemMaster.APPLY_STOCK_CODE){
                            useStockCode = true;
                        }
                        
                    }catch(Exception e){}
                    
                }    
                
                int totQty = 0;
                
                if(useStockCode){                    
                    if(transferItem.getQty() > 0){
                        for(double xQty = 0 ; xQty < transferItem.getQty() ; xQty++){
                            totQty++;
                        }
                    }                    
                    
                    if(totQty != qtyStockCode){
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                        return RSLT_FORM_INCOMPLETE;
                    }
                }

                transferItem.setTransferId(oidTransfer);
                

                if (jspTransferItem.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (transferItem.getOID() == 0) {
                    System.out.println("err >>> : masuk 2");
                    try {
                        if(CheckItemId(transferItem.getItemMasterId(),oidTransfer)){
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DATA_EXIST);
                            return RSLT_EST_CODE_EXIST;
                        }    
                        long oid = pstTransferItem.insertExc(this.transferItem);
                        Transfer tran = new Transfer();
                        try{
                            tran= DbTransfer.fetchExc(oidTransfer);
                        }catch(Exception ex){
                            
                        }
                       
                        DbStock.delete(DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID] + "=" + oid);
                        DbStock.insertTransferGoods(tran, transferItem);
                        //DbOrder.updateOrderByTransferItem(tran, transferItem);
                        //.out.println("err >>> : masuk sukses");
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
                        if(CheckItemIdEdit(transferItem.getItemMasterId(),oidTransferItem,oidTransfer)){
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DATA_EXIST);
                            return RSLT_EST_CODE_EXIST;
                        }                  
                        long oid = pstTransferItem.updateExc(this.transferItem);
                        
                        Transfer tran = new Transfer();
                        try{
                            tran= DbTransfer.fetchExc(oidTransfer);
                        }catch(Exception ex){
                            
                        }
                        DbStock.delete(DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID] + "=" + oid);
                        DbStock.insertTransferGoods(tran, transferItem);
                        //DbOrder.updateAuto(" set qty_proces="+ transferItem.getQty() + " where item_master_id=" + transferItem.getItemMasterId() + " and transfer_item_id="+ transferItem.getOID());
                        
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) { 
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }

                }
                break;

            case JSPCommand.EDIT:
                if (oidTransferItem != 0) {
                    try {
                        transferItem = DbTransferItem.fetchExc(oidTransferItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;
                
            case JSPCommand.REFRESH:
                if (oidTransferItem != 0) {
                    try {
                        transferItem = DbTransferItem.fetchExc(oidTransferItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                jspTransferItem.requestEntityObject(transferItem);
                break;    
                

            case JSPCommand.ASK:
                if (oidTransferItem != 0) {
                    try {
                        transferItem = DbTransferItem.fetchExc(oidTransferItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidTransferItem != 0) {
                    try {
                        
                        DbStockCode.deleteStockCodeByTransferItem(oidTransferItem);
                        long oid = DbTransferItem.deleteExc(oidTransferItem);
                        if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                            DbStock.delete(DbStock.colNames[DbStock.COL_TRANSFER_ITEM_ID]+ " = " + oidTransferItem);
                        }
                        DbStock.delete(DbStock.colNames[DbStock.COL_TRANSFER_ITEM_ID]+ " = " + oidTransferItem);
                        //DbOrder.deleteOrderByTransferItem(oidTransferItem);
                        DbOrder.updateAuto("set status='DRAFT', transfer_id=0, transfer_item_id=0 where transfer_item_id="+oidTransferItem);
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
     public static boolean CheckItemId(long itemMasterId, long transferId){
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "select count(*) as tot from pos_transfer_item where " +
                    "  item_master_id="  + itemMasterId + " and transfer_id=" + transferId;
                    
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
    public static boolean CheckItemIdEdit(long itemMasterId, long transferItemId, long transferId){
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "select count(*) as tot from pos_transfer_item where " +
                    "  item_master_id=" + itemMasterId + " and transfer_id="+transferId+ " and transfer_item_id <> " + transferItemId;
                    
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
