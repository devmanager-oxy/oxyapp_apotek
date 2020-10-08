/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.uploader;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;
/**
 *
 * @author Roy
 */
public class DbCashCashierUpload extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_CASH_CASHIER_UPLOAD = "pos_cash_cashier_upload";
    
    public static final int COL_CASH_CASHIER_UPLOAD_ID = 0;
    public static final int COL_CASH_CASHIER_ID = 1;
    public static final int COL_DATE = 2;
    public static final int COL_QUERY_STRING = 3;  
    public static final int COL_STATUS_UPLOAD = 4;  
    
    public static final String[] colNames = {
        "cash_cashier_upload_id",
        "cash_cashier_id",
        "date",
        "query_string",
        "status_upload"        
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG, 
        TYPE_DATE, 
        TYPE_STRING,
        TYPE_INT
    };

    public DbCashCashierUpload() {
    }

    public DbCashCashierUpload(int i) throws CONException {
        super(new DbCashCashierUpload());
    }

    public DbCashCashierUpload(String sOid) throws CONException {
        super(new DbCashCashierUpload(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCashCashierUpload(long lOid) throws CONException {
        super(new DbCashCashierUpload(0));
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
        return DB_POS_CASH_CASHIER_UPLOAD;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCashCashierUpload().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CashCashierUpload cashCashierUpload = fetchExc(ent.getOID());
        ent = (Entity) cashCashierUpload;
        return cashCashierUpload.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CashCashierUpload) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CashCashierUpload) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CashCashierUpload fetchExc(long oid) throws CONException {
        try {
            CashCashierUpload cashCashierUpload = new CashCashierUpload();
            DbCashCashierUpload pstCashierUpload = new DbCashCashierUpload(oid);
            cashCashierUpload.setOID(oid);
            cashCashierUpload.setCashCashierId(pstCashierUpload.getlong(COL_CASH_CASHIER_ID));
            cashCashierUpload.setDate(pstCashierUpload.getDate(COL_DATE));
            cashCashierUpload.setQueryString(pstCashierUpload.getString(COL_QUERY_STRING));
            cashCashierUpload.setStatusUpload(pstCashierUpload.getInt(COL_STATUS_UPLOAD));

            return cashCashierUpload;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashCashierUpload(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(CashCashierUpload cashCashierUpload) throws CONException {
        try {
            DbCashCashierUpload pstCashierUpload = new DbCashCashierUpload(0);
            pstCashierUpload.setLong(COL_CASH_CASHIER_ID, cashCashierUpload.getCashCashierId());
            pstCashierUpload.setDate(COL_DATE, cashCashierUpload.getDate());
            pstCashierUpload.setString(COL_QUERY_STRING, cashCashierUpload.getQueryString());
            pstCashierUpload.setInt(COL_STATUS_UPLOAD, cashCashierUpload.getStatusUpload());
            pstCashierUpload.insert();
            cashCashierUpload.setOID(pstCashierUpload.getlong(COL_CASH_CASHIER_UPLOAD_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashCashierUpload(0), CONException.UNKNOWN);
        }
        return cashCashierUpload.getOID();
    }

    public static long updateExc(CashCashierUpload cashCashierUpload) throws CONException {
        try {
            if (cashCashierUpload.getOID() != 0) {
                DbCashCashierUpload pstCashierUpload = new DbCashCashierUpload(cashCashierUpload.getOID());

                pstCashierUpload.setLong(COL_CASH_CASHIER_ID, cashCashierUpload.getCashCashierId());
                pstCashierUpload.setDate(COL_DATE, cashCashierUpload.getDate());
                pstCashierUpload.setString(COL_QUERY_STRING, cashCashierUpload.getQueryString());
                pstCashierUpload.setInt(COL_STATUS_UPLOAD, cashCashierUpload.getStatusUpload());
                
                pstCashierUpload.update();
                return cashCashierUpload.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashCashierUpload(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCashCashierUpload pstCashierUpload = new DbCashCashierUpload(oid);
            pstCashierUpload.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashCashierUpload(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_CASH_CASHIER_UPLOAD;
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
                CashCashierUpload cashCashierUpload = new CashCashierUpload();
                resultToObject(rs, cashCashierUpload);
                lists.add(cashCashierUpload);
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

    private static void resultToObject(ResultSet rs, CashCashierUpload cashCashierUpload) {
        try {
            cashCashierUpload.setOID(rs.getLong(DbCashCashierUpload.colNames[DbCashCashierUpload.COL_CASH_CASHIER_UPLOAD_ID])); 
            cashCashierUpload.setCashCashierId(rs.getLong(DbCashCashierUpload.colNames[DbCashCashierUpload.COL_CASH_CASHIER_ID])); 
            cashCashierUpload.setDate(rs.getDate(DbCashCashierUpload.colNames[DbCashCashierUpload.COL_DATE]));
            cashCashierUpload.setQueryString(rs.getString(DbCashCashierUpload.colNames[DbCashCashierUpload.COL_QUERY_STRING]));
            cashCashierUpload.setStatusUpload(rs.getInt(DbCashCashierUpload.colNames[DbCashCashierUpload.COL_STATUS_UPLOAD]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long cashUploadId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_CASH_CASHIER_UPLOAD + " WHERE " +
                    DbCashCashierUpload.colNames[DbCashCashierUpload.COL_CASH_CASHIER_UPLOAD_ID] + " = " + cashUploadId;

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
            String sql = "SELECT COUNT(" + DbCashCashierUpload.colNames[DbCashCashierUpload.COL_CASH_CASHIER_UPLOAD_ID] + ") FROM " + DB_POS_CASH_CASHIER_UPLOAD;
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
                    CashCashierUpload cashCashierUpload = (CashCashierUpload) list.get(ls);
                    if (oid == cashCashierUpload.getOID()) {
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
