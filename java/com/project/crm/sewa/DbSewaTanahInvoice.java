/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */
package com.project.crm.sewa;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.util.*;
import com.project.general.Currency;
import com.project.general.DbCurrency;
import com.project.crm.*;
import com.project.crm.transaction.DbPembayaran;
import com.project.payroll.DbDepartment;
import com.project.payroll.Department;
import com.project.simprop.property.DbSalesData;
import com.project.system.DbSystemProperty;

public class DbSewaTanahInvoice extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_CRM_SEWA_TANAH_INVOICE = "crm_sewa_tanah_invoice";
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
    public static final int COL_CREATE_ID = 37;
    public static final int COL_APPROVE_ID = 38;
    public static final int COL_CREATE_DATE = 39;
    public static final int COL_APPROVE_DATE = 40;
    
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
        "sts_print_pdf",
        "create_id",
        "approve_id",
        "create_date",
        "approve_date"
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
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE
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
    
    public static final int STATUS_PROP_DRAFT       = 0;
    public static final int STATUS_PROP_APPROVED    = 1;

    public DbSewaTanahInvoice() {
    }

    public DbSewaTanahInvoice(int i) throws CONException {
        super(new DbSewaTanahInvoice());
    }

    public DbSewaTanahInvoice(String sOid) throws CONException {
        super(new DbSewaTanahInvoice(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSewaTanahInvoice(long lOid) throws CONException {
        super(new DbSewaTanahInvoice(0));
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
        return DB_CRM_SEWA_TANAH_INVOICE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSewaTanahInvoice().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SewaTanahInvoice sewatanahinvoice = fetchExc(ent.getOID());
        ent = (Entity) sewatanahinvoice;
        return sewatanahinvoice.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SewaTanahInvoice) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SewaTanahInvoice) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SewaTanahInvoice fetchExc(long oid) throws CONException {
        try {
            SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();
            DbSewaTanahInvoice pstSewaTanahInvoice = new DbSewaTanahInvoice(oid);
            sewatanahinvoice.setOID(oid);

            sewatanahinvoice.setTanggal(pstSewaTanahInvoice.getDate(COL_TANGGAL));
            sewatanahinvoice.setInvestorId(pstSewaTanahInvoice.getlong(COL_INVESTOR_ID));
            sewatanahinvoice.setSaranaId(pstSewaTanahInvoice.getlong(COL_SARANA_ID));
            sewatanahinvoice.setCurrencyId(pstSewaTanahInvoice.getlong(COL_CURRENCY_ID));
            sewatanahinvoice.setJumlah(pstSewaTanahInvoice.getdouble(COL_JUMLAH));
            sewatanahinvoice.setKeterangan(pstSewaTanahInvoice.getString(COL_KETERANGAN));
            sewatanahinvoice.setJatuhTempo(pstSewaTanahInvoice.getDate(COL_JATUH_TEMPO));
            sewatanahinvoice.setSewaTanahId(pstSewaTanahInvoice.getlong(COL_SEWA_TANAH_ID));
            sewatanahinvoice.setUserId(pstSewaTanahInvoice.getlong(COL_USER_ID));
            sewatanahinvoice.setStatus(pstSewaTanahInvoice.getInt(COL_STATUS));
            sewatanahinvoice.setTanggalInput(pstSewaTanahInvoice.getDate(COL_TANGGAL_INPUT));
            sewatanahinvoice.setCounter(pstSewaTanahInvoice.getInt(COL_COUNTER));
            sewatanahinvoice.setPrefixNumber(pstSewaTanahInvoice.getString(COL_PREFIX_NUMBER));
            sewatanahinvoice.setNumber(pstSewaTanahInvoice.getString(COL_NUMBER));
            sewatanahinvoice.setType(pstSewaTanahInvoice.getInt(COL_TYPE));
            sewatanahinvoice.setMasaInvoiceId(pstSewaTanahInvoice.getlong(COL_MASA_INVOICE_ID));
            sewatanahinvoice.setJmlBulan(pstSewaTanahInvoice.getInt(COL_JML_BULAN));
            sewatanahinvoice.setNoFp(pstSewaTanahInvoice.getString(COL_NO_FP));
            sewatanahinvoice.setTotalDenda(pstSewaTanahInvoice.getdouble(COL_TOTAL_DENDA));
            sewatanahinvoice.setPphPersen(pstSewaTanahInvoice.getdouble(COL_PPH_PERSEN));
            sewatanahinvoice.setPph(pstSewaTanahInvoice.getdouble(COL_PPH));
            sewatanahinvoice.setPpnPersen(pstSewaTanahInvoice.getdouble(COL_PPN_PERSEN));
            sewatanahinvoice.setPpn(pstSewaTanahInvoice.getdouble(COL_PPN));
            sewatanahinvoice.setStatusPembayaran(pstSewaTanahInvoice.getInt(COL_STATUS_PEMBAYARAN));
            sewatanahinvoice.setDendaDiakui(pstSewaTanahInvoice.getdouble(COL_DENDA_DIAKUI));
            sewatanahinvoice.setDendaApproveId(pstSewaTanahInvoice.getlong(COL_DENDA_APPROVE_ID));
            sewatanahinvoice.setDendaApproveDate(pstSewaTanahInvoice.getDate(COL_DENDA_APPROVE_DATE));
            sewatanahinvoice.setDendaKeterangan(pstSewaTanahInvoice.getString(COL_DENDA_KETERANGAN));
            sewatanahinvoice.setDendaPostStatus(pstSewaTanahInvoice.getInt(COL_DENDA_POST_STATUS));
            sewatanahinvoice.setDendaClientName(pstSewaTanahInvoice.getString(COL_DENDA_CLIENT_NAME));
            sewatanahinvoice.setDendaClientPosition(pstSewaTanahInvoice.getString(COL_DENDA_CLIENT_POSITION));            
            sewatanahinvoice.setPaymentType(pstSewaTanahInvoice.getInt(COL_PAYMENT_TYPE));
            sewatanahinvoice.setPaymentSimulationId(pstSewaTanahInvoice.getlong(COL_PAYMENT_SIMULATION_ID));
            sewatanahinvoice.setSalesDataId(pstSewaTanahInvoice.getlong(COL_SALES_DATA_ID));
            sewatanahinvoice.setStsPrintXls(pstSewaTanahInvoice.getInt(COL_STS_PRINT_XLS));
            sewatanahinvoice.setStsPrintPdf(pstSewaTanahInvoice.getInt(COL_STS_PRINT_PDF));
            
            sewatanahinvoice.setCreateId(pstSewaTanahInvoice.getlong(COL_CREATE_ID));
            sewatanahinvoice.setApproveId(pstSewaTanahInvoice.getlong(COL_APPROVE_ID));
            sewatanahinvoice.setCreateDate(pstSewaTanahInvoice.getDate(COL_CREATE_DATE));
            sewatanahinvoice.setApproveDate(pstSewaTanahInvoice.getDate(COL_APPROVE_DATE));

            return sewatanahinvoice;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahInvoice(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SewaTanahInvoice sewatanahinvoice) throws CONException {
        try {
            DbSewaTanahInvoice pstSewaTanahInvoice = new DbSewaTanahInvoice(0);

            pstSewaTanahInvoice.setDate(COL_TANGGAL, sewatanahinvoice.getTanggal());
            pstSewaTanahInvoice.setLong(COL_INVESTOR_ID, sewatanahinvoice.getInvestorId());
            pstSewaTanahInvoice.setLong(COL_SARANA_ID, sewatanahinvoice.getSaranaId());
            pstSewaTanahInvoice.setLong(COL_CURRENCY_ID, sewatanahinvoice.getCurrencyId());
            pstSewaTanahInvoice.setDouble(COL_JUMLAH, sewatanahinvoice.getJumlah());
            pstSewaTanahInvoice.setString(COL_KETERANGAN, sewatanahinvoice.getKeterangan());
            pstSewaTanahInvoice.setDate(COL_JATUH_TEMPO, sewatanahinvoice.getJatuhTempo());
            pstSewaTanahInvoice.setLong(COL_SEWA_TANAH_ID, sewatanahinvoice.getSewaTanahId());
            pstSewaTanahInvoice.setLong(COL_USER_ID, sewatanahinvoice.getUserId());
            pstSewaTanahInvoice.setInt(COL_STATUS, sewatanahinvoice.getStatus());
            pstSewaTanahInvoice.setDate(COL_TANGGAL_INPUT, sewatanahinvoice.getTanggalInput());
            pstSewaTanahInvoice.setInt(COL_COUNTER, sewatanahinvoice.getCounter());
            pstSewaTanahInvoice.setString(COL_PREFIX_NUMBER, sewatanahinvoice.getPrefixNumber());
            pstSewaTanahInvoice.setString(COL_NUMBER, sewatanahinvoice.getNumber());
            pstSewaTanahInvoice.setInt(COL_TYPE, sewatanahinvoice.getType());
            pstSewaTanahInvoice.setLong(COL_MASA_INVOICE_ID, sewatanahinvoice.getMasaInvoiceId());
            pstSewaTanahInvoice.setInt(COL_JML_BULAN, sewatanahinvoice.getJmlBulan());
            pstSewaTanahInvoice.setString(COL_NO_FP, sewatanahinvoice.getNoFp());
            pstSewaTanahInvoice.setDouble(COL_TOTAL_DENDA, sewatanahinvoice.getTotalDenda());
            pstSewaTanahInvoice.setDouble(COL_PPH_PERSEN, sewatanahinvoice.getPphPersen());
            pstSewaTanahInvoice.setDouble(COL_PPH, sewatanahinvoice.getPph());
            pstSewaTanahInvoice.setDouble(COL_PPN_PERSEN, sewatanahinvoice.getPpnPersen());
            pstSewaTanahInvoice.setDouble(COL_PPN, sewatanahinvoice.getPpn());
            pstSewaTanahInvoice.setInt(COL_STATUS_PEMBAYARAN, sewatanahinvoice.getStatusPembayaran());
            pstSewaTanahInvoice.setDouble(COL_DENDA_DIAKUI, sewatanahinvoice.getDendaDiakui());
            pstSewaTanahInvoice.setLong(COL_DENDA_APPROVE_ID, sewatanahinvoice.getDendaApproveId());
            pstSewaTanahInvoice.setDate(COL_DENDA_APPROVE_DATE, sewatanahinvoice.getDendaApproveDate());
            pstSewaTanahInvoice.setString(COL_DENDA_KETERANGAN, sewatanahinvoice.getDendaKeterangan());
            pstSewaTanahInvoice.setInt(COL_DENDA_POST_STATUS, sewatanahinvoice.getDendaPostStatus());
            pstSewaTanahInvoice.setString(COL_DENDA_CLIENT_NAME, sewatanahinvoice.getDendaClientName());
            pstSewaTanahInvoice.setString(COL_DENDA_CLIENT_POSITION, sewatanahinvoice.getDendaClientPosition());
            pstSewaTanahInvoice.setInt(COL_PAYMENT_TYPE, sewatanahinvoice.getPaymentType());
            pstSewaTanahInvoice.setLong(COL_PAYMENT_SIMULATION_ID, sewatanahinvoice.getPaymentSimulationId());
            pstSewaTanahInvoice.setLong(COL_SALES_DATA_ID, sewatanahinvoice.getSalesDataId());            
            pstSewaTanahInvoice.setInt(COL_STS_PRINT_XLS, sewatanahinvoice.getStsPrintXls());
            pstSewaTanahInvoice.setInt(COL_STS_PRINT_PDF, sewatanahinvoice.getStsPrintPdf());
            
            pstSewaTanahInvoice.setLong(COL_CREATE_ID, sewatanahinvoice.getCreateId());
            pstSewaTanahInvoice.setLong(COL_APPROVE_ID, sewatanahinvoice.getApproveId());
            pstSewaTanahInvoice.setDate(COL_CREATE_DATE, sewatanahinvoice.getCreateDate());
            pstSewaTanahInvoice.setDate(COL_APPROVE_DATE, sewatanahinvoice.getApproveDate());
            pstSewaTanahInvoice.insert();
            sewatanahinvoice.setOID(pstSewaTanahInvoice.getlong(COL_SEWA_TANAH_INVOICE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahInvoice(0), CONException.UNKNOWN);
        }
        return sewatanahinvoice.getOID();
    }

    public static long updateExc(SewaTanahInvoice sewatanahinvoice) throws CONException {
        try {
            if (sewatanahinvoice.getOID() != 0) {
                DbSewaTanahInvoice pstSewaTanahInvoice = new DbSewaTanahInvoice(sewatanahinvoice.getOID());

                pstSewaTanahInvoice.setDate(COL_TANGGAL, sewatanahinvoice.getTanggal());
                pstSewaTanahInvoice.setLong(COL_INVESTOR_ID, sewatanahinvoice.getInvestorId());
                pstSewaTanahInvoice.setLong(COL_SARANA_ID, sewatanahinvoice.getSaranaId());
                pstSewaTanahInvoice.setLong(COL_CURRENCY_ID, sewatanahinvoice.getCurrencyId());
                pstSewaTanahInvoice.setDouble(COL_JUMLAH, sewatanahinvoice.getJumlah());
                pstSewaTanahInvoice.setString(COL_KETERANGAN, sewatanahinvoice.getKeterangan());
                pstSewaTanahInvoice.setDate(COL_JATUH_TEMPO, sewatanahinvoice.getJatuhTempo());
                pstSewaTanahInvoice.setLong(COL_SEWA_TANAH_ID, sewatanahinvoice.getSewaTanahId());
                pstSewaTanahInvoice.setLong(COL_USER_ID, sewatanahinvoice.getUserId());
                pstSewaTanahInvoice.setInt(COL_STATUS, sewatanahinvoice.getStatus());
                pstSewaTanahInvoice.setDate(COL_TANGGAL_INPUT, sewatanahinvoice.getTanggalInput());
                pstSewaTanahInvoice.setInt(COL_COUNTER, sewatanahinvoice.getCounter());
                pstSewaTanahInvoice.setString(COL_PREFIX_NUMBER, sewatanahinvoice.getPrefixNumber());
                pstSewaTanahInvoice.setString(COL_NUMBER, sewatanahinvoice.getNumber());
                pstSewaTanahInvoice.setInt(COL_TYPE, sewatanahinvoice.getType());
                pstSewaTanahInvoice.setLong(COL_MASA_INVOICE_ID, sewatanahinvoice.getMasaInvoiceId());
                pstSewaTanahInvoice.setInt(COL_JML_BULAN, sewatanahinvoice.getJmlBulan());
                pstSewaTanahInvoice.setString(COL_NO_FP, sewatanahinvoice.getNoFp());
                pstSewaTanahInvoice.setDouble(COL_TOTAL_DENDA, sewatanahinvoice.getTotalDenda());
                pstSewaTanahInvoice.setDouble(COL_PPH_PERSEN, sewatanahinvoice.getPphPersen());
                pstSewaTanahInvoice.setDouble(COL_PPH, sewatanahinvoice.getPph());
                pstSewaTanahInvoice.setDouble(COL_PPN_PERSEN, sewatanahinvoice.getPpnPersen());
                pstSewaTanahInvoice.setDouble(COL_PPN, sewatanahinvoice.getPpn());
                pstSewaTanahInvoice.setInt(COL_STATUS_PEMBAYARAN, sewatanahinvoice.getStatusPembayaran());
                pstSewaTanahInvoice.setDouble(COL_DENDA_DIAKUI, sewatanahinvoice.getDendaDiakui());
                pstSewaTanahInvoice.setLong(COL_DENDA_APPROVE_ID, sewatanahinvoice.getDendaApproveId());
                pstSewaTanahInvoice.setDate(COL_DENDA_APPROVE_DATE, sewatanahinvoice.getDendaApproveDate());
                pstSewaTanahInvoice.setString(COL_DENDA_KETERANGAN, sewatanahinvoice.getDendaKeterangan());
                pstSewaTanahInvoice.setInt(COL_DENDA_POST_STATUS, sewatanahinvoice.getDendaPostStatus());
                pstSewaTanahInvoice.setString(COL_DENDA_CLIENT_NAME, sewatanahinvoice.getDendaClientName());
                pstSewaTanahInvoice.setString(COL_DENDA_CLIENT_POSITION, sewatanahinvoice.getDendaClientPosition());
                pstSewaTanahInvoice.setInt(COL_PAYMENT_TYPE, sewatanahinvoice.getPaymentType());
                pstSewaTanahInvoice.setLong(COL_PAYMENT_SIMULATION_ID, sewatanahinvoice.getPaymentSimulationId());
                pstSewaTanahInvoice.setLong(COL_SALES_DATA_ID, sewatanahinvoice.getSalesDataId());
                pstSewaTanahInvoice.setInt(COL_STS_PRINT_XLS, sewatanahinvoice.getStsPrintXls());
                pstSewaTanahInvoice.setInt(COL_STS_PRINT_PDF, sewatanahinvoice.getStsPrintPdf());
                pstSewaTanahInvoice.setLong(COL_CREATE_ID, sewatanahinvoice.getCreateId());
                pstSewaTanahInvoice.setLong(COL_APPROVE_ID, sewatanahinvoice.getApproveId());
                pstSewaTanahInvoice.setDate(COL_CREATE_DATE, sewatanahinvoice.getCreateDate());
                pstSewaTanahInvoice.setDate(COL_APPROVE_DATE, sewatanahinvoice.getApproveDate());

                pstSewaTanahInvoice.update();
                return sewatanahinvoice.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahInvoice(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSewaTanahInvoice pstSewaTanahInvoice = new DbSewaTanahInvoice(oid);
            pstSewaTanahInvoice.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSewaTanahInvoice(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_INVOICE;
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
                SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();
                resultToObject(rs, sewatanahinvoice);
                lists.add(sewatanahinvoice);
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

    private static void resultToObject(ResultSet rs, SewaTanahInvoice sewatanahinvoice) {
        try {
            sewatanahinvoice.setOID(rs.getLong(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]));
            sewatanahinvoice.setTanggal(rs.getDate(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]));
            sewatanahinvoice.setInvestorId(rs.getLong(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_INVESTOR_ID]));
            sewatanahinvoice.setSaranaId(rs.getLong(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]));
            sewatanahinvoice.setCurrencyId(rs.getLong(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_CURRENCY_ID]));
            sewatanahinvoice.setJumlah(rs.getDouble(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]));
            sewatanahinvoice.setKeterangan(rs.getString(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_KETERANGAN]));
            sewatanahinvoice.setJatuhTempo(rs.getDate(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JATUH_TEMPO]));
            sewatanahinvoice.setSewaTanahId(rs.getLong(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_ID]));
            sewatanahinvoice.setUserId(rs.getLong(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_USER_ID]));
            sewatanahinvoice.setStatus(rs.getInt(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]));
            sewatanahinvoice.setTanggalInput(rs.getDate(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL_INPUT]));
            sewatanahinvoice.setCounter(rs.getInt(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_COUNTER]));
            sewatanahinvoice.setPrefixNumber(rs.getString(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PREFIX_NUMBER]));
            sewatanahinvoice.setNumber(rs.getString(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER]));
            sewatanahinvoice.setType(rs.getInt(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TYPE]));
            sewatanahinvoice.setMasaInvoiceId(rs.getLong(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_MASA_INVOICE_ID]));
            sewatanahinvoice.setJmlBulan(rs.getInt(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JML_BULAN]));
            sewatanahinvoice.setNoFp(rs.getString(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NO_FP]));
            sewatanahinvoice.setTotalDenda(rs.getDouble(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TOTAL_DENDA]));
            sewatanahinvoice.setPphPersen(rs.getDouble(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PPH_PERSEN]));
            sewatanahinvoice.setPph(rs.getDouble(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PPH]));
            sewatanahinvoice.setPpnPersen(rs.getDouble(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PPN_PERSEN]));
            sewatanahinvoice.setPpn(rs.getDouble(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PPN]));
            sewatanahinvoice.setStatusPembayaran(rs.getInt(DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]));
            sewatanahinvoice.setDendaDiakui(rs.getDouble(colNames[COL_DENDA_DIAKUI]));
            sewatanahinvoice.setDendaApproveId(rs.getLong(colNames[COL_DENDA_APPROVE_ID]));
            sewatanahinvoice.setDendaApproveDate(rs.getDate(colNames[COL_DENDA_APPROVE_DATE]));
            sewatanahinvoice.setDendaKeterangan(rs.getString(colNames[COL_DENDA_KETERANGAN]));
            sewatanahinvoice.setDendaPostStatus(rs.getInt(colNames[COL_DENDA_POST_STATUS]));
            sewatanahinvoice.setDendaClientName(rs.getString(colNames[COL_DENDA_CLIENT_NAME]));
            sewatanahinvoice.setDendaClientPosition(rs.getString(colNames[COL_DENDA_CLIENT_POSITION]));            
            sewatanahinvoice.setPaymentType(rs.getInt(colNames[COL_PAYMENT_TYPE]));
            sewatanahinvoice.setPaymentSimulationId(rs.getLong(colNames[COL_PAYMENT_SIMULATION_ID]));
            sewatanahinvoice.setSalesDataId(rs.getLong(colNames[COL_SALES_DATA_ID]));            
            sewatanahinvoice.setStsPrintXls(rs.getInt(colNames[COL_STS_PRINT_XLS]));
            sewatanahinvoice.setStsPrintPdf(rs.getInt(colNames[COL_STS_PRINT_PDF]));                        
            sewatanahinvoice.setCreateId(rs.getLong(colNames[COL_CREATE_ID]));     
            sewatanahinvoice.setApproveId(rs.getLong(colNames[COL_APPROVE_ID]));     
            sewatanahinvoice.setCreateDate(rs.getDate(colNames[COL_CREATE_DATE]));     
            sewatanahinvoice.setApproveDate(rs.getDate(colNames[COL_APPROVE_DATE]));     

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sewaTanahInvoiceId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_INVOICE + " WHERE " +
                    DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID] + " = " + sewaTanahInvoiceId;

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
            String sql = "SELECT COUNT(" + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID] + ") FROM " + DB_CRM_SEWA_TANAH_INVOICE;
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
                    SewaTanahInvoice sewatanahinvoice = (SewaTanahInvoice) list.get(ls);
                    if (oid == sewatanahinvoice.getOID()) {
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

    /**
     * invoice diterbitkan satu bulan sebelum tanggal invoice jatuh tempo,
     * sehingga pengecekkan dilakukan pada bulan berikutnya
     * jan = 0
     * feb = 1
     * mar = 2
     * dst...
     */
    public static boolean isCreateNewInvoice(int masa, int month, int year, int type, SewaTanah st) {
        SewaTanahInvoice sti = new SewaTanahInvoice();
        boolean yesNew = false;

        Calendar calendar = new GregorianCalendar(year, month - 1, 1, 0, 0, 0);
        calendar.add(Calendar.MONTH, 1);/***** GET NEXT MONTH *****/
        
        month = calendar.get(Calendar.MONTH) + 1;
        year = calendar.get(Calendar.YEAR);
        Date dueDate = calendar.getTime();

        /** Ignore when selected date before Komin/Komper/Assesment start date */
        int compareTo = 0;
        if (type == TYPE_INV_KOMIN) {
            dueDate.setDate(st.getTglInvoiceKomin().getDate());
            compareTo = dueDate.compareTo(st.getTglMulaiKomin());
        } else if (type == TYPE_INV_KOMPER) {
            dueDate.setDate(st.getTglInvoiceKomin().getDate());
            compareTo = dueDate.compareTo(st.getTglMulaiKomper());
        } else {
            dueDate.setDate(st.getTglInvoiceAssesment().getDate());
            compareTo = dueDate.compareTo(st.getTglMulaiAssesment());
        }

        if (compareTo < 0) {
            System.out.println("isCreateNewInvoice() return FALSE");
            return false;
        }
        /**END*/
        switch (masa) {
            //BLN
            case 0: //kondisi untuk yg tdk menggunakan komin, invoice hasil generate diabaikan
                sti = getLatestInvoice(month, year, type, st);
                if (sti.getOID() == 0) {
                    yesNew = true;
                }
                break;
            case 1:
                sti = getLatestInvoice(month, year, type, st);
                if (sti.getOID() == 0) {
                    yesNew = true;
                }
                break;
            case 3:
                int stMonth = 0;
                if (type == TYPE_INV_KOMIN) {
                    stMonth = st.getTglInvoiceKomin().getMonth() + 1; //tanggal invoice terbit
                } else if (type == TYPE_INV_KOMPER) {
                    stMonth = st.getTglMulaiKomper().getMonth() + 1;
                } else {
                    stMonth = st.getTglInvoiceAssesment().getMonth() + 1; //tanggal invoice terbit
                }

                if (month == stMonth) { //jika tanggal yg dipilih sama dng tanggal di data kontrak
                    sti = getLatestInvoice(month, year, type, st);
                    if (sti.getOID() == 0) {
                        yesNew = true;
                    }
                } else if (month > stMonth) { //jika tanggal yg dipilih setelah tanggal di data kontrak
                    if (((month - stMonth) % 3) == 0) {
                        sti = getLatestInvoice(month, year, type, st);
                        if (sti.getOID() == 0) {
                            yesNew = true;
                        }
                    }
                } else { //jika tanggal yg dipilih sebelum tanggal di data kontrak
                    if ((((12 - stMonth) + month) % 3) == 0) {
                        sti = getLatestInvoice(month, year, type, st);
                        if (sti.getOID() == 0) {
                            yesNew = true;
                        }
                    }
                }
                break;

            case 6:

                //stMonth =  st.getTglMulaiKomin().getMonth()+1;
                stMonth = 0;
                if (type == TYPE_INV_KOMIN) {
                    stMonth = st.getTglInvoiceKomin().getMonth() + 1;
                } else if (type == TYPE_INV_KOMPER) {
                    stMonth = st.getTglMulaiKomper().getMonth() + 1;
                } else {
                    stMonth = st.getTglInvoiceAssesment().getMonth() + 1;
                }

                if (month == stMonth) {
                    sti = getLatestInvoice(month, year, type, st);
                    if (sti.getOID() == 0) {
                        yesNew = true;
                    }
                } else if (month > stMonth) {
                    if (((month - stMonth) % 6) == 0) {
                        sti = getLatestInvoice(month, year, type, st);
                        if (sti.getOID() == 0) {
                            yesNew = true;
                        }
                    }
                } else {
                    if ((((12 - stMonth) + month) % 6) == 0) {
                        sti = getLatestInvoice(month, year, type, st);
                        if (sti.getOID() == 0) {
                            yesNew = true;
                        }
                    }
                }
                break;

            case 12:

                //stMonth =  st.getTglMulaiKomin().getMonth()+1;			
                stMonth = 0;
                if (type == TYPE_INV_KOMIN) {
                    stMonth = st.getTglInvoiceKomin().getMonth() + 1;
                } else if (type == TYPE_INV_KOMPER) {
                    stMonth = st.getTglMulaiKomper().getMonth() + 1;
                } else {
                    stMonth = st.getTglInvoiceAssesment().getMonth() + 1;
                }

                if (stMonth == month) {
                    sti = getLatestInvoice(month, year, type, st);
                    if (sti.getOID() == 0) {
                        yesNew = true;
                    }
                }
                break;
            //jika bukan salah satu diatas
            default:

                if (masa > 12) {
                    if (masa % 12 == 0) {

                        //Date dtx = st.getTglMulaiKomin();

                        Date dtx = new Date();
                        if (type == TYPE_INV_KOMIN) {
                            dtx = st.getTglInvoiceKomin();
                        } else if (type == TYPE_INV_KOMPER) {
                            dtx = st.getTglMulaiKomper();
                        } else {
                            dtx = st.getTglInvoiceAssesment();
                        }


                        int x = masa / 12;
                        stMonth = dtx.getMonth() + 1;
                        int stYear = dtx.getYear() + 1900;

                        if ((year - stYear) % x == 0) {
                            if (stMonth == month) {
                                sti = getLatestInvoice(month, year, type, st);
                                if (sti.getOID() == 0) {
                                    yesNew = true;
                                }
                            }
                        }
                    } //jika tidak genap tahunan
                    else {
                    //masih difikirkan
                    //hehehehe
                    }
                } //2,4,5,7,8,9,10,11
                else if (masa < 12) {

                    //stMonth =  st.getTglMulaiKomin().getMonth()+1;
                    stMonth = 0;
                    if (type == TYPE_INV_KOMIN) {
                        stMonth = st.getTglInvoiceKomin().getMonth() + 1;
                    } else if (type == TYPE_INV_KOMPER) {
                        stMonth = st.getTglMulaiKomper().getMonth() + 1;
                    } else {
                        stMonth = st.getTglInvoiceAssesment().getMonth() + 1;
                    }

                    if (month > stMonth) {
                        if (((month - stMonth) % masa) == 0) {
                            sti = getLatestInvoice(month, year, type, st);
                            if (sti.getOID() == 0) {
                                yesNew = true;
                            }
                        }
                    } else {
                        if ((((12 - stMonth) + month) % masa) == 0) {
                            sti = getLatestInvoice(month, year, type, st);
                            if (sti.getOID() == 0) {
                                yesNew = true;
                            }
                        }
                    }

                }


                break;

        }

        return yesNew;

    }

    public static boolean isCreateNewInvoice(int masa, int month, int year, SewaTanah st) {

        SewaTanahInvoice sti = new SewaTanahInvoice();
        boolean yesNew = false;

        Calendar calendar = new GregorianCalendar(year, month - 1, 1, 0, 0, 0);
        calendar.add(Calendar.MONTH, 1);
        /***** GET NEXT MONTH *****/
        month = calendar.get(Calendar.MONTH) + 1;
        year = calendar.get(Calendar.YEAR);
        Date dueDate = calendar.getTime();

        /** Ignore when selected date before Komin/Komper/Assesment start date */
        int compareTo = 0;

        dueDate.setDate(st.getTanggalMulai().getDate());
        compareTo = dueDate.compareTo(st.getTanggalMulai());

        if (compareTo < 0) {
            System.out.println("isCreateNewInvoice() return FALSE");
            return false;
        }
        /**END*/
        switch (masa) {
            //BLN
            case 0: //kondisi untuk yg tdk menggunakan komin, invoice hasil generate diabaikan
                sti = getLatestInvoice(month, year, st);
                if (sti.getOID() == 0) {
                    yesNew = true;
                }
                break;
            case 1:
                sti = getLatestInvoice(month, year, st);
                if (sti.getOID() == 0) {
                    yesNew = true;
                }
                break;
            case 3:
                int stMonth = 0;

                stMonth = st.getTanggalMulai().getMonth() + 1; //tanggal invoice terbit


                if (month == stMonth) { //jika tanggal yg dipilih sama dng tanggal di data kontrak
                    sti = getLatestInvoice(month, year, st);
                    if (sti.getOID() == 0) {
                        yesNew = true;
                    }
                } else if (month > stMonth) { //jika tanggal yg dipilih setelah tanggal di data kontrak
                    if (((month - stMonth) % 3) == 0) {
                        sti = getLatestInvoice(month, year, st);
                        if (sti.getOID() == 0) {
                            yesNew = true;
                        }
                    }
                } else { //jika tanggal yg dipilih sebelum tanggal di data kontrak
                    if ((((12 - stMonth) + month) % 3) == 0) {
                        sti = getLatestInvoice(month, year, st);
                        if (sti.getOID() == 0) {
                            yesNew = true;
                        }
                    }
                }
                break;

            case 6:

                //stMonth =  st.getTglMulaiKomin().getMonth()+1;
                stMonth = 0;
                stMonth = st.getTanggalMulai().getMonth() + 1;

                if (month == stMonth) {
                    sti = getLatestInvoice(month, year, st);
                    if (sti.getOID() == 0) {
                        yesNew = true;
                    }
                } else if (month > stMonth) {
                    if (((month - stMonth) % 6) == 0) {
                        sti = getLatestInvoice(month, year, st);
                        if (sti.getOID() == 0) {
                            yesNew = true;
                        }
                    }
                } else {
                    if ((((12 - stMonth) + month) % 6) == 0) {
                        sti = getLatestInvoice(month, year, st);
                        if (sti.getOID() == 0) {
                            yesNew = true;
                        }
                    }
                }
                break;

            case 12:

                stMonth = 0;
                stMonth = st.getTglInvoiceKomin().getMonth() + 1;

                if (stMonth == month) {
                    sti = getLatestInvoice(month, year, st);
                    if (sti.getOID() == 0) {
                        yesNew = true;
                    }
                }
                break;
            //jika bukan salah satu diatas
            default:

                if (masa > 12) {
                    if (masa % 12 == 0) {

                        Date dtx = new Date();
                        dtx = st.getTanggalMulai();

                        int x = masa / 12;
                        stMonth = dtx.getMonth() + 1;
                        int stYear = dtx.getYear() + 1900;

                        if ((year - stYear) % x == 0) {
                            if (stMonth == month) {
                                sti = getLatestInvoice(month, year, st);
                                if (sti.getOID() == 0) {
                                    yesNew = true;
                                }
                            }
                        }
                    } //jika tidak genap tahunan
                    else {
                    //masih difikirkan
                    //hehehehe
                    }
                } //2,4,5,7,8,9,10,11
                else if (masa < 12) {

                    //stMonth =  st.getTglMulaiKomin().getMonth()+1;
                    stMonth = 0;
                    stMonth = st.getTanggalMulai().getMonth() + 1;

                    if (month > stMonth) {
                        if (((month - stMonth) % masa) == 0) {
                            sti = getLatestInvoice(month, year, st);
                            if (sti.getOID() == 0) {
                                yesNew = true;
                            }
                        }
                    } else {
                        if ((((12 - stMonth) + month) % masa) == 0) {
                            sti = getLatestInvoice(month, year, st);
                            if (sti.getOID() == 0) {
                                yesNew = true;
                            }
                        }
                    }
                }

                break;

        }
        return yesNew;

    }

    private static String getNamaMasa(int masa, Date dueDate) {
        String namaMasa = "";
        int month = dueDate.getMonth();
        int year = dueDate.getYear();

        switch (masa) {
            case 1:
                String[] nama = {"I", "II", "III", "IV", "V", "VI", "VII", "VII", "IX", "X", "XI", "XII"};
                namaMasa = "Bulan " + nama[month];
                break;
            case 3:
                if(month >= 0 && month <= 2) namaMasa = "Triwulan I";
                else if(month >= 3 && month <= 5) namaMasa = "Triwulan II";
                else if(month >= 6 && month <= 8) namaMasa = "Triwulan III";
                else if(month >= 9 && month <= 11) namaMasa = "Triwulan IV";
                break;
            case 6:
                if(month >= 0 && month <= 5) namaMasa = "Semester I";
                else namaMasa = "Semester II";
                break;
            default:
                break;
        }
        return namaMasa + " Tahun " + JSPFormater.formatDate(dueDate, "yyyy");
    }

    public static SewaTanahInvoice getLatestInvoice(int month, int year, int type, SewaTanah st) {

        String where = " month(" + colNames[COL_JATUH_TEMPO] + ")=" + month + " and year(" + colNames[COL_JATUH_TEMPO] + ")=" + year +
                " and " + colNames[COL_SEWA_TANAH_ID] + "=" + st.getOID() + " and " + colNames[COL_TYPE] + "=" + type;

        System.out.println("getLatestInvoice >> where: " + where);

        Vector temp = list(0, 1, where, colNames[COL_TANGGAL] + " desc");
        if (temp != null && temp.size() > 0) {
            return (SewaTanahInvoice) temp.get(0);
        }

        return new SewaTanahInvoice();
    }

    public static SewaTanahInvoice getLatestInvoice(int month, int year, SewaTanah st) {

        String where = " month(" + colNames[COL_JATUH_TEMPO] + ")=" + month + " and year(" + colNames[COL_JATUH_TEMPO] + ")=" + year +
                " and " + colNames[COL_SEWA_TANAH_ID] + "=" + st.getOID();

        System.out.println("getLatestInvoice >> where: " + where);

        Vector temp = list(0, 1, where, colNames[COL_TANGGAL] + " desc");
        if (temp != null && temp.size() > 0) {
            return (SewaTanahInvoice) temp.get(0);
        }

        return new SewaTanahInvoice();
    }

    public static synchronized Vector generateInvoice(int month, int year, int type, long userId) {

        Vector result = new Vector();

        Date selectedDate = new Date();
        selectedDate.setMonth(month - 1);
        selectedDate.setYear(year - 1900);

        /***********
         * DUEDATE : bulan jatuh tempo invoice merupakan awal bulan berikutnya
         * jan = 0
         * feb = 1
         * mar = 2
         * dst...
         */
        Calendar calendar = new GregorianCalendar(year, month - 1, 1, 0, 0, 0);
        calendar.add(Calendar.MONTH, 1);
        /***** GET NEXT MONTH *****/
        Date dueDate = calendar.getTime();

        Vector rincian = DbSewaTanahRincianPiutang.list(0, 0, DbSewaTanahRincianPiutang.colNames[DbSewaTanahRincianPiutang.COL_PERIODE_TAHUN] + "=" + year, "");

        SystemDocCode systemDocCode = new SystemDocCode();

        if (type == TYPE_INV_KOMIN) {
            systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_KOMIN]);
        } else {//type = TYPE_INV_KOMPER
            systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_KOMPER]);
        }

        String formatDocCode = systemDocCode.getCode() + systemDocCode.getSeparator() + YearMonth.getMonthRomawi(selectedDate.getMonth()) + systemDocCode.getSeparator() + JSPFormater.formatDate(selectedDate, "yy");

        int counter = DbSystemDocNumber.getDocCodeCounter(formatDocCode);

        if (rincian != null && rincian.size() > 0) {

            for (int i = 0; i < rincian.size(); i++) {

                SewaTanahRincianPiutang strp = (SewaTanahRincianPiutang) rincian.get(i);

                SewaTanah sewaTanah = new SewaTanah();
                try {
                    sewaTanah = DbSewaTanah.fetchExc(strp.getSewaTanahId());
                } catch (Exception e) {
                }

                int masa = 0;
                //if (type == TYPE_INV_KOMIN || type == TYPE_INV_KOMPER) {
                //    masa = strp.getMasaKominJmlBulan();
                //    dueDate.setDate(sewaTanah.getTglInvoiceKomin().getDate());
                //} else {
                //    masa = strp.getMasaAssesJmlBulan();
                //    dueDate.setDate(sewaTanah.getTglInvoiceAssesment().getDate());
                //}

                boolean createNew = true;//isCreateNewInvoice(masa, month, year, type, sewaTanah);

                if (createNew) {

                    SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();

                    sewatanahinvoice.setTanggal(selectedDate);
                    sewatanahinvoice.setInvestorId(sewaTanah.getInvestorId());
                    sewatanahinvoice.setSaranaId(sewaTanah.getCustomerId());

                    double amount = 0;

                    if (type == TYPE_INV_KOMIN || type == TYPE_INV_KOMPER) {
                        amount = strp.getNilaiKominTh() * strp.getMasaKominJmlBulan() / 12;
                        sewatanahinvoice.setCurrencyId(strp.getKominCurrencyId());
                        sewatanahinvoice.setKeterangan("Kewajiban Kompensasi Minimum <br>" + getNamaMasa(masa, dueDate));
                    } else {
                        amount = strp.getNilaiAssesTh() * strp.getMasaAssesJmlBulan() / 12;
                        sewatanahinvoice.setCurrencyId(strp.getAssesCurrencyId());
                        sewatanahinvoice.setKeterangan("Kewajiban Assesment <br>" + getNamaMasa(masa, dueDate));
                    }

                    sewatanahinvoice.setJumlah(amount);

                    sewatanahinvoice.setPphPersen((-1) * 10);
                    sewatanahinvoice.setPph((-1) * amount * 10 / 100);
                    sewatanahinvoice.setPpnPersen(10);
                    sewatanahinvoice.setPpn(amount * 10 / 100);

                    sewatanahinvoice.setJatuhTempo(dueDate);
                    sewatanahinvoice.setSewaTanahId(sewaTanah.getOID());
                    sewatanahinvoice.setUserId(userId);
                    sewatanahinvoice.setStatus(INV_STATUS_DRAFT);
                    sewatanahinvoice.setTanggalInput(new Date());
                    //sewatanahinvoice.setCounter(pstSewaTanahInvoice.getInt(COL_COUNTER));
                    //sewatanahinvoice.setPrefixNumber(pstSewaTanahInvoice.getString(COL_PREFIX_NUMBER));
                    //sewatanahinvoice.setNumber(pstSewaTanahInvoice.getString(COL_NUMBER));

                    sewatanahinvoice.setType(type);

                    if (type == TYPE_INV_KOMIN || type == TYPE_INV_KOMPER) {

                        sewatanahinvoice.setMasaInvoiceId(strp.getMasaKominId());
                        sewatanahinvoice.setJmlBulan(strp.getMasaKominJmlBulan());

                        //format = 28/INV/XII/10

                        String formatDoc = counter + systemDocCode.getSeparator() + formatDocCode;

                        sewatanahinvoice.setNumber(formatDoc);
                        sewatanahinvoice.setCounter(counter);

                    } else {

                        sewatanahinvoice.setMasaInvoiceId(strp.getMasaAssesId());
                        sewatanahinvoice.setJmlBulan(strp.getMasaAssesJmlBulan());

                        //format = 28/INV/XII/10

                        String formatDoc = counter + systemDocCode.getSeparator() + formatDocCode;

                        sewatanahinvoice.setNumber(formatDoc);
                        sewatanahinvoice.setCounter(counter);

                    }

                    sewatanahinvoice.setNoFp("");
                    sewatanahinvoice.setTotalDenda(0);

                    result.add(sewatanahinvoice);

                    counter++;

                }
            }
        }

        return result;
    }

    public static synchronized Vector generateInvoice(int month, int year, long userId) {

        Vector result = new Vector();

        Date selectedDate = new Date();
        selectedDate.setMonth(month - 1);
        selectedDate.setYear(year - 1900);

        /***********
         * DUEDATE : bulan jatuh tempo invoice merupakan awal bulan berikutnya
         * jan = 0
         * feb = 1
         * mar = 2
         * dst...
         */
        Calendar calendar = new GregorianCalendar(year, month - 1, 1, 0, 0, 0);
        calendar.add(Calendar.MONTH, 1);
        /***** GET NEXT MONTH *****/
        Date dueDate = calendar.getTime();

        Vector rincian = DbSewaTanahRincianPiutang.list(0, 0, DbSewaTanahRincianPiutang.colNames[DbSewaTanahRincianPiutang.COL_PERIODE_TAHUN] + "=" + year, "");

        SystemDocCode systemDocCode = new SystemDocCode();

        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_RENTAL]);

        String formatDocCode = systemDocCode.getCode() + systemDocCode.getSeparator() + YearMonth.getMonthRomawi(selectedDate.getMonth()) + systemDocCode.getSeparator() + JSPFormater.formatDate(selectedDate, "yy");

        int counter = DbSystemDocNumber.getDocCodeCounter(formatDocCode);

        if (rincian != null && rincian.size() > 0) {

            for (int i = 0; i < rincian.size(); i++) {

                SewaTanahRincianPiutang strp = (SewaTanahRincianPiutang) rincian.get(i);

                SewaTanah sewaTanah = new SewaTanah();
                try {
                    sewaTanah = DbSewaTanah.fetchExc(strp.getSewaTanahId());
                } catch (Exception e) {
                }

                int masa = 0;
                masa = strp.getMasaKominJmlBulan();
                dueDate.setDate(sewaTanah.getTanggalMulai().getDate());

                //if (type == TYPE_INV_KOMIN || type == TYPE_INV_KOMPER) {
                //    masa = strp.getMasaKominJmlBulan();
                //    dueDate.setDate(sewaTanah.getTglInvoiceKomin().getDate());
                //} else {
                //    masa = strp.getMasaAssesJmlBulan();
                //    dueDate.setDate(sewaTanah.getTglInvoiceAssesment().getDate());
                //}

                boolean createNew = true;//isCreateNewInvoice(masa, month, year, sewaTanah);

                if (createNew) {

                    SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();

                    sewatanahinvoice.setTanggal(selectedDate);
                    sewatanahinvoice.setInvestorId(sewaTanah.getInvestorId());
                    sewatanahinvoice.setSaranaId(sewaTanah.getCustomerId());

                    double amount = 0;

                    amount = strp.getNilaiKominTh() * strp.getMasaKominJmlBulan() / 12;
                    sewatanahinvoice.setCurrencyId(strp.getKominCurrencyId());
                    sewatanahinvoice.setKeterangan("Kewajiban sewa <br>" + getNamaMasa(masa, dueDate));

                    sewatanahinvoice.setJumlah(amount);

                    sewatanahinvoice.setPphPersen((-1) * 10);
                    sewatanahinvoice.setPph((-1) * amount * 10 / 100);
                    sewatanahinvoice.setPpnPersen(10);
                    sewatanahinvoice.setPpn(amount * 10 / 100);

                    sewatanahinvoice.setJatuhTempo(dueDate);
                    sewatanahinvoice.setSewaTanahId(sewaTanah.getOID());
                    sewatanahinvoice.setUserId(userId);
                    sewatanahinvoice.setStatus(INV_STATUS_DRAFT);
                    sewatanahinvoice.setTanggalInput(new Date());

                    //sewatanahinvoice.setCounter(pstSewaTanahInvoice.getInt(COL_COUNTER));
                    //sewatanahinvoice.setPrefixNumber(pstSewaTanahInvoice.getString(COL_PREFIX_NUMBER));
                    //sewatanahinvoice.setNumber(pstSewaTanahInvoice.getString(COL_NUMBER));

                    //sewatanahinvoice.setType(type);

                    //if (type == TYPE_INV_KOMIN || type == TYPE_INV_KOMPER) {

                    sewatanahinvoice.setMasaInvoiceId(strp.getMasaKominId());
                    sewatanahinvoice.setJmlBulan(strp.getMasaKominJmlBulan());

                    //format = 28/INV/XII/10

                    String formatDoc = counter + systemDocCode.getSeparator() + formatDocCode;

                    sewatanahinvoice.setNumber(formatDoc);
                    sewatanahinvoice.setCounter(counter);

                    //} else {

                    //sewatanahinvoice.setMasaInvoiceId(strp.getMasaAssesId());
                    //sewatanahinvoice.setJmlBulan(strp.getMasaAssesJmlBulan());

                    //format = 28/INV/XII/10

                    ///String formatDoc = counter + systemDocCode.getSeparator() + formatDocCode;

                    //sewatanahinvoice.setNumber(formatDoc);
                    //sewatanahinvoice.setCounter(counter);

                    //}

                    sewatanahinvoice.setNoFp("");
                    sewatanahinvoice.setTotalDenda(0);

                    result.add(sewatanahinvoice);

                    counter++;

                }
            }
        }

        return result;
    }

    /**
     * @Author  Roy Andika
     * @Desc    Untuk memproses sewa tanah Komin, komper, assesment
     * @param   month
     * @param   year
     * @param   type
     * @param   userId
     * @return
     */
    public static synchronized Vector prosesSewaTanah(int month, int year, int type, long userId) {

        try {
            Vector result = new Vector();

            Date selectedDate = new Date();
            selectedDate.setMonth(month - 1);
            selectedDate.setYear(year - 1900);

            /***********
             * DUEDATE : bulan jatuh tempo invoice merupakan awal bulan berikutnya
             * jan = 0; feb = 1; mar = 2; dst...
             */
            Calendar calendar = new GregorianCalendar(year, month - 1, 1, 0, 0, 0);
            calendar.add(Calendar.MONTH, 1);
            /***** GET NEXT MONTH *****/
            Date dueDate = calendar.getTime();

            Vector rincian = DbSewaTanahRincianPiutang.list(0, 0, DbSewaTanahRincianPiutang.colNames[DbSewaTanahRincianPiutang.COL_PERIODE_TAHUN] + "=" + year, "");

            if (rincian != null && rincian.size() > 0) {

                for (int i = 0; i < rincian.size(); i++) {

                    SewaTanahRincianPiutang strp = (SewaTanahRincianPiutang) rincian.get(i);

                    SewaTanah sewaTanah = new SewaTanah();
                    try {
                        sewaTanah = DbSewaTanah.fetchExc(strp.getSewaTanahId());
                    } catch (Exception e) {
                    }

                    int masa = 0;
                    if (type == TYPE_INV_KOMIN || type == TYPE_INV_KOMPER) {
                        masa = strp.getMasaKominJmlBulan();
                    } else {
                        masa = strp.getMasaAssesJmlBulan();
                    }

                    boolean createNew = true;//isCreateNewInvoice(masa, month, year, type, sewaTanah);
                    String noInvoice = "";

                    if (createNew) {

                        SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();

                        sewatanahinvoice.setTanggal(selectedDate);
                        sewatanahinvoice.setInvestorId(sewaTanah.getInvestorId());
                        sewatanahinvoice.setSaranaId(sewaTanah.getCustomerId());

                        String keterangan = "";

                        double amount = 0;

                        if (type == TYPE_INV_KOMIN || type == TYPE_INV_KOMPER) {
                            amount = strp.getNilaiKominTh() * strp.getMasaKominJmlBulan() / 12;
                            sewatanahinvoice.setCurrencyId(strp.getKominCurrencyId());
                            sewatanahinvoice.setKeterangan("Kewajiban Kompensasi Minimum <br>" + getNamaMasa(masa, dueDate));
                            keterangan = "Kewajiban Kompensasi Minimum <br>" + getNamaMasa(masa, dueDate);
                        } else {
                            amount = strp.getNilaiAssesTh() * strp.getMasaAssesJmlBulan() / 12;
                            sewatanahinvoice.setCurrencyId(strp.getAssesCurrencyId());
                            sewatanahinvoice.setKeterangan("Kewajiban Assesment <br>" + getNamaMasa(masa, dueDate));
                            keterangan = "Kewajiban Assesment <br>" + getNamaMasa(masa, dueDate);
                        }

                        sewatanahinvoice.setJumlah(amount);

                        sewatanahinvoice.setPphPersen((-1) * 10);
                        sewatanahinvoice.setPph((-1) * amount * 10 / 100);
                        sewatanahinvoice.setPpnPersen(10);
                        sewatanahinvoice.setPpn(amount * 10 / 100);
                        sewatanahinvoice.setJatuhTempo(dueDate);
                        sewatanahinvoice.setSewaTanahId(sewaTanah.getOID());
                        sewatanahinvoice.setUserId(userId);
                        sewatanahinvoice.setStatus(INV_STATUS_DRAFT);
                        sewatanahinvoice.setTanggalInput(new Date());

                        sewatanahinvoice.setType(type);

                        if (type == TYPE_INV_KOMIN || type == TYPE_INV_KOMPER) {

                            sewatanahinvoice.setMasaInvoiceId(strp.getMasaKominId());
                            sewatanahinvoice.setJmlBulan(strp.getMasaKominJmlBulan());

                            /* Untuk penentuan nomor invoice */
                            SystemDocCode systemDocCode = new SystemDocCode();

                            if (type == TYPE_INV_KOMIN) {
                                systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_KOMIN]);
                            } else { //type = TYPE_INV_KOMPER
                                systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_KOMPER]);
                            }

                            int monthVal = sewatanahinvoice.getTanggal().getMonth();

                            //format = 28/INV/XII/10
                            String formatDocCode = systemDocCode.getCode() + systemDocCode.getSeparator() + YearMonth.getMonthRomawi(monthVal) + systemDocCode.getSeparator() + JSPFormater.formatDate(sewatanahinvoice.getTanggal(), "yy");

                            int counter = DbSystemDocNumber.getDocCodeCounter(formatDocCode);

                            // proses untuk object ke general penanpungan code
                            SystemDocNumber systemDocNumber = new SystemDocNumber();
                            systemDocNumber.setCounter(counter);
                            systemDocNumber.setDate(sewatanahinvoice.getTanggal());
                            systemDocNumber.setPrefixNumber(formatDocCode);
                            systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_LIMBAH]);
                            systemDocNumber.setYear(sewatanahinvoice.getTanggal().getYear() + 1900);

                            formatDocCode = counter + systemDocCode.getSeparator() + formatDocCode;
                            systemDocNumber.setDocNumber(formatDocCode);

                            try {
                                // proses insert Doc Number
                                DbSystemDocNumber.insertExc(systemDocNumber);

                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }

                            noInvoice = formatDocCode;
                            sewatanahinvoice.setNumber(formatDocCode);
                            sewatanahinvoice.setCounter(counter);


                        } else {

                            sewatanahinvoice.setMasaInvoiceId(strp.getMasaAssesId());
                            sewatanahinvoice.setJmlBulan(strp.getMasaAssesJmlBulan());

                            /* Untuk penentuan nomor invoice */
                            SystemDocCode systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_ASSESSMENT]);
                            int monthVal = sewatanahinvoice.getTanggal().getMonth();

                            //format = 28/INV/XII/10
                            String formatDocCode = systemDocCode.getCode() + systemDocCode.getSeparator() + YearMonth.getMonthRomawi(monthVal) + systemDocCode.getSeparator() + JSPFormater.formatDate(sewatanahinvoice.getTanggal(), "yy");

                            int counter = DbSystemDocNumber.getDocCodeCounter(formatDocCode);

                            // proses untuk object ke general penanpungan code
                            SystemDocNumber systemDocNumber = new SystemDocNumber();
                            systemDocNumber.setCounter(counter);
                            systemDocNumber.setDate(sewatanahinvoice.getTanggal());
                            systemDocNumber.setPrefixNumber(formatDocCode);
                            systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_LIMBAH]);
                            systemDocNumber.setYear(sewatanahinvoice.getTanggal().getYear() + 1900);

                            formatDocCode = counter + systemDocCode.getSeparator() + formatDocCode;
                            systemDocNumber.setDocNumber(formatDocCode);

                            try {
                                // proses insert Doc Number
                                DbSystemDocNumber.insertExc(systemDocNumber);
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                            noInvoice = formatDocCode;
                            sewatanahinvoice.setNumber(formatDocCode);
                            sewatanahinvoice.setCounter(counter);

                        }

                        sewatanahinvoice.setNoFp("");
                        sewatanahinvoice.setTotalDenda(0);

                        try {

                            long oid = DbSewaTanahInvoice.insertExc(sewatanahinvoice);

                            if (oid != 0) {

                                /* Insert ke Bku Pembantu piutang*/
                                SewaTanahBp sewaTanahBp = new SewaTanahBp();

                                sewaTanahBp.setTanggal(selectedDate);
                                sewaTanahBp.setKeterangan(keterangan);
                                sewaTanahBp.setRefnumber(noInvoice);
                                sewaTanahBp.setMem("-");
                                sewaTanahBp.setDebet(amount);
                                sewaTanahBp.setCredit(0);
                                sewaTanahBp.setMataUangId(strp.getKominCurrencyId());
                                sewaTanahBp.setSewaTanahId(sewaTanah.getOID());
                                sewaTanahBp.setSewaTanahInvId(oid);

                                sewaTanahBp.setCustomerId(sewatanahinvoice.getSaranaId());
                                sewaTanahBp.setIrigasiTransactionId(0);
                                sewaTanahBp.setLimbahTransactionId(0);

                                long oidStb = DbSewaTanahBp.insertExc(sewaTanahBp);

                            }

                        } catch (Exception e) {
                            System.out.println();
                        }

                        result.add(sewatanahinvoice);

                    }

                }
            }

            return result;


        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return null;
    }

    public static synchronized Vector prosesSewaTanah(int month, int year, long userId) {

        try {
            Vector result = new Vector();

            Date selectedDate = new Date();
            selectedDate.setMonth(month - 1);
            selectedDate.setYear(year - 1900);

            Calendar calendar = new GregorianCalendar(year, month - 1, 1, 0, 0, 0);
            calendar.add(Calendar.MONTH, 1);
            Date dueDate = calendar.getTime();

            Vector rincian = DbSewaTanahRincianPiutang.list(0, 0, DbSewaTanahRincianPiutang.colNames[DbSewaTanahRincianPiutang.COL_PERIODE_TAHUN] + "=" + year, "");

            if (rincian != null && rincian.size() > 0) {

                for (int i = 0; i < rincian.size(); i++) {

                    SewaTanahRincianPiutang strp = (SewaTanahRincianPiutang) rincian.get(i);

                    SewaTanah sewaTanah = new SewaTanah();
                    try {
                        sewaTanah = DbSewaTanah.fetchExc(strp.getSewaTanahId());
                    } catch (Exception e) {
                    }

                    int masa = 0;

                    masa = strp.getMasaKominJmlBulan();

                    boolean createNew = true;//isCreateNewInvoice(masa, month, year, sewaTanah);
                    String noInvoice = "";

                    if (createNew) {

                        SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();

                        sewatanahinvoice.setTanggal(selectedDate);
                        sewatanahinvoice.setInvestorId(sewaTanah.getInvestorId());
                        sewatanahinvoice.setSaranaId(sewaTanah.getCustomerId());

                        String keterangan = "";

                        double amount = 0;


                        amount = strp.getNilaiKominTh() * strp.getMasaKominJmlBulan() / 12;
                        sewatanahinvoice.setCurrencyId(strp.getKominCurrencyId());
                        sewatanahinvoice.setKeterangan("Kewajiban Sewa <br>" + getNamaMasa(masa, dueDate));
                        keterangan = "Kewajiban Sewa <br>" + getNamaMasa(masa, dueDate);


                        sewatanahinvoice.setJumlah(amount);

                        sewatanahinvoice.setPphPersen((-1) * 10);
                        sewatanahinvoice.setPph((-1) * amount * 10 / 100);
                        sewatanahinvoice.setPpnPersen(10);
                        sewatanahinvoice.setPpn(amount * 10 / 100);
                        sewatanahinvoice.setJatuhTempo(dueDate);
                        sewatanahinvoice.setSewaTanahId(sewaTanah.getOID());
                        sewatanahinvoice.setUserId(userId);
                        sewatanahinvoice.setStatus(INV_STATUS_DRAFT);
                        sewatanahinvoice.setTanggalInput(new Date());

                        //sewatanahinvoice.setType(type);

                        sewatanahinvoice.setMasaInvoiceId(strp.getMasaKominId());
                        sewatanahinvoice.setJmlBulan(strp.getMasaKominJmlBulan());

                        /* Untuk penentuan nomor invoice */
                        SystemDocCode systemDocCode = new SystemDocCode();
                        systemDocCode = DbSystemDocCode.getDocCodeByTypeCode(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_RENTAL]);


                        int monthVal = sewatanahinvoice.getTanggal().getMonth();

                        //format = 28/INV/XII/10
                        String formatDocCode = systemDocCode.getCode() + systemDocCode.getSeparator() + YearMonth.getMonthRomawi(monthVal) + systemDocCode.getSeparator() + JSPFormater.formatDate(sewatanahinvoice.getTanggal(), "yy");

                        int counter = DbSystemDocNumber.getDocCodeCounter(formatDocCode);

                        // proses untuk object ke general penanpungan code
                        SystemDocNumber systemDocNumber = new SystemDocNumber();
                        systemDocNumber.setCounter(counter);
                        systemDocNumber.setDate(sewatanahinvoice.getTanggal());
                        systemDocNumber.setPrefixNumber(formatDocCode);
                        systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_RENTAL]);
                        systemDocNumber.setYear(sewatanahinvoice.getTanggal().getYear() + 1900);

                        formatDocCode = counter + systemDocCode.getSeparator() + formatDocCode;
                        systemDocNumber.setDocNumber(formatDocCode);

                        try {
                            // proses insert Doc Number
                            DbSystemDocNumber.insertExc(systemDocNumber);

                        } catch (Exception e) {
                            System.out.println("[exception] " + e.toString());
                        }

                        noInvoice = formatDocCode;
                        sewatanahinvoice.setNumber(formatDocCode);
                        sewatanahinvoice.setCounter(counter);

                        sewatanahinvoice.setNoFp("");
                        sewatanahinvoice.setTotalDenda(0);

                        try {

                            long oid = DbSewaTanahInvoice.insertExc(sewatanahinvoice);

                            if (oid != 0) {

                                /* Insert ke Bku Pembantu piutang*/
                                SewaTanahBp sewaTanahBp = new SewaTanahBp();

                                sewaTanahBp.setTanggal(selectedDate);
                                sewaTanahBp.setKeterangan(keterangan);
                                sewaTanahBp.setRefnumber(noInvoice);
                                sewaTanahBp.setMem("-");
                                sewaTanahBp.setDebet(amount);
                                sewaTanahBp.setCredit(0);
                                sewaTanahBp.setMataUangId(strp.getKominCurrencyId());
                                sewaTanahBp.setSewaTanahId(sewaTanah.getOID());
                                sewaTanahBp.setSewaTanahInvId(oid);

                                sewaTanahBp.setCustomerId(sewatanahinvoice.getSaranaId());
                                sewaTanahBp.setIrigasiTransactionId(0);
                                sewaTanahBp.setLimbahTransactionId(0);

                                DbSewaTanahBp.insertExc(sewaTanahBp);
                            }
                        } catch (Exception e) {
                            System.out.println();
                        }
                        result.add(sewatanahinvoice);
                    }

                }
            }

            return result;
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return null;
    }

    //POSTING ke journal - ar assesment & komin
    public static boolean postJournal(SewaTanahInvoice sewaTanahInvoice) {

        boolean ok = true;

        if (sewaTanahInvoice.getType() == TYPE_INV_KOMIN) {
            ok = postJournalKomin(sewaTanahInvoice);
        } else if (sewaTanahInvoice.getType() == TYPE_INV_ASSESMENT) {
            ok = postJournalAssesment(sewaTanahInvoice);
        }

        return ok;

    }

    //journal income Income 90%, 
    //dimana pph sudah dikurangi dari income
    public static boolean postJournalKomin(SewaTanahInvoice sewaTanahInvoice) {

        boolean ok = true;

        System.out.println("\n---- bean start posting journal AR komin ---");

        Company comp = DbCompany.getCompany();

        //IrigasiTransaction limbah = cr;//new IrigasiTransaction();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanahInvoice.getSaranaId());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

       

        //invoice - Invoice Komin

        String memo = cus.getName() + " - Tagihan Kompensasi Minimum, invoice : " + sewaTanahInvoice.getNumber() +
                ", tanggal : " + JSPFormater.formatDate(sewaTanahInvoice.getTanggal(), "dd/MM/yyyy");

        //jika sarana mamakai limbahgasi	                           
        if (true) {

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, 
            //int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), sewaTanahInvoice.getCounter(), sewaTanahInvoice.getNumber(), sewaTanahInvoice.getNumber(),
                    I_Project.JOURNAL_TYPE_INVOICE,
                    memo, 0, "", sewaTanahInvoice.getOID(), "", sewaTanahInvoice.getTanggal());

            //pengakuan piutang
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                double excRate = 0;
                if (sewaTanahInvoice.getCurrencyId() == comp.getBookingCurrencyId()) {
                    excRate = 1;
                } else {
                    ExchangeRate erate = DbExchangeRate.getStandardRate();
                    excRate = erate.getValueUsd();
                }

                //journal debet piutang
                //double harga = sewaTanahInvoice.getJumlah()+sewaTanahInvoice.getPpn()+sewaTanahInvoice.getPph();
                //piutang

                Currency c = new Currency();
                try {
                    c = DbCurrency.fetchExc(sewaTanahInvoice.getCurrencyId());
                } catch (Exception e) {
                }

                String detailMemo = memo + ", " + c.getCurrencyCode() + " " + JSPFormater.formatNumber(sewaTanahInvoice.getJumlah(), "#,###.##") +
                        ", ExcRate : " + JSPFormater.formatNumber(excRate, "#,###.##");

                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);


                //update status invoice
                try {
                    sewaTanahInvoice.setStatus(DbSewaTanahInvoice.INV_STATUS_POSTED);
                    DbSewaTanahInvoice.updateExc(sewaTanahInvoice);
                } catch (Exception e) {

                }


            } else {
                ok = false;
            }

        } else {
            ok = false;
        }

        return ok;

    }

    //journal income Income 90%, 
    //dimana pph sudah dikurangi dari income
    public static boolean postJournalAssesment(SewaTanahInvoice sewaTanahInvoice) {

        boolean ok = true;

        System.out.println("\n---- bean start posting journal AR Ass ---");

        Company comp = DbCompany.getCompany();

        //IrigasiTransaction limbah = cr;//new IrigasiTransaction();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanahInvoice.getSaranaId());
        } catch (Exception e) {
        }


        //invoice - Invoice Komin

        String memo = cus.getName() + " - Tagihan Assesment, invoice : " + sewaTanahInvoice.getNumber() +
                ", tanggal : " + JSPFormater.formatDate(sewaTanahInvoice.getTanggal(), "dd/MM/yyyy");

        //jika sarana mamakai limbahgasi	                           
        if (true) {

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, 
            //int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), sewaTanahInvoice.getCounter(), sewaTanahInvoice.getNumber(), sewaTanahInvoice.getNumber(),
                    I_Project.JOURNAL_TYPE_INVOICE,
                    memo, 0, "", sewaTanahInvoice.getOID(), "", sewaTanahInvoice.getTanggal());

            //pengakuan piutang
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                double excRate = 0;
                if (sewaTanahInvoice.getCurrencyId() == comp.getBookingCurrencyId()) {
                    excRate = 1;
                } else {
                    ExchangeRate erate = DbExchangeRate.getStandardRate();
                    excRate = erate.getValueUsd();
                }

                Currency c = new Currency();
                try {
                    c = DbCurrency.fetchExc(sewaTanahInvoice.getCurrencyId());
                } catch (Exception e) {
                }

             
                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);


                //update status invoice
                try {
                    sewaTanahInvoice.setStatus(DbSewaTanahInvoice.INV_STATUS_POSTED);
                    DbSewaTanahInvoice.updateExc(sewaTanahInvoice);
                } catch (Exception e) {

                }


            } else {
                ok = false;
            }

        } else {
            ok = false;
        }

        return ok;

    }

    //journal income dengan menjurnal pph
    public static boolean postJournalAssesment_org(SewaTanahInvoice sewaTanahInvoice) {

        boolean ok = true;

        System.out.println("\n---- bean start posting journal AR komin ---");

        Company comp = DbCompany.getCompany();

        //IrigasiTransaction limbah = cr;//new IrigasiTransaction();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanahInvoice.getSaranaId());
        } catch (Exception e) {
        }


        //invoice - Invoice Komin

        String memo = cus.getName() + " - Tagihan Assesment, invoice : " + sewaTanahInvoice.getNumber() +
                ", tanggal : " + JSPFormater.formatDate(sewaTanahInvoice.getTanggal(), "dd/MM/yyyy");

        //jika sarana mamakai limbahgasi	                           
        if (true) {

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, 
            //int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), sewaTanahInvoice.getCounter(), sewaTanahInvoice.getNumber(), sewaTanahInvoice.getNumber(),
                    I_Project.JOURNAL_TYPE_INVOICE,
                    memo, 0, "", sewaTanahInvoice.getOID(), "", sewaTanahInvoice.getTanggal());

            //pengakuan piutang
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                double excRate = 0;
                if (sewaTanahInvoice.getCurrencyId() == comp.getBookingCurrencyId()) {
                    excRate = 1;
                } else {
                    ExchangeRate erate = DbExchangeRate.getStandardRate();
                    excRate = erate.getValueUsd();
                }

                //journal debet piutang
                double harga = sewaTanahInvoice.getJumlah() + sewaTanahInvoice.getPpn() + sewaTanahInvoice.getPph();
                //piutang
             
                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);

                //update status invoice
                try {
                    sewaTanahInvoice.setStatus(DbSewaTanahInvoice.INV_STATUS_POSTED);
                    DbSewaTanahInvoice.updateExc(sewaTanahInvoice);
                } catch (Exception e) {

                }

            } else {
                ok = false;
            }

        } else {
            ok = false;
        }

        return ok;

    }

    //POSTING ke journal - ar sewa tanah komin
    public static boolean postJournalDenda(SewaTanahInvoice sewaTanah) {

        //Set Department ID
        long departmentId = 0;
        try {
            String ID_DEPARTMENT = DbSystemProperty.getValueByName("ID_DEPARTMENT");
            if (ID_DEPARTMENT.equals("Not initialized")) {
                return false;
            } else {
                departmentId = Long.parseLong(ID_DEPARTMENT);
                Department d = DbDepartment.fetchExc(departmentId);
                if (d.getOID() == 0) {
                    return false;
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
            return false;
        }

        boolean ok = true;

        System.out.println("\n---- bean start posting journal denda pembayaran ---");

        Company comp = DbCompany.getCompany();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanah.getSaranaId());
        } catch (Exception e) {
        }

        String memo = cus.getName() + " - Denda komin, invoice : " + sewaTanah.getNumber() + "D" +
                ", tanggal : " + JSPFormater.formatDate(sewaTanah.getTanggal(), "dd/MM/yyyy");

        
        return ok;

    }

    //POSTING ke journal - ar sewa tanah komper
    public static boolean postJournalDendaKomper(SewaTanahInvoice sewaTanah) {

        //Set Department ID
        long departmentId = 0;
        try {
            String ID_DEPARTMENT = DbSystemProperty.getValueByName("ID_DEPARTMENT");
            if (ID_DEPARTMENT.equals("Not initialized")) {
                return false;
            } else {
                departmentId = Long.parseLong(ID_DEPARTMENT);
                Department d = DbDepartment.fetchExc(departmentId);
                if (d.getOID() == 0) {
                    return false;
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
            return false;
        }

        boolean ok = true;

        System.out.println("\n---- bean start posting journal denda komper ---");

        Company comp = DbCompany.getCompany();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanah.getSaranaId());
        } catch (Exception e) {
        }

       

        String memo = cus.getName() + " - Denda komper, invoice : " + sewaTanah.getNumber() + "D" +
                ", tanggal : " + JSPFormater.formatDate(sewaTanah.getTanggal(), "dd/MM/yyyy");

      

        return ok;

    }

    public static boolean postJournalDendaAssesment(SewaTanahInvoice sewaTanah){

        //Set Department ID
        long departmentId = 0;
        try {
            String ID_DEPARTMENT = DbSystemProperty.getValueByName("ID_DEPARTMENT");
            if (ID_DEPARTMENT.equals("Not initialized")) {
                return false;
            } else {
                departmentId = Long.parseLong(ID_DEPARTMENT);
                Department d = DbDepartment.fetchExc(departmentId);
                if (d.getOID() == 0) {
                    return false;
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
            return false;
        }

        boolean ok = true;

        System.out.println("\n---- bean start posting journal denda pembayaran ---");

        Company comp = DbCompany.getCompany();

        Customer cus = new Customer();

        try {
            cus = DbCustomer.fetchExc(sewaTanah.getSaranaId());
        } catch (Exception e) {
        }


        String memo = cus.getName() + " - Denda assesment, invoice : " + sewaTanah.getNumber() + "D" +
                ", tanggal : " + JSPFormater.formatDate(sewaTanah.getTanggal(), "dd/MM/yyyy");

        

        return ok;

    }

    /**
     * create by gwawan 20110728
     * Get invoice Komper list
     * @param month
     * @param year
     * @param checkTotalKomper - Digunakan jika ingin menampilkan Invoice Komper yang memiliki total KOMPER > 0
     * @return
     */
    public static Vector listInvoiceKomper(int month, int year, boolean checkTotalKomper) {
        CONResultSet dbrs = null;
        Vector list = new Vector();

        try {
            String sDate = JSPFormater.formatDate(year + "/" + month + "/31", "yyyy/mm/dd", "yyyy/mm/dd");

            String sql = "";

            if (checkTotalKomper) {
                sql = sql = "SELECT sti.* FROM crm_sewa_tanah st INNER JOIN crm_sewa_tanah_invoice sti" +
                        " ON st.sewa_tanah_id = sti.sewa_tanah_id" +
                        " INNER JOIN crm_sewa_tanah_benefit stb ON st.sewa_tanah_id = stb.sewa_tanah_id" +
                        " WHERE st.tgl_mulai_komper <= '" + sDate + "%' AND" +
                        " (month(sti.tanggal)=" + month + " AND year(sti.tanggal)=" + year + ") AND" +
                        " " + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TYPE] + "=" + DbSewaTanahInvoice.TYPE_INV_KOMIN +
                        " AND stb.total_komper > 0";
            } else {
                sql = "SELECT sti.* FROM crm_sewa_tanah st INNER JOIN crm_sewa_tanah_invoice sti" +
                        " ON st.sewa_tanah_id = sti.sewa_tanah_id" +
                        " WHERE st.tgl_mulai_komper <= '" + sDate + "%' AND" +
                        " (month(sti.tanggal)=" + month + " AND year(sti.tanggal)=" + year + ") AND" +
                        " " + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TYPE] + "=" + DbSewaTanahInvoice.TYPE_INV_KOMIN;
            }
            System.out.println("listInvoiceKomper: " + sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();
                resultToObject(rs, sewatanahinvoice);
                list.add(sewatanahinvoice);
            }
        } catch (Exception e) {
            System.out.println("listInvoiceKomper: " + e.toString());
        }
        return list;
    }
    
    public static double totalPayment(long sti){
        CONResultSet dbrs = null;
        try{
            String sql = "select sum("+DbPembayaran.colNames[DbPembayaran.COL_JUMLAH]+") from "+
                    DbPembayaran.DB_CRM_PEMBAYARAN+" where "+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+" = "+sti;
                    
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();  
            
            while (rs.next()) {
                return rs.getDouble(1);
            }
                    
        }catch(Exception e){}
        finally{
            CONResultSet.close(dbrs);
        }
        return 0;
    }
    
    public static Vector listInvoice(long customerId, int type, Date start, Date end){
        
        try{
            
            if(type == 1){
                
                Date currDt = new Date();
                Date startDate = currDt;
                Date endDate = currDt;
                
                long longstartDate = currDt.getTime() - (15 * 24 * 60 * 60 * 1000);
                long longendDate = currDt.getTime() + (15 * 24 * 60 * 60 * 1000);
                
                startDate = new Date(longstartDate);
                endDate = new Date(longendDate);
                
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" != 1 and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where + " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                }        
                
                where = where + " to_days(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = to_days('"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd")+"') ";
                
                Vector list = invoice(where);
                return list;
                
            }else if(type == 2){
                Date currDt = new Date();
                int month = currDt.getMonth()+1;
                int year= currDt.getYear()+1900;
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" != 1 and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+" sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where + " month(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+month+" and year(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+year;
                Vector list = invoice(where);
                return list;
            }else if(type == 3){
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" != 1 and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+" sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where + " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" >= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"'";
                
                Vector list = invoice(where);
                return list;
            }else{
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" != 1 and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+" sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                Vector list = invoice(where);
                return list;
            }
            
        }catch(Exception e){}
        return null;
    }
    
    
    public static Vector listInvoice(int limitStart, int recordToGet, long customerId, int type, Date start, Date end,int statusPembayaran){
        
        try{
            
            if(type == 1){
                
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+statusPembayaran+" and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where + " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                }        
                
                where = where + " to_days(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = to_days('"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd")+"') ";
                
                Vector list = invoice(limitStart,recordToGet,where);
                return list;
                
            }else if(type == 2){
                Date currDt = new Date();
                int month = currDt.getMonth()+1;
                int year= currDt.getYear()+1900;
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+statusPembayaran+" and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+" sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where + " month(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+month+" and year(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+year;
                Vector list = invoice(limitStart,recordToGet,where);
                return list;
            }else if(type == 3){
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+statusPembayaran+" and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+" sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where + " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" >= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"'";
                
                Vector list = invoice(limitStart,recordToGet,where);
                return list;
            }else{
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+statusPembayaran+" and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+" sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                Vector list = invoice(limitStart,recordToGet,where);
                return list;
            }
            
        }catch(Exception e){}
        return null;
    }
    
    public static int countInvoice( long customerId, int type, Date start, Date end,int statusPembayaran){
        
        try{
            
            if(type == 1){
                
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+statusPembayaran+" and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where + " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                
                if(where.length() > 0){
                    where = where+ " and ";
                }        
                
                where = where + " to_days(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = to_days('"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd")+"') ";
                
                int count = countInvoice(where);
                return count;
                
            }else if(type == 2){
                Date currDt = new Date();
                int month = currDt.getMonth()+1;
                int year= currDt.getYear()+1900;
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+statusPembayaran+" and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+" sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where + " month(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+month+" and year(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+") = "+year;
                int count = countInvoice(where);
                return count;
            }else if(type == 3){
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+statusPembayaran+" and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+" sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                if(where.length() > 0){
                    where = where+ " and ";
                }    
                where = where + " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" >= '"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"' and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL]+" <= '"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"'";
                
                int count = countInvoice(where);
                return count;
            }else{
                String where = " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+" = "+statusPembayaran+" and sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS]+" = "+DbSewaTanahInvoice.STATUS_PROP_APPROVED;
                if(customerId != 0){
                    if(where.length() > 0){
                        where = where+ " and ";
                    }        
                    where = where+" sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+" = "+customerId;
                }
                int count = countInvoice(where);
                return count;
            }
            
        }catch(Exception e){}
        return 0;
    }
    
    public static int dateDiff(Date start, Date end){
        CONResultSet dbrs = null;
        try{
            
            String sql = "select datediff('"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"','"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"')";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                int x = rs.getInt(1);
                return x;
            }
                    
        }catch(Exception e){}
        
        return 0;        
    }
    
    
    public static Vector invoice(String where){
        
        CONResultSet dbrs = null;
        try{
            String sql = "select sti.* from "+DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" sti inner join "+DbSalesData.DB_SALES_DATA+" sd on "+
                    " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID]+" = sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+
                    " where sd."+DbSalesData.colNames[DbSalesData.COL_STATUS]+" != "+DbSalesData.STATUS_CANCEL;
            
            if(where.length() > 0){
                sql = sql+" and "+where;
            }    
            
            sql = sql +" order by sd."+DbSalesData.colNames[DbSalesData.COL_NAME]+",sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER];
            Vector lists = new Vector();
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();
                resultToObject(rs, sewatanahinvoice);
                lists.add(sewatanahinvoice);
            }
            rs.close();
            return lists;
            
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return null;
    }
    
    
    public static Vector invoice(int limitStart, int recordToGet, String where){
        
        CONResultSet dbrs = null;
        try{
            String sql = "select sti.* from "+DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" sti inner join "+DbSalesData.DB_SALES_DATA+" sd on "+
                    " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID]+" = sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+
                    " where sd."+DbSalesData.colNames[DbSalesData.COL_STATUS]+" != "+DbSalesData.STATUS_CANCEL;
            
            if(where.length() > 0){
                sql = sql+" and "+where;
            }    
            
            sql = sql +" order by sd."+DbSalesData.colNames[DbSalesData.COL_NAME]+",sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER];
            
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            
            Vector lists = new Vector();
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();
                resultToObject(rs, sewatanahinvoice);
                lists.add(sewatanahinvoice);
            }
            rs.close();
            return lists;
            
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return null;
    }
    
    public static int countInvoice(String where){
        
        CONResultSet dbrs = null;
        try{
            String sql = "select count(sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]+") from "+DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" sti inner join "+DbSalesData.DB_SALES_DATA+" sd on "+
                    " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID]+" = sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+
                    " where sd."+DbSalesData.colNames[DbSalesData.COL_STATUS]+" != "+DbSalesData.STATUS_CANCEL;
            
            if(where.length() > 0){
                sql = sql+" and "+where;
            }    
            
            sql = sql +" order by sd."+DbSalesData.colNames[DbSalesData.COL_NAME]+",sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER];            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                int count = rs.getInt(1);
                return count;
            }
            rs.close();
            
            
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }        
        return 0;
    }
    
    
    public static Vector listRiviewInvoice(long employeeId,long customerId, int type, int salesType, int statusOverDue, int statusProses,Date startDate, Date endDate){
        Vector lists = new Vector();
        CONResultSet dbrs = null;        
        try{
            String sql = "select sti.* from "+DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" sti inner join "+DbSalesData.DB_SALES_DATA+" sd on "+
                    " sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SALES_DATA_ID]+" = sd."+DbSalesData.colNames[DbSalesData.COL_SALES_DATA_ID]+
                    " where sd."+DbSalesData.colNames[DbSalesData.COL_STATUS]+" != "+DbSalesData.STATUS_CANCEL +" and sti."+
                    DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN] + "=" + DbPembayaran.STATUS_BAYAR_OPEN;
                    
            String where = "";
            if(employeeId != 0) {               
                where = where + " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_USER_ID] + "=" + employeeId;
            }
            
            if (customerId != 0) {                
                where = where + " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + "=" + customerId;
            }
            
            if (type > 0 && statusOverDue == 0) {                
                //todays
                if (type == 1) {
                    where = where + " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + " = '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "'";
                } //this month
                else if (type == 2) {
                    Date dtNow = new Date();
                    dtNow.setDate(1);
                    Date nowEnd = (Date) dtNow.clone();
                    nowEnd.setDate(1);
                    nowEnd.setMonth(nowEnd.getMonth() + 1);
                    nowEnd.setDate(nowEnd.getDate() - 1);
                    where = where + " and ( sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + " >= '" + JSPFormater.formatDate(dtNow, "yyyy-MM-dd") + "'" +
                            " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + " <= '" + JSPFormater.formatDate(nowEnd, "yyyy-MM-dd") + "')";
                } //this periode
                else {
                    where = where + " and (sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + " >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                            " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + " <= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
                }
            }

            if (statusOverDue == 1) {
                where = where + " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + " < '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd") + "'";
            }
        
            if(statusProses == 1){
                where = where + " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_DIAKUI] + " != 0";
            }else{
                where = where + " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_DIAKUI] + " = 0";
            }
            
            if (salesType > 0) {
                //hard cash
                if (salesType == 1) {
                    where = where + " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE] + "=" + DbSalesData.TYPE_HARD_CASH;
                } //cash by term
                else if (salesType == 2) {
                    where = where + " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE] + "=" + DbSalesData.TYPE_CASH_BERJANGKA;
                } //kpa
                else {
                    where = where + " and sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_PAYMENT_TYPE] + "=" + DbSalesData.TYPE_KPA;
                }
            }            
            
            if(where != null && where.length() > 0){                
                sql = sql + where;
            }
            
            sql = sql + " order by sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID]+",sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_KETERANGAN];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                SewaTanahInvoice sewatanahinvoice = new SewaTanahInvoice();
                resultToObject(rs, sewatanahinvoice);
                lists.add(sewatanahinvoice);
            }
            rs.close();
            return lists;
        
        }catch(Exception e){
            System.out.println("exception"+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
}
