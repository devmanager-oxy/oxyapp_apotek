package com.project.crm.transaction;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.*;
import com.project.fms.master.*;
import com.project.fms.transaction.*;
import com.project.util.*;
import com.project.crm.master.limbah.*;
import com.project.*;
import com.project.admin.DbUser;
import com.project.admin.User;

public class DbLimbahTransaction extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_LIMBAH_TRASACTION = "crm_limbah_transaction";
    public static final int COL_LIMBAH_TRANSACTION_ID = 0;
    public static final int COL_CUSTOMER_ID = 1;
    public static final int COL_MASTER_LIMBAH_ID = 2;
    public static final int COL_PERIOD_ID = 3;
    public static final int COL_BULAN_INI = 4;
    public static final int COL_BULAN_LALU = 5;
    public static final int COL_PERCENTAGE_USED = 6;
    public static final int COL_HARGA = 7;
    public static final int COL_POSTED_STATUS = 8;
    public static final int COL_KETERANGAN = 9;
    public static final int COL_TRANSACTION_NUMBER = 10;
    public static final int COL_NUMBER_COUNTER = 11;
    public static final int COL_TRANSACTION_DATE = 12;
    public static final int COL_NOMOR_FP = 13;
    public static final int COL_DUE_DATE = 14;
    public static final int COL_TOTAL_DENDA = 15;
    public static final int COL_STATUS_PEMBAYARAN = 16;
    public static final int COL_PPN = 17;
    public static final int COL_PPN_PERCENT = 18;
    public static final int COL_PPH = 19;
    public static final int COL_PPH_PERCENT = 20;
    public static final int COL_TOTAL_HARGA = 21;
    public static final int COL_DENDA_DIAKUI = 22;
    public static final int COL_DENDA_APPROVE_ID = 23;
    public static final int COL_DENDA_APPROVE_DATE = 24;
    public static final int COL_DENDA_KETERANGAN = 25;
    public static final int COL_DENDA_POST_STATUS = 26;
    public static final int COL_DENDA_CLIENT_NAME = 27;
    public static final int COL_DENDA_CLIENT_POSITION = 28;
    public static final String[] colNames = {
        "limbah_transaction_id",
        "customer_id",
        "master_limbah_id",
        "period_id",
        "bulan_ini",
        "bulan_lalu",
        "percentage_used",
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
        TYPE_FLOAT,
        TYPE_INT,
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

    public DbLimbahTransaction() {
    }

    public DbLimbahTransaction(int i) throws CONException {
        super(new DbLimbahTransaction());
    }

    public DbLimbahTransaction(String sOid) throws CONException {
        super(new DbLimbahTransaction(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLimbahTransaction(long lOid) throws CONException {
        super(new DbLimbahTransaction(0));
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
        return DB_LIMBAH_TRASACTION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLimbahTransaction().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LimbahTransaction dblimbahTransaction = fetchExc(ent.getOID());


        ent = (Entity) dblimbahTransaction;
        return dblimbahTransaction.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LimbahTransaction) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LimbahTransaction) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static LimbahTransaction fetchExc(long oid) throws CONException {
        try {
            LimbahTransaction limbahTransaction = new LimbahTransaction();

            DbLimbahTransaction dblimbahTransaction = new DbLimbahTransaction(oid);
            limbahTransaction.setOID(oid);

            limbahTransaction.setCustomerId(dblimbahTransaction.getlong(COL_CUSTOMER_ID));
            limbahTransaction.setMasterLimbahId(dblimbahTransaction.getlong(COL_MASTER_LIMBAH_ID));
            limbahTransaction.setPeriodId(dblimbahTransaction.getlong(COL_PERIOD_ID));
            limbahTransaction.setBulanIni(dblimbahTransaction.getdouble(COL_BULAN_INI));
            limbahTransaction.setBulanLalu(dblimbahTransaction.getdouble(COL_BULAN_LALU));
            limbahTransaction.setPercentageUsed(dblimbahTransaction.getdouble(COL_PERCENTAGE_USED));
            limbahTransaction.setHarga(dblimbahTransaction.getdouble(COL_HARGA));
            limbahTransaction.setPostedStatus(dblimbahTransaction.getInt(COL_POSTED_STATUS));
            limbahTransaction.setKeterangan(dblimbahTransaction.getString(COL_KETERANGAN));

            limbahTransaction.setInvoiceNumber(dblimbahTransaction.getString(COL_TRANSACTION_NUMBER));
            limbahTransaction.setInvoiceNumberCounter(dblimbahTransaction.getInt(COL_NUMBER_COUNTER));
            limbahTransaction.setTransactionDate(dblimbahTransaction.getDate(COL_TRANSACTION_DATE));
            limbahTransaction.setNomorFp(dblimbahTransaction.getString(COL_NOMOR_FP));
            limbahTransaction.setDueDate(dblimbahTransaction.getDate(COL_DUE_DATE));

            limbahTransaction.setTotalDenda(dblimbahTransaction.getdouble(COL_TOTAL_DENDA));
            limbahTransaction.setStatusPembayaran(dblimbahTransaction.getInt(COL_STATUS_PEMBAYARAN));

            limbahTransaction.setPpn(dblimbahTransaction.getdouble(COL_PPN));
            limbahTransaction.setPpnPercent(dblimbahTransaction.getdouble(COL_PPN_PERCENT));
            limbahTransaction.setPph(dblimbahTransaction.getdouble(COL_PPH));
            limbahTransaction.setPphPercent(dblimbahTransaction.getdouble(COL_PPH_PERCENT));
            limbahTransaction.setTotalHarga(dblimbahTransaction.getdouble(COL_TOTAL_HARGA));

            limbahTransaction.setDendaDiakui(dblimbahTransaction.getdouble(COL_DENDA_DIAKUI));
            limbahTransaction.setDendaApproveId(dblimbahTransaction.getlong(COL_DENDA_APPROVE_ID));
            limbahTransaction.setDendaApproveDate(dblimbahTransaction.getDate(COL_DENDA_APPROVE_DATE));
            limbahTransaction.setDendaKeterangan(dblimbahTransaction.getString(COL_DENDA_KETERANGAN));
            limbahTransaction.setDendaPostStatus(dblimbahTransaction.getInt(COL_DENDA_POST_STATUS));
            limbahTransaction.setDendaClientName(dblimbahTransaction.getString(COL_DENDA_CLIENT_NAME));
            limbahTransaction.setDendaClientPosition(dblimbahTransaction.getString(COL_DENDA_CLIENT_POSITION));

            return limbahTransaction;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLimbahTransaction(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LimbahTransaction limbahTransaction) throws CONException {
        try {
            DbLimbahTransaction dblimbahTransaction = new DbLimbahTransaction(0);

            dblimbahTransaction.setLong(COL_CUSTOMER_ID, limbahTransaction.getCustomerId());
            dblimbahTransaction.setLong(COL_MASTER_LIMBAH_ID, limbahTransaction.getMasterLimbahId());
            dblimbahTransaction.setLong(COL_PERIOD_ID, limbahTransaction.getPeriodId());
            dblimbahTransaction.setDouble(COL_BULAN_INI, limbahTransaction.getBulanIni());
            dblimbahTransaction.setDouble(COL_BULAN_LALU, limbahTransaction.getBulanLalu());
            dblimbahTransaction.setDouble(COL_PERCENTAGE_USED, limbahTransaction.getPercentageUsed());
            dblimbahTransaction.setDouble(COL_HARGA, limbahTransaction.getHarga());
            dblimbahTransaction.setInt(COL_POSTED_STATUS, limbahTransaction.getPostedStatus());
            dblimbahTransaction.setString(COL_KETERANGAN, limbahTransaction.getKeterangan());

            dblimbahTransaction.setString(COL_TRANSACTION_NUMBER, limbahTransaction.getInvoiceNumber());
            dblimbahTransaction.setInt(COL_NUMBER_COUNTER, limbahTransaction.getInvoiceNumberCounter());
            dblimbahTransaction.setDate(COL_TRANSACTION_DATE, limbahTransaction.getTransactionDate());
            dblimbahTransaction.setString(COL_NOMOR_FP, limbahTransaction.getNomorFp());
            dblimbahTransaction.setDate(COL_DUE_DATE, limbahTransaction.getDueDate());

            dblimbahTransaction.setDouble(COL_TOTAL_DENDA, limbahTransaction.getTotalDenda());
            dblimbahTransaction.setInt(COL_STATUS_PEMBAYARAN, limbahTransaction.getStatusPembayaran());

            dblimbahTransaction.setDouble(COL_PPN, limbahTransaction.getPpn());
            dblimbahTransaction.setDouble(COL_PPN_PERCENT, limbahTransaction.getPpnPercent());
            dblimbahTransaction.setDouble(COL_PPH, limbahTransaction.getPph());
            dblimbahTransaction.setDouble(COL_PPH_PERCENT, limbahTransaction.getPphPercent());
            dblimbahTransaction.setDouble(COL_TOTAL_HARGA, limbahTransaction.getTotalHarga());

            dblimbahTransaction.setDouble(COL_DENDA_DIAKUI, limbahTransaction.getDendaDiakui());
            dblimbahTransaction.setLong(COL_DENDA_APPROVE_ID, limbahTransaction.getDendaApproveId());
            dblimbahTransaction.setDate(COL_DENDA_APPROVE_DATE, limbahTransaction.getDendaApproveDate());
            dblimbahTransaction.setString(COL_DENDA_KETERANGAN, limbahTransaction.getDendaKeterangan());
            dblimbahTransaction.setInt(COL_DENDA_POST_STATUS, limbahTransaction.getDendaPostStatus());
            dblimbahTransaction.setString(COL_DENDA_CLIENT_NAME, limbahTransaction.getDendaClientName());
            dblimbahTransaction.setString(COL_DENDA_CLIENT_POSITION, limbahTransaction.getDendaClientPosition());

            dblimbahTransaction.insert();
            limbahTransaction.setOID(dblimbahTransaction.getlong(COL_CUSTOMER_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomer(0), CONException.UNKNOWN);
        }
        return limbahTransaction.getOID();
    }

    public static long updateExc(LimbahTransaction limbahTransaction) throws CONException {
        try {
            if (limbahTransaction.getOID() != 0) {

                DbLimbahTransaction dblimbahTransaction = new DbLimbahTransaction(limbahTransaction.getOID());

                dblimbahTransaction.setLong(COL_CUSTOMER_ID, limbahTransaction.getCustomerId());
                dblimbahTransaction.setLong(COL_MASTER_LIMBAH_ID, limbahTransaction.getMasterLimbahId());
                dblimbahTransaction.setLong(COL_PERIOD_ID, limbahTransaction.getPeriodId());
                dblimbahTransaction.setFloat(COL_BULAN_INI, limbahTransaction.getBulanIni());
                dblimbahTransaction.setFloat(COL_BULAN_LALU, limbahTransaction.getBulanLalu());
                dblimbahTransaction.setFloat(COL_PERCENTAGE_USED, limbahTransaction.getPercentageUsed());
                dblimbahTransaction.setFloat(COL_HARGA, limbahTransaction.getHarga());
                dblimbahTransaction.setInt(COL_POSTED_STATUS, limbahTransaction.getPostedStatus());
                dblimbahTransaction.setString(COL_KETERANGAN, limbahTransaction.getKeterangan());

                dblimbahTransaction.setString(COL_TRANSACTION_NUMBER, limbahTransaction.getInvoiceNumber());
                dblimbahTransaction.setInt(COL_NUMBER_COUNTER, limbahTransaction.getInvoiceNumberCounter());
                dblimbahTransaction.setDate(COL_TRANSACTION_DATE, limbahTransaction.getTransactionDate());
                dblimbahTransaction.setString(COL_NOMOR_FP, limbahTransaction.getNomorFp());
                dblimbahTransaction.setDate(COL_DUE_DATE, limbahTransaction.getDueDate());

                dblimbahTransaction.setDouble(COL_TOTAL_DENDA, limbahTransaction.getTotalDenda());
                dblimbahTransaction.setInt(COL_STATUS_PEMBAYARAN, limbahTransaction.getStatusPembayaran());

                dblimbahTransaction.setDouble(COL_PPN, limbahTransaction.getPpn());
                dblimbahTransaction.setDouble(COL_PPN_PERCENT, limbahTransaction.getPpnPercent());
                dblimbahTransaction.setDouble(COL_PPH, limbahTransaction.getPph());
                dblimbahTransaction.setDouble(COL_PPH_PERCENT, limbahTransaction.getPphPercent());
                dblimbahTransaction.setDouble(COL_TOTAL_HARGA, limbahTransaction.getTotalHarga());

                dblimbahTransaction.setDouble(COL_DENDA_DIAKUI, limbahTransaction.getDendaDiakui());
                dblimbahTransaction.setLong(COL_DENDA_APPROVE_ID, limbahTransaction.getDendaApproveId());
                dblimbahTransaction.setDate(COL_DENDA_APPROVE_DATE, limbahTransaction.getDendaApproveDate());
                dblimbahTransaction.setString(COL_DENDA_KETERANGAN, limbahTransaction.getDendaKeterangan());
                dblimbahTransaction.setInt(COL_DENDA_POST_STATUS, limbahTransaction.getDendaPostStatus());
                dblimbahTransaction.setString(COL_DENDA_CLIENT_NAME, limbahTransaction.getDendaClientName());
                dblimbahTransaction.setString(COL_DENDA_CLIENT_POSITION, limbahTransaction.getDendaClientPosition());

                dblimbahTransaction.update();
                return limbahTransaction.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomer(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLimbahTransaction dbdblimbahTransaction = new DbLimbahTransaction(oid);
            dbdblimbahTransaction.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLimbahTransaction(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LIMBAH_TRASACTION;
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
                LimbahTransaction dblimbahTransaction = new LimbahTransaction();
                resultToObject(rs, dblimbahTransaction);
                lists.add(dblimbahTransaction);
            }
        //rs.close();
        //return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return lists;

    //return new Vector();
    }

    private static void resultToObject(ResultSet rs, LimbahTransaction limbahTransaction) {
        try {
            limbahTransaction.setOID(rs.getLong(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_LIMBAH_TRANSACTION_ID]));
            limbahTransaction.setCustomerId(rs.getLong(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_CUSTOMER_ID]));
            limbahTransaction.setMasterLimbahId(rs.getLong(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_MASTER_LIMBAH_ID]));
            limbahTransaction.setPeriodId(rs.getLong(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERIOD_ID]));
            limbahTransaction.setBulanIni(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_INI]));
            limbahTransaction.setBulanLalu(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_BULAN_LALU]));
            limbahTransaction.setPercentageUsed(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PERCENTAGE_USED]));
            limbahTransaction.setHarga(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_HARGA]));
            limbahTransaction.setPostedStatus(rs.getInt(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_POSTED_STATUS]));
            limbahTransaction.setKeterangan(rs.getString(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_KETERANGAN]));

            limbahTransaction.setInvoiceNumber(rs.getString(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TRANSACTION_NUMBER]));
            limbahTransaction.setInvoiceNumberCounter(rs.getInt(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_NUMBER_COUNTER]));
            limbahTransaction.setTransactionDate(rs.getDate(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TRANSACTION_DATE]));
            limbahTransaction.setNomorFp(rs.getString(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_NOMOR_FP]));
            limbahTransaction.setDueDate(rs.getDate(colNames[COL_DUE_DATE]));

            limbahTransaction.setTotalDenda(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TOTAL_DENDA]));
            limbahTransaction.setStatusPembayaran(rs.getInt(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_STATUS_PEMBAYARAN]));

            limbahTransaction.setPpn(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PPN]));
            limbahTransaction.setPpnPercent(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PPN_PERCENT]));
            limbahTransaction.setPph(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PPH]));
            limbahTransaction.setPphPercent(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_PPH_PERCENT]));
            limbahTransaction.setTotalHarga(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_TOTAL_HARGA]));

            limbahTransaction.setDendaDiakui(rs.getDouble(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DENDA_DIAKUI]));
            limbahTransaction.setDendaApproveId(rs.getLong(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DENDA_APPROVE_ID]));
            limbahTransaction.setDendaApproveDate(rs.getDate(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DENDA_APPROVE_DATE]));
            limbahTransaction.setDendaKeterangan(rs.getString(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DENDA_KETERANGAN]));
            limbahTransaction.setDendaPostStatus(rs.getInt(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DENDA_POST_STATUS]));
            limbahTransaction.setDendaClientName(rs.getString(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DENDA_CLIENT_NAME]));
            limbahTransaction.setDendaClientPosition(rs.getString(DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DENDA_CLIENT_POSITION]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long dblimbahTransactionId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LIMBAH_TRASACTION + " WHERE " +
                    DbLimbahTransaction.colNames[DbLimbahTransaction.COL_LIMBAH_TRANSACTION_ID] + " = " + dblimbahTransactionId;

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
            String sql = "SELECT COUNT(" + DbLimbahTransaction.colNames[DbLimbahTransaction.COL_LIMBAH_TRANSACTION_ID] + ") FROM " + DB_LIMBAH_TRASACTION;
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
                    LimbahTransaction dblimbahTransaction = (LimbahTransaction) list.get(ls);
                    if (oid == dblimbahTransaction.getOID()) {
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

    public static LimbahTransaction getLimbahTransaction() {
        Vector v = list(0, 0, "", "");
        if (v != null && v.size() > 0) {
            return (LimbahTransaction) v.get(0);
        }
        return new LimbahTransaction();
    }

    /**
     * Posting transaksi Limbah ke GL
     * update by gwawan 201209
     * @param limbahTransaction
     * @param periodId
     * @param postingDate
     * @param userId
     * @return
     */
    public static boolean postJournal(LimbahTransaction limbahTransaction, long periodId, Date postingDate, long userId) {
        try {
            Company company = DbCompany.getCompany();
            Customer customer = DbCustomer.fetchExc(limbahTransaction.getCustomerId());
            Limbah limbah = DbLimbah.fetchExc(limbahTransaction.getMasterLimbahId());
            Periode periode = DbPeriode.fetchExc(periodId);
            User user = DbUser.fetch(userId);

           
            
            String memo = customer.getName() + " - Tagihan Limbah " + periode.getName() + " invoice " + limbahTransaction.getInvoiceNumber();

            //jika sarana mamakai limbah	                           
            if (limbahTransaction.getOID() != 0) {
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
                gl.setOwnerId(limbahTransaction.getOID());
                gl.setRefNumber(limbahTransaction.getInvoiceNumber());
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
                    double pendapatan = (limbahTransaction.getBulanIni() - limbahTransaction.getBulanLalu()) * limbahTransaction.getHarga() * (limbahTransaction.getPercentageUsed() / 100);
                    double ppn = 0;
                    if (customer.getType() == DbCustomer.CUSTOMER_TYPE_REGULAR) {
                        ppn = pendapatan * (limbah.getPpnPercent() / 100);
                    }
                    double piutang = pendapatan + ppn;

                    //journal debet piutang
                    /*DbGl.postJournalDetail(1, customer.getLimbahDebetAccountId(), 0, piutang, piutang,
                            company.getBookingCurrencyId(), oidGl, memo, 0);//non departmenttal item, department id = 0

                    //jurnal credit income
                    DbGl.postJournalDetail(1, customer.getLimbahCreditAccountId(), pendapatan, 0, pendapatan,
                            company.getBookingCurrencyId(), oidGl, memo, 0);//non departmenttal item, department id = 0

                    //journal credit ppn
                    if (customer.getType() == DbCustomer.CUSTOMER_TYPE_REGULAR) {
                        DbGl.postJournalDetail(1, customer.getLimbahPpnAccauntId(), ppn, 0, ppn,
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
    
    //POSTING ke journal - ar limbah
    public static boolean postJournalDenda(LimbahTransaction limbahTransaction){
        boolean ok = true;
        Company company = DbCompany.getCompany();
        Customer customer = new Customer();

        try {
            customer = DbCustomer.fetchExc(limbahTransaction.getCustomerId());
        } catch (Exception e) {
        }
        
      

        Periode periode = new Periode();
        try {
            periode = DbPeriode.fetchExc(limbahTransaction.getPeriodId());
        } catch(Exception e) {}

        String memo = customer.getName() + " - Denda Limbah "+ periode.getName() +", invoice : " + limbahTransaction.getInvoiceNumber();

        //jika sarana mamakai limbahgasi	                           
        //if (limbahTransaction.getOID() != 0 && customer.getLimbahFlag() == 1){

            //keterangan
            //postJournalMain(long currencyId, Date dt, int counter, String number, String prefix, 
            //int journalType, 
            //String memo, long operatorId, String operatorName, long ownerId, String refNumber, Date transDate)

            long oid = DbGl.postJournalMain(0, new Date(), limbahTransaction.getInvoiceNumberCounter(), limbahTransaction.getInvoiceNumber()+"D", limbahTransaction.getInvoiceNumber()+"D",
                    I_Project.JOURNAL_TYPE_INVOICE,
                    memo, 0, "", limbahTransaction.getOID(), "", limbahTransaction.getTransactionDate());

            //pengakuan piutang
            if (oid != 0) {
                //keterangan
                //postJournalDetail(double bookedRate, long coaId, double credit, double debet,             
                //double fCurrAmount, long currId, long glId, String memo, long departmentId)

                double harga = limbahTransaction.getDendaDiakui();
                
                //journal debet
                /*DbGl.postJournalDetail(1, customer.getPendapatanTerimaDiMukaAccountId(), 0, harga,
                        harga, company.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                
                //jurnal credit
                DbGl.postJournalDetail(1, customer.getLimbahCreditAccountId(), harga, 0,
                        harga, company.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                */        
                //optimalkan, jika akunnya sama digabung    
                DbGl.optimizeJournal(oid);
            }else{
                ok = false;
            }
      
        return ok;
    }   
}