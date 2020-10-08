package com.project.clinic.transaction;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspPatientXray extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PatientXray patientXray;

	public static final String JSP_NAME_PATIENTXRAY		=  "JSP_NAME_PATIENTXRAY" ;

	public static final int JSP_FIELD_PATIENT_XRAY_ID			=  0 ;
	public static final int JSP_FIELD_NAME			=  1 ;
	public static final int JSP_FIELD_DESCRIPTION			=  2 ;
	public static final int JSP_FIELD_IMAGE_NAME			=  3 ;

	public static String[] colNames = {
		"JSP_FIELD_PATIENT_XRAY_ID",  "JSP_FIELD_NAME",
		"JSP_FIELD_DESCRIPTION",  "JSP_FIELD_IMAGE_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspPatientXray(){
	}
	public JspPatientXray(PatientXray patientXray){
		this.patientXray = patientXray;
	}

	public JspPatientXray(HttpServletRequest request, PatientXray patientXray){
		super(new JspPatientXray(patientXray), request);
		this.patientXray = patientXray;
	}

	public String getFormName() { return JSP_NAME_PATIENTXRAY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PatientXray getEntityObject(){ return patientXray; }

	public void requestEntityObject(PatientXray patientXray) {
		try{
			this.requestParam();
			patientXray.setName(getLong(JSP_FIELD_NAME));
			patientXray.setDescription(getString(JSP_FIELD_DESCRIPTION));
			patientXray.setImageName(getString(JSP_FIELD_IMAGE_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
