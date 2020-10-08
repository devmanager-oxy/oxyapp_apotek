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
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;
import com.project.fms.activity.*;

public class DbGl extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_GL = "gl";
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
    //add by Roy Andika
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

    public DbGl() {
    }

    public DbGl(int i) throws CONException {
        super(new DbGl());
    }

    public DbGl(String sOid) throws CONException {
        super(new DbGl(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGl(long lOid) throws CONException {
        super(new DbGl(0));
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
        return DB_GL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGl().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Gl gl = fetchExc(ent.getOID());
        ent = (Entity) gl;
        return gl.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Gl) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Gl) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Gl fetchExc(long oid) throws CONException {
        try {
            Gl gl = new Gl();
            DbGl pstGl = new DbGl(oid);
            gl.setOID(oid);

            gl.setJournalNumber(pstGl.getString(COL_JOURNAL_NUMBER));
            gl.setJournalCounter(pstGl.getInt(COL_JOURNAL_COUNTER));
            gl.setJournalPrefix(pstGl.getString(COL_JOURNAL_PREFIX));
            gl.setDate(pstGl.getDate(COL_DATE));
            gl.setTransDate(pstGl.getDate(COL_TRANS_DATE));
            gl.setOperatorId(pstGl.getlong(COL_OPERATOR_ID));
            gl.setOperatorName(pstGl.getString(COL_OPERATOR_NAME));
            gl.setJournalType(pstGl.getInt(COL_JOURNAL_TYPE));
            gl.setOwnerId(pstGl.getlong(COL_OWNER_ID));
            gl.setRefNumber(pstGl.getString(COL_REF_NUMBER));
            gl.setCurrencyId(pstGl.getlong(COL_CURRENCY_ID));
            gl.setMemo(pstGl.getString(COL_MEMO));
            gl.setPeriodId(pstGl.getlong(COL_PERIOD_ID));
            gl.setActivityStatus(pstGl.getString(COL_ACTIVITY_STATUS));
            gl.setNotActivityBase(pstGl.getInt(COL_NOT_ACTIVITY_BASE));
            gl.setIsReversal(pstGl.getInt(COL_IS_REVERSAL));
            gl.setReversalDate(pstGl.getDate(COL_REVERSAL_DATE));
            gl.setReversalType(pstGl.getInt(COL_REVERSAL_TYPE));
            gl.setReversalStatus(pstGl.getInt(COL_REVERSAL_STATUS));
            gl.setPostedStatus(pstGl.getInt(COL_POSTED_STATUS));
            gl.setPostedById(pstGl.getlong(COL_POSTED_BY_ID));
            gl.setPostedDate(pstGl.getDate(COL_POSTED_DATE));
            gl.setEffectiveDate(pstGl.getDate(COL_EFFECTIVE_DATE));
            gl.setReferensiId(pstGl.getlong(COL_REFERENSI_ID));

            return gl;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Gl gl) throws CONException {
        try {
            DbGl pstGl = new DbGl(0);

            pstGl.setString(COL_JOURNAL_NUMBER, gl.getJournalNumber());
            pstGl.setInt(COL_JOURNAL_COUNTER, gl.getJournalCounter());
            pstGl.setString(COL_JOURNAL_PREFIX, gl.getJournalPrefix());
            pstGl.setDate(COL_DATE, gl.getDate());
            pstGl.setDate(COL_TRANS_DATE, gl.getTransDate());
            pstGl.setLong(COL_OPERATOR_ID, gl.getOperatorId());
            pstGl.setString(COL_OPERATOR_NAME, gl.getOperatorName());
            pstGl.setInt(COL_JOURNAL_TYPE, gl.getJournalType());
            pstGl.setLong(COL_OWNER_ID, gl.getOwnerId());
            pstGl.setString(COL_REF_NUMBER, gl.getRefNumber());
            pstGl.setLong(COL_CURRENCY_ID, gl.getCurrencyId());
            pstGl.setString(COL_MEMO, gl.getMemo());
            pstGl.setLong(COL_PERIOD_ID, gl.getPeriodId());
            pstGl.setString(COL_ACTIVITY_STATUS, gl.getActivityStatus());
            pstGl.setInt(COL_NOT_ACTIVITY_BASE, gl.getNotActivityBase());
            pstGl.setInt(COL_IS_REVERSAL, gl.getIsReversal());
            pstGl.setDate(COL_REVERSAL_DATE, gl.getReversalDate());
            pstGl.setInt(COL_REVERSAL_TYPE, gl.getReversalType());
            pstGl.setInt(COL_REVERSAL_STATUS, gl.getReversalStatus());
            pstGl.setInt(COL_POSTED_STATUS, gl.getPostedStatus());
            pstGl.setLong(COL_POSTED_BY_ID, gl.getPostedById());
            pstGl.setDate(COL_POSTED_DATE, gl.getPostedDate());
            pstGl.setDate(COL_EFFECTIVE_DATE, gl.getEffectiveDate());
            pstGl.setLong(COL_REFERENSI_ID, gl.getReferensiId());

            pstGl.insert();
            gl.setOID(pstGl.getlong(COL_GL_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl(0), CONException.UNKNOWN);
        }
        return gl.getOID();
    }

    public static long updateExc(Gl gl) throws CONException {
        try {
            if (gl.getOID() != 0) {
                DbGl pstGl = new DbGl(gl.getOID());

                pstGl.setString(COL_JOURNAL_NUMBER, gl.getJournalNumber());
                pstGl.setInt(COL_JOURNAL_COUNTER, gl.getJournalCounter());
                pstGl.setString(COL_JOURNAL_PREFIX, gl.getJournalPrefix());
                pstGl.setDate(COL_DATE, gl.getDate());
                pstGl.setDate(COL_TRANS_DATE, gl.getTransDate());
                pstGl.setLong(COL_OPERATOR_ID, gl.getOperatorId());
                pstGl.setString(COL_OPERATOR_NAME, gl.getOperatorName());
                pstGl.setInt(COL_JOURNAL_TYPE, gl.getJournalType());
                pstGl.setLong(COL_OWNER_ID, gl.getOwnerId());
                pstGl.setString(COL_REF_NUMBER, gl.getRefNumber());
                pstGl.setLong(COL_CURRENCY_ID, gl.getCurrencyId());
                pstGl.setString(COL_MEMO, gl.getMemo());
                pstGl.setLong(COL_PERIOD_ID, gl.getPeriodId());
                pstGl.setString(COL_ACTIVITY_STATUS, gl.getActivityStatus());
                pstGl.setInt(COL_NOT_ACTIVITY_BASE, gl.getNotActivityBase());
                pstGl.setInt(COL_IS_REVERSAL, gl.getIsReversal());
                pstGl.setDate(COL_REVERSAL_DATE, gl.getReversalDate());
                pstGl.setInt(COL_REVERSAL_TYPE, gl.getReversalType());
                pstGl.setInt(COL_REVERSAL_STATUS, gl.getReversalStatus());
                pstGl.setInt(COL_POSTED_STATUS, gl.getPostedStatus());
                pstGl.setLong(COL_POSTED_BY_ID, gl.getPostedById());
                pstGl.setDate(COL_POSTED_DATE, gl.getPostedDate());
                pstGl.setDate(COL_EFFECTIVE_DATE, gl.getEffectiveDate());
                pstGl.setLong(COL_REFERENSI_ID, gl.getReferensiId());

                pstGl.update();
                return gl.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGl pstGl = new DbGl(oid);
            pstGl.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGl(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_GL;
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
                Gl gl = new Gl();
                resultToObject(rs, gl);
                lists.add(gl);
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

    public static void resultToObject(ResultSet rs, Gl gl) {
        try {
            gl.setOID(rs.getLong(DbGl.colNames[DbGl.COL_GL_ID]));
            gl.setJournalNumber(rs.getString(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]));
            gl.setJournalCounter(rs.getInt(DbGl.colNames[DbGl.COL_JOURNAL_COUNTER]));
            gl.setJournalPrefix(rs.getString(DbGl.colNames[DbGl.COL_JOURNAL_PREFIX]));
            gl.setDate(rs.getDate(DbGl.colNames[DbGl.COL_DATE]));
            gl.setTransDate(rs.getDate(DbGl.colNames[DbGl.COL_TRANS_DATE]));
            gl.setOperatorId(rs.getLong(DbGl.colNames[DbGl.COL_OPERATOR_ID]));
            gl.setOperatorName(rs.getString(DbGl.colNames[DbGl.COL_OPERATOR_NAME]));
            gl.setJournalType(rs.getInt(DbGl.colNames[DbGl.COL_JOURNAL_TYPE]));
            gl.setOwnerId(rs.getLong(DbGl.colNames[DbGl.COL_OWNER_ID]));
            gl.setRefNumber(rs.getString(DbGl.colNames[DbGl.COL_REF_NUMBER]));
            gl.setCurrencyId(rs.getLong(DbGl.colNames[DbGl.COL_CURRENCY_ID]));
            gl.setMemo(rs.getString(DbGl.colNames[DbGl.COL_MEMO]));
            gl.setPeriodId(rs.getLong(DbGl.colNames[DbGl.COL_PERIOD_ID]));
            gl.setActivityStatus(rs.getString(DbGl.colNames[DbGl.COL_ACTIVITY_STATUS]));
            gl.setNotActivityBase(rs.getInt(DbGl.colNames[DbGl.COL_NOT_ACTIVITY_BASE]));
            gl.setIsReversal(rs.getInt(colNames[COL_IS_REVERSAL]));
            gl.setReversalDate(rs.getDate(colNames[COL_REVERSAL_DATE]));
            gl.setReversalType(rs.getInt(colNames[COL_REVERSAL_TYPE]));
            gl.setReversalStatus(rs.getInt(colNames[COL_REVERSAL_STATUS]));
            gl.setPostedStatus(rs.getInt(colNames[COL_POSTED_STATUS]));
            gl.setPostedById(rs.getLong(colNames[COL_POSTED_BY_ID]));
            gl.setPostedDate(rs.getDate(colNames[COL_POSTED_DATE]));
            gl.setEffectiveDate(rs.getDate(colNames[COL_EFFECTIVE_DATE]));
            gl.setReferensiId(rs.getLong(colNames[COL_REFERENSI_ID]));

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }
    }

    public static boolean checkOID(long glId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_GL + " WHERE " +
                    DbGl.colNames[DbGl.COL_GL_ID] + " = " + glId;

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
            String sql = "SELECT COUNT(" + DbGl.colNames[DbGl.COL_GL_ID] + ") FROM " + DB_GL;
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
                    Gl gl = (Gl) list.get(ls);
                    if (oid == gl.getOID()) {
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

    public static void updateStatusPosting(Gl gl, long userId) {

        try {
            gl = DbGl.fetchExc(gl.getOID());
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }
        
        Periode periode = new Periode();
        if (gl.getPeriodId() != 0) {
            try{
                periode = DbPeriode.fetchExc(gl.getPeriodId());
            }catch(Exception e){}
        }    
        
        if(gl.getPeriodId() != 0 && periode.getOID() != 0 && periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0){

            try {

                gl.setPostedStatus(POSTED);
                gl.setPostedById(userId);
                gl.setPostedDate(new Date());

                Date dt = new Date();
                String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                    DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                    DbPeriode.colNames[DbPeriode.COL_END_DATE];

                Vector temp = DbPeriode.list(0, 0, where, "");

                if (temp != null && temp.size() > 0) {
                    gl.setEffectiveDate(new Date());
                } else {
                    Periode per = DbPeriode.getOpenPeriod();
                    gl.setEffectiveDate(per.getEndDate());
                }

                DbGl.updateExc(gl);

            } catch (Exception e) {
                System.out.println("[Exception]" + e.toString());
            }
        }
    }

    public static long postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, int journalType, String memo,
            long operatorId, String operatorName, long ownerId, String refNumber, Date transDate) {

        Periode openPeriod = DbPeriode.getOpenPeriod();
        
        if(openPeriod.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0){
            return 0;
        }

        if (transDate.before(openPeriod.getStartDate())) {
            transDate = openPeriod.getStartDate();
        }

        if (transDate.after(openPeriod.getEndDate())) {
            transDate = openPeriod.getEndDate();
        }

        Gl gl = new Gl();
        gl.setPeriodId(openPeriod.getOID());
        gl.setCurrencyId(currencyId);
        gl.setDate(dt);
        gl.setJournalCounter(counter);
        gl.setJournalNumber(number);
        gl.setJournalPrefix(prefix);
        gl.setTransDate(transDate);
        gl.setOperatorId(operatorId);
        gl.setOperatorName(operatorName);
        gl.setJournalType(journalType);
        gl.setOwnerId(ownerId);
        gl.setRefNumber(refNumber);
        gl.setMemo(memo);
        gl.setPostedStatus(DbGl.POSTED);
        gl.setPostedDate(new Date());
        gl.setPostedById(operatorId);

        long oid = 0;
        try {
            oid = DbGl.insertExc(gl);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        return oid;

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
        
        if(openPeriod.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0){
            return 0;
        }

        if (transDate.before(openPeriod.getStartDate())) {
            transDate = openPeriod.getStartDate();
        }

        if (transDate.after(openPeriod.getEndDate())) {
            transDate = openPeriod.getEndDate();
        }

        Gl gl = new Gl();
        gl.setPeriodId(openPeriod.getOID());
        gl.setCurrencyId(currencyId);
        gl.setDate(dt);
        gl.setJournalCounter(counter);
        gl.setJournalNumber(number);
        gl.setJournalPrefix(prefix);
        gl.setTransDate(transDate);
        gl.setOperatorId(operatorId);
        gl.setOperatorName(operatorName);
        gl.setJournalType(journalType);
        gl.setOwnerId(ownerId);
        gl.setRefNumber(refNumber);
        gl.setMemo(memo);
        gl.setPostedStatus(DbGl.POSTED);
        gl.setPostedDate(new Date());
        gl.setPostedById(operatorId);

        long oid = 0;
        try {
            oid = DbGl.insertExc(gl);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return oid;
    }
    
    
    public static long postJournalMain(String tblName,long currencyId, Date dt, int counter, String number, String prefix, int journalType, String memo,
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
        
        if(openPeriod.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0){
            return 0;
        }

        if (transDate.before(openPeriod.getStartDate())) {
            transDate = openPeriod.getStartDate();
        }

        if (transDate.after(openPeriod.getEndDate())) {
            transDate = openPeriod.getEndDate();
        }
        
        long oid = 0;

        if(tblName.equals(I_Project.GL)){
            Gl gl = new Gl();
            gl.setPeriodId(openPeriod.getOID());
            gl.setCurrencyId(currencyId);
            gl.setDate(dt);
            gl.setJournalCounter(counter);
            gl.setJournalNumber(number);
            gl.setJournalPrefix(prefix);
            gl.setTransDate(transDate);
            gl.setOperatorId(operatorId);
            gl.setOperatorName(operatorName);
            gl.setJournalType(journalType);
            gl.setOwnerId(ownerId);
            gl.setRefNumber(refNumber);
            gl.setMemo(memo);
            gl.setPostedStatus(DbGl.POSTED);
            gl.setPostedDate(new Date());
            gl.setPostedById(operatorId);
            
            try {
                oid = DbGl.insertExc(gl);
            } catch (Exception e) {
                System.out.println(e.toString());
            }
        }else if(tblName.equals(I_Project.GL_2015)){
            Gl2015 gl = new Gl2015();
            gl.setPeriodId(openPeriod.getOID());
            gl.setCurrencyId(currencyId);
            gl.setDate(dt);
            gl.setJournalCounter(counter);
            gl.setJournalNumber(number);
            gl.setJournalPrefix(prefix);
            gl.setTransDate(transDate);
            gl.setOperatorId(operatorId);
            gl.setOperatorName(operatorName);
            gl.setJournalType(journalType);
            gl.setOwnerId(ownerId);
            gl.setRefNumber(refNumber);
            gl.setMemo(memo);
            gl.setPostedStatus(DbGl.POSTED);
            gl.setPostedDate(new Date());
            gl.setPostedById(operatorId);
            
            try {
                oid = DbGl2015.insertExc(gl);
            } catch (Exception e) {
                System.out.println(e.toString());
            }
        }else if(tblName.equals(I_Project.GL_2016)){
            Gl2016 gl = new Gl2016();
            gl.setPeriodId(openPeriod.getOID());
            gl.setCurrencyId(currencyId);
            gl.setDate(dt);
            gl.setJournalCounter(counter);
            gl.setJournalNumber(number);
            gl.setJournalPrefix(prefix);
            gl.setTransDate(transDate);
            gl.setOperatorId(operatorId);
            gl.setOperatorName(operatorName);
            gl.setJournalType(journalType);
            gl.setOwnerId(ownerId);
            gl.setRefNumber(refNumber);
            gl.setMemo(memo);
            gl.setPostedStatus(DbGl.POSTED);
            gl.setPostedDate(new Date());
            gl.setPostedById(operatorId);
            
            try {
                oid = DbGl2016.insertExc(gl);
            } catch (Exception e) {
                System.out.println(e.toString());
            }
        }else{
            Gl gl = new Gl();
            gl.setPeriodId(openPeriod.getOID());
            gl.setCurrencyId(currencyId);
            gl.setDate(dt);
            gl.setJournalCounter(counter);
            gl.setJournalNumber(number);
            gl.setJournalPrefix(prefix);
            gl.setTransDate(transDate);
            gl.setOperatorId(operatorId);
            gl.setOperatorName(operatorName);
            gl.setJournalType(journalType);
            gl.setOwnerId(ownerId);
            gl.setRefNumber(refNumber);
            gl.setMemo(memo);
            gl.setPostedStatus(DbGl.POSTED);
            gl.setPostedDate(new Date());
            gl.setPostedById(operatorId);
            
            try {
                oid = DbGl.insertExc(gl);
            } catch (Exception e) {
                System.out.println(e.toString());
            }
        }
        return oid;
    }
    
    
    public static long postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, int journalType, String memo,
            long operatorId, String operatorName, long ownerId, String refNumber, Date transDate, long periodeId,long referensiId){

        Periode openPeriod = new Periode();

        try {
            openPeriod = DbPeriode.getOpenPeriod(); // jika periodeId == 0
            if (periodeId != 0) {
                openPeriod = DbPeriode.fetchExc(periodeId);
            }
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }

        if(openPeriod.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0){
            return 0;
        }
        
        if (transDate.before(openPeriod.getStartDate())) {
            transDate = openPeriod.getStartDate();
        }

        if (transDate.after(openPeriod.getEndDate())) {
            transDate = openPeriod.getEndDate();
        }

        Gl gl = new Gl();
        gl.setPeriodId(openPeriod.getOID());
        gl.setCurrencyId(currencyId);
        gl.setDate(dt);
        gl.setJournalCounter(counter);
        gl.setJournalNumber(number);
        gl.setJournalPrefix(prefix);
        gl.setTransDate(transDate);
        gl.setOperatorId(operatorId);
        gl.setOperatorName(operatorName);
        gl.setJournalType(journalType);
        gl.setOwnerId(ownerId);
        gl.setRefNumber(refNumber);
        gl.setMemo(memo);
        gl.setPostedStatus(DbGl.POSTED);
        gl.setPostedDate(new Date());
        gl.setPostedById(operatorId);
        gl.setReferensiId(referensiId);

        long oid = 0;
        try {
            oid = DbGl.insertExc(gl);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return oid;
    }

    public static long postJournalDetailRetail(double bookedRate, long coaId, double credit, double debet,
            double fCurrAmount, long currId, long glId, String memo, long departmentId) {
        GlDetail gldetail = new GlDetail();
        gldetail.setGlId(glId);
        gldetail.setCoaId(coaId);
        gldetail.setDebet(debet);
        gldetail.setCredit(credit);
        gldetail.setForeignCurrencyId(currId);
        gldetail.setForeignCurrencyAmount(fCurrAmount);
        gldetail.setMemo(memo);
        gldetail.setBookedRate(bookedRate);

        if (departmentId != 0) {
            try {
                Department d = DbDepartment.fetchExc(departmentId);
                switch (d.getLevel()) {
                    case DbDepartment.LEVEL_DIREKTORAT:
                        gldetail.setDirectorateId(departmentId);
                        break;
                    case DbDepartment.LEVEL_DIVISION:
                        gldetail.setDivisionId(departmentId);
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_DEPARTMENT:
                        gldetail.setDepartmentId(departmentId);
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SECTION:
                        gldetail.setSectionId(departmentId);
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SUB_SECTION:
                        gldetail.setSubSectionId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_JOB:
                        gldetail.setJobId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSubSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                }
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }
        }

        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(gldetail.getCoaId());
        } catch (Exception e) {
        }

        gldetail = DbGlDetail.setCoaLevel(gldetail);
        gldetail = DbGlDetail.setOrganizationLevel(gldetail);

        long oid = 0;

        try {
            oid = DbGlDetail.insertExc(gldetail);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        //process budget
        if (oid != 0 && gldetail.getModuleId() != 0) {
            double amount = 0;

            if (gldetail.getDebet() > 0) {
                //kalau saldo normal debet, maka(+)
                amount = gldetail.getDebet();

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
                amount = gldetail.getCredit() * -1;

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
                DbModuleBudget.updateBudgetUsed(gldetail.getModuleId(), gldetail.getCoaId(), amount);
            }
        }
        return oid;
    }

    public static long postJournalDetail(double bookedRate, long coaId, double credit, double debet,
            double fCurrAmount, long currId, long glId, String memo, long departmentId) {
        GlDetail gldetail = new GlDetail();
        gldetail.setGlId(glId);
        gldetail.setCoaId(coaId);
        gldetail.setDebet(debet);
        gldetail.setCredit(credit);
        gldetail.setForeignCurrencyId(currId);
        gldetail.setForeignCurrencyAmount(fCurrAmount);
        gldetail.setMemo(memo);
        gldetail.setBookedRate(bookedRate);

        if (departmentId != 0) {
            try {
                Department d = DbDepartment.fetchExc(departmentId);
                switch (d.getLevel()) {
                    case DbDepartment.LEVEL_DIREKTORAT:
                        gldetail.setDirectorateId(departmentId);
                        break;
                    case DbDepartment.LEVEL_DIVISION:
                        gldetail.setDivisionId(departmentId);
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_DEPARTMENT:
                        gldetail.setDepartmentId(departmentId);
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SECTION:
                        gldetail.setSectionId(departmentId);
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SUB_SECTION:
                        gldetail.setSubSectionId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_JOB:
                        gldetail.setJobId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSubSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                }
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }
        }

        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(gldetail.getCoaId());
        } catch (Exception e) {
        }

        gldetail = DbGlDetail.setCoaLevel(gldetail);
        gldetail = DbGlDetail.setOrganizationLevel(gldetail);

        long oid = 0;

        try {
            oid = DbGlDetail.insertExc(gldetail);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        //process budget
        if (oid != 0 && gldetail.getModuleId() != 0) {
            double amount = 0;

            if (gldetail.getDebet() > 0) {
                //kalau saldo normal debet, maka(+)
                amount = gldetail.getDebet();

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
                amount = gldetail.getCredit() * -1;

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
                DbModuleBudget.updateBudgetUsed(gldetail.getModuleId(), gldetail.getCoaId(), amount);
            }
        }

        return oid;
    }

    public static long postJournalDetail(double bookedRate, long coaId, double credit, double debet,
            double fCurrAmount, long currId, long glId, String memo, long departmentId,
            long segment1Id, long segment2Id, long segment3Id, long segment4Id, long segment5Id, long segment6Id,
            long segment7Id, long segment8Id, long segment9Id, long segment10Id, long segment11Id, long segment12Id,
            long segment13Id, long segment14Id, long segment15Id, long moduleId) {
        GlDetail gldetail = new GlDetail();
        gldetail.setGlId(glId);
        gldetail.setCoaId(coaId);
        gldetail.setDebet(debet);
        gldetail.setCredit(credit);
        gldetail.setForeignCurrencyId(currId);
        gldetail.setForeignCurrencyAmount(fCurrAmount);
        gldetail.setMemo(memo);
        gldetail.setBookedRate(bookedRate);
        gldetail.setDepartmentId(departmentId);
        gldetail.setSegment1Id(segment1Id);
        gldetail.setSegment2Id(segment2Id);
        gldetail.setSegment3Id(segment3Id);
        gldetail.setSegment4Id(segment4Id);
        gldetail.setSegment5Id(segment5Id);
        gldetail.setSegment6Id(segment6Id);
        gldetail.setSegment7Id(segment7Id);
        gldetail.setSegment8Id(segment8Id);
        gldetail.setSegment9Id(segment9Id);
        gldetail.setSegment10Id(segment10Id);
        gldetail.setSegment11Id(segment11Id);
        gldetail.setSegment12Id(segment12Id);
        gldetail.setSegment13Id(segment13Id);
        gldetail.setSegment14Id(segment14Id);
        gldetail.setSegment15Id(segment15Id);
        gldetail.setModuleId(moduleId);

        if (departmentId != 0) {
            try {
                Department d = DbDepartment.fetchExc(departmentId);
                switch (d.getLevel()) {
                    case DbDepartment.LEVEL_DIREKTORAT:
                        gldetail.setDirectorateId(departmentId);
                        break;

                    case DbDepartment.LEVEL_DIVISION:
                        gldetail.setDivisionId(departmentId);
                        gldetail.setDirectorateId(d.getRefId());
                        break;

                    case DbDepartment.LEVEL_DEPARTMENT:
                        gldetail.setDepartmentId(departmentId);
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SECTION:
                        gldetail.setSectionId(departmentId);
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SUB_SECTION:
                        gldetail.setSubSectionId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_JOB:
                        gldetail.setJobId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSubSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                }
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }
        }

        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(gldetail.getCoaId());
        } catch (Exception e) {
        }

        gldetail = DbGlDetail.setCoaLevel(gldetail);
        gldetail = DbGlDetail.setOrganizationLevel(gldetail);

        long oid = 0;

        try {
            oid = DbGlDetail.insertExc(gldetail);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        //process budget
        if (oid != 0 && gldetail.getModuleId() != 0) {
            double amount = 0;

            if (gldetail.getDebet() > 0) {

                //kalau saldo normal debet, maka(+)
                amount = gldetail.getDebet();

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
                amount = gldetail.getCredit() * -1;

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
                DbModuleBudget.updateBudgetUsed(gldetail.getModuleId(), gldetail.getCoaId(), amount);
            }
        }

        return oid;
    }
    
    
     public static long postJournalDetail(String tblName,double bookedRate, long coaId, double credit, double debet,
            double fCurrAmount, long currId, long glId, String memo, long departmentId,
            long segment1Id, long segment2Id, long segment3Id, long segment4Id, long segment5Id, long segment6Id,
            long segment7Id, long segment8Id, long segment9Id, long segment10Id, long segment11Id, long segment12Id,
            long segment13Id, long segment14Id, long segment15Id, long moduleId) {
         
        long oid = 0;
         
        if(tblName.equals(I_Project.GL)){   
            GlDetail gldetail = new GlDetail();
            gldetail.setGlId(glId);
            gldetail.setCoaId(coaId);
            gldetail.setDebet(debet);
            gldetail.setCredit(credit);
            gldetail.setForeignCurrencyId(currId);
            gldetail.setForeignCurrencyAmount(fCurrAmount);
            gldetail.setMemo(memo);
            gldetail.setBookedRate(bookedRate);
            gldetail.setDepartmentId(departmentId);
            gldetail.setSegment1Id(segment1Id);
            gldetail.setSegment2Id(segment2Id);
            gldetail.setSegment3Id(segment3Id);
            gldetail.setSegment4Id(segment4Id);
            gldetail.setSegment5Id(segment5Id);
            gldetail.setSegment6Id(segment6Id);
            gldetail.setSegment7Id(segment7Id);
            gldetail.setSegment8Id(segment8Id);
            gldetail.setSegment9Id(segment9Id);
            gldetail.setSegment10Id(segment10Id);
            gldetail.setSegment11Id(segment11Id);
            gldetail.setSegment12Id(segment12Id);
            gldetail.setSegment13Id(segment13Id);
            gldetail.setSegment14Id(segment14Id);
            gldetail.setSegment15Id(segment15Id);
            gldetail.setModuleId(moduleId);

            if (departmentId != 0) {
                try {
                    Department d = DbDepartment.fetchExc(departmentId);
                    switch (d.getLevel()) {
                    case DbDepartment.LEVEL_DIREKTORAT:
                        gldetail.setDirectorateId(departmentId);
                        break;

                    case DbDepartment.LEVEL_DIVISION:
                        gldetail.setDivisionId(departmentId);
                        gldetail.setDirectorateId(d.getRefId());
                        break;

                    case DbDepartment.LEVEL_DEPARTMENT:
                        gldetail.setDepartmentId(departmentId);
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SECTION:
                        gldetail.setSectionId(departmentId);
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SUB_SECTION:
                        gldetail.setSubSectionId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_JOB:
                        gldetail.setJobId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSubSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    }
                } catch (Exception ex) {
                    System.out.println(ex.toString());
                }
            }

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(gldetail.getCoaId());
            } catch (Exception e) {
            }

            gldetail = DbGlDetail.setCoaLevel(gldetail);
            gldetail = DbGlDetail.setOrganizationLevel(gldetail);

            try {
                oid = DbGlDetail.insertExc(gldetail);
            } catch (Exception e) {
                System.out.println(e.toString());
            }

            //process budget
            if (oid != 0 && gldetail.getModuleId() != 0) {
                double amount = 0;

                if (gldetail.getDebet() > 0) {

                    //kalau saldo normal debet, maka(+)
                    amount = gldetail.getDebet();

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
                    amount = gldetail.getCredit() * -1;

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
                    DbModuleBudget.updateBudgetUsed(gldetail.getModuleId(), gldetail.getCoaId(), amount);
                }
            }
        }else if(tblName.equals(I_Project.GL_2015)){
            GlDetail2015 gldetail = new GlDetail2015();
            gldetail.setGlId(glId);
            gldetail.setCoaId(coaId);
            gldetail.setDebet(debet);
            gldetail.setCredit(credit);
            gldetail.setForeignCurrencyId(currId);
            gldetail.setForeignCurrencyAmount(fCurrAmount);
            gldetail.setMemo(memo);
            gldetail.setBookedRate(bookedRate);
            gldetail.setDepartmentId(departmentId);
            gldetail.setSegment1Id(segment1Id);
            gldetail.setSegment2Id(segment2Id);
            gldetail.setSegment3Id(segment3Id);
            gldetail.setSegment4Id(segment4Id);
            gldetail.setSegment5Id(segment5Id);
            gldetail.setSegment6Id(segment6Id);
            gldetail.setSegment7Id(segment7Id);
            gldetail.setSegment8Id(segment8Id);
            gldetail.setSegment9Id(segment9Id);
            gldetail.setSegment10Id(segment10Id);
            gldetail.setSegment11Id(segment11Id);
            gldetail.setSegment12Id(segment12Id);
            gldetail.setSegment13Id(segment13Id);
            gldetail.setSegment14Id(segment14Id);
            gldetail.setSegment15Id(segment15Id);
            gldetail.setModuleId(moduleId);

            if (departmentId != 0) {
                try {
                    Department d = DbDepartment.fetchExc(departmentId);
                    switch (d.getLevel()) {
                    case DbDepartment.LEVEL_DIREKTORAT:
                        gldetail.setDirectorateId(departmentId);
                        break;

                    case DbDepartment.LEVEL_DIVISION:
                        gldetail.setDivisionId(departmentId);
                        gldetail.setDirectorateId(d.getRefId());
                        break;

                    case DbDepartment.LEVEL_DEPARTMENT:
                        gldetail.setDepartmentId(departmentId);
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SECTION:
                        gldetail.setSectionId(departmentId);
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SUB_SECTION:
                        gldetail.setSubSectionId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_JOB:
                        gldetail.setJobId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSubSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    }
                } catch (Exception ex) {
                    System.out.println(ex.toString());
                }
            }

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(gldetail.getCoaId());
            } catch (Exception e) {
            }

            gldetail = DbGlDetail2015.setCoaLevel(gldetail);
            gldetail = DbGlDetail2015.setOrganizationLevel(gldetail);

            try {
                oid = DbGlDetail2015.insertExc(gldetail);
            } catch (Exception e) {
                System.out.println(e.toString());
            }

            //process budget
            if (oid != 0 && gldetail.getModuleId() != 0) {
                double amount = 0;

                if (gldetail.getDebet() > 0) {

                    //kalau saldo normal debet, maka(+)
                    amount = gldetail.getDebet();

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
                    amount = gldetail.getCredit() * -1;

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
                    DbModuleBudget.updateBudgetUsed(gldetail.getModuleId(), gldetail.getCoaId(), amount);
                }
            }
            
        }else if(tblName.equals(I_Project.GL_2016)){
            GlDetail2016 gldetail = new GlDetail2016();
            gldetail.setGlId(glId);
            gldetail.setCoaId(coaId);
            gldetail.setDebet(debet);
            gldetail.setCredit(credit);
            gldetail.setForeignCurrencyId(currId);
            gldetail.setForeignCurrencyAmount(fCurrAmount);
            gldetail.setMemo(memo);
            gldetail.setBookedRate(bookedRate);
            gldetail.setDepartmentId(departmentId);
            gldetail.setSegment1Id(segment1Id);
            gldetail.setSegment2Id(segment2Id);
            gldetail.setSegment3Id(segment3Id);
            gldetail.setSegment4Id(segment4Id);
            gldetail.setSegment5Id(segment5Id);
            gldetail.setSegment6Id(segment6Id);
            gldetail.setSegment7Id(segment7Id);
            gldetail.setSegment8Id(segment8Id);
            gldetail.setSegment9Id(segment9Id);
            gldetail.setSegment10Id(segment10Id);
            gldetail.setSegment11Id(segment11Id);
            gldetail.setSegment12Id(segment12Id);
            gldetail.setSegment13Id(segment13Id);
            gldetail.setSegment14Id(segment14Id);
            gldetail.setSegment15Id(segment15Id);
            gldetail.setModuleId(moduleId);

            if (departmentId != 0) {
                try {
                    Department d = DbDepartment.fetchExc(departmentId);
                    switch (d.getLevel()) {
                    case DbDepartment.LEVEL_DIREKTORAT:
                        gldetail.setDirectorateId(departmentId);
                        break;

                    case DbDepartment.LEVEL_DIVISION:
                        gldetail.setDivisionId(departmentId);
                        gldetail.setDirectorateId(d.getRefId());
                        break;

                    case DbDepartment.LEVEL_DEPARTMENT:
                        gldetail.setDepartmentId(departmentId);
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SECTION:
                        gldetail.setSectionId(departmentId);
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SUB_SECTION:
                        gldetail.setSubSectionId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_JOB:
                        gldetail.setJobId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSubSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    }
                } catch (Exception ex) {
                    System.out.println(ex.toString());
                }
            }

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(gldetail.getCoaId());
            } catch (Exception e) {
            }

            gldetail = DbGlDetail2016.setCoaLevel(gldetail);
            gldetail = DbGlDetail2016.setOrganizationLevel(gldetail);

            try {
                oid = DbGlDetail2016.insertExc(gldetail);
            } catch (Exception e) {
                System.out.println(e.toString());
            }

            //process budget
            if (oid != 0 && gldetail.getModuleId() != 0) {
                double amount = 0;

                if (gldetail.getDebet() > 0) {

                    //kalau saldo normal debet, maka(+)
                    amount = gldetail.getDebet();

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
                    amount = gldetail.getCredit() * -1;

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
                    DbModuleBudget.updateBudgetUsed(gldetail.getModuleId(), gldetail.getCoaId(), amount);
                }
            }
        }else{
            GlDetail gldetail = new GlDetail();
            gldetail.setGlId(glId);
            gldetail.setCoaId(coaId);
            gldetail.setDebet(debet);
            gldetail.setCredit(credit);
            gldetail.setForeignCurrencyId(currId);
            gldetail.setForeignCurrencyAmount(fCurrAmount);
            gldetail.setMemo(memo);
            gldetail.setBookedRate(bookedRate);
            gldetail.setDepartmentId(departmentId);
            gldetail.setSegment1Id(segment1Id);
            gldetail.setSegment2Id(segment2Id);
            gldetail.setSegment3Id(segment3Id);
            gldetail.setSegment4Id(segment4Id);
            gldetail.setSegment5Id(segment5Id);
            gldetail.setSegment6Id(segment6Id);
            gldetail.setSegment7Id(segment7Id);
            gldetail.setSegment8Id(segment8Id);
            gldetail.setSegment9Id(segment9Id);
            gldetail.setSegment10Id(segment10Id);
            gldetail.setSegment11Id(segment11Id);
            gldetail.setSegment12Id(segment12Id);
            gldetail.setSegment13Id(segment13Id);
            gldetail.setSegment14Id(segment14Id);
            gldetail.setSegment15Id(segment15Id);
            gldetail.setModuleId(moduleId);

            if (departmentId != 0) {
                try {
                    Department d = DbDepartment.fetchExc(departmentId);
                    switch (d.getLevel()) {
                    case DbDepartment.LEVEL_DIREKTORAT:
                        gldetail.setDirectorateId(departmentId);
                        break;

                    case DbDepartment.LEVEL_DIVISION:
                        gldetail.setDivisionId(departmentId);
                        gldetail.setDirectorateId(d.getRefId());
                        break;

                    case DbDepartment.LEVEL_DEPARTMENT:
                        gldetail.setDepartmentId(departmentId);
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SECTION:
                        gldetail.setSectionId(departmentId);
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_SUB_SECTION:
                        gldetail.setSubSectionId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    case DbDepartment.LEVEL_JOB:
                        gldetail.setJobId(departmentId);
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSubSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setSectionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDepartmentId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDivisionId(d.getRefId());
                        d = DbDepartment.fetchExc(d.getRefId());
                        gldetail.setDirectorateId(d.getRefId());
                        break;
                    }
                } catch (Exception ex) {
                    System.out.println(ex.toString());
                }
            }

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(gldetail.getCoaId());
            } catch (Exception e) {
            }

            gldetail = DbGlDetail.setCoaLevel(gldetail);
            gldetail = DbGlDetail.setOrganizationLevel(gldetail);

            try {
                oid = DbGlDetail.insertExc(gldetail);
            } catch (Exception e) {
                System.out.println(e.toString());
            }

            //process budget
            if (oid != 0 && gldetail.getModuleId() != 0) {
                double amount = 0;

                if (gldetail.getDebet() > 0) {

                    //kalau saldo normal debet, maka(+)
                    amount = gldetail.getDebet();

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
                    amount = gldetail.getCredit() * -1;

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
                    DbModuleBudget.updateBudgetUsed(gldetail.getModuleId(), gldetail.getCoaId(), amount);
                }
            }
        }

        return oid;
    }

    public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(journal_counter) from " + DB_GL + " where " +
                    " journal_prefix='" + getNumberPrefix() + "' ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }

            if (result == 0) {
                result = result + 1;
            } else {
                result = result + 1;
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    public static String getNumberPrefix() {
        Company sysCompany = DbCompany.getCompany();
        Location sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());
        String code = sysLocation.getCode();//DbSystemProperty.getValueByName("LOCATION_CODE");
        code = code + sysCompany.getGeneralLedgerCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");
        code = code + JSPFormater.formatDate(new Date(), "MMyy");
        return code;
    }

    public static String getNextNumber(int ctr) {
        String code = getNumberPrefix();

        if (ctr < 10) {
            code = code + "000" + ctr;
        } else if (ctr < 100) {
            code = code + "00" + ctr;
        } else if (ctr < 1000) {
            code = code + "0" + ctr;
        } else {
            code = code + ctr;
        }

        return code;
    }

    public static void postActivityStatus(long oidFlag, long oidGl) {
        try {
            Gl pp = DbGl.fetchExc(oidGl);
            if (oidFlag == 0) {
                pp.setActivityStatus(I_Project.STATUS_NOT_POSTED);
            } else {
                pp.setActivityStatus(I_Project.STATUS_POSTED);
            }

            DbGl.updateExc(pp);
        } catch (Exception e) {
        }
    }

    public static double getAmountByCoa(long coaId, Periode p, long glId) {
        double result = 0;
        CONResultSet crs = null;

        //run query
        try {
            String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                    " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getAmountByCoaCD(long coaId, Periode p, long glId) {
        double result = 0;
        CONResultSet crs = null;

        //run query
        try {
            String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                    " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    //digunakan saat proses singkronisasi data dilakukan
    public static void synchGLPeriodId() {

        CONResultSet crs = null;
        Gl gl = new Gl();
        try {
            String sql = " select * from " + DbGl.DB_GL + " g " +
                    " where g." + DbGl.colNames[DbGl.COL_PERIOD_ID] +
                    " not in (select p." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " from " + DbPeriode.DB_PERIODE + " p) limit 0,1";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                DbGl.resultToObject(rs, gl);
            }

            if (gl.getOID() != 0) {
                updateSynchGlPeriodId(gl);
                synchGLPeriodId();
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
    }

    public static void updateSynchGlPeriodId(Gl gl) {
        Date trDate = gl.getTransDate();
        String where = " to_days(" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + ")<=to_days('" + JSPFormater.formatDate(trDate, "yyyy-MM-dd") + "')" +
                " and to_days(" + DbPeriode.colNames[DbPeriode.COL_END_DATE] + ")>=to_days('" + JSPFormater.formatDate(trDate, "yyyy-MM-dd") + "')";

        Vector v = DbPeriode.list(0, 0, where, "");
        if (v != null && v.size() > 0) {
            Periode p = (Periode) v.get(0);
            String sql = "update " + DbGl.DB_GL + " set " + colNames[COL_PERIOD_ID] + "=" + p.getOID() + " where " + colNames[COL_PERIOD_ID] + "=" + gl.getPeriodId();
            try {
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
            }
        }
    }

    public static void optimizedJournal(long glOID) {
        String sql = " select sum(" + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")" +
                ", sum(" + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_AMOUNT] + ")" +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID] + // 6
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT8_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT9_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT10_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT11_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT12_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT13_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT14_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT15_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIRECTORATE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIVISION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_MODULE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL0_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_JOB_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_STATUS_TRANSACTION] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL1_ID] +
                " from " + DbGlDetail.DB_GL_DETAIL +
                " where " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID +
                " and " + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ">0" +
                " group by " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                " , " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID];
        
        CONResultSet crs = null;
        Vector temp = new Vector();
        
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();
                gd.setGlId(glOID);
                gd.setDebet(rs.getDouble(1));
                gd.setForeignCurrencyAmount(rs.getDouble(2));
                gd.setCoaId(rs.getLong(3));
                gd.setForeignCurrencyId(rs.getLong(4));
                gd.setBookedRate(rs.getDouble(5));
                gd.setCredit(0);

                gd.setSegment1Id(rs.getLong(6));
                gd.setSegment2Id(rs.getLong(7));
                gd.setSegment3Id(rs.getLong(8));
                gd.setSegment4Id(rs.getLong(9));
                gd.setSegment5Id(rs.getLong(10));
                gd.setSegment6Id(rs.getLong(11));
                gd.setSegment7Id(rs.getLong(12));
                gd.setSegment8Id(rs.getLong(13));
                gd.setSegment9Id(rs.getLong(14));
                gd.setSegment10Id(rs.getLong(15));
                gd.setSegment11Id(rs.getLong(16));
                gd.setSegment12Id(rs.getLong(17));
                gd.setSegment13Id(rs.getLong(18));
                gd.setSegment14Id(rs.getLong(19));
                gd.setSegment15Id(rs.getLong(20));

                gd.setCoaLevel1Id(rs.getLong(21));
                gd.setCoaLevel2Id(rs.getLong(22));
                gd.setCoaLevel3Id(rs.getLong(23));
                gd.setCoaLevel4Id(rs.getLong(24));
                gd.setCoaLevel5Id(rs.getLong(25));
                gd.setCoaLevel6Id(rs.getLong(26));
                gd.setCoaLevel7Id(rs.getLong(27));

                gd.setDirectorateId(rs.getLong(28));
                gd.setDivisionId(rs.getLong(29));
                gd.setDepLevel2Id(rs.getLong(30));
                gd.setDepLevel3Id(rs.getLong(31));
                gd.setDepLevel4Id(rs.getLong(32));
                gd.setDepLevel5Id(rs.getLong(33));
                gd.setModuleId(rs.getLong(34));
                gd.setDepLevel0Id(rs.getLong(35));

                gd.setDepartmentId(rs.getLong(36));
                gd.setSectionId(rs.getLong(37));
                gd.setSubSectionId(rs.getLong(38));
                gd.setJobId(rs.getLong(39));
                gd.setStatusTransaction(rs.getInt(40));
                gd.setDepLevel1Id(rs.getLong(41));

                temp.add(gd);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        Vector jDetailDebet = new Vector();

        if (temp != null && temp.size() > 0) {

            Vector jDebetDetails = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID + " and " + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ">0", "");
            if (jDebetDetails != null && jDebetDetails.size() > 0) {
                for (int x = 0; x < temp.size(); x++) {
                    GlDetail gdx = (GlDetail) temp.get(x);
                    String memo = "";
                    for (int i = 0; i < jDebetDetails.size(); i++) {
                        GlDetail gd = (GlDetail) jDebetDetails.get(i);
                        if (gd.getCoaId() == gdx.getCoaId() && gd.getForeignCurrencyId() == gdx.getForeignCurrencyId()) {
                            if (gd.getMemo() != null && gd.getMemo().length() > 0) {
                                memo = memo + gd.getMemo() + "(" + JSPFormater.formatNumber(gd.getDebet(), "#,###.#") + "), ";
                            }
                        }
                    }

                    if (memo.length() > 0) {
                        memo = memo.substring(0, memo.length() - 2);
                    }

                    gdx.setMemo(memo);

                    jDetailDebet.add(gdx);
                }
            }
        }

        //process credit ===========================

        sql = " select sum(" + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")" +
                ", sum(" + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_AMOUNT] + ")" +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID] +// 6
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT8_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT9_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT10_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT11_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT12_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT13_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT14_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT15_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIRECTORATE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DIVISION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL2_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL3_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL4_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL5_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_MODULE_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL0_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_JOB_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_STATUS_TRANSACTION] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_DEP_LEVEL1_ID] +
                " from " + DbGlDetail.DB_GL_DETAIL +
                " where " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID +
                " and " + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ">0" +
                " group by " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                " , " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID];

        CONResultSet crsx = null;
        temp = new Vector();
        try {
            crsx = CONHandler.execQueryResult(sql);
            ResultSet rs = crsx.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();
                gd.setGlId(glOID);
                gd.setCredit(rs.getDouble(1));
                gd.setForeignCurrencyAmount(rs.getDouble(2));
                gd.setCoaId(rs.getLong(3));
                gd.setForeignCurrencyId(rs.getLong(4));
                gd.setBookedRate(rs.getDouble(5));
                gd.setDebet(0);

                gd.setSegment1Id(rs.getLong(6));
                gd.setSegment2Id(rs.getLong(7));
                gd.setSegment3Id(rs.getLong(8));
                gd.setSegment4Id(rs.getLong(9));
                gd.setSegment5Id(rs.getLong(10));
                gd.setSegment6Id(rs.getLong(11));
                gd.setSegment7Id(rs.getLong(12));
                gd.setSegment8Id(rs.getLong(13));
                gd.setSegment9Id(rs.getLong(14));
                gd.setSegment10Id(rs.getLong(15));
                gd.setSegment11Id(rs.getLong(16));
                gd.setSegment12Id(rs.getLong(17));
                gd.setSegment13Id(rs.getLong(18));
                gd.setSegment14Id(rs.getLong(19));
                gd.setSegment15Id(rs.getLong(20));

                gd.setCoaLevel1Id(rs.getLong(21));
                gd.setCoaLevel2Id(rs.getLong(22));
                gd.setCoaLevel3Id(rs.getLong(23));
                gd.setCoaLevel4Id(rs.getLong(24));
                gd.setCoaLevel5Id(rs.getLong(25));
                gd.setCoaLevel6Id(rs.getLong(26));
                gd.setCoaLevel7Id(rs.getLong(27));

                gd.setDirectorateId(rs.getLong(28));
                gd.setDivisionId(rs.getLong(29));
                gd.setDepLevel2Id(rs.getLong(30));
                gd.setDepLevel3Id(rs.getLong(31));
                gd.setDepLevel4Id(rs.getLong(32));
                gd.setDepLevel5Id(rs.getLong(33));
                gd.setModuleId(rs.getLong(34));
                gd.setDepLevel0Id(rs.getLong(35));

                gd.setDepartmentId(rs.getLong(36));
                gd.setSectionId(rs.getLong(37));
                gd.setSubSectionId(rs.getLong(38));
                gd.setJobId(rs.getLong(39));
                gd.setStatusTransaction(rs.getInt(40));                
                gd.setDepLevel1Id(rs.getLong(41));

                temp.add(gd);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crsx);
        }

        Vector jDetailCredit = new Vector();

        if (temp != null && temp.size() > 0) {

            Vector jCreditDetails = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID + " and " + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ">0", "");
            if (jCreditDetails != null && jCreditDetails.size() > 0) {
                for (int x = 0; x < temp.size(); x++) {
                    GlDetail gdx = (GlDetail) temp.get(x);
                    String memo = "";
                    for (int i = 0; i < jCreditDetails.size(); i++) {
                        GlDetail gd = (GlDetail) jCreditDetails.get(i);
                        if (gd.getCoaId() == gdx.getCoaId() && gd.getForeignCurrencyId() == gdx.getForeignCurrencyId()) {
                            if (gd.getMemo() != null && gd.getMemo().length() > 0) {
                                memo = memo + gd.getMemo() + " (" + JSPFormater.formatNumber(gd.getCredit(), "#,###.#") + "), ";
                            }
                        }
                    }

                    if (memo.length() > 0) {
                        memo = memo.substring(0, memo.length() - 2);
                    }

                    gdx.setMemo(memo);

                    jDetailCredit.add(gdx);

                }
            }
        }


        //delete journal detail
        try {
            CONHandler.execUpdate("delete from " + DbGlDetail.DB_GL_DETAIL + " where " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID);
        } catch (Exception e) {
        }

        //insert yang baru
        for (int i = 0; i < jDetailDebet.size(); i++) {
            GlDetail gdx = (GlDetail) jDetailDebet.get(i);            
            try {
                DbGlDetail.insertExc(gdx);
            } catch (Exception e) {
            }
        }

        for (int i = 0; i < jDetailCredit.size(); i++) {
            GlDetail gdx = (GlDetail) jDetailCredit.get(i);
            try {
                DbGlDetail.insertExc(gdx);
            } catch (Exception e) {
            }
        }
    }

    public static void optimizeJournal(long glOID) {
        String sql = " select sum(" + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")" +
                ", sum(" + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_AMOUNT] + ")" +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE] +
                " from " + DbGlDetail.DB_GL_DETAIL +
                " where " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID +
                " and " + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ">0" +
                " group by " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                " , " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID];

        CONResultSet crs = null;
        Vector temp = new Vector();
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();
                gd.setGlId(glOID);
                gd.setDebet(rs.getDouble(1));
                gd.setForeignCurrencyAmount(rs.getDouble(2));
                gd.setCoaId(rs.getLong(3));
                gd.setForeignCurrencyId(rs.getLong(4));
                gd.setBookedRate(rs.getDouble(5));
                gd.setCredit(0);
                temp.add(gd);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        Vector jDetailDebet = new Vector();

        if (temp != null && temp.size() > 0) {

            Vector jDebetDetails = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID + " and " + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ">0", "");
            if (jDebetDetails != null && jDebetDetails.size() > 0) {
                for (int x = 0; x < temp.size(); x++) {
                    GlDetail gdx = (GlDetail) temp.get(x);
                    String memo = "";
                    for (int i = 0; i < jDebetDetails.size(); i++) {
                        GlDetail gd = (GlDetail) jDebetDetails.get(i);
                        if (gd.getCoaId() == gdx.getCoaId() && gd.getForeignCurrencyId() == gdx.getForeignCurrencyId()) {
                            if (gd.getMemo() != null && gd.getMemo().length() > 0) {
                                memo = memo + gd.getMemo() + "(" + JSPFormater.formatNumber(gd.getDebet(), "#,###.#") + "), ";
                            }
                        }
                    }

                    if (memo.length() > 0) {
                        memo = memo.substring(0, memo.length() - 2);
                    }

                    gdx.setMemo(memo);

                    jDetailDebet.add(gdx);

                }
            }
        }

        //process credit ===========================

        sql = " select sum(" + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")" +
                ", sum(" + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_AMOUNT] + ")" +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID] +
                ", " + DbGlDetail.colNames[DbGlDetail.COL_BOOKED_RATE] +
                " from " + DbGlDetail.DB_GL_DETAIL +
                " where " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID +
                " and " + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ">0" +
                " group by " + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] +
                " , " + DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_ID];

        CONResultSet crsx = null;
        temp = new Vector();
        try {
            crsx = CONHandler.execQueryResult(sql);
            ResultSet rs = crsx.getResultSet();
            while (rs.next()) {
                GlDetail gd = new GlDetail();
                gd.setGlId(glOID);
                gd.setCredit(rs.getDouble(1));
                gd.setForeignCurrencyAmount(rs.getDouble(2));
                gd.setCoaId(rs.getLong(3));
                gd.setForeignCurrencyId(rs.getLong(4));
                gd.setBookedRate(rs.getDouble(5));
                gd.setDebet(0);
                temp.add(gd);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crsx);
        }

        Vector jDetailCredit = new Vector();

        if (temp != null && temp.size() > 0) {

            Vector jCreditDetails = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID + " and " + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ">0", "");
            if (jCreditDetails != null && jCreditDetails.size() > 0) {
                for (int x = 0; x < temp.size(); x++) {
                    GlDetail gdx = (GlDetail) temp.get(x);
                    String memo = "";
                    for (int i = 0; i < jCreditDetails.size(); i++) {
                        GlDetail gd = (GlDetail) jCreditDetails.get(i);
                        if (gd.getCoaId() == gdx.getCoaId() && gd.getForeignCurrencyId() == gdx.getForeignCurrencyId()) {
                            if (gd.getMemo() != null && gd.getMemo().length() > 0) {
                                memo = memo + gd.getMemo() + " (" + JSPFormater.formatNumber(gd.getCredit(), "#,###.#") + "), ";
                            }
                        }
                    }

                    if (memo.length() > 0) {
                        memo = memo.substring(0, memo.length() - 2);
                    }

                    gdx.setMemo(memo);

                    jDetailCredit.add(gdx);

                }
            }
        }


        //delete journal detail
        try {
            CONHandler.execUpdate("delete from " + DbGlDetail.DB_GL_DETAIL + " where " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glOID);
        } catch (Exception e) {
        }

        //insert yang baru
        for (int i = 0; i < jDetailDebet.size(); i++) {
            GlDetail gdx = (GlDetail) jDetailDebet.get(i);
            try {
                DbGlDetail.insertExc(gdx);
            } catch (Exception e) {
            }
        }

        for (int i = 0; i < jDetailCredit.size(); i++) {
            GlDetail gdx = (GlDetail) jDetailCredit.get(i);
            try {
                DbGlDetail.insertExc(gdx);
            } catch (Exception e) {
            }
        }
    }

    /**
     * Proses reversal untuk jurnal yang sudah terposting. Di eksekusi oleh user.
     * 
     * @param oidGl
     * @param newGl
     * @return
     */
    public static long doReversePostedJournal(long oidGl, Gl newGl, int glType, long userId) {
        try {
            Gl objGl = DbGl.fetchExc(oidGl);
            Gl reverseGl = new Gl();
            Periode p = DbPeriode.getOpenPeriod();
            Date startDate = p.getStartDate();
            startDate.setMonth(startDate.getMonth() + 1);
            startDate.setDate(1);

            //duplicate Posted Journal
            reverseGl.setOID(0);
            reverseGl.setJournalNumber(newGl.getJournalNumber());
            reverseGl.setJournalPrefix(newGl.getJournalPrefix());
            reverseGl.setJournalCounter(newGl.getJournalCounter());
            reverseGl.setJournalType(newGl.getJournalType());
            reverseGl.setRefNumber(newGl.getRefNumber());
            reverseGl.setPeriodId(newGl.getPeriodId());
            reverseGl.setMemo(newGl.getMemo());
            reverseGl.setDate(newGl.getTransDate());
            reverseGl.setTransDate(newGl.getTransDate());
            reverseGl.setEffectiveDate(newGl.getTransDate());
            reverseGl.setOperatorId(userId);
            reverseGl.setCurrencyId(objGl.getCurrencyId());
            reverseGl.setIsReversal(glType);
            if (glType == DbGl.IS_REVERSAL) {
                reverseGl.setPostedStatus(POSTED);
            } else {
                reverseGl.setPostedStatus(NOT_POSTED);
            }
            reverseGl.setReversalStatus(POSTED);
            long oidGlReversal = insertExc(reverseGl);

            if (oidGlReversal != 0) {
                try {
                    // proses untuk object ke general penanpungan code
                    SystemDocNumber systemDocNumber = new SystemDocNumber();
                    systemDocNumber.setCounter(reverseGl.getJournalCounter());
                    systemDocNumber.setPrefixNumber(reverseGl.getJournalPrefix());
                    systemDocNumber.setDocNumber(reverseGl.getJournalNumber());
                    systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
                    systemDocNumber.setDate(new Date());
                    systemDocNumber.setYear(reverseGl.getTransDate().getYear() + 1900);
                    DbSystemDocNumber.insertExc(systemDocNumber);
                } catch (Exception e) {
                    System.out.println("[Exception]" + e.toString());
                }
            }

            //update Posted Journal
            objGl.setReversalStatus(POSTED);
            objGl.setReversalDate(new Date());
            oidGl = updateExc(objGl);

            //process Revers Posted Journal Detail
            Vector vGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + oidGl, "");

            for (int n = 0; n < vGlDetail.size(); n++) {
                GlDetail objGlDetail = (GlDetail) vGlDetail.get(n);
                GlDetail objGlDetailReversal = new GlDetail();

                double debet = objGlDetail.getDebet();
                double credit = objGlDetail.getCredit();

                objGlDetailReversal = objGlDetail;
                objGlDetailReversal.setOID(0);
                objGlDetailReversal.setGlId(oidGlReversal);
                objGlDetailReversal.setCredit(debet);
                objGlDetailReversal.setDebet(credit);

                DbGlDetail.insertExc(objGlDetailReversal);
            }
            return oidGlReversal;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }
        return 0;
    }
    
    
    public static long doReversePostedJournal(long oidGl, Gl newGl, long userId) {
        try {
            
            Gl objGl = DbGl.fetchExc(oidGl);
            Gl reverseGl = new Gl();

            //duplicate Posted Journal
            int x = 1;
            String number = newGl.getJournalNumber();
            int count = getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]+" = '"+number+"'");
            
            if(count > 0){
                while(count > 0){           
                    number = number+x;
                    count = getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]+" = '"+number+"'");
                    x++;
                }
            }
            
            reverseGl.setOID(0);
            reverseGl.setJournalNumber(number);
            reverseGl.setJournalPrefix(newGl.getJournalPrefix());
            reverseGl.setJournalCounter(newGl.getJournalCounter());
            reverseGl.setJournalType(newGl.getJournalType());
            reverseGl.setRefNumber(newGl.getRefNumber());
            reverseGl.setPeriodId(newGl.getPeriodId());
            reverseGl.setMemo(newGl.getMemo());
            reverseGl.setDate(newGl.getTransDate());
            reverseGl.setTransDate(newGl.getTransDate());
            reverseGl.setEffectiveDate(newGl.getTransDate());
            reverseGl.setOperatorId(userId);
            reverseGl.setCurrencyId(objGl.getCurrencyId());
            reverseGl.setIsReversal(0);
            reverseGl.setReferensiId(oidGl);
            reverseGl.setPostedStatus(POSTED);
            reverseGl.setPostedDate(new Date());
            reverseGl.setPostedById(userId);
            
            
            long oidGlReversal = insertExc(reverseGl);

            //process Revers Posted Journal Detail
            Vector vGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + oidGl, "");

            for (int n = 0; n < vGlDetail.size(); n++) {
                GlDetail objGlDetail = (GlDetail) vGlDetail.get(n);
                GlDetail objGlDetailReversal = new GlDetail();

                double debet = objGlDetail.getDebet();
                double credit = objGlDetail.getCredit();

                objGlDetailReversal = objGlDetail;
                objGlDetailReversal.setOID(0);
                objGlDetailReversal.setGlId(oidGlReversal);
                objGlDetailReversal.setCredit(debet);
                objGlDetailReversal.setDebet(credit);
                DbGlDetail.insertExc(objGlDetailReversal);
            }
            return oidGlReversal;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }
        return 0;
    }

    
    public static long doCopyPostedJournal(long oidGl, Gl newGl, long userId){
        try {
            
            Gl objGl = DbGl.fetchExc(oidGl);
            Gl copyGl = new Gl();

            //duplicate Posted Journal
            int x = 1;
            String number = newGl.getJournalNumber();
            int count = getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]+" = '"+number+"'");
            
            if(count > 0){
                while(count > 0){           
                    number = number+x;
                    count = getCount(DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]+" = '"+number+"'");
                    x++;
                }
            }
            
            copyGl.setOID(0);
            copyGl.setJournalNumber(number);
            copyGl.setJournalPrefix(newGl.getJournalPrefix());
            copyGl.setJournalCounter(newGl.getJournalCounter());
            copyGl.setJournalType(newGl.getJournalType());
            copyGl.setRefNumber(newGl.getRefNumber());
            copyGl.setPeriodId(newGl.getPeriodId());
            copyGl.setMemo(newGl.getMemo());
            copyGl.setDate(newGl.getTransDate());
            copyGl.setTransDate(newGl.getTransDate());
            copyGl.setEffectiveDate(newGl.getTransDate());
            copyGl.setOperatorId(userId);
            copyGl.setCurrencyId(objGl.getCurrencyId());
            copyGl.setIsReversal(0);
            copyGl.setReferensiId(oidGl);
            copyGl.setPostedStatus(POSTED);
            copyGl.setPostedDate(new Date());
            copyGl.setPostedById(userId);
            
            long oidGlReversal = insertExc(copyGl);
            
            Vector vGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + oidGl, "");

            for (int n = 0; n < vGlDetail.size(); n++) {
                GlDetail objGlDetail = (GlDetail) vGlDetail.get(n);
                GlDetail objGlDetailReversal = new GlDetail();

                objGlDetailReversal = objGlDetail;
                objGlDetailReversal.setOID(0);
                objGlDetailReversal.setGlId(oidGlReversal);
                objGlDetailReversal.setCredit(objGlDetail.getCredit());
                objGlDetailReversal.setDebet(objGlDetail.getDebet());
                DbGlDetail.insertExc(objGlDetailReversal);
            }
            return oidGlReversal;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        }
        return 0;
    }
    
    
    /**
     * Proses reversal saat closing periode.
     * 
     * @param oidGL
     */
    public static void doJournalReversal(long oidGL) {
        try {
            Gl objGl = DbGl.fetchExc(oidGL);
            Gl objGlReversal = new Gl();
            int counter = DbGl.getNextCounter();
            Periode p = DbPeriode.getOpenPeriod();
            Date startDate = p.getStartDate();
            startDate.setMonth(startDate.getMonth() + 1);
            startDate.setDate(1);

            //duplicate Journal Reversal
            objGlReversal.setOID(0);
            objGlReversal.setJournalCounter(counter);
            objGlReversal.setPeriodId(p.getOID());
            objGlReversal.setJournalPrefix(DbGl.getNumberPrefix());
            objGlReversal.setJournalNumber(getNextNumber(counter));
            objGlReversal.setRefNumber(objGl.getJournalNumber());
            objGlReversal.setOperatorId(objGl.getOperatorId());
            objGlReversal.setCurrencyId(objGl.getCurrencyId());
            objGlReversal.setDate(startDate);
            objGlReversal.setTransDate(startDate);
            objGlReversal.setEffectiveDate(startDate);
            objGlReversal.setIsReversal(IS_REVERSAL);
            objGlReversal.setReversalStatus(POSTED);
            objGlReversal.setPostedStatus(POSTED);
            long oidGlReversal = insertExc(objGlReversal);

            //update Journal Reversal
            objGl.setPostedStatus(POSTED);
            objGl.setReversalStatus(POSTED);
            objGl.setReversalDate(new Date());
            oidGL = updateExc(objGl);

            //process Journal Reversal Detail
            Vector vGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + oidGL, "");

            for (int n = 0; n < vGlDetail.size(); n++) {
                GlDetail objGlDetail = (GlDetail) vGlDetail.get(n);
                GlDetail objGlDetailReversal = new GlDetail();

                double debet = objGlDetail.getDebet();
                double credit = objGlDetail.getCredit();

                objGlDetailReversal = objGlDetail;
                objGlDetailReversal.setOID(0);
                objGlDetailReversal.setGlId(oidGlReversal);
                objGlDetailReversal.setCredit(debet);
                objGlDetailReversal.setDebet(credit);

                DbGlDetail.insertExc(objGlDetailReversal);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static long getGlId(long referensiId) {
        CONResultSet crs = null;

        try {

            String sql = "SELECT " + DbGl.colNames[DbGl.COL_GL_ID] + " FROM " + DbGl.DB_GL + " WHERE " +
                    DbGl.colNames[DbGl.COL_REFERENSI_ID] + "=" + referensiId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                long GlOid = rs.getLong(1);
                return GlOid;
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return 0;
    }

    //eka ds
    public static boolean copyPeriod13TransToOpenPeriod(Periode per13, Periode openPer) {
        Vector temp = list(0, 0, colNames[COL_PERIOD_ID] + "=" + per13.getOID(), "");
        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                Gl gl = (Gl) temp.get(i);
                gl.setPeriodId(openPer.getOID());
                gl.setDate(openPer.getStartDate());
                gl.setEffectiveDate(openPer.getStartDate());
                gl.setJournalNumber("13Corr" + gl.getJournalNumber());
                gl.setMemo("Correction from closing period 13(" + per13.getName() + ") : " + gl.getMemo());

                Vector details = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), "");

                try {
                    long oidGL = insertExc(gl);
                    if (oidGL != 0) {

                        if (details != null && details.size() > 0) {
                            for (int x = 0; x < details.size(); x++) {
                                GlDetail gd = (GlDetail) details.get(x);
                                gd.setGlId(oidGL);
                                DbGlDetail.insertExc(gd);
                            }
                        }
                    }

                } catch (Exception e) {

                }
            }
        }

        return true;
    }

    public static Vector getGLReguler(int isReversal, String jurNumber) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR + " AND " +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal+" AND " +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + I_Project.JOURNAL_TYPE_GENERAL_LEDGER;

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            sql = sql + " ORDER BY " + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));

                result.add(gl);
            }

            return result;

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    
    public static Vector getGLReguler(int limitStart, int recordToGet,int isReversal, String jurNumber) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR + " AND " +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal+" AND " +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + I_Project.JOURNAL_TYPE_GENERAL_LEDGER;

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            sql = sql + " ORDER BY " + DbGl.colNames[DbGl.COL_JOURNAL_PREFIX]+","+ DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];
            
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));

                result.add(gl);
            }

            return result;

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    public static int getCountGLReguler(int isReversal, String jurNumber) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT count(gl." + DbGl.colNames[DbGl.COL_GL_ID] + ") as tot FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR + " AND " +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal+" AND " +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + I_Project.JOURNAL_TYPE_GENERAL_LEDGER;

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                return rs.getInt("tot");
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }    


    public static Vector getGLReguler(int isReversal, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, int limitStart, int recordToGet, String order) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal;

            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {

                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }

                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
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
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    
    public static Vector getGLRegulerArchive(int journalType, int isReversal, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, int limitStart, int recordToGet, String order, String memo) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal
                    + " and gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + journalType;

            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = '" + periodId + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (memo != null && memo.length() > 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " like '%" + memo + "%'";
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
            Vector result = new Vector();

            while (rs.next()) {

                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));

                result.add(gl);
            }

            return result;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    
    
    public static Vector getGLRegulerIByType(int isReversal, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, int limitStart, int recordToGet, String order, String memo) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal + " and gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + I_Project.JOURNAL_TYPE_GENERAL_LEDGER;
                       
            
            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = '" + periodId + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (memo != null && memo.length() > 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " like '%" + memo + "%'";
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
            Vector result = new Vector();

            while (rs.next()) {

                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));

                result.add(gl);
            }

            return result;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    
    public static Vector getGLRegulerIByType(int isReversal,int journalType, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, int limitStart, int recordToGet, String order, String memo) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " as journal_type," +
                    "gl." + DbGl.colNames[DbGl.COL_OPERATOR_ID] + " as operator_id," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal;
                       
            if(journalType == -1){                
                sql = sql +" and gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " in (" + I_Project.JOURNAL_TYPE_GENERAL_LEDGER+","+I_Project.JOURNAL_TYPE_REVERSE+","+I_Project.JOURNAL_TYPE_COPY+")";
            }else{
                
                sql = sql +" and gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = "+journalType;
            }
            
            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = '" + periodId + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (memo != null && memo.length() > 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " like '%" + memo + "%'";
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
            Vector result = new Vector();

            while (rs.next()) {

                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setJournalType(rs.getInt("journal_type"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));
                gl.setOperatorId(rs.getLong("operator_id"));

                result.add(gl);
            }

            return result;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static Vector getGLRegulerI(int isReversal, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, int limitStart, int recordToGet, String order, String memo) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal;

            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = '" + periodId + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (memo != null && memo.length() > 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " like '%" + memo + "%'";
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
            Vector result = new Vector();

            while (rs.next()) {

                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));

                result.add(gl);
            }

            return result;

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static int getCountGLReguler(int isReversal, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT count(gl." + DbGl.colNames[DbGl.COL_GL_ID] + ") FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal;

            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {

                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }

                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int sum = 0;

            while (rs.next()) {
                sum = rs.getInt(1);
                return sum;
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static int getCountGLRegulerIByType(int isReversal, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, String memo) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT count(gl." + DbGl.colNames[DbGl.COL_GL_ID] + ") FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal + " and gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + I_Project.JOURNAL_TYPE_GENERAL_LEDGER;

            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = '" + periodId + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (memo != null && memo.length() > 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " like '%" + memo + "%'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int sum = 0;

            while (rs.next()) {
                sum = rs.getInt(1);
                return sum;
            }

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }
    
    
    public static int getCountGLRegulerIByType(int isReversal,int journalType, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, String memo) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT count(gl." + DbGl.colNames[DbGl.COL_GL_ID] + ") FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal;

            if(journalType == -1){
                
                sql = sql +" and gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " in (" + I_Project.JOURNAL_TYPE_GENERAL_LEDGER+","+I_Project.JOURNAL_TYPE_REVERSE+","+I_Project.JOURNAL_TYPE_COPY+")";
            }else{
                
                sql = sql +" and gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = "+journalType;
            }
            
            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = '" + periodId + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (memo != null && memo.length() > 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " like '%" + memo + "%'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int sum = 0;

            while (rs.next()) {
                sum = rs.getInt(1);
                return sum;
            }

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }
    
    
    
    public static int getCountGLRegulerArchives(int journalType,int isReversal, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, String memo) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT count(gl." + DbGl.colNames[DbGl.COL_GL_ID] + ") FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal + 
                    " and gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + journalType;

            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = '" + periodId + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (memo != null && memo.length() > 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " like '%" + memo + "%'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int sum = 0;

            while (rs.next()) {
                sum = rs.getInt(1);
                return sum;
            }

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }
    

    public static int getCountGLRegulerI(int isReversal, String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, String memo) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT count(gl." + DbGl.colNames[DbGl.COL_GL_ID] + ") FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal;

            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = '" + periodId + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (memo != null && memo.length() > 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " like '%" + memo + "%'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int sum = 0;

            while (rs.next()) {
                sum = rs.getInt(1);
                return sum;
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static Vector getGLPosted(int isReversal) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transdate," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR + " AND " +
                    
                    " gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal + " AND " +
                    " ( gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.NOT_POSTED + " OR gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " IS NULL )";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setTransDate(rs.getDate("transdate"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    public static Vector getGLUmumPosted(int isReversal) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transdate," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR + " AND " +
                    " gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE]+" = "+I_Project.JOURNAL_TYPE_GENERAL_LEDGER+ " and "+ 
                    " gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal + " AND " +
                    " ( gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.NOT_POSTED + " OR gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " IS NULL )";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setTransDate(rs.getDate("transdate"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    public static Vector getGLPostedKasbon() {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transdate," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR + " AND " +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " = " + I_Project.JOURNAL_TYPE_PEMAKAIAN_KASBON + " AND " +
                    " ( gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.NOT_POSTED + " OR gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " IS NULL )";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setTransDate(rs.getDate("transdate"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static Vector glReverse(int IgnoreTransactionDate, Date TransactionDate, String JournalNumber,
            int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber, int glType,
            long periodId, String memo, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate" +
                    " FROM " + DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR +
                    " AND " + "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + glType +
                    " AND " + "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED +
                    " AND gl." + DbGl.colNames[DbGl.COL_REVERSAL_STATUS] + " = " + DbGl.NOT_POSTED;

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " LIKE '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " BETWEEN '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' AND '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " LIKE '%" + srcRefNumber + "%'";
            }

            if (periodId != 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId;
            }

            if (!memo.equals("")) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " LIKE '%" + memo + "%'";
            }

            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    public static Vector glReverse(int IgnoreTransactionDate, Date TransactionDate, String JournalNumber,
            int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber,
            long periodId, String memo, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate" +
                    " FROM " + DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR +                    
                    " AND " + "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED +  
                    " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " != " + I_Project.JOURNAL_TYPE_REVERSE+ 
                    " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " != " + I_Project.JOURNAL_TYPE_COPY;

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " LIKE '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " BETWEEN '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' AND '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " LIKE '%" + srcRefNumber + "%'";
            }

            if (periodId != 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId;
            }

            if (!memo.equals("")) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " LIKE '%" + memo + "%'";
            }

            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }
    
    public static Vector glCopy(int IgnoreTransactionDate, Date TransactionDate, String JournalNumber,
            int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber,
            long periodId, String memo, int limitStart, int recordToGet) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate" +
                    " FROM " + DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR +                    
                    " AND " + "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED +
                    " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " != " + I_Project.JOURNAL_TYPE_REVERSE+                    
                    " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " != " + I_Project.JOURNAL_TYPE_COPY;                    

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " LIKE '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " BETWEEN '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' AND '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " LIKE '%" + srcRefNumber + "%'";
            }

            if (periodId != 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId;
            }

            if (!memo.equals("")) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " LIKE '%" + memo + "%'";
            }

            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {

                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static int CountGlReverse(int IgnoreTransactionDate, Date TransactionDate,
            String JournalNumber, int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber, int glType,
            long periodId, String memo) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT COUNT(gl." + DbGl.colNames[DbGl.COL_GL_ID] + " )" +
                    " FROM " + DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR +
                    " AND " + "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + glType +
                    " AND gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED +
                    " AND gl." + DbGl.colNames[DbGl.COL_REVERSAL_STATUS] + " = " + DbGl.NOT_POSTED;

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (periodId != 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId;
            }

            if (!memo.equals("")) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " LIKE '%" + memo + "%'";
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;

            while (rs.next()) {
                count = rs.getInt(1);
            }

            return count;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }
    
    
    public static int countGlReverse(int IgnoreTransactionDate, Date TransactionDate,
            String JournalNumber, int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber,
            long periodId, String memo) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT COUNT(gl." + DbGl.colNames[DbGl.COL_GL_ID] + " )" +
                    " FROM " + DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR +                    
                    " AND gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED +
                    " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " != " + I_Project.JOURNAL_TYPE_REVERSE+
                    " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " != " + I_Project.JOURNAL_TYPE_COPY
                    ;

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (periodId != 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId;
            }

            if (!memo.equals("")) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " LIKE '%" + memo + "%'";
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;

            while (rs.next()) {
                count = rs.getInt(1);
            }

            return count;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }
    
    public static int countGlCopy(int IgnoreTransactionDate, Date TransactionDate,
            String JournalNumber, int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber,
            long periodId, String memo) {
        CONResultSet dbrs = null;

        try {

            String sql = "SELECT COUNT(gl." + DbGl.colNames[DbGl.COL_GL_ID] + " )" +
                    " FROM " + DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR +                    
                    " AND gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED +
                    " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " != " + I_Project.JOURNAL_TYPE_REVERSE+                    
                    " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_TYPE] + " != " + I_Project.JOURNAL_TYPE_COPY;

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            if (periodId != 0) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId;
            }

            if (!memo.equals("")) {
                sql += " AND gl." + DbGl.colNames[DbGl.COL_MEMO] + " LIKE '%" + memo + "%'";
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int count = 0;

            while (rs.next()) {
                count = rs.getInt(1);
            }

            return count;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static Vector glReverseArchive(long periodeId, int IgnoreTransactionDate, Date TransactionDate, String JournalNumber,
            int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId," +
                    "gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " as transDate" +
                    " FROM " + DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR +
                    " AND " + "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + DbGl.IS_REVERSAL;

            if (periodeId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodeId);
                } catch (Exception e) {
                }

                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " BETWEEN '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));
                gl.setTransDate(rs.getDate("transDate"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static int CountGlReverseArchive(long periodeId, int IgnoreTransactionDate, Date TransactionDate, String JournalNumber,
            int IgnoreInputDate, Date StartDate, Date EndDate, String srcRefNumber) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT COUNT(gl." + DbGl.colNames[DbGl.COL_GL_ID] + ") FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD_REGULAR + " AND " +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + DbGl.IS_REVERSAL;

            if (periodeId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodeId);
                } catch (Exception e) {
                }

                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " BETWEEN '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }

            if (IgnoreTransactionDate == 0 && TransactionDate != null) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(TransactionDate, "yyyy-MM-dd") + "'";
            }

            if (!JournalNumber.equals("")) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + JournalNumber + "%'";
            }

            if (IgnoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(StartDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(EndDate, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int result = 0;

            while (rs.next()) {
                result = rs.getInt(1);
                return result;
            }
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static Vector getGL13(String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, int limitStart, int recordToGet, String order) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD13;

            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }

                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
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
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static int getCountGL13(String jurNumber, int ignoreTransactionDate, Date transDate, long periodId, int ignoreInputDate, Date strtDt, Date endDt, String srcRefNumber, int limitStart, int recordToGet, String order) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT count(gl." + DbGl.colNames[DbGl.COL_GL_ID] + ") FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD13;

            if (ignoreTransactionDate == 0 && transDate != null) {//trans_date
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "'";
            }

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND " + "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            if (periodId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }

                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
            }

            if (ignoreInputDate == 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(strtDt, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDt, "yyyy-MM-dd") + "'";
            }

            if (srcRefNumber != null && srcRefNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_REF_NUMBER] + " like '%" + srcRefNumber + "%'";
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
            int sum = 0;

            while (rs.next()) {
                sum = rs.getInt(1);
                return sum;
            }
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static GlDetail sumGlDetail(long glId) {
        CONResultSet dbrs = null;
        GlDetail glDetail = new GlDetail();

        try {
            String sql = "";
            sql = "SELECT SUM(" + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + "),SUM(" + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ") FROM " + DbGlDetail.DB_GL_DETAIL +
                    " WHERE " + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + glId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                try {
                    glDetail.setDebet(rs.getDouble(1));
                } catch (Exception e) {
                }

                try {
                    glDetail.setCredit(rs.getDouble(2));
                } catch (Exception e) {
                }

                return glDetail;
            }
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return glDetail;
    }

    public static Vector getGL13Posted() {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD13 + " AND " +
                    " ( gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.NOT_POSTED + " OR gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " IS NULL )";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));

                result.add(gl);
            }

            return result;
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static Vector getGL13(int isReversal, String jurNumber) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT gl." + DbGl.colNames[DbGl.COL_GL_ID] + " as glId ," +
                    "gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " as postedStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_ACTIVITY_STATUS] + " as actStatus," +
                    "gl." + DbGl.colNames[DbGl.COL_CURRENCY_ID] + " as currId," +
                    "gl." + DbGl.colNames[DbGl.COL_DATE] + " as date," +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " as isReversal," +
                    "gl." + DbGl.colNames[DbGl.COL_MEMO] + " as memo," +
                    "gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " as jurNum," +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " as perodId FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD13 + " AND " +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal;

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            sql = sql + " ORDER BY " + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();

            while (rs.next()) {
                Gl gl = new Gl();
                gl.setOID(rs.getLong("glId"));
                gl.setPostedStatus(rs.getInt("postedStatus"));
                gl.setActivityStatus(rs.getString("actStatus"));
                gl.setCurrencyId(rs.getLong("currId"));
                gl.setDate(rs.getDate("date"));
                gl.setIsReversal(rs.getInt("isReversal"));
                gl.setMemo(rs.getString("memo"));
                gl.setPeriodId(rs.getLong("perodId"));
                gl.setJournalNumber(rs.getString("jurNum"));

                result.add(gl);
            }

            return result;

        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static int getCountGL13(int isReversal, String jurNumber) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT SUM(gl." + DbGl.colNames[DbGl.COL_GL_ID] + ") FROM " +
                    DbGl.DB_GL + " gl INNER JOIN " + DbPeriode.DB_PERIODE + " period on " +
                    "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + "period." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE period." + DbPeriode.colNames[DbPeriode.COL_TYPE] + " = " + DbPeriode.TYPE_PERIOD13 + " AND " +
                    "gl." + DbGl.colNames[DbGl.COL_IS_REVERSAL] + " = " + isReversal;

            if (jurNumber != null && jurNumber.length() > 0) {
                sql = sql + " AND gl." + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " like '%" + jurNumber + "%'";
            }

            sql = sql + " ORDER BY " + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER];
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                int sum = rs.getInt(1);
                return sum;
            }
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }
    
    
    
    public static long getNextGl(int counter,long periodId) {
        CONResultSet dbrs = null;

        try {
            String sql = "select " + DbGl.colNames[DbGl.COL_GL_ID] + " FROM " +
                    DbGl.DB_GL + 
                    " where " + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + periodId+" and "+
                    DbGl.colNames[DbGl.COL_JOURNAL_TYPE]+" = "+I_Project.JOURNAL_TYPE_GENERAL_LEDGER+
                    " and "+DbGl.colNames[DbGl.COL_JOURNAL_COUNTER]+" > "+counter+" order by "+DbGl.colNames[DbGl.COL_JOURNAL_COUNTER]+" asc limit 0,1";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                long glId = rs.getLong(DbGl.colNames[DbGl.COL_GL_ID]);
                return glId;
            }
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }
    
     public static long getPrevGl(int counter,long periodId) {
        CONResultSet dbrs = null;

        try {
            String sql = "select " + DbGl.colNames[DbGl.COL_GL_ID] + " FROM " +
                    DbGl.DB_GL + 
                    " where " + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = " + periodId+" and "+
                    DbGl.colNames[DbGl.COL_JOURNAL_TYPE]+" = "+I_Project.JOURNAL_TYPE_GENERAL_LEDGER+
                    " and "+DbGl.colNames[DbGl.COL_JOURNAL_COUNTER]+" < "+counter+" order by "+DbGl.colNames[DbGl.COL_JOURNAL_COUNTER]+" desc limit 0,1";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                long glId = rs.getLong(DbGl.colNames[DbGl.COL_GL_ID]);
                return glId;
            }
        } catch (Exception e) {
            System.out.println("[Exception]" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }

    /**
     * 
     * @param idCashAdvance
     * @return
     */
    public static Gl getCashAdvanceGL(long idCashAdvance) {
        Gl glCashAdvance = new Gl();
        Vector list = list(0, 0, DbGl.colNames[DbGl.COL_REFERENSI_ID] + "=" + idCashAdvance, "");
        if (list != null && list.size() > 0) {
            glCashAdvance = (Gl) list.get(0);
        }
        return glCashAdvance;
    }
}
