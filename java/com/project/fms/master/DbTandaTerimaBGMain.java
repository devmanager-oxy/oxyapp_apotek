/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.master;

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
public class DbTandaTerimaBGMain extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_TANDA_TERIMA_BG_MAIN = "tanda_terima_bg_main";
    
    public static final int COL_TANDA_TERIMA_BG_MAIN_ID = 0;
    public static final int COL_NUMBER = 1;
    public static final int COL_COUNTER = 2;
    public static final int COL_PREFIX = 3;
    public static final int COL_VENDOR_ID = 4;
    public static final int COL_TRANS_DATE = 5;
    public static final int COL_CREATE_DATE = 6;
    public static final int COL_VENDOR = 7;

    public static final String[] colNames = {
        "tanda_terima_bg_main_id","number","counter","prefix","vendor_id","trans_date","create_date","vendor"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID, TYPE_STRING, TYPE_INT, TYPE_STRING, TYPE_LONG, TYPE_DATE, TYPE_DATE,TYPE_STRING
    };

    public DbTandaTerimaBGMain() {
    }

    public DbTandaTerimaBGMain(int i) throws CONException {
        super(new DbTandaTerimaBGMain());
    }

    public DbTandaTerimaBGMain(String sOid) throws CONException {
        super(new DbTandaTerimaBGMain(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbTandaTerimaBGMain(long lOid) throws CONException {
        super(new DbTandaTerimaBGMain(0));
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
        return DB_TANDA_TERIMA_BG_MAIN;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbTandaTerimaBGMain().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        TandaTerimaBGMain tandaTerimaBGMain = fetchExc(ent.getOID());
        ent = (Entity) tandaTerimaBGMain;
        return tandaTerimaBGMain.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((TandaTerimaBGMain) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((TandaTerimaBGMain) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static TandaTerimaBGMain fetchExc(long oid) throws CONException {
        try {
            TandaTerimaBGMain tandaTerimaBGMain = new TandaTerimaBGMain();
            DbTandaTerimaBGMain DbTandaTerimaBGMain = new DbTandaTerimaBGMain(oid);
            tandaTerimaBGMain.setOID(oid);
            tandaTerimaBGMain.setNumber(DbTandaTerimaBGMain.getString(COL_NUMBER));
            tandaTerimaBGMain.setCounter(DbTandaTerimaBGMain.getInt(COL_COUNTER));
            tandaTerimaBGMain.setPrefix(DbTandaTerimaBGMain.getString(COL_PREFIX));
            tandaTerimaBGMain.setVendorId(DbTandaTerimaBGMain.getlong(COL_VENDOR_ID));
            tandaTerimaBGMain.setTransDate(DbTandaTerimaBGMain.getDate(COL_TRANS_DATE));
            tandaTerimaBGMain.setCreateDate(DbTandaTerimaBGMain.getDate(COL_CREATE_DATE));
            tandaTerimaBGMain.setVendor(DbTandaTerimaBGMain.getString(COL_VENDOR));

            return tandaTerimaBGMain;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTandaTerimaBGMain(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(TandaTerimaBGMain tandaTerimaBGMain) throws CONException {
        try {            
            DbTandaTerimaBGMain dbTandaTerimaBGMain = new DbTandaTerimaBGMain(0);

            dbTandaTerimaBGMain.setString(COL_NUMBER, tandaTerimaBGMain.getNumber());
            dbTandaTerimaBGMain.setInt(COL_COUNTER, tandaTerimaBGMain.getCounter());
            dbTandaTerimaBGMain.setString(COL_PREFIX, tandaTerimaBGMain.getPrefix());
            dbTandaTerimaBGMain.setLong(COL_VENDOR_ID, tandaTerimaBGMain.getVendorId());
            dbTandaTerimaBGMain.setDate(COL_TRANS_DATE, tandaTerimaBGMain.getTransDate());
            dbTandaTerimaBGMain.setDate(COL_CREATE_DATE, tandaTerimaBGMain.getCreateDate());
            dbTandaTerimaBGMain.setString(COL_VENDOR, tandaTerimaBGMain.getVendor());

            dbTandaTerimaBGMain.insert();
            tandaTerimaBGMain.setOID(dbTandaTerimaBGMain.getlong(COL_TANDA_TERIMA_BG_MAIN_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTandaTerimaBGMain(0), CONException.UNKNOWN);
        }
        return tandaTerimaBGMain.getOID();
    }

    public static long updateExc(TandaTerimaBGMain tandaTerimaBGMain) throws CONException {
        try {
            if (tandaTerimaBGMain.getOID() != 0) {
                DbTandaTerimaBGMain dbTandaTerimaBGMain = new DbTandaTerimaBGMain(tandaTerimaBGMain.getOID());
                dbTandaTerimaBGMain.setString(COL_NUMBER, tandaTerimaBGMain.getNumber());
                dbTandaTerimaBGMain.setInt(COL_COUNTER, tandaTerimaBGMain.getCounter());
                dbTandaTerimaBGMain.setString(COL_PREFIX, tandaTerimaBGMain.getPrefix());
                dbTandaTerimaBGMain.setLong(COL_VENDOR_ID, tandaTerimaBGMain.getVendorId());
                dbTandaTerimaBGMain.setDate(COL_TRANS_DATE, tandaTerimaBGMain.getTransDate());                
                dbTandaTerimaBGMain.setDate(COL_CREATE_DATE, tandaTerimaBGMain.getCreateDate());                
                dbTandaTerimaBGMain.setString(COL_VENDOR, tandaTerimaBGMain.getVendor());
                dbTandaTerimaBGMain.update();
                return tandaTerimaBGMain.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTandaTerimaBGMain(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbTandaTerimaBGMain DbTandaTerimaBGMain = new DbTandaTerimaBGMain(oid);
            DbTandaTerimaBGMain.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTandaTerimaBGMain(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_TANDA_TERIMA_BG_MAIN;
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
                TandaTerimaBGMain tandaTerimaBGMain = new TandaTerimaBGMain();
                resultToObject(rs, tandaTerimaBGMain);
                lists.add(tandaTerimaBGMain);
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

    private static void resultToObject(ResultSet rs, TandaTerimaBGMain tandaTerimaBGMain) {
        try {
            tandaTerimaBGMain.setOID(rs.getLong(DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_TANDA_TERIMA_BG_MAIN_ID]));
            tandaTerimaBGMain.setNumber(rs.getString(DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_NUMBER]));
            tandaTerimaBGMain.setCounter(rs.getInt(DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_COUNTER]));
            tandaTerimaBGMain.setPrefix(rs.getString(DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_PREFIX]));
            tandaTerimaBGMain.setVendorId(rs.getLong(DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_VENDOR_ID]));
            tandaTerimaBGMain.setTransDate(rs.getDate(DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_TRANS_DATE]));
            tandaTerimaBGMain.setCreateDate(rs.getDate(DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_CREATE_DATE]));
            tandaTerimaBGMain.setVendor(rs.getString(DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_VENDOR]));            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long tandaTerimaBgMainId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_TANDA_TERIMA_BG_MAIN + " WHERE " +
                    DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_TANDA_TERIMA_BG_MAIN_ID] + " = " + tandaTerimaBgMainId;

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
            String sql = "SELECT COUNT(" + DbTandaTerimaBGMain.colNames[DbTandaTerimaBGMain.COL_TANDA_TERIMA_BG_MAIN_ID] + ") FROM " + DB_TANDA_TERIMA_BG_MAIN;
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
                    TandaTerimaBGMain tandaTerimaBGMain = (TandaTerimaBGMain) list.get(ls);
                    if (oid == tandaTerimaBGMain.getOID()) {
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
