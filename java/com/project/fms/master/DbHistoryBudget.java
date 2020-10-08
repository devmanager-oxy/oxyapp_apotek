/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.master;

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
public class DbHistoryBudget extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_HISTORY_BUDGET = "history_budget";
    
    public static final int COL_HISTORY_BUDGET_ID = 0;
    public static final int COL_TYPE = 1;
    public static final int COL_USER_ID = 2;
    public static final int COL_EMPLOYEE_ID = 3;
    public static final int COL_DESCRIPTION = 4;
    public static final int COL_REF_ID = 5;
    public static final int COL_DATE = 6;
    public static final int COL_FULL_NAME = 7;
    public static final int COL_MONTH = 8;
    public static final int COL_YEAR = 9;
    public static final int COL_SEGMENT1_ID = 10;
    public static final int COL_PERIOD_ID = 11;
    
    public static final String[] colNames = {
        "history_budget_id",
        "type",
        "user_id",
        "employee_id",
        "description",
        "ref_id",
        "date",
        "full_name",
        "month",
        "year",
        "segment1_id",
        "period_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG        
    };
    
    public static final int TYPE_BUDGET_MASTER = 0;
    public static final int TYPE_BUDGET_REQUEST = 1;    
    public static final int TYPE_BUDGET_REQUEST_MAIN = 2;  

    public DbHistoryBudget() {
    }

    public DbHistoryBudget(int i) throws CONException {
        super(new DbHistoryBudget());
    }

    public DbHistoryBudget(String sOid) throws CONException {
        super(new DbHistoryBudget(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbHistoryBudget(long lOid) throws CONException {
        super(new DbHistoryBudget(0));
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
        return DB_HISTORY_BUDGET;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbHistoryBudget().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        HistoryBudget historyBudget = fetchExc(ent.getOID());
        ent = (Entity) historyBudget;
        return historyBudget.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((HistoryBudget) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((HistoryBudget) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static HistoryBudget fetchExc(long oid) throws CONException {
        try {
            HistoryBudget historyBudget = new HistoryBudget();
            DbHistoryBudget pstHistoryBudget = new DbHistoryBudget(oid);
            historyBudget.setOID(oid);

            historyBudget.setType(pstHistoryBudget.getInt(COL_TYPE));
            historyBudget.setUserId(pstHistoryBudget.getlong(COL_USER_ID));
            historyBudget.setEmployeeId(pstHistoryBudget.getlong(COL_EMPLOYEE_ID));
            historyBudget.setDescription(pstHistoryBudget.getString(COL_DESCRIPTION));
            historyBudget.setRefId(pstHistoryBudget.getlong(COL_REF_ID));
            historyBudget.setDate(pstHistoryBudget.getDate(COL_DATE));
            historyBudget.setFullName(pstHistoryBudget.getString(COL_FULL_NAME));
            historyBudget.setMonth(pstHistoryBudget.getInt(COL_MONTH));
            historyBudget.setYear(pstHistoryBudget.getInt(COL_YEAR));
            historyBudget.setPeriodId(pstHistoryBudget.getlong(COL_PERIOD_ID));
            historyBudget.setSegment1Id(pstHistoryBudget.getlong(COL_SEGMENT1_ID));
            
            return historyBudget;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbHistoryBudget(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(HistoryBudget historyBudget) throws CONException {
        try {
            DbHistoryBudget pstHistoryBudget = new DbHistoryBudget(0);

            pstHistoryBudget.setInt(COL_TYPE, historyBudget.getType());
            pstHistoryBudget.setLong(COL_USER_ID, historyBudget.getUserId());
            pstHistoryBudget.setLong(COL_EMPLOYEE_ID, historyBudget.getEmployeeId());
            pstHistoryBudget.setString(COL_DESCRIPTION, historyBudget.getDescription());
            pstHistoryBudget.setLong(COL_REF_ID, historyBudget.getRefId());
            pstHistoryBudget.setDate(COL_DATE, historyBudget.getDate());
            pstHistoryBudget.setString(COL_FULL_NAME, historyBudget.getFullName());
            pstHistoryBudget.setInt(COL_MONTH, historyBudget.getMonth());
            pstHistoryBudget.setInt(COL_YEAR, historyBudget.getYear());
            pstHistoryBudget.setLong(COL_PERIOD_ID, historyBudget.getPeriodId());
            pstHistoryBudget.setLong(COL_SEGMENT1_ID, historyBudget.getSegment1Id());

            pstHistoryBudget.insert();
            historyBudget.setOID(pstHistoryBudget.getlong(COL_HISTORY_BUDGET_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbHistoryBudget(0), CONException.UNKNOWN);
        }
        return historyBudget.getOID();
    }

    public static long updateExc(HistoryBudget historyBudget) throws CONException {
        try {
            if (historyBudget.getOID() != 0) {
                DbHistoryBudget pstHistoryBudget = new DbHistoryBudget(historyBudget.getOID());

                pstHistoryBudget.setInt(COL_TYPE, historyBudget.getType());
                pstHistoryBudget.setLong(COL_USER_ID, historyBudget.getUserId());
                pstHistoryBudget.setLong(COL_EMPLOYEE_ID, historyBudget.getEmployeeId());
                pstHistoryBudget.setString(COL_DESCRIPTION, historyBudget.getDescription());
                pstHistoryBudget.setLong(COL_REF_ID, historyBudget.getRefId());
                pstHistoryBudget.setDate(COL_DATE, historyBudget.getDate());
                pstHistoryBudget.setString(COL_FULL_NAME, historyBudget.getFullName());
                pstHistoryBudget.setInt(COL_MONTH, historyBudget.getMonth());
                pstHistoryBudget.setInt(COL_YEAR, historyBudget.getYear());
                pstHistoryBudget.setLong(COL_PERIOD_ID, historyBudget.getPeriodId());
                pstHistoryBudget.setLong(COL_SEGMENT1_ID, historyBudget.getSegment1Id());

                pstHistoryBudget.update();
                return historyBudget.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbHistoryBudget(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbHistoryBudget pstHistoryBudget = new DbHistoryBudget(oid);
            pstHistoryBudget.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbHistoryBudget(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_HISTORY_BUDGET;
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
                HistoryBudget historyBudget = new HistoryBudget();
                resultToObject(rs, historyBudget);
                lists.add(historyBudget);
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

    private static void resultToObject(ResultSet rs, HistoryBudget historyBudget) {
        try {
            historyBudget.setOID(rs.getLong(DbHistoryBudget.colNames[DbHistoryBudget.COL_HISTORY_BUDGET_ID]));
            historyBudget.setType(rs.getInt(DbHistoryBudget.colNames[DbHistoryBudget.COL_TYPE]));
            historyBudget.setUserId(rs.getLong(DbHistoryBudget.colNames[DbHistoryBudget.COL_USER_ID]));
            historyBudget.setEmployeeId(rs.getLong(DbHistoryBudget.colNames[DbHistoryBudget.COL_EMPLOYEE_ID]));
            historyBudget.setDescription(rs.getString(DbHistoryBudget.colNames[DbHistoryBudget.COL_DESCRIPTION]));
            String str = rs.getString(DbHistoryBudget.colNames[DbHistoryBudget.COL_DATE]);
            historyBudget.setDate(JSPFormater.formatDate(str, "yyyy-MM-dd hh:mm:ss"));
            historyBudget.setRefId(rs.getLong(DbHistoryBudget.colNames[DbHistoryBudget.COL_REF_ID]));
            historyBudget.setFullName(rs.getString(DbHistoryBudget.colNames[DbHistoryBudget.COL_FULL_NAME]));
            historyBudget.setMonth(rs.getInt(DbHistoryBudget.colNames[DbHistoryBudget.COL_MONTH]));
            historyBudget.setYear(rs.getInt(DbHistoryBudget.colNames[DbHistoryBudget.COL_YEAR]));
            historyBudget.setPeriodId(rs.getLong(DbHistoryBudget.colNames[DbHistoryBudget.COL_PERIOD_ID]));
            historyBudget.setSegment1Id(rs.getLong(DbHistoryBudget.colNames[DbHistoryBudget.COL_SEGMENT1_ID]));
            
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static boolean checkOID(long historyBudgetId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_HISTORY_BUDGET + " WHERE " +
                    DbHistoryBudget.colNames[DbHistoryBudget.COL_HISTORY_BUDGET_ID] + " = " + historyBudgetId;

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
            String sql = "SELECT COUNT(" + DbHistoryBudget.colNames[DbHistoryBudget.COL_HISTORY_BUDGET_ID] + ") FROM " + DB_HISTORY_BUDGET;
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
                    HistoryBudget historyBudget = (HistoryBudget) list.get(ls);
                    if (oid == historyBudget.getOID()) {
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
