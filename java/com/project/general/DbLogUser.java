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
public class DbLogUser extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {
  
    public static final String DB_LOG_USER = "log_user";
    
    public static final int COL_LOG_USER_ID = 0;
    public static final int COL_TYPE = 1;
    public static final int COL_USER_ID = 2;
    public static final int COL_EMPLOYEE_ID = 3;
    public static final int COL_DESCRIPTION = 4;
    public static final int COL_REF_ID = 5;
    public static final int COL_DATE = 6;
    
    public static final String[] colNames = {
        "log_user_id",
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
    
    public static final int TYPE_AP_CLEREANCE = 0;
   

    public DbLogUser() {
    }

    public DbLogUser(int i) throws CONException {
        super(new DbLogUser());
    }

    public DbLogUser(String sOid) throws CONException {
        super(new DbLogUser(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLogUser(long lOid) throws CONException {
        super(new DbLogUser(0));
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
        return DB_LOG_USER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLogUser().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LogUser logUser = fetchExc(ent.getOID());
        ent = (Entity) logUser;
        return logUser.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LogUser) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LogUser) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static LogUser fetchExc(long oid) throws CONException {
        try {
            LogUser logUser = new LogUser();
            DbLogUser pstLogUser = new DbLogUser(oid);
            logUser.setOID(oid);

            logUser.setType(pstLogUser.getInt(COL_TYPE));
            logUser.setUserId(pstLogUser.getlong(COL_USER_ID));
            logUser.setEmployeeId(pstLogUser.getlong(COL_EMPLOYEE_ID));
            logUser.setDescription(pstLogUser.getString(COL_DESCRIPTION));
            logUser.setRefId(pstLogUser.getlong(COL_REF_ID));
            logUser.setDate(pstLogUser.getDate(COL_DATE));

            return logUser;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogUser(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LogUser logUser) throws CONException {
        try {
            DbLogUser pstLogUser = new DbLogUser(0);

            pstLogUser.setInt(COL_TYPE, logUser.getType());
            pstLogUser.setLong(COL_USER_ID, logUser.getUserId());
            pstLogUser.setLong(COL_EMPLOYEE_ID, logUser.getEmployeeId());
            pstLogUser.setString(COL_DESCRIPTION, logUser.getDescription());
            pstLogUser.setLong(COL_REF_ID, logUser.getRefId());
            pstLogUser.setDate(COL_DATE, logUser.getDate());

            pstLogUser.insert();
            logUser.setOID(pstLogUser.getlong(COL_LOG_USER_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogUser(0), CONException.UNKNOWN);
        }
        return logUser.getOID();
    }

    public static long updateExc(LogUser logUser) throws CONException {
        try {
            if (logUser.getOID() != 0) {
                DbLogUser pstLogUser = new DbLogUser(logUser.getOID());

                pstLogUser.setInt(COL_TYPE, logUser.getType());
                pstLogUser.setLong(COL_USER_ID, logUser.getUserId());
                pstLogUser.setLong(COL_EMPLOYEE_ID, logUser.getEmployeeId());
                pstLogUser.setString(COL_DESCRIPTION, logUser.getDescription());
                pstLogUser.setLong(COL_REF_ID, logUser.getRefId());
                pstLogUser.setDate(COL_DATE, logUser.getDate());

                pstLogUser.update();
                return logUser.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogUser(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLogUser pstLogUser = new DbLogUser(oid);
            pstLogUser.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogUser(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LOG_USER;
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
                LogUser logUser = new LogUser();
                resultToObject(rs, logUser);
                lists.add(logUser);
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

    private static void resultToObject(ResultSet rs, LogUser logUser) {
        try {
            logUser.setOID(rs.getLong(DbLogUser.colNames[DbLogUser.COL_LOG_USER_ID]));
            logUser.setType(rs.getInt(DbLogUser.colNames[DbLogUser.COL_TYPE]));
            logUser.setUserId(rs.getLong(DbLogUser.colNames[DbLogUser.COL_USER_ID]));
            logUser.setEmployeeId(rs.getLong(DbLogUser.colNames[DbLogUser.COL_EMPLOYEE_ID]));
            logUser.setDescription(rs.getString(DbLogUser.colNames[DbLogUser.COL_DESCRIPTION]));            
            String str = rs.getString(DbLogUser.colNames[DbLogUser.COL_DATE]);
            logUser.setDate(JSPFormater.formatDate(str, "yyyy-MM-dd hh:mm:ss"));
            logUser.setRefId(rs.getLong(DbLogUser.colNames[DbLogUser.COL_REF_ID]));            
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static boolean checkOID(long historyUserId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOG_USER + " WHERE " +
                    DbLogUser.colNames[DbLogUser.COL_LOG_USER_ID] + " = " + historyUserId;

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
            String sql = "SELECT COUNT(" + DbLogUser.colNames[DbLogUser.COL_LOG_USER_ID] + ") FROM " + DB_LOG_USER;
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
                    LogUser logUser = (LogUser) list.get(ls);
                    if (oid == logUser.getOID()) {
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
