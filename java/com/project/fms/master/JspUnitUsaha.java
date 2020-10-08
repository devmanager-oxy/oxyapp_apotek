package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspUnitUsaha extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private UnitUsaha unitUsaha;

	public static final String JSP_NAME_UNITUSAHA		=  "JSP_NAME_UNITUSAHA" ;

	public static final int JSP_UNIT_USAHA_ID			=  0 ;
	public static final int JSP_CODE			=  1 ;
	public static final int JSP_NAME			=  2 ;
	public static final int JSP_COA_AR_ID			=  3 ;
	public static final int JSP_COA_AP_ID			=  4 ;
	public static final int JSP_COA_PPN_ID			=  5 ;
	public static final int JSP_COA_PPH_ID			=  6 ;
	public static final int JSP_COA_DISCOUNT_ID			=  7 ;
	public static final int JSP_LOCATION_ID			=  8 ;

	public static String[] colNames = {
		"JSP_UNIT_USAHA_ID",  "JSP_CODE",
		"JSP_NAME",  "JSP_COA_AR_ID",
		"JSP_COA_AP_ID",  "JSP_COA_PPN_ID",
		"JSP_COA_PPH_ID",  "JSP_COA_DISCOUNT_ID",
		"JSP_LOCATION_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG
	} ;

	public JspUnitUsaha(){
	}
	public JspUnitUsaha(UnitUsaha unitUsaha){
		this.unitUsaha = unitUsaha;
	}

	public JspUnitUsaha(HttpServletRequest request, UnitUsaha unitUsaha){
		super(new JspUnitUsaha(unitUsaha), request);
		this.unitUsaha = unitUsaha;
	}

	public String getFormName() { return JSP_NAME_UNITUSAHA; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public UnitUsaha getEntityObject(){ return unitUsaha; }

	public void requestEntityObject(UnitUsaha unitUsaha) {
		try{
			this.requestParam();
			unitUsaha.setCode(getString(JSP_CODE));
			unitUsaha.setName(getString(JSP_NAME));
			unitUsaha.setCoaArId(getLong(JSP_COA_AR_ID));
			unitUsaha.setCoaApId(getLong(JSP_COA_AP_ID));
			unitUsaha.setCoaPpnId(getLong(JSP_COA_PPN_ID));
			unitUsaha.setCoaPphId(getLong(JSP_COA_PPH_ID));
			unitUsaha.setCoaDiscountId(getLong(JSP_COA_DISCOUNT_ID));
			unitUsaha.setLocationId(getLong(JSP_LOCATION_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
