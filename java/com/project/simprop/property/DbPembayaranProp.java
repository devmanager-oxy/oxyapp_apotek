
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */
package com.project.simprop.property;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.*;
import com.project.crm.master.DbLot;
import com.project.crm.master.Lot;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.general.*;

public class DbPembayaranProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PEMBAYARAN_PROP = "crm_pembayaranProp";
    public static final int COL_PEMBAYARAN_ID = 0;
    public static final int COL_TRANSACTION_SOURCE = 1;
    public static final int COL_TYPE = 2;
    public static final int COL_NO_BKM = 3;
    public static final int COL_COUNTER = 4;
    public static final int COL_NO_KWITANSI = 5;
    public static final int COL_NO_INVOICE = 6;
    public static final int COL_TANGGAL_INVOICE = 7;
    public static final int COL_TANGGAL = 8;
    public static final int COL_MATA_UANG_ID = 9;
    public static final int COL_EXCHANGE_RATE = 10;
    public static final int COL_CUSTOMER_ID = 11;
    public static final int COL_IRIGASI_TRANSACTION_ID = 12;
    public static final int COL_LIMBAH_TRANSACTION_ID = 13;
    public static final int COL_JUMLAH = 14;
    public static final int COL_CREATE_BY_ID = 15;
    public static final int COL_POSTED_BY_ID = 16;
    public static final int COL_POSTED_DATE = 17;
    public static final int COL_PERIOD_ID = 18;
    public static final int COL_GL_ID = 19;
    public static final int COL_STATUS = 20;
    public static final int COL_PAYMENT_ACCOUNT_ID = 21;
    public static final int COL_SEWA_TANAH_INVOICE_ID = 22;
    public static final int COL_SEWA_TANAH_BENEFIT_ID = 23;
    public static final int COL_DENDA_ID = 24;
    public static final int COL_FOREIGN_AMOUNT = 25;
    public static final int COL_MEMO = 26;
    public static final String[] colNames = {
        "pembayaranProp_id",
        "transaction_source",
        "type",
        "no_bkm",
        "counter",
        "no_kwitansi",
        "no_invoice",
        "tanggal_invoice",
        "tanggal",
        "mata_uang_id",
        "exchange_rate",
        "customer_id",
        "irigasi_transaction_id",
        "limbah_transaction_id",
        "jumlah",
        "create_by_id",
        "posted_by_id",
        "posted_date",
        "period_id",
        "gl_id",
        "status",
        "payment_account_id",
        "sewa_tanah_invoice_id",
        "sewa_tanah_benefit_id",
        "denda_id",
        "foreign_amount",
        "memo"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING
    };
    //contanta
    public static final int PAYMENT_TYPE_CASH = 0;
    public static final int PAYMENT_TYPE_BANK = 1;
    public static final String[] paymentTypeStr = {"KAS", "BANK"};
    public static final int PAYMENT_SALES_PROPERTY = 6;
    public static final String[] paymentSourceStr = {"SALES PROPERTY"};
    public static final int DOCUMENT_STATUS_DRAFT = 0;
    public static final int DOCUMENT_STATUS_POSTING = 1;
    public static final String[] statusDocumentStr = {"Draft", "Posted"};
    public static int STATUS_DRAFT = 0;
    public static int STATUS_PARTIALY_PAID = 1;
    public static int STATUS_FULL_PAID = 2;
    public static String[] stsBayarStr = {"Draft", "Partialy Paid", "Full Paid"};

    public DbPembayaranProp() {
    }

    public DbPembayaranProp(int i) throws CONException {
        super(new DbPembayaranProp());
    }

    public DbPembayaranProp(String sOid) throws CONException {
        super(new DbPembayaranProp(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPembayaranProp(long lOid) throws CONException {
        super(new DbPembayaranProp(0));
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
        return DB_PEMBAYARAN_PROP;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPembayaranProp().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PembayaranProp pembayaranProp = fetchExc(ent.getOID());
        ent = (Entity) pembayaranProp;
        return pembayaranProp.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PembayaranProp) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PembayaranProp) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PembayaranProp fetchExc(long oid) throws CONException {
        try {
            PembayaranProp pembayaranProp = new PembayaranProp();
            DbPembayaranProp pstPembayaranProp = new DbPembayaranProp(oid);
            pembayaranProp.setOID(oid);

            pembayaranProp.setTransactionSource(pstPembayaranProp.getInt(COL_TRANSACTION_SOURCE));
            pembayaranProp.setType(pstPembayaranProp.getInt(COL_TYPE));
            pembayaranProp.setNoBkm(pstPembayaranProp.getString(COL_NO_BKM));
            pembayaranProp.setCounter(pstPembayaranProp.getInt(COL_COUNTER));
            pembayaranProp.setNoKwitansi(pstPembayaranProp.getString(COL_NO_KWITANSI));
            pembayaranProp.setNoInvoice(pstPembayaranProp.getString(COL_NO_INVOICE));
            pembayaranProp.setTanggalInvoice(pstPembayaranProp.getDate(COL_TANGGAL_INVOICE));
            pembayaranProp.setTanggal(pstPembayaranProp.getDate(COL_TANGGAL));
            pembayaranProp.setMataUangId(pstPembayaranProp.getlong(COL_MATA_UANG_ID));
            pembayaranProp.setExchangeRate(pstPembayaranProp.getdouble(COL_EXCHANGE_RATE));
            pembayaranProp.setCustomerId(pstPembayaranProp.getlong(COL_CUSTOMER_ID));
            pembayaranProp.setIrigasiTransactionId(pstPembayaranProp.getlong(COL_IRIGASI_TRANSACTION_ID));
            pembayaranProp.setLimbahTransactionId(pstPembayaranProp.getlong(COL_LIMBAH_TRANSACTION_ID));
            pembayaranProp.setJumlah(pstPembayaranProp.getdouble(COL_JUMLAH));
            pembayaranProp.setCreateById(pstPembayaranProp.getlong(COL_CREATE_BY_ID));
            pembayaranProp.setPostedById(pstPembayaranProp.getlong(COL_POSTED_BY_ID));
            pembayaranProp.setPostedDate(pstPembayaranProp.getDate(COL_POSTED_DATE));
            pembayaranProp.setPeriodId(pstPembayaranProp.getlong(COL_PERIOD_ID));
            pembayaranProp.setGlId(pstPembayaranProp.getlong(COL_GL_ID));
            pembayaranProp.setStatus(pstPembayaranProp.getInt(COL_STATUS));
            pembayaranProp.setPaymentAccountId(pstPembayaranProp.getlong(COL_PAYMENT_ACCOUNT_ID));
            pembayaranProp.setSewaTanahInvoiceId(pstPembayaranProp.getlong(COL_SEWA_TANAH_INVOICE_ID));
            pembayaranProp.setSewaTanahBenefitId(pstPembayaranProp.getlong(COL_SEWA_TANAH_BENEFIT_ID));
            pembayaranProp.setDendaId(pstPembayaranProp.getlong(COL_DENDA_ID));
            pembayaranProp.setForeignAmount(pstPembayaranProp.getdouble(COL_FOREIGN_AMOUNT));
            pembayaranProp.setMemo(pstPembayaranProp.getString(COL_MEMO));

            return pembayaranProp;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPembayaranProp(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PembayaranProp pembayaranProp) throws CONException {
        try {
            DbPembayaranProp pstPembayaranProp = new DbPembayaranProp(0);

            pstPembayaranProp.setInt(COL_TRANSACTION_SOURCE, pembayaranProp.getTransactionSource());
            pstPembayaranProp.setInt(COL_TYPE, pembayaranProp.getType());
            pstPembayaranProp.setString(COL_NO_BKM, pembayaranProp.getNoBkm());
            pstPembayaranProp.setInt(COL_COUNTER, pembayaranProp.getCounter());
            pstPembayaranProp.setString(COL_NO_KWITANSI, pembayaranProp.getNoKwitansi());
            pstPembayaranProp.setString(COL_NO_INVOICE, pembayaranProp.getNoInvoice());
            pstPembayaranProp.setDate(COL_TANGGAL_INVOICE, pembayaranProp.getTanggalInvoice());
            pstPembayaranProp.setDate(COL_TANGGAL, pembayaranProp.getTanggal());
            pstPembayaranProp.setLong(COL_MATA_UANG_ID, pembayaranProp.getMataUangId());
            pstPembayaranProp.setDouble(COL_EXCHANGE_RATE, pembayaranProp.getExchangeRate());
            pstPembayaranProp.setLong(COL_CUSTOMER_ID, pembayaranProp.getCustomerId());
            pstPembayaranProp.setLong(COL_IRIGASI_TRANSACTION_ID, pembayaranProp.getIrigasiTransactionId());
            pstPembayaranProp.setLong(COL_LIMBAH_TRANSACTION_ID, pembayaranProp.getLimbahTransactionId());
            pstPembayaranProp.setDouble(COL_JUMLAH, pembayaranProp.getJumlah());
            pstPembayaranProp.setLong(COL_CREATE_BY_ID, pembayaranProp.getCreateById());
            pstPembayaranProp.setLong(COL_POSTED_BY_ID, pembayaranProp.getPostedById());
            pstPembayaranProp.setDate(COL_POSTED_DATE, pembayaranProp.getPostedDate());
            pstPembayaranProp.setLong(COL_PERIOD_ID, pembayaranProp.getPeriodId());
            pstPembayaranProp.setLong(COL_GL_ID, pembayaranProp.getGlId());
            pstPembayaranProp.setInt(COL_STATUS, pembayaranProp.getStatus());
            pstPembayaranProp.setLong(COL_PAYMENT_ACCOUNT_ID, pembayaranProp.getPaymentAccountId());
            pstPembayaranProp.setLong(COL_SEWA_TANAH_INVOICE_ID, pembayaranProp.getSewaTanahInvoiceId());
            pstPembayaranProp.setLong(COL_SEWA_TANAH_BENEFIT_ID, pembayaranProp.getSewaTanahBenefitId());
            pstPembayaranProp.setLong(COL_DENDA_ID, pembayaranProp.getDendaId());
            pstPembayaranProp.setDouble(COL_FOREIGN_AMOUNT, pembayaranProp.getForeignAmount());
            pstPembayaranProp.setString(COL_MEMO, pembayaranProp.getMemo());

            pstPembayaranProp.insert();
            pembayaranProp.setOID(pstPembayaranProp.getlong(COL_PEMBAYARAN_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPembayaranProp(0), CONException.UNKNOWN);
        }
        return pembayaranProp.getOID();
    }

    public static long updateExc(PembayaranProp pembayaranProp) throws CONException {
        try {
            if (pembayaranProp.getOID() != 0) {
                DbPembayaranProp pstPembayaranProp = new DbPembayaranProp(pembayaranProp.getOID());

                pstPembayaranProp.setInt(COL_TRANSACTION_SOURCE, pembayaranProp.getTransactionSource());
                pstPembayaranProp.setInt(COL_TYPE, pembayaranProp.getType());
                pstPembayaranProp.setString(COL_NO_BKM, pembayaranProp.getNoBkm());
                pstPembayaranProp.setInt(COL_COUNTER, pembayaranProp.getCounter());
                pstPembayaranProp.setString(COL_NO_KWITANSI, pembayaranProp.getNoKwitansi());
                pstPembayaranProp.setString(COL_NO_INVOICE, pembayaranProp.getNoInvoice());
                pstPembayaranProp.setDate(COL_TANGGAL_INVOICE, pembayaranProp.getTanggalInvoice());
                pstPembayaranProp.setDate(COL_TANGGAL, pembayaranProp.getTanggal());
                pstPembayaranProp.setLong(COL_MATA_UANG_ID, pembayaranProp.getMataUangId());
                pstPembayaranProp.setDouble(COL_EXCHANGE_RATE, pembayaranProp.getExchangeRate());
                pstPembayaranProp.setLong(COL_CUSTOMER_ID, pembayaranProp.getCustomerId());
                pstPembayaranProp.setLong(COL_IRIGASI_TRANSACTION_ID, pembayaranProp.getIrigasiTransactionId());
                pstPembayaranProp.setLong(COL_LIMBAH_TRANSACTION_ID, pembayaranProp.getLimbahTransactionId());
                pstPembayaranProp.setDouble(COL_JUMLAH, pembayaranProp.getJumlah());
                pstPembayaranProp.setLong(COL_CREATE_BY_ID, pembayaranProp.getCreateById());
                pstPembayaranProp.setLong(COL_POSTED_BY_ID, pembayaranProp.getPostedById());
                pstPembayaranProp.setDate(COL_POSTED_DATE, pembayaranProp.getPostedDate());
                pstPembayaranProp.setLong(COL_PERIOD_ID, pembayaranProp.getPeriodId());
                pstPembayaranProp.setLong(COL_GL_ID, pembayaranProp.getGlId());
                pstPembayaranProp.setInt(COL_STATUS, pembayaranProp.getStatus());
                pstPembayaranProp.setLong(COL_PAYMENT_ACCOUNT_ID, pembayaranProp.getPaymentAccountId());
                pstPembayaranProp.setLong(COL_SEWA_TANAH_INVOICE_ID, pembayaranProp.getSewaTanahInvoiceId());
                pstPembayaranProp.setLong(COL_SEWA_TANAH_BENEFIT_ID, pembayaranProp.getSewaTanahBenefitId());
                pstPembayaranProp.setLong(COL_DENDA_ID, pembayaranProp.getDendaId());
                pstPembayaranProp.setDouble(COL_FOREIGN_AMOUNT, pembayaranProp.getForeignAmount());
                pstPembayaranProp.setString(COL_MEMO, pembayaranProp.getMemo());

                pstPembayaranProp.update();
                return pembayaranProp.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPembayaranProp(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPembayaranProp pstPembayaranProp = new DbPembayaranProp(oid);
            pstPembayaranProp.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPembayaranProp(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PEMBAYARAN_PROP;
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
                PembayaranProp pembayaranProp = new PembayaranProp();
                resultToObject(rs, pembayaranProp);
                lists.add(pembayaranProp);
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

    private static void resultToObject(ResultSet rs, PembayaranProp pembayaranProp) {
        try {
            pembayaranProp.setOID(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_PEMBAYARAN_ID]));
            pembayaranProp.setTransactionSource(rs.getInt(DbPembayaranProp.colNames[DbPembayaranProp.COL_TRANSACTION_SOURCE]));
            pembayaranProp.setType(rs.getInt(DbPembayaranProp.colNames[DbPembayaranProp.COL_TYPE]));
            pembayaranProp.setNoBkm(rs.getString(DbPembayaranProp.colNames[DbPembayaranProp.COL_NO_BKM]));
            pembayaranProp.setCounter(rs.getInt(DbPembayaranProp.colNames[DbPembayaranProp.COL_COUNTER]));
            pembayaranProp.setNoKwitansi(rs.getString(DbPembayaranProp.colNames[DbPembayaranProp.COL_NO_KWITANSI]));
            pembayaranProp.setNoInvoice(rs.getString(DbPembayaranProp.colNames[DbPembayaranProp.COL_NO_INVOICE]));
            pembayaranProp.setTanggalInvoice(rs.getDate(DbPembayaranProp.colNames[DbPembayaranProp.COL_TANGGAL_INVOICE]));
            pembayaranProp.setTanggal(rs.getDate(DbPembayaranProp.colNames[DbPembayaranProp.COL_TANGGAL]));
            pembayaranProp.setMataUangId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_MATA_UANG_ID]));
            pembayaranProp.setExchangeRate(rs.getDouble(DbPembayaranProp.colNames[DbPembayaranProp.COL_EXCHANGE_RATE]));
            pembayaranProp.setCustomerId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_CUSTOMER_ID]));
            pembayaranProp.setIrigasiTransactionId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_IRIGASI_TRANSACTION_ID]));
            pembayaranProp.setLimbahTransactionId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_LIMBAH_TRANSACTION_ID]));
            pembayaranProp.setJumlah(rs.getDouble(DbPembayaranProp.colNames[DbPembayaranProp.COL_JUMLAH]));
            pembayaranProp.setCreateById(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_CREATE_BY_ID]));
            pembayaranProp.setPostedById(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_POSTED_BY_ID]));
            pembayaranProp.setPostedDate(rs.getDate(DbPembayaranProp.colNames[DbPembayaranProp.COL_POSTED_DATE]));
            pembayaranProp.setPeriodId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_PERIOD_ID]));
            pembayaranProp.setGlId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_GL_ID]));
            pembayaranProp.setStatus(rs.getInt(DbPembayaranProp.colNames[DbPembayaranProp.COL_STATUS]));
            pembayaranProp.setPaymentAccountId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_PAYMENT_ACCOUNT_ID]));
            pembayaranProp.setSewaTanahInvoiceId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_SEWA_TANAH_INVOICE_ID]));
            pembayaranProp.setSewaTanahBenefitId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_SEWA_TANAH_BENEFIT_ID]));
            pembayaranProp.setDendaId(rs.getLong(DbPembayaranProp.colNames[DbPembayaranProp.COL_DENDA_ID]));
            pembayaranProp.setForeignAmount(rs.getDouble(DbPembayaranProp.colNames[DbPembayaranProp.COL_FOREIGN_AMOUNT]));
            pembayaranProp.setMemo(rs.getString(DbPembayaranProp.colNames[DbPembayaranProp.COL_MEMO]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long pembayaranId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PEMBAYARAN_PROP + " WHERE " +
                    DbPembayaranProp.colNames[DbPembayaranProp.COL_PEMBAYARAN_ID] + " = " + pembayaranId;

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
            String sql = "SELECT COUNT(" + DbPembayaranProp.colNames[DbPembayaranProp.COL_PEMBAYARAN_ID] + ") FROM " + DB_PEMBAYARAN_PROP;
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
                    PembayaranProp pembayaranProp = (PembayaranProp) list.get(ls);
                    if (oid == pembayaranProp.getOID()) {
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

    public static double getTotPembayaran(long pembayaranId, long invoiceId) {
        CONResultSet dbrs = null;

        try {
            double totalPembayaran = 0;
            String where = DbPembayaranProp.colNames[DbPembayaranProp.COL_PEMBAYARAN_ID] + " != " + pembayaranId;

            where += " AND " + DbPembayaranProp.colNames[DbPembayaranProp.COL_SEWA_TANAH_INVOICE_ID] + " = " + invoiceId;

            Vector vPembayaran = DbPembayaranProp.list(0, 0, where, "");

            if (vPembayaran != null) {
                for (int i = 0; i < vPembayaran.size(); i++) {
                    PembayaranProp objPembayaran = (PembayaranProp) vPembayaran.get(i);
                    totalPembayaran += objPembayaran.getJumlah();
                }
            }

            return totalPembayaran;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;

    }

    public static void updateStatusInvoice(long permbayaranId, long invoiceId, double totalAmount) {

        double payment = getTotPembayaran(permbayaranId, invoiceId);

        if (payment >= totalAmount) {

            SewaTanahInvoice sti = new SewaTanahInvoice();
            try {
                sti = DbSewaTanahInvoice.fetchExc(invoiceId);
                sti.setStatusPembayaran(STATUS_FULL_PAID);
                DbSewaTanahInvoice.updateExc(sti);

                if (sti.getPaymentSimulationId() != 0){
                    
                    PaymentSimulation ps = DbPaymentSimulation.fetchExc(sti.getPaymentSimulationId());
                    ps.setStatus(DbPaymentSimulation.STATUS_LUNAS);

                    DbPaymentSimulation.updateExc(ps);
                    SalesData sd = new SalesData();
                    
                    try {
                        sd = DbSalesData.fetchExc(ps.getSalesDataId());
                        Lot lot = DbLot.fetchExc(sd.getLotId());
                        if (ps.getPayment() == DbPaymentSimulation.PAYMENT_BF) {
                            sd.setStatus(DbSalesData.STATUS_BOOKED);
                            lot.setStatus(DbLot.LOT_STATUS_BOOKED);
                        } else if (ps.getPayment() == DbPaymentSimulation.PAYMENT_DP) {
                            sd.setStatus(DbSalesData.STATUS_SOLD);
                            lot.setStatus(DbLot.LOT_STATUS_SOLD);
                        } else if (ps.getPayment() == DbPaymentSimulation.PAYMENT_PELUNASAN) {
                            sd.setStatus(DbSalesData.STATUS_SOLD);
                            lot.setStatus(DbLot.LOT_STATUS_SOLD);
                        }

                        DbSalesData.updateExc(sd);
                        DbLot.updateExc(lot);
                    } catch (Exception e) {
                    }
                }
            } catch (Exception e) {}

        } else {
            SewaTanahInvoice sti = new SewaTanahInvoice();
            try {
                sti = DbSewaTanahInvoice.fetchExc(invoiceId);
                sti.setStatusPembayaran(STATUS_PARTIALY_PAID);
                DbSewaTanahInvoice.updateExc(sti);
            } catch (Exception e) {}
        }
    }
    
    public static boolean isMoreThanTotInvoice(PembayaranProp pembayaranProp, double totalInvoice) {
        
        double totalPembayaran = getTotPembayaran(pembayaranProp.getOID(), pembayaranProp.getSewaTanahInvoiceId());        
        double amount = totalPembayaran + pembayaranProp.getJumlah();
        if (totalInvoice < amount) {
            return true;
        }
        return false;
    }

    public static void delPembayaran(long sti) {

        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + DbPembayaranProp.DB_PEMBAYARAN_PROP + " WHERE " + DbPembayaranProp.colNames[DbPembayaranProp.COL_SEWA_TANAH_INVOICE_ID] + " = " + sti;
            CONHandler.execUpdate(sql);
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
}
