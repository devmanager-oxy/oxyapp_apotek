/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;

/* package qdep */
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.master.*;
import com.project.*;
import com.project.util.*;
import com.project.util.lang.*;
import com.project.payroll.*;
import com.project.fms.activity.*;
/**
 *
 * @author Roy
 */
public class DbGl2018 extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_GL2018 = "gl_2018";
    
    public static final int COL_GL_ID = 0;
    public static final int COL_JOURNAL_NUMBER = 1;
    public static final int COL_JOURNAL_COUNTER = 2;
    public static final int COL_JOURNAL_PREFIX = 3;
    public static final int COL_DATE = 4;
    public static final int COL_TRANS_DATE = 5;
    public static final int COL_OPERATOR_ID = 6;
    public static final int COL_OPERATOR_NAME = 7;
    public static final int COL_JOURNAL_TYPE = 8;
    public static final int COL_OWNER_ID = 9;
    public static final int COL_REF_NUMBER = 10;
    public static final int COL_CURRENCY_ID = 11;
    public static final int COL_MEMO = 12;
    public static final int COL_PERIOD_ID = 13;
    public static final int COL_ACTIVITY_STATUS = 14;
    public static final int COL_NOT_ACTIVITY_BASE = 15;
    public static final int COL_IS_REVERSAL = 16;
    public static final int COL_REVERSAL_DATE = 17;
    public static final int COL_REVERSAL_TYPE = 18;
    public static final int COL_REVERSAL_STATUS = 19;    
    public static final int COL_POSTED_STATUS = 20;
    public static final int COL_POSTED_BY_ID = 21;
    public static final int COL_POSTED_DATE = 22;
    public static final int COL_EFFECTIVE_DATE = 23;
    public static final int COL_REFERENSI_ID = 24;
    
    public static final String[] colNames = {
        "gl_id",
        "journal_number",
        "journal_counter",
        "journal_prefix",
        "date",
        "trans_date",
        "operator_id",
        "operator_name",
        "journal_type",
        "owner_id",
        "ref_number",
        "currency_id",
        "memo",
        "period_id",
        "activity_status",
        "not_activity_base",
        "is_reversal",
        "reversal_date",
        "reversal_type",
        "reversal_status",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "effective_date",
        "referensi_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_DATE,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG
    };
    public static final int REVERSAL_MANUAL = 0;
    public static final int REVERSAL_ON_CLOSING = 1;
    
    //add by roy
    public static final int IS_REVERSAL = 1;
    public static final int IS_NOT_REVERSAL = 0;
    public static final int NOT_POSTED = 0;
    public static final int POSTED = 1;
    public static final int TYPE_JURNAL_UMUM = 0;
    public static final int TYPE_JURNAL_KASBON = 1;

    public DbGl2018() {
    }

    public DbGl2018(int i) throws CONException {
        super(new DbGl2018());
    }

    public DbGl2018(String sOid) throws CONException {
        super(new DbGl2018(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGl2018(long lOid) throws CONException {
        super(new DbGl2018(0));
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
        return DB_GL2018;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGl2018().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Gl2018 gl2018 = fetchExc(ent.getOID());
        ent = (Entity) gl2018;
        return gl2018.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Gl2018) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Gl2018) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Gl2018 fetchExc(long oid) throws CONException {
        try {
            Gl2018 gl2018 = new Gl2018();
            DbGl2018 pstGl2018 = new DbGl2018(oid);
            gl2018.setOID(oid);

            gl2018.setJournalNumber(pstGl2018.getString(COL_JOURNAL_NUMBER));
            gl2018.setJournalCounter(pstGl2018.getInt(COL_JOURNAL_COUNTER));
            gl2018.setJournalPrefix(pstGl2018.getString(COL_JOURNAL_PREFIX));
            gl2018.setDate(pstGl2018.getDate(COL_DATE));
            gl2018.setTransDate(pstGl2018.getDate(COL_TRANS_DATE));
            gl2018.setOperatorId(pstGl2018.getlong(COL_OPERATOR_ID));
            gl2018.setOperatorName(pstGl2018.getString(COL_OPERATOR_NAME));
            gl2018.setJournalType(pstGl2018.getInt(COL_JOURNAL_TYPE));
            gl2018.setOwnerId(pstGl2018.getlong(COL_OWNER_ID));
            gl2018.setRefNumber(pstGl2018.getString(COL_REF_NUMBER));
            gl2018.setCurrencyId(pstGl2018.getlong(COL_CURRENCY_ID));
            gl2018.setMemo(pstGl2018.getString(COL_MEMO));
            gl2018.setPeriodId(pstGl2018.getlong(COL_PERIOD_ID));
            gl2018.setActivityStatus(pstGl2018.getString(COL_ACTIVITY_STATUS));
            gl2018.setNotActivityBase(pstGl2018.getInt(COL_NOT_ACTIVITY_BASE));
            gl2018.setIsReversal(pstGl2018.getInt(COL_IS_REVERSAL));
            gl2018.setReversalDate(pstGl2018.getDate(COL_REVERSAL_DATE));
            gl2018.setReversalType(pstGl2018.getInt(COL_REVERSAL_TYPE));
            gl2018.setReversalStatus(pstGl2018.getInt(COL_REVERSAL_STATUS));
            gl2018.setPostedStatus(pstGl2018.getInt(COL_POSTED_STATUS));
            gl2018.setPostedById(pstGl2018.getlong(COL_POSTED_BY_ID));
            gl2018.setPostedDate(pstGl2018.getDate(COL_POSTED_DATE));
            gl2018.setEffectiveDate(pstGl2018.getDate(COL_EFFECTIVE_DATE));
            gl2018.setReferensiId(pstGl2018.getlong(COL_REFERENSI_ID));

            return gl2018;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2018(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Gl2018 gl2018) throws CONException {
        try {
            DbGl2018 pstGl2018 = new DbGl2018(0);

            pstGl2018.setString(COL_JOURNAL_NUMBER, gl2018.getJournalNumber());
            pstGl2018.setInt(COL_JOURNAL_COUNTER, gl2018.getJournalCounter());
            pstGl2018.setString(COL_JOURNAL_PREFIX, gl2018.getJournalPrefix());
            pstGl2018.setDate(COL_DATE, gl2018.getDate());
            pstGl2018.setDate(COL_TRANS_DATE, gl2018.getTransDate());
            pstGl2018.setLong(COL_OPERATOR_ID, gl2018.getOperatorId());
            pstGl2018.setString(COL_OPERATOR_NAME, gl2018.getOperatorName());
            pstGl2018.setInt(COL_JOURNAL_TYPE, gl2018.getJournalType());
            pstGl2018.setLong(COL_OWNER_ID, gl2018.getOwnerId());
            pstGl2018.setString(COL_REF_NUMBER, gl2018.getRefNumber());
            pstGl2018.setLong(COL_CURRENCY_ID, gl2018.getCurrencyId());
            pstGl2018.setString(COL_MEMO, gl2018.getMemo());
            pstGl2018.setLong(COL_PERIOD_ID, gl2018.getPeriodId());
            pstGl2018.setString(COL_ACTIVITY_STATUS, gl2018.getActivityStatus());
            pstGl2018.setInt(COL_NOT_ACTIVITY_BASE, gl2018.getNotActivityBase());
            pstGl2018.setInt(COL_IS_REVERSAL, gl2018.getIsReversal());
            pstGl2018.setDate(COL_REVERSAL_DATE, gl2018.getReversalDate());
            pstGl2018.setInt(COL_REVERSAL_TYPE, gl2018.getReversalType());
            pstGl2018.setInt(COL_REVERSAL_STATUS, gl2018.getReversalStatus());
            pstGl2018.setInt(COL_POSTED_STATUS, gl2018.getPostedStatus());
            pstGl2018.setLong(COL_POSTED_BY_ID, gl2018.getPostedById());
            pstGl2018.setDate(COL_POSTED_DATE, gl2018.getPostedDate());
            pstGl2018.setDate(COL_EFFECTIVE_DATE, gl2018.getEffectiveDate());
            pstGl2018.setLong(COL_REFERENSI_ID, gl2018.getReferensiId());

            pstGl2018.insert();
            gl2018.setOID(pstGl2018.getlong(COL_GL_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2018(0), CONException.UNKNOWN);
        }
        return gl2018.getOID();
    }

    public static long updateExc(Gl2018 gl2018) throws CONException {
        try {
            if (gl2018.getOID() != 0) {
                DbGl2018 pstGl2018 = new DbGl2018(gl2018.getOID());

                pstGl2018.setString(COL_JOURNAL_NUMBER, gl2018.getJournalNumber());
                pstGl2018.setInt(COL_JOURNAL_COUNTER, gl2018.getJournalCounter());
                pstGl2018.setString(COL_JOURNAL_PREFIX, gl2018.getJournalPrefix());
                pstGl2018.setDate(COL_DATE, gl2018.getDate());
                pstGl2018.setDate(COL_TRANS_DATE, gl2018.getTransDate());
                pstGl2018.setLong(COL_OPERATOR_ID, gl2018.getOperatorId());
                pstGl2018.setString(COL_OPERATOR_NAME, gl2018.getOperatorName());
                pstGl2018.setInt(COL_JOURNAL_TYPE, gl2018.getJournalType());
                pstGl2018.setLong(COL_OWNER_ID, gl2018.getOwnerId());
                pstGl2018.setString(COL_REF_NUMBER, gl2018.getRefNumber());
                pstGl2018.setLong(COL_CURRENCY_ID, gl2018.getCurrencyId());
                pstGl2018.setString(COL_MEMO, gl2018.getMemo());
                pstGl2018.setLong(COL_PERIOD_ID, gl2018.getPeriodId());
                pstGl2018.setString(COL_ACTIVITY_STATUS, gl2018.getActivityStatus());
                pstGl2018.setInt(COL_NOT_ACTIVITY_BASE, gl2018.getNotActivityBase());
                pstGl2018.setInt(COL_IS_REVERSAL, gl2018.getIsReversal());
                pstGl2018.setDate(COL_REVERSAL_DATE, gl2018.getReversalDate());
                pstGl2018.setInt(COL_REVERSAL_TYPE, gl2018.getReversalType());
                pstGl2018.setInt(COL_REVERSAL_STATUS, gl2018.getReversalStatus());
                pstGl2018.setInt(COL_POSTED_STATUS, gl2018.getPostedStatus());
                pstGl2018.setLong(COL_POSTED_BY_ID, gl2018.getPostedById());
                pstGl2018.setDate(COL_POSTED_DATE, gl2018.getPostedDate());
                pstGl2018.setDate(COL_EFFECTIVE_DATE, gl2018.getEffectiveDate());
                pstGl2018.setLong(COL_REFERENSI_ID, gl2018.getReferensiId());

                pstGl2018.update();
                return gl2018.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2018(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGl2018 pstGl2018 = new DbGl2018(oid);
            pstGl2018.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2018(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_GL2018;
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
                Gl2018 gl2018 = new Gl2018();
                resultToObject(rs, gl2018);
                lists.add(gl2018);
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

    public static void resultToObject(ResultSet rs, Gl2018 gl2018) {
        try {
            gl2018.setOID(rs.getLong(DbGl2018.colNames[DbGl2018.COL_GL_ID]));
            gl2018.setJournalNumber(rs.getString(DbGl2018.colNames[DbGl2018.COL_JOURNAL_NUMBER]));
            gl2018.setJournalCounter(rs.getInt(DbGl2018.colNames[DbGl2018.COL_JOURNAL_COUNTER]));
            gl2018.setJournalPrefix(rs.getString(DbGl2018.colNames[DbGl2018.COL_JOURNAL_PREFIX]));
            gl2018.setDate(rs.getDate(DbGl2018.colNames[DbGl2018.COL_DATE]));
            gl2018.setTransDate(rs.getDate(DbGl2018.colNames[DbGl2018.COL_TRANS_DATE]));
            gl2018.setOperatorId(rs.getLong(DbGl2018.colNames[DbGl2018.COL_OPERATOR_ID]));
            gl2018.setOperatorName(rs.getString(DbGl2018.colNames[DbGl2018.COL_OPERATOR_NAME]));
            gl2018.setJournalType(rs.getInt(DbGl2018.colNames[DbGl2018.COL_JOURNAL_TYPE]));
            gl2018.setOwnerId(rs.getLong(DbGl2018.colNames[DbGl2018.COL_OWNER_ID]));
            gl2018.setRefNumber(rs.getString(DbGl2018.colNames[DbGl2018.COL_REF_NUMBER]));
            gl2018.setCurrencyId(rs.getLong(DbGl2018.colNames[DbGl2018.COL_CURRENCY_ID]));
            gl2018.setMemo(rs.getString(DbGl2018.colNames[DbGl2018.COL_MEMO]));
            gl2018.setPeriodId(rs.getLong(DbGl2018.colNames[DbGl2018.COL_PERIOD_ID]));
            gl2018.setActivityStatus(rs.getString(DbGl2018.colNames[DbGl2018.COL_ACTIVITY_STATUS]));
            gl2018.setNotActivityBase(rs.getInt(DbGl2018.colNames[DbGl2018.COL_NOT_ACTIVITY_BASE]));
            gl2018.setIsReversal(rs.getInt(colNames[COL_IS_REVERSAL]));
            gl2018.setReversalDate(rs.getDate(colNames[COL_REVERSAL_DATE]));
            gl2018.setReversalType(rs.getInt(colNames[COL_REVERSAL_TYPE]));
            gl2018.setReversalStatus(rs.getInt(colNames[COL_REVERSAL_STATUS]));
            gl2018.setPostedStatus(rs.getInt(colNames[COL_POSTED_STATUS]));
            gl2018.setPostedById(rs.getLong(colNames[COL_POSTED_BY_ID]));
            gl2018.setPostedDate(rs.getDate(colNames[COL_POSTED_DATE]));
            gl2018.setEffectiveDate(rs.getDate(colNames[COL_EFFECTIVE_DATE]));
            gl2018.setReferensiId(rs.getLong(colNames[COL_REFERENSI_ID]));

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }
    }

    public static boolean checkOID(long glId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_GL2018 + " WHERE " +
                    DbGl2018.colNames[DbGl2018.COL_GL_ID] + " = " + glId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbGl2018.colNames[DbGl2018.COL_GL_ID] + ") FROM " + DB_GL2018;
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
                    Gl2018 gl2018 = (Gl2018) list.get(ls);
                    if (oid == gl2018.getOID()) {
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
