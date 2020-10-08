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
public class DbLogStockStandar extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_LOG_STOCK_STANDAR = "log_stock_standar";
    public static final int COL_LOG_STOCK_STANDAR_ID = 0;
    public static final int COL_DATE = 1;
    public static final int COL_LOG_DESC = 2;
    public static final int COL_STOCK_MIN_ID = 3;
    public static final int COL_USER_ID = 4;
    public static final int COL_USER_NAME = 5;
    public static final int COL_QTY_STANDAR = 6;
    
    
    public static final String[] colNames = {
        "log_stock_standar_id",
        "date",
        "log_desc",
        "stock_min_id",
        "user_id",
        "user_name",
        "qty_standar"
        
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT
        
    };
  
    
    

    public DbLogStockStandar() {
    }

    public DbLogStockStandar(int i) throws CONException {
        super(new DbLogStockStandar());
    }

    public DbLogStockStandar(String sOid) throws CONException {
        super(new DbLogStockStandar(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLogStockStandar(long lOid) throws CONException {
        super(new DbLogStockStandar(0));
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
        return DB_LOG_STOCK_STANDAR;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLogStockStandar().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LogStockStandar logStockS = fetchExc(ent.getOID());
        ent = (Entity) logStockS;
        return logStockS.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LogStockStandar) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LogStockStandar) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static LogStockStandar fetchExc(long oid) throws CONException {
        try {
            LogStockStandar logStockS = new LogStockStandar();
            DbLogStockStandar pstLogStockS = new DbLogStockStandar(oid);
            logStockS.setOID(oid);

            logStockS.setDate(pstLogStockS.getDate(COL_DATE));
            logStockS.setLogDesc(pstLogStockS.getString(COL_LOG_DESC));
            logStockS.setStockMinId(pstLogStockS.getlong(COL_STOCK_MIN_ID));
            logStockS.setUserId(pstLogStockS.getlong(COL_USER_ID));
            logStockS.setUserName(pstLogStockS.getString(COL_USER_NAME));
            logStockS.setQtyStandar(pstLogStockS.getdouble(COL_QTY_STANDAR));
            
            return logStockS;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogStockStandar(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LogStockStandar logStockS) throws CONException {
        try {


            DbLogStockStandar pstLogStockS = new DbLogStockStandar(0);

            pstLogStockS.setDate(COL_DATE, logStockS.getDate());
            pstLogStockS.setString(COL_LOG_DESC, logStockS.getLogDesc());
            pstLogStockS.setLong(COL_STOCK_MIN_ID, logStockS.getStockMinId());
            pstLogStockS.setLong(COL_USER_ID, logStockS.getUserId());
            pstLogStockS.setString(COL_USER_NAME, logStockS.getUserName());
            pstLogStockS.setDouble(COL_QTY_STANDAR, logStockS.getQtyStandar());
            
            
            
            pstLogStockS.insert();
            logStockS.setOID(pstLogStockS.getlong(COL_LOG_STOCK_STANDAR_ID));


        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogStockStandar(0), CONException.UNKNOWN);
        }
        return logStockS.getOID();
    }

    public static long updateExc(LogStockStandar logStockS) throws CONException {
        try {
            if (logStockS.getOID() != 0) {

                DbLogStockStandar pstLogStockS = new DbLogStockStandar(logStockS.getOID());

                pstLogStockS.setDate(COL_DATE, logStockS.getDate());
                pstLogStockS.setString(COL_LOG_DESC, logStockS.getLogDesc());
                pstLogStockS.setLong(COL_STOCK_MIN_ID, logStockS.getStockMinId());
                pstLogStockS.setLong(COL_USER_ID, logStockS.getUserId());
                pstLogStockS.setString(COL_USER_NAME, logStockS.getUserName());
                pstLogStockS.setDouble(COL_QTY_STANDAR, logStockS.getQtyStandar());
                pstLogStockS.update();
                return logStockS.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogStockStandar(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLogStockStandar pstLogStockS = new DbLogStockStandar(oid);
            pstLogStockS.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogStockStandar(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LOG_STOCK_STANDAR;
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
                LogStockStandar logStockS = new LogStockStandar();
                resultToObject(rs, logStockS);
                lists.add(logStockS);
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

    public static void resultToObject(ResultSet rs, LogStockStandar logStockS) {
        try {

            logStockS.setOID(rs.getLong(DbLogStockStandar.colNames[DbLogStockStandar.COL_LOG_STOCK_STANDAR_ID]));
            logStockS.setDate(rs.getDate(DbLogStockStandar.colNames[DbLogStockStandar.COL_DATE]));

            logStockS.setLogDesc(rs.getString(DbLogStockStandar.colNames[DbLogStockStandar.COL_LOG_DESC]));
            logStockS.setStockMinId(rs.getLong(DbLogStockStandar.colNames[DbLogStockStandar.COL_STOCK_MIN_ID]));
            logStockS.setUserId(rs.getLong(DbLogStockStandar.colNames[DbLogStockStandar.COL_USER_ID]));
            logStockS.setUserName(rs.getString(DbLogStockStandar.colNames[DbLogStockStandar.COL_USER_NAME]));
            logStockS.setQtyStandar(rs.getDouble(DbLogStockStandar.colNames[DbLogStockStandar.COL_QTY_STANDAR]));
            
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long stockCodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOG_STOCK_STANDAR + " WHERE " +
                    DbLogStockStandar.colNames[DbLogStockStandar.COL_LOG_STOCK_STANDAR_ID] + " = " + stockCodeId;

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
            String sql = "SELECT COUNT(" + DbLogStockStandar.colNames[DbLogStockStandar.COL_LOG_STOCK_STANDAR_ID] + ") FROM " + DB_LOG_STOCK_STANDAR;
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
                    LogStockStandar logStockS = (LogStockStandar) list.get(ls);
                    if (oid == logStockS.getOID()) {
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
