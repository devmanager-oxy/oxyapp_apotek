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
public class DbCashMaster extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_CASH_MASTER = "pos_cash_master";
    public static final int COL_CASH_MASTER_ID = 0;
    public static final int COL_CASHIER_NUMBER = 1;
    public static final int COL_LOCATION_ID = 2;
    
 
    
    public static final String[] colNames = {
        "cash_master_id",
        "cashier_number",
        "location_id"
        
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_LONG
    };
    

    public DbCashMaster() {
    }

    public DbCashMaster(int i) throws CONException {
        super(new DbCashMaster());
    }

    public DbCashMaster(String sOid) throws CONException {
        super(new DbCashMaster(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCashMaster(long lOid) throws CONException {
        super(new DbCashMaster(0));
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
        return DB_CASH_MASTER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCashMaster().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CashMaster cashMaster = fetchExc(ent.getOID());
        ent = (Entity) cashMaster;
        return cashMaster.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CashMaster) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CashMaster) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CashMaster fetchExc(long oid) throws CONException {
        try {
            CashMaster cashMaster = new CashMaster();
            DbCashMaster dbCashMaster = new DbCashMaster(oid);
            cashMaster.setOID(oid);

            cashMaster.setCashierNumber(dbCashMaster.getInt(COL_CASHIER_NUMBER));
            cashMaster.setLocationId(dbCashMaster.getlong(COL_LOCATION_ID));
            
            return cashMaster;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashMaster(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(CashMaster cashMaster) throws CONException {
        try {


            DbCashMaster dbCashMaster = new DbCashMaster(0);

            dbCashMaster.setInt(COL_CASHIER_NUMBER, cashMaster.getCashierNumber());
            dbCashMaster.setLong(COL_LOCATION_ID, cashMaster.getLocationId());
            
                        
            dbCashMaster.insert();
            cashMaster.setOID(dbCashMaster.getlong(COL_CASH_MASTER_ID));


        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashMaster(0), CONException.UNKNOWN);
        }
        return cashMaster.getOID();
    }

    public static long updateExc( CashMaster cashMaster) throws CONException {
        try {
            if (cashMaster.getOID() != 0) {

                DbCashMaster dbCashMaster = new DbCashMaster(cashMaster.getOID());

                dbCashMaster.setInt(COL_CASHIER_NUMBER, cashMaster.getCashierNumber());
                dbCashMaster.setLong(COL_LOCATION_ID, cashMaster.getLocationId());
                
                dbCashMaster.update();
                return cashMaster.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashMaster(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCashMaster dbCashMaster = new DbCashMaster(oid);
            dbCashMaster.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCashMaster(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_CASH_MASTER;
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
                CashMaster cashMaster = new CashMaster();
                resultToObject(rs, cashMaster);
                lists.add(cashMaster);
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

    public static void resultToObject(ResultSet rs, CashMaster cashMaster) {
        try {
            cashMaster.setOID(rs.getLong(DbCashMaster.colNames[DbCashMaster.COL_CASH_MASTER_ID]));
            cashMaster.setCashierNumber(rs.getInt(DbCashMaster.colNames[DbCashMaster.COL_CASHIER_NUMBER]));
            cashMaster.setLocationId(rs.getLong(DbCashMaster.colNames[DbCashMaster.COL_LOCATION_ID]));
            
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long cashMasterId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CASH_MASTER + " WHERE " +
                    DbCashMaster.colNames[DbCashMaster.COL_CASH_MASTER_ID] + " = " + cashMasterId;

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
            String sql = "SELECT COUNT(" + DbCashMaster.colNames[DbCashMaster.COL_CASH_MASTER_ID] + ") FROM " + DB_CASH_MASTER;
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
                    CashMaster cashMaster = (CashMaster) list.get(ls);
                    if (oid == cashMaster.getOID()) {
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
