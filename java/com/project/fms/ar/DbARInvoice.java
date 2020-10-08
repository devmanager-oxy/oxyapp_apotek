package com.project.fms.ar;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.*;
import com.project.ccs.postransaction.sales.DbCreditPayment;
import com.project.util.*;
import com.project.util.lang.I_Language;
import com.project.fms.master.*;
import com.project.fms.transaction.DbGl;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;

public class DbARInvoice extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_AR_INVOICE = "ar_invoice";
    public static final int COL_AR_INVOICE_ID = 0;
    public static final int COL_CURRENCY_ID = 1;
    public static final int COL_INVOICE_NUMBER = 2;
    public static final int COL_TERM_OF_PAYMENT_ID = 3;
    public static final int COL_DATE = 4;
    public static final int COL_TRANS_DATE = 5;
    public static final int COL_JOURNAL_NUMBER = 6;
    public static final int COL_JOURNAL_PREFIX = 7;
    public static final int COL_JOURNAL_COUNTER = 8;
    public static final int COL_DUE_DATE = 9;
    public static final int COL_VAT = 10;
    public static final int COL_MEMO = 11;
    public static final int COL_DISCOUNT_PERCENT = 12;
    public static final int COL_DISCOUNT = 13;
    public static final int COL_VAT_PERCENT = 14;
    public static final int COL_VAT_AMOUNT = 15;
    public static final int COL_TOTAL = 16;
    public static final int COL_STATUS = 17;
    public static final int COL_OPERATOR_ID = 18;
    public static final int COL_CUSTOMER_ID = 19;
    public static final int COL_COMPANY_ID = 20;
    public static final int COL_PROJECT_ID = 21;
    public static final int COL_PROJECT_TERM_ID = 22;
    public static final int COL_BANK_ACCOUNT_ID = 23;
    public static final int COL_LAST_PAYMENT_DATE = 24;
    public static final int COL_LAST_PAYMENT_AMOUNT = 25;
    public static final int COL_SALES_SOURCE = 26;
    public static final int COL_TYPE_AR = 27;
    public static final int COL_COA_AR_ID = 28;
    public static final int COL_CREATE_ID = 29;
    public static final int COL_APPROVAL1_ID = 30;
    public static final int COL_APPROVAL1_DATE = 31;
    public static final int COL_POSTED_STATUS = 32;
    public static final int COL_POSTED_ID = 33;
    public static final int COL_POSTED_DATE = 34;
    public static final int COL_PERIODE_ID = 35;
    public static final int COL_CREATE_DATE = 36;
    public static final int COL_LOCATION_ID = 37;
    public static final int COL_DOC_STATUS = 38;
    public static final int COL_REF_ID = 39;
    
    public static final String[] colNames = {
        "ar_invoice_id",
        "currency_id",
        "invoice_number",
        "term_of_payment_id",
        "date",
        "trans_date",
        "journal_number",
        "journal_prefix",
        "journal_counter",
        "due_date",
        "vat",
        "memo",
        "discount_percent",
        "discount",
        "vat_percent",
        "vat_amount",
        "total",
        "status",
        "operator_id",
        "customer_id",
        "company_id",
        "project_id",
        "project_term_id",
        "bank_account_id",
        "last_payment_date",
        "last_payment_amount",
        "sales_source",
        "type_ar",
        "coa_ar_id",
        "create_id",
        "approval1_id",
        "approval1_date",
        "posted_status",
        "posted_id",
        "posted_date",
        "periode_id",
        "create_date",
        "location_id",
        "doc_status",
        "ref_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_DATE,
        TYPE_INT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG
    };
    public static final int TYPE_NON_AR_MEMO = 0;
    public static final int TYPE_AR_MEMO = 1;
    public static final int TYPE_RETUR = 2;
    
    public static final int TYPE_STATUS_DRAFT = 0;
    public static final int TYPE_STATUS_APPROVED = 1;
    public static final int TYPE_STATUS_POSTED = 2;

    public DbARInvoice() {
    }

    public DbARInvoice(int i) throws CONException {
        super(new DbARInvoice());
    }

    public DbARInvoice(String sOid) throws CONException {
        super(new DbARInvoice(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbARInvoice(long lOid) throws CONException {
        super(new DbARInvoice(0));
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
        return DB_AR_INVOICE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbARInvoice().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ARInvoice arinvoice = fetchExc(ent.getOID());
        ent = (Entity) arinvoice;
        return arinvoice.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ARInvoice) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ARInvoice) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ARInvoice fetchExc(long oid) throws CONException {
        try {
            ARInvoice arinvoice = new ARInvoice();
            DbARInvoice pstARInvoice = new DbARInvoice(oid);
            arinvoice.setOID(oid);

            arinvoice.setCurrencyId(pstARInvoice.getlong(COL_CURRENCY_ID));
            arinvoice.setInvoiceNumber(pstARInvoice.getString(COL_INVOICE_NUMBER));
            arinvoice.setTermOfPaymentId(pstARInvoice.getlong(COL_TERM_OF_PAYMENT_ID));
            arinvoice.setDate(pstARInvoice.getDate(COL_DATE));
            arinvoice.setTransDate(pstARInvoice.getDate(COL_TRANS_DATE));
            arinvoice.setJournalNumber(pstARInvoice.getString(COL_JOURNAL_NUMBER));
            arinvoice.setJournalPrefix(pstARInvoice.getString(COL_JOURNAL_PREFIX));
            arinvoice.setJournalCounter(pstARInvoice.getInt(COL_JOURNAL_COUNTER));
            arinvoice.setDueDate(pstARInvoice.getDate(COL_DUE_DATE));
            arinvoice.setVat(pstARInvoice.getInt(COL_VAT));
            arinvoice.setMemo(pstARInvoice.getString(COL_MEMO));
            arinvoice.setDiscountPercent(pstARInvoice.getdouble(COL_DISCOUNT_PERCENT));
            arinvoice.setDiscount(pstARInvoice.getdouble(COL_DISCOUNT));
            arinvoice.setVatPercent(pstARInvoice.getdouble(COL_VAT_PERCENT));
            arinvoice.setVatAmount(pstARInvoice.getdouble(COL_VAT_AMOUNT));
            arinvoice.setTotal(pstARInvoice.getdouble(COL_TOTAL));
            arinvoice.setStatus(pstARInvoice.getInt(COL_STATUS));
            arinvoice.setOperatorId(pstARInvoice.getlong(COL_OPERATOR_ID));
            arinvoice.setCustomerId(pstARInvoice.getlong(COL_CUSTOMER_ID));
            arinvoice.setCompanyId(pstARInvoice.getlong(COL_COMPANY_ID));
            arinvoice.setProjectId(pstARInvoice.getlong(COL_PROJECT_ID));
            arinvoice.setProjectTermId(pstARInvoice.getlong(COL_PROJECT_TERM_ID));
            arinvoice.setBankAccountId(pstARInvoice.getlong(COL_BANK_ACCOUNT_ID));
            arinvoice.setLastPaymentDate(pstARInvoice.getDate(COL_LAST_PAYMENT_DATE));
            arinvoice.setLastPaymentAmount(pstARInvoice.getdouble(COL_LAST_PAYMENT_AMOUNT));
            arinvoice.setSalesSource(pstARInvoice.getInt(COL_SALES_SOURCE));
            arinvoice.setTypeAR(pstARInvoice.getInt(COL_TYPE_AR));
            arinvoice.setCoaARId(pstARInvoice.getlong(COL_COA_AR_ID));
            arinvoice.setCreateId(pstARInvoice.getlong(COL_CREATE_ID));
            arinvoice.setApproval1Id(pstARInvoice.getlong(COL_APPROVAL1_ID));
            arinvoice.setApproval1Date(pstARInvoice.getDate(COL_APPROVAL1_DATE));
            arinvoice.setPostedStatus(pstARInvoice.getInt(COL_POSTED_STATUS));
            arinvoice.setPostedId(pstARInvoice.getlong(COL_POSTED_ID));
            arinvoice.setPostedDate(pstARInvoice.getDate(COL_POSTED_DATE));
            arinvoice.setPeriodeId(pstARInvoice.getlong(COL_PERIODE_ID));
            arinvoice.setCreateDate(pstARInvoice.getDate(COL_CREATE_DATE));
            arinvoice.setLocationId(pstARInvoice.getlong(COL_LOCATION_ID));
            arinvoice.setDocStatus(pstARInvoice.getInt(COL_DOC_STATUS));
            arinvoice.setRefId(pstARInvoice.getlong(COL_REF_ID));

            return arinvoice;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbARInvoice(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(ARInvoice arinvoice) throws CONException {
        try {
            DbARInvoice pstARInvoice = new DbARInvoice(0);

            pstARInvoice.setLong(COL_CURRENCY_ID, arinvoice.getCurrencyId());
            pstARInvoice.setString(COL_INVOICE_NUMBER, arinvoice.getInvoiceNumber());
            pstARInvoice.setLong(COL_TERM_OF_PAYMENT_ID, arinvoice.getTermOfPaymentId());
            pstARInvoice.setDate(COL_DATE, arinvoice.getDate());
            pstARInvoice.setDate(COL_TRANS_DATE, arinvoice.getTransDate());
            pstARInvoice.setString(COL_JOURNAL_NUMBER, arinvoice.getJournalNumber());
            pstARInvoice.setString(COL_JOURNAL_PREFIX, arinvoice.getJournalPrefix());
            pstARInvoice.setInt(COL_JOURNAL_COUNTER, arinvoice.getJournalCounter());
            pstARInvoice.setDate(COL_DUE_DATE, arinvoice.getDueDate());
            pstARInvoice.setInt(COL_VAT, arinvoice.getVat());
            pstARInvoice.setString(COL_MEMO, arinvoice.getMemo());
            pstARInvoice.setDouble(COL_DISCOUNT_PERCENT, arinvoice.getDiscountPercent());
            pstARInvoice.setDouble(COL_DISCOUNT, arinvoice.getDiscount());
            pstARInvoice.setDouble(COL_VAT_PERCENT, arinvoice.getVatPercent());
            pstARInvoice.setDouble(COL_VAT_AMOUNT, arinvoice.getVatAmount());
            pstARInvoice.setDouble(COL_TOTAL, arinvoice.getTotal());
            pstARInvoice.setInt(COL_STATUS, arinvoice.getStatus());
            pstARInvoice.setLong(COL_OPERATOR_ID, arinvoice.getOperatorId());
            pstARInvoice.setLong(COL_CUSTOMER_ID, arinvoice.getCustomerId());
            pstARInvoice.setLong(COL_COMPANY_ID, arinvoice.getCompanyId());
            pstARInvoice.setLong(COL_PROJECT_ID, arinvoice.getProjectId());
            pstARInvoice.setLong(COL_PROJECT_TERM_ID, arinvoice.getProjectTermId());
            pstARInvoice.setLong(COL_BANK_ACCOUNT_ID, arinvoice.getBankAccountId());
            pstARInvoice.setDate(COL_LAST_PAYMENT_DATE, arinvoice.getLastPaymentDate());
            pstARInvoice.setDouble(COL_LAST_PAYMENT_AMOUNT, arinvoice.getLastPaymentAmount());
            pstARInvoice.setInt(COL_SALES_SOURCE, arinvoice.getSalesSource());
            pstARInvoice.setInt(COL_TYPE_AR, arinvoice.getTypeAR());
            pstARInvoice.setLong(COL_COA_AR_ID, arinvoice.getCoaARId());
            pstARInvoice.setLong(COL_CREATE_ID, arinvoice.getCreateId());
            pstARInvoice.setLong(COL_APPROVAL1_ID, arinvoice.getApproval1Id());
            pstARInvoice.setDate(COL_APPROVAL1_DATE, arinvoice.getApproval1Date());
            pstARInvoice.setInt(COL_POSTED_STATUS, arinvoice.getPostedStatus());
            pstARInvoice.setLong(COL_POSTED_ID, arinvoice.getPostedId());
            pstARInvoice.setDate(COL_POSTED_DATE, arinvoice.getPostedDate());
            pstARInvoice.setLong(COL_PERIODE_ID, arinvoice.getPeriodeId());
            pstARInvoice.setDate(COL_CREATE_DATE, arinvoice.getCreateDate());
            pstARInvoice.setLong(COL_LOCATION_ID, arinvoice.getLocationId());
            pstARInvoice.setInt(COL_DOC_STATUS, arinvoice.getDocStatus());
            pstARInvoice.setLong(COL_REF_ID, arinvoice.getRefId());

            pstARInvoice.insert();
            arinvoice.setOID(pstARInvoice.getlong(COL_AR_INVOICE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbARInvoice(0), CONException.UNKNOWN);
        }
        return arinvoice.getOID();
    }

    public static long updateExc(ARInvoice arinvoice) throws CONException {
        try {
            if (arinvoice.getOID() != 0) {
                DbARInvoice pstARInvoice = new DbARInvoice(arinvoice.getOID());

                pstARInvoice.setLong(COL_CURRENCY_ID, arinvoice.getCurrencyId());
                pstARInvoice.setString(COL_INVOICE_NUMBER, arinvoice.getInvoiceNumber());
                pstARInvoice.setLong(COL_TERM_OF_PAYMENT_ID, arinvoice.getTermOfPaymentId());
                pstARInvoice.setDate(COL_DATE, arinvoice.getDate());
                pstARInvoice.setDate(COL_TRANS_DATE, arinvoice.getTransDate());
                pstARInvoice.setString(COL_JOURNAL_NUMBER, arinvoice.getJournalNumber());
                pstARInvoice.setString(COL_JOURNAL_PREFIX, arinvoice.getJournalPrefix());
                pstARInvoice.setInt(COL_JOURNAL_COUNTER, arinvoice.getJournalCounter());
                pstARInvoice.setDate(COL_DUE_DATE, arinvoice.getDueDate());
                pstARInvoice.setInt(COL_VAT, arinvoice.getVat());
                pstARInvoice.setString(COL_MEMO, arinvoice.getMemo());
                pstARInvoice.setDouble(COL_DISCOUNT_PERCENT, arinvoice.getDiscountPercent());
                pstARInvoice.setDouble(COL_DISCOUNT, arinvoice.getDiscount());
                pstARInvoice.setDouble(COL_VAT_PERCENT, arinvoice.getVatPercent());
                pstARInvoice.setDouble(COL_VAT_AMOUNT, arinvoice.getVatAmount());
                pstARInvoice.setDouble(COL_TOTAL, arinvoice.getTotal());
                pstARInvoice.setInt(COL_STATUS, arinvoice.getStatus());
                pstARInvoice.setLong(COL_OPERATOR_ID, arinvoice.getOperatorId());
                pstARInvoice.setLong(COL_CUSTOMER_ID, arinvoice.getCustomerId());
                pstARInvoice.setLong(COL_COMPANY_ID, arinvoice.getCompanyId());
                pstARInvoice.setLong(COL_PROJECT_ID, arinvoice.getProjectId());
                pstARInvoice.setLong(COL_PROJECT_TERM_ID, arinvoice.getProjectTermId());
                pstARInvoice.setLong(COL_BANK_ACCOUNT_ID, arinvoice.getBankAccountId());
                pstARInvoice.setDate(COL_LAST_PAYMENT_DATE, arinvoice.getLastPaymentDate());
                pstARInvoice.setDouble(COL_LAST_PAYMENT_AMOUNT, arinvoice.getLastPaymentAmount());
                pstARInvoice.setInt(COL_SALES_SOURCE, arinvoice.getSalesSource());
                pstARInvoice.setInt(COL_TYPE_AR, arinvoice.getTypeAR());
                pstARInvoice.setLong(COL_COA_AR_ID, arinvoice.getCoaARId());
                pstARInvoice.setLong(COL_CREATE_ID, arinvoice.getCreateId());
                pstARInvoice.setLong(COL_APPROVAL1_ID, arinvoice.getApproval1Id());
                pstARInvoice.setDate(COL_APPROVAL1_DATE, arinvoice.getApproval1Date());
                pstARInvoice.setInt(COL_POSTED_STATUS, arinvoice.getPostedStatus());
                pstARInvoice.setLong(COL_POSTED_ID, arinvoice.getPostedId());
                pstARInvoice.setDate(COL_POSTED_DATE, arinvoice.getPostedDate());
                pstARInvoice.setLong(COL_PERIODE_ID, arinvoice.getPeriodeId());
                pstARInvoice.setDate(COL_CREATE_DATE, arinvoice.getCreateDate());
                pstARInvoice.setLong(COL_LOCATION_ID, arinvoice.getLocationId());
                pstARInvoice.setInt(COL_DOC_STATUS, arinvoice.getDocStatus());
                pstARInvoice.setLong(COL_REF_ID, arinvoice.getRefId());

                pstARInvoice.update();
                return arinvoice.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbARInvoice(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbARInvoice pstARInvoice = new DbARInvoice(oid);
            pstARInvoice.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbARInvoice(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_AR_INVOICE;
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
                ARInvoice arinvoice = new ARInvoice();
                resultToObject(rs, arinvoice);
                lists.add(arinvoice);
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

    public static void resultToObject(ResultSet rs, ARInvoice arinvoice) {
        try {
            arinvoice.setOID(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_AR_INVOICE_ID]));
            arinvoice.setCurrencyId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_CURRENCY_ID]));
            arinvoice.setInvoiceNumber(rs.getString(DbARInvoice.colNames[DbARInvoice.COL_INVOICE_NUMBER]));
            arinvoice.setTermOfPaymentId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_TERM_OF_PAYMENT_ID]));
            arinvoice.setDate(rs.getDate(DbARInvoice.colNames[DbARInvoice.COL_DATE]));
            arinvoice.setTransDate(rs.getDate(DbARInvoice.colNames[DbARInvoice.COL_TRANS_DATE]));
            arinvoice.setJournalNumber(rs.getString(DbARInvoice.colNames[DbARInvoice.COL_JOURNAL_NUMBER]));
            arinvoice.setJournalPrefix(rs.getString(DbARInvoice.colNames[DbARInvoice.COL_JOURNAL_PREFIX]));
            arinvoice.setJournalCounter(rs.getInt(DbARInvoice.colNames[DbARInvoice.COL_JOURNAL_COUNTER]));
            arinvoice.setDueDate(rs.getDate(DbARInvoice.colNames[DbARInvoice.COL_DUE_DATE]));
            arinvoice.setVat(rs.getInt(DbARInvoice.colNames[DbARInvoice.COL_VAT]));
            arinvoice.setMemo(rs.getString(DbARInvoice.colNames[DbARInvoice.COL_MEMO]));
            arinvoice.setDiscountPercent(rs.getDouble(DbARInvoice.colNames[DbARInvoice.COL_DISCOUNT_PERCENT]));
            arinvoice.setDiscount(rs.getDouble(DbARInvoice.colNames[DbARInvoice.COL_DISCOUNT]));
            arinvoice.setVatPercent(rs.getDouble(DbARInvoice.colNames[DbARInvoice.COL_VAT_PERCENT]));
            arinvoice.setVatAmount(rs.getDouble(DbARInvoice.colNames[DbARInvoice.COL_VAT_AMOUNT]));
            arinvoice.setTotal(rs.getDouble(DbARInvoice.colNames[DbARInvoice.COL_TOTAL]));
            arinvoice.setStatus(rs.getInt(DbARInvoice.colNames[DbARInvoice.COL_STATUS]));
            arinvoice.setOperatorId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_OPERATOR_ID]));
            arinvoice.setCustomerId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID]));
            arinvoice.setCompanyId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_COMPANY_ID]));
            arinvoice.setProjectId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_PROJECT_ID]));
            arinvoice.setProjectTermId(rs.getInt(DbARInvoice.colNames[DbARInvoice.COL_PROJECT_TERM_ID]));
            arinvoice.setBankAccountId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_BANK_ACCOUNT_ID]));
            arinvoice.setLastPaymentDate(rs.getDate(DbARInvoice.colNames[DbARInvoice.COL_LAST_PAYMENT_DATE]));
            arinvoice.setLastPaymentAmount(rs.getDouble(DbARInvoice.colNames[DbARInvoice.COL_LAST_PAYMENT_AMOUNT]));
            arinvoice.setSalesSource(rs.getInt(DbARInvoice.colNames[DbARInvoice.COL_SALES_SOURCE]));
            arinvoice.setTypeAR(rs.getInt(DbARInvoice.colNames[DbARInvoice.COL_TYPE_AR]));
            arinvoice.setCoaARId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_COA_AR_ID]));
            arinvoice.setCreateId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_CREATE_ID]));
            arinvoice.setApproval1Id(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_APPROVAL1_ID]));
            arinvoice.setApproval1Date(rs.getDate(DbARInvoice.colNames[DbARInvoice.COL_APPROVAL1_DATE]));
            arinvoice.setPostedStatus(rs.getInt(DbARInvoice.colNames[DbARInvoice.COL_POSTED_STATUS]));
            arinvoice.setPostedId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_POSTED_ID]));
            arinvoice.setPostedDate(rs.getDate(DbARInvoice.colNames[DbARInvoice.COL_POSTED_DATE]));
            arinvoice.setPeriodeId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_PERIODE_ID]));
            arinvoice.setCreateDate(rs.getDate(DbARInvoice.colNames[DbARInvoice.COL_CREATE_DATE]));
            arinvoice.setLocationId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_LOCATION_ID]));
            arinvoice.setDocStatus(rs.getInt(DbARInvoice.colNames[DbARInvoice.COL_DOC_STATUS]));
            arinvoice.setRefId(rs.getLong(DbARInvoice.colNames[DbARInvoice.COL_REF_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long arInvoiceId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_AR_INVOICE + " WHERE " +
                    DbARInvoice.colNames[DbARInvoice.COL_AR_INVOICE_ID] + " = " + arInvoiceId;

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
            String sql = "SELECT COUNT(" + DbARInvoice.colNames[DbARInvoice.COL_AR_INVOICE_ID] + ") FROM " + DB_AR_INVOICE;
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
                    ARInvoice arinvoice = (ARInvoice) list.get(ls);
                    if (oid == arinvoice.getOID()) {
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

    public static int getNextCounter(long systemCompanyId) {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_JOURNAL_COUNTER] + ") from " + DB_AR_INVOICE + " where " +
                    " journal_prefix='" + getNumberPrefix(systemCompanyId) + "' ";

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

    public static String getNumberPrefix(long systemCompanyId) {
        Company sysCompany = new Company();
        try {
            sysCompany = DbCompany.fetchExc(systemCompanyId);
        } catch (Exception e) {
            System.out.println(e);
        }
        Location sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());
        String code = sysLocation.getCode();
        code = code + sysCompany.getInvoiceCode();
        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }

    public static String getNextNumber(int ctr, long systemCompanyId) {

        String code = getNumberPrefix(systemCompanyId);

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

    public static void postJournal(Vector vARInvoice, long userId){

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        if (vARInvoice != null && vARInvoice.size() > 0) {

            for (int i = 0; i < vARInvoice.size(); i++) {

                ARInvoice arInvoice = (ARInvoice) vARInvoice.get(i);

                boolean isComplete = true;

                if (arInvoice.getPeriodeId() != 0) {

                    Periode periode = new Periode();
                    try {
                        periode = DbPeriode.fetchExc(arInvoice.getPeriodeId());
                    } catch (Exception e) {
                    }

                    if (periode.getOID() == 0) {
                        isComplete = false;
                    }
                }

                String where = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + " = " + arInvoice.getLocationId();
                Vector vSd = DbSegmentDetail.list(0, 1, where, null);
                SegmentDetail segmentDetail = new SegmentDetail();

                if (vSd != null && vSd.size() > 0) {
                    segmentDetail = (SegmentDetail) vSd.get(0);
                }

                if (segmentDetail.getOID() == 0) {
                    isComplete = false;
                }

                if (isComplete) {

                    String memo = "AR Memo number : " + arInvoice.getJournalNumber() + " : " + arInvoice.getMemo();

                    long oid = DbGl.postJournalMain(er.getCurrencyIdrId(), arInvoice.getCreateDate(), arInvoice.getJournalCounter(), arInvoice.getJournalNumber(), arInvoice.getJournalPrefix(),
                            I_Project.JOURNAL_TYPE_AR_MEMO,
                            memo, arInvoice.getCreateId(), "", arInvoice.getOID(), "", arInvoice.getDate(), arInvoice.getPeriodeId());

                    if (oid != 0) {

                        Vector vARInvoiceDetail = new Vector();

                        vARInvoiceDetail = DbARInvoiceDetail.list(0, 0, DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID] + "=" + arInvoice.getOID(), null);

                        if (vARInvoiceDetail != null && vARInvoiceDetail.size() > 0) {

                            double tot = 0;

                            for (int t = 0; t < vARInvoiceDetail.size(); t++) {

                                ARInvoiceDetail ard = (ARInvoiceDetail) vARInvoiceDetail.get(t);
                                Coa c = new Coa();
                                try {
                                    c = DbCoa.fetchExc(ard.getCoaId());
                                } catch (Exception e) {
                                }
                                memo = "Perkiraan " + c.getName();

                                if (ard.getTotalAmount() < 0) {
                                    DbGl.postJournalDetail(er.getValueIdr(), ard.getCoaId(), 0, ard.getTotalAmount() * -1,
                                            ard.getTotalAmount() * -1, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segmentDetail.getOID(), 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0); //non departmenttal item, department id = 0  

                                    tot = tot + (ard.getTotalAmount() * -1);

                                } else {

                                    DbGl.postJournalDetail(er.getValueIdr(), ard.getCoaId(), ard.getTotalAmount(), 0,
                                            ard.getTotalAmount() * -1, comp.getBookingCurrencyId(), oid, memo, 0,
                                            segmentDetail.getOID(), 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0); //non departmenttal item, department id = 0  

                                    tot = tot - ard.getTotalAmount();

                                }
                            }

                            if (tot > 0) {
                                memo = "Piutang";
                                DbGl.postJournalDetail(er.getValueIdr(), arInvoice.getCoaARId(), tot, 0,
                                        tot, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segmentDetail.getOID(), 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); //non departmenttal item, department id = 0                                          
                            } else {
                                memo = "Piutang";
                                DbGl.postJournalDetail(er.getValueIdr(), arInvoice.getCoaARId(), 0, tot,
                                        tot, comp.getBookingCurrencyId(), oid, memo, 0,
                                        segmentDetail.getOID(), 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); //non departmenttal item, department id = 0  

                            }
                        }                        
                        
                        arInvoice.setDocStatus(DbARInvoice.TYPE_STATUS_POSTED);
                        arInvoice.setPostedStatus(1);
                        arInvoice.setPostedId(userId);
                        arInvoice.setPostedDate(new Date());
                        
                        try{
                            DbARInvoice.updateExc(arInvoice);
                        }catch(Exception e){}
                        
                    }
                }
            }
        }
    }
    
    public static double amountPaid(long arInvoiceId){
        
        CONResultSet dbrs = null;
        try{
            
            String sql = "select sum("+DbArPayment.colNames[DbArPayment.COL_AMOUNT] +") from "+DbArPayment.DB_AR_PAYMENT+" where "+
                    DbArPayment.colNames[DbArPayment.COL_AR_INVOICE_ID]+" = "+arInvoiceId;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                double result = rs.getInt(1);
                return result;
            }
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        
        return 0;
    }
    
    
    public static double posAmount(long salesId){
        
        CONResultSet dbrs = null;
        try{
            
            String sql = "select sum("+DbCreditPayment.colNames[DbCreditPayment.COL_AMOUNT] +") from "+DbCreditPayment.DB_CREDIT_PAYMENT+" where "+
                    DbCreditPayment.colNames[DbCreditPayment.COL_SALES_ID]+" = "+salesId+" and "+DbCreditPayment.colNames[DbCreditPayment.COL_POSTED_STATUS]+" = 0";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                double result = rs.getInt(1);
                return result;
            }
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        
        return 0;
    }
}