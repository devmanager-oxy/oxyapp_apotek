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
import com.project.general.*;
import com.project.system.*;
import com.project.util.*;

/**
 *
 * @author Tu Roy
 */
public class DbLotProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_LOT = "prop_lot";
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
    
    public static final String[] colNames = {
        "lotProp_id",
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
        "lotProp_value_id",
        "rental_rate",
        "lotProp_type_id"
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
        TYPE_LONG
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

    public DbLotProp() {
    }

    public DbLotProp(int i) throws CONException {
        super(new DbLotProp());
    }

    public DbLotProp(String sOid) throws CONException {

        super(new DbLotProp(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLotProp(long lOid) throws CONException {
        super(new DbLotProp(0));
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
        return new DbLotProp().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LotProp lotProp = fetchExc(ent.getOID());
        ent = (Entity) lotProp;
        return lotProp.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LotProp) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LotProp) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static LotProp fetchExc(long oid) throws CONException {
        try {

            LotProp lotProp = new LotProp();
            DbLotProp dbLot = new DbLotProp(oid);

            lotProp.setOID(oid);
            lotProp.setNama(dbLot.getString(COL_NAMA));
            lotProp.setPanjang(dbLot.getdouble(COL_PANJANG));
            lotProp.setLebar(dbLot.getdouble(COL_LEBAR));
            lotProp.setKeterangan(dbLot.getString(COL_KETERANGAN));
            lotProp.setStatus(dbLot.getInt(COL_STATUS));
            lotProp.setNo(dbLot.getInt(COL_NO));
            lotProp.setForeignCurrencyId(dbLot.getlong(COL_FOREIGN_CURRENCY_ID));
            lotProp.setForeignAmount(dbLot.getdouble(COL_FOREIGN_AMOUNT));
            lotProp.setBookedRate(dbLot.getdouble(COL_BOOKED_RATE));
            lotProp.setAmount(dbLot.getdouble(COL_AMOUNT));
            lotProp.setNamePic(dbLot.getString(COL_NAME_PIC));
            lotProp.setPropertyId(dbLot.getlong(COL_PROPERTY_ID));
            lotProp.setFloorId(dbLot.getlong(COL_FLOOR_ID));
            lotProp.setBuildingId(dbLot.getlong(COL_BUILDING_ID));            
            lotProp.setCashKeras(dbLot.getdouble(COL_CASH_KERAS));
            lotProp.setCashByTermin(dbLot.getdouble(COL_CASH_BY_TERMIN));
            lotProp.setKpa(dbLot.getdouble(COL_KPA));
            lotProp.setLotValueId(dbLot.getlong(COL_LOT_VALUE_ID));
            lotProp.setRentalRate(dbLot.getdouble(COL_RENTAL_RATE));
            lotProp.setLotTypeId(dbLot.getlong(COL_LOT_TYPE_ID));

            return lotProp;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LotProp lotProp) throws CONException {
        try {

            DbLotProp dbLot = new DbLotProp(0);
            dbLot.setString(COL_NAMA, lotProp.getNama());
            dbLot.setDouble(COL_PANJANG, lotProp.getPanjang());
            dbLot.setDouble(COL_LEBAR, lotProp.getLebar());
            dbLot.setDouble(COL_LUAS, lotProp.getLuas());
            dbLot.setString(COL_KETERANGAN, lotProp.getKeterangan());
            dbLot.setInt(COL_STATUS, lotProp.getStatus());
            dbLot.setInt(COL_NO, lotProp.getNo());
            dbLot.setLong(COL_FOREIGN_CURRENCY_ID, lotProp.getForeignCurrencyId());
            dbLot.setDouble(COL_FOREIGN_AMOUNT, lotProp.getForeignAmount());
            dbLot.setDouble(COL_BOOKED_RATE, lotProp.getBookedRate());
            dbLot.setDouble(COL_AMOUNT, lotProp.getAmount());
            dbLot.setString(COL_NAME_PIC, lotProp.getNamePic());
            dbLot.setLong(COL_PROPERTY_ID, lotProp.getPropertyId());
            dbLot.setLong(COL_FLOOR_ID, lotProp.getFloorId());
            dbLot.setLong(COL_BUILDING_ID, lotProp.getBuildingId());            
            dbLot.setDouble(COL_CASH_KERAS, lotProp.getCashKeras());
            dbLot.setDouble(COL_CASH_BY_TERMIN, lotProp.getCashByTermin());
            dbLot.setDouble(COL_KPA, lotProp.getKpa());
            dbLot.setLong(COL_LOT_VALUE_ID, lotProp.getLotValueId());
            dbLot.setDouble(COL_RENTAL_RATE, lotProp.getRentalRate());
            dbLot.setLong(COL_LOT_TYPE_ID, lotProp.getLotTypeId());

            dbLot.insert();
            lotProp.setOID(dbLot.getlong(COL_LOT_ID));

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbApproval(0), CONException.UNKNOWN);
        }
        return lotProp.getOID();
    }

    public static long updateExc(LotProp lotProp) throws CONException {
        try {
            if (lotProp.getOID() != 0) {
                DbLotProp dbLot = new DbLotProp(lotProp.getOID());
                dbLot.setString(COL_NAMA, lotProp.getNama());
                dbLot.setDouble(COL_PANJANG, lotProp.getPanjang());
                dbLot.setDouble(COL_LEBAR, lotProp.getLebar());
                dbLot.setDouble(COL_LUAS, lotProp.getLuas());
                dbLot.setString(COL_KETERANGAN, lotProp.getKeterangan());
                dbLot.setInt(COL_STATUS, lotProp.getStatus());
                dbLot.setInt(COL_NO, lotProp.getNo());
                dbLot.setLong(COL_FOREIGN_CURRENCY_ID, lotProp.getForeignCurrencyId());
                dbLot.setDouble(COL_FOREIGN_AMOUNT, lotProp.getForeignAmount());
                dbLot.setDouble(COL_BOOKED_RATE, lotProp.getBookedRate());
                dbLot.setDouble(COL_AMOUNT, lotProp.getAmount());
                dbLot.setString(COL_NAME_PIC, lotProp.getNamePic());
                dbLot.setLong(COL_PROPERTY_ID, lotProp.getPropertyId());
                dbLot.setLong(COL_FLOOR_ID, lotProp.getFloorId());
                dbLot.setLong(COL_BUILDING_ID, lotProp.getBuildingId());                
                dbLot.setDouble(COL_CASH_KERAS, lotProp.getCashKeras());
                dbLot.setDouble(COL_CASH_BY_TERMIN, lotProp.getCashByTermin());
                dbLot.setDouble(COL_KPA, lotProp.getKpa());
                dbLot.setLong(COL_LOT_VALUE_ID, lotProp.getLotValueId());
                dbLot.setDouble(COL_RENTAL_RATE, lotProp.getRentalRate());
                dbLot.setLong(COL_LOT_TYPE_ID, lotProp.getLotTypeId());

                dbLot.update();

                return lotProp.getOID();
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
            DbLotProp dbLot = new DbLotProp(oid);
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
                LotProp lotProp = new LotProp();
                resultToObject(rs, lotProp);
                lists.add(lotProp);
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

    public static void resultToObject(ResultSet rs, LotProp lotProp) {
        try {
            lotProp.setOID(rs.getLong(DbLotProp.colNames[DbLotProp.COL_LOT_ID]));
            lotProp.setNama(rs.getString(DbLotProp.colNames[DbLotProp.COL_NAMA]));
            lotProp.setPanjang(rs.getDouble(DbLotProp.colNames[DbLotProp.COL_PANJANG]));
            lotProp.setLebar(rs.getDouble(DbLotProp.colNames[DbLotProp.COL_LEBAR]));
            lotProp.setKeterangan(rs.getString(DbLotProp.colNames[DbLotProp.COL_KETERANGAN]));
            lotProp.setStatus(rs.getInt(DbLotProp.colNames[DbLotProp.COL_STATUS]));
            lotProp.setNo(rs.getInt(DbLotProp.colNames[DbLotProp.COL_NO]));
            lotProp.setForeignCurrencyId(rs.getLong(DbLotProp.colNames[DbLotProp.COL_FOREIGN_CURRENCY_ID]));
            lotProp.setForeignAmount(rs.getDouble(DbLotProp.colNames[DbLotProp.COL_FOREIGN_AMOUNT]));
            lotProp.setBookedRate(rs.getDouble(DbLotProp.colNames[DbLotProp.COL_BOOKED_RATE]));
            lotProp.setAmount(rs.getDouble(DbLotProp.colNames[DbLotProp.COL_AMOUNT]));
            lotProp.setNamePic(rs.getString(DbLotProp.colNames[DbLotProp.COL_NAME_PIC]));
            lotProp.setPropertyId(rs.getLong(DbLotProp.colNames[DbLotProp.COL_PROPERTY_ID]));
            lotProp.setFloorId(rs.getLong(DbLotProp.colNames[DbLotProp.COL_FLOOR_ID]));
            lotProp.setBuildingId(rs.getLong(DbLotProp.colNames[DbLotProp.COL_BUILDING_ID]));            
            lotProp.setCashKeras(rs.getDouble(DbLotProp.colNames[DbLotProp.COL_CASH_KERAS]));
            lotProp.setCashByTermin(rs.getDouble(DbLotProp.colNames[DbLotProp.COL_CASH_BY_TERMIN]));
            lotProp.setKpa(rs.getDouble(DbLotProp.colNames[DbLotProp.COL_KPA]));
            lotProp.setLotValueId(rs.getLong(DbLotProp.colNames[DbLotProp.COL_LOT_VALUE_ID]));
            lotProp.setRentalRate(rs.getDouble(DbLotProp.colNames[DbLotProp.COL_RENTAL_RATE]));
            lotProp.setLotTypeId(rs.getLong(DbLotProp.colNames[DbLotProp.COL_LOT_TYPE_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long lotId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOT + " WHERE " +
                    DbLotProp.colNames[DbLotProp.COL_LOT_ID] + " = " + lotId;

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
            String sql = "SELECT COUNT(" + DbLotProp.colNames[DbLotProp.COL_LOT_ID] + ") FROM " + DB_LOT;
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
            String sql = "DELETE FROM " + DbLotProp.DB_LOT;
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
                    LotProp lotProp = (LotProp) list.get(ls);
                    if (oid == lotProp.getOID()) {
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
    
}
