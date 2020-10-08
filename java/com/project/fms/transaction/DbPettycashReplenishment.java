package com.project.fms.transaction;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.transaction.*;
import com.project.fms.master.*;
import com.project.util.*;
import com.project.system.*;
import com.project.*;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;

public class DbPettycashReplenishment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PETTYCASH_REPLENISHMENT = "pettycash_replenishment";
    public static final int COL_PETTYCASH_REPLENISHMENT_ID = 0;
    public static final int COL_REPLACE_COA_ID = 1;
    public static final int COL_REPLACE_FROM_COA_ID = 2;
    public static final int COL_MEMO = 3;
    public static final int COL_DATE = 4;
    public static final int COL_TRANS_DATE = 5;
    public static final int COL_OPERATOR_ID = 6;
    public static final int COL_OPERATOR_NAME = 7;
    public static final int COL_REPLACE_AMOUNT = 8;
    public static final int COL_JOURNAL_NUMBER = 9;
    public static final int COL_JOURNAL_PREFIX = 10;
    public static final int COL_JOURNAL_COUNTER = 11;
    public static final int COL_STATUS = 12;
    public static final int COL_POSTED_STATUS = 13;
    public static final int COL_POSTED_BY_ID = 14;
    public static final int COL_POSTED_DATE = 15;
    public static final int COL_EFFECTIVE_DATE = 16;
    public static final int COL_CUSTOMER_ID = 17;
    
    public static final int COL_SEGMENT1_ID = 18;
    public static final int COL_SEGMENT2_ID = 19;
    public static final int COL_SEGMENT3_ID = 20;
    public static final int COL_SEGMENT4_ID = 21;
    public static final int COL_SEGMENT5_ID = 22;
    public static final int COL_SEGMENT6_ID = 23;
    public static final int COL_SEGMENT7_ID = 24;
    public static final int COL_SEGMENT8_ID = 25;
    public static final int COL_SEGMENT9_ID = 26;
    public static final int COL_SEGMENT10_ID = 27;
    public static final int COL_SEGMENT11_ID = 28;
    public static final int COL_SEGMENT12_ID = 29;
    public static final int COL_SEGMENT13_ID = 30;
    public static final int COL_SEGMENT14_ID = 31;
    public static final int COL_SEGMENT15_ID = 32;
    
    public static final String[] colNames = {
        "pettycash_replenishment_id",
        "replace_coa_id",
        "replace_from_coa_id",
        "memo",
        "date",
        "trans_date",
        "operator_id",
        "operator_name",
        "replace_amount",
        "journal_number",
        "journal_prefix",
        "journal_counter",
        "status",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "effective_date",
        "customer_id",
        
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
        "segment15_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
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
        TYPE_LONG
    };

    public DbPettycashReplenishment() {
    }

    public DbPettycashReplenishment(int i) throws CONException {
        super(new DbPettycashReplenishment());
    }

    public DbPettycashReplenishment(String sOid) throws CONException {
        super(new DbPettycashReplenishment(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPettycashReplenishment(long lOid) throws CONException {
        super(new DbPettycashReplenishment(0));
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
        return DB_PETTYCASH_REPLENISHMENT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPettycashReplenishment().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PettycashReplenishment pettycashreplenishment = fetchExc(ent.getOID());
        ent = (Entity) pettycashreplenishment;
        return pettycashreplenishment.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PettycashReplenishment) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PettycashReplenishment) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PettycashReplenishment fetchExc(long oid) throws CONException {
        try {
            PettycashReplenishment pettycashreplenishment = new PettycashReplenishment();
            DbPettycashReplenishment pstPettycashReplenishment = new DbPettycashReplenishment(oid);
            pettycashreplenishment.setOID(oid);

            pettycashreplenishment.setReplaceCoaId(pstPettycashReplenishment.getlong(COL_REPLACE_COA_ID));
            pettycashreplenishment.setReplaceFromCoaId(pstPettycashReplenishment.getlong(COL_REPLACE_FROM_COA_ID));
            pettycashreplenishment.setMemo(pstPettycashReplenishment.getString(COL_MEMO));
            pettycashreplenishment.setDate(pstPettycashReplenishment.getDate(COL_DATE));
            pettycashreplenishment.setTransDate(pstPettycashReplenishment.getDate(COL_TRANS_DATE));
            pettycashreplenishment.setOperatorId(pstPettycashReplenishment.getlong(COL_OPERATOR_ID));
            pettycashreplenishment.setOperatorName(pstPettycashReplenishment.getString(COL_OPERATOR_NAME));
            pettycashreplenishment.setReplaceAmount(pstPettycashReplenishment.getdouble(COL_REPLACE_AMOUNT));
            pettycashreplenishment.setJournalNumber(pstPettycashReplenishment.getString(COL_JOURNAL_NUMBER));
            pettycashreplenishment.setJournalPrefix(pstPettycashReplenishment.getString(COL_JOURNAL_PREFIX));
            pettycashreplenishment.setJournalCounter(pstPettycashReplenishment.getInt(COL_JOURNAL_COUNTER));
            pettycashreplenishment.setStatus(pstPettycashReplenishment.getString(COL_STATUS));

            pettycashreplenishment.setPostedStatus(pstPettycashReplenishment.getInt(COL_POSTED_STATUS));
            pettycashreplenishment.setPostedById(pstPettycashReplenishment.getlong(COL_POSTED_BY_ID));
            pettycashreplenishment.setPostedDate(pstPettycashReplenishment.getDate(COL_POSTED_DATE));
            pettycashreplenishment.setEffectiveDate(pstPettycashReplenishment.getDate(COL_EFFECTIVE_DATE));
            pettycashreplenishment.setCustomerId(pstPettycashReplenishment.getlong(COL_CUSTOMER_ID));
            
            pettycashreplenishment.setSegment1Id(pstPettycashReplenishment.getlong(COL_SEGMENT1_ID));
            pettycashreplenishment.setSegment2Id(pstPettycashReplenishment.getlong(COL_SEGMENT2_ID));
            pettycashreplenishment.setSegment3Id(pstPettycashReplenishment.getlong(COL_SEGMENT3_ID));
            pettycashreplenishment.setSegment4Id(pstPettycashReplenishment.getlong(COL_SEGMENT4_ID));
            pettycashreplenishment.setSegment5Id(pstPettycashReplenishment.getlong(COL_SEGMENT5_ID));
            pettycashreplenishment.setSegment6Id(pstPettycashReplenishment.getlong(COL_SEGMENT6_ID));
            pettycashreplenishment.setSegment7Id(pstPettycashReplenishment.getlong(COL_SEGMENT7_ID));
            pettycashreplenishment.setSegment8Id(pstPettycashReplenishment.getlong(COL_SEGMENT8_ID));
            pettycashreplenishment.setSegment9Id(pstPettycashReplenishment.getlong(COL_SEGMENT9_ID));
            pettycashreplenishment.setSegment10Id(pstPettycashReplenishment.getlong(COL_SEGMENT10_ID));
            pettycashreplenishment.setSegment11Id(pstPettycashReplenishment.getlong(COL_SEGMENT11_ID));
            pettycashreplenishment.setSegment12Id(pstPettycashReplenishment.getlong(COL_SEGMENT12_ID));
            pettycashreplenishment.setSegment13Id(pstPettycashReplenishment.getlong(COL_SEGMENT13_ID));
            pettycashreplenishment.setSegment14Id(pstPettycashReplenishment.getlong(COL_SEGMENT14_ID));
            pettycashreplenishment.setSegment15Id(pstPettycashReplenishment.getlong(COL_SEGMENT15_ID));

            return pettycashreplenishment;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashReplenishment(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PettycashReplenishment pettycashreplenishment) throws CONException {
        try {
            DbPettycashReplenishment pstPettycashReplenishment = new DbPettycashReplenishment(0);

            pstPettycashReplenishment.setLong(COL_REPLACE_COA_ID, pettycashreplenishment.getReplaceCoaId());
            pstPettycashReplenishment.setLong(COL_REPLACE_FROM_COA_ID, pettycashreplenishment.getReplaceFromCoaId());
            pstPettycashReplenishment.setString(COL_MEMO, pettycashreplenishment.getMemo());
            pstPettycashReplenishment.setDate(COL_DATE, pettycashreplenishment.getDate());
            pstPettycashReplenishment.setDate(COL_TRANS_DATE, pettycashreplenishment.getTransDate());
            pstPettycashReplenishment.setLong(COL_OPERATOR_ID, pettycashreplenishment.getOperatorId());
            pstPettycashReplenishment.setString(COL_OPERATOR_NAME, pettycashreplenishment.getOperatorName());
            pstPettycashReplenishment.setDouble(COL_REPLACE_AMOUNT, pettycashreplenishment.getReplaceAmount());
            pstPettycashReplenishment.setString(COL_JOURNAL_NUMBER, pettycashreplenishment.getJournalNumber());
            pstPettycashReplenishment.setString(COL_JOURNAL_PREFIX, pettycashreplenishment.getJournalPrefix());
            pstPettycashReplenishment.setInt(COL_JOURNAL_COUNTER, pettycashreplenishment.getJournalCounter());
            pstPettycashReplenishment.setString(COL_STATUS, pettycashreplenishment.getStatus());

            pstPettycashReplenishment.setInt(COL_POSTED_STATUS, pettycashreplenishment.getPostedStatus());
            pstPettycashReplenishment.setLong(COL_POSTED_BY_ID, pettycashreplenishment.getPostedById());
            pstPettycashReplenishment.setDate(COL_POSTED_DATE, pettycashreplenishment.getPostedDate());
            pstPettycashReplenishment.setDate(COL_EFFECTIVE_DATE, pettycashreplenishment.getEffectiveDate());
            pstPettycashReplenishment.setLong(COL_CUSTOMER_ID, pettycashreplenishment.getCustomerId());
            
            pstPettycashReplenishment.setLong(COL_SEGMENT1_ID, pettycashreplenishment.getSegment1Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT2_ID, pettycashreplenishment.getSegment2Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT3_ID, pettycashreplenishment.getSegment3Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT4_ID, pettycashreplenishment.getSegment4Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT5_ID, pettycashreplenishment.getSegment5Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT6_ID, pettycashreplenishment.getSegment6Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT7_ID, pettycashreplenishment.getSegment7Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT8_ID, pettycashreplenishment.getSegment8Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT9_ID, pettycashreplenishment.getSegment9Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT10_ID, pettycashreplenishment.getSegment10Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT11_ID, pettycashreplenishment.getSegment11Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT12_ID, pettycashreplenishment.getSegment12Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT13_ID, pettycashreplenishment.getSegment13Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT14_ID, pettycashreplenishment.getSegment14Id());
            pstPettycashReplenishment.setLong(COL_SEGMENT15_ID, pettycashreplenishment.getSegment15Id());

            pstPettycashReplenishment.insert();
            pettycashreplenishment.setOID(pstPettycashReplenishment.getlong(COL_PETTYCASH_REPLENISHMENT_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashReplenishment(0), CONException.UNKNOWN);
        }
        return pettycashreplenishment.getOID();
    }

    public static long updateExc(PettycashReplenishment pettycashreplenishment) throws CONException {
        try {
            if (pettycashreplenishment.getOID() != 0) {
                DbPettycashReplenishment pstPettycashReplenishment = new DbPettycashReplenishment(pettycashreplenishment.getOID());

                pstPettycashReplenishment.setLong(COL_REPLACE_COA_ID, pettycashreplenishment.getReplaceCoaId());
                pstPettycashReplenishment.setLong(COL_REPLACE_FROM_COA_ID, pettycashreplenishment.getReplaceFromCoaId());
                pstPettycashReplenishment.setString(COL_MEMO, pettycashreplenishment.getMemo());
                pstPettycashReplenishment.setDate(COL_DATE, pettycashreplenishment.getDate());
                pstPettycashReplenishment.setDate(COL_TRANS_DATE, pettycashreplenishment.getTransDate());
                pstPettycashReplenishment.setLong(COL_OPERATOR_ID, pettycashreplenishment.getOperatorId());
                pstPettycashReplenishment.setString(COL_OPERATOR_NAME, pettycashreplenishment.getOperatorName());
                pstPettycashReplenishment.setDouble(COL_REPLACE_AMOUNT, pettycashreplenishment.getReplaceAmount());
                pstPettycashReplenishment.setString(COL_JOURNAL_NUMBER, pettycashreplenishment.getJournalNumber());
                pstPettycashReplenishment.setString(COL_JOURNAL_PREFIX, pettycashreplenishment.getJournalPrefix());
                pstPettycashReplenishment.setInt(COL_JOURNAL_COUNTER, pettycashreplenishment.getJournalCounter());
                pstPettycashReplenishment.setString(COL_STATUS, pettycashreplenishment.getStatus());

                pstPettycashReplenishment.setInt(COL_POSTED_STATUS, pettycashreplenishment.getPostedStatus());
                pstPettycashReplenishment.setLong(COL_POSTED_BY_ID, pettycashreplenishment.getPostedById());
                pstPettycashReplenishment.setDate(COL_POSTED_DATE, pettycashreplenishment.getPostedDate());
                pstPettycashReplenishment.setDate(COL_EFFECTIVE_DATE, pettycashreplenishment.getEffectiveDate());
                pstPettycashReplenishment.setLong(COL_CUSTOMER_ID, pettycashreplenishment.getCustomerId());
                
                pstPettycashReplenishment.setLong(COL_SEGMENT1_ID, pettycashreplenishment.getSegment1Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT2_ID, pettycashreplenishment.getSegment2Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT3_ID, pettycashreplenishment.getSegment3Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT4_ID, pettycashreplenishment.getSegment4Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT5_ID, pettycashreplenishment.getSegment5Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT6_ID, pettycashreplenishment.getSegment6Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT7_ID, pettycashreplenishment.getSegment7Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT8_ID, pettycashreplenishment.getSegment8Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT9_ID, pettycashreplenishment.getSegment9Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT10_ID, pettycashreplenishment.getSegment10Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT11_ID, pettycashreplenishment.getSegment11Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT12_ID, pettycashreplenishment.getSegment12Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT13_ID, pettycashreplenishment.getSegment13Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT14_ID, pettycashreplenishment.getSegment14Id());
	            pstPettycashReplenishment.setLong(COL_SEGMENT15_ID, pettycashreplenishment.getSegment15Id());

                pstPettycashReplenishment.update();
                return pettycashreplenishment.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashReplenishment(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPettycashReplenishment pstPettycashReplenishment = new DbPettycashReplenishment(oid);
            pstPettycashReplenishment.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashReplenishment(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PETTYCASH_REPLENISHMENT;
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
                PettycashReplenishment pettycashreplenishment = new PettycashReplenishment();
                resultToObject(rs, pettycashreplenishment);
                lists.add(pettycashreplenishment);
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

    private static void resultToObject(ResultSet rs, PettycashReplenishment pettycashreplenishment) {
        try {
            pettycashreplenishment.setOID(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_PETTYCASH_REPLENISHMENT_ID]));
            pettycashreplenishment.setReplaceCoaId(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_REPLACE_COA_ID]));
            pettycashreplenishment.setReplaceFromCoaId(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_REPLACE_FROM_COA_ID]));
            pettycashreplenishment.setMemo(rs.getString(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_MEMO]));
            pettycashreplenishment.setDate(rs.getDate(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_DATE]));
            pettycashreplenishment.setTransDate(rs.getDate(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_TRANS_DATE]));
            pettycashreplenishment.setOperatorId(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_OPERATOR_ID]));
            pettycashreplenishment.setOperatorName(rs.getString(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_OPERATOR_NAME]));
            pettycashreplenishment.setReplaceAmount(rs.getDouble(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_REPLACE_AMOUNT]));
            pettycashreplenishment.setJournalNumber(rs.getString(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_JOURNAL_NUMBER]));
            pettycashreplenishment.setJournalPrefix(rs.getString(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_JOURNAL_PREFIX]));
            pettycashreplenishment.setJournalCounter(rs.getInt(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_JOURNAL_COUNTER]));
            pettycashreplenishment.setStatus(rs.getString(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_STATUS]));

            pettycashreplenishment.setPostedStatus(rs.getInt(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_POSTED_STATUS]));
            pettycashreplenishment.setPostedById(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_POSTED_BY_ID]));
            pettycashreplenishment.setPostedDate(rs.getDate(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_POSTED_DATE]));
            pettycashreplenishment.setEffectiveDate(rs.getDate(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_EFFECTIVE_DATE]));
            pettycashreplenishment.setCustomerId(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_CUSTOMER_ID]));
            
            pettycashreplenishment.setSegment1Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT1_ID]));
            pettycashreplenishment.setSegment2Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT2_ID]));
            pettycashreplenishment.setSegment3Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT3_ID]));
            pettycashreplenishment.setSegment4Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT4_ID]));
            pettycashreplenishment.setSegment5Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT5_ID]));
            pettycashreplenishment.setSegment6Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT6_ID]));
            pettycashreplenishment.setSegment7Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT7_ID]));
            pettycashreplenishment.setSegment8Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT8_ID]));
            pettycashreplenishment.setSegment9Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT9_ID]));
            pettycashreplenishment.setSegment10Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT10_ID]));
            pettycashreplenishment.setSegment11Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT11_ID]));
            pettycashreplenishment.setSegment12Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT12_ID]));
            pettycashreplenishment.setSegment13Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT13_ID]));
            pettycashreplenishment.setSegment14Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT14_ID]));
            pettycashreplenishment.setSegment15Id(rs.getLong(DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_SEGMENT15_ID]));

        } catch (Exception e) {
            System.out.println("[exception] "+e.toString());
        }
    }

    public static boolean checkOID(long pettycashReplenishmentId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PETTYCASH_REPLENISHMENT + " WHERE " +
                    DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_PETTYCASH_REPLENISHMENT_ID] + " = " + pettycashReplenishmentId;

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
            String sql = "SELECT COUNT(" + DbPettycashReplenishment.colNames[DbPettycashReplenishment.COL_PETTYCASH_REPLENISHMENT_ID] + ") FROM " + DB_PETTYCASH_REPLENISHMENT;
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
                    PettycashReplenishment pettycashreplenishment = (PettycashReplenishment) list.get(ls);
                    if (oid == pettycashreplenishment.getOID()) {
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

    public static double getReplenishmentByPeriod(Periode openPeriod, long coaId) {
        double result = 0;
        CONResultSet crs = null;
        try {
            String sql = "select sum(" + colNames[COL_REPLACE_AMOUNT] + ") from " + DB_PETTYCASH_REPLENISHMENT +
                    " where (" + colNames[COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(openPeriod.getStartDate(), "yyyy-MM-dd") + "'" +
                    " and '" + JSPFormater.formatDate(openPeriod.getEndDate(), "yyyy-MM-dd") + "')" +
                    " and " + colNames[COL_REPLACE_COA_ID] + "=" + coaId +
                    " and " + colNames[COL_STATUS] + "='" + I_Project.STATUS_POSTED + "'";

            System.out.println("\n" + sql);

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    //ambil semua replenishment oleh bank, baik yang open maupun yang sudah posted,
    //agar allokasi dana untuk transaksi lain tidak error        
    public static double getBankReplenishmentByPeriod(Periode openPeriod, long coaId) {
        double result = 0;
        CONResultSet crs = null;
        try {
            String sql = "select sum(" + colNames[COL_REPLACE_AMOUNT] + ") from " + DB_PETTYCASH_REPLENISHMENT +
                    " where (" + colNames[COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(openPeriod.getStartDate(), "yyyy-MM-dd") + "'" +
                    " and '" + JSPFormater.formatDate(openPeriod.getEndDate(), "yyyy-MM-dd") + "')" +
                    " and " + colNames[COL_REPLACE_FROM_COA_ID] + "=" + coaId;//+
            //" and "+colNames[COL_STATUS]+"='"+I_Project.STATUS_POSTED+"'";

            //System.out.println("\n"+sql);

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(journal_counter) from " + DB_PETTYCASH_REPLENISHMENT + " where " +
                    " journal_prefix='" + getNumberPrefix() + "' ";

            System.out.println(sql);

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
        code = code + sysCompany.getPettycashReplaceCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");

        //String code = DbSystemProperty.getValueByName("LOCATION_CODE");
        //code = code + DbSystemProperty.getValueByName("JOURNAL_PETTYCASH_REPLENISHMENT_CODE");

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

    public static PettycashReplenishment getOpenReplenishment(long oidReplaceCoa) {
        PettycashReplenishment result = new PettycashReplenishment();
        if (oidReplaceCoa != 0) {
            Vector v = DbPettycashReplenishment.list(0, 0, colNames[COL_REPLACE_COA_ID] + "=" + oidReplaceCoa + " and " + colNames[COL_STATUS] + "='" + I_Project.STATUS_NOT_POSTED + "'", "");
            if (v != null && v.size() > 0) {
                result = (PettycashReplenishment) v.get(0);
            }
        }

        return result;

    }

    //posting ke journal
    public static void postJournal(PettycashReplenishment cr, long userId) {//, Vector details){
        
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        if (cr.getOID() != 0) {

            long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_PETTYCASH_REPLENISHMENT,
                    cr.getMemo(), userId, "", cr.getOID(), "", cr.getTransDate());

            if (oid != 0) {

                //journal debet cash
                DbGl.postJournalDetail(er.getValueIdr(), cr.getReplaceCoaId(), 0, cr.getReplaceAmount(),
                        0, comp.getBookingCurrencyId(), oid, "", 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0
                        );


                //journal credit pada bank
                DbGl.postJournalDetail(er.getValueIdr(), cr.getReplaceFromCoaId(), cr.getReplaceAmount(), 0,
                        0, comp.getBookingCurrencyId(), oid, "", 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0
                        );
            }

            //update status
            if (oid != 0) {
                try {

                    cr.setPostedStatus(1);
                    cr.setPostedById(userId);
                    cr.setPostedDate(new Date());

                    Date dt = new Date();
                    String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                            DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                            DbPeriode.colNames[DbPeriode.COL_END_DATE];

                    Vector temp = DbPeriode.list(0, 0, where, "");
                    if (temp != null && temp.size() > 0) {
                        cr.setEffectiveDate(new Date());
                    } else {
                        Periode per = DbPeriode.getOpenPeriod();
                        cr.setEffectiveDate(per.getEndDate());
                    }

                    DbPettycashReplenishment.updateExc(cr);
                } catch (Exception e) {}
            }
        }
    }
}

