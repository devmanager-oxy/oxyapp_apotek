package com.project.clinic.master;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspSpecialty extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Specialty specialty;

	public static final String JSP_NAME_SPECIALTY		=  "JSP_NAME_SPECIALTY" ;

	public static final int JSP_FIELD_SPECIALTY_ID			=  0 ;
	public static final int JSP_FIELD_NAME			=  1 ;

	public static String[] colNames = {
		"JSP_FIELD_SPECIALTY_ID",  "JSP_FIELD_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspSpecialty(){
	}
	public JspSpecialty(Specialty specialty){
		this.specialty = specialty;
	}

	public JspSpecialty(HttpServletRequest request, Specialty specialty){
		super(new JspSpecialty(specialty), request);
		this.specialty = specialty;
	}

	public String getFormName() { return JSP_NAME_SPECIALTY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Specialty getEntityObject(){ return specialty; }

	public void requestEntityObject(Specialty specialty) {
		try{
			this.requestParam();
			specialty.setName(getString(JSP_FIELD_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
