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
 * @author Roy
 */
public class DbUniqKey extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_UNIQ_KEY = "uniq_key";
    
    public static final int COL_UNIQ_KEY_ID = 0;
    public static final int COL_TYPE = 1;
    public static final int COL_REF_ID = 2;    
    public static final int COL_UNIQ_ID = 3;    
    
    public static final String[] colNames = {
        "uniq_key_id",
        "type",
        "ref_id",
        "uniq_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG
    };    
    
    public static final int TYPE_BANK_PO_PAYMENT = 0;    

    public DbUniqKey() {
    }

    public DbUniqKey(int i) throws CONException {
        super(new DbUniqKey());
    }

    public DbUniqKey(String sOid) throws CONException {
        super(new DbUniqKey(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbUniqKey(long lOid) throws CONException {
        super(new DbUniqKey(0));
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
        return DB_UNIQ_KEY;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbUniqKey().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        UniqKey uniqKey = fetchExc(ent.getOID());
        ent = (Entity) uniqKey;
        return uniqKey.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((UniqKey) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((UniqKey) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static UniqKey fetchExc(long oid) throws CONException {
        try {
            UniqKey uniqKey = new UniqKey();
            DbUniqKey pstUniqKey = new DbUniqKey(oid);
            uniqKey.setOID(oid);
            uniqKey.setType(pstUniqKey.getInt(COL_TYPE));
            uniqKey.setRefId(pstUniqKey.getlong(COL_REF_ID));
            uniqKey.setUniqId(pstUniqKey.getlong(COL_UNIQ_ID));    
            return uniqKey;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUniqKey(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(UniqKey uniqKey) throws CONException {
        try {
            DbUniqKey pstUniqKey = new DbUniqKey(0);
            pstUniqKey.setInt(COL_TYPE, uniqKey.getType());
            pstUniqKey.setLong(COL_REF_ID, uniqKey.getRefId());
            pstUniqKey.setLong(COL_UNIQ_ID, uniqKey.getUniqId());
            pstUniqKey.insert();
            uniqKey.setOID(pstUniqKey.getlong(COL_UNIQ_KEY_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUniqKey(0), CONException.UNKNOWN);
        }
        return uniqKey.getOID();
    }

    public static long updateExc(UniqKey uniqKey) throws CONException {
        try {
            if (uniqKey.getOID() != 0) {
                DbUniqKey pstUniqKey = new DbUniqKey(uniqKey.getOID());
                pstUniqKey.setInt(COL_TYPE, uniqKey.getType());
                pstUniqKey.setLong(COL_REF_ID, uniqKey.getRefId());
                pstUniqKey.setLong(COL_UNIQ_ID, uniqKey.getUniqId());
                pstUniqKey.update();
                return uniqKey.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUniqKey(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbUniqKey pstUniqKey = new DbUniqKey(oid);
            pstUniqKey.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUniqKey(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_UNIQ_KEY;
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
                UniqKey uniqKey = new UniqKey();
                resultToObject(rs, uniqKey);
                lists.add(uniqKey);
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

    private static void resultToObject(ResultSet rs, UniqKey uniqKey) {
        try {
            uniqKey.setOID(rs.getLong(DbUniqKey.colNames[DbUniqKey.COL_UNIQ_KEY_ID]));
            uniqKey.setType(rs.getInt(DbUniqKey.colNames[DbUniqKey.COL_TYPE]));
            uniqKey.setRefId(rs.getLong(DbUniqKey.colNames[DbUniqKey.COL_REF_ID]));
            uniqKey.setUniqId(rs.getLong(DbUniqKey.colNames[DbUniqKey.COL_UNIQ_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long uniqKeyId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_UNIQ_KEY + " WHERE " +
                    DbUniqKey.colNames[DbUniqKey.COL_UNIQ_KEY_ID] + " = " + uniqKeyId;

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
            String sql = "SELECT COUNT(" + DbUniqKey.colNames[DbUniqKey.COL_UNIQ_KEY_ID] + ") FROM " + DB_UNIQ_KEY;
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
                    UniqKey uniqKey = (UniqKey) list.get(ls);
                    if (oid == uniqKey.getOID()) {
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
