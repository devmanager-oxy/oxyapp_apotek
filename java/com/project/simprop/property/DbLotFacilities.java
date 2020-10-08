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
public class DbLotFacilities extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    
    public static final String DB_LOT_FACILITIES = "prop_lot_facilities";
    
    public static final int COL_LOT_FACILITIES_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_DESCRIPTION = 2;
    
     public static final String[] colNames = {
        "lot_facilities_id",
        "name",
        "description"
    };
     
     public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING
    };     
    
    public DbLotFacilities() {
    }

    public DbLotFacilities(int i) throws CONException {
        super(new DbLotFacilities());
    }

    public DbLotFacilities(String sOid) throws CONException {
        super(new DbLotFacilities(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLotFacilities(long lOid) throws CONException {
        super(new DbLotFacilities(0));
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
        return DB_LOT_FACILITIES;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLotFacilities().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LotFacilities lotFacilities = fetchExc(ent.getOID());
        ent = (Entity) lotFacilities;
        return lotFacilities.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LotFacilities) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LotFacilities) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static LotFacilities fetchExc(long oid) throws CONException {
        try {
            LotFacilities lotFacilities = new LotFacilities();
            DbLotFacilities pstLotFacilities = new DbLotFacilities(oid);            
            
            lotFacilities.setOID(oid);
            lotFacilities.setName(pstLotFacilities.getString(COL_NAME));
            lotFacilities.setDescription(pstLotFacilities.getString(COL_DESCRIPTION));

            return lotFacilities;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotFacilities(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LotFacilities lotFacilities) throws CONException {
        try {
            DbLotFacilities pstLotFacilities = new DbLotFacilities(0);
            
            pstLotFacilities.setString(COL_NAME, lotFacilities.getName());
            pstLotFacilities.setString(COL_DESCRIPTION, lotFacilities.getDescription());
            
            pstLotFacilities.insert();
            lotFacilities.setOID(pstLotFacilities.getlong(COL_LOT_FACILITIES_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotFacilities(0), CONException.UNKNOWN);
        }
        return lotFacilities.getOID();
    }

    public static long updateExc(LotFacilities lotFacilities) throws CONException {
        try {
            if (lotFacilities.getOID() != 0) {
                DbLotFacilities pstLotFacilities = new DbLotFacilities(lotFacilities.getOID());
                
                pstLotFacilities.setString(COL_NAME, lotFacilities.getName());
                pstLotFacilities.setString(COL_DESCRIPTION, lotFacilities.getDescription());
                
                pstLotFacilities.update();
                return lotFacilities.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotFacilities(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLotFacilities pstLotFacilities = new DbLotFacilities(oid);
            pstLotFacilities.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotFacilities(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LOT_FACILITIES;
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
                LotFacilities lotFacilities = new LotFacilities();
                resultToObject(rs, lotFacilities);
                lists.add(lotFacilities);
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

    private static void resultToObject(ResultSet rs, LotFacilities lotFacilities) {
        try {            
            lotFacilities.setOID(rs.getLong(DbLotFacilities.colNames[DbLotFacilities.COL_LOT_FACILITIES_ID]));
            lotFacilities.setName(rs.getString(DbLotFacilities.colNames[DbLotFacilities.COL_NAME]));
            lotFacilities.setDescription(rs.getString(DbLotFacilities.colNames[DbLotFacilities.COL_DESCRIPTION]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long lotFacilitiesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOT_FACILITIES + " WHERE " +
                    DbLotFacilities.colNames[DbLotFacilities.COL_LOT_FACILITIES_ID] + " = " + lotFacilitiesId;

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
            String sql = "SELECT COUNT(" + DbLotFacilities.colNames[DbLotFacilities.COL_LOT_FACILITIES_ID] + ") FROM " + DB_LOT_FACILITIES;
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
                    LotFacilities lotFacilities = (LotFacilities) list.get(ls);
                    if (oid == lotFacilities.getOID()) {
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
