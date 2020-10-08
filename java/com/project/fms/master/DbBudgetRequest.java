/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.master;

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
import com.project.util.*;
import com.project.*;

/**
 *
 * @author Roy
 */
public class DbBudgetRequest extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BUDGET_REQUEST = "budget_request";
    
    public static final int COL_BUDGET_REQUEST_ID = 0;    
    public static final int COL_JOURNAL_NUMBER = 1;
    public static final int COL_JOURNAL_PREFIX = 2;
    public static final int COL_JOURNAL_COUNTER = 3;
    public static final int COL_DATE = 4;
    public static final int COL_TRANS_DATE = 5;
    public static final int COL_PERIODE_ID = 6;
    public static final int COL_MEMO = 7;    
    public static final int COL_USER_ID = 8;
    
    public static final int COL_APPROVAL1_ID = 9;
    public static final int COL_APPROVAL1_DATE = 10;    
    public static final int COL_APPROVAL2_ID = 11;
    public static final int COL_APPROVAL2_DATE = 12;
    public static final int COL_APPROVAL3_ID = 13;
    public static final int COL_APPROVAL3_DATE = 14;
    
    public static final int COL_POSTED_STATUS = 15;
    public static final int COL_POSTED_BY_ID = 16;
    public static final int COL_POSTED_DATE = 17;
    public static final int COL_DEPARTMENT_ID = 18;
    public static final int COL_COA_ID = 19;
    public static final int COL_SEGMENT1_ID = 20;
    public static final int COL_SEGMENT2_ID = 21;
    public static final int COL_SEGMENT3_ID = 22;
    public static final int COL_SEGMENT4_ID = 23;
    public static final int COL_SEGMENT5_ID = 24;
    public static final int COL_SEGMENT6_ID = 25;
    public static final int COL_SEGMENT7_ID = 26;
    public static final int COL_SEGMENT8_ID = 27;
    public static final int COL_SEGMENT9_ID = 28;
    public static final int COL_SEGMENT10_ID = 29;
    public static final int COL_SEGMENT11_ID = 30;
    public static final int COL_SEGMENT12_ID = 31;
    public static final int COL_SEGMENT13_ID = 32;
    public static final int COL_SEGMENT14_ID = 33;
    public static final int COL_SEGMENT15_ID = 34;
    public static final int COL_UNIQ_KEY_ID = 35;
    public static final int COL_STATUS = 36;    
    public static final int COL_REF_ID = 37;
    public static final int COL_PAYMENT_TYPE = 38;
    
    public static final String[] colNames = {
        "budget_request_id",
        "journal_number",
        "journal_prefix",
        "journal_counter",
        "date",
        "trans_date",
        "periode_id",
        "memo",//7        
        "user_id",
        
        "approval1_id",
        "approval1_date",        
        "approval2_id",
        "approval2_date",        
        "approval3_id",
        "approval3_date",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "department_id",
        "coa_id",//19        
        
        "segment1_id",
        "segment2_id",
        "segment3_id",
        "segment4_id",
        "segment5_id",
        "segment6_id",
        "segment7_id",
        "segment8_id",
        "segment9_id",
        "segment10_id",
        "segment11_id",
        "segment12_id",
        "segment13_id",
        "segment14_id",
        "segment15_id", //34
        "uniq_key_id",
        "status",
        "ref_id",
        "payment_type"
    };
    
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,        
        
        //segment
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT
    };    
    
    public static int DOC_STATUS_DRAFT = 0;    
    public static int DOC_STATUS_APPROVED = 1;    
    public static int DOC_STATUS_CHECKED = 2;   
    public static int DOC_STATUS_CANCEL = 3;   
    public static int DOC_STATUS_POSTED = 4;   
    
    public static String[] strStatusDocument = {"Draft", "Approved", "Checked", "Cancel","Posted"};
    
    public static int PAYMENT_TYPE_NO_PAYMENT = 0;    
    public static int PAYMENT_TYPE_CASH       = 1;    
    public static int PAYMENT_TYPE_BANK       = 2;    
    public static int PAYMENT_TYPE_RECEIVABLE = 3; 
    

    public DbBudgetRequest() {
    }

    public DbBudgetRequest(int i) throws CONException {
        super(new DbBudgetRequest());
    }

    public DbBudgetRequest(String sOid) throws CONException {
        super(new DbBudgetRequest(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBudgetRequest(long lOid) throws CONException {
        super(new DbBudgetRequest(0));
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
        return DB_BUDGET_REQUEST;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBudgetRequest().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BudgetRequest budgetRequest = fetchExc(ent.getOID());
        ent = (Entity) budgetRequest;
        return budgetRequest.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BudgetRequest) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BudgetRequest) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BudgetRequest fetchExc(long oid) throws CONException {
        try {
            BudgetRequest budgetRequest = new BudgetRequest();
            DbBudgetRequest pstBudgetRequest = new DbBudgetRequest(oid);
            budgetRequest.setOID(oid);
            budgetRequest.setJournalNumber(pstBudgetRequest.getString(COL_JOURNAL_NUMBER));
            budgetRequest.setJournalPrefix(pstBudgetRequest.getString(COL_JOURNAL_PREFIX));
            budgetRequest.setJournalCounter(pstBudgetRequest.getInt(COL_JOURNAL_COUNTER));
            budgetRequest.setDate(pstBudgetRequest.getDate(COL_DATE));
            budgetRequest.setTransDate(pstBudgetRequest.getDate(COL_TRANS_DATE));
            budgetRequest.setPeriodeId(pstBudgetRequest.getlong(COL_PERIODE_ID));
            budgetRequest.setMemo(pstBudgetRequest.getString(COL_MEMO));
            budgetRequest.setUserId(pstBudgetRequest.getlong(COL_USER_ID));
            
            budgetRequest.setApproval1Id(pstBudgetRequest.getlong(COL_APPROVAL1_ID));
            budgetRequest.setApproval1Date(pstBudgetRequest.getDate(COL_APPROVAL1_DATE));
            budgetRequest.setApproval2Id(pstBudgetRequest.getlong(COL_APPROVAL2_ID));
            budgetRequest.setApproval2Date(pstBudgetRequest.getDate(COL_APPROVAL2_DATE));
            budgetRequest.setApproval3Id(pstBudgetRequest.getlong(COL_APPROVAL3_ID));
            budgetRequest.setApproval3Date(pstBudgetRequest.getDate(COL_APPROVAL3_DATE));
            budgetRequest.setPostedStatus(pstBudgetRequest.getInt(COL_POSTED_STATUS));
            budgetRequest.setPostedById(pstBudgetRequest.getlong(COL_POSTED_BY_ID));
            budgetRequest.setPostedDate(pstBudgetRequest.getDate(COL_POSTED_DATE));            
            budgetRequest.setDepartmentId(pstBudgetRequest.getlong(COL_DEPARTMENT_ID));
            budgetRequest.setCoaId(pstBudgetRequest.getlong(COL_COA_ID));            
            
            budgetRequest.setSegment1Id(pstBudgetRequest.getlong(COL_SEGMENT1_ID));
            budgetRequest.setSegment2Id(pstBudgetRequest.getlong(COL_SEGMENT2_ID));
            budgetRequest.setSegment3Id(pstBudgetRequest.getlong(COL_SEGMENT3_ID));
            budgetRequest.setSegment4Id(pstBudgetRequest.getlong(COL_SEGMENT4_ID));
            budgetRequest.setSegment5Id(pstBudgetRequest.getlong(COL_SEGMENT5_ID));
            budgetRequest.setSegment6Id(pstBudgetRequest.getlong(COL_SEGMENT6_ID));
            budgetRequest.setSegment7Id(pstBudgetRequest.getlong(COL_SEGMENT7_ID));
            budgetRequest.setSegment8Id(pstBudgetRequest.getlong(COL_SEGMENT8_ID));
            budgetRequest.setSegment9Id(pstBudgetRequest.getlong(COL_SEGMENT9_ID));
            budgetRequest.setSegment10Id(pstBudgetRequest.getlong(COL_SEGMENT10_ID));
            budgetRequest.setSegment11Id(pstBudgetRequest.getlong(COL_SEGMENT11_ID));
            budgetRequest.setSegment12Id(pstBudgetRequest.getlong(COL_SEGMENT12_ID));
            budgetRequest.setSegment13Id(pstBudgetRequest.getlong(COL_SEGMENT13_ID));
            budgetRequest.setSegment14Id(pstBudgetRequest.getlong(COL_SEGMENT14_ID));
            budgetRequest.setSegment15Id(pstBudgetRequest.getlong(COL_SEGMENT15_ID));
            budgetRequest.setUniqKeyId(pstBudgetRequest.getlong(COL_UNIQ_KEY_ID));
            budgetRequest.setStatus(pstBudgetRequest.getInt(COL_STATUS));            
            budgetRequest.setRefId(pstBudgetRequest.getlong(COL_REF_ID));
            budgetRequest.setPaymentType(pstBudgetRequest.getInt(COL_PAYMENT_TYPE));

            return budgetRequest;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBudgetRequest(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BudgetRequest budgetRequest) throws CONException {
        try {
            DbBudgetRequest pstBudgetRequest = new DbBudgetRequest(0);
        
            pstBudgetRequest.setString(COL_JOURNAL_NUMBER, budgetRequest.getJournalNumber());
            pstBudgetRequest.setString(COL_JOURNAL_PREFIX, budgetRequest.getJournalPrefix());
            pstBudgetRequest.setInt(COL_JOURNAL_COUNTER, budgetRequest.getJournalCounter());
            pstBudgetRequest.setDate(COL_DATE, budgetRequest.getDate());
            pstBudgetRequest.setDate(COL_TRANS_DATE, budgetRequest.getTransDate());
            pstBudgetRequest.setLong(COL_PERIODE_ID, budgetRequest.getPeriodeId());            
            pstBudgetRequest.setString(COL_MEMO, budgetRequest.getMemo());            
            pstBudgetRequest.setLong(COL_USER_ID, budgetRequest.getUserId());
            
            pstBudgetRequest.setLong(COL_APPROVAL1_ID, budgetRequest.getApproval1Id());        
            pstBudgetRequest.setDate(COL_APPROVAL1_DATE, budgetRequest.getApproval1Date());        
            pstBudgetRequest.setLong(COL_APPROVAL2_ID, budgetRequest.getApproval2Id());        
            pstBudgetRequest.setDate(COL_APPROVAL2_DATE, budgetRequest.getApproval2Date());        
            pstBudgetRequest.setLong(COL_APPROVAL3_ID, budgetRequest.getApproval3Id());        
            pstBudgetRequest.setDate(COL_APPROVAL3_DATE, budgetRequest.getApproval3Date());        
            pstBudgetRequest.setInt(COL_POSTED_STATUS, budgetRequest.getPostedStatus());
            pstBudgetRequest.setLong(COL_POSTED_BY_ID, budgetRequest.getPostedById());
            pstBudgetRequest.setDate(COL_POSTED_DATE, budgetRequest.getPostedDate());
            pstBudgetRequest.setLong(COL_DEPARTMENT_ID, budgetRequest.getDepartmentId());
            pstBudgetRequest.setLong(COL_COA_ID, budgetRequest.getCoaId());

            pstBudgetRequest.setLong(COL_SEGMENT1_ID, budgetRequest.getSegment1Id());
            pstBudgetRequest.setLong(COL_SEGMENT2_ID, budgetRequest.getSegment2Id());
            pstBudgetRequest.setLong(COL_SEGMENT3_ID, budgetRequest.getSegment3Id());
            pstBudgetRequest.setLong(COL_SEGMENT4_ID, budgetRequest.getSegment4Id());
            pstBudgetRequest.setLong(COL_SEGMENT5_ID, budgetRequest.getSegment5Id());
            pstBudgetRequest.setLong(COL_SEGMENT6_ID, budgetRequest.getSegment6Id());
            pstBudgetRequest.setLong(COL_SEGMENT7_ID, budgetRequest.getSegment7Id());
            pstBudgetRequest.setLong(COL_SEGMENT8_ID, budgetRequest.getSegment8Id());
            pstBudgetRequest.setLong(COL_SEGMENT9_ID, budgetRequest.getSegment9Id());
            pstBudgetRequest.setLong(COL_SEGMENT10_ID, budgetRequest.getSegment10Id());
            pstBudgetRequest.setLong(COL_SEGMENT11_ID, budgetRequest.getSegment11Id());
            pstBudgetRequest.setLong(COL_SEGMENT12_ID, budgetRequest.getSegment12Id());
            pstBudgetRequest.setLong(COL_SEGMENT13_ID, budgetRequest.getSegment13Id());
            pstBudgetRequest.setLong(COL_SEGMENT14_ID, budgetRequest.getSegment14Id());
            pstBudgetRequest.setLong(COL_SEGMENT15_ID, budgetRequest.getSegment15Id());
            pstBudgetRequest.setLong(COL_UNIQ_KEY_ID, budgetRequest.getUniqKeyId());
            pstBudgetRequest.setInt(COL_STATUS, budgetRequest.getStatus());            
            pstBudgetRequest.setLong(COL_REF_ID, budgetRequest.getRefId());
            pstBudgetRequest.setInt(COL_PAYMENT_TYPE, budgetRequest.getPaymentType());
            pstBudgetRequest.insert();
            budgetRequest.setOID(pstBudgetRequest.getlong(COL_BUDGET_REQUEST_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBudgetRequest(0), CONException.UNKNOWN);
        }
        return budgetRequest.getOID();
    }

    public static long updateExc(BudgetRequest budgetRequest) throws CONException {
        try {
            if (budgetRequest.getOID() != 0) {
                DbBudgetRequest pstBudgetRequest = new DbBudgetRequest(budgetRequest.getOID());

                pstBudgetRequest.setString(COL_JOURNAL_NUMBER, budgetRequest.getJournalNumber());
                pstBudgetRequest.setString(COL_JOURNAL_PREFIX, budgetRequest.getJournalPrefix());
                pstBudgetRequest.setInt(COL_JOURNAL_COUNTER, budgetRequest.getJournalCounter());
                pstBudgetRequest.setDate(COL_DATE, budgetRequest.getDate());
                pstBudgetRequest.setDate(COL_TRANS_DATE, budgetRequest.getTransDate());
                pstBudgetRequest.setLong(COL_PERIODE_ID, budgetRequest.getPeriodeId());            
                pstBudgetRequest.setString(COL_MEMO, budgetRequest.getMemo());            
                pstBudgetRequest.setLong(COL_USER_ID, budgetRequest.getUserId());
            
                pstBudgetRequest.setLong(COL_APPROVAL1_ID, budgetRequest.getApproval1Id());        
                pstBudgetRequest.setDate(COL_APPROVAL1_DATE, budgetRequest.getApproval1Date());        
                pstBudgetRequest.setLong(COL_APPROVAL2_ID, budgetRequest.getApproval2Id());        
                pstBudgetRequest.setDate(COL_APPROVAL2_DATE, budgetRequest.getApproval2Date());        
                pstBudgetRequest.setLong(COL_APPROVAL3_ID, budgetRequest.getApproval3Id());        
                pstBudgetRequest.setDate(COL_APPROVAL3_DATE, budgetRequest.getApproval3Date());        
                pstBudgetRequest.setInt(COL_POSTED_STATUS, budgetRequest.getPostedStatus());
                pstBudgetRequest.setLong(COL_POSTED_BY_ID, budgetRequest.getPostedById());
                pstBudgetRequest.setDate(COL_POSTED_DATE, budgetRequest.getPostedDate());
                pstBudgetRequest.setLong(COL_DEPARTMENT_ID, budgetRequest.getDepartmentId());
                pstBudgetRequest.setLong(COL_COA_ID, budgetRequest.getCoaId());

                pstBudgetRequest.setLong(COL_SEGMENT1_ID, budgetRequest.getSegment1Id());
                pstBudgetRequest.setLong(COL_SEGMENT2_ID, budgetRequest.getSegment2Id());
                pstBudgetRequest.setLong(COL_SEGMENT3_ID, budgetRequest.getSegment3Id());
                pstBudgetRequest.setLong(COL_SEGMENT4_ID, budgetRequest.getSegment4Id());
                pstBudgetRequest.setLong(COL_SEGMENT5_ID, budgetRequest.getSegment5Id());
                pstBudgetRequest.setLong(COL_SEGMENT6_ID, budgetRequest.getSegment6Id());
                pstBudgetRequest.setLong(COL_SEGMENT7_ID, budgetRequest.getSegment7Id());
                pstBudgetRequest.setLong(COL_SEGMENT8_ID, budgetRequest.getSegment8Id());
                pstBudgetRequest.setLong(COL_SEGMENT9_ID, budgetRequest.getSegment9Id());
                pstBudgetRequest.setLong(COL_SEGMENT10_ID, budgetRequest.getSegment10Id());
                pstBudgetRequest.setLong(COL_SEGMENT11_ID, budgetRequest.getSegment11Id());
                pstBudgetRequest.setLong(COL_SEGMENT12_ID, budgetRequest.getSegment12Id());
                pstBudgetRequest.setLong(COL_SEGMENT13_ID, budgetRequest.getSegment13Id());
                pstBudgetRequest.setLong(COL_SEGMENT14_ID, budgetRequest.getSegment14Id());
                pstBudgetRequest.setLong(COL_SEGMENT15_ID, budgetRequest.getSegment15Id());
                pstBudgetRequest.setLong(COL_UNIQ_KEY_ID, budgetRequest.getUniqKeyId());
                pstBudgetRequest.setInt(COL_STATUS, budgetRequest.getStatus());
                pstBudgetRequest.setLong(COL_REF_ID, budgetRequest.getRefId());
                pstBudgetRequest.setInt(COL_PAYMENT_TYPE, budgetRequest.getPaymentType());
                pstBudgetRequest.update();
                return budgetRequest.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBudgetRequest(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBudgetRequest pstBudgetRequest = new DbBudgetRequest(oid);
            pstBudgetRequest.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBudgetRequest(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BUDGET_REQUEST;
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
                BudgetRequest budgetRequest = new BudgetRequest();
                resultToObject(rs, budgetRequest);
                lists.add(budgetRequest);
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

    private static void resultToObject(ResultSet rs, BudgetRequest budgetRequest) {
        try {
            budgetRequest.setOID(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_BUDGET_REQUEST_ID]));            
            budgetRequest.setJournalNumber(rs.getString(DbBudgetRequest.colNames[DbBudgetRequest.COL_JOURNAL_NUMBER]));
            budgetRequest.setJournalPrefix(rs.getString(DbBudgetRequest.colNames[DbBudgetRequest.COL_JOURNAL_PREFIX]));
            budgetRequest.setJournalCounter(rs.getInt(DbBudgetRequest.colNames[DbBudgetRequest.COL_JOURNAL_COUNTER]));            
            budgetRequest.setDate(rs.getDate(DbBudgetRequest.colNames[DbBudgetRequest.COL_DATE]));
            budgetRequest.setTransDate(rs.getDate(DbBudgetRequest.colNames[DbBudgetRequest.COL_TRANS_DATE]));
            budgetRequest.setPeriodeId(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_PERIODE_ID]));
            budgetRequest.setMemo(rs.getString(DbBudgetRequest.colNames[DbBudgetRequest.COL_MEMO]));
            budgetRequest.setUserId(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_USER_ID]));            
            
            budgetRequest.setApproval1Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_APPROVAL1_ID]));    
            budgetRequest.setApproval1Date(rs.getDate(DbBudgetRequest.colNames[DbBudgetRequest.COL_APPROVAL1_DATE]));    
            budgetRequest.setApproval2Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_APPROVAL2_ID]));    
            budgetRequest.setApproval2Date(rs.getDate(DbBudgetRequest.colNames[DbBudgetRequest.COL_APPROVAL2_DATE]));    
            budgetRequest.setApproval3Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_APPROVAL3_ID]));    
            budgetRequest.setApproval3Date(rs.getDate(DbBudgetRequest.colNames[DbBudgetRequest.COL_APPROVAL3_DATE]));    
            budgetRequest.setPostedStatus(rs.getInt(DbBudgetRequest.colNames[DbBudgetRequest.COL_POSTED_STATUS]));
            budgetRequest.setPostedById(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_POSTED_BY_ID]));
            budgetRequest.setPostedDate(rs.getDate(DbBudgetRequest.colNames[DbBudgetRequest.COL_POSTED_DATE]));            
            budgetRequest.setDepartmentId(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_DEPARTMENT_ID]));
            budgetRequest.setCoaId(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_COA_ID]));

            budgetRequest.setSegment1Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID]));
            budgetRequest.setSegment2Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT2_ID]));
            budgetRequest.setSegment3Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT3_ID]));
            budgetRequest.setSegment4Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT4_ID]));
            budgetRequest.setSegment5Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT5_ID]));
            budgetRequest.setSegment6Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT6_ID]));
            budgetRequest.setSegment7Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT7_ID]));
            budgetRequest.setSegment8Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT8_ID]));
            budgetRequest.setSegment9Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT9_ID]));
            budgetRequest.setSegment10Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT10_ID]));
            budgetRequest.setSegment11Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT11_ID]));
            budgetRequest.setSegment12Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT12_ID]));
            budgetRequest.setSegment13Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT13_ID]));
            budgetRequest.setSegment14Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT14_ID]));
            budgetRequest.setSegment15Id(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT15_ID]));
            budgetRequest.setUniqKeyId(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_UNIQ_KEY_ID]));
            budgetRequest.setStatus(rs.getInt(DbBudgetRequest.colNames[DbBudgetRequest.COL_STATUS]));
            budgetRequest.setRefId(rs.getLong(DbBudgetRequest.colNames[DbBudgetRequest.COL_REF_ID]));
            budgetRequest.setPaymentType(rs.getInt(DbBudgetRequest.colNames[DbBudgetRequest.COL_PAYMENT_TYPE]));

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
    }

    public static boolean checkOID(long budgetRequestId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BUDGET_REQUEST + " WHERE " +
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_BUDGET_REQUEST_ID] + " = " + budgetRequestId;

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
            String sql = "SELECT COUNT(" + DbBudgetRequest.colNames[DbBudgetRequest.COL_BUDGET_REQUEST_ID] + ") FROM " + DB_BUDGET_REQUEST;
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
                    BudgetRequest budgetRequest = (BudgetRequest) list.get(ls);
                    if (oid == budgetRequest.getOID()) {
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
    
    public static void updatePosted(long userId,long oid,int paymentType,long refId){
                       
        CONResultSet dbrs = null;                
        try{                    
            String sql = "update "+DbBudgetRequest.DB_BUDGET_REQUEST+" set "+
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_STATUS]+" = "+DOC_STATUS_POSTED+","+
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_PAYMENT_TYPE]+" = "+paymentType+","+
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_REF_ID]+" = "+refId+","+
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_APPROVAL3_ID]+"="+userId+","+
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_POSTED_STATUS]+" = "+1+","+
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_POSTED_BY_ID]+" = "+userId+","+
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_POSTED_DATE]+" = '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd HH:mm:ss")+"', "+
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_APPROVAL3_DATE]+" = '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd HH:mm:ss")+"' "+
                    " where "+
                    DbBudgetRequest.colNames[DbBudgetRequest.COL_BUDGET_REQUEST_ID]+" = "+oid;
                
            CONHandler.execUpdate(sql);
                    
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
    }

    
}
