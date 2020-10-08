/* 
 * Form Name  	:  JspPurchase.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	:  [authorName] 
 * @version  	:  [version] 
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.project.fms.transaction;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* qdep package */ 
import com.project.util.jsp.*;
import com.project.fms.transaction.*;
import com.project.util.*;


public class JspPurchase extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Purchase purchases;

	public static final String JSP_NAME_PURCHASES		=  "JSP_NAME_PURCHASES" ;

	public static final int JSP_PURCHASE_ID			=  0 ;
	public static final int JSP_VENDOR_ID			=  1 ;
	public static final int JSP_CURRENCY_ID			=  2 ;
	public static final int JSP_VENDOR_INVOICE_NUMBER			=  3 ;
	public static final int JSP_TERM_OF_PAYMENT_ID			=  4 ;
	public static final int JSP_DATE			=  5 ;
	public static final int JSP_TRANS_DATE			=  6 ;
	public static final int JSP_JOURNAL_NUMBER			=  7 ;
	public static final int JSP_JOURNAL_PREFIX			=  8 ;
	public static final int JSP_JOURNAL_COUNTER			=  9 ;
	public static final int JSP_DUE_DATE			=  10 ;
	public static final int JSP_VAT			=  11 ;
	public static final int JSP_MEMO			=  12 ;
	public static final int JSP_SHIP_ADDRESS_ID			=  13 ;
	public static final int JSP_SHIP_ADDRESS			=  14 ;
	public static final int JSP_DISCOUNT_PERCENT			=  15 ;
	public static final int JSP_DISCOUNT			=  16 ;
	public static final int JSP_VAT_PERCENT			=  17 ;
	public static final int JSP_VAT_AMOUNT			=  18 ;
	public static final int JSP_TOTAL			=  19 ;
	public static final int JSP_STATUS			=  20 ;
        public static final int JSP_OPERATOR_ID			=  21 ;

	public static String[] colNames = {
		"JSP_PURCHASE_ID",  "JSP_VENDOR_ID",
		"JSP_CURRENCY_ID",  "JSP_VENDOR_INVOICE_NUMBER",
		"JSP_TERM_OF_PAYMENT_ID",  "JSP_DATE",
		"JSP_TRANS_DATE",  "JSP_JOURNAL_NUMBER",
		"JSP_JOURNAL_PREFIX",  "JSP_JOURNAL_COUNTER",
		"JSP_DUE_DATE",  "JSP_VAT",
		"JSP_MEMO",  "JSP_SHIP_ADDRESS_ID",
		"JSP_SHIP_ADDRESS",  "JSP_DISCOUNT_PERCENT",
		"JSP_DISCOUNT",  "JSP_VAT_PERCENT",
		"JSP_VAT_AMOUNT",  "JSP_TOTAL",
		"JSP_STATUS", "JSP_OPERATOR_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_LONG,  TYPE_DATE,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_INT,
		TYPE_STRING,  TYPE_INT,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_STRING, TYPE_LONG
	} ;

	public JspPurchase(){
	}
	public JspPurchase(Purchase purchases){
		this.purchases = purchases;
	}

	public JspPurchase(HttpServletRequest request, Purchase purchases){
		super(new JspPurchase(purchases), request);
		this.purchases = purchases;
	}

	public String getFormName() { return JSP_NAME_PURCHASES; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Purchase getEntityObject(){ return purchases; }

	public void requestEntityObject(Purchase purchases) {
		try{
			this.requestParam();
			purchases.setVendorId(getLong(JSP_VENDOR_ID));
			purchases.setCurrencyId(getLong(JSP_CURRENCY_ID));
			purchases.setVendorInvoiceNumber(getString(JSP_VENDOR_INVOICE_NUMBER));
			purchases.setTermOfPaymentId(getLong(JSP_TERM_OF_PAYMENT_ID));
			//purchases.setDate(getDate(JSP_DATE));
			purchases.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE),"dd/MM/yyyy"));
			//purchases.setJournalNumber(getString(JSP_JOURNAL_NUMBER));
			//purchases.setJournalPrefix(getString(JSP_JOURNAL_PREFIX));
			//purchases.setJournalCounter(getInt(JSP_JOURNAL_COUNTER));
			purchases.setDueDate(JSPFormater.formatDate(getString(JSP_DUE_DATE),"dd/MM/yyyy"));
			purchases.setVat(getInt(JSP_VAT));
			purchases.setMemo(getString(JSP_MEMO));
			purchases.setShipAddressId(getLong(JSP_SHIP_ADDRESS_ID));
			purchases.setShipAddress(getString(JSP_SHIP_ADDRESS));
			purchases.setDiscountPercent(getDouble(JSP_DISCOUNT_PERCENT));
			purchases.setDiscount(getDouble(JSP_DISCOUNT));
			purchases.setVatPercent(getDouble(JSP_VAT_PERCENT));
			purchases.setVatAmount(getDouble(JSP_VAT_AMOUNT));
			purchases.setTotal(getDouble(JSP_TOTAL));
			//purchases.setStatus(getString(JSP_STATUS));
                        purchases.setOperatorId(getLong(JSP_OPERATOR_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
