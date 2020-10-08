package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspCoaPortofolioSetup extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private CoaPortofolioSetup coaPortofolioSetup;

	public static final String JSP_NAME_COAPORTOFOLIOSETUP		=  "JSP_NAME_COAPORTOFOLIOSETUP" ;

	public static final int JSP_PORTOFOLIO_SETUP_ID			=  0 ;
	public static final int JSP_NOTE			=  1 ;
	public static final int JSP_PERIODE_ID			=  2 ;
	public static final int JSP_COA_REVENUE_ID			=  3 ;
	public static final int JSP_COA_EXPENSE_ID			=  4 ;
	public static final int JSP_LEVEL			=  5 ;
	public static final int JSP_COA_REF_ID			=  6 ;
	public static final int JSP_STATUS			=  7 ;
	public static final int JSP_COA_STATUS			=  8 ;
        public static final int JSP_TYPE			=  9 ;

	public static String[] colNames = {
		"JSP_PORTOFOLIO_SETUP_ID",  "JSP_NOTE",
		"JSP_PERIODE_ID",  "JSP_COA_REVENUE_ID",
		"JSP_COA_EXPENSE_ID",  "JSP_LEVEL",
		"JSP_COA_REF_ID",  "JSP_STATUS",
		"JSP_COA_STATUS", "JSP_TYPE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG,
		TYPE_LONG,  TYPE_INT,
		TYPE_LONG,  TYPE_INT,
		TYPE_STRING, TYPE_INT
	} ;

	public JspCoaPortofolioSetup(){
	}
	public JspCoaPortofolioSetup(CoaPortofolioSetup coaPortofolioSetup){
		this.coaPortofolioSetup = coaPortofolioSetup;
	}

	public JspCoaPortofolioSetup(HttpServletRequest request, CoaPortofolioSetup coaPortofolioSetup){
		super(new JspCoaPortofolioSetup(coaPortofolioSetup), request);
		this.coaPortofolioSetup = coaPortofolioSetup;
	}

	public String getFormName() { return JSP_NAME_COAPORTOFOLIOSETUP; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public CoaPortofolioSetup getEntityObject(){ return coaPortofolioSetup; }

	public void requestEntityObject(CoaPortofolioSetup coaPortofolioSetup) {
		try{
			this.requestParam();
			coaPortofolioSetup.setNote(getString(JSP_NOTE));
			coaPortofolioSetup.setPeriodeId(getLong(JSP_PERIODE_ID));
			coaPortofolioSetup.setCoaRevenueId(getLong(JSP_COA_REVENUE_ID));
			coaPortofolioSetup.setCoaExpenseId(getLong(JSP_COA_EXPENSE_ID));
			coaPortofolioSetup.setLevel(getInt(JSP_LEVEL));
			coaPortofolioSetup.setCoaRefId(getLong(JSP_COA_REF_ID));
			coaPortofolioSetup.setStatus(getInt(JSP_STATUS));
			coaPortofolioSetup.setCoaStatus(getString(JSP_COA_STATUS));
                        coaPortofolioSetup.setType(getInt(JSP_TYPE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
