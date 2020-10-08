/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.request;

import com.project.I_Project;
import com.project.ccs.postransaction.purchase.DbPurchase;
import com.project.ccs.postransaction.purchase.DbPurchaseItem;
import com.project.ccs.postransaction.purchase.Purchase;
import com.project.ccs.postransaction.purchase.PurchaseItem;
import com.project.general.DbLocation;
import com.project.general.Location;
import java.util.Vector;
import com.project.main.db.*;
import java.sql.*;
 
/**
 *
 * @author Adnyana Eka Yasa
 */
public class SessRequest {

    public static Vector insertDataPrToPo(Vector list, long userOid, long prOid) {
        Vector listresult = new Vector();
        if (list != null && list.size() > 0) {
            Vector locations = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_TYPE] + "='" + DbLocation.TYPE_WAREHOUSE + "'", "code");
            Location d = new Location();
            if (locations != null && locations.size() > 0) {
                d = (Location) locations.get(0);
            }

            for (int k = 0; k < list.size(); k++) {
                Vector listmain = (Vector) list.get(k);
                Purchase purchase = (Purchase) listmain.get(0);
                purchase.setLocationId(d.getOID());
                purchase.setUserId(userOid);
                int ctr = DbPurchase.getNextCounter();
                purchase.setCounter(ctr);

                purchase.setPrefixNumber(DbPurchase.getNumberPrefix());
                purchase.setNumber(DbPurchase.getNextNumber(ctr));

                long oidPurchase = 0;
                try {
                    oidPurchase = DbPurchase.insertExc(purchase);
                    purchase.setOID(oidPurchase);
                    listresult.add(purchase);
                } catch (Exception e) {
                }
                Vector listitem = (Vector) listmain.get(1);
                if (listitem != null && listitem.size() > 0) {
                    for (int i = 0; i < listitem.size(); i++) {
                        PurchaseItem purchaseItem = (PurchaseItem) listitem.get(i);
                        purchaseItem.setPurchaseId(oidPurchase);
                        try {
                            DbPurchaseItem.insertExc(purchaseItem);
                        } catch (Exception de) {
                        }
                    }

                    // Update total purchase
                    double total = DbPurchaseItem.getTotalPurchaseAmount(oidPurchase);
                    purchase.setTotalAmount(total);
                    try {
                        DbPurchase.updateExc(purchase);
                    } catch (Exception de) {
                    }
                }
            }
            
            // update status pr
            CONResultSet crs = null;
            try{
                PurchaseRequest pr = new PurchaseRequest();
                pr = DbPurchaseRequest.fetchExc(prOid);
                
                String sql = " select sum("+DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_QTY]+"), "+
                             " sum("+DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PROCESS_QTY]+") " +
                             " from "+DbPurchaseRequestItem.DB_PURCHASE_REQUEST_ITEM+
                             " where "+DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID]+"="+prOid;
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                
                boolean bo = false;
                
                while(rs.next()){
                    int qty1 = rs.getInt(1);
                    int qty2 = rs.getInt(2);
                    if(qty1==qty2){
                        bo = true;
                    }
                }
                
                //boolean status = DbPurchaseRequestItem.checkPrToPOReadyClosed(userOid);
                if(bo){
                    pr.setStatus(I_Project.DOC_STATUS_CLOSE);
                    DbPurchaseRequest.updateExc(pr);
                }
                
            }catch(Exception e){
                
            }
            finally{
                CONResultSet.close(crs);
            }
            
        }
        return listresult;
    }
    
    
    public static Vector getPendingRequest(int start, int recordToGet){
        String sql = " select * from "+DbPurchaseRequest.DB_PURCHASE_REQUEST+
                     " pr inner join "+DbPurchaseRequestItem.DB_PURCHASE_REQUEST_ITEM+" pi "+
                     " on pi."+DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID]+
                     " = pr."+DbPurchaseRequest.colNames[DbPurchaseRequest.COL_PURCHASE_REQUEST_ID]+
                     " where pi."+DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_ITEM_STATUS]+"="+DbPurchaseRequestItem.STATUS_PENDING;
        
                     if(recordToGet>0){
                         sql = sql + " limit "+start+","+recordToGet;
                     }
        
        Vector result = new Vector();
        CONResultSet crs = null;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                PurchaseRequest pr = new PurchaseRequest();
                PurchaseRequestItem pi = new PurchaseRequestItem();
                
                DbPurchaseRequest.resultToObject(rs, pr);
                DbPurchaseRequestItem.resultToObject(rs, pi);
                
                Vector v = new Vector();
                v.add(pr);
                v.add(pi);
                
                result.add(v);
                
            }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
    }
    
    
    public static int getCountPending(){
        String sql = " select count(pr."+DbPurchaseRequest.colNames[DbPurchaseRequest.COL_PURCHASE_REQUEST_ID]+") from "+DbPurchaseRequest.DB_PURCHASE_REQUEST+
                     " pr inner join "+DbPurchaseRequestItem.DB_PURCHASE_REQUEST_ITEM+" pi "+
                     " on pi."+DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID]+
                     " = pr."+DbPurchaseRequest.colNames[DbPurchaseRequest.COL_PURCHASE_REQUEST_ID]+
                     " where pi."+DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_ITEM_STATUS]+"="+DbPurchaseRequestItem.STATUS_PENDING;
        
        int result = 0;
        CONResultSet crs = null;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){                
                result = rs.getInt(1);
            }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
    }
    
    
}
