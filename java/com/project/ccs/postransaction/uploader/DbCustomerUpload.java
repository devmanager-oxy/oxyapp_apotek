/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.uploader;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;
/**
 *
 * @author Roy
 */
public class DbCustomerUpload extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_CUSTOMER_UPLOAD = "pos_customer_upload";
    
    public static final int COL_CUSTOMER_UPLOAD_ID = 0;
    public static final int COL_CUSTOMER_ID = 1;
    public static final int COL_DATE = 2;
    public static final int COL_QUERY_STRING = 3;  
    public static final int COL_STATUS_UPLOAD = 4;  
    
    public static final String[] colNames = {
        "customer_upload_id",
        "customer_id",
        "date",
        "query_string",
        "status_upload"        
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG, 
        TYPE_DATE, 
        TYPE_STRING,
        TYPE_INT
    };

    public DbCustomerUpload() {
    }

    public DbCustomerUpload(int i) throws CONException {
        super(new DbCustomerUpload());
    }

    public DbCustomerUpload(String sOid) throws CONException {
        super(new DbCustomerUpload(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCustomerUpload(long lOid) throws CONException {
        super(new DbCustomerUpload(0));
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
        return DB_POS_CUSTOMER_UPLOAD;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCustomerUpload().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CustomerUpload customerUpload = fetchExc(ent.getOID());
        ent = (Entity) customerUpload;
        return customerUpload.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CustomerUpload) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CustomerUpload) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CustomerUpload fetchExc(long oid) throws CONException {
        try {
            CustomerUpload customerUpload = new CustomerUpload();
            DbCustomerUpload pstCashierUpload = new DbCustomerUpload(oid);
            customerUpload.setOID(oid);
            customerUpload.setCustomerId(pstCashierUpload.getlong(COL_CUSTOMER_ID));
            customerUpload.setDate(pstCashierUpload.getDate(COL_DATE));
            customerUpload.setQueryString(pstCashierUpload.getString(COL_QUERY_STRING));
            customerUpload.setStatusUpload(pstCashierUpload.getInt(COL_STATUS_UPLOAD));

            return customerUpload;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomerUpload(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(CustomerUpload customerUpload) throws CONException {
        try {
            DbCustomerUpload pstCashierUpload = new DbCustomerUpload(0);
            pstCashierUpload.setLong(COL_CUSTOMER_ID, customerUpload.getCustomerId());
            pstCashierUpload.setDate(COL_DATE, customerUpload.getDate());
            pstCashierUpload.setString(COL_QUERY_STRING, customerUpload.getQueryString());
            pstCashierUpload.setInt(COL_STATUS_UPLOAD, customerUpload.getStatusUpload());
            pstCashierUpload.insert();
            customerUpload.setOID(pstCashierUpload.getlong(COL_CUSTOMER_UPLOAD_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomerUpload(0), CONException.UNKNOWN);
        }
        return customerUpload.getOID();
    }

    public static long updateExc(CustomerUpload customerUpload) throws CONException {
        try {
            if (customerUpload.getOID() != 0) {
                DbCustomerUpload pstCashierUpload = new DbCustomerUpload(customerUpload.getOID());

                pstCashierUpload.setLong(COL_CUSTOMER_ID, customerUpload.getCustomerId());
                pstCashierUpload.setDate(COL_DATE, customerUpload.getDate());
                pstCashierUpload.setString(COL_QUERY_STRING, customerUpload.getQueryString());
                pstCashierUpload.setInt(COL_STATUS_UPLOAD, customerUpload.getStatusUpload());
                
                pstCashierUpload.update();
                return customerUpload.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomerUpload(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCustomerUpload pstCashierUpload = new DbCustomerUpload(oid);
            pstCashierUpload.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomerUpload(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_CUSTOMER_UPLOAD;
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
                CustomerUpload customerUpload = new CustomerUpload();
                resultToObject(rs, customerUpload);
                lists.add(customerUpload);
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

    private static void resultToObject(ResultSet rs, CustomerUpload customerUpload) {
        try {
            customerUpload.setOID(rs.getLong(DbCustomerUpload.colNames[DbCustomerUpload.COL_CUSTOMER_UPLOAD_ID])); 
            customerUpload.setCustomerId(rs.getLong(DbCustomerUpload.colNames[DbCustomerUpload.COL_CUSTOMER_ID])); 
            customerUpload.setDate(rs.getDate(DbCustomerUpload.colNames[DbCustomerUpload.COL_DATE]));
            customerUpload.setQueryString(rs.getString(DbCustomerUpload.colNames[DbCustomerUpload.COL_QUERY_STRING]));
            customerUpload.setStatusUpload(rs.getInt(DbCustomerUpload.colNames[DbCustomerUpload.COL_STATUS_UPLOAD]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long cashUploadId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_CUSTOMER_UPLOAD + " WHERE " +
                    DbCustomerUpload.colNames[DbCustomerUpload.COL_CUSTOMER_UPLOAD_ID] + " = " + cashUploadId;

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
            String sql = "SELECT COUNT(" + DbCustomerUpload.colNames[DbCustomerUpload.COL_CUSTOMER_UPLOAD_ID] + ") FROM " + DB_POS_CUSTOMER_UPLOAD;
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
                    CustomerUpload customerUpload = (CustomerUpload) list.get(ls);
                    if (oid == customerUpload.getOID()) {
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
