/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.crm.master;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.simprop.property.DbBuilding;
import com.project.simprop.property.DbFloor;
import com.project.simprop.property.DbLotType;
import com.project.simprop.property.DbProperty;
import com.project.system.*;
import com.project.util.*;

/**
 *
 * @author Tu Roy
 */
public class DbLot extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_LOT = "crm_lot";
    public static final int COL_LOT_ID = 0;
    public static final int COL_NAMA = 1;
    public static final int COL_PANJANG = 2;
    public static final int COL_LEBAR = 3;
    public static final int COL_LUAS = 4;
    public static final int COL_KETERANGAN = 5;
    public static final int COL_STATUS = 6;
    public static final int COL_NO = 7;
    public static final int COL_FOREIGN_CURRENCY_ID = 8;
    public static final int COL_FOREIGN_AMOUNT = 9;
    public static final int COL_BOOKED_RATE = 10;
    public static final int COL_AMOUNT = 11;
    public static final int COL_NAME_PIC = 12;
    public static final int COL_PROPERTY_ID = 13;
    public static final int COL_FLOOR_ID = 14;
    public static final int COL_BUILDING_ID = 15;    
    public static final int COL_CASH_KERAS = 16;
    public static final int COL_CASH_BY_TERMIN = 17;
    public static final int COL_KPA = 18;
    public static final int COL_LOT_VALUE_ID = 19;
    public static final int COL_RENTAL_RATE = 20;
    public static final int COL_LOT_TYPE_ID = 21;
    public static final int COL_LUAS_TANAH = 22;
    public static final int COL_LUAS_BANGUNAN = 23;
    
    public static final String[] colNames = {
        "lot_id",
        "nama",
        "panjang",
        "lebar",
        "luas",
        "keterangan",
        "status",
        "no",
        "foreign_currency_id",
        "foreign_amount",
        "booked_rate",
        "amount",
        "name_pic",
        "property_id",
        "floor_id",
        "building_id",
        "cash_keras",
        "cash_by_termin",
        "kpa",
        "lot_value_id",
        "rental_rate",
        "lot_type_id",
        "luas_tanah",
        "luas_bangunan"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT
    };
    
    public static final int STS_KOSONG = 0;
    public static final int STS_SUDAH_SEWA = 1;
    public static final int STS_AKTIF = 2;
    public static final String[] stsValue = {"0", "1", "2"};
    public static final String[] stsKey = {"Kosong", "Sudah disewa", "Tidak aktif"};
    
    //available, reservation, booked, dan sold
    public static final int LOT_STATUS_AVAILABLE = 0;
    public static final int LOT_STATUS_RESERVATION = 1;
    public static final int LOT_STATUS_BOOKED = 2;
    public static final int LOT_STATUS_SOLD = 3;
    public static final int LOT_STATUS_RENTED = 4;
    
    public static final int[] lotStatusValue = {0, 1, 2, 3,4};
    public static final String[] lotStatusKey = {"AVAILABLE", "RESERVATION", "BOOKED", "SOLD","RENTED"};
    
    public static final int LOT_0 = 0;
    public static final int LOT_1 = 1;
    public static final int LOT_2 = 2;
    public static final int LOT_3 = 3;
    public static final int LOT_4 = 4;
    public static final int LOT_5 = 5;
    public static final int LOT_6 = 6;
    public static final int LOT_7 = 7;
    public static final int LOT_8 = 8;
    public static final int LOT_9 = 9;
    public static final int LOT_10 = 10;
    public static final int LOT_11 = 11;
    public static final int LOT_12 = 12;
    public static final int LOT_13 = 13;
    public static final int LOT_14 = 14;
    public static final int LOT_15 = 15;
    
    public static final int[] lotValue = {0, 1, 2, 3,4,5,6,7,8,9,10,11,12,13,14,15};
    public static final String[] lotKey = {"0", "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"};

    public DbLot() {
    }

    public DbLot(int i) throws CONException {
        super(new DbLot());
    }

    public DbLot(String sOid) throws CONException {

        super(new DbLot(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLot(long lOid) throws CONException {
        super(new DbLot(0));
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
        return DB_LOT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLot().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Lot lot = fetchExc(ent.getOID());
        ent = (Entity) lot;
        return lot.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Lot) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Lot) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Lot fetchExc(long oid) throws CONException {
        try {

            Lot lot = new Lot();
            DbLot dbLot = new DbLot(oid);

            lot.setOID(oid);
            lot.setNama(dbLot.getString(COL_NAMA));
            lot.setPanjang(dbLot.getdouble(COL_PANJANG));
            lot.setLebar(dbLot.getdouble(COL_LEBAR));
            lot.setKeterangan(dbLot.getString(COL_KETERANGAN));
            lot.setStatus(dbLot.getInt(COL_STATUS));
            lot.setNo(dbLot.getInt(COL_NO));
            lot.setForeignCurrencyId(dbLot.getlong(COL_FOREIGN_CURRENCY_ID));
            lot.setForeignAmount(dbLot.getdouble(COL_FOREIGN_AMOUNT));
            lot.setBookedRate(dbLot.getdouble(COL_BOOKED_RATE));
            lot.setAmount(dbLot.getdouble(COL_AMOUNT));
            lot.setNamePic(dbLot.getString(COL_NAME_PIC));
            lot.setPropertyId(dbLot.getlong(COL_PROPERTY_ID));
            lot.setFloorId(dbLot.getlong(COL_FLOOR_ID));
            lot.setBuildingId(dbLot.getlong(COL_BUILDING_ID));            
            lot.setCashKeras(dbLot.getdouble(COL_CASH_KERAS));
            lot.setCashByTermin(dbLot.getdouble(COL_CASH_BY_TERMIN));
            lot.setKpa(dbLot.getdouble(COL_KPA));
            lot.setLotValueId(dbLot.getlong(COL_LOT_VALUE_ID));
            lot.setRentalRate(dbLot.getdouble(COL_RENTAL_RATE));
            lot.setLotTypeId(dbLot.getlong(COL_LOT_TYPE_ID));
            lot.setLuasTanah(dbLot.getdouble(COL_LUAS_TANAH));
            lot.setLuasBangunan(dbLot.getdouble(COL_LUAS_BANGUNAN));

            return lot;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Lot lot) throws CONException {
        try {

            DbLot dbLot = new DbLot(0);
            dbLot.setString(COL_NAMA, lot.getNama());
            dbLot.setDouble(COL_PANJANG, lot.getPanjang());
            dbLot.setDouble(COL_LEBAR, lot.getLebar());
            dbLot.setDouble(COL_LUAS, lot.getLuas());
            dbLot.setString(COL_KETERANGAN, lot.getKeterangan());
            dbLot.setInt(COL_STATUS, lot.getStatus());
            dbLot.setInt(COL_NO, lot.getNo());
            dbLot.setLong(COL_FOREIGN_CURRENCY_ID, lot.getForeignCurrencyId());
            dbLot.setDouble(COL_FOREIGN_AMOUNT, lot.getForeignAmount());
            dbLot.setDouble(COL_BOOKED_RATE, lot.getBookedRate());
            dbLot.setDouble(COL_AMOUNT, lot.getAmount());
            dbLot.setString(COL_NAME_PIC, lot.getNamePic());
            dbLot.setLong(COL_PROPERTY_ID, lot.getPropertyId());
            dbLot.setLong(COL_FLOOR_ID, lot.getFloorId());
            dbLot.setLong(COL_BUILDING_ID, lot.getBuildingId());            
            dbLot.setDouble(COL_CASH_KERAS, lot.getCashKeras());
            dbLot.setDouble(COL_CASH_BY_TERMIN, lot.getCashByTermin());
            dbLot.setDouble(COL_KPA, lot.getKpa());
            dbLot.setLong(COL_LOT_VALUE_ID, lot.getLotValueId());
            dbLot.setDouble(COL_RENTAL_RATE, lot.getRentalRate());
            dbLot.setLong(COL_LOT_TYPE_ID, lot.getLotTypeId());
            
            dbLot.setDouble(COL_LUAS_TANAH, lot.getLuasTanah());
            dbLot.setDouble(COL_LUAS_BANGUNAN, lot.getLuasBangunan());

            dbLot.insert();
            lot.setOID(dbLot.getlong(COL_LOT_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
        }
        return lot.getOID();
    }

    public static long updateExc(Lot lot) throws CONException {
        try {
            if (lot.getOID() != 0) {
                DbLot dbLot = new DbLot(lot.getOID());
                dbLot.setString(COL_NAMA, lot.getNama());
                dbLot.setDouble(COL_PANJANG, lot.getPanjang());
                dbLot.setDouble(COL_LEBAR, lot.getLebar());
                dbLot.setDouble(COL_LUAS, lot.getLuas());
                dbLot.setString(COL_KETERANGAN, lot.getKeterangan());
                dbLot.setInt(COL_STATUS, lot.getStatus());
                dbLot.setInt(COL_NO, lot.getNo());
                dbLot.setLong(COL_FOREIGN_CURRENCY_ID, lot.getForeignCurrencyId());
                dbLot.setDouble(COL_FOREIGN_AMOUNT, lot.getForeignAmount());
                dbLot.setDouble(COL_BOOKED_RATE, lot.getBookedRate());
                dbLot.setDouble(COL_AMOUNT, lot.getAmount());
                dbLot.setString(COL_NAME_PIC, lot.getNamePic());
                dbLot.setLong(COL_PROPERTY_ID, lot.getPropertyId());
                dbLot.setLong(COL_FLOOR_ID, lot.getFloorId());
                dbLot.setLong(COL_BUILDING_ID, lot.getBuildingId());                
                dbLot.setDouble(COL_CASH_KERAS, lot.getCashKeras());
                dbLot.setDouble(COL_CASH_BY_TERMIN, lot.getCashByTermin());
                dbLot.setDouble(COL_KPA, lot.getKpa());
                dbLot.setLong(COL_LOT_VALUE_ID, lot.getLotValueId());
                dbLot.setDouble(COL_RENTAL_RATE, lot.getRentalRate());
                dbLot.setLong(COL_LOT_TYPE_ID, lot.getLotTypeId());
                dbLot.setDouble(COL_LUAS_TANAH, lot.getLuasTanah());
                dbLot.setDouble(COL_LUAS_BANGUNAN, lot.getLuasBangunan());

                dbLot.update();

                return lot.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLot dbLot = new DbLot(oid);
            dbLot.delete();

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LOT;
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
                Lot lot = new Lot();
                resultToObject(rs, lot);
                lists.add(lot);
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

    public static void resultToObject(ResultSet rs, Lot lot) {
        try {
            lot.setOID(rs.getLong(DbLot.colNames[DbLot.COL_LOT_ID]));
            lot.setNama(rs.getString(DbLot.colNames[DbLot.COL_NAMA]));
            lot.setPanjang(rs.getDouble(DbLot.colNames[DbLot.COL_PANJANG]));
            lot.setLebar(rs.getDouble(DbLot.colNames[DbLot.COL_LEBAR]));
            lot.setKeterangan(rs.getString(DbLot.colNames[DbLot.COL_KETERANGAN]));
            lot.setStatus(rs.getInt(DbLot.colNames[DbLot.COL_STATUS]));
            lot.setNo(rs.getInt(DbLot.colNames[DbLot.COL_NO]));
            lot.setForeignCurrencyId(rs.getLong(DbLot.colNames[DbLot.COL_FOREIGN_CURRENCY_ID]));
            lot.setForeignAmount(rs.getDouble(DbLot.colNames[DbLot.COL_FOREIGN_AMOUNT]));
            lot.setBookedRate(rs.getDouble(DbLot.colNames[DbLot.COL_BOOKED_RATE]));
            lot.setAmount(rs.getDouble(DbLot.colNames[DbLot.COL_AMOUNT]));
            lot.setNamePic(rs.getString(DbLot.colNames[DbLot.COL_NAME_PIC]));
            lot.setPropertyId(rs.getLong(DbLot.colNames[DbLot.COL_PROPERTY_ID]));
            lot.setFloorId(rs.getLong(DbLot.colNames[DbLot.COL_FLOOR_ID]));
            lot.setBuildingId(rs.getLong(DbLot.colNames[DbLot.COL_BUILDING_ID]));            
            lot.setCashKeras(rs.getDouble(DbLot.colNames[DbLot.COL_CASH_KERAS]));
            lot.setCashByTermin(rs.getDouble(DbLot.colNames[DbLot.COL_CASH_BY_TERMIN]));
            lot.setKpa(rs.getDouble(DbLot.colNames[DbLot.COL_KPA]));
            lot.setLotValueId(rs.getLong(DbLot.colNames[DbLot.COL_LOT_VALUE_ID]));
            lot.setRentalRate(rs.getDouble(DbLot.colNames[DbLot.COL_RENTAL_RATE]));
            lot.setLotTypeId(rs.getLong(DbLot.colNames[DbLot.COL_LOT_TYPE_ID]));
            
            lot.setLuasTanah(rs.getDouble(DbLot.colNames[DbLot.COL_LUAS_TANAH]));
            lot.setLuasBangunan(rs.getDouble(DbLot.colNames[DbLot.COL_LUAS_BANGUNAN]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long lotId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOT + " WHERE " +
                    DbLot.colNames[DbLot.COL_LOT_ID] + " = " + lotId;

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
            String sql = "SELECT COUNT(" + DbLot.colNames[DbLot.COL_LOT_ID] + ") FROM " + DB_LOT;
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
    
    public static void del(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + DbLot.DB_LOT;
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
                    Lot lot = (Lot) list.get(ls);
                    if (oid == lot.getOID()) {
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
    
    public void deleteByFloorId(long oidFloor){
    	
    	try{
    		CONHandler.execUpdate("delete from "+DB_LOT+" where "+colNames[COL_FLOOR_ID]+"="+oidFloor);
    	}
    	catch(Exception e){
    		System.out.println("exception : "+ e.toString());
    	}
    	
    }
    
    public void deleteByBuildingId(long oidBuilding){
    	
    	try{
    		CONHandler.execUpdate("delete from "+DB_LOT+" where "+colNames[COL_BUILDING_ID]+"="+oidBuilding);
    	}
    	catch(Exception e){
    		System.out.println("exception : "+ e.toString());
    	}
    	
    }
    
    public void deleteByPropertyId(long oidProperty){
    	
    	try{
    		CONHandler.execUpdate("delete from "+DB_LOT+" where "+colNames[COL_PROPERTY_ID]+"="+oidProperty);
    	}
    	catch(Exception e){
    		System.out.println("exception : "+ e.toString());
    	}
    	
    }
    
    public static Vector listAvailable(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT lot.* FROM " + DB_LOT+" lot inner join "+DbProperty.DB_PROPERTY+" prop on "+
                    " lot."+DbLot.colNames[DbLot.COL_PROPERTY_ID]+" = prop."+DbProperty.colNames[DbProperty.COL_PROPERTY_ID]+
                    " inner join "+DbBuilding.DB_BUILDING+" b on lot."+DbLot.colNames[DbLot.COL_BUILDING_ID]+" = b."+DbBuilding.colNames[DbBuilding.COL_BUILDING_ID]+
                    " inner join "+DbFloor.DB_FLOOR+" floor on lot."+DbLot.colNames[DbLot.COL_FLOOR_ID]+" = floor."+DbFloor.colNames[DbFloor.COL_FLOOR_ID]+
                    " inner join "+DbLotType.DB_LOT_TYPE+" lt on lot."+DbLot.colNames[DbLot.COL_LOT_TYPE_ID]+" = lt."+DbLotType.colNames[DbLotType.COL_LOT_TYPE_ID];
            
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
                Lot lot = new Lot();
                resultToObject(rs, lot);
                lists.add(lot);
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
