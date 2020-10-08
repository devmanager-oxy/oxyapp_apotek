/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.reportform;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy Andika
 */
public class DbRptPrint extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_RPT_PRINT = "rpt_print";
    public static final int COL_RPT_PRINT_ID = 0;
    public static final int COL_TYPE_REPORT = 1;
    public static final int COL_NO = 2;
    public static final int COL_DATE_REPORT = 3;
    public static final int COL_USER_ID = 4;
    public static final int COL_TYPE_DATA = 5;
    public static final int COL_REALISASI_LAST_YEAR = 6;
    public static final int COL_BUDGET_THIS_YEAR = 7;
    public static final int COL_REALISASI_THIS_YEAR = 8;
    public static final int COL_PERCENT_THIS_YEAR = 9;
    public static final int COL_PERCENT_BUDGET_THIS_YEAR = 10;
    public static final String[] colNames = {
        "rpt_print_id",
        "type_report",
        "no",
        "date_report",
        "user_id",
        "type_data",
        "realisasi_last_year",
        "budget_this_year",
        "realisasi_this_year",
        "percent_this_year",
        "percent_budget_this_year"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT
    };
    public static final int TYPE_REPORT_NERACA = 0;
    public static final int TYPE_PNL = 1;

    public DbRptPrint() {
    }

    public DbRptPrint(int i) throws CONException {
        super(new DbRptPrint());
    }

    public DbRptPrint(String sOid) throws CONException {
        super(new DbRptPrint(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbRptPrint(long lOid) throws CONException {
        super(new DbRptPrint(0));
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
        return DB_RPT_PRINT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbRptPrint().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        RptPrint rptPrint = fetchExc(ent.getOID());
        ent = (Entity) rptPrint;
        return rptPrint.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((RptPrint) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((RptPrint) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static RptPrint fetchExc(long oid) throws CONException {
        try {
            RptPrint rptPrint = new RptPrint();
            DbRptPrint pstRptPrint = new DbRptPrint(oid);
            rptPrint.setOID(oid);
            
            rptPrint.setTypeReport(pstRptPrint.getInt(COL_TYPE_REPORT));
            rptPrint.setNo(pstRptPrint.getInt(COL_NO));
            rptPrint.setDateReport(pstRptPrint.getDate(COL_DATE_REPORT));
            rptPrint.setUserId(pstRptPrint.getlong(COL_USER_ID));
            rptPrint.setTypeData(pstRptPrint.getInt(COL_TYPE_DATA));
            rptPrint.setRealisasiLastYear(pstRptPrint.getdouble(COL_REALISASI_LAST_YEAR));
            rptPrint.setBudgetThisYear(pstRptPrint.getdouble(COL_BUDGET_THIS_YEAR));
            rptPrint.setRealisasiThisYear(pstRptPrint.getdouble(COL_REALISASI_THIS_YEAR));
            rptPrint.setPercentThisYear(pstRptPrint.getdouble(COL_PERCENT_THIS_YEAR));
            rptPrint.setPercentBudgetThisYear(pstRptPrint.getdouble(COL_PERCENT_BUDGET_THIS_YEAR));

            return rptPrint;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRptPrint(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(RptPrint rptPrint) throws CONException {
        try {
            DbRptPrint pstRptPrint = new DbRptPrint(0);

            pstRptPrint.setInt(COL_TYPE_REPORT, rptPrint.getTypeReport());
            pstRptPrint.setInt(COL_NO, rptPrint.getNo());
            pstRptPrint.setDate(COL_DATE_REPORT,rptPrint.getDateReport());
            pstRptPrint.setLong(COL_USER_ID, rptPrint.getUserId());
            pstRptPrint.setInt(COL_TYPE_DATA, rptPrint.getTypeData());
            pstRptPrint.setDouble(COL_REALISASI_LAST_YEAR, rptPrint.getRealisasiLastYear());
            pstRptPrint.setDouble(COL_BUDGET_THIS_YEAR, rptPrint.getBudgetThisYear());
            pstRptPrint.setDouble(COL_REALISASI_THIS_YEAR, rptPrint.getRealisasiThisYear());
            pstRptPrint.setDouble(COL_PERCENT_THIS_YEAR, rptPrint.getPercentThisYear());
            pstRptPrint.setDouble(COL_PERCENT_BUDGET_THIS_YEAR, rptPrint.getPercentBudgetThisYear());

            pstRptPrint.insert();
            rptPrint.setOID(pstRptPrint.getlong(COL_RPT_PRINT_ID));
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRptPrint(0), CONException.UNKNOWN);
        }
        return rptPrint.getOID();
    }

    public static long updateExc(RptPrint rptPrint) throws CONException {
        try {
            if (rptPrint.getOID() != 0) {
                
                DbRptPrint pstRptPrint = new DbRptPrint(rptPrint.getOID());
                
                pstRptPrint.setInt(COL_TYPE_REPORT, rptPrint.getTypeReport());
                pstRptPrint.setInt(COL_NO, rptPrint.getNo());
                pstRptPrint.setDate(COL_DATE_REPORT,rptPrint.getDateReport());
                pstRptPrint.setLong(COL_USER_ID, rptPrint.getUserId());
                pstRptPrint.setInt(COL_TYPE_DATA, rptPrint.getTypeData());
                pstRptPrint.setDouble(COL_REALISASI_LAST_YEAR, rptPrint.getRealisasiLastYear());
                pstRptPrint.setDouble(COL_BUDGET_THIS_YEAR, rptPrint.getBudgetThisYear());
                pstRptPrint.setDouble(COL_REALISASI_THIS_YEAR, rptPrint.getRealisasiThisYear());
                pstRptPrint.setDouble(COL_PERCENT_THIS_YEAR, rptPrint.getPercentThisYear());
                pstRptPrint.setDouble(COL_PERCENT_BUDGET_THIS_YEAR, rptPrint.getPercentBudgetThisYear());

                pstRptPrint.update();
                return rptPrint.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRptPrint(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbRptPrint pstRptPrint = new DbRptPrint(oid);
            pstRptPrint.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbRptPrint(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_RPT_PRINT;
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
                RptPrint rptPrint = new RptPrint();
                resultToObject(rs, rptPrint);
                lists.add(rptPrint);
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

    private static void resultToObject(ResultSet rs, RptPrint rptPrint) {
        try {
            
            rptPrint.setOID(rs.getLong(DbRptPrint.colNames[DbRptPrint.COL_RPT_PRINT_ID]));            
            rptPrint.setTypeReport(rs.getInt(DbRptPrint.colNames[DbRptPrint.COL_TYPE_REPORT]));            
            rptPrint.setNo(rs.getInt(DbRptPrint.colNames[DbRptPrint.COL_NO]));            
            rptPrint.setDateReport(rs.getDate(DbRptPrint.colNames[DbRptPrint.COL_DATE_REPORT]));
            rptPrint.setUserId(rs.getLong(DbRptPrint.colNames[DbRptPrint.COL_USER_ID]));
            rptPrint.setTypeData(rs.getInt(DbRptPrint.colNames[DbRptPrint.COL_TYPE_DATA]));
            rptPrint.setRealisasiLastYear(rs.getDouble(DbRptPrint.colNames[DbRptPrint.COL_REALISASI_LAST_YEAR]));
            rptPrint.setBudgetThisYear(rs.getDouble(DbRptPrint.colNames[DbRptPrint.COL_BUDGET_THIS_YEAR]));
            rptPrint.setRealisasiThisYear(rs.getDouble(DbRptPrint.colNames[DbRptPrint.COL_REALISASI_THIS_YEAR]));
            rptPrint.setPercentThisYear(rs.getDouble(DbRptPrint.colNames[DbRptPrint.COL_PERCENT_THIS_YEAR]));
            rptPrint.setPercentBudgetThisYear(rs.getDouble(DbRptPrint.colNames[DbRptPrint.COL_PERCENT_BUDGET_THIS_YEAR]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long rptPrintId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_RPT_PRINT + " WHERE " +
                    DbRptPrint.colNames[DbRptPrint.COL_RPT_PRINT_ID] + " = " + rptPrintId;

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
            String sql = "SELECT COUNT(" + DbRptPrint.colNames[DbRptPrint.COL_RPT_PRINT_ID] + ") FROM " + DB_RPT_PRINT;
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
                    RptPrint rptPrint = (RptPrint) list.get(ls);
                    if (oid == rptPrint.getOID()) {
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
