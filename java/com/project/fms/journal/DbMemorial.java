/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.journal;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;
/**
 *
 * @author Roy
 */

public class DbMemorial extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language{
    
	public static final  String DB_MEMORIAL = "memorial";

	public static final  int CL_MEMORIAL_ID = 0;
	public static final  int CL_START_DATE = 1;
        public static final  int CL_END_DATE = 2;
        public static final  int CL_VENDOR_ID = 3;
        public static final  int CL_LOCATION_ID = 4;
        public static final  int CL_USER_ID = 5;
        public static final  int CL_CREATE_DATE = 6;
        public static final  int CL_UNIQ_KEY_ID = 7;

	public static final  String[] colNames = {
		"memorial_id",
		"start_date",
		"end_date",
                "vendor_id",
                "location_id",
                "user_id",
                "create_date",
                "uniq_key_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_DATE,
                TYPE_LONG
	 }; 

	public DbMemorial(){
	}

	public DbMemorial(int i) throws CONException { 
		super(new DbMemorial()); 
	}

	public DbMemorial(String sOid) throws CONException { 
		super(new DbMemorial(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbMemorial(long lOid) throws CONException { 
		super(new DbMemorial(0)); 
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
		return DB_MEMORIAL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbMemorial().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Memorial memorial = fetchExc(ent.getOID()); 
		ent = (Entity)memorial; 
		return memorial.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Memorial) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Memorial) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Memorial fetchExc(long oid) throws CONException{ 
		try{ 
			Memorial memorial = new Memorial();
			DbMemorial pstMemorial = new DbMemorial(oid); 
			memorial.setOID(oid);

			memorial.setStartDate(pstMemorial.getDate(CL_START_DATE));
			memorial.setEndDate(pstMemorial.getDate(CL_END_DATE));
                        memorial.setVendorId(pstMemorial.getlong(CL_VENDOR_ID));
                        memorial.setLocationId(pstMemorial.getlong(CL_LOCATION_ID));
                        memorial.setUserId(pstMemorial.getlong(CL_USER_ID));
                        memorial.setCreateDate(pstMemorial.getDate(CL_CREATE_DATE));
                        memorial.setUniqKeyId(pstMemorial.getlong(CL_UNIQ_KEY_ID));
                        
			return memorial; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMemorial(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Memorial memorial) throws CONException{ 
		try{ 
			DbMemorial pstMemorial = new DbMemorial(0);
			pstMemorial.setDate(CL_START_DATE, memorial.getStartDate());
                        pstMemorial.setDate(CL_END_DATE, memorial.getEndDate());
                        pstMemorial.setLong(CL_VENDOR_ID, memorial.getVendorId());
                        pstMemorial.setLong(CL_LOCATION_ID, memorial.getLocationId());
                        pstMemorial.setLong(CL_USER_ID, memorial.getUserId());
                        pstMemorial.setDate(CL_CREATE_DATE, memorial.getCreateDate());
                        pstMemorial.setLong(CL_UNIQ_KEY_ID, memorial.getUniqKeyId());
			pstMemorial.insert(); 
			memorial.setOID(pstMemorial.getlong(CL_MEMORIAL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMemorial(0),CONException.UNKNOWN); 
		}
		return memorial.getOID();
	}

	public static long updateExc(Memorial memorial) throws CONException{ 
		try{ 
			if(memorial.getOID() != 0){ 
				DbMemorial pstMemorial = new DbMemorial(memorial.getOID());

				pstMemorial.setDate(CL_START_DATE, memorial.getStartDate());
                                pstMemorial.setDate(CL_END_DATE, memorial.getEndDate());
                                pstMemorial.setLong(CL_VENDOR_ID, memorial.getVendorId());
                                pstMemorial.setLong(CL_LOCATION_ID, memorial.getLocationId());
                                pstMemorial.setLong(CL_USER_ID, memorial.getUserId());
                                pstMemorial.setDate(CL_CREATE_DATE, memorial.getCreateDate());
                                pstMemorial.setLong(CL_UNIQ_KEY_ID, memorial.getUniqKeyId());

				pstMemorial.update(); 
				return memorial.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMemorial(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbMemorial pstMemorial = new DbMemorial(oid);
			pstMemorial.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMemorial(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_MEMORIAL; 
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
				Memorial memorial = new Memorial();
				resultToObject(rs, memorial);
				lists.add(memorial);
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

	private static void resultToObject(ResultSet rs, Memorial memorial){
		try{
			memorial.setOID(rs.getLong(DbMemorial.colNames[DbMemorial.CL_MEMORIAL_ID]));
			memorial.setStartDate(rs.getDate(DbMemorial.colNames[DbMemorial.CL_START_DATE]));
			memorial.setEndDate(rs.getDate(DbMemorial.colNames[DbMemorial.CL_END_DATE]));
			memorial.setVendorId(rs.getLong(DbMemorial.colNames[DbMemorial.CL_VENDOR_ID]));
			memorial.setLocationId(rs.getLong(DbMemorial.colNames[DbMemorial.CL_LOCATION_ID]));
                        memorial.setUserId(rs.getLong(DbMemorial.colNames[DbMemorial.CL_USER_ID]));
                        memorial.setUniqKeyId(rs.getLong(DbMemorial.colNames[DbMemorial.CL_UNIQ_KEY_ID]));
                        memorial.setCreateDate(rs.getDate(DbMemorial.colNames[DbMemorial.CL_CREATE_DATE]));                        
		}catch(Exception e){ }
	}

	public static boolean checkOID(long memorialId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_MEMORIAL + " WHERE " + 
						DbMemorial.colNames[DbMemorial.CL_MEMORIAL_ID] + " = " + memorialId;

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
			String sql = "SELECT COUNT("+ DbMemorial.colNames[DbMemorial.CL_MEMORIAL_ID] + ") FROM " + DB_MEMORIAL;
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
			  	   Memorial memorial = (Memorial)list.get(ls);
				   if(oid == memorial.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
      
}
