
package com.project.fms.journal;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.fms.journal.*;
import com.project.*;
import com.project.util.*;
import com.project.util.jsp.*;

public class JspAr extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Ar ar;

	public static final String JSP_NAME_AR		=  "JSP_NAME_AR" ;

	public static final int JSP_AR_ID			=  0 ;
	public static final int JSP_DATE			=  1 ;
	public static final int JSP_DUE_DATE			=  2 ;
	public static final int JSP_INVOICE_NUMBER			=  3 ;
	public static final int JSP_NUMBER_COUNTER			=  4 ;
	public static final int JSP_AMOUNT			=  5 ;
	public static final int JSP_STATUS			=  6 ;
	public static final int JSP_PO_NUMBER			=  7 ;
	public static final int JSP_CURRENCY			=  8 ;
	public static final int JSP_PERIODE_ID			=  9 ;
	public static final int JSP_EXCHANGE_RATE			=  10 ;
	public static final int JSP_VOUCHER_NUMBER			=  11 ;
	public static final int JSP_VOUCHER_DATE			=  12 ;
	public static final int JSP_VOUCHER_COUNTER			=  13 ;
	public static final int JSP_USER_ID			=  14 ;
	public static final int JSP_CUSTOMER_ID			=  15 ;
	public static final int JSP_MEMO			=  16 ;
	public static final int JSP_TOTAL_PAYMENT			=  17 ;

	public static String[] colNames = {
		"JSP_AR_ID",  "JSP_DATE",
		"JSP_DUE_DATE",  "JSP_INVOICE_NUMBER",
		"JSP_NUMBER_COUNTER",  "JSP_AMOUNT",
		"JSP_STATUS",  "JSP_PO_NUMBER",
		"JSP_CURRENCY",  "JSP_PERIODE_ID",
		"JSP_EXCHANGE_RATE",  "JSP_VOUCHER_NUMBER",
		"JSP_VOUCHER_DATE",  "JSP_VOUCHER_COUNTER",
		"JSP_USER_ID",  "JSP_CUSTOMER_ID",
		"JSP_MEMO",  "JSP_TOTAL_PAYMENT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_INT,  TYPE_FLOAT,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
		TYPE_FLOAT,  TYPE_STRING,
		TYPE_STRING,  TYPE_INT,
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_FLOAT
	} ;

	public JspAr(){
	}
	public JspAr(Ar ar){
		this.ar = ar;
	}

	public JspAr(HttpServletRequest request, Ar ar){
		super(new JspAr(ar), request);
		this.ar = ar;
	}

	public String getFormName() { return JSP_NAME_AR; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Ar getEntityObject(){ return ar; }

	public void requestEntityObject(Ar ar) {
		try{
			this.requestParam();
			ar.setDate(JSPFormater.formatDate(getString(JSP_DATE),"dd/MM/yyyy"));
			ar.setDueDate(JSPFormater.formatDate(getString(JSP_DUE_DATE), "dd/MM/yyyy"));
			ar.setInvoiceNumber(getString(JSP_INVOICE_NUMBER));
			ar.setNumberCounter(getInt(JSP_NUMBER_COUNTER));
			ar.setAmount(getDouble(JSP_AMOUNT));
			ar.setStatus(getString(JSP_STATUS));
			ar.setPoNumber(getString(JSP_PO_NUMBER));
			ar.setCurrency(getString(JSP_CURRENCY));
			ar.setPeriodeId(getLong(JSP_PERIODE_ID));
			ar.setExchangeRate(getDouble(JSP_EXCHANGE_RATE));
			ar.setVoucherNumber(getString(JSP_VOUCHER_NUMBER));
			ar.setVoucherDate(JSPFormater.formatDate(getString(JSP_VOUCHER_DATE), "dd/MM/yyyy"));
			ar.setVoucherCounter(getInt(JSP_VOUCHER_COUNTER));
			ar.setUserId(getLong(JSP_USER_ID));
			ar.setCustomerId(getLong(JSP_CUSTOMER_ID));
			ar.setMemo(getString(JSP_MEMO));
			ar.setTotalPayment(getDouble(JSP_TOTAL_PAYMENT));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
