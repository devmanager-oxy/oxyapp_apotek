/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

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
public class DbGiro extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_GIRO = "giro";
    
    public static final int COL_GIRO_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_COA_ID = 2;
    
    public static final String[] colNames = {
        "giro_id",
        "name",
        "coa_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG
    };

    public DbGiro() {
    }

    public DbGiro(int i) throws CONException {
        super(new DbGiro());
    }

    public DbGiro(String sOid) throws CONException {
        super(new DbGiro(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGiro(long lOid) throws CONException {
        super(new DbGiro(0));
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
        return DB_GIRO;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGiro().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Giro giro = fetchExc(ent.getOID());
        ent = (Entity) giro;
        return giro.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Giro) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Giro) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Giro fetchExc(long oid) throws CONException {
        try {
            Giro giro = new Giro();
            DbGiro DbGiro = new DbGiro(oid);            
            giro.setOID(oid);
            giro.setName(DbGiro.getString(COL_NAME));
            giro.setCoaId(DbGiro.getlong(COL_COA_ID));
            return giro;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGiro(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Giro giro) throws CONException {
        try {            
            DbGiro DbGiro = new DbGiro(0);
            DbGiro.setString(COL_NAME, giro.getName());
            DbGiro.setLong(COL_COA_ID, giro.getCoaId());
            DbGiro.insert();
            giro.setOID(DbGiro.getlong(COL_GIRO_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGiro(0), CONException.UNKNOWN);
        }
        return giro.getOID();
    }

    public static long updateExc(Giro giro) throws CONException {
        try {
            if (giro.getOID() != 0) {                
                DbGiro DbGiro = new DbGiro(giro.getOID());
                DbGiro.setString(COL_NAME, giro.getName());
                DbGiro.setLong(COL_COA_ID, giro.getCoaId());
                DbGiro.update();
                return giro.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGiro(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGiro DbGiro = new DbGiro(oid);
            DbGiro.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGiro(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_GIRO;
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
                Giro giro = new Giro();
                resultToObject(rs, giro);
                lists.add(giro);
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

    private static void resultToObject(ResultSet rs, Giro giro) {
        try {
            giro.setOID(rs.getLong(DbGiro.colNames[DbGiro.COL_GIRO_ID]));
            giro.setName(rs.getString(DbGiro.colNames[DbGiro.COL_NAME]));
            giro.setCoaId(rs.getLong(DbGiro.colNames[DbGiro.COL_COA_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long giroId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_GIRO + " WHERE " +
                    DbGiro.colNames[DbGiro.COL_GIRO_ID] + " = " + giroId;

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
            String sql = "SELECT COUNT(" + DbGiro.colNames[DbGiro.COL_GIRO_ID] + ") FROM " + DB_GIRO;
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
                    Giro giro = (Giro) list.get(ls);
                    if (oid == giro.getOID()) {
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
