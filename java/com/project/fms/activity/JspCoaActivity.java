
package com.project.fms.activity;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspCoaActivity extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private CoaActivity coaActivity;

	public static final String JSP_NAME_COAACTIVITY		=  "coaactivity" ;

	public static final int JSP_COA_ACTIVITY_ID			=  0 ;
	public static final int JSP_COA_ID			=  1 ;
	public static final int JSP_MODULE_ID			=  2 ;
        public static final int JSP_DEPARTMENT_ID			=  3 ;
        public static final int JSP_SECTION_ID			=  4 ;

	public static String[] colNames = {
		"x_coa_activity_id",  "x_coa_id",
		"x_module_id", "depid",
                "secid"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED, TYPE_LONG + ENTRY_REQUIRED,
                TYPE_LONG
	} ;

	public JspCoaActivity(){
	}
	public JspCoaActivity(CoaActivity coaActivity){
		this.coaActivity = coaActivity;
	}

	public JspCoaActivity(HttpServletRequest request, CoaActivity coaActivity){
		super(new JspCoaActivity(coaActivity), request);
		this.coaActivity = coaActivity;
	}

	public String getFormName() { return JSP_NAME_COAACTIVITY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public CoaActivity getEntityObject(){ return coaActivity; }

	public void requestEntityObject(CoaActivity coaActivity) {
		try{
			this.requestParam();
			coaActivity.setCoaId(getLong(JSP_COA_ID));
			coaActivity.setModuleId(getLong(JSP_MODULE_ID));
                        coaActivity.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
                        coaActivity.setSectionId(getLong(JSP_SECTION_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
