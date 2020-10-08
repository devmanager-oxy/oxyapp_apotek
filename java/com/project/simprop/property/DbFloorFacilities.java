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
public class DbFloorFacilities extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    
    public static final String DB_FLOOR_FACILITIES = "prop_floor_facilities";
    
    public static final int COL_FLOOR_FACILITIES_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_DESCRIPTION = 2;
    
     public static final String[] colNames = {
        "floor_facilities_id",
        "name",
        "description"
    };
     
     public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };     
    
    public DbFloorFacilities() {
    }

    public DbFloorFacilities(int i) throws CONException {
        super(new DbFloorFacilities());
    }

    public DbFloorFacilities(String sOid) throws CONException {
        super(new DbFloorFacilities(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFloorFacilities(long lOid) throws CONException {
        super(new DbFloorFacilities(0));
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
        return DB_FLOOR_FACILITIES;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbFloorFacilities().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        FloorFacilities floorFacilities = fetchExc(ent.getOID());
        ent = (Entity) floorFacilities;
        return floorFacilities.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((FloorFacilities) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((FloorFacilities) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static FloorFacilities fetchExc(long oid) throws CONException {
        try {
            FloorFacilities floorFacilities = new FloorFacilities();
            DbFloorFacilities pstFloorFacilities = new DbFloorFacilities(oid);            
            
            floorFacilities.setOID(oid);
            floorFacilities.setName(pstFloorFacilities.getString(COL_NAME));
            floorFacilities.setDescription(pstFloorFacilities.getString(COL_DESCRIPTION));

            return floorFacilities;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloorFacilities(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(FloorFacilities floorFacilities) throws CONException {
        try {
            DbFloorFacilities pstFloorFacilities = new DbFloorFacilities(0);
            
            pstFloorFacilities.setString(COL_NAME, floorFacilities.getName());
            pstFloorFacilities.setString(COL_DESCRIPTION, floorFacilities.getDescription());
            
            pstFloorFacilities.insert();
            floorFacilities.setOID(pstFloorFacilities.getlong(COL_FLOOR_FACILITIES_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloorFacilities(0), CONException.UNKNOWN);
        }
        return floorFacilities.getOID();
    }

    public static long updateExc(FloorFacilities floorFacilities) throws CONException {
        try {
            if (floorFacilities.getOID() != 0) {
                DbFloorFacilities pstFloorFacilities = new DbFloorFacilities(floorFacilities.getOID());
                
                pstFloorFacilities.setString(COL_NAME, floorFacilities.getName());
                pstFloorFacilities.setString(COL_DESCRIPTION, floorFacilities.getDescription());
                
                pstFloorFacilities.update();
                return floorFacilities.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloorFacilities(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFloorFacilities pstFloorFacilities = new DbFloorFacilities(oid);
            pstFloorFacilities.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloorFacilities(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_FLOOR_FACILITIES;
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
                FloorFacilities floorFacilities = new FloorFacilities();
                resultToObject(rs, floorFacilities);
                lists.add(floorFacilities);
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

    private static void resultToObject(ResultSet rs, FloorFacilities floorFacilities) {
        try {            
            floorFacilities.setOID(rs.getLong(DbFloorFacilities.colNames[DbFloorFacilities.COL_FLOOR_FACILITIES_ID]));
            floorFacilities.setName(rs.getString(DbFloorFacilities.colNames[DbFloorFacilities.COL_NAME]));
            floorFacilities.setDescription(rs.getString(DbFloorFacilities.colNames[DbFloorFacilities.COL_DESCRIPTION]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long floorFacilitiesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_FLOOR_FACILITIES + " WHERE " +
                    DbFloorFacilities.colNames[DbFloorFacilities.COL_FLOOR_FACILITIES_ID] + " = " + floorFacilitiesId;

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

    public static int getCount(String whereClause){
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbFloorFacilities.colNames[DbFloorFacilities.COL_FLOOR_FACILITIES_ID] + ") FROM " + DB_FLOOR_FACILITIES;
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
                    FloorFacilities floorFacilities = (FloorFacilities) list.get(ls);
                    if (oid == floorFacilities.getOID()) {
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
