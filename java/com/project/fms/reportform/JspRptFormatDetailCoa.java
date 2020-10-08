package com.project.fms.reportform;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class JspRptFormatDetailCoa extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private RptFormatDetailCoa rptFormatDetailCoa;

	public static final String JSP_NAME_RPTFORMATDETAILCOA		=  "JSP_NAME_RPTFORMATDETAILCOA" ;

	public static final int JSP_RPT_FORMAT_DETAIL_COA_ID			=  0 ;
	public static final int JSP_RPT_FORMAT_DETAIL_ID			=  1 ;
	public static final int JSP_COA_ID							=  2 ;
	public static final int JSP_IS_MINUS							=  3 ;
	public static final int JSP_DEP_ID							=  4 ;

	public static String[] colNames = {
		"JSP_RPT_FORMAT_DETAIL_COA_ID",  "JSP_RPT_FORMAT_DETAIL_ID",
		"JSP_COA_ID", "JSP_IS_MINUS",
		"JSP_DEP_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED, TYPE_INT,
		TYPE_LONG		
	} ;

	public JspRptFormatDetailCoa(){
	}
	public JspRptFormatDetailCoa(RptFormatDetailCoa rptFormatDetailCoa){
		this.rptFormatDetailCoa = rptFormatDetailCoa;
	}

	public JspRptFormatDetailCoa(HttpServletRequest request, RptFormatDetailCoa rptFormatDetailCoa){
		super(new JspRptFormatDetailCoa(rptFormatDetailCoa), request);
		this.rptFormatDetailCoa = rptFormatDetailCoa;
	}

	public String getFormName() { return JSP_NAME_RPTFORMATDETAILCOA; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public RptFormatDetailCoa getEntityObject(){ return rptFormatDetailCoa; }

	public void requestEntityObject(RptFormatDetailCoa rptFormatDetailCoa) {
		try{
			this.requestParam();
			rptFormatDetailCoa.setRptFormatDetailId(getLong(JSP_RPT_FORMAT_DETAIL_ID));
			rptFormatDetailCoa.setCoaId(getLong(JSP_COA_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
