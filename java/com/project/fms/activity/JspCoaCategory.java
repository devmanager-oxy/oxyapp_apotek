
package com.project.fms.activity;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspCoaCategory extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private CoaCategory coaCategory;

	public static final String JSP_NAME_EXPENSECATEGORY		=  "JSP_NAME_EXPENSECATEGORY" ;

	public static final int JSP_COA_CATEGORY_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
        public static final int JSP_TYPE			=  2 ;

	public static String[] colNames = {
		"JSP_COA_CATEGORY_ID",  "JSP_NAME", "JSP_TYPE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
                TYPE_INT
	} ;

	public JspCoaCategory(){
	}
	public JspCoaCategory(CoaCategory coaCategory){
		this.coaCategory = coaCategory;
	}

	public JspCoaCategory(HttpServletRequest request, CoaCategory coaCategory){
		super(new JspCoaCategory(coaCategory), request);
		this.coaCategory = coaCategory;
	}

	public String getFormName() { return JSP_NAME_EXPENSECATEGORY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public CoaCategory getEntityObject(){ return coaCategory; }

	public void requestEntityObject(CoaCategory coaCategory) {
		try{
			this.requestParam();
			coaCategory.setName(getString(JSP_NAME));
                        coaCategory.setType(getInt(JSP_TYPE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
