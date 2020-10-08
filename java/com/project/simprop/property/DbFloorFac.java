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
public class DbFloorFac extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    
    public static final String DB_FLOOR_FAC = "prop_floor_fac";
    
    public static final int COL_FLOOR_FAC_ID = 0;
    public static final int COL_FLOOR_ID = 1;
    public static final int COL_FLOOR_FACILITIES_ID = 2;
    public static final int COL_QTY = 3;
    
     public static final String[] colNames = {
        "floor_fac_id",
        "floor_id",
        "floor_facilities_id",
        "qty"
    };
     
     public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT
    };     
    
    public DbFloorFac() {
    }

    public DbFloorFac(int i) throws CONException {
        super(new DbFloorFac());
    }

    public DbFloorFac(String sOid) throws CONException {
        super(new DbFloorFac(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFloorFac(long lOid) throws CONException {
        super(new DbFloorFac(0));
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
        return DB_FLOOR_FAC;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbFloorFac().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        FloorFac floorFac = fetchExc(ent.getOID());
        ent = (Entity) floorFac;
        return floorFac.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((FloorFac) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((FloorFac) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static FloorFac fetchExc(long oid) throws CONException {
        try {
            
            FloorFac floorFac = new FloorFac();
            
            DbFloorFac pstFloorFacilities = new DbFloorFac(oid);            
            
            floorFac.setOID(oid);
            floorFac.setFloorId(pstFloorFacilities.getlong(COL_FLOOR_ID));
            floorFac.setFloorFacilitiesId(pstFloorFacilities.getlong(COL_FLOOR_FACILITIES_ID));
            floorFac.setQty(pstFloorFacilities.getInt(COL_QTY));

            return floorFac;
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloorFac(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(FloorFac floorFac) throws CONException {
        try {
            DbFloorFac pstFloorFac = new DbFloorFac(0);
            
            pstFloorFac.setLong(COL_FLOOR_ID, floorFac.getFloorId());
            pstFloorFac.setLong(COL_FLOOR_FACILITIES_ID, floorFac.getFloorFacilitiesId());
            pstFloorFac.setInt(COL_QTY, floorFac.getQty());
            
            pstFloorFac.insert();
            floorFac.setOID(pstFloorFac.getlong(COL_FLOOR_FAC_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloorFac(0), CONException.UNKNOWN);
        }
        return floorFac.getOID();
    }

    public static long updateExc(FloorFac floorFac) throws CONException {
        try {
            if (floorFac.getOID() != 0) {
                DbFloorFac pstFloorFac = new DbFloorFac(floorFac.getOID());
                
                pstFloorFac.setLong(COL_FLOOR_ID, floorFac.getFloorId());
                pstFloorFac.setLong(COL_FLOOR_FACILITIES_ID, floorFac.getFloorFacilitiesId());
                pstFloorFac.setInt(COL_QTY, floorFac.getQty());
                
                pstFloorFac.update();
                return floorFac.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloorFac(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFloorFac pstFloorFac = new DbFloorFac(oid);
            pstFloorFac.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloorFac(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_FLOOR_FAC;
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
                FloorFac floorFac = new FloorFac();
                resultToObject(rs, floorFac);
                lists.add(floorFac);
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

    private static void resultToObject(ResultSet rs, FloorFac floorFac) {
        try {            
            floorFac.setOID(rs.getLong(DbFloorFac.colNames[DbFloorFac.COL_FLOOR_FAC_ID]));
            floorFac.setFloorId(rs.getLong(DbFloorFac.colNames[DbFloorFac.COL_FLOOR_ID]));
            floorFac.setFloorFacilitiesId(rs.getLong(DbFloorFac.colNames[DbFloorFac.COL_FLOOR_FACILITIES_ID]));
            floorFac.setQty(rs.getInt(DbFloorFac.colNames[DbFloorFac.COL_QTY]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long floorFacilitiesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_FLOOR_FAC + " WHERE " +
                    DbFloorFac.colNames[DbFloorFac.COL_FLOOR_FACILITIES_ID] + " = " + floorFacilitiesId;

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
            String sql = "SELECT COUNT(" + DbFloorFac.colNames[DbFloorFac.COL_FLOOR_FACILITIES_ID] + ") FROM " + DB_FLOOR_FAC;
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
                    FloorFac floorFac = (FloorFac) list.get(ls);
                    if (oid == floorFac.getOID()) {
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
    
    public static Vector listFacilities(long floorId){
        
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        
        try {
            
            String sql = "SELECT * FROM " + DB_FLOOR_FAC+" where "+DbFloorFac.colNames[DbFloorFac.COL_FLOOR_ID]+" = "+floorId;
            
            dbrs = CONHandler.execQueryResult(sql);            
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()){
                FloorFac floorFac = new FloorFac();
                resultToObject(rs, floorFac);
                lists.add(floorFac);
            }
            return lists;
        }catch(Exception e){        
        }finally {
            CONResultSet.close(dbrs);
        }   
        return null;
        
    }
    
    
    public static void deleteList(long floorId){
        CONResultSet dbrs = null;        
        try {
            
            String sql = "DELETE FROM " + DB_FLOOR_FAC+" where "+DbFloorFac.colNames[DbFloorFac.COL_FLOOR_ID]+" = "+floorId;
            int i = CONHandler.execUpdate(sql);            
            
        }catch(Exception e){        
        }finally {
            CONResultSet.close(dbrs);
        }   
    }

}
