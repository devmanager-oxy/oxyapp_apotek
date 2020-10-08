
package com.project.fms.activity;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspCoaActivityBudget extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private CoaActivityBudget coaActivityBudget;

	public static final String JSP_NAME_COAACTIVITYBUDGET		=  "JSP_NAME_COAACTIVITYBUDGET" ;

	public static final int JSP_TYPE			=  0 ;
	public static final int JSP_COA_ACTIVITY_BUDGET_ID			=  1 ;
	public static final int JSP_COA_ID			=  2 ;
	public static final int JSP_ADMIN_PERCENT			=  3 ;
	public static final int JSP_LOGISTIC_PERCENT			=  4 ;
	public static final int JSP_MEMO			=  5 ;
        
        public static final int JSP_COA_EXPENSE_CATEGORY_ID			=  6 ;
        public static final int JSP_COA_NATURE_EXPENSE_CATEGORY_ID			=  7 ;
        public static final int JSP_ACTIVITY_PERIOD_ID			=  8 ;

	public static String[] colNames = {
		"JSP_TYPE",  "JSP_COA_ACTIVITY_BUDGET_ID",
		"JSP_COA_ID",  "JSP_ADMIN_PERCENT",
		"JSP_LOGISTIC_PERCENT",  "JSP_MEMO",
                "JSP_COA_EXPENSE_CATEGORY_ID", "JSP_COA_NATURE_EXPENSE_CATEGORY_ID",
                "JSP_ACTIVITY_PERIOD_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_STRING,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_STRING,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG
	} ;

	public JspCoaActivityBudget(){
	}
	public JspCoaActivityBudget(CoaActivityBudget coaActivityBudget){
		this.coaActivityBudget = coaActivityBudget;
	}

	public JspCoaActivityBudget(HttpServletRequest request, CoaActivityBudget coaActivityBudget){
		super(new JspCoaActivityBudget(coaActivityBudget), request);
		this.coaActivityBudget = coaActivityBudget;
	}

	public String getFormName() { return JSP_NAME_COAACTIVITYBUDGET; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public CoaActivityBudget getEntityObject(){ return coaActivityBudget; }

	public void requestEntityObject(CoaActivityBudget coaActivityBudget) {
		try{
			this.requestParam();
			coaActivityBudget.setType(getInt(JSP_TYPE));
			coaActivityBudget.setCoaId(getLong(JSP_COA_ID));
			coaActivityBudget.setAdminPercent(getDouble(JSP_ADMIN_PERCENT));
			coaActivityBudget.setLogisticPercent(getDouble(JSP_LOGISTIC_PERCENT));
			coaActivityBudget.setMemo(getString(JSP_MEMO));
                        
                        coaActivityBudget.setCoaExpenseCategoryId(getLong(JSP_COA_EXPENSE_CATEGORY_ID));
                        coaActivityBudget.setCoaNatureExpenseCategoryId(getLong(JSP_COA_NATURE_EXPENSE_CATEGORY_ID));
                        coaActivityBudget.setActivityPeriodId(getLong(JSP_ACTIVITY_PERIOD_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
