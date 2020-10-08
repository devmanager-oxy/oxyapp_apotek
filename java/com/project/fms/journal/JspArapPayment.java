
package com.project.fms.journal;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.fms.journal.*;
import com.project.*;
import com.project.util.*;
import com.project.util.jsp.*;

public class JspArapPayment extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ArapPayment arapPayment;

	public static final String JSP_NAME_ARAPPAYMENT		=  "JSP_NAME_ARAPPAYMENT" ;

	public static final int JSP_ARAP_PAYMENT_ID			=  0 ;
	public static final int JSP_AP_ID			=  1 ;
	public static final int JSP_PERIODE_ID			=  2 ;
	public static final int JSP_DATE			=  3 ;
	public static final int JSP_PAID_BY			=  4 ;
	public static final int JSP_REC_BY			=  5 ;
	public static final int JSP_PAY_METHOD			=  6 ;
	public static final int JSP_AMOUNT			=  7 ;
	public static final int JSP_CURRENCY			=  8 ;
	public static final int JSP_EXCHANGE_RATE			=  9 ;
	public static final int JSP_VOUCHER_NUMBER			=  10 ;
	public static final int JSP_VOUCHER_DATE			=  11 ;
	public static final int JSP_VOUCHER_COUNTER			=  12 ;
	public static final int JSP_STATUS			=  13 ;
	public static final int JSP_USER_ID			=  14 ;
	public static final int JSP_AR_ID			=  15 ;
	public static final int JSP_MEMO			=  16 ;

	public static String[] colNames = {
		"JSP_ARAP_PAYMENT_ID",  "JSP_AP_ID",
		"JSP_PERIODE_ID",  "JSP_DATE",
		"JSP_PAID_BY",  "JSP_REC_BY",
		"JSP_PAY_METHOD",  "JSP_AMOUNT",
		"JSP_CURRENCY",  "JSP_EXCHANGE_RATE",
		"JSP_VOUCHER_NUMBER",  "JSP_VOUCHER_DATE",
		"JSP_VOUCHER_COUNTER",  "JSP_STATUS",
		"JSP_USER_ID",  "JSP_AR_ID",
		"JSP_MEMO"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_FLOAT,
		TYPE_STRING,  TYPE_FLOAT,
		TYPE_STRING,  TYPE_STRING,
		TYPE_INT,  TYPE_STRING,
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING
	} ;

	public JspArapPayment(){
	}
	public JspArapPayment(ArapPayment arapPayment){
		this.arapPayment = arapPayment;
	}

	public JspArapPayment(HttpServletRequest request, ArapPayment arapPayment){
		super(new JspArapPayment(arapPayment), request);
		this.arapPayment = arapPayment;
	}

	public String getFormName() { return JSP_NAME_ARAPPAYMENT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ArapPayment getEntityObject(){ return arapPayment; }

	public void requestEntityObject(ArapPayment arapPayment) {
		try{
			this.requestParam();
			arapPayment.setApId(getLong(JSP_AP_ID));
			arapPayment.setPeriodeId(getLong(JSP_PERIODE_ID));
			arapPayment.setDate(JSPFormater.formatDate(getString(JSP_DATE),"dd/MM/yyyy"));
			arapPayment.setPaidBy(getString(JSP_PAID_BY));
			arapPayment.setRecBy(getString(JSP_REC_BY));
			arapPayment.setPayMethod(getString(JSP_PAY_METHOD));
			arapPayment.setAmount(getDouble(JSP_AMOUNT));
			arapPayment.setCurrency(getString(JSP_CURRENCY));
			arapPayment.setExchangeRate(getDouble(JSP_EXCHANGE_RATE));
			arapPayment.setVoucherNumber(getString(JSP_VOUCHER_NUMBER));
			arapPayment.setVoucherDate(getDate(JSP_VOUCHER_DATE));
			arapPayment.setVoucherCounter(getInt(JSP_VOUCHER_COUNTER));
			arapPayment.setStatus(getString(JSP_STATUS));
			arapPayment.setUserId(getLong(JSP_USER_ID));
			arapPayment.setArId(getLong(JSP_AR_ID));
			arapPayment.setMemo(getString(JSP_MEMO));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
