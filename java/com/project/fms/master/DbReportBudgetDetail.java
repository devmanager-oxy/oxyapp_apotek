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
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.*;
import com.project.util.*;
/**
 *
 * @author Roy
 */
public class DbReportBudgetDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {
    
    public static final String DB_REPORT_BUDGET_DETAIL = "report_budget_detail";
    
    public static final int COL_REPORT_BUDGET_DETAIL_ID = 0;    
    public static final int COL_REPORT_BUDGET_ID = 1;    
    public static final int COL_VENDOR_ID = 2;
    public static final int COL_SEQUENCE = 3;    
    
    public static final String[] colNames = {
        "report_budget_detail_id",
        "report_budget_id",
        "vendor_id",
        "sequence"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,        
        TYPE_INT        
    };

    public DbReportBudgetDetail() {
    }

    public DbReportBudgetDetail(int i) throws CONException {
        super(new DbReportBudgetDetail());
    }

    public DbReportBudgetDetail(String sOid) throws CONException {
        super(new DbReportBudgetDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbReportBudgetDetail(long lOid) throws CONException {
        super(new DbReportBudgetDetail(0));
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
        return DB_REPORT_BUDGET_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbReportBudgetDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ReportBudgetDetail reportBudgetDetail = fetchExc(ent.getOID());
        ent = (Entity) reportBudgetDetail;
        return reportBudgetDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ReportBudgetDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ReportBudgetDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ReportBudgetDetail fetchExc(long oid) throws CONException {
        try {
            ReportBudgetDetail reportBudgetDetail = new ReportBudgetDetail();
            DbReportBudgetDetail dbReportBudgetDetail = new DbReportBudgetDetail(oid);
            reportBudgetDetail.setOID(oid);
            reportBudgetDetail.setReportBudgetId(dbReportBudgetDetail.getlong(COL_REPORT_BUDGET_ID));
            reportBudgetDetail.setVendorId(dbReportBudgetDetail.getlong(COL_VENDOR_ID));
            reportBudgetDetail.setSequence(dbReportBudgetDetail.getInt(COL_SEQUENCE));

            return reportBudgetDetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReportBudgetDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(ReportBudgetDetail reportBudgetDetail) throws CONException {
        try {
            DbReportBudgetDetail dbReportBudgetDetail = new DbReportBudgetDetail(0);

            dbReportBudgetDetail.setLong(COL_REPORT_BUDGET_ID, reportBudgetDetail.getReportBudgetId());
            dbReportBudgetDetail.setLong(COL_VENDOR_ID, reportBudgetDetail.getVendorId());            
            dbReportBudgetDetail.setInt(COL_SEQUENCE, reportBudgetDetail.getSequence());                        
            dbReportBudgetDetail.insert();
            reportBudgetDetail.setOID(dbReportBudgetDetail.getlong(COL_REPORT_BUDGET_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReportBudgetDetail(0), CONException.UNKNOWN);
        }
        return reportBudgetDetail.getOID();
    }

    public static long updateExc(ReportBudgetDetail reportBudgetDetail) throws CONException {
        try {
            if (reportBudgetDetail.getOID() != 0) {
                DbReportBudgetDetail dbReportBudgetDetail = new DbReportBudgetDetail(reportBudgetDetail.getOID());
                dbReportBudgetDetail.setLong(COL_REPORT_BUDGET_ID, reportBudgetDetail.getReportBudgetId());
                dbReportBudgetDetail.setLong(COL_VENDOR_ID, reportBudgetDetail.getVendorId());            
                dbReportBudgetDetail.setInt(COL_SEQUENCE, reportBudgetDetail.getSequence());                        
                dbReportBudgetDetail.update();
                return reportBudgetDetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReportBudgetDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbReportBudgetDetail dbReportBudgetDetail = new DbReportBudgetDetail(oid);
            dbReportBudgetDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReportBudgetDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_REPORT_BUDGET_DETAIL;
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
                ReportBudgetDetail reportBudgetDetail = new ReportBudgetDetail();
                resultToObject(rs, reportBudgetDetail);
                lists.add(reportBudgetDetail);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, ReportBudgetDetail reportBudgetDetail) {
        try {
            reportBudgetDetail.setOID(rs.getLong(DbReportBudgetDetail.colNames[DbReportBudgetDetail.COL_REPORT_BUDGET_DETAIL_ID]));            
            reportBudgetDetail.setReportBudgetId(rs.getLong(DbReportBudgetDetail.colNames[DbReportBudgetDetail.COL_REPORT_BUDGET_ID]));            
            reportBudgetDetail.setVendorId(rs.getLong(DbReportBudgetDetail.colNames[DbReportBudgetDetail.COL_VENDOR_ID]));
            reportBudgetDetail.setSequence(rs.getInt(DbReportBudgetDetail.colNames[DbReportBudgetDetail.COL_SEQUENCE]));            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long reportBudgetDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_REPORT_BUDGET_DETAIL + " WHERE " +
                    DbReportBudgetDetail.colNames[DbReportBudgetDetail.COL_REPORT_BUDGET_DETAIL_ID] + " = " + reportBudgetDetailId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbReportBudgetDetail.colNames[DbReportBudgetDetail.COL_REPORT_BUDGET_DETAIL_ID] + ") FROM " + DB_REPORT_BUDGET_DETAIL;
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
                    ReportBudgetDetail reportBudgetDetail = (ReportBudgetDetail) list.get(ls);
                    if (oid == reportBudgetDetail.getOID()) {
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
