
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

public class DbShift extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_SHIFT = "pos_shift";

	public static final  int COL_SHIFT_ID = 0;
	public static final  int COL_NAME = 1;
	public static final  int COL_START_TIME = 2;
	public static final  int COL_END_TIME = 3;
        
        public static final  int COL_START_HOURS = 4;
        public static final  int COL_START_MINUTES = 5;
        public static final  int COL_END_HOURS = 6;
        public static final  int COL_END_MINUTES = 7;

	public static final  String[] colNames = {
		"shift_id",
		"name",
		"start_time",
		"end_time",
                
                "start_hours",
                "start_minutes",
                "end_hours",
                "end_minutes"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_DATE,
                
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT
	 }; 

	public DbShift(){
	}

	public DbShift(int i) throws CONException { 
		super(new DbShift()); 
	}

	public DbShift(String sOid) throws CONException { 
		super(new DbShift(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbShift(long lOid) throws CONException { 
		super(new DbShift(0)); 
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
		return DB_SHIFT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbShift().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Shift shift = fetchExc(ent.getOID()); 
		ent = (Entity)shift; 
		return shift.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Shift) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Shift) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Shift fetchExc(long oid) throws CONException{ 
		try{ 
			Shift shift = new Shift();
			DbShift pstShift = new DbShift(oid); 
			shift.setOID(oid);

			shift.setName(pstShift.getString(COL_NAME));
			shift.setStartTime(pstShift.getDate(COL_START_TIME));
			shift.setEndTime(pstShift.getDate(COL_END_TIME));
                        
                        shift.setStartHours(pstShift.getInt(COL_START_HOURS));
                        shift.setStartMinutes(pstShift.getInt(COL_START_MINUTES));
                        shift.setEndHours(pstShift.getInt(COL_END_HOURS));
                        shift.setEndMinutes(pstShift.getInt(COL_END_MINUTES));

			return shift; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbShift(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Shift shift) throws CONException{ 
		try{ 
			DbShift pstShift = new DbShift(0);

			pstShift.setString(COL_NAME, shift.getName());
			pstShift.setDate(COL_START_TIME, shift.getStartTime());
			pstShift.setDate(COL_END_TIME, shift.getEndTime());
                        
                        pstShift.setInt(COL_START_HOURS, shift.getStartHours());
                        pstShift.setInt(COL_START_MINUTES, shift.getStartMinutes());
                        pstShift.setInt(COL_END_HOURS, shift.getEndHours());
                        pstShift.setInt(COL_END_MINUTES, shift.getEndMinutes());
                        

			pstShift.insert(); 
			shift.setOID(pstShift.getlong(COL_SHIFT_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbShift(0),CONException.UNKNOWN); 
		}
		return shift.getOID();
	}

	public static long updateExc(Shift shift) throws CONException{ 
		try{ 
			if(shift.getOID() != 0){ 
				DbShift pstShift = new DbShift(shift.getOID());

				pstShift.setString(COL_NAME, shift.getName());
				pstShift.setDate(COL_START_TIME, shift.getStartTime());
				pstShift.setDate(COL_END_TIME, shift.getEndTime());
                                
                                pstShift.setInt(COL_START_HOURS, shift.getStartHours());
                                pstShift.setInt(COL_START_MINUTES, shift.getStartMinutes());
                                pstShift.setInt(COL_END_HOURS, shift.getEndHours());
                                pstShift.setInt(COL_END_MINUTES, shift.getEndMinutes());

				pstShift.update(); 
				return shift.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbShift(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbShift pstShift = new DbShift(oid);
			pstShift.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbShift(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_SHIFT; 
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
				Shift shift = new Shift();
				resultToObject(rs, shift);
				lists.add(shift);
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

	private static void resultToObject(ResultSet rs, Shift shift){
		try{
			shift.setOID(rs.getLong(DbShift.colNames[DbShift.COL_SHIFT_ID]));
			shift.setName(rs.getString(DbShift.colNames[DbShift.COL_NAME]));
			shift.setStartTime(rs.getDate(DbShift.colNames[DbShift.COL_START_TIME]));
			shift.setEndTime(rs.getDate(DbShift.colNames[DbShift.COL_END_TIME]));
                        
                        shift.setStartHours(rs.getInt(DbShift.colNames[DbShift.COL_START_HOURS]));
                        shift.setStartMinutes(rs.getInt(DbShift.colNames[DbShift.COL_START_MINUTES]));
                        shift.setEndHours(rs.getInt(DbShift.colNames[DbShift.COL_END_HOURS]));
                        shift.setEndMinutes(rs.getInt(DbShift.colNames[DbShift.COL_END_MINUTES]));                        

		}catch(Exception e){ }
	}

	public static boolean checkOID(long shiftId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SHIFT + " WHERE " + 
						DbShift.colNames[DbShift.COL_SHIFT_ID] + " = " + shiftId;

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
			String sql = "SELECT COUNT("+ DbShift.colNames[DbShift.COL_SHIFT_ID] + ") FROM " + DB_SHIFT;
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
			  	   Shift shift = (Shift)list.get(ls);
				   if(oid == shift.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
