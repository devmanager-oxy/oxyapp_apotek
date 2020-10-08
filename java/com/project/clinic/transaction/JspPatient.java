package com.project.clinic.transaction;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspPatient extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Patient patient;

	public static final String JSP_NAME_PATIENT		=  "JSP_NAME_PATIENT" ;

	public static final int JSP_FIELD_PATIENT_ID			=  0 ;
	public static final int JSP_FIELD_REG_DATE			=  1 ;
	public static final int JSP_FIELD_CIN			=  2 ;
	public static final int JSP_FIELD_COUNTER			=  3 ;
	public static final int JSP_FIELD_ID_NUMBER			=  4 ;
	public static final int JSP_FIELD_ID_TYPE			=  5 ;
	public static final int JSP_FIELD_TITLE			=  6 ;
	public static final int JSP_FIELD_GENDER			=  7 ;
	public static final int JSP_FIELD_NAME			=  8 ;
	public static final int JSP_FIELD_BIRTH_PLACE			=  9 ;
	public static final int JSP_FIELD_BIRTH_DATE			=  10 ;
	public static final int JSP_FIELD_ADDRESS			=  11 ;
	public static final int JSP_FIELD_STATE_ID			=  12 ;
	public static final int JSP_FIELD_COUNTRY_ID			=  13 ;
	public static final int JSP_FIELD_ZIP			=  14 ;
	public static final int JSP_FIELD_FAX			=  15 ;
	public static final int JSP_FIELD_COMPANY_ID			=  16 ;
	public static final int JSP_FIELD_EMAIL			=  17 ;
	public static final int JSP_FIELD_EMPLOYEE_NUM			=  18 ;
	public static final int JSP_FIELD_INSURANCE_ID			=  19 ;
	public static final int JSP_FIELD_INSURANCE_NO			=  20 ;
	public static final int JSP_FIELD_INSURANCE_RELATION_ID			=  21 ;
	public static final int JSP_FIELD_PHONE			=  22 ;
	public static final int JSP_FIELD_MOBILE			=  23 ;
	public static final int JSP_FIELD_OCCUPATION			=  24 ;
	public static final int JSP_FIELD_DOCTOR_ID			=  25 ;
	public static final int JSP_FIELD_POS_MEMBER_ID			=  26 ;

	public static String[] colNames = {
		"JSP_FIELD_PATIENT_ID",  "JSP_FIELD_REG_DATE",
		"JSP_FIELD_CIN",  "JSP_FIELD_COUNTER",
		"JSP_FIELD_ID_NUMBER",  "JSP_FIELD_ID_TYPE",
		"JSP_FIELD_TITLE",  "JSP_FIELD_GENDER",
		"JSP_FIELD_NAME",  "JSP_FIELD_BIRTH_PLACE",
		"JSP_FIELD_BIRTH_DATE",  "JSP_FIELD_ADDRESS",
		"JSP_FIELD_STATE_ID",  "JSP_FIELD_COUNTRY_ID",
		"JSP_FIELD_ZIP",  "JSP_FIELD_FAX",
		"JSP_FIELD_COMPANY_ID",  "JSP_FIELD_EMAIL",
		"JSP_FIELD_EMPLOYEE_NUM",  "JSP_FIELD_INSURANCE_ID",
		"JSP_FIELD_INSURANCE_NO",  "JSP_FIELD_INSURANCE_RELATION_ID",
		"JSP_FIELD_PHONE",  "JSP_FIELD_MOBILE",
		"JSP_FIELD_OCCUPATION",  "JSP_FIELD_DOCTOR_ID",
		"JSP_FIELD_POS_MEMBER_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_INT,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING,  TYPE_INT,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_STRING,
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
		TYPE_STRING,  TYPE_LONG,
		TYPE_STRING,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_LONG,
		TYPE_LONG
	} ;

	public JspPatient(){
	}
	public JspPatient(Patient patient){
		this.patient = patient;
	}

	public JspPatient(HttpServletRequest request, Patient patient){
		super(new JspPatient(patient), request);
		this.patient = patient;
	}

	public String getFormName() { return JSP_NAME_PATIENT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Patient getEntityObject(){ return patient; }

	public void requestEntityObject(Patient patient) {
		try{
			this.requestParam();
			patient.setRegDate(JSPFormater.formatDate(getString(JSP_FIELD_REG_DATE),"dd/MM/yyyy"));
			//patient.setCin(getString(JSP_FIELD_CIN));
			//patient.setCounter(getInt(JSP_FIELD_COUNTER));
			patient.setIdNumber(getString(JSP_FIELD_ID_NUMBER));
			patient.setIdType(getString(JSP_FIELD_ID_TYPE));
			patient.setTitle(getString(JSP_FIELD_TITLE));
			patient.setGender(getInt(JSP_FIELD_GENDER));
			patient.setName(getString(JSP_FIELD_NAME));
			patient.setBirthPlace(getString(JSP_FIELD_BIRTH_PLACE));
			patient.setBirthDate(JSPFormater.formatDate(getString(JSP_FIELD_BIRTH_DATE),"dd/MM/yyyy"));
			patient.setAddress(getString(JSP_FIELD_ADDRESS));
			patient.setStateId(getLong(JSP_FIELD_STATE_ID));
			patient.setCountryId(getLong(JSP_FIELD_COUNTRY_ID));
			patient.setZip(getString(JSP_FIELD_ZIP));
			patient.setFax(getString(JSP_FIELD_FAX));
			patient.setCompanyId(getLong(JSP_FIELD_COMPANY_ID));
			patient.setEmail(getString(JSP_FIELD_EMAIL));
			patient.setEmployeeNum(getString(JSP_FIELD_EMPLOYEE_NUM));
			patient.setInsuranceId(getLong(JSP_FIELD_INSURANCE_ID));
			patient.setInsuranceNo(getString(JSP_FIELD_INSURANCE_NO));
			patient.setInsuranceRelationId(getLong(JSP_FIELD_INSURANCE_RELATION_ID));
			patient.setPhone(getString(JSP_FIELD_PHONE));
			patient.setMobile(getString(JSP_FIELD_MOBILE));
			patient.setOccupation(getString(JSP_FIELD_OCCUPATION));
			patient.setDoctorId(getLong(JSP_FIELD_DOCTOR_ID));
			patient.setPosMemberId(getLong(JSP_FIELD_POS_MEMBER_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
