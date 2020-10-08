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
public class DbLotFac extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    
    public static final String DB_LOT_FAC = "prop_lot_fac";
    
    public static final int COL_LOT_FAC_ID = 0;
    public static final int COL_LOT_ID = 1;
    public static final int COL_LOT_FACILITIES_ID = 2;
    public static final int COL_QTY = 3;
    
     public static final String[] colNames = {
        "lot_fac_id",
        "lot_id",
        "lot_facilities_id",
        "qty"
    };
     
     public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT
    };     
    
    public DbLotFac() {
    }

    public DbLotFac(int i) throws CONException {
        super(new DbLotFac());
    }

    public DbLotFac(String sOid) throws CONException {
        super(new DbLotFac(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLotFac(long lOid) throws CONException {
        super(new DbLotFac(0));
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
        return DB_LOT_FAC;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLotFac().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LotFac lotFacilities = fetchExc(ent.getOID());
        ent = (Entity) lotFacilities;
        return lotFacilities.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LotFac) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LotFac) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static LotFac fetchExc(long oid) throws CONException {
        try {
            
            LotFac lotFac = new LotFac();
            
            DbLotFac pstLotFacilities = new DbLotFac(oid);            
            
            lotFac.setOID(oid);
            lotFac.setLotId(pstLotFacilities.getlong(COL_LOT_ID));
            lotFac.setLotFacilitiesId(pstLotFacilities.getlong(COL_LOT_FACILITIES_ID));
            lotFac.setQty(pstLotFacilities.getInt(COL_QTY));

            return lotFac;
            
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotFac(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LotFac lotFac) throws CONException {
        try {
            DbLotFac pstLotFac = new DbLotFac(0);
            
            pstLotFac.setLong(COL_LOT_ID, lotFac.getLotId());
            pstLotFac.setLong(COL_LOT_FACILITIES_ID, lotFac.getLotFacilitiesId());
            pstLotFac.setInt(COL_QTY, lotFac.getQty());
            
            pstLotFac.insert();
            lotFac.setOID(pstLotFac.getlong(COL_LOT_FAC_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotFac(0), CONException.UNKNOWN);
        }
        return lotFac.getOID();
    }

    public static long updateExc(LotFac lotFac) throws CONException {
        try {
            if (lotFac.getOID() != 0) {
                DbLotFac pstLotFac = new DbLotFac(lotFac.getOID());
                
                pstLotFac.setLong(COL_LOT_ID, lotFac.getLotId());
                pstLotFac.setLong(COL_LOT_FACILITIES_ID, lotFac.getLotFacilitiesId());
                pstLotFac.setInt(COL_QTY, lotFac.getQty());
                
                pstLotFac.update();
                return lotFac.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotFac(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLotFac pstLotFac = new DbLotFac(oid);
            pstLotFac.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotFac(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LOT_FAC;
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
                LotFac lotFacilities = new LotFac();
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

    private static void resultToObject(ResultSet rs, LotFac lotFac) {
        try {            
            lotFac.setOID(rs.getLong(DbLotFac.colNames[DbLotFac.COL_LOT_FAC_ID]));
            lotFac.setLotId(rs.getLong(DbLotFac.colNames[DbLotFac.COL_LOT_ID]));
            lotFac.setLotFacilitiesId(rs.getLong(DbLotFac.colNames[DbLotFac.COL_LOT_FACILITIES_ID]));
            lotFac.setQty(rs.getInt(DbLotFac.colNames[DbLotFac.COL_QTY]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long lotFacilitiesId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOT_FAC + " WHERE " +
                    DbLotFac.colNames[DbLotFac.COL_LOT_FACILITIES_ID] + " = " + lotFacilitiesId;

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
            String sql = "SELECT COUNT(" + DbLotFac.colNames[DbLotFac.COL_LOT_FACILITIES_ID] + ") FROM " + DB_LOT_FAC;
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
                    LotFac lotFacilities = (LotFac) list.get(ls);
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
    
    public static Vector listFacilities(long lotId){
        
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        
        try {
            
            String sql = "SELECT * FROM " + DB_LOT_FAC+" where "+DbLotFac.colNames[DbLotFac.COL_LOT_ID]+" = "+lotId;
            
            dbrs = CONHandler.execQueryResult(sql);            
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()){
                LotFac lotFacilities = new LotFac();
                resultToObject(rs, lotFacilities);
                lists.add(lotFacilities);
            }
            return lists;
        }catch(Exception e){        
        }finally {
            CONResultSet.close(dbrs);
        }   
        return null;
        
    }
    
    
    public static void deleteList(long lotId){
        CONResultSet dbrs = null;        
        try {
            
            String sql = "DELETE FROM " + DB_LOT_FAC+" where "+DbLotFac.colNames[DbLotFac.COL_LOT_ID]+" = "+lotId;
            int i = CONHandler.execUpdate(sql);            
            
        }catch(Exception e){        
        }finally {
            CONResultSet.close(dbrs);
        }   
    }

}
