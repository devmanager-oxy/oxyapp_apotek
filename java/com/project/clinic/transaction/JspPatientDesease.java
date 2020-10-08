package com.project.clinic.transaction;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspPatientDesease extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PatientDesease patientDesease;

	public static final String JSP_NAME_PATIENTDESEASE		=  "JSP_NAME_PATIENTDESEASE" ;

	public static final int JSP_FIELD_DESEASE_ID			=  0 ;
	public static final int JSP_FIELD_PATIENT_ID			=  1 ;
	public static final int JSP_FIELD_PATIENT_DESEAS_ID			=  2 ;

	public static String[] colNames = {
		"JSP_FIELD_DESEASE_ID",  "JSP_FIELD_PATIENT_ID",
		"JSP_FIELD_PATIENT_DESEAS_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG
	} ;

	public JspPatientDesease(){
	}
	public JspPatientDesease(PatientDesease patientDesease){
		this.patientDesease = patientDesease;
	}

	public JspPatientDesease(HttpServletRequest request, PatientDesease patientDesease){
		super(new JspPatientDesease(patientDesease), request);
		this.patientDesease = patientDesease;
	}

	public String getFormName() { return JSP_NAME_PATIENTDESEASE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PatientDesease getEntityObject(){ return patientDesease; }

	public void requestEntityObject(PatientDesease patientDesease) {
		try{
			this.requestParam();
			patientDesease.setDeseaseId(getLong(JSP_FIELD_DESEASE_ID));
			patientDesease.setPatientId(getLong(JSP_FIELD_PATIENT_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
