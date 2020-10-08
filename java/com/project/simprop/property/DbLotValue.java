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
public class DbLotValue extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{
    public static final String DB_LOT_VALUE = "prop_lot_value";
    
    public static final int COL_LOT_VALUE_ID = 0;
    public static final int COL_AMOUNT_HARD_CASH = 1;
    public static final int COL_AMOUNT_CASH_BY_TERMIN = 2;
    public static final int COL_AMOUNT_KPA = 3;
    public static final int COL_LOT_TYPE = 4;
    public static final int COL_LOT_QTY = 5;
    public static final int COL_FLOOR_ID = 6;
    public static final int COL_LOT_ID = 7;
    public static final int COL_LOT_FROM = 8;
    public static final int COL_LOT_TO = 9;    
    public static final int COL_RENTAL_RATE = 10;
    
     public static final String[] colNames = {
        "lot_value_id",
        "amount_hard_cash",
        "amount_cash_by_termin",
        "amount_kpa",
        "lot_type",
        "lot_qty",
        "floor_id",
        "lot_id",
        "lot_from",
        "lot_to",        
        "rental_rate"
     };    
     
      public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT ,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT
    };     
      
    public static final int TYPE_MAWAR = 0;
    public static final int TYPE_KAMBOJA = 1;
    public static final int TYPE_MELATI = 2;
    public static final int[] typeValue = {0,1,2};
    
    public static final String[] typeKey = {"Type Mawar", "Type Kamboja","Type Melati"};
    
    public DbLotValue() {
    }

    public DbLotValue(int i) throws CONException {
        super(new DbLotValue());
    }

    public DbLotValue(String sOid) throws CONException {
        super(new DbLotValue(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLotValue(long lOid) throws CONException {
        super(new DbLotValue(0));
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
        return DB_LOT_VALUE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLotValue().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LotValue lotValue = fetchExc(ent.getOID());
        ent = (Entity) lotValue;
        return lotValue.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LotValue) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LotValue) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }
    
    public static LotValue fetchExc(long oid) throws CONException {
        try {
            LotValue lotValue = new LotValue();
            DbLotValue pstLotType = new DbLotValue(oid);            
            lotValue.setOID(oid);
            
            lotValue.setAmountHardCash(pstLotType.getdouble(COL_AMOUNT_HARD_CASH));
            lotValue.setAmountCashByTermin(pstLotType.getdouble(COL_AMOUNT_CASH_BY_TERMIN));
            lotValue.setAmountKPA(pstLotType.getdouble(COL_AMOUNT_KPA));
            lotValue.setLotType(pstLotType.getlong(COL_LOT_TYPE));
            lotValue.setLotQty(pstLotType.getInt(COL_LOT_QTY));
            lotValue.setFloorId(pstLotType.getlong(COL_FLOOR_ID));
            lotValue.setLotId(pstLotType.getlong(COL_LOT_ID));            
            lotValue.setLotFrom(pstLotType.getInt(COL_LOT_FROM));
            lotValue.setLotTo(pstLotType.getInt(COL_LOT_TO));
            lotValue.setRentalRate(pstLotType.getdouble(COL_RENTAL_RATE));

            return lotValue;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotValue(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LotValue lotValue) throws CONException {
        try {
            DbLotValue pstLotTye = new DbLotValue(0);
            
            pstLotTye.setDouble(COL_AMOUNT_HARD_CASH, lotValue.getAmountHardCash());
            pstLotTye.setDouble(COL_AMOUNT_CASH_BY_TERMIN, lotValue.getAmountCashByTermin());
            pstLotTye.setDouble(COL_AMOUNT_KPA, lotValue.getAmountKPA());
            pstLotTye.setLong(COL_LOT_TYPE, lotValue.getLotType());           
            pstLotTye.setInt(COL_LOT_QTY, lotValue.getLotQty());               
            pstLotTye.setLong(COL_FLOOR_ID, lotValue.getFloorId());   
            pstLotTye.setLong(COL_LOT_ID, lotValue.getLotId());               
            pstLotTye.setInt(COL_LOT_FROM, lotValue.getLotFrom());   
            pstLotTye.setInt(COL_LOT_TO, lotValue.getLotTo());   
            pstLotTye.setDouble(COL_RENTAL_RATE, lotValue.getRentalRate());   
            pstLotTye.insert();
            lotValue.setOID(pstLotTye.getlong(COL_LOT_VALUE_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotValue(0), CONException.UNKNOWN);
        }
        return lotValue.getOID();
    }

    public static long updateExc(LotValue lotValue) throws CONException {
        try {
            if (lotValue.getOID() != 0) {
                DbLotValue pstLotTye = new DbLotValue(lotValue.getOID());
                
                pstLotTye.setDouble(COL_AMOUNT_HARD_CASH, lotValue.getAmountHardCash());
                pstLotTye.setDouble(COL_AMOUNT_CASH_BY_TERMIN, lotValue.getAmountCashByTermin());
                pstLotTye.setDouble(COL_AMOUNT_KPA, lotValue.getAmountKPA());
                pstLotTye.setLong(COL_LOT_TYPE, lotValue.getLotType());
                pstLotTye.setInt(COL_LOT_QTY, lotValue.getLotQty());
                pstLotTye.setLong(COL_FLOOR_ID, lotValue.getFloorId());   
                pstLotTye.setLong(COL_LOT_ID, lotValue.getLotId());   
                pstLotTye.setInt(COL_LOT_FROM, lotValue.getLotFrom());   
                pstLotTye.setInt(COL_LOT_TO, lotValue.getLotTo());   
                pstLotTye.setDouble(COL_RENTAL_RATE, lotValue.getRentalRate());   

                pstLotTye.update();
                return lotValue.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotValue(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLotValue pstLotTye = new DbLotValue(oid);
            pstLotTye.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLotValue(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LOT_VALUE;
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
                LotValue lotValue = new LotValue();
                resultToObject(rs, lotValue);
                lists.add(lotValue);
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

    private static void resultToObject(ResultSet rs, LotValue lotValue) {
        try {
            
            lotValue.setOID(rs.getLong(DbLotValue.colNames[DbLotValue.COL_LOT_VALUE_ID]));
            lotValue.setAmountHardCash(rs.getDouble(DbLotValue.colNames[DbLotValue.COL_AMOUNT_HARD_CASH]));
            lotValue.setAmountCashByTermin(rs.getDouble(DbLotValue.colNames[DbLotValue.COL_AMOUNT_CASH_BY_TERMIN]));
            lotValue.setAmountKPA(rs.getDouble(DbLotValue.colNames[DbLotValue.COL_AMOUNT_KPA]));
            lotValue.setLotType(rs.getLong(DbLotValue.colNames[DbLotValue.COL_LOT_TYPE]));
            lotValue.setLotQty(rs.getInt(DbLotValue.colNames[DbLotValue.COL_LOT_QTY]));
            lotValue.setFloorId(rs.getLong(DbLotValue.colNames[DbLotValue.COL_FLOOR_ID]));
            lotValue.setLotId(rs.getLong(DbLotValue.colNames[DbLotValue.COL_LOT_ID]));            
            lotValue.setLotFrom(rs.getInt(DbLotValue.colNames[DbLotValue.COL_LOT_FROM]));
            lotValue.setLotTo(rs.getInt(DbLotValue.colNames[DbLotValue.COL_LOT_TO]));
            lotValue.setRentalRate(rs.getDouble(DbLotValue.colNames[DbLotValue.COL_RENTAL_RATE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long lotTypeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOT_VALUE + " WHERE " +
                    DbLotValue.colNames[DbLotValue.COL_LOT_VALUE_ID] + " = " + lotTypeId;

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
            String sql = "SELECT COUNT(" + DbLotValue.colNames[DbLotValue.COL_LOT_VALUE_ID] + ") FROM " + DB_LOT_VALUE;
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
    
    
    public static int getSum(long floorId) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(" + DbLotValue.colNames[DbLotValue.COL_LOT_QTY] + ") FROM " + DB_LOT_VALUE+
            " where "+DbLotValue.colNames[DbLotValue.COL_FLOOR_ID]+" = "+floorId;

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
                    LotValue lotValue = (LotValue) list.get(ls);
                    if (oid == lotValue.getOID()) {
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

