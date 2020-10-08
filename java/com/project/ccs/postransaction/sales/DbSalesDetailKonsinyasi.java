/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.sales;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;

/**
 *
 * @author Roy
 */
public class DbSalesDetailKonsinyasi extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SALES_DETAIL_KONSINYASI = "pos_sales_detail_konsinyasi";
    public static final int COL_SALES_DETAIL_KONSINYASI_ID = 0;
    public static final int COL_SALES_ID = 1;
    public static final int COL_SALES_DETAIL_ID = 2;
    public static final int COL_VENDOR_ID = 3;
    public static final int COL_CREATE_DATE = 4;
    public static final int COL_CREATE_ID = 5;
    public static final int COL_REFERENSI_ID = 6;
    
    public static final String[] colNames = {
        "sales_detail_konsinyasi_id",
        "sales_id",
        "sales_detail_id",
        "vendor_id",
        "create_date",
        "create_id",
        "referensi_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbSalesDetailKonsinyasi() {
    }

    public DbSalesDetailKonsinyasi(int i) throws CONException {
        super(new DbSalesDetailKonsinyasi());
    }

    public DbSalesDetailKonsinyasi(String sOid) throws CONException {
        super(new DbSalesDetailKonsinyasi(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSalesDetailKonsinyasi(long lOid) throws CONException {
        super(new DbSalesDetailKonsinyasi(0));
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
        return DB_SALES_DETAIL_KONSINYASI;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSalesDetailKonsinyasi().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SalesDetailKonsinyasi salesDetailKonsinyasi = fetchExc(ent.getOID());
        ent = (Entity) salesDetailKonsinyasi;
        return salesDetailKonsinyasi.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SalesDetailKonsinyasi) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SalesDetailKonsinyasi) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SalesDetailKonsinyasi fetchExc(long oid) throws CONException {
        try {
            SalesDetailKonsinyasi salesDetailKonsinyasi = new SalesDetailKonsinyasi();
            DbSalesDetailKonsinyasi dbpayment = new DbSalesDetailKonsinyasi(oid);
            salesDetailKonsinyasi.setOID(oid);
            salesDetailKonsinyasi.setSalesId(dbpayment.getlong(COL_SALES_ID));
            salesDetailKonsinyasi.setSalesDetailId(dbpayment.getlong(COL_SALES_DETAIL_ID));
            salesDetailKonsinyasi.setVendorId(dbpayment.getlong(COL_VENDOR_ID));
            salesDetailKonsinyasi.setCreateDate(dbpayment.getDate(COL_CREATE_DATE));
            salesDetailKonsinyasi.setCreateId(dbpayment.getlong(COL_CREATE_ID));
            salesDetailKonsinyasi.setReferensiId(dbpayment.getlong(COL_REFERENSI_ID));
            return salesDetailKonsinyasi;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesDetailKonsinyasi(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SalesDetailKonsinyasi salesDetailKonsinyasi) throws CONException {
        try {
            DbSalesDetailKonsinyasi dbpayment = new DbSalesDetailKonsinyasi(0);
            dbpayment.setLong(COL_SALES_ID, salesDetailKonsinyasi.getSalesId());
            dbpayment.setLong(COL_SALES_DETAIL_ID, salesDetailKonsinyasi.getSalesDetailId());
            dbpayment.setLong(COL_VENDOR_ID, salesDetailKonsinyasi.getVendorId());
            dbpayment.setDate(COL_CREATE_DATE, salesDetailKonsinyasi.getCreateDate());
            dbpayment.setLong(COL_CREATE_ID, salesDetailKonsinyasi.getCreateId());
            dbpayment.setLong(COL_REFERENSI_ID, salesDetailKonsinyasi.getReferensiId());
            dbpayment.insert();
            salesDetailKonsinyasi.setOID(dbpayment.getlong(COL_SALES_DETAIL_KONSINYASI_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesDetail(0), CONException.UNKNOWN);
        }
        return salesDetailKonsinyasi.getOID();
    }

    public static long updateExc(SalesDetailKonsinyasi salesDetailKonsinyasi) throws CONException {
        try {
            if (salesDetailKonsinyasi.getOID() != 0) {
                DbSalesDetailKonsinyasi dbpayment = new DbSalesDetailKonsinyasi(salesDetailKonsinyasi.getOID());
                dbpayment.setLong(COL_SALES_ID, salesDetailKonsinyasi.getSalesId());
                dbpayment.setLong(COL_SALES_DETAIL_ID, salesDetailKonsinyasi.getSalesDetailId());
                dbpayment.setLong(COL_VENDOR_ID, salesDetailKonsinyasi.getVendorId());
                dbpayment.setDate(COL_CREATE_DATE, salesDetailKonsinyasi.getCreateDate());
                dbpayment.setLong(COL_CREATE_ID, salesDetailKonsinyasi.getCreateId());
                dbpayment.setLong(COL_REFERENSI_ID, salesDetailKonsinyasi.getReferensiId());
                dbpayment.update();
                return salesDetailKonsinyasi.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesDetailKonsinyasi(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSalesDetailKonsinyasi dbPayment = new DbSalesDetailKonsinyasi(oid);
            dbPayment.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesDetailKonsinyasi(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SALES_DETAIL_KONSINYASI;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }
                    break;

                case CONHandler.CONSVR_SYBASE:
                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SalesDetailKonsinyasi salesDetailKonsinyasi = new SalesDetailKonsinyasi();
                resultToObject(rs, salesDetailKonsinyasi);
                lists.add(salesDetailKonsinyasi);
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

    private static void resultToObject(ResultSet rs, SalesDetailKonsinyasi salesDetailKonsinyasi) {
        try {
            salesDetailKonsinyasi.setOID(rs.getLong(DbSalesDetailKonsinyasi.colNames[DbSalesDetailKonsinyasi.COL_SALES_DETAIL_KONSINYASI_ID]));
            salesDetailKonsinyasi.setSalesId(rs.getLong(DbSalesDetailKonsinyasi.colNames[DbSalesDetailKonsinyasi.COL_SALES_ID]));
            salesDetailKonsinyasi.setSalesDetailId(rs.getLong(DbSalesDetailKonsinyasi.colNames[DbSalesDetailKonsinyasi.COL_SALES_DETAIL_ID]));            
            salesDetailKonsinyasi.setVendorId(rs.getLong(DbSalesDetailKonsinyasi.colNames[DbSalesDetailKonsinyasi.COL_VENDOR_ID]));
            salesDetailKonsinyasi.setCreateDate(rs.getDate(DbSalesDetailKonsinyasi.colNames[DbSalesDetailKonsinyasi.COL_CREATE_DATE]));
            salesDetailKonsinyasi.setCreateId(rs.getLong(DbSalesDetailKonsinyasi.colNames[DbSalesDetailKonsinyasi.COL_CREATE_ID]));
            salesDetailKonsinyasi.setReferensiId(rs.getLong(DbSalesDetailKonsinyasi.colNames[DbSalesDetailKonsinyasi.COL_REFERENSI_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long salesKonsinyasiId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SALES_DETAIL_KONSINYASI + " WHERE " +
                    DbSalesDetailKonsinyasi.colNames[DbSalesDetailKonsinyasi.COL_SALES_DETAIL_KONSINYASI_ID] + " = " + salesKonsinyasiId;
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
            String sql = "SELECT COUNT(" + DbSalesDetailKonsinyasi.colNames[DbSalesDetailKonsinyasi.COL_SALES_DETAIL_KONSINYASI_ID] + ") FROM " + DB_SALES_DETAIL_KONSINYASI;
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
                    SalesDetail salesDetail = (SalesDetail) list.get(ls);
                    if (oid == salesDetail.getOID()) {
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
