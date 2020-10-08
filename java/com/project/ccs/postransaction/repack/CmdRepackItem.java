package com.project.ccs.postransaction.repack;

import com.project.I_Project;
import java.sql.*;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbRecipe;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.posmaster.Recipe;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.util.jsp.*;
import com.project.main.entity.*;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.main.db.*;

public class CmdRepackItem extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private RepackItem repackItem;
    private DbRepackItem pstRepackItem;
    private JspRepackItem jspRepackItem;
    int language = LANGUAGE_DEFAULT;

    public CmdRepackItem(HttpServletRequest request) {
        msgString = "";
        repackItem = new RepackItem();
        try {
            pstRepackItem = new DbRepackItem(0);
        } catch (Exception e) {
            ;
        }
        jspRepackItem = new JspRepackItem(request, repackItem);
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

    public RepackItem getRepackItem() {
        return repackItem;
    }

    public JspRepackItem getForm() {
        return jspRepackItem;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidRepackItem, long oidRepack, int qtyStockCode) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.ACTIVATE:
                break;

            case JSPCommand.SAVE:
                
                Repack repack = new Repack();
                
                if (oidRepackItem != 0) {                    
                    try{
                        repackItem = DbRepackItem.fetchExc(oidRepackItem);                        
                    } catch (Exception exc) {
                    }
                }
                
                if(oidRepack!=0){
                    try {
                        repack = DbRepack.fetchExc(oidRepack);  
                    } catch (Exception exc) {
                    }
                }
                
                jspRepackItem.requestEntityObject(repackItem);
                repackItem.setRepackId(oidRepack);

                if(repackItem.getRepackId()==0){
                    jspRepackItem.addError(jspRepackItem.JSP_QTY_STOCK, "failed to save main data");
                }
                
                if(repackItem.getType()==0){
                    if(repackItem.getQtyStock() < repackItem.getQty()){
                        jspRepackItem.addError(jspRepackItem.JSP_QTY_STOCK, "stock less than input qty");
                    }
                }
                //jika output, check jika ada yg sudah ada - ga perlu
                //else{
                    //if(repackItem.getOID()==0){
                    //    if(DbRepackItem.getCount("repack_id="+repackItem.getRepackId()+" and type=1")>0){
                    //        jspRepackItem.addError(jspRepackItem.JSP_TYPE, "Maximum one output allowed in this repackaging");
                    //    }
                    //}
                //}
                
                //add update item hanya boleh saat draft
                if(!repack.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){
                    jspRepackItem.addError(jspRepackItem.JSP_QTY, "Error, document have been locked for update");
                }
                
                if(getTotalOutputPercent(oidRepack, oidRepackItem, repackItem.getPercentCogs())>100){
                    jspRepackItem.addError(jspRepackItem.JSP_PERCENT_COGS, "Total output limit is 100%");
                }
                
                if (jspRepackItem.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }
                
                
                if (repackItem.getOID() == 0) {
                    try {
                        ItemMaster im = new ItemMaster();
                        try {
                            im = DbItemMaster.fetchExc(this.repackItem.getItemMasterId());
                        } catch (Exception ex) {}
                        this.repackItem.setCogs(im.getCogs());                        
                        long oid = pstRepackItem.insertExc(this.repackItem);
                        
                        if(oid!=0){
                            recalculateOutputCogs(repackItem.getRepackId());
                        }
                        
                        if (oid != 0 && im.getNeedBom() == 1 && false) {
                            Vector vbom = new Vector();
                            vbom = DbRecipe.list(0, 0, DbRecipe.colNames[DbRecipe.COL_ITEM_MASTER_ID]+" = " + im.getOID(), "");
                            if (vbom.size() > 0) {
                                for (int i = 0; i < vbom.size(); i++) {
                                    Recipe bom = (Recipe) vbom.get(i);
                                    RepackItem rebom = new RepackItem();
                                    rebom.setItemMasterId(bom.getItemRecipeId());
                                    rebom.setQty((bom.getQty() * this.repackItem.getQty()));
                                    rebom.setRepackId(oidRepack);
                                    rebom.setType(0);
                                    long oidrebom = pstRepackItem.insertExc(rebom);
                                }
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

                } else {
                    try {
                        ItemMaster im = new ItemMaster();
                        try {
                            im = DbItemMaster.fetchExc(this.repackItem.getItemMasterId());
                        } catch (Exception ex) {}
                        this.repackItem.setCogs(im.getCogs());                        
                        long oid = pstRepackItem.updateExc(this.repackItem); 
                        
                        if(oid!=0){
                            recalculateOutputCogs(repackItem.getRepackId());
                        }
                        
                        if (oid != 0 && im.getNeedBom() == 1 && false) {
                            Vector vbom = new Vector();
                            vbom = DbRecipe.list(0, 0, "item_master_id=" + im.getOID(), "");
                            if (vbom.size() > 0) {
                                for (int i = 0; i < vbom.size(); i++) {
                                    Vector vItem = new Vector();
                                    Recipe bom = (Recipe) vbom.get(i);
                                    vItem = DbRepackItem.list(0, 0, "item_master_id=" + bom.getItemRecipeId() + " and repack_id=" + oidRepack, "");
                                    RepackItem rebom = new RepackItem();
                                    rebom = (RepackItem) vItem.get(0);
                                    rebom.setQty((bom.getQty() * this.repackItem.getQty()));
                                    long oidrebom = pstRepackItem.updateExc(rebom);
                                }
                            }
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
                if (oidRepackItem != 0) {
                    try {
                        repackItem = DbRepackItem.fetchExc(oidRepackItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidRepackItem != 0) {
                    try {
                        repackItem = DbRepackItem.fetchExc(oidRepackItem);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;


            case JSPCommand.DELETE:
                if (oidRepackItem != 0) {
                    try {
                        RepackItem ri = new RepackItem();
                        try {
                            ri = DbRepackItem.fetchExc(oidRepackItem);
                        } catch (Exception ex) {}

                        ItemMaster im = new ItemMaster();
                        try {
                            im = DbItemMaster.fetchExc(ri.getItemMasterId());
                        } catch (Exception ex) {}

                        long oid = DbRepackItem.deleteExc(oidRepackItem);
                        DbStock.delete(DbRepackItem.colNames[DbRepackItem.COL_REPACK_ITEM_ID] + "=" + oid);
                        //kalkulasi ulang cogs output
                        recalculateOutputCogs(ri.getRepackId());
                        
                        if (im.getNeedBom() == 1 && false) {
                            Vector vbom = new Vector();
                            vbom = DbRecipe.list(0, 0, "item_master_id=" + im.getOID(), "");
                            if (vbom.size() > 0) {
                                for (int i = 0; i < vbom.size(); i++) {
                                    Vector vItem = new Vector();
                                    Recipe bom = (Recipe) vbom.get(i);
                                    vItem = DbRepackItem.list(0, 0, "item_master_id=" + bom.getItemRecipeId() + " and repack_id=" + oidRepack, "");
                                    RepackItem rebom = new RepackItem();
                                    rebom = (RepackItem) vItem.get(0);
                                    pstRepackItem.deleteExc(rebom.getOID());
                                    DbStock.delete(DbRepackItem.colNames[DbRepackItem.COL_REPACK_ITEM_ID] + "=" + rebom.getOID());
                                }
                            }
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
    
    public static double getTotalOutputPercent(long oidRepack, long oidRepackItem, double percentCogs){
        //ambil total input cogs
        String sql = "select sum(percent_cogs) from pos_repack_item where repack_id="+oidRepack+" and type=1";
        if(oidRepackItem!=0){
            sql = sql +" and repack_item_id<>"+oidRepackItem;
        }
        CONResultSet dbrs = null;
        double amount = 0;
        try {
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                amount = rs.getDouble(1);
            }

            rs.close();

        } catch (Exception e){

        } finally{
            CONResultSet.close(dbrs);
        }
        
        return (amount + percentCogs);
    }
    
    public static void recalculateOutputCogs(long repackId){
        //ambil total input cogs
        String sql = "select sum(qty*cogs) from pos_repack_item where repack_id="+repackId+" and type=0";
        CONResultSet dbrs = null;
        double amount = 0;
        try {
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                amount = rs.getDouble(1);
            }

            rs.close();

        } catch (Exception e){

        } finally{
            CONResultSet.close(dbrs);
        }
        
        //ambil output
        RepackItem ri = new RepackItem();
        Vector temp = DbRepackItem.list(0, 0, "repack_id="+repackId+" and type=1", "");
        if(temp!=null && temp.size()>0){
            for(int i=0; i<temp.size(); i++){
                ri = (RepackItem)temp.get(i);
                //update output
                try{
                    ri.setCogs((amount * ri.getPercentCogs() * 0.01)/ri.getQty());
                    DbRepackItem.updateExc(ri);
                }
                catch(Exception e){

                }

            }
        }
        
        
        
    }
    
}
