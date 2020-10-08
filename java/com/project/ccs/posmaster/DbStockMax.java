/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.posmaster;

import com.project.ccs.postransaction.order.DbOrder;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.general.*;
import com.project.ccs.postransaction.stock.*;

/**
 *
 * @author Ngurah Wirata J
 */
public class DbStockMax extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_STOCK_MAX = "pos_stock_max";
    public static final int COL_STOCK_MAX_ID = 0;
    public static final int COL_LOCATION_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_ITEM_NAME = 3;
    public static final int COL_CODE = 4;
    public static final int COL_BARCODE = 5;
    public static final int COL_MAX_STOCK = 6;
    
    public static final String[] colNames = {
        "stock_max_id",
        "location_id",
        "item_master_id",
        "item_name",
        "code",
        "barcode",
        "max_stock"
        
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT
    };
    

    public DbStockMax() {
    }

    public DbStockMax(int i) throws CONException {
        super(new DbStockMax());
    }

    public DbStockMax(String sOid) throws CONException {
        super(new DbStockMax(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbStockMax(long lOid) throws CONException {
        super(new DbStockMax(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public String getTableName() {
        return DB_STOCK_MAX;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbStockMax().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        StockMax stockMax = fetchExc(ent.getOID());
        ent = (Entity) stockMax;
        return stockMax.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((StockMax) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((StockMax) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static StockMax fetchExc(long oid) throws CONException {
        try {
            StockMax stockMax = new  StockMax();
            DbStockMax dbStockMax = new DbStockMax(oid);
            stockMax.setOID(oid);

            stockMax.setLocationId(dbStockMax.getlong(COL_LOCATION_ID));
            stockMax.setItemMasterId(dbStockMax.getlong(COL_ITEM_MASTER_ID));
            stockMax.setItemName(dbStockMax.getString(COL_ITEM_NAME));
            stockMax.setCode(dbStockMax.getString(COL_CODE));
            stockMax.setBarcode(dbStockMax.getString(COL_BARCODE));
            stockMax.setMaxStock(dbStockMax.getdouble(COL_MAX_STOCK));
            
            return stockMax;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashMaster(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(StockMax stockMax) throws CONException {
        try {


            DbStockMax dbStockMax = new DbStockMax(0);

            
            dbStockMax.setLong(COL_LOCATION_ID, stockMax.getLocationId());
            dbStockMax.setLong(COL_ITEM_MASTER_ID, stockMax.getItemMasterId());
            dbStockMax.setString(COL_ITEM_NAME, stockMax.getItemName());
            dbStockMax.setString(COL_CODE, stockMax.getCode());
            dbStockMax.setString(COL_BARCODE, stockMax.getBarcode());
            dbStockMax.setDouble(COL_MAX_STOCK, stockMax.getMaxStock());
                        
            dbStockMax.insert();
            
            stockMax.setOID(dbStockMax.getlong(COL_STOCK_MAX_ID));
            

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashMaster(0), CONException.UNKNOWN);
        }
        return stockMax.getOID();
    }

    public static long updateExc( StockMax stockMax) throws CONException {
        try {
            if (stockMax.getOID() != 0) {

                DbStockMax dbStockMax = new DbStockMax(stockMax.getOID());

                
                dbStockMax.setLong(COL_LOCATION_ID, stockMax.getLocationId());
                dbStockMax.setLong(COL_ITEM_MASTER_ID, stockMax.getItemMasterId());        
                dbStockMax.setString(COL_ITEM_NAME, stockMax.getItemName()); 
                dbStockMax.setString(COL_CODE, stockMax.getCode()); 
                dbStockMax.setString(COL_BARCODE, stockMax.getBarcode()); 
                dbStockMax.setDouble(COL_MAX_STOCK, stockMax.getMaxStock()); 
                
                dbStockMax.update();
                
                return stockMax.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockMax(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbStockMax dbStockMax = new DbStockMax(oid);
            dbStockMax.delete();
            
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockMax(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_STOCK_MAX;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                StockMax stockMax = new StockMax();
                resultToObject(rs, stockMax);
                lists.add(stockMax);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, StockMax stockMax) {
        try {
            stockMax.setOID(rs.getLong(DbStockMax.colNames[DbStockMax.COL_STOCK_MAX_ID]));
            stockMax.setLocationId(rs.getLong(DbStockMax.colNames[DbStockMax.COL_LOCATION_ID]));
            stockMax.setItemMasterId(rs.getLong(DbStockMax.colNames[DbStockMax.COL_ITEM_MASTER_ID]));
            stockMax.setItemName(rs.getString(DbStockMax.colNames[DbStockMax.COL_ITEM_NAME]));
            stockMax.setCode(rs.getString(DbStockMax.colNames[DbStockMax.COL_CODE]));
            stockMax.setBarcode(rs.getString(DbStockMax.colNames[DbStockMax.COL_BARCODE]));
            stockMax.setMaxStock(rs.getDouble(DbStockMax.colNames[DbStockMax.COL_MAX_STOCK]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long stokMindId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " +  DB_STOCK_MAX + " WHERE " +
                    DbStockMax.colNames[DbStockMax.COL_STOCK_MAX_ID] + " = " + stokMindId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }
    

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbStockMax.colNames[DbStockMax.COL_STOCK_MAX_ID] + ") FROM " + DB_STOCK_MAX;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static void processMaxStock(long userId, String userName, long itemId, double qty){
        
        Vector v = list(0,1, colNames[COL_ITEM_MASTER_ID]+"="+itemId, "");
        
        //update
        if(v!=null && v.size()>0){
            StockMax ms = (StockMax)v.get(0);
            double old = ms.getMaxStock();
            ms.setMaxStock(qty);
            
            if(qty != old){
                try{
                    long oid = DbStockMax.updateExc(ms);
                    if(oid!=0){
                        insertOperationLog(itemId, userId, userName, old, qty);
                    }
                }
                catch(Exception e){
                }
            }
            
        }
        //insert new
        else{
            if(qty!=0){
                StockMax ms = new StockMax();                
                ms.setMaxStock(qty);
                ms.setItemMasterId(itemId);

                try{
                    long oid = DbStockMax.insertExc(ms);
                    if(oid!=0){
                        insertOperationLog(itemId, userId, userName, 0, qty);
                    }
                }
                catch(Exception e){
                }
                
            }
        }
        
    }
    
    public static double getStockMax(long itemMasterId) {
        
        Vector v = list(0,1, colNames[COL_ITEM_MASTER_ID]+"="+itemMasterId, "");
        double qty = 0;
        //update
        if(v!=null && v.size()>0){
            StockMax ms = (StockMax)v.get(0);
            qty = ms.getMaxStock();
        }
        
        return qty;
    }

    

    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    StockMax stockMax = (StockMax) list.get(ls);
                    if (oid == stockMax.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }

        return start;
    }

    
    public static int getCount(long categoryId, long groupId, long vendorId, long locationId) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(sm." + DbStockMax.colNames[DbStockMax.COL_STOCK_MAX_ID] + ") as jum FROM " + DB_STOCK_MAX + " sm " + 
            " INNER JOIN pos_item_master im ON sm.item_master_id=im.item_master_id INNER JOIN pos_vendor_item vi ON sm.item_master_id=vi.item_master_id " +
            " where sm.location_id="+ locationId ;
            
            if(categoryId!=0){
                sql=sql + " and im.item_category_id=" + categoryId;
            }
            if(groupId!=0){
                sql = sql + " and im.item_group_id=" + groupId;
                
            }
           
            
            if(vendorId!=0){
                sql = sql + " and vi.vendor_id=" + vendorId ;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static Vector listByParameter(int limitStart, int recordToGet, long itemCategoryId, long itemGroupId, long vendorId, long locationId) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_STOCK_MAX + " sm INNER JOIN pos_item_master im ON " +
                    " sm.item_master_id=im.item_master_id INNER JOIN pos_vendor_item vi ON "+
                    " sm.item_master_id=vi.item_master_id where sm.location_id=" + locationId;
            
            if (itemCategoryId!=0) {
                sql = sql + " and im.item_category_id=" + itemCategoryId;
            }
            if (itemGroupId!=0) {
                sql = sql + " and im.item_group_id=" + itemGroupId;
            }
            if (vendorId!=0) {
                sql = sql + " and vi.vendor_id=" + vendorId;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                StockMax stockMax = new StockMax();
                resultToObject(rs, stockMax);
                lists.add(stockMax);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }
  
    //insert logs for update item
    public static void insertOperationLog(long oid, long userId, String userName, StockMax oldStockMax, StockMax stockMax){

        String logDesc = getLogDesc(oldStockMax, stockMax);

        if(logDesc.length()>0){

            LogOperation lo = new LogOperation();
            lo.setDate(new java.util.Date());
            lo.setOwnerId(oid);
            lo.setUserId(userId);
            lo.setUserName(userName);
            lo.setLogDesc(logDesc);

            try{
                DbLogOperation.insertExc(lo);
            }
            catch(Exception e){

            }
        }
    }
    
    public static void insertOperationLog(long oid, long userId, String userName, double oldStockMax, double stockMax){

        String logDesc = getLogDesc(oldStockMax, stockMax);

        if(logDesc.length()>0){

            LogOperation lo = new LogOperation();
            lo.setDate(new java.util.Date());
            lo.setOwnerId(oid);
            lo.setUserId(userId);
            lo.setUserName(userName);
            lo.setLogDesc(logDesc);

            try{
                DbLogOperation.insertExc(lo);
            }
            catch(Exception e){

            }
        }
    }
    
    
    
    public static String getLogDesc(StockMax oldStockMax, StockMax stockMax){
        String logDesc = "";
        
        /*Location locNow = new Location();
        try{
            locNow = DbLocation.fetchExc(stockMax.getLocationId());

        }catch(Exception ex){

        }
         */ 

         if(oldStockMax.getMaxStock()!=stockMax.getMaxStock()){
            logDesc = logDesc + ((logDesc.length()>0) ? ", " : "" )+ " Maximum Stock :";
             try{
                logDesc = logDesc + " "+oldStockMax.getMaxStock() + " --> "+stockMax.getMaxStock();

            }
            catch(Exception e){
            }
        }

        if(logDesc.length()>0){
            logDesc = "Update data Max Stock >> "+logDesc;
        }
        return logDesc;
    }
    
    public static String getLogDesc(double oldStockMax, double stockMax){
        String logDesc = "";
        
         if(oldStockMax!=stockMax){
            logDesc = logDesc + ((logDesc.length()>0) ? ", " : "" )+ " Maximum Stock :";
             try{
                logDesc = logDesc + " "+oldStockMax + " --> "+stockMax;

            }
            catch(Exception e){
            }
        }

        if(logDesc.length()>0){
            logDesc = "Update data Max Stock >> "+logDesc;
        }
        return logDesc;
    }
  
        
}
