/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.journal;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

/**
/**
 *
 * @author Roy
 */
public class DbMemorialKonsinyasi extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_MEMORIAL_KONSINYASI = "memorial_konsinyasi";
    
    public static final int CL_MEMORIAL_KONSINYASI_ID = 0;
    public static final int CL_START_DATE = 1;
    public static final int CL_END_DATE = 2;
    public static final int CL_VENDOR_ID = 3;
    public static final int CL_LOCATION_ID = 4;
    public static final int CL_USER_ID = 5;
    public static final int CL_CREATE_DATE = 6;
    public static final int CL_UNIQ_KEY_ID = 7;
    public static final int CL_TYPE = 8;
    
    public static final String[] colNames = {
        "memorial_konsinyasi_id",
        "start_date",
        "end_date",
        "vendor_id",
        "location_id",
        "user_id",
        "create_date",
        "uniq_key_id",
        "type"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT
    };
    
     public static int TYPE_CONSIGNED_BY_COST   = 0;
     public static int TYPE_CONSIGNED_BY_PRICE  = 1;

    public DbMemorialKonsinyasi() {
    }

    public DbMemorialKonsinyasi(int i) throws CONException {
        super(new DbMemorialKonsinyasi());
    }

    public DbMemorialKonsinyasi(String sOid) throws CONException {
        super(new DbMemorialKonsinyasi(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbMemorialKonsinyasi(long lOid) throws CONException {
        super(new DbMemorialKonsinyasi(0));
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
        return DB_MEMORIAL_KONSINYASI;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbMemorialKonsinyasi().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        MemorialKonsinyasi memorialKonsinyasi = fetchExc(ent.getOID());
        ent = (Entity) memorialKonsinyasi;
        return memorialKonsinyasi.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((MemorialKonsinyasi) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((MemorialKonsinyasi) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static MemorialKonsinyasi fetchExc(long oid) throws CONException {
        try {
            MemorialKonsinyasi memorialKonsinyasi = new MemorialKonsinyasi();
            DbMemorialKonsinyasi pstMemorialKonsinyasi = new DbMemorialKonsinyasi(oid);
            memorialKonsinyasi.setOID(oid);

            memorialKonsinyasi.setStartDate(pstMemorialKonsinyasi.getDate(CL_START_DATE));
            memorialKonsinyasi.setEndDate(pstMemorialKonsinyasi.getDate(CL_END_DATE));
            memorialKonsinyasi.setVendorId(pstMemorialKonsinyasi.getlong(CL_VENDOR_ID));
            memorialKonsinyasi.setLocationId(pstMemorialKonsinyasi.getlong(CL_LOCATION_ID));
            memorialKonsinyasi.setUserId(pstMemorialKonsinyasi.getlong(CL_USER_ID));
            memorialKonsinyasi.setCreateDate(pstMemorialKonsinyasi.getDate(CL_CREATE_DATE));
            memorialKonsinyasi.setUniqKeyId(pstMemorialKonsinyasi.getlong(CL_UNIQ_KEY_ID));
            memorialKonsinyasi.setType(pstMemorialKonsinyasi.getInt(CL_TYPE));

            return memorialKonsinyasi;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialKonsinyasi(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(MemorialKonsinyasi memorialKonsinyasi) throws CONException {
        try {
            DbMemorialKonsinyasi pstMemorialKonsinyasi = new DbMemorialKonsinyasi(0);
            pstMemorialKonsinyasi.setDate(CL_START_DATE, memorialKonsinyasi.getStartDate());
            pstMemorialKonsinyasi.setDate(CL_END_DATE, memorialKonsinyasi.getEndDate());
            pstMemorialKonsinyasi.setLong(CL_VENDOR_ID, memorialKonsinyasi.getVendorId());
            pstMemorialKonsinyasi.setLong(CL_LOCATION_ID, memorialKonsinyasi.getLocationId());
            pstMemorialKonsinyasi.setLong(CL_USER_ID, memorialKonsinyasi.getUserId());
            pstMemorialKonsinyasi.setDate(CL_CREATE_DATE, memorialKonsinyasi.getCreateDate());
            pstMemorialKonsinyasi.setLong(CL_UNIQ_KEY_ID, memorialKonsinyasi.getUniqKeyId());
            pstMemorialKonsinyasi.setInt(CL_TYPE, memorialKonsinyasi.getType());
            pstMemorialKonsinyasi.insert();
            memorialKonsinyasi.setOID(pstMemorialKonsinyasi.getlong(CL_MEMORIAL_KONSINYASI_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialKonsinyasi(0), CONException.UNKNOWN);
        }
        return memorialKonsinyasi.getOID();
    }

    public static long updateExc(MemorialKonsinyasi memorialKonsinyasi) throws CONException {
        try {
            if (memorialKonsinyasi.getOID() != 0) {
                DbMemorialKonsinyasi pstMemorialKonsinyasi = new DbMemorialKonsinyasi(memorialKonsinyasi.getOID());

                pstMemorialKonsinyasi.setDate(CL_START_DATE, memorialKonsinyasi.getStartDate());
                pstMemorialKonsinyasi.setDate(CL_END_DATE, memorialKonsinyasi.getEndDate());
                pstMemorialKonsinyasi.setLong(CL_VENDOR_ID, memorialKonsinyasi.getVendorId());
                pstMemorialKonsinyasi.setLong(CL_LOCATION_ID, memorialKonsinyasi.getLocationId());
                pstMemorialKonsinyasi.setLong(CL_USER_ID, memorialKonsinyasi.getUserId());
                pstMemorialKonsinyasi.setDate(CL_CREATE_DATE, memorialKonsinyasi.getCreateDate());
                pstMemorialKonsinyasi.setLong(CL_UNIQ_KEY_ID, memorialKonsinyasi.getUniqKeyId());
                pstMemorialKonsinyasi.setInt(CL_TYPE, memorialKonsinyasi.getType());

                pstMemorialKonsinyasi.update();
                return memorialKonsinyasi.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialKonsinyasi(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbMemorialKonsinyasi pstMemorialKonsinyasi = new DbMemorialKonsinyasi(oid);
            pstMemorialKonsinyasi.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialKonsinyasi(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_MEMORIAL_KONSINYASI;
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
                MemorialKonsinyasi memorialKonsinyasi = new MemorialKonsinyasi();
                resultToObject(rs, memorialKonsinyasi);
                lists.add(memorialKonsinyasi);
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

    private static void resultToObject(ResultSet rs, MemorialKonsinyasi memorialKonsinyasi) {
        try {
            memorialKonsinyasi.setOID(rs.getLong(DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_MEMORIAL_KONSINYASI_ID]));
            memorialKonsinyasi.setStartDate(rs.getDate(DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_START_DATE]));
            memorialKonsinyasi.setEndDate(rs.getDate(DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_END_DATE]));
            memorialKonsinyasi.setVendorId(rs.getLong(DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_VENDOR_ID]));
            memorialKonsinyasi.setLocationId(rs.getLong(DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_LOCATION_ID]));
            memorialKonsinyasi.setUserId(rs.getLong(DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_USER_ID]));
            memorialKonsinyasi.setUniqKeyId(rs.getLong(DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_UNIQ_KEY_ID]));
            memorialKonsinyasi.setCreateDate(rs.getDate(DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_CREATE_DATE]));
            memorialKonsinyasi.setType(rs.getInt(DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_TYPE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long memorialId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_MEMORIAL_KONSINYASI + " WHERE " +
                    DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_MEMORIAL_KONSINYASI_ID] + " = " + memorialId;

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
            String sql = "SELECT COUNT(" + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_MEMORIAL_KONSINYASI_ID] + ") FROM " + DB_MEMORIAL_KONSINYASI;
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
                    MemorialKonsinyasi memorialKonsinyasi = (MemorialKonsinyasi) list.get(ls);
                    if (oid == memorialKonsinyasi.getOID()) {
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
