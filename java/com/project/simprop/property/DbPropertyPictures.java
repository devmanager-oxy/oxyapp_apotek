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
public class DbPropertyPictures extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_PROPERTY_PICTURES = "prop_property_pictures";
    public static final int COL_PROPERTY_PICTURES_ID = 0;
    public static final int COL_PROPERTY_ID = 1;
    public static final int COL_NAME_PIC = 2;
    public static final int COL_DISCRIPTION = 3;
    
    public static final String[] colNames = {
        "property_pictures_id",
        "property_id",
        "name_pic",
        "discription"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };     
    
    public DbPropertyPictures() {
    }

    public DbPropertyPictures(int i) throws CONException {
        super(new DbPropertyPictures());
    }

    public DbPropertyPictures(String sOid) throws CONException {
        super(new DbPropertyPictures(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPropertyPictures(long lOid) throws CONException {
        super(new DbPropertyPictures(0));
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
        return DB_PROPERTY_PICTURES;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPropertyPictures().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PropertyPictures propertyPictures = fetchExc(ent.getOID());
        ent = (Entity) propertyPictures;
        return propertyPictures.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PropertyPictures) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PropertyPictures) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PropertyPictures fetchExc(long oid) throws CONException {
        try {
            PropertyPictures propertyPictures = new PropertyPictures();
            DbPropertyPictures pstPropertyPictures = new DbPropertyPictures(oid);
            propertyPictures.setOID(oid);

            propertyPictures.setPropertyId(pstPropertyPictures.getlong(COL_PROPERTY_ID));
            propertyPictures.setNamePic(pstPropertyPictures.getString(COL_NAME_PIC));
            propertyPictures.setDiscription(pstPropertyPictures.getString(COL_DISCRIPTION));

            return propertyPictures;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPropertyPictures(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PropertyPictures propertyPictures) throws CONException {
        try {
            DbPropertyPictures pstPropertyPictures = new DbPropertyPictures(0);

            pstPropertyPictures.setLong(COL_PROPERTY_ID, propertyPictures.getPropertyId());
            pstPropertyPictures.setString(COL_NAME_PIC, propertyPictures.getNamePic());
            pstPropertyPictures.setString(COL_DISCRIPTION, propertyPictures.getDiscription());
            
            pstPropertyPictures.insert();
            propertyPictures.setOID(pstPropertyPictures.getlong(COL_PROPERTY_PICTURES_ID));


        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPropertyPictures(0), CONException.UNKNOWN);
        }
        return propertyPictures.getOID();
    }

    public static long updateExc(PropertyPictures propertyPictures) throws CONException {
        try {
            if (propertyPictures.getOID() != 0) {
                DbPropertyPictures pstPropertyPictures = new DbPropertyPictures(propertyPictures.getOID());
                
                pstPropertyPictures.setLong(COL_PROPERTY_ID, propertyPictures.getPropertyId());
                pstPropertyPictures.setString(COL_NAME_PIC, propertyPictures.getNamePic());
                pstPropertyPictures.setString(COL_DISCRIPTION, propertyPictures.getDiscription());

                pstPropertyPictures.update();
                return propertyPictures.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPropertyPictures(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPropertyPictures pstPropertyPictures = new DbPropertyPictures(oid);
            pstPropertyPictures.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPropertyPictures(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PROPERTY_PICTURES;
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
                PropertyPictures propertyPictures = new PropertyPictures();
                resultToObject(rs, propertyPictures);
                lists.add(propertyPictures);
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

    private static void resultToObject(ResultSet rs, PropertyPictures propertyPictures) {
        try {
            propertyPictures.setOID(rs.getLong(DbPropertyPictures.colNames[DbPropertyPictures.COL_PROPERTY_PICTURES_ID]));
            propertyPictures.setPropertyId(rs.getLong(DbPropertyPictures.colNames[DbPropertyPictures.COL_PROPERTY_ID]));
            propertyPictures.setNamePic(rs.getString(DbPropertyPictures.colNames[DbPropertyPictures.COL_NAME_PIC]));
            propertyPictures.setDiscription(rs.getString(DbPropertyPictures.colNames[DbPropertyPictures.COL_DISCRIPTION]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long propertyPicturesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PROPERTY_PICTURES + " WHERE " +
                    DbPropertyPictures.colNames[DbPropertyPictures.COL_PROPERTY_ID] + " = " + propertyPicturesId;

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
            String sql = "SELECT COUNT(" + DbPropertyPictures.colNames[DbPropertyPictures.COL_PROPERTY_ID] + ") FROM " + DB_PROPERTY_PICTURES;
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
                    PropertyPictures propertyPictures = (PropertyPictures) list.get(ls);
                    if (oid == propertyPictures.getOID()) {
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
