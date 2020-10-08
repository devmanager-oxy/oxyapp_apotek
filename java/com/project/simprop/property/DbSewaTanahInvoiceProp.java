/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.general.*;
import com.project.util.*;

/**
 *
 * @author Roy Andika
 */
public class DbSewaTanahInvoiceProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SEWA_TANAH_INVOICE_PROP = "crm_sewa_tanah_invoice";
    
    public static final int COL_SEWA_TANAH_INVOICE_ID = 0;
    public static final int COL_TANGGAL = 1;
    public static final int COL_INVESTOR_ID = 2;
    public static final int COL_SARANA_ID = 3;
    public static final int COL_CURRENCY_ID = 4;
    public static final int COL_JUMLAH = 5;
    public static final int COL_KETERANGAN = 6;
    public static final int COL_JATUH_TEMPO = 7;
    public static final int COL_SEWA_TANAH_ID = 8;
    public static final int COL_USER_ID = 9;
    public static final int COL_STATUS = 10;
    public static final int COL_TANGGAL_INPUT = 11;
    public static final int COL_COUNTER = 12;
    public static final int COL_PREFIX_NUMBER = 13;
    public static final int COL_NUMBER = 14;
    public static final int COL_TYPE = 15;
    public static final int COL_MASA_INVOICE_ID = 16;
    public static final int COL_JML_BULAN = 17;
    public static final int COL_NO_FP = 18;
    public static final int COL_TOTAL_DENDA = 19;
    public static final int COL_PPN_PERSEN = 20;
    public static final int COL_PPN = 21;
    public static final int COL_PPH_PERSEN = 22;
    public static final int COL_PPH = 23;
    public static final int COL_STATUS_PEMBAYARAN = 24;
    public static final int COL_DENDA_DIAKUI = 25;
    public static final int COL_DENDA_APPROVE_ID = 26;
    public static final int COL_DENDA_APPROVE_DATE = 27;
    public static final int COL_DENDA_KETERANGAN = 28;
    public static final int COL_DENDA_POST_STATUS = 29;
    public static final int COL_DENDA_CLIENT_NAME = 30;
    public static final int COL_DENDA_CLIENT_POSITION = 31;
    public static final int COL_PAYMENT_TYPE = 32;
    public static final int COL_PAYMENT_SIMULATION_ID = 33;
    public static final int COL_SALES_DATA_ID = 34;
    public static final int COL_STS_PRINT_XLS = 35;
    public static final int COL_STS_PRINT_PDF = 36;
    
    public static final String[] colNames = {
        "sewa_tanah_invoice_id",
        "tanggal",
        "investor_id",
        "sarana_id",
        "currency_id",
        "jumlah",
        "keterangan",
        "jatuh_tempo",
        "sewa_tanah_id",
        "user_id",
        "status",
        "tanggal_input",
        "counter",
        "prefix_number",
        "number",
        "type",
        "masa_invoice_id",
        "jml_bulan",
        "no_fp",
        "total_denda",
        "ppn_persen",
        "ppn",
        "pph_persen",
        "pph",
        "status_pembayaran",
        "denda_diakui",
        "denda_approve_id",
        "denda_approve_date",
        "denda_keterangan",
        "denda_post_status",
        "denda_client_name",
        "denda_client_position",
        "payment_type",
        "payment_simulation_id",
        "sales_data_id",
        "sts_print_xls",
        "sts_print_pdf"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_DATE,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT
    };
    public static int TYPE_INV_KOMIN = 0;
    public static int TYPE_INV_KOMPER = 1;
    public static int TYPE_INV_ASSESMENT = 2;
    public static String[] typeInvStr = {"Komin", "Komper", "Assesment"};
    public static int KOMIN_YR_MTH = 12;//komin tahunan inv dibuat bulan desember
    public static int KOMIN_TW_I_MTH = 3;
    public static int KOMIN_TW_II_MTH = 6;
    public static int KOMIN_TW_III_MTH = 9;
    public static int KOMIN_TW_IIV_MTH = 12;
    public static int KOMIN_SMS_MTH = 12;
    public static int INV_STATUS_DRAFT = 0;
    public static int INV_STATUS_SENT = 1;
    public static int INV_STATUS_POSTED = 2;
    public static String[] statusStr = {"Draft", "Terkirim", "Posted"};
    public static final int STATUS_DENDA_DRAFT = 0;
    public static final int STATUS_DENDA_POSTED = 1;
    public static final String[] Posted_sts_denda_key = {"DRAFT", "POSTED"};
    public static final int[] Posted_sts_denda_value = {0, 1};

    public DbSewaTanahInvoiceProp() {
    }

    public DbSewaTanahInvoiceProp(int i) throws CONException {
        super(new DbSewaTanahInvoiceProp());
    }

    public DbSewaTanahInvoiceProp(String sOid) throws CONException {
        super(new DbSewaTanahInvoiceProp(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSewaTanahInvoiceProp(long lOid) throws CONException {
        super(new DbSewaTanahInvoiceProp(0));
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
        return DB_SEWA_TANAH_INVOICE_PROP;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSewaTanahInvoiceProp().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SewaTanahInvoiceProp sewaTanahInvoiceProp = fetchExc(ent.getOID());
        ent = (Entity) sewaTanahInvoiceProp;
        return sewaTanahInvoiceProp.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SewaTanahInvoiceProp) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SewaTanahInvoiceProp) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SewaTanahInvoiceProp fetchExc(long oid) throws CONException {
        try {
            SewaTanahInvoiceProp sewaTanahInvoiceProp = new SewaTanahInvoiceProp();
            DbSewaTanahInvoiceProp pstSewaTanahInvoiceProp = new DbSewaTanahInvoiceProp(oid);
            sewaTanahInvoiceProp.setOID(oid);

            sewaTanahInvoiceProp.setTanggal(pstSewaTanahInvoiceProp.getDate(COL_TANGGAL));
            sewaTanahInvoiceProp.setInvestorId(pstSewaTanahInvoiceProp.getlong(COL_INVESTOR_ID));
            sewaTanahInvoiceProp.setSaranaId(pstSewaTanahInvoiceProp.getlong(COL_SARANA_ID));
            sewaTanahInvoiceProp.setCurrencyId(pstSewaTanahInvoiceProp.getlong(COL_CURRENCY_ID));
            sewaTanahInvoiceProp.setJumlah(pstSewaTanahInvoiceProp.getdouble(COL_JUMLAH));
            sewaTanahInvoiceProp.setKeterangan(pstSewaTanahInvoiceProp.getString(COL_KETERANGAN));
            sewaTanahInvoiceProp.setJatuhTempo(pstSewaTanahInvoiceProp.getDate(COL_JATUH_TEMPO));
            sewaTanahInvoiceProp.setSewaTanahId(pstSewaTanahInvoiceProp.getlong(COL_SEWA_TANAH_ID));
            sewaTanahInvoiceProp.setUserId(pstSewaTanahInvoiceProp.getlong(COL_USER_ID));
            sewaTanahInvoiceProp.setStatus(pstSewaTanahInvoiceProp.getInt(COL_STATUS));
            sewaTanahInvoiceProp.setTanggalInput(pstSewaTanahInvoiceProp.getDate(COL_TANGGAL_INPUT));
            sewaTanahInvoiceProp.setCounter(pstSewaTanahInvoiceProp.getInt(COL_COUNTER));
            sewaTanahInvoiceProp.setPrefixNumber(pstSewaTanahInvoiceProp.getString(COL_PREFIX_NUMBER));
            sewaTanahInvoiceProp.setNumber(pstSewaTanahInvoiceProp.getString(COL_NUMBER));
            sewaTanahInvoiceProp.setType(pstSewaTanahInvoiceProp.getInt(COL_TYPE));
            sewaTanahInvoiceProp.setMasaInvoiceId(pstSewaTanahInvoiceProp.getlong(COL_MASA_INVOICE_ID));
            sewaTanahInvoiceProp.setJmlBulan(pstSewaTanahInvoiceProp.getInt(COL_JML_BULAN));
            sewaTanahInvoiceProp.setNoFp(pstSewaTanahInvoiceProp.getString(COL_NO_FP));
            sewaTanahInvoiceProp.setTotalDenda(pstSewaTanahInvoiceProp.getdouble(COL_TOTAL_DENDA));
            sewaTanahInvoiceProp.setPphPersen(pstSewaTanahInvoiceProp.getdouble(COL_PPH_PERSEN));
            sewaTanahInvoiceProp.setPph(pstSewaTanahInvoiceProp.getdouble(COL_PPH));
            sewaTanahInvoiceProp.setPpnPersen(pstSewaTanahInvoiceProp.getdouble(COL_PPN_PERSEN));
            sewaTanahInvoiceProp.setPpn(pstSewaTanahInvoiceProp.getdouble(COL_PPN));
            sewaTanahInvoiceProp.setStatusPembayaran(pstSewaTanahInvoiceProp.getInt(COL_STATUS_PEMBAYARAN));
            sewaTanahInvoiceProp.setDendaDiakui(pstSewaTanahInvoiceProp.getdouble(COL_DENDA_DIAKUI));
            sewaTanahInvoiceProp.setDendaApproveId(pstSewaTanahInvoiceProp.getlong(COL_DENDA_APPROVE_ID));
            sewaTanahInvoiceProp.setDendaApproveDate(pstSewaTanahInvoiceProp.getDate(COL_DENDA_APPROVE_DATE));
            sewaTanahInvoiceProp.setDendaKeterangan(pstSewaTanahInvoiceProp.getString(COL_DENDA_KETERANGAN));
            sewaTanahInvoiceProp.setDendaPostStatus(pstSewaTanahInvoiceProp.getInt(COL_DENDA_POST_STATUS));
            sewaTanahInvoiceProp.setDendaClientName(pstSewaTanahInvoiceProp.getString(COL_DENDA_CLIENT_NAME));
            sewaTanahInvoiceProp.setDendaClientPosition(pstSewaTanahInvoiceProp.getString(COL_DENDA_CLIENT_POSITION));
            sewaTanahInvoiceProp.setPaymentType(pstSewaTanahInvoiceProp.getInt(COL_PAYMENT_TYPE));
            sewaTanahInvoiceProp.setPaymentSimulationId(pstSewaTanahInvoiceProp.getlong(COL_PAYMENT_SIMULATION_ID));
            sewaTanahInvoiceProp.setSalesDataId(pstSewaTanahInvoiceProp.getlong(COL_SALES_DATA_ID));
            sewaTanahInvoiceProp.setStsPrintXls(pstSewaTanahInvoiceProp.getInt(COL_STS_PRINT_XLS));
            sewaTanahInvoiceProp.setStsPrintPdf(pstSewaTanahInvoiceProp.getInt(COL_STS_PRINT_PDF));

            return sewaTanahInvoiceProp;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahInvoiceProp(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SewaTanahInvoiceProp sewaTanahInvoiceProp) throws CONException {
        try {
            DbSewaTanahInvoiceProp pstSewaTanahInvoiceProp = new DbSewaTanahInvoiceProp(0);

            pstSewaTanahInvoiceProp.setDate(COL_TANGGAL, sewaTanahInvoiceProp.getTanggal());
            pstSewaTanahInvoiceProp.setLong(COL_INVESTOR_ID, sewaTanahInvoiceProp.getInvestorId());
            pstSewaTanahInvoiceProp.setLong(COL_SARANA_ID, sewaTanahInvoiceProp.getSaranaId());
            pstSewaTanahInvoiceProp.setLong(COL_CURRENCY_ID, sewaTanahInvoiceProp.getCurrencyId());
            pstSewaTanahInvoiceProp.setDouble(COL_JUMLAH, sewaTanahInvoiceProp.getJumlah());
            pstSewaTanahInvoiceProp.setString(COL_KETERANGAN, sewaTanahInvoiceProp.getKeterangan());
            pstSewaTanahInvoiceProp.setDate(COL_JATUH_TEMPO, sewaTanahInvoiceProp.getJatuhTempo());
            pstSewaTanahInvoiceProp.setLong(COL_SEWA_TANAH_ID, sewaTanahInvoiceProp.getSewaTanahId());
            pstSewaTanahInvoiceProp.setLong(COL_USER_ID, sewaTanahInvoiceProp.getUserId());
            pstSewaTanahInvoiceProp.setInt(COL_STATUS, sewaTanahInvoiceProp.getStatus());
            pstSewaTanahInvoiceProp.setDate(COL_TANGGAL_INPUT, sewaTanahInvoiceProp.getTanggalInput());
            pstSewaTanahInvoiceProp.setInt(COL_COUNTER, sewaTanahInvoiceProp.getCounter());
            pstSewaTanahInvoiceProp.setString(COL_PREFIX_NUMBER, sewaTanahInvoiceProp.getPrefixNumber());
            pstSewaTanahInvoiceProp.setString(COL_NUMBER, sewaTanahInvoiceProp.getNumber());
            pstSewaTanahInvoiceProp.setInt(COL_TYPE, sewaTanahInvoiceProp.getType());
            pstSewaTanahInvoiceProp.setLong(COL_MASA_INVOICE_ID, sewaTanahInvoiceProp.getMasaInvoiceId());
            pstSewaTanahInvoiceProp.setInt(COL_JML_BULAN, sewaTanahInvoiceProp.getJmlBulan());
            pstSewaTanahInvoiceProp.setString(COL_NO_FP, sewaTanahInvoiceProp.getNoFp());
            pstSewaTanahInvoiceProp.setDouble(COL_TOTAL_DENDA, sewaTanahInvoiceProp.getTotalDenda());
            pstSewaTanahInvoiceProp.setDouble(COL_PPH_PERSEN, sewaTanahInvoiceProp.getPphPersen());
            pstSewaTanahInvoiceProp.setDouble(COL_PPH, sewaTanahInvoiceProp.getPph());
            pstSewaTanahInvoiceProp.setDouble(COL_PPN_PERSEN, sewaTanahInvoiceProp.getPpnPersen());
            pstSewaTanahInvoiceProp.setDouble(COL_PPN, sewaTanahInvoiceProp.getPpn());
            pstSewaTanahInvoiceProp.setInt(COL_STATUS_PEMBAYARAN, sewaTanahInvoiceProp.getStatusPembayaran());
            pstSewaTanahInvoiceProp.setDouble(COL_DENDA_DIAKUI, sewaTanahInvoiceProp.getDendaDiakui());
            pstSewaTanahInvoiceProp.setLong(COL_DENDA_APPROVE_ID, sewaTanahInvoiceProp.getDendaApproveId());
            pstSewaTanahInvoiceProp.setDate(COL_DENDA_APPROVE_DATE, sewaTanahInvoiceProp.getDendaApproveDate());
            pstSewaTanahInvoiceProp.setString(COL_DENDA_KETERANGAN, sewaTanahInvoiceProp.getDendaKeterangan());
            pstSewaTanahInvoiceProp.setInt(COL_DENDA_POST_STATUS, sewaTanahInvoiceProp.getDendaPostStatus());
            pstSewaTanahInvoiceProp.setString(COL_DENDA_CLIENT_NAME, sewaTanahInvoiceProp.getDendaClientName());
            pstSewaTanahInvoiceProp.setString(COL_DENDA_CLIENT_POSITION, sewaTanahInvoiceProp.getDendaClientPosition());
            pstSewaTanahInvoiceProp.setInt(COL_PAYMENT_TYPE, sewaTanahInvoiceProp.getPaymentType());
            pstSewaTanahInvoiceProp.setLong(COL_PAYMENT_SIMULATION_ID, sewaTanahInvoiceProp.getPaymentSimulationId());
            pstSewaTanahInvoiceProp.setLong(COL_SALES_DATA_ID, sewaTanahInvoiceProp.getSalesDataId());
            pstSewaTanahInvoiceProp.setInt(COL_STS_PRINT_XLS, sewaTanahInvoiceProp.getStsPrintXls());
            pstSewaTanahInvoiceProp.setInt(COL_STS_PRINT_PDF, sewaTanahInvoiceProp.getStsPrintPdf());

            pstSewaTanahInvoiceProp.insert();
            sewaTanahInvoiceProp.setOID(pstSewaTanahInvoiceProp.getlong(COL_SEWA_TANAH_INVOICE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahInvoiceProp(0), CONException.UNKNOWN);
        }
        return sewaTanahInvoiceProp.getOID();
    }

    public static long updateExc(SewaTanahInvoiceProp sewaTanahInvoiceProp) throws CONException {
        try {
            if (sewaTanahInvoiceProp.getOID() != 0) {
                DbSewaTanahInvoiceProp pstSewaTanahInvoiceProp = new DbSewaTanahInvoiceProp(sewaTanahInvoiceProp.getOID());

                pstSewaTanahInvoiceProp.setDate(COL_TANGGAL, sewaTanahInvoiceProp.getTanggal());
                pstSewaTanahInvoiceProp.setLong(COL_INVESTOR_ID, sewaTanahInvoiceProp.getInvestorId());
                pstSewaTanahInvoiceProp.setLong(COL_SARANA_ID, sewaTanahInvoiceProp.getSaranaId());
                pstSewaTanahInvoiceProp.setLong(COL_CURRENCY_ID, sewaTanahInvoiceProp.getCurrencyId());
                pstSewaTanahInvoiceProp.setDouble(COL_JUMLAH, sewaTanahInvoiceProp.getJumlah());
                pstSewaTanahInvoiceProp.setString(COL_KETERANGAN, sewaTanahInvoiceProp.getKeterangan());
                pstSewaTanahInvoiceProp.setDate(COL_JATUH_TEMPO, sewaTanahInvoiceProp.getJatuhTempo());
                pstSewaTanahInvoiceProp.setLong(COL_SEWA_TANAH_ID, sewaTanahInvoiceProp.getSewaTanahId());
                pstSewaTanahInvoiceProp.setLong(COL_USER_ID, sewaTanahInvoiceProp.getUserId());
                pstSewaTanahInvoiceProp.setInt(COL_STATUS, sewaTanahInvoiceProp.getStatus());
                pstSewaTanahInvoiceProp.setDate(COL_TANGGAL_INPUT, sewaTanahInvoiceProp.getTanggalInput());
                pstSewaTanahInvoiceProp.setInt(COL_COUNTER, sewaTanahInvoiceProp.getCounter());
                pstSewaTanahInvoiceProp.setString(COL_PREFIX_NUMBER, sewaTanahInvoiceProp.getPrefixNumber());
                pstSewaTanahInvoiceProp.setString(COL_NUMBER, sewaTanahInvoiceProp.getNumber());
                pstSewaTanahInvoiceProp.setInt(COL_TYPE, sewaTanahInvoiceProp.getType());
                pstSewaTanahInvoiceProp.setLong(COL_MASA_INVOICE_ID, sewaTanahInvoiceProp.getMasaInvoiceId());
                pstSewaTanahInvoiceProp.setInt(COL_JML_BULAN, sewaTanahInvoiceProp.getJmlBulan());
                pstSewaTanahInvoiceProp.setString(COL_NO_FP, sewaTanahInvoiceProp.getNoFp());
                pstSewaTanahInvoiceProp.setDouble(COL_TOTAL_DENDA, sewaTanahInvoiceProp.getTotalDenda());
                pstSewaTanahInvoiceProp.setDouble(COL_PPH_PERSEN, sewaTanahInvoiceProp.getPphPersen());
                pstSewaTanahInvoiceProp.setDouble(COL_PPH, sewaTanahInvoiceProp.getPph());
                pstSewaTanahInvoiceProp.setDouble(COL_PPN_PERSEN, sewaTanahInvoiceProp.getPpnPersen());
                pstSewaTanahInvoiceProp.setDouble(COL_PPN, sewaTanahInvoiceProp.getPpn());
                pstSewaTanahInvoiceProp.setInt(COL_STATUS_PEMBAYARAN, sewaTanahInvoiceProp.getStatusPembayaran());
                pstSewaTanahInvoiceProp.setDouble(COL_DENDA_DIAKUI, sewaTanahInvoiceProp.getDendaDiakui());
                pstSewaTanahInvoiceProp.setLong(COL_DENDA_APPROVE_ID, sewaTanahInvoiceProp.getDendaApproveId());
                pstSewaTanahInvoiceProp.setDate(COL_DENDA_APPROVE_DATE, sewaTanahInvoiceProp.getDendaApproveDate());
                pstSewaTanahInvoiceProp.setString(COL_DENDA_KETERANGAN, sewaTanahInvoiceProp.getDendaKeterangan());
                pstSewaTanahInvoiceProp.setInt(COL_DENDA_POST_STATUS, sewaTanahInvoiceProp.getDendaPostStatus());
                pstSewaTanahInvoiceProp.setString(COL_DENDA_CLIENT_NAME, sewaTanahInvoiceProp.getDendaClientName());
                pstSewaTanahInvoiceProp.setString(COL_DENDA_CLIENT_POSITION, sewaTanahInvoiceProp.getDendaClientPosition());
                pstSewaTanahInvoiceProp.setInt(COL_PAYMENT_TYPE, sewaTanahInvoiceProp.getPaymentType());
                pstSewaTanahInvoiceProp.setLong(COL_PAYMENT_SIMULATION_ID, sewaTanahInvoiceProp.getPaymentSimulationId());
                pstSewaTanahInvoiceProp.setLong(COL_SALES_DATA_ID, sewaTanahInvoiceProp.getSalesDataId());
                pstSewaTanahInvoiceProp.setInt(COL_STS_PRINT_XLS, sewaTanahInvoiceProp.getStsPrintXls());
                pstSewaTanahInvoiceProp.setInt(COL_STS_PRINT_PDF, sewaTanahInvoiceProp.getStsPrintPdf());

                pstSewaTanahInvoiceProp.update();
                return sewaTanahInvoiceProp.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahInvoiceProp(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSewaTanahInvoiceProp pstSewaTanahInvoiceProp = new DbSewaTanahInvoiceProp(oid);
            pstSewaTanahInvoiceProp.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahInvoiceProp(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SEWA_TANAH_INVOICE_PROP;
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
                SewaTanahInvoiceProp sewaTanahInvoiceProp = new SewaTanahInvoiceProp();
                resultToObject(rs, sewaTanahInvoiceProp);
                lists.add(sewaTanahInvoiceProp);
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

    private static void resultToObject(ResultSet rs, SewaTanahInvoiceProp sewaTanahInvoiceProp) {
        try {
            sewaTanahInvoiceProp.setOID(rs.getLong(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_SEWA_TANAH_INVOICE_ID]));
            sewaTanahInvoiceProp.setTanggal(rs.getDate(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_TANGGAL]));
            sewaTanahInvoiceProp.setInvestorId(rs.getLong(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_INVESTOR_ID]));
            sewaTanahInvoiceProp.setSaranaId(rs.getLong(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_SARANA_ID]));
            sewaTanahInvoiceProp.setCurrencyId(rs.getLong(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_CURRENCY_ID]));
            sewaTanahInvoiceProp.setJumlah(rs.getDouble(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_JUMLAH]));
            sewaTanahInvoiceProp.setKeterangan(rs.getString(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_KETERANGAN]));
            sewaTanahInvoiceProp.setJatuhTempo(rs.getDate(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_JATUH_TEMPO]));
            sewaTanahInvoiceProp.setSewaTanahId(rs.getLong(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_SEWA_TANAH_ID]));
            sewaTanahInvoiceProp.setUserId(rs.getLong(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_USER_ID]));
            sewaTanahInvoiceProp.setStatus(rs.getInt(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_STATUS]));
            sewaTanahInvoiceProp.setTanggalInput(rs.getDate(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_TANGGAL_INPUT]));
            sewaTanahInvoiceProp.setCounter(rs.getInt(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_COUNTER]));
            sewaTanahInvoiceProp.setPrefixNumber(rs.getString(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_PREFIX_NUMBER]));
            sewaTanahInvoiceProp.setNumber(rs.getString(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_NUMBER]));
            sewaTanahInvoiceProp.setType(rs.getInt(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_TYPE]));
            sewaTanahInvoiceProp.setMasaInvoiceId(rs.getLong(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_MASA_INVOICE_ID]));
            sewaTanahInvoiceProp.setJmlBulan(rs.getInt(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_JML_BULAN]));
            sewaTanahInvoiceProp.setNoFp(rs.getString(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_NO_FP]));
            sewaTanahInvoiceProp.setTotalDenda(rs.getDouble(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_TOTAL_DENDA]));
            sewaTanahInvoiceProp.setPphPersen(rs.getDouble(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_PPH_PERSEN]));
            sewaTanahInvoiceProp.setPph(rs.getDouble(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_PPH]));
            sewaTanahInvoiceProp.setPpnPersen(rs.getDouble(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_PPN_PERSEN]));
            sewaTanahInvoiceProp.setPpn(rs.getDouble(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_PPN]));
            sewaTanahInvoiceProp.setStatusPembayaran(rs.getInt(DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_STATUS_PEMBAYARAN]));
            sewaTanahInvoiceProp.setDendaDiakui(rs.getDouble(colNames[COL_DENDA_DIAKUI]));
            sewaTanahInvoiceProp.setDendaApproveId(rs.getLong(colNames[COL_DENDA_APPROVE_ID]));
            sewaTanahInvoiceProp.setDendaApproveDate(rs.getDate(colNames[COL_DENDA_APPROVE_DATE]));
            sewaTanahInvoiceProp.setDendaKeterangan(rs.getString(colNames[COL_DENDA_KETERANGAN]));
            sewaTanahInvoiceProp.setDendaPostStatus(rs.getInt(colNames[COL_DENDA_POST_STATUS]));
            sewaTanahInvoiceProp.setDendaClientName(rs.getString(colNames[COL_DENDA_CLIENT_NAME]));
            sewaTanahInvoiceProp.setDendaClientPosition(rs.getString(colNames[COL_DENDA_CLIENT_POSITION]));
            sewaTanahInvoiceProp.setPaymentType(rs.getInt(colNames[COL_PAYMENT_TYPE]));
            sewaTanahInvoiceProp.setPaymentSimulationId(rs.getLong(colNames[COL_PAYMENT_SIMULATION_ID]));
            sewaTanahInvoiceProp.setSalesDataId(rs.getLong(colNames[COL_SALES_DATA_ID]));
            sewaTanahInvoiceProp.setStsPrintXls(rs.getInt(colNames[COL_STS_PRINT_XLS]));
            sewaTanahInvoiceProp.setStsPrintPdf(rs.getInt(colNames[COL_STS_PRINT_PDF]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sewaTanahInvoiceId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SEWA_TANAH_INVOICE_PROP + " WHERE " +
                    DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_SEWA_TANAH_INVOICE_ID] + " = " + sewaTanahInvoiceId;

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
            String sql = "SELECT COUNT(" + DbSewaTanahInvoiceProp.colNames[DbSewaTanahInvoiceProp.COL_SEWA_TANAH_INVOICE_ID] + ") FROM " + DB_SEWA_TANAH_INVOICE_PROP;
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
                    SewaTanahInvoiceProp sewaTanahInvoiceProp = (SewaTanahInvoiceProp) list.get(ls);
                    if (oid == sewaTanahInvoiceProp.getOID()) {
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
