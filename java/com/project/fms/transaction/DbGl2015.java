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
public class DbGl2015 extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language  {
    
    public static final String DB_GL2015 = "gl_2015";
    
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

    public DbGl2015() {
    }

    public DbGl2015(int i) throws CONException {
        super(new DbGl2015());
    }

    public DbGl2015(String sOid) throws CONException {
        super(new DbGl2015(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGl2015(long lOid) throws CONException {
        super(new DbGl2015(0));
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
        return DB_GL2015;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGl2015().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Gl2015 gl2015 = fetchExc(ent.getOID());
        ent = (Entity) gl2015;
        return gl2015.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Gl2015) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Gl2015) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Gl2015 fetchExc(long oid) throws CONException {
        try {
            Gl2015 gl2015 = new Gl2015();
            DbGl2015 pstGl2015 = new DbGl2015(oid);
            gl2015.setOID(oid);

            gl2015.setJournalNumber(pstGl2015.getString(COL_JOURNAL_NUMBER));
            gl2015.setJournalCounter(pstGl2015.getInt(COL_JOURNAL_COUNTER));
            gl2015.setJournalPrefix(pstGl2015.getString(COL_JOURNAL_PREFIX));
            gl2015.setDate(pstGl2015.getDate(COL_DATE));
            gl2015.setTransDate(pstGl2015.getDate(COL_TRANS_DATE));
            gl2015.setOperatorId(pstGl2015.getlong(COL_OPERATOR_ID));
            gl2015.setOperatorName(pstGl2015.getString(COL_OPERATOR_NAME));
            gl2015.setJournalType(pstGl2015.getInt(COL_JOURNAL_TYPE));
            gl2015.setOwnerId(pstGl2015.getlong(COL_OWNER_ID));
            gl2015.setRefNumber(pstGl2015.getString(COL_REF_NUMBER));
            gl2015.setCurrencyId(pstGl2015.getlong(COL_CURRENCY_ID));
            gl2015.setMemo(pstGl2015.getString(COL_MEMO));
            gl2015.setPeriodId(pstGl2015.getlong(COL_PERIOD_ID));
            gl2015.setActivityStatus(pstGl2015.getString(COL_ACTIVITY_STATUS));
            gl2015.setNotActivityBase(pstGl2015.getInt(COL_NOT_ACTIVITY_BASE));
            gl2015.setIsReversal(pstGl2015.getInt(COL_IS_REVERSAL));
            gl2015.setReversalDate(pstGl2015.getDate(COL_REVERSAL_DATE));
            gl2015.setReversalType(pstGl2015.getInt(COL_REVERSAL_TYPE));
            gl2015.setReversalStatus(pstGl2015.getInt(COL_REVERSAL_STATUS));
            gl2015.setPostedStatus(pstGl2015.getInt(COL_POSTED_STATUS));
            gl2015.setPostedById(pstGl2015.getlong(COL_POSTED_BY_ID));
            gl2015.setPostedDate(pstGl2015.getDate(COL_POSTED_DATE));
            gl2015.setEffectiveDate(pstGl2015.getDate(COL_EFFECTIVE_DATE));
            gl2015.setReferensiId(pstGl2015.getlong(COL_REFERENSI_ID));

            return gl2015;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2015(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Gl2015 gl2015) throws CONException {
        try {
            DbGl2015 pstGl2015 = new DbGl2015(0);

            pstGl2015.setString(COL_JOURNAL_NUMBER, gl2015.getJournalNumber());
            pstGl2015.setInt(COL_JOURNAL_COUNTER, gl2015.getJournalCounter());
            pstGl2015.setString(COL_JOURNAL_PREFIX, gl2015.getJournalPrefix());
            pstGl2015.setDate(COL_DATE, gl2015.getDate());
            pstGl2015.setDate(COL_TRANS_DATE, gl2015.getTransDate());
            pstGl2015.setLong(COL_OPERATOR_ID, gl2015.getOperatorId());
            pstGl2015.setString(COL_OPERATOR_NAME, gl2015.getOperatorName());
            pstGl2015.setInt(COL_JOURNAL_TYPE, gl2015.getJournalType());
            pstGl2015.setLong(COL_OWNER_ID, gl2015.getOwnerId());
            pstGl2015.setString(COL_REF_NUMBER, gl2015.getRefNumber());
            pstGl2015.setLong(COL_CURRENCY_ID, gl2015.getCurrencyId());
            pstGl2015.setString(COL_MEMO, gl2015.getMemo());
            pstGl2015.setLong(COL_PERIOD_ID, gl2015.getPeriodId());
            pstGl2015.setString(COL_ACTIVITY_STATUS, gl2015.getActivityStatus());
            pstGl2015.setInt(COL_NOT_ACTIVITY_BASE, gl2015.getNotActivityBase());
            pstGl2015.setInt(COL_IS_REVERSAL, gl2015.getIsReversal());
            pstGl2015.setDate(COL_REVERSAL_DATE, gl2015.getReversalDate());
            pstGl2015.setInt(COL_REVERSAL_TYPE, gl2015.getReversalType());
            pstGl2015.setInt(COL_REVERSAL_STATUS, gl2015.getReversalStatus());
            pstGl2015.setInt(COL_POSTED_STATUS, gl2015.getPostedStatus());
            pstGl2015.setLong(COL_POSTED_BY_ID, gl2015.getPostedById());
            pstGl2015.setDate(COL_POSTED_DATE, gl2015.getPostedDate());
            pstGl2015.setDate(COL_EFFECTIVE_DATE, gl2015.getEffectiveDate());
            pstGl2015.setLong(COL_REFERENSI_ID, gl2015.getReferensiId());

            pstGl2015.insert();
            gl2015.setOID(pstGl2015.getlong(COL_GL_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2015(0), CONException.UNKNOWN);
        }
        return gl2015.getOID();
    }

    public static long updateExc(Gl2015 gl2015) throws CONException {
        try {
            if (gl2015.getOID() != 0) {
                DbGl2015 pstGl2015 = new DbGl2015(gl2015.getOID());

                pstGl2015.setString(COL_JOURNAL_NUMBER, gl2015.getJournalNumber());
                pstGl2015.setInt(COL_JOURNAL_COUNTER, gl2015.getJournalCounter());
                pstGl2015.setString(COL_JOURNAL_PREFIX, gl2015.getJournalPrefix());
                pstGl2015.setDate(COL_DATE, gl2015.getDate());
                pstGl2015.setDate(COL_TRANS_DATE, gl2015.getTransDate());
                pstGl2015.setLong(COL_OPERATOR_ID, gl2015.getOperatorId());
                pstGl2015.setString(COL_OPERATOR_NAME, gl2015.getOperatorName());
                pstGl2015.setInt(COL_JOURNAL_TYPE, gl2015.getJournalType());
                pstGl2015.setLong(COL_OWNER_ID, gl2015.getOwnerId());
                pstGl2015.setString(COL_REF_NUMBER, gl2015.getRefNumber());
                pstGl2015.setLong(COL_CURRENCY_ID, gl2015.getCurrencyId());
                pstGl2015.setString(COL_MEMO, gl2015.getMemo());
                pstGl2015.setLong(COL_PERIOD_ID, gl2015.getPeriodId());
                pstGl2015.setString(COL_ACTIVITY_STATUS, gl2015.getActivityStatus());
                pstGl2015.setInt(COL_NOT_ACTIVITY_BASE, gl2015.getNotActivityBase());
                pstGl2015.setInt(COL_IS_REVERSAL, gl2015.getIsReversal());
                pstGl2015.setDate(COL_REVERSAL_DATE, gl2015.getReversalDate());
                pstGl2015.setInt(COL_REVERSAL_TYPE, gl2015.getReversalType());
                pstGl2015.setInt(COL_REVERSAL_STATUS, gl2015.getReversalStatus());
                pstGl2015.setInt(COL_POSTED_STATUS, gl2015.getPostedStatus());
                pstGl2015.setLong(COL_POSTED_BY_ID, gl2015.getPostedById());
                pstGl2015.setDate(COL_POSTED_DATE, gl2015.getPostedDate());
                pstGl2015.setDate(COL_EFFECTIVE_DATE, gl2015.getEffectiveDate());
                pstGl2015.setLong(COL_REFERENSI_ID, gl2015.getReferensiId());

                pstGl2015.update();
                return gl2015.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2015(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGl2015 pstGl2015 = new DbGl2015(oid);
            pstGl2015.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl2015(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_GL2015;
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
                Gl2015 gl2015 = new Gl2015();
                resultToObject(rs, gl2015);
                lists.add(gl2015);
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

    public static void resultToObject(ResultSet rs, Gl2015 gl2015) {
        try {
            gl2015.setOID(rs.getLong(DbGl2015.colNames[DbGl2015.COL_GL_ID]));
            gl2015.setJournalNumber(rs.getString(DbGl2015.colNames[DbGl2015.COL_JOURNAL_NUMBER]));
            gl2015.setJournalCounter(rs.getInt(DbGl2015.colNames[DbGl2015.COL_JOURNAL_COUNTER]));
            gl2015.setJournalPrefix(rs.getString(DbGl2015.colNames[DbGl2015.COL_JOURNAL_PREFIX]));
            gl2015.setDate(rs.getDate(DbGl2015.colNames[DbGl2015.COL_DATE]));
            gl2015.setTransDate(rs.getDate(DbGl2015.colNames[DbGl2015.COL_TRANS_DATE]));
            gl2015.setOperatorId(rs.getLong(DbGl2015.colNames[DbGl2015.COL_OPERATOR_ID]));
            gl2015.setOperatorName(rs.getString(DbGl2015.colNames[DbGl2015.COL_OPERATOR_NAME]));
            gl2015.setJournalType(rs.getInt(DbGl2015.colNames[DbGl2015.COL_JOURNAL_TYPE]));
            gl2015.setOwnerId(rs.getLong(DbGl2015.colNames[DbGl2015.COL_OWNER_ID]));
            gl2015.setRefNumber(rs.getString(DbGl2015.colNames[DbGl2015.COL_REF_NUMBER]));
            gl2015.setCurrencyId(rs.getLong(DbGl2015.colNames[DbGl2015.COL_CURRENCY_ID]));
            gl2015.setMemo(rs.getString(DbGl2015.colNames[DbGl2015.COL_MEMO]));
            gl2015.setPeriodId(rs.getLong(DbGl2015.colNames[DbGl2015.COL_PERIOD_ID]));
            gl2015.setActivityStatus(rs.getString(DbGl2015.colNames[DbGl2015.COL_ACTIVITY_STATUS]));
            gl2015.setNotActivityBase(rs.getInt(DbGl2015.colNames[DbGl2015.COL_NOT_ACTIVITY_BASE]));
            gl2015.setIsReversal(rs.getInt(colNames[COL_IS_REVERSAL]));
            gl2015.setReversalDate(rs.getDate(colNames[COL_REVERSAL_DATE]));
            gl2015.setReversalType(rs.getInt(colNames[COL_REVERSAL_TYPE]));
            gl2015.setReversalStatus(rs.getInt(colNames[COL_REVERSAL_STATUS]));
            gl2015.setPostedStatus(rs.getInt(colNames[COL_POSTED_STATUS]));
            gl2015.setPostedById(rs.getLong(colNames[COL_POSTED_BY_ID]));
            gl2015.setPostedDate(rs.getDate(colNames[COL_POSTED_DATE]));
            gl2015.setEffectiveDate(rs.getDate(colNames[COL_EFFECTIVE_DATE]));
            gl2015.setReferensiId(rs.getLong(colNames[COL_REFERENSI_ID]));

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }
    }

    public static boolean checkOID(long glId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_GL2015 + " WHERE " +
                    DbGl2015.colNames[DbGl2015.COL_GL_ID] + " = " + glId;

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
            String sql = "SELECT COUNT(" + DbGl2015.colNames[DbGl2015.COL_GL_ID] + ") FROM " + DB_GL2015;
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
                    Gl2015 gl2015 = (Gl2015) list.get(ls);
                    if (oid == gl2015.getOID()) {
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

        Gl2015 gl2015 = new Gl2015();
        gl2015.setPeriodId(openPeriod.getOID());
        gl2015.setCurrencyId(currencyId);
        gl2015.setDate(dt);
        gl2015.setJournalCounter(counter);
        gl2015.setJournalNumber(number);
        gl2015.setJournalPrefix(prefix);
        gl2015.setTransDate(transDate);
        gl2015.setOperatorId(operatorId);
        gl2015.setOperatorName(operatorName);
        gl2015.setJournalType(journalType);
        gl2015.setOwnerId(ownerId);
        gl2015.setRefNumber(refNumber);
        gl2015.setMemo(memo);
        gl2015.setPostedStatus(DbGl.POSTED);
        gl2015.setPostedDate(new Date());
        gl2015.setPostedById(operatorId);

        long oid = 0;
        try {
            oid = DbGl2015.insertExc(gl2015);
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
        GlDetail2015 gldetail2015 = new GlDetail2015();
        gldetail2015.setGlId(glId);
        gldetail2015.setCoaId(coaId);
        gldetail2015.setDebet(debet);
        gldetail2015.setCredit(credit);
        gldetail2015.setForeignCurrencyId(currId);
        gldetail2015.setForeignCurrencyAmount(fCurrAmount);
        gldetail2015.setMemo(memo);
        gldetail2015.setBookedRate(bookedRate);
        gldetail2015.setDepartmentId(departmentId);
        gldetail2015.setSegment1Id(segment1Id);
        gldetail2015.setSegment2Id(segment2Id);
        gldetail2015.setSegment3Id(segment3Id);
        gldetail2015.setSegment4Id(segment4Id);
        gldetail2015.setSegment5Id(segment5Id);
        gldetail2015.setSegment6Id(segment6Id);
        gldetail2015.setSegment7Id(segment7Id);
        gldetail2015.setSegment8Id(segment8Id);
        gldetail2015.setSegment9Id(segment9Id);
        gldetail2015.setSegment10Id(segment10Id);
        gldetail2015.setSegment11Id(segment11Id);
        gldetail2015.setSegment12Id(segment12Id);
        gldetail2015.setSegment13Id(segment13Id);
        gldetail2015.setSegment14Id(segment14Id);
        gldetail2015.setSegment15Id(segment15Id);
        gldetail2015.setModuleId(moduleId);

        if (departmentId != 0) {
            try {
                Department d = DbDepartment.fetchExc(departmentId);
                switch (d.getLevel()) {
                    case DbDepartment.LEVEL_DIREKTORAT:
                        gldetail2015.setDirectorateId(departmentId);
                        break;

                    case DbDepartment.LEVEL_DIVISION:
                        gldetail2015.setDivisionId(departmentId);
                        gldetail2015.setDirectorateId(d.getRefId());
                        break;

                    case DbDepartment.LEVEL_DEPARTMENT:
                        gldetail2015.setDepartmentId(departmentId);
                        gldetail2015.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SECTION:
                        gldetail2015.setSectionId(departmentId);
                        gldetail2015.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SUB_SECTION:
                        gldetail2015.setSubSectionId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_JOB:
                        gldetail2015.setJobId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setSubSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail2015.setDirectorateId(d.getRefId());
                        break;
                }
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }
        }

        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(gldetail2015.getCoaId());
        } catch (Exception e) {
        }

        gldetail2015 = DbGlDetail2015.setCoaLevel(gldetail2015);
        gldetail2015 = DbGlDetail2015.setOrganizationLevel(gldetail2015);

        long oid = 0;

        try {
            oid = DbGlDetail2015.insertExc(gldetail2015);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        //process budget
        if (oid != 0 && gldetail2015.getModuleId() != 0) {
            double amount = 0;

            if (gldetail2015.getDebet() > 0) {

                //kalau saldo normal debet, maka(+)
                amount = gldetail2015.getDebet();

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
                amount = gldetail2015.getCredit() * -1;

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
                DbModuleBudget.updateBudgetUsed(gldetail2015.getModuleId(), gldetail2015.getCoaId(), amount);
            }
        }

        return oid;
    }
    
    
}
