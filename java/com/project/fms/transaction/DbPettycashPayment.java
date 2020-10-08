package com.project.fms.transaction;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

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
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;
import com.project.payroll.DbEmployee;

public class DbPettycashPayment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PETTYCASH_PAYMENT = "pettycash_payment";
    public static final int COL_PETTYCASH_PAYMENT_ID = 0;
    public static final int COL_COA_ID = 1;
    public static final int COL_JOURNAL_NUMBER = 2;
    public static final int COL_JOURNAL_COUNTER = 3;
    public static final int COL_JOURNAL_PREFIX = 4;
    public static final int COL_DATE = 5;
    public static final int COL_TRANS_DATE = 6;
    public static final int COL_MEMO = 7;
    public static final int COL_OPERATOR_ID = 8;
    public static final int COL_OPERATOR_NAME = 9;
    public static final int COL_AMOUNT = 10;
    public static final int COL_REPLACE_STATUS = 11;
    public static final int COL_ACTIVITY_STATUS = 12;
    public static final int COL_SHARE_GROUP_ID = 13;
    public static final int COL_SHARE_CATEGORY_ID = 14;
    public static final int COL_STATUS = 15;
    public static final int COL_EXPENSE_CATEGORY_ID = 16;
    public static final int COL_POSTED_STATUS = 17;
    public static final int COL_POSTED_BY_ID = 18;
    public static final int COL_POSTED_DATE = 19;
    public static final int COL_EFFECTIVE_DATE = 20;
    public static final int COL_TYPE = 21;
    public static final int COL_CUSTOMER_ID = 22;
    // add untuk menu kasbon
    public static final int COL_TYPE_KASBON = 23;
    public static final int COL_EMPLOYEE_ID = 24;
    public static final int COL_REFERENSI_ID = 25;
    public static final int COL_PAYMENT_TO = 26;
    public static final int COL_SEGMENT1_ID = 27;
    public static final int COL_SEGMENT2_ID = 28;
    public static final int COL_SEGMENT3_ID = 29;
    public static final int COL_SEGMENT4_ID = 30;
    public static final int COL_SEGMENT5_ID = 31;
    public static final int COL_SEGMENT6_ID = 32;
    public static final int COL_SEGMENT7_ID = 33;
    public static final int COL_SEGMENT8_ID = 34;
    public static final int COL_SEGMENT9_ID = 35;
    public static final int COL_SEGMENT10_ID = 36;
    public static final int COL_SEGMENT11_ID = 37;
    public static final int COL_SEGMENT12_ID = 38;
    public static final int COL_SEGMENT13_ID = 39;
    public static final int COL_SEGMENT14_ID = 40;
    public static final int COL_SEGMENT15_ID = 41;
    public static final int COL_PERIODE_ID = 42;
    public static final String[] colNames = {
        "pettycash_payment_id",
        "coa_id",
        "journal_number",
        "journal_counter",
        "journal_prefix",
        "date",
        "trans_date",
        "memo",
        "operator_id",
        "operator_name",
        "amount",
        "replace_status",
        "activity_status",
        "share_group_id",
        "share_category_id",
        "status",
        "expense_category_id",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "effective_date",
        "type",
        "customer_id",
        "type_kasbon",
        "employee_id",
        "referensi_id",
        "payment_to",
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
        "segment15_id",
        "periode_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
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
        TYPE_LONG
    };
    /* Type status*/
    //---------- COLOM STATUS -----------------
    public static int STATUS_TYPE_DRAFT = 0;
    public static int STATUS_TYPE_APPROVED = 1;
    public static int STATUS_TYPE_POSTED = 2;
    public static int STATUS_TYPE_PAID = 3;
    public static int STATUS_TYPE_DROP_OUT = 4;
    //------------- COLOM TYPE -----------
    public static int STATUS_TYPE_PENGAKUAN_BIAYA = 0;
    public static int STATUS_TYPE_PELUNASAN_TUNAI = 1;
    public static int STATUS_TYPE_KASBON = 2;

    public DbPettycashPayment() {
    }

    public DbPettycashPayment(int i) throws CONException {
        super(new DbPettycashPayment());
    }

    public DbPettycashPayment(String sOid) throws CONException {
        super(new DbPettycashPayment(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPettycashPayment(long lOid) throws CONException {
        super(new DbPettycashPayment(0));
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
        return DB_PETTYCASH_PAYMENT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPettycashPayment().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PettycashPayment pettycashpayment = fetchExc(ent.getOID());
        ent = (Entity) pettycashpayment;
        return pettycashpayment.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PettycashPayment) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PettycashPayment) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PettycashPayment fetchExc(long oid) throws CONException {
        try {
            PettycashPayment pettycashpayment = new PettycashPayment();
            DbPettycashPayment pstPettycashPayment = new DbPettycashPayment(oid);
            pettycashpayment.setOID(oid);

            pettycashpayment.setCoaId(pstPettycashPayment.getlong(COL_COA_ID));
            pettycashpayment.setJournalNumber(pstPettycashPayment.getString(COL_JOURNAL_NUMBER));
            pettycashpayment.setJournalCounter(pstPettycashPayment.getInt(COL_JOURNAL_COUNTER));
            pettycashpayment.setJournalPrefix(pstPettycashPayment.getString(COL_JOURNAL_PREFIX));
            pettycashpayment.setDate(pstPettycashPayment.getDate(COL_DATE));
            pettycashpayment.setTransDate(pstPettycashPayment.getDate(COL_TRANS_DATE));
            pettycashpayment.setMemo(pstPettycashPayment.getString(COL_MEMO));
            pettycashpayment.setOperatorId(pstPettycashPayment.getlong(COL_OPERATOR_ID));
            pettycashpayment.setOperatorName(pstPettycashPayment.getString(COL_OPERATOR_NAME));
            pettycashpayment.setAmount(pstPettycashPayment.getdouble(COL_AMOUNT));
            pettycashpayment.setReplaceStatus(pstPettycashPayment.getInt(COL_REPLACE_STATUS));
            pettycashpayment.setActivityStatus(pstPettycashPayment.getString(COL_ACTIVITY_STATUS));
            pettycashpayment.setShareCategoryId(pstPettycashPayment.getlong(COL_SHARE_CATEGORY_ID));
            pettycashpayment.setShareGroupId(pstPettycashPayment.getlong(COL_SHARE_GROUP_ID));
            pettycashpayment.setStatus(pstPettycashPayment.getInt(COL_STATUS));
            pettycashpayment.setExpenseCategoryId(pstPettycashPayment.getlong(COL_EXPENSE_CATEGORY_ID));
            pettycashpayment.setPostedStatus(pstPettycashPayment.getInt(COL_POSTED_STATUS));
            pettycashpayment.setPostedById(pstPettycashPayment.getlong(COL_POSTED_BY_ID));
            pettycashpayment.setPostedDate(pstPettycashPayment.getDate(COL_POSTED_DATE));
            pettycashpayment.setEffectiveDate(pstPettycashPayment.getDate(COL_EFFECTIVE_DATE));
            pettycashpayment.setType(pstPettycashPayment.getInt(COL_TYPE));
            pettycashpayment.setCustomerId(pstPettycashPayment.getlong(COL_CUSTOMER_ID));

            pettycashpayment.setTypeKasbon(pstPettycashPayment.getInt(COL_TYPE_KASBON));
            pettycashpayment.setEmployeeId(pstPettycashPayment.getlong(COL_EMPLOYEE_ID));
            pettycashpayment.setReferensiId(pstPettycashPayment.getlong(COL_REFERENSI_ID));
            pettycashpayment.setPaymentTo(pstPettycashPayment.getString(COL_PAYMENT_TO));

            pettycashpayment.setSegment1Id(pstPettycashPayment.getlong(COL_SEGMENT1_ID));
            pettycashpayment.setSegment2Id(pstPettycashPayment.getlong(COL_SEGMENT2_ID));
            pettycashpayment.setSegment3Id(pstPettycashPayment.getlong(COL_SEGMENT3_ID));
            pettycashpayment.setSegment4Id(pstPettycashPayment.getlong(COL_SEGMENT4_ID));
            pettycashpayment.setSegment5Id(pstPettycashPayment.getlong(COL_SEGMENT5_ID));
            pettycashpayment.setSegment6Id(pstPettycashPayment.getlong(COL_SEGMENT6_ID));
            pettycashpayment.setSegment7Id(pstPettycashPayment.getlong(COL_SEGMENT7_ID));
            pettycashpayment.setSegment8Id(pstPettycashPayment.getlong(COL_SEGMENT8_ID));
            pettycashpayment.setSegment9Id(pstPettycashPayment.getlong(COL_SEGMENT9_ID));
            pettycashpayment.setSegment10Id(pstPettycashPayment.getlong(COL_SEGMENT10_ID));
            pettycashpayment.setSegment11Id(pstPettycashPayment.getlong(COL_SEGMENT11_ID));
            pettycashpayment.setSegment12Id(pstPettycashPayment.getlong(COL_SEGMENT12_ID));
            pettycashpayment.setSegment13Id(pstPettycashPayment.getlong(COL_SEGMENT13_ID));
            pettycashpayment.setSegment14Id(pstPettycashPayment.getlong(COL_SEGMENT14_ID));
            pettycashpayment.setSegment15Id(pstPettycashPayment.getlong(COL_SEGMENT15_ID));

            pettycashpayment.setPeriodeId(pstPettycashPayment.getlong(COL_PERIODE_ID));

            return pettycashpayment;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashPayment(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PettycashPayment pettycashpayment) throws CONException {
        try {
            DbPettycashPayment pstPettycashPayment = new DbPettycashPayment(0);

            pstPettycashPayment.setLong(COL_COA_ID, pettycashpayment.getCoaId());
            pstPettycashPayment.setString(COL_JOURNAL_NUMBER, pettycashpayment.getJournalNumber());
            pstPettycashPayment.setInt(COL_JOURNAL_COUNTER, pettycashpayment.getJournalCounter());
            pstPettycashPayment.setString(COL_JOURNAL_PREFIX, pettycashpayment.getJournalPrefix());
            pstPettycashPayment.setDate(COL_DATE, pettycashpayment.getDate());
            pstPettycashPayment.setDate(COL_TRANS_DATE, pettycashpayment.getTransDate());
            pstPettycashPayment.setString(COL_MEMO, pettycashpayment.getMemo());
            pstPettycashPayment.setLong(COL_OPERATOR_ID, pettycashpayment.getOperatorId());
            pstPettycashPayment.setString(COL_OPERATOR_NAME, pettycashpayment.getOperatorName());
            pstPettycashPayment.setDouble(COL_AMOUNT, pettycashpayment.getAmount());
            pstPettycashPayment.setInt(COL_REPLACE_STATUS, pettycashpayment.getReplaceStatus());

            pstPettycashPayment.setString(COL_ACTIVITY_STATUS, pettycashpayment.getActivityStatus());

            pstPettycashPayment.setLong(COL_SHARE_CATEGORY_ID, pettycashpayment.getShareCategoryId());
            pstPettycashPayment.setLong(COL_SHARE_GROUP_ID, pettycashpayment.getShareGroupId());
            pstPettycashPayment.setInt(COL_STATUS, pettycashpayment.getStatus());
            pstPettycashPayment.setLong(COL_EXPENSE_CATEGORY_ID, pettycashpayment.getExpenseCategoryId());

            pstPettycashPayment.setInt(COL_POSTED_STATUS, pettycashpayment.getPostedStatus());
            pstPettycashPayment.setLong(COL_POSTED_BY_ID, pettycashpayment.getPostedById());
            pstPettycashPayment.setDate(COL_POSTED_DATE, pettycashpayment.getPostedDate());
            pstPettycashPayment.setDate(COL_EFFECTIVE_DATE, pettycashpayment.getEffectiveDate());
            pstPettycashPayment.setInt(COL_TYPE, pettycashpayment.getType());
            pstPettycashPayment.setLong(COL_CUSTOMER_ID, pettycashpayment.getCustomerId());

            pstPettycashPayment.setInt(COL_TYPE_KASBON, pettycashpayment.getTypeKasbon());
            pstPettycashPayment.setLong(COL_EMPLOYEE_ID, pettycashpayment.getEmployeeId());
            pstPettycashPayment.setLong(COL_REFERENSI_ID, pettycashpayment.getReferensiId());
            pstPettycashPayment.setString(COL_PAYMENT_TO, pettycashpayment.getPaymentTo());

            pstPettycashPayment.setLong(COL_SEGMENT1_ID, pettycashpayment.getSegment1Id());
            pstPettycashPayment.setLong(COL_SEGMENT2_ID, pettycashpayment.getSegment2Id());
            pstPettycashPayment.setLong(COL_SEGMENT3_ID, pettycashpayment.getSegment3Id());
            pstPettycashPayment.setLong(COL_SEGMENT4_ID, pettycashpayment.getSegment4Id());
            pstPettycashPayment.setLong(COL_SEGMENT5_ID, pettycashpayment.getSegment5Id());
            pstPettycashPayment.setLong(COL_SEGMENT6_ID, pettycashpayment.getSegment6Id());
            pstPettycashPayment.setLong(COL_SEGMENT7_ID, pettycashpayment.getSegment7Id());
            pstPettycashPayment.setLong(COL_SEGMENT8_ID, pettycashpayment.getSegment8Id());
            pstPettycashPayment.setLong(COL_SEGMENT9_ID, pettycashpayment.getSegment9Id());
            pstPettycashPayment.setLong(COL_SEGMENT10_ID, pettycashpayment.getSegment10Id());
            pstPettycashPayment.setLong(COL_SEGMENT11_ID, pettycashpayment.getSegment11Id());
            pstPettycashPayment.setLong(COL_SEGMENT12_ID, pettycashpayment.getSegment12Id());
            pstPettycashPayment.setLong(COL_SEGMENT13_ID, pettycashpayment.getSegment13Id());
            pstPettycashPayment.setLong(COL_SEGMENT14_ID, pettycashpayment.getSegment14Id());
            pstPettycashPayment.setLong(COL_SEGMENT15_ID, pettycashpayment.getSegment15Id());
            pstPettycashPayment.setLong(COL_PERIODE_ID, pettycashpayment.getPeriodeId());

            pstPettycashPayment.insert();
            pettycashpayment.setOID(pstPettycashPayment.getlong(COL_PETTYCASH_PAYMENT_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashPayment(0), CONException.UNKNOWN);
        }
        return pettycashpayment.getOID();
    }

    public static long updateExc(PettycashPayment pettycashpayment) throws CONException {
        try {
            if (pettycashpayment.getOID() != 0) {
                DbPettycashPayment pstPettycashPayment = new DbPettycashPayment(pettycashpayment.getOID());

                pstPettycashPayment.setLong(COL_COA_ID, pettycashpayment.getCoaId());
                pstPettycashPayment.setString(COL_JOURNAL_NUMBER, pettycashpayment.getJournalNumber());
                pstPettycashPayment.setInt(COL_JOURNAL_COUNTER, pettycashpayment.getJournalCounter());
                pstPettycashPayment.setString(COL_JOURNAL_PREFIX, pettycashpayment.getJournalPrefix());
                pstPettycashPayment.setDate(COL_DATE, pettycashpayment.getDate());
                pstPettycashPayment.setDate(COL_TRANS_DATE, pettycashpayment.getTransDate());
                pstPettycashPayment.setString(COL_MEMO, pettycashpayment.getMemo());
                pstPettycashPayment.setLong(COL_OPERATOR_ID, pettycashpayment.getOperatorId());
                pstPettycashPayment.setString(COL_OPERATOR_NAME, pettycashpayment.getOperatorName());
                pstPettycashPayment.setDouble(COL_AMOUNT, pettycashpayment.getAmount());
                pstPettycashPayment.setInt(COL_REPLACE_STATUS, pettycashpayment.getReplaceStatus());
                pstPettycashPayment.setString(COL_ACTIVITY_STATUS, pettycashpayment.getActivityStatus());

                pstPettycashPayment.setLong(COL_SHARE_CATEGORY_ID, pettycashpayment.getShareCategoryId());
                pstPettycashPayment.setLong(COL_SHARE_GROUP_ID, pettycashpayment.getShareGroupId());
                pstPettycashPayment.setInt(COL_STATUS, pettycashpayment.getStatus());
                pstPettycashPayment.setLong(COL_EXPENSE_CATEGORY_ID, pettycashpayment.getExpenseCategoryId());

                pstPettycashPayment.setInt(COL_POSTED_STATUS, pettycashpayment.getPostedStatus());
                pstPettycashPayment.setLong(COL_POSTED_BY_ID, pettycashpayment.getPostedById());
                pstPettycashPayment.setDate(COL_POSTED_DATE, pettycashpayment.getPostedDate());
                pstPettycashPayment.setInt(COL_TYPE, pettycashpayment.getType());
                pstPettycashPayment.setLong(COL_CUSTOMER_ID, pettycashpayment.getCustomerId());

                pstPettycashPayment.setInt(COL_TYPE_KASBON, pettycashpayment.getTypeKasbon());
                pstPettycashPayment.setLong(COL_EMPLOYEE_ID, pettycashpayment.getEmployeeId());
                pstPettycashPayment.setLong(COL_REFERENSI_ID, pettycashpayment.getReferensiId());
                pstPettycashPayment.setString(COL_PAYMENT_TO, pettycashpayment.getPaymentTo());

                pstPettycashPayment.setLong(COL_SEGMENT1_ID, pettycashpayment.getSegment1Id());
                pstPettycashPayment.setLong(COL_SEGMENT2_ID, pettycashpayment.getSegment2Id());
                pstPettycashPayment.setLong(COL_SEGMENT3_ID, pettycashpayment.getSegment3Id());
                pstPettycashPayment.setLong(COL_SEGMENT4_ID, pettycashpayment.getSegment4Id());
                pstPettycashPayment.setLong(COL_SEGMENT5_ID, pettycashpayment.getSegment5Id());
                pstPettycashPayment.setLong(COL_SEGMENT6_ID, pettycashpayment.getSegment6Id());
                pstPettycashPayment.setLong(COL_SEGMENT7_ID, pettycashpayment.getSegment7Id());
                pstPettycashPayment.setLong(COL_SEGMENT8_ID, pettycashpayment.getSegment8Id());
                pstPettycashPayment.setLong(COL_SEGMENT9_ID, pettycashpayment.getSegment9Id());
                pstPettycashPayment.setLong(COL_SEGMENT10_ID, pettycashpayment.getSegment10Id());
                pstPettycashPayment.setLong(COL_SEGMENT11_ID, pettycashpayment.getSegment11Id());
                pstPettycashPayment.setLong(COL_SEGMENT12_ID, pettycashpayment.getSegment12Id());
                pstPettycashPayment.setLong(COL_SEGMENT13_ID, pettycashpayment.getSegment13Id());
                pstPettycashPayment.setLong(COL_SEGMENT14_ID, pettycashpayment.getSegment14Id());
                pstPettycashPayment.setLong(COL_SEGMENT15_ID, pettycashpayment.getSegment15Id());

                pstPettycashPayment.setLong(COL_PERIODE_ID, pettycashpayment.getPeriodeId());

                pstPettycashPayment.update();
                return pettycashpayment.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashPayment(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPettycashPayment pstPettycashPayment = new DbPettycashPayment(oid);
            pstPettycashPayment.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPettycashPayment(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PETTYCASH_PAYMENT;
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
                PettycashPayment pettycashpayment = new PettycashPayment();
                resultToObject(rs, pettycashpayment);
                lists.add(pettycashpayment);
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

    private static void resultToObject(ResultSet rs, PettycashPayment pettycashpayment) {
        try {
            pettycashpayment.setOID(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID]));
            pettycashpayment.setCoaId(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_COA_ID]));
            pettycashpayment.setJournalNumber(rs.getString(DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER]));
            pettycashpayment.setJournalCounter(rs.getInt(DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_COUNTER]));
            pettycashpayment.setJournalPrefix(rs.getString(DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_PREFIX]));
            pettycashpayment.setDate(rs.getDate(DbPettycashPayment.colNames[DbPettycashPayment.COL_DATE]));
            pettycashpayment.setTransDate(rs.getDate(DbPettycashPayment.colNames[DbPettycashPayment.COL_TRANS_DATE]));
            pettycashpayment.setMemo(rs.getString(DbPettycashPayment.colNames[DbPettycashPayment.COL_MEMO]));
            pettycashpayment.setOperatorId(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_OPERATOR_ID]));
            pettycashpayment.setOperatorName(rs.getString(DbPettycashPayment.colNames[DbPettycashPayment.COL_OPERATOR_NAME]));
            pettycashpayment.setAmount(rs.getDouble(DbPettycashPayment.colNames[DbPettycashPayment.COL_AMOUNT]));
            pettycashpayment.setReplaceStatus(rs.getInt(DbPettycashPayment.colNames[DbPettycashPayment.COL_REPLACE_STATUS]));
            pettycashpayment.setActivityStatus(rs.getString(DbPettycashPayment.colNames[DbPettycashPayment.COL_ACTIVITY_STATUS]));

            pettycashpayment.setShareCategoryId(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SHARE_CATEGORY_ID]));
            pettycashpayment.setShareGroupId(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SHARE_GROUP_ID]));
            pettycashpayment.setStatus(rs.getInt(DbPettycashPayment.colNames[DbPettycashPayment.COL_STATUS]));
            pettycashpayment.setExpenseCategoryId(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_EXPENSE_CATEGORY_ID]));

            pettycashpayment.setPostedStatus(rs.getInt(DbPettycashPayment.colNames[DbPettycashPayment.COL_POSTED_STATUS]));
            pettycashpayment.setPostedById(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_POSTED_BY_ID]));
            pettycashpayment.setPostedDate(rs.getDate(DbPettycashPayment.colNames[DbPettycashPayment.COL_POSTED_DATE]));
            pettycashpayment.setEffectiveDate(rs.getDate(DbPettycashPayment.colNames[DbPettycashPayment.COL_EFFECTIVE_DATE]));
            pettycashpayment.setType(rs.getInt(DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE]));
            pettycashpayment.setCustomerId(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_CUSTOMER_ID]));

            pettycashpayment.setTypeKasbon(rs.getInt(DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE_KASBON]));
            pettycashpayment.setEmployeeId(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_EMPLOYEE_ID]));
            pettycashpayment.setReferensiId(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_REFERENSI_ID]));
            pettycashpayment.setPaymentTo(rs.getString(DbPettycashPayment.colNames[DbPettycashPayment.COL_PAYMENT_TO]));

            pettycashpayment.setSegment1Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT1_ID]));
            pettycashpayment.setSegment2Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT2_ID]));
            pettycashpayment.setSegment3Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT3_ID]));
            pettycashpayment.setSegment4Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT4_ID]));
            pettycashpayment.setSegment5Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT5_ID]));
            pettycashpayment.setSegment6Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT6_ID]));
            pettycashpayment.setSegment7Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT7_ID]));
            pettycashpayment.setSegment8Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT8_ID]));
            pettycashpayment.setSegment9Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT9_ID]));
            pettycashpayment.setSegment10Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT10_ID]));
            pettycashpayment.setSegment11Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT11_ID]));
            pettycashpayment.setSegment12Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT12_ID]));
            pettycashpayment.setSegment13Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT13_ID]));
            pettycashpayment.setSegment14Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT14_ID]));
            pettycashpayment.setSegment15Id(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_SEGMENT15_ID]));
            pettycashpayment.setPeriodeId(rs.getLong(DbPettycashPayment.colNames[DbPettycashPayment.COL_PERIODE_ID]));

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
    }

    public static boolean checkOID(long pettycashPaymentId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PETTYCASH_PAYMENT + " WHERE " +
                    DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + " = " + pettycashPaymentId;

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
            String sql = "SELECT COUNT(" + DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + ") FROM " + DB_PETTYCASH_PAYMENT;
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
                    PettycashPayment pettycashpayment = (PettycashPayment) list.get(ls);
                    if (oid == pettycashpayment.getOID()) {
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

    public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(journal_counter) from " + DB_PETTYCASH_PAYMENT + " where " +
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
        code = code + sysCompany.getPettycashPaymentCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");

        //String code = DbSystemProperty.getValueByName("LOCATION_CODE");
        //code = code + DbSystemProperty.getValueByName("JOURNAL_PETTYCASH_PAYMENT_CODE");

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

    public static double getPaymentByPeriod(Periode openPeriod, long coaId) {
        double result = 0;
        CONResultSet crs = null;
        try {
            String sql = "select sum(" + colNames[COL_AMOUNT] + ") from " + DB_PETTYCASH_PAYMENT +
                    " where (" + colNames[COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(openPeriod.getStartDate(), "yyyy-MM-dd") + "'" +
                    " and '" + JSPFormater.formatDate(openPeriod.getEndDate(), "yyyy-MM-dd") + "')" +
                    " and " + colNames[COL_COA_ID] + "=" + coaId;

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
    public static final int REPLACE_STATUS_OPEN = 0;
    public static final int REPLACE_STATUS_CLOSED = 1;

    public static Vector getOpenPayment(long coaId) {

        CONResultSet crs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "select * from " + DB_PETTYCASH_PAYMENT +
                    " where coa_id=" + coaId + " and  " + colNames[COL_POSTED_STATUS] + "=" + I_Fms.STATUS_POSTED +
                    " and (" + colNames[COL_PETTYCASH_PAYMENT_ID] +
                    " not in (select " + DbPettycashExpense.colNames[DbPettycashExpense.COL_PETTYCASH_PAYMENT_ID] +
                    " from " + DbPettycashExpense.DB_PETTYCASH_EXPENSES + "))";

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                PettycashPayment pp = new PettycashPayment();
                DbPettycashPayment.resultToObject(rs, pp);

                result.add(pp);
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static Vector getPettycashPayment(long oidReplen) {
        CONResultSet crs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = "select pp.* from " + DB_PETTYCASH_PAYMENT + " as pp " +
                    " inner join " + DbPettycashExpense.DB_PETTYCASH_EXPENSES + " as pe " +
                    " on pe." + DbPettycashExpense.colNames[DbPettycashExpense.COL_PETTYCASH_PAYMENT_ID] + " = pp." + colNames[COL_PETTYCASH_PAYMENT_ID] +
                    " where pe." + DbPettycashExpense.colNames[DbPettycashExpense.COL_PETTYCASH_REPLENISHMENT_ID] + "=" + oidReplen;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                PettycashPayment pp = new PettycashPayment();
                DbPettycashPayment.resultToObject(rs, pp);

                result.add(pp);
            }

        } catch (Exception e) {

        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    //posting kasbon ke journal 
    //Roy Andika
    public static void postJournalKasbon(PettycashPayment cr, Vector details, long userId) {

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        try {
            cr = DbPettycashPayment.fetchExc(cr.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        Periode p = new Periode();
        try{
            p = DbPeriode.fetchExc(cr.getPeriodeId());
        }catch(Exception e){}

        if (cr.getOID() != 0 && details != null && details.size() > 0 && p.getOID() != 0 &&  p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {

            long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_KASBON,
                    cr.getMemo(), userId, "", cr.getOID(), "", cr.getTransDate(),cr.getPeriodeId());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {
                    //journal debet pada advance

                    PettycashPaymentDetail crd = (PettycashPaymentDetail) details.get(i);

                    DbGl.postJournalDetail(er.getValueIdr(), crd.getCoaId(), 0, crd.getAmount(),
                            0, comp.getBookingCurrencyId(), oid, crd.getMemo(), crd.getDepartmentId(),
                            crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
                            crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
                            crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
                            crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), crd.getModuleId());
                }

                //journal credit pada kas
                DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), cr.getAmount(), 0,
                        0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0); // petty cash : non departmental coa

            }

            if (oid != 0) {
                try {
                    //cr.setStatus(DbPettycashPayment.STATUS_TYPE_PAID);                    
                    DbPettycashPayment.updateExc(cr);
                } catch (Exception e) {
                    System.out.println("[exception]" + e.toString());
                }
            }
        }
    }

    //posting ke journal 
    //Roy Andika
    public static void postJournalPelunasanTunai(PettycashPayment cr, Vector details, long userId) {

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        try {
            cr = DbPettycashPayment.fetchExc(cr.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        Periode p = new Periode();
        try{
            p = DbPeriode.fetchExc(cr.getPeriodeId());
        }catch(Exception e){}

        if (cr.getOID() != 0 && details != null && details.size() > 0 && p.getOID() != 0 &&  p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {

            long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_PELUNASAN_TUNAI,
                    cr.getMemo(), userId, "", cr.getOID(), "", cr.getTransDate(),cr.getPeriodeId());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {

                    PettycashPaymentDetail crd = (PettycashPaymentDetail) details.get(i);
                    //journal debet pada suspense account
                    DbGl.postJournalDetail(er.getValueIdr(), crd.getCoaId(), 0, crd.getAmount(),
                            0, comp.getBookingCurrencyId(), oid, crd.getMemo(), crd.getDepartmentId(),
                            crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
                            crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
                            crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
                            crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), crd.getModuleId());
                }

                //journal credit pada kas
                DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), cr.getAmount(), 0,
                        0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0); // petty cash : non departmental coa

            }

            //update status ke paid
            if (oid != 0) {
                try {                    
                    cr.setPostedStatus(1);
                    cr.setPostedById(userId);
                    cr.setPostedDate(new Date());
                    cr.setStatus(DbPettycashPayment.STATUS_TYPE_PAID);

                    DbPettycashPayment.updateExc(cr);
                } catch (Exception e) {
                    System.out.println("[exception]" + e.toString());
                }
            }
        }
    }

    //posting ke journal
    public static void postJournal(PettycashPayment cr, Vector details, long userId) {

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
        try {
            cr = DbPettycashPayment.fetchExc(cr.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        Periode p = new Periode();
        try{
            p = DbPeriode.fetchExc(cr.getPeriodeId());
        }catch(Exception e){}

        if (cr.getOID() != 0 && details != null && details.size() > 0 && p.getOID() != 0 &&  p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {

            long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_PETTYCASH_PAYMENT,
                    cr.getMemo(), userId, "", cr.getOID(), "", cr.getTransDate(), cr.getPeriodeId());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {

                    PettycashPaymentDetail crd = (PettycashPaymentDetail) details.get(i);
                    //journal debet pada pendapatan atau untuk kasbon, account kasbon pada debet
                    if (crd.getAmount() != 0) {
                        DbGl.postJournalDetail(er.getValueIdr(), crd.getCoaId(), 0, crd.getAmount(),
                                0, comp.getBookingCurrencyId(), oid, crd.getMemo(), crd.getDepartmentId(),
                                crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
                                crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
                                crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
                                crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), crd.getModuleId()); // expense : departmental coa
                    } //posisi credit - pph 21, ppn
                    else {
                        DbGl.postJournalDetail(er.getValueIdr(), crd.getCoaId(), crd.getCreditAmount(), 0,
                                0, comp.getBookingCurrencyId(), oid, crd.getMemo(), crd.getDepartmentId(),
                                crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
                                crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
                                crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
                                crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), crd.getModuleId()); // ppn/pph : departmental coa
                    }
                }

                //journal credit pada suspense account atau untuk kasbon credit pada kas
                DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), cr.getAmount(), 0,
                        0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0); // petty cash : non departmental coa
            }

            //update status
            if (oid != 0) {
                try {
                    cr.setPostedStatus(1);
                    cr.setPostedById(userId);
                    cr.setPostedDate(new Date());
                    cr.setStatus(DbPettycashPayment.STATUS_TYPE_POSTED);

                    Date dt = new Date();
                    String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                            DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                            DbPeriode.colNames[DbPeriode.COL_END_DATE];

                    Vector temp = DbPeriode.list(0, 0, where, "");

                    if (temp != null && temp.size() > 0) {
                        cr.setEffectiveDate(new Date());
                    } else {
                        Periode per = DbPeriode.getOpenPeriod();
                        if (cr.getPeriodeId() != 0) {
                            per = DbPeriode.fetchExc(cr.getPeriodeId());
                        }
                        cr.setEffectiveDate(per.getEndDate());
                    }

                    DbPettycashPayment.updateExc(cr);

                } catch (Exception e) {
                    System.out.println("[exception]" + e.toString());
                }
            }
        }
    }

    public static void postActivityStatus(long oidFlag, long oidPettyCashPayment) {
        try {

            PettycashPayment pp = DbPettycashPayment.fetchExc(oidPettyCashPayment);
            if (oidFlag == 0) {
                pp.setActivityStatus(I_Project.STATUS_NOT_POSTED);
            } else {
                pp.setActivityStatus(I_Project.STATUS_POSTED);
            }
            DbPettycashPayment.updateExc(pp);

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

    }

    public static void getUpdateTotalAmount(long oid) {
        String sql = "";
        CONResultSet crs = null;
        double amount = 0;
        try {

            sql = " SELECT sum(" + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_AMOUNT] + ")- " +
                    " sum(" + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_CREDIT_AMOUNT] + ")" +
                    " FROM " +
                    DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL + " p where " +
                    DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + "=" + oid;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                amount = rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        PettycashPayment pp = new PettycashPayment();
        try {
            pp = DbPettycashPayment.fetchExc(oid);
            pp.setAmount(amount);
            DbPettycashPayment.updateExc(pp);
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
    }

    public static String getNomorReferensi(long pettycashPaymentId) {
        CONResultSet crs = null;
        try {
            String sql = "SELECT " + DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER] +
                    " FROM " + DbPettycashPayment.DB_PETTYCASH_PAYMENT + " WHERE " +
                    DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID] + "=" + pettycashPaymentId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                String jurNum = rs.getString(1);
                return jurNum;
            }

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return "";
    }

    public static Vector listKasbon(String noJurnal, String pegawai, String vamount) {
        CONResultSet crs = null;
        try {

            String sql = "SELECT PAY." +DbPettycashPayment.colNames[DbPettycashPayment.COL_PETTYCASH_PAYMENT_ID]+" as petycashId,"+
                    " PAY."+DbPettycashPayment.colNames[DbPettycashPayment.COL_PAYMENT_TO]+" as paymentTo,"+
                    " PAY."+DbPettycashPayment.colNames[DbPettycashPayment.COL_EMPLOYEE_ID]+" as employeeId,"+
                    " PAY."+DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER]+" as jurNum,"+
                    " PAY."+DbPettycashPayment.colNames[DbPettycashPayment.COL_STATUS]+" as status,"+
                    " PAY."+DbPettycashPayment.colNames[DbPettycashPayment.COL_AMOUNT]+" as amount "+
                    " FROM " + DbPettycashPayment.DB_PETTYCASH_PAYMENT + " PAY INNER JOIN " + DbEmployee.CON_EMPLOYEE + " EMP ON PAY." +
                    DbPettycashPayment.colNames[DbPettycashPayment.COL_EMPLOYEE_ID] + " = EMP." + DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID]+
                    
                    " WHERE "+" PAY."+DbPettycashPayment.colNames[DbPettycashPayment.COL_TYPE] + "=" + DbPettycashPayment.STATUS_TYPE_KASBON +
						" and PAY."+DbPettycashPayment.colNames[DbPettycashPayment.COL_POSTED_STATUS] + " = 1 ";

            if (noJurnal.length() > 0) {
                sql = sql + " AND PAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_JOURNAL_NUMBER] + " like '%" + noJurnal + "%'";
            }

            if (pegawai.length() > 0) {
                sql = sql + " AND EMP." + DbEmployee.colNames[DbEmployee.COL_NAME] + " like '%" + pegawai + "%' ";
            }

            if (vamount.length() > 0) {
                try {
                    if (sql.length() > 0) {
                        sql = sql + " and ";
                    }

                    StringTokenizer strTokenizerOutputDeliver = new StringTokenizer(vamount, ",");
                    String _amount = "";
                    while (strTokenizerOutputDeliver.hasMoreTokens()) {
                        _amount = _amount + strTokenizerOutputDeliver.nextToken();
                    }

                    StringTokenizer strTokenizeramount = new StringTokenizer(_amount, ".");
                    String amount_ = "";

                    while (strTokenizeramount.hasMoreTokens()) {
                        amount_ = amount_ + strTokenizeramount.nextToken();
                    }
                    
                    sql = sql + " PAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_AMOUNT] + " like '%" + vamount + "%'";
                } catch (Exception e) {
                    sql = sql + " PAY." + DbPettycashPayment.colNames[DbPettycashPayment.COL_AMOUNT] + " = '" + vamount + "'";
                }

            }
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            Vector result = new Vector();
            
            while (rs.next()) {
                
                PettycashPayment pet = new PettycashPayment();
                pet.setOID(rs.getLong("petycashId"));
                pet.setEmployeeId(rs.getLong("employeeId"));
                pet.setPaymentTo(rs.getString("paymentTo"));
                pet.setJournalNumber(rs.getString("jurNum"));
                pet.setAmount(rs.getDouble("amount"));
                pet.setStatus(rs.getInt("status"));
                result.add(pet);
            }

            return result;
            
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    /**
     * Modul untuk mencari jumlah transaksi dari menu pencarian di dashboard
     * create by gwawan 201209
     * @param sNumber
     * @param sNote
     * @param sAmount
     * @param sCoa
     * @return
     */
    public static int getCountDashboard(String sNumber, String sNote, String sAmount, String sCoa) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(DISTINCT " + DB_PETTYCASH_PAYMENT + "." + colNames[COL_PETTYCASH_PAYMENT_ID] + ")" +
                    " FROM " + DB_PETTYCASH_PAYMENT + " INNER JOIN " + DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL +
                    " ON " + DB_PETTYCASH_PAYMENT + "." + colNames[COL_PETTYCASH_PAYMENT_ID] +
                    " = " + DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL + "." + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] +
                    " INNER JOIN " + DbCoa.DB_COA +
                    " ON " + DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL + "." + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_COA_ID] +
                    " = " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_COA_ID];
            
            String whereClause = "";
            
            if(sNumber != null && sNumber.length() > 0) {
                whereClause = DB_PETTYCASH_PAYMENT + "." + colNames[COL_JOURNAL_NUMBER] + " LIKE '%" + sNumber + "%'";
            }
            
            if(sNote != null && sNote.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DB_PETTYCASH_PAYMENT + "." + colNames[COL_MEMO] + " LIKE '%" + sNote + "%'" +
                        " OR " + DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL + "." + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_MEMO] + " LIKE '%" + sNote + "%')";
            }
            
            if(sAmount != null && sAmount.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += DB_PETTYCASH_PAYMENT + "." + colNames[COL_AMOUNT] + " LIKE '%" + sAmount + "%'";
            }
            
            if(sCoa != null && sCoa.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_CODE] + " LIKE '%" + sCoa + "%'" +
                        " OR " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_NAME] + " LIKE '%" + sCoa + "%')";
            }
            
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
    
    /**
     * Modul untuk mencari daftar transaksi dari menu pencarian di dashboard
     * create by gwawan 201209
     * @param limitStart
     * @param recordToGet
     * @param sNumber
     * @param sNote
     * @param sAmount
     * @param sCoa
     * @param order
     * @return
     */
    public static Vector listDashboard(int limitStart, int recordToGet, String sNumber, String sNote, String sAmount, String sCoa, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT DISTINCT " + DB_PETTYCASH_PAYMENT + ".* FROM " + DB_PETTYCASH_PAYMENT +
                    " INNER JOIN " + DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL +
                    " ON " + DB_PETTYCASH_PAYMENT + "." + colNames[COL_PETTYCASH_PAYMENT_ID] +
                    " = " + DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL + "." + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] +
                    " INNER JOIN " + DbCoa.DB_COA +
                    " ON " + DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL + "." + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_COA_ID] +
                    " = " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_COA_ID];
            
            String whereClause = "";
            
            if(sNumber != null && sNumber.length() > 0) {
                whereClause = DB_PETTYCASH_PAYMENT + "." + colNames[COL_JOURNAL_NUMBER] + " LIKE '%" + sNumber + "%'";
            }
            
            if(sNote != null && sNote.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DB_PETTYCASH_PAYMENT + "." + colNames[COL_MEMO] + " LIKE '%" + sNote + "%'" +
                        " OR " + DbPettycashPaymentDetail.DB_PETTYCASH_PAYMENT_DETAIL + "." + DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_MEMO] + " LIKE '%" + sNote + "%')";
            }
            
            if(sAmount != null && sAmount.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += DB_PETTYCASH_PAYMENT + "." + colNames[COL_AMOUNT] + " LIKE '%" + sAmount + "%'";
            }
            
            if(sCoa != null && sCoa.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_CODE] + " LIKE '%" + sCoa + "%'" +
                        " OR " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_NAME] + " LIKE '%" + sCoa + "%')";
            }
            
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
                PettycashPayment pettycashpayment = new PettycashPayment();
                resultToObject(rs, pettycashpayment);
                lists.add(pettycashpayment);
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
}
