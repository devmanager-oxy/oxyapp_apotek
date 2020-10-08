
package com.project.fms.activity;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspCoaActivityBudgetDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private CoaActivityBudgetDetail coaActivityBudgetDetail;

	public static final String JSP_NAME_COAACTIVITYBUDGETDETAIL		=  "JSP_NAME_COAACTIVITYBUDGETDETAIL" ;

	public static final int JSP_COA_ACTIVITY_BUDGET_ID			=  0 ;
	public static final int JSP_COA_ACTIVITY_BUDGET_DETAIL_ID			=  1 ;
	public static final int JSP_PERCENT			=  2 ;
	public static final int JSP_MODULE_ID			=  3 ;

	public static String[] colNames = {
		"JSP_COA_ACTIVITY_BUDGET_ID",  "JSP_COA_ACTIVITY_BUDGET_DETAIL_ID",
		"JSP_PERCENT",  "JSP_MODULE_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_FLOAT,  TYPE_LONG
	} ;

	public JspCoaActivityBudgetDetail(){
	}
	public JspCoaActivityBudgetDetail(CoaActivityBudgetDetail coaActivityBudgetDetail){
		this.coaActivityBudgetDetail = coaActivityBudgetDetail;
	}

	public JspCoaActivityBudgetDetail(HttpServletRequest request, CoaActivityBudgetDetail coaActivityBudgetDetail){
		super(new JspCoaActivityBudgetDetail(coaActivityBudgetDetail), request);
		this.coaActivityBudgetDetail = coaActivityBudgetDetail;
	}

	public String getFormName() { return JSP_NAME_COAACTIVITYBUDGETDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public CoaActivityBudgetDetail getEntityObject(){ return coaActivityBudgetDetail; }

	public void requestEntityObject(CoaActivityBudgetDetail coaActivityBudgetDetail) {
		try{
			this.requestParam();
			coaActivityBudgetDetail.setCoaActivityBudgetId(getLong(JSP_COA_ACTIVITY_BUDGET_ID));
			coaActivityBudgetDetail.setPercent(getDouble(JSP_PERCENT));
			coaActivityBudgetDetail.setModuleId(getLong(JSP_MODULE_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
