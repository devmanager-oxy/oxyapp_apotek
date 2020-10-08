/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.transaction;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.system.*;
import com.project.util.*;
import com.project.fms.master.*;
import com.project.fms.*;
import com.project.*;

/**
 *
 * @author Roy
 */
public class DbSetoranKasir extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SETORAN_KASIR = "setoran_kasir";
    
    public static final int COL_SETORAN_KASIR_ID = 0;
    public static final int COL_COA_ID = 1;
    public static final int COL_JOURNAL_NUMBER = 2;
    public static final int COL_JOURNAL_COUNTER = 3;
    public static final int COL_LOCATION_ID = 4;
    public static final int COL_JOURNAL_PREFIX = 5;
    public static final int COL_DATE = 6;
    public static final int COL_TRANSACTION_DATE = 7;
    public static final int COL_MEMO = 8;
    public static final int COL_OPERATOR_ID = 9;
    public static final int COL_AMOUNT = 10;
    public static final int COL_POSTED_STATUS = 11;
    public static final int COL_POSTED_BY_ID = 12;
    public static final int COL_POSTED_DATE = 13;
    public static final int COL_EFECTIVE_DATE = 14;
    public static final int COL_PERIODE_ID = 15; 
    public static final int COL_SEGMENT1_ID = 16; 
    
    public static final String[] colNames = {
        "setoran_kasir_id",
        "coa_id",
        "journal_number",
        "journal_counter",
        "location_id",
        "journal_prefix",
        "date",
        "trans_date",
        "memo",
        "operator_id",
        "amount",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "effective_date",
        "periode_id",
        "segment1_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbSetoranKasir() {
    }

    public DbSetoranKasir(int i) throws CONException {
        super(new DbSetoranKasir());
    }

    public DbSetoranKasir(String sOid) throws CONException {
        super(new DbSetoranKasir(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSetoranKasir(long lOid) throws CONException {
        super(new DbSetoranKasir(0));
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
        return DB_SETORAN_KASIR;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSetoranKasir().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SetoranKasir setoranKasir = fetchExc(ent.getOID());
        ent = (Entity) setoranKasir;
        return setoranKasir.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SetoranKasir) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SetoranKasir) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SetoranKasir fetchExc(long oid) throws CONException {
        try {
            SetoranKasir setoranKasir = new SetoranKasir();
            DbSetoranKasir dbSetoranKasir = new DbSetoranKasir(oid);
            setoranKasir.setOID(oid);

            setoranKasir.setCoaId(dbSetoranKasir.getlong(COL_COA_ID));
            setoranKasir.setJournalNumber(dbSetoranKasir.getString(COL_JOURNAL_NUMBER));
            setoranKasir.setJournalCounter(dbSetoranKasir.getInt(COL_JOURNAL_COUNTER));
            setoranKasir.setLocationId(dbSetoranKasir.getlong(COL_LOCATION_ID));
            setoranKasir.setJournalPrefix(dbSetoranKasir.getString(COL_JOURNAL_PREFIX));
            setoranKasir.setDate(dbSetoranKasir.getDate(COL_DATE));
            setoranKasir.setTransDate(dbSetoranKasir.getDate(COL_TRANSACTION_DATE));
            setoranKasir.setMemo(dbSetoranKasir.getString(COL_MEMO));
            setoranKasir.setOperatorId(dbSetoranKasir.getlong(COL_OPERATOR_ID));
            setoranKasir.setAmount(dbSetoranKasir.getdouble(COL_AMOUNT));
            setoranKasir.setPostedStatus(dbSetoranKasir.getInt(COL_POSTED_STATUS));
            setoranKasir.setPostedById(dbSetoranKasir.getInt(COL_POSTED_BY_ID));
            setoranKasir.setPostedDate(dbSetoranKasir.getDate(COL_POSTED_DATE));
            setoranKasir.setEffectiveDate(dbSetoranKasir.getDate(COL_EFECTIVE_DATE));
            setoranKasir.setPeriodeId(dbSetoranKasir.getlong(COL_PERIODE_ID));
            setoranKasir.setSegment1Id(dbSetoranKasir.getlong(COL_SEGMENT1_ID));

            return setoranKasir;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSetoranKasir(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SetoranKasir setoranKasir) throws CONException {
        try {
            DbSetoranKasir dbSetoranKasir = new DbSetoranKasir(0);

            dbSetoranKasir.setLong(COL_COA_ID, setoranKasir.getCoaId());
            dbSetoranKasir.setString(COL_JOURNAL_NUMBER, setoranKasir.getJournalNumber());
            dbSetoranKasir.setInt(COL_JOURNAL_COUNTER, setoranKasir.getJournalCounter());
            dbSetoranKasir.setLong(COL_LOCATION_ID, setoranKasir.getLocationId());
            dbSetoranKasir.setString(COL_JOURNAL_PREFIX, setoranKasir.getJournalPrefix());
            dbSetoranKasir.setDate(COL_DATE, setoranKasir.getDate());
            dbSetoranKasir.setDate(COL_TRANSACTION_DATE, setoranKasir.getTransDate());
            dbSetoranKasir.setString(COL_MEMO, setoranKasir.getMemo());
            dbSetoranKasir.setLong(COL_OPERATOR_ID, setoranKasir.getOperatorId());
            dbSetoranKasir.setDouble(COL_AMOUNT, setoranKasir.getAmount());
            dbSetoranKasir.setInt(COL_POSTED_STATUS, setoranKasir.getPostedStatus());
            dbSetoranKasir.setLong(COL_POSTED_BY_ID, setoranKasir.getPostedById());
            dbSetoranKasir.setDate(COL_POSTED_DATE, setoranKasir.getPostedDate());
            dbSetoranKasir.setDate(COL_EFECTIVE_DATE, setoranKasir.getEffectiveDate());
            dbSetoranKasir.setLong(COL_PERIODE_ID, setoranKasir.getPeriodeId());
            dbSetoranKasir.setLong(COL_SEGMENT1_ID, setoranKasir.getSegment1Id());

            dbSetoranKasir.insert();
            setoranKasir.setOID(dbSetoranKasir.getlong(COL_SETORAN_KASIR_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSetoranKasir(0), CONException.UNKNOWN);
        }
        return setoranKasir.getOID();
    }

    public static long updateExc(SetoranKasir setoranKasir) throws CONException {
        try {
            if (setoranKasir.getOID() != 0) {
                DbSetoranKasir dbSetoranKasir = new DbSetoranKasir(setoranKasir.getOID());

                dbSetoranKasir.setLong(COL_COA_ID, setoranKasir.getCoaId());
                dbSetoranKasir.setString(COL_JOURNAL_NUMBER, setoranKasir.getJournalNumber());
                dbSetoranKasir.setInt(COL_JOURNAL_COUNTER, setoranKasir.getJournalCounter());
                dbSetoranKasir.setLong(COL_LOCATION_ID, setoranKasir.getLocationId());
                dbSetoranKasir.setString(COL_JOURNAL_PREFIX, setoranKasir.getJournalPrefix());
                dbSetoranKasir.setDate(COL_DATE, setoranKasir.getDate());
                dbSetoranKasir.setDate(COL_TRANSACTION_DATE, setoranKasir.getTransDate());
                dbSetoranKasir.setString(COL_MEMO, setoranKasir.getMemo());
                dbSetoranKasir.setLong(COL_OPERATOR_ID, setoranKasir.getOperatorId());
                dbSetoranKasir.setDouble(COL_AMOUNT, setoranKasir.getAmount());
                dbSetoranKasir.setInt(COL_POSTED_STATUS, setoranKasir.getPostedStatus());
                dbSetoranKasir.setLong(COL_POSTED_BY_ID, setoranKasir.getPostedById());
                dbSetoranKasir.setDate(COL_POSTED_DATE, setoranKasir.getPostedDate());
                dbSetoranKasir.setDate(COL_EFECTIVE_DATE, setoranKasir.getEffectiveDate());
                dbSetoranKasir.setLong(COL_PERIODE_ID, setoranKasir.getPeriodeId());
                dbSetoranKasir.setLong(COL_SEGMENT1_ID, setoranKasir.getSegment1Id());
                dbSetoranKasir.update();
                return setoranKasir.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSetoranKasir(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSetoranKasir dbSetoranKasir = new DbSetoranKasir(oid);
            dbSetoranKasir.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSetoranKasir(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SETORAN_KASIR;
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
                SetoranKasir setoranKasir = new SetoranKasir();
                resultToObject(rs, setoranKasir);
                lists.add(setoranKasir);
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

    private static void resultToObject(ResultSet rs, SetoranKasir setoranKasir) {
        try {

            setoranKasir.setOID(rs.getLong(DbSetoranKasir.colNames[DbSetoranKasir.COL_SETORAN_KASIR_ID]));
            setoranKasir.setCoaId(rs.getLong(DbSetoranKasir.colNames[DbSetoranKasir.COL_COA_ID]));
            setoranKasir.setJournalNumber(rs.getString(DbSetoranKasir.colNames[DbSetoranKasir.COL_JOURNAL_NUMBER]));
            setoranKasir.setJournalCounter(rs.getInt(DbSetoranKasir.colNames[DbSetoranKasir.COL_JOURNAL_COUNTER]));
            setoranKasir.setLocationId(rs.getLong(DbSetoranKasir.colNames[DbSetoranKasir.COL_LOCATION_ID]));
            setoranKasir.setJournalPrefix(rs.getString(DbSetoranKasir.colNames[DbSetoranKasir.COL_JOURNAL_PREFIX]));
            setoranKasir.setDate(rs.getDate(DbSetoranKasir.colNames[DbSetoranKasir.COL_DATE]));
            setoranKasir.setTransDate(rs.getDate(DbSetoranKasir.colNames[DbSetoranKasir.COL_TRANSACTION_DATE]));
            setoranKasir.setMemo(rs.getString(DbSetoranKasir.colNames[DbSetoranKasir.COL_MEMO]));
            setoranKasir.setOperatorId(rs.getLong(DbSetoranKasir.colNames[DbSetoranKasir.COL_OPERATOR_ID]));
            setoranKasir.setAmount(rs.getDouble(DbSetoranKasir.colNames[DbSetoranKasir.COL_AMOUNT]));
            setoranKasir.setPostedStatus(rs.getInt(DbSetoranKasir.colNames[DbSetoranKasir.COL_POSTED_STATUS]));
            setoranKasir.setPostedById(rs.getLong(DbSetoranKasir.colNames[DbSetoranKasir.COL_POSTED_BY_ID]));
            setoranKasir.setPostedDate(rs.getDate(DbSetoranKasir.colNames[DbSetoranKasir.COL_POSTED_DATE]));
            setoranKasir.setEffectiveDate(rs.getDate(DbSetoranKasir.colNames[DbSetoranKasir.COL_EFECTIVE_DATE]));
            setoranKasir.setPeriodeId(rs.getLong(DbSetoranKasir.colNames[DbSetoranKasir.COL_PERIODE_ID]));
            setoranKasir.setSegment1Id(rs.getLong(DbSetoranKasir.colNames[DbSetoranKasir.COL_SEGMENT1_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long setoranId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SETORAN_KASIR + " WHERE " +
                    DbSetoranKasir.colNames[DbSetoranKasir.COL_SETORAN_KASIR_ID] + " = " + setoranId;
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
            String sql = "SELECT COUNT(" + DbSetoranKasir.colNames[DbSetoranKasir.COL_SETORAN_KASIR_ID] + ") FROM " + DB_SETORAN_KASIR;
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
                    SetoranKasir setoranKasir = (SetoranKasir) list.get(ls);
                    if (oid == setoranKasir.getOID()) {
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
