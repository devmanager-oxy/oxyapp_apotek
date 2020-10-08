/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class DbFacilitiesValue extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_FACILITIES_VALUE = "prop_facilities_value";
    
    public static final int COL_FACILITIES_VALUE_ID = 0;
    public static final int COL_FLOOR_ID = 1;
    public static final int COL_FACILITIES_ID = 2;
    public static final int COL_URUTAN = 3;
    public static final int COL_DESCRIPTION = 4;
    public static final int COL_VALUE = 5;
    
    public static final String[] colNames = {
        "facilities_value_id",
        "floor_id",
        "facilities_id",
        "urutan",
        "description",
        "value"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING
    };
    
    public static final int URUTAN_0 = 0;
    public static final int URUTAN_1 = 1;
    public static final int URUTAN_2 = 2;
    public static final int URUTAN_3 = 3;
    public static final int URUTAN_4 = 4;
    public static final int URUTAN_5 = 5;
    public static final int URUTAN_6 = 6;
    public static final int URUTAN_7 = 7;
    public static final int URUTAN_8 = 8;
    public static final int URUTAN_9 = 9;
    public static final int URUTAN_10 = 10;
    public static final int URUTAN_11 = 11;
    public static final int URUTAN_12 = 12;
    public static final int URUTAN_13 = 13;
    public static final int URUTAN_14 = 14;
    public static final int URUTAN_15 = 15;
    public static final int URUTAN_16 = 20;
    
    public static final int[] urutanValue = {0, 1, 2, 3,4,5,6,7,8,9,10,11,12,13,14,15,16};
    public static final String[] urutanKey = {"0", "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16"};

    public DbFacilitiesValue() {
    }

    public DbFacilitiesValue(int i) throws CONException {
        super(new DbFacilitiesValue());
    }

    public DbFacilitiesValue(String sOid) throws CONException {
        super(new DbFacilitiesValue(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFacilitiesValue(long lOid) throws CONException {
        super(new DbFacilitiesValue(0));
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
        return DB_FACILITIES_VALUE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbFacilitiesValue().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        FacilitiesValue facilitiesValue = fetchExc(ent.getOID());
        ent = (Entity) facilitiesValue;
        return facilitiesValue.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((FacilitiesValue) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((FacilitiesValue) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static FacilitiesValue fetchExc(long oid) throws CONException {
        try {
            FacilitiesValue facilitiesValue = new FacilitiesValue();
            DbFacilitiesValue pstFacilities = new DbFacilitiesValue(oid);

            facilitiesValue.setOID(oid);
            facilitiesValue.setFloorId(pstFacilities.getlong(COL_FLOOR_ID));
            facilitiesValue.setFacilitiesId(pstFacilities.getlong(COL_FACILITIES_ID));
            facilitiesValue.setUrutan(pstFacilities.getInt(COL_URUTAN));
            facilitiesValue.setDescription(pstFacilities.getString(COL_DESCRIPTION));
            facilitiesValue.setValue(pstFacilities.getString(COL_VALUE));

            return facilitiesValue;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFacilitiesValue(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(FacilitiesValue facilitiesValue) throws CONException {
        try {
            DbFacilitiesValue pstFacilities = new DbFacilitiesValue(0);
            
            pstFacilities.setLong(COL_FLOOR_ID, facilitiesValue.getFloorId());
            pstFacilities.setLong(COL_FACILITIES_ID, facilitiesValue.getFacilitiesId());
            pstFacilities.setInt(COL_URUTAN, facilitiesValue.getUrutan());
            pstFacilities.setString(COL_DESCRIPTION, facilitiesValue.getDescription());
            pstFacilities.setString(COL_VALUE, facilitiesValue.getValue());

            pstFacilities.insert();
            facilitiesValue.setOID(pstFacilities.getlong(COL_FACILITIES_VALUE_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFacilitiesValue(0), CONException.UNKNOWN);
        }
        return facilitiesValue.getOID();
    }

    public static long updateExc(FacilitiesValue facilitiesValue) throws CONException {
        try {
            if (facilitiesValue.getOID() != 0) {
                DbFacilitiesValue pstFacilities = new DbFacilitiesValue(facilitiesValue.getOID());

                pstFacilities.setLong(COL_FLOOR_ID, facilitiesValue.getFloorId());
                pstFacilities.setLong(COL_FACILITIES_ID, facilitiesValue.getFacilitiesId());
                pstFacilities.setInt(COL_URUTAN, facilitiesValue.getUrutan());
                pstFacilities.setString(COL_DESCRIPTION, facilitiesValue.getDescription());
                pstFacilities.setString(COL_VALUE, facilitiesValue.getValue());
               
                pstFacilities.update();
                return facilitiesValue.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFacilitiesValue(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFacilitiesValue pstFacilities = new DbFacilitiesValue(oid);
            pstFacilities.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFacilitiesValue(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_FACILITIES_VALUE;
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
                FacilitiesValue facilitiesValue = new FacilitiesValue();
                resultToObject(rs, facilitiesValue);
                lists.add(facilitiesValue);
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

    private static void resultToObject(ResultSet rs, FacilitiesValue facilitiesValue) {
        try {
            
            facilitiesValue.setOID(rs.getLong(DbFacilitiesValue.colNames[DbFacilitiesValue.COL_FACILITIES_VALUE_ID]));
            facilitiesValue.setFloorId(rs.getLong(DbFacilitiesValue.colNames[DbFacilitiesValue.COL_FLOOR_ID]));
            facilitiesValue.setFacilitiesId(rs.getLong(DbFacilitiesValue.colNames[DbFacilitiesValue.COL_FACILITIES_ID]));            
            facilitiesValue.setUrutan(rs.getInt(DbFacilitiesValue.colNames[DbFacilitiesValue.COL_URUTAN]));
            facilitiesValue.setDescription(rs.getString(DbFacilitiesValue.colNames[DbFacilitiesValue.COL_DESCRIPTION]));
            facilitiesValue.setValue(rs.getString(DbFacilitiesValue.colNames[DbFacilitiesValue.COL_VALUE]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long facilitiesValueId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_FACILITIES_VALUE + " WHERE " +
                    DbFacilitiesValue.colNames[DbFacilitiesValue.COL_FACILITIES_VALUE_ID] + " = " + facilitiesValueId;

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
            String sql = "SELECT COUNT(" + DbFacilitiesValue.colNames[DbFacilitiesValue.COL_FACILITIES_VALUE_ID] + ") FROM " + DB_FACILITIES_VALUE;
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
                    FacilitiesValue facilitiesValue = (FacilitiesValue) list.get(ls);
                    if (oid == facilitiesValue.getOID()) {
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
