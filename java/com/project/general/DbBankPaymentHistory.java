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
public class DbBankPaymentHistory extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language{
    
    public static final String DB_BANK_PAYMENT_HISTORY = "bank_payment_history";
    
    public static final int COL_BANK_PAYMENT_HISTORY_ID = 0;
    public static final int COL_BANK_PAYMENT_ID = 1;
    public static final int COL_DATE = 2;
    public static final int COL_TYPE = 3;
    public static final int COL_GL_ID = 4;
    public static final int COL_JOURNAL_NUMBER = 5;
    
    public static final String[] colNames = {
        "bank_payment_history_id",
        "bank_payment_id",
        "date",
        "type",
        "gl_id",
        "journal_number"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_STRING        
    };

    public DbBankPaymentHistory() {
    }

    public DbBankPaymentHistory(int i) throws CONException {
        super(new DbBankPaymentHistory());
    }

    public DbBankPaymentHistory(String sOid) throws CONException {
        super(new DbBankPaymentHistory(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBankPaymentHistory(long lOid) throws CONException {
        super(new DbBankPaymentHistory(0));
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
        return DB_BANK_PAYMENT_HISTORY;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBankPaymentHistory().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BankPaymentHistory bankPaymentHistory = fetchExc(ent.getOID());
        ent = (Entity) bankPaymentHistory;
        return bankPaymentHistory.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BankPaymentHistory) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BankPaymentHistory) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BankPaymentHistory fetchExc(long oid) throws CONException {
        try {
            BankPaymentHistory bankPaymentHistory = new BankPaymentHistory();
            DbBankPaymentHistory pstBankPaymentHistory = new DbBankPaymentHistory(oid);
            bankPaymentHistory.setOID(oid);
            
            bankPaymentHistory.setBankPaymentId(pstBankPaymentHistory.getlong(COL_BANK_PAYMENT_ID));
            bankPaymentHistory.setDate(pstBankPaymentHistory.getDate(COL_DATE));
            bankPaymentHistory.setType(pstBankPaymentHistory.getInt(COL_TYPE));
            bankPaymentHistory.setGlId(pstBankPaymentHistory.getlong(COL_GL_ID));
            bankPaymentHistory.setJournalNumber(pstBankPaymentHistory.getString(COL_JOURNAL_NUMBER));            
    
            return bankPaymentHistory;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankPaymentHistory(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BankPaymentHistory bankPaymentHistory) throws CONException {
        try {
            DbBankPaymentHistory pstBankPaymentHistory = new DbBankPaymentHistory(0);
            
            pstBankPaymentHistory.setLong(COL_BANK_PAYMENT_ID, bankPaymentHistory.getBankPaymentId());
            pstBankPaymentHistory.setDate(COL_DATE, bankPaymentHistory.getDate());
            pstBankPaymentHistory.setInt(COL_TYPE, bankPaymentHistory.getType());
            pstBankPaymentHistory.setLong(COL_GL_ID, bankPaymentHistory.getGlId());
            pstBankPaymentHistory.setString(COL_JOURNAL_NUMBER, bankPaymentHistory.getJournalNumber());
                    
            pstBankPaymentHistory.insert();
            bankPaymentHistory.setOID(pstBankPaymentHistory.getlong(COL_BANK_PAYMENT_HISTORY_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankPaymentHistory(0), CONException.UNKNOWN);
        }
        return bankPaymentHistory.getOID();
    }

    public static long updateExc(BankPaymentHistory bankPaymentHistory) throws CONException {
        try {
            if (bankPaymentHistory.getOID() != 0) {
                DbBankPaymentHistory pstBankPaymentHistory = new DbBankPaymentHistory(bankPaymentHistory.getOID());

                pstBankPaymentHistory.setLong(COL_BANK_PAYMENT_ID, bankPaymentHistory.getBankPaymentId());
                pstBankPaymentHistory.setDate(COL_DATE, bankPaymentHistory.getDate());
                pstBankPaymentHistory.setInt(COL_TYPE, bankPaymentHistory.getType());
                pstBankPaymentHistory.setLong(COL_GL_ID, bankPaymentHistory.getGlId());
                pstBankPaymentHistory.setString(COL_JOURNAL_NUMBER, bankPaymentHistory.getJournalNumber());
                pstBankPaymentHistory.update();
                return bankPaymentHistory.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankPaymentHistory(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBankPaymentHistory pstBankPaymentHistory = new DbBankPaymentHistory(oid);
            pstBankPaymentHistory.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankPaymentHistory(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BANK_PAYMENT_HISTORY;
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
                BankPaymentHistory bankPaymentHistory = new BankPaymentHistory();
                resultToObject(rs, bankPaymentHistory);
                lists.add(bankPaymentHistory);
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

    private static void resultToObject(ResultSet rs, BankPaymentHistory bankPaymentHistory) {
        try {
            bankPaymentHistory.setOID(rs.getLong(DbBankPaymentHistory.colNames[DbBankPaymentHistory.COL_BANK_PAYMENT_HISTORY_ID]));
            bankPaymentHistory.setBankPaymentId(rs.getLong(DbBankPaymentHistory.colNames[DbBankPaymentHistory.COL_BANK_PAYMENT_ID]));
            bankPaymentHistory.setDate(rs.getDate(DbBankPaymentHistory.colNames[DbBankPaymentHistory.COL_DATE]));            
            bankPaymentHistory.setType(rs.getInt(DbBankPaymentHistory.colNames[DbBankPaymentHistory.COL_TYPE]));
            bankPaymentHistory.setGlId(rs.getLong(DbBankPaymentHistory.colNames[DbBankPaymentHistory.COL_GL_ID]));
            bankPaymentHistory.setJournalNumber(rs.getString(DbBankPaymentHistory.colNames[DbBankPaymentHistory.COL_JOURNAL_NUMBER]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long bankPaymentHistoryId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BANK_PAYMENT_HISTORY + " WHERE " +
                    DbBankPaymentHistory.colNames[DbBankPaymentHistory.COL_BANK_PAYMENT_HISTORY_ID] + " = " + bankPaymentHistoryId;

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
            String sql = "SELECT COUNT(" + DbBankPaymentHistory.colNames[DbBankPaymentHistory.COL_BANK_PAYMENT_HISTORY_ID] + ") FROM " + DB_BANK_PAYMENT_HISTORY;
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
                    BankPaymentHistory bankPaymentHistory = (BankPaymentHistory) list.get(ls);
                    if (oid == bankPaymentHistory.getOID()) {
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
