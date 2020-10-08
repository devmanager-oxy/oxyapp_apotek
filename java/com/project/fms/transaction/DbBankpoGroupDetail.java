/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

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
public class DbBankpoGroupDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_BANK_PO_GROUP_DETAIL = "bankpo_group_detail";
    
    public static final int COL_BANKPO_GROUP_DETAIL_ID = 0;
    public static final int COL_BANKPO_GROUP_ID = 1;
    public static final int COL_BANKPO_PAYMENT_ID = 2;    
    public static final int COL_DATE = 3;  
    public static final int COL_TYPE = 4;  
    public static final int COL_REF_ID = 5;  
    public static final int COL_VENDOR_ID = 6;  
    public static final int COL_AMOUNT = 7;  
    public static final int COL_COA_ID = 8;  
    public static final int COL_SEGMENT1_ID = 9;  
    
    public static final String[] colNames = {
        "bankpo_group_detail_id",
        "bankpo_group_id",
        "bankpo_payment_id",
        "date",
        "type",
        "ref_id",
        "vendor_id",
        "amount",
        "coa_id",
        "segment1_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG
    };

    public static final int TYPE_BANK_PO = 0;
    public static final int TYPE_GENERAL_LEDGER = 1;
    
    public DbBankpoGroupDetail() {
    }

    public DbBankpoGroupDetail(int i) throws CONException {
        super(new DbBankpoGroupDetail());
    }

    public DbBankpoGroupDetail(String sOid) throws CONException {
        super(new DbBankpoGroupDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBankpoGroupDetail(long lOid) throws CONException {
        super(new DbBankpoGroupDetail(0));
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
        return DB_BANK_PO_GROUP_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBankpoGroupDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BankpoGroupDetail bankpoGroupDetail = fetchExc(ent.getOID());
        ent = (Entity) bankpoGroupDetail;
        return bankpoGroupDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BankpoGroupDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BankpoGroupDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BankpoGroupDetail fetchExc(long oid) throws CONException {
        try {
            BankpoGroupDetail bankpoGroupDetail = new BankpoGroupDetail();
            DbBankpoGroupDetail pstBankpoGroupDetail = new DbBankpoGroupDetail(oid);
            bankpoGroupDetail.setOID(oid);            
            bankpoGroupDetail.setBankpoGroupId(pstBankpoGroupDetail.getlong(COL_BANKPO_GROUP_ID));
            bankpoGroupDetail.setBankpoPaymentId(pstBankpoGroupDetail.getlong(COL_BANKPO_PAYMENT_ID));
            bankpoGroupDetail.setDate(pstBankpoGroupDetail.getDate(COL_DATE));
            bankpoGroupDetail.setType(pstBankpoGroupDetail.getInt(COL_TYPE));
            bankpoGroupDetail.setRefId(pstBankpoGroupDetail.getlong(COL_REF_ID));
            bankpoGroupDetail.setVendorId(pstBankpoGroupDetail.getlong(COL_VENDOR_ID));
            
            bankpoGroupDetail.setAmount(pstBankpoGroupDetail.getdouble(COL_AMOUNT));
            bankpoGroupDetail.setCoaId(pstBankpoGroupDetail.getlong(COL_COA_ID));
            bankpoGroupDetail.setSegment1Id(pstBankpoGroupDetail.getlong(COL_SEGMENT1_ID));
            
            return bankpoGroupDetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoGroupDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BankpoGroupDetail bankpoGroupDetail) throws CONException {
        try {
            DbBankpoGroupDetail pstBankpoGroupDetail = new DbBankpoGroupDetail(0);
            pstBankpoGroupDetail.setLong(COL_BANKPO_GROUP_ID, bankpoGroupDetail.getBankpoGroupId());
            pstBankpoGroupDetail.setLong(COL_BANKPO_PAYMENT_ID, bankpoGroupDetail.getBankpoPaymentId());
            pstBankpoGroupDetail.setDate(COL_DATE, bankpoGroupDetail.getDate());
            pstBankpoGroupDetail.setInt(COL_TYPE, bankpoGroupDetail.getType());
            pstBankpoGroupDetail.setLong(COL_REF_ID, bankpoGroupDetail.getRefId());
            pstBankpoGroupDetail.setLong(COL_VENDOR_ID, bankpoGroupDetail.getVendorId());
            
            pstBankpoGroupDetail.setDouble(COL_AMOUNT, bankpoGroupDetail.getAmount());
            pstBankpoGroupDetail.setLong(COL_COA_ID, bankpoGroupDetail.getCoaId());
            pstBankpoGroupDetail.setLong(COL_SEGMENT1_ID, bankpoGroupDetail.getSegment1Id());
            
            pstBankpoGroupDetail.insert();
            bankpoGroupDetail.setOID(pstBankpoGroupDetail.getlong(COL_BANKPO_GROUP_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoGroupDetail(0), CONException.UNKNOWN);
        }
        return bankpoGroupDetail.getOID();
    }

    public static long updateExc(BankpoGroupDetail bankpoGroupDetail) throws CONException {
        try {
            if (bankpoGroupDetail.getOID() != 0) {
                DbBankpoGroupDetail pstBankpoGroupDetail = new DbBankpoGroupDetail(bankpoGroupDetail.getOID());
                pstBankpoGroupDetail.setLong(COL_BANKPO_GROUP_ID, bankpoGroupDetail.getBankpoGroupId());
                pstBankpoGroupDetail.setLong(COL_BANKPO_PAYMENT_ID, bankpoGroupDetail.getBankpoPaymentId());
                pstBankpoGroupDetail.setDate(COL_DATE, bankpoGroupDetail.getDate());
                pstBankpoGroupDetail.setInt(COL_TYPE, bankpoGroupDetail.getType());
                pstBankpoGroupDetail.setLong(COL_REF_ID, bankpoGroupDetail.getRefId());
                pstBankpoGroupDetail.setLong(COL_VENDOR_ID, bankpoGroupDetail.getVendorId());
                pstBankpoGroupDetail.setDouble(COL_AMOUNT, bankpoGroupDetail.getAmount());
                pstBankpoGroupDetail.setLong(COL_COA_ID, bankpoGroupDetail.getCoaId());
                pstBankpoGroupDetail.setLong(COL_SEGMENT1_ID, bankpoGroupDetail.getSegment1Id());
                pstBankpoGroupDetail.update();
                return bankpoGroupDetail.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoGroupDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBankpoGroupDetail pstBankpoGroupDetail = new DbBankpoGroupDetail(oid);
            pstBankpoGroupDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBankpoGroupDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BANK_PO_GROUP_DETAIL;
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
                BankpoGroupDetail bankpoGroupDetail = new BankpoGroupDetail();
                resultToObject(rs, bankpoGroupDetail);
                lists.add(bankpoGroupDetail);
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

    private static void resultToObject(ResultSet rs, BankpoGroupDetail bankpoGroupDetail) {
        try {
            bankpoGroupDetail.setOID(rs.getLong(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_BANKPO_GROUP_DETAIL_ID]));            
            bankpoGroupDetail.setBankpoGroupId(rs.getLong(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_BANKPO_GROUP_ID]));
            bankpoGroupDetail.setBankpoPaymentId(rs.getLong(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_BANKPO_PAYMENT_ID]));
            bankpoGroupDetail.setDate(rs.getDate(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_DATE]));
            bankpoGroupDetail.setType(rs.getInt(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_TYPE]));
            bankpoGroupDetail.setRefId(rs.getLong(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_REF_ID]));
            bankpoGroupDetail.setVendorId(rs.getLong(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_VENDOR_ID]));
            
            bankpoGroupDetail.setAmount(rs.getDouble(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_AMOUNT]));
            bankpoGroupDetail.setCoaId(rs.getLong(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_COA_ID]));
            bankpoGroupDetail.setSegment1Id(rs.getLong(DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_SEGMENT1_ID]));            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long bankpoGroupDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BANK_PO_GROUP_DETAIL + " WHERE " +
                    DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_BANKPO_GROUP_DETAIL_ID] + " = " + bankpoGroupDetailId;

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
            String sql = "SELECT COUNT(" + DbBankpoGroupDetail.colNames[DbBankpoGroupDetail.COL_BANKPO_GROUP_DETAIL_ID] + ") FROM " + DB_BANK_PO_GROUP_DETAIL;
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
                    BankpoGroupDetail bankpoGroupDetail = (BankpoGroupDetail) list.get(ls);
                    if (oid == bankpoGroupDetail.getOID()) {
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
