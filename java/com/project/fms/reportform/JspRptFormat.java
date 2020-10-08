package com.project.fms.reportform;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class JspRptFormat extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private RptFormat rptFormat;

	public static final String JSP_NAME_RPTFORMAT		=  "JSP_NAME_RPTFORMAT" ;

	public static final int JSP_RPT_FORMAT_ID		=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_CREATE_DATE			=  2 ;
	public static final int JSP_INACTIVE_DATE		=  3 ;
	public static final int JSP_STATUS			=  4 ;
	public static final int JSP_REPORT_SCOPE		=  5 ;
	public static final int JSP_REF_ID			=  6 ;
	public static final int JSP_CREATOR_ID			=  7 ;
	public static final int JSP_UPDATE_BY_ID		=  8 ;
	public static final int JSP_UPDATE_DATE			=  9 ;
	public static final int JSP_REPORT_TYPE			=  10 ;
        public static final int JSP_REPORT_TITLE		=  11 ;

	public static String[] colNames = {
		"JSP_RPT_FORMAT_ID",  "JSP_NAME",
		"JSP_CREATE_DATE",  "JSP_INACTIVE_DATE",
		"JSP_STATUS",  "JSP_REPORT_SCOPE",
		"JSP_REF_ID",  "JSP_CREATOR_ID",
		"JSP_UPDATE_BY_ID",  "JSP_UPDATE_DATE",
		"JSP_REPORT_TYPE","JSP_REPORT_TITLE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_DATE,  TYPE_DATE,
		TYPE_INT,  TYPE_INT,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_DATE,
		TYPE_INT,  TYPE_STRING
	} ;

	public JspRptFormat(){
	}
        
	public JspRptFormat(RptFormat rptFormat){
		this.rptFormat = rptFormat;
	}

	public JspRptFormat(HttpServletRequest request, RptFormat rptFormat){
		super(new JspRptFormat(rptFormat), request);
		this.rptFormat = rptFormat;
	}

	public String getFormName() { return JSP_NAME_RPTFORMAT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public RptFormat getEntityObject(){ return rptFormat; }

	public void requestEntityObject(RptFormat rptFormat) {
		try{
			this.requestParam();
			rptFormat.setName(getString(JSP_NAME));
			//rptFormat.setCreateDate(getDate(JSP_CREATE_DATE));
			//rptFormat.setInactiveDate(getDate(JSP_INACTIVE_DATE));
			rptFormat.setStatus(getInt(JSP_STATUS));
			rptFormat.setReportScope(getInt(JSP_REPORT_SCOPE));
			rptFormat.setRefId(getLong(JSP_REF_ID));
			//rptFormat.setCreatorId(getLong(JSP_CREATOR_ID));
			//rptFormat.setUpdateById(getLong(JSP_UPDATE_BY_ID));
			//rptFormat.setUpdateDate(getDate(JSP_UPDATE_DATE));
			rptFormat.setReportType(getInt(JSP_REPORT_TYPE));
                        rptFormat.setReportTitle(getString(JSP_REPORT_TITLE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
