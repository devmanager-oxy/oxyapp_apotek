/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.util.*;

/**
 *
 * @author Roy Andika
 */
public class DbSewaTanahKominProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PROP_SEWA_TANAH_KOMIN = "prop_sewa_tanah_komin";
    
    public static final int COL_SEWA_TANAH_KOMIN_ID = 0;
    public static final int COL_NAMA = 1;
    public static final int COL_TYPE = 2;
    public static final int COL_MULAI = 3;
    public static final int COL_SELESAI = 4;
    public static final int COL_RATE = 5;
    public static final int COL_UNIT_KONTRAK_ID = 6;
    public static final int COL_KETERANGAN = 7;
    public static final int COL_SEWA_TANAH_ID = 8;
    public static final int COL_DASAR_PERHITUNGAN = 9;
    
    public static final String[] colNames = {
        "sewa_tanah_komin_id",
        "nama",
        "type",
        "mulai",
        "selesai",
        "rate",
        "unit_kontrak_id",
        "keterangan",
        "sewa_tanah_id",
        "dasar_perhitungan"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_INT,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_FLOAT3,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_INT
    };
    
    public static int KOMIN_BY_ROOM = 1;
    public static int KOMIN_BY_SQUARE = 2;
    public static int KOMIN_BY_TOTAL = 3;
    
    public static String[] strKominBy = {"", "Kamar", "Luas", "Total"};

    public DbSewaTanahKominProp() {
    }

    public DbSewaTanahKominProp(int i) throws CONException {
        super(new DbSewaTanahKominProp());
    }

    public DbSewaTanahKominProp(String sOid) throws CONException {
        super(new DbSewaTanahKominProp(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSewaTanahKominProp(long lOid) throws CONException {
        super(new DbSewaTanahKominProp(0));
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
        return DB_PROP_SEWA_TANAH_KOMIN;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSewaTanahKominProp().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SewaTanahKominProp sewaTanahKominProp = fetchExc(ent.getOID());
        ent = (Entity) sewaTanahKominProp;
        return sewaTanahKominProp.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SewaTanahKominProp) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SewaTanahKominProp) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SewaTanahKominProp fetchExc(long oid) throws CONException {
        try {
            SewaTanahKominProp sewaTanahKominProp = new SewaTanahKominProp();
            DbSewaTanahKominProp pstSewaTanahKominProp = new DbSewaTanahKominProp(oid);
            sewaTanahKominProp.setOID(oid);

            sewaTanahKominProp.setNama(pstSewaTanahKominProp.getString(COL_NAMA));
            sewaTanahKominProp.setType(pstSewaTanahKominProp.getInt(COL_TYPE));
            sewaTanahKominProp.setMulai(pstSewaTanahKominProp.getDate(COL_MULAI));
            sewaTanahKominProp.setSelesai(pstSewaTanahKominProp.getDate(COL_SELESAI));
            sewaTanahKominProp.setRate(pstSewaTanahKominProp.getdouble(COL_RATE));
            sewaTanahKominProp.setUnitKontrakId(pstSewaTanahKominProp.getlong(COL_UNIT_KONTRAK_ID));
            sewaTanahKominProp.setKeterangan(pstSewaTanahKominProp.getString(COL_KETERANGAN));
            sewaTanahKominProp.setSewaTanahId(pstSewaTanahKominProp.getlong(COL_SEWA_TANAH_ID));
            sewaTanahKominProp.setDasarPerhitungan(pstSewaTanahKominProp.getInt(COL_DASAR_PERHITUNGAN));

            return sewaTanahKominProp;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahKominProp(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SewaTanahKominProp sewaTanahKominProp) throws CONException {
        try {
            DbSewaTanahKominProp pstSewaTanahKominProp = new DbSewaTanahKominProp(0);

            pstSewaTanahKominProp.setString(COL_NAMA, sewaTanahKominProp.getNama());
            pstSewaTanahKominProp.setInt(COL_TYPE, sewaTanahKominProp.getType());
            pstSewaTanahKominProp.setDate(COL_MULAI, sewaTanahKominProp.getMulai());
            pstSewaTanahKominProp.setDate(COL_SELESAI, sewaTanahKominProp.getSelesai());
            pstSewaTanahKominProp.setDouble(COL_RATE, sewaTanahKominProp.getRate());
            pstSewaTanahKominProp.setLong(COL_UNIT_KONTRAK_ID, sewaTanahKominProp.getUnitKontrakId());
            pstSewaTanahKominProp.setString(COL_KETERANGAN, sewaTanahKominProp.getKeterangan());
            pstSewaTanahKominProp.setLong(COL_SEWA_TANAH_ID, sewaTanahKominProp.getSewaTanahId());
            pstSewaTanahKominProp.setInt(COL_DASAR_PERHITUNGAN, sewaTanahKominProp.getDasarPerhitungan());

            pstSewaTanahKominProp.insert();
            sewaTanahKominProp.setOID(pstSewaTanahKominProp.getlong(COL_SEWA_TANAH_KOMIN_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahKominProp(0), CONException.UNKNOWN);
        }
        return sewaTanahKominProp.getOID();
    }

    public static long updateExc(SewaTanahKominProp sewaTanahKominProp) throws CONException {
        try {
            if (sewaTanahKominProp.getOID() != 0) {
                DbSewaTanahKominProp pstSewaTanahKominProp = new DbSewaTanahKominProp(sewaTanahKominProp.getOID());

                pstSewaTanahKominProp.setString(COL_NAMA, sewaTanahKominProp.getNama());
                pstSewaTanahKominProp.setInt(COL_TYPE, sewaTanahKominProp.getType());
                pstSewaTanahKominProp.setDate(COL_MULAI, sewaTanahKominProp.getMulai());
                pstSewaTanahKominProp.setDate(COL_SELESAI, sewaTanahKominProp.getSelesai());
                pstSewaTanahKominProp.setDouble(COL_RATE, sewaTanahKominProp.getRate());
                pstSewaTanahKominProp.setLong(COL_UNIT_KONTRAK_ID, sewaTanahKominProp.getUnitKontrakId());
                pstSewaTanahKominProp.setString(COL_KETERANGAN, sewaTanahKominProp.getKeterangan());
                pstSewaTanahKominProp.setLong(COL_SEWA_TANAH_ID, sewaTanahKominProp.getSewaTanahId());
                pstSewaTanahKominProp.setInt(COL_DASAR_PERHITUNGAN, sewaTanahKominProp.getDasarPerhitungan());

                pstSewaTanahKominProp.update();
                return sewaTanahKominProp.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahKominProp(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSewaTanahKominProp pstSewaTanahKominProp = new DbSewaTanahKominProp(oid);
            pstSewaTanahKominProp.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahKominProp(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_KOMIN;
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
            System.out.println("sql " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SewaTanahKominProp sewaTanahKominProp = new SewaTanahKominProp();
                resultToObject(rs, sewaTanahKominProp);
                lists.add(sewaTanahKominProp);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("List DbSewaTanahKominProp() : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, SewaTanahKominProp sewaTanahKominProp) {
        try {
            sewaTanahKominProp.setOID(rs.getLong(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_SEWA_TANAH_KOMIN_ID]));
            sewaTanahKominProp.setNama(rs.getString(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_NAMA]));
            sewaTanahKominProp.setType(rs.getInt(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_TYPE]));
            sewaTanahKominProp.setMulai(rs.getDate(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_MULAI]));
            sewaTanahKominProp.setSelesai(rs.getDate(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_SELESAI]));
            sewaTanahKominProp.setRate(rs.getDouble(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_RATE]));
            sewaTanahKominProp.setUnitKontrakId(rs.getLong(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_UNIT_KONTRAK_ID]));
            sewaTanahKominProp.setKeterangan(rs.getString(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_KETERANGAN]));
            sewaTanahKominProp.setSewaTanahId(rs.getLong(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_SEWA_TANAH_ID]));
            sewaTanahKominProp.setDasarPerhitungan(rs.getInt(DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_DASAR_PERHITUNGAN]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sewaTanahKominId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_KOMIN + " WHERE " +
                    DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_SEWA_TANAH_KOMIN_ID] + " = " + sewaTanahKominId;

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
            String sql = "SELECT COUNT(" + DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_SEWA_TANAH_KOMIN_ID] + ") FROM " + DB_PROP_SEWA_TANAH_KOMIN;
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
                    SewaTanahKominProp sewaTanahKominProp = (SewaTanahKominProp) list.get(ls);
                    if (oid == sewaTanahKominProp.getOID()) {
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

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order, String group) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_KOMIN;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (group != null && group.length() > 0) {
                sql = sql + " GROUP BY " + group;
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
                SewaTanahKominProp sewaTanahKominProp = new SewaTanahKominProp();
                resultToObject(rs, sewaTanahKominProp);
                lists.add(sewaTanahKominProp);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("List DbSewaTanahKominProp() : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Date getMulai(String period) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT MIN(" + DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_MULAI] + ") FROM " +
                    DbSewaTanahKominProp.DB_PROP_SEWA_TANAH_KOMIN + " WHERE " +
                    DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_NAMA] + " = '" + period + "'";

            System.out.println("sql " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                return rs.getDate(1);
            }

        } catch (Exception E) {
            System.out.println("");
        }

        return null;

    }

    public static Date getSelesai(String period){

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT MAX(" + DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_SELESAI] + ") FROM " +
                    DbSewaTanahKominProp.DB_PROP_SEWA_TANAH_KOMIN + " WHERE " +
                    DbSewaTanahKominProp.colNames[DbSewaTanahKominProp.COL_NAMA] + " = '" + period + "'";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                return rs.getDate(1);
            }

        } catch (Exception E) {
            System.out.println("");
        }

        return null;

    }

    public static SewaTanahKominProp getActifKomin(int year, long sewaTanahId) {

        Date dt = new Date();
        dt.setYear(year - 1900);

        String sql = "select * from " + DB_PROP_SEWA_TANAH_KOMIN +
                " where '" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "'" +
                " between " + colNames[COL_MULAI] +
                " and " + colNames[COL_SELESAI] + " and " + colNames[COL_SEWA_TANAH_ID] + "=" + sewaTanahId;

        System.out.println(sql);

        SewaTanahKominProp stk = new SewaTanahKominProp();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                resultToObject(rs, stk);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return stk;

    }
}
