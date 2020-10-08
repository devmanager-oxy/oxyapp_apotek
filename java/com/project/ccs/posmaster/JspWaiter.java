
package com.project.ccs.posmaster;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.ccs.posmaster.*;

public class JspWaiter extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Waiter waiter;

	public static final String JSP_NAME_WAITER		=  "JSP_NAME_WAITER" ;

	public static final int JSP_WAITRES_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_CODE			=  2 ;
	public static final int JSP_LOGIN_ID			=  3 ;
	public static final int JSP_PASSWORD			=  4 ;
	public static final int JSP_STATUS			=  5 ;
	public static final int JSP_LEVEL			=  6 ;
        public static final int JSP_CONFIRM_PASSWORD			=  7 ;
        public static final int JSP_LOCATION_ID			=  8 ;

	public static String[] colNames = {
		"JSP_WAITRES_ID",  "JSP_NAME",
		"JSP_CODE",  "JSP_LOGIN_ID",
		"JSP_PASSWORD",  "JSP_STATUS",
		"JSP_LEVEL", "JSP_CONFIRM_PASSWORD",
                "JSP_LOCATION_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_INT, TYPE_STRING + ENTRY_REQUIRED,
                TYPE_LONG + ENTRY_REQUIRED
	} ;

	public JspWaiter(){
	}
	public JspWaiter(Waiter waiter){
		this.waiter = waiter;
	}

	public JspWaiter(HttpServletRequest request, Waiter waiter){
		super(new JspWaiter(waiter), request);
		this.waiter = waiter;
	}

	public String getFormName() { return JSP_NAME_WAITER; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Waiter getEntityObject(){ return waiter; }

	public void requestEntityObject(Waiter waiter) {
		try{
			this.requestParam();
			waiter.setName(getString(JSP_NAME));
			waiter.setCode(getString(JSP_CODE));
			waiter.setLoginId(getString(JSP_LOGIN_ID));
			waiter.setPassword(getString(JSP_PASSWORD));
			waiter.setStatus(getString(JSP_STATUS));
			waiter.setLevel(getInt(JSP_LEVEL));
                        waiter.setConfirmPwd(getString(JSP_CONFIRM_PASSWORD));
                        waiter.setLocationId(getLong(JSP_LOCATION_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
