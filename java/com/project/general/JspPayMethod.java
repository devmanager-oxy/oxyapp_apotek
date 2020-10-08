

package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;


public class JspPayMethod extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PayMethod payMethod;

	public static final String JSP_NAME_PAYMETHOD		=  "paymethod" ;

	public static final int JSP_PAY_METHOD			=  0 ;
	public static final int JSP_DESCRIPTION			=  1 ;
	public static final int JSP_PAY_METHOD_ID			=  2 ;

	public static String[] colNames = {
		"paymet",  "descrip",
		"paymet_id"
	} ;

	public static int[] fieldTypes = {
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_LONG
	} ;

	public JspPayMethod(){
	}
	public JspPayMethod(PayMethod payMethod){
		this.payMethod = payMethod;
	}

	public JspPayMethod(HttpServletRequest request, PayMethod payMethod){
		super(new JspPayMethod(payMethod), request);
		this.payMethod = payMethod;
	}

	public String getFormName() { return JSP_NAME_PAYMETHOD; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PayMethod getEntityObject(){ return payMethod; }

	public void requestEntityObject(PayMethod payMethod) {
		try{
			this.requestParam();
			payMethod.setPayMethod(getString(JSP_PAY_METHOD));
			payMethod.setDescription(getString(JSP_DESCRIPTION));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
