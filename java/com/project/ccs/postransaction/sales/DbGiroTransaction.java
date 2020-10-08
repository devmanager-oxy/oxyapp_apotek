/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.sales;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;

/**
 *
 * @author Roy Andika
 */

public class DbGiroTransaction extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_GIRO_TRANSACTION = "giro_transaction";
    
    public static final int COL_GIRO_TRANSACTION_ID = 0;
    public static final int COL_TRANSACTION_TYPE = 1;
    public static final int COL_SOURCE_ID = 2;
    public static final int COL_COA_ID = 3;
    public static final int COL_DATE_TRANSACTION = 4;
    public static final int COL_DUE_DATE = 5;
    public static final int COL_STATUS = 6;
    public static final int COL_GIRO_ID = 7;
    public static final int COL_AMOUNT = 8;    
    public static final int COL_CUSTOMER_ID = 9;
    public static final int COL_NUMBER = 10;
    public static final int COL_SEGMENT1_ID = 11;    
    public static final int COL_NUMBER_PREFIX = 12;
    public static final int COL_COUNTER = 13;
    public static final int COL_SEGMENT1_ID_POSTED = 14;
    
    public static final String[] colNames = {
        "giro_transaction_id",
        "transaction_type",
        "source_id",
        "coa_id",
        "date_transaction",
        "due_date",
        "status",
        "giro_id",
        "amount",
        "customer_id",
        "number",
        "segment1_id",
        "number_prefix",
        "counter",
        "segment1_id_posted"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG
    };
    
    public static final int TYPE_CREDIT_PAYMENT = 0;
    public static final int TYPE_PO_TRSANCTION = 1;    
    
    public static final int STATUS_NOT_PAID = 0;
    public static final int STATUS_PAID = 1;    

    public DbGiroTransaction() {
    }

    public DbGiroTransaction(int i) throws CONException {
        super(new DbGiroTransaction());
    }

    public DbGiroTransaction(String sOid) throws CONException {
        super(new DbGiroTransaction(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGiroTransaction(long lOid) throws CONException {
        super(new DbGiroTransaction(0));
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
        return DB_GIRO_TRANSACTION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGiroTransaction().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        GiroTransaction giroTransaction = fetchExc(ent.getOID());
        ent = (Entity) giroTransaction;
        return giroTransaction.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((GiroTransaction) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((GiroTransaction) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static GiroTransaction fetchExc(long oid) throws CONException {
        try {
            GiroTransaction giroTransaction = new GiroTransaction();
            DbGiroTransaction DbGiroTransaction = new DbGiroTransaction(oid);
            giroTransaction.setOID(oid);

            giroTransaction.setTransactionType(DbGiroTransaction.getInt(COL_TRANSACTION_TYPE));
            giroTransaction.setSourceId(DbGiroTransaction.getlong(COL_SOURCE_ID));
            giroTransaction.setCoaId(DbGiroTransaction.getlong(COL_COA_ID));
            giroTransaction.setDateTransaction(DbGiroTransaction.getDate(COL_DATE_TRANSACTION));
            giroTransaction.setDueDate(DbGiroTransaction.getDate(COL_DUE_DATE));
            giroTransaction.setStatus(DbGiroTransaction.getInt(COL_STATUS));
            giroTransaction.setGiroId(DbGiroTransaction.getlong(COL_GIRO_ID));
            giroTransaction.setAmount(DbGiroTransaction.getdouble(COL_AMOUNT));
            giroTransaction.setCustomerId(DbGiroTransaction.getlong(COL_CUSTOMER_ID));
            giroTransaction.setNumber(DbGiroTransaction.getString(COL_NUMBER));
            giroTransaction.setSegmentId(DbGiroTransaction.getlong(COL_SEGMENT1_ID));
            giroTransaction.setNumberPrefix(DbGiroTransaction.getString(COL_NUMBER_PREFIX));
            giroTransaction.setCounter(DbGiroTransaction.getInt(COL_COUNTER));
            giroTransaction.setSegment1IdPosted(DbGiroTransaction.getlong(COL_SEGMENT1_ID_POSTED));

            return giroTransaction;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGiroTransaction(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(GiroTransaction giroTransaction) throws CONException {
        try {
            DbGiroTransaction DbGiroTransaction = new DbGiroTransaction(0);

            DbGiroTransaction.setInt(COL_TRANSACTION_TYPE, giroTransaction.getTransactionType());
            DbGiroTransaction.setLong(COL_SOURCE_ID, giroTransaction.getSourceId());
            DbGiroTransaction.setLong(COL_COA_ID, giroTransaction.getCoaId());
            DbGiroTransaction.setDate(COL_DATE_TRANSACTION, giroTransaction.getDateTransaction());
            DbGiroTransaction.setDate(COL_DUE_DATE, giroTransaction.getDueDate());
            DbGiroTransaction.setInt(COL_STATUS, giroTransaction.getStatus());
            DbGiroTransaction.setLong(COL_GIRO_ID, giroTransaction.getGiroId());
            DbGiroTransaction.setDouble(COL_AMOUNT, giroTransaction.getAmount());                        
            DbGiroTransaction.setLong(COL_CUSTOMER_ID, giroTransaction.getCustomerId());            
            DbGiroTransaction.setString(COL_NUMBER, giroTransaction.getNumber());            
            DbGiroTransaction.setLong(COL_SEGMENT1_ID, giroTransaction.getSegmentId());                     
            DbGiroTransaction.setString(COL_NUMBER_PREFIX, giroTransaction.getNumberPrefix());            
            DbGiroTransaction.setInt(COL_COUNTER, giroTransaction.getCounter());         
            DbGiroTransaction.setLong(COL_SEGMENT1_ID_POSTED, giroTransaction.getSegment1IdPosted());         

            DbGiroTransaction.insert();
            giroTransaction.setOID(DbGiroTransaction.getlong(COL_GIRO_TRANSACTION_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGiroTransaction(0), CONException.UNKNOWN);
        }
        return giroTransaction.getOID();
    }

    public static long updateExc(GiroTransaction giroTransaction) throws CONException {
        try {
            if (giroTransaction.getOID() != 0) {
                DbGiroTransaction DbGiroTransaction = new DbGiroTransaction(giroTransaction.getOID());

                DbGiroTransaction.setInt(COL_TRANSACTION_TYPE, giroTransaction.getTransactionType());
                DbGiroTransaction.setLong(COL_SOURCE_ID, giroTransaction.getSourceId());
                DbGiroTransaction.setLong(COL_COA_ID, giroTransaction.getCoaId());
                DbGiroTransaction.setDate(COL_DATE_TRANSACTION, giroTransaction.getDateTransaction());
                DbGiroTransaction.setDate(COL_DUE_DATE, giroTransaction.getDueDate());
                DbGiroTransaction.setInt(COL_STATUS, giroTransaction.getStatus());
                DbGiroTransaction.setLong(COL_GIRO_ID, giroTransaction.getGiroId());
                DbGiroTransaction.setDouble(COL_AMOUNT, giroTransaction.getAmount());
                DbGiroTransaction.setLong(COL_CUSTOMER_ID, giroTransaction.getCustomerId());            
                DbGiroTransaction.setString(COL_NUMBER, giroTransaction.getNumber());          
                DbGiroTransaction.setLong(COL_SEGMENT1_ID, giroTransaction.getSegmentId());   
                DbGiroTransaction.setString(COL_NUMBER_PREFIX, giroTransaction.getNumberPrefix());            
                DbGiroTransaction.setInt(COL_COUNTER, giroTransaction.getCounter());         
                DbGiroTransaction.setLong(COL_SEGMENT1_ID_POSTED, giroTransaction.getSegment1IdPosted());               

                DbGiroTransaction.update();
                return giroTransaction.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGiroTransaction(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGiroTransaction DbGiroTransaction = new DbGiroTransaction(oid);
            DbGiroTransaction.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGiroTransaction(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_GIRO_TRANSACTION;
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
                GiroTransaction giroTransaction = new GiroTransaction();
                resultToObject(rs, giroTransaction);
                lists.add(giroTransaction);
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

    private static void resultToObject(ResultSet rs, GiroTransaction giroTransaction) {
        try {
            giroTransaction.setOID(rs.getLong(DbGiroTransaction.colNames[DbGiroTransaction.COL_GIRO_TRANSACTION_ID]));
            giroTransaction.setTransactionType(rs.getInt(DbGiroTransaction.colNames[DbGiroTransaction.COL_TRANSACTION_TYPE]));
            giroTransaction.setSourceId(rs.getLong(DbGiroTransaction.colNames[DbGiroTransaction.COL_SOURCE_ID]));
            giroTransaction.setCoaId(rs.getLong(DbGiroTransaction.colNames[DbGiroTransaction.COL_COA_ID]));
            giroTransaction.setDateTransaction(rs.getDate(DbGiroTransaction.colNames[DbGiroTransaction.COL_DATE_TRANSACTION]));
            giroTransaction.setDueDate(rs.getDate(DbGiroTransaction.colNames[DbGiroTransaction.COL_DUE_DATE]));
            giroTransaction.setStatus(rs.getInt(DbGiroTransaction.colNames[DbGiroTransaction.COL_STATUS]));
            giroTransaction.setGiroId(rs.getLong(DbGiroTransaction.colNames[DbGiroTransaction.COL_GIRO_ID]));
            giroTransaction.setAmount(rs.getDouble(DbGiroTransaction.colNames[DbGiroTransaction.COL_AMOUNT]));            
            giroTransaction.setCustomerId(rs.getLong(DbGiroTransaction.colNames[DbGiroTransaction.COL_CUSTOMER_ID]));
            giroTransaction.setNumber(rs.getString(DbGiroTransaction.colNames[DbGiroTransaction.COL_NUMBER]));
            giroTransaction.setSegmentId(rs.getLong(DbGiroTransaction.colNames[DbGiroTransaction.COL_SEGMENT1_ID]));            
            giroTransaction.setNumberPrefix(rs.getString(DbGiroTransaction.colNames[DbGiroTransaction.COL_NUMBER_PREFIX]));
            giroTransaction.setCounter(rs.getInt(DbGiroTransaction.colNames[DbGiroTransaction.COL_COUNTER]));            
            giroTransaction.setSegment1IdPosted(rs.getLong(DbGiroTransaction.colNames[DbGiroTransaction.COL_SEGMENT1_ID_POSTED]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long giroTransactionId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_GIRO_TRANSACTION + " WHERE " +
                    DbGiroTransaction.colNames[DbGiroTransaction.COL_GIRO_TRANSACTION_ID] + " = " + giroTransactionId;

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
            String sql = "SELECT COUNT(" + DbGiroTransaction.colNames[DbGiroTransaction.COL_GIRO_TRANSACTION_ID] + ") FROM " + DB_GIRO_TRANSACTION;
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
                    GiroTransaction giroTransaction = (GiroTransaction) list.get(ls);
                    if (oid == giroTransaction.getOID()) {
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

