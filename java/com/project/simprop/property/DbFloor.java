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

import com.project.crm.master.Lot;
import com.project.crm.master.DbLot;
import com.project.crm.master.CmdLot;
import com.project.crm.master.JspLot;
import com.project.util.*;
import com.project.simprop.property.*;

/**
 *
 * @author Roy Andika
 */
public class DbFloor extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{

    public static final String DB_FLOOR = "prop_floor";
    
    public static final int COL_FLOOR_ID = 0;
    public static final int COL_NO = 1;
    public static final int COL_NAME = 2;
    public static final int COL_DISCRIPTION = 3;
    public static final int COL_FACILITIES = 4;
    public static final int COL_LOT_QTY = 5;
    public static final int COL_CURRENCY_ID = 6;    
    public static final int COL_LOT_PRICE = 7;
    public static final int COL_PROPERTY_ID = 8;
    public static final int COL_NAME_PIC = 9;
    public static final int COL_BOOKED_RATE = 10;
    public static final int COL_FOREIGN_AMOUNT = 11;
    public static final int COL_BUILDING_ID = 12;
    
    public static final String[] colNames = {
        "floor_id",
        "no",
        "name",
        "discription",
        "facilities",
        "lot_qty",
        "currency_id",
        "lot_price",
        "property_id",
        "name_pic",
        "booked_rate",
        "foreign_amount",
        "building_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,   
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG
    };     
    
    public DbFloor() {
    }

    public DbFloor(int i) throws CONException {
        super(new DbFloor());
    }

    public DbFloor(String sOid) throws CONException {
        super(new DbFloor(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFloor(long lOid) throws CONException {
        super(new DbFloor(0));
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
        return DB_FLOOR;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbFloor().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Floor floor = fetchExc(ent.getOID());
        ent = (Entity) floor;
        return floor.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Floor) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Floor) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Floor fetchExc(long oid) throws CONException {
        try {
            Floor floor = new Floor();
            DbFloor pstFloor = new DbFloor(oid);            
            floor.setOID(oid);
            floor.setNo(pstFloor.getInt(COL_NO));
            floor.setName(pstFloor.getString(COL_NAME));
            floor.setDiscription(pstFloor.getString(COL_DISCRIPTION));
            floor.setFacilities(pstFloor.getString(COL_FACILITIES));
            floor.setLotQty(pstFloor.getInt(COL_LOT_QTY));
            floor.setCurrencyId(pstFloor.getlong(COL_CURRENCY_ID));
            floor.setLotPrice(pstFloor.getdouble(COL_LOT_PRICE));
            floor.setPropertyId(pstFloor.getlong(COL_PROPERTY_ID));
            floor.setNamePic(pstFloor.getString(COL_NAME_PIC));            
            floor.setBookedRate(pstFloor.getdouble(COL_BOOKED_RATE));
            floor.setForeignAmount(pstFloor.getdouble(COL_FOREIGN_AMOUNT));
            floor.setBuildingId(pstFloor.getlong(COL_BUILDING_ID));

            return floor;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloor(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Floor floor) throws CONException {
        try {
            DbFloor pstFloor = new DbFloor(0);

            pstFloor.setInt(COL_NO, floor.getNo());
            pstFloor.setString(COL_NAME, floor.getName());
            pstFloor.setString(COL_DISCRIPTION, floor.getDiscription());
            pstFloor.setString(COL_FACILITIES, floor.getFacilities());
            pstFloor.setInt(COL_LOT_QTY, floor.getLotQty());
            pstFloor.setLong(COL_CURRENCY_ID, floor.getCurrencyId());
            pstFloor.setDouble(COL_LOT_PRICE, floor.getLotPrice());
            pstFloor.setLong(COL_PROPERTY_ID, floor.getPropertyId());
            pstFloor.setString(COL_NAME_PIC, floor.getNamePic());            
            pstFloor.setDouble(COL_BOOKED_RATE, floor.getBookedRate());
            pstFloor.setDouble(COL_FOREIGN_AMOUNT, floor.getForeignAmount());
            pstFloor.setLong(COL_BUILDING_ID, floor.getBuildingId());
            
            pstFloor.insert();
            floor.setOID(pstFloor.getlong(COL_FLOOR_ID));


        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloor(0), CONException.UNKNOWN);
        }
        return floor.getOID();
    }

    public static long updateExc(Floor floor) throws CONException {
        try {
            if (floor.getOID() != 0) {
                DbFloor pstFloor = new DbFloor(floor.getOID());
                
                pstFloor.setInt(COL_NO, floor.getNo());
                pstFloor.setString(COL_NAME, floor.getName());
                pstFloor.setString(COL_DISCRIPTION, floor.getDiscription());
                pstFloor.setString(COL_FACILITIES, floor.getFacilities());
                pstFloor.setInt(COL_LOT_QTY, floor.getLotQty());
                pstFloor.setLong(COL_CURRENCY_ID, floor.getCurrencyId());
                pstFloor.setDouble(COL_LOT_PRICE, floor.getLotPrice());
                pstFloor.setLong(COL_PROPERTY_ID, floor.getPropertyId());
                pstFloor.setString(COL_NAME_PIC, floor.getNamePic());
                pstFloor.setDouble(COL_BOOKED_RATE, floor.getBookedRate());
                pstFloor.setDouble(COL_FOREIGN_AMOUNT, floor.getForeignAmount());
                pstFloor.setLong(COL_BUILDING_ID, floor.getBuildingId());

                pstFloor.update();
                return floor.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloor(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFloor pstFloor = new DbFloor(oid);
            pstFloor.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFloor(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_FLOOR;
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
                Floor floor = new Floor();
                resultToObject(rs, floor);
                lists.add(floor);
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

    private static void resultToObject(ResultSet rs, Floor floor) {
        try {
            
            floor.setOID(rs.getLong(DbFloor.colNames[DbFloor.COL_FLOOR_ID]));
            floor.setNo(rs.getInt(DbFloor.colNames[DbFloor.COL_NO]));
            floor.setName(rs.getString(DbFloor.colNames[DbFloor.COL_NAME]));
            floor.setDiscription(rs.getString(DbFloor.colNames[DbFloor.COL_DISCRIPTION]));
            floor.setFacilities(rs.getString(DbFloor.colNames[DbFloor.COL_FACILITIES]));
            floor.setLotQty(rs.getInt(DbFloor.colNames[DbFloor.COL_LOT_QTY]));
            floor.setCurrencyId(rs.getLong(DbFloor.colNames[DbFloor.COL_CURRENCY_ID]));
            floor.setLotPrice(rs.getDouble(DbFloor.colNames[DbFloor.COL_LOT_PRICE]));
            floor.setPropertyId(rs.getLong(DbFloor.colNames[DbFloor.COL_PROPERTY_ID]));
            floor.setNamePic(rs.getString(DbFloor.colNames[DbFloor.COL_NAME_PIC]));            
            floor.setBookedRate(rs.getDouble(DbFloor.colNames[DbFloor.COL_BOOKED_RATE]));
            floor.setForeignAmount(rs.getDouble(DbFloor.colNames[DbFloor.COL_FOREIGN_AMOUNT]));
            floor.setBuildingId(rs.getLong(DbFloor.colNames[DbFloor.COL_BUILDING_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long floorId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_FLOOR + " WHERE " +
                    DbFloor.colNames[DbFloor.COL_FLOOR_ID] + " = " + floorId;

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
            String sql = "SELECT COUNT(" + DbFloor.colNames[DbFloor.COL_FLOOR_ID] + ") FROM " + DB_FLOOR;
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
            String sql = "DELETE FROM " + DB_FLOOR;
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
                    Floor floor = (Floor) list.get(ls);
                    if (oid == floor.getOID()) {
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
    
    //update ke table lot value
    public static void updateLotQty(long lotId, long floorId, long lotTypeId, int cmd){
    	
    	System.out.println("................ in update lot qty");
    	
    	if(cmd==JSPCommand.SAVE){
    		
    		System.out.println("................ in command SAVE ");
    	    	
	    	Lot lot = new Lot();
	    	try{
	    		
	    		lot = DbLot.fetchExc(lotId);
	    		
	    		if(lot.getLotValueId()==0){
	    			
	    			String where = //DbLotValue.colNames[DbLotValue.COL_LOT_ID]+"="+lotId+" and  "+
	    				DbLotValue.colNames[DbLotValue.COL_FLOOR_ID]+"="+floorId+" and "+
	    				DbLotValue.colNames[DbLotValue.COL_LOT_TYPE]+"="+lotTypeId;
	    				
	    			Vector v = DbLotValue.list(0,0, where, "");
	    			
	    			if(v!=null && v.size()>0){
	    				LotValue lv = (LotValue)v.get(0);    				
				    	
				    	lot.setLotValueId(lv.getOID());
			    		DbLot.updateExc(lot); 
			    		
			    		int count = DbLot.getCount(DbLot.colNames[DbLot.COL_LOT_VALUE_ID]+"="+lot.getLotValueId());	
			    		lv.setLotQty(count);
			    		DbLotValue.updateExc(lv);
			    		   				
	    			}	
	    			else{
	    				LotValue lv = new LotValue();
	    				lv.setLotType(lot.getLotTypeId());
	    				lv.setLotQty(1);
	    				lv.setLotFrom(lot.getNo());
	    				lv.setLotTo(lot.getNo());
	    				lv.setAmountCashByTermin(lot.getCashByTermin());
	    				lv.setAmountHardCash(lot.getCashKeras());
	    				lv.setAmountKPA(lot.getKpa());
	    				lv.setFloorId(lot.getFloorId());
	    				lv.setRentalRate(lot.getRentalRate());
	    				lv.setLotId(lot.getOID());
	    				
	    				long oid = DbLotValue.insertExc(lv);
	    				
	    				lot.setLotValueId(oid);
	    				
	    				DbLot.updateExc(lot);
	    			}    			
	    		}
	    		else{    			
	    			int count = DbLot.getCount(DbLot.colNames[DbLot.COL_LOT_VALUE_ID]+"="+lot.getLotValueId());
	    			LotValue lv = DbLotValue.fetchExc(lot.getLotValueId());
	    			lv.setLotQty(count);
	    			DbLotValue.updateExc(lv);    			
	    		}
	    		
	    	}
	    	catch(Exception e){
	    		System.out.println(e.toString());
	    	}
	    //end if save	
    	}
    	else{
    		String where = //DbLotValue.colNames[DbLotValue.COL_LOT_ID]+"="+lotId+" and  "+
				DbLotValue.colNames[DbLotValue.COL_FLOOR_ID]+"="+floorId+" and "+
				DbLotValue.colNames[DbLotValue.COL_LOT_TYPE]+"="+lotTypeId;
				
			System.out.println("................ in command DELETE ");	
			System.out.println("................ where : "+where);		
				
			Vector v = DbLotValue.list(0,0, where, "");
			
			System.out.println("................ v : "+v);		
			
			if(v!=null && v.size()>0){
				
				try{				
					LotValue lv = (LotValue)v.get(0);    				
			    	
		    		int count = DbLot.getCount(DbLot.colNames[DbLot.COL_LOT_VALUE_ID]+"="+lv.getOID());
		    		
		    		System.out.println("................ count : "+count);		
		    			
	    			lv.setLotQty(count);
	    			DbLotValue.updateExc(lv);    			  				
				}
				catch(Exception e){
					System.out.println("................ exception e : "+e.toString());
				}
			}
    	}
    	
    }
}
