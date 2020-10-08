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
public class DbTandaTerimaBG extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_TANDA_TERIMA_BG = "tanda_terima_bg";
    
    public static final int COL_TANDA_TERIMA_BG_ID = 0;   
    public static final int COL_BANKPO_PAYMENT_ID = 1;
    public static final int COL_VENDOR_ID = 2;
    public static final int COL_SUPPLIER_NAME = 3;
    public static final int COL_TRANS_DATE = 4;
    public static final int COL_AMOUNT = 5;
    public static final int COL_TANDA_TERIMA_BG_MAIN_ID = 6;

    public static final String[] colNames = {
        "tanda_terima_bg_id", 
        "bankpo_payment_id", 
        "vendor_id",
        "supplier_name", 
        "trans_date", 
        "amount", 
        "tanda_terima_bg_main_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID, 
        TYPE_LONG, 
        TYPE_LONG,
        TYPE_STRING, 
        TYPE_DATE, 
        TYPE_FLOAT,
        TYPE_LONG
    };

    public DbTandaTerimaBG() {
    }

    public DbTandaTerimaBG(int i) throws CONException {
        super(new DbTandaTerimaBG());
    }

    public DbTandaTerimaBG(String sOid) throws CONException {
        super(new DbTandaTerimaBG(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbTandaTerimaBG(long lOid) throws CONException {
        super(new DbTandaTerimaBG(0));
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
        return DB_TANDA_TERIMA_BG;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbTandaTerimaBG().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        TandaTerimaBG tandaTerimaBG = fetchExc(ent.getOID());
        ent = (Entity) tandaTerimaBG;
        return tandaTerimaBG.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((TandaTerimaBG) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((TandaTerimaBG) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static TandaTerimaBG fetchExc(long oid) throws CONException {
        try {
            TandaTerimaBG tandaTerimaBG = new TandaTerimaBG();
            DbTandaTerimaBG DbTandaTerimaBG = new DbTandaTerimaBG(oid);
            tandaTerimaBG.setOID(oid);           
            tandaTerimaBG.setBankpoPaymentId(DbTandaTerimaBG.getlong(COL_BANKPO_PAYMENT_ID));
            tandaTerimaBG.setVendorId(DbTandaTerimaBG.getlong(COL_VENDOR_ID));
            tandaTerimaBG.setSupplierName(DbTandaTerimaBG.getString(COL_SUPPLIER_NAME));
            tandaTerimaBG.setTransDate(DbTandaTerimaBG.getDate(COL_TRANS_DATE));
            tandaTerimaBG.setAmount(DbTandaTerimaBG.getdouble(COL_AMOUNT));
            tandaTerimaBG.setTandaTerimaBgMainId(DbTandaTerimaBG.getlong(COL_TANDA_TERIMA_BG_MAIN_ID));
            return tandaTerimaBG;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTandaTerimaBG(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(TandaTerimaBG tandaTerimaBG) throws CONException {
        try {            
            DbTandaTerimaBG dbTandaTerimaBG = new DbTandaTerimaBG(0);
            dbTandaTerimaBG.setLong(COL_BANKPO_PAYMENT_ID, tandaTerimaBG.getBankpoPaymentId());
            dbTandaTerimaBG.setLong(COL_VENDOR_ID, tandaTerimaBG.getVendorId());
            dbTandaTerimaBG.setString(COL_SUPPLIER_NAME, tandaTerimaBG.getSupplierName());
            dbTandaTerimaBG.setDate(COL_TRANS_DATE, tandaTerimaBG.getTransDate());
            dbTandaTerimaBG.setDouble(COL_AMOUNT, tandaTerimaBG.getAmount());
            dbTandaTerimaBG.setLong(COL_TANDA_TERIMA_BG_MAIN_ID, tandaTerimaBG.getTandaTerimaBgMainId());
            dbTandaTerimaBG.insert();
            tandaTerimaBG.setOID(dbTandaTerimaBG.getLong(COL_TANDA_TERIMA_BG_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTandaTerimaBG(0), CONException.UNKNOWN);
        }
        return tandaTerimaBG.getOID();
    }

    public static long updateExc(TandaTerimaBG tandaTerimaBG) throws CONException {
        try {
            if (tandaTerimaBG.getOID() != 0) {
                DbTandaTerimaBG DbTandaTerimaBG = new DbTandaTerimaBG(tandaTerimaBG.getOID());                
                DbTandaTerimaBG.setLong(COL_BANKPO_PAYMENT_ID, tandaTerimaBG.getBankpoPaymentId());
                DbTandaTerimaBG.setLong(COL_VENDOR_ID, tandaTerimaBG.getVendorId());
                DbTandaTerimaBG.setString(COL_SUPPLIER_NAME, tandaTerimaBG.getSupplierName());
                DbTandaTerimaBG.setDate(COL_TRANS_DATE, tandaTerimaBG.getTransDate());
                DbTandaTerimaBG.setDouble(COL_AMOUNT, tandaTerimaBG.getAmount());
                DbTandaTerimaBG.setLong(COL_TANDA_TERIMA_BG_MAIN_ID, tandaTerimaBG.getTandaTerimaBgMainId());
                DbTandaTerimaBG.update();
                return tandaTerimaBG.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTandaTerimaBG(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbTandaTerimaBG DbTandaTerimaBG = new DbTandaTerimaBG(oid);
            DbTandaTerimaBG.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTandaTerimaBG(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_TANDA_TERIMA_BG;
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
                TandaTerimaBG tandaTerimaBG = new TandaTerimaBG();
                resultToObject(rs, tandaTerimaBG);
                lists.add(tandaTerimaBG);
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

    private static void resultToObject(ResultSet rs, TandaTerimaBG tandaTerimaBG) {
        try {
            tandaTerimaBG.setOID(rs.getLong(DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_TANDA_TERIMA_BG_ID]));            
            tandaTerimaBG.setBankpoPaymentId(rs.getLong(DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_BANKPO_PAYMENT_ID]));
            tandaTerimaBG.setVendorId(rs.getLong(DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_VENDOR_ID]));
            tandaTerimaBG.setSupplierName(rs.getString(DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_SUPPLIER_NAME]));
            tandaTerimaBG.setTransDate(rs.getDate(DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_TRANS_DATE]));
            tandaTerimaBG.setAmount(rs.getDouble(DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_AMOUNT]));
            tandaTerimaBG.setTandaTerimaBgMainId(rs.getLong(DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_TANDA_TERIMA_BG_MAIN_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long tandaTerimaBgId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_TANDA_TERIMA_BG + " WHERE " +
                    DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_TANDA_TERIMA_BG_ID] + " = " + tandaTerimaBgId;

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
            String sql = "SELECT COUNT(" + DbTandaTerimaBG.colNames[DbTandaTerimaBG.COL_TANDA_TERIMA_BG_ID] + ") FROM " + DB_TANDA_TERIMA_BG;
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
                    TandaTerimaBG tandaTerimaBG = (TandaTerimaBG) list.get(ls);
                    if (oid == tandaTerimaBG.getOID()) {
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
