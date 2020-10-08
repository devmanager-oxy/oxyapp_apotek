/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.sales;

/**
 *
 * @author Administrator
 */
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspCreditPayment extends JSPHandler implements I_JSPInterface, I_JSPType {

	private CreditPayment creditPayment;

	public static final  String JSP_NAME_CREDIT_PAYMENT = "jsp_credit_payment";

	public static final  int JSP_CREDIT_PAYMENT_ID = 0;
	public static final  int JSP_SALES_ID = 1;
	public static final  int JSP_CURRENCY_ID = 2;
	public static final  int JSP_DATETIME_PAY = 3;
	public static final  int JSP_AMOUNT = 4;
        public static final  int JSP_RATE = 5;
        public static final int JSP_CASH_cASHIER =6;        
        public static final int JSP_TYPE =7;      
        public static final int JSP_BANK_ID =8;      
        public static final int JSP_CUSTOMER_ID =9;      
        public static final int JSP_MERCHANT_ID =10;      
        public static final int JSP_GIRO_ID =11;      
        public static final int JSP_EXPIRED_DATE =12;      

	public static final  String[] colNames = {
		"x_jsp_credit_payment_id",
		"x_jsp_sales_id",
		"x_jsp_currency_id",
		"x_jsp_datetime_pay",
		"x_jsp_amount",
                "x_jsp_rate",
                "x_jsp_cash_cashier",
                "x_jsp_type",
                "x_jsp_bank_id",
                "x_jsp_customer_id",
                "x_jsp_merchant_id",
                "x_jsp_giro_id",
                "x_jsp_expired_date"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_LONG,                
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_DATE
        };

	public JspCreditPayment(){
	}

	public JspCreditPayment(CreditPayment creditPayment) {
		this.creditPayment = creditPayment;
	}

	public JspCreditPayment(HttpServletRequest request, CreditPayment creditPayment)
	{
		super(new JspCreditPayment(creditPayment), request);
		this.creditPayment = creditPayment;
	}

	public String getFormName() { return JSP_NAME_CREDIT_PAYMENT; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public CreditPayment getEntityObject(){ return creditPayment; }

	public void requestEntityObject(CreditPayment creditPayment) {
		try{                        
			this.requestParam();
			creditPayment.setSales_id(getLong(JSP_SALES_ID));
                        creditPayment.setCurrency_id(getLong(JSP_CURRENCY_ID));
                        creditPayment.setPay_datetime(JSPFormater.formatDate(getString(JSP_DATETIME_PAY), "dd/MM/yyyy"));
			creditPayment.setAmount(getDouble(JSP_AMOUNT));
                        creditPayment.setRate(getDouble(JSP_RATE));
                        creditPayment.setCash_cashier_id(getLong(JSP_CASH_cASHIER));
                        creditPayment.setType(getInt(JSP_TYPE));
                        creditPayment.setBankId(getLong(JSP_BANK_ID));
                        creditPayment.setCustomerId(getLong(JSP_CUSTOMER_ID));
                        creditPayment.setMerchantId(getLong(JSP_MERCHANT_ID));
                        creditPayment.setGiroId(getLong(JSP_GIRO_ID));
                        creditPayment.setExpiredDate(getDate(JSP_EXPIRED_DATE));

		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
