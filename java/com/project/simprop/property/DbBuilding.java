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
public class DbBuilding extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{

    public static final String DB_BUILDING = "prop_building";
    
    public static final int COL_BUILDING_ID = 0;
    public static final int COL_PROPERTY_ID = 1;
    public static final int COL_SALES_TYPE = 2;
    public static final int COL_BUILDING_NAME = 3;
    public static final int COL_BUILDING_TYPE = 4;
    public static final int COL_NUMBER_OF_FLOOR = 5;
    public static final int COL_SELECT_FACILITIES_OTHER = 6;
    public static final int COL_NAME_FACILITIES_OTHER = 7;
    public static final int COL_DESCRIPTION = 8;
    public static final int COL_BUILDING_STATUS = 9;
    public static final int COL_NAME_PIC = 10;
    
    public static final String[] colNames = {
        "building_id",
        "property_id",
        "sales_type",
        "building_name",          
        "building_type",        
        "number_of_floor",
        "select_facilities_other",
        "name_facilities_other",        
        "description",
        "building_status",        
        "name_pic"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,         
        TYPE_INT,        
        TYPE_INT,         
        TYPE_INT, 
        TYPE_STRING,        
        TYPE_STRING,
        TYPE_INT,         
        TYPE_STRING
    };
    
    public static final int SALES_TYPE_FOR_SALE = 0;
    public static final int SALES_TYPE_FOR_RENT = 1;
    public static final int[] salesTypeValue = {0,1};
    public static final String[] salesTypeKey = {"Building For Sale", "Building For Rent"};
    
    public static final int BUILDING_TYPE_HOME = 0;
    public static final int BUILDING_TYPE_APARTMENT = 1;
    public static final int BUILDING_TYPE_HOTEL = 2;
    public static final int BUILDING_TYPE_BUILDING = 3;
    public static final int BUILDING_TYPE_RUKO = 4;
    public static final int BUILDING_TYPE_KIOS = 5;
    
    public static final int[] buildingTypeValue = {0,1,2,3,4,5};
    public static final String[] buildingTypeKey = {"House", "Apartment", "Hotel/Kondo","Shooping Arcade","Ruko","Kios"};
    
    public static final int BUILDING_STATUS_IN_PROGRESS = 0;
    public static final int BUILDING_STATUS_FINISH = 1;
    public static final int[] buildingStatusValue = {0, 1};
    public static final String[] buildingStatusKey = {"In Progress", "Finish"};

    public DbBuilding() {
    }

    public DbBuilding(int i) throws CONException {
        super(new DbBuilding());
    }

    public DbBuilding(String sOid) throws CONException {
        super(new DbBuilding(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBuilding(long lOid) throws CONException {
        super(new DbBuilding(0));
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
        return DB_BUILDING;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBuilding().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Building building = fetchExc(ent.getOID());
        ent = (Entity) building;
        return building.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Building) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Building) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Building fetchExc(long oid) throws CONException {
        try {
            Building building = new Building();
            DbBuilding pstBuilding = new DbBuilding(oid);
            building.setOID(oid);

            building.setPropertyId(pstBuilding.getlong(COL_PROPERTY_ID));
            building.setSalesType(pstBuilding.getInt(COL_SALES_TYPE));
            building.setBuildingName(pstBuilding.getString(COL_BUILDING_NAME));            
            building.setBuildingType(pstBuilding.getInt(COL_BUILDING_TYPE));            
            building.setNumberOfFloor(pstBuilding.getInt(COL_NUMBER_OF_FLOOR));
            building.setSelectFacilitiesOther(pstBuilding.getInt(COL_SELECT_FACILITIES_OTHER));
            building.setNameFacilitiesOther(pstBuilding.getString(COL_NAME_FACILITIES_OTHER));
            building.setDescription(pstBuilding.getString(COL_DESCRIPTION));
            building.setBuildingStatus(pstBuilding.getInt(COL_BUILDING_STATUS));
            building.setNamePic(pstBuilding.getString(COL_NAME_PIC));

            return building;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuilding(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Building building) throws CONException {
        try {
            DbBuilding pstBuilding = new DbBuilding(0);

            pstBuilding.setLong(COL_PROPERTY_ID, building.getPropertyId());
            pstBuilding.setInt(COL_SALES_TYPE, building.getSalesType());
            pstBuilding.setString(COL_BUILDING_NAME, building.getBuildingName());          
            pstBuilding.setInt(COL_BUILDING_TYPE, building.getBuildingType());            
            pstBuilding.setInt(COL_NUMBER_OF_FLOOR, building.getNumberOfFloor());
            pstBuilding.setInt(COL_SELECT_FACILITIES_OTHER, building.getSelectFacilitiesOther());
            pstBuilding.setString(COL_NAME_FACILITIES_OTHER, building.getNameFacilitiesOther());
            pstBuilding.setString(COL_DESCRIPTION, building.getDescription());
            pstBuilding.setInt(COL_BUILDING_STATUS, building.getBuildingStatus());
            pstBuilding.setString(COL_NAME_PIC, building.getNamePic());

            pstBuilding.insert();
            building.setOID(pstBuilding.getlong(COL_BUILDING_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuilding(0), CONException.UNKNOWN);
        }
        return building.getOID();
    }

    public static long updateExc(Building building) throws CONException {
        try {
            if (building.getOID() != 0) {
                DbBuilding pstProperty = new DbBuilding(building.getOID());

                pstProperty.setLong(COL_PROPERTY_ID, building.getPropertyId());
                pstProperty.setInt(COL_SALES_TYPE, building.getSalesType());
                pstProperty.setString(COL_BUILDING_NAME, building.getBuildingName());                
                pstProperty.setInt(COL_BUILDING_TYPE, building.getBuildingType());                
                pstProperty.setInt(COL_NUMBER_OF_FLOOR, building.getNumberOfFloor());
                pstProperty.setInt(COL_SELECT_FACILITIES_OTHER, building.getSelectFacilitiesOther());
                pstProperty.setString(COL_NAME_FACILITIES_OTHER, building.getNameFacilitiesOther());
                pstProperty.setString(COL_DESCRIPTION, building.getDescription());
                pstProperty.setInt(COL_BUILDING_STATUS, building.getBuildingStatus());
                pstProperty.setString(COL_NAME_PIC, building.getNamePic());

                pstProperty.update();
                return building.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuilding(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBuilding pstProperty = new DbBuilding(oid);
            pstProperty.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBuilding(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BUILDING;
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
                Building building = new Building();
                resultToObject(rs, building);
                lists.add(building);
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

    private static void resultToObject(ResultSet rs, Building building) {
        try {
            
            building.setOID(rs.getLong(DbBuilding.colNames[DbBuilding.COL_BUILDING_ID]));
            building.setPropertyId(rs.getLong(DbBuilding.colNames[DbBuilding.COL_PROPERTY_ID]));
            building.setSalesType(rs.getInt(DbBuilding.colNames[DbBuilding.COL_SALES_TYPE]));
            building.setBuildingName(rs.getString(DbBuilding.colNames[DbBuilding.COL_BUILDING_NAME]));            
            building.setBuildingType(rs.getInt(DbBuilding.colNames[DbBuilding.COL_BUILDING_TYPE]));            
            building.setNumberOfFloor(rs.getInt(DbBuilding.colNames[DbBuilding.COL_NUMBER_OF_FLOOR]));
            building.setSelectFacilitiesOther(rs.getInt(DbBuilding.colNames[DbBuilding.COL_SELECT_FACILITIES_OTHER]));
            building.setNameFacilitiesOther(rs.getString(DbBuilding.colNames[DbBuilding.COL_NAME_FACILITIES_OTHER]));
            building.setDescription(rs.getString(DbBuilding.colNames[DbBuilding.COL_DESCRIPTION]));
            building.setBuildingStatus(rs.getInt(DbBuilding.colNames[DbBuilding.COL_BUILDING_STATUS]));
            building.setNamePic(rs.getString(DbBuilding.colNames[DbBuilding.COL_NAME_PIC]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long buildingId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BUILDING + " WHERE " +
                    DbBuilding.colNames[DbBuilding.COL_BUILDING_ID] + " = " + buildingId;

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
            String sql = "SELECT COUNT(" + DbBuilding.colNames[DbBuilding.COL_BUILDING_ID] + ") FROM " + DB_BUILDING;
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
                    Building building = (Building) list.get(ls);
                    if (oid == building.getOID()) {
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
    
    public static void del(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + DB_BUILDING;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
         int i = CONHandler.execUpdate(sql); 
        } catch (Exception e) {
            System.out.println("[exception] "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static void updateFloorQty(long oidBuilding){
    	
    	int count = DbFloor.getCount(DbFloor.colNames[DbFloor.COL_BUILDING_ID]+"="+oidBuilding);
    	Building bd = new Building();
    	try{
    		bd = fetchExc(oidBuilding);
    		bd.setNumberOfFloor(count);
    		updateExc(bd);
    	}
    	catch(Exception e){
    		System.out.println(e.toString());
    	}
    	
    }
    
}
