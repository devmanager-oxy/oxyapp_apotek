
package com.project.fms.journal;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.fms.journal.*;
import com.project.*;
import com.project.util.*;
import com.project.util.jsp.*;

public class JspJournal extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Journal journal;

	public static final String JSP_NAME_JOURNAL		=  "JSP_NAME_JOURNAL" ;

	public static final int JSP_JOURNAL_ID			=  0 ;
	public static final int JSP_DATE			=  1 ;
	public static final int JSP_PIC_BY			=  2 ;
	public static final int JSP_CURRENCY			=  3 ;
	public static final int JSP_MEMO			=  4 ;
	public static final int JSP_PIC_FROM			=  5 ;
	public static final int JSP_USER_BY_ID			=  6 ;
	public static final int JSP_USER_FROM_ID			=  7 ;
	public static final int JSP_PERIODE_ID			=  8 ;
	public static final int JSP_STATUS			=  9 ;
	public static final int JSP_AMOUNT			=  10 ;
	public static final int JSP_REFF_NO			=  11 ;
	public static final int JSP_VOUCHER_NUMBER			=  12 ;
	public static final int JSP_VOUCHER_COUNTER			=  13 ;
	public static final int JSP_VOUCHER_DATE			=  14 ;
	public static final int JSP_EXCHANGE_RATE			=  15 ;
	public static final int JSP_USER_ID			=  16 ;
	public static final int JSP_JOURNAL_TYPE			=  17 ;
	public static final int JSP_AP_ID			=  18 ;
	public static final int JSP_ARAP_PAYMENT_ID			=  19 ;
	public static final int JSP_AR_ID			=  20 ;

	public static String[] colNames = {
		"JSP_JOURNAL_ID",  "JSP_DATE",
		"JSP_PIC_BY",  "JSP_CURRENCY",
		"JSP_MEMO",  "JSP_PIC_FROM",
		"JSP_USER_BY_ID",  "JSP_USER_FROM_ID",
		"JSP_PERIODE_ID",  "JSP_STATUS",
		"JSP_AMOUNT",  "JSP_REFF_NO",
		"JSP_VOUCHER_NUMBER",  "JSP_VOUCHER_COUNTER",
		"JSP_VOUCHER_DATE",  "JSP_EXCHANGE_RATE",
		"JSP_USER_ID",  "JSP_JOURNAL_TYPE",
		"JSP_AP_ID",  "JSP_ARAP_PAYMENT_ID",
		"JSP_AR_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_STRING,
		TYPE_FLOAT,  TYPE_STRING,
		TYPE_STRING,  TYPE_INT,
		TYPE_STRING,  TYPE_FLOAT,
		TYPE_LONG,  TYPE_STRING,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG
	} ;

	public JspJournal(){
	}
	public JspJournal(Journal journal){
		this.journal = journal;
	}

	public JspJournal(HttpServletRequest request, Journal journal){
		super(new JspJournal(journal), request);
		this.journal = journal;
	}

	public String getFormName() { return JSP_NAME_JOURNAL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Journal getEntityObject(){ return journal; }

	public void requestEntityObject(Journal journal) {
		try{
			this.requestParam();
			journal.setDate(JSPFormater.formatDate(getString(JSP_DATE),"dd/MM/yyyy"));
			journal.setPicBy(getString(JSP_PIC_BY));
			journal.setCurrency(getString(JSP_CURRENCY));
			journal.setMemo(getString(JSP_MEMO));
			journal.setPicFrom(getString(JSP_PIC_FROM));
			journal.setUserById(getLong(JSP_USER_BY_ID));
			journal.setUserFromId(getLong(JSP_USER_FROM_ID));
			journal.setPeriodeId(getLong(JSP_PERIODE_ID));
			journal.setStatus(getString(JSP_STATUS));
			journal.setAmount(getDouble(JSP_AMOUNT));
			journal.setReffNo(getString(JSP_REFF_NO));
			journal.setVoucherNumber(getString(JSP_VOUCHER_NUMBER));
			journal.setVoucherCounter(getInt(JSP_VOUCHER_COUNTER));
			journal.setVoucherDate(JSPFormater.formatDate(getString(JSP_VOUCHER_DATE),"dd/MM/yyyy"));
			journal.setExchangeRate(getDouble(JSP_EXCHANGE_RATE));
			journal.setUserId(getLong(JSP_USER_ID));
			journal.setJournalType(getString(JSP_JOURNAL_TYPE));
			journal.setApId(getLong(JSP_AP_ID));
			journal.setArapPaymentId(getLong(JSP_ARAP_PAYMENT_ID));
			journal.setArId(getLong(JSP_AR_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
