package com.project.clinic.transaction;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspPatientLab extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PatientLab patientLab;

	public static final String JSP_NAME_PATIENTLAB		=  "JSP_NAME_PATIENTLAB" ;

	public static final int JSP_FIELD_PATIENT_LAB_ID			=  0 ;
	public static final int JSP_FIELD_DATE			=  1 ;
	public static final int JSP_FIELD_PATIENT_ID			=  2 ;
	public static final int JSP_FIELD_TEST_LAB_ID			=  3 ;
	public static final int JSP_FIELD_RESULT_VALUE			=  4 ;
	public static final int JSP_FIELD_NORMAL_VALUE			=  5 ;
	public static final int JSP_FIELD_DESCRIPTION			=  6 ;

	public static String[] colNames = {
		"JSP_FIELD_PATIENT_LAB_ID",  "JSP_FIELD_DATE",
		"JSP_FIELD_PATIENT_ID",  "JSP_FIELD_TEST_LAB_ID",
		"JSP_FIELD_RESULT_VALUE",  "JSP_FIELD_NORMAL_VALUE",
		"JSP_FIELD_DESCRIPTION"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_DATE,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING
	} ;

	public JspPatientLab(){
	}
	public JspPatientLab(PatientLab patientLab){
		this.patientLab = patientLab;
	}

	public JspPatientLab(HttpServletRequest request, PatientLab patientLab){
		super(new JspPatientLab(patientLab), request);
		this.patientLab = patientLab;
	}

	public String getFormName() { return JSP_NAME_PATIENTLAB; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PatientLab getEntityObject(){ return patientLab; }

	public void requestEntityObject(PatientLab patientLab) {
		try{
			this.requestParam();
			patientLab.setDate(getDate(JSP_FIELD_DATE));
			patientLab.setPatientId(getLong(JSP_FIELD_PATIENT_ID));
			patientLab.setTestLabId(getLong(JSP_FIELD_TEST_LAB_ID));
			patientLab.setResultValue(getString(JSP_FIELD_RESULT_VALUE));
			patientLab.setNormalValue(getString(JSP_FIELD_NORMAL_VALUE));
			patientLab.setDescription(getString(JSP_FIELD_DESCRIPTION));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
