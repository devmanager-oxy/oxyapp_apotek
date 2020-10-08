package com.project.fms.transaction;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.fms.transaction.*;

public class JspInvoiceItem extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private InvoiceItem invoiceItem;

	public static final String JSP_NAME_INVOICEITEM		=  "JSP_NAME_INVOICEITEM" ;

	public static final int JSP_PURCHASE_ITEM_ID			=  0 ;
	public static final int JSP_INVOICE_ID			=  1 ;
	public static final int JSP_INVOICE_ITEM_ID			=  2 ;
	public static final int JSP_COA_ID			=  3 ;
	public static final int JSP_INV_QTY			=  4 ;
	public static final int JSP_PRICE			=  5 ;
	public static final int JSP_TOTAL			=  6 ;
	public static final int JSP_MEMO			=  7 ;
	public static final int JSP_ITEM_TYPE			=  8 ;
        public static final int JSP_ITEM_NAME			=  9 ;
        
	public static String[] colNames = {
		"JSP_PURCHASE_ITEM_ID",  "JSP_INVOICE_ID",
		"JSP_INVOICE_ITEM_ID",  "JSP_COA_ID",
		"JSP_INV_QTY",  "JSP_PRICE",
		"JSP_TOTAL",  "JSP_MEMO",
		"JSP_ITEM_TYPE", "JSP_ITEM_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_INT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_STRING,
		TYPE_STRING, TYPE_STRING
	} ;

	public JspInvoiceItem(){
	}
	public JspInvoiceItem(InvoiceItem invoiceItem){
		this.invoiceItem = invoiceItem;
	}

	public JspInvoiceItem(HttpServletRequest request, InvoiceItem invoiceItem){
		super(new JspInvoiceItem(invoiceItem), request);
		this.invoiceItem = invoiceItem;
	}

	public String getFormName() { return JSP_NAME_INVOICEITEM; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public InvoiceItem getEntityObject(){ return invoiceItem; }

	public void requestEntityObject(InvoiceItem invoiceItem) {
		try{
			this.requestParam();
			invoiceItem.setPurchaseItemId(getLong(JSP_PURCHASE_ITEM_ID));
			invoiceItem.setInvoiceId(getLong(JSP_INVOICE_ID));
			invoiceItem.setCoaId(getLong(JSP_COA_ID));
			invoiceItem.setInvQty(getDouble(JSP_INV_QTY));
			invoiceItem.setPrice(getDouble(JSP_PRICE));
			invoiceItem.setTotal(getDouble(JSP_TOTAL));
			invoiceItem.setMemo(getString(JSP_MEMO));
			invoiceItem.setItemType(getString(JSP_ITEM_TYPE));
                        invoiceItem.setItemName(getString(JSP_ITEM_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
