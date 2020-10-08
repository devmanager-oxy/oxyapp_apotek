
package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class JspAccLink extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private AccLink accLink;

	public static final String JSP_NAME_ACCLINK		=  "acclink" ;

	public static final int JSP_ACC_LINK_ID			=  0 ;
	public static final int JSP_COA_ID			=  1 ;
	public static final int JSP_DEPARTMENT_ID			=  2 ;
	public static final int JSP_TYPE			=  3 ;
	public static final int JSP_COA_NAME			=  4 ;
	public static final int JSP_COA_CODE			=  5 ;
	public static final int JSP_DEPARTMENT_NAME			=  6 ;
	public static final int JSP_USER_ID			=  7 ;
        public static final int JSP_LOCATION_ID			=  8 ;

	public static String[] colNames = {
		"x_acc_link_id",  "x_coa_id",
		"x_department_id",  "x_type",
		"x_coa_name",  "x_coa_code",
		"x_department_name",  "x_user_id",
                "x_location_id"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
                TYPE_LONG
	} ;

	public JspAccLink(){
	}
	public JspAccLink(AccLink accLink){
		this.accLink = accLink;
	}

	public JspAccLink(HttpServletRequest request, AccLink accLink){
		super(new JspAccLink(accLink), request);
		this.accLink = accLink;
	}

	public String getFormName() { return JSP_NAME_ACCLINK; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public AccLink getEntityObject(){ return accLink; }

	public void requestEntityObject(AccLink accLink) {
		try{
			this.requestParam();
			accLink.setCoaId(getLong(JSP_COA_ID));
			accLink.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
			accLink.setType(getString(JSP_TYPE));
			accLink.setCoaName(getString(JSP_COA_NAME));
			accLink.setCoaCode(getString(JSP_COA_CODE));
			accLink.setDepartmentName(getString(JSP_DEPARTMENT_NAME));
			accLink.setUserId(getLong(JSP_USER_ID));
                        accLink.setLocationId(getLong(JSP_LOCATION_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}

