package com.project.fms.ar;

import com.project.I_Project;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.fms.master.*;
import com.project.fms.transaction.*;
import com.project.admin.*;
import com.project.crm.project.*;


public class DbArapMemo extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_ARAP_MEMO = "arap_memo";
    public static final int COL_ARAP_MEMO_ID = 0;
    public static final int COL_DATE = 1;
    public static final int COL_POSTED_DATE = 2;
    public static final int COL_USER_ID = 3;
    public static final int COL_POSTED_BY_ID = 4;
    public static final int COL_MEMO = 5;
    public static final int COL_AMOUNT = 6;
    public static final int COL_STATUS = 7;
    public static final int COL_POSTED_STATUS = 8;
    public static final int COL_PAYMENT_STATUS = 9;
    public static final int COL_TYPE = 10;
    public static final int COL_REF_ID = 11;
    public static final int COL_COA_ID = 12;
    public static final int COL_VENDOR_ID = 13;
    public static final int COL_COUNTER = 14;
    public static final int COL_PREFIX_NUMBER = 15;
    public static final int COL_NUMBER = 16;
    public static final int COL_PERIODE_ID = 17;
    public static final int COL_APPROVAL1 = 18;
    public static final int COL_APPROVAL2 = 19;
    public static final int COL_DATE_APP1 = 20;
    public static final int COL_DATE_APP2 = 21;
    public static final int COL_CURRENCY_ID = 22;
    public static final int COL_LOCATION_ID = 23;
    public static final int COL_COA_AP_ID = 24;
    public static final String[] fieldNames = {
        "arap_memo_id",
        "date",
        "posted_date",
        "user_id",
        "posted_by_id",
        "memo",
        "amount",
        "status",
        "posted_status",
        "payment_status",
        "type",
        "ref_id",
        "coa_id",
        "vendor_id",
        "counter",
        "prefix_number",
        "number",
        "periode_id",
        "approval1",
        "approval2",
        "date_app1",
        "date_app2",
        "currency_id",
        "location_id",
        "coa_ap_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };
    public static int TYPE_AP = 0;
    public static int TYPE_AR = 1;
    public static int TYPE_STATUS_DRAFT = 0;
    public static int TYPE_STATUS_APPROVED = 1;
    public static int TYPE_STATUS_POSTED = 2;
    public static final int MEMO_STATUS_DRAFT = 0;
    public static final int MEMO_STATUS_PARTIALY_PAID = 1;
    public static final int MEMO_STATUS_FULL_PAID = 2;

    public DbArapMemo() {
    }

    public DbArapMemo(int i) throws CONException {
        super(new DbArapMemo());
    }

    public DbArapMemo(String sOid) throws CONException {
        super(new DbArapMemo(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbArapMemo(long lOid) throws CONException {
        super(new DbArapMemo(0));
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
        return fieldNames.length;
    }

    public String getTableName() {
        return DB_ARAP_MEMO;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbArapMemo().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ArapMemo arapmemo = fetchExc(ent.getOID());
        ent = (Entity) arapmemo;
        return arapmemo.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ArapMemo) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ArapMemo) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ArapMemo fetchExc(long oid) throws CONException {
        try {
            ArapMemo arapmemo = new ArapMemo();
            DbArapMemo pstArapMemo = new DbArapMemo(oid);
            arapmemo.setOID(oid);

            arapmemo.setDate(pstArapMemo.getDate(COL_DATE));
            arapmemo.setPostedDate(pstArapMemo.getDate(COL_POSTED_DATE));
            arapmemo.setUserId(pstArapMemo.getlong(COL_USER_ID));
            arapmemo.setPostedById(pstArapMemo.getlong(COL_POSTED_BY_ID));
            arapmemo.setMemo(pstArapMemo.getString(COL_MEMO));
            arapmemo.setAmount(pstArapMemo.getdouble(COL_AMOUNT));
            arapmemo.setStatus(pstArapMemo.getInt(COL_STATUS));
            arapmemo.setPostedStatus(pstArapMemo.getInt(COL_POSTED_STATUS));
            arapmemo.setPaymentStatus(pstArapMemo.getInt(COL_PAYMENT_STATUS));
            arapmemo.setType(pstArapMemo.getInt(COL_TYPE));
            arapmemo.setRefId(pstArapMemo.getlong(COL_REF_ID));
            arapmemo.setCoaId(pstArapMemo.getlong(COL_COA_ID));
            arapmemo.setVendorId(pstArapMemo.getlong(COL_VENDOR_ID));
            arapmemo.setCounter(pstArapMemo.getInt(COL_COUNTER));
            arapmemo.setPrefixNumber(pstArapMemo.getString(COL_PREFIX_NUMBER));
            arapmemo.setNumber(pstArapMemo.getString(COL_NUMBER));
            arapmemo.setPeriodeId(pstArapMemo.getlong(COL_PERIODE_ID));
            arapmemo.setApproval1(pstArapMemo.getlong(COL_APPROVAL1));
            arapmemo.setApproval2(pstArapMemo.getlong(COL_APPROVAL2));
            arapmemo.setDateApp1(pstArapMemo.getDate(COL_DATE_APP1));
            arapmemo.setDateApp2(pstArapMemo.getDate(COL_DATE_APP2));
            arapmemo.setCurrencyId(pstArapMemo.getlong(COL_CURRENCY_ID));
            arapmemo.setLocationId(pstArapMemo.getlong(COL_LOCATION_ID));
            arapmemo.setCoaApId(pstArapMemo.getlong(COL_COA_AP_ID));

            return arapmemo;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbArapMemo(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(ArapMemo arapmemo) throws CONException {
        try {
            DbArapMemo pstArapMemo = new DbArapMemo(0);

            pstArapMemo.setDate(COL_DATE, arapmemo.getDate());
            pstArapMemo.setDate(COL_POSTED_DATE, arapmemo.getPostedDate());
            pstArapMemo.setLong(COL_USER_ID, arapmemo.getUserId());
            pstArapMemo.setLong(COL_POSTED_BY_ID, arapmemo.getPostedById());
            pstArapMemo.setString(COL_MEMO, arapmemo.getMemo());
            pstArapMemo.setDouble(COL_AMOUNT, arapmemo.getAmount());
            pstArapMemo.setInt(COL_STATUS, arapmemo.getStatus());
            pstArapMemo.setInt(COL_POSTED_STATUS, arapmemo.getPostedStatus());
            pstArapMemo.setInt(COL_PAYMENT_STATUS, arapmemo.getPaymentStatus());
            pstArapMemo.setInt(COL_TYPE, arapmemo.getType());
            pstArapMemo.setLong(COL_REF_ID, arapmemo.getRefId());
            pstArapMemo.setLong(COL_COA_ID, arapmemo.getCoaId());
            pstArapMemo.setLong(COL_VENDOR_ID, arapmemo.getVendorId());
            pstArapMemo.setInt(COL_COUNTER, arapmemo.getCounter());
            pstArapMemo.setString(COL_PREFIX_NUMBER, arapmemo.getPrefixNumber());
            pstArapMemo.setString(COL_NUMBER, arapmemo.getNumber());
            pstArapMemo.setLong(COL_PERIODE_ID, arapmemo.getPeriodeId());
            pstArapMemo.setLong(COL_APPROVAL1, arapmemo.getApproval1());
            pstArapMemo.setLong(COL_APPROVAL2, arapmemo.getApproval2());
            pstArapMemo.setDate(COL_DATE_APP1, arapmemo.getDateApp1());
            pstArapMemo.setDate(COL_DATE_APP2, arapmemo.getDateApp2());
            pstArapMemo.setLong(COL_CURRENCY_ID, arapmemo.getCurrencyId());
            pstArapMemo.setLong(COL_LOCATION_ID, arapmemo.getLocationId());
            pstArapMemo.setLong(COL_COA_AP_ID, arapmemo.getCoaApId());

            pstArapMemo.insert();
            arapmemo.setOID(pstArapMemo.getlong(COL_ARAP_MEMO_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbArapMemo(0), CONException.UNKNOWN);
        }
        return arapmemo.getOID();
    }

    public static long updateExc(ArapMemo arapmemo) throws CONException {
        try {
            if (arapmemo.getOID() != 0) {
                DbArapMemo pstArapMemo = new DbArapMemo(arapmemo.getOID());

                pstArapMemo.setDate(COL_DATE, arapmemo.getDate());
                pstArapMemo.setDate(COL_POSTED_DATE, arapmemo.getPostedDate());
                pstArapMemo.setLong(COL_USER_ID, arapmemo.getUserId());
                pstArapMemo.setLong(COL_POSTED_BY_ID, arapmemo.getPostedById());
                pstArapMemo.setString(COL_MEMO, arapmemo.getMemo());
                pstArapMemo.setDouble(COL_AMOUNT, arapmemo.getAmount());
                pstArapMemo.setInt(COL_STATUS, arapmemo.getStatus());
                pstArapMemo.setInt(COL_POSTED_STATUS, arapmemo.getPostedStatus());
                pstArapMemo.setInt(COL_PAYMENT_STATUS, arapmemo.getPaymentStatus());
                pstArapMemo.setInt(COL_TYPE, arapmemo.getType());
                pstArapMemo.setLong(COL_REF_ID, arapmemo.getRefId());
                pstArapMemo.setLong(COL_COA_ID, arapmemo.getCoaId());
                pstArapMemo.setLong(COL_VENDOR_ID, arapmemo.getVendorId());
                pstArapMemo.setInt(COL_COUNTER, arapmemo.getCounter());
                pstArapMemo.setString(COL_PREFIX_NUMBER, arapmemo.getPrefixNumber());
                pstArapMemo.setString(COL_NUMBER, arapmemo.getNumber());
                pstArapMemo.setLong(COL_PERIODE_ID, arapmemo.getPeriodeId());
                pstArapMemo.setLong(COL_APPROVAL1, arapmemo.getApproval1());
                pstArapMemo.setLong(COL_APPROVAL2, arapmemo.getApproval2());
                pstArapMemo.setDate(COL_DATE_APP1, arapmemo.getDateApp1());
                pstArapMemo.setDate(COL_DATE_APP2, arapmemo.getDateApp2());
                pstArapMemo.setLong(COL_CURRENCY_ID, arapmemo.getCurrencyId());
                pstArapMemo.setLong(COL_LOCATION_ID, arapmemo.getLocationId());
                pstArapMemo.setLong(COL_COA_AP_ID, arapmemo.getCoaApId());

                pstArapMemo.update();
                return arapmemo.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbArapMemo(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbArapMemo pstArapMemo = new DbArapMemo(oid);
            pstArapMemo.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbArapMemo(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_ARAP_MEMO;
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
                ArapMemo arapmemo = new ArapMemo();
                resultToObject(rs, arapmemo);
                lists.add(arapmemo);
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

    private static void resultToObject(ResultSet rs, ArapMemo arapmemo) {
        try {
            arapmemo.setOID(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_ARAP_MEMO_ID]));
            arapmemo.setDate(rs.getDate(DbArapMemo.fieldNames[DbArapMemo.COL_DATE]));
            arapmemo.setPostedDate(rs.getDate(DbArapMemo.fieldNames[DbArapMemo.COL_POSTED_DATE]));
            arapmemo.setUserId(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_USER_ID]));
            arapmemo.setPostedById(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_POSTED_BY_ID]));
            arapmemo.setMemo(rs.getString(DbArapMemo.fieldNames[DbArapMemo.COL_MEMO]));
            arapmemo.setAmount(rs.getDouble(DbArapMemo.fieldNames[DbArapMemo.COL_AMOUNT]));
            arapmemo.setStatus(rs.getInt(DbArapMemo.fieldNames[DbArapMemo.COL_STATUS]));
            arapmemo.setPostedStatus(rs.getInt(DbArapMemo.fieldNames[DbArapMemo.COL_POSTED_STATUS]));
            arapmemo.setPaymentStatus(rs.getInt(DbArapMemo.fieldNames[DbArapMemo.COL_PAYMENT_STATUS]));
            arapmemo.setType(rs.getInt(DbArapMemo.fieldNames[DbArapMemo.COL_TYPE]));
            arapmemo.setRefId(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_REF_ID]));
            arapmemo.setCoaId(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_COA_ID]));
            arapmemo.setVendorId(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_VENDOR_ID]));
            arapmemo.setCounter(rs.getInt(DbArapMemo.fieldNames[DbArapMemo.COL_COUNTER]));
            arapmemo.setPrefixNumber(rs.getString(DbArapMemo.fieldNames[DbArapMemo.COL_PREFIX_NUMBER]));
            arapmemo.setNumber(rs.getString(DbArapMemo.fieldNames[DbArapMemo.COL_NUMBER]));
            arapmemo.setPeriodeId(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_PERIODE_ID]));
            arapmemo.setApproval1(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_APPROVAL1]));
            arapmemo.setApproval2(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_APPROVAL2]));
            arapmemo.setDateApp1(rs.getDate(DbArapMemo.fieldNames[DbArapMemo.COL_DATE_APP1]));
            arapmemo.setDateApp2(rs.getDate(DbArapMemo.fieldNames[DbArapMemo.COL_DATE_APP2]));
            arapmemo.setCurrencyId(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_CURRENCY_ID]));
            arapmemo.setLocationId(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_LOCATION_ID]));
            arapmemo.setCoaApId(rs.getLong(DbArapMemo.fieldNames[DbArapMemo.COL_COA_AP_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long arapMemoId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_ARAP_MEMO + " WHERE " +
                    DbArapMemo.fieldNames[DbArapMemo.COL_ARAP_MEMO_ID] + " = " + arapMemoId;

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
            String sql = "SELECT COUNT(" + DbArapMemo.fieldNames[DbArapMemo.COL_ARAP_MEMO_ID] + ") FROM " + DB_ARAP_MEMO;
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
                    ArapMemo arapmemo = (ArapMemo) list.get(ls);
                    if (oid == arapmemo.getOID()) {
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

    public static double getInvoiceBalance(long arapMemoId) {
        double result = 0;
        ArapMemo arapMemp = new ArapMemo();

        try {
            arapMemp = DbArapMemo.fetchExc(arapMemoId);
            result = arapMemp.getAmount();

        } catch (Exception e) {
        }

        double payment = DbBankpoPaymentDetail.getTotalPaymentByArapMemo(arapMemp.getOID());

        return result - payment;
    }

    public static void postJournal(ArapMemo arapMemo, long userId) {
        
        ExchangeRate er = DbExchangeRate.getStandardRate();

        try {
            arapMemo = DbArapMemo.fetchExc(arapMemo.getOID());
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        String where = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID]+" = "+arapMemo.getLocationId();
        
        Vector vSd = DbSegmentDetail.list(0, 1, where, null);
        
        SegmentDetail segmentDetail = new SegmentDetail();
        
        if(vSd != null && vSd.size() > 0){
            segmentDetail = (SegmentDetail)vSd.get(0);
        }

        if (arapMemo.getOID() != 0 ) {
            
            String memo = "AP Memo "+arapMemo.getNumber();

            long oid = DbGl.postJournalMain(0, arapMemo.getDate(), arapMemo.getCounter(), arapMemo.getNumber(), arapMemo.getPrefixNumber(), I_Project.JOURNAL_TYPE_AP_MEMO,
                    memo, userId, "", arapMemo.getOID(), "", arapMemo.getDate(), arapMemo.getPeriodeId());

            if (oid != 0) {
                memo = "AP Memo "+arapMemo.getCoaId();
                //Hutang pada other income
                DbGl.postJournalDetail(er.getValueIdr(), arapMemo.getCoaId(), arapMemo.getAmount(), 0,
                                arapMemo.getAmount(), arapMemo.getCurrencyId(), oid, memo, 0,
                                segmentDetail.getOID(), 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);
                
                memo = "AP Memo "+arapMemo.getCoaApId();
                DbGl.postJournalDetail(er.getValueIdr(), arapMemo.getCoaApId(), 0, arapMemo.getAmount(),
                                arapMemo.getAmount(), arapMemo.getCurrencyId(), oid, memo, 0,
                                segmentDetail.getOID(), 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);
             
            }

            //update status
            if (oid != 0) {

                try {

                    arapMemo.setStatus(DbArapMemo.TYPE_STATUS_POSTED);
                    arapMemo.setPostedStatus(1);
                    arapMemo.setPostedById(userId);
                    arapMemo.setPostedDate(new Date());

                    DbArapMemo.updateExc(arapMemo);

                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
            }
        }
    }
}


