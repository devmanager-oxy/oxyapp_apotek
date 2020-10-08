
package com.project.fms.ar;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspARInvoice extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ARInvoice aRInvoice;

	public static final String JSP_NAME_ARINVOICE		=  "JSP_NAME_ARINVOICE" ;

	public static final int JSP_AR_INVOICE_ID		=  0 ;
	public static final int JSP_CURRENCY_ID			=  1 ;
	public static final int JSP_INVOICE_NUMBER		=  2 ;
	public static final int JSP_TERM_OF_PAYMENT_ID		=  3 ;
	public static final int JSP_DATE			=  4 ;
	public static final int JSP_TRANS_DATE			=  5 ;
	public static final int JSP_JOURNAL_NUMBER		=  6 ;
	public static final int JSP_JOURNAL_PREFIX		=  7 ;
	public static final int JSP_JOURNAL_COUNTER		=  8 ;
	public static final int JSP_DUE_DATE			=  9 ;
	public static final int JSP_VAT                         =  10 ;
	public static final int JSP_MEMO			=  11 ;
	public static final int JSP_DISCOUNT_PERCENT		=  12 ;
	public static final int JSP_DISCOUNT			=  13 ;
	public static final int JSP_VAT_PERCENT			=  14 ;
	public static final int JSP_VAT_AMOUNT			=  15 ;
	public static final int JSP_TOTAL			=  16 ;
	public static final int JSP_STATUS			=  17 ;
	public static final int JSP_OPERATOR_ID			=  18 ;
	public static final int JSP_CUSTOMER_ID			=  19 ;
	public static final int JSP_COMPANY_ID			=  20 ;
	public static final int JSP_PROJECT_ID			=  21 ;
	public static final int JSP_PROJECT_TERM_ID		=  22 ;
        public static final int JSP_BANK_ACCOUNT_ID		=  23 ;
        public static final int JSP_LAST_PAYMENT_DATE           =  24 ;
        public static final int JSP_LAST_PAYMENT_AMOUNT		=  25 ;
        public static final int JSP_TYPE_AR     		=  26 ;        
        public static final int JSP_COA_AR_ID     		=  27 ;        
        public static final int JSP_CREATE_ID     		=  28 ;
        public static final int JSP_APPROVAL1_ID     		=  29 ;
        public static final int JSP_APPROVAL1_DATE     		=  30 ;
        public static final int JSP_POSTED_STATUS     		=  31 ;
        public static final int JSP_POSTED_ID     		=  32 ;
        public static final int JSP_POSTED_DATE     		=  33 ;
        public static final int JSP_PERIODE_ID     		=  34 ;
        public static final int JSP_CREATE_DATE     		=  35 ;
        public static final int JSP_LOCATION_ID     		=  36 ;
        public static final int JSP_DOC_STATUS     		=  37 ;
        public static final int JSP_REF_ID                      =  38 ;
        
	public static String[] colNames = {
		"JSP_AR_INVOICE_ID",  "JSP_CURRENCY_ID",
		"JSP_INVOICE_NUMBER",  "JSP_TERM_OF_PAYMENT_ID",
		"JSP_DATE",  "JSP_TRANS_DATE",
		"JSP_JOURNAL_NUMBER",  "JSP_JOURNAL_PREFIX",
		"JSP_JOURNAL_COUNTER",  "JSP_DUE_DATE",
		"JSP_VAT",  "JSP_MEMO",
		"JSP_DISCOUNT_PERCENT",  "JSP_DISCOUNT",
		"JSP_VAT_PERCENT",  "JSP_VAT_AMOUNT",
		"JSP_TOTAL",  "JSP_STATUS",
		"JSP_OPERATOR_ID",  "JSP_CUSTOMER_ID",
		"JSP_COMPANY_ID",  "JSP_PROJECT_ID",
		"JSP_PROJECT_TERM_ID", "JSP_BANK_ACCOUNT_ID",                
                "JSP_LAST_PAYMENT_DATE", "JSP_LAST_PAYMENT_AMOUNT",
                "JSP_TYPE_AR","JSP_COA_AR_ID",
                "JSP_CREATE_ID","JSP_APPROVAL1_ID",
                "JSP_APPROVAL1_DATE",
                "JSP_POSTED_STATUS","JSP_POSTED_ID",
                "JSP_POSTED_DATE","JSP_PERIODE_ID",
                "JSP_CREATE_DATE","JS_LOCATION_ID",
                "JSP_DOC_STATUS","REF_ID"
	} ;
        
	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_LONG,
		TYPE_DATE,  TYPE_DATE,
		TYPE_STRING,  TYPE_STRING,
		TYPE_INT,  TYPE_STRING,
		TYPE_INT,  TYPE_STRING,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_INT,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG, TYPE_LONG,                
                TYPE_STRING, TYPE_FLOAT,
                TYPE_INT,TYPE_LONG,                
                TYPE_LONG,TYPE_LONG, TYPE_DATE,
                TYPE_INT,TYPE_LONG,
                TYPE_DATE,TYPE_LONG,
                TYPE_DATE,TYPE_LONG,
                TYPE_INT,TYPE_LONG
	} ;
        
	public JspARInvoice(){
	}
        
	public JspARInvoice(ARInvoice aRInvoice){
		this.aRInvoice = aRInvoice;
	}

	public JspARInvoice(HttpServletRequest request, ARInvoice aRInvoice){
		super(new JspARInvoice(aRInvoice), request);
		this.aRInvoice = aRInvoice;
	}

	public String getFormName() { return JSP_NAME_ARINVOICE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ARInvoice getEntityObject(){ return aRInvoice; }

	public void requestEntityObject(ARInvoice aRInvoice) {
		try{
			this.requestParam();
			aRInvoice.setCurrencyId(getLong(JSP_CURRENCY_ID));			
			aRInvoice.setTermOfPaymentId(getLong(JSP_TERM_OF_PAYMENT_ID));			
			aRInvoice.setTransDate(getDate(JSP_TRANS_DATE));			
			aRInvoice.setDueDate(JSPFormater.formatDate(getString(JSP_DUE_DATE), "dd/MM/yyyy"));
			aRInvoice.setVat(getInt(JSP_VAT));
			aRInvoice.setMemo(getString(JSP_MEMO));
			aRInvoice.setDiscountPercent(getDouble(JSP_DISCOUNT_PERCENT));
			aRInvoice.setDiscount(getDouble(JSP_DISCOUNT));
			aRInvoice.setVatPercent(getDouble(JSP_VAT_PERCENT));
			aRInvoice.setVatAmount(getDouble(JSP_VAT_AMOUNT));
			aRInvoice.setTotal(getDouble(JSP_TOTAL));
			aRInvoice.setStatus(getInt(JSP_STATUS));
			aRInvoice.setOperatorId(getLong(JSP_OPERATOR_ID));
			aRInvoice.setCustomerId(getLong(JSP_CUSTOMER_ID));			
			aRInvoice.setProjectId(getLong(JSP_PROJECT_ID));
			aRInvoice.setProjectTermId(getLong(JSP_PROJECT_TERM_ID));
                        aRInvoice.setBankAccountId(getLong(JSP_BANK_ACCOUNT_ID));
                        aRInvoice.setTypeAR(getInt(JSP_TYPE_AR));
                        aRInvoice.setCoaARId(getLong(JSP_COA_AR_ID));
                        aRInvoice.setCreateId(getLong(JSP_CREATE_ID));
                        aRInvoice.setApproval1Id(getLong(JSP_APPROVAL1_ID));
                        aRInvoice.setApproval1Date(getDate(JSP_APPROVAL1_DATE));
                        aRInvoice.setPostedStatus(getInt(JSP_POSTED_STATUS));
                        aRInvoice.setPostedId(getLong(JSP_POSTED_ID));
                        aRInvoice.setPostedDate(getDate(JSP_POSTED_DATE));
                        aRInvoice.setPeriodeId(getLong(JSP_PERIODE_ID));
                        aRInvoice.setCreateDate(getDate(JSP_CREATE_DATE));
                        aRInvoice.setLocationId(getLong(JSP_LOCATION_ID));
                        aRInvoice.setDocStatus(getInt(JSP_DOC_STATUS));
                        aRInvoice.setRefId(getLong(JSP_REF_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
