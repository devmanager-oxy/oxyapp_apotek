
package com.project.fms.journal;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.fms.journal.*;
import com.project.*;
import com.project.util.*;
import com.project.util.jsp.*;

public class JspAp extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Ap ap;

	public static final String JSP_NAME_AP		=  "JSP_NAME_AP" ;

	public static final int JSP_AP_ID			=  0 ;
	public static final int JSP_DATE			=  1 ;
	public static final int JSP_DUE_DATE			=  2 ;
	public static final int JSP_VENDOR_ID			=  3 ;
	public static final int JSP_INVOICE_NUMBER			=  4 ;
	public static final int JSP_NUMBER_COUNTER			=  5 ;
	public static final int JSP_AMOUNT			=  6 ;
	public static final int JSP_STATUS			=  7 ;
	public static final int JSP_CURRENCY			=  8 ;
	public static final int JSP_PERIODE_ID			=  9 ;
	public static final int JSP_EXCHANGE_RATE			=  10 ;
	public static final int JSP_VOUCHER_NUMBER			=  11 ;
	public static final int JSP_VOUCHER_DATE			=  12 ;
	public static final int JSP_VOUCHER_COUNTER			=  13 ;
	public static final int JSP_USER_ID			=  14 ;
	public static final int JSP_MEMO			=  15 ;
	public static final int JSP_TOTAL_PAYMENT			=  16 ;

	public static String[] colNames = {
		"JSP_AP_ID",  "JSP_DATE",
		"JSP_DUE_DATE",  "JSP_VENDOR_ID",
		"JSP_INVOICE_NUMBER",  "JSP_NUMBER_COUNTER",
		"JSP_AMOUNT",  "JSP_STATUS",
		"JSP_CURRENCY",  "JSP_PERIODE_ID",
		"JSP_EXCHANGE_RATE",  "JSP_VOUCHER_NUMBER",
		"JSP_VOUCHER_DATE",  "JSP_VOUCHER_COUNTER",
		"JSP_USER_ID",  "JSP_MEMO",
		"JSP_TOTAL_PAYMENT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
		TYPE_STRING,  TYPE_INT,
		TYPE_FLOAT,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
		TYPE_FLOAT,  TYPE_STRING,
		TYPE_STRING,  TYPE_INT,
		TYPE_LONG,  TYPE_STRING,
		TYPE_FLOAT
	} ;

	public JspAp(){
	}
	public JspAp(Ap ap){
		this.ap = ap;
	}

	public JspAp(HttpServletRequest request, Ap ap){
		super(new JspAp(ap), request);
		this.ap = ap;
	}

	public String getFormName() { return JSP_NAME_AP; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Ap getEntityObject(){ return ap; }

	public void requestEntityObject(Ap ap) {
		try{
			this.requestParam();
			ap.setDate(JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy"));
			ap.setDueDate(JSPFormater.formatDate(getString(JSP_DUE_DATE), "dd/MM/yyyy"));
			ap.setVendorId(getLong(JSP_VENDOR_ID));
			ap.setInvoiceNumber(getString(JSP_INVOICE_NUMBER));
			ap.setNumberCounter(getInt(JSP_NUMBER_COUNTER));
			ap.setAmount(getDouble(JSP_AMOUNT));
			ap.setStatus(getString(JSP_STATUS));
			ap.setCurrency(getString(JSP_CURRENCY));
			ap.setPeriodeId(getLong(JSP_PERIODE_ID));
			ap.setExchangeRate(getDouble(JSP_EXCHANGE_RATE));
			ap.setVoucherNumber(getString(JSP_VOUCHER_NUMBER));
			ap.setVoucherDate(getDate(JSP_VOUCHER_DATE));
			ap.setVoucherCounter(getInt(JSP_VOUCHER_COUNTER));
			ap.setUserId(getLong(JSP_USER_ID));
			ap.setMemo(getString(JSP_MEMO));
			ap.setTotalPayment(getDouble(JSP_TOTAL_PAYMENT));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
