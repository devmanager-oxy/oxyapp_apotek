package com.project.crm.transaction;

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
import com.project.crm.master.irigasi.*;
import com.project.util.*;
import com.project.*;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.fms.master.*;
import com.project.fms.transaction.*;

public class DbIrigasiTransaction extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_IRIGASI_TRANSACTION = "crm_irigasi_transaction";
    public static final int COL_IRIGASI_TRANSACTION_ID = 0;
    public static final int COL_CUSTOMER_ID = 1;
    public static final int COL_MASTER_IRIGASI_ID = 2;
    public static final int COL_PERIOD_ID = 3;
    public static final int COL_BULAN_INI = 4;
    public static final int COL_BULAN_LALU = 5;
    public static final int COL_HARGA = 6;
    public static final int COL_POSTED_STATUS = 7;
    public static final int COL_KETERANGAN = 8;
    public static final int COL_TRANSACTION_NUMBER = 9;
    public static final int COL_NUMBER_COUNTER = 10;
    public static final int COL_TRANSACTION_DATE = 11;
    public static final int COL_NOMOR_FP = 12;
    public static final int COL_DUE_DATE = 13;
    public static final int COL_TOTAL_DENDA = 14;
    public static final int COL_STATUS_PEMBAYARAN = 15;
    public static final int COL_PPN = 16;
    public static final int COL_PPN_PERCENT = 17;
    public static final int COL_PPH = 18;
    public static final int COL_PPH_PERCENT = 19;
    public static final int COL_TOTAL_HARGA = 20;
    public static final int COL_DENDA_DIAKUI = 21;
    public static final int COL_DENDA_APPROVE_ID = 22;
    public static final int COL_DENDA_APPROVE_DATE = 23;
    public static final int COL_DENDA_KETERANGAN = 24;
    public static final int COL_DENDA_POST_STATUS = 25;
    public static final int COL_DENDA_CLIENT_NAME = 26;
    public static final int COL_DENDA_CLIENT_POSITION = 27;
    
    public static final String[] colNames = {
        "irigasi_transaction_id",
        "customer_id",
        "master_irigasi_id",
        "period_id",
        "bulan_ini",
        "bulan_lalu",
        "harga",
        "posted_status",
        "keterangan",
        "transaction_number",
        "number_counter",
        "transaction_date",
        "nomor_fp",
        "jatuh_tempo",
        "total_denda",
        "status_pembayaran",
        "ppn",
        "ppn_percent",
        "pph",
        "pph_percent",
        "total_harga",
        "denda_diakui",
        "denda_approve_id",
        "denda_approve_date",
        "denda_keterangan",
        "denda_post_status",
        "denda_client_name",
        "denda_client_position"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING
    };
    
    public static final int UNPOSTED = 0;
    public static final int POSTED = 1;
    public static final String[] Posted_sts_key = {"DRAFT", "POSTED"};
    public static final int[] Posted_sts_value = {0, 1};
    
    public static final int STATUS_DENDA_DRAFT = 0;
    public static final int STATUS_DENDA_POSTED = 1;
    
    public static final String[] Posted_sts_denda_key = {"DRAFT", "POSTED"};
    public static final int[] Posted_sts_denda_value = {0, 1};

    public DbIrigasiTransaction() {
    }

    public DbIrigasiTransaction(int i) throws CONException {
        super(new DbIrigasiTransaction());
    }

    public DbIrigasiTransaction(String sOid) throws CONException {
        super(new DbIrigasiTransaction(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbIrigasiTransaction(long lOid) throws CONException {
        super(new DbIrigasiTransaction(0));
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
        return DB_IRIGASI_TRANSACTION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbIrigasiTransaction().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        IrigasiTransaction irigasitransaction = fetchExc(ent.getOID());
        ent = (Entity) irigasitransaction;
        return irigasitransaction.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((IrigasiTransaction) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((IrigasiTransaction) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static IrigasiTransaction fetchExc(long oid) throws CONException {
        try {
            IrigasiTransaction irigasitransaction = new IrigasiTransaction();
            DbIrigasiTransaction pstIrigasiTransaction = new DbIrigasiTransaction(oid);
            irigasitransaction.setOID(oid);

            irigasitransaction.setCustumerId(pstIrigasiTransaction.getlong(COL_CUSTOMER_ID));
            irigasitransaction.setMasterIrigasiId(pstIrigasiTransaction.getlong(COL_MASTER_IRIGASI_ID));
            irigasitransaction.setPeriodId(pstIrigasiTransaction.getlong(COL_PERIOD_ID));
            irigasitransaction.setBulanIni(pstIrigasiTransaction.getdouble(COL_BULAN_INI));
            irigasitransaction.setBulanLalu(pstIrigasiTransaction.getdouble(COL_BULAN_LALU));
            irigasitransaction.setHarga(pstIrigasiTransaction.getdouble(COL_HARGA));
            irigasitransaction.setPostStatus(pstIrigasiTransaction.getInt(COL_POSTED_STATUS));
            irigasitransaction.setKeterangan(pstIrigasiTransaction.getString(COL_KETERANGAN));
            irigasitransaction.setInvoiceNumber(pstIrigasiTransaction.getString(COL_TRANSACTION_NUMBER));
            irigasitransaction.setInvoiceNumberCounter(pstIrigasiTransaction.getInt(COL_NUMBER_COUNTER));
            irigasitransaction.setTransactionDate(pstIrigasiTransaction.getDate(COL_TRANSACTION_DATE));
            irigasitransaction.setNomorFp(pstIrigasiTransaction.getString(COL_NOMOR_FP));
            irigasitransaction.setDueDate(pstIrigasiTransaction.getDate(COL_DUE_DATE));

            irigasitransaction.setTotalDenda(pstIrigasiTransaction.getdouble(COL_TOTAL_DENDA));
            irigasitransaction.setStatusPembayaran(pstIrigasiTransaction.getInt(COL_STATUS_PEMBAYARAN));

            irigasitransaction.setPpn(pstIrigasiTransaction.getdouble(COL_PPN));
            irigasitransaction.setPpnPercent(pstIrigasiTransaction.getdouble(COL_PPN_PERCENT));
            irigasitransaction.setPph(pstIrigasiTransaction.getdouble(COL_PPH));
            irigasitransaction.setPphPercent(pstIrigasiTransaction.getdouble(COL_PPH_PERCENT));
            irigasitransaction.setTotalHarga(pstIrigasiTransaction.getdouble(COL_TOTAL_HARGA));

            irigasitransaction.setDendaDiakui(pstIrigasiTransaction.getdouble(COL_DENDA_DIAKUI));
            irigasitransaction.setDendaApproveId(pstIrigasiTransaction.getlong(COL_DENDA_APPROVE_ID));
            irigasitransaction.setDendaApproveDate(pstIrigasiTransaction.getDate(COL_DENDA_APPROVE_DATE));
            irigasitransaction.setDendaKeterangan(pstIrigasiTransaction.getString(COL_DENDA_KETERANGAN));
            irigasitransaction.setDendaPostStatus(pstIrigasiTransaction.getInt(COL_DENDA_POST_STATUS));
            irigasitransaction.setDendaClientName(pstIrigasiTransaction.getString(COL_DENDA_CLIENT_NAME));
            irigasitransaction.setDendaClientPosition(pstIrigasiTransaction.getString(COL_DENDA_CLIENT_POSITION));

            return irigasitransaction;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbIrigasiTransaction(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(IrigasiTransaction irigasitransaction) throws CONException {
        try {
            DbIrigasiTransaction pstIrigasiTransaction = new DbIrigasiTransaction(0);

            pstIrigasiTransaction.setLong(COL_CUSTOMER_ID, irigasitransaction.getCustumerId());
            pstIrigasiTransaction.setLong(COL_MASTER_IRIGASI_ID, irigasitransaction.getMasterIrigasiId());
            pstIrigasiTransaction.setLong(COL_PERIOD_ID, irigasitransaction.getPeriodId());
            pstIrigasiTransaction.setDouble(COL_BULAN_INI, irigasitransaction.getBulanIni());
            pstIrigasiTransaction.setDouble(COL_BULAN_LALU, irigasitransaction.getBulanLalu());
            pstIrigasiTransaction.setDouble(COL_HARGA, irigasitransaction.getHarga());
            pstIrigasiTransaction.setInt(COL_POSTED_STATUS, irigasitransaction.getPostStatus());
            pstIrigasiTransaction.setString(COL_KETERANGAN, irigasitransaction.getKeterangan());
            pstIrigasiTransaction.setString(COL_TRANSACTION_NUMBER, irigasitransaction.getInvoiceNumber());
            pstIrigasiTransaction.setInt(COL_NUMBER_COUNTER, irigasitransaction.getInvoiceNumberCounter());
            pstIrigasiTransaction.setDate(COL_TRANSACTION_DATE, irigasitransaction.getTransactionDate());
            pstIrigasiTransaction.setString(COL_NOMOR_FP, irigasitransaction.getNomorFp());
            pstIrigasiTransaction.setDate(COL_DUE_DATE, irigasitransaction.getDueDate());

            pstIrigasiTransaction.setDouble(COL_TOTAL_DENDA, irigasitransaction.getTotalDenda());
            pstIrigasiTransaction.setInt(COL_STATUS_PEMBAYARAN, irigasitransaction.getStatusPembayaran());

            pstIrigasiTransaction.setDouble(COL_PPN, irigasitransaction.getPpn());
            pstIrigasiTransaction.setDouble(COL_PPN_PERCENT, irigasitransaction.getPpnPercent());
            pstIrigasiTransaction.setDouble(COL_PPH, irigasitransaction.getPph());
            pstIrigasiTransaction.setDouble(COL_PPH_PERCENT, irigasitransaction.getPphPercent());
            pstIrigasiTransaction.setDouble(COL_TOTAL_HARGA, irigasitransaction.getTotalHarga());

            pstIrigasiTransaction.setDouble(COL_DENDA_DIAKUI, irigasitransaction.getDendaDiakui());
            pstIrigasiTransaction.setLong(COL_DENDA_APPROVE_ID, irigasitransaction.getDendaApproveId());
            pstIrigasiTransaction.setDate(COL_DENDA_APPROVE_DATE, irigasitransaction.getDendaApproveDate());
            pstIrigasiTransaction.setString(COL_DENDA_KETERANGAN, irigasitransaction.getDendaKeterangan());
            pstIrigasiTransaction.setInt(COL_DENDA_POST_STATUS, irigasitransaction.getDendaPostStatus());
            pstIrigasiTransaction.setString(COL_DENDA_CLIENT_NAME, irigasitransaction.getDendaClientName());
            pstIrigasiTransaction.setString(COL_DENDA_CLIENT_POSITION, irigasitransaction.getDendaClientPosition());

            pstIrigasiTransaction.insert();
            irigasitransaction.setOID(pstIrigasiTransaction.getlong(COL_IRIGASI_TRANSACTION_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbIrigasiTransaction(0), CONException.UNKNOWN);
        }
        return irigasitransaction.getOID();
    }

    public static long updateExc(IrigasiTransaction irigasitransaction) throws CONException {
        try {
            if (irigasitransaction.getOID() != 0) {
                DbIrigasiTransaction pstIrigasiTransaction = new DbIrigasiTransaction(irigasitransaction.getOID());

                pstIrigasiTransaction.setLong(COL_CUSTOMER_ID, irigasitransaction.getCustumerId());
                pstIrigasiTransaction.setLong(COL_MASTER_IRIGASI_ID, irigasitransaction.getMasterIrigasiId());
                pstIrigasiTransaction.setLong(COL_PERIOD_ID, irigasitransaction.getPeriodId());
                pstIrigasiTransaction.setDouble(COL_BULAN_INI, irigasitransaction.getBulanIni());
                pstIrigasiTransaction.setDouble(COL_BULAN_LALU, irigasitransaction.getBulanLalu());
                pstIrigasiTransaction.setDouble(COL_HARGA, irigasitransaction.getHarga());
                pstIrigasiTransaction.setInt(COL_POSTED_STATUS, irigasitransaction.getPostStatus());
                pstIrigasiTransaction.setString(COL_KETERANGAN, irigasitransaction.getKeterangan());

                pstIrigasiTransaction.setString(COL_TRANSACTION_NUMBER, irigasitransaction.getInvoiceNumber());
                pstIrigasiTransaction.setInt(COL_NUMBER_COUNTER, irigasitransaction.getInvoiceNumberCounter());
                pstIrigasiTransaction.setDate(COL_TRANSACTION_DATE, irigasitransaction.getTransactionDate());
                pstIrigasiTransaction.setString(COL_NOMOR_FP, irigasitransaction.getNomorFp());
                pstIrigasiTransaction.setDate(COL_DUE_DATE, irigasitransaction.getDueDate());

                pstIrigasiTransaction.setDouble(COL_TOTAL_DENDA, irigasitransaction.getTotalDenda());
                pstIrigasiTransaction.setInt(COL_STATUS_PEMBAYARAN, irigasitransaction.getStatusPembayaran());

                pstIrigasiTransaction.setDouble(COL_PPN, irigasitransaction.getPpn());
                pstIrigasiTransaction.setDouble(COL_PPN_PERCENT, irigasitransaction.getPpnPercent());
                pstIrigasiTransaction.setDouble(COL_PPH, irigasitransaction.getPph());
                pstIrigasiTransaction.setDouble(COL_PPH_PERCENT, irigasitransaction.getPphPercent());
                pstIrigasiTransaction.setDouble(COL_TOTAL_HARGA, irigasitransaction.getTotalHarga());

                pstIrigasiTransaction.setDouble(COL_DENDA_DIAKUI, irigasitransaction.getDendaDiakui());
                pstIrigasiTransaction.setLong(COL_DENDA_APPROVE_ID, irigasitransaction.getDendaApproveId());
                pstIrigasiTransaction.setDate(COL_DENDA_APPROVE_DATE, irigasitransaction.getDendaApproveDate());
                pstIrigasiTransaction.setString(COL_DENDA_KETERANGAN, irigasitransaction.getDendaKeterangan());
                pstIrigasiTransaction.setInt(COL_DENDA_POST_STATUS, irigasitransaction.getDendaPostStatus());
                pstIrigasiTransaction.setString(COL_DENDA_CLIENT_NAME, irigasitransaction.getDendaClientName());
                pstIrigasiTransaction.setString(COL_DENDA_CLIENT_POSITION, irigasitransaction.getDendaClientPosition());

                pstIrigasiTransaction.update();
                return irigasitransaction.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbIrigasiTransaction(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbIrigasiTransaction pstIrigasiTransaction = new DbIrigasiTransaction(oid);
            pstIrigasiTransaction.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbIrigasiTransaction(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_IRIGASI_TRANSACTION;
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
                IrigasiTransaction irigasitransaction = new IrigasiTransaction();
                resultToObject(rs, irigasitransaction);
                lists.add(irigasitransaction);
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

    private static void resultToObject(ResultSet rs, IrigasiTransaction irigasitransaction) {
        try {
            irigasitransaction.setOID(rs.getLong(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_IRIGASI_TRANSACTION_ID]));
            irigasitransaction.setCustumerId(rs.getLong(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_CUSTOMER_ID]));
            irigasitransaction.setMasterIrigasiId(rs.getLong(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_MASTER_IRIGASI_ID]));
            irigasitransaction.setPeriodId(rs.getLong(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PERIOD_ID]));
            irigasitransaction.setBulanIni(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_INI]));
            irigasitransaction.setBulanLalu(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_BULAN_LALU]));
            irigasitransaction.setHarga(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_HARGA]));
            irigasitransaction.setPostStatus(rs.getInt(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_POSTED_STATUS]));
            irigasitransaction.setKeterangan(rs.getString(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_KETERANGAN]));

            irigasitransaction.setInvoiceNumber(rs.getString(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TRANSACTION_NUMBER]));
            irigasitransaction.setInvoiceNumberCounter(rs.getInt(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_NUMBER_COUNTER]));
            irigasitransaction.setTransactionDate(rs.getDate(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TRANSACTION_DATE]));
            irigasitransaction.setNomorFp(rs.getString(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_NOMOR_FP]));
            irigasitransaction.setDueDate(rs.getDate(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DUE_DATE]));

            irigasitransaction.setTotalDenda(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TOTAL_DENDA]));
            irigasitransaction.setStatusPembayaran(rs.getInt(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_STATUS_PEMBAYARAN]));

            irigasitransaction.setPpn(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PPN]));
            irigasitransaction.setPpnPercent(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PPN_PERCENT]));
            irigasitransaction.setPph(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PPH]));
            irigasitransaction.setPphPercent(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_PPH_PERCENT]));
            irigasitransaction.setTotalHarga(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_TOTAL_HARGA]));

            irigasitransaction.setDendaDiakui(rs.getDouble(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DENDA_DIAKUI]));
            irigasitransaction.setDendaApproveId(rs.getLong(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DENDA_APPROVE_ID]));
            irigasitransaction.setDendaApproveDate(rs.getDate(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DENDA_APPROVE_DATE]));
            irigasitransaction.setDendaKeterangan(rs.getString(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DENDA_KETERANGAN]));
            irigasitransaction.setDendaPostStatus(rs.getInt(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DENDA_POST_STATUS]));
            irigasitransaction.setDendaClientName(rs.getString(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DENDA_CLIENT_NAME]));
            irigasitransaction.setDendaClientPosition(rs.getString(DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DENDA_CLIENT_POSITION]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long transaksiIrigasiId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_IRIGASI_TRANSACTION + " WHERE " +
                    DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_IRIGASI_TRANSACTION_ID] + " = " + transaksiIrigasiId;

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
            String sql = "SELECT COUNT(" + DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_IRIGASI_TRANSACTION_ID] + ") FROM " + DB_IRIGASI_TRANSACTION;
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
                    IrigasiTransaction irigasitransaction = (IrigasiTransaction) list.get(ls);
                    if (oid == irigasitransaction.getOID()) {
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
     * Posting transaksi Irigasi ke GL
     * update by gwawan 201209
     * @param irigasiTransaction
     * @param periodId
     * @param postingDate
     * @param userId
     * @return
     */
    public static boolean postJournal(IrigasiTransaction irigasiTransaction, long periodId, Date postingDate, long userId) {
        try {
            Company company = DbCompany.getCompany();
            Customer customer = DbCustomer.fetchExc(irigasiTransaction.getCustumerId());
            Irigasi irigasi = DbIrigasi.fetchExc(irigasiTransaction.getMasterIrigasiId());
            Periode periode = DbPeriode.fetchExc(periodId);
            User user = DbUser.fetch(userId);

            //cek jika akun perkiraan setiap sarana belum terisi
            if (customer.getType() == DbCustomer.CUSTOMER_TYPE_COMMON_AREA) {
                //if (customer.getOID() == 0 || customer.getIrigasiFlag() == 0 || customer.getIrigasiDebetAccountId() == 0 || customer.getIrigasiCreditAccountId() == 0) {
                //    return false;
                //}
            } else {
                //if (customer.getOID() == 0 || customer.getIrigasiFlag() == 0 || customer.getIrigasiDebetAccountId() == 0 || customer.getIrigasiCreditAccountId() == 0 || customer.getIrigasiPpnAccauntId() == 0) {
                //    return false;
                //}
            }

            String memo = customer.getName() + " - Tagihan irigasi, invoice : " + irigasiTransaction.getInvoiceNumber() +
                    ", tanggal : " + JSPFormater.formatDate(irigasiTransaction.getTransactionDate(), "dd/MM/yyyy");

            //jika sarana mamakai irigasi	                           
            if (irigasiTransaction.getOID() != 0) {
                //Insert GL
                String prefixGl = DbSystemDocNumber.getNumberPrefixGl(periode.getOID());
                int counterGl = DbSystemDocNumber.getNextCounterGl(periode.getOID());
                String strNumber = DbSystemDocNumber.getNextNumberGl(counterGl, periode.getOID());

                Gl gl = new Gl();
                gl.setPeriodId(periode.getOID());
                gl.setCurrencyId(0);
                gl.setDate(new Date());
                gl.setTransDate(postingDate);
                gl.setJournalCounter(counterGl);
                gl.setJournalNumber(strNumber);
                gl.setJournalPrefix(prefixGl);
                gl.setOperatorId(user.getOID());
                gl.setOperatorName(user.getFullName());
                gl.setJournalType(I_Project.JOURNAL_TYPE_INVOICE);
                gl.setOwnerId(irigasiTransaction.getOID());
                gl.setRefNumber(irigasiTransaction.getInvoiceNumber());
                gl.setMemo(memo);
                gl.setPostedById(user.getOID());
                gl.setPostedDate(postingDate);
                gl.setPostedStatus(POSTED);
                long oidGl = DbGl.insertExc(gl);

                if (oidGl != 0) {
                    //save GL number into doc number logger
                    SystemDocNumber systemDocNumber = new SystemDocNumber();
                    systemDocNumber.setCounter(gl.getJournalCounter());
                    systemDocNumber.setPrefixNumber(gl.getJournalPrefix());
                    systemDocNumber.setDocNumber(gl.getJournalNumber());
                    systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_GL]);
                    systemDocNumber.setDate(new Date());
                    systemDocNumber.setYear(gl.getTransDate().getYear() + 1900);
                    DbSystemDocNumber.insertExc(systemDocNumber);

                    //insert GL detail
                    double pendapatan = (irigasiTransaction.getBulanIni() - irigasiTransaction.getBulanLalu()) * irigasiTransaction.getHarga();
                    double ppn = 0;
                    if (customer.getType() == DbCustomer.CUSTOMER_TYPE_REGULAR) {
                        ppn = (irigasiTransaction.getBulanIni() - irigasiTransaction.getBulanLalu()) * irigasiTransaction.getHarga() * (irigasi.getPpnPercent() / 100);
                    }
                    double piutang = pendapatan + ppn;

                    //journal debet piutang
                    /*DbGl.postJournalDetail(1, customer.getIrigasiDebetAccountId(), 0, piutang, piutang,
                            company.getBookingCurrencyId(), oidGl, memo, 0);//non departmenttal item, department id = 0

                    //jurnal credit income
                    DbGl.postJournalDetail(1, customer.getIrigasiCreditAccountId(), pendapatan, 0, pendapatan,
                            company.getBookingCurrencyId(), oidGl, memo, 0);//non departmenttal item, department id = 0

                    //journal credit ppn
                    if (customer.getType() == DbCustomer.CUSTOMER_TYPE_REGULAR) {
                        DbGl.postJournalDetail(1, customer.getIrigasiPpnAccauntId(), ppn, 0, ppn,
                                company.getBookingCurrencyId(), oidGl, memo, 0);//non departmenttal item, department id = 0
                    }*/
                } else {
                    return false;
                }
            } else {
                return false;
            }
            
            return true;
        } catch (Exception e) {
            System.out.println(e.toString());
            return false;
        }
    }
    
    
    //POSTING ke journal - pembalikan pihutang/pembayaran
    public static boolean postJournalDenda(IrigasiTransaction irigasiTransaction){

        boolean ok = true;
        Company company = DbCompany.getCompany();
        Customer customer = new Customer();

        try {
            customer = DbCustomer.fetchExc(irigasiTransaction.getCustumerId());
        } catch (Exception e) {
        }
        
       /* if(customer.getOID() == 0 || customer.getPendapatanTerimaDiMukaAccountId() == 0 || customer.getIrigasiCreditAccountId()==0){
            return false;
        }*/

        String memo = customer.getName() + " - Denda irigasi, invoice : " + irigasiTransaction.getInvoiceNumber() +
                "D, tanggal : " + JSPFormater.formatDate(irigasiTransaction.getTransactionDate(), "dd/MM/yyyy");

        //jika sarana mamakai irigasi	                           
        //if (irigasiTransaction.getOID() != 0 && customer.getIrigasiFlag() == 1){
            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, 
            //int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), irigasiTransaction.getInvoiceNumberCounter(), irigasiTransaction.getInvoiceNumber()+"D", irigasiTransaction.getInvoiceNumber()+"D",
                    I_Project.JOURNAL_TYPE_INVOICE,
                    memo, 0, "", irigasiTransaction.getOID(), "", irigasiTransaction.getTransactionDate());

            //pengakuan piutang
            if (oid != 0) {

                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                double harga = irigasiTransaction.getDendaDiakui();
                
                //journal debet
                /*DbGl.postJournalDetail(1, customer.getPendapatanTerimaDiMukaAccountId(), 0, harga,
                        harga, company.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                
                //jurnal credit
                DbGl.postJournalDetail(1, customer.getIrigasiCreditAccountId(), harga, 0,
                        harga, company.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                */        
                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);
            } else {
                ok = false;
            }
        //} else {
        //    ok = false;
        //}
        return ok;
    }
}
