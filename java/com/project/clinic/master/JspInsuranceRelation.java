package com.project.clinic.master;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspInsuranceRelation extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private InsuranceRelation insuranceRelation;

	public static final String JSP_NAME_INSURANCERELATION		=  "JSP_NAME_INSURANCERELATION" ;

	public static final int JSP_FIELD_INSURANCE_RELATION_ID			=  0 ;
	public static final int JSP_FIELD_NAME			=  1 ;

	public static String[] colNames = {
		"JSP_FIELD_INSURANCE_RELATION_ID",  "JSP_FIELD_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspInsuranceRelation(){
	}
	public JspInsuranceRelation(InsuranceRelation insuranceRelation){
		this.insuranceRelation = insuranceRelation;
	}

	public JspInsuranceRelation(HttpServletRequest request, InsuranceRelation insuranceRelation){
		super(new JspInsuranceRelation(insuranceRelation), request);
		this.insuranceRelation = insuranceRelation;
	}

	public String getFormName() { return JSP_NAME_INSURANCERELATION; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public InsuranceRelation getEntityObject(){ return insuranceRelation; }

	public void requestEntityObject(InsuranceRelation insuranceRelation) {
		try{
			this.requestParam();
			insuranceRelation.setName(getString(JSP_FIELD_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
