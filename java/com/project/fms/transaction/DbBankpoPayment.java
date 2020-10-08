package com.project.fms.transaction;

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
import com.project.util.*;
import com.project.*;
import com.project.general.Currency;
import com.project.general.DbCurrency;
import com.project.system.*;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;
import com.project.ccs.postransaction.receiving.*;
import com.project.fms.session.SessReportBudgetSuplier;

public class DbBankpoPayment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BANKPO_PAYMENT = "bankpo_payment";
    public static final int COL_BANKPO_PAYMENT_ID = 0;
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
    public static final int COL_REF_NUMBER = 11;
    public static final int COL_VENDOR_ID = 12;
    public static final int COL_CURRENCY_ID = 13;
    public static final int COL_PAYMENT_METHOD = 14;
    public static final int COL_PAYMENT_METHOD_ID = 15;
    public static final int COL_STATUS = 16;
    //add by Roy Andika
    public static final int COL_POSTED_STATUS = 17;
    public static final int COL_POSTED_BY_ID = 18;
    public static final int COL_POSTED_DATE = 19;
    public static final int COL_EFFECTIVE_DATE = 20;
    public static final int COL_TYPE = 21;
    public static final int COL_CUSTOMER_ID = 22;
    //eka    	
    public static final int COL_SEGMENT1_ID = 23;
    public static final int COL_SEGMENT2_ID = 24;
    public static final int COL_SEGMENT3_ID = 25;
    public static final int COL_SEGMENT4_ID = 26;
    public static final int COL_SEGMENT5_ID = 27;
    public static final int COL_SEGMENT6_ID = 28;
    public static final int COL_SEGMENT7_ID = 29;
    public static final int COL_SEGMENT8_ID = 30;
    public static final int COL_SEGMENT9_ID = 31;
    public static final int COL_SEGMENT10_ID = 32;
    public static final int COL_SEGMENT11_ID = 33;
    public static final int COL_SEGMENT12_ID = 34;
    public static final int COL_SEGMENT13_ID = 35;
    public static final int COL_SEGMENT14_ID = 36;
    public static final int COL_SEGMENT15_ID = 37;
    public static final int COL_PERIODE_ID = 38;
    public static final int COL_REF_ID = 39;
    public static final int COL_DUE_DATE_BG = 40;
    
    public static final String[] colNames = {
        "bankpo_payment_id",
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
        "ref_number",
        "vendor_id",
        "currency_id",
        "payment_method",
        "payment_method_id",
        "status",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "effective_date",
        "type",
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
        "segment15_id",
        "periode_id",
        "ref_id",
        "due_date"
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
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
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
        TYPE_LONG,
        TYPE_DATE
    };
    public static final String STATUS_DRAFT = "Draft";
    public static final String STATUS_APPROVE = "Approve";
    public static final String STATUS_POSTED = "Posted";
    public static final String STATUS_PARTIALY_PAID = "Partialy Paid";
    public static final String STATUS_PAID = "Paid";
    
    public static final String TYPE_ORDER_PEMBELIAN = "0";
    public static final String TYPE_PEMBELIAN_TUNAI = "1";
    
    public static final String TYPE_PENGAKUAN_BIAYA = "0";
    public static final String TYPE_PEMBAYARAN_BANK = "1";
    
    public static final int TYPE_DRAFT = 0;
    public static final int TYPE_APPROVE = 1;
    public static final int TYPE_POSTED = 2;
    public static final int TYPE_PAID = 3;
    public static final int TYPE_DROP_OUT = 4;

    public DbBankpoPayment() {
    }

    public DbBankpoPayment(int i) throws CONException {
        super(new DbBankpoPayment());
    }

    public DbBankpoPayment(String sOid) throws CONException {
        super(new DbBankpoPayment(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBankpoPayment(long lOid) throws CONException {
        super(new DbBankpoPayment(0));
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
        return DB_BANKPO_PAYMENT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBankpoPayment().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BankpoPayment bankpopayment = fetchExc(ent.getOID());
        ent = (Entity) bankpopayment;
        return bankpopayment.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BankpoPayment) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BankpoPayment) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BankpoPayment fetchExc(long oid) throws CONException {
        try {
            BankpoPayment bankpopayment = new BankpoPayment();
            DbBankpoPayment pstBankpoPayment = new DbBankpoPayment(oid);
            bankpopayment.setOID(oid);

            bankpopayment.setCoaId(pstBankpoPayment.getlong(COL_COA_ID));
            bankpopayment.setJournalNumber(pstBankpoPayment.getString(COL_JOURNAL_NUMBER));
            bankpopayment.setJournalCounter(pstBankpoPayment.getInt(COL_JOURNAL_COUNTER));
            bankpopayment.setJournalPrefix(pstBankpoPayment.getString(COL_JOURNAL_PREFIX));
            bankpopayment.setDate(pstBankpoPayment.getDate(COL_DATE));
            bankpopayment.setTransDate(pstBankpoPayment.getDate(COL_TRANS_DATE));
            bankpopayment.setMemo(pstBankpoPayment.getString(COL_MEMO));
            bankpopayment.setOperatorId(pstBankpoPayment.getlong(COL_OPERATOR_ID));
            bankpopayment.setOperatorName(pstBankpoPayment.getString(COL_OPERATOR_NAME));
            bankpopayment.setAmount(pstBankpoPayment.getdouble(COL_AMOUNT));
            bankpopayment.setRefNumber(pstBankpoPayment.getString(COL_REF_NUMBER));
            bankpopayment.setVendorId(pstBankpoPayment.getlong(COL_VENDOR_ID));
            bankpopayment.setCurrencyId(pstBankpoPayment.getlong(COL_CURRENCY_ID));
            bankpopayment.setPaymentMethod(pstBankpoPayment.getString(COL_PAYMENT_METHOD));
            bankpopayment.setPaymentMethodId(pstBankpoPayment.getlong(COL_PAYMENT_METHOD_ID));
            bankpopayment.setStatus(pstBankpoPayment.getString(COL_STATUS));
            bankpopayment.setPostedStatus(pstBankpoPayment.getInt(COL_POSTED_STATUS));
            bankpopayment.setPostedById(pstBankpoPayment.getlong(COL_POSTED_BY_ID));
            bankpopayment.setPostedDate(pstBankpoPayment.getDate(COL_POSTED_DATE));
            bankpopayment.setEffectiveDate(pstBankpoPayment.getDate(COL_EFFECTIVE_DATE));
            bankpopayment.setType(pstBankpoPayment.getInt(COL_TYPE));
            bankpopayment.setCustomerId(pstBankpoPayment.getlong(COL_CUSTOMER_ID));
            bankpopayment.setSegment1Id(pstBankpoPayment.getlong(COL_SEGMENT1_ID));
            bankpopayment.setSegment2Id(pstBankpoPayment.getlong(COL_SEGMENT2_ID));
            bankpopayment.setSegment3Id(pstBankpoPayment.getlong(COL_SEGMENT3_ID));
            bankpopayment.setSegment4Id(pstBankpoPayment.getlong(COL_SEGMENT4_ID));
            bankpopayment.setSegment5Id(pstBankpoPayment.getlong(COL_SEGMENT5_ID));
            bankpopayment.setSegment6Id(pstBankpoPayment.getlong(COL_SEGMENT6_ID));
            bankpopayment.setSegment7Id(pstBankpoPayment.getlong(COL_SEGMENT7_ID));
            bankpopayment.setSegment8Id(pstBankpoPayment.getlong(COL_SEGMENT8_ID));
            bankpopayment.setSegment9Id(pstBankpoPayment.getlong(COL_SEGMENT9_ID));
            bankpopayment.setSegment10Id(pstBankpoPayment.getlong(COL_SEGMENT10_ID));
            bankpopayment.setSegment11Id(pstBankpoPayment.getlong(COL_SEGMENT11_ID));
            bankpopayment.setSegment12Id(pstBankpoPayment.getlong(COL_SEGMENT12_ID));
            bankpopayment.setSegment13Id(pstBankpoPayment.getlong(COL_SEGMENT13_ID));
            bankpopayment.setSegment14Id(pstBankpoPayment.getlong(COL_SEGMENT14_ID));
            bankpopayment.setSegment15Id(pstBankpoPayment.getlong(COL_SEGMENT15_ID));
            bankpopayment.setPeriodeId(pstBankpoPayment.getlong(COL_PERIODE_ID));
            bankpopayment.setRefId(pstBankpoPayment.getlong(COL_REF_ID));
            bankpopayment.setDueDateBG(pstBankpoPayment.getDate(COL_DUE_DATE_BG));

            return bankpopayment;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoPayment(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BankpoPayment bankpopayment) throws CONException {
        try {
            DbBankpoPayment pstBankpoPayment = new DbBankpoPayment(0);

            pstBankpoPayment.setLong(COL_COA_ID, bankpopayment.getCoaId());
            pstBankpoPayment.setString(COL_JOURNAL_NUMBER, bankpopayment.getJournalNumber());
            pstBankpoPayment.setInt(COL_JOURNAL_COUNTER, bankpopayment.getJournalCounter());
            pstBankpoPayment.setString(COL_JOURNAL_PREFIX, bankpopayment.getJournalPrefix());
            pstBankpoPayment.setDate(COL_DATE, bankpopayment.getDate());
            pstBankpoPayment.setDate(COL_TRANS_DATE, bankpopayment.getTransDate());
            pstBankpoPayment.setString(COL_MEMO, bankpopayment.getMemo());
            pstBankpoPayment.setLong(COL_OPERATOR_ID, bankpopayment.getOperatorId());
            pstBankpoPayment.setString(COL_OPERATOR_NAME, bankpopayment.getOperatorName());
            pstBankpoPayment.setDouble(COL_AMOUNT, bankpopayment.getAmount());
            pstBankpoPayment.setString(COL_REF_NUMBER, bankpopayment.getRefNumber());
            pstBankpoPayment.setLong(COL_VENDOR_ID, bankpopayment.getVendorId());
            pstBankpoPayment.setLong(COL_CURRENCY_ID, bankpopayment.getCurrencyId());
            pstBankpoPayment.setString(COL_PAYMENT_METHOD, bankpopayment.getPaymentMethod());
            pstBankpoPayment.setLong(COL_PAYMENT_METHOD_ID, bankpopayment.getPaymentMethodId());
            pstBankpoPayment.setString(COL_STATUS, bankpopayment.getStatus());
            pstBankpoPayment.setInt(COL_POSTED_STATUS, bankpopayment.getPostedStatus());
            pstBankpoPayment.setLong(COL_POSTED_BY_ID, bankpopayment.getPostedById());
            pstBankpoPayment.setDate(COL_POSTED_DATE, bankpopayment.getPostedDate());
            pstBankpoPayment.setDate(COL_EFFECTIVE_DATE, bankpopayment.getEffectiveDate());
            pstBankpoPayment.setInt(COL_TYPE, bankpopayment.getType());
            pstBankpoPayment.setLong(COL_CUSTOMER_ID, bankpopayment.getCustomerId());
            pstBankpoPayment.setLong(COL_SEGMENT1_ID, bankpopayment.getSegment1Id());
            pstBankpoPayment.setLong(COL_SEGMENT2_ID, bankpopayment.getSegment2Id());
            pstBankpoPayment.setLong(COL_SEGMENT3_ID, bankpopayment.getSegment3Id());
            pstBankpoPayment.setLong(COL_SEGMENT4_ID, bankpopayment.getSegment4Id());
            pstBankpoPayment.setLong(COL_SEGMENT5_ID, bankpopayment.getSegment5Id());
            pstBankpoPayment.setLong(COL_SEGMENT6_ID, bankpopayment.getSegment6Id());
            pstBankpoPayment.setLong(COL_SEGMENT7_ID, bankpopayment.getSegment7Id());
            pstBankpoPayment.setLong(COL_SEGMENT8_ID, bankpopayment.getSegment8Id());
            pstBankpoPayment.setLong(COL_SEGMENT9_ID, bankpopayment.getSegment9Id());
            pstBankpoPayment.setLong(COL_SEGMENT10_ID, bankpopayment.getSegment10Id());
            pstBankpoPayment.setLong(COL_SEGMENT11_ID, bankpopayment.getSegment11Id());
            pstBankpoPayment.setLong(COL_SEGMENT12_ID, bankpopayment.getSegment12Id());
            pstBankpoPayment.setLong(COL_SEGMENT13_ID, bankpopayment.getSegment13Id());
            pstBankpoPayment.setLong(COL_SEGMENT14_ID, bankpopayment.getSegment14Id());
            pstBankpoPayment.setLong(COL_SEGMENT15_ID, bankpopayment.getSegment15Id());
            pstBankpoPayment.setLong(COL_PERIODE_ID, bankpopayment.getPeriodeId());
            pstBankpoPayment.setLong(COL_REF_ID, bankpopayment.getRefId());
            pstBankpoPayment.setDate(COL_DUE_DATE_BG, bankpopayment.getDueDateBG());

            pstBankpoPayment.insert();
            bankpopayment.setOID(pstBankpoPayment.getlong(COL_BANKPO_PAYMENT_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoPayment(0), CONException.UNKNOWN);
        }
        return bankpopayment.getOID();
    }

    public static long updateExc(BankpoPayment bankpopayment) throws CONException {
        try {
            if (bankpopayment.getOID() != 0) {
                DbBankpoPayment pstBankpoPayment = new DbBankpoPayment(bankpopayment.getOID());

                pstBankpoPayment.setLong(COL_COA_ID, bankpopayment.getCoaId());
                pstBankpoPayment.setString(COL_JOURNAL_NUMBER, bankpopayment.getJournalNumber());
                pstBankpoPayment.setInt(COL_JOURNAL_COUNTER, bankpopayment.getJournalCounter());
                pstBankpoPayment.setString(COL_JOURNAL_PREFIX, bankpopayment.getJournalPrefix());
                pstBankpoPayment.setDate(COL_DATE, bankpopayment.getDate());
                pstBankpoPayment.setDate(COL_TRANS_DATE, bankpopayment.getTransDate());
                pstBankpoPayment.setString(COL_MEMO, bankpopayment.getMemo());
                pstBankpoPayment.setLong(COL_OPERATOR_ID, bankpopayment.getOperatorId());
                pstBankpoPayment.setString(COL_OPERATOR_NAME, bankpopayment.getOperatorName());
                pstBankpoPayment.setDouble(COL_AMOUNT, bankpopayment.getAmount());
                pstBankpoPayment.setString(COL_REF_NUMBER, bankpopayment.getRefNumber());
                pstBankpoPayment.setLong(COL_VENDOR_ID, bankpopayment.getVendorId());
                pstBankpoPayment.setLong(COL_CURRENCY_ID, bankpopayment.getCurrencyId());
                pstBankpoPayment.setString(COL_PAYMENT_METHOD, bankpopayment.getPaymentMethod());
                pstBankpoPayment.setLong(COL_PAYMENT_METHOD_ID, bankpopayment.getPaymentMethodId());
                pstBankpoPayment.setString(COL_STATUS, bankpopayment.getStatus());
                pstBankpoPayment.setInt(COL_POSTED_STATUS, bankpopayment.getPostedStatus());
                pstBankpoPayment.setLong(COL_POSTED_BY_ID, bankpopayment.getPostedById());
                pstBankpoPayment.setDate(COL_POSTED_DATE, bankpopayment.getPostedDate());
                pstBankpoPayment.setDate(COL_EFFECTIVE_DATE, bankpopayment.getEffectiveDate());
                pstBankpoPayment.setInt(COL_TYPE, bankpopayment.getType());
                pstBankpoPayment.setLong(COL_CUSTOMER_ID, bankpopayment.getCustomerId());
                pstBankpoPayment.setLong(COL_SEGMENT1_ID, bankpopayment.getSegment1Id());
                pstBankpoPayment.setLong(COL_SEGMENT2_ID, bankpopayment.getSegment2Id());
                pstBankpoPayment.setLong(COL_SEGMENT3_ID, bankpopayment.getSegment3Id());
                pstBankpoPayment.setLong(COL_SEGMENT4_ID, bankpopayment.getSegment4Id());
                pstBankpoPayment.setLong(COL_SEGMENT5_ID, bankpopayment.getSegment5Id());
                pstBankpoPayment.setLong(COL_SEGMENT6_ID, bankpopayment.getSegment6Id());
                pstBankpoPayment.setLong(COL_SEGMENT7_ID, bankpopayment.getSegment7Id());
                pstBankpoPayment.setLong(COL_SEGMENT8_ID, bankpopayment.getSegment8Id());
                pstBankpoPayment.setLong(COL_SEGMENT9_ID, bankpopayment.getSegment9Id());
                pstBankpoPayment.setLong(COL_SEGMENT10_ID, bankpopayment.getSegment10Id());
                pstBankpoPayment.setLong(COL_SEGMENT11_ID, bankpopayment.getSegment11Id());
                pstBankpoPayment.setLong(COL_SEGMENT12_ID, bankpopayment.getSegment12Id());
                pstBankpoPayment.setLong(COL_SEGMENT13_ID, bankpopayment.getSegment13Id());
                pstBankpoPayment.setLong(COL_SEGMENT14_ID, bankpopayment.getSegment14Id());
                pstBankpoPayment.setLong(COL_SEGMENT15_ID, bankpopayment.getSegment15Id());
                pstBankpoPayment.setLong(COL_PERIODE_ID, bankpopayment.getPeriodeId());
                pstBankpoPayment.setLong(COL_REF_ID, bankpopayment.getRefId());
                pstBankpoPayment.setDate(COL_DUE_DATE_BG, bankpopayment.getDueDateBG());

                pstBankpoPayment.update();
                return bankpopayment.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoPayment(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBankpoPayment pstBankpoPayment = new DbBankpoPayment(oid);
            pstBankpoPayment.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoPayment(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BANKPO_PAYMENT;
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
                BankpoPayment bankpopayment = new BankpoPayment();
                resultToObject(rs, bankpopayment);
                lists.add(bankpopayment);
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

    private static void resultToObject(ResultSet rs, BankpoPayment bankpopayment) {
        try {
            bankpopayment.setOID(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]));
            bankpopayment.setCoaId(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_COA_ID]));
            bankpopayment.setJournalNumber(rs.getString(DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER]));
            bankpopayment.setJournalCounter(rs.getInt(DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_COUNTER]));
            bankpopayment.setJournalPrefix(rs.getString(DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_PREFIX]));
            bankpopayment.setDate(rs.getDate(DbBankpoPayment.colNames[DbBankpoPayment.COL_DATE]));
            bankpopayment.setTransDate(rs.getDate(DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE]));
            bankpopayment.setMemo(rs.getString(DbBankpoPayment.colNames[DbBankpoPayment.COL_MEMO]));
            bankpopayment.setOperatorId(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_OPERATOR_ID]));
            bankpopayment.setOperatorName(rs.getString(DbBankpoPayment.colNames[DbBankpoPayment.COL_OPERATOR_NAME]));
            bankpopayment.setAmount(rs.getDouble(DbBankpoPayment.colNames[DbBankpoPayment.COL_AMOUNT]));
            bankpopayment.setRefNumber(rs.getString(DbBankpoPayment.colNames[DbBankpoPayment.COL_REF_NUMBER]));
            bankpopayment.setVendorId(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_VENDOR_ID]));
            bankpopayment.setCurrencyId(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_CURRENCY_ID]));
            bankpopayment.setPaymentMethod(rs.getString(DbBankpoPayment.colNames[DbBankpoPayment.COL_PAYMENT_METHOD]));
            bankpopayment.setPaymentMethodId(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_PAYMENT_METHOD_ID]));
            bankpopayment.setStatus(rs.getString(DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS]));
            bankpopayment.setPostedStatus(rs.getInt(DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS]));
            bankpopayment.setPostedById(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_BY_ID]));
            bankpopayment.setPostedDate(rs.getDate(DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_DATE]));
            bankpopayment.setEffectiveDate(rs.getDate(DbBankpoPayment.colNames[DbBankpoPayment.COL_EFFECTIVE_DATE]));
            bankpopayment.setType(rs.getInt(DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE]));
            bankpopayment.setCustomerId(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_CUSTOMER_ID]));
            bankpopayment.setSegment1Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT1_ID]));
            bankpopayment.setSegment2Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT2_ID]));
            bankpopayment.setSegment3Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT3_ID]));
            bankpopayment.setSegment4Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT4_ID]));
            bankpopayment.setSegment5Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT5_ID]));
            bankpopayment.setSegment6Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT6_ID]));
            bankpopayment.setSegment7Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT7_ID]));
            bankpopayment.setSegment8Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT8_ID]));
            bankpopayment.setSegment9Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT9_ID]));
            bankpopayment.setSegment10Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT10_ID]));
            bankpopayment.setSegment11Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT11_ID]));
            bankpopayment.setSegment12Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT12_ID]));
            bankpopayment.setSegment13Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT13_ID]));
            bankpopayment.setSegment14Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT14_ID]));
            bankpopayment.setSegment15Id(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_SEGMENT15_ID]));
            bankpopayment.setPeriodeId(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_PERIODE_ID]));
            bankpopayment.setRefId(rs.getLong(DbBankpoPayment.colNames[DbBankpoPayment.COL_REF_ID]));
            bankpopayment.setDueDateBG(rs.getDate(DbBankpoPayment.colNames[DbBankpoPayment.COL_DUE_DATE_BG]));

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
    }

    public static boolean checkOID(long bankpoPaymentId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BANKPO_PAYMENT + " WHERE " +
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + " = " + bankpoPaymentId;

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
            String sql = "SELECT COUNT(" + DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + ") FROM " + DB_BANKPO_PAYMENT;
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
                    BankpoPayment bankpopayment = (BankpoPayment) list.get(ls);
                    if (oid == bankpopayment.getOID()) {
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

    public static double getPaymentByPeriod(Periode openPeriod, long coaId) {

        double result = 0;
        CONResultSet crs = null;

        try {
            String sql = "select sum(" + colNames[COL_AMOUNT] + ") from " + DB_BANKPO_PAYMENT +
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

    public static int getNextCounter(long oid) {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(journal_counter) from " + DB_BANKPO_PAYMENT + " where " +
                    " journal_prefix='" + getNumberPrefix(oid) + "' ";

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

    public static String getNumberPrefix(long oid) {

        Company sysCompany = DbCompany.getCompany();
        Location sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());

        String code = sysLocation.getCode();

        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(oid);
        } catch (Exception e) {
        }

        if (coa.getIsNeedExtra() == 1) {
            code = code + coa.getCreditPrefixCode();
        } else {
            code = code + sysCompany.getBankPaymentPoCode();
        }

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }

    public static String getNextNumber(int ctr, long oid) {

        String code = getNumberPrefix(oid);

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

    public static double getTotalPaymentByInvoice(long invoiceId) {
        double result = 0;
        CONResultSet crs = null;
        try {
            String sql = "select sum(" + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] + ") from " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL +
                    " where " + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + "=" + invoiceId;

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

    public static double getTotInvoice(long recOID) {
        double result = 0;

        Receive r = new Receive();
        try {
            r = DbReceive.fetchExc(recOID);
            String where = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + " = " + recOID + " and " + DbReceiveItem.colNames[DbReceiveItem.COL_IS_BONUS] + " = " + DbReceiveItem.NON_BONUS;
            Vector vRD = DbReceiveItem.list(0, 0, where, null);
            if (vRD != null && vRD.size() > 0) {
                double subTotal = DbReceiveItem.getTotalReceiveAmount(recOID);
                for (int i = 0; i < vRD.size(); i++) {
                    ReceiveItem ri = new ReceiveItem();
                    ri = (ReceiveItem) vRD.get(i);
                    double summary = 0;
                    summary = ri.getTotalAmount();

                    if (r.getDiscountTotal() != 0) {
                        summary = ri.getTotalAmount() - ((ri.getTotalAmount() / subTotal) * r.getDiscountTotal());
                    }

                    result = result + summary;
                }

                result = result + r.getTotalTax();
            }
        } catch (Exception e) {
        }
        return result;
    }

    public static void checkForClosed(Vector bpoDetails) {
        if (bpoDetails != null && bpoDetails.size() > 0) {
            for (int i = 0; i < bpoDetails.size(); i++) {
                BankpoPaymentDetail bpod = (BankpoPaymentDetail) bpoDetails.get(i);

                Receive r = new Receive();
                try {
                    r = DbReceive.fetchExc(bpod.getInvoiceId());
                    double total = DbReceive.getInvoiceBalance(r.getOID());
                    double balanceTotal = DbBankpoPayment.getTotalPaymentByInvoice(bpod.getInvoiceId());

                    int statusPayment = 0;

                    if (total > 0) {
                        if (balanceTotal >= total) {
                            statusPayment = DbReceive.STATUS_FULL_PAID_POSTED;
                        } else {
                            statusPayment = DbReceive.STATUS_PARTIAL_PAID_POSTED;
                        }
                    } else {
                        if (balanceTotal <= total) {
                            statusPayment = DbReceive.STATUS_FULL_PAID_POSTED;
                        } else {
                            statusPayment = DbReceive.STATUS_PARTIAL_PAID_POSTED;
                        }
                    }
                    DbBankpoPaymentDetail.updatePostedPayment(r.getOID(), statusPayment);


                } catch (Exception e) {
                }
            }
        }
    }

    public static double getTotalPaymentPostedByInvoice(long invoiceId) {
        double result = 0;
        CONResultSet crs = null;
        try {
            String sql = "select sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] + ") " +
                    " from " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd on " + DbBankpoPayment.DB_BANKPO_PAYMENT + " bp on " +
                    " bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " = bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] +
                    " where bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + "=" + invoiceId;

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

    public static double getTotalPaymentByInvoiceFin(long invId) {
        double result = 0;
        CONResultSet crs = null;
        try {

            String sql = "SELECT sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] +
                    ") FROM " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd " +
                    " where bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + " = " + invId;

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

    public static double getTotalPaymentByInvoiceFin(long invId, long bpdId) {
        double result = 0;
        CONResultSet crs = null;
        try {

            String sql = "SELECT sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] +
                    ") FROM " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd " +
                    " where bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + " = " + invId + " and " +
                    DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_DETAIL_ID] + " !=  " + bpdId;

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

    public static double getTotalBalance(long invId) {
        double result = 0;
        CONResultSet crs = null;
        try {

            String sql = "SELECT sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] +
                    ") FROM " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd " +
                    " where bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + " = " + invId;

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

    public static double getTotalPaymentByVendor(long vendorId) {
        double result = 0;
        CONResultSet crs = null;
        try {
            String sql = "select " + DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + " from " + DbBankpoPayment.DB_BANKPO_PAYMENT +
                    " where " + DbBankpoPayment.colNames[DbBankpoPayment.COL_VENDOR_ID] + "=" + vendorId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = result + getTotalPayment(rs.getLong(1));
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getTotalPaymentByVendorFin(long vendorId) {
        double result = 0;
        CONResultSet crs = null;
        try {

            String sql = "SELECT sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] +
                    ") FROM " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd " +
                    " inner join " + DbReceive.DB_RECEIVE + " r on r." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] +
                    " = bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] +
                    " where r." + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + " = " + vendorId +
                    " and r." + DbReceive.colNames[DbReceive.COL_STATUS] + "='" + I_Project.DOC_STATUS_CHECKED + "'";

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

    public static double getTotalPayment(long bankpoPayment) {
        double result = 0;
        CONResultSet crs = null;
        try {
            String sql = "select sum(" + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] + ") from " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL +
                    " where " + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + "=" + bankpoPayment;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
                System.out.println(result);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    //dipakai pada terdahulu menggunakan po pada finance
    public static double getTotalInvoice(long vendorId) {

        double result = 0;
        CONResultSet crs = null;
        try {
            String sql = "select sum(" + DbInvoice.colNames[DbInvoice.COL_GRAND_TOTAL] + ") from " + DbInvoice.DB_INVOICE +
                    " where " + DbInvoice.colNames[DbInvoice.COL_VENDOR_ID] + "=" + vendorId + " and " + DbInvoice.colNames[DbInvoice.COL_STATUS] + "<>'Not Posted'";

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

    //dipakai 
    public static double getTotalInvoiceFin(long vendorId) {
        double result = 0;
        CONResultSet crs = null;
        try {
            String sql = "select sum(" + DbReceive.colNames[DbReceive.COL_TOTAL_AMOUNT] + "-" +
                    DbReceive.colNames[DbReceive.COL_DISCOUNT_TOTAL] + "+" +
                    DbReceive.colNames[DbReceive.COL_TOTAL_TAX] +
                    " ) from " + DbReceive.DB_RECEIVE +
                    " where " + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "=" + vendorId +
                    " and " + DbReceive.colNames[DbReceive.COL_STATUS] + "='" + I_Project.DOC_STATUS_CHECKED + "'";

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

    public static long postJournalPembelianTunai(BankpoPayment bankpoPayment, long userId) {

        long oid = 0;
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        String USDCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_USD");

        double excRate = er.getValueIdr();

        if (bankpoPayment.getCurrencyId() != comp.getBookingCurrencyId()) {

            Currency c = new Currency();

            try {
                c = DbCurrency.fetchExc(bankpoPayment.getCurrencyId());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            if (c.getCurrencyCode().equals(USDCODE)) {
                excRate = er.getValueUsd();
            } else {
                excRate = er.getValueEuro();
            }

        }

        Vector bankAccounts = DbAccLink.list(0, 1, "type='" + I_Project.ACC_LINK_GROUP_BANK + "' and location_id=" + comp.getSystemLocation(), "");

        AccLink acBank = new AccLink();

        if (bankAccounts != null && bankAccounts.size() > 0) {
            acBank = (AccLink) bankAccounts.get(0);
        }

        Vector susAccounts = DbAccLink.list(0, 1, "type='" + I_Project.ACC_LINK_GROUP_SUSPENSE_ACCOUNT + "' and location_id=" + comp.getSystemLocation(), "");
        AccLink acSuspense = new AccLink();

        if (susAccounts != null && susAccounts.size() > 0) {
            acSuspense = (AccLink) susAccounts.get(0);
        }

        Vector details = DbBankpoPaymentDetail.list(0, 0, "bankpo_payment_id=" + bankpoPayment.getOID(), "");

        if (bankpoPayment.getOID() != 0 && details != null && details.size() > 0) {

            oid = DbGl.postJournalMain(0, bankpoPayment.getDate(), bankpoPayment.getJournalCounter(), bankpoPayment.getJournalNumber(), bankpoPayment.getJournalPrefix(), I_Project.JOURNAL_TYPE_BANKPAYMENT_PO,
                    bankpoPayment.getMemo(), userId, "", bankpoPayment.getOID(), "", bankpoPayment.getTransDate());

            if (oid != 0) {

                double amount = 0;

                for (int i = 0; i < details.size(); i++) {

                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) details.get(i);

                    Receive rec = new Receive();

                    try {

                        rec = DbReceive.fetchExc(bpd.getInvoiceId());

                        Vector items = DbReceiveItem.list(0, 0, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + rec.getOID(), "");
                        if (items != null && items.size() > 0) {

                            for (int x = 0; x < items.size(); x++) {

                                ReceiveItem ri = (ReceiveItem) items.get(x);

                                amount = ri.getTotalAmount() / rec.getTotalAmount();
                            }
                        }
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }
                }

                //journal credit pada cash/bank
                if (bankpoPayment.getCurrencyId() != comp.getBookingCurrencyId()) {
                    DbGl.postJournalDetail(excRate, bankpoPayment.getCoaId(), excRate * bankpoPayment.getAmount(), 0,
                            bankpoPayment.getAmount(), bankpoPayment.getCurrencyId(), oid, "", 0);
                } else {
                    DbGl.postJournalDetail(excRate, bankpoPayment.getCoaId(), bankpoPayment.getAmount(), 0,
                            bankpoPayment.getAmount(), bankpoPayment.getCurrencyId(), oid, "", 0);
                }
                DbGl.optimizeJournal(oid);

            }

            //update status
            if (oid != 0) {

                try {

                    bankpoPayment.setStatus(STATUS_PAID);

                    bankpoPayment.setPostedStatus(1);
                    bankpoPayment.setPostedById(userId);
                    bankpoPayment.setPostedDate(new Date());

                    Date dt = new Date();
                    String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                            DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                            DbPeriode.colNames[DbPeriode.COL_END_DATE];

                    Vector temp = DbPeriode.list(0, 0, where, "");

                    if (temp != null && temp.size() > 0) {
                        bankpoPayment.setEffectiveDate(new Date());
                    } else {
                        Periode per = DbPeriode.getOpenPeriod();
                        bankpoPayment.setEffectiveDate(per.getEndDate());
                    }

                    DbBankpoPayment.updateExc(bankpoPayment);

                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }

        }

        return oid;
    }
    
    public static long postOnlyUpdateStatus(BankpoPayment bankpoPayment, long userId){
        
        try{
            bankpoPayment = DbBankpoPayment.fetchExc(bankpoPayment.getOID());
            bankpoPayment.setStatus(STATUS_POSTED);
            bankpoPayment.setPostedStatus(1);
            bankpoPayment.setPostedById(userId);
            bankpoPayment.setPostedDate(new Date());

            Date dt = new Date();
            String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                DbPeriode.colNames[DbPeriode.COL_END_DATE];

            Vector temp = DbPeriode.list(0, 0, where, "");

            if (temp != null && temp.size() > 0) {
                bankpoPayment.setEffectiveDate(new Date());
            } else {
                Periode per = DbPeriode.getOpenPeriod();
                if (bankpoPayment.getPeriodeId() != 0) {
                    try {
                        per = DbPeriode.fetchExc(bankpoPayment.getPeriodeId());
                    } catch (Exception e) {}
                }
                bankpoPayment.setEffectiveDate(per.getEndDate());
            }
            DbBankpoPayment.updateExc(bankpoPayment);
        }catch(Exception e){}
        
        return 1;
    }

    //Posting Ke Jurnal
    public static long postJournal(BankpoPayment bankpoPayment, long userId) {

        long oid = 0;
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
        String USDCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_USD");
        double excRate = er.getValueIdr();
        try{
            bankpoPayment = DbBankpoPayment.fetchExc(bankpoPayment.getOID());
        }catch(Exception e){}

        if (bankpoPayment.getCurrencyId() != comp.getBookingCurrencyId()) {

            Currency c = new Currency();
            try {
                c = DbCurrency.fetchExc(bankpoPayment.getCurrencyId());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            if (c.getCurrencyCode().equals(USDCODE)) {
                excRate = er.getValueUsd();
            } else {
                excRate = er.getValueEuro();
            }
        }

        boolean isCoa = true;

        SegmentDetail sd = new SegmentDetail();
        try {
            sd = DbSegmentDetail.fetchExc(bankpoPayment.getSegment1Id());
        } catch (Exception e) {
        }

        Location loc = new Location();
        try {
            loc = DbLocation.fetchExc(sd.getLocationId());
        } catch (Exception e) {
        }

        if (loc.getCoaApId() == 0) {
            isCoa = false;
        }

        if (bankpoPayment.getCoaId() == 0) {
            isCoa = false;
        }

        Vector detailsck = DbBankpoPaymentDetail.list(0, 0, "bankpo_payment_id=" + bankpoPayment.getOID(), "");

        if (detailsck != null && detailsck.size() > 0) {

            for (int ick = 0; ick < detailsck.size(); ick++) {

                BankpoPaymentDetail bpd = (BankpoPaymentDetail) detailsck.get(ick);

                Receive rec = new Receive();

                try {
                    rec = DbReceive.fetchExc(bpd.getInvoiceId());
                    ReceiveItem ri = new ReceiveItem();
                    Vector items = DbReceiveItem.list(0, 1, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + rec.getOID(), "");

                    if (items != null && items.size() > 0) {
                        ri = (ReceiveItem) items.get(0);
                    }
                    if (ri.getApCoaId() == 0) {
                        isCoa = false;
                    }
                } catch (Exception e) {
                }
            }
        }

        Vector details = DbBankpoPaymentDetail.list(0, 0, "bankpo_payment_id=" + bankpoPayment.getOID(), "");

        if (bankpoPayment.getOID() != 0 && details != null && details.size() > 0 && isCoa) {

            oid = DbGl.postJournalMain(0, bankpoPayment.getDate(), bankpoPayment.getJournalCounter(), bankpoPayment.getJournalNumber(), bankpoPayment.getJournalPrefix(), I_Project.JOURNAL_TYPE_BANKPAYMENT_PO,
                    bankpoPayment.getMemo(), userId, "", bankpoPayment.getOID(), "", bankpoPayment.getTransDate(), bankpoPayment.getPeriodeId());

            if (oid != 0) {

                double amount = 0;
                for (int i = 0; i < details.size(); i++) {

                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) details.get(i);
                    Receive rec = new Receive();
                    try {

                        if (bpd.getInvoiceId() != 0) {

                            rec = DbReceive.fetchExc(bpd.getInvoiceId());
                            ReceiveItem ri = new ReceiveItem();
                            Vector items = DbReceiveItem.list(0, 1, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + rec.getOID(), "");
                            if (items != null && items.size() > 0) {
                                ri = (ReceiveItem) items.get(0);
                            }
                            amount = amount + bpd.getPaymentAmount();
                        }
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }
                }

                String memo = "hutang";
                DbGl.postJournalDetail(er.getValueIdr(), loc.getCoaApId(), 0, amount,
                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                        bankpoPayment.getSegment1Id(), 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0);

                //journal credit pada cash/bank
                DbGl.postJournalDetail(excRate, bankpoPayment.getCoaId(), amount, 0,
                        amount, bankpoPayment.getCurrencyId(), oid, "", 0,
                        bankpoPayment.getSegment1Id(), bankpoPayment.getSegment2Id(), bankpoPayment.getSegment3Id(), bankpoPayment.getSegment4Id(),
                        bankpoPayment.getSegment5Id(), bankpoPayment.getSegment6Id(), bankpoPayment.getSegment7Id(), bankpoPayment.getSegment8Id(),
                        bankpoPayment.getSegment9Id(), bankpoPayment.getSegment10Id(), bankpoPayment.getSegment11Id(), bankpoPayment.getSegment12Id(),
                        bankpoPayment.getSegment13Id(), bankpoPayment.getSegment14Id(), bankpoPayment.getSegment15Id(), 0);
                
                DbGl.optimizedJournal(oid);

            }

            //update status
            if (oid != 0) {

                try {

                    bankpoPayment.setStatus(STATUS_POSTED);
                    bankpoPayment.setPostedStatus(1);
                    bankpoPayment.setPostedById(userId);
                    bankpoPayment.setPostedDate(new Date());

                    Date dt = new Date();
                    String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                            DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                            DbPeriode.colNames[DbPeriode.COL_END_DATE];

                    Vector temp = DbPeriode.list(0, 0, where, "");

                    if (temp != null && temp.size() > 0) {
                        bankpoPayment.setEffectiveDate(new Date());
                    } else {
                        Periode per = DbPeriode.getOpenPeriod();
                        if (bankpoPayment.getPeriodeId() != 0) {
                            try {
                                per = DbPeriode.fetchExc(bankpoPayment.getPeriodeId());
                            } catch (Exception e) {
                            }
                        }
                        bankpoPayment.setEffectiveDate(per.getEndDate());
                    }
                    DbBankpoPayment.updateExc(bankpoPayment);

                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
        }
        return oid;
    }

    //Posting Ke Jurnal
    public static long postJournal(BankpoPayment bankpoPayment, long userId, Company comp) {

        long oid = 0;

        ExchangeRate er = DbExchangeRate.getStandardRate();
        String USDCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_USD");
        double excRate = er.getValueIdr();

        if (bankpoPayment.getCurrencyId() != comp.getBookingCurrencyId()) {

            Currency c = new Currency();
            try {
                c = DbCurrency.fetchExc(bankpoPayment.getCurrencyId());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            if (c.getCurrencyCode().equals(USDCODE)) {
                excRate = er.getValueUsd();
            } else {
                excRate = er.getValueIdr();
            }
        }

        boolean isCoa = true;

        SegmentDetail sd = new SegmentDetail();
        try {
            sd = DbSegmentDetail.fetchExc(bankpoPayment.getSegment1Id());
        } catch (Exception e) {
        }

        Location loc = new Location();
        try {
            loc = DbLocation.fetchExc(sd.getLocationId());
        } catch (Exception e) {
        }

        if (loc.getCoaApId() == 0) {
            isCoa = false;
        }

        if (bankpoPayment.getCoaId() == 0) {
            isCoa = false;
        }

        Vector detailsck = DbBankpoPaymentDetail.list(0, 0, "bankpo_payment_id=" + bankpoPayment.getOID(), "");

        if (detailsck != null && detailsck.size() > 0) {

            for (int ick = 0; ick < detailsck.size(); ick++) {

                BankpoPaymentDetail bpd = (BankpoPaymentDetail) detailsck.get(ick);

                Receive rec = new Receive();

                try {
                    rec = DbReceive.fetchExc(bpd.getInvoiceId());
                    ReceiveItem ri = new ReceiveItem();
                    Vector items = DbReceiveItem.list(0, 1, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + rec.getOID(), "");

                    if (items != null && items.size() > 0) {
                        ri = (ReceiveItem) items.get(0);
                    }
                    if (ri.getApCoaId() == 0) {
                        isCoa = false;
                    }
                } catch (Exception e) {
                }
            }
        }

        Vector details = DbBankpoPaymentDetail.list(0, 0, "bankpo_payment_id=" + bankpoPayment.getOID(), "");

        if (bankpoPayment.getOID() != 0 && details != null && details.size() > 0 && isCoa) {

            oid = DbGl.postJournalMain(0, bankpoPayment.getDate(), bankpoPayment.getJournalCounter(), bankpoPayment.getJournalNumber(), bankpoPayment.getJournalPrefix(), I_Project.JOURNAL_TYPE_BANKPAYMENT_PO,
                    bankpoPayment.getMemo(), userId, "", bankpoPayment.getOID(), "", bankpoPayment.getTransDate(), bankpoPayment.getPeriodeId());

            if (oid != 0) {

                double amount = 0;
                for (int i = 0; i < details.size(); i++) {

                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) details.get(i);
                    Receive rec = new Receive();
                    try {

                        if (bpd.getInvoiceId() != 0) {

                            rec = DbReceive.fetchExc(bpd.getInvoiceId());
                            ReceiveItem ri = new ReceiveItem();
                            Vector items = DbReceiveItem.list(0, 1, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + rec.getOID(), "");
                            if (items != null && items.size() > 0) {
                                ri = (ReceiveItem) items.get(0);
                            }
                            amount = amount + bpd.getPaymentAmount();
                        }
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }
                }

                String memo = "hutang";
                DbGl.postJournalDetail(er.getValueIdr(), loc.getCoaApId(), 0, amount,
                        amount, comp.getBookingCurrencyId(), oid, memo, 0,
                        bankpoPayment.getSegment1Id(), 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0,
                        0, 0, 0, 0);

                //journal credit pada cash/bank
                DbGl.postJournalDetail(excRate, bankpoPayment.getCoaId(), amount, 0,
                        amount, bankpoPayment.getCurrencyId(), oid, "", 0,
                        bankpoPayment.getSegment1Id(), bankpoPayment.getSegment2Id(), bankpoPayment.getSegment3Id(), bankpoPayment.getSegment4Id(),
                        bankpoPayment.getSegment5Id(), bankpoPayment.getSegment6Id(), bankpoPayment.getSegment7Id(), bankpoPayment.getSegment8Id(),
                        bankpoPayment.getSegment9Id(), bankpoPayment.getSegment10Id(), bankpoPayment.getSegment11Id(), bankpoPayment.getSegment12Id(),
                        bankpoPayment.getSegment13Id(), bankpoPayment.getSegment14Id(), bankpoPayment.getSegment15Id(), 0);
            //DbGl.optimizedJournal(oid);

            }

            //update status
            if (oid != 0) {

                try {

                    bankpoPayment.setStatus(STATUS_POSTED);
                    bankpoPayment.setPostedStatus(1);
                    bankpoPayment.setPostedById(userId);
                    bankpoPayment.setPostedDate(new Date());

                    Date dt = new Date();
                    String where = "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " +
                            DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " +
                            DbPeriode.colNames[DbPeriode.COL_END_DATE];

                    Vector temp = DbPeriode.list(0, 0, where, "");

                    if (temp != null && temp.size() > 0) {
                        bankpoPayment.setEffectiveDate(new Date());
                    } else {
                        Periode per = DbPeriode.getOpenPeriod();
                        if (bankpoPayment.getPeriodeId() != 0) {
                            try {
                                per = DbPeriode.fetchExc(bankpoPayment.getPeriodeId());
                            } catch (Exception e) {
                            }
                        }
                        bankpoPayment.setEffectiveDate(per.getEndDate());
                    }
                    DbBankpoPayment.updateExc(bankpoPayment);

                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
        }
        return oid;
    }

    public static long postJournal(BankpoPayment bankpoPayment) {

        long oid = 0;
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        String USDCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_USD");
        String EURCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_EUR");

        double excRate = er.getValueIdr();

        if (bankpoPayment.getCurrencyId() != comp.getBookingCurrencyId()) {

            Currency c = new Currency();

            try {
                c = DbCurrency.fetchExc(bankpoPayment.getCurrencyId());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            if (c.getCurrencyCode().equals(USDCODE)) {
                excRate = er.getValueUsd();
            } else {
                excRate = er.getValueEuro();
            }

        }

        Vector bankAccounts = DbAccLink.list(0, 1, "type='" + I_Project.ACC_LINK_GROUP_BANK + "' and location_id=" + comp.getSystemLocation(), "");
        AccLink acBank = new AccLink();
        if (bankAccounts != null && bankAccounts.size() > 0) {
            acBank = (AccLink) bankAccounts.get(0);
        }

        Vector susAccounts = DbAccLink.list(0, 1, "type='" + I_Project.ACC_LINK_GROUP_SUSPENSE_ACCOUNT + "' and location_id=" + comp.getSystemLocation(), "");
        AccLink acSuspense = new AccLink();

        if (susAccounts != null && susAccounts.size() > 0) {
            acSuspense = (AccLink) susAccounts.get(0);
        }

        Vector details = DbBankpoPaymentDetail.list(0, 0, "bankpo_payment_id=" + bankpoPayment.getOID(), "");

        if (bankpoPayment.getOID() != 0 && details != null && details.size() > 0) {

            oid = DbGl.postJournalMain(0, bankpoPayment.getDate(), bankpoPayment.getJournalCounter(), bankpoPayment.getJournalNumber(), bankpoPayment.getJournalPrefix(), I_Project.JOURNAL_TYPE_BANKPAYMENT_PO,
                    bankpoPayment.getMemo(), bankpoPayment.getOperatorId(), bankpoPayment.getOperatorName(), bankpoPayment.getOID(), "", bankpoPayment.getTransDate());

            if (oid != 0) {

                double amount = 0;

                for (int i = 0; i < details.size(); i++) {

                    BankpoPaymentDetail bpd = (BankpoPaymentDetail) details.get(i);

                    Receive rec = new Receive();

                    try {

                        rec = DbReceive.fetchExc(bpd.getInvoiceId());

                        Vector items = DbReceiveItem.list(0, 0, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + rec.getOID(), "");
                        if (items != null && items.size() > 0) {
                            for (int x = 0; x < items.size(); x++) {
                                ReceiveItem ri = (ReceiveItem) items.get(x);
                                amount = ri.getTotalAmount() / rec.getTotalAmount();
                            }
                        }
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }
                }

                //journal credit pada cash/bank
                if (bankpoPayment.getCurrencyId() != comp.getBookingCurrencyId()) {
                    DbGl.postJournalDetail(excRate, bankpoPayment.getCoaId(), excRate * bankpoPayment.getAmount(), 0,
                            bankpoPayment.getAmount(), bankpoPayment.getCurrencyId(), oid, "", 0);
                } else {
                    DbGl.postJournalDetail(excRate, bankpoPayment.getCoaId(), bankpoPayment.getAmount(), 0,
                            bankpoPayment.getAmount(), bankpoPayment.getCurrencyId(), oid, "", 0);
                }

                DbGl.optimizeJournal(oid);

            }

        }

        return oid;
    }

    public static double getTotalPaymentByVendor(long oidVendor, Date startDate, Date endDate) {

        String sql = "SELECT sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT] + ") FROM " + DbReceive.DB_RECEIVE + " pr " +
                " inner join " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd " +
                " on bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] +
                " = pr." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] +
                " inner join " + DB_BANKPO_PAYMENT + " bpp on bpp." + colNames[COL_BANKPO_PAYMENT_ID] +
                " = bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] +
                " where pr." + DbReceive.colNames[DbReceive.COL_STATUS] + "='" + I_Project.DOC_STATUS_CHECKED + "'" +
                //" and pr." + DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS_POSTED] + "=" + DbReceive.STATUS_FULL_PAID_POSTED+
                " and pr." + DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS] + "=" + I_Project.INV_STATUS_FULL_PAID +
                " and pr." + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "=" + oidVendor;

        if (startDate != null && endDate != null) {
            sql = sql + " and (pr." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                    " and pr." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " <= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
        } else if (startDate == null) {
            sql = sql + " and pr." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " >= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";
        } else if (endDate == null) {
            sql = sql + " and pr." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " <= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'";
        }

        double result = 0;
        CONResultSet crs = null;
        try {
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

    public static double getTotalPaymentByVendor(long oidVendor, Date startDate, Date endDate, long unitUsahaId) {

        String sql = "SELECT sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT] + ") FROM " + DbReceive.DB_RECEIVE + " pr " +
                " inner join " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd " +
                " on bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] +
                " = pr." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] +
                " inner join " + DB_BANKPO_PAYMENT + " bpp on bpp." + colNames[COL_BANKPO_PAYMENT_ID] +
                " = bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] +
                " where pr." + DbReceive.colNames[DbReceive.COL_STATUS] + "='" + I_Project.DOC_STATUS_CHECKED + "'" +
                " and pr." + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "=" + oidVendor;

        if (startDate != null && endDate != null) {
            sql = sql + " and (pr." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                    " and pr." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " <= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
        } else if (startDate == null) {
            sql = sql + " and pr." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " >= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";
        } else if (endDate == null) {
            sql = sql + " and pr." + DbReceive.colNames[DbReceive.COL_DUE_DATE] + " <= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'";
        }

        double result = 0;
        CONResultSet crs = null;
        try {
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

    public static void saveAllDetail(BankpoPayment bankpoPayment, Vector listBankpoPaymentDetail) {

        if (listBankpoPaymentDetail != null && listBankpoPaymentDetail.size() > 0) {

            for (int i = 0; i < listBankpoPaymentDetail.size(); i++) {
                BankpoPaymentDetail crd = (BankpoPaymentDetail) listBankpoPaymentDetail.get(i);
                crd.setBankpoPaymentId(bankpoPayment.getOID());

                try {
                    if (crd.getOID() == 0) {
                        DbBankpoPaymentDetail.insertExc(crd);
                    } else {
                        DbBankpoPaymentDetail.updateExc(crd);
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
        }
    }

    public static void postJournalPembayaran(BankpoPayment cr, Vector details, long userId) {

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        try {
            cr = DbBankpoPayment.fetchExc(cr.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        Periode periode = new Periode();
        try {
            periode = DbPeriode.fetchExc(cr.getPeriodeId());
        } catch (Exception e) {}        

        if (periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0 && cr.getOID() != 0 && details != null && details.size() > 0) {

            long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_BANK_PAYMENT,
                    cr.getMemo(), userId, "", cr.getOID(), "", cr.getTransDate(), cr.getPeriodeId());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {

                    BankpoPaymentDetail crd = (BankpoPaymentDetail) details.get(i);
                    //journal debet pada suspense account

                    DbGl.postJournalDetail(er.getValueIdr(), crd.getCoaId(), 0, crd.getPaymentAmount(),
                            0, comp.getBookingCurrencyId(), oid, crd.getMemo(), 0,
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
                    cr.setStatus(DbBankpoPayment.STATUS_PAID);

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
                            try {
                                per = DbPeriode.fetchExc(cr.getPeriodeId());
                            } catch (Exception e) {
                            }
                        }
                        cr.setEffectiveDate(per.getEndDate());
                    }

                    DbBankpoPayment.updateExc(cr);

                } catch (Exception e) {
                    System.out.println("[exception]" + e.toString());
                }
            }
        }
    }

    public static Vector getBudgetSuplier(long suplierId, Date start, Date end, int ignore, int pkp, int nonPkp) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {

            String sql = "select bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " as vendorId " +
                    ",vnd." + DbVendor.colNames[DbVendor.COL_NAME] + " as name " +
                    ",bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " as number " +
                    ",bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " as transDate " +
                    ",sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT] + ") as amount from " +
                    DB_BANKPO_PAYMENT + " bp inner join " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd on bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] +
                    " = bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " inner join " +
                    DbVendor.DB_VENDOR + " vnd on bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = vnd." + DbVendor.colNames[DbVendor.COL_VENDOR_ID] +
                    " where bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + TYPE_PENGAKUAN_BIAYA;

            if (suplierId != 0) {
                sql = sql + " and bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " = " + suplierId;
            }

            if (ignore == 0) {
                sql = sql + " and bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(start, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(end, "yyyy-MM-dd") + "' ";
            }

            if (!(pkp == 1 && nonPkp == 1)) {
                if (pkp == 1) {
                    sql = sql + " and vnd." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 1;
                }
                if (nonPkp == 1) {
                    sql = sql + " and vnd." + DbVendor.colNames[DbVendor.COL_IS_PKP] + " = " + 0;
                }
            }

            sql = sql + " group by bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + ",bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " order by vnd." + DbVendor.colNames[DbVendor.COL_NAME] + ",bp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER];


            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int counter = 1;
            while (rs.next()) {
                SessReportBudgetSuplier bgt = new SessReportBudgetSuplier();
                bgt.setVendorId(rs.getLong("vendorId"));
                bgt.setSuplier(rs.getString("name"));
                bgt.setDivisi("");
                bgt.setNoTT(rs.getString("number"));
                bgt.setValue(rs.getDouble("amount"));
                bgt.setTransDate(rs.getDate("transDate"));
                bgt.setCounter(counter);
                lists.add(bgt);
                counter++;
            }
            return lists;

        } catch (Exception e) {
        }
        return null;
    }

    public static Vector getArchive(int limitStart, int recordToGet, String order, int ignore, int ignoreInput, Date startDate, Date endDate, Date transDate, String number, long periodId, String invoice) {

        CONResultSet dbrs = null;
        Vector lists = new Vector();
        try {

            String sql = " select distinct bpp.* from " + DbBankpoPayment.DB_BANKPO_PAYMENT + " bpp inner join " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd on bpp." +
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + " = bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " inner join " +
                    DbReceive.DB_RECEIVE + " rec on bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + " = rec." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] +
                    " where bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_ORDER_PEMBELIAN;

            if (number != null && number.length() > 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " like '%" + number + "%' ";
            }

            if (periodId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }

                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "' ";
            }

            if (ignore == 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "' ";
            }

            if (ignoreInput == 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_DATE] + " = between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "' ";
            }

            if (invoice != null && invoice.length() > 0) {
                sql = sql + " and rec." + DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + invoice + "%' ";
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
                BankpoPayment bankpopayment = new BankpoPayment();
                resultToObject(rs, bankpopayment);
                lists.add(bankpopayment);
            }

            return lists;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static Vector getArchive(int limitStart, int recordToGet, String order, int ignore, int ignoreInput, Date startDate, Date endDate, Date transDate, String number, long periodId, String invoice, long vendorId) {

        CONResultSet dbrs = null;
        Vector lists = new Vector();
        try {

            String sql = " select distinct bpp.* from " + DbBankpoPayment.DB_BANKPO_PAYMENT + " bpp inner join " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd on bpp." +
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + " = bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " inner join " +
                    DbReceive.DB_RECEIVE + " rec on bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + " = rec." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] +
                    " where bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_ORDER_PEMBELIAN;

            if (number != null && number.length() > 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " like '%" + number + "%' ";
            }

            if (periodId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }

                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "' ";
            }

            if (ignore == 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "' ";
            }

            if (ignoreInput == 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_DATE] + " = between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "' ";
            }

            if (invoice != null && invoice.length() > 0) {
                sql = sql + " and rec." + DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + invoice + "%' ";
            }

            if (vendorId != 0) {
                sql = sql + " and rec." + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "  =" + vendorId;
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
                BankpoPayment bankpopayment = new BankpoPayment();
                resultToObject(rs, bankpopayment);
                lists.add(bankpopayment);
            }

            return lists;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;
    }

    public static int getCountArchive(String order, int ignore, int ignoreInput, Date startDate, Date endDate, Date transDate, String number, long periodId, String invoice) {

        CONResultSet dbrs = null;
        try {

            String sql = " select count(distinct bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + ") from " + DbBankpoPayment.DB_BANKPO_PAYMENT + " bpp inner join " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd on bpp." +
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + " = bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " inner join " +
                    DbReceive.DB_RECEIVE + " rec on bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + " = rec." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] +
                    " where bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_ORDER_PEMBELIAN;

            if (number != null && number.length() > 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " like '%" + number + "%' ";
            }

            if (periodId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }

                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "' ";
            }

            if (ignore == 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "' ";
            }

            if (ignoreInput == 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_DATE] + " = between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "' ";
            }

            if (invoice != null && invoice.length() > 0) {
                sql = sql + " and rec." + DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + invoice + "%' ";
            }

            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static int getCountArchive(String order, int ignore, int ignoreInput, Date startDate, Date endDate, Date transDate, String number, long periodId, String invoice, long vendorId) {

        CONResultSet dbrs = null;
        try {

            String sql = " select count(distinct bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + ") from " + DbBankpoPayment.DB_BANKPO_PAYMENT + " bpp inner join " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd on bpp." +
                    DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID] + " = bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " inner join " +
                    DbReceive.DB_RECEIVE + " rec on bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + " = rec." + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] +
                    " where bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + " = " + DbBankpoPayment.TYPE_ORDER_PEMBELIAN;

            if (number != null && number.length() > 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " like '%" + number + "%' ";
            }

            if (periodId != 0) {
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }

                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "' ";
            }

            if (ignore == 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " = '" + JSPFormater.formatDate(transDate, "yyyy-MM-dd") + "' ";
            }

            if (ignoreInput == 0) {
                sql = sql + " and bpp." + DbBankpoPayment.colNames[DbBankpoPayment.COL_DATE] + " = between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "' ";
            }

            if (invoice != null && invoice.length() > 0) {
                sql = sql + " and rec." + DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + invoice + "%' ";
            }

            if (vendorId != 0) {
                sql = sql + " and rec." + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + " = " + vendorId;
            }

            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }    
    
    
    public static Vector listDetail(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select bp.bankpo_payment_id as bankpo_payment_id,bp.journal_number as journal_number,sum(payment_by_inv_currency_amount) as amount,bp.memo as memo from bankpo_payment bp inner join bankpo_payment_detail bpd on bp.bankpo_payment_id = bpd.bankpo_payment_id ";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            
            sql = sql + " group by bp.bankpo_payment_id ";
            
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
                BankpoPayment bankpopayment = new BankpoPayment();
                bankpopayment.setOID(rs.getLong("bankpo_payment_id"));
                bankpopayment.setJournalNumber(rs.getString("journal_number"));
                bankpopayment.setAmount(rs.getDouble("amount"));
                bankpopayment.setMemo(rs.getString("memo"));
                lists.add(bankpopayment);
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
    
    public static int countDetail(String whereClause) {
        
        CONResultSet dbrs = null;
        int jumlah = 0;
        try {
            String sql = "select count(bankpo_payment_id) as total from " +                    "" +
                    "(select distinct bp.bankpo_payment_id as bankpo_payment_id from bankpo_payment bp inner join bankpo_payment_detail bpd on bp.bankpo_payment_id = bpd.bankpo_payment_id ";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            
            sql = sql + " group by bp.bankpo_payment_id ) as x";            
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                jumlah = rs.getInt("total");
            }
            rs.close();            

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return jumlah;
    }
    
    
    
}
