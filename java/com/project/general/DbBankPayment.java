/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy
 */
public class DbBankPayment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BANK_PAYMENT = "bank_payment";
    
    public static final int COL_BANK_PAYMENT_ID = 0;
    public static final int COL_TYPE = 1;
    public static final int COL_CREATE_DATE = 2;    
    public static final int COL_JOURNAL_NUMBER = 3;
    public static final int COL_JOURNAL_PREFIX = 4;
    public static final int COL_JOURNAL_COUNTER = 5;
    public static final int COL_CURRENCY_ID = 6;
    public static final int COL_CREATE_ID = 7;
    public static final int COL_DUE_DATE = 8;
    public static final int COL_AMOUNT = 9;
    public static final int COL_COA_ID = 10;
    public static final int COL_COA_PAYMENT_ID = 11;
    public static final int COL_PAYMENT_DATE = 12;
    public static final int COL_REFERENSI_ID = 13;
    public static final int COL_STATUS = 14;
    public static final int COL_SEGMENT1_ID = 15;
    public static final int COL_SEGMENT2_ID = 16;
    public static final int COL_SEGMENT3_ID = 17;
    public static final int COL_SEGMENT4_ID = 18;    
    public static final int COL_SEGMENT5_ID = 19;
    public static final int COL_SEGMENT6_ID = 20;
    public static final int COL_SEGMENT7_ID = 21;
    public static final int COL_SEGMENT8_ID = 22;
    public static final int COL_SEGMENT9_ID = 23;
    public static final int COL_SEGMENT10_ID = 24;
    public static final int COL_SEGMENT11_ID = 25;
    public static final int COL_SEGMENT12_ID = 26;
    public static final int COL_SEGMENT13_ID = 27;
    public static final int COL_SEGMENT14_ID = 28;
    public static final int COL_SEGMENT15_ID = 29;    
    public static final int COL_TRANSACTION_DATE = 30;    
    public static final int COL_VENDOR_ID = 31;    
    public static final int COL_NUMBER = 32;    
    public static final int COL_BANK_ID = 33;   
    public static final int COL_SYSTEM_DOC_NUMBER_ID = 34;       
    
    public static final String[] colNames = {
        "bank_payment_id",
        "type",
        "create_date",        
        "journal_number",
        "journal_prefix",
        "journal_counter",
        "currency_id",        
        "create_id",
        "due_date",
        "amount",
        "coa_id",
        "coa_payment_id",
        "payment_date",
        "referensi_id",
        "status",
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
        "transaction_date",
        "vendor_id",
        "number",
        "bank_id",
        "system_doc_number_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_DATE,
        
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        
        TYPE_LONG,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        
        TYPE_INT,
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
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG
    };
    
    public static final int TYPE_BANK_PO = 0;    
    public static final int TYPE_CARD_CREDIT = 1;    
    public static final int TYPE_CARD_DEBIT = 2;    
    public static final int TYPE_BANK_PO_GROUP = 3;    
    public static final int TYPE_BANK_PO_CHECK = 4;
    public static final int TYPE_BANK_NONPO = 5;
    public static final int TYPE_BANK_NONPO_CHECK = 6;
    
    public static final int STATUS_NOT_PAID = 0;
    public static final int STATUS_PAID = 1;    
    

    public DbBankPayment() {
    }

    public DbBankPayment(int i) throws CONException {
        super(new DbBankPayment());
    }

    public DbBankPayment(String sOid) throws CONException {
        super(new DbBankPayment(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBankPayment(long lOid) throws CONException {
        super(new DbBankPayment(0));
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
        return DB_BANK_PAYMENT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBankPayment().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BankPayment bankPayment = fetchExc(ent.getOID());
        ent = (Entity) bankPayment;
        return bankPayment.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BankPayment) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BankPayment) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BankPayment fetchExc(long oid) throws CONException {
        try {
            BankPayment bankPayment = new BankPayment();
            DbBankPayment pstBankPayment = new DbBankPayment(oid);
            bankPayment.setOID(oid);
            
            bankPayment.setType(pstBankPayment.getInt(COL_TYPE));
            bankPayment.setCreateDate(pstBankPayment.getDate(COL_CREATE_DATE));
            bankPayment.setCreateId(pstBankPayment.getlong(COL_CREATE_ID));
            
            bankPayment.setJournalNumber(pstBankPayment.getString(COL_JOURNAL_NUMBER));
            bankPayment.setJournalCounter(pstBankPayment.getInt(COL_JOURNAL_COUNTER));
            bankPayment.setJournalPrefix(pstBankPayment.getString(COL_JOURNAL_PREFIX));            
            bankPayment.setCurrencyId(pstBankPayment.getlong(COL_CURRENCY_ID));
            
            bankPayment.setDueDate(pstBankPayment.getDate(COL_DUE_DATE));
            bankPayment.setAmount(pstBankPayment.getdouble(COL_AMOUNT));
            bankPayment.setCoaId(pstBankPayment.getlong(COL_COA_ID));
            bankPayment.setCoaPaymentId(pstBankPayment.getlong(COL_COA_PAYMENT_ID));
            bankPayment.setPaymentDate(pstBankPayment.getDate(COL_PAYMENT_DATE));
            bankPayment.setReferensiId(pstBankPayment.getlong(COL_REFERENSI_ID));
            
            bankPayment.setStatus(pstBankPayment.getInt(COL_STATUS));
            bankPayment.setSegment1Id(pstBankPayment.getlong(COL_SEGMENT1_ID));
            bankPayment.setSegment2Id(pstBankPayment.getlong(COL_SEGMENT2_ID));
            bankPayment.setSegment3Id(pstBankPayment.getlong(COL_SEGMENT3_ID));
            bankPayment.setSegment4Id(pstBankPayment.getlong(COL_SEGMENT4_ID));
            bankPayment.setSegment5Id(pstBankPayment.getlong(COL_SEGMENT5_ID));
            bankPayment.setSegment6Id(pstBankPayment.getlong(COL_SEGMENT6_ID));
            bankPayment.setSegment7Id(pstBankPayment.getlong(COL_SEGMENT7_ID));
            bankPayment.setSegment8Id(pstBankPayment.getlong(COL_SEGMENT8_ID));
            bankPayment.setSegment9Id(pstBankPayment.getlong(COL_SEGMENT9_ID));
            bankPayment.setSegment10Id(pstBankPayment.getlong(COL_SEGMENT10_ID));
            bankPayment.setSegment11Id(pstBankPayment.getlong(COL_SEGMENT11_ID));
            bankPayment.setSegment12Id(pstBankPayment.getlong(COL_SEGMENT12_ID));
            bankPayment.setSegment13Id(pstBankPayment.getlong(COL_SEGMENT13_ID));
            bankPayment.setSegment14Id(pstBankPayment.getlong(COL_SEGMENT14_ID));
            bankPayment.setSegment15Id(pstBankPayment.getlong(COL_SEGMENT15_ID));
            
            bankPayment.setTransactionDate(pstBankPayment.getDate(COL_TRANSACTION_DATE));
            bankPayment.setVendorId(pstBankPayment.getlong(COL_VENDOR_ID));
            bankPayment.setNumber(pstBankPayment.getString(COL_NUMBER));
            bankPayment.setBankId(pstBankPayment.getlong(COL_BANK_ID));
            bankPayment.setSystemDocNumberId(pstBankPayment.getlong(COL_SYSTEM_DOC_NUMBER_ID));
            return bankPayment;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankPayment(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BankPayment bankPayment) throws CONException {
        try {
            DbBankPayment pstBankPayment = new DbBankPayment(0);
            pstBankPayment.setInt(COL_TYPE, bankPayment.getType());
            pstBankPayment.setDate(COL_CREATE_DATE, bankPayment.getCreateDate());
            pstBankPayment.setLong(COL_CREATE_ID, bankPayment.getCreateId());            
            pstBankPayment.setString(COL_JOURNAL_NUMBER, bankPayment.getJournalNumber());
            pstBankPayment.setInt(COL_JOURNAL_COUNTER, bankPayment.getJournalCounter());
            pstBankPayment.setString(COL_JOURNAL_PREFIX, bankPayment.getJournalPrefix());
            pstBankPayment.setLong(COL_CURRENCY_ID, bankPayment.getCurrencyId());            
            pstBankPayment.setDate(COL_DUE_DATE, bankPayment.getDueDate());
            pstBankPayment.setDouble(COL_AMOUNT, bankPayment.getAmount());
            pstBankPayment.setLong(COL_COA_ID, bankPayment.getCoaId());
            pstBankPayment.setLong(COL_COA_PAYMENT_ID, bankPayment.getCoaPaymentId());
            pstBankPayment.setDate(COL_PAYMENT_DATE, bankPayment.getPaymentDate());
            pstBankPayment.setLong(COL_REFERENSI_ID, bankPayment.getReferensiId());            
            pstBankPayment.setInt(COL_STATUS, bankPayment.getStatus());
            pstBankPayment.setLong(COL_SEGMENT1_ID, bankPayment.getSegment1Id());
            pstBankPayment.setLong(COL_SEGMENT2_ID, bankPayment.getSegment2Id());
            pstBankPayment.setLong(COL_SEGMENT3_ID, bankPayment.getSegment3Id());
            pstBankPayment.setLong(COL_SEGMENT4_ID, bankPayment.getSegment4Id());
            pstBankPayment.setLong(COL_SEGMENT5_ID, bankPayment.getSegment5Id());
            pstBankPayment.setLong(COL_SEGMENT6_ID, bankPayment.getSegment6Id());
            pstBankPayment.setLong(COL_SEGMENT7_ID, bankPayment.getSegment7Id());
            pstBankPayment.setLong(COL_SEGMENT8_ID, bankPayment.getSegment8Id());
            pstBankPayment.setLong(COL_SEGMENT9_ID, bankPayment.getSegment9Id());
            pstBankPayment.setLong(COL_SEGMENT10_ID, bankPayment.getSegment10Id());
            pstBankPayment.setLong(COL_SEGMENT11_ID, bankPayment.getSegment11Id());
            pstBankPayment.setLong(COL_SEGMENT12_ID, bankPayment.getSegment12Id());
            pstBankPayment.setLong(COL_SEGMENT13_ID, bankPayment.getSegment13Id());
            pstBankPayment.setLong(COL_SEGMENT14_ID, bankPayment.getSegment14Id());
            pstBankPayment.setLong(COL_SEGMENT15_ID, bankPayment.getSegment15Id());            
            pstBankPayment.setDate(COL_TRANSACTION_DATE, bankPayment.getTransactionDate());
            pstBankPayment.setLong(COL_VENDOR_ID, bankPayment.getVendorId());
            pstBankPayment.setString(COL_NUMBER, bankPayment.getNumber());
            pstBankPayment.setLong(COL_BANK_ID, bankPayment.getBankId());
            pstBankPayment.setLong(COL_SYSTEM_DOC_NUMBER_ID, bankPayment.getSystemDocNumberId());            
            pstBankPayment.insert();
            bankPayment.setOID(pstBankPayment.getlong(COL_BANK_PAYMENT_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankPayment(0), CONException.UNKNOWN);
        }
        return bankPayment.getOID();
    }

    public static long updateExc(BankPayment bankPayment) throws CONException {
        try {
            if (bankPayment.getOID() != 0) {
                DbBankPayment pstBankPayment = new DbBankPayment(bankPayment.getOID());

                pstBankPayment.setInt(COL_TYPE, bankPayment.getType());
                pstBankPayment.setDate(COL_CREATE_DATE, bankPayment.getCreateDate());
                pstBankPayment.setLong(COL_CREATE_ID, bankPayment.getCreateId());            
                pstBankPayment.setString(COL_JOURNAL_NUMBER, bankPayment.getJournalNumber());
                pstBankPayment.setInt(COL_JOURNAL_COUNTER, bankPayment.getJournalCounter());
                pstBankPayment.setString(COL_JOURNAL_PREFIX, bankPayment.getJournalPrefix());
                pstBankPayment.setLong(COL_CURRENCY_ID, bankPayment.getCurrencyId());            
                pstBankPayment.setDate(COL_DUE_DATE, bankPayment.getDueDate());
                pstBankPayment.setDouble(COL_AMOUNT, bankPayment.getAmount());
                pstBankPayment.setLong(COL_COA_ID, bankPayment.getCoaId());
                pstBankPayment.setLong(COL_COA_PAYMENT_ID, bankPayment.getCoaPaymentId());
                pstBankPayment.setDate(COL_PAYMENT_DATE, bankPayment.getPaymentDate());
                pstBankPayment.setLong(COL_REFERENSI_ID, bankPayment.getReferensiId());            
                pstBankPayment.setInt(COL_STATUS, bankPayment.getStatus());
                pstBankPayment.setLong(COL_SEGMENT1_ID, bankPayment.getSegment1Id());
                pstBankPayment.setLong(COL_SEGMENT2_ID, bankPayment.getSegment2Id());
                pstBankPayment.setLong(COL_SEGMENT3_ID, bankPayment.getSegment3Id());
                pstBankPayment.setLong(COL_SEGMENT4_ID, bankPayment.getSegment4Id());
                pstBankPayment.setLong(COL_SEGMENT5_ID, bankPayment.getSegment5Id());
                pstBankPayment.setLong(COL_SEGMENT6_ID, bankPayment.getSegment6Id());
                pstBankPayment.setLong(COL_SEGMENT7_ID, bankPayment.getSegment7Id());
                pstBankPayment.setLong(COL_SEGMENT8_ID, bankPayment.getSegment8Id());
                pstBankPayment.setLong(COL_SEGMENT9_ID, bankPayment.getSegment9Id());
                pstBankPayment.setLong(COL_SEGMENT10_ID, bankPayment.getSegment10Id());
                pstBankPayment.setLong(COL_SEGMENT11_ID, bankPayment.getSegment11Id());
                pstBankPayment.setLong(COL_SEGMENT12_ID, bankPayment.getSegment12Id());
                pstBankPayment.setLong(COL_SEGMENT13_ID, bankPayment.getSegment13Id());
                pstBankPayment.setLong(COL_SEGMENT14_ID, bankPayment.getSegment14Id());
                pstBankPayment.setLong(COL_SEGMENT15_ID, bankPayment.getSegment15Id());                
                pstBankPayment.setDate(COL_TRANSACTION_DATE, bankPayment.getTransactionDate());
                pstBankPayment.setLong(COL_VENDOR_ID, bankPayment.getVendorId());
                pstBankPayment.setString(COL_NUMBER, bankPayment.getNumber());
                pstBankPayment.setLong(COL_BANK_ID, bankPayment.getBankId());
                pstBankPayment.setLong(COL_SYSTEM_DOC_NUMBER_ID, bankPayment.getSystemDocNumberId()); 
                pstBankPayment.update();
                return bankPayment.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankPayment(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBankPayment pstBankPayment = new DbBankPayment(oid);
            pstBankPayment.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankPayment(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BANK_PAYMENT;
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
                BankPayment bankPayment = new BankPayment();
                resultToObject(rs, bankPayment);
                lists.add(bankPayment);
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

    private static void resultToObject(ResultSet rs, BankPayment bankPayment) {
        try {
            bankPayment.setOID(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_BANK_PAYMENT_ID]));
            bankPayment.setType(rs.getInt(DbBankPayment.colNames[DbBankPayment.COL_TYPE]));
            bankPayment.setCreateDate(rs.getDate(DbBankPayment.colNames[DbBankPayment.COL_CREATE_DATE]));
            bankPayment.setCreateId(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_CREATE_ID]));
            
            bankPayment.setJournalNumber(rs.getString(DbBankPayment.colNames[DbBankPayment.COL_JOURNAL_NUMBER]));            
            bankPayment.setJournalPrefix(rs.getString(DbBankPayment.colNames[DbBankPayment.COL_JOURNAL_PREFIX]));
            bankPayment.setJournalCounter(rs.getInt(DbBankPayment.colNames[DbBankPayment.COL_JOURNAL_COUNTER]));
            bankPayment.setCurrencyId(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_CURRENCY_ID]));
            
            bankPayment.setDueDate(rs.getDate(DbBankPayment.colNames[DbBankPayment.COL_DUE_DATE]));
            bankPayment.setAmount(rs.getDouble(DbBankPayment.colNames[DbBankPayment.COL_AMOUNT]));
            bankPayment.setCoaId(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_COA_ID]));
            bankPayment.setCoaPaymentId(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_COA_PAYMENT_ID]));
            bankPayment.setPaymentDate(rs.getDate(DbBankPayment.colNames[DbBankPayment.COL_PAYMENT_DATE]));
            bankPayment.setReferensiId(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_REFERENSI_ID]));
            
            bankPayment.setStatus(rs.getInt(DbBankPayment.colNames[DbBankPayment.COL_STATUS]));
            bankPayment.setSegment1Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT1_ID]));
            bankPayment.setSegment2Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT2_ID]));
            bankPayment.setSegment3Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT3_ID]));
            bankPayment.setSegment4Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT4_ID]));
            bankPayment.setSegment5Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT5_ID]));
            bankPayment.setSegment6Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT6_ID]));
            bankPayment.setSegment7Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT7_ID]));
            bankPayment.setSegment8Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT8_ID]));
            bankPayment.setSegment9Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT9_ID]));
            bankPayment.setSegment10Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT10_ID]));
            bankPayment.setSegment11Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT11_ID]));
            bankPayment.setSegment12Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT12_ID]));
            bankPayment.setSegment13Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT13_ID]));
            bankPayment.setSegment14Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT14_ID]));
            bankPayment.setSegment15Id(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SEGMENT15_ID]));            
            bankPayment.setTransactionDate(rs.getDate(DbBankPayment.colNames[DbBankPayment.COL_TRANSACTION_DATE]));
            bankPayment.setVendorId(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_VENDOR_ID]));
            bankPayment.setNumber(rs.getString(DbBankPayment.colNames[DbBankPayment.COL_NUMBER]));
            bankPayment.setBankId(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_BANK_ID]));            
            bankPayment.setSystemDocNumberId(rs.getLong(DbBankPayment.colNames[DbBankPayment.COL_SYSTEM_DOC_NUMBER_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long bankPaymentId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BANK_PAYMENT + " WHERE " +
                    DbBankPayment.colNames[DbBankPayment.COL_BANK_PAYMENT_ID] + " = " + bankPaymentId;

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
            String sql = "SELECT COUNT(" + DbBankPayment.colNames[DbBankPayment.COL_BANK_PAYMENT_ID] + ") FROM " + DB_BANK_PAYMENT;
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
                    BankPayment bankPayment = (BankPayment) list.get(ls);
                    if (oid == bankPayment.getOID()) {
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


