package com.project.clinic.master;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspDiagnosis extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Diagnosis diagnosis;

	public static final String JSP_NAME_DIAGNOSIS		=  "JSP_NAME_DIAGNOSIS" ;

	public static final int JSP_FIELD_DIAGNOSIS_ID			=  0 ;
	public static final int JSP_FIELD_CODE			=  1 ;
	public static final int JSP_FIELD_NAME			=  2 ;

	public static String[] colNames = {
		"JSP_FIELD_DIAGNOSIS_ID",  "JSP_FIELD_CODE",
		"JSP_FIELD_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspDiagnosis(){
	}
	public JspDiagnosis(Diagnosis diagnosis){
		this.diagnosis = diagnosis;
	}

	public JspDiagnosis(HttpServletRequest request, Diagnosis diagnosis){
		super(new JspDiagnosis(diagnosis), request);
		this.diagnosis = diagnosis;
	}

	public String getFormName() { return JSP_NAME_DIAGNOSIS; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Diagnosis getEntityObject(){ return diagnosis; }

	public void requestEntityObject(Diagnosis diagnosis) {
		try{
			this.requestParam();
			diagnosis.setCode(getString(JSP_FIELD_CODE));
			diagnosis.setName(getString(JSP_FIELD_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
