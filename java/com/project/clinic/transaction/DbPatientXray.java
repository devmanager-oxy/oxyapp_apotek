
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

public class DbPatientXray extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_PATIENT_XRAY = "CL_PATIENT_XRAY";

	public static final  int COL_PATIENT_XRAY_ID = 0;
	public static final  int COL_NAME = 1;
	public static final  int COL_DESCRIPTION = 2;
	public static final  int COL_IMAGE_NAME = 3;

	public static final  String[] colNames = {
		"PATIENT_XRAY_ID",
		"NAME",
		"DESCRIPTION",
		"IMAGE_NAME"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbPatientXray(){
	}

	public DbPatientXray(int i) throws CONException { 
		super(new DbPatientXray()); 
	}

	public DbPatientXray(String sOid) throws CONException { 
		super(new DbPatientXray(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPatientXray(long lOid) throws CONException { 
		super(new DbPatientXray(0)); 
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
		return DB_CL_PATIENT_XRAY;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPatientXray().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PatientXray patientxray = fetchExc(ent.getOID()); 
		ent = (Entity)patientxray; 
		return patientxray.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PatientXray) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PatientXray) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PatientXray fetchExc(long oid) throws CONException{ 
		try{ 
			PatientXray patientxray = new PatientXray();
			DbPatientXray pstPatientXray = new DbPatientXray(oid); 
			patientxray.setOID(oid);

			patientxray.setName(pstPatientXray.getlong(COL_NAME));
			patientxray.setDescription(pstPatientXray.getString(COL_DESCRIPTION));
			patientxray.setImageName(pstPatientXray.getString(COL_IMAGE_NAME));

			return patientxray; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientXray(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PatientXray patientxray) throws CONException{ 
		try{ 
			DbPatientXray pstPatientXray = new DbPatientXray(0);

			pstPatientXray.setLong(COL_NAME, patientxray.getName());
			pstPatientXray.setString(COL_DESCRIPTION, patientxray.getDescription());
			pstPatientXray.setString(COL_IMAGE_NAME, patientxray.getImageName());

			pstPatientXray.insert(); 
			patientxray.setOID(pstPatientXray.getlong(COL_PATIENT_XRAY_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientXray(0),CONException.UNKNOWN); 
		}
		return patientxray.getOID();
	}

	public static long updateExc(PatientXray patientxray) throws CONException{ 
		try{ 
			if(patientxray.getOID() != 0){ 
				DbPatientXray pstPatientXray = new DbPatientXray(patientxray.getOID());

				pstPatientXray.setLong(COL_NAME, patientxray.getName());
				pstPatientXray.setString(COL_DESCRIPTION, patientxray.getDescription());
				pstPatientXray.setString(COL_IMAGE_NAME, patientxray.getImageName());

				pstPatientXray.update(); 
				return patientxray.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientXray(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPatientXray pstPatientXray = new DbPatientXray(oid);
			pstPatientXray.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientXray(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_PATIENT_XRAY; 
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
				PatientXray patientxray = new PatientXray();
				resultToObject(rs, patientxray);
				lists.add(patientxray);
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

	private static void resultToObject(ResultSet rs, PatientXray patientxray){
		try{
			patientxray.setOID(rs.getLong(DbPatientXray.colNames[DbPatientXray.COL_PATIENT_XRAY_ID]));
			patientxray.setName(rs.getLong(DbPatientXray.colNames[DbPatientXray.COL_NAME]));
			patientxray.setDescription(rs.getString(DbPatientXray.colNames[DbPatientXray.COL_DESCRIPTION]));
			patientxray.setImageName(rs.getString(DbPatientXray.colNames[DbPatientXray.COL_IMAGE_NAME]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long patientXrayId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_PATIENT_XRAY + " WHERE " + 
						DbPatientXray.colNames[DbPatientXray.COL_PATIENT_XRAY_ID] + " = " + patientXrayId;

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
			String sql = "SELECT COUNT("+ DbPatientXray.colNames[DbPatientXray.COL_PATIENT_XRAY_ID] + ") FROM " + DB_CL_PATIENT_XRAY;
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
			  	   PatientXray patientxray = (PatientXray)list.get(ls);
				   if(oid == patientxray.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
