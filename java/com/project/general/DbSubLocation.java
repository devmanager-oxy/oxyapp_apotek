
package com.project.general; 

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;

public class DbSubLocation extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_SUB_LOCATION = "pos_sub_location";

	public static final  int COL_SUB_LOCATION_ID = 0;
	public static final  int COL_LOCATION_ID = 1;
	public static final  int COL_NAME = 2;
	public static final  int COL_DESCRIPTION = 3;
        
	

	public static final  String[] colNames = {
		"sub_location_id",
		"location_id",
		"name",
		"description"
                
                
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
                TYPE_STRING
                
	 }; 
         
         

	public DbSubLocation(){
	}

	public DbSubLocation(int i) throws CONException { 
		super(new DbSubLocation()); 
	}

	public DbSubLocation(String sOid) throws CONException { 
		super(new DbSubLocation(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSubLocation(long lOid) throws CONException { 
		super(new DbSubLocation(0)); 
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
		return DB_SUB_LOCATION;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSubLocation().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SubLocation subLocation = fetchExc(ent.getOID()); 
		ent = (Entity)subLocation; 
		return subLocation.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SubLocation) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SubLocation) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SubLocation fetchExc(long oid) throws CONException{ 
		try{ 
			SubLocation subLocation = new SubLocation();
			DbSubLocation pstLocation = new DbSubLocation(oid); 
			subLocation.setOID(oid);

			subLocation.setLocation_id(pstLocation.getlong(COL_LOCATION_ID));
			subLocation.setName(pstLocation.getString(COL_NAME));
			subLocation.setDescription(pstLocation.getString(COL_DESCRIPTION));
			
			return subLocation; 
                        
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSubLocation(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SubLocation subLocation) throws CONException{ 
		try{ 
			DbSubLocation pstLocation = new DbSubLocation(0);

			pstLocation.setLong(COL_LOCATION_ID, subLocation.getLocation_id());
			pstLocation.setString(COL_NAME, subLocation.getName());
			pstLocation.setString(COL_DESCRIPTION, subLocation.getDescription());
			
                        
			pstLocation.insert(); 
			subLocation.setOID(pstLocation.getlong(COL_SUB_LOCATION_ID));
                        
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSubLocation(0),CONException.UNKNOWN); 
		}
		return subLocation.getOID();
	}

	public static long updateExc(SubLocation subLocation) throws CONException{ 
		try{ 
			if(subLocation.getOID() != 0){ 
				DbSubLocation pstLocation = new DbSubLocation(subLocation.getOID());

				pstLocation.setLong(COL_LOCATION_ID, subLocation.getLocation_id());
				pstLocation.setString(COL_NAME, subLocation.getName());
				pstLocation.setString(COL_DESCRIPTION, subLocation.getDescription());
                                
				pstLocation.update(); 
				return subLocation.getOID();
			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSubLocation(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSubLocation pstLocation = new DbSubLocation(oid);
			pstLocation.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSubLocation(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_SUB_LOCATION; 
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
				SubLocation subLocation = new SubLocation();
				resultToObject(rs, subLocation);
				lists.add(subLocation);
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

	private static void resultToObject(ResultSet rs, SubLocation subLocation){
		try{
			subLocation.setOID(rs.getLong(DbSubLocation.colNames[DbSubLocation.COL_SUB_LOCATION_ID]));
			subLocation.setLocation_id(rs.getLong(DbSubLocation.colNames[DbSubLocation.COL_LOCATION_ID]));
			subLocation.setName(rs.getString(DbSubLocation.colNames[DbSubLocation.COL_NAME]));
			subLocation.setDescription(rs.getString(DbSubLocation.colNames[DbSubLocation.COL_DESCRIPTION]));
			
                        
		}catch(Exception e){ }
	}

	public static boolean checkOID(long locationId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SUB_LOCATION + " WHERE " + 
						DbSubLocation.colNames[DbSubLocation.COL_LOCATION_ID] + " = " + locationId;

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
			String sql = "SELECT COUNT("+ DbSubLocation.colNames[DbSubLocation.COL_SUB_LOCATION_ID] + ") FROM " + DB_SUB_LOCATION;
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
			  	   Location location = (Location)list.get(ls);
				   if(oid == location.getOID())
					  found=true; 
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
       
}
