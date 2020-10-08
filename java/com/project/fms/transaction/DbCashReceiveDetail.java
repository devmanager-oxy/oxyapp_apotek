package com.project.fms.transaction;

import com.project.fms.master.DbCoa;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;
import com.project.*;
import com.project.general.*;

public class DbCashReceiveDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_CASH_RECEIVE_DETAIL = "cash_receive_detail";
    public static final int COL_CASH_RECEIVE_ID = 0;
    public static final int COL_CASH_RECEIVE_DETAIL_ID = 1;
    public static final int COL_COA_ID = 2;
    public static final int COL_FOREIGN_CURRENCY_ID = 3;
    public static final int COL_FOREIGN_AMOUNT = 4;
    public static final int COL_BOOKED_RATE = 5;
    public static final int COL_AMOUNT = 6;
    public static final int COL_MEMO = 7;
    public static final int COL_CUSTOMER_ID = 8;
    public static final int COL_BYMHD_COA_ID = 9;
    public static final int COL_SEGMENT1_ID = 10;
    public static final int COL_SEGMENT2_ID = 11;
    public static final int COL_SEGMENT3_ID = 12;
    public static final int COL_SEGMENT4_ID = 13;
    public static final int COL_SEGMENT5_ID = 14;
    public static final int COL_SEGMENT6_ID = 15;
    public static final int COL_SEGMENT7_ID = 16;
    public static final int COL_SEGMENT8_ID = 17;
    public static final int COL_SEGMENT9_ID = 18;
    public static final int COL_SEGMENT10_ID = 19;
    public static final int COL_SEGMENT11_ID = 20;
    public static final int COL_SEGMENT12_ID = 21;
    public static final int COL_SEGMENT13_ID = 22;
    public static final int COL_SEGMENT14_ID = 23;
    public static final int COL_SEGMENT15_ID = 24;
    public static final int COL_DEPARTMENT_ID = 25;
    //add by roy andika : sesuai permintaan ibu desa (BTDC)
    public static final int COL_FOREIGN_CREDIT_AMOUNT = 26;
    public static final int COL_CREDIT_AMOUNT = 27;
    
    public static final String[] colNames = {
        "cash_receive_id",
        "cash_receive_detail_id",
        "coa_id",
        "foreign_currency_id",
        "foreign_amount",
        "booked_rate",
        "amount",
        "memo",
        "customer_id",
        "bymhd_coa_id",
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
        "department_id",
        "foreign_credit_amount",
        "credit_amount"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
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
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    public DbCashReceiveDetail() {
    }

    public DbCashReceiveDetail(int i) throws CONException {
        super(new DbCashReceiveDetail());
    }

    public DbCashReceiveDetail(String sOid) throws CONException {
        super(new DbCashReceiveDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCashReceiveDetail(long lOid) throws CONException {
        super(new DbCashReceiveDetail(0));
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
        return DB_CASH_RECEIVE_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCashReceiveDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CashReceiveDetail cashreceivedetail = fetchExc(ent.getOID());
        ent = (Entity) cashreceivedetail;
        return cashreceivedetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CashReceiveDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CashReceiveDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CashReceiveDetail fetchExc(long oid) throws CONException {
        try {
            CashReceiveDetail cashreceivedetail = new CashReceiveDetail();
            DbCashReceiveDetail pstCashReceiveDetail = new DbCashReceiveDetail(oid);
            cashreceivedetail.setOID(oid);

            cashreceivedetail.setCashReceiveId(pstCashReceiveDetail.getlong(COL_CASH_RECEIVE_ID));
            cashreceivedetail.setCoaId(pstCashReceiveDetail.getlong(COL_COA_ID));
            cashreceivedetail.setForeignCurrencyId(pstCashReceiveDetail.getlong(COL_FOREIGN_CURRENCY_ID));
            cashreceivedetail.setForeignAmount(pstCashReceiveDetail.getdouble(COL_FOREIGN_AMOUNT));
            cashreceivedetail.setBookedRate(pstCashReceiveDetail.getdouble(COL_BOOKED_RATE));
            cashreceivedetail.setAmount(pstCashReceiveDetail.getdouble(COL_AMOUNT));
            cashreceivedetail.setMemo(pstCashReceiveDetail.getString(COL_MEMO));
            cashreceivedetail.setCustomerId(pstCashReceiveDetail.getlong(COL_CUSTOMER_ID));
            cashreceivedetail.setBymhdCoaId(pstCashReceiveDetail.getlong(COL_BYMHD_COA_ID));

            cashreceivedetail.setSegment1Id(pstCashReceiveDetail.getlong(COL_SEGMENT1_ID));
            cashreceivedetail.setSegment2Id(pstCashReceiveDetail.getlong(COL_SEGMENT2_ID));
            cashreceivedetail.setSegment3Id(pstCashReceiveDetail.getlong(COL_SEGMENT3_ID));
            cashreceivedetail.setSegment4Id(pstCashReceiveDetail.getlong(COL_SEGMENT4_ID));
            cashreceivedetail.setSegment5Id(pstCashReceiveDetail.getlong(COL_SEGMENT5_ID));
            cashreceivedetail.setSegment6Id(pstCashReceiveDetail.getlong(COL_SEGMENT6_ID));
            cashreceivedetail.setSegment7Id(pstCashReceiveDetail.getlong(COL_SEGMENT7_ID));
            cashreceivedetail.setSegment8Id(pstCashReceiveDetail.getlong(COL_SEGMENT8_ID));
            cashreceivedetail.setSegment9Id(pstCashReceiveDetail.getlong(COL_SEGMENT9_ID));
            cashreceivedetail.setSegment10Id(pstCashReceiveDetail.getlong(COL_SEGMENT10_ID));
            cashreceivedetail.setSegment11Id(pstCashReceiveDetail.getlong(COL_SEGMENT11_ID));
            cashreceivedetail.setSegment12Id(pstCashReceiveDetail.getlong(COL_SEGMENT12_ID));
            cashreceivedetail.setSegment13Id(pstCashReceiveDetail.getlong(COL_SEGMENT13_ID));
            cashreceivedetail.setSegment14Id(pstCashReceiveDetail.getlong(COL_SEGMENT14_ID));
            cashreceivedetail.setSegment15Id(pstCashReceiveDetail.getlong(COL_SEGMENT15_ID));
            cashreceivedetail.setDepartmentId(pstCashReceiveDetail.getlong(COL_DEPARTMENT_ID));
            
            cashreceivedetail.setForeignCreditAmount(pstCashReceiveDetail.getdouble(COL_FOREIGN_CREDIT_AMOUNT));
            cashreceivedetail.setCreditAmount(pstCashReceiveDetail.getdouble(COL_CREDIT_AMOUNT));

            return cashreceivedetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashReceiveDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(CashReceiveDetail cashreceivedetail) throws CONException {
        try {
            DbCashReceiveDetail pstCashReceiveDetail = new DbCashReceiveDetail(0);

            pstCashReceiveDetail.setLong(COL_CASH_RECEIVE_ID, cashreceivedetail.getCashReceiveId());
            pstCashReceiveDetail.setLong(COL_COA_ID, cashreceivedetail.getCoaId());
            pstCashReceiveDetail.setLong(COL_FOREIGN_CURRENCY_ID, cashreceivedetail.getForeignCurrencyId());
            pstCashReceiveDetail.setDouble(COL_FOREIGN_AMOUNT, cashreceivedetail.getForeignAmount());
            pstCashReceiveDetail.setDouble(COL_BOOKED_RATE, cashreceivedetail.getBookedRate());
            pstCashReceiveDetail.setDouble(COL_AMOUNT, cashreceivedetail.getAmount());
            pstCashReceiveDetail.setString(COL_MEMO, cashreceivedetail.getMemo());
            pstCashReceiveDetail.setLong(COL_CUSTOMER_ID, cashreceivedetail.getCustomerId());
            pstCashReceiveDetail.setLong(COL_BYMHD_COA_ID, cashreceivedetail.getBymhdCoaId());

            pstCashReceiveDetail.setLong(COL_SEGMENT1_ID, cashreceivedetail.getSegment1Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT2_ID, cashreceivedetail.getSegment2Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT3_ID, cashreceivedetail.getSegment3Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT4_ID, cashreceivedetail.getSegment4Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT5_ID, cashreceivedetail.getSegment5Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT6_ID, cashreceivedetail.getSegment6Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT7_ID, cashreceivedetail.getSegment7Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT8_ID, cashreceivedetail.getSegment8Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT9_ID, cashreceivedetail.getSegment9Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT10_ID, cashreceivedetail.getSegment10Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT11_ID, cashreceivedetail.getSegment11Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT12_ID, cashreceivedetail.getSegment12Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT13_ID, cashreceivedetail.getSegment13Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT14_ID, cashreceivedetail.getSegment14Id());
            pstCashReceiveDetail.setLong(COL_SEGMENT15_ID, cashreceivedetail.getSegment15Id());
            pstCashReceiveDetail.setLong(COL_DEPARTMENT_ID, cashreceivedetail.getDepartmentId());
            pstCashReceiveDetail.setDouble(COL_FOREIGN_CREDIT_AMOUNT, cashreceivedetail.getForeignCreditAmount());
            pstCashReceiveDetail.setDouble(COL_CREDIT_AMOUNT, cashreceivedetail.getCreditAmount());

            pstCashReceiveDetail.insert();
            cashreceivedetail.setOID(pstCashReceiveDetail.getlong(COL_CASH_RECEIVE_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashReceiveDetail(0), CONException.UNKNOWN);
        }
        return cashreceivedetail.getOID();
    }

    public static long updateExc(CashReceiveDetail cashreceivedetail) throws CONException {
        try {
            if (cashreceivedetail.getOID() != 0) {
                DbCashReceiveDetail pstCashReceiveDetail = new DbCashReceiveDetail(cashreceivedetail.getOID());

                pstCashReceiveDetail.setLong(COL_CASH_RECEIVE_ID, cashreceivedetail.getCashReceiveId());
                pstCashReceiveDetail.setLong(COL_COA_ID, cashreceivedetail.getCoaId());
                pstCashReceiveDetail.setLong(COL_FOREIGN_CURRENCY_ID, cashreceivedetail.getForeignCurrencyId());
                pstCashReceiveDetail.setDouble(COL_FOREIGN_AMOUNT, cashreceivedetail.getForeignAmount());
                pstCashReceiveDetail.setDouble(COL_BOOKED_RATE, cashreceivedetail.getBookedRate());
                pstCashReceiveDetail.setDouble(COL_AMOUNT, cashreceivedetail.getAmount());
                pstCashReceiveDetail.setString(COL_MEMO, cashreceivedetail.getMemo());
                pstCashReceiveDetail.setLong(COL_CUSTOMER_ID, cashreceivedetail.getCustomerId());
                pstCashReceiveDetail.setLong(COL_BYMHD_COA_ID, cashreceivedetail.getBymhdCoaId());

                pstCashReceiveDetail.setLong(COL_SEGMENT1_ID, cashreceivedetail.getSegment1Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT2_ID, cashreceivedetail.getSegment2Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT3_ID, cashreceivedetail.getSegment3Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT4_ID, cashreceivedetail.getSegment4Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT5_ID, cashreceivedetail.getSegment5Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT6_ID, cashreceivedetail.getSegment6Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT7_ID, cashreceivedetail.getSegment7Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT8_ID, cashreceivedetail.getSegment8Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT9_ID, cashreceivedetail.getSegment9Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT10_ID, cashreceivedetail.getSegment10Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT11_ID, cashreceivedetail.getSegment11Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT12_ID, cashreceivedetail.getSegment12Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT13_ID, cashreceivedetail.getSegment13Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT14_ID, cashreceivedetail.getSegment14Id());
                pstCashReceiveDetail.setLong(COL_SEGMENT15_ID, cashreceivedetail.getSegment15Id());
                pstCashReceiveDetail.setLong(COL_DEPARTMENT_ID, cashreceivedetail.getDepartmentId());                
                pstCashReceiveDetail.setDouble(COL_FOREIGN_CREDIT_AMOUNT, cashreceivedetail.getForeignCreditAmount());
                pstCashReceiveDetail.setDouble(COL_CREDIT_AMOUNT, cashreceivedetail.getCreditAmount());

                pstCashReceiveDetail.update();
                return cashreceivedetail.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashReceiveDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCashReceiveDetail pstCashReceiveDetail = new DbCashReceiveDetail(oid);
            pstCashReceiveDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashReceiveDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_CASH_RECEIVE_DETAIL;
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
                CashReceiveDetail cashreceivedetail = new CashReceiveDetail();
                resultToObject(rs, cashreceivedetail);
                lists.add(cashreceivedetail);
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

    private static void resultToObject(ResultSet rs, CashReceiveDetail cashreceivedetail) {
        try {
            cashreceivedetail.setOID(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_DETAIL_ID]));
            cashreceivedetail.setCashReceiveId(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID]));
            cashreceivedetail.setCoaId(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_COA_ID]));
            cashreceivedetail.setForeignCurrencyId(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_FOREIGN_CURRENCY_ID]));
            cashreceivedetail.setForeignAmount(rs.getDouble(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_FOREIGN_AMOUNT]));
            cashreceivedetail.setBookedRate(rs.getDouble(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_BOOKED_RATE]));
            cashreceivedetail.setAmount(rs.getDouble(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_AMOUNT]));
            cashreceivedetail.setMemo(rs.getString(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_MEMO]));
            cashreceivedetail.setCustomerId(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CUSTOMER_ID]));
            cashreceivedetail.setBymhdCoaId(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_BYMHD_COA_ID]));

            cashreceivedetail.setSegment1Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT1_ID]));
            cashreceivedetail.setSegment2Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT2_ID]));
            cashreceivedetail.setSegment3Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT3_ID]));
            cashreceivedetail.setSegment4Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT4_ID]));
            cashreceivedetail.setSegment5Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT5_ID]));
            cashreceivedetail.setSegment6Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT6_ID]));
            cashreceivedetail.setSegment7Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT7_ID]));
            cashreceivedetail.setSegment8Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT8_ID]));
            cashreceivedetail.setSegment9Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT9_ID]));
            cashreceivedetail.setSegment10Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT10_ID]));
            cashreceivedetail.setSegment11Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT11_ID]));
            cashreceivedetail.setSegment12Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT12_ID]));
            cashreceivedetail.setSegment13Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT13_ID]));
            cashreceivedetail.setSegment14Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT14_ID]));
            cashreceivedetail.setSegment15Id(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_SEGMENT15_ID]));
            cashreceivedetail.setDepartmentId(rs.getLong(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_DEPARTMENT_ID]));            
            cashreceivedetail.setForeignCreditAmount(rs.getDouble(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_FOREIGN_CREDIT_AMOUNT]));
            cashreceivedetail.setCreditAmount(rs.getDouble(DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CREDIT_AMOUNT]));

        } catch (Exception e) {
        }
    }
    
    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_DETAIL_ID] + ") FROM " + DB_CASH_RECEIVE_DETAIL;
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
                    CashReceiveDetail cashreceivedetail = (CashReceiveDetail) list.get(ls);
                    if (oid == cashreceivedetail.getOID()) {
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

    public static void saveAllDetail(CashReceive cashReceive, Vector listCashReceiveDetail) {
        if (listCashReceiveDetail != null && listCashReceiveDetail.size() > 0) {

            //jika bymhd baru, ambil bymhd id dari cash receive
            //jika payment, ambil bymhd dari detail
            for (int i = 0; i < listCashReceiveDetail.size(); i++) {
                CashReceiveDetail crd = (CashReceiveDetail) listCashReceiveDetail.get(i);
                crd.setCashReceiveId(cashReceive.getOID());

                if (cashReceive.getType() == DbCashReceive.TYPE_BYMHD_NEW || cashReceive.getType() == DbCashReceive.TYPE_DP) {
                    crd.setBymhdCoaId(cashReceive.getCoaId());
                } else if (cashReceive.getType() == DbCashReceive.TYPE_BYMHD || cashReceive.getType() == DbCashReceive.TYPE_DP_RETURN) {
                    crd.setBymhdCoaId(crd.getCoaId());
                    crd.setInOut(-1);
                }

                try {
                    if (crd.getOID() == 0) {
                        DbCashReceiveDetail.insertExc(crd);
                    } else {
                        DbCashReceiveDetail.updateExc(crd);
                    }
                } catch (Exception e) {

                }
            }
            
            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM, cashReceive.getOID(), cashReceive.getAmount(), cashReceive.getOperatorId());            
            	
        }

        DbCashReceive.updateAmount(cashReceive);

    }

    public static void saveDetail(CashReceive cashReceive, CashReceiveDetail cashReceiveDetail) {
        //if(listCashReceiveDetail!=null && listCashReceiveDetail.size()>0){

        //jika bymhd baru, ambil bymhd id dari cash receive
        //jika payment, ambil bymhd dari detail
        //  for(int i=0; i<listCashReceiveDetail.size(); i++){
        //CashReceiveDetail crd = (CashReceiveDetail)listCashReceiveDetail.get(i);
        cashReceiveDetail.setCashReceiveId(cashReceive.getOID());

        if (cashReceive.getType() == DbCashReceive.TYPE_BYMHD_NEW || cashReceive.getType() == DbCashReceive.TYPE_DP) {
            cashReceiveDetail.setBymhdCoaId(cashReceive.getCoaId());
        } else if (cashReceive.getType() == DbCashReceive.TYPE_BYMHD || cashReceive.getType() == DbCashReceive.TYPE_DP_RETURN) {
            cashReceiveDetail.setBymhdCoaId(cashReceiveDetail.getCoaId());
            cashReceiveDetail.setInOut(-1);
        }

        try {
            DbCashReceiveDetail.insertExc(cashReceiveDetail);
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        //  }                
        //}

        DbCashReceive.updateAmount(cashReceive);

    }

    /**
     * @Author  Roy Andika
     * @param   coaId
     * @Desc    Untuk mendapatlan nomor rekening yang ada di report BKM
     * @return  
     */
    public static Vector getCodeCoa(long coaId) {

        CONResultSet dbrs = null;

        try {

            String sql = "SELECT " + DbCoa.colNames[DbCoa.COL_CODE] + "," + DbCoa.colNames[DbCoa.COL_NAME] + " FROM " + DbCoa.DB_COA + " WHERE " +
                    DbCoa.colNames[DbCoa.COL_COA_ID] + "=" + coaId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Vector result = new Vector();
                String code = rs.getString(DbCoa.colNames[DbCoa.COL_CODE]);
                String name = rs.getString(DbCoa.colNames[DbCoa.COL_NAME]);

                result.add("" + code);
                result.add("" + name);

                return result;
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;

    }
    
    public static void deleteAllDetail(long cashReceiveId){
            
            if(cashReceiveId != 0){
                
                CONResultSet dbrs = null;
                
                try{
                    
                    String sql = "DELETE FROM "+DbCashReceiveDetail.DB_CASH_RECEIVE_DETAIL+" WHERE "+
                        DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID]+" = "+cashReceiveId;
                
                    CONHandler.execUpdate(sql);
                    
                }catch(Exception e){
                    System.out.println("[exception] "+e.toString());
                }finally{
                    CONResultSet.close(dbrs);
                }
            }
    }
    
}
