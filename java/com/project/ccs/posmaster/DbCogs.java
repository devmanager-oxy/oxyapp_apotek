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
public class DbCogs extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_COGS = "cogs";
    
    public static final int COL_COGS_ID = 0;
    public static final int COL_ITEM_MASTER_ID = 1;
    public static final int COL_QTY = 2;
    public static final int COL_COGS = 3;
    public static final int COL_LAST_UPDATE = 4;
    public static final int COL_REF_ID = 5;
    
    public static final String[] colNames = {
        "cogs_id",
        "item_master_id",
        "qty",
        "cogs",
        "last_update",
        "ref_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_LONG
    };

    public DbCogs() {
    }

    public DbCogs(int i) throws CONException {
        super(new DbCogs());
    }

    public DbCogs(String sOid) throws CONException {
        super(new DbCogs(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCogs(long lOid) throws CONException {
        super(new DbCogs(0));
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
        return DB_COGS;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCogs().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Cogs cogs = fetchExc(ent.getOID());
        ent = (Entity) cogs;
        return cogs.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Cogs) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Cogs) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Cogs fetchExc(long oid) throws CONException {
        try {
            Cogs cogs = new Cogs();
            DbCogs dbCogs = new DbCogs(oid);
            cogs.setOID(oid);

            cogs.setItemMasterId(dbCogs.getlong(COL_ITEM_MASTER_ID));
            cogs.setQty(dbCogs.getdouble(COL_QTY));
            cogs.setCogs(dbCogs.getdouble(COL_COGS));
            cogs.setLastUpdate(dbCogs.getDate(COL_LAST_UPDATE));
            cogs.setRefId(dbCogs.getlong(COL_REF_ID));

            return cogs;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCogs(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Cogs cogs) throws CONException {
        try {
            DbCogs dbCogs = new DbCogs(0);

            dbCogs.setLong(COL_ITEM_MASTER_ID, cogs.getItemMasterId());
            dbCogs.setDouble(COL_COGS, cogs.getCogs());
            dbCogs.setDouble(COL_QTY, cogs.getQty());
            dbCogs.setDate(COL_LAST_UPDATE, cogs.getLastUpdate());
            dbCogs.setLong(COL_REF_ID, cogs.getRefId());

            dbCogs.insert();
            cogs.setOID(dbCogs.getlong(COL_COGS_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCogs(0), CONException.UNKNOWN);
        }
        return cogs.getOID();
    }

    public static long updateExc(Cogs cogs) throws CONException {
        try {
            if (cogs.getOID() != 0) {

                DbCogs dbCogs = new DbCogs(cogs.getOID());

                dbCogs.setLong(COL_ITEM_MASTER_ID, cogs.getItemMasterId());
                dbCogs.setDouble(COL_COGS, cogs.getCogs());
                dbCogs.setDouble(COL_QTY, cogs.getQty());
                dbCogs.setDate(COL_LAST_UPDATE, cogs.getLastUpdate());
                dbCogs.setLong(COL_REF_ID, cogs.getRefId());

                dbCogs.update();
                return cogs.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCogs(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCogs dbCogs = new DbCogs(oid);
            dbCogs.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCogs(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_COGS;
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
                Cogs cogs = new Cogs();
                resultToObject(rs, cogs);
                lists.add(cogs);
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

    public static void resultToObject(ResultSet rs, Cogs cogs) {
        try {
            cogs.setOID(rs.getLong(DbCogs.colNames[DbCogs.COL_COGS_ID]));
            cogs.setItemMasterId(rs.getLong(DbCogs.colNames[DbCogs.COL_ITEM_MASTER_ID]));
            cogs.setCogs(rs.getDouble(DbCogs.colNames[DbCogs.COL_COGS]));
            cogs.setQty(rs.getDouble(DbCogs.colNames[DbCogs.COL_QTY]));
            cogs.setLastUpdate(rs.getDate(DbCogs.colNames[DbCogs.COL_LAST_UPDATE]));
            cogs.setRefId(rs.getLong(DbCogs.colNames[DbCogs.COL_REF_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long cogsId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_COGS + " WHERE " +
                    DbCogs.colNames[DbCogs.COL_COGS_ID] + " = " + cogsId;

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
            String sql = "SELECT COUNT(" + DbCogs.colNames[DbCogs.COL_COGS_ID] + ") FROM " + DB_COGS;
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
                    Cogs cogs = (Cogs) list.get(ls);
                    if (oid == cogs.getOID()) {
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
