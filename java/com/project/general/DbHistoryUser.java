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
import com.project.util.JSPFormater;
import com.project.util.jsp.*;

/**
 *
 * @author Roy
 */
public class DbHistoryUser extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_HISTORY_USER = "history_user";
    public static final int COL_HISTORY_USER_ID = 0;
    public static final int COL_TYPE = 1;
    public static final int COL_USER_ID = 2;
    public static final int COL_EMPLOYEE_ID = 3;
    public static final int COL_DESCRIPTION = 4;
    public static final int COL_REF_ID = 5;
    public static final int COL_DATE = 6;
    
    public static final String[] colNames = {
        "history_user_id",
        "type",
        "user_id",
        "employee_id",
        "description",
        "ref_id",
        "date"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_DATE
    };
    
    public static final int TYPE_USER_GROUP = 0;
    public static final int TYPE_USER = 1;
    public static final int TYPE_VENDOR = 2;
    public static final int TYPE_COGS_MASTER = 3;
    public static final int TYPE_BALANCE_GL = 4;
    public static final int TYPE_PERIOD = 5;
    public static final int TYPE_ITEM_GROUP = 6;
    public static final int TYPE_LOCATION = 7;
    public static final int TYPE_SEGMENT_DETAIL = 8;
    public static final int TYPE_VENDOR_FINANCE = 9;
    public static final int TYPE_VENDOR_ITEM = 10;
    public static final int TYPE_CURRENCY = 11;

    public DbHistoryUser() {
    }

    public DbHistoryUser(int i) throws CONException {
        super(new DbHistoryUser());
    }

    public DbHistoryUser(String sOid) throws CONException {
        super(new DbHistoryUser(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbHistoryUser(long lOid) throws CONException {
        super(new DbHistoryUser(0));
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
        return DB_HISTORY_USER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbHistoryUser().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        HistoryUser historyUser = fetchExc(ent.getOID());
        ent = (Entity) historyUser;
        return historyUser.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((HistoryUser) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((HistoryUser) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static HistoryUser fetchExc(long oid) throws CONException {
        try {
            HistoryUser historyUser = new HistoryUser();
            DbHistoryUser pstHistoryUser = new DbHistoryUser(oid);
            historyUser.setOID(oid);

            historyUser.setType(pstHistoryUser.getInt(COL_TYPE));
            historyUser.setUserId(pstHistoryUser.getlong(COL_USER_ID));
            historyUser.setEmployeeId(pstHistoryUser.getlong(COL_EMPLOYEE_ID));
            historyUser.setDescription(pstHistoryUser.getString(COL_DESCRIPTION));
            historyUser.setRefId(pstHistoryUser.getlong(COL_REF_ID));
            historyUser.setDate(pstHistoryUser.getDate(COL_DATE));

            return historyUser;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbHistoryUser(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(HistoryUser historyUser) throws CONException {
        try {
            DbHistoryUser pstHistoryUser = new DbHistoryUser(0);

            pstHistoryUser.setInt(COL_TYPE, historyUser.getType());
            pstHistoryUser.setLong(COL_USER_ID, historyUser.getUserId());
            pstHistoryUser.setLong(COL_EMPLOYEE_ID, historyUser.getEmployeeId());
            pstHistoryUser.setString(COL_DESCRIPTION, historyUser.getDescription());
            pstHistoryUser.setLong(COL_REF_ID, historyUser.getRefId());
            pstHistoryUser.setDate(COL_DATE, historyUser.getDate());

            pstHistoryUser.insert();
            historyUser.setOID(pstHistoryUser.getlong(COL_HISTORY_USER_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbHistoryUser(0), CONException.UNKNOWN);
        }
        return historyUser.getOID();
    }

    public static long updateExc(HistoryUser historyUser) throws CONException {
        try {
            if (historyUser.getOID() != 0) {
                DbHistoryUser pstHistoryUser = new DbHistoryUser(historyUser.getOID());

                pstHistoryUser.setInt(COL_TYPE, historyUser.getType());
                pstHistoryUser.setLong(COL_USER_ID, historyUser.getUserId());
                pstHistoryUser.setLong(COL_EMPLOYEE_ID, historyUser.getEmployeeId());
                pstHistoryUser.setString(COL_DESCRIPTION, historyUser.getDescription());
                pstHistoryUser.setLong(COL_REF_ID, historyUser.getRefId());
                pstHistoryUser.setDate(COL_DATE, historyUser.getDate());

                pstHistoryUser.update();
                return historyUser.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbHistoryUser(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbHistoryUser pstHistoryUser = new DbHistoryUser(oid);
            pstHistoryUser.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbHistoryUser(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_HISTORY_USER;
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
                HistoryUser historyUser = new HistoryUser();
                resultToObject(rs, historyUser);
                lists.add(historyUser);
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

    private static void resultToObject(ResultSet rs, HistoryUser historyUser) {
        try {
            historyUser.setOID(rs.getLong(DbHistoryUser.colNames[DbHistoryUser.COL_HISTORY_USER_ID]));
            historyUser.setType(rs.getInt(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE]));
            historyUser.setUserId(rs.getLong(DbHistoryUser.colNames[DbHistoryUser.COL_USER_ID]));
            historyUser.setEmployeeId(rs.getLong(DbHistoryUser.colNames[DbHistoryUser.COL_EMPLOYEE_ID]));
            historyUser.setDescription(rs.getString(DbHistoryUser.colNames[DbHistoryUser.COL_DESCRIPTION]));            
            String str = rs.getString(DbHistoryUser.colNames[DbHistoryUser.COL_DATE]);
            historyUser.setDate(JSPFormater.formatDate(str, "yyyy-MM-dd hh:mm:ss"));
            historyUser.setRefId(rs.getLong(DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID]));            
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static boolean checkOID(long historyUserId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_HISTORY_USER + " WHERE " +
                    DbHistoryUser.colNames[DbHistoryUser.COL_HISTORY_USER_ID] + " = " + historyUserId;

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
            String sql = "SELECT COUNT(" + DbHistoryUser.colNames[DbHistoryUser.COL_HISTORY_USER_ID] + ") FROM " + DB_HISTORY_USER;
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
                    HistoryUser historyUser = (HistoryUser) list.get(ls);
                    if (oid == historyUser.getOID()) {
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
