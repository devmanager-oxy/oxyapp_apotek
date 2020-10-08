/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.system.*;
import com.project.util.*;
import com.project.fms.master.*;
import com.project.fms.*;
import com.project.*;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.DbReceiveItem;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.receiving.ReceiveItem;

/**
 *
 * @author Roy
 */
public class SessMemorial {

      
    public static void saveAllDetailBudget(BudgetRequest budgetRequest,Receive receive, Vector listBudgetRequestDetail,long userId) {
        long itemId = 0;
        long oidUom = 0;
        try{
            itemId = Long.parseLong(DbSystemProperty.getValueByName("OID_ITEM_MEMO"));
        }catch(Exception e){}
        try {
            oidUom = Long.parseLong(DbSystemProperty.getValueByName("OID_UOM_MEMO"));
        } catch (Exception e) {
        }
        double total = 0;
        if (listBudgetRequestDetail != null && listBudgetRequestDetail.size() > 0) {
            for (int i = 0; i < listBudgetRequestDetail.size(); i++) {
                BudgetRequestDetail brd = (BudgetRequestDetail)listBudgetRequestDetail.get(i);
                
                ReceiveItem ri = new ReceiveItem();                
                ri.setReceiveId(receive.getOID());
                ri.setDeliveryDate(new Date());
                ri.setTotalDiscount(0);
                ri.setApCoaId(brd.getCoaId());
                ri.setIsBonus(DbReceiveItem.NON_BONUS);
                ri.setQty(1);
                ri.setAmount(brd.getRequest());
                ri.setTotalAmount(brd.getRequest());
                ri.setItemMasterId(itemId);
                ri.setMemo(brd.getMemo());
                ri.setUomId(oidUom);
                ri.setPurchaseItemId(0);
                ri.setExpiredDate(new Date());
                ri.setType(0);     
                total = total + brd.getRequest();

                try {
                    boolean insert = getUniqDetail(ri);
                    if(insert){
                        DbReceiveItem.insertExc(ri);
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
        }
        
        updateTotalAmount(receive.getOID(),total);
        
        DbBudgetRequest.updatePosted(userId,budgetRequest.getOID(),DbBudgetRequest.PAYMENT_TYPE_RECEIVABLE,receive.getOID());
        DbReceive.postJournalAPMemo(receive,userId);
        
    }
    
    public static void updateTotalAmount(long oid,double total) {
        if (oid != 0) {
            CONResultSet dbrs = null;

            try {
                String sql = "update " + DbReceive.DB_RECEIVE + " set "+DbReceive.colNames[DbReceive.COL_TOTAL_AMOUNT]+" = "+total+
                        " where " +DbReceive.colNames[DbReceive.COL_RECEIVE_ID] + " = " + oid;
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            } finally {
                CONResultSet.close(dbrs);
            }
        }
    }
    
    
    public static boolean getUniqDetail(ReceiveItem ri){
        CONResultSet crs = null;
        try{
            String sql = "select "+DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID]+" from "+DbReceiveItem.DB_RECEIVE_ITEM+" where "+
                    DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+" = "+ri.getReceiveId()+" and "+
                    DbReceiveItem.colNames[DbReceiveItem.COL_AP_COA_ID]+" = "+ri.getApCoaId()+" and "+
                    DbReceiveItem.colNames[DbReceiveItem.COL_AMOUNT]+" = "+ri.getAmount()+" and "+
                    DbReceiveItem.colNames[DbReceiveItem.COL_MEMO]+" = '"+ri.getMemo()+"' ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            long oid = 0;
            while(rs.next()){
                oid = rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID]);
            }
            if(oid == 0){
                return true;
            }
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        
        return false;
    }
    
}
