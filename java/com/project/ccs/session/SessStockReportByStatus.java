/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import com.project.ccs.report.*;
import com.project.general.DbVendor; 
import com.project.general.Vendor;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.sql.ResultSet;
import java.util.Vector;
import java.util.Date;
import com.project.general.DbLocation;
import com.project.general.Location;
import com.project.ccs.postransaction.stock.*;
import com.project.ccs.posmaster.*;

/**
 *
 * @author Adnyana Eka Yasa
 */
public class SessStockReportByStatus {

    public static Vector getStockByLocation(long oidLocation, int groupBy) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "select im.code, im.name, sum(st.qty*st.in_out) as total_qty, im.cogs, sum(st.qty*st.in_out*im.cogs) as amounth from pos_stock as st "+
                         "inner join pos_item_master as im on st.item_master_id = im.item_master_id "+
                         "inner join pos_item_group as ig on im.item_group_id = ig.item_group_id "+
                         "inner join pos_item_category as ic on im.item_category_id = ic.item_category_id ";

            String where = ""; 
            if(oidLocation!=0){
                where = "st.location_id = "+oidLocation;
            }

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;
            
            sql = sql + " group by ";

            switch(groupBy){
                case 0:
                    sql = sql + "st.item_master_id ";
                    break;
                case 1:
                    sql = sql + "im.item_group_id ";
                    break;
                case 2:
                    sql = sql + "im.item_category_id ";
                    break;
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                /*
                Stock stock = new Stock();
                //DbStock.resultToObject(rs, stock); 
                 */
                SrcStockReportL srcReportL = new SrcStockReportL();
                
                srcReportL.setCode(rs.getString(1));
                srcReportL.setDescription(rs.getString(2));
                srcReportL.setQty(rs.getDouble(3));
                srcReportL.setPrice(rs.getDouble(4));
                srcReportL.setAmount(rs.getDouble(5));
                
                list.add(srcReportL);
            }

        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(dbrs);
        }

        return list;
    }
    public static Vector getStockByLocation(long oidLocation, int groupBy, int type) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            String sql = "select im.code, im.name, sum(st.qty*st.in_out) as total_qty, im.cogs, sum(st.qty*st.in_out*im.cogs) as amounth, st.location_id, im.item_group_id, im.item_category_id  from pos_stock as st "+
                         "inner join pos_item_master as im on st.item_master_id = im.item_master_id "+
                         "inner join pos_item_group as ig on im.item_group_id = ig.item_group_id "+
                         "inner join pos_item_category as ic on im.item_category_id = ic.item_category_id ";

            String where = ""; 
            if(oidLocation!=0){
                where = "st.location_id = "+oidLocation;
            }
            if(where.length()>0){
                where = where + " and st." + DbStock.colNames[DbStock.COL_TYPE_ITEM] + "=" + type;
            }else{
                where = "st." + DbStock.colNames[DbStock.COL_TYPE_ITEM] + "=" + type;
            }
                

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;
            
            sql = sql + " group by ";

            switch(groupBy){
                case 0:
                    sql = sql + "st.item_master_id ";
                    break;
                case 1:
                    sql = sql + "im.item_group_id ";
                    break;
                case 2:
                    sql = sql + "im.item_category_id ";
                    break;
            }

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                /*
                Stock stock = new Stock();
                //DbStock.resultToObject(rs, stock); 
           
                 */
                SrcStockReportL srcReportL = new SrcStockReportL();
                
                srcReportL.setCode(rs.getString(1));
                if(groupBy==1){
                    try{
                        ItemGroup ig = DbItemGroup.fetchExc(rs.getLong(7));
                        srcReportL.setDescription(ig.getName());
                    }catch(Exception e){
                        
                    }
                    
                }else if(groupBy==2){
                    try{
                        ItemCategory ic = DbItemCategory.fetchExc(rs.getLong(8));
                        srcReportL.setDescription(ic.getName());
                    }catch(Exception e){
                        
                    }
                    
                }else{
                    srcReportL.setDescription(rs.getString(2));
                }
                
                srcReportL.setQty(rs.getDouble(3));
                //srcReportL.setPrice(rs.getDouble(4));
                //srcReportL.setAmount(rs.getDouble(5));
                try{
                    Location loc = DbLocation.fetchExc(rs.getLong(6));
                    srcReportL.setLocationName(loc.getName());
                }catch(Exception e){
                    
                }
                list.add(srcReportL);
            }

        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(dbrs);
        }

        return list;
    }
    public static Vector getStockMinimum(long oidLocation, int type, int limitStart, int recordToGet){
        CONResultSet dbrs = null;
        Vector list = new Vector();
        try {
            //String sql = "select im.code, im.name, sum(st.qty*st.in_out) as total_qty, im.cogs, im.min_stock from pos_stock as st "+
              //           "inner join pos_item_master as im on st.item_master_id = im.item_master_id "+
                //         "inner join pos_item_group as ig on im.item_group_id = ig.item_group_id "+
                  //       "inner join pos_item_category as ic on im.item_category_id = ic.item_category_id ";

            String sql ="select im.code, im.name, sum(st.qty*st.in_out) as total_qty, im.cogs, st.item_master_id, st.location_id from pos_item_master as im "+
                    "inner join pos_stock as st on im.item_master_id = st.item_master_id " ;
                    
            String where = ""; 
            if(oidLocation!=0){
                where = "st.location_id = "+oidLocation ;
            }
            if(where.length()>0){
                where = where + " and st." + DbStock.colNames[DbStock.COL_TYPE_ITEM] + "=" + type;
            }else{
                where = "st." + DbStock.colNames[DbStock.COL_TYPE_ITEM] + "=" + type;
            }
                

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;
            
            sql = sql + " group by st.item_master_id, st.location_id";
                  
            /*if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
            }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
            }*/
            
            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                /*
                Stock stock = new Stock();
                //DbStock.resultToObject(rs, stock); 
                 */
                int minStock= DbStockMin.getStockMinValue(rs.getLong(6), rs.getLong(5));               
                if(rs.getDouble(3)< minStock ){ //DbStockMin.getStockMinValue(oidLocation, rs.getDouble(5)){
                    SrcStockReportMinimum srcReportMinimum = new SrcStockReportMinimum();
                    srcReportMinimum.setCode(rs.getString(1));
                    srcReportMinimum.setDescription(rs.getString(2));
                    srcReportMinimum.setQty_system(rs.getDouble(3));
                    srcReportMinimum.setQty_minimum(minStock);
                    srcReportMinimum.setLocationId(rs.getLong(6));
                            
                    list.add(srcReportMinimum);
                }
                             
            }

        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(dbrs);
        }

        return list;
    }
    public static int getStockMinimumCount(long oidLocation, int type){
        CONResultSet dbrs = null;
        int count =0;
        try {
            //String sql = "select im.code, im.name, sum(st.qty*st.in_out) as total_qty, im.cogs, im.min_stock from pos_stock as st "+
              //           "inner join pos_item_master as im on st.item_master_id = im.item_master_id "+
                //         "inner join pos_item_group as ig on im.item_group_id = ig.item_group_id "+
                  //       "inner join pos_item_category as ic on im.item_category_id = ic.item_category_id ";

            String sql ="select sum(st.qty*st.in_out) as total_qty, st.item_master_id, st.location_id from pos_item_master as im "+
                    "inner join pos_stock as st on im.item_master_id = st.item_master_id " ;
                    
            String where = ""; 
            if(oidLocation!=0){
                where = "st.location_id = "+oidLocation ;
            }
            if(where.length()>0){
                where = where + " and st." + DbStock.colNames[DbStock.COL_TYPE_ITEM] + "=" + type;
            }else{
                where = "st." + DbStock.colNames[DbStock.COL_TYPE_ITEM] + "=" + type;
            }
                

            if(where.length()>0){
                where = " where "+where;
            }

            sql = sql + where;
            
            sql = sql + " group by st.item_master_id, st.location_id";
                  

            System.out.println("SQL : " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                
                int minStock= DbStockMin.getStockMinValue(rs.getLong(3), rs.getLong(2));               
                if(rs.getDouble(1)< minStock ){ //DbStockMin.getStockMinValue(oidLocation, rs.getDouble(5)){
                    count = count + 1;
                }
                             
            }

        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(dbrs);
        }

        return count;
    }
    
    public static Vector getItemStock(String itmCode, String itmName, long locationId, long groupId, int orderBy){
        
        String sql = "select " +
            " l."+DbLocation.colNames[DbLocation.COL_NAME]+" as loc "+
            ", g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as ig "+
            ", s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+
            ", sum(s."+DbStock.colNames[DbStock.COL_QTY]+"*s."+DbStock.colNames[DbStock.COL_IN_OUT]+") qty " +
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as price " +
            " from "+DbStock.DB_POS_STOCK+" s "+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
            " on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " inner join "+DbLocation.DB_LOCATION+" l "+
            " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
        
            String where = "";
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
            //0 = all location, 1=group by location
            if(locationId!=0 && locationId!=1){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+locationId;
            }
            
            if(groupId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = "+groupId;
            }
           
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
            
            if(locationId!=0){
                sql = sql + ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
            }
            
            sql = sql + " order by ";
            if(orderBy==0){
                sql = sql + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
            }
            else if(orderBy==1){
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE];
            }
            else if(orderBy==2){                
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
            }
            else{
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];
            }
            
            System.out.println("\n\n"+sql);
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    SrcStockReportL srcReportL = new SrcStockReportL();
                
                    srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setGroupName(rs.getString(2));
                    srcReportL.setItemMasterId(rs.getLong(3));
                    srcReportL.setLocation(rs.getLong(4));
                    srcReportL.setCode(rs.getString(5));
                    srcReportL.setDescription(rs.getString(6));
                    srcReportL.setQty(rs.getDouble(7));
                    srcReportL.setPrice(rs.getDouble(8));
                    srcReportL.setAmount(srcReportL.getQty()*srcReportL.getPrice());

                    result.add(srcReportL);
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
    public static Vector getDetailStock(String startDate, String endDate, long locationId, long itemMasterId, int type){
        String sql = "select " + DbStock.colNames[DbStock.COL_DATE] + ", " + DbStock.colNames[DbStock.COL_TYPE] +
                ", " + DbStock.colNames[DbStock.COL_QTY] + ", " + DbStock.colNames[DbStock.COL_IN_OUT] +
                ", " + DbStock.colNames[DbStock.COL_TRANSFER_ID] + 
                ", " + DbStock.colNames[DbStock.COL_INCOMING_ID] +
                ", " + DbStock.colNames[DbStock.COL_SALES_DETAIL_ID] +
                " from " + DbStock.DB_POS_STOCK + " where " + DbStock.colNames[DbStock.COL_LOCATION_ID] +
                " = " + locationId + " and " + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = " + itemMasterId +
                " and " + DbStock.colNames[DbStock.COL_TYPE_ITEM] + "=" +  type +
                " and to_days(" + DbStock.colNames[DbStock.COL_DATE] + ") between to_days('" + 
                startDate + "')" + " and to_days('" + endDate + "') order by " + DbStock.colNames[DbStock.COL_DATE] ;
                
        
         Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock srcStockCard = new Stock();
                
                    srcStockCard.setDate(rs.getDate(1));
                    srcStockCard.setType(rs.getInt(2));
                    srcStockCard.setQty(rs.getDouble(3));
                    srcStockCard.setInOut(rs.getInt(4));
                    srcStockCard.setTransferId(rs.getLong(5));
                    srcStockCard.setIncomingId(rs.getLong(6));
                    srcStockCard.setSalesDetailId(rs.getLong(7));
                    result.add(srcStockCard);
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
    
    public static Vector getItemStockCard(String itmCode, String itmName, long locationId, int type, String startDate, String endDate, int limitStart, int recordToGet){
        
        String sql = "select " +
            " l."+DbLocation.colNames[DbLocation.COL_NAME]+" as loc "+
            ", s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+
            " from "+DbStock.DB_POS_STOCK+" s "+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
            " on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " inner join "+DbLocation.DB_LOCATION+" l "+
            " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
        
            String where = "";
            
            
            
            
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            if(where.length()>0){
                where = where + " and m.is_active=1 ";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
            //0 = all location, 1=group by location
            if(locationId!=0 && locationId!=1){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+locationId;
            }
            if(where.length()>0 ){
                where = where + " and s." + DbStock.colNames[DbStock.COL_TYPE_ITEM]+ "=" + type;
            }else{
                where =DbStock.colNames[DbStock.COL_TYPE_ITEM]+ "=" + type;
            }
               
            if(where.length()>0){
                where = where + " and to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") between to_days('" + startDate + "') and to_days('" + endDate + "')";
            }else{
                where = "to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") between to_days('" + startDate + "') and to_days('" + endDate + "')";
            }
                
           
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
            
            if(locationId!=0){
                sql = sql + ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
            }
            
            if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
             }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                }
           
           
            System.out.println("\n\n"+sql);
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    SrcStockCardL srcStockCard = new SrcStockCardL();
                
                    srcStockCard.setLocationName(rs.getString(1));
                    srcStockCard.setItemMasterId(rs.getLong(2));
                    srcStockCard.setLocationId(rs.getLong(3));
                    srcStockCard.setCode(rs.getString(4));
                    srcStockCard.setItemName(rs.getString(5));
                    srcStockCard.setQtyIn(getStockQtyInOut(rs.getLong(2), rs.getLong(3), DbStock.STOCK_IN, type, startDate, endDate));
                    srcStockCard.setQtyOut(getStockQtyInOut(rs.getLong(2), rs.getLong(3), DbStock.STOCK_OUT, type, startDate, endDate));
                    srcStockCard.setOpening(getSaldoOpeningStock(rs.getLong(2), rs.getLong(3),type,startDate));
                    srcStockCard.setSaldo(srcStockCard.getQtyIn()+ srcStockCard.getOpening() + srcStockCard.getQtyOut());
                    
                    result.add(srcStockCard);
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
    public static int getItemStockCardCount(String itmCode, String itmName, long locationId, int type, String startDate, String endDate){
        
        String sql = "select s." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] +
            " from "+DbStock.DB_POS_STOCK+" s "+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
            " on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " inner join "+DbLocation.DB_LOCATION+" l "+
            " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
        
            String where = "";
            
            
            
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
            //0 = all location, 1=group by location
            if(locationId!=0 && locationId!=1){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+locationId;
            }
            if(where.length()>0 ){
                where = where + " and " + DbStock.colNames[DbStock.COL_TYPE_ITEM]+ "=" + type;
            }else{
                where =DbStock.colNames[DbStock.COL_TYPE_ITEM]+ "=" + type;
            }
               
            if(where.length()>0){
                where = where + " and to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") between to_days('" + startDate + "') and to_days('" + endDate + "')";
            }else{
                where = "to_days(s." + DbStock.colNames[DbStock.COL_DATE] + ") between to_days('" + startDate + "') and to_days('" + endDate + "')";
            }
                
           
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
            
            if(locationId!=0){
                sql = sql + ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
            }
            
                       
           
            System.out.println("\n\n"+sql);
            
            //Vector result = new Vector();
            int count=0;
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    count=count+1;
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return count;
            
    }
    public static double getStockQtyInOut(long itemMasterId, long locationId, int type, int type_item, String startDate, String endDate){
        String sql="select sum("+ DbStock.colNames[DbStock.COL_QTY ] + "*" + DbStock.colNames[DbStock.COL_IN_OUT]+ ") as jum" +
                " from " + DbStock.DB_POS_STOCK + " where " + 
                DbStock.colNames[DbStock.COL_IN_OUT]+ "=" + type + " and " + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] +
                "=" + itemMasterId + " and " + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId +
                " and " + DbStock.colNames[DbStock.COL_TYPE_ITEM] + "=" + type_item  + " and " + 
                "to_days(" + DbStock.colNames[DbStock.COL_DATE] + ") between to_days('" + startDate + "') and to_days('" + endDate + "')";
        CONResultSet crs = null;
        double jumlah =0;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    jumlah = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            return jumlah;
    }
     public static double getSaldoOpeningStock(long itemMasterId, long locationId, int type_item, String startDate){
        String sql="select sum("+ DbStock.colNames[DbStock.COL_QTY ] + "*" + DbStock.colNames[DbStock.COL_IN_OUT]+ ") as jum" +
                " from " + DbStock.DB_POS_STOCK + " where " + 
                "to_days(" + DbStock.colNames[DbStock.COL_DATE]+ ") < to_days('" + startDate + "') and " + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] +
                "=" + itemMasterId + " and " + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId +
                " and " + DbStock.colNames[DbStock.COL_TYPE_ITEM] + "=" + type_item ;
        CONResultSet crs = null;
        double jumlah =0;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    jumlah = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            return jumlah;
    }
     
    public static Vector getItemStock(String itmCode, String itmName, long locationId, long groupId, int orderBy, int type){
        
        String sql = "select " +
            " l."+DbLocation.colNames[DbLocation.COL_NAME]+" as loc "+
            ", g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as ig "+
            ", s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+
            ", sum(s."+DbStock.colNames[DbStock.COL_QTY]+"*s."+DbStock.colNames[DbStock.COL_IN_OUT]+") qty " +
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as price " +
            " from "+DbStock.DB_POS_STOCK+" s "+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
            " on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " inner join "+DbLocation.DB_LOCATION+" l "+
            " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
        
            String where = "";
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
            //0 = all location, 1=group by location
            if(locationId!=0 && locationId!=1){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+locationId;
            }
            
            if(groupId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = "+groupId;
            }
            if(where.length()>0){
                where = where + " and s."+DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }else{
                where  = "s." +DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }
            
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
            
            if(locationId!=0){
                sql = sql + ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
            }
            
            sql = sql + " order by ";
            if(orderBy==0){
                sql = sql + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
            }
            else if(orderBy==1){
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE];
            }
            else if(orderBy==2){                
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
            }
            else{
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];
            }
            
            System.out.println("\n\n"+sql);
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    SrcStockReportL srcReportL = new SrcStockReportL();
                
                    srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setGroupName(rs.getString(2));
                    srcReportL.setItemMasterId(rs.getLong(3));
                    srcReportL.setLocation(rs.getLong(4));
                    srcReportL.setCode(rs.getString(5));
                    srcReportL.setDescription(rs.getString(6));
                    srcReportL.setQty(rs.getDouble(7));
                    srcReportL.setPrice(rs.getDouble(8));
                    srcReportL.setAmount(srcReportL.getQty()*srcReportL.getPrice());

                    result.add(srcReportL);
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
    public static Vector getItemStockTransfer(long locationId, long oidItemMaster, String dt){
        
        String sql = "select t.date, t.status, t.number, t.to_location_id, t.from_location_id, ti.item_master_id, ti.qty " +
                " from pos_transfer_item ti inner join pos_transfer t on ti.transfer_id=t.transfer_id where " +
                " (t.to_location_id=" + locationId + " or t.from_location_id=" + locationId + ")" +
                " and ti.item_master_id=" + oidItemMaster + " and to_days(t.date) = to_days('"+ dt +"')";
              
            
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    StockCrdDetil srcReportL = new StockCrdDetil();
                
                    //srcReportL.setLocationName(rs.getString(1));
                     

                    result.add(srcReportL);
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
    public static Vector getItemStockIncoming(long locationId, long oidItemMaster, String dt){
        
        String sql = "select r.date, r.status, r.number, ri.item_master_id, ri.qty, r.vendor_id " +
                " from pos_receive_item ri inner join pos_receive r on ri.receive_id=r.receive_id where " +
                " r.location_id=" + locationId + " and ri.item_master_id=" + oidItemMaster + " and to_days(r.date) = to_days('"+ dt +"')";
              
            
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    StockCrdDetil srcReportL = new StockCrdDetil();
                
                    //srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setDocNumber(rs.getString(3));
                    srcReportL.setDate(rs.getDate(1));
                    srcReportL.setItemMasterId(rs.getLong(4));
                    srcReportL.setStatus(rs.getString(2));
                    srcReportL.setQtyIn(rs.getInt(5));
                    srcReportL.setType(0);
                    srcReportL.setVendorId(rs.getLong(6));
                    
                    

                    result.add(srcReportL);
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
    public static Vector getItemStockCosting(long locationId, long oidItemMaster, String dt){
        
        String sql = "select c.date, c.status, c.number, ci.item_master_id, ci.qty " +
                " from pos_costing_item ci inner join pos_costing c on ci.costing_id=c.costing_id where " +
                " c.location_id=" + locationId + " and ci.item_master_id=" + oidItemMaster + " and to_days(c.date) = to_days('"+ dt +"')";
              
            
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    StockCrdDetil srcReportL = new StockCrdDetil();
                
                    //srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setDocNumber(rs.getString(3));
                    srcReportL.setDate(rs.getDate(1));
                    srcReportL.setItemMasterId(rs.getLong(4));
                    srcReportL.setStatus(rs.getString(2));
                    srcReportL.setQtyOut(rs.getInt(5));
                    srcReportL.setType(8);
                    
                    
                    

                    result.add(srcReportL);
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
    public static Vector getItemStockOpnameAwal(long locationId, long oidItemMaster, String dt){
        
        String sql = "select c.date, c.status, c.number, ci.item_master_id, ci.qty_real " +
                " from pos_opname_item ci inner join pos_opname c on ci.opname_id=c.opname_id where " +
                " c.location_id=" + locationId + " and ci.item_master_id=" + oidItemMaster + " and to_days(c.date) = to_days('"+ dt +"')";
              
            
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    StockCrdDetil srcReportL = new StockCrdDetil();
                
                    //srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setDocNumber(rs.getString(3));
                    srcReportL.setDate(rs.getDate(1));
                    srcReportL.setItemMasterId(rs.getLong(4));
                    srcReportL.setStatus(rs.getString(2));
                    srcReportL.setQtyIn(rs.getInt(5));
                    srcReportL.setType(5);
                    
                    
                    

                    result.add(srcReportL);
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
    
    public static Vector getItemStockRepack(long locationId, long oidItemMaster, String dt){
        
        String sql = "select r.date, r.status, r.number, ri.item_master_id, ri.qty, ri.type" +
                " from pos_repack_item ri inner join pos_repack r on ri.repack_id=r.repack_id where " +
                " r.location_id=" + locationId + " and ri.item_master_id=" + oidItemMaster + " and to_days(r.date) = to_days('"+ dt +"')";
              
            
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    StockCrdDetil srcReportL = new StockCrdDetil();
                
                    //srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setDocNumber(rs.getString(3));
                    srcReportL.setDate(rs.getDate(1));
                    srcReportL.setItemMasterId(rs.getLong(4));
                    srcReportL.setStatus(rs.getString(2));
                    srcReportL.setType_repack(rs.getInt(6));
                    if(srcReportL.getType_repack()==0){
                        srcReportL.setQtyOut(rs.getInt(5));
                    }else if(srcReportL.getType_repack()==1){
                        srcReportL.setQtyIn(rs.getInt(5));
                    }
                    
                    srcReportL.setType(9);
                       

                    result.add(srcReportL);
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
    public static Vector getItemStockRetur(long locationId, long oidItemMaster, String dt){
        
        String sql = "select r.date, r.status, r.number, ri.item_master_id, ri.qty, r.vendor_id " +
                " from pos_retur_item ri inner join pos_retur r on ri.retur_id=r.retur_id where " +
                " r.location_id=" + locationId + " and ri.item_master_id=" + oidItemMaster + " and to_days(r.date) = to_days('"+ dt +"')";
              
            
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    StockCrdDetil srcReportL = new StockCrdDetil();
                
                    //srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setDocNumber(rs.getString(3));
                    srcReportL.setDate(rs.getDate(1));
                    srcReportL.setItemMasterId(rs.getLong(4));
                    srcReportL.setStatus(rs.getString(2));
                    srcReportL.setQtyOut(rs.getInt(5));
                    srcReportL.setVendorId(rs.getLong(6));
                    
                    srcReportL.setType(1);
                       

                    result.add(srcReportL);
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
    public static Vector getItemStockSales(long locationId, long oidItemMaster, String dt){
        
        String sql = "select s.date, s.number, sd.product_master_id, sd.qty " +
                " from pos_sales_detail sd inner join pos_sales s on sd.sales_id=s.sales_id where " +
                " s.location_id=" + locationId + " and sd.product_master_id=" + oidItemMaster + " and to_days(s.date) = to_days('"+ dt +"')";
              
            
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    StockCrdDetil srcReportL = new StockCrdDetil();
                
                    //srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setDocNumber(rs.getString(2));
                    srcReportL.setDate(rs.getDate(1));
                    srcReportL.setItemMasterId(rs.getLong(3));
                    srcReportL.setQtyOut(rs.getInt(4));
                    
                    srcReportL.setType(7);
                       

                    result.add(srcReportL);
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
    
    public static int getStockByStatus(long locationId, long oidItemMaster, String status){
        int result=0;
        String sql="";
         CONResultSet crs = null;
        try{
           sql = "select sum(qty * in_out) from pos_stock where status='" + status +
                "' and location_id=" + locationId + " and item_master_id=" + oidItemMaster ;
           try{
               crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     result = rs.getInt(1);
               }
           } catch(Exception ex){
               
           }
        }catch(Exception ex){
            
        }
        return result;
    }
    
    public static int getStockPrev(long locationId, long oidItemMaster, String dt){
        int totSales =0;
        int totTransferIn =0;
        int totTransferOut =0;
        int totIncoming =0;
        int totRepackIn =0;
        int totRepackOut =0;
        int totCosting =0;
        int totRetur =0;
        int totOpnameAwal=0;
        int saldo =0;
        
        String sql ="";
        
        CONResultSet crs = null;
        try{
           //penjualan
           sql = "select sum(sd.qty) " +
                " from pos_sales_detail sd inner join pos_sales s on sd.sales_id=s.sales_id where " +
                " s.location_id=" + locationId + " and sd.product_master_id=" + oidItemMaster + " and to_days(s.date) < to_days('"+ dt +"')"; 
           try{
                crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     totSales = rs.getInt(1);
               }
           } catch(Exception ex){
               
           }
           
            //opname awal
           sql = "select sum(sd.qty_real) " +
                " from pos_opname_item sd inner join pos_opname s on sd.opname_id=s.opname_id where " +
                " s.location_id=" + locationId + " and sd.item_master_id=" + oidItemMaster + " and to_days(s.date) < to_days('"+ dt +"')"; 
           try{
                crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     totOpnameAwal = rs.getInt(1);
               }
               
           } catch(Exception ex){
               
           }
           
           //transfer in
           sql = "select sum(sd.qty) " +
                " from pos_transfer_item sd inner join pos_transfer s on sd.transfer_id=s.transfer_id where " +
                " s.to_location_id=" + locationId + " and sd.item_master_id=" + oidItemMaster + " and to_days(s.date) < to_days('"+ dt +"')"; 
           try{
                crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     totTransferIn = rs.getInt(1);
               }
           } catch(Exception ex){
               
           }
           
           //transfer out
           sql = "select sum(sd.qty) " +
                " from pos_transfer_item sd inner join pos_transfer s on sd.transfer_id=s.transfer_id where " +
                " s.from_location_id=" + locationId + " and sd.item_master_id=" + oidItemMaster + " and to_days(s.date) < to_days('"+ dt +"')"; 
           try{
                crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     totTransferOut = rs.getInt(1);
               }
           } catch(Exception ex){
               
           }
           
           //incoming
           sql = "select sum(sd.qty) " +
                " from pos_receive_item sd inner join pos_receive s on sd.receive_id=s.receive_id where " +
                " s.location_id=" + locationId + " and sd.item_master_id=" + oidItemMaster + " and to_days(s.date) < to_days('"+ dt +"')"; 
           try{
                crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     totIncoming = rs.getInt(1);
               }
           } catch(Exception ex){
               
           }
           
           //repack in
           sql = "select sum(sd.qty) " +
                " from pos_repack_item sd inner join pos_repack s on sd.repack_id=s.repack_id where " +
                " s.location_id=" + locationId + " and sd.item_master_id=" + oidItemMaster + " and type=0 and to_days(s.date) < to_days('"+ dt +"')"; 
           try{
               crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     totRepackIn = rs.getInt(1);
               }
           } catch(Exception ex){
               
           }
           
           //repack out
           sql = "select sum(sd.qty) " +
                " from pos_repack_item sd inner join pos_repack s on sd.repack_id=s.repack_id where " +
                " s.location_id=" + locationId + " and sd.item_master_id=" + oidItemMaster + " and type=1 and to_days(s.date) < to_days('"+ dt +"')"; 
           try{
               crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     totRepackOut = rs.getInt(1);
               }
           } catch(Exception ex){
               
           }
           
           //retur
           sql = "select sum(sd.qty) " +
                " from pos_retur_item sd inner join pos_retur s on sd.retur_id=s.retur_id where " +
                " s.location_id=" + locationId + " and sd.item_master_id=" + oidItemMaster + " and to_days(s.date) < to_days('"+ dt +"')"; 
           try{
               crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     totRetur = rs.getInt(1);
               }
           } catch(Exception ex){
               
           }
           
        }
        
        catch(Exception e){
             System.out.println(e.toString());
        }
        finally{
             CONResultSet.close(crs);
        }
        
        saldo=totIncoming + totRepackOut + totTransferIn + totOpnameAwal - (totCosting + totRepackIn + totSales + totTransferOut);
            
        return saldo;
       
    }
    
    public static Vector getItemStock(String itmCode, String itmName, long groupId, int limitStart,int recordToGet){
        
        String sql = "select " +
            "  g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as ig "+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+
            " from " + DbItemMaster.DB_ITEM_MASTER+" m "+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];
            
        
            String where = "";
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
            
            
            if(groupId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = "+groupId;
            }
            
            
                        
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by m."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
            
            
            
             if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
                }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                }
            
            System.out.println("\n\n"+sql);
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    SrcStockReportL srcReportL = new SrcStockReportL();
                
                    //srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setGroupName(rs.getString(1));
                    srcReportL.setItemMasterId(rs.getLong(2));
                   // srcReportL.setLocation(rs.getLong(4));
                    srcReportL.setCode(rs.getString(3));
                    srcReportL.setDescription(rs.getString(4));
                   // srcReportL.setQty(rs.getDouble(7));
                    //srcReportL.setPrice(rs.getDouble(8));
                    //srcReportL.setAmount(srcReportL.getQty()*srcReportL.getPrice());

                    result.add(srcReportL);
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
    
    public static Vector getItemStockBySupplier(String itmCode, String itmName, long locationId, long groupId, int orderBy, int type, int limitStart,int recordToGet, long vendorId){
        
        String sql = "select " +
            " l."+DbLocation.colNames[DbLocation.COL_NAME]+" as loc "+
            ", g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as ig "+
            ", s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+
            ", sum(s."+DbStock.colNames[DbStock.COL_QTY]+"*s."+DbStock.colNames[DbStock.COL_IN_OUT]+") qty " +
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as price " +
            " from "+DbStock.DB_POS_STOCK+" s "+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
            " on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " inner join "+DbLocation.DB_LOCATION+" l "+
            " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = s."+DbStock.colNames[DbStock.COL_LOCATION_ID] +
            " inner join "+DbVendorItem.DB_VENDOR_ITEM+" v "+
            " on v."+DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
        
            String where = "";
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
            //0 = all location, 1=group by location
            if(locationId!=0 && locationId!=1){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+locationId;
            }
            
            if(groupId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = "+groupId;
            }
            if(vendorId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " v."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+" = "+vendorId;
            }
            
            if(where.length()>0){
                where = where + " and s."+DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }else{
                where  = "s." +DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }
            
            if(where.length()>0){
                where = where + " and s."+DbStock.colNames[DbStock.COL_STATUS]+" = 'APPROVED' ";
            }else{
                where  = " s." +DbStock.colNames[DbStock.COL_STATUS]+" =  = 'APPROVED' ";
            }
            
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
            
            //if(locationId!=0){
                sql = sql + ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID];//seharusnya di group per lokasi jg. seblumnya tidak ada
            //}
            
            sql = sql + " order by ";
            if(orderBy==0){
                sql = sql + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
            }
            else if(orderBy==1){
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE];
            }
            else if(orderBy==2){                
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
            }
            else{
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];
            }
            
             if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
                }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                }
            
            System.out.println("\n\n"+sql);
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   
                    SrcStockReportL srcReportL = new SrcStockReportL();
                
                    srcReportL.setLocationName(rs.getString(1));
                    srcReportL.setGroupName(rs.getString(2));
                    srcReportL.setItemMasterId(rs.getLong(3));
                    srcReportL.setLocation(rs.getLong(4));
                    srcReportL.setCode(rs.getString(5));
                    srcReportL.setDescription(rs.getString(6));
                    srcReportL.setQty(rs.getDouble(7));
                    srcReportL.setPrice(rs.getDouble(8));
                    srcReportL.setAmount(srcReportL.getQty()*srcReportL.getPrice());

                    result.add(srcReportL);
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
    public static int getItemStockCountBySupplier(String itmCode, String itmName, long locationId, long groupId, int orderBy, int type, long vendorId){
        int count=0;
        String sql = "select " +
            " l."+DbLocation.colNames[DbLocation.COL_NAME]+" as loc "+
            ", g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as ig "+
            ", s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+
            ", sum(s."+DbStock.colNames[DbStock.COL_QTY]+"*s."+DbStock.colNames[DbStock.COL_IN_OUT]+") qty " +
            ", m."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as price " +
            " from "+DbStock.DB_POS_STOCK+" s "+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
            " on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " inner join "+DbLocation.DB_LOCATION+" l "+
            " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = s."+DbStock.colNames[DbStock.COL_LOCATION_ID] +
            " inner join "+DbVendorItem.DB_VENDOR_ITEM+" v "+
            " on v."+DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
        
            String where = "";
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
            //0 = all location, 1=group by location
            if(locationId!=0 && locationId!=1){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+locationId;
            }
            
            if(groupId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = "+groupId;
            }
            if(vendorId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " v."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+" = "+vendorId;
            }
            if(where.length()>0){
                where = where + " and s."+DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }else{
                where  = "s." +DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }
            
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
            
            //if(locationId!=0){
                sql = sql + ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
           // }
            
            sql = sql + " order by ";
            if(orderBy==0){
                sql = sql + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
            }
            else if(orderBy==1){
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE];
            }
            else if(orderBy==2){                
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
            }
            else{
                sql = sql + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];
            }
            
            System.out.println("\n\n"+sql);
            
            
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                   count= count + 1;
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return count;
            
    }
    
    
    
    public static int getItemCount(String itmCode, String itmName, long groupId){
        int count=0;
        String sql = "select " +
            " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+
            " from "+DbItemMaster.DB_ITEM_MASTER+" m "+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID];
            
        
            String where = "";
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
                        
            if(groupId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = "+groupId;
            }
                       
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];
                  
            
            sql = "select count(*) as tot from ((" + sql + ")) as tabel";
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                   count= rs.getInt(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return count;
            
    }
    
    
}