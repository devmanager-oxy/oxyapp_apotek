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
public class DbBuildingFac extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    
    public static final String DB_BUILDING_FAC = "prop_building_fac";
    
    public static final int COL_BUILDING_FAC_ID = 0;
    public static final int COL_BUILDING_ID = 1;
    public static final int COL_BUILDING_FACILITIES_ID = 2;
    public static final int COL_QTY = 3;
    
     public static final String[] colNames = {
        "building_fac_id",
        "building_id",
        "building_facilities_id",
        "qty"
    };
     
     public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT
    };     
    
    public DbBuildingFac() {
    }

    public DbBuildingFac(int i) throws CONException {
        super(new DbBuildingFac());
    }

    public DbBuildingFac(String sOid) throws CONException {
        super(new DbBuildingFac(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBuildingFac(long lOid) throws CONException {
        super(new DbBuildingFac(0));
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
        return DB_BUILDING_FAC;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBuildingFac().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BuildingFac buildingFacilities = fetchExc(ent.getOID());
        ent = (Entity) buildingFacilities;
        return buildingFacilities.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BuildingFac) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BuildingFac) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BuildingFac fetchExc(long oid) throws CONException {
        try {
            
            BuildingFac buildingFac = new BuildingFac();            
            DbBuildingFac pstBuildingFacilities = new DbBuildingFac(oid);                        
            buildingFac.setOID(oid);
            buildingFac.setBuildingId(pstBuildingFacilities.getlong(COL_BUILDING_ID));
            buildingFac.setBuildingFacilitiesId(pstBuildingFacilities.getlong(COL_BUILDING_FACILITIES_ID));
            buildingFac.setQty(pstBuildingFacilities.getInt(COL_QTY));

            return buildingFac;
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuildingFac(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BuildingFac buildingFac) throws CONException {
        try {
            DbBuildingFac pstBuildingFac = new DbBuildingFac(0);
            
            pstBuildingFac.setLong(COL_BUILDING_ID, buildingFac.getBuildingId());
            pstBuildingFac.setLong(COL_BUILDING_FACILITIES_ID, buildingFac.getBuildingFacilitiesId());
            pstBuildingFac.setInt(COL_QTY, buildingFac.getQty());
            
            pstBuildingFac.insert();
            buildingFac.setOID(pstBuildingFac.getlong(COL_BUILDING_FAC_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuildingFac(0), CONException.UNKNOWN);
        }
        return buildingFac.getOID();
    }

    public static long updateExc(BuildingFac buildingFac) throws CONException {
        try {
            if (buildingFac.getOID() != 0) {
                DbBuildingFac pstBuildingFac = new DbBuildingFac(buildingFac.getOID());
                
                pstBuildingFac.setLong(COL_BUILDING_ID, buildingFac.getBuildingId());
                pstBuildingFac.setLong(COL_BUILDING_FACILITIES_ID, buildingFac.getBuildingFacilitiesId());
                pstBuildingFac.setInt(COL_QTY, buildingFac.getQty());
                
                pstBuildingFac.update();
                return buildingFac.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuildingFac(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBuildingFac pstBuildingFac = new DbBuildingFac(oid);
            pstBuildingFac.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuildingFac(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BUILDING_FAC;
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
                BuildingFac buildingFacilities = new BuildingFac();
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

    private static void resultToObject(ResultSet rs, BuildingFac buildingFac) {
        try {            
            buildingFac.setOID(rs.getLong(DbBuildingFac.colNames[DbBuildingFac.COL_BUILDING_FAC_ID]));
            buildingFac.setBuildingId(rs.getLong(DbBuildingFac.colNames[DbBuildingFac.COL_BUILDING_ID]));
            buildingFac.setBuildingFacilitiesId(rs.getLong(DbBuildingFac.colNames[DbBuildingFac.COL_BUILDING_FACILITIES_ID]));
            buildingFac.setQty(rs.getInt(DbBuildingFac.colNames[DbBuildingFac.COL_QTY]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long buildingFacilitiesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BUILDING_FAC + " WHERE " +
                    DbBuildingFac.colNames[DbBuildingFac.COL_BUILDING_FACILITIES_ID] + " = " + buildingFacilitiesId;

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
            String sql = "SELECT COUNT(" + DbBuildingFac.colNames[DbBuildingFac.COL_BUILDING_FACILITIES_ID] + ") FROM " + DB_BUILDING_FAC;
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
                    BuildingFac buildingFacilities = (BuildingFac) list.get(ls);
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
    
    public static Vector listFacilities(long buildingId){
        
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        
        try {
            
            String sql = "SELECT * FROM " + DB_BUILDING_FAC+" where "+DbBuildingFac.colNames[DbBuildingFac.COL_BUILDING_ID]+" = "+buildingId;
            
            dbrs = CONHandler.execQueryResult(sql);            
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()){
                BuildingFac buildingFacilities = new BuildingFac();
                resultToObject(rs, buildingFacilities);
                lists.add(buildingFacilities);
            }
            return lists;
        }catch(Exception e){        
        }finally {
            CONResultSet.close(dbrs);
        }   
        return null;
        
    }
    
    
    public static void deleteList(long buildingId){
        CONResultSet dbrs = null;        
        try {
            
            String sql = "DELETE FROM " + DB_BUILDING_FAC+" where "+DbBuildingFac.colNames[DbBuildingFac.COL_BUILDING_ID]+" = "+buildingId;
            int i = CONHandler.execUpdate(sql);            
            
        }catch(Exception e){        
        }finally {
            CONResultSet.close(dbrs);
        }   
    }

}
