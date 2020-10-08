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
public class DbFacilities extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    
    public static final String DB_FACILITIES = "prop_facilities";
    
    public static final int COL_FACILITIES_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_DISCRIPTION = 2;
    
     public static final String[] colNames = {
        "facilities_id",
        "name",
        "discription"
    };
     
     public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };     
    
     public DbFacilities() {
    }

    public DbFacilities(int i) throws CONException {
        super(new DbFacilities());
    }

    public DbFacilities(String sOid) throws CONException {
        super(new DbFacilities(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFacilities(long lOid) throws CONException {
        super(new DbFacilities(0));
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
        return DB_FACILITIES;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbFacilities().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Facilities facilities = fetchExc(ent.getOID());
        ent = (Entity) facilities;
        return facilities.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Facilities) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Facilities) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Facilities fetchExc(long oid) throws CONException {
        try {
            Facilities facilities = new Facilities();
            DbFacilities pstFacilities = new DbFacilities(oid);            
            
            facilities.setOID(oid);
            facilities.setName(pstFacilities.getString(COL_NAME));
            facilities.setDiscription(pstFacilities.getString(COL_DISCRIPTION));

            return facilities;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFacilities(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Facilities facilities) throws CONException {
        try {
            DbFacilities pstFacilities = new DbFacilities(0);
            
            pstFacilities.setString(COL_NAME, facilities.getName());
            pstFacilities.setString(COL_DISCRIPTION, facilities.getDiscription());
            
            pstFacilities.insert();
            facilities.setOID(pstFacilities.getlong(COL_FACILITIES_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFacilities(0), CONException.UNKNOWN);
        }
        return facilities.getOID();
    }

    public static long updateExc(Facilities facilities) throws CONException {
        try {
            if (facilities.getOID() != 0) {
                DbFacilities pstFacilities = new DbFacilities(facilities.getOID());
                
                pstFacilities.setString(COL_NAME, facilities.getName());
                pstFacilities.setString(COL_DISCRIPTION, facilities.getDiscription());
                
                pstFacilities.update();
                return facilities.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFacilities(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFacilities pstFacilities = new DbFacilities(oid);
            pstFacilities.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFacilities(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_FACILITIES;
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
                Facilities facilities = new Facilities();
                resultToObject(rs, facilities);
                lists.add(facilities);
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

    private static void resultToObject(ResultSet rs, Facilities facilities) {
        try {            
            facilities.setOID(rs.getLong(DbFacilities.colNames[DbFacilities.COL_FACILITIES_ID]));
            facilities.setName(rs.getString(DbFacilities.colNames[DbFacilities.COL_NAME]));
            facilities.setDiscription(rs.getString(DbFacilities.colNames[DbFacilities.COL_DISCRIPTION]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long facilitiesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_FACILITIES + " WHERE " +
                    DbFacilities.colNames[DbFacilities.COL_FACILITIES_ID] + " = " + facilitiesId;

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
            String sql = "SELECT COUNT(" + DbFacilities.colNames[DbFacilities.COL_FACILITIES_ID] + ") FROM " + DB_FACILITIES;
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
                    Facilities facilities = (Facilities) list.get(ls);
                    if (oid == facilities.getOID()) {
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
