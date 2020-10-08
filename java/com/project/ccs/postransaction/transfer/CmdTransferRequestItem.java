/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.transfer;
import com.project.I_Project;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemMaster;

import com.project.general.DbDocumentHistory;
import com.project.general.DocumentHistory;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import java.sql.ResultSet;
import java.util.Date;
/**
 *
 * @author Roy Andika
 */
public class CmdTransferRequestItem extends Control implements I_Language {
    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private TransferRequestItem transferRequestItem;
    private DbTransferRequestItem pstTransferRequestItem;
    private JspTransferRequestItem jspTransferRequestItem;
    int language = LANGUAGE_DEFAULT;
    private long userId = 0;

    public CmdTransferRequestItem(HttpServletRequest request) {
        msgString = "";
        transferRequestItem = new TransferRequestItem();
        try {
            pstTransferRequestItem = new DbTransferRequestItem(0);
        } catch (Exception e) {            
        }
        jspTransferRequestItem = new JspTransferRequestItem(request, transferRequestItem);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                //this.jspTransferRequestItem.addError(jspTransferRequestItem.JSP_FIELD_transfer_item_id, resultText[language][RSLT_EST_CODE_EXIST] );
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

    public TransferRequestItem getTransferItem() {
        return transferRequestItem;
    }

    public JspTransferRequestItem getForm() {
        return jspTransferRequestItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidTransferItem, long oidTransfer) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        TransferRequestItem transferItemOld = new TransferRequestItem();

        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.VIEW:

                if (oidTransferItem != 0) {
                    try {
                        transferRequestItem = DbTransferRequestItem.fetchExc(oidTransferItem);
                    } catch (Exception exc) {}
                }
                jspTransferRequestItem.requestEntityObject(transferRequestItem);

                break;

            case JSPCommand.SAVE:
                if (oidTransferItem != 0){
                    try {
                        transferRequestItem = DbTransferRequestItem.fetchExc(oidTransferItem); 
                        transferItemOld = DbTransferRequestItem.fetchExc(oidTransferItem);
                    }catch (Exception exc) {
                    }
                }
                
                jspTransferRequestItem.requestEntityObject(transferRequestItem);
                
                TransferRequest tran = new TransferRequest();
                try{
                    tran= DbTransferRequest.fetchExc(oidTransfer);
                }catch(Exception ex){

                }

                if(transferRequestItem.getItemMasterId() != 0){
                    try{
                        ItemMaster im = new ItemMaster();
                        im = DbItemMaster.fetchExc(transferRequestItem.getItemMasterId());
                    }catch(Exception e){}

                }
                
                //ini pengulangan proses karena refresh
                if(tran.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                    jspTransferRequestItem.addError(jspTransferRequestItem.JSP_QTY, "Document have been locked for update - current status APPROVED");
                }
               
                transferRequestItem.setTransferRequestId(oidTransfer);

                if (jspTransferRequestItem.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (transferRequestItem.getOID() == 0) {                    
                    try {
                        if(CheckItemId(transferRequestItem.getItemMasterId(),oidTransfer)){
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DATA_EXIST);
                            return RSLT_EST_CODE_EXIST;
                        }else if(transferRequestItem.getTransferRequestId()==0){
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DATA_EXIST);
                            return RSLT_EST_CODE_EXIST;
                        }
                        long oid = pstTransferRequestItem.insertExc(this.transferRequestItem);                        
                        
                        // history document
                        String strUpdate = "Insert new detail";
                        ItemMaster it = new ItemMaster();
                        try{
                            it = DbItemMaster.fetchExc(transferRequestItem.getItemMasterId());
                            strUpdate = strUpdate + " " + it.getCode() + "/" + it.getBarcode() + "-" + it.getName() + ", Qty:" + transferRequestItem.getQty();
                        }catch(Exception e){}

                        DocumentHistory his = new DocumentHistory();
                        his.setDate(new Date());
                        his.setDescription(strUpdate);
                        his.setEmployeeId(0);
                        his.setRefId(tran.getOID());
                        his.setType(DbDocumentHistory.TYPE_DOC_TRANSFER);
                        his.setUserId(this.getUserId());
                        try{
                            if(!strUpdate.equalsIgnoreCase("")){
                                DbDocumentHistory.insertExc(his);
                            }
                        }catch(Exception e){System.out.println("err history : " + e.toString());}
                        // end history

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
                        if(CheckItemIdEdit(transferRequestItem.getItemMasterId(),oidTransferItem,oidTransfer)){
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_DATA_EXIST);
                            return RSLT_EST_CODE_EXIST;
                        }                  
                        long oid = pstTransferRequestItem.updateExc(this.transferRequestItem);
                        if(oid!=0){
                            
                            //== history document
                            String strUpdate = "";

                            if(transferItemOld.getItemMasterId()!=transferRequestItem.getItemMasterId() || transferItemOld.getQty()!=transferRequestItem.getQty()){
                                try{
                                    if(strUpdate.length()>0){strUpdate = strUpdate + "; ";}

                                    ItemMaster itemOld = new ItemMaster();
                                    ItemMaster itemNew = new ItemMaster();

                                    try{
                                        itemOld = DbItemMaster.fetchExc(transferItemOld.getItemMasterId());
                                    }catch(Exception e){System.out.println("err itmOld:" + e.toString());}

                                    try{
                                        itemNew = DbItemMaster.fetchExc(transferRequestItem.getItemMasterId());
                                    }catch(Exception e){System.out.println("err itmNew:" + e.toString());}

                                    if(transferItemOld.getItemMasterId()!=transferRequestItem.getItemMasterId()){
                                        if(strUpdate.length()>0){strUpdate = strUpdate + "; ";}
                                        strUpdate = strUpdate + "  Item updated from: " + itemOld.getCode()+ " - " + itemOld.getName() + " qty : "+ transferItemOld.getQty() + "=>" + itemNew.getCode()+ "-" + itemNew.getName() + "; Qty:" + transferRequestItem.getQty();
                                    }else if(transferItemOld.getQty()!=transferRequestItem.getQty()){
                                        if(strUpdate.length()>0){strUpdate = strUpdate + "; ";}
                                        strUpdate = strUpdate + "  Item : " + itemNew.getCode()+ "-" + itemNew.getName() + ", Qty updated from: " + transferItemOld.getQty() + " -> " + transferRequestItem.getQty();
                                    }

                                }catch(Exception e){
                                    System.out.println("err history detail : " + e.toString());
                                }
                            }


                            DocumentHistory his = new DocumentHistory();
                            his.setDate(new Date());
                            his.setDescription(strUpdate);
                            his.setEmployeeId(0);
                            his.setRefId(tran.getOID());
                            his.setType(DbDocumentHistory.TYPE_DOC_TRANSFER);
                            his.setUserId(this.getUserId());
                            try{
                                if(!strUpdate.equalsIgnoreCase("")){
                                    DbDocumentHistory.insertExc(his);
                                }
                            }catch(Exception e){System.out.println("err history : " + e.toString());}
                            // end history ====

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
                if (oidTransferItem != 0) {
                    try {
                        transferRequestItem = DbTransferRequestItem.fetchExc(oidTransferItem);
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
                        transferRequestItem = DbTransferRequestItem.fetchExc(oidTransferItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                jspTransferRequestItem.requestEntityObject(transferRequestItem);
                break;    
                

            case JSPCommand.ASK:
                if (oidTransferItem != 0) {
                    try {
                        transferRequestItem = DbTransferRequestItem.fetchExc(oidTransferItem);
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
                        
                        tran = new TransferRequest();
                        try{
                            tran= DbTransferRequest.fetchExc(oidTransfer);
                        }catch(Exception ex){
                        }
                        //ini pengulangan proses karena refresh
                        if(tran.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                            jspTransferRequestItem.addError(jspTransferRequestItem.JSP_QTY, "Document have been locked for update - current status APPROVED");
                            msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                            return RSLT_FORM_INCOMPLETE;
                        }   

                        // history doc
                        String strUpdate="";
                        try{
                            if(strUpdate.length()>0){strUpdate = strUpdate + "; ";}
                            TransferRequestItem transferItemx = DbTransferRequestItem.fetchExc(oidTransferItem);
                            ItemMaster itemMaster = DbItemMaster.fetchExc(transferItemx.getItemMasterId());
                            strUpdate = strUpdate + "  Item deleted: " + itemMaster.getCode() + "-" + itemMaster.getName() + " Qty:" + transferItemx.getQty();
                        }catch(Exception e){System.out.println("err:" + e.toString());}
                        // end history doc

                        long oid = DbTransferRequestItem.deleteExc(oidTransferItem);
                      
                        if (oid != 0) {
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                            excCode = RSLT_OK;

                            // history doc
                            DocumentHistory his = new DocumentHistory();
                            his.setDate(new Date());
                            his.setDescription(strUpdate);
                            his.setEmployeeId(0);
                            his.setRefId(tran.getOID());
                            his.setType(DbDocumentHistory.TYPE_DOC_TRANSFER);
                            his.setUserId(this.getUserId());
                            try{
                                if(!strUpdate.equalsIgnoreCase("")){
                                    DbDocumentHistory.insertExc(his);
                                }
                            }catch(Exception e){System.out.println("err history : " + e.toString());}
                            // end history

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

    /**
     * @return the userId
     */
    public long getUserId() {
        return userId;
    }

    /**
     * @param userId the userId to set
     */
    public void setUserId(long userId) {
        this.userId = userId;
    }

}
