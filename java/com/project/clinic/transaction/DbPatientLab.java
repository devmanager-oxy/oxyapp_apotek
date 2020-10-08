
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

public class DbPatientLab extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_PATIENT_LAB = "CL_PATIENT_LAB";

	public static final  int COL_PATIENT_LAB_ID = 0;
	public static final  int COL_DATE = 1;
	public static final  int COL_PATIENT_ID = 2;
	public static final  int COL_TEST_LAB_ID = 3;
	public static final  int COL_RESULT_VALUE = 4;
	public static final  int COL_NORMAL_VALUE = 5;
	public static final  int COL_DESCRIPTION = 6;

	public static final  String[] colNames = {
		"PATIENT_LAB_ID",
		"DATE",
		"PATIENT_ID",
		"TEST_LAB_ID",
		"RESULT_VALUE",
		"NORMAL_VALUE",
		"DESCRIPTION"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbPatientLab(){
	}

	public DbPatientLab(int i) throws CONException { 
		super(new DbPatientLab()); 
	}

	public DbPatientLab(String sOid) throws CONException { 
		super(new DbPatientLab(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPatientLab(long lOid) throws CONException { 
		super(new DbPatientLab(0)); 
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
		return DB_CL_PATIENT_LAB;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPatientLab().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PatientLab patientlab = fetchExc(ent.getOID()); 
		ent = (Entity)patientlab; 
		return patientlab.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PatientLab) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PatientLab) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PatientLab fetchExc(long oid) throws CONException{ 
		try{ 
			PatientLab patientlab = new PatientLab();
			DbPatientLab pstPatientLab = new DbPatientLab(oid); 
			patientlab.setOID(oid);

			patientlab.setDate(pstPatientLab.getDate(COL_DATE));
			patientlab.setPatientId(pstPatientLab.getlong(COL_PATIENT_ID));
			patientlab.setTestLabId(pstPatientLab.getlong(COL_TEST_LAB_ID));
			patientlab.setResultValue(pstPatientLab.getString(COL_RESULT_VALUE));
			patientlab.setNormalValue(pstPatientLab.getString(COL_NORMAL_VALUE));
			patientlab.setDescription(pstPatientLab.getString(COL_DESCRIPTION));

			return patientlab; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientLab(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PatientLab patientlab) throws CONException{ 
		try{ 
			DbPatientLab pstPatientLab = new DbPatientLab(0);

			pstPatientLab.setDate(COL_DATE, patientlab.getDate());
			pstPatientLab.setLong(COL_PATIENT_ID, patientlab.getPatientId());
			pstPatientLab.setLong(COL_TEST_LAB_ID, patientlab.getTestLabId());
			pstPatientLab.setString(COL_RESULT_VALUE, patientlab.getResultValue());
			pstPatientLab.setString(COL_NORMAL_VALUE, patientlab.getNormalValue());
			pstPatientLab.setString(COL_DESCRIPTION, patientlab.getDescription());

			pstPatientLab.insert(); 
			patientlab.setOID(pstPatientLab.getlong(COL_PATIENT_LAB_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientLab(0),CONException.UNKNOWN); 
		}
		return patientlab.getOID();
	}

	public static long updateExc(PatientLab patientlab) throws CONException{ 
		try{ 
			if(patientlab.getOID() != 0){ 
				DbPatientLab pstPatientLab = new DbPatientLab(patientlab.getOID());

				pstPatientLab.setDate(COL_DATE, patientlab.getDate());
				pstPatientLab.setLong(COL_PATIENT_ID, patientlab.getPatientId());
				pstPatientLab.setLong(COL_TEST_LAB_ID, patientlab.getTestLabId());
				pstPatientLab.setString(COL_RESULT_VALUE, patientlab.getResultValue());
				pstPatientLab.setString(COL_NORMAL_VALUE, patientlab.getNormalValue());
				pstPatientLab.setString(COL_DESCRIPTION, patientlab.getDescription());

				pstPatientLab.update(); 
				return patientlab.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientLab(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPatientLab pstPatientLab = new DbPatientLab(oid);
			pstPatientLab.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatientLab(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_PATIENT_LAB; 
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
				PatientLab patientlab = new PatientLab();
				resultToObject(rs, patientlab);
				lists.add(patientlab);
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

	private static void resultToObject(ResultSet rs, PatientLab patientlab){
		try{
			patientlab.setOID(rs.getLong(DbPatientLab.colNames[DbPatientLab.COL_PATIENT_LAB_ID]));
			patientlab.setDate(rs.getDate(DbPatientLab.colNames[DbPatientLab.COL_DATE]));
			patientlab.setPatientId(rs.getLong(DbPatientLab.colNames[DbPatientLab.COL_PATIENT_ID]));
			patientlab.setTestLabId(rs.getLong(DbPatientLab.colNames[DbPatientLab.COL_TEST_LAB_ID]));
			patientlab.setResultValue(rs.getString(DbPatientLab.colNames[DbPatientLab.COL_RESULT_VALUE]));
			patientlab.setNormalValue(rs.getString(DbPatientLab.colNames[DbPatientLab.COL_NORMAL_VALUE]));
			patientlab.setDescription(rs.getString(DbPatientLab.colNames[DbPatientLab.COL_DESCRIPTION]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long patientLabId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_PATIENT_LAB + " WHERE " + 
						DbPatientLab.colNames[DbPatientLab.COL_PATIENT_LAB_ID] + " = " + patientLabId;

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
			String sql = "SELECT COUNT("+ DbPatientLab.colNames[DbPatientLab.COL_PATIENT_LAB_ID] + ") FROM " + DB_CL_PATIENT_LAB;
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
			  	   PatientLab patientlab = (PatientLab)list.get(ls);
				   if(oid == patientlab.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
