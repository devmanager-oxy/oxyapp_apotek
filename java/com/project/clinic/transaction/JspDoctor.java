package com.project.clinic.transaction;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspDoctor extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Doctor doctor;

	public static final String JSP_NAME_DOCTOR		=  "JSP_NAME_DOCTOR" ;

	public static final int JSP_FIELD_DOCTOR_ID			=  0 ;
	public static final int JSP_FIELD_TITLE			=  1 ;
	public static final int JSP_FIELD_NAME			=  2 ;
	public static final int JSP_FIELD_SPECIALTY_ID			=  3 ;
	public static final int JSP_FIELD_SSN			=  4 ;
	public static final int JSP_FIELD_DEGREE			=  5 ;
	public static final int JSP_FIELD_EMAIL			=  6 ;
	public static final int JSP_FIELD_ADDRESS			=  7 ;
	public static final int JSP_FIELD_STATE_ID			=  8 ;
	public static final int JSP_FIELD_COUNTRY_ID			=  9 ;
	public static final int JSP_FIELD_ZIP			=  10 ;
	public static final int JSP_FIELD_FAX			=  11 ;
	public static final int JSP_FIELD_PHONE			=  12 ;
	public static final int JSP_FIELD_MOBILE			=  13 ;

	public static String[] colNames = {
		"JSP_FIELD_DOCTOR_ID",  "JSP_FIELD_TITLE",
		"JSP_FIELD_NAME",  "JSP_FIELD_SPECIALTY_ID",
		"JSP_FIELD_SSN",  "JSP_FIELD_DEGREE",
		"JSP_FIELD_EMAIL",  "JSP_FIELD_ADDRESS",
		"JSP_FIELD_STATE_ID",  "JSP_FIELD_COUNTRY_ID",
		"JSP_FIELD_ZIP",  "JSP_FIELD_FAX",
		"JSP_FIELD_PHONE",  "JSP_FIELD_MOBILE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_LONG,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspDoctor(){
	}
	public JspDoctor(Doctor doctor){
		this.doctor = doctor;
	}

	public JspDoctor(HttpServletRequest request, Doctor doctor){
		super(new JspDoctor(doctor), request);
		this.doctor = doctor;
	}

	public String getFormName() { return JSP_NAME_DOCTOR; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Doctor getEntityObject(){ return doctor; }

	public void requestEntityObject(Doctor doctor) {
		try{
			this.requestParam();
			doctor.setTitle(getString(JSP_FIELD_TITLE));
			doctor.setName(getString(JSP_FIELD_NAME));
			doctor.setSpecialtyId(getLong(JSP_FIELD_SPECIALTY_ID));
			doctor.setSsn(getString(JSP_FIELD_SSN));
			doctor.setDegree(getString(JSP_FIELD_DEGREE));
			doctor.setEmail(getString(JSP_FIELD_EMAIL));
			doctor.setAddress(getString(JSP_FIELD_ADDRESS));
			doctor.setStateId(getLong(JSP_FIELD_STATE_ID));
			doctor.setCountryId(getLong(JSP_FIELD_COUNTRY_ID));
			doctor.setZip(getString(JSP_FIELD_ZIP));
			doctor.setFax(getString(JSP_FIELD_FAX));
			doctor.setPhone(getString(JSP_FIELD_PHONE));
			doctor.setMobile(getString(JSP_FIELD_MOBILE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
