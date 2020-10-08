/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.posmaster;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;

/**
 *
 * @author Roy Andika
 */
public class DbStockCode extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_STOCK_CODE = "pos_stock_code";
    public static final int COL_STOCK_CODE_ID = 0;
    public static final int COL_CODE = 1;
    public static final int COL_LOCATION_ID = 2;
    public static final int COL_ITEM_MASTER_ID = 3;
    public static final int COL_IN_OUT = 4;
    public static final int COL_TYPE = 5;
    public static final int COL_RECEIVE_ID = 6;
    public static final int COL_RETUR_ID = 7;
    public static final int COL_TRANSFER_ID = 8;
    public static final int COL_QTY = 9;
    public static final int COL_STATUS = 10;
    public static final int COL_RECEIVE_ITEM_ID = 11;
    public static final int COL_TRANSFER_ITEM_ID = 12;
    public static final int COL_RETUR_ITEM_ID = 13;
    public static final int COL_TYPE_ITEM = 14;
    public static final int COL_SALES_ID = 15;
    public static final int COL_SALES_DETAIL_ID = 16;
    
    public static final String[] colNames = {
        "stock_code_id",
        "code",
        "location_id",
        "item_master_id",
        "in_out",
        "type",
        "receive_id",
        "retur_id",
        "transfer_id",
        "qty",
        "status",
        "receive_item_id",
        "transfer_item_id",
        "retur_item_id",
        "type_item",
        "sales_id",
        "sales_detail_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG
    };
    public static int TYPE_INCOMING_GOODS = 0;
    public static int TYPE_RETUR_GOODS = 1;
    public static int TYPE_TRANSFER = 2;
    public static int TYPE_TRANSFER_IN = 3;
    public static int TYPE_ADJUSTMENT = 4;
    public static int TYPE_OPNAME = 5;
    public static int TYPE_PROJECT_INSTALL = 6;
    public static int TYPE_SALES = 7;
    
    public static int TYPE_NON_CONSIGMENT = 0;
    public static int TYPE_CONSIGMENT = 1;
    
    public static String[] strType = {
        "Incoming Goods", "Retur PO", "Transfer Out", "Transfer In", "Adjustment", "Opname", "Sales"
    };
    public static int STOCK_IN = 1;
    public static int STOCK_OUT = -1;
    public static String[] strStatus = {
        "Status In", "Status Out"
    };
    public static int STATUS_IN = 0;
    public static int STATUS_OUT = 1;

    public DbStockCode() {
    }

    public DbStockCode(int i) throws CONException {
        super(new DbStockCode());
    }

    public DbStockCode(String sOid) throws CONException {
        super(new DbStockCode(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbStockCode(long lOid) throws CONException {
        super(new DbStockCode(0));
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
        return DB_STOCK_CODE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbStockCode().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        StockCode stockCode = fetchExc(ent.getOID());
        ent = (Entity) stockCode;
        return stockCode.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((StockCode) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((StockCode) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static StockCode fetchExc(long oid) throws CONException {
        try {
            StockCode stockCode = new StockCode();
            DbStockCode pstStockCode = new DbStockCode(oid);
            stockCode.setOID(oid);

            stockCode.setCode(pstStockCode.getString(COL_CODE));
            stockCode.setLocationId(pstStockCode.getlong(COL_LOCATION_ID));
            stockCode.setItemMasterId(pstStockCode.getlong(COL_ITEM_MASTER_ID));
            stockCode.setInOut(pstStockCode.getInt(COL_IN_OUT));
            stockCode.setType(pstStockCode.getInt(COL_TYPE));
            stockCode.setReceiveId(pstStockCode.getlong(COL_RECEIVE_ID));
            stockCode.setReturId(pstStockCode.getlong(COL_RETUR_ID));
            stockCode.setTransferId(pstStockCode.getlong(COL_TRANSFER_ID));
            stockCode.setQty(pstStockCode.getdouble(COL_QTY));
            stockCode.setStatus(pstStockCode.getInt(COL_STATUS));
            stockCode.setReceiveItemId(pstStockCode.getlong(COL_RECEIVE_ITEM_ID));
            stockCode.setTransferItemId(pstStockCode.getlong(COL_TRANSFER_ITEM_ID));
            stockCode.setReturItemId(pstStockCode.getlong(COL_RETUR_ITEM_ID));
            stockCode.setType_item(pstStockCode.getInt(COL_TYPE_ITEM));
            stockCode.setSalesId(pstStockCode.getlong(COL_SALES_ID));
            stockCode.setSalesDetailId(pstStockCode.getlong(COL_SALES_DETAIL_ID));
            return stockCode;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockCode(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(StockCode stockCode) throws CONException {
        try {


            DbStockCode pstStockCode = new DbStockCode(0);

            pstStockCode.setString(COL_CODE, stockCode.getCode());
            pstStockCode.setLong(COL_LOCATION_ID, stockCode.getLocationId());
            pstStockCode.setLong(COL_ITEM_MASTER_ID, stockCode.getItemMasterId());
            pstStockCode.setInt(COL_IN_OUT, stockCode.getInOut());
            pstStockCode.setInt(COL_TYPE, stockCode.getType());
            pstStockCode.setLong(COL_RECEIVE_ID, stockCode.getReceiveId());
            pstStockCode.setLong(COL_RETUR_ID, stockCode.getReturId());
            pstStockCode.setLong(COL_TRANSFER_ID, stockCode.getTransferId());
            pstStockCode.setDouble(COL_QTY, stockCode.getQty());
            pstStockCode.setInt(COL_STATUS, stockCode.getStatus());
            pstStockCode.setLong(COL_RECEIVE_ITEM_ID, stockCode.getReceiveItemId());
            pstStockCode.setLong(COL_TRANSFER_ITEM_ID, stockCode.getTransferItemId());
            pstStockCode.setLong(COL_RETUR_ITEM_ID, stockCode.getReturItemId());
            pstStockCode.setInt(COL_TYPE_ITEM, stockCode.getType_item());
            pstStockCode.setLong(COL_SALES_ID, stockCode.getSalesId());
            pstStockCode.setLong(COL_SALES_DETAIL_ID, stockCode.getSalesDetailId());
            
            pstStockCode.insert();
            stockCode.setOID(pstStockCode.getlong(COL_STOCK_CODE_ID));


        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockCode(0), CONException.UNKNOWN);
        }
        return stockCode.getOID();
    }

    public static long updateExc(StockCode stockCode) throws CONException {
        try {
            if (stockCode.getOID() != 0) {

                DbStockCode pstStockCode = new DbStockCode(stockCode.getOID());

                pstStockCode.setString(COL_CODE, stockCode.getCode());
                pstStockCode.setLong(COL_LOCATION_ID, stockCode.getLocationId());
                pstStockCode.setLong(COL_ITEM_MASTER_ID, stockCode.getItemMasterId());
                pstStockCode.setInt(COL_IN_OUT, stockCode.getInOut());
                pstStockCode.setInt(COL_TYPE, stockCode.getType());
                pstStockCode.setLong(COL_RECEIVE_ID, stockCode.getReceiveId());
                pstStockCode.setLong(COL_RETUR_ID, stockCode.getReturId());
                pstStockCode.setLong(COL_TRANSFER_ID, stockCode.getTransferId());
                pstStockCode.setDouble(COL_QTY, stockCode.getQty());
                pstStockCode.setInt(COL_STATUS, stockCode.getStatus());
                pstStockCode.setLong(COL_RECEIVE_ITEM_ID, stockCode.getReceiveItemId());
                pstStockCode.setLong(COL_TRANSFER_ITEM_ID, stockCode.getTransferItemId());
                pstStockCode.setLong(COL_RETUR_ITEM_ID, stockCode.getReturItemId());
                pstStockCode.setLong(COL_TYPE_ITEM, stockCode.getType_item());
                pstStockCode.setLong(COL_SALES_ID, stockCode.getSalesId());
                pstStockCode.setLong(COL_SALES_DETAIL_ID, stockCode.getSalesDetailId());
                pstStockCode.update();
                return stockCode.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockCode(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbStockCode pstStockCode = new DbStockCode(oid);
            pstStockCode.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockCode(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_STOCK_CODE;
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
                StockCode stockCode = new StockCode();
                resultToObject(rs, stockCode);
                lists.add(stockCode);
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

    public static void resultToObject(ResultSet rs, StockCode stockCode) {
        try {

            stockCode.setOID(rs.getLong(DbStockCode.colNames[DbStockCode.COL_STOCK_CODE_ID]));
            stockCode.setCode(rs.getString(DbStockCode.colNames[DbStockCode.COL_CODE]));

            stockCode.setLocationId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_LOCATION_ID]));
            stockCode.setItemMasterId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_ITEM_MASTER_ID]));
            stockCode.setInOut(rs.getInt(DbStockCode.colNames[DbStockCode.COL_IN_OUT]));
            stockCode.setType(rs.getInt(DbStockCode.colNames[DbStockCode.COL_TYPE]));
            stockCode.setReceiveId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_RECEIVE_ID]));
            stockCode.setReturId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_RETUR_ID]));
            stockCode.setTransferId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_TRANSFER_ID]));
            stockCode.setQty(rs.getLong(DbStockCode.colNames[DbStockCode.COL_QTY]));
            stockCode.setStatus(rs.getInt(DbStockCode.colNames[DbStockCode.COL_STATUS]));
            stockCode.setReceiveItemId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_RECEIVE_ITEM_ID]));
            stockCode.setTransferItemId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_TRANSFER_ITEM_ID]));
            stockCode.setReturItemId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_RETUR_ITEM_ID]));
            stockCode.setType_item(rs.getInt(DbStockCode.colNames[DbStockCode.COL_TYPE_ITEM]));
            stockCode.setSalesId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_SALES_ID]));
            stockCode.setSalesDetailId(rs.getLong(DbStockCode.colNames[DbStockCode.COL_SALES_DETAIL_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long stockCodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_STOCK_CODE + " WHERE " +
                    DbStockCode.colNames[DbStockCode.COL_STOCK_CODE_ID] + " = " + stockCodeId;

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
    public static boolean checkCode(String code) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_STOCK_CODE + " WHERE " +
                    DbStockCode.colNames[DbStockCode.COL_CODE] + " = '" + code + "'";

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
            String sql = "SELECT COUNT(" + DbStockCode.colNames[DbStockCode.COL_STOCK_CODE_ID] + ") FROM " + DB_STOCK_CODE;
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
                    StockCode stockCode = (StockCode) list.get(ls);
                    if (oid == stockCode.getOID()) {
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

    public static void deleteStockCode(long receiveItemId) {
        CONResultSet dbrs = null;
        try {

            String sql = "DELETE FROM " + DbStockCode.DB_STOCK_CODE + " WHERE " + DbStockCode.colNames[DbStockCode.COL_RECEIVE_ITEM_ID] + "=" + receiveItemId;
            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    public static void deleteStockCodeRetur(long returId) {
        CONResultSet dbrs = null;
        try {

            String sql = "DELETE FROM " + DbStockCode.DB_STOCK_CODE + " WHERE " + DbStockCode.colNames[DbStockCode.COL_RETUR_ID] + "=" + returId;
            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static void deleteStockCodeByTransferItem(long transferItemId) {
        CONResultSet dbrs = null;
        try {

            String sql = "DELETE FROM " + DbStockCode.DB_STOCK_CODE + " WHERE " + DbStockCode.colNames[DbStockCode.COL_TRANSFER_ITEM_ID] + "=" + transferItemId;
            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
     public static void deleteStockCodeBySalesItem(long salesItemId) {
        CONResultSet dbrs = null;
        try {

            String sql = "DELETE FROM " + DbStockCode.DB_STOCK_CODE + " WHERE " + DbStockCode.colNames[DbStockCode.COL_SALES_DETAIL_ID] + "=" + salesItemId;
            CONHandler.execUpdate(sql);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static long deleteAllItem(long receiveId) throws CONException {
        try {
            String sql = "DELETE FROM " + DB_STOCK_CODE +
                    " WHERE " + colNames[COL_RECEIVE_ID] + "=" + receiveId;
            CONHandler.execUpdate(sql);
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockCode(0), CONException.UNKNOWN);
        }
        return receiveId;
    }

    public static long deleteAllItemByTransferItem(long transferId) throws CONException {
        try {
            String sql = "DELETE FROM " + DB_STOCK_CODE +
                    " WHERE " + colNames[COL_TRANSFER_ID] + "=" + transferId;
            CONHandler.execUpdate(sql);
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockCode(0), CONException.UNKNOWN);
        }
        return transferId;
    }

    public static Vector getAddStockCode(long locationId, long itemMasterId, String where) {

        //select stock_code_id,code,sum(in_out) as 'con' from pos_stock_code where location_id = 1011161331752486  group by code;
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT " + colNames[COL_STOCK_CODE_ID] + ",SUM(" + colNames[COL_IN_OUT] + ") AS 'con' FROM " + DbStockCode.DB_STOCK_CODE;
            
            String wherex = "";
            
            if (where.length() > 0) {

                wherex = where;
            }

            if(wherex.length() > 0){
                wherex = wherex + " AND " + colNames[COL_LOCATION_ID] + " = " + locationId + " AND " + colNames[COL_ITEM_MASTER_ID] + " = " + itemMasterId ;
            }else{
                wherex = colNames[COL_LOCATION_ID] + " = " + locationId + " AND " + colNames[COL_ITEM_MASTER_ID] + " = " + itemMasterId ;
            }         
            
            sql = sql + " WHERE "+wherex + " GROUP BY " + colNames[COL_CODE];
            
            System.out.println("[sql] "+sql);

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector result = new Vector();
            
            while (rs.next()){
                
                long stockId = rs.getLong(colNames[COL_STOCK_CODE_ID]);
                int inOut = rs.getInt("con");
                
                if(inOut > 0){
                   
                    StockCode stockCode = new StockCode();
                    
                    try{
                        stockCode = DbStockCode.fetchExc(stockId);
                        result.add(stockCode);                        
                    }catch(Exception e){}
                }
            }

            return result;

        } catch (Exception e) {
            System.out.println("[exception] "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    public static Vector getStockCode(long locationId, long itemMasterId, String where, int type_item) {

        //select stock_code_id,code,sum(in_out) as 'con' from pos_stock_code where location_id = 1011161331752486  group by code;
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT " + colNames[COL_STOCK_CODE_ID] +  " FROM " + DbStockCode.DB_STOCK_CODE;
            
            String wherex = "";
            
            if (where.length() > 0) {

                wherex = where;
            }

            if(wherex.length() > 0){
                wherex = wherex + " AND " + colNames[COL_LOCATION_ID] + " = " + locationId + " AND " + colNames[COL_ITEM_MASTER_ID] + " = " + itemMasterId ;
            }else{
                wherex = colNames[COL_LOCATION_ID] + " = " + locationId + " AND " + colNames[COL_ITEM_MASTER_ID] + " = " + itemMasterId ;
            }  
            
            if(wherex.length() >0){
                wherex = wherex + " AND " + colNames[COL_TYPE_ITEM] + "=" + type_item;
            }else{
                wherex = colNames[COL_TYPE_ITEM] + "=" + type_item;
            }
            
            sql = sql + " WHERE "+wherex + " GROUP BY " + colNames[COL_STOCK_CODE_ID];
            
            System.out.println("[sql] "+sql);

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector result = new Vector();
            
            while (rs.next()){
                
                long stockId = rs.getLong(colNames[COL_STOCK_CODE_ID]);
                         
                    StockCode stockCode = new StockCode();
                    
                    try{
                        stockCode = DbStockCode.fetchExc(stockId);
                        result.add(stockCode);                        
                    }catch(Exception e){}
                
            }

            return result;

        } catch (Exception e) {
            System.out.println("[exception] "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
}
