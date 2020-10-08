/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;

import java.io.*;
import java.sql.ResultSet;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.*;
import com.project.util.lang.*;
import java.util.Vector;
/**
 *
 * @author Roy
 */

public class DbBankpoHistory extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language{
    
    
    public static final String DB_BANKPO_HISTORY = "bankpo_history";
    
    public static final int COL_BANKPO_HISTORY_ID = 0;
    public static final int COL_USER_ID = 1;
    public static final int COL_JOURNAL_NUMBER = 2;
    public static final int COL_DATE = 3;
    public static final int COL_REF_ID = 4;
    public static final int COL_TYPE = 5;
    
    public static final String[] colNames = {
        "bankpo_history_id",
        "user_id",
        "journal_number",
        "date",
        "ref_id",
        "type"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT
    };
    
    public static final int TYPE_RELEASE_STATUS = 0;
    

    public DbBankpoHistory() {
    }

    public DbBankpoHistory(int i) throws CONException {
        super(new DbBankpoHistory());
    }

    public DbBankpoHistory(String sOid) throws CONException {
        super(new DbBankpoHistory(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBankpoHistory(long lOid) throws CONException {
        super(new DbBankpoHistory(0));
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
        return DB_BANKPO_HISTORY;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBankpoHistory().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BankpoHistory bankpoHistory = fetchExc(ent.getOID());
        ent = (Entity) bankpoHistory;
        return bankpoHistory.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BankpoHistory) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BankpoHistory) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BankpoHistory fetchExc(long oid) throws CONException {
        try {
            BankpoHistory bankpoHistory = new BankpoHistory();
            DbBankpoHistory pstBankpoHistory = new DbBankpoHistory(oid);
            bankpoHistory.setOID(oid);

            bankpoHistory.setUserId(pstBankpoHistory.getlong(COL_USER_ID));
            bankpoHistory.setJournalNumber(pstBankpoHistory.getString(COL_JOURNAL_NUMBER));            
            bankpoHistory.setDate(pstBankpoHistory.getDate(COL_DATE));            
            bankpoHistory.setRefId(pstBankpoHistory.getlong(COL_REF_ID));            
            bankpoHistory.setType(pstBankpoHistory.getInt(COL_TYPE));

            return bankpoHistory;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoHistory(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BankpoHistory bankpoHistory) throws CONException {
        try {
            DbBankpoHistory pstBankpoHistory = new DbBankpoHistory(0);            
            pstBankpoHistory.setLong(COL_USER_ID, bankpoHistory.getUserId());
            pstBankpoHistory.setString(COL_JOURNAL_NUMBER, bankpoHistory.getJournalNumber());
            pstBankpoHistory.setDate(COL_DATE, bankpoHistory.getDate());
            pstBankpoHistory.setLong(COL_REF_ID, bankpoHistory.getRefId());
            pstBankpoHistory.setInt(COL_TYPE, bankpoHistory.getType());
            pstBankpoHistory.insert();
            bankpoHistory.setOID(pstBankpoHistory.getlong(COL_BANKPO_HISTORY_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoHistory(0), CONException.UNKNOWN);
        }
        return bankpoHistory.getOID();
    }

    public static long updateExc(BankpoHistory bankpoHistory) throws CONException {
        try {
            if (bankpoHistory.getOID() != 0) {
                DbBankpoHistory pstBankpoHistory = new DbBankpoHistory(bankpoHistory.getOID());
                pstBankpoHistory.setLong(COL_USER_ID, bankpoHistory.getUserId());
                pstBankpoHistory.setString(COL_JOURNAL_NUMBER, bankpoHistory.getJournalNumber());
                pstBankpoHistory.setDate(COL_DATE, bankpoHistory.getDate());
                pstBankpoHistory.setLong(COL_REF_ID, bankpoHistory.getRefId());
                pstBankpoHistory.setInt(COL_TYPE, bankpoHistory.getType());
                pstBankpoHistory.update();
                return bankpoHistory.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoHistory(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBankpoHistory pstBankpoHistory = new DbBankpoHistory(oid);
            pstBankpoHistory.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoHistory(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BANKPO_HISTORY;
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
                BankpoHistory bankpoHistory = new BankpoHistory();
                resultToObject(rs, bankpoHistory);
                lists.add(bankpoHistory);
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

    private static void resultToObject(ResultSet rs, BankpoHistory bankpoHistory) {
        try {
            bankpoHistory.setOID(rs.getLong(DbBankpoHistory.colNames[DbBankpoHistory.COL_BANKPO_HISTORY_ID]));
            bankpoHistory.setUserId(rs.getLong(DbBankpoHistory.colNames[DbBankpoHistory.COL_USER_ID]));
            bankpoHistory.setJournalNumber(rs.getString(DbBankpoHistory.colNames[DbBankpoHistory.COL_JOURNAL_NUMBER]));
            Date tm = CONHandler.convertDate(rs.getDate(DbBankpoHistory.colNames[DbBankpoHistory.COL_DATE]), rs.getTime(DbBankpoHistory.colNames[DbBankpoHistory.COL_DATE]));
            bankpoHistory.setDate(tm);
            bankpoHistory.setRefId(rs.getLong(DbBankpoHistory.colNames[DbBankpoHistory.COL_REF_ID]));
            bankpoHistory.setType(rs.getInt(DbBankpoHistory.colNames[DbBankpoHistory.COL_TYPE]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long bankpoHistoryId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BANKPO_HISTORY + " WHERE " +
                    DbBankpoHistory.colNames[DbBankpoHistory.COL_BANKPO_HISTORY_ID] + " = " + bankpoHistoryId;

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
            String sql = "SELECT COUNT(" + DbBankpoHistory.colNames[DbBankpoHistory.COL_BANKPO_HISTORY_ID] + ") FROM " + DB_BANKPO_HISTORY;
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
                    BankpoHistory bankpoHistory = (BankpoHistory) list.get(ls);
                    if (oid == bankpoHistory.getOID()) {
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
