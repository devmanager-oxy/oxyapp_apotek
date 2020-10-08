
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

public class DbPatientDesease extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_PATIENT_DESEASE = "CL_PATIENT_DESEASE";

	public static final  int COL_DESEASE_ID = 0;
	public static final  int COL_PATIENT_ID = 1;
	public static final  int COL_PATIENT_DESEAS_ID = 2;

	public static final  String[] colNames = {
		"DESEASE_ID",
		"PATIENT_ID",
		"PATIENT_DESEAS_ID"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID
	 }; 

	public DbPatientDesease(){
	}

	public DbPatientDesease(int i) throws CONException { 
		super(new DbPatientDesease()); 
	}

	public DbPatientDesease(String sOid) throws CONException { 
		super(new DbPatientDesease(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPatientDesease(long lOid) throws CONException { 
		super(new DbPatientDesease(0)); 
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
		return DB_CL_PATIENT_DESEASE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPatientDesease().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PatientDesease patientdesease = fetchExc(ent.getOID()); 
		ent = (Entity)patientdesease; 
		return patientdesease.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PatientDesease) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PatientDesease) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PatientDesease fetchExc(long oid) throws CONException{ 
		try{ 
			PatientDesease patientdesease = new PatientDesease();
			DbPatientDesease pstPatientDesease = new DbPatientDesease(oid); 
			patientdesease.setOID(oid);

			patientdesease.setDeseaseId(pstPatientDesease.getlong(COL_DESEASE_ID));
			patientdesease.setPatientId(pstPatientDesease.getlong(COL_PATIENT_ID));

			return patientdesease; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientDesease(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PatientDesease patientdesease) throws CONException{ 
		try{ 
			DbPatientDesease pstPatientDesease = new DbPatientDesease(0);

			pstPatientDesease.setLong(COL_DESEASE_ID, patientdesease.getDeseaseId());
			pstPatientDesease.setLong(COL_PATIENT_ID, patientdesease.getPatientId());

			pstPatientDesease.insert(); 
			patientdesease.setOID(pstPatientDesease.getlong(COL_PATIENT_DESEAS_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientDesease(0),CONException.UNKNOWN); 
		}
		return patientdesease.getOID();
	}

	public static long updateExc(PatientDesease patientdesease) throws CONException{ 
		try{ 
			if(patientdesease.getOID() != 0){ 
				DbPatientDesease pstPatientDesease = new DbPatientDesease(patientdesease.getOID());

				pstPatientDesease.setLong(COL_DESEASE_ID, patientdesease.getDeseaseId());
				pstPatientDesease.setLong(COL_PATIENT_ID, patientdesease.getPatientId());

				pstPatientDesease.update(); 
				return patientdesease.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientDesease(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPatientDesease pstPatientDesease = new DbPatientDesease(oid);
			pstPatientDesease.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientDesease(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_PATIENT_DESEASE; 
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
				PatientDesease patientdesease = new PatientDesease();
				resultToObject(rs, patientdesease);
				lists.add(patientdesease);
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

	private static void resultToObject(ResultSet rs, PatientDesease patientdesease){
		try{
			patientdesease.setOID(rs.getLong(DbPatientDesease.colNames[DbPatientDesease.COL_PATIENT_DESEAS_ID]));
			patientdesease.setDeseaseId(rs.getLong(DbPatientDesease.colNames[DbPatientDesease.COL_DESEASE_ID]));
			patientdesease.setPatientId(rs.getLong(DbPatientDesease.colNames[DbPatientDesease.COL_PATIENT_ID]));

		}catch(Exception e){ }
	}

	/*public static boolean checkOID(long patientDeseasId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_PATIENT_DESEASE + " WHERE " + 
						DbPatientDesease.colNames[DbPatientDesease.COL_DESEASE_ID] + " = " + deseaseId;

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
         */ 

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbPatientDesease.colNames[DbPatientDesease.COL_PATIENT_DESEAS_ID] + ") FROM " + DB_CL_PATIENT_DESEASE;
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
			  	   PatientDesease patientdesease = (PatientDesease)list.get(ls);
				   if(oid == patientdesease.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
