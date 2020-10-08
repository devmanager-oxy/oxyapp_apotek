/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy
 */
public class DbVendorGroup extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_VENDOR_GROUP = "vendor_group";
    
    public static final int COL_VENDOR_GROUP_ID = 0;
    public static final int COL_GROUP_NAME = 1;
    public static final int COL_VENDOR_ID = 2;
    
    public static final String[] colNames = {
        "vendor_group_id",
        "group_name",
        "vendor_id"
    };
    
    public static final int[] fieldTypes = {        
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_LONG
    };    
    

    public DbVendorGroup() {
    }

    public DbVendorGroup(int i) throws CONException {
        super(new DbVendorGroup());
    }

    public DbVendorGroup(String sOid) throws CONException {
        super(new DbVendorGroup(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbVendorGroup(long lOid) throws CONException {
        super(new DbVendorGroup(0));
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
        return DB_VENDOR_GROUP;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbVendorGroup().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        VendorGroup vendorGroup = fetchExc(ent.getOID());
        ent = (Entity) vendorGroup;
        return vendorGroup.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((VendorGroup) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((VendorGroup) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static VendorGroup fetchExc(long oid) throws CONException {
        try {
            VendorGroup vendorGroup = new VendorGroup();
            DbVendorGroup dbVendor = new DbVendorGroup(oid);
            vendorGroup.setOID(oid);

            vendorGroup.setGroupName(dbVendor.getString(COL_GROUP_NAME));
            vendorGroup.setVendorId(dbVendor.getlong(COL_VENDOR_ID));
            
            return vendorGroup;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbVendorGroup(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(VendorGroup vendorGroup) throws CONException {
        try {
            DbVendorGroup dbVendor = new DbVendorGroup(0);
            dbVendor.setString(COL_GROUP_NAME, vendorGroup.getGroupName());
            dbVendor.setLong(COL_VENDOR_ID, vendorGroup.getVendorId());            
            dbVendor.insert();
            vendorGroup.setOID(dbVendor.getlong(COL_VENDOR_GROUP_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbVendorGroup(0), CONException.UNKNOWN);
        }
        return vendorGroup.getOID();
    }

    public static long updateExc(VendorGroup vendorGroup) throws CONException {
        try {
            if (vendorGroup.getOID() != 0) {
                DbVendorGroup dbVendor = new DbVendorGroup(vendorGroup.getOID());

                dbVendor.setString(COL_GROUP_NAME, vendorGroup.getGroupName());
                dbVendor.setLong(COL_VENDOR_ID, vendorGroup.getVendorId());      
                dbVendor.update();
                return vendorGroup.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbVendorGroup(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbVendorGroup dbVendor = new DbVendorGroup(oid);
            dbVendor.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbVendorGroup(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_VENDOR_GROUP;
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
                VendorGroup vendorGroup = new VendorGroup();
                resultToObject(rs, vendorGroup);
                lists.add(vendorGroup);
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

    public static void resultToObject(ResultSet rs, VendorGroup vendorGroup) {
        try {
            vendorGroup.setOID(rs.getLong(DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_GROUP_ID]));
            vendorGroup.setGroupName(rs.getString(DbVendorGroup.colNames[DbVendorGroup.COL_GROUP_NAME]));
            vendorGroup.setVendorId(rs.getLong(DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_ID]));
            
        } catch (Exception e) {
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbVendorGroup.colNames[DbVendorGroup.COL_VENDOR_GROUP_ID] + ") FROM " + DB_VENDOR_GROUP;
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
                    VendorGroup vendorGroup = (VendorGroup) list.get(ls);
                    if (oid == vendorGroup.getOID()) {
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
