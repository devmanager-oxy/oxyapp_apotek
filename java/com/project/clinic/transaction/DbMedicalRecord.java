
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

public class DbMedicalRecord extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_MEDICAL_RECORD = "CL_MEDICAL_RECORD";

	public static final  int COL_MEDICAL_RECORD_ID = 0;
	public static final  int COL_NUMBER = 1;
	public static final  int COL_COUNTER = 2;
	public static final  int COL_PATIENT_ID = 3;
	public static final  int COL_RESERVATION_ID = 4;
	public static final  int COL_REG_DATE = 5;
	public static final  int COL_DOCTOR_ID = 6;
	public static final  int COL_WEIGHT = 7;
	public static final  int COL_HEIGHT = 8;
	public static final  int COL_TEMPERATURE = 9;
	public static final  int COL_RESPIRATION = 10;
	public static final  int COL_PULSE = 11;
	public static final  int COL_BLOOD_CLASS = 12;
	public static final  int COL_BP_DIATOPLIC = 13;
	public static final  int COL_BP_SYSTOLIC = 14;
	public static final  int COL_COMPLAINTS = 15;
	public static final  int COL_TEST_CONDUCTED = 16;
	public static final  int COL_RESULTS = 17;
	public static final  int COL_PRESCRIPTION = 18;
	public static final  int COL_DIAGNOSIS_ID = 19;

	public static final  String[] colNames = {
		"MEDICAL_RECORD_ID",
		"NUMBER",
		"COUNTER",
		"PATIENT_ID",
		"RESERVATION_ID",
		"REG_DATE",
		"DOCTOR_ID",
		"WEIGHT",
		"HEIGHT",
		"TEMPERATURE",
		"RESPIRATION",
		"PULSE",
		"BLOOD_CLASS",
		"BP_DIATOPLIC",
		"BP_SYSTOLIC",
		"COMPLAINTS",
		"TEST_CONDUCTED",
		"RESULTS",
		"PRESCRIPTION",
		"DIAGNOSIS_ID"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG
	 }; 

	public DbMedicalRecord(){
	}

	public DbMedicalRecord(int i) throws CONException { 
		super(new DbMedicalRecord()); 
	}

	public DbMedicalRecord(String sOid) throws CONException { 
		super(new DbMedicalRecord(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbMedicalRecord(long lOid) throws CONException { 
		super(new DbMedicalRecord(0)); 
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
		return DB_CL_MEDICAL_RECORD;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbMedicalRecord().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		MedicalRecord medicalrecord = fetchExc(ent.getOID()); 
		ent = (Entity)medicalrecord; 
		return medicalrecord.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((MedicalRecord) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((MedicalRecord) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static MedicalRecord fetchExc(long oid) throws CONException{ 
		try{ 
			MedicalRecord medicalrecord = new MedicalRecord();
			DbMedicalRecord pstMedicalRecord = new DbMedicalRecord(oid); 
			medicalrecord.setOID(oid);

			medicalrecord.setNumber(pstMedicalRecord.getString(COL_NUMBER));
			medicalrecord.setCounter(pstMedicalRecord.getInt(COL_COUNTER));
			medicalrecord.setPatientId(pstMedicalRecord.getlong(COL_PATIENT_ID));
			medicalrecord.setReservationId(pstMedicalRecord.getlong(COL_RESERVATION_ID));
			medicalrecord.setRegDate(pstMedicalRecord.getDate(COL_REG_DATE));
			medicalrecord.setDoctorId(pstMedicalRecord.getlong(COL_DOCTOR_ID));
			medicalrecord.setWeight(pstMedicalRecord.getdouble(COL_WEIGHT));
			medicalrecord.setHeight(pstMedicalRecord.getdouble(COL_HEIGHT));
			medicalrecord.setTemperature(pstMedicalRecord.getdouble(COL_TEMPERATURE));
			medicalrecord.setRespiration(pstMedicalRecord.getdouble(COL_RESPIRATION));
			medicalrecord.setPulse(pstMedicalRecord.getdouble(COL_PULSE));
			medicalrecord.setBloodClass(pstMedicalRecord.getString(COL_BLOOD_CLASS));
			medicalrecord.setBpDiatoplic(pstMedicalRecord.getString(COL_BP_DIATOPLIC));
			medicalrecord.setBpSystolic(pstMedicalRecord.getString(COL_BP_SYSTOLIC));
			medicalrecord.setComplaints(pstMedicalRecord.getString(COL_COMPLAINTS));
			medicalrecord.setTestConducted(pstMedicalRecord.getString(COL_TEST_CONDUCTED));
			medicalrecord.setResults(pstMedicalRecord.getString(COL_RESULTS));
			medicalrecord.setPrescription(pstMedicalRecord.getString(COL_PRESCRIPTION));
			medicalrecord.setDiagnosisId(pstMedicalRecord.getlong(COL_DIAGNOSIS_ID));

			return medicalrecord; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMedicalRecord(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(MedicalRecord medicalrecord) throws CONException{ 
		try{ 
			DbMedicalRecord pstMedicalRecord = new DbMedicalRecord(0);

			pstMedicalRecord.setString(COL_NUMBER, medicalrecord.getNumber());
			pstMedicalRecord.setInt(COL_COUNTER, medicalrecord.getCounter());
			pstMedicalRecord.setLong(COL_PATIENT_ID, medicalrecord.getPatientId());
			pstMedicalRecord.setLong(COL_RESERVATION_ID, medicalrecord.getReservationId());
			pstMedicalRecord.setDate(COL_REG_DATE, medicalrecord.getRegDate());
			pstMedicalRecord.setLong(COL_DOCTOR_ID, medicalrecord.getDoctorId());
			pstMedicalRecord.setDouble(COL_WEIGHT, medicalrecord.getWeight());
			pstMedicalRecord.setDouble(COL_HEIGHT, medicalrecord.getHeight());
			pstMedicalRecord.setDouble(COL_TEMPERATURE, medicalrecord.getTemperature());
			pstMedicalRecord.setDouble(COL_RESPIRATION, medicalrecord.getRespiration());
			pstMedicalRecord.setDouble(COL_PULSE, medicalrecord.getPulse());
			pstMedicalRecord.setString(COL_BLOOD_CLASS, medicalrecord.getBloodClass());
			pstMedicalRecord.setString(COL_BP_DIATOPLIC, medicalrecord.getBpDiatoplic());
			pstMedicalRecord.setString(COL_BP_SYSTOLIC, medicalrecord.getBpSystolic());
			pstMedicalRecord.setString(COL_COMPLAINTS, medicalrecord.getComplaints());
			pstMedicalRecord.setString(COL_TEST_CONDUCTED, medicalrecord.getTestConducted());
			pstMedicalRecord.setString(COL_RESULTS, medicalrecord.getResults());
			pstMedicalRecord.setString(COL_PRESCRIPTION, medicalrecord.getPrescription());
			pstMedicalRecord.setLong(COL_DIAGNOSIS_ID, medicalrecord.getDiagnosisId());

			pstMedicalRecord.insert(); 
			medicalrecord.setOID(pstMedicalRecord.getlong(COL_MEDICAL_RECORD_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMedicalRecord(0),CONException.UNKNOWN); 
		}
		return medicalrecord.getOID();
	}

	public static long updateExc(MedicalRecord medicalrecord) throws CONException{ 
		try{ 
			if(medicalrecord.getOID() != 0){ 
				DbMedicalRecord pstMedicalRecord = new DbMedicalRecord(medicalrecord.getOID());

				pstMedicalRecord.setString(COL_NUMBER, medicalrecord.getNumber());
				pstMedicalRecord.setInt(COL_COUNTER, medicalrecord.getCounter());
				pstMedicalRecord.setLong(COL_PATIENT_ID, medicalrecord.getPatientId());
				pstMedicalRecord.setLong(COL_RESERVATION_ID, medicalrecord.getReservationId());
				pstMedicalRecord.setDate(COL_REG_DATE, medicalrecord.getRegDate());
				pstMedicalRecord.setLong(COL_DOCTOR_ID, medicalrecord.getDoctorId());
				pstMedicalRecord.setDouble(COL_WEIGHT, medicalrecord.getWeight());
				pstMedicalRecord.setDouble(COL_HEIGHT, medicalrecord.getHeight());
				pstMedicalRecord.setDouble(COL_TEMPERATURE, medicalrecord.getTemperature());
				pstMedicalRecord.setDouble(COL_RESPIRATION, medicalrecord.getRespiration());
				pstMedicalRecord.setDouble(COL_PULSE, medicalrecord.getPulse());
				pstMedicalRecord.setString(COL_BLOOD_CLASS, medicalrecord.getBloodClass());
				pstMedicalRecord.setString(COL_BP_DIATOPLIC, medicalrecord.getBpDiatoplic());
				pstMedicalRecord.setString(COL_BP_SYSTOLIC, medicalrecord.getBpSystolic());
				pstMedicalRecord.setString(COL_COMPLAINTS, medicalrecord.getComplaints());
				pstMedicalRecord.setString(COL_TEST_CONDUCTED, medicalrecord.getTestConducted());
				pstMedicalRecord.setString(COL_RESULTS, medicalrecord.getResults());
				pstMedicalRecord.setString(COL_PRESCRIPTION, medicalrecord.getPrescription());
				pstMedicalRecord.setLong(COL_DIAGNOSIS_ID, medicalrecord.getDiagnosisId());

				pstMedicalRecord.update(); 
				return medicalrecord.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMedicalRecord(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbMedicalRecord pstMedicalRecord = new DbMedicalRecord(oid);
			pstMedicalRecord.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMedicalRecord(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_MEDICAL_RECORD; 
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
				MedicalRecord medicalrecord = new MedicalRecord();
				resultToObject(rs, medicalrecord);
				lists.add(medicalrecord);
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

	private static void resultToObject(ResultSet rs, MedicalRecord medicalrecord){
		try{
			medicalrecord.setOID(rs.getLong(DbMedicalRecord.colNames[DbMedicalRecord.COL_MEDICAL_RECORD_ID]));
			medicalrecord.setNumber(rs.getString(DbMedicalRecord.colNames[DbMedicalRecord.COL_NUMBER]));
			medicalrecord.setCounter(rs.getInt(DbMedicalRecord.colNames[DbMedicalRecord.COL_COUNTER]));
			medicalrecord.setPatientId(rs.getLong(DbMedicalRecord.colNames[DbMedicalRecord.COL_PATIENT_ID]));
			medicalrecord.setReservationId(rs.getLong(DbMedicalRecord.colNames[DbMedicalRecord.COL_RESERVATION_ID]));
			medicalrecord.setRegDate(rs.getDate(DbMedicalRecord.colNames[DbMedicalRecord.COL_REG_DATE]));
			medicalrecord.setDoctorId(rs.getLong(DbMedicalRecord.colNames[DbMedicalRecord.COL_DOCTOR_ID]));
			medicalrecord.setWeight(rs.getDouble(DbMedicalRecord.colNames[DbMedicalRecord.COL_WEIGHT]));
			medicalrecord.setHeight(rs.getDouble(DbMedicalRecord.colNames[DbMedicalRecord.COL_HEIGHT]));
			medicalrecord.setTemperature(rs.getDouble(DbMedicalRecord.colNames[DbMedicalRecord.COL_TEMPERATURE]));
			medicalrecord.setRespiration(rs.getDouble(DbMedicalRecord.colNames[DbMedicalRecord.COL_RESPIRATION]));
			medicalrecord.setPulse(rs.getDouble(DbMedicalRecord.colNames[DbMedicalRecord.COL_PULSE]));
			medicalrecord.setBloodClass(rs.getString(DbMedicalRecord.colNames[DbMedicalRecord.COL_BLOOD_CLASS]));
			medicalrecord.setBpDiatoplic(rs.getString(DbMedicalRecord.colNames[DbMedicalRecord.COL_BP_DIATOPLIC]));
			medicalrecord.setBpSystolic(rs.getString(DbMedicalRecord.colNames[DbMedicalRecord.COL_BP_SYSTOLIC]));
			medicalrecord.setComplaints(rs.getString(DbMedicalRecord.colNames[DbMedicalRecord.COL_COMPLAINTS]));
			medicalrecord.setTestConducted(rs.getString(DbMedicalRecord.colNames[DbMedicalRecord.COL_TEST_CONDUCTED]));
			medicalrecord.setResults(rs.getString(DbMedicalRecord.colNames[DbMedicalRecord.COL_RESULTS]));
			medicalrecord.setPrescription(rs.getString(DbMedicalRecord.colNames[DbMedicalRecord.COL_PRESCRIPTION]));
			medicalrecord.setDiagnosisId(rs.getLong(DbMedicalRecord.colNames[DbMedicalRecord.COL_DIAGNOSIS_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long medicalRecordId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_MEDICAL_RECORD + " WHERE " + 
						DbMedicalRecord.colNames[DbMedicalRecord.COL_MEDICAL_RECORD_ID] + " = " + medicalRecordId;

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
			String sql = "SELECT COUNT("+ DbMedicalRecord.colNames[DbMedicalRecord.COL_MEDICAL_RECORD_ID] + ") FROM " + DB_CL_MEDICAL_RECORD;
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
			  	   MedicalRecord medicalrecord = (MedicalRecord)list.get(ls);
				   if(oid == medicalrecord.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
