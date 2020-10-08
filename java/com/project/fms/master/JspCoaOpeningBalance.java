
package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspCoaOpeningBalance extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private CoaOpeningBalance coaOpeningBalance;

	public static final String JSP_NAME_COAOPENINGBALANCE		=  "JSP_NAME_COAOPENINGBALANCE" ;

	public static final int JSP_COA_OPENING_BALANCE_ID			=  0 ;
	public static final int JSP_COA_ID			=  1 ;
	public static final int JSP_PERIODE_ID			=  2 ;
	public static final int JSP_OPENING_BALANCE			=  3 ;

	public static String[] colNames = {
		"JSP_COA_OPENING_BALANCE_ID",  "JSP_COA_ID",
		"JSP_PERIODE_ID",  "JSP_OPENING_BALANCE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT
	} ;

	public JspCoaOpeningBalance(){
	}
	public JspCoaOpeningBalance(CoaOpeningBalance coaOpeningBalance){
		this.coaOpeningBalance = coaOpeningBalance;
	}

	public JspCoaOpeningBalance(HttpServletRequest request, CoaOpeningBalance coaOpeningBalance){
		super(new JspCoaOpeningBalance(coaOpeningBalance), request);
		this.coaOpeningBalance = coaOpeningBalance;
	}

	public String getFormName() { return JSP_NAME_COAOPENINGBALANCE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public CoaOpeningBalance getEntityObject(){ return coaOpeningBalance; }

	public void requestEntityObject(CoaOpeningBalance coaOpeningBalance) {
		try{
			this.requestParam();
			coaOpeningBalance.setCoaId(getLong(JSP_COA_ID));
			coaOpeningBalance.setPeriodeId(getLong(JSP_PERIODE_ID));
			coaOpeningBalance.setOpeningBalance(getDouble(JSP_OPENING_BALANCE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
