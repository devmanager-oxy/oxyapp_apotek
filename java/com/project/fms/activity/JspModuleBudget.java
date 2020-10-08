package com.project.fms.activity;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspModuleBudget extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ModuleBudget moduleBudget;

	public static final String JSP_NAME_MODULEBUDGET	=  "JSP_NAME_MODULEBUDGET" ;

	public static final int JSP_MODULE_BUDGET_ID		=  0 ;
	public static final int JSP_COA_ID			=  1 ;
	public static final int JSP_DESCRIPTION			=  2 ;
	public static final int JSP_AMOUNT			=  3 ;
	public static final int JSP_CURRENCY_ID			=  4 ;
	public static final int JSP_MODULE_ID			=  5 ;
        public static final int JSP_STATUS			=  6 ;
        public static final int JSP_REF_HISTORY_ID              =  7 ;
        public static final int JSP_USER_UPDATE_ID              =  8 ;        

	public static String[] colNames = {
		"JSP_MODULE_BUDGET_ID",  "JSP_COA_ID",
		"JSP_DESCRIPTION",  "JSP_AMOUNT",
		"JSP_CURRENCY_ID",  "JSP_MODULE_ID",
                "JSP_STATUS","JSP_REF_HISTORY_ID",
                "JSP_USER_UPDATE_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_FLOAT,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG + ENTRY_REQUIRED,
                TYPE_INT, TYPE_LONG,
                TYPE_LONG
	} ;

	public JspModuleBudget(){
	}
	public JspModuleBudget(ModuleBudget moduleBudget){
		this.moduleBudget = moduleBudget;
	}

	public JspModuleBudget(HttpServletRequest request, ModuleBudget moduleBudget){
		super(new JspModuleBudget(moduleBudget), request);
		this.moduleBudget = moduleBudget;
	}

	public String getFormName() { return JSP_NAME_MODULEBUDGET; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ModuleBudget getEntityObject(){ return moduleBudget; }

	public void requestEntityObject(ModuleBudget moduleBudget) {
		try{
			this.requestParam();
			moduleBudget.setCoaId(getLong(JSP_COA_ID));
			moduleBudget.setDescription(getString(JSP_DESCRIPTION));
			moduleBudget.setAmount(getDouble(JSP_AMOUNT));
			moduleBudget.setCurrencyId(getLong(JSP_CURRENCY_ID));
			moduleBudget.setModuleId(getLong(JSP_MODULE_ID));
                        moduleBudget.setStatus(getInt(JSP_STATUS));
                        moduleBudget.setRefHistoryId(getLong(JSP_REF_HISTORY_ID));
                        moduleBudget.setUserUpdateId(getLong(JSP_USER_UPDATE_ID ));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
