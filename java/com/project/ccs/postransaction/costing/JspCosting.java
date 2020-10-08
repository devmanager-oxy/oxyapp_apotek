
package com.project.ccs.postransaction.costing;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.util.JSPFormater;

public class JspCosting extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Costing costing;

	public static final String JSP_NAME_COSTING		=  "JSP_NAME_COSTING" ;

	public static final int JSP_COSTING_ID			=  0 ;
	public static final int JSP_DATE			=  1 ;
	public static final int JSP_COUNTER			=  2 ;
	public static final int JSP_NUMBER			=  3 ;
	public static final int JSP_NOTE			=  4 ;
	public static final int JSP_APPROVAL_1			=  5 ;
	public static final int JSP_APPROVAL_2			=  6 ;
	public static final int JSP_APPROVAL_3			=  7 ;
	public static final int JSP_STATUS			=  8 ;
	public static final int JSP_LOCATION_ID			=  9 ;
	public static final int JSP_USER_ID			=  10;
        public static final int JSP_PREFIX_NUMBER		=  11;
        public static final int JSP_POSTED_STATUS               =  12;
        public static final int JSP_POSTED_BY_ID                =  13;
        public static final int JSP_POSTED_DATE                 =  14;
        public static final int JSP_EFFECTIVE_DATE              =  15;
        public static final int JSP_LOCATION_POST_ID            =  16 ;

	public static String[] colNames = {
		"JSP_COSTING_ID",  "JSP_DATE",
		"JSP_COUNTER",  "JSP_NUMBER",
		"JSP_NOTE",  "JSP_APPROVAL_1",
		"JSP_APPROVAL_2",  "JSP_APPROVAL_3",
		"JSP_STATUS",  "JSP_LOCATION_ID",
		"JSP_USER_ID", "JSP_PREFIX_NUMBER",
                "JSP_POSTED_STATUS","JSP_POSTED_BY_ID",
                "JSP_POSTED_DATE", "JSP_EFFECTIVE_DATE",
                "JSP_LOCATION_POST_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_INT,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_LONG,
		TYPE_LONG, TYPE_INT,
                TYPE_INT, TYPE_LONG,
                TYPE_DATE, TYPE_DATE,
                TYPE_LONG
	} ;

	public JspCosting(){
	}
	public JspCosting(Costing costing){
		this.costing = costing;
	}

	public JspCosting(HttpServletRequest request, Costing costing){
		super(new JspCosting(costing), request);
		this.costing = costing;
	}

	public String getFormName() { return JSP_NAME_COSTING; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Costing getEntityObject(){ return costing; }

	public void requestEntityObject(Costing costing) {
		try{
			this.requestParam();
                        Date newDate = new Date();
                        newDate = JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy");
                        newDate.setHours(new Date().getHours());
                        newDate.setMinutes(new Date().getMinutes());
                        newDate.setSeconds(new Date().getSeconds());
			costing.setDate(newDate);                        
			costing.setNote(getString(JSP_NOTE));
			costing.setStatus(getString(JSP_STATUS));
			costing.setLocationId(getLong(JSP_LOCATION_ID));
			costing.setUserId(getLong(JSP_USER_ID));   
                        costing.setLocationPostId(getLong(JSP_LOCATION_POST_ID));		
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
