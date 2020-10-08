/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbVendorItem;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.postransaction.sales.DbSalesDetail;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Hashtable;

/**
 *
 * @author Roy Andika
 */
public class SessReportInventory {

    public static Hashtable inventoryReport(Date end, long locationId) {        
        CONResultSet crs = null;
        try {

            String sql = "select " + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " as item_id,sum(" + DbStock.colNames[DbStock.COL_QTY] + " * " + DbStock.colNames[DbStock.COL_IN_OUT] + ") as tot from " +
                    DbStock.DB_POS_STOCK + " where to_days(" + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "') ";

            if (locationId != 0) {
                sql = sql + " and " + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
            }

            sql = sql + " group by " + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Hashtable hIS = new Hashtable();

            while (rs.next()) {
                InventoryStock is = new InventoryStock();
                long imId = rs.getLong("item_id");
                is.setItemMasterId(imId);
                is.setStock(rs.getDouble("tot"));
                hIS.put(""+imId, is);
            }
            rs.close();
            return hIS;            
        } catch (Exception e) {
        }finally{
            CONResultSet.close(crs);
        }

        return null;
    }
    
    
    public static double getPrice(Date end,long itemId){
        CONResultSet crs = null;
        try{
            String sql = "select "+DbVendorItem.colNames[DbVendorItem.COL_LAST_PRICE]+" from "+DbVendorItem.DB_VENDOR_ITEM+" where "+
                    DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+" = "+itemId+" and ( to_days("+DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE]+") <= to_days('"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"') "+
                    " or "+DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE]+" is NULL ) order by "+DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE]+" desc limit 0,1";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                return rs.getDouble(DbVendorItem.colNames[DbVendorItem.COL_LAST_PRICE]);
            }
            rs.close();
            
        }catch(Exception e){}
        finally{
            CONResultSet.close(crs);
        }
        return 0;
    }
    
    
    public static Hashtable getBegining(Date startDate){
        CONResultSet crs = null;
        Hashtable hashResult = new Hashtable();
        
        try{                        
            String sql = "select item_id,name,tot from ( "+
                " select m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as item_id," +
                " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as name," +
                " sum(s."+DbStock.colNames[DbStock.COL_QTY]+" * s."+DbStock.colNames[DbStock.COL_IN_OUT]+") as tot from "+
                " "+DbStock.DB_POS_STOCK+" s inner join "+DbItemMaster.DB_ITEM_MASTER+" m on s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " where to_days(s."+DbStock.colNames[DbStock.COL_DATE]+") < to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+
                " and s."+DbStock.colNames[DbStock.COL_TYPE] + " in (" + DbStock.TYPE_INCOMING_GOODS + "," + DbStock.TYPE_SALES + "," + DbStock.TYPE_TRANSFER + "," + DbStock.TYPE_TRANSFER_IN + "," + DbStock.TYPE_RETUR_GOODS + "," + DbStock.TYPE_ADJUSTMENT + "," + DbStock.TYPE_OPNAME +") "+ 
                "') "+
                " group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" ) as x where tot > 0 ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                long itemId = rs.getLong("item_id");
                double price = getPrice(startDate,itemId);
                hashResult.put(""+itemId, ""+price);
            }
            rs.close();
            
            return hashResult;
            
        }catch(Exception e){
            
        }finally{
            CONResultSet.close(crs);
        }      
        return null;
    }
    
    public static double beginingGroup(Date startDate,Hashtable listPrice,long groupId,long locationId){
        
        CONResultSet crs = null;        
        double total = 0;
        
        try{                        
            String sql = " select m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as item_id," +
                " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as name," +
                " sum(s."+DbStock.colNames[DbStock.COL_QTY]+" * s."+DbStock.colNames[DbStock.COL_IN_OUT]+") as tot from "+
                " "+DbStock.DB_POS_STOCK+" s inner join "+DbItemMaster.DB_ITEM_MASTER+" m on s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " where to_days(s."+DbStock.colNames[DbStock.COL_DATE]+") < to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') and "+
                " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = "+ groupId+" and "+
                " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+" = "+locationId+
                " and s."+DbStock.colNames[DbStock.COL_TYPE] + " in (" + DbStock.TYPE_INCOMING_GOODS + "," + DbStock.TYPE_SALES + "," + DbStock.TYPE_TRANSFER + "," + DbStock.TYPE_TRANSFER_IN + "," + DbStock.TYPE_RETUR_GOODS + "," + DbStock.TYPE_ADJUSTMENT + "," + DbStock.TYPE_OPNAME +") "+ 
                " group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                long itemId = rs.getLong("item_id");                
                double stock = rs.getDouble("tot");
                
                double price = 0;
                try{
                    price = Double.parseDouble(""+listPrice.get(""+itemId));
                }catch(Exception e){}
                total = total + (stock * price);
                
            }
            rs.close();
            
            return total;
            
        }catch(Exception e){
            
        }finally{
            CONResultSet.close(crs);
        }      
        return 0;
    }
    
    
     public static double beginingItem(Date startDate,long itemMasterId,long locationId){
        
        CONResultSet crs = null;        
        
        try{                        
            String sql = " select m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as item_id," +
                " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as name," +
                " sum(s."+DbStock.colNames[DbStock.COL_QTY]+" * s."+DbStock.colNames[DbStock.COL_IN_OUT]+") as tot from "+
                " "+DbStock.DB_POS_STOCK+" s inner join "+DbItemMaster.DB_ITEM_MASTER+" m on s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " where to_days(s."+DbStock.colNames[DbStock.COL_DATE]+") < to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') and "+
                " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = "+ itemMasterId+" and "+
                " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+" = "+locationId+
                " and s."+DbStock.colNames[DbStock.COL_TYPE] + " in (" + DbStock.TYPE_INCOMING_GOODS + "," + DbStock.TYPE_SALES + "," + DbStock.TYPE_TRANSFER + "," + DbStock.TYPE_TRANSFER_IN + "," + DbStock.TYPE_RETUR_GOODS + "," + DbStock.TYPE_ADJUSTMENT + "," + DbStock.TYPE_OPNAME +") "+ 
                " group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {                
                double stock = rs.getDouble("tot");                
                return stock;
            }
            rs.close();
            
        }catch(Exception e){
            
        }finally{
            CONResultSet.close(crs);
        }      
        return 0;
    }
    
    
    
    public static Hashtable amountSales(long locationId,String itemGroupId,Date start,Date end){
        
        CONResultSet crs = null; 
        Hashtable result = new Hashtable();
        
        try{
            
            String sql = "select im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" as item_group_id,sum((sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SELLING_PRICE]+") - sd."+DbSalesDetail.colNames[DbSalesDetail.COL_DISCOUNT_AMOUNT]+" ) as total," +
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+" * sd."+DbSalesDetail.colNames[DbSalesDetail.COL_COGS]+") as cogs "+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" im on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " where s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") >= to_days('"+JSPFormater.formatDate(start, "yyyy-MM-dd")+"') and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") <= to_days('"+JSPFormater.formatDate(end, "yyyy-MM-dd")+"') and "+
                    " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" in ("+itemGroupId +") group by im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];
                    
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                long groupId = rs.getLong("item_group_id");                
                double total = rs.getDouble("total");
                double cogs = rs.getDouble("cogs");
                
                InvReport iR = new InvReport();
                iR.setNetSales(total);
                iR.setCogs(cogs);
                result.put(""+groupId, iR);
            }
            rs.close();        
            
            return result;
        }catch(Exception e){}
        
        return null;
    }
    
    public static InvReport amountSales(long locationId,long itemMasterId,Date start,Date end){
        
        CONResultSet crs = null; 
        
        try{
            
            String sql = "select sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as total," +
                    " sum(sd."+DbSalesDetail.colNames[DbSalesDetail.COL_QTY]+") as cogs "+
                    " from "+
                    DbSales.DB_SALES+" s inner join "+DbSalesDetail.DB_SALES_DETAIL+" sd on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = sd."+DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID]+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" im on sd."+DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID]+" = im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " where s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId+" and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") >= to_days('"+JSPFormater.formatDate(start, "yyyy-MM-dd")+"') and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") <= to_days('"+JSPFormater.formatDate(end, "yyyy-MM-dd")+"') and "+
                    " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = "+itemMasterId;
                    
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {                             
                double total = rs.getDouble("total");
                double cogs = rs.getDouble("cogs");
                
                InvReport iR = new InvReport();
                iR.setNetSales(total);
                iR.setCogs(cogs);
                return iR;
            }
            rs.close();        
            
        }catch(Exception e){}
        
        return new InvReport();
    }
    
    public static int getPeriodDate(Date end,Date start){
        CONResultSet crs = null; 
        try{
            String sql = "select datediff('"+JSPFormater.formatDate(end, "yyyy-MM-dd")+"','"+JSPFormater.formatDate(start, "yyyy-MM-dd")+"')+1 as tot ";
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                return rs.getInt("tot");
            }
            rs.close();  
            
        }catch(Exception e){}
        finally{
            CONResultSet.close(crs);
        } 
        
        return 0;
    }
    
    
}
