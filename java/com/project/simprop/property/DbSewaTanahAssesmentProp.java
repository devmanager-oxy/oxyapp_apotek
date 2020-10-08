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
public class DbSewaTanahAssesmentProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PROP_SEWA_TANAH_ASSESMENT = "prop_sewa_tanah_assesment";
    public static final int COL_SEWA_TANAH_ASSESMENT_ID = 0;
    public static final int COL_MULAI = 1;
    public static final int COL_SELESAI = 2;
    public static final int COL_RATE = 3;
    public static final int COL_UNIT_KONTRAK_ID = 4;
    public static final int COL_DASAR_PERHITUNGAN = 5;
    public static final int COL_SEWA_TANAH_ID = 6;
    public static final int COL_CURRENCY_ID = 7;
    
    public static final String[] colNames = {
        "sewa_tanah_assesment_id",
        "mulai",
        "selesai",
        "rate",
        "unit_kontrak_id",
        "dasar_perhitungan",
        "sewa_tanah_id",
        "currency_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_FLOAT3,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG
    };
    
    public static final int DASAR_LUAS = 0;
    public static final int DASAR_KAMAR = 1;
    public static final int DASAR_TOTAL = 2;
    public static String[] dasarPerhitungan = {"Luas", "Kamar", "Total"};

    public DbSewaTanahAssesmentProp() {
    }

    public DbSewaTanahAssesmentProp(int i) throws CONException {
        super(new DbSewaTanahAssesmentProp());
    }

    public DbSewaTanahAssesmentProp(String sOid) throws CONException {
        super(new DbSewaTanahAssesmentProp(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSewaTanahAssesmentProp(long lOid) throws CONException {
        super(new DbSewaTanahAssesmentProp(0));
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
        return DB_PROP_SEWA_TANAH_ASSESMENT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSewaTanahAssesmentProp().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SewaTanahAssesmentProp sewaTanahAssesmentProp = fetchExc(ent.getOID());
        ent = (Entity) sewaTanahAssesmentProp;
        return sewaTanahAssesmentProp.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SewaTanahAssesmentProp) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SewaTanahAssesmentProp) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SewaTanahAssesmentProp fetchExc(long oid) throws CONException {
        try {
            SewaTanahAssesmentProp sewaTanahAssesmentProp = new SewaTanahAssesmentProp();
            DbSewaTanahAssesmentProp pstSewaTanahAssesmentProp = new DbSewaTanahAssesmentProp(oid);
            sewaTanahAssesmentProp.setOID(oid);

            sewaTanahAssesmentProp.setMulai(pstSewaTanahAssesmentProp.getDate(COL_MULAI));
            sewaTanahAssesmentProp.setSelesai(pstSewaTanahAssesmentProp.getDate(COL_SELESAI));
            sewaTanahAssesmentProp.setRate(pstSewaTanahAssesmentProp.getdouble(COL_RATE));
            sewaTanahAssesmentProp.setUnitKontrakId(pstSewaTanahAssesmentProp.getlong(COL_UNIT_KONTRAK_ID));
            sewaTanahAssesmentProp.setDasarPerhitungan(pstSewaTanahAssesmentProp.getInt(COL_DASAR_PERHITUNGAN));
            sewaTanahAssesmentProp.setSewaTanahId(pstSewaTanahAssesmentProp.getlong(COL_SEWA_TANAH_ID));
            sewaTanahAssesmentProp.setCurrencyId(pstSewaTanahAssesmentProp.getlong(COL_CURRENCY_ID));

            return sewaTanahAssesmentProp;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahAssesmentProp(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SewaTanahAssesmentProp sewaTanahAssesmentProp) throws CONException {
        try {
            DbSewaTanahAssesmentProp pstSewaTanahAssesmentProp = new DbSewaTanahAssesmentProp(0);

            pstSewaTanahAssesmentProp.setDate(COL_MULAI, sewaTanahAssesmentProp.getMulai());
            pstSewaTanahAssesmentProp.setDate(COL_SELESAI, sewaTanahAssesmentProp.getSelesai());
            pstSewaTanahAssesmentProp.setDouble(COL_RATE, sewaTanahAssesmentProp.getRate());
            pstSewaTanahAssesmentProp.setLong(COL_UNIT_KONTRAK_ID, sewaTanahAssesmentProp.getUnitKontrakId());
            pstSewaTanahAssesmentProp.setInt(COL_DASAR_PERHITUNGAN, sewaTanahAssesmentProp.getDasarPerhitungan());
            pstSewaTanahAssesmentProp.setLong(COL_SEWA_TANAH_ID, sewaTanahAssesmentProp.getSewaTanahId());
            pstSewaTanahAssesmentProp.setLong(COL_CURRENCY_ID, sewaTanahAssesmentProp.getCurrencyId());

            pstSewaTanahAssesmentProp.insert();
            sewaTanahAssesmentProp.setOID(pstSewaTanahAssesmentProp.getlong(COL_SEWA_TANAH_ASSESMENT_ID));
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahAssesmentProp(0), CONException.UNKNOWN);
        }
        return sewaTanahAssesmentProp.getOID();
    }

    public static long updateExc(SewaTanahAssesmentProp sewaTanahAssesmentProp) throws CONException {
        try {
            if (sewaTanahAssesmentProp.getOID() != 0) {
                DbSewaTanahAssesmentProp pstSewaTanahAssesmentProp = new DbSewaTanahAssesmentProp(sewaTanahAssesmentProp.getOID());
                pstSewaTanahAssesmentProp.setDate(COL_MULAI, sewaTanahAssesmentProp.getMulai());
                pstSewaTanahAssesmentProp.setDate(COL_SELESAI, sewaTanahAssesmentProp.getSelesai());
                pstSewaTanahAssesmentProp.setDouble(COL_RATE, sewaTanahAssesmentProp.getRate());
                pstSewaTanahAssesmentProp.setLong(COL_UNIT_KONTRAK_ID, sewaTanahAssesmentProp.getUnitKontrakId());
                pstSewaTanahAssesmentProp.setInt(COL_DASAR_PERHITUNGAN, sewaTanahAssesmentProp.getDasarPerhitungan());
                pstSewaTanahAssesmentProp.setLong(COL_SEWA_TANAH_ID, sewaTanahAssesmentProp.getSewaTanahId());
                pstSewaTanahAssesmentProp.setLong(COL_CURRENCY_ID, sewaTanahAssesmentProp.getCurrencyId());
                pstSewaTanahAssesmentProp.update();
                return sewaTanahAssesmentProp.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahAssesmentProp(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSewaTanahAssesmentProp pstSewaTanahAssesmentProp = new DbSewaTanahAssesmentProp(oid);
            pstSewaTanahAssesmentProp.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahAssesmentProp(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_ASSESMENT;
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
                SewaTanahAssesmentProp sewaTanahAssesmentProp = new SewaTanahAssesmentProp();
                resultToObject(rs, sewaTanahAssesmentProp);
                lists.add(sewaTanahAssesmentProp);
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

    private static void resultToObject(ResultSet rs, SewaTanahAssesmentProp sewaTanahAssesmentProp) {
        try {
            sewaTanahAssesmentProp.setOID(rs.getLong(DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_SEWA_TANAH_ASSESMENT_ID]));
            sewaTanahAssesmentProp.setMulai(rs.getDate(DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_MULAI]));
            sewaTanahAssesmentProp.setSelesai(rs.getDate(DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_SELESAI]));
            sewaTanahAssesmentProp.setRate(rs.getDouble(DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_RATE]));
            sewaTanahAssesmentProp.setUnitKontrakId(rs.getLong(DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_UNIT_KONTRAK_ID]));
            sewaTanahAssesmentProp.setDasarPerhitungan(rs.getInt(DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_DASAR_PERHITUNGAN]));
            sewaTanahAssesmentProp.setSewaTanahId(rs.getLong(DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_SEWA_TANAH_ID]));
            sewaTanahAssesmentProp.setCurrencyId(rs.getLong(DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_CURRENCY_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sewaTanahAssesmentId){
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            
            String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_ASSESMENT + " WHERE " +
                    DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_SEWA_TANAH_ASSESMENT_ID] + " = " + sewaTanahAssesmentId;

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
            String sql = "SELECT COUNT(" + DbSewaTanahAssesmentProp.colNames[DbSewaTanahAssesmentProp.COL_SEWA_TANAH_ASSESMENT_ID] + ") FROM " + DB_PROP_SEWA_TANAH_ASSESMENT;
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
                    SewaTanahAssesmentProp sewaTanahAssesmentProp = (SewaTanahAssesmentProp) list.get(ls);
                    if (oid == sewaTanahAssesmentProp.getOID()) {
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

    public static SewaTanahAssesmentProp getActifAssesment(int year, long sewaTanahId) {

        Date dt = new Date();
        dt.setYear(year - 1900);

        String sql = "select * from " + DB_PROP_SEWA_TANAH_ASSESMENT +
                " where '" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "'" +
                " between " + colNames[COL_MULAI] +
                " and " + colNames[COL_SELESAI] + " and " + colNames[COL_SEWA_TANAH_ID] + "=" + sewaTanahId;

        SewaTanahAssesmentProp sta = new SewaTanahAssesmentProp();
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                resultToObject(rs, sta);
            }
        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return sta;

    }
}
