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
public class DbProperty extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_PROPERTY = "prop_property";
    public static final int COL_PROPERTY_ID = 0;
    public static final int COL_SALES_TYPE = 1;
    public static final int COL_BUILDING_NAME = 2;
    public static final int COL_LOCATION_ID = 3;
    public static final int COL_ADDRESS = 4;
    public static final int COL_PROPERTY_TYPE = 5;
    public static final int COL_IMB_NUMBER = 6;
    public static final int COL_OWNER = 7;
    public static final int COL_LAND_SERTIFICATE_NUMBER = 8;
    public static final int COL_NUMBER_OF_FLOOR = 9;
    public static final int COL_SELECT_FACILITIES_OTHER = 10;
    public static final int COL_NAME_FACILITIES_OTHER = 11;
    public static final int COL_DESCRIPTION = 12;
    public static final int COL_PROPERTY_STATUS = 13;
    public static final int COL_LOCATION_MAP = 14;
    public static final int COL_CITY = 15;
    public static final int COL_LAND_AREA = 16;
    public static final int COL_BUILDING_AREA = 17;
    public static final int COL_COMMENCEMENT = 18;
    public static final int COL_COMPLETION = 19;
    public static final int COL_DEVELOPER = 20;
    public static final String[] colNames = {
        "property_id",
        "sales_type",
        "building_name",
        "location_id",
        "address",
        "property_type",
        "imb_number",
        "owner",
        "land_sertificate_number",
        "number_of_floor",
        "select_facilities_other",
        "name_facilities_other",
        "description",
        "property_status",
        "location_map",
        "city",
        "land_area",
        "building_area",
        "commencement",
        "completion",
        "developer"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING
    };
    public static final int SALES_TYPE_FOR_SALE = 0;
    public static final int SALES_TYPE_FOR_RENT = 1;
    public static final int[] salesTypeValue = {0, 1};
    public static final String[] salesTypeKey = {"Property For Sale", "Property For Rent"};
    public static final int PROPERTY_TYPE_HOME = 0;
    public static final int PROPERTY_TYPE_APARTMENT = 1;
    public static final int PROPERTY_TYPE_HOTEL = 2;
    public static final int PROPERTY_TYPE_BUILDING = 3;
    public static final int[] propertyTypeValue = {0, 1, 2, 3};
    public static final String[] propertyTypeKey = {"Home", "Apartment", "Hotel", "Building"};
    public static final int PROPERTY_STATUS_IN_PROGRESS = 0;
    public static final int PROPERTY_STATUS_FINISH = 1;
    public static final int[] propertyStatusValue = {0, 1};
    public static final String[] propertyStatusKey = {"In Progress", "Finish"};

    public DbProperty() {
    }

    public DbProperty(int i) throws CONException {
        super(new DbProperty());
    }

    public DbProperty(String sOid) throws CONException {
        super(new DbProperty(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbProperty(long lOid) throws CONException {
        super(new DbProperty(0));
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
        return DB_PROPERTY;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbProperty().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Property property = fetchExc(ent.getOID());
        ent = (Entity) property;
        return property.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Property) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Property) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Property fetchExc(long oid) throws CONException {
        try {
            Property property = new Property();
            DbProperty pstProperty = new DbProperty(oid);
            property.setOID(oid);

            property.setSalesType(pstProperty.getInt(COL_SALES_TYPE));
            property.setBuildingName(pstProperty.getString(COL_BUILDING_NAME));
            property.setLocationId(pstProperty.getlong(COL_LOCATION_ID));
            property.setAddress(pstProperty.getString(COL_ADDRESS));
            property.setPropertyType(pstProperty.getInt(COL_PROPERTY_TYPE));
            property.setImbNumber(pstProperty.getString(COL_IMB_NUMBER));
            property.setOwner(pstProperty.getString(COL_OWNER));
            property.setLandSertificateNumber(pstProperty.getString(COL_LAND_SERTIFICATE_NUMBER));
            property.setNumberOfFloor(pstProperty.getInt(COL_NUMBER_OF_FLOOR));
            property.setSelectFacilitiesOther(pstProperty.getInt(COL_SELECT_FACILITIES_OTHER));
            property.setNameFacilitiesOther(pstProperty.getString(COL_NAME_FACILITIES_OTHER));
            property.setDescription(pstProperty.getString(COL_DESCRIPTION));
            property.setPropertyStatus(pstProperty.getInt(COL_PROPERTY_STATUS));
            property.setLocationMap(pstProperty.getString(COL_LOCATION_MAP));
            property.setCity(pstProperty.getString(COL_CITY));
            property.setLandArea(pstProperty.getString(COL_LAND_AREA));
            property.setBuildingArea(pstProperty.getString(COL_BUILDING_AREA));
            property.setCommencement(pstProperty.getDate(COL_COMMENCEMENT));
            property.setCompletion(pstProperty.getDate(COL_COMPLETION));
            property.setDeveloper(pstProperty.getString(COL_DEVELOPER));

            return property;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbProperty(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Property property) throws CONException {
        try {
            DbProperty pstProperty = new DbProperty(0);

            pstProperty.setInt(COL_SALES_TYPE, property.getSalesType());
            pstProperty.setString(COL_BUILDING_NAME, property.getBuildingName());
            pstProperty.setLong(COL_LOCATION_ID, property.getLocationId());
            pstProperty.setString(COL_ADDRESS, property.getAddress());
            pstProperty.setInt(COL_PROPERTY_TYPE, property.getPropertyType());
            pstProperty.setString(COL_IMB_NUMBER, property.getImbNumber());
            pstProperty.setString(COL_OWNER, property.getOwner());
            pstProperty.setString(COL_LAND_SERTIFICATE_NUMBER, property.getLandSertificateNumber());
            pstProperty.setInt(COL_NUMBER_OF_FLOOR, property.getNumberOfFloor());
            pstProperty.setInt(COL_SELECT_FACILITIES_OTHER, property.getSelectFacilitiesOther());
            pstProperty.setString(COL_NAME_FACILITIES_OTHER, property.getNameFacilitiesOther());
            pstProperty.setString(COL_DESCRIPTION, property.getDescription());
            pstProperty.setInt(COL_PROPERTY_STATUS, property.getPropertyStatus());
            pstProperty.setString(COL_LOCATION_MAP, property.getLocationMap());
            pstProperty.setString(COL_CITY, property.getCity());
            pstProperty.setString(COL_LAND_AREA, property.getLandArea());
            pstProperty.setString(COL_BUILDING_AREA, property.getBuildingArea());
            pstProperty.setDate(COL_COMMENCEMENT, property.getCommencement());
            pstProperty.setDate(COL_COMPLETION, property.getCompletion());
            pstProperty.setString(COL_DEVELOPER, property.getDeveloper());

            pstProperty.insert();
            property.setOID(pstProperty.getlong(COL_PROPERTY_ID));


        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbProperty(0), CONException.UNKNOWN);
        }
        return property.getOID();
    }

    public static long updateExc(Property property) throws CONException {
        try {
            if (property.getOID() != 0) {
                DbProperty pstProperty = new DbProperty(property.getOID());

                pstProperty.setInt(COL_SALES_TYPE, property.getSalesType());
                pstProperty.setString(COL_BUILDING_NAME, property.getBuildingName());
                pstProperty.setLong(COL_LOCATION_ID, property.getLocationId());
                pstProperty.setString(COL_ADDRESS, property.getAddress());
                pstProperty.setInt(COL_PROPERTY_TYPE, property.getPropertyType());
                pstProperty.setString(COL_IMB_NUMBER, property.getImbNumber());
                pstProperty.setString(COL_OWNER, property.getOwner());
                pstProperty.setString(COL_LAND_SERTIFICATE_NUMBER, property.getLandSertificateNumber());
                pstProperty.setInt(COL_NUMBER_OF_FLOOR, property.getNumberOfFloor());
                pstProperty.setInt(COL_SELECT_FACILITIES_OTHER, property.getSelectFacilitiesOther());
                pstProperty.setString(COL_NAME_FACILITIES_OTHER, property.getNameFacilitiesOther());
                pstProperty.setString(COL_DESCRIPTION, property.getDescription());
                pstProperty.setInt(COL_PROPERTY_STATUS, property.getPropertyStatus());
                pstProperty.setString(COL_LOCATION_MAP, property.getLocationMap());
                pstProperty.setString(COL_CITY, property.getCity());
                pstProperty.setString(COL_LAND_AREA, property.getLandArea());
                pstProperty.setString(COL_BUILDING_AREA, property.getBuildingArea());
                pstProperty.setDate(COL_COMMENCEMENT, property.getCommencement());
                pstProperty.setDate(COL_COMPLETION, property.getCompletion());
                pstProperty.setString(COL_DEVELOPER, property.getDeveloper());

                pstProperty.update();
                return property.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbProperty(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbProperty pstProperty = new DbProperty(oid);
            pstProperty.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbProperty(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PROPERTY;
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
                Property property = new Property();
                resultToObject(rs, property);
                lists.add(property);
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

    private static void resultToObject(ResultSet rs, Property property) {
        try {
            property.setOID(rs.getLong(DbProperty.colNames[DbProperty.COL_PROPERTY_ID]));
            property.setSalesType(rs.getInt(DbProperty.colNames[DbProperty.COL_SALES_TYPE]));
            property.setBuildingName(rs.getString(DbProperty.colNames[DbProperty.COL_BUILDING_NAME]));
            property.setLocationId(rs.getLong(DbProperty.colNames[DbProperty.COL_LOCATION_ID]));
            property.setAddress(rs.getString(DbProperty.colNames[DbProperty.COL_ADDRESS]));
            property.setPropertyType(rs.getInt(DbProperty.colNames[DbProperty.COL_PROPERTY_TYPE]));
            property.setImbNumber(rs.getString(DbProperty.colNames[DbProperty.COL_IMB_NUMBER]));
            property.setOwner(rs.getString(DbProperty.colNames[DbProperty.COL_OWNER]));
            property.setLandSertificateNumber(rs.getString(DbProperty.colNames[DbProperty.COL_LAND_SERTIFICATE_NUMBER]));
            property.setNumberOfFloor(rs.getInt(DbProperty.colNames[DbProperty.COL_NUMBER_OF_FLOOR]));
            property.setSelectFacilitiesOther(rs.getInt(DbProperty.colNames[DbProperty.COL_SELECT_FACILITIES_OTHER]));
            property.setNameFacilitiesOther(rs.getString(DbProperty.colNames[DbProperty.COL_NAME_FACILITIES_OTHER]));
            property.setDescription(rs.getString(DbProperty.colNames[DbProperty.COL_DESCRIPTION]));
            property.setPropertyStatus(rs.getInt(DbProperty.colNames[DbProperty.COL_PROPERTY_STATUS]));
            property.setLocationMap(rs.getString(DbProperty.colNames[DbProperty.COL_LOCATION_MAP]));
            property.setCity(rs.getString(DbProperty.colNames[DbProperty.COL_CITY]));
            property.setLandArea(rs.getString(DbProperty.colNames[DbProperty.COL_LAND_AREA]));
            property.setBuildingArea(rs.getString(DbProperty.colNames[DbProperty.COL_BUILDING_AREA]));
            property.setCommencement(rs.getDate(DbProperty.colNames[DbProperty.COL_COMMENCEMENT]));
            property.setCompletion(rs.getDate(DbProperty.colNames[DbProperty.COL_COMPLETION]));
            property.setDeveloper(rs.getString(DbProperty.colNames[DbProperty.COL_DEVELOPER]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long propertyId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PROPERTY + " WHERE " +
                    DbProperty.colNames[DbProperty.COL_PROPERTY_ID] + " = " + propertyId;

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
            String sql = "SELECT COUNT(" + DbProperty.colNames[DbProperty.COL_PROPERTY_ID] + ") FROM " + DB_PROPERTY;
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
                    Property property = (Property) list.get(ls);
                    if (oid == property.getOID()) {
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

    public static Vector listProperty(String propertyName, String buildingName, long locationId) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT distinct property.* FROM " + DB_PROPERTY + " property inner join " + DbBuilding.DB_BUILDING +
                    " building on property." + DbProperty.colNames[DbProperty.COL_PROPERTY_ID] + " = building." + DbBuilding.colNames[DbBuilding.COL_PROPERTY_ID];

            String where = "";
            if (propertyName.length() > 0) {
                where = where + " property." + DbProperty.colNames[DbProperty.COL_BUILDING_NAME] + " like '%" + propertyName + "%' ";
            }

            if (buildingName.length() > 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }

                where = where + " building." + DbBuilding.colNames[DbBuilding.COL_BUILDING_NAME] + " like '%" + buildingName + "%' ";
            }

            if (locationId != 0) {
                if (where.length() > 0) {
                    where = where + " and ";
                }

                where = where + " property." + DbProperty.colNames[DbProperty.COL_LOCATION_ID] + " = " + locationId + " ";
            }

            if (where.length() > 0) {
                sql = sql + " where " + where+ " group by property."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID];
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Property property = new Property();

                property.setOID(rs.getLong("property." + DbProperty.colNames[DbProperty.COL_PROPERTY_ID]));
                property.setSalesType(rs.getInt("property." + DbProperty.colNames[DbProperty.COL_SALES_TYPE]));
                property.setBuildingName(rs.getString("property." + DbProperty.colNames[DbProperty.COL_BUILDING_NAME]));
                property.setLocationId(rs.getLong("property." + DbProperty.colNames[DbProperty.COL_LOCATION_ID]));
                property.setAddress(rs.getString("property." + DbProperty.colNames[DbProperty.COL_ADDRESS]));
                property.setPropertyType(rs.getInt("property." + DbProperty.colNames[DbProperty.COL_PROPERTY_TYPE]));
                property.setImbNumber(rs.getString("property." + DbProperty.colNames[DbProperty.COL_IMB_NUMBER]));
                property.setOwner(rs.getString("property." + DbProperty.colNames[DbProperty.COL_OWNER]));
                property.setLandSertificateNumber(rs.getString("property." + DbProperty.colNames[DbProperty.COL_LAND_SERTIFICATE_NUMBER]));
                property.setNumberOfFloor(rs.getInt("property." + DbProperty.colNames[DbProperty.COL_NUMBER_OF_FLOOR]));
                property.setSelectFacilitiesOther(rs.getInt("property." + DbProperty.colNames[DbProperty.COL_SELECT_FACILITIES_OTHER]));
                property.setNameFacilitiesOther(rs.getString("property." + DbProperty.colNames[DbProperty.COL_NAME_FACILITIES_OTHER]));
                property.setDescription(rs.getString("property." + DbProperty.colNames[DbProperty.COL_DESCRIPTION]));
                property.setPropertyStatus(rs.getInt("property." + DbProperty.colNames[DbProperty.COL_PROPERTY_STATUS]));
                property.setLocationMap(rs.getString("property." + DbProperty.colNames[DbProperty.COL_LOCATION_MAP]));
                property.setCity(rs.getString("property." + DbProperty.colNames[DbProperty.COL_CITY]));
                property.setLandArea(rs.getString("property." + DbProperty.colNames[DbProperty.COL_LAND_AREA]));
                property.setBuildingArea(rs.getString("property." + DbProperty.colNames[DbProperty.COL_BUILDING_AREA]));
                property.setCommencement(rs.getDate("property." + DbProperty.colNames[DbProperty.COL_COMMENCEMENT]));
                property.setCompletion(rs.getDate("property." + DbProperty.colNames[DbProperty.COL_COMPLETION]));
                property.setDeveloper(rs.getString("property." + DbProperty.colNames[DbProperty.COL_DEVELOPER]));

                lists.add(property);
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
}
