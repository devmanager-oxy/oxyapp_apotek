
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

public class DbWaiter extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_WAITRES = "pos_waiters";

	public static final  int COL_WAITRES_ID = 0;
	public static final  int COL_NAME = 1;
	public static final  int COL_CODE = 2;
	public static final  int COL_LOGIN_ID = 3;
	public static final  int COL_PASSWORD = 4;
	public static final  int COL_STATUS = 5;
	public static final  int COL_LEVEL = 6;
        public static final  int COL_LOCATION_ID = 7;

	public static final  String[] colNames = {
		"waiters_id",
		"name",
		"code",
		"login_id",
		"password",
		"status",
		"level",
                "location_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
                TYPE_LONG
	 }; 
         
         
         public static int LEVEL_STAFT   = 0;
         public static int LEVEL_SUPERVISOR   = 1;
         public static int LEVEL_MANAGER   = 2;
         
         public static String[] strLevel = {"Staft", "Supervisor", "Manager"};

	public DbWaiter(){
	}

	public DbWaiter(int i) throws CONException { 
		super(new DbWaiter()); 
	}

	public DbWaiter(String sOid) throws CONException { 
		super(new DbWaiter(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbWaiter(long lOid) throws CONException { 
		super(new DbWaiter(0)); 
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
		return DB_WAITRES;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbWaiter().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Waiter waiter = fetchExc(ent.getOID()); 
		ent = (Entity)waiter; 
		return waiter.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Waiter) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Waiter) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Waiter fetchExc(long oid) throws CONException{ 
		try{ 
			Waiter waiter = new Waiter();
			DbWaiter pstWaiter = new DbWaiter(oid); 
			waiter.setOID(oid);

			waiter.setName(pstWaiter.getString(COL_NAME));
			waiter.setCode(pstWaiter.getString(COL_CODE));
			waiter.setLoginId(pstWaiter.getString(COL_LOGIN_ID));
			waiter.setPassword(pstWaiter.getString(COL_PASSWORD));
			waiter.setStatus(pstWaiter.getString(COL_STATUS));
			waiter.setLevel(pstWaiter.getInt(COL_LEVEL));
                        waiter.setLocationId(pstWaiter.getlong(COL_LOCATION_ID));

			return waiter; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbWaiter(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Waiter waiter) throws CONException{ 
		try{ 
			DbWaiter pstWaiter = new DbWaiter(0);

			pstWaiter.setString(COL_NAME, waiter.getName());
			pstWaiter.setString(COL_CODE, waiter.getCode());
			pstWaiter.setString(COL_LOGIN_ID, waiter.getLoginId());
			pstWaiter.setString(COL_PASSWORD, waiter.getPassword());
			pstWaiter.setString(COL_STATUS, waiter.getStatus());
			pstWaiter.setInt(COL_LEVEL, waiter.getLevel());
                        pstWaiter.setLong(COL_LOCATION_ID, waiter.getLocationId());

			pstWaiter.insert(); 
			waiter.setOID(pstWaiter.getlong(COL_WAITRES_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbWaiter(0),CONException.UNKNOWN); 
		}
		return waiter.getOID();
	}

	public static long updateExc(Waiter waiter) throws CONException{ 
		try{ 
			if(waiter.getOID() != 0){ 
				DbWaiter pstWaiter = new DbWaiter(waiter.getOID());

				pstWaiter.setString(COL_NAME, waiter.getName());
				pstWaiter.setString(COL_CODE, waiter.getCode());
				pstWaiter.setString(COL_LOGIN_ID, waiter.getLoginId());
				pstWaiter.setString(COL_PASSWORD, waiter.getPassword());
				pstWaiter.setString(COL_STATUS, waiter.getStatus());
				pstWaiter.setInt(COL_LEVEL, waiter.getLevel());
                                pstWaiter.setLong(COL_LOCATION_ID, waiter.getLocationId());

				pstWaiter.update(); 
				return waiter.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbWaiter(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbWaiter pstWaiter = new DbWaiter(oid);
			pstWaiter.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbWaiter(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_WAITRES; 
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
				Waiter waiter = new Waiter();
				resultToObject(rs, waiter);
				lists.add(waiter);
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

	private static void resultToObject(ResultSet rs, Waiter waiter){
		try{
			waiter.setOID(rs.getLong(DbWaiter.colNames[DbWaiter.COL_WAITRES_ID]));
			waiter.setName(rs.getString(DbWaiter.colNames[DbWaiter.COL_NAME]));
			waiter.setCode(rs.getString(DbWaiter.colNames[DbWaiter.COL_CODE]));
			waiter.setLoginId(rs.getString(DbWaiter.colNames[DbWaiter.COL_LOGIN_ID]));
			waiter.setPassword(rs.getString(DbWaiter.colNames[DbWaiter.COL_PASSWORD]));
			waiter.setStatus(rs.getString(DbWaiter.colNames[DbWaiter.COL_STATUS]));
			waiter.setLevel(rs.getInt(DbWaiter.colNames[DbWaiter.COL_LEVEL]));
                        waiter.setLocationId(rs.getLong(DbWaiter.colNames[DbWaiter.COL_LOCATION_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long waitresId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_WAITRES + " WHERE " + 
						DbWaiter.colNames[DbWaiter.COL_WAITRES_ID] + " = " + waitresId;

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
			String sql = "SELECT COUNT("+ DbWaiter.colNames[DbWaiter.COL_WAITRES_ID] + ") FROM " + DB_WAITRES;
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
			  	   Waiter waiter = (Waiter)list.get(ls);
				   if(oid == waiter.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
