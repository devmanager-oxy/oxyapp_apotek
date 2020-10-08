
package com.project.ccs.posmaster; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*; 

public class DbWaiterTable extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_WAITER_TABLE = "pos_waiter_table";

	public static final  int COL_NAME = 0;
	public static final  int COL_PAX = 1;
	public static final  int COL_WAITER_TABLE_ID = 2;
	public static final  int COL_STATUS = 3;
        public static final  int COL_LOCATION_ID = 4;

	public static final  String[] colNames = {
		"name",
		"pax",
		"waiter_table_id",
		"status",
                "location_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
                TYPE_LONG
	 }; 

	public DbWaiterTable(){
	}

	public DbWaiterTable(int i) throws CONException { 
		super(new DbWaiterTable()); 
	}

	public DbWaiterTable(String sOid) throws CONException { 
		super(new DbWaiterTable(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbWaiterTable(long lOid) throws CONException { 
		super(new DbWaiterTable(0)); 
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
		return DB_WAITER_TABLE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbWaiterTable().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		WaiterTable waitertable = fetchExc(ent.getOID()); 
		ent = (Entity)waitertable; 
		return waitertable.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((WaiterTable) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((WaiterTable) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static WaiterTable fetchExc(long oid) throws CONException{ 
		try{ 
			WaiterTable waitertable = new WaiterTable();
			DbWaiterTable pstWaiterTable = new DbWaiterTable(oid); 
			waitertable.setOID(oid);

			waitertable.setName(pstWaiterTable.getString(COL_NAME));
			waitertable.setPax(pstWaiterTable.getInt(COL_PAX));
			waitertable.setStatus(pstWaiterTable.getString(COL_STATUS));
                        waitertable.setLocationId(pstWaiterTable.getlong(COL_LOCATION_ID));

			return waitertable; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbWaiterTable(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(WaiterTable waitertable) throws CONException{ 
		try{ 
			DbWaiterTable pstWaiterTable = new DbWaiterTable(0);

			pstWaiterTable.setString(COL_NAME, waitertable.getName());
			pstWaiterTable.setInt(COL_PAX, waitertable.getPax());
			pstWaiterTable.setString(COL_STATUS, waitertable.getStatus());
                        pstWaiterTable.setLong(COL_LOCATION_ID, waitertable.getLocationId());

			pstWaiterTable.insert(); 
			waitertable.setOID(pstWaiterTable.getlong(COL_WAITER_TABLE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbWaiterTable(0),CONException.UNKNOWN); 
		}
		return waitertable.getOID();
	}

	public static long updateExc(WaiterTable waitertable) throws CONException{ 
		try{ 
			if(waitertable.getOID() != 0){ 
				DbWaiterTable pstWaiterTable = new DbWaiterTable(waitertable.getOID());

				pstWaiterTable.setString(COL_NAME, waitertable.getName());
				pstWaiterTable.setInt(COL_PAX, waitertable.getPax());
				pstWaiterTable.setString(COL_STATUS, waitertable.getStatus());
                                pstWaiterTable.setLong(COL_LOCATION_ID, waitertable.getLocationId());

				pstWaiterTable.update(); 
				return waitertable.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbWaiterTable(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbWaiterTable pstWaiterTable = new DbWaiterTable(oid);
			pstWaiterTable.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbWaiterTable(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_WAITER_TABLE; 
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
				WaiterTable waitertable = new WaiterTable();
				resultToObject(rs, waitertable);
				lists.add(waitertable);
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

	private static void resultToObject(ResultSet rs, WaiterTable waitertable){
		try{
			waitertable.setOID(rs.getLong(DbWaiterTable.colNames[DbWaiterTable.COL_WAITER_TABLE_ID]));
			waitertable.setName(rs.getString(DbWaiterTable.colNames[DbWaiterTable.COL_NAME]));
			waitertable.setPax(rs.getInt(DbWaiterTable.colNames[DbWaiterTable.COL_PAX]));
			waitertable.setStatus(rs.getString(DbWaiterTable.colNames[DbWaiterTable.COL_STATUS]));
                        waitertable.setLocationId(rs.getLong(DbWaiterTable.colNames[DbWaiterTable.COL_LOCATION_ID]));

		}catch(Exception e){ }
	}

	

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbWaiterTable.colNames[DbWaiterTable.COL_WAITER_TABLE_ID] + ") FROM " + DB_WAITER_TABLE;
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
			  	   WaiterTable waitertable = (WaiterTable)list.get(ls);
				   if(oid == waitertable.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
