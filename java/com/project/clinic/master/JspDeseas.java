package com.project.clinic.master;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspDeseas extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Deseas deseas;

	public static final String JSP_NAME_DESEAS		=  "JSP_NAME_DESEAS" ;

	public static final int JSP_FIELD_DESEASE_ID			=  0 ;
	public static final int JSP_FIELD_NAME			=  1 ;

	public static String[] colNames = {
		"JSP_FIELD_DESEASE_ID",  "JSP_FIELD_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspDeseas(){
	}
	public JspDeseas(Deseas deseas){
		this.deseas = deseas;
	}

	public JspDeseas(HttpServletRequest request, Deseas deseas){
		super(new JspDeseas(deseas), request);
		this.deseas = deseas;
	}

	public String getFormName() { return JSP_NAME_DESEAS; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Deseas getEntityObject(){ return deseas; }

	public void requestEntityObject(Deseas deseas) {
		try{
			this.requestParam();
			deseas.setName(getString(JSP_FIELD_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
