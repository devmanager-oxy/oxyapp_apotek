/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 *
 * @author Tu Roy
 */
package com.project.crm.master.limbah;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.crm.master.*;
import com.project.general.*;
import com.project.system.*;
import com.project.util.*;

public class DbLimbah extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_LIMBAH = "crm_master_limbah";
    public static final int COL_MASTER_LIMBAH_ID = 0;
    public static final int COL_RATE = 1;
    public static final int COL_UNIT = 2;
    public static final int COL_PERCENTAGE_USED = 3;
    public static final int COL_STATUS = 4;
    public static final int COL_PERIODE_ID = 5;
    public static final int COL_PPN_PERCENT = 6;
    public static final int COL_PRICE_TYPE = 7;
    
    public static final String[] colNames = {
        "master_limbah_id",
        "rate",
        "unit",
        "percentage_used",
        "status",
        "periode_id",
        "ppn_percent",
        "price_type"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT
    };
    
    public static final int POSTED_STATUS_UNPOST = 0;
    public static final int POSTED_STATUS_POSTED = 1;
    public static final String[] postKey = {"Active", "InActive"};
    public static final int[] postValue = {0, 1};

    public DbLimbah() {
    }

    public DbLimbah(int i) throws CONException {
        super(new DbLimbah());
    }

    public DbLimbah(String sOid) throws CONException {
        super(new DbLimbah(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLimbah(long lOid) throws CONException {
        super(new DbLimbah(0));
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
        return DB_LIMBAH;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLimbah().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Limbah limbah = fetchExc(ent.getOID());
        ent = (Entity) limbah;
        return limbah.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Limbah) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Limbah) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Limbah fetchExc(long oid) throws CONException {
        try {
            Limbah limbah = new Limbah();
            DbLimbah dbLimbah = new DbLimbah(oid);
            
            limbah.setOID(oid);
            limbah.setRate(dbLimbah.getdouble(COL_RATE));
            limbah.setUnit(dbLimbah.getlong(COL_UNIT));
            limbah.setPercentageUsed(dbLimbah.getdouble(COL_PERCENTAGE_USED));
            limbah.setStatus(dbLimbah.getInt(COL_STATUS));
            limbah.setPeriodeId(dbLimbah.getlong(COL_PERIODE_ID));
            limbah.setPpnPercent(dbLimbah.getdouble(COL_PPN_PERCENT));
            limbah.setPriceType(dbLimbah.getInt(COL_PRICE_TYPE));

            return limbah;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLimbah(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Limbah limbah) throws CONException {
        try {
            DbLimbah dbLimbah = new DbLimbah(0);

            dbLimbah.setDouble(COL_RATE, limbah.getRate());
            dbLimbah.setLong(COL_UNIT, limbah.getUnit());
            dbLimbah.setDouble(COL_PERCENTAGE_USED, limbah.getPercentageUsed());
            dbLimbah.setInt(COL_STATUS, limbah.getStatus());
            dbLimbah.setLong(COL_PERIODE_ID, limbah.getPeriodeId());
            dbLimbah.setDouble(COL_PPN_PERCENT, limbah.getPpnPercent());
            dbLimbah.setInt(COL_PRICE_TYPE, limbah.getPriceType());
            
            dbLimbah.insert();
            limbah.setOID(dbLimbah.getlong(COL_MASTER_LIMBAH_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLimbah(0), CONException.UNKNOWN);
        }
        return limbah.getOID();
    }

    public static long updateExc(Limbah limbah) throws CONException {
        try {
            DbLimbah dbLimbah = new DbLimbah(limbah.getOID());

            dbLimbah.setDouble(COL_RATE, limbah.getRate());
            dbLimbah.setLong(COL_UNIT, limbah.getUnit());
            dbLimbah.setDouble(COL_PERCENTAGE_USED, limbah.getPercentageUsed());
            dbLimbah.setInt(COL_STATUS, limbah.getStatus());
            dbLimbah.setLong(COL_PERIODE_ID, limbah.getPeriodeId());
            dbLimbah.setDouble(COL_PPN_PERCENT, limbah.getPpnPercent());
            dbLimbah.setInt(COL_PRICE_TYPE, limbah.getPriceType());

            dbLimbah.update();
            return limbah.getOID();

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLimbah(0), CONException.UNKNOWN);
        }
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLimbah dbLimbah = new DbLimbah(oid);
            dbLimbah.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLimbah(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LIMBAH;
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
                Limbah limbah = new Limbah();
                resultToObject(rs, limbah);
                lists.add(limbah);
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

    public static void resultToObject(ResultSet rs, Limbah limbah) {
        try {
            limbah.setOID(rs.getLong(DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID]));
            limbah.setRate(rs.getDouble(DbLimbah.colNames[DbLimbah.COL_RATE]));
            limbah.setUnit(rs.getLong(DbLimbah.colNames[DbLimbah.COL_UNIT]));
            limbah.setPercentageUsed(rs.getDouble(DbLimbah.colNames[DbLimbah.COL_PERCENTAGE_USED]));
            limbah.setStatus(rs.getInt(DbLimbah.colNames[DbLimbah.COL_STATUS]));
            limbah.setPeriodeId(rs.getLong(DbLimbah.colNames[DbLimbah.COL_PERIODE_ID]));
            limbah.setPpnPercent(rs.getDouble(DbLimbah.colNames[DbLimbah.COL_PPN_PERCENT]));
            limbah.setPriceType(rs.getInt(DbLimbah.colNames[DbLimbah.COL_PRICE_TYPE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long limbahId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LIMBAH + " WHERE " +
                    DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " = " + limbahId;

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

    public static boolean checkPeriodExist(long limbahOID, long periodeOId, int priceType) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LIMBAH + " WHERE " +
                    DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + " != " + limbahOID +
                    " AND " + DbLimbah.colNames[DbLimbah.COL_PERIODE_ID] + " = " + periodeOId +
                    " AND " + DbLimbah.colNames[DbLimbah.COL_PRICE_TYPE] + " = " + priceType;

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
            String sql = "SELECT COUNT(" + DbLimbah.colNames[DbLimbah.COL_MASTER_LIMBAH_ID] + ") FROM " + DB_LIMBAH;
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
                    Limbah limbah = (Limbah) list.get(ls);
                    if (oid == limbah.getOID()) {
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

    // proses update status limbah yg active
    public static void updateLimbahStatus(long limbahNewOID) {
        try {
            String sql = "UPDATE " + DB_LIMBAH + " SET " + colNames[COL_STATUS] + "=1 WHERE " + colNames[COL_MASTER_LIMBAH_ID] + "!=" + limbahNewOID;
            int hasil = CONHandler.execUpdate(sql);

        } catch (Exception e) {
        }
    }
}



