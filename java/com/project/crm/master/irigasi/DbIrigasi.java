package com.project.crm.master.irigasi;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.system.*;
import com.project.util.*;

public class DbIrigasi extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_IRIGASI = "crm_master_irigasi";
    public static final int COL_MASTER_IRIGASI_ID = 0;
    public static final int COL_RATE = 1;
    public static final int COL_UNIT = 2;
    public static final int COL_STATUS = 3;
    public static final int COL_PERIODE_ID = 4;
    public static final int COL_PPN_PERCENT = 5;
    public static final int COL_PRICE_TYPE = 6;
    
    public static final String[] colNames = {
        "master_irigasi_id",
        "rate",
        "unit",
        "status",
        "periode_id",
        "ppn_percent",
        "price_type"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT
    };
    
    public static final int POSTED_STATUS_UNPOST = 0;
    public static final int POSTED_STATUS_POSTED = 1;
    public static final String[] postKey = {"Active", "InActive"};
    public static final int[] postValue = {0, 1};

    public DbIrigasi() {
    }

    public DbIrigasi(int i) throws CONException {
        super(new DbIrigasi());
    }

    public DbIrigasi(String sOid) throws CONException {
        super(new DbIrigasi(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbIrigasi(long lOid) throws CONException {
        super(new DbIrigasi(0));
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
        return DB_IRIGASI;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbIrigasi().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Irigasi irigasi = fetchExc(ent.getOID());
        ent = (Entity) irigasi;
        return irigasi.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Irigasi) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Irigasi) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Irigasi fetchExc(long oid) throws CONException {
        try {
            Irigasi irigasi = new Irigasi();
            DbIrigasi dbIrigasi = new DbIrigasi(oid);

            irigasi.setOID(oid);
            irigasi.setRate(dbIrigasi.getdouble(COL_RATE));
            irigasi.setUnit(dbIrigasi.getlong(COL_UNIT));
            irigasi.setStatus(dbIrigasi.getInt(COL_STATUS));
            irigasi.setPeriodeId(dbIrigasi.getlong(COL_PERIODE_ID));
            irigasi.setPpnPercent(dbIrigasi.getdouble(COL_PPN_PERCENT));
            irigasi.setPriceType(dbIrigasi.getInt(COL_PRICE_TYPE));

            return irigasi;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbIrigasi(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Irigasi irigasi) throws CONException {
        try {
            DbIrigasi dbIrigasi = new DbIrigasi(0);

            dbIrigasi.setDouble(COL_RATE, irigasi.getRate());
            dbIrigasi.setLong(COL_UNIT, irigasi.getUnit());
            dbIrigasi.setInt(COL_STATUS, irigasi.getStatus());
            dbIrigasi.setLong(COL_PERIODE_ID, irigasi.getPeriodeId());
            dbIrigasi.setDouble(COL_PPN_PERCENT, irigasi.getPpnPercent());
            dbIrigasi.setInt(COL_PRICE_TYPE, irigasi.getPriceType());
            
            dbIrigasi.insert();
            irigasi.setOID(dbIrigasi.getlong(COL_MASTER_IRIGASI_ID));
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbIrigasi(0), CONException.UNKNOWN);
        }
        return irigasi.getOID();
    }

    public static long updateExc(Irigasi irigasi) throws CONException {
        try {
            if (irigasi.getOID() != 0) {
                DbIrigasi dbIrigasi = new DbIrigasi(irigasi.getOID());

                dbIrigasi.setDouble(COL_RATE, irigasi.getRate());
                dbIrigasi.setLong(COL_UNIT, irigasi.getUnit());
                dbIrigasi.setInt(COL_STATUS, irigasi.getStatus());
                dbIrigasi.setLong(COL_PERIODE_ID, irigasi.getPeriodeId());
                dbIrigasi.setDouble(COL_PPN_PERCENT, irigasi.getPpnPercent());
                dbIrigasi.setInt(COL_PRICE_TYPE, irigasi.getPriceType());

                dbIrigasi.update();
                return irigasi.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbIrigasi(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbIrigasi dbLimbah = new DbIrigasi(oid);
            dbLimbah.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbIrigasi(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_IRIGASI;
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
                Irigasi irigasi = new Irigasi();
                resultToObject(rs, irigasi);
                lists.add(irigasi);
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

    public static void resultToObject(ResultSet rs, Irigasi irigasi) {
        try {
            irigasi.setOID(rs.getLong(DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID]));
            irigasi.setRate(rs.getDouble(DbIrigasi.colNames[DbIrigasi.COL_RATE]));
            irigasi.setUnit(rs.getLong(DbIrigasi.colNames[DbIrigasi.COL_UNIT]));
            irigasi.setStatus(rs.getInt(DbIrigasi.colNames[DbIrigasi.COL_STATUS]));
            irigasi.setPeriodeId(rs.getLong(DbIrigasi.colNames[DbIrigasi.COL_PERIODE_ID]));
            irigasi.setPpnPercent(rs.getDouble(DbIrigasi.colNames[DbIrigasi.COL_PPN_PERCENT]));
            irigasi.setPriceType(rs.getInt(DbIrigasi.colNames[DbIrigasi.COL_PRICE_TYPE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long irigasiId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_IRIGASI + " WHERE " +
                    DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " = " + irigasiId;

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

    public static boolean checkPeriodExist(long irigasiOID, long periodeOId, int priceType) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_IRIGASI + " WHERE " +
                    DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + " != " + irigasiOID +
                    " AND " + DbIrigasi.colNames[DbIrigasi.COL_PERIODE_ID] + " = " + periodeOId +
                    " AND " + DbIrigasi.colNames[DbIrigasi.COL_PRICE_TYPE] + " = " + priceType;

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
            String sql = "SELECT COUNT(" + DbIrigasi.colNames[DbIrigasi.COL_MASTER_IRIGASI_ID] + ") FROM " + DB_IRIGASI;
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
                    Irigasi irigasi = (Irigasi) list.get(ls);
                    if (oid == irigasi.getOID()) {
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
    public static void updateIrigasiStatus(long irigasiNewOID) {
        try {
            String sql = "UPDATE " + DB_IRIGASI + " SET " + colNames[COL_STATUS] + "=1 WHERE " + colNames[COL_MASTER_IRIGASI_ID] + "!=" + irigasiNewOID;
            int hasil = CONHandler.execUpdate(sql);

        } catch (Exception e) {
        }
    }
}

