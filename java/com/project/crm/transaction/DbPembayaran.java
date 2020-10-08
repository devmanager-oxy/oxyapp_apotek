
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */
package com.project.crm.transaction;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.crm.master.DbLot;
import com.project.crm.master.Lot;
import com.project.fms.transaction.*;
import com.project.fms.transaction.*;
import com.project.crm.sewa.*;
import com.project.general.*;
import com.project.payroll.DbDepartment;
import com.project.payroll.Department;
import com.project.simprop.property.DbPaymentSimulation;
import com.project.simprop.property.DbSalesData;
import com.project.simprop.property.PaymentSimulation;
import com.project.simprop.property.SalesData;
import com.project.system.DbSystemProperty;

public class DbPembayaran extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_CRM_PEMBAYARAN = "crm_pembayaran";
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
    public static final int COL_BANK_ID = 27;
    
    public static final String[] colNames = {
        "pembayaran_id",
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
        "memo",
        "bank_id"
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
        TYPE_STRING,
        TYPE_LONG
    };
    
    //contanta
    public static final int PAYMENT_TYPE_CASH       = 0;
    public static final int PAYMENT_TYPE_BANK       = 1;
    public static final int PAYMENT_TYPE_BG         = 2;
    public static final int PAYMENT_TYPE_CC         = 2;
    
    public static final String[] paymentTypeStr = {"Cash", "Transfer","BG","Credit Card/Debit"};
    
    public static final int PAYMENT_SOURCE_IRIGASI = 0;
    public static final int PAYMENT_SOURCE_LIMBAH = 1;
    public static final int PAYMENT_SOURCE_KOMIN = 2;
    public static final int PAYMENT_SOURCE_KOMPER = 3;
    public static final int PAYMENT_SOURCE_ASSESMENT = 4;
    public static final int PAYMENT_SOURCE_DENDA = 5;
    
    public static final String[] paymentSourceStr = {"IRIGASI", "LIMBAH", "KOMP. MINIMUM", "KOMP. PERSENTASE", "ASSESMENT", "DENDA"};
    public static final int DOCUMENT_STATUS_DRAFT = 0;
    public static final int DOCUMENT_STATUS_POSTING = 1;
    public static final String[] statusDocumentStr = {"Draft", "Posted"};
    public static int STATUS_BAYAR_OPEN = 0;
    public static int STATUS_BAYAR_LUNAS = 1;
    public static String[] stsBayarStr = {"Belum Lunas", "Lunas"};

    public DbPembayaran() {
    }

    public DbPembayaran(int i) throws CONException {
        super(new DbPembayaran());
    }

    public DbPembayaran(String sOid) throws CONException {
        super(new DbPembayaran(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPembayaran(long lOid) throws CONException {
        super(new DbPembayaran(0));
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
        return DB_CRM_PEMBAYARAN;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPembayaran().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Pembayaran pembayaran = fetchExc(ent.getOID());
        ent = (Entity) pembayaran;
        return pembayaran.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Pembayaran) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Pembayaran) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Pembayaran fetchExc(long oid) throws CONException {
        try {
            Pembayaran pembayaran = new Pembayaran();
            DbPembayaran pstPembayaran = new DbPembayaran(oid);
            pembayaran.setOID(oid);

            pembayaran.setTransactionSource(pstPembayaran.getInt(COL_TRANSACTION_SOURCE));
            pembayaran.setType(pstPembayaran.getInt(COL_TYPE));
            pembayaran.setNoBkm(pstPembayaran.getString(COL_NO_BKM));
            pembayaran.setCounter(pstPembayaran.getInt(COL_COUNTER));
            pembayaran.setNoKwitansi(pstPembayaran.getString(COL_NO_KWITANSI));
            pembayaran.setNoInvoice(pstPembayaran.getString(COL_NO_INVOICE));
            pembayaran.setTanggalInvoice(pstPembayaran.getDate(COL_TANGGAL_INVOICE));
            pembayaran.setTanggal(pstPembayaran.getDate(COL_TANGGAL));
            pembayaran.setMataUangId(pstPembayaran.getlong(COL_MATA_UANG_ID));
            pembayaran.setExchangeRate(pstPembayaran.getdouble(COL_EXCHANGE_RATE));
            pembayaran.setCustomerId(pstPembayaran.getlong(COL_CUSTOMER_ID));
            pembayaran.setIrigasiTransactionId(pstPembayaran.getlong(COL_IRIGASI_TRANSACTION_ID));
            pembayaran.setLimbahTransactionId(pstPembayaran.getlong(COL_LIMBAH_TRANSACTION_ID));
            pembayaran.setJumlah(pstPembayaran.getdouble(COL_JUMLAH));
            pembayaran.setCreateById(pstPembayaran.getlong(COL_CREATE_BY_ID));
            pembayaran.setPostedById(pstPembayaran.getlong(COL_POSTED_BY_ID));
            pembayaran.setPostedDate(pstPembayaran.getDate(COL_POSTED_DATE));
            pembayaran.setPeriodId(pstPembayaran.getlong(COL_PERIOD_ID));
            pembayaran.setGlId(pstPembayaran.getlong(COL_GL_ID));
            pembayaran.setStatus(pstPembayaran.getInt(COL_STATUS));
            pembayaran.setPaymentAccountId(pstPembayaran.getlong(COL_PAYMENT_ACCOUNT_ID));
            pembayaran.setSewaTanahInvoiceId(pstPembayaran.getlong(COL_SEWA_TANAH_INVOICE_ID));
            pembayaran.setSewaTanahBenefitId(pstPembayaran.getlong(COL_SEWA_TANAH_BENEFIT_ID));
            pembayaran.setDendaId(pstPembayaran.getlong(COL_DENDA_ID));
            pembayaran.setForeignAmount(pstPembayaran.getdouble(COL_FOREIGN_AMOUNT));
            pembayaran.setMemo(pstPembayaran.getString(COL_MEMO));
            pembayaran.setBankId(pstPembayaran.getlong(COL_BANK_ID));

            return pembayaran;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPembayaran(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Pembayaran pembayaran) throws CONException {
        try {
            DbPembayaran pstPembayaran = new DbPembayaran(0);

            pstPembayaran.setInt(COL_TRANSACTION_SOURCE, pembayaran.getTransactionSource());
            pstPembayaran.setInt(COL_TYPE, pembayaran.getType());
            pstPembayaran.setString(COL_NO_BKM, pembayaran.getNoBkm());
            pstPembayaran.setInt(COL_COUNTER, pembayaran.getCounter());
            pstPembayaran.setString(COL_NO_KWITANSI, pembayaran.getNoKwitansi());
            pstPembayaran.setString(COL_NO_INVOICE, pembayaran.getNoInvoice());
            pstPembayaran.setDate(COL_TANGGAL_INVOICE, pembayaran.getTanggalInvoice());
            pstPembayaran.setDate(COL_TANGGAL, pembayaran.getTanggal());
            pstPembayaran.setLong(COL_MATA_UANG_ID, pembayaran.getMataUangId());
            pstPembayaran.setDouble(COL_EXCHANGE_RATE, pembayaran.getExchangeRate());
            pstPembayaran.setLong(COL_CUSTOMER_ID, pembayaran.getCustomerId());
            pstPembayaran.setLong(COL_IRIGASI_TRANSACTION_ID, pembayaran.getIrigasiTransactionId());
            pstPembayaran.setLong(COL_LIMBAH_TRANSACTION_ID, pembayaran.getLimbahTransactionId());
            pstPembayaran.setDouble(COL_JUMLAH, pembayaran.getJumlah());
            pstPembayaran.setLong(COL_CREATE_BY_ID, pembayaran.getCreateById());
            pstPembayaran.setLong(COL_POSTED_BY_ID, pembayaran.getPostedById());
            pstPembayaran.setDate(COL_POSTED_DATE, pembayaran.getPostedDate());
            pstPembayaran.setLong(COL_PERIOD_ID, pembayaran.getPeriodId());
            pstPembayaran.setLong(COL_GL_ID, pembayaran.getGlId());
            pstPembayaran.setInt(COL_STATUS, pembayaran.getStatus());
            pstPembayaran.setLong(COL_PAYMENT_ACCOUNT_ID, pembayaran.getPaymentAccountId());
            pstPembayaran.setLong(COL_SEWA_TANAH_INVOICE_ID, pembayaran.getSewaTanahInvoiceId());
            pstPembayaran.setLong(COL_SEWA_TANAH_BENEFIT_ID, pembayaran.getSewaTanahBenefitId());
            pstPembayaran.setLong(COL_DENDA_ID, pembayaran.getDendaId());
            pstPembayaran.setDouble(COL_FOREIGN_AMOUNT, pembayaran.getForeignAmount());
            pstPembayaran.setString(COL_MEMO, pembayaran.getMemo());
            pstPembayaran.setLong(COL_BANK_ID, pembayaran.getBankId());

            pstPembayaran.insert();
            pembayaran.setOID(pstPembayaran.getlong(COL_PEMBAYARAN_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPembayaran(0), CONException.UNKNOWN);
        }
        return pembayaran.getOID();
    }

    public static long updateExc(Pembayaran pembayaran) throws CONException {
        try {
            if (pembayaran.getOID() != 0) {
                DbPembayaran pstPembayaran = new DbPembayaran(pembayaran.getOID());

                pstPembayaran.setInt(COL_TRANSACTION_SOURCE, pembayaran.getTransactionSource());
                pstPembayaran.setInt(COL_TYPE, pembayaran.getType());
                pstPembayaran.setString(COL_NO_BKM, pembayaran.getNoBkm());
                pstPembayaran.setInt(COL_COUNTER, pembayaran.getCounter());
                pstPembayaran.setString(COL_NO_KWITANSI, pembayaran.getNoKwitansi());
                pstPembayaran.setString(COL_NO_INVOICE, pembayaran.getNoInvoice());
                pstPembayaran.setDate(COL_TANGGAL_INVOICE, pembayaran.getTanggalInvoice());
                pstPembayaran.setDate(COL_TANGGAL, pembayaran.getTanggal());
                pstPembayaran.setLong(COL_MATA_UANG_ID, pembayaran.getMataUangId());
                pstPembayaran.setDouble(COL_EXCHANGE_RATE, pembayaran.getExchangeRate());
                pstPembayaran.setLong(COL_CUSTOMER_ID, pembayaran.getCustomerId());
                pstPembayaran.setLong(COL_IRIGASI_TRANSACTION_ID, pembayaran.getIrigasiTransactionId());
                pstPembayaran.setLong(COL_LIMBAH_TRANSACTION_ID, pembayaran.getLimbahTransactionId());
                pstPembayaran.setDouble(COL_JUMLAH, pembayaran.getJumlah());
                pstPembayaran.setLong(COL_CREATE_BY_ID, pembayaran.getCreateById());
                pstPembayaran.setLong(COL_POSTED_BY_ID, pembayaran.getPostedById());
                pstPembayaran.setDate(COL_POSTED_DATE, pembayaran.getPostedDate());
                pstPembayaran.setLong(COL_PERIOD_ID, pembayaran.getPeriodId());
                pstPembayaran.setLong(COL_GL_ID, pembayaran.getGlId());
                pstPembayaran.setInt(COL_STATUS, pembayaran.getStatus());
                pstPembayaran.setLong(COL_PAYMENT_ACCOUNT_ID, pembayaran.getPaymentAccountId());
                pstPembayaran.setLong(COL_SEWA_TANAH_INVOICE_ID, pembayaran.getSewaTanahInvoiceId());
                pstPembayaran.setLong(COL_SEWA_TANAH_BENEFIT_ID, pembayaran.getSewaTanahBenefitId());
                pstPembayaran.setLong(COL_DENDA_ID, pembayaran.getDendaId());
                pstPembayaran.setDouble(COL_FOREIGN_AMOUNT, pembayaran.getForeignAmount());
                pstPembayaran.setString(COL_MEMO, pembayaran.getMemo());
                pstPembayaran.setLong(COL_BANK_ID, pembayaran.getBankId());

                pstPembayaran.update();
                return pembayaran.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPembayaran(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPembayaran pstPembayaran = new DbPembayaran(oid);
            pstPembayaran.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPembayaran(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_CRM_PEMBAYARAN;
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
                Pembayaran pembayaran = new Pembayaran();
                resultToObject(rs, pembayaran);
                lists.add(pembayaran);
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

    private static void resultToObject(ResultSet rs, Pembayaran pembayaran) {
        try {
            pembayaran.setOID(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID]));
            pembayaran.setTransactionSource(rs.getInt(DbPembayaran.colNames[DbPembayaran.COL_TRANSACTION_SOURCE]));
            pembayaran.setType(rs.getInt(DbPembayaran.colNames[DbPembayaran.COL_TYPE]));
            pembayaran.setNoBkm(rs.getString(DbPembayaran.colNames[DbPembayaran.COL_NO_BKM]));
            pembayaran.setCounter(rs.getInt(DbPembayaran.colNames[DbPembayaran.COL_COUNTER]));
            pembayaran.setNoKwitansi(rs.getString(DbPembayaran.colNames[DbPembayaran.COL_NO_KWITANSI]));
            pembayaran.setNoInvoice(rs.getString(DbPembayaran.colNames[DbPembayaran.COL_NO_INVOICE]));
            pembayaran.setTanggalInvoice(rs.getDate(DbPembayaran.colNames[DbPembayaran.COL_TANGGAL_INVOICE]));
            pembayaran.setTanggal(rs.getDate(DbPembayaran.colNames[DbPembayaran.COL_TANGGAL]));
            pembayaran.setMataUangId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_MATA_UANG_ID]));
            pembayaran.setExchangeRate(rs.getDouble(DbPembayaran.colNames[DbPembayaran.COL_EXCHANGE_RATE]));
            pembayaran.setCustomerId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_CUSTOMER_ID]));
            pembayaran.setIrigasiTransactionId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_IRIGASI_TRANSACTION_ID]));
            pembayaran.setLimbahTransactionId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID]));
            pembayaran.setJumlah(rs.getDouble(DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]));
            pembayaran.setCreateById(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_CREATE_BY_ID]));
            pembayaran.setPostedById(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_POSTED_BY_ID]));
            pembayaran.setPostedDate(rs.getDate(DbPembayaran.colNames[DbPembayaran.COL_POSTED_DATE]));
            pembayaran.setPeriodId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_PERIOD_ID]));
            pembayaran.setGlId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_GL_ID]));
            pembayaran.setStatus(rs.getInt(DbPembayaran.colNames[DbPembayaran.COL_STATUS]));
            pembayaran.setPaymentAccountId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_PAYMENT_ACCOUNT_ID]));
            pembayaran.setSewaTanahInvoiceId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]));
            pembayaran.setSewaTanahBenefitId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_BENEFIT_ID]));
            pembayaran.setDendaId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_DENDA_ID]));
            pembayaran.setForeignAmount(rs.getDouble(DbPembayaran.colNames[DbPembayaran.COL_FOREIGN_AMOUNT]));
            pembayaran.setMemo(rs.getString(DbPembayaran.colNames[DbPembayaran.COL_MEMO]));
            pembayaran.setBankId(rs.getLong(DbPembayaran.colNames[DbPembayaran.COL_BANK_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long pembayaranId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CRM_PEMBAYARAN + " WHERE " +
                    DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID] + " = " + pembayaranId;

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
            String sql = "SELECT COUNT(" + DbPembayaran.colNames[DbPembayaran.COL_PEMBAYARAN_ID] + ") FROM " + DB_CRM_PEMBAYARAN;
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
                    Pembayaran pembayaran = (Pembayaran) list.get(ls);
                    if (oid == pembayaran.getOID()) {
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

    public static IrigasiTransaction getTransaksiIrigasi(long periodId, long unitUsahaId) {
        String where = DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID] + "=" + periodId + " and " +
                DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID] + "=" + unitUsahaId;

        Vector temp = DbIrigasiTransaction.list(0, 1, where, "");

        if (temp != null && temp.size() > 0) {
            return (IrigasiTransaction) temp.get(0);
        }

        return new IrigasiTransaction();

    }

    public static LimbahTransaction getTransaksiLimbah(long periodId, long unitUsahaId) {
        String where = DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID] + "=" + periodId + " and " +
                DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID] + "=" + unitUsahaId;

        Vector temp = DbLimbahTransaction.list(0, 1, where, "");

        if (temp != null && temp.size() > 0) {
            return (LimbahTransaction) temp.get(0);
        }

        return new LimbahTransaction();

    }

    public static Pembayaran getPembayaranIrigasi(long irigasiId) {
        String where = colNames[COL_IRIGASI_TRANSACTION_ID] + "=" + irigasiId;

        Vector temp = list(0, 1, where, "");

        if (temp != null && temp.size() > 0) {
            return (Pembayaran) temp.get(0);
        }

        return new Pembayaran();

    }

    public static Pembayaran getPembayaranLimbah(long limbahId) {
        String where = colNames[COL_LIMBAH_TRANSACTION_ID] + "=" + limbahId;

        Vector temp = list(0, 1, where, "");

        if (temp != null && temp.size() > 0) {
            return (Pembayaran) temp.get(0);
        }

        return new Pembayaran();

    }

    //POSTING ke journal - pembalikan pihutang/pembayaran
    public static long postJournal(Pembayaran cr) {

        long glId = 0;

        System.out.println("\n---- bean start posting journal pembayaran ---");

        Company comp = DbCompany.getCompany();

        IrigasiTransaction iri = new IrigasiTransaction();
        LimbahTransaction lim = new LimbahTransaction();
        Customer cus = new Customer();

        if (cr.getTransactionSource() == PAYMENT_SOURCE_IRIGASI) {
            try {
                iri = DbIrigasiTransaction.fetchExc(cr.getIrigasiTransactionId());
            } catch (Exception e) {
            }

        } else {
            try {
                lim = DbLimbahTransaction.fetchExc(cr.getLimbahTransactionId());
            } catch (Exception e) {
            }
        }

        try {
            cus = DbCustomer.fetchExc(cr.getCustomerId());
        } catch (Exception e) {
        }

        //Pembayaran Bank - Invoice Irigasi 
        //Pembayaran Cash - Invoice Limbah

        String memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                ((cr.getTransactionSource() == PAYMENT_SOURCE_IRIGASI) ? " Invoice - Irigasi" : " Invoice - Limbah") +
                "(" + cr.getNoInvoice() + ")";

        if (cr.getOID() != 0) {

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), cr.getCounter(), cr.getNoBkm(), cr.getNoBkm(),
                    I_Project.JOURNAL_TYPE_CASH_RECEIVE,
                    memo, cr.getPostedById(), "", cr.getOID(), cr.getNoBkm(), cr.getTanggal());

            glId = oid;

            //pengakuan pembayaran
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                //journal debet cash/bank
                DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                        cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

             

                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);

            }
        }

        return glId;
    }
    
    /**
     * Fungsi ini bertugas untuk melakukan posting data Pembayaran ke BKM
     * Kondisi :
     * - Jenis transaksi : Limbah, Irigasi, Assesment, Komin dan Komper
     * - Tipe transaksi : Kas dan Bank
     * 
     * @Author gwawan
     * @param objPembayaran
     * @return oid BKM
     * 
     */
    public static long postingBKM(Pembayaran pembayaran) {
        if(pembayaran.getOID() == 0) return 0;
        
        try {
            long departmentId = 0;
            String ID_DEPARTMENT = DbSystemProperty.getValueByName("ID_DEPARTMENT");
            if (ID_DEPARTMENT.equals("Not initialized")) {
                return 0;
            } else {
                departmentId = Long.parseLong(ID_DEPARTMENT);
                Department d = DbDepartment.fetchExc(departmentId);
                if (d.getOID() == 0) {
                    return 0;
                }
            }
            
            long oidCurrrencyRp = 0;
            String OID_CURRENCY_RP = DbSystemProperty.getValueByName("OID_CURRENCY_RP");
            if(OID_CURRENCY_RP.equals("Not initialized")) return 0;
            else oidCurrrencyRp = Long.parseLong(OID_CURRENCY_RP);
            
            Customer customer = DbCustomer.fetchExc(pembayaran.getCustomerId());
            Company company = DbCompany.getCompany();
            String memo = customer.getName() + " - PEMBAYARAN " + paymentSourceStr[pembayaran.getTransactionSource()] + " " + pembayaran.getNoInvoice() + 
                    " (" + ((pembayaran.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") + ")";
            
        
            
            double totalRp = 0;
            if(pembayaran.getMataUangId() == oidCurrrencyRp) totalRp = pembayaran.getJumlah();
            else totalRp = pembayaran.getJumlah() * pembayaran.getExchangeRate();
            
            CrmPost crmPost = new CrmPost();
            crmPost.setTransactionSource(pembayaran.getTransactionSource()); // cash or bank
            crmPost.setReferensiId(pembayaran.getOID());
            crmPost.setJournalNumber(pembayaran.getNoBkm());
            crmPost.setJournalCounter(pembayaran.getCounter());
            crmPost.setJournalPrefix("");
            crmPost.setCurrencyId(oidCurrrencyRp);
            crmPost.setAmount(totalRp); //total pembayaran dalam Rp
            crmPost.setForeignCurrencyId(pembayaran.getMataUangId());
            crmPost.setForeignAmount(pembayaran.getJumlah());
            crmPost.setBookedRate(pembayaran.getExchangeRate());
            crmPost.setMemo(memo);
            crmPost.setPostedById(pembayaran.getPostedById());
            crmPost.setDate(pembayaran.getTanggalInvoice()); //tanggal invoice
            crmPost.setDateTransaction(pembayaran.getTanggal()); //tanggal pembayaran
            crmPost.setPeriodeId(pembayaran.getPeriodId());
            crmPost.setDepartmentId(departmentId);
            crmPost.setSaranaId(pembayaran.getCustomerId());
            
            crmPost.setLimbahTransactionId(pembayaran.getLimbahTransactionId());
            crmPost.setIrigasiTransactionId(pembayaran.getIrigasiTransactionId());
            crmPost.setSewaTanahInvoiceId(pembayaran.getSewaTanahInvoiceId());
            crmPost.setSewaTanahBenefitId(pembayaran.getSewaTanahBenefitId());
            
            crmPost.setPaymentAccountId(pembayaran.getPaymentAccountId()); //bkm debet
            
            
            long oidBKM = 0;
            if(pembayaran.getType() == DbPembayaran.PAYMENT_TYPE_BANK) {
                crmPost.setType(I_Project.JOURNAL_TYPE_BANK_DEPOSIT);
                
                //posting ke bank deposit
                DbBankDeposit dbBankDeposit = new DbBankDeposit();
                oidBKM = dbBankDeposit.insertBKM(crmPost);
            } else {
                crmPost.setType(I_Project.JOURNAL_TYPE_CASH_RECEIVE);
                
                //posting ke cash receive
                DbCashReceive dbCashReceive = new DbCashReceive();
                oidBKM = dbCashReceive.insertBKM(crmPost);
            }
            
            //update status dokumen pembayaran di CRM
            if(oidBKM != 0) {
                pembayaran.setGlId(oidBKM);
                pembayaran.setStatus(DbPembayaran.DOCUMENT_STATUS_POSTING);
                DbPembayaran.updateExc(pembayaran);
            }
            return oidBKM;
            
        } catch(Exception e) {
            return 0;
        }
    }

    /**
     * @Author  Roy Andika
     * @Desc    Untuk memposting data ke finance CRM (cash receive)
     * @return
     */
    public static long postingKas(Pembayaran cr){

        long departmentId = 0;

        try {

            try {
                String ID_DEPARTMENT = DbSystemProperty.getValueByName("ID_DEPARTMENT");
                if (ID_DEPARTMENT.equals("Not initialized")) {
                    return 0;
                } else {
                    departmentId = Long.parseLong(ID_DEPARTMENT);
                    Department d = DbDepartment.fetchExc(departmentId);
                    if (d.getOID() == 0) {
                        return 0;
                    }
                }
            } catch (Exception e) {
                System.out.println(e.toString());
                return 0;
            }

            Customer cus = new Customer();

            try {
                cus = DbCustomer.fetchExc(cr.getCustomerId());
            } catch (Exception e) {
                System.out.println("[exception fetch employee] : " + e.toString());
            }

            if (cus.getOID() == 0) {
                return 0;
            }
            
            Company comp = DbCompany.getCompany();

            String memo = "";
            double totpembayaran = 0;
            double totalHarusDByr = 0;
            boolean pembayaranLunas = false;

            if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_LIMBAH){

                memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                        " Invoice - Limbah" +
                        "(" + cr.getNoInvoice() + ")";
                String wherePembLimbah = DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID] + " = " + cr.getLimbahTransactionId();
                totpembayaran = sumPembayaran(wherePembLimbah);

            } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_IRIGASI) {

                memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                        " Invoice - Irigasi" +
                        "(" + cr.getNoInvoice() + ")";
                String wherePembIrigasi = DbPembayaran.colNames[DbPembayaran.COL_IRIGASI_TRANSACTION_ID] + " = " + cr.getIrigasiTransactionId();
                totpembayaran = sumPembayaran(wherePembIrigasi);

            } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMIN) {

                memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                        " Invoice - Kompensasi Minimum" +
                        "(" + cr.getNoInvoice() + ")";
                String wherePembKomin = DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] + " = " + cr.getSewaTanahInvoiceId();
                totpembayaran = sumPembayaran(wherePembKomin);

            } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_ASSESMENT) {

                memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                        " Invoice - Assesment" +
                        "(" + cr.getNoInvoice() + ")";
                String wherePembKomin = DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] + " = " + cr.getSewaTanahInvoiceId();
                totpembayaran = sumPembayaran(wherePembKomin);

            } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMPER) {

                memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                        " Invoice - Kompensasi Persentase" +
                        "(" + cr.getNoInvoice() + ")";
                String wherePembKomin = DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_BENEFIT_ID] + " = " + cr.getSewaTanahBenefitId();
                totpembayaran = sumPembayaran(wherePembKomin);
            }

            try {
                totalHarusDByr = statusPembayaran(cr);
            } catch (Exception E) {
                System.out.println("[exception] get Total Pembayaran : " + E.toString());
            }

            //jika pembayaran yang dilakukan sudah lunas
            if (totpembayaran >= totalHarusDByr){
                pembayaranLunas = true;
            }

           
         

            if (cr.getOID() != 0){  // jika OID nya tdk = 0                
                
                //insert ke table cash receive
                CrmPost crmPost = new CrmPost();
                crmPost.setReferensiId(cr.getOID());
                crmPost.setJournalNumber(cr.getNoBkm());
                crmPost.setJournalCounter(cr.getCounter());
                crmPost.setJournalPrefix("");
                crmPost.setCurrencyId(cr.getMataUangId());
                crmPost.setType(I_Project.JOURNAL_TYPE_CASH_RECEIVE);
                crmPost.setMemo(memo);
                crmPost.setPostedById(cr.getPostedById());                
                crmPost.setDate(cr.getTanggalInvoice());
                crmPost.setDateTransaction(cr.getTanggal());
                crmPost.setPeriodeId(cr.getPeriodId());                
                crmPost.setPaymentAccountId(cr.getPaymentAccountId());
                crmPost.setAmount(cr.getJumlah());
                crmPost.setBookedRate(cr.getExchangeRate());
                 
                crmPost.setForeignAmount(cr.getJumlah());
                crmPost.setPostedById(cr.getPostedById());
                crmPost.setForeignCurrencyId(comp.getBookingCurrencyId());                
                crmPost.setTransactionSource(cr.getTransactionSource());                
                crmPost.setSewaTanahBenefitId(cr.getSewaTanahBenefitId());
                crmPost.setSewaTanahInvoiceId(cr.getSewaTanahInvoiceId());                
                crmPost.setLimbahTransactionId(cr.getLimbahTransactionId());
                crmPost.setIrigasiTransactionId(cr.getIrigasiTransactionId());                
                crmPost.setTotHarusDibayar(totalHarusDByr);
                crmPost.setTotPembayaran(totpembayaran);
                crmPost.setDepartmentId(departmentId);
                crmPost.setSaranaId(cr.getCustomerId());
                
                if(pembayaranLunas){
                    crmPost.setStatusPembayaran(true);
                }else{
                    crmPost.setStatusPembayaran(false);
                }
                
                DbCashReceive dbCashReceive = new DbCashReceive();
                        
                long oid = dbCashReceive.insertBKMv1(crmPost);
                
                return oid;                        
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        return 0;
    }

    //POSTING ke journal - pembalikan pihutang/pembayaran
    public static long postingJournal(Pembayaran cr) {

        //Set Department ID
        long departmentId = 0;
        try {
            String ID_DEPARTMENT = DbSystemProperty.getValueByName("ID_DEPARTMENT");
            if (ID_DEPARTMENT.equals("Not initialized")) {
                return 0;
            } else {
                departmentId = Long.parseLong(ID_DEPARTMENT);
                Department d = DbDepartment.fetchExc(departmentId);
                if (d.getOID() == 0) {
                    return 0;
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
            return 0;
        }

        long glId = 0;

        System.out.println("\n---- bean start posting journal pembayaran ---");

        Company comp = DbCompany.getCompany();

        String memo = "";

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(cr.getCustomerId());
        } catch (Exception e) { System.out.println("[exception] " + e.toString()); }

        if (cus.getOID() == 0) {
            return 0;
        }

        //pengecekan account yang digunakan / accoutn yang digunakan tidak boleh kosong       
        //boolean lunas = false

        double totalHarusDByr = 0;
        boolean pembayaranLunas = false;

        //Pembayaran Bank - Invoice Irigasi 
        //Pembayaran Cash - Invoice Limbah

        double totpembayaran = 0;

        if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_LIMBAH) {

            memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                    " Invoice - Limbah" +
                    "(" + cr.getNoInvoice() + ")";
            String wherePembLimbah = DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID] + " = " + cr.getLimbahTransactionId();
            totpembayaran = sumPembayaran(wherePembLimbah);

        } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_IRIGASI) {

            memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                    " Invoice - Limbah" +
                    "(" + cr.getNoInvoice() + ")";
            String wherePembIrigasi = DbPembayaran.colNames[DbPembayaran.COL_IRIGASI_TRANSACTION_ID] + " = " + cr.getIrigasiTransactionId();
            totpembayaran = sumPembayaran(wherePembIrigasi);

        } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMIN) {

            memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                    " Invoice - Sewa Tanah Komin" +
                    "(" + cr.getNoInvoice() + ")";
            String wherePembKomin = DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] + " = " + cr.getSewaTanahInvoiceId();
            totpembayaran = sumPembayaran(wherePembKomin);

        } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_ASSESMENT) {

            memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                    " Invoice - Sewa Tanah Assesment" +
                    "(" + cr.getNoInvoice() + ")";
            String wherePembKomin = DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] + " = " + cr.getSewaTanahInvoiceId();
            totpembayaran = sumPembayaran(wherePembKomin);

        } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMPER) {

            memo = cus.getName() + " - Pembayaran " + ((cr.getType() == PAYMENT_TYPE_CASH) ? "Cash" : "Bank") +
                    " Invoice - Sewa Tanah Komper" +
                    "(" + cr.getNoInvoice() + ")";
            String wherePembKomin = DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_BENEFIT_ID] + " = " + cr.getSewaTanahBenefitId();
            totpembayaran = sumPembayaran(wherePembKomin);

        }

        try {
            totalHarusDByr = statusPembayaran(cr);
        } catch (Exception E) {
            System.out.println("[exception] get Total Pembayaran : " + E.toString());
        }

        //jika pembayaran yang dilakukan sudah lunas
        if (totpembayaran >= totalHarusDByr) {
            pembayaranLunas = true;
        }



        if (cr.getOID() != 0) {

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)
            long oid = DbGl.postJournalMain(0, new Date(), cr.getCounter(), cr.getNoBkm(), cr.getNoBkm(),
                    I_Project.JOURNAL_TYPE_CASH_RECEIVE,
                    memo, cr.getPostedById(), "", cr.getOID(), cr.getNoBkm(), cr.getTanggal());

            glId = oid;

            //pengakuan pembayaran
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                if (pembayaranLunas) { // jika pembayaran sudah lunas

                    double selisih = totpembayaran - totalHarusDByr;

                    //jika pembayarannya sudah lunas tetapi denda belum lunas
                    if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_LIMBAH){

                        boolean stsLimbah = stsPembayaranLimbah(cr.getLimbahTransactionId());

                        if (stsLimbah == false){ // jika pembayarannya belum lunas

                            //journal debet cash/bank
                            DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, departmentId);//non departmenttal item, department id = 0

                            //journal credit AR
                         

                        } else { // jika sudah lunas

                            LimbahTransaction limTransaction = new LimbahTransaction();

                            try {
                                limTransaction = DbLimbahTransaction.fetchExc(cr.getLimbahTransactionId());
                            } catch (Exception e) {
                            }

                            //journal debet cash/bank
                            DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, departmentId);//non departmenttal item, department id = 0

                            //journal Kredit Pendapatan Terima di muka
                           
                        }

                    } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_IRIGASI){

                        boolean stsIrigasi = stsPembayaranIrigasi(cr.getIrigasiTransactionId());

                        if (stsIrigasi == false){

                            //journal debet cash/bank
                            DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, departmentId);//non departmenttal item, department id = 0

                          

                        } else {

                            IrigasiTransaction iriTransaction = new IrigasiTransaction();

                            try {
                                iriTransaction = DbIrigasiTransaction.fetchExc(cr.getIrigasiTransactionId());
                            } catch (Exception e) {
                            }

                            //journal debet cash/bank
                            DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, departmentId);//non departmenttal item, department id = 0

                            //journal Kredit Pendapatan Terima di muka
                           

                        }

                    } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMIN){

                        boolean stsKomin = stsPembayaranSewaTanahInvoice(cr.getSewaTanahInvoiceId());

                        if (stsKomin == false) {

                            //journal debet cash/bank
                            DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, departmentId);//non departmenttal item, department id = 0

                         

                        } else {
                            
                            SewaTanahInvoice sewaTanahInv = new SewaTanahInvoice();
                            
                            try {
                                sewaTanahInv = DbSewaTanahInvoice.fetchExc(cr.getSewaTanahInvoiceId());
                            } catch (Exception e) {
                            }

                            //journal debet cash/bank
                            DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, departmentId);//non departmenttal item, department id = 0

                         
                        }

                    } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMPER){

                        boolean stsKomper = stsPembayaranSewaTanahKomper(cr.getSewaTanahBenefitId());

                        if (stsKomper == false) {

                            //journal debet cash/bank
                            DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, departmentId);//non departmenttal item, department id = 0

                        

                        } else {

                            SewaTanahInvoice sewaTanahInv = new SewaTanahInvoice();
                            
                            try {
                                sewaTanahInv = DbSewaTanahInvoice.fetchExc(cr.getSewaTanahInvoiceId());
                            } catch (Exception e) {
                            }

                            //journal debet cash/bank
                            DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, departmentId);//non departmenttal item, department id = 0


                        }

                    } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_ASSESMENT){

                        boolean stsAssesment = stsPembayaranSewaTanahInvoice(cr.getSewaTanahInvoiceId());

                        if (stsAssesment == false) {

                           

                        } else {

                            SewaTanahBenefit sewaTanahBenefit = new SewaTanahBenefit();

                            try {
                                sewaTanahBenefit = DbSewaTanahBenefit.fetchExc(cr.getSewaTanahBenefitId());
                            } catch (Exception e){
                            }

                        }
                    }

                } else {   // jika pembayarannya belum lunas        

                    if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_LIMBAH) {

                      
                    } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_IRIGASI) {

                    } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMIN) {

                       

                    } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMPER) {

                      

                    } else if (cr.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_ASSESMENT) {

                      
                    }
                }

                //journal debet cash/bank
                DbGl.postJournalDetail(cr.getExchangeRate(), cr.getPaymentAccountId(), 0, cr.getJumlah() * cr.getExchangeRate(),
                        cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, departmentId);//non departmenttal item, department id = 0


                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);

            }
        }

        return glId;
    }

    public static boolean isMoreThanTotInvoice(Pembayaran pembayaran, double totalInvoice, long invoiceCurrency) {
        long transactionId = 0;
        
        if (pembayaran.getIrigasiTransactionId() != 0) {
            transactionId = pembayaran.getIrigasiTransactionId();
        } else if (pembayaran.getLimbahTransactionId() != 0) {
            transactionId = pembayaran.getLimbahTransactionId();
        } else if (pembayaran.getSewaTanahInvoiceId() != 0) {
            transactionId = pembayaran.getSewaTanahInvoiceId();
        } else if (pembayaran.getSewaTanahBenefitId() != 0) {
            transactionId = pembayaran.getSewaTanahBenefitId();
        } else if (pembayaran.getDendaId() != 0) {
            transactionId = pembayaran.getDendaId();
        }
        
        double totalPembayaran = getTotPembayaran(pembayaran.getOID(), pembayaran.getTransactionSource(), transactionId, invoiceCurrency);
        double amount = totalPembayaran + pembayaran.getJumlah();
        if (totalInvoice < amount) {
            return true;
        }

        return false;
    }

    public static double getTotPembayaran(long pembayaranId, int transactionSource, long transactionId, long invoiceCurrency) {
        CONResultSet dbrs = null;

        try {
            /**
             * Proses perhitungan total pembayaran hanya support multi payment untuk 2 mata uang, IDR dan USD.
             */
            double totalPembayaran = 0;
            String where = colNames[COL_PEMBAYARAN_ID] + " != " + pembayaranId;
            
            String OID_CURR_DOLLAR = DbSystemProperty.getValueByName("OID_CURR_DOLLAR");
            long idUSD = 0;
            if(!OID_CURR_DOLLAR.equals("Not initialized")) idUSD = Long.parseLong(OID_CURR_DOLLAR);
            System.out.println(">>>> OID_CURR_DOLLAR : "+idUSD);

            if (transactionSource == DbPembayaran.PAYMENT_SOURCE_IRIGASI) {
                where += " AND " + DbPembayaran.colNames[DbPembayaran.COL_IRIGASI_TRANSACTION_ID] + " = " + transactionId;
            } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_LIMBAH) {
                where += " AND " + DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID] + " = " + transactionId;
            } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_KOMIN) {
                where += " AND " + DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] + " = " + transactionId;
            } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_ASSESMENT) {
                where += " AND " + DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] + " = " + transactionId;
            } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_DENDA) {
                where += " AND " + DbPembayaran.colNames[DbPembayaran.COL_DENDA_ID] + " = " + transactionId;
            } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_KOMPER) {
                where += " AND " + DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_BENEFIT_ID] + " = " + transactionId;
            }
            
            Vector vPembayaran = DbPembayaran.list(0, 0, where, "");
            
            if(vPembayaran != null) {
                for(int i=0; i<vPembayaran.size(); i++) {
                    Pembayaran objPembayaran = (Pembayaran)vPembayaran.get(i);
                    
                    if(invoiceCurrency == idUSD) { //invoice dalam USD
                        if(objPembayaran.getMataUangId() == idUSD) totalPembayaran += objPembayaran.getJumlah(); //USD
                        else totalPembayaran += (1/objPembayaran.getExchangeRate())*objPembayaran.getJumlah(); //IDR
                    } else { //invoice dalam IDR
                        if(objPembayaran.getMataUangId() == idUSD) totalPembayaran += objPembayaran.getJumlah()*objPembayaran.getExchangeRate(); //USD
                        else totalPembayaran += objPembayaran.getJumlah();
                    }
                }
            }
            
            System.out.println("totalPembayaran: "+totalPembayaran);
            
            return totalPembayaran;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;

    }

    public static void updateStatusInvoice(long transactionId, int transactionSource, double totalAmount, long invoiceCurrency) {

        if (transactionId != 0){

            double payment = getTotPembayaran(0, transactionSource, transactionId, invoiceCurrency);
            
            if (payment >= totalAmount) {
                if (transactionSource == DbPembayaran.PAYMENT_SOURCE_IRIGASI){
                    IrigasiTransaction iri = new IrigasiTransaction();
                    try {
                        iri = DbIrigasiTransaction.fetchExc(transactionId);
                        iri.setStatusPembayaran(STATUS_BAYAR_LUNAS);
                        DbIrigasiTransaction.updateExc(iri);
                    } catch (Exception e) {

                    }
                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_LIMBAH) {
                    LimbahTransaction lim = new LimbahTransaction();
                    try {
                        lim = DbLimbahTransaction.fetchExc(transactionId);
                        lim.setStatusPembayaran(STATUS_BAYAR_LUNAS);
                        DbLimbahTransaction.updateExc(lim);
                    } catch (Exception e) {

                    }
                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_KOMIN) {
                    SewaTanahInvoice sti = new SewaTanahInvoice();
                    try {
                        sti = DbSewaTanahInvoice.fetchExc(transactionId);
                        sti.setStatusPembayaran(STATUS_BAYAR_LUNAS);
                        DbSewaTanahInvoice.updateExc(sti);
                        
                        if(sti.getPaymentSimulationId() != 0){
                            PaymentSimulation ps = DbPaymentSimulation.fetchExc(sti.getPaymentSimulationId());
                            ps.setStatus(DbPaymentSimulation.STATUS_LUNAS);
                            
                            DbPaymentSimulation.updateExc(ps);                               
                            SalesData sd = new SalesData();
                            try{
                                sd = DbSalesData.fetchExc(ps.getSalesDataId());
                                Lot lot = DbLot.fetchExc(sd.getLotId());
                                if(ps.getPayment() == DbPaymentSimulation.PAYMENT_BF){
                                    sd.setStatus(DbSalesData.STATUS_BOOKED);
                                    lot.setStatus(DbLot.LOT_STATUS_BOOKED);
                                }else if(ps.getPayment() == DbPaymentSimulation.PAYMENT_DP){
                                    sd.setStatus(DbSalesData.STATUS_SOLD);
                                    lot.setStatus(DbLot.LOT_STATUS_SOLD);
                                }else if(ps.getPayment() == DbPaymentSimulation.PAYMENT_PELUNASAN){
                                    sd.setStatus(DbSalesData.STATUS_SOLD);
                                    lot.setStatus(DbLot.LOT_STATUS_SOLD);
                                }     
                                
                                DbSalesData.updateExc(sd);
                                DbLot.updateExc(lot);
                            }catch(Exception e){}
                        }
                    } catch (Exception e) {

                    }
                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_ASSESMENT) {
                    SewaTanahInvoice sti = new SewaTanahInvoice();
                    try {
                        sti = DbSewaTanahInvoice.fetchExc(transactionId);
                        sti.setStatusPembayaran(STATUS_BAYAR_LUNAS);
                        DbSewaTanahInvoice.updateExc(sti);
                    } catch (Exception e) {

                    }
                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_DENDA) {

                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_KOMPER) {
                    SewaTanahBenefit benef = new SewaTanahBenefit();
                    try {
                        benef = DbSewaTanahBenefit.fetchExc(transactionId);
                        benef.setStatusPembayaran(STATUS_BAYAR_LUNAS);
                        DbSewaTanahBenefit.updateExc(benef);
                    } catch (Exception e) {

                    }
                }
            } //jika tidak lunas
            else {
                if (transactionSource == DbPembayaran.PAYMENT_SOURCE_IRIGASI) {
                    IrigasiTransaction iri = new IrigasiTransaction();
                    try {
                        iri = DbIrigasiTransaction.fetchExc(transactionId);
                        iri.setStatusPembayaran(STATUS_BAYAR_OPEN);// ngurah: sebelumnya di set Status_bayar_lunas,
                        DbIrigasiTransaction.updateExc(iri);
                    } catch (Exception e) {

                    }
                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_LIMBAH) {
                    LimbahTransaction lim = new LimbahTransaction();
                    try {
                        lim = DbLimbahTransaction.fetchExc(transactionId);
                        lim.setStatusPembayaran(STATUS_BAYAR_OPEN);// ngurah: sebelumnya di set Status_bayar_lunas,
                        DbLimbahTransaction.updateExc(lim);
                    } catch (Exception e) {

                    }
                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_KOMIN) {
                    SewaTanahInvoice sti = new SewaTanahInvoice();
                    try {
                        sti = DbSewaTanahInvoice.fetchExc(transactionId);
                        sti.setStatusPembayaran(STATUS_BAYAR_OPEN);
                        DbSewaTanahInvoice.updateExc(sti);
                    } catch (Exception e) {

                    }
                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_ASSESMENT) {
                    SewaTanahInvoice sti = new SewaTanahInvoice();
                    try {
                        sti = DbSewaTanahInvoice.fetchExc(transactionId);
                        sti.setStatusPembayaran(STATUS_BAYAR_OPEN);
                        DbSewaTanahInvoice.updateExc(sti);
                    } catch (Exception e) {

                    }
                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_DENDA) {

                } else if (transactionSource == DbPembayaran.PAYMENT_SOURCE_KOMPER) {
                    SewaTanahBenefit benef = new SewaTanahBenefit();
                    try {
                        benef = DbSewaTanahBenefit.fetchExc(transactionId);
                        benef.setStatusPembayaran(STATUS_BAYAR_OPEN);
                        DbSewaTanahBenefit.updateExc(benef);
                    } catch (Exception e) {

                    }
                }
            }
        }

    }

    public static boolean stsPembayaranLimbah(long limbahTransactionId) {

        try {

            LimbahTransaction limbahTransaction = (LimbahTransaction) DbLimbahTransaction.fetchExc(limbahTransactionId);

            double totHarusDiBayar = limbahTransaction.getTotalHarga() + limbahTransaction.getDendaDiakui();
            double totPembayaran = 0;

            try {
                totPembayaran = getTotPembayaranLimbah(limbahTransactionId);
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            if (totHarusDiBayar <= totPembayaran) {
                return true;
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return false;
    }

    public static double getTotPembayaranLimbah(long limbahTransactionId) {

        CONResultSet dbrs = null;
        double total = 0;

        try {

            String sql = "SELECT SUM(" + DbPembayaran.colNames[DbPembayaran.COL_JUMLAH] + ") FROM " +
                    DbPembayaran.DB_CRM_PEMBAYARAN + " WHERE " + DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID] +
                    " = " + limbahTransactionId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                total = rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return total;
    }

    public static boolean stsPembayaranIrigasi(long irigasiTransactionId) {

        try {

            IrigasiTransaction irigasiTransaction = (IrigasiTransaction) DbIrigasiTransaction.fetchExc(irigasiTransactionId);

            double totHarusDiBayar = irigasiTransaction.getTotalHarga() + irigasiTransaction.getDendaDiakui();
            double totPembayaran = 0;

            try {
                totPembayaran = getTotPembayaranIrigasi(irigasiTransactionId);
            } catch (Exception e) {
            }

            if (totHarusDiBayar <= totPembayaran) {

                return true;

            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return false;
    }

    public static double getTotPembayaranIrigasi(long irigasiTransactionId) {

        CONResultSet dbrs = null;
        double total = 0;

        try {

            String sql = "SELECT SUM(" + DbPembayaran.colNames[DbPembayaran.COL_JUMLAH] + ") FROM " +
                    DbPembayaran.DB_CRM_PEMBAYARAN + " WHERE " + DbPembayaran.colNames[DbPembayaran.COL_IRIGASI_TRANSACTION_ID] +
                    " = " + irigasiTransactionId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                total = rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return total;
    }

    public static boolean stsPembayaranSewaTanahInvoice(long sewaTanahInvoiceId) {

        try {

            SewaTanahInvoice sewaTanahInvoice = (SewaTanahInvoice) DbSewaTanahInvoice.fetchExc(sewaTanahInvoiceId);

            double totHarusDiBayar = sewaTanahInvoice.getJumlah() + sewaTanahInvoice.getDendaDiakui();
            double totPembayaran = 0;

            try {
                totPembayaran = getTotPembayaranSewaTanah(sewaTanahInvoiceId);
            } catch (Exception e) {
            }

            if (totHarusDiBayar <= totPembayaran) {

                return true;

            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return false;
    }

    public static double getTotPembayaranSewaTanah(long sewaTanahInvoiceId) {

        CONResultSet dbrs = null;
        double total = 0;

        try {

            String sql = "SELECT SUM(" + DbPembayaran.colNames[DbPembayaran.COL_JUMLAH] + ") FROM " +
                    DbPembayaran.DB_CRM_PEMBAYARAN + " WHERE " + DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] +
                    " = " + sewaTanahInvoiceId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                total = rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return total;
    }

    public void updateExchangeRate(String sql) {
        CONResultSet dbrs = null;
        try {

            CONHandler.execUpdate(sql);


        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

    }

    public static boolean stsPembayaranSewaTanahKomper(long sewaTanahBenefitId) {

        try {

            SewaTanahBenefit sewaTanahBenefit = (SewaTanahBenefit) DbSewaTanahBenefit.fetchExc(sewaTanahBenefitId);

            double totHarusDiBayar = sewaTanahBenefit.getTotalKomper() + sewaTanahBenefit.getDendaDiakui();
            double totPembayaran = 0;

            try {
                totPembayaran = getTotPembayaranSewaTanahKomper(sewaTanahBenefitId);
            } catch (Exception e) {
            }

            if (totHarusDiBayar <= totPembayaran) {

                return true;

            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return false;
    }

    public static double getTotPembayaranSewaTanahKomper(long sewaTanahBenefitId) {

        CONResultSet dbrs = null;
        double total = 0;

        try {

            String sql = "SELECT SUM(" + DbPembayaran.colNames[DbPembayaran.COL_JUMLAH] + ") FROM " +
                    DbPembayaran.DB_CRM_PEMBAYARAN + " WHERE " + DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_BENEFIT_ID] +
                    " = " + sewaTanahBenefitId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                total = rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return total;
    }

    public static double statusPembayaran(Pembayaran pembayaran) {

        double totalPembayaran = 0;

        if (pembayaran.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_LIMBAH) {

            try {

                LimbahTransaction limbahTransaction = DbLimbahTransaction.fetchExc(pembayaran.getLimbahTransactionId());

                totalPembayaran = limbahTransaction.getTotalHarga();

            } catch (Exception e) {
                System.out.println("[exception] SOURCE LIMBAH " + e.toString());
            }

        } else if (pembayaran.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_IRIGASI) {

            try {

                LimbahTransaction limbahTransaction = DbLimbahTransaction.fetchExc(pembayaran.getLimbahTransactionId());
                totalPembayaran = limbahTransaction.getTotalHarga();

            } catch (Exception e) {
                System.out.println("[exception] SOURCE IRIGASI " + e.toString());
            }

        } else if (pembayaran.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMIN) {

            try {

                SewaTanahInvoice sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(pembayaran.getSewaTanahInvoiceId());
                totalPembayaran = sewaTanahInvoice.getJumlah();

            } catch (Exception e) {
                System.out.println("[exception] SOURCE KOMIN " + e.toString());
            }

        } else if (pembayaran.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMPER) {

            try {

                SewaTanahBenefit sewaTanahBenefit = DbSewaTanahBenefit.fetchExc(pembayaran.getSewaTanahBenefitId());
                totalPembayaran = sewaTanahBenefit.getTotalKomper();

            } catch (Exception e) {
                System.out.println("[exception] SOURCE KMPER " + e.toString());
            }

        } else if (pembayaran.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_ASSESMENT) {

            try {
                SewaTanahInvoice sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(pembayaran.getSewaTanahInvoiceId());
                totalPembayaran = sewaTanahInvoice.getJumlah();
            } catch (Exception e) {
                System.out.println("[exception] SOURCE ASSESMENT " + e.toString());
            }
        }

        return totalPembayaran;
    }

    public static double sumPembayaran(String where) {

        CONResultSet dbrs = null;
        double total = 0;

        try {

            String sql = "SELECT SUM(" + DbPembayaran.colNames[DbPembayaran.COL_JUMLAH] + ") FROM " + DbPembayaran.DB_CRM_PEMBAYARAN + " WHERE " + where;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                total = rs.getDouble(1);
            }

            return total;
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return total;

    }
    
    public static void delPembayaran(long sti) {

        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + DbPembayaran.DB_CRM_PEMBAYARAN + " WHERE " + DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID] + " = " + sti;
            CONHandler.execUpdate(sql);            
        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
}
