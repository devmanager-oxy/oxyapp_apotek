
package com.project.clinic.transaction; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*; 

public class DbDoctor extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_DOCTOR = "CL_DOCTOR";

	public static final  int COL_DOCTOR_ID = 0;
	public static final  int COL_TITLE = 1;
	public static final  int COL_NAME = 2;
	public static final  int COL_SPECIALTY_ID = 3;
	public static final  int COL_SSN = 4;
	public static final  int COL_DEGREE = 5;
	public static final  int COL_EMAIL = 6;
	public static final  int COL_ADDRESS = 7;
	public static final  int COL_STATE_ID = 8;
	public static final  int COL_COUNTRY_ID = 9;
	public static final  int COL_ZIP = 10;
	public static final  int COL_FAX = 11;
	public static final  int COL_PHONE = 12;
	public static final  int COL_MOBILE = 13;

	public static final  String[] colNames = {
		"DOCTOR_ID",
		"TITLE",
		"NAME",
		"SPECIALTY_ID",
		"SSN",
		"DEGREE",
		"EMAIL",
		"ADDRESS",
		"STATE_ID",
		"COUNTRY_ID",
		"ZIP",
		"FAX",
		"PHONE",
		"MOBILE"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbDoctor(){
	}

	public DbDoctor(int i) throws CONException { 
		super(new DbDoctor()); 
	}

	public DbDoctor(String sOid) throws CONException { 
		super(new DbDoctor(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbDoctor(long lOid) throws CONException { 
		super(new DbDoctor(0)); 
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
		return DB_CL_DOCTOR;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbDoctor().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Doctor doctor = fetchExc(ent.getOID()); 
		ent = (Entity)doctor; 
		return doctor.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Doctor) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Doctor) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Doctor fetchExc(long oid) throws CONException{ 
		try{ 
			Doctor doctor = new Doctor();
			DbDoctor pstDoctor = new DbDoctor(oid); 
			doctor.setOID(oid);

			doctor.setTitle(pstDoctor.getString(COL_TITLE));
			doctor.setName(pstDoctor.getString(COL_NAME));
			doctor.setSpecialtyId(pstDoctor.getlong(COL_SPECIALTY_ID));
			doctor.setSsn(pstDoctor.getString(COL_SSN));
			doctor.setDegree(pstDoctor.getString(COL_DEGREE));
			doctor.setEmail(pstDoctor.getString(COL_EMAIL));
			doctor.setAddress(pstDoctor.getString(COL_ADDRESS));
			doctor.setStateId(pstDoctor.getlong(COL_STATE_ID));
			doctor.setCountryId(pstDoctor.getlong(COL_COUNTRY_ID));
			doctor.setZip(pstDoctor.getString(COL_ZIP));
			doctor.setFax(pstDoctor.getString(COL_FAX));
			doctor.setPhone(pstDoctor.getString(COL_PHONE));
			doctor.setMobile(pstDoctor.getString(COL_MOBILE));

			return doctor; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDoctor(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Doctor doctor) throws CONException{ 
		try{ 
			DbDoctor pstDoctor = new DbDoctor(0);

			pstDoctor.setString(COL_TITLE, doctor.getTitle());
			pstDoctor.setString(COL_NAME, doctor.getName());
			pstDoctor.setLong(COL_SPECIALTY_ID, doctor.getSpecialtyId());
			pstDoctor.setString(COL_SSN, doctor.getSsn());
			pstDoctor.setString(COL_DEGREE, doctor.getDegree());
			pstDoctor.setString(COL_EMAIL, doctor.getEmail());
			pstDoctor.setString(COL_ADDRESS, doctor.getAddress());
			pstDoctor.setLong(COL_STATE_ID, doctor.getStateId());
			pstDoctor.setLong(COL_COUNTRY_ID, doctor.getCountryId());
			pstDoctor.setString(COL_ZIP, doctor.getZip());
			pstDoctor.setString(COL_FAX, doctor.getFax());
			pstDoctor.setString(COL_PHONE, doctor.getPhone());
			pstDoctor.setString(COL_MOBILE, doctor.getMobile());

			pstDoctor.insert(); 
			doctor.setOID(pstDoctor.getlong(COL_DOCTOR_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDoctor(0),CONException.UNKNOWN); 
		}
		return doctor.getOID();
	}

	public static long updateExc(Doctor doctor) throws CONException{ 
		try{ 
			if(doctor.getOID() != 0){ 
				DbDoctor pstDoctor = new DbDoctor(doctor.getOID());

				pstDoctor.setString(COL_TITLE, doctor.getTitle());
				pstDoctor.setString(COL_NAME, doctor.getName());
				pstDoctor.setLong(COL_SPECIALTY_ID, doctor.getSpecialtyId());
				pstDoctor.setString(COL_SSN, doctor.getSsn());
				pstDoctor.setString(COL_DEGREE, doctor.getDegree());
				pstDoctor.setString(COL_EMAIL, doctor.getEmail());
				pstDoctor.setString(COL_ADDRESS, doctor.getAddress());
				pstDoctor.setLong(COL_STATE_ID, doctor.getStateId());
				pstDoctor.setLong(COL_COUNTRY_ID, doctor.getCountryId());
				pstDoctor.setString(COL_ZIP, doctor.getZip());
				pstDoctor.setString(COL_FAX, doctor.getFax());
				pstDoctor.setString(COL_PHONE, doctor.getPhone());
				pstDoctor.setString(COL_MOBILE, doctor.getMobile());

				pstDoctor.update(); 
				return doctor.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDoctor(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbDoctor pstDoctor = new DbDoctor(oid);
			pstDoctor.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDoctor(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_DOCTOR; 
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
				Doctor doctor = new Doctor();
				resultToObject(rs, doctor);
				lists.add(doctor);
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

	private static void resultToObject(ResultSet rs, Doctor doctor){
		try{
			doctor.setOID(rs.getLong(DbDoctor.colNames[DbDoctor.COL_DOCTOR_ID]));
			doctor.setTitle(rs.getString(DbDoctor.colNames[DbDoctor.COL_TITLE]));
			doctor.setName(rs.getString(DbDoctor.colNames[DbDoctor.COL_NAME]));
			doctor.setSpecialtyId(rs.getLong(DbDoctor.colNames[DbDoctor.COL_SPECIALTY_ID]));
			doctor.setSsn(rs.getString(DbDoctor.colNames[DbDoctor.COL_SSN]));
			doctor.setDegree(rs.getString(DbDoctor.colNames[DbDoctor.COL_DEGREE]));
			doctor.setEmail(rs.getString(DbDoctor.colNames[DbDoctor.COL_EMAIL]));
			doctor.setAddress(rs.getString(DbDoctor.colNames[DbDoctor.COL_ADDRESS]));
			doctor.setStateId(rs.getLong(DbDoctor.colNames[DbDoctor.COL_STATE_ID]));
			doctor.setCountryId(rs.getLong(DbDoctor.colNames[DbDoctor.COL_COUNTRY_ID]));
			doctor.setZip(rs.getString(DbDoctor.colNames[DbDoctor.COL_ZIP]));
			doctor.setFax(rs.getString(DbDoctor.colNames[DbDoctor.COL_FAX]));
			doctor.setPhone(rs.getString(DbDoctor.colNames[DbDoctor.COL_PHONE]));
			doctor.setMobile(rs.getString(DbDoctor.colNames[DbDoctor.COL_MOBILE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long doctorId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_DOCTOR + " WHERE " + 
						DbDoctor.colNames[DbDoctor.COL_DOCTOR_ID] + " = " + doctorId;

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
			String sql = "SELECT COUNT("+ DbDoctor.colNames[DbDoctor.COL_DOCTOR_ID] + ") FROM " + DB_CL_DOCTOR;
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
			  	   Doctor doctor = (Doctor)list.get(ls);
				   if(oid == doctor.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
