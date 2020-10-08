/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import com.project.ccs.posmaster.DbItemCategory; 
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbPriceType;
import com.project.ccs.posmaster.DbVendorItem;
import com.project.ccs.posmaster.VendorItem;
import com.project.ccs.postransaction.promotion.DbPromotion;
import com.project.ccs.postransaction.promotion.DbPromotionItem;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.general.DbLocation;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.DateCalc;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

public class SessStockCardByDate {
    
   public static double getItemTotalStock(long locationId, long itemOID, String tgl){
            
            String sql = " select sum(qty*in_out)" +
                         " from pos_stock where item_master_id= "+itemOID +
                         " and location_id=" + locationId + " and type_item=0 and to_days(date)<=to_days('"+tgl+"')";
            double result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
     
     public static double getItemTotalStockByDate(long locationId, long itemOID,String status, String tgl){
            
            String sql = " select sum(qty*in_out)" +
                         " from pos_stock where item_master_id= "+itemOID +
                         " and location_id=" + locationId + " and status='"+status+"' and type_item=0 and to_days(date)<=to_days('"+tgl+"')";
            
            double result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }

}
