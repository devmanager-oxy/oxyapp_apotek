package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspTelpCharge extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private TelpCharge telpCharge;

	public static final String JSP_NAME_TELPCHARGE		=  "telpcharge" ;

	public static final int JSP_TELP_CHARGE_ID			=  0 ;
	public static final int JSP_USER_ID			=  1 ;
	public static final int JSP_CALL_TYPE			=  2 ;
	public static final int JSP_AREA_NAME			=  3 ;
	public static final int JSP_PREFIX_NUMBER			=  4 ;
	public static final int JSP_UNIT_CALL			=  5 ;
	public static final int JSP_CHARGE			=  6 ;

	public static String[] fieldNames = {
		"x_telp_charge",  "x_user_id",
		"x_call_type",  "x_area_name",
		"x_prefix_number",  "x_unit_call",
		"x_charge"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_INT,
		TYPE_FLOAT
	} ;

	public JspTelpCharge(){
	}
	public JspTelpCharge(TelpCharge telpCharge){
		this.telpCharge = telpCharge;
	}

	public JspTelpCharge(HttpServletRequest request, TelpCharge telpCharge){
		super(new JspTelpCharge(telpCharge), request);
		this.telpCharge = telpCharge;
	}

	public String getFormName() { return JSP_NAME_TELPCHARGE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public TelpCharge getEntityObject(){ return telpCharge; }

	public void requestEntityObject(TelpCharge telpCharge) {
		try{
			this.requestParam();
			telpCharge.setUserId(getLong(JSP_USER_ID));
			telpCharge.setCallType(getString(JSP_CALL_TYPE));
			telpCharge.setAreaName(getString(JSP_AREA_NAME));
			telpCharge.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
			telpCharge.setUnitCall(getInt(JSP_UNIT_CALL));
			telpCharge.setCharge(getDouble(JSP_CHARGE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
