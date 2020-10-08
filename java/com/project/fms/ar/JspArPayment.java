
package com.project.fms.ar;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspArPayment extends JSPHandler implements I_JSPInterface, I_JSPType {

	private ArPayment arPayment;

	public static final  String JSP_NAME_AR_PAYMENT = "ar_payment";

	public static final  int JSP_AR_PAYMENT_ID = 0;
	public static final  int JSP_AR_INVOICE_ID = 1;
	public static final  int JSP_CURRENCY_ID = 2;
	public static final  int JSP_EXCHANGE_RATE = 3;
	public static final  int JSP_AMOUNT = 4;
	public static final  int JSP_CUSTOMER_ID = 5;
	public static final  int JSP_DATE = 6;
	public static final  int JSP_NOTES = 7;
	public static final  int JSP_AR_CURRENCY_AMOUNT = 8;
	public static final  int JSP_COMPANY_ID = 9;
	public static final  int JSP_JOURNAL_NUMBER = 10;
	public static final  int JSP_JOURNAL_NUMBER_PREFIX = 11;
	public static final  int JSP_COUNTER = 12;
	public static final  int JSP_PROJECT_ID = 13;
	public static final  int JSP_PROJECT_TERM_ID = 14;
	public static final  int JSP_AR_ACCOUNT_ID = 15;
	public static final  int JSP_RECEIPT_ACCOUNT_ID = 16;
	public static final  int JSP_BANK_TRANSFER_NUMBER = 17;
        public static final  int JSP_TRANSACTION_DATE = 18;
        public static final  int JSP_OPERATOR_ID = 19;
        public static final  int JSP_REF_ID = 20;
        public static final  int JSP_CREDIT_PAYMENT_ID = 21;
        
	public static final  String[] colNames = {
		"x_ar_payment_id",
		"x_ar_invoice_id",
		"x_currency_id",
		"x_exchange_rate",
		"x_amount",
		"x_customer_id",
		"x_date",
		"x_notes",
		"x_ar_currency_amount",
		"x_company_id",
		"x_journal_number",
		"x_journal_number_prefix",
		"x_counter",
		"x_project_id",
		"x_project_term_id",
		"x_ar_account_id",
		"x_receipt_account_id",
		"x_bank_transfer_number",                
                "x_transaction_date",
                "x_operator_id",
                "x_ref_id",
                "x_credit_payment_id"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING + ENTRY_REQUIRED,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED,                
                TYPE_STRING,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	};

	public JspArPayment(){
	}

	public JspArPayment(ArPayment arPayment) {
		this.arPayment = arPayment;
	}

	public JspArPayment(HttpServletRequest request, ArPayment arPayment)
	{
		super(new JspArPayment(arPayment), request);
		this.arPayment = arPayment;
	}

	public String getFormName() { return JSP_NAME_AR_PAYMENT; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public ArPayment getEntityObject(){ return arPayment; }

	public void requestEntityObject(ArPayment arPayment) {
		try{
			this.requestParam();
			arPayment.setArInvoiceId(getLong(JSP_AR_INVOICE_ID));
			arPayment.setCurrencyId(getLong(JSP_CURRENCY_ID));
			arPayment.setExchangeRate(getDouble(JSP_EXCHANGE_RATE));
			arPayment.setAmount(getDouble(JSP_AMOUNT));
			arPayment.setCustomerId(getLong(JSP_CUSTOMER_ID));
			arPayment.setDate(JSPFormater.formatDate(getString(JSP_DATE),"dd/MM/yyyy"));
			arPayment.setNotes(getString(JSP_NOTES));
			arPayment.setArCurrencyAmount(getDouble(JSP_AR_CURRENCY_AMOUNT));
			arPayment.setCompanyId(getLong(JSP_COMPANY_ID));
			arPayment.setJournalNumber(getString(JSP_JOURNAL_NUMBER));
			arPayment.setJournalNumberPrefix(getString(JSP_JOURNAL_NUMBER_PREFIX));
			arPayment.setCounter(getInt(JSP_COUNTER));
			arPayment.setProjectId(getLong(JSP_PROJECT_ID));
			arPayment.setProjectTermId(getLong(JSP_PROJECT_TERM_ID));
			arPayment.setArAccountId(getLong(JSP_AR_ACCOUNT_ID));
			arPayment.setReceiptAccountId(getLong(JSP_RECEIPT_ACCOUNT_ID));
			arPayment.setBankTransferNumber(getString(JSP_BANK_TRANSFER_NUMBER ));                        
                        arPayment.setTransactionDate(JSPFormater.formatDate(getString(JSP_TRANSACTION_DATE),"dd/MM/yyyy"));
                        arPayment.setOperatorId(getLong(JSP_OPERATOR_ID));
                        arPayment.setRefId(getLong(JSP_REF_ID));
                        arPayment.setCreditPaymentId(getLong(JSP_CREDIT_PAYMENT_ID));

		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
