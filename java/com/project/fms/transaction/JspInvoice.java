

package com.project.fms.transaction;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.util.*;

public class JspInvoice extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Invoice invoice;

	public static final String JSP_NAME_INVOICE		=  "JSP_NAME_INVOICE" ;

	public static final int JSP_INVOICE_ID			=  0 ;
	public static final int JSP_DATE			=  1 ;
	public static final int JSP_TRANS_DATE			=  2 ;
	public static final int JSP_MEMO			=  3 ;
	public static final int JSP_JOURNAL_NUMBER			=  4 ;
	public static final int JSP_JOURNAL_PREFIX			=  5 ;
	public static final int JSP_VENDOR_INVOICE_NUMBER			=  6 ;
	public static final int JSP_PURCHASE_ID			=  7 ;
	public static final int JSP_JOURNAL_COUNTER			=  8 ;
	public static final int JSP_VENDOR_ID			=  9 ;
	public static final int JSP_CURRENCY_ID			=  10 ;
	public static final int JSP_STATUS			=  11 ;
	public static final int JSP_OPERATOR_ID			=  12 ;
        public static final int JSP_DUE_DATE			=  13 ;
        
        public static final int JSP_VAT_AMOUNT			=  14 ;
        public static final int JSP_VAT_PERCENT			=  15 ;
        public static final int JSP_APPLY_VAT			=  16 ;
        public static final int JSP_SUB_TOTAL			=  17 ;
        public static final int JSP_GRAND_TOTAL			=  18 ;
        
	public static String[] colNames = {
		"JSP_INVOICE_ID",  "JSP_DATE",
		"JSP_TRANS_DATE",  "JSP_MEMO",
		"JSP_JOURNAL_NUMBER",  "JSP_JOURNAL_PREFIX",
		"JSP_VENDOR_INVOICE_NUMBER",  "JSP_PURCHASE_ID",
		"JSP_JOURNAL_COUNTER",  "JSP_VENDOR_ID",
		"JSP_CURRENCY_ID",  "JSP_STATUS",
		"JSP_OPERATOR_ID", "JSP_DUE_DATE",
                "JSP_VAT_AMOUNT", "JSP_VAT_PERCENT", 
                "JSP_APPLY_VAT", "JSP_SUB_TOTAL",
                "JSP_GRAND_TOTAL"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_DATE,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_INT,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_LONG + ENTRY_REQUIRED, TYPE_STRING + ENTRY_REQUIRED,
                
                TYPE_FLOAT, TYPE_FLOAT, 
                TYPE_INT, TYPE_FLOAT, 
                TYPE_FLOAT
	} ;

	public JspInvoice(){
	}
	public JspInvoice(Invoice invoice){
		this.invoice = invoice;
	}

	public JspInvoice(HttpServletRequest request, Invoice invoice){
		super(new JspInvoice(invoice), request);
		this.invoice = invoice;
	}

	public String getFormName() { return JSP_NAME_INVOICE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Invoice getEntityObject(){ return invoice; }

	public void requestEntityObject(Invoice invoice) {
		try{
			this.requestParam();
			//invoice.setDate(getDate(JSP_DATE));
			invoice.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE), "dd/MM/yyyy"));
			invoice.setMemo(getString(JSP_MEMO));
			//invoice.setJournalNumber(getString(JSP_JOURNAL_NUMBER));
			//invoice.setJournalPrefix(getString(JSP_JOURNAL_PREFIX));
			invoice.setVendorInvoiceNumber(getString(JSP_VENDOR_INVOICE_NUMBER));
			invoice.setPurchaseId(getLong(JSP_PURCHASE_ID));
			//invoice.setJournalCounter(getInt(JSP_JOURNAL_COUNTER));
			invoice.setVendorId(getLong(JSP_VENDOR_ID));
			invoice.setCurrencyId(getLong(JSP_CURRENCY_ID));
			//invoice.setStatus(getString(JSP_STATUS));
			invoice.setOperatorId(getLong(JSP_OPERATOR_ID));
                        invoice.setDueDate(JSPFormater.formatDate(getString(JSP_DUE_DATE),"dd/MM/yyyy"));
                        
                        invoice.setVatAmount(getDouble(JSP_VAT_AMOUNT));
                        invoice.setVatPercent(getDouble(JSP_VAT_PERCENT));
                        invoice.setApplyVat(getInt(JSP_APPLY_VAT));
                        invoice.setSubTotal(getDouble(JSP_SUB_TOTAL));
                        invoice.setGrandTotal(getDouble(JSP_GRAND_TOTAL));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
