package com.project.clinic.master;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspInsurance extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Insurance insurance;

	public static final String JSP_NAME_INSURANCE		=  "JSP_NAME_INSURANCE" ;

	public static final int JSP_FIELD_INSURANCE_ID			=  0 ;
	public static final int JSP_FIELD_NAME			=  1 ;
	public static final int JSP_FIELD_CODE			=  2 ;
        public static final int JSP_FIELD_PRICE_GROUP			=  3 ;
        

	public static String[] colNames = {
		"JSP_FIELD_INSURANCE_ID",  "JSP_FIELD_NAME",
		"JSP_FIELD_CODE", "JSP_FIELD_PRICE_GROUP"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED, TYPE_STRING
	} ;

	public JspInsurance(){
	}
	public JspInsurance(Insurance insurance){
		this.insurance = insurance;
	}

	public JspInsurance(HttpServletRequest request, Insurance insurance){
		super(new JspInsurance(insurance), request);
		this.insurance = insurance;
	}

	public String getFormName() { return JSP_NAME_INSURANCE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Insurance getEntityObject(){ return insurance; }

	public void requestEntityObject(Insurance insurance) {
		try{
			this.requestParam();
			insurance.setName(getString(JSP_FIELD_NAME));
			insurance.setCode(getString(JSP_FIELD_CODE));
                        insurance.setPriceGroup(getString(JSP_FIELD_PRICE_GROUP));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
