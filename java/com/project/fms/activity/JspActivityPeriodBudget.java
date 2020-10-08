
package com.project.fms.activity;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspActivityPeriodBudget extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ActivityPeriodBudget donorActivityPeriod;

	public static final String JSP_NAME_DONORACTIVITYPERIOD		=  "donoractivityperiod" ;

	public static final int JSP_DONOR_ACTIVITY_PERIOD_ID			=  0 ;
	public static final int JSP_ACTIVITY_PERIOD_ID			=  1 ;
	public static final int JSP_BUDGET			=  2 ;
	public static final int JSP_MODULE_ID			=  3 ;

	public static String[] colNames = {
		"x_donor_activity_period_id",  
                "x_activity_period_id",
		"x_budget",
		"x_module_id"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  
                TYPE_LONG + ENTRY_REQUIRED,
		TYPE_FLOAT + ENTRY_REQUIRED,		
                TYPE_LONG + ENTRY_REQUIRED
	} ;

	public JspActivityPeriodBudget(){
	}
	public JspActivityPeriodBudget(ActivityPeriodBudget donorActivityPeriod){
		this.donorActivityPeriod = donorActivityPeriod;
	}

	public JspActivityPeriodBudget(HttpServletRequest request, ActivityPeriodBudget donorActivityPeriod){
		super(new JspActivityPeriodBudget(donorActivityPeriod), request);
		this.donorActivityPeriod = donorActivityPeriod;
	}

	public String getFormName() { return JSP_NAME_DONORACTIVITYPERIOD; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ActivityPeriodBudget getEntityObject(){ return donorActivityPeriod; }

	public void requestEntityObject(ActivityPeriodBudget donorActivityPeriod) {
		try{
			this.requestParam();
			donorActivityPeriod.setActivityPeriodId(getLong(JSP_ACTIVITY_PERIOD_ID));
			donorActivityPeriod.setBudget(getDouble(JSP_BUDGET));
			donorActivityPeriod.setModuleId(getLong(JSP_MODULE_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
