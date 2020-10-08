
package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class JspTermOfPayment extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private TermOfPayment termOfPayment;

	public static final String JSP_NAME_TERMOFPAYMENT		=  "JSP_NAME_TERMOFPAYMENT" ;

	public static final int JSP_TERM_OF_PAYMENT_ID			=  0 ;
	public static final int JSP_DESCRIPTION			=  1 ;
	public static final int JSP_DUE			=  2 ;
	public static final int JSP_QTY_DISC			=  3 ;
	public static final int JSP_DISC_PERCENT			=  4 ;

	public static String[] colNames = {
		"JSP_TERM_OF_PAYMENT_ID",  "JSP_DESCRIPTION",
		"JSP_DUE",  "JSP_QTY_DISC",
		"JSP_DISC_PERCENT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_INT,  TYPE_INT,
		TYPE_INT
	} ;

	public JspTermOfPayment(){
	}
	public JspTermOfPayment(TermOfPayment termOfPayment){
		this.termOfPayment = termOfPayment;
	}

	public JspTermOfPayment(HttpServletRequest request, TermOfPayment termOfPayment){
		super(new JspTermOfPayment(termOfPayment), request);
		this.termOfPayment = termOfPayment;
	}

	public String getFormName() { return JSP_NAME_TERMOFPAYMENT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public TermOfPayment getEntityObject(){ return termOfPayment; }

	public void requestEntityObject(TermOfPayment termOfPayment) {
		try{
			this.requestParam();
			termOfPayment.setDescription(getString(JSP_DESCRIPTION));
			termOfPayment.setDue(getInt(JSP_DUE));
			termOfPayment.setQtyDisc(getInt(JSP_QTY_DISC));
			termOfPayment.setDiscPercent(getInt(JSP_DISC_PERCENT));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
