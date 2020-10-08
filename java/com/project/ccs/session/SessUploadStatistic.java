/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.math.*;
import java.sql.ResultSet; 
import java.util.Vector;
import com.project.util.*;
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.stock.*;
import com.project.general.*;
import com.project.ccs.*;
import com.project.system.*;
import com.project.main.db.*;
import java.util.Date;
/**
 *
 * @author Eka Ds
 */
public class SessUploadStatistic {
    
    //eka d
    //get qty stock sesuai status
    public static double getStockByLocationByItem(long itemId, long locationId, String status){
        
        double result = 0;
        
        //String sql = "SELECT qty FROM pos_stock_view where item_master_id="+itemId+" and location_id="+locationId+" and status='"+status+"'";
        
        String sql = "select sum("+DbStock.colNames[DbStock.COL_QTY]+" * "+DbStock.colNames[DbStock.COL_IN_OUT]+") AS qty "+
            " from "+DbStock.DB_POS_STOCK;
            
            String where = "";
            
            if(locationId!=0){
                where = DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+locationId;
            }
            
            if(itemId!=0){
                if(where.length()>0){
                    where = where + " and ";
                }
                
                where = where + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+"="+itemId;
            }
            
            if(status!=null && status.length()>0){
                
                if(where.length()>0){
                    where = where + " and ";
                }
                
                where = where + DbStock.colNames[DbStock.COL_STATUS]+"='"+status+"'";            
            }
            
        if(where.length()>0){
            sql = sql + " where "+where;        
        }    
            
            
        System.out.println(sql);     
        
        CONResultSet crs = null;
        try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    
    public static Hashtable getStockByLocationByItem(long itemId, String where){
        
        Hashtable result = new Hashtable();
        
        String sql = "SELECT * FROM pos_stock_view where item_master_id="+itemId+" and "+where;
        
        System.out.println(sql); 
        long oid = 0;
        double qty = 0;
        
        CONResultSet crs = null;
        try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    oid = rs.getLong("location_id");
                    qty = rs.getDouble("qty");
                    result.put(""+oid, ""+qty);
                }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static Hashtable getStockByLocationByItem(){
        
        Hashtable result = new Hashtable();
        
        String sql = "SELECT * FROM pos_stock_view";
        
        System.out.println(sql); 
        long oiditem = 0;
        long oidloc = 0;
        double qty = 0;
        
        CONResultSet crs = null;
        try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    oiditem = rs.getLong("item_master_id");
                    oidloc = rs.getLong("location_id");
                    qty = rs.getDouble("qty");
                    result.put(oiditem+""+oidloc, ""+qty);
                }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    //get qty sales pending
    public static double getSalesPendingLocationByItem(long itemId, long locationId){
        
        double result = 0;
        
        String sql = "SELECT qty FROM sales_pending_view where item_master_id="+itemId+" and location_id="+locationId;
        CONResultSet crs = null;
        try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
    public static Vector getStockItemList(int limitStart, int recordToGet, String whereClause, String order){
        
        Vector temp = new Vector();
        
        String sql = "SELECT item_master_id, code, barcode, name FROM pos_stock_item_view";   
        //String sql = "SELECT distinct im.* FROM pos_stock_view p "+
        //        " inner join pos_item_master im";// where im.item_master_id=p.item_master_id and p.qty<0 limit 0,20;
        //String sql = "SELECT distinct im.* FROM "+
        //        "  pos_item_master im";// where im.item_master_id=p.item_master_id and p.qty<0 limit 0,20;
        
        if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
        if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;
        if(limitStart == 0 && recordToGet == 0)
                sql = sql + "";
        else
                sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
        
        System.out.println(sql);
        System.out.println("start-"+System.currentTimeMillis());
        
        CONResultSet crs = null;
        
        try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    ItemMaster im = new ItemMaster();
                    im.setOID(rs.getLong("item_master_id"));
                    im.setCode(rs.getString("code"));
                    im.setBarcode(rs.getString("barcode"));
                    im.setName(rs.getString("name"));
                    
                    temp.add(im);
                }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        System.out.println("end-"+System.currentTimeMillis());
        
        return temp;
        
    }
    
    public static int getStockItemCount(String whereClause){
        
        int temp = 0;
        
        String sql = "SELECT count(item_master_id) FROM pos_stock_item_view";
        //        " inner join pos_item_master im";   
        //String sql = "SELECT count(im.item_master_id) FROM pos_item_master im";   
        
        if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
        
        System.out.println(sql);
        System.out.println("start-"+System.currentTimeMillis());
        
        CONResultSet crs = null;
        try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    temp = rs.getInt(1);
                }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        System.out.println("end-"+System.currentTimeMillis());
        
        return temp;
        
    }
    
    public static double getAkumulasiStockMin(long itemMasterId) {
        CONResultSet dbrs = null;
        try {
            String sql = "select sum("+DbStockMin.colNames[DbStockMin.COL_MIN_STOCK]+") as jum from "+DbStockMin.DB_STOCK_MIN+
                    " where "+DbStockMin.colNames[DbStockMin.COL_ITEM_MASTER_ID]+"=" + itemMasterId;
                  
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double count = 0;
            while (rs.next()) {
                count = rs.getInt("jum");
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static boolean isPoNeedReview(long oidItem, double poQty){
        
        double currStock = getStockByLocationByItem(oidItem, 0, "");
        
        System.out.println("in review method");
        System.out.println("oidItem : "+oidItem);
        System.out.println("currStock : "+currStock+", poQty : "+poQty);
        
        Vector temp = DbStockMax.list(0,1, DbStockMax.colNames[DbStockMax.COL_ITEM_MASTER_ID]+"="+oidItem, "");
        if(temp!=null && temp.size()>0){
            StockMax sm = (StockMax)temp.get(0);
            
            System.out.println("sm.getMaxStock() : "+sm.getMaxStock()+", poQty+currStock : "+(poQty+currStock));
            
            if(sm.getMaxStock()>0){
                if(currStock+poQty > sm.getMaxStock()){
                    return true;
                }
            }
            
        }
        
        return false;
    }
    
   public static double getTotalRecordSales(long locationId, Date dt){
            
            String sql = " select count(sd.sales_detail_id) from pos_sales_detail sd inner join pos_sales" + 
                   " s on sd.sales_id=s.sales_id inner join pos_item_master im on sd.product_master_id=im.item_master_id " +
                   " where im.is_service <> 1 and to_days(s.date) = to_days('" +  JSPFormater.formatDate(dt,"yyyy-MM-dd")+"') and s.location_id="+ locationId ; 
                   
            
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
   public static double getTotalStockSales(long locationId, Date dt){
            
            String sql = " select count(sd.stock_id) from pos_stock sd inner join pos_sales" + 
                   " s on sd.opname_id=s.sales_id where to_days(s.date) = to_days('" +  JSPFormater.formatDate(dt,"yyyy-MM-dd")+"') and s.location_id="+ locationId  ;
                    
                         
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
