
package com.project.clinic.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*; 

public class DbSpecialty extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_SPECIALTY = "CL_SPECIALTY";

	public static final  int COL_SPECIALTY_ID = 0;
	public static final  int COL_NAME = 1;

	public static final  String[] colNames = {
		"SPECIALTY_ID",
		"NAME"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
	 }; 

	public DbSpecialty(){
	}

	public DbSpecialty(int i) throws CONException { 
		super(new DbSpecialty()); 
	}

	public DbSpecialty(String sOid) throws CONException { 
		super(new DbSpecialty(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSpecialty(long lOid) throws CONException { 
		super(new DbSpecialty(0)); 
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
		return DB_CL_SPECIALTY;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSpecialty().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Specialty specialty = fetchExc(ent.getOID()); 
		ent = (Entity)specialty; 
		return specialty.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Specialty) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Specialty) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Specialty fetchExc(long oid) throws CONException{ 
		try{ 
			Specialty specialty = new Specialty();
			DbSpecialty pstSpecialty = new DbSpecialty(oid); 
			specialty.setOID(oid);

			specialty.setName(pstSpecialty.getString(COL_NAME));

			return specialty; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSpecialty(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Specialty specialty) throws CONException{ 
		try{ 
			DbSpecialty pstSpecialty = new DbSpecialty(0);

			pstSpecialty.setString(COL_NAME, specialty.getName());

			pstSpecialty.insert(); 
			specialty.setOID(pstSpecialty.getlong(COL_SPECIALTY_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSpecialty(0),CONException.UNKNOWN); 
		}
		return specialty.getOID();
	}

	public static long updateExc(Specialty specialty) throws CONException{ 
		try{ 
			if(specialty.getOID() != 0){ 
				DbSpecialty pstSpecialty = new DbSpecialty(specialty.getOID());

				pstSpecialty.setString(COL_NAME, specialty.getName());

				pstSpecialty.update(); 
				return specialty.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSpecialty(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSpecialty pstSpecialty = new DbSpecialty(oid);
			pstSpecialty.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSpecialty(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_SPECIALTY; 
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
				Specialty specialty = new Specialty();
				resultToObject(rs, specialty);
				lists.add(specialty);
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

	private static void resultToObject(ResultSet rs, Specialty specialty){
		try{
			specialty.setOID(rs.getLong(DbSpecialty.colNames[DbSpecialty.COL_SPECIALTY_ID]));
			specialty.setName(rs.getString(DbSpecialty.colNames[DbSpecialty.COL_NAME]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long specialtyId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_SPECIALTY + " WHERE " + 
						DbSpecialty.colNames[DbSpecialty.COL_SPECIALTY_ID] + " = " + specialtyId;

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
			String sql = "SELECT COUNT("+ DbSpecialty.colNames[DbSpecialty.COL_SPECIALTY_ID] + ") FROM " + DB_CL_SPECIALTY;
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
			  	   Specialty specialty = (Specialty)list.get(ls);
				   if(oid == specialty.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
