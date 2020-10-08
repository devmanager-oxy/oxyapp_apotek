/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

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

public class DbGl2016 extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_GL2016 = "gl_2016";
    
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

    public DbGl2016() {
    }

    public DbGl2016(int i) throws CONException {
        super(new DbGl2016());
    }

    public DbGl2016(String sOid) throws CONException {
        super(new DbGl2016(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGl2016(long lOid) throws CONException {
        super(new DbGl2016(0));
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
        return DB_GL2016;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGl2016().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Gl2016 gl2016 = fetchExc(ent.getOID());
        ent = (Entity) gl2016;
        return gl2016.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Gl2016) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Gl2016) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Gl2016 fetchExc(long oid) throws CONException {
        try {
            Gl2016 gl2016 = new Gl2016();
            DbGl2016 pstGl2016 = new DbGl2016(oid);
            gl2016.setOID(oid);

            gl2016.setJournalNumber(pstGl2016.getString(COL_JOURNAL_NUMBER));
            gl2016.setJournalCounter(pstGl2016.getInt(COL_JOURNAL_COUNTER));
            gl2016.setJournalPrefix(pstGl2016.getString(COL_JOURNAL_PREFIX));
            gl2016.setDate(pstGl2016.getDate(COL_DATE));
            gl2016.setTransDate(pstGl2016.getDate(COL_TRANS_DATE));
            gl2016.setOperatorId(pstGl2016.getlong(COL_OPERATOR_ID));
            gl2016.setOperatorName(pstGl2016.getString(COL_OPERATOR_NAME));
            gl2016.setJournalType(pstGl2016.getInt(COL_JOURNAL_TYPE));
            gl2016.setOwnerId(pstGl2016.getlong(COL_OWNER_ID));
            gl2016.setRefNumber(pstGl2016.getString(COL_REF_NUMBER));
            gl2016.setCurrencyId(pstGl2016.getlong(COL_CURRENCY_ID));
            gl2016.setMemo(pstGl2016.getString(COL_MEMO));
            gl2016.setPeriodId(pstGl2016.getlong(COL_PERIOD_ID));
            gl2016.setActivityStatus(pstGl2016.getString(COL_ACTIVITY_STATUS));
            gl2016.setNotActivityBase(pstGl2016.getInt(COL_NOT_ACTIVITY_BASE));
            gl2016.setIsReversal(pstGl2016.getInt(COL_IS_REVERSAL));
            gl2016.setReversalDate(pstGl2016.getDate(COL_REVERSAL_DATE));
            gl2016.setReversalType(pstGl2016.getInt(COL_REVERSAL_TYPE));
            gl2016.setReversalStatus(pstGl2016.getInt(COL_REVERSAL_STATUS));
            gl2016.setPostedStatus(pstGl2016.getInt(COL_POSTED_STATUS));
            gl2016.setPostedById(pstGl2016.getlong(COL_POSTED_BY_ID));
            gl2016.setPostedDate(pstGl2016.getDate(COL_POSTED_DATE));
            gl2016.setEffectiveDate(pstGl2016.getDate(COL_EFFECTIVE_DATE));
            gl2016.setReferensiId(pstGl2016.getlong(COL_REFERENSI_ID));

            return gl2016;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2016(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Gl2016 gl2016) throws CONException {
        try {
            DbGl2016 pstGl2016 = new DbGl2016(0);

            pstGl2016.setString(COL_JOURNAL_NUMBER, gl2016.getJournalNumber());
            pstGl2016.setInt(COL_JOURNAL_COUNTER, gl2016.getJournalCounter());
            pstGl2016.setString(COL_JOURNAL_PREFIX, gl2016.getJournalPrefix());
            pstGl2016.setDate(COL_DATE, gl2016.getDate());
            pstGl2016.setDate(COL_TRANS_DATE, gl2016.getTransDate());
            pstGl2016.setLong(COL_OPERATOR_ID, gl2016.getOperatorId());
            pstGl2016.setString(COL_OPERATOR_NAME, gl2016.getOperatorName());
            pstGl2016.setInt(COL_JOURNAL_TYPE, gl2016.getJournalType());
            pstGl2016.setLong(COL_OWNER_ID, gl2016.getOwnerId());
            pstGl2016.setString(COL_REF_NUMBER, gl2016.getRefNumber());
            pstGl2016.setLong(COL_CURRENCY_ID, gl2016.getCurrencyId());
            pstGl2016.setString(COL_MEMO, gl2016.getMemo());
            pstGl2016.setLong(COL_PERIOD_ID, gl2016.getPeriodId());
            pstGl2016.setString(COL_ACTIVITY_STATUS, gl2016.getActivityStatus());
            pstGl2016.setInt(COL_NOT_ACTIVITY_BASE, gl2016.getNotActivityBase());
            pstGl2016.setInt(COL_IS_REVERSAL, gl2016.getIsReversal());
            pstGl2016.setDate(COL_REVERSAL_DATE, gl2016.getReversalDate());
            pstGl2016.setInt(COL_REVERSAL_TYPE, gl2016.getReversalType());
            pstGl2016.setInt(COL_REVERSAL_STATUS, gl2016.getReversalStatus());
            pstGl2016.setInt(COL_POSTED_STATUS, gl2016.getPostedStatus());
            pstGl2016.setLong(COL_POSTED_BY_ID, gl2016.getPostedById());
            pstGl2016.setDate(COL_POSTED_DATE, gl2016.getPostedDate());
            pstGl2016.setDate(COL_EFFECTIVE_DATE, gl2016.getEffectiveDate());
            pstGl2016.setLong(COL_REFERENSI_ID, gl2016.getReferensiId());

            pstGl2016.insert();
            gl2016.setOID(pstGl2016.getlong(COL_GL_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2016(0), CONException.UNKNOWN);
        }
        return gl2016.getOID();
    }

    public static long updateExc(Gl2016 gl2016) throws CONException {
        try {
            if (gl2016.getOID() != 0) {
                DbGl2016 pstGl2016 = new DbGl2016(gl2016.getOID());

                pstGl2016.setString(COL_JOURNAL_NUMBER, gl2016.getJournalNumber());
                pstGl2016.setInt(COL_JOURNAL_COUNTER, gl2016.getJournalCounter());
                pstGl2016.setString(COL_JOURNAL_PREFIX, gl2016.getJournalPrefix());
                pstGl2016.setDate(COL_DATE, gl2016.getDate());
                pstGl2016.setDate(COL_TRANS_DATE, gl2016.getTransDate());
                pstGl2016.setLong(COL_OPERATOR_ID, gl2016.getOperatorId());
                pstGl2016.setString(COL_OPERATOR_NAME, gl2016.getOperatorName());
                pstGl2016.setInt(COL_JOURNAL_TYPE, gl2016.getJournalType());
                pstGl2016.setLong(COL_OWNER_ID, gl2016.getOwnerId());
                pstGl2016.setString(COL_REF_NUMBER, gl2016.getRefNumber());
                pstGl2016.setLong(COL_CURRENCY_ID, gl2016.getCurrencyId());
                pstGl2016.setString(COL_MEMO, gl2016.getMemo());
                pstGl2016.setLong(COL_PERIOD_ID, gl2016.getPeriodId());
                pstGl2016.setString(COL_ACTIVITY_STATUS, gl2016.getActivityStatus());
                pstGl2016.setInt(COL_NOT_ACTIVITY_BASE, gl2016.getNotActivityBase());
                pstGl2016.setInt(COL_IS_REVERSAL, gl2016.getIsReversal());
                pstGl2016.setDate(COL_REVERSAL_DATE, gl2016.getReversalDate());
                pstGl2016.setInt(COL_REVERSAL_TYPE, gl2016.getReversalType());
                pstGl2016.setInt(COL_REVERSAL_STATUS, gl2016.getReversalStatus());
                pstGl2016.setInt(COL_POSTED_STATUS, gl2016.getPostedStatus());
                pstGl2016.setLong(COL_POSTED_BY_ID, gl2016.getPostedById());
                pstGl2016.setDate(COL_POSTED_DATE, gl2016.getPostedDate());
                pstGl2016.setDate(COL_EFFECTIVE_DATE, gl2016.getEffectiveDate());
                pstGl2016.setLong(COL_REFERENSI_ID, gl2016.getReferensiId());

                pstGl2016.update();
                return gl2016.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2016(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGl2016 pstGl2016 = new DbGl2016(oid);
            pstGl2016.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2016(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_GL2016;
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
                Gl2016 gl2016 = new Gl2016();
                resultToObject(rs, gl2016);
                lists.add(gl2016);
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

    public static void resultToObject(ResultSet rs, Gl2016 gl2016) {
        try {
            gl2016.setOID(rs.getLong(DbGl2016.colNames[DbGl2016.COL_GL_ID]));
            gl2016.setJournalNumber(rs.getString(DbGl2016.colNames[DbGl2016.COL_JOURNAL_NUMBER]));
            gl2016.setJournalCounter(rs.getInt(DbGl2016.colNames[DbGl2016.COL_JOURNAL_COUNTER]));
            gl2016.setJournalPrefix(rs.getString(DbGl2016.colNames[DbGl2016.COL_JOURNAL_PREFIX]));
            gl2016.setDate(rs.getDate(DbGl2016.colNames[DbGl2016.COL_DATE]));
            gl2016.setTransDate(rs.getDate(DbGl2016.colNames[DbGl2016.COL_TRANS_DATE]));
            gl2016.setOperatorId(rs.getLong(DbGl2016.colNames[DbGl2016.COL_OPERATOR_ID]));
            gl2016.setOperatorName(rs.getString(DbGl2016.colNames[DbGl2016.COL_OPERATOR_NAME]));
            gl2016.setJournalType(rs.getInt(DbGl2016.colNames[DbGl2016.COL_JOURNAL_TYPE]));
            gl2016.setOwnerId(rs.getLong(DbGl2016.colNames[DbGl2016.COL_OWNER_ID]));
            gl2016.setRefNumber(rs.getString(DbGl2016.colNames[DbGl2016.COL_REF_NUMBER]));
            gl2016.setCurrencyId(rs.getLong(DbGl2016.colNames[DbGl2016.COL_CURRENCY_ID]));
            gl2016.setMemo(rs.getString(DbGl2016.colNames[DbGl2016.COL_MEMO]));
            gl2016.setPeriodId(rs.getLong(DbGl2016.colNames[DbGl2016.COL_PERIOD_ID]));
            gl2016.setActivityStatus(rs.getString(DbGl2016.colNames[DbGl2016.COL_ACTIVITY_STATUS]));
            gl2016.setNotActivityBase(rs.getInt(DbGl2016.colNames[DbGl2016.COL_NOT_ACTIVITY_BASE]));
            gl2016.setIsReversal(rs.getInt(colNames[COL_IS_REVERSAL]));
            gl2016.setReversalDate(rs.getDate(colNames[COL_REVERSAL_DATE]));
            gl2016.setReversalType(rs.getInt(colNames[COL_REVERSAL_TYPE]));
            gl2016.setReversalStatus(rs.getInt(colNames[COL_REVERSAL_STATUS]));
            gl2016.setPostedStatus(rs.getInt(colNames[COL_POSTED_STATUS]));
            gl2016.setPostedById(rs.getLong(colNames[COL_POSTED_BY_ID]));
            gl2016.setPostedDate(rs.getDate(colNames[COL_POSTED_DATE]));
            gl2016.setEffectiveDate(rs.getDate(colNames[COL_EFFECTIVE_DATE]));
            gl2016.setReferensiId(rs.getLong(colNames[COL_REFERENSI_ID]));

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }
    }

    public static boolean checkOID(long glId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_GL2016 + " WHERE " +
                    DbGl2016.colNames[DbGl2016.COL_GL_ID] + " = " + glId;

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
            String sql = "SELECT COUNT(" + DbGl2016.colNames[DbGl2016.COL_GL_ID] + ") FROM " + DB_GL2016;
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
                    Gl2016 gl2016 = (Gl2016) list.get(ls);
                    if (oid == gl2016.getOID()) {
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
    
    public static long postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, int journalType, String memo,
            long operatorId, String operatorName, long ownerId, String refNumber, Date transDate, long periodeId){

        Periode openPeriod = new Periode();

        try {
            openPeriod = DbPeriode.getOpenPeriod(); // jika periodeId == 0
            if (periodeId != 0) {
                openPeriod = DbPeriode.fetchExc(periodeId);
            }
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }

        if (transDate.before(openPeriod.getStartDate())) {
            transDate = openPeriod.getStartDate();
        }

        if (transDate.after(openPeriod.getEndDate())) {
            transDate = openPeriod.getEndDate();
        }

        Gl2016 gl2016 = new Gl2016();
        gl2016.setPeriodId(openPeriod.getOID());
        gl2016.setCurrencyId(currencyId);
        gl2016.setDate(dt);
        gl2016.setJournalCounter(counter);
        gl2016.setJournalNumber(number);
        gl2016.setJournalPrefix(prefix);
        gl2016.setTransDate(transDate);
        gl2016.setOperatorId(operatorId);
        gl2016.setOperatorName(operatorName);
        gl2016.setJournalType(journalType);
        gl2016.setOwnerId(ownerId);
        gl2016.setRefNumber(refNumber);
        gl2016.setMemo(memo);
        gl2016.setPostedStatus(DbGl.POSTED);
        gl2016.setPostedDate(new Date());
        gl2016.setPostedById(operatorId);

        long oid = 0;
        try {
            oid = DbGl2016.insertExc(gl2016);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return oid;
    }
    
    public static long postJournalDetail(double bookedRate, long coaId, double credit, double debet,
            double fCurrAmount, long currId, long glId, String memo, long departmentId,
            long segment1Id, long segment2Id, long segment3Id, long segment4Id, long segment5Id, long segment6Id,
            long segment7Id, long segment8Id, long segment9Id, long segment10Id, long segment11Id, long segment12Id,
            long segment13Id, long segment14Id, long segment15Id, long moduleId) {
        GlDetail2016 gldetail2016 = new GlDetail2016();
        gldetail2016.setGlId(glId);
        gldetail2016.setCoaId(coaId);
        gldetail2016.setDebet(debet);
        gldetail2016.setCredit(credit);
        gldetail2016.setForeignCurrencyId(currId);
        gldetail2016.setForeignCurrencyAmount(fCurrAmount);
        gldetail2016.setMemo(memo);
        gldetail2016.setBookedRate(bookedRate);
        gldetail2016.setDepartmentId(departmentId);
        gldetail2016.setSegment1Id(segment1Id);
        gldetail2016.setSegment2Id(segment2Id);
        gldetail2016.setSegment3Id(segment3Id);
        gldetail2016.setSegment4Id(segment4Id);
        gldetail2016.setSegment5Id(segment5Id);
        gldetail2016.setSegment6Id(segment6Id);
        gldetail2016.setSegment7Id(segment7Id);
        gldetail2016.setSegment8Id(segment8Id);
        gldetail2016.setSegment9Id(segment9Id);
        gldetail2016.setSegment10Id(segment10Id);
        gldetail2016.setSegment11Id(segment11Id);
        gldetail2016.setSegment12Id(segment12Id);
        gldetail2016.setSegment13Id(segment13Id);
        gldetail2016.setSegment14Id(segment14Id);
        gldetail2016.setSegment15Id(segment15Id);
        gldetail2016.setModuleId(moduleId);

        if (departmentId != 0) {
            try {
                Department d = DbDepartment.fetchExc(departmentId);
                switch (d.getLevel()) {
                    case DbDepartment.LEVEL_DIREKTORAT:
                        gldetail2016.setDirectorateId(departmentId);
                        break;

                    case DbDepartment.LEVEL_DIVISION:
                        gldetail2016.setDivisionId(departmentId);
                        gldetail2016.setDirectorateId(d.getRefId());
                        break;

                    case DbDepartment.LEVEL_DEPARTMENT:
                        gldetail2016.setDepartmentId(departmentId);
                        gldetail2016.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SECTION:
                        gldetail2016.setSectionId(departmentId);
                        gldetail2016.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SUB_SECTION:
                        gldetail2016.setSubSectionId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_JOB:
                        gldetail2016.setJobId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setSubSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2016.setDirectorateId(d.getRefId());
                        break;
                }
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }
        }

        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(gldetail2016.getCoaId());
        } catch (Exception e) {
        }

        gldetail2016 = DbGlDetail2016.setCoaLevel(gldetail2016);
        gldetail2016 = DbGlDetail2016.setOrganizationLevel(gldetail2016);

        long oid = 0;

        try {
            oid = DbGlDetail2016.insertExc(gldetail2016);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        //process budget
        if (oid != 0 && gldetail2016.getModuleId() != 0) {
            double amount = 0;

            if (gldetail2016.getDebet() > 0) {

                //kalau saldo normal debet, maka(+)
                amount = gldetail2016.getDebet();

                //saldo normal credit
                if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {

                    amount = amount * -1;
                }
            } else {
                //kalau saldo normal debet maka (-)
                amount = gldetail2016.getCredit() * -1;

                //saldo normal credit, maka kembalikan ke positif
                if (!(coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                        coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))) {
                    amount = amount * -1;
                }
            }

            if (oid != 0 && amount != 0) {
                DbModuleBudget.updateBudgetUsed(gldetail2016.getModuleId(), gldetail2016.getCoaId(), amount);
            }
        }

        return oid;
    }
    

}
