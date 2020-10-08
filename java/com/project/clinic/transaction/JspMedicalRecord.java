package com.project.clinic.transaction;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspMedicalRecord extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private MedicalRecord medicalRecord;

	public static final String JSP_NAME_MEDICALRECORD		=  "JSP_NAME_MEDICALRECORD" ;

	public static final int JSP_FIELD_MEDICAL_RECORD_ID			=  0 ;
	public static final int JSP_FIELD_NUMBER			=  1 ;
	public static final int JSP_FIELD_COUNTER			=  2 ;
	public static final int JSP_FIELD_PATIENT_ID			=  3 ;
	public static final int JSP_FIELD_RESERVATION_ID			=  4 ;
	public static final int JSP_FIELD_REG_DATE			=  5 ;
	public static final int JSP_FIELD_DOCTOR_ID			=  6 ;
	public static final int JSP_FIELD_WEIGHT			=  7 ;
	public static final int JSP_FIELD_HEIGHT			=  8 ;
	public static final int JSP_FIELD_TEMPERATURE			=  9 ;
	public static final int JSP_FIELD_RESPIRATION			=  10 ;
	public static final int JSP_FIELD_PULSE			=  11 ;
	public static final int JSP_FIELD_BLOOD_CLASS			=  12 ;
	public static final int JSP_FIELD_BP_DIATOPLIC			=  13 ;
	public static final int JSP_FIELD_BP_SYSTOLIC			=  14 ;
	public static final int JSP_FIELD_COMPLAINTS			=  15 ;
	public static final int JSP_FIELD_TEST_CONDUCTED			=  16 ;
	public static final int JSP_FIELD_RESULTS			=  17 ;
	public static final int JSP_FIELD_PRESCRIPTION			=  18 ;
	public static final int JSP_FIELD_DIAGNOSIS_ID			=  19 ;

	public static String[] colNames = {
		"JSP_FIELD_MEDICAL_RECORD_ID",  "JSP_FIELD_NUMBER",
		"JSP_FIELD_COUNTER",  "JSP_FIELD_PATIENT_ID",
		"JSP_FIELD_RESERVATION_ID",  "JSP_FIELD_REG_DATE",
		"JSP_FIELD_DOCTOR_ID",  "JSP_FIELD_WEIGHT",
		"JSP_FIELD_HEIGHT",  "JSP_FIELD_TEMPERATURE",
		"JSP_FIELD_RESPIRATION",  "JSP_FIELD_PULSE",
		"JSP_FIELD_BLOOD_CLASS",  "JSP_FIELD_BP_DIATOPLIC",
		"JSP_FIELD_BP_SYSTOLIC",  "JSP_FIELD_COMPLAINTS",
		"JSP_FIELD_TEST_CONDUCTED",  "JSP_FIELD_RESULTS",
		"JSP_FIELD_PRESCRIPTION",  "JSP_FIELD_DIAGNOSIS_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_INT,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG,  TYPE_DATE,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_LONG
	} ;

	public JspMedicalRecord(){
	}
	public JspMedicalRecord(MedicalRecord medicalRecord){
		this.medicalRecord = medicalRecord;
	}

	public JspMedicalRecord(HttpServletRequest request, MedicalRecord medicalRecord){
		super(new JspMedicalRecord(medicalRecord), request);
		this.medicalRecord = medicalRecord;
	}

	public String getFormName() { return JSP_NAME_MEDICALRECORD; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public MedicalRecord getEntityObject(){ return medicalRecord; }

	public void requestEntityObject(MedicalRecord medicalRecord) {
		try{
			this.requestParam();
			medicalRecord.setNumber(getString(JSP_FIELD_NUMBER));
			medicalRecord.setCounter(getInt(JSP_FIELD_COUNTER));
			medicalRecord.setPatientId(getLong(JSP_FIELD_PATIENT_ID));
			medicalRecord.setReservationId(getLong(JSP_FIELD_RESERVATION_ID));
			medicalRecord.setRegDate(getDate(JSP_FIELD_REG_DATE));
			medicalRecord.setDoctorId(getLong(JSP_FIELD_DOCTOR_ID));
			medicalRecord.setWeight(getDouble(JSP_FIELD_WEIGHT));
			medicalRecord.setHeight(getDouble(JSP_FIELD_HEIGHT));
			medicalRecord.setTemperature(getDouble(JSP_FIELD_TEMPERATURE));
			medicalRecord.setRespiration(getDouble(JSP_FIELD_RESPIRATION));
			medicalRecord.setPulse(getDouble(JSP_FIELD_PULSE));
			medicalRecord.setBloodClass(getString(JSP_FIELD_BLOOD_CLASS));
			medicalRecord.setBpDiatoplic(getString(JSP_FIELD_BP_DIATOPLIC));
			medicalRecord.setBpSystolic(getString(JSP_FIELD_BP_SYSTOLIC));
			medicalRecord.setComplaints(getString(JSP_FIELD_COMPLAINTS));
			medicalRecord.setTestConducted(getString(JSP_FIELD_TEST_CONDUCTED));
			medicalRecord.setResults(getString(JSP_FIELD_RESULTS));
			medicalRecord.setPrescription(getString(JSP_FIELD_PRESCRIPTION));
			medicalRecord.setDiagnosisId(getLong(JSP_FIELD_DIAGNOSIS_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
