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
public class DbStockDays extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_STOCK_DAYS = "pos_stock_days";
    
    public static final int COL_STOCK_DAYS_ID = 0;
    public static final int COL_LOCATION_ID = 1;
    public static final int COL_MONTH = 2;
    public static final int COL_YEAR = 3;
    public static final int COL_USER_ID = 4;
    public static final int COL_UPDATE_DATE = 5;
    public static final int COL_STOCK_DAYS_EOD = 6;
    public static final int COL_DAYS = 7;
    public static final int COL_DAYA_BELI = 8;
    
    public static final String[] colNames = {
        "stock_days_id",
        "location_id",
        "month",
        "year",
        "user_id",
        "update_date",
        "stock_days_eod",
        "days",
        "daya_beli"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_FLOAT
    };

    public DbStockDays() {
    }

    public DbStockDays(int i) throws CONException {
        super(new DbStockDays());
    }

    public DbStockDays(String sOid) throws CONException {
        super(new DbStockDays(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbStockDays(long lOid) throws CONException {
        super(new DbStockDays(0));
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
        return DB_STOCK_DAYS;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbStockDays().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        StockDays stockDays = fetchExc(ent.getOID());
        ent = (Entity) stockDays;
        return stockDays.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((StockDays) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((StockDays) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static StockDays fetchExc(long oid) throws CONException {
        try {
            StockDays stockDays = new StockDays();
            DbStockDays dbStockDays = new DbStockDays(oid);
            stockDays.setOID(oid);

            stockDays.setLocationId(dbStockDays.getlong(COL_LOCATION_ID));
            stockDays.setMonth(dbStockDays.getInt(COL_MONTH));
            stockDays.setYear(dbStockDays.getInt(COL_YEAR));
            stockDays.setUserId(dbStockDays.getlong(COL_USER_ID));
            stockDays.setUpdateDate(dbStockDays.getDate(COL_UPDATE_DATE));
            stockDays.setStockDaysEOD(dbStockDays.getdouble(COL_STOCK_DAYS_EOD));
            stockDays.setDays(dbStockDays.getInt(COL_DAYS));
            stockDays.setDayaBeli(dbStockDays.getdouble(COL_DAYA_BELI));

            return stockDays;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockDays(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(StockDays stockDays) throws CONException {
        try {
            DbStockDays dbStockDays = new DbStockDays(0);

            dbStockDays.setLong(COL_LOCATION_ID, stockDays.getLocationId());
            dbStockDays.setInt(COL_MONTH, stockDays.getMonth());
            dbStockDays.setInt(COL_YEAR, stockDays.getYear());
            dbStockDays.setLong(COL_USER_ID, stockDays.getUserId());
            dbStockDays.setDate(COL_UPDATE_DATE, stockDays.getUpdateDate());
            dbStockDays.setDouble(COL_STOCK_DAYS_EOD, stockDays.getStockDaysEOD());
            dbStockDays.setInt(COL_DAYS, stockDays.getDays());
            dbStockDays.setDouble(COL_DAYA_BELI, stockDays.getDayaBeli());

            dbStockDays.insert();
            stockDays.setOID(dbStockDays.getlong(COL_STOCK_DAYS_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockDays(0), CONException.UNKNOWN);
        }
        return stockDays.getOID();
    }

    public static long updateExc(StockDays stockDays) throws CONException {
        try {
            if (stockDays.getOID() != 0) {
                DbStockDays dbStockDays = new DbStockDays(stockDays.getOID());

                dbStockDays.setLong(COL_LOCATION_ID, stockDays.getLocationId());
                dbStockDays.setInt(COL_MONTH, stockDays.getMonth());
                dbStockDays.setInt(COL_YEAR, stockDays.getYear());
                dbStockDays.setLong(COL_USER_ID, stockDays.getUserId());
                dbStockDays.setDate(COL_UPDATE_DATE, stockDays.getUpdateDate());
                dbStockDays.setDouble(COL_STOCK_DAYS_EOD, stockDays.getStockDaysEOD());
                dbStockDays.setInt(COL_DAYS, stockDays.getDays());
                dbStockDays.setDouble(COL_DAYA_BELI, stockDays.getDayaBeli());

                dbStockDays.update();
                return stockDays.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbShift(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbStockDays dbStockDays = new DbStockDays(oid);
            dbStockDays.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbStockDays(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_STOCK_DAYS;
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
                StockDays stockDays = new StockDays();
                resultToObject(rs, stockDays);
                lists.add(stockDays);
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

    private static void resultToObject(ResultSet rs, StockDays stockDays) {
        try {
            stockDays.setOID(rs.getLong(DbStockDays.colNames[DbStockDays.COL_STOCK_DAYS_ID]));
            stockDays.setLocationId(rs.getLong(DbStockDays.colNames[DbStockDays.COL_LOCATION_ID]));
            stockDays.setMonth(rs.getInt(DbStockDays.colNames[DbStockDays.COL_MONTH]));
            stockDays.setYear(rs.getInt(DbStockDays.colNames[DbStockDays.COL_YEAR]));
            stockDays.setUserId(rs.getLong(DbStockDays.colNames[DbStockDays.COL_USER_ID]));
            stockDays.setUpdateDate(rs.getDate(DbStockDays.colNames[DbStockDays.COL_UPDATE_DATE]));
            stockDays.setStockDaysEOD(rs.getDouble(DbStockDays.colNames[DbStockDays.COL_STOCK_DAYS_EOD]));
            stockDays.setDays(rs.getInt(DbStockDays.colNames[DbStockDays.COL_DAYS]));
            stockDays.setDayaBeli(rs.getDouble(DbStockDays.colNames[DbStockDays.COL_DAYA_BELI]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long merkId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_STOCK_DAYS + " WHERE " +
                    DbStockDays.colNames[DbStockDays.COL_STOCK_DAYS_ID] + " = " + merkId;

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
            String sql = "SELECT COUNT(" + DbStockDays.colNames[DbStockDays.COL_STOCK_DAYS_ID] + ") FROM " + DB_STOCK_DAYS;
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
                    StockDays stockDays = (StockDays) list.get(ls);
                    if (oid == stockDays.getOID()) {
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
}
