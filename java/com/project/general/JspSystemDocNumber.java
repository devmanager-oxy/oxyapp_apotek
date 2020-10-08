package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspSystemDocNumber extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SystemDocNumber systemDocNumber;

	public static final String JSP_NAME_SYSTEMDOCNUMBER		=  "JSP_NAME_SYSTEMDOCNUMBER" ;

	public static final int JSP_SYSTEM_DOC_NUMBER_ID			=  0 ;
	public static final int JSP_TYPE			=  1 ;
	public static final int JSP_COUNTER			=  2 ;
	public static final int JSP_PREFIX_NUMBER			=  3 ;
	public static final int JSP_YEAR			=  4 ;
	public static final int JSP_DATE			=  5 ;
	public static final int JSP_USER_ID			=  6 ;
	public static final int JSP_DOC_NUMBER			=  7 ;

	public static String[] colNames = {
		"JSP_SYSTEM_DOC_NUMBER_ID",  "JSP_TYPE",
		"JSP_COUNTER",  "JSP_PREFIX_NUMBER",
		"JSP_YEAR",  "JSP_DATE",
		"JSP_USER_ID",  "JSP_DOC_NUMBER"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_INT,  TYPE_STRING,
		TYPE_INT,  TYPE_DATE,
		TYPE_LONG,  TYPE_STRING
	} ;

	public JspSystemDocNumber(){
	}
	public JspSystemDocNumber(SystemDocNumber systemDocNumber){
		this.systemDocNumber = systemDocNumber;
	}

	public JspSystemDocNumber(HttpServletRequest request, SystemDocNumber systemDocNumber){
		super(new JspSystemDocNumber(systemDocNumber), request);
		this.systemDocNumber = systemDocNumber;
	}

	public String getFormName() { return JSP_NAME_SYSTEMDOCNUMBER; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SystemDocNumber getEntityObject(){ return systemDocNumber; }

	public void requestEntityObject(SystemDocNumber systemDocNumber) {
		try{
			this.requestParam();
			systemDocNumber.setType(getString(JSP_TYPE));
			systemDocNumber.setCounter(getInt(JSP_COUNTER));
			systemDocNumber.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
			systemDocNumber.setYear(getInt(JSP_YEAR));
			systemDocNumber.setDate(getDate(JSP_DATE));
			systemDocNumber.setUserId(getLong(JSP_USER_ID));
			systemDocNumber.setDocNumber(getString(JSP_DOC_NUMBER));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
