/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.posmaster;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;

/**
 *
 * @author Roy Andika
 */
public class DbCashCashier extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_CASH_CASHIER= "pos_cash_cashier";
    public static final int COL_CASH_CASHIER_ID = 0;
    public static final int COL_CASH_MASTER_ID = 1;
    public static final int COL_USER_ID = 2;
    public static final int COL_SHIFT_ID = 3;
    public static final int COL_DATE_OPEN = 4;
    public static final int COL_CURRENCY_ID_OPEN = 5;
    public static final int COL_RATE_OPEN = 6;
    public static final int COL_AMOUNT_OPEN = 7;
    public static final int COL_DATE_CLOSING = 8;
    public static final int COL_CURRENCY_ID_CLOSING = 9;
    public static final int COL_RATE_CLOSING = 10;
    public static final int COL_AMOUNT_CLOSING = 11;
    public static final int COL_STATUS = 12;
    
    public static final String[] colNames = {
        "cash_cashier_id",
        "cash_master_id",
        "user_id",
        "shift_id",
        "date_open",
        "currency_id_open",
        "rate_open",
        "amount_open",
        "date_closing",
        "currency_id_closing",
        "rate_closing",
        "amount_closing",
        "status"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT
    };
    
    public static final int status_opening =0;
    public static final int status_closing =1;

    public DbCashCashier() {
    }

    public DbCashCashier(int i) throws CONException {
        super(new DbCashCashier());
    }

    public DbCashCashier(String sOid) throws CONException {
        super(new DbCashCashier(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCashCashier(long lOid) throws CONException {
        super(new DbCashCashier(0));
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
        return DB_CASH_CASHIER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCashCashier().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CashCashier cashCashier = fetchExc(ent.getOID());
        ent = (Entity) cashCashier;
        return cashCashier.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CashCashier) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CashCashier) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CashCashier fetchExc(long oid) throws CONException {
        try {
            CashCashier cashCashier = new CashCashier();
            DbCashCashier dbCashCashier = new DbCashCashier(oid);
            cashCashier.setOID(oid);

            cashCashier.setCashMasterId(dbCashCashier.getlong(COL_CASH_MASTER_ID));
            cashCashier.setUserId(dbCashCashier.getlong(COL_USER_ID));
            cashCashier.setShiftId(dbCashCashier.getlong(COL_SHIFT_ID));
            cashCashier.setDateOpen(dbCashCashier.getDate(COL_DATE_OPEN));
            cashCashier.setCurrencyIdOpen(dbCashCashier.getlong(COL_CURRENCY_ID_OPEN));
            cashCashier.setRateOpen(dbCashCashier.getdouble(COL_RATE_OPEN));
            cashCashier.setAmountOpen(dbCashCashier.getdouble(COL_AMOUNT_OPEN));
            cashCashier.setDateClosing(dbCashCashier.getDate(COL_DATE_CLOSING));
            cashCashier.setCurrencyIdClosing(dbCashCashier.getlong(COL_CURRENCY_ID_CLOSING));
            cashCashier.setRateClosing(dbCashCashier.getdouble(COL_RATE_CLOSING));
            cashCashier.setAmountClosing(dbCashCashier.getdouble(COL_AMOUNT_CLOSING));
            cashCashier.setStatus(dbCashCashier.getInt(COL_STATUS));
            return cashCashier;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashCashier(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(CashCashier cashCashier) throws CONException {
        try {


            DbCashCashier dbCashCashier = new DbCashCashier(0);

            dbCashCashier.setLong(COL_CASH_MASTER_ID, cashCashier.getCashMasterId());
            dbCashCashier.setLong(COL_USER_ID, cashCashier.getUserId());
            dbCashCashier.setLong(COL_SHIFT_ID, cashCashier.getShiftId());
            dbCashCashier.setDate(COL_DATE_OPEN, cashCashier.getDateOpen());
            dbCashCashier.setLong(COL_CURRENCY_ID_OPEN, cashCashier.getCurrencyIdOpen());
            dbCashCashier.setDouble(COL_RATE_OPEN, cashCashier.getRateOpen());
            dbCashCashier.setDouble(COL_AMOUNT_OPEN, cashCashier.getAmountOpen());
            dbCashCashier.setDate(COL_DATE_CLOSING, cashCashier.getDateClosing());
            dbCashCashier.setLong(COL_CURRENCY_ID_CLOSING, cashCashier.getCurrencyIdClosing());
            dbCashCashier.setDouble(COL_RATE_CLOSING, cashCashier.getRateClosing());
            dbCashCashier.setDouble(COL_AMOUNT_CLOSING, cashCashier.getAmountClosing());
            dbCashCashier.setInt(COL_STATUS, cashCashier.getStatus());
            
            dbCashCashier.insert();
            cashCashier.setOID(dbCashCashier.getlong(COL_CASH_CASHIER_ID));


        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashCashier(0), CONException.UNKNOWN);
        }
        return cashCashier.getOID();
    }

    public static long updateExc( CashCashier cashCashier) throws CONException {
        try {
            if (cashCashier.getOID() != 0) {

                DbCashCashier dbCashCashier = new DbCashCashier(cashCashier.getOID());

                dbCashCashier.setLong(COL_CASH_MASTER_ID, cashCashier.getCashMasterId());
                dbCashCashier.setLong(COL_USER_ID, cashCashier.getUserId());
                dbCashCashier.setLong(COL_SHIFT_ID, cashCashier.getShiftId());
                dbCashCashier.setDate(COL_DATE_OPEN, cashCashier.getDateOpen());
                dbCashCashier.setLong(COL_CURRENCY_ID_OPEN, cashCashier.getCurrencyIdOpen());
                dbCashCashier.setDouble(COL_RATE_OPEN, cashCashier.getRateOpen());
                dbCashCashier.setDouble(COL_AMOUNT_OPEN, cashCashier.getAmountOpen());
                dbCashCashier.setDate(COL_DATE_CLOSING, cashCashier.getDateClosing());
                dbCashCashier.setLong(COL_CURRENCY_ID_CLOSING, cashCashier.getCurrencyIdClosing());
                dbCashCashier.setDouble(COL_RATE_CLOSING, cashCashier.getRateClosing());
                dbCashCashier.setDouble(COL_AMOUNT_CLOSING, cashCashier.getAmountClosing());
                dbCashCashier.setInt(COL_STATUS, cashCashier.getStatus());
                dbCashCashier.update();
                return cashCashier.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashCashier(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCashCashier dbCashMaster = new DbCashCashier(oid);
            dbCashMaster.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashCashier(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order){
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_CASH_CASHIER;
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
                CashCashier cashCashier = new CashCashier();
                resultToObject(rs, cashCashier);
                lists.add(cashCashier);
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

    public static void resultToObject(ResultSet rs, CashCashier cashCashier) {
        try {
            cashCashier.setOID(rs.getLong(DbCashCashier.colNames[DbCashCashier.COL_CASH_CASHIER_ID]));
            cashCashier.setCashMasterId(rs.getLong(DbCashCashier.colNames[DbCashCashier.COL_CASH_MASTER_ID]));
            cashCashier.setUserId(rs.getLong(DbCashCashier.colNames[DbCashCashier.COL_USER_ID]));
            cashCashier.setShiftId(rs.getLong(DbCashCashier.colNames[DbCashCashier.COL_SHIFT_ID]));
            cashCashier.setDateOpen(rs.getDate(DbCashCashier.colNames[DbCashCashier.COL_DATE_OPEN]));
            cashCashier.setCurrencyIdOpen(rs.getLong(DbCashCashier.colNames[DbCashCashier.COL_CURRENCY_ID_OPEN]));
            cashCashier.setRateOpen(rs.getDouble(DbCashCashier.colNames[DbCashCashier.COL_RATE_OPEN]));
            cashCashier.setAmountOpen(rs.getDouble(DbCashCashier.colNames[DbCashCashier.COL_AMOUNT_OPEN]));
            cashCashier.setDateClosing(rs.getDate(DbCashCashier.colNames[DbCashCashier.COL_DATE_CLOSING]));
            cashCashier.setCurrencyIdClosing(rs.getLong(DbCashCashier.colNames[DbCashCashier.COL_CURRENCY_ID_CLOSING]));
            cashCashier.setRateClosing(rs.getDouble(DbCashCashier.colNames[DbCashCashier.COL_RATE_CLOSING]));
            cashCashier.setAmountClosing(rs.getDouble(DbCashCashier.colNames[DbCashCashier.COL_AMOUNT_CLOSING]));
            cashCashier.setStatus(rs.getInt(DbCashCashier.colNames[DbCashCashier.COL_STATUS]));
        } catch (Exception e) {
            
        }
    }

    public static boolean checkOID(long cashCashierId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CASH_CASHIER + " WHERE " +
                    DbCashCashier.colNames[DbCashCashier.COL_CASH_CASHIER_ID] + " = " + cashCashierId;

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
            String sql = "SELECT COUNT(" + DbCashCashier.colNames[DbCashCashier.COL_CASH_CASHIER_ID] + ") FROM " + DB_CASH_CASHIER;
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
                    CashCashier cashCashier = (CashCashier) list.get(ls);
                    if (oid == cashCashier.getOID()) {
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
