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
public class DbBuildingFacilities extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    
    public static final String DB_BUILDING_FACILITIES = "prop_building_facilities";
    
    public static final int COL_BUILDING_FACILITIES_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_DESCRIPTION = 2;
    
     public static final String[] colNames = {
        "building_facilities_id",
        "name",
        "description"
    };
     
     public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };     
    
    public DbBuildingFacilities() {
    }

    public DbBuildingFacilities(int i) throws CONException {
        super(new DbBuildingFacilities());
    }

    public DbBuildingFacilities(String sOid) throws CONException {
        super(new DbBuildingFacilities(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBuildingFacilities(long lOid) throws CONException {
        super(new DbBuildingFacilities(0));
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
        return DB_BUILDING_FACILITIES;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBuildingFacilities().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BuildingFacilities buildingFacilities = fetchExc(ent.getOID());
        ent = (Entity) buildingFacilities;
        return buildingFacilities.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BuildingFacilities) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BuildingFacilities) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BuildingFacilities fetchExc(long oid) throws CONException {
        try {
            BuildingFacilities buildingFacilities = new BuildingFacilities();
            DbBuildingFacilities pstBuildingFacilities = new DbBuildingFacilities(oid);            
            
            buildingFacilities.setOID(oid);
            buildingFacilities.setName(pstBuildingFacilities.getString(COL_NAME));
            buildingFacilities.setDescription(pstBuildingFacilities.getString(COL_DESCRIPTION));

            return buildingFacilities;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuildingFacilities(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BuildingFacilities buildingFacilities) throws CONException {
        try {
            DbBuildingFacilities pstBuildingFacilities = new DbBuildingFacilities(0);
            
            pstBuildingFacilities.setString(COL_NAME, buildingFacilities.getName());
            pstBuildingFacilities.setString(COL_DESCRIPTION, buildingFacilities.getDescription());
            
            pstBuildingFacilities.insert();
            buildingFacilities.setOID(pstBuildingFacilities.getlong(COL_BUILDING_FACILITIES_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuildingFacilities(0), CONException.UNKNOWN);
        }
        return buildingFacilities.getOID();
    }

    public static long updateExc(BuildingFacilities buildingFacilities) throws CONException {
        try {
            if (buildingFacilities.getOID() != 0) {
                DbBuildingFacilities pstBuildingFacilities = new DbBuildingFacilities(buildingFacilities.getOID());
                
                pstBuildingFacilities.setString(COL_NAME, buildingFacilities.getName());
                pstBuildingFacilities.setString(COL_DESCRIPTION, buildingFacilities.getDescription());
                
                pstBuildingFacilities.update();
                return buildingFacilities.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuildingFacilities(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBuildingFacilities pstBuildingFacilities = new DbBuildingFacilities(oid);
            pstBuildingFacilities.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuildingFacilities(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BUILDING_FACILITIES;
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
                BuildingFacilities buildingFacilities = new BuildingFacilities();
                resultToObject(rs, buildingFacilities);
                lists.add(buildingFacilities);
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

    private static void resultToObject(ResultSet rs, BuildingFacilities buildingFacilities) {
        try {            
            buildingFacilities.setOID(rs.getLong(DbBuildingFacilities.colNames[DbBuildingFacilities.COL_BUILDING_FACILITIES_ID]));
            buildingFacilities.setName(rs.getString(DbBuildingFacilities.colNames[DbBuildingFacilities.COL_NAME]));
            buildingFacilities.setDescription(rs.getString(DbBuildingFacilities.colNames[DbBuildingFacilities.COL_DESCRIPTION]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long lotFacilitiesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BUILDING_FACILITIES + " WHERE " +
                    DbBuildingFacilities.colNames[DbBuildingFacilities.COL_BUILDING_FACILITIES_ID] + " = " + lotFacilitiesId;

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
            String sql = "SELECT COUNT(" + DbBuildingFacilities.colNames[DbBuildingFacilities.COL_BUILDING_FACILITIES_ID] + ") FROM " + DB_BUILDING_FACILITIES;
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
                    BuildingFacilities buildingFacilities = (BuildingFacilities) list.get(ls);
                    if (oid == buildingFacilities.getOID()) {
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
