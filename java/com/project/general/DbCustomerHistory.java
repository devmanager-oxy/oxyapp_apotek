package com.project.general;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

public class DbCustomerHistory extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_CUSTOMER_HISTORY     = "customer_history";

    public static final int COL_CUSTOMER_HISTORY_ID = 0;
    public static final int COL_TYPE               = 1;
    public static final int COL_TYPE_HISTORY       = 2;
    public static final int COL_CUSTOMER_ID        = 3;
    public static final int COL_USER_ID            = 4;
    public static final int COL_DATE               = 5;
    public static final int COL_STATUS             = 6;
    public static final int COL_STATUS_DATE        = 7;
    public static final int COL_NOTE               = 8;
    public static final int COL_BARCODE            = 9;
    public static final int COL_NAME               = 10;
    public static final int COL_SALES_ID           = 11;

    public static final String[] colNames = {
        "customer_history_id",
        "type",               
        "type_history",       
        "customer_id",        
        "user_id",            
        "date",               
        "status",             
        "status_date",        
        "note",
        "barcode",
        "name",
        "sales_id"
    };

    public static final int[] colTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG
    };
    
    public static final int TYPE_INSERT = 0;
    public static final int TYPE_UPDATE = 1;
    public static final int TYPE_DELETE = 2;
    public static final int TYPE_POINT_KELUAR = 3;
    
    public static final String[] strType = {"Insert", "Update","Delete","Point Keluar"};
    
    public static int TYPE_HISTORY_POS = 0;
    public static int TYPE_HISTORY_BACKOFFICE = 1;
    
    public static final String[] strHistoryType = {"Pos", "Back Office"};

    public DbCustomerHistory() {
    }

    public DbCustomerHistory(int i) throws CONException {
        super(new DbCustomerHistory());
    }
    
    public DbCustomerHistory(String sOid) throws CONException {
        super(new DbCustomerHistory(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }
    
    public DbCustomerHistory(long lOid) throws CONException {
        super(new DbCustomerHistory(0));
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
        return DB_CUSTOMER_HISTORY;
    }
    
    public String[] getFieldNames() {
        return colNames;
    }
    
    public int[] getFieldTypes() {
        return colTypes;
    }
    
    public String getPersistentName() {
        return new DbCustomerHistory().getClass().getName();
    }
    
    public long fetchExc(Entity ent) throws Exception {
        CustomerHistory customerHistory = fetchExc(ent.getOID());
        ent = (Entity) customerHistory;
        return customerHistory.getOID();
    }
    
    public long insertExc(Entity ent) throws Exception {
        return insertExc((CustomerHistory) ent);
    }
    
    public long updateExc(Entity ent) throws Exception {
        return updateExc((CustomerHistory) ent);
    }
    
    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }
    
    public static CustomerHistory fetchExc(long oid) throws CONException {
        try {
            CustomerHistory customerHistory = new CustomerHistory();

            DbCustomerHistory dbCustomerHistory = new DbCustomerHistory(oid);

            customerHistory.setOID(oid);
            customerHistory.setType(dbCustomerHistory.getInt(COL_TYPE));
            customerHistory.setTypeHistory(dbCustomerHistory.getInt(COL_TYPE_HISTORY));
            customerHistory.setCustomerId(dbCustomerHistory.getlong(COL_CUSTOMER_ID));
            customerHistory.setUserId(dbCustomerHistory.getlong(COL_USER_ID));
            customerHistory.setDate(dbCustomerHistory.getDate(COL_DATE));
            customerHistory.setStatus(dbCustomerHistory.getString(COL_STATUS));
            customerHistory.setStatusDate(dbCustomerHistory.getDate(COL_STATUS_DATE));
            customerHistory.setNote(dbCustomerHistory.getString(COL_NOTE));
            customerHistory.setBarcode(dbCustomerHistory.getString(COL_BARCODE));
            customerHistory.setName(dbCustomerHistory.getString(COL_NAME));
            customerHistory.setSalesId(dbCustomerHistory.getlong(COL_SALES_ID));

            return customerHistory;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomerHistory(0), CONException.UNKNOWN);
        }
    }
    
    public static long insertExc(CustomerHistory customerHistory) throws CONException {
        try {
            DbCustomerHistory dbCustomerHistory = new DbCustomerHistory(0);
    
            dbCustomerHistory.setInt(COL_TYPE, customerHistory.getType());
            dbCustomerHistory.setInt(COL_TYPE_HISTORY, customerHistory.getTypeHistory());
            dbCustomerHistory.setLong(COL_CUSTOMER_ID, customerHistory.getCustomerId());
            dbCustomerHistory.setLong(COL_USER_ID, customerHistory.getUserId());
            dbCustomerHistory.setDate(COL_DATE, customerHistory.getDate());
            dbCustomerHistory.setString(COL_STATUS, customerHistory.getStatus());
            dbCustomerHistory.setDate(COL_STATUS_DATE, customerHistory.getStatusDate());
            dbCustomerHistory.setString(COL_NOTE, customerHistory.getNote());            
            dbCustomerHistory.setString(COL_BARCODE, customerHistory.getBarcode());
            dbCustomerHistory.setString(COL_NAME, customerHistory.getName());
            dbCustomerHistory.setLong(COL_SALES_ID, customerHistory.getSalesId());
            
            dbCustomerHistory.insert();
            customerHistory.setOID(dbCustomerHistory.getlong(COL_CUSTOMER_HISTORY_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomerHistory(0), CONException.UNKNOWN);
        }
        return customerHistory.getOID();
    }
    
    public static long updateExc(CustomerHistory customerHistory) throws CONException {
        try {
            if (customerHistory.getOID() != 0) {
                DbCustomerHistory dbCustomerHistory = new DbCustomerHistory(customerHistory.getOID());
    
                dbCustomerHistory.setInt(COL_TYPE, customerHistory.getType());
                dbCustomerHistory.setInt(COL_TYPE_HISTORY, customerHistory.getTypeHistory());
                dbCustomerHistory.setLong(COL_CUSTOMER_ID, customerHistory.getCustomerId());
                dbCustomerHistory.setLong(COL_USER_ID, customerHistory.getUserId());
                dbCustomerHistory.setDate(COL_DATE, customerHistory.getDate());
                dbCustomerHistory.setString(COL_STATUS, customerHistory.getStatus());
                dbCustomerHistory.setDate(COL_STATUS_DATE, customerHistory.getStatusDate());
                dbCustomerHistory.setString(COL_NOTE, customerHistory.getNote());
                dbCustomerHistory.setString(COL_BARCODE, customerHistory.getBarcode());
                dbCustomerHistory.setString(COL_NAME, customerHistory.getName());
                dbCustomerHistory.setLong(COL_SALES_ID, customerHistory.getSalesId());
                
                dbCustomerHistory.update();
    
                return customerHistory.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomerHistory(0), CONException.UNKNOWN);
        }
        return 0;
    }
    
    public static long deleteExc(long oid) throws CONException {
        try {
            DbCustomerHistory dbCustomerHistory = new DbCustomerHistory(oid);
    
            dbCustomerHistory.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCustomerHistory(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_CUSTOMER_HISTORY;
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
                    ;
            }
    
            dbrs = CONHandler.execQueryResult(sql);
    
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                CustomerHistory customerHistory = new CustomerHistory();
                resultToObject(rs, customerHistory);
                lists.add(customerHistory);
            }
            rs.close();
            return lists;
    
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    private static void resultToObject(ResultSet rs, CustomerHistory customerHistory) {
        try {
            customerHistory.setOID(rs.getLong(colNames[COL_CUSTOMER_HISTORY_ID]));
            customerHistory.setType(rs.getInt(colNames[COL_TYPE]));
            customerHistory.setTypeHistory(rs.getInt(colNames[COL_TYPE_HISTORY]));
            customerHistory.setCustomerId(rs.getLong(colNames[COL_CUSTOMER_ID]));
            customerHistory.setUserId(rs.getLong(colNames[COL_USER_ID]));
            customerHistory.setDate(rs.getDate(colNames[COL_DATE]));
            customerHistory.setStatus(rs.getString(colNames[COL_STATUS]));
            customerHistory.setStatusDate(rs.getDate(colNames[COL_STATUS_DATE]));
            customerHistory.setNote(rs.getString(colNames[COL_NOTE]));
            customerHistory.setBarcode(rs.getString(colNames[COL_BARCODE]));
            customerHistory.setName(rs.getString(colNames[COL_NAME]));
            customerHistory.setSalesId(rs.getLong(colNames[COL_SALES_ID]));
        } catch (Exception e) {
    
        }
    }
    
    public static boolean checkOID(long oid) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_CUSTOMER_HISTORY + " WHERE " + colNames[COL_CUSTOMER_HISTORY_ID] + " = " + oid;
    
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
    
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }
    
    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
    
        try {
            String sql = "SELECT COUNT(" + colNames[COL_CUSTOMER_HISTORY_ID] + ") FROM " + DB_CUSTOMER_HISTORY;
    
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
                    CustomerHistory customerHistory = (CustomerHistory) list.get(ls);
                    if (oid == customerHistory.getOID()) {
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
    
    public static long getCustomerHistoryByNama(String name) {
        CONResultSet dbrs = null;
        long oid = 0;
        CustomerHistory customerHistory = new CustomerHistory();
    
        try {
            String sql = "SELECT * FROM " + DB_CUSTOMER_HISTORY+ " WHERE " + colNames[COL_CUSTOMER_HISTORY_ID] + " LIKE '" + name + "'";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
    
            while (rs.next()) {
                resultToObject(rs, customerHistory);
            }
    
            oid = customerHistory.getOID();
            rs.close();
        } catch(Exception e) {
            System.out.println(e.toString());
        }
    
        return oid;
    }
}
