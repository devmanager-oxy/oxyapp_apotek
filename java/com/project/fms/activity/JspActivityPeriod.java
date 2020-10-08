
package com.project.fms.activity;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.fms.activity.*;
import com.project.util.*;

public class JspActivityPeriod extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ActivityPeriod activityPeriod;

	public static final String JSP_NAME_ACTIVITYPERIOD		=  "activityperiod" ;

	public static final int JSP_ACTIVITY_PERIOD_ID			=  0 ;
	public static final int JSP_START_DATE			=  1 ;
	public static final int JSP_END_DATE			=  2 ;
	public static final int JSP_STATUS			=  3 ;
	public static final int JSP_NAME			=  4 ;

	public static String[] colNames = {
		"x_activity_period_id",  "x_start_date",
		"x_end_date",  "x_status",
		"x_name"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspActivityPeriod(){
	}
	public JspActivityPeriod(ActivityPeriod activityPeriod){
		this.activityPeriod = activityPeriod;
	}

	public JspActivityPeriod(HttpServletRequest request, ActivityPeriod activityPeriod){
		super(new JspActivityPeriod(activityPeriod), request);
		this.activityPeriod = activityPeriod;
	}

	public String getFormName() { return JSP_NAME_ACTIVITYPERIOD; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ActivityPeriod getEntityObject(){ return activityPeriod; }

	public void requestEntityObject(ActivityPeriod activityPeriod) {
		try{
			this.requestParam();
			activityPeriod.setStartDate(JSPFormater.formatDate(getString(JSP_START_DATE),"dd/MM/yyyy"));
			activityPeriod.setEndDate(JSPFormater.formatDate(getString(JSP_END_DATE),"dd/MM/yyyy"));
			//activityPeriod.setStatus(getString(JSP_STATUS));
			activityPeriod.setName(getString(JSP_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
