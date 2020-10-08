
package com.project.fms.activity;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspCoaGroupAlias extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private CoaGroupAlias coaGroupAlias;

	public static final String JSP_NAME_COANATUREEXPENSECATEGORY		=  "JSP_NAME_COANATUREEXPENSECATEGORY" ;

	public static final int JSP_COA_GROUP_ALIAS_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;

	public static String[] colNames = {
		"JSP_COA_GROUP_ALIAS_ID",  "JSP_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspCoaGroupAlias(){
	}
	public JspCoaGroupAlias(CoaGroupAlias coaGroupAlias){
		this.coaGroupAlias = coaGroupAlias;
	}

	public JspCoaGroupAlias(HttpServletRequest request, CoaGroupAlias coaGroupAlias){
		super(new JspCoaGroupAlias(coaGroupAlias), request);
		this.coaGroupAlias = coaGroupAlias;
	}

	public String getFormName() { return JSP_NAME_COANATUREEXPENSECATEGORY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public CoaGroupAlias getEntityObject(){ return coaGroupAlias; }

	public void requestEntityObject(CoaGroupAlias coaGroupAlias) {
		try{
			this.requestParam();
			coaGroupAlias.setName(getString(JSP_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
