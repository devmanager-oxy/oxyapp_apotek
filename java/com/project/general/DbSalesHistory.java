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
import com.project.util.lang.*;
/**
 *
 * @author Roy
 */
public class DbSalesHistory extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SALES_HISTORY = "sales_history";
    
    public static final int COL_SALES_HISTORY_ID = 0;
    public static final int COL_CASH_CASHIER_ID = 1;
    public static final int COL_DATE = 2;    
    public static final int COL_GL_ID = 3;
    public static final int COL_JOURNAL_NUMBER = 4;
    
    public static final String[] colNames = {
        "sales_history_id",
        "cash_cashier_id",
        "date",        
        "gl_id",
        "journal_number"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_DATE,        
        TYPE_LONG,
        TYPE_STRING
    };

    public DbSalesHistory() {
    }

    public DbSalesHistory(int i) throws CONException {
        super(new DbSalesHistory());
    }

    public DbSalesHistory(String sOid) throws CONException {
        super(new DbSalesHistory(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSalesHistory(long lOid) throws CONException {
        super(new DbSalesHistory(0));
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
        return DB_SALES_HISTORY;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSalesHistory().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SalesHistory salesHistory = fetchExc(ent.getOID());
        ent = (Entity) salesHistory;
        return salesHistory.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SalesHistory) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SalesHistory) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SalesHistory fetchExc(long oid) throws CONException {
        try {
            SalesHistory salesHistory = new SalesHistory();
            DbSalesHistory pstSalesHistory = new DbSalesHistory(oid);
            salesHistory.setOID(oid);

            salesHistory.setCashCashierId(pstSalesHistory.getlong(COL_CASH_CASHIER_ID));
            salesHistory.setDate(pstSalesHistory.getDate(COL_DATE));            
            salesHistory.setGlId(pstSalesHistory.getlong(COL_GL_ID));
            salesHistory.setJournalNumber(pstSalesHistory.getString(COL_JOURNAL_NUMBER));
            
            return salesHistory;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesHistory(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SalesHistory salesHistory) throws CONException {
        try {
            DbSalesHistory pstSalesHistory = new DbSalesHistory(0);
            pstSalesHistory.setLong(COL_CASH_CASHIER_ID, salesHistory.getCashCashierId());
            pstSalesHistory.setDate(COL_DATE, salesHistory.getDate());            
            pstSalesHistory.setLong(COL_GL_ID, salesHistory.getGlId());
            pstSalesHistory.setString(COL_JOURNAL_NUMBER, salesHistory.getJournalNumber());
            pstSalesHistory.insert();
            salesHistory.setOID(pstSalesHistory.getlong(COL_SALES_HISTORY_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesHistory(0), CONException.UNKNOWN);
        }
        return salesHistory.getOID();
    }

    public static long updateExc(SalesHistory salesHistory) throws CONException {
        try {
            if (salesHistory.getOID() != 0) {
                DbSalesHistory pstSalesHistory = new DbSalesHistory(salesHistory.getOID());
                pstSalesHistory.setLong(COL_CASH_CASHIER_ID, salesHistory.getCashCashierId());
                pstSalesHistory.setDate(COL_DATE, salesHistory.getDate());                
                pstSalesHistory.setLong(COL_GL_ID, salesHistory.getGlId());
                pstSalesHistory.setString(COL_JOURNAL_NUMBER, salesHistory.getJournalNumber());
                pstSalesHistory.update();
                return salesHistory.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesHistory(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSalesHistory pstSalesHistory = new DbSalesHistory(oid);
            pstSalesHistory.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSalesHistory(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SALES_HISTORY;
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
                SalesHistory salesHistory = new SalesHistory();
                resultToObject(rs, salesHistory);
                lists.add(salesHistory);
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

    private static void resultToObject(ResultSet rs, SalesHistory salesHistory) {
        try {
            salesHistory.setOID(rs.getLong(DbSalesHistory.colNames[DbSalesHistory.COL_SALES_HISTORY_ID]));
            salesHistory.setCashCashierId(rs.getLong(DbSalesHistory.colNames[DbSalesHistory.COL_CASH_CASHIER_ID]));
            salesHistory.setDate(rs.getDate(DbSalesHistory.colNames[DbSalesHistory.COL_DATE]));            
            salesHistory.setGlId(rs.getLong(DbSalesHistory.colNames[DbSalesHistory.COL_GL_ID]));
            salesHistory.setJournalNumber(rs.getString(DbSalesHistory.colNames[DbSalesHistory.COL_JOURNAL_NUMBER]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long salesHistoryId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SALES_HISTORY + " WHERE " +
                    DbSalesHistory.colNames[DbSalesHistory.COL_SALES_HISTORY_ID] + " = " + salesHistoryId;

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
            String sql = "SELECT COUNT(" + DbSalesHistory.colNames[DbSalesHistory.COL_SALES_HISTORY_ID] + ") FROM " + DB_SALES_HISTORY;
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
                    SalesHistory salesHistory = (SalesHistory) list.get(ls);
                    if (oid == salesHistory.getOID()) {
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
