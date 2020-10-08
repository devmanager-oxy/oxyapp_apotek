package com.project.fms.transaction;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;
import com.project.util.*;
import com.project.system.*;
import com.project.fms.master.*;
import com.project.*;
import com.project.crm.sewa.DbSewaTanahBenefit;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahBenefit;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.crm.transaction.DbIrigasiTransaction;
import com.project.crm.transaction.DbLimbahTransaction;
import com.project.crm.transaction.DbPembayaran;
import com.project.crm.transaction.IrigasiTransaction;
import com.project.crm.transaction.LimbahTransaction;
import com.project.general.*;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;
import com.project.interfaces.*;

public class DbCashReceive extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language, I_FmsCrmInsertUpdate {

    public static final String DB_CASH_RECEIVE = "cash_receive";
    public static final int COL_CASH_RECEIVE_ID = 0;
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
    public static final int COL_RECEIVE_FROM_ID = 11;
    public static final int COL_RECEIVE_FROM_NAME = 12;
    public static final int COL_TYPE = 13;
    public static final int COL_CUSTOMER_ID = 14;
    public static final int COL_IN_OUT = 15;
    public static final int COL_POSTED_STATUS = 16;
    public static final int COL_POSTED_BY_ID = 17;
    public static final int COL_POSTED_DATE = 18;
    public static final int COL_EFFECTIVE_DATE = 19;
    public static final int COL_REFERENSI_ID = 20;
    public static final int COL_SEGMENT1_ID = 21;
    public static final int COL_SEGMENT2_ID = 22;
    public static final int COL_SEGMENT3_ID = 23;
    public static final int COL_SEGMENT4_ID = 24;
    public static final int COL_SEGMENT5_ID = 25;
    public static final int COL_SEGMENT6_ID = 26;
    public static final int COL_SEGMENT7_ID = 27;
    public static final int COL_SEGMENT8_ID = 28;
    public static final int COL_SEGMENT9_ID = 29;
    public static final int COL_SEGMENT10_ID = 30;
    public static final int COL_SEGMENT11_ID = 31;
    public static final int COL_SEGMENT12_ID = 32;
    public static final int COL_SEGMENT13_ID = 33;
    public static final int COL_SEGMENT14_ID = 34;
    public static final int COL_SEGMENT15_ID = 35;
    public static final int COL_REF_PEMBAYARAN_ID = 36;
    public static final int COL_PERIODE_ID = 37;
    public static final String[] colNames = {
        "cash_receive_id",
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
        "receive_from_id",
        "receive_from_name",        
        "type",
        "customer_id",
        "in_out",
        "posted_status",
        "posted_by_id",
        "posted_date",
        "effective_date",
        "referensi_id",
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
        "ref_pembayaran_id",
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
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
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
        TYPE_LONG
    };
    public static final int TYPE_CASH_INCOME = 0;
    public static final int TYPE_CASH_LIABILITY = 1;
    public static final int TYPE_CASH_LIABILITY_PAYMENT = 2;
    public static final int TYPE_BYMHD = 3;
    public static final int TYPE_BYMHD_NEW = 4;
    public static final int TYPE_DP = 5;
    public static final int TYPE_DP_RETURN = 6;
    public static final int TYPE_CASH_INCOME_KASBON = 7;

    public DbCashReceive() {
    }

    public DbCashReceive(int i) throws CONException {
        super(new DbCashReceive());
    }

    public DbCashReceive(String sOid) throws CONException {
        super(new DbCashReceive(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCashReceive(long lOid) throws CONException {
        super(new DbCashReceive(0));
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
        return DB_CASH_RECEIVE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCashReceive().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CashReceive cashreceive = fetchExc(ent.getOID());
        ent = (Entity) cashreceive;
        return cashreceive.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CashReceive) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CashReceive) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CashReceive fetchExc(long oid) throws CONException {
        try {

            CashReceive cashreceive = new CashReceive();
            DbCashReceive pstCashReceive = new DbCashReceive(oid);
            cashreceive.setOID(oid);

            cashreceive.setCoaId(pstCashReceive.getlong(COL_COA_ID));
            cashreceive.setJournalNumber(pstCashReceive.getString(COL_JOURNAL_NUMBER));
            cashreceive.setJournalCounter(pstCashReceive.getInt(COL_JOURNAL_COUNTER));
            cashreceive.setJournalPrefix(pstCashReceive.getString(COL_JOURNAL_PREFIX));
            cashreceive.setDate(pstCashReceive.getDate(COL_DATE));
            cashreceive.setTransDate(pstCashReceive.getDate(COL_TRANS_DATE));
            cashreceive.setMemo(pstCashReceive.getString(COL_MEMO));
            cashreceive.setOperatorId(pstCashReceive.getlong(COL_OPERATOR_ID));
            cashreceive.setOperatorName(pstCashReceive.getString(COL_OPERATOR_NAME));
            cashreceive.setAmount(pstCashReceive.getdouble(COL_AMOUNT));
            cashreceive.setReceiveFromId(pstCashReceive.getlong(COL_RECEIVE_FROM_ID));
            cashreceive.setReceiveFromName(pstCashReceive.getString(COL_RECEIVE_FROM_NAME));

            cashreceive.setType(pstCashReceive.getInt(COL_TYPE));
            cashreceive.setCustomerId(pstCashReceive.getlong(COL_CUSTOMER_ID));
            cashreceive.setInOut(pstCashReceive.getInt(COL_IN_OUT));

            cashreceive.setPostedStatus(pstCashReceive.getInt(COL_POSTED_STATUS));
            cashreceive.setPostedById(pstCashReceive.getlong(COL_POSTED_BY_ID));
            cashreceive.setPostedDate(pstCashReceive.getDate(COL_POSTED_DATE));
            cashreceive.setEffectiveDate(pstCashReceive.getDate(COL_EFFECTIVE_DATE));
            cashreceive.setReferensiId(pstCashReceive.getlong(COL_REFERENSI_ID));

            cashreceive.setSegment1Id(pstCashReceive.getlong(COL_SEGMENT1_ID));
            cashreceive.setSegment2Id(pstCashReceive.getlong(COL_SEGMENT2_ID));
            cashreceive.setSegment3Id(pstCashReceive.getlong(COL_SEGMENT3_ID));
            cashreceive.setSegment4Id(pstCashReceive.getlong(COL_SEGMENT4_ID));
            cashreceive.setSegment5Id(pstCashReceive.getlong(COL_SEGMENT5_ID));
            cashreceive.setSegment6Id(pstCashReceive.getlong(COL_SEGMENT6_ID));
            cashreceive.setSegment7Id(pstCashReceive.getlong(COL_SEGMENT7_ID));
            cashreceive.setSegment8Id(pstCashReceive.getlong(COL_SEGMENT8_ID));
            cashreceive.setSegment9Id(pstCashReceive.getlong(COL_SEGMENT9_ID));
            cashreceive.setSegment10Id(pstCashReceive.getlong(COL_SEGMENT10_ID));
            cashreceive.setSegment11Id(pstCashReceive.getlong(COL_SEGMENT11_ID));
            cashreceive.setSegment12Id(pstCashReceive.getlong(COL_SEGMENT12_ID));
            cashreceive.setSegment13Id(pstCashReceive.getlong(COL_SEGMENT13_ID));
            cashreceive.setSegment14Id(pstCashReceive.getlong(COL_SEGMENT14_ID));
            cashreceive.setSegment15Id(pstCashReceive.getlong(COL_SEGMENT15_ID));
            cashreceive.setRefPembayaranId(pstCashReceive.getlong(COL_REF_PEMBAYARAN_ID));
            cashreceive.setPeriodeId(pstCashReceive.getlong(COL_PERIODE_ID));

            return cashreceive;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashReceive(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(CashReceive cashreceive) throws CONException {
        try {
            DbCashReceive pstCashReceive = new DbCashReceive(0);

            pstCashReceive.setLong(COL_COA_ID, cashreceive.getCoaId());
            pstCashReceive.setString(COL_JOURNAL_NUMBER, cashreceive.getJournalNumber());
            pstCashReceive.setInt(COL_JOURNAL_COUNTER, cashreceive.getJournalCounter());
            pstCashReceive.setString(COL_JOURNAL_PREFIX, cashreceive.getJournalPrefix());
            pstCashReceive.setDate(COL_DATE, cashreceive.getDate());
            pstCashReceive.setDate(COL_TRANS_DATE, cashreceive.getTransDate());
            pstCashReceive.setString(COL_MEMO, cashreceive.getMemo());
            pstCashReceive.setLong(COL_OPERATOR_ID, cashreceive.getOperatorId());
            pstCashReceive.setString(COL_OPERATOR_NAME, cashreceive.getOperatorName());
            pstCashReceive.setDouble(COL_AMOUNT, cashreceive.getAmount());
            pstCashReceive.setLong(COL_RECEIVE_FROM_ID, cashreceive.getReceiveFromId());
            pstCashReceive.setString(COL_RECEIVE_FROM_NAME, cashreceive.getReceiveFromName());

            pstCashReceive.setInt(COL_TYPE, cashreceive.getType());
            pstCashReceive.setLong(COL_CUSTOMER_ID, cashreceive.getCustomerId());
            pstCashReceive.setInt(COL_IN_OUT, cashreceive.getInOut());

            pstCashReceive.setInt(COL_POSTED_STATUS, cashreceive.getPostedStatus());
            pstCashReceive.setLong(COL_POSTED_BY_ID, cashreceive.getPostedById());
            pstCashReceive.setDate(COL_POSTED_DATE, cashreceive.getPostedDate());
            pstCashReceive.setDate(COL_EFFECTIVE_DATE, cashreceive.getEffectiveDate());
            pstCashReceive.setLong(COL_REFERENSI_ID, cashreceive.getReferensiId());

            pstCashReceive.setLong(COL_SEGMENT1_ID, cashreceive.getSegment1Id());
            pstCashReceive.setLong(COL_SEGMENT2_ID, cashreceive.getSegment2Id());
            pstCashReceive.setLong(COL_SEGMENT3_ID, cashreceive.getSegment3Id());
            pstCashReceive.setLong(COL_SEGMENT4_ID, cashreceive.getSegment4Id());
            pstCashReceive.setLong(COL_SEGMENT5_ID, cashreceive.getSegment5Id());
            pstCashReceive.setLong(COL_SEGMENT6_ID, cashreceive.getSegment6Id());
            pstCashReceive.setLong(COL_SEGMENT7_ID, cashreceive.getSegment7Id());
            pstCashReceive.setLong(COL_SEGMENT8_ID, cashreceive.getSegment8Id());
            pstCashReceive.setLong(COL_SEGMENT9_ID, cashreceive.getSegment9Id());
            pstCashReceive.setLong(COL_SEGMENT10_ID, cashreceive.getSegment10Id());
            pstCashReceive.setLong(COL_SEGMENT11_ID, cashreceive.getSegment11Id());
            pstCashReceive.setLong(COL_SEGMENT12_ID, cashreceive.getSegment12Id());
            pstCashReceive.setLong(COL_SEGMENT13_ID, cashreceive.getSegment13Id());
            pstCashReceive.setLong(COL_SEGMENT14_ID, cashreceive.getSegment14Id());
            pstCashReceive.setLong(COL_SEGMENT15_ID, cashreceive.getSegment15Id());
            pstCashReceive.setLong(COL_REF_PEMBAYARAN_ID, cashreceive.getRefPembayaranId());
            pstCashReceive.setLong(COL_PERIODE_ID, cashreceive.getPeriodeId());

            pstCashReceive.insert();
            cashreceive.setOID(pstCashReceive.getlong(COL_CASH_RECEIVE_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashReceive(0), CONException.UNKNOWN);
        }
        return cashreceive.getOID();
    }

    public static long updateExc(CashReceive cashreceive) throws CONException {
        try {
            if (cashreceive.getOID() != 0) {
                DbCashReceive pstCashReceive = new DbCashReceive(cashreceive.getOID());

                pstCashReceive.setLong(COL_COA_ID, cashreceive.getCoaId());
                pstCashReceive.setString(COL_JOURNAL_NUMBER, cashreceive.getJournalNumber());
                pstCashReceive.setInt(COL_JOURNAL_COUNTER, cashreceive.getJournalCounter());
                pstCashReceive.setString(COL_JOURNAL_PREFIX, cashreceive.getJournalPrefix());
                pstCashReceive.setDate(COL_DATE, cashreceive.getDate());
                pstCashReceive.setDate(COL_TRANS_DATE, cashreceive.getTransDate());
                pstCashReceive.setString(COL_MEMO, cashreceive.getMemo());
                pstCashReceive.setLong(COL_OPERATOR_ID, cashreceive.getOperatorId());
                pstCashReceive.setString(COL_OPERATOR_NAME, cashreceive.getOperatorName());
                pstCashReceive.setDouble(COL_AMOUNT, cashreceive.getAmount());
                pstCashReceive.setLong(COL_RECEIVE_FROM_ID, cashreceive.getReceiveFromId());
                pstCashReceive.setString(COL_RECEIVE_FROM_NAME, cashreceive.getReceiveFromName());

                pstCashReceive.setInt(COL_TYPE, cashreceive.getType());
                pstCashReceive.setLong(COL_CUSTOMER_ID, cashreceive.getCustomerId());
                pstCashReceive.setInt(COL_IN_OUT, cashreceive.getInOut());

                pstCashReceive.setInt(COL_POSTED_STATUS, cashreceive.getPostedStatus());
                pstCashReceive.setLong(COL_POSTED_BY_ID, cashreceive.getPostedById());
                pstCashReceive.setDate(COL_POSTED_DATE, cashreceive.getPostedDate());
                pstCashReceive.setDate(COL_EFFECTIVE_DATE, cashreceive.getEffectiveDate());
                pstCashReceive.setLong(COL_REFERENSI_ID, cashreceive.getReferensiId());

                pstCashReceive.setLong(COL_SEGMENT1_ID, cashreceive.getSegment1Id());
                pstCashReceive.setLong(COL_SEGMENT2_ID, cashreceive.getSegment2Id());
                pstCashReceive.setLong(COL_SEGMENT3_ID, cashreceive.getSegment3Id());
                pstCashReceive.setLong(COL_SEGMENT4_ID, cashreceive.getSegment4Id());
                pstCashReceive.setLong(COL_SEGMENT5_ID, cashreceive.getSegment5Id());
                pstCashReceive.setLong(COL_SEGMENT6_ID, cashreceive.getSegment6Id());
                pstCashReceive.setLong(COL_SEGMENT7_ID, cashreceive.getSegment7Id());
                pstCashReceive.setLong(COL_SEGMENT8_ID, cashreceive.getSegment8Id());
                pstCashReceive.setLong(COL_SEGMENT9_ID, cashreceive.getSegment9Id());
                pstCashReceive.setLong(COL_SEGMENT10_ID, cashreceive.getSegment10Id());
                pstCashReceive.setLong(COL_SEGMENT11_ID, cashreceive.getSegment11Id());
                pstCashReceive.setLong(COL_SEGMENT12_ID, cashreceive.getSegment12Id());
                pstCashReceive.setLong(COL_SEGMENT13_ID, cashreceive.getSegment13Id());
                pstCashReceive.setLong(COL_SEGMENT14_ID, cashreceive.getSegment14Id());
                pstCashReceive.setLong(COL_SEGMENT15_ID, cashreceive.getSegment15Id());
                pstCashReceive.setLong(COL_REF_PEMBAYARAN_ID, cashreceive.getRefPembayaranId());
                pstCashReceive.setLong(COL_PERIODE_ID, cashreceive.getPeriodeId());

                pstCashReceive.update();
                return cashreceive.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashReceive(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCashReceive pstCashReceive = new DbCashReceive(oid);
            pstCashReceive.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashReceive(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_CASH_RECEIVE;
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
                CashReceive cashreceive = new CashReceive();
                resultToObject(rs, cashreceive);
                lists.add(cashreceive);
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

    public static void resultToObject(ResultSet rs, CashReceive cashreceive) {
        try {
            cashreceive.setOID(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID]));
            cashreceive.setCoaId(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_COA_ID]));
            cashreceive.setJournalNumber(rs.getString(DbCashReceive.colNames[DbCashReceive.COL_JOURNAL_NUMBER]));
            cashreceive.setJournalCounter(rs.getInt(DbCashReceive.colNames[DbCashReceive.COL_JOURNAL_COUNTER]));
            cashreceive.setJournalPrefix(rs.getString(DbCashReceive.colNames[DbCashReceive.COL_JOURNAL_PREFIX]));
            cashreceive.setDate(rs.getDate(DbCashReceive.colNames[DbCashReceive.COL_DATE]));
            cashreceive.setTransDate(rs.getDate(DbCashReceive.colNames[DbCashReceive.COL_TRANS_DATE]));
            cashreceive.setMemo(rs.getString(DbCashReceive.colNames[DbCashReceive.COL_MEMO]));
            cashreceive.setOperatorId(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_OPERATOR_ID]));
            cashreceive.setOperatorName(rs.getString(DbCashReceive.colNames[DbCashReceive.COL_OPERATOR_NAME]));
            cashreceive.setAmount(rs.getDouble(DbCashReceive.colNames[DbCashReceive.COL_AMOUNT]));
            cashreceive.setReceiveFromId(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_RECEIVE_FROM_ID]));
            cashreceive.setReceiveFromName(rs.getString(DbCashReceive.colNames[DbCashReceive.COL_RECEIVE_FROM_NAME]));

            cashreceive.setType(rs.getInt(DbCashReceive.colNames[DbCashReceive.COL_TYPE]));
            cashreceive.setCustomerId(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_CUSTOMER_ID]));
            cashreceive.setInOut(rs.getInt(DbCashReceive.colNames[DbCashReceive.COL_IN_OUT]));

            cashreceive.setPostedStatus(rs.getInt(DbCashReceive.colNames[DbCashReceive.COL_POSTED_STATUS]));
            cashreceive.setPostedById(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_POSTED_BY_ID]));
            cashreceive.setPostedDate(rs.getDate(DbCashReceive.colNames[DbCashReceive.COL_POSTED_DATE]));
            cashreceive.setEffectiveDate(rs.getDate(DbCashReceive.colNames[DbCashReceive.COL_EFFECTIVE_DATE]));
            cashreceive.setReferensiId(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_REFERENSI_ID]));

            cashreceive.setSegment1Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT1_ID]));
            cashreceive.setSegment2Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT2_ID]));
            cashreceive.setSegment3Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT3_ID]));
            cashreceive.setSegment4Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT4_ID]));
            cashreceive.setSegment5Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT5_ID]));
            cashreceive.setSegment6Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT6_ID]));
            cashreceive.setSegment7Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT7_ID]));
            cashreceive.setSegment8Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT8_ID]));
            cashreceive.setSegment9Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT9_ID]));
            cashreceive.setSegment10Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT10_ID]));
            cashreceive.setSegment11Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT11_ID]));
            cashreceive.setSegment12Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT12_ID]));
            cashreceive.setSegment13Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT13_ID]));
            cashreceive.setSegment14Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT14_ID]));
            cashreceive.setSegment15Id(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_SEGMENT15_ID]));
            cashreceive.setRefPembayaranId(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_REF_PEMBAYARAN_ID]));
            cashreceive.setPeriodeId(rs.getLong(DbCashReceive.colNames[DbCashReceive.COL_PERIODE_ID]));

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
    }

    public static boolean checkOID(long cashReceiveId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CASH_RECEIVE + " WHERE " +
                    DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID] + " = " + cashReceiveId;

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
            String sql = "SELECT COUNT(" + DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID] + ") FROM " + DB_CASH_RECEIVE;
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
                    CashReceive cashreceive = (CashReceive) list.get(ls);
                    if (oid == cashreceive.getOID()) {
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

    public static int getNextCounter(int type) {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(journal_counter) from " + DB_CASH_RECEIVE + " where " +
                    " journal_prefix='" + getNumberPrefix(type) + "' ";

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

    public static String getNumberPrefix(int type) {

        Company sysCompany = DbCompany.getCompany();
        Location sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());

        String code = sysLocation.getCode();//DbSystemProperty.getValueByName("LOCATION_CODE");

        if (type == TYPE_CASH_INCOME) {
            code = code + DbSystemProperty.getValueByName("JOURNAL_CODE_CASH_RECEIPT");
        } else if (type == TYPE_CASH_LIABILITY) {
            code = code + DbSystemProperty.getValueByName("JOURNAL_CODE_TITIPAN");
        } else if (type == TYPE_CASH_LIABILITY_PAYMENT) {
            code = code + DbSystemProperty.getValueByName("JOURNAL_CODE_TITIPAN_PAYMENT");
        } else if (type == TYPE_BYMHD_NEW) {
            code = code + DbSystemProperty.getValueByName("JOURNAL_CODE_BYMHD");
        } else if (type == TYPE_BYMHD) {
            code = code + DbSystemProperty.getValueByName("JOURNAL_CODE_BYMHD_PAYMENT");
        }

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }

    public static String getNextNumber(int ctr, int type) {

        String code = getNumberPrefix(type);

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

    //POSTING ke journal
    public static void postJournal(CashReceive cr, Vector details, long userId) {

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        try {
            cr = DbCashReceive.fetchExc(cr.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        Periode p = new Periode();
        try{
            p = DbPeriode.fetchExc(cr.getPeriodeId());
        }catch(Exception e){}

        if (cr.getOID() != 0 && details != null && details.size() > 0 && p.getOID() != 0 &&  p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {

            long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_CASH_RECEIVE,
                    cr.getMemo(), userId, "", cr.getOID(), "", cr.getTransDate(), cr.getPeriodeId());

            if (oid != 0) {
                for (int i = 0; i < details.size(); i++) {

                    CashReceiveDetail crd = (CashReceiveDetail) details.get(i);
                    //journal credit pada pendapatan

                    if (crd.getAmount() != 0) {

                        DbGl.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), crd.getAmount(), 0,
                                crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo(), crd.getDepartmentId(),
                                crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
                                crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
                                crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
                                crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), 0); //non departmenttal item, department id = 0
                    } else {

                        DbGl.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), 0, crd.getCreditAmount(),
                                crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo(), crd.getDepartmentId(),
                                crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
                                crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
                                crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
                                crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), 0);
                    }
                }

                //journal debet pada cash 
                DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), 0, cr.getAmount(),
                        0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0);//non departmenttal item, department id = 0
            }

            //update status
            if (oid != 0) {

                try {

                    cr.setPostedStatus(1);
                    cr.setPostedById(userId);
                    cr.setPostedDate(new Date());

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

                    DbCashReceive.updateExc(cr);

                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
        }
    }

    //POSTING ke journal
    //jurnal hutang pada cash
    public static void postJournalKembaliTitipan(CashReceive cr, Vector details) {
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
        try {
            cr = DbCashReceive.fetchExc(cr.getOID());
        } catch (Exception e) {}
        
        Periode p = new Periode();
        try{
            p = DbPeriode.fetchExc(cr.getPeriodeId());
        }catch(Exception e){}
        

        if (cr.getOID() != 0 && details != null && details.size() > 0 && p.getOID() != 0 &&  p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {
            long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_CASH_RECEIVE,
                    cr.getMemo(), cr.getOperatorId(), cr.getOperatorName(), cr.getOID(), "", cr.getTransDate());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {
                    CashReceiveDetail crd = (CashReceiveDetail) details.get(i);
                    //journal debet pada utang
                    DbGl.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), 0, crd.getAmount(),
                            crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo(), 0,
                            cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                            cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                            cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                            cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0); //non departmenttal item, department id = 0
                }

                //journal credit pada cash 
                DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), cr.getAmount(), 0,
                        0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0);//non departmenttal item, department id = 0




            }
        }
    }

    //POSTING ke journal
    //jurnal expense pada hutang
    public static void postJournalBYHMDNew(CashReceive cr, Vector details) {

        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();
        try {
            cr = DbCashReceive.fetchExc(cr.getOID());
        } catch (Exception e) {}
        
        Periode p = new Periode();
        try{
            p = DbPeriode.fetchExc(cr.getPeriodeId());
        }catch(Exception e){}

        if (cr.getOID() != 0 && details != null && details.size() > 0 && p.getOID() != 0 &&  p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {
            long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_CASH_RECEIVE,
                    cr.getMemo(), cr.getOperatorId(), cr.getOperatorName(), cr.getOID(), "", cr.getTransDate());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {
                    CashReceiveDetail crd = (CashReceiveDetail) details.get(i);
                    //journal debet pada expense
                    DbGl.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), 0, crd.getAmount(),
                            crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo(), 0,
                            cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                            cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                            cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                            cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0); //non departmenttal item, department id = 0
                }

                //journal credit pada hutang 
                DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), cr.getAmount(), 0,
                        0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0);//non departmenttal item, department id = 0


            }
        }
    }

    //POSTING ke journal
    //jurnal hutang pada cash
    public static void postJournalBYHMD(CashReceive cr, Vector details) {
        Company comp = DbCompany.getCompany();
        ExchangeRate er = DbExchangeRate.getStandardRate();

        try {
            cr = DbCashReceive.fetchExc(cr.getOID());
        } catch (Exception e) {}
        
        Periode p = new Periode();
        try{
            p = DbPeriode.fetchExc(cr.getPeriodeId());
        }catch(Exception e){}

        if (cr.getOID() != 0 && details != null && details.size() > 0 && p.getOID() != 0 &&  p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {
            long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_CASH_RECEIVE,
                    cr.getMemo(), cr.getOperatorId(), cr.getOperatorName(), cr.getOID(), "", cr.getTransDate());

            if (oid != 0) {

                for (int i = 0; i < details.size(); i++) {
                    CashReceiveDetail crd = (CashReceiveDetail) details.get(i);
                    //journal debet pada utang
                    DbGl.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), 0, crd.getAmount(),
                            crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo(), 0,
                            cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                            cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                            cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                            cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0); //non departmenttal item, department id = 0
                }

                //journal credit pada cash 
                DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), cr.getAmount(), 0,
                        0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0);//non departmenttal item, department id = 0




            }
        }
    }

    public static void updateAmount(CashReceive cashReceive) {
        String sql = "";
        CONResultSet crs = null;
        double amount = 0;
        try {
            sql = "SELECT sum(" + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_AMOUNT] + ") - " +
                    " sum(" + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CREDIT_AMOUNT] + ")" +
                    " FROM " +
                    DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + " p where " +
                    DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] + "=" + cashReceive.getOID();

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

        try {
            cashReceive.setAmount(amount);
            DbCashReceive.updateExc(cashReceive);
        } catch (Exception e) {

        }
    }

    public static Vector getSaldoTitipan(long customerId) {

        String sql = "select " + colNames[COL_CUSTOMER_ID] + ", sum(" + colNames[COL_AMOUNT] + "*" + colNames[COL_IN_OUT] + ") from " +
                DB_CASH_RECEIVE + " where (" + colNames[COL_TYPE] + "=" + TYPE_CASH_LIABILITY + " or " + colNames[COL_TYPE] + "=" + TYPE_CASH_LIABILITY_PAYMENT + ")";

        if (customerId != 0) {
            sql = sql + " and " + colNames[COL_CUSTOMER_ID] + "=" + customerId;
        }

        sql = sql + " group by " + colNames[COL_CUSTOMER_ID];

        CONResultSet crs = null;
        Vector result = new Vector();

        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                CashReceive cr = new CashReceive();
                cr.setCustomerId(rs.getLong(1));
                cr.setAmount(rs.getDouble(2));
                result.add(cr);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static Vector getSaldoTitipan(long customerId, long accountId) {

        /*String sql = "select "+colNames[COL_CUSTOMER_ID]+", sum("+colNames[COL_AMOUNT]+"*"+colNames[COL_IN_OUT]+") from "+
        DB_CASH_RECEIVE+" where ("+colNames[COL_TYPE]+"="+TYPE_CASH_LIABILITY+" or "+colNames[COL_TYPE]+"="+TYPE_CASH_LIABILITY_PAYMENT+")";
        if(customerId!=0){
        sql = sql + " and "+colNames[COL_CUSTOMER_ID]+"="+customerId;
        }
        sql = sql + " group by "+colNames[COL_CUSTOMER_ID];
        System.out.println(sql);
         */


        String sql = "SELECT cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID] + ", " +
                " sum(cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_AMOUNT] +
                " *c." + DbCashReceive.colNames[DbCashReceive.COL_IN_OUT] + ") " +
                " FROM " + DB_CASH_RECEIVE + " c " +
                " inner join " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + " cd " +
                " on cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] +
                " = c." + DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID] +
                " where (c." + colNames[COL_TYPE] + "=" + TYPE_CASH_LIABILITY + " or c." + colNames[COL_TYPE] + "=" + TYPE_CASH_LIABILITY_PAYMENT + ")";

        if (customerId != 0) {
            sql = sql + " and cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID] + "=" + customerId;
        }

        if (accountId != 0) {
            sql = sql + " and cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_COA_ID] + "=" + accountId;
        }

        sql = sql + " group by cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID];

        CONResultSet crs = null;
        Vector result = new Vector();

        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                CashReceive cr = new CashReceive();
                cr.setCustomerId(rs.getLong(1));
                cr.setAmount(rs.getDouble(2));
                result.add(cr);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static Vector getSaldoBYMHD(long customerId) {

        String sql = "select " + colNames[COL_CUSTOMER_ID] + ", sum(" + colNames[COL_AMOUNT] + "*" + colNames[COL_IN_OUT] + ") from " +
                DB_CASH_RECEIVE + " where (" + colNames[COL_TYPE] + "=" + TYPE_BYMHD_NEW + " or " + colNames[COL_TYPE] + "=" + TYPE_BYMHD + ")";

        if (customerId != 0) {
            sql = sql + " and " + colNames[COL_CUSTOMER_ID] + "=" + customerId;
        }

        sql = sql + " group by " + colNames[COL_CUSTOMER_ID];

        CONResultSet crs = null;
        Vector result = new Vector();

        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                CashReceive cr = new CashReceive();
                cr.setCustomerId(rs.getLong(1));
                cr.setAmount(rs.getDouble(2));
                result.add(cr);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static Vector getSaldoBYMHD(long customerId, long accountId) {

        /*String sql = "select "+colNames[COL_CUSTOMER_ID]+", sum("+colNames[COL_AMOUNT]+"*"+colNames[COL_IN_OUT]+") from "+
        DB_CASH_RECEIVE+" where ("+colNames[COL_TYPE]+"="+TYPE_BYMHD_NEW+" or "+colNames[COL_TYPE]+"="+TYPE_BYMHD+")";
        if(customerId!=0){
        sql = sql + " and "+colNames[COL_CUSTOMER_ID]+"="+customerId;
        }
        sql = sql + " group by "+colNames[COL_CUSTOMER_ID];
        System.out.println(sql);
         */

        String sql = "SELECT cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID] + ", " +
                " sum(cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_AMOUNT] +
                " *c." + DbCashReceive.colNames[DbCashReceive.COL_IN_OUT] + ") " +
                " FROM " + DB_CASH_RECEIVE + " c " +
                " inner join " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + " cd " +
                " on cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] +
                " = c." + DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID] +
                " where (c." + colNames[COL_TYPE] + "=" + TYPE_BYMHD_NEW + " or c." + colNames[COL_TYPE] + "=" + TYPE_BYMHD + ")";

        if (customerId != 0) {
            sql = sql + " and cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID] + "=" + customerId;
        }

        if (accountId != 0) {
            sql = sql + " and cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_BYMHD_COA_ID] + "=" + accountId;
        }

        sql = sql + " group by cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID];

        CONResultSet crs = null;
        Vector result = new Vector();

        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                CashReceive cr = new CashReceive();
                cr.setCustomerId(rs.getLong(1));
                cr.setAmount(rs.getDouble(2));
                result.add(cr);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static Vector getSaldoDP(long customerId, long accountId) {

        /*String sql = "select "+colNames[COL_CUSTOMER_ID]+", sum("+colNames[COL_AMOUNT]+"*"+colNames[COL_IN_OUT]+") from "+
        DB_CASH_RECEIVE+" where ("+colNames[COL_TYPE]+"="+TYPE_BYMHD_NEW+" or "+colNames[COL_TYPE]+"="+TYPE_BYMHD+")";
        if(customerId!=0){
        sql = sql + " and "+colNames[COL_CUSTOMER_ID]+"="+customerId;
        }
        sql = sql + " group by "+colNames[COL_CUSTOMER_ID];
        System.out.println(sql);
         */

        String sql = "SELECT cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID] + ", " +
                " sum(cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_AMOUNT] +
                " *c." + DbCashReceive.colNames[DbCashReceive.COL_IN_OUT] + ") " +
                " FROM " + DB_CASH_RECEIVE + " c " +
                " inner join " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + " cd " +
                " on cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] +
                " = c." + DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID] +
                " where (c." + colNames[COL_TYPE] + "=" + TYPE_DP + " or c." + colNames[COL_TYPE] + "=" + TYPE_DP_RETURN + ")";

        if (customerId != 0) {
            sql = sql + " and cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID] + "=" + customerId;
        }

        if (accountId != 0) {
            sql = sql + " and cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_BYMHD_COA_ID] + "=" + accountId;
        }

        sql = sql + " group by cd." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID];

        CONResultSet crs = null;
        Vector result = new Vector();

        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                CashReceive cr = new CashReceive();
                cr.setCustomerId(rs.getLong(1));
                cr.setAmount(rs.getDouble(2));
                result.add(cr);
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static long getCashReceiveOid(long referensiId) {

        CONResultSet crs = null;

        try {

            String sql = "SELECT " + DbCashReceive.colNames[DbCashReceive.COL_CASH_RECEIVE_ID] + " FROM " + DbCashReceive.DB_CASH_RECEIVE + " WHERE " +
                    DbCashReceive.colNames[DbCashReceive.COL_REFERENSI_ID] + " = " + referensiId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {

                long tmpOid = rs.getLong(1);
                return tmpOid;
            }

        } catch (Exception E) {
            System.out.println("[exception] " + E.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return 0;

    }

    public static Vector getCRD(long refId) {

        if (refId == 0) {
            return null;
        }

        String whereCR = DbCashReceive.colNames[DbCashReceive.COL_REFERENSI_ID] + " = " + refId;

        Vector lstCR = DbCashReceive.list(0, 0, whereCR, null);

        if (lstCR != null && lstCR.size() > 0) {

            CashReceive cr = (CashReceive) lstCR.get(0);

            String whereCRD = DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] + " = " + cr.getOID();

            Vector result = DbCashReceiveDetail.list(0, 0, whereCRD, null);

            return result;

        }
        return null;
    }

    public long insertBKM(Entity ent) throws Exception {
        return insertBKM((CrmPost) ent);
    }

    public long updateBKM(Entity ent) throws Exception {
        return updateBKM((CrmPost) ent);
    }
    
    /**
     * @author gwawan
     * @param crmPost
     * @return
     * 
     * Fungsi untuk melakukan posting data pembayaran agar terbentuk BKM
     */
    public long insertBKM(CrmPost crmPost) {
        try {
            CashReceive cashReceive = new CashReceive();
            Customer customer = DbCustomer.fetchExc(crmPost.getSaranaId());
            
            //proses main cash receive
            cashReceive.setCoaId(crmPost.getPaymentAccountId());
            cashReceive.setJournalNumber(crmPost.getJournalNumber());
            cashReceive.setJournalCounter(crmPost.getJournalCounter());
            cashReceive.setJournalPrefix(crmPost.getJournalPrefix());
            cashReceive.setDate(crmPost.getDate());
            cashReceive.setTransDate(crmPost.getDateTransaction());
            cashReceive.setMemo(crmPost.getMemo());
            cashReceive.setAmount(crmPost.getAmount());
            cashReceive.setCustomerId(customer.getOID());
            cashReceive.setReceiveFromId(customer.getOID());
            cashReceive.setReceiveFromName(customer.getName());
            cashReceive.setType(crmPost.getType());
            cashReceive.setPeriodeId(crmPost.getPeriodeId());
            cashReceive.setReferensiId(crmPost.getReferensiId());
            cashReceive.setOperatorId(crmPost.getPostedById());
            long oidCashReceive = DbCashReceive.insertExc(cashReceive);
            
            //proses detail cash receive
            if(oidCashReceive != 0) {
                CashReceiveDetail cashReceiveDetail = new CashReceiveDetail();
                
                cashReceiveDetail.setCashReceiveId(oidCashReceive);
                
                if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_LIMBAH) {
                    cashReceiveDetail.setCoaId(crmPost.getLimbahDebetAccountId());
                } else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_IRIGASI) {
                    cashReceiveDetail.setCoaId(crmPost.getIrigasiDebetAccountId());
                } else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_ASSESMENT) {
                    cashReceiveDetail.setCoaId(crmPost.getAssesmentDebetAccountId());
                } else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMIN) {
                    cashReceiveDetail.setCoaId(crmPost.getKominDebetAccountId());
                } else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMPER) {
                    cashReceiveDetail.setCoaId(crmPost.getKomperDebetAccountId());
                }
                
                cashReceiveDetail.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                cashReceiveDetail.setForeignAmount(crmPost.getForeignAmount());
                cashReceiveDetail.setBookedRate(crmPost.getBookedRate());
                cashReceiveDetail.setAmount(crmPost.getAmount());
                cashReceiveDetail.setMemo(crmPost.getMemo());
                cashReceiveDetail.setDepartmentId(crmPost.getDepartmentId());
                DbCashReceiveDetail.insertExc(cashReceiveDetail);
                
            }
            
            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashReceive.getAmount(), cashReceive.getOperatorId());
            
            return oidCashReceive;
            
        } catch(Exception e) {
            return 0;
        }
    }

    public long insertBKMv1(CrmPost crmPost){

        try {

            if (crmPost.getReferensiId() != 0){ // jika OID pembayaran ada
                
                CashReceive cashreceive = new CashReceive();                
                cashreceive.setReferensiId(crmPost.getReferensiId());
                
                //posting ke journal main
                cashreceive.setDate(crmPost.getDate());
                cashreceive.setJournalCounter(crmPost.getJournalCounter());
                cashreceive.setJournalNumber(crmPost.getJournalNumber());
                cashreceive.setJournalPrefix(crmPost.getJournalPrefix());
                cashreceive.setType(crmPost.getType());
                cashreceive.setMemo(crmPost.getMemo());
                cashreceive.setPeriodeId(crmPost.getPeriodeId());
                cashreceive.setTransDate(crmPost.getDateTransaction());
                cashreceive.setSegment1Id(0);
                cashreceive.setSegment2Id(0);
                cashreceive.setSegment3Id(0);
                cashreceive.setSegment4Id(0);
                cashreceive.setSegment5Id(0);
                cashreceive.setSegment6Id(0);
                cashreceive.setSegment7Id(0);
                cashreceive.setSegment8Id(0);
                cashreceive.setSegment9Id(0);
                cashreceive.setSegment10Id(0);
                cashreceive.setSegment11Id(0);
                cashreceive.setSegment12Id(0);
                cashreceive.setSegment13Id(0);
                cashreceive.setSegment14Id(0);
                cashreceive.setSegment15Id(0);
                
                try{
                    Customer cust = DbCustomer.fetchExc(crmPost.getSaranaId());
                    cashreceive.setReceiveFromName(cust.getName());
                }catch(Exception e){}

                long oidCashReceive = 0;
                
                if (crmPost.isStatusPembayaran()){  // jika pembayarannya lunas
                    
                    double selisih = crmPost.getTotPembayaran() - crmPost.getTotHarusDibayar();
                    
                    if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_LIMBAH){ // jika termasuk pembayaran limbah
                        
                        boolean stsLimbah = DbPembayaran.stsPembayaranLimbah(crmPost.getLimbahTransactionId());                        
                        
                        if(stsLimbah == false){ //jika pembayaran belum lunas
                            
                            double amount = (crmPost.getAmount() * crmPost.getBookedRate()) + (selisih * crmPost.getBookedRate());
                            
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);                           
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){
                                System.out.println("[exception] "+e.toString());
                            }
                            
                            if(oidCashReceive != 0){
                                //cash detail Credit
                                
                                double amountCrd = crmPost.getAmount() * crmPost.getBookedRate();
                                
                                if(amountCrd != 0){
                                
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getLimbahDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());  
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}
                                
                                }
                                
                                if(selisih != 0){
                                    
                                    double amountCrd2 = selisih * crmPost.getBookedRate();
                                    if(amountCrd2 != 0){
                                        CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                        cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                        cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                        cashreceiveDetailCredit2.setAmount(selisih * crmPost.getBookedRate());  
                                        cashreceiveDetailCredit2.setForeignAmount(selisih);
                                        cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                        cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                        cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                        cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                                
                                
                                        try{
                                            DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                        }catch(Exception e){System.out.println("[exception] "+e.toString());}       
                                    }
                                }
                                
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                                
                            }
                            
                        }else{ //jika sudah lunas
                            
                            LimbahTransaction limTransaction = new LimbahTransaction();
                            
                            try {
                                limTransaction = DbLimbahTransaction.fetchExc(crmPost.getLimbahTransactionId());
                            } catch (Exception e){
                                System.out.println("[exception] "+e.toString());
                            }
                            
                            double amount = (crmPost.getAmount() * crmPost.getBookedRate()) + limTransaction.getDendaDiakui();
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);  
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){ System.out.println("[exception] "+e.toString()); }
                            
                            if(oidCashReceive != 0){
                                //cash detail Credit
                                double amountCrd = crmPost.getAmount() * crmPost.getBookedRate();
                                
                                if(amountCrd != 0){
                                    
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getLimbahDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());  
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                  
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());} 
                                }
                                
                                double amountCrd2 = limTransaction.getDendaDiakui();
                                
                                if(amountCrd2 != 0){
                                    CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                    cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                    cashreceiveDetailCredit2.setAmount(limTransaction.getDendaDiakui());  
                                    cashreceiveDetailCredit2.setForeignAmount(limTransaction.getDendaDiakui()/crmPost.getBookedRate());  
                                    cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}                                 
                                }
                                
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                                
                            }   
                        }
                        
                        
                        
                    }else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_IRIGASI){ // jika termasuk pembayaran irigasi
                        
                        boolean stsIrigasi = DbPembayaran.stsPembayaranIrigasi(crmPost.getIrigasiTransactionId());
                        
                        if(stsIrigasi == false){  //jika pembayaran belum lunas
                            
                            double amount = (crmPost.getAmount() * crmPost.getBookedRate()) + (selisih * crmPost.getBookedRate());
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);                           
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){
                                System.out.println("[exception] "+e.toString());
                            }
                            
                            if(oidCashReceive != 0){
                                double amountCrd = crmPost.getAmount() * crmPost.getBookedRate();
                                if(amountCrd != 0){
                                    //cash detail Credit
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getIrigasiDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());  
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}
                                }
                                
                                if(selisih != 0){
                                    double amountCrd2 = selisih * crmPost.getBookedRate();
                                    if(amountCrd2 != 0){
                                        CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                        cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                        cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                        cashreceiveDetailCredit2.setAmount(selisih * crmPost.getBookedRate());  
                                        cashreceiveDetailCredit2.setForeignAmount(selisih);  
                                        cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                        cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                        cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                        cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                                
                                
                                        try{
                                            DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                        }catch(Exception e){System.out.println("[exception] "+e.toString());}                                    
                                    }
                                }
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                            }
                            
                        }else{ //jika sudah lunas
                            
                            IrigasiTransaction irigasiTransaction = new IrigasiTransaction();
                            
                            try {
                                irigasiTransaction = DbIrigasiTransaction.fetchExc(crmPost.getIrigasiTransactionId());
                            } catch (Exception e){ System.out.println("[exception] "+e.toString()); }
                            
                            double amount = (crmPost.getAmount() * crmPost.getBookedRate()) + irigasiTransaction.getDendaDiakui();
                            
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);  
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){ System.out.println("[exception] "+e.toString()); }
                            
                            if(oidCashReceive != 0){
                                double amountCrd = crmPost.getAmount() * crmPost.getBookedRate();
                                if(amountCrd != 0){
                                    //cash detail Credit
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getIrigasiDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate()); 
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount()); 
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                  
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());} 
                                }
                                double amountCrd2 = irigasiTransaction.getDendaDiakui();
                                if(amountCrd2 != 0){
                                    CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                    cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                    cashreceiveDetailCredit2.setAmount(irigasiTransaction.getDendaDiakui());  
                                    cashreceiveDetailCredit2.setForeignAmount(irigasiTransaction.getDendaDiakui()/crmPost.getBookedRate());  
                                    cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}   
                                }
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                            }   
                        }   
                        
                     }else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMIN){ // jika termasuk pembayaran komin
                         
                         boolean stsKomin = DbPembayaran.stsPembayaranSewaTanahInvoice(crmPost.getSewaTanahInvoiceId());
                         
                         if (stsKomin == false) {
                            
                            double amount = (crmPost.getAmount() * crmPost.getBookedRate()) + (selisih * crmPost.getBookedRate());
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);                           
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){
                                System.out.println("[exception] "+e.toString());
                            }
                            
                            if(oidCashReceive != 0){
                                double amountCrd = crmPost.getAmount() * crmPost.getBookedRate();
                                if(amountCrd != 0){
                                    //cash detail Credit
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getKominDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());  
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}
                                }
                                
                                if(selisih != 0){
                                    double amountCrd2 = selisih * crmPost.getBookedRate();
                                    if(amountCrd2 != 0){
                                        CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                        cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                        cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                        cashreceiveDetailCredit2.setAmount(selisih * crmPost.getBookedRate());  
                                        cashreceiveDetailCredit2.setForeignAmount(selisih);  
                                        cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                        cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                        cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                        cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                                
                                
                                        try{
                                            DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                        }catch(Exception e){System.out.println("[exception] "+e.toString());}                                    
                                    }
                                }
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                            }
                                
                         }else{                            
                            SewaTanahInvoice sewaTanahInvoice = new SewaTanahInvoice();                            
                            try {
                                sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(crmPost.getSewaTanahInvoiceId());
                            } catch (Exception e){ System.out.println("[exception] "+e.toString()); }
                            
                            double amount = (crmPost.getAmount() * crmPost.getBookedRate()) + (sewaTanahInvoice.getDendaDiakui());
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);  
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){ System.out.println("[exception] "+e.toString()); }
                            
                            if(oidCashReceive != 0){
                                double amountCrd = crmPost.getAmount() * crmPost.getBookedRate();
                                if(amountCrd != 0){
                                    //cash detail Credit
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getKominDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                  
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());} 
                                }
                                
                                double amountCrd2 = sewaTanahInvoice.getDendaDiakui();
                                if(amountCrd2 != 0){
                                    CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                    cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                    cashreceiveDetailCredit2.setAmount(sewaTanahInvoice.getDendaDiakui());  
                                    cashreceiveDetailCredit2.setForeignAmount(sewaTanahInvoice.getDendaDiakui()/crmPost.getBookedRate());
                                    cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}                                 
                                }                                
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                            } 
                             
                         }
                    }else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_ASSESMENT){ // jika termasuk pembayaran asessment
                         
                         boolean stsAssesment = DbPembayaran.stsPembayaranSewaTanahInvoice(crmPost.getSewaTanahInvoiceId());
                         
                         if (stsAssesment == false) {
                            
                            double amount =  (crmPost.getAmount() * crmPost.getBookedRate()) + selisih * crmPost.getBookedRate();
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);                           
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){
                                System.out.println("[exception] "+e.toString());
                            }
                            
                            if(oidCashReceive != 0){
                                
                                double amountCrd = crmPost.getAmount() * crmPost.getBookedRate();
                                if(amountCrd != 0){
                                    //cash detail Credit
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getAssesmentDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate()); 
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}
                                }
                                
                                double amountCrd2 = selisih * crmPost.getBookedRate();
                                if(amountCrd2 != 0){                                    
                                    if(selisih != 0){                                    
                                        CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                        cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                        cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                        cashreceiveDetailCredit2.setAmount(selisih * crmPost.getBookedRate());  
                                        cashreceiveDetailCredit2.setForeignAmount(selisih);
                                        cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                        cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                        cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                        cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                                                                
                                        try{
                                            DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                        }catch(Exception e){System.out.println("[exception] "+e.toString());}                                    
                                    }
                                }
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                            }
                                
                         }else{
                            
                            SewaTanahInvoice sewaTanahInvoice = new SewaTanahInvoice();
                            
                            try {
                                sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(crmPost.getSewaTanahInvoiceId());
                            } catch (Exception e){ System.out.println("[exception] "+e.toString()); }
                            double amount = (crmPost.getAmount() * crmPost.getBookedRate()) + (sewaTanahInvoice.getDendaDiakui());
                            
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);  
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){ System.out.println("[exception] "+e.toString()); }
                            
                            if(oidCashReceive != 0){
                                double amountCrd = crmPost.getAmount() * crmPost.getBookedRate();
                                
                                if(amountCrd != 0){
                                    //cash detail Credit
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getAssesmentDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());  
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                  
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());} 
                                }
                                
                                double amountCrd2 = sewaTanahInvoice.getDendaDiakui();
                                
                                if(amountCrd2 != 0 ){
                                    CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                    cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                    cashreceiveDetailCredit2.setAmount(sewaTanahInvoice.getDendaDiakui());  
                                    cashreceiveDetailCredit2.setForeignAmount(sewaTanahInvoice.getDendaDiakui()/crmPost.getBookedRate());  
                                    cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}                                 
                                }
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                            }                              
                         }
                    }else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMPER){ //jika termasuk pembayaran komper
                         
                         boolean stsKomper = DbPembayaran.stsPembayaranSewaTanahInvoice(crmPost.getSewaTanahInvoiceId());
                         
                         if (stsKomper == false){
                            
                            double amount = (crmPost.getAmount() * crmPost.getBookedRate()) + (selisih * crmPost.getBookedRate());
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);                                             
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){
                                System.out.println("[exception] "+e.toString());
                            }
                            
                            if(oidCashReceive != 0){
                                
                                double amountCrd = (crmPost.getAmount() * crmPost.getBookedRate());
                                if(amountCrd != 0){
                                    //cash detail Credit
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getKominDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}
                                }
                                
                                double amountCrd2 = selisih * crmPost.getBookedRate();
                                
                                if(amountCrd2 != 0){
                                    if(selisih != 0){                                    
                                        CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                        cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                        cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                        cashreceiveDetailCredit2.setAmount(selisih * crmPost.getBookedRate());  
                                        cashreceiveDetailCredit2.setForeignAmount(selisih);
                                        cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                        cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                        cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                        cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                               
                                
                                        try{
                                            DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                        }catch(Exception e){System.out.println("[exception] "+e.toString());}                                    
                                    }
                                }
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                            }                                
                         }else{
                            
                            SewaTanahBenefit sewaTanahBenefit = new SewaTanahBenefit();
                            
                            try {
                                sewaTanahBenefit = DbSewaTanahBenefit.fetchExc(crmPost.getSewaTanahBenefitId());
                            } catch (Exception e){ System.out.println("[exception] "+e.toString()); }
                            
                            double amount = (crmPost.getAmount() * crmPost.getBookedRate()) + sewaTanahBenefit.getDendaDiakui();
                            cashreceive.setCoaId(crmPost.getPaymentAccountId());
                            cashreceive.setAmount(amount);  
                            
                            try{
                                oidCashReceive = DbCashReceive.insertExc(cashreceive);
                            }catch(Exception e){ System.out.println("[exception] "+e.toString()); }
                            
                            if(oidCashReceive != 0){
                                double amountCrd = crmPost.getAmount() * crmPost.getBookedRate();
                                if(amountCrd != 0){
                                    //cash detail Credit
                                    CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                                    cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit.setCoaId(crmPost.getKominDebetAccountId());
                                    cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                                    cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());
                                    cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                  
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());} 
                                }
                                
                                double amountCrd2 = sewaTanahBenefit.getDendaDiakui();
                                if(amountCrd2 != 0){
                                    CashReceiveDetail cashreceiveDetailCredit2 = new CashReceiveDetail();
                                    cashreceiveDetailCredit2.setBookedRate(crmPost.getBookedRate());
                                    cashreceiveDetailCredit2.setCoaId(crmPost.getPendapatanTerimaDiMukaAccountId());
                                    cashreceiveDetailCredit2.setAmount(sewaTanahBenefit.getDendaDiakui());  
                                    cashreceiveDetailCredit2.setForeignAmount(sewaTanahBenefit.getDendaDiakui()/crmPost.getBookedRate());
                                    cashreceiveDetailCredit2.setMemo(crmPost.getMemo());
                                    cashreceiveDetailCredit2.setDepartmentId(crmPost.getDepartmentId());
                                    cashreceiveDetailCredit2.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                    cashreceiveDetailCredit2.setCashReceiveId(oidCashReceive);                                
                                
                                    try{
                                        DbCashReceiveDetail.insertExc(cashreceiveDetailCredit2);
                                    }catch(Exception e){System.out.println("[exception] "+e.toString());}                                 
                                }
                                DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                            } 
                         }
                    }

                } else { // jika pembayarannya belum lunas
                    
                    if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_LIMBAH){
                        
                        cashreceive.setCoaId(crmPost.getPaymentAccountId());
                        cashreceive.setAmount(crmPost.getAmount() * crmPost.getBookedRate());    
                        
                        try{
                            oidCashReceive = DbCashReceive.insertExc(cashreceive);
                        }catch(Exception e){System.out.println("[exception] "+e.toString());}
                        
                        if(oidCashReceive != 0){
                            CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                            cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                            cashreceiveDetailCredit.setCoaId(crmPost.getLimbahDebetAccountId());
                            cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                            cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());
                            cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                            cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                            cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                            cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                                                  
                            try{
                                DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                            }catch(Exception e){System.out.println("[exception] "+e.toString());}      
                            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                        }
                         
                    }else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_IRIGASI){
                        cashreceive.setCoaId(crmPost.getPaymentAccountId());
                        cashreceive.setAmount(crmPost.getAmount() * crmPost.getBookedRate());          
                        
                        long oid = 0;
                        try{
                            oid = DbCashReceive.insertExc(cashreceive);
                        }catch(Exception e){System.out.println("[exception] "+e.toString());}
                        
                        if(oid != 0){
                            CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                            cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);
                            cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                            cashreceiveDetailCredit.setCoaId(crmPost.getIrigasiDebetAccountId());
                            cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                            cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());
                            cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                            cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                            cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                            cashreceiveDetailCredit.setCashReceiveId(oid);                                                  
                            try{
                                DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                            }catch(Exception e){System.out.println("[exception] "+e.toString());}       
                            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                        }
                    }else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMIN){
                        cashreceive.setCoaId(crmPost.getPaymentAccountId());
                        cashreceive.setAmount(crmPost.getAmount() * crmPost.getBookedRate());          
                        
                        try{
                            oidCashReceive = DbCashReceive.insertExc(cashreceive);
                        }catch(Exception e){System.out.println("[exception] "+e.toString());}
                        
                        if(oidCashReceive != 0){
                            CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                            cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);
                            cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                            cashreceiveDetailCredit.setCoaId(crmPost.getKominDebetAccountId());
                            cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                            cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());
                            cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                            cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                            cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                                                                       
                            try{
                                DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                            }catch(Exception e){System.out.println("[exception] "+e.toString());}       
                            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                        }
                    }else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_ASSESMENT){
                        
                        cashreceive.setCoaId(crmPost.getPaymentAccountId());
                        cashreceive.setAmount(crmPost.getAmount() * crmPost.getBookedRate());          
                        
                        try{
                            oidCashReceive = DbCashReceive.insertExc(cashreceive);
                        }catch(Exception e){System.out.println("[exception] "+e.toString());}
                        
                        if(oidCashReceive != 0){
                            CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                            cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                            cashreceiveDetailCredit.setCoaId(crmPost.getAssesmentDebetAccountId());
                            cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                            cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());
                            cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                            cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                            cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                            cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);                                                  
                            try{
                                DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                            }catch(Exception e){System.out.println("[exception] "+e.toString());}   
                            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                        }
                    }else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMPER){
                        
                        cashreceive.setCoaId(crmPost.getPaymentAccountId());
                        cashreceive.setAmount(crmPost.getAmount() * crmPost.getBookedRate());          
                        
                        try{
                            oidCashReceive = DbCashReceive.insertExc(cashreceive);
                        }catch(Exception e){System.out.println("[exception] "+e.toString());}
                        
                        if(oidCashReceive != 0){
                            CashReceiveDetail cashreceiveDetailCredit = new CashReceiveDetail();
                            cashreceiveDetailCredit.setBookedRate(crmPost.getBookedRate());
                            cashreceiveDetailCredit.setCoaId(crmPost.getKomperDebetAccountId());
                            cashreceiveDetailCredit.setAmount(crmPost.getAmount() * crmPost.getBookedRate());  
                            cashreceiveDetailCredit.setForeignAmount(crmPost.getAmount());
                            cashreceiveDetailCredit.setMemo(crmPost.getMemo());
                            cashreceiveDetailCredit.setDepartmentId(crmPost.getDepartmentId());
                            cashreceiveDetailCredit.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                            cashreceiveDetailCredit.setCashReceiveId(oidCashReceive);     
                            
                            try{
                                DbCashReceiveDetail.insertExc(cashreceiveDetailCredit);
                            }catch(Exception e){System.out.println("[exception] "+e.toString());}           
                            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, oidCashReceive, cashreceive.getAmount(), cashreceive.getOperatorId());            
                        }
                    }
                }
                
                return oidCashReceive;
            }
            
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        return 0;
    }

    public long updateBKMv1(CrmPost crmPost) {

        return 0;
    }
    
    /**
     * Get Cash in transit, used in modul Cash Register. Cash in transit is cash receive not yet posted
     * by gwawan 201204
     * @param selectedDate Selected date
     * @param oidCoa OID from COA
     * @return
     */
    public static Vector getCashInTransit(Date selectedDate, long oidCoa) {
        Vector list = new Vector();
        try {
            String where = "(TO_DAYS("+ DbCashReceive.colNames[DbCashReceive.COL_TRANS_DATE] +")" +
                    " <= TO_DAYS('"+ JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") +"'))"+
                    " AND "+ DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_COA_ID] +" = "+ oidCoa+
                    " AND "+ DbCashReceive.colNames[DbCashReceive.COL_POSTED_STATUS] +"="+ DbGl.NOT_POSTED;
            String order = DbCashReceive.colNames[DbCashReceive.COL_TRANS_DATE]+", "+
                    DbCashReceive.colNames[DbCashReceive.COL_JOURNAL_NUMBER];
            
            list = list(0, 0, where, order);
        }catch(Exception e) {
            System.out.println("Exception while getCashInTransit(#,# : "+ e.toString());
        }
        return list;
    }
    
    /**
     * Fungsi untuk mengambil total penerimaan kas yang masih dalam proses (DRAFT)
     * by gwawan 201209
     * @param selectedDate
     * @param oidCoa
     * @return
     */
    public static double getTotalCashReceiveDraft(Date selectedDate, long oidCoa) {
        double openingBalance = 0;
        CONResultSet crs = null;
        String sql = "";
        try {
            sql = "SELECT SUM("+ colNames[DbCashReceive.COL_AMOUNT] +") FROM "+ DB_CASH_RECEIVE+
                    " WHERE "+ colNames[COL_TRANS_DATE] +" < " +
                    " '"+ JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") +"' "+
                    " AND "+ colNames[COL_COA_ID] +" = "+ oidCoa+
                    " AND "+ colNames[COL_POSTED_STATUS] +"="+ DbGl.NOT_POSTED;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()) {
                openingBalance = rs.getDouble(1);
            }
            
        } catch(Exception e) {
            System.out.println("Exception on getTotalCashReceiveDraft(#,#) : "+sql);
        } finally {
            CONResultSet.close(crs);
        }
        return openingBalance;
    }
    
    /**
     * Fungsi untuk mengambil penerimaan kas yang masih dalam proses (DRAFT).
     * Untuk penerimaan kas yang POSTED, data sudah menjadi satu di GL.
     * by gwawan 201209
     * @param userId
     * @param coaId
     * @param date
     * @return
     */
    public static Vector getCashRegister(long userId, long coaId, Date date) {
        Vector result = new Vector();
        try {
            String where = "(TO_DAYS("+ colNames[COL_TRANS_DATE] +") = TO_DAYS('"+ JSPFormater.formatDate(date, "yyyy-MM-dd") +"'))"+
                    " AND "+ colNames[COL_COA_ID] +" = "+ coaId+" AND "+ colNames[COL_POSTED_STATUS] +"="+ DbGl.NOT_POSTED;
            
            Vector list = list(0, 0, where, "");
            
            if(list != null && list.size() > 0) {
                for(int i=0; i<list.size(); i++) {
                    CashReceive cashReceive = (CashReceive)list.get(i);
                    
                    CashRegister cashRegister = new CashRegister();
                    cashRegister.setOID(cashReceive.getOID());
                    cashRegister.setUserId(userId);
                    cashRegister.setDocNumber(cashReceive.getJournalNumber());
                    cashRegister.setTransDate(cashReceive.getTransDate());
                    cashRegister.setCheckBGNumber("");
                    cashRegister.setName(cashReceive.getReceiveFromName());
                    cashRegister.setDescription(cashReceive.getMemo());
                    cashRegister.setDebet(cashReceive.getAmount());
                    cashRegister.setCredit(0);
                    cashRegister.setStatus(cashReceive.getPostedStatus());
                    
                    result.add(cashRegister);
                }
            }
        }catch(Exception e) {
            System.out.println("[Exception] while getCashRegister(#,#,#) "+ e.toString());
        }
        return result;
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
            String sql = "SELECT COUNT(DISTINCT " + DB_CASH_RECEIVE + "." + colNames[COL_CASH_RECEIVE_ID] + ")" +
                    " FROM " + DB_CASH_RECEIVE + " INNER JOIN " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL +
                    " ON " + DB_CASH_RECEIVE + "." + colNames[COL_CASH_RECEIVE_ID] +
                    " = " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + "." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] +
                    " INNER JOIN " + DbCoa.DB_COA +
                    " ON " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + "." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_COA_ID] +
                    " = " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_COA_ID];
            
            String whereClause = "";
            
            if(sNumber != null && sNumber.length() > 0) {
                whereClause = DB_CASH_RECEIVE + "." + colNames[COL_JOURNAL_NUMBER] + " LIKE '%" + sNumber + "%'";
            }
            
            if(sNote != null && sNote.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DB_CASH_RECEIVE + "." + colNames[COL_MEMO] + " LIKE '%" + sNote + "%'" +
                        " OR " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + "." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_MEMO] + " LIKE '%" + sNote + "%')";
            }
            
            if(sAmount != null && sAmount.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += DB_CASH_RECEIVE + "." + colNames[COL_AMOUNT] + " LIKE '%" + sAmount + "%'";
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
            String sql = "SELECT DISTINCT " + DB_CASH_RECEIVE + ".*" +
                    " FROM " + DB_CASH_RECEIVE + " INNER JOIN " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL +
                    " ON " + DB_CASH_RECEIVE + "." + colNames[COL_CASH_RECEIVE_ID] +
                    " = " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + "." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] +
                    " INNER JOIN " + DbCoa.DB_COA +
                    " ON " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + "." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_COA_ID] +
                    " = " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_COA_ID];
            
            String whereClause = "";
            
            if(sNumber != null && sNumber.length() > 0) {
                whereClause = DB_CASH_RECEIVE + "." + colNames[COL_JOURNAL_NUMBER] + " LIKE '%" + sNumber + "%'";
            }
            
            if(sNote != null && sNote.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DB_CASH_RECEIVE + "." + colNames[COL_MEMO] + " LIKE '%" + sNote + "%'" +
                        " OR " + DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL + "." + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_MEMO] + " LIKE '%" + sNote + "%')";
            }
            
            if(sAmount != null && sAmount.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += DB_CASH_RECEIVE + "." + colNames[COL_AMOUNT] + " LIKE '%" + sAmount + "%'";
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
                CashReceive cashreceive = new CashReceive();
                resultToObject(rs, cashreceive);
                lists.add(cashreceive);
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
    
    /**
     * Get cash receive from advance
     * create by gwawan 201209
     * @param oidCashAdvance
     * @return
     */
    public static CashReceive getCashAdvanceRefund(long oidCashAdvance) {
        CashReceive cashReceive = new CashReceive();
        Vector list = list( 0, 0, colNames[COL_REFERENSI_ID]+"="+oidCashAdvance, "");
        if(list != null && list.size() > 0) {
            cashReceive = (CashReceive)list.get(0);
        }
        return cashReceive;
    }
}
