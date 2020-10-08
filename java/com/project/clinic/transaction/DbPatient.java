
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
import com.project.util.JSPFormater;

public class DbPatient extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_PATIENT = "CL_PATIENT";

	public static final  int COL_PATIENT_ID = 0;
	public static final  int COL_REG_DATE = 1;
	public static final  int COL_CIN = 2;
	public static final  int COL_COUNTER = 3;
	public static final  int COL_ID_NUMBER = 4;
	public static final  int COL_ID_TYPE = 5;
	public static final  int COL_TITLE = 6;
	public static final  int COL_GENDER = 7;
	public static final  int COL_NAME = 8;
	public static final  int COL_BIRTH_PLACE = 9;
	public static final  int COL_BIRTH_DATE = 10;
	public static final  int COL_ADDRESS = 11;
	public static final  int COL_STATE_ID = 12;
	public static final  int COL_COUNTRY_ID = 13;
	public static final  int COL_ZIP = 14;
	public static final  int COL_FAX = 15;
	public static final  int COL_COMPANY_ID = 16;
	public static final  int COL_EMAIL = 17;
	public static final  int COL_EMPLOYEE_NUM = 18;
	public static final  int COL_INSURANCE_ID = 19;
	public static final  int COL_INSURANCE_NO = 20;
	public static final  int COL_INSURANCE_RELATION_ID = 21;
	public static final  int COL_PHONE = 22;
	public static final  int COL_MOBILE = 23;
	public static final  int COL_OCCUPATION = 24;
	public static final  int COL_DOCTOR_ID = 25;
	public static final  int COL_POS_MEMBER_ID = 26;

	public static final  String[] colNames = {
		"PATIENT_ID",
		"REG_DATE",
		"CIN",
		"COUNTER",
		"ID_NUMBER",
		"ID_TYPE",
		"TITLE",
		"GENDER",
		"NAME",
		"BIRTH_PLACE",
		"BIRTH_DATE",
		"ADDRESS",
		"STATE_ID",
		"COUNTRY_ID",
		"ZIP",
		"FAX",
		"COMPANY_ID",
		"EMAIL",
		"EMPLOYEE_NUM",
		"INSURANCE_ID",
		"INSURANCE_NO",
		"INSURANCE_RELATION_ID",
		"PHONE",
		"MOBILE",
		"OCCUPATION",
		"DOCTOR_ID",
		"POS_MEMBER_ID"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_INT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG
	 }; 

	public DbPatient(){
	}

	public DbPatient(int i) throws CONException { 
		super(new DbPatient()); 
	}

	public DbPatient(String sOid) throws CONException { 
		super(new DbPatient(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPatient(long lOid) throws CONException { 
		super(new DbPatient(0)); 
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
		return DB_CL_PATIENT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPatient().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Patient patient = fetchExc(ent.getOID()); 
		ent = (Entity)patient; 
		return patient.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Patient) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Patient) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Patient fetchExc(long oid) throws CONException{ 
		try{ 
			Patient patient = new Patient();
			DbPatient pstPatient = new DbPatient(oid); 
			patient.setOID(oid);

			patient.setRegDate(pstPatient.getDate(COL_REG_DATE));
			patient.setCin(pstPatient.getString(COL_CIN));
			patient.setCounter(pstPatient.getInt(COL_COUNTER));
			patient.setIdNumber(pstPatient.getString(COL_ID_NUMBER));
			patient.setIdType(pstPatient.getString(COL_ID_TYPE));
			patient.setTitle(pstPatient.getString(COL_TITLE));
			patient.setGender(pstPatient.getInt(COL_GENDER));
			patient.setName(pstPatient.getString(COL_NAME));
			patient.setBirthPlace(pstPatient.getString(COL_BIRTH_PLACE));
			patient.setBirthDate(pstPatient.getDate(COL_BIRTH_DATE));
			patient.setAddress(pstPatient.getString(COL_ADDRESS));
			patient.setStateId(pstPatient.getlong(COL_STATE_ID));
			patient.setCountryId(pstPatient.getlong(COL_COUNTRY_ID));
			patient.setZip(pstPatient.getString(COL_ZIP));
			patient.setFax(pstPatient.getString(COL_FAX));
			patient.setCompanyId(pstPatient.getlong(COL_COMPANY_ID));
			patient.setEmail(pstPatient.getString(COL_EMAIL));
			patient.setEmployeeNum(pstPatient.getString(COL_EMPLOYEE_NUM));
			patient.setInsuranceId(pstPatient.getlong(COL_INSURANCE_ID));
			patient.setInsuranceNo(pstPatient.getString(COL_INSURANCE_NO));
			patient.setInsuranceRelationId(pstPatient.getlong(COL_INSURANCE_RELATION_ID));
			patient.setPhone(pstPatient.getString(COL_PHONE));
			patient.setMobile(pstPatient.getString(COL_MOBILE));
			patient.setOccupation(pstPatient.getString(COL_OCCUPATION));
			patient.setDoctorId(pstPatient.getlong(COL_DOCTOR_ID));
			patient.setPosMemberId(pstPatient.getlong(COL_POS_MEMBER_ID));

			return patient; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatient(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Patient patient) throws CONException{ 
		try{ 
			DbPatient pstPatient = new DbPatient(0);

			pstPatient.setDate(COL_REG_DATE, patient.getRegDate());
			pstPatient.setString(COL_CIN, patient.getCin());
			pstPatient.setInt(COL_COUNTER, patient.getCounter());
			pstPatient.setString(COL_ID_NUMBER, patient.getIdNumber());
			pstPatient.setString(COL_ID_TYPE, patient.getIdType());
			pstPatient.setString(COL_TITLE, patient.getTitle());
			pstPatient.setInt(COL_GENDER, patient.getGender());
			pstPatient.setString(COL_NAME, patient.getName());
			pstPatient.setString(COL_BIRTH_PLACE, patient.getBirthPlace());
			pstPatient.setDate(COL_BIRTH_DATE, patient.getBirthDate());
			pstPatient.setString(COL_ADDRESS, patient.getAddress());
			pstPatient.setLong(COL_STATE_ID, patient.getStateId());
			pstPatient.setLong(COL_COUNTRY_ID, patient.getCountryId());
			pstPatient.setString(COL_ZIP, patient.getZip());
			pstPatient.setString(COL_FAX, patient.getFax());
			pstPatient.setLong(COL_COMPANY_ID, patient.getCompanyId());
			pstPatient.setString(COL_EMAIL, patient.getEmail());
			pstPatient.setString(COL_EMPLOYEE_NUM, patient.getEmployeeNum());
			pstPatient.setLong(COL_INSURANCE_ID, patient.getInsuranceId());
			pstPatient.setString(COL_INSURANCE_NO, patient.getInsuranceNo());
			pstPatient.setLong(COL_INSURANCE_RELATION_ID, patient.getInsuranceRelationId());
			pstPatient.setString(COL_PHONE, patient.getPhone());
			pstPatient.setString(COL_MOBILE, patient.getMobile());
			pstPatient.setString(COL_OCCUPATION, patient.getOccupation());
			pstPatient.setLong(COL_DOCTOR_ID, patient.getDoctorId());
			pstPatient.setLong(COL_POS_MEMBER_ID, patient.getPosMemberId());

			pstPatient.insert(); 
			patient.setOID(pstPatient.getlong(COL_PATIENT_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatient(0),CONException.UNKNOWN); 
		}
		return patient.getOID();
	}

	public static long updateExc(Patient patient) throws CONException{ 
		try{ 
			if(patient.getOID() != 0){ 
				DbPatient pstPatient = new DbPatient(patient.getOID());

				pstPatient.setDate(COL_REG_DATE, patient.getRegDate());
				pstPatient.setString(COL_CIN, patient.getCin());
				pstPatient.setInt(COL_COUNTER, patient.getCounter());
				pstPatient.setString(COL_ID_NUMBER, patient.getIdNumber());
				pstPatient.setString(COL_ID_TYPE, patient.getIdType());
				pstPatient.setString(COL_TITLE, patient.getTitle());
				pstPatient.setInt(COL_GENDER, patient.getGender());
				pstPatient.setString(COL_NAME, patient.getName());
				pstPatient.setString(COL_BIRTH_PLACE, patient.getBirthPlace());
				pstPatient.setDate(COL_BIRTH_DATE, patient.getBirthDate());
				pstPatient.setString(COL_ADDRESS, patient.getAddress());
				pstPatient.setLong(COL_STATE_ID, patient.getStateId());
				pstPatient.setLong(COL_COUNTRY_ID, patient.getCountryId());
				pstPatient.setString(COL_ZIP, patient.getZip());
				pstPatient.setString(COL_FAX, patient.getFax());
				pstPatient.setLong(COL_COMPANY_ID, patient.getCompanyId());
				pstPatient.setString(COL_EMAIL, patient.getEmail());
				pstPatient.setString(COL_EMPLOYEE_NUM, patient.getEmployeeNum());
				pstPatient.setLong(COL_INSURANCE_ID, patient.getInsuranceId());
				pstPatient.setString(COL_INSURANCE_NO, patient.getInsuranceNo());
				pstPatient.setLong(COL_INSURANCE_RELATION_ID, patient.getInsuranceRelationId());
				pstPatient.setString(COL_PHONE, patient.getPhone());
				pstPatient.setString(COL_MOBILE, patient.getMobile());
				pstPatient.setString(COL_OCCUPATION, patient.getOccupation());
				pstPatient.setLong(COL_DOCTOR_ID, patient.getDoctorId());
				pstPatient.setLong(COL_POS_MEMBER_ID, patient.getPosMemberId());

				pstPatient.update(); 
				return patient.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatient(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPatient pstPatient = new DbPatient(oid);
			pstPatient.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPatient(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_PATIENT; 
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
				Patient patient = new Patient();
				resultToObject(rs, patient);
				lists.add(patient);
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

	private static void resultToObject(ResultSet rs, Patient patient){
		try{
			patient.setOID(rs.getLong(DbPatient.colNames[DbPatient.COL_PATIENT_ID]));
			patient.setRegDate(rs.getDate(DbPatient.colNames[DbPatient.COL_REG_DATE]));
			patient.setCin(rs.getString(DbPatient.colNames[DbPatient.COL_CIN]));
			patient.setCounter(rs.getInt(DbPatient.colNames[DbPatient.COL_COUNTER]));
			patient.setIdNumber(rs.getString(DbPatient.colNames[DbPatient.COL_ID_NUMBER]));
			patient.setIdType(rs.getString(DbPatient.colNames[DbPatient.COL_ID_TYPE]));
			patient.setTitle(rs.getString(DbPatient.colNames[DbPatient.COL_TITLE]));
			patient.setGender(rs.getInt(DbPatient.colNames[DbPatient.COL_GENDER]));
			patient.setName(rs.getString(DbPatient.colNames[DbPatient.COL_NAME]));
			patient.setBirthPlace(rs.getString(DbPatient.colNames[DbPatient.COL_BIRTH_PLACE]));
			patient.setBirthDate(rs.getDate(DbPatient.colNames[DbPatient.COL_BIRTH_DATE]));
			patient.setAddress(rs.getString(DbPatient.colNames[DbPatient.COL_ADDRESS]));
			patient.setStateId(rs.getLong(DbPatient.colNames[DbPatient.COL_STATE_ID]));
			patient.setCountryId(rs.getLong(DbPatient.colNames[DbPatient.COL_COUNTRY_ID]));
			patient.setZip(rs.getString(DbPatient.colNames[DbPatient.COL_ZIP]));
			patient.setFax(rs.getString(DbPatient.colNames[DbPatient.COL_FAX]));
			patient.setCompanyId(rs.getLong(DbPatient.colNames[DbPatient.COL_COMPANY_ID]));
			patient.setEmail(rs.getString(DbPatient.colNames[DbPatient.COL_EMAIL]));
			patient.setEmployeeNum(rs.getString(DbPatient.colNames[DbPatient.COL_EMPLOYEE_NUM]));
			patient.setInsuranceId(rs.getLong(DbPatient.colNames[DbPatient.COL_INSURANCE_ID]));
			patient.setInsuranceNo(rs.getString(DbPatient.colNames[DbPatient.COL_INSURANCE_NO]));
			patient.setInsuranceRelationId(rs.getLong(DbPatient.colNames[DbPatient.COL_INSURANCE_RELATION_ID]));
			patient.setPhone(rs.getString(DbPatient.colNames[DbPatient.COL_PHONE]));
			patient.setMobile(rs.getString(DbPatient.colNames[DbPatient.COL_MOBILE]));
			patient.setOccupation(rs.getString(DbPatient.colNames[DbPatient.COL_OCCUPATION]));
			patient.setDoctorId(rs.getLong(DbPatient.colNames[DbPatient.COL_DOCTOR_ID]));
			patient.setPosMemberId(rs.getLong(DbPatient.colNames[DbPatient.COL_POS_MEMBER_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long patientId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_PATIENT + " WHERE " + 
						DbPatient.colNames[DbPatient.COL_PATIENT_ID] + " = " + patientId;

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
			String sql = "SELECT COUNT("+ DbPatient.colNames[DbPatient.COL_PATIENT_ID] + ") FROM " + DB_CL_PATIENT;
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
			  	   Patient patient = (Patient)list.get(ls);
				   if(oid == patient.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static int getNextCounter(){
            String where = colNames[COL_CIN]+" like '"+JSPFormater.formatDate(new Date(), "MMyy")+"%'";
            String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_CL_PATIENT+" where  "+where;
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
            
            return (result+1);                     
        }
        
        public static String getNextNumber(int cnt){
            String code = JSPFormater.formatDate(new Date(), "MMyy");
            if(cnt<10){
                code = code + ".000"+cnt;
            }
            else if(cnt<100){
                code = code + ".00"+cnt;
            }
            else if(cnt<1000){
                code = code + ".0"+cnt;
            }
            else{
                code = code + "."+cnt;
            }
            
            return code;
        }
        
        
}
