package com.project.fms.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.*;

public class DbSegment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_SEGMENT = "segment";

	public static final  int COL_SEGMENT_ID = 0;
	public static final  int COL_NAME = 1;
	public static final  int COL_TYPE = 2;
	public static final  int COL_FUNCTION = 3;
	public static final  int COL_COLUMN_NAME = 4;
	public static final  int COL_COUNT = 5;

	public static final  String[] colNames = {
		"segment_id",
		"name",
		"type",
		"function",
		"column_name",
		"count"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT
	 }; 
	 	
	public static int TYPE_NA = 0;
	public static int TYPE_NBAL = 1;
	public static int TYPE_RES = 2;
	
	public static String[] strType = {"N/A", "NBAL", "RES"}; 
		
	public static int FUNCTION_NA = 0;	
	public static int FUNCTION_RES = 1;
	public static int FUNCTION_PGM = 2;
	public static int FUNCTION_FND = 3;
	
	public static String[] strFunction = {"N/A", "RES", "PGM", "FND"}; 		

	public DbSegment(){
	}

	public DbSegment(int i) throws CONException { 
		super(new DbSegment()); 
	}

	public DbSegment(String sOid) throws CONException { 
		super(new DbSegment(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSegment(long lOid) throws CONException { 
		super(new DbSegment(0)); 
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
		return DB_SEGMENT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSegment().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Segment segment = fetchExc(ent.getOID()); 
		ent = (Entity)segment; 
		return segment.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Segment) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Segment) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Segment fetchExc(long oid) throws CONException{ 
		try{ 
			Segment segment = new Segment();
			DbSegment DbSegment = new DbSegment(oid); 
			segment.setOID(oid);

			segment.setName(DbSegment.getString(COL_NAME));
			segment.setType(DbSegment.getString(COL_TYPE));
			segment.setFunction(DbSegment.getString(COL_FUNCTION));
			segment.setColumnName(DbSegment.getString(COL_COLUMN_NAME));
			segment.setCount(DbSegment.getInt(COL_COUNT));

			return segment; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSegment(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Segment segment) throws CONException{ 
		try{ 
			DbSegment DbSegment = new DbSegment(0);

			DbSegment.setString(COL_NAME, segment.getName());
			DbSegment.setString(COL_TYPE, segment.getType());
			DbSegment.setString(COL_FUNCTION, segment.getFunction());
			DbSegment.setString(COL_COLUMN_NAME, segment.getColumnName());
			DbSegment.setInt(COL_COUNT, segment.getCount());

			DbSegment.insert(); 
			segment.setOID(DbSegment.getlong(COL_SEGMENT_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSegment(0),CONException.UNKNOWN); 
		}
		return segment.getOID();
	}

	public static long updateExc(Segment segment) throws CONException{ 
		try{ 
			if(segment.getOID() != 0){ 
				DbSegment DbSegment = new DbSegment(segment.getOID());

				DbSegment.setString(COL_NAME, segment.getName());
				DbSegment.setString(COL_TYPE, segment.getType());
				DbSegment.setString(COL_FUNCTION, segment.getFunction());
				DbSegment.setString(COL_COLUMN_NAME, segment.getColumnName());
				DbSegment.setInt(COL_COUNT, segment.getCount());

				DbSegment.update(); 
				return segment.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSegment(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSegment DbSegment = new DbSegment(oid);
			DbSegment.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSegment(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_SEGMENT; 
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
				Segment segment = new Segment();
				resultToObject(rs, segment);
				lists.add(segment);
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

	private static void resultToObject(ResultSet rs, Segment segment){
		try{
			segment.setOID(rs.getLong(DbSegment.colNames[DbSegment.COL_SEGMENT_ID]));
			segment.setName(rs.getString(DbSegment.colNames[DbSegment.COL_NAME]));
			segment.setType(rs.getString(DbSegment.colNames[DbSegment.COL_TYPE]));
			segment.setFunction(rs.getString(DbSegment.colNames[DbSegment.COL_FUNCTION]));
			segment.setColumnName(rs.getString(DbSegment.colNames[DbSegment.COL_COLUMN_NAME]));
			segment.setCount(rs.getInt(DbSegment.colNames[DbSegment.COL_COUNT]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long segmentId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SEGMENT + " WHERE " + 
						DbSegment.colNames[DbSegment.COL_SEGMENT_ID] + " = " + segmentId;

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
			String sql = "SELECT COUNT("+ DbSegment.colNames[DbSegment.COL_SEGMENT_ID] + ") FROM " + DB_SEGMENT;
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
			  	   Segment segment = (Segment)list.get(ls);
				   if(oid == segment.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
	
	public static int getNextCounter(){
		String sql  = "select max("+colNames[COL_COUNT]+") from "+DB_SEGMENT;
		
		int result = 0;
		
		CONResultSet crs = null;
		try{
			crs = CONHandler.execQueryResult(sql);
			ResultSet rs = crs.getResultSet();
			while(rs.next()){
				result = rs.getInt(1);
			}
		}
		catch(Exception e){
			
		}
		finally{
			CONResultSet.close(crs);
		}
		
		return result + 1;
	}
        
        public static Segment gerRef(long segmentId){
            try{
                Segment segParent = new Segment();
                Segment s = new Segment();
                try{
                    s = DbSegment.fetchExc(segmentId);
                }catch(Exception e){}                
                Vector lisSegment = DbSegment.list(0, 1, DbSegment.colNames[DbSegment.COL_COUNT]+" = "+(s.getCount()-1), null);
                
                if(lisSegment != null && lisSegment.size() > 0){
                    segParent = (Segment)lisSegment.get(0);
                }
                return segParent;
            }catch(Exception e){}
            
            return new Segment();
        }
	
}
