
package com.project.fms.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 

public class DbShipAddress extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_SHIP_ADDRESS = "ship_address";

	public static final  int CL_SHIP_ADDRESS_ID = 0;
	public static final  int CL_NAME = 1;
	public static final  int CL_ADDRESS = 2;

	public static final  String[] colNames = {
		"ship_address_id",
		"name",
		"address"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbShipAddress(){
	}

	public DbShipAddress(int i) throws CONException { 
		super(new DbShipAddress()); 
	}

	public DbShipAddress(String sOid) throws CONException { 
		super(new DbShipAddress(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbShipAddress(long lOid) throws CONException { 
		super(new DbShipAddress(0)); 
		String sOid = "0"; 
		try { 
			sOid = String.valueOf(lOid); 
		}catch(Exception e) { 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	} 

	public int getFieldSize(){ 
		return colNames.length; 
	}

	public String getTableName(){ 
		return DB_SHIP_ADDRESS;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbShipAddress().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		ShipAddress shipaddress = fetchExc(ent.getOID()); 
		ent = (Entity)shipaddress; 
		return shipaddress.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((ShipAddress) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((ShipAddress) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static ShipAddress fetchExc(long oid) throws CONException{ 
		try{ 
			ShipAddress shipaddress = new ShipAddress();
			DbShipAddress pstShipAddress = new DbShipAddress(oid); 
			shipaddress.setOID(oid);

			shipaddress.setName(pstShipAddress.getString(CL_NAME));
			shipaddress.setAddress(pstShipAddress.getString(CL_ADDRESS));

			return shipaddress; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbShipAddress(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(ShipAddress shipaddress) throws CONException{ 
		try{ 
			DbShipAddress pstShipAddress = new DbShipAddress(0);

			pstShipAddress.setString(CL_NAME, shipaddress.getName());
			pstShipAddress.setString(CL_ADDRESS, shipaddress.getAddress());

			pstShipAddress.insert(); 
			shipaddress.setOID(pstShipAddress.getlong(CL_SHIP_ADDRESS_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbShipAddress(0),CONException.UNKNOWN); 
		}
		return shipaddress.getOID();
	}

	public static long updateExc(ShipAddress shipaddress) throws CONException{ 
		try{ 
			if(shipaddress.getOID() != 0){ 
				DbShipAddress pstShipAddress = new DbShipAddress(shipaddress.getOID());

				pstShipAddress.setString(CL_NAME, shipaddress.getName());
				pstShipAddress.setString(CL_ADDRESS, shipaddress.getAddress());

				pstShipAddress.update(); 
				return shipaddress.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbShipAddress(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbShipAddress pstShipAddress = new DbShipAddress(oid);
			pstShipAddress.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbShipAddress(0),CONException.UNKNOWN); 
		}
		return oid;
	}

	public static Vector listAll(){ 
		return list(0, 500, "",""); 
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_SHIP_ADDRESS; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				ShipAddress shipaddress = new ShipAddress();
				resultToObject(rs, shipaddress);
				lists.add(shipaddress);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}

	private static void resultToObject(ResultSet rs, ShipAddress shipaddress){
		try{
			shipaddress.setOID(rs.getLong(DbShipAddress.colNames[DbShipAddress.CL_SHIP_ADDRESS_ID]));
			shipaddress.setName(rs.getString(DbShipAddress.colNames[DbShipAddress.CL_NAME]));
			shipaddress.setAddress(rs.getString(DbShipAddress.colNames[DbShipAddress.CL_ADDRESS]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long shipAddressId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SHIP_ADDRESS + " WHERE " + 
						DbShipAddress.colNames[DbShipAddress.CL_SHIP_ADDRESS_ID] + " = " + shipAddressId;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) { result = true; }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			CONResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbShipAddress.colNames[DbShipAddress.CL_SHIP_ADDRESS_ID] + ") FROM " + DB_SHIP_ADDRESS;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
	}


	/* This method used to find current data */
	public static int findLimitStart( long oid, int recordToGet, String whereClause){
		String order = "";
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, order); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   ShipAddress shipaddress = (ShipAddress)list.get(ls);
				   if(oid == shipaddress.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
     
        
}
