/***********************************\
|  Create by Rahde              |
|  Karya kami mohon jangan dibajak  |
|                                   |
| 03/11/2011 9:58:08 AM
\***********************************/

package com.project.ccs.postransaction.sales;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspPayment extends JSPHandler implements I_JSPInterface, I_JSPType {

	private Payment payment;

	public static final  String JSP_NAME_PAYMENT = "jsp_payment";

	public static final  int JSP_PAYMENT_ID = 0;
	public static final  int JSP_SALES_ID = 1;
	public static final  int JSP_CURRENCY_ID = 2;
	public static final  int JSP_PAY_DATE = 3;
	public static final  int JSP_PAY_TYPE = 4;
	public static final  int JSP_AMOUNT = 5;
        public static final  int JSP_RATE = 6;
        public static final  int JSP_COST_CARD_AMOUNT = 7;
	public static final  int JSP_COST_CARD_PERCENT = 8;
        public static final  int JSP_BANK_ID = 9;
        public static final  int JSP_MERCHANT_ID = 10;
        
	public static final  String[] colNames = {
		"x_payment_id",
		"x_sales_id",
		"xPayment_currency_id",
		"x_pay_date",
		"x_pay_type",
		"xx_amount_payment",
                "x_rate",
                "x_cost_card_amount",
                "x_cost_card_percent",
                "x_bank_id",
                "x_merchant_id"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_INT,
		TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_LONG
	};

	public JspPayment(){
	}

	public JspPayment(Payment payment) {
		this.payment = payment;
	}

	public JspPayment(HttpServletRequest request, Payment payment)
	{
		super(new JspPayment(payment), request);
		this.payment = payment;
	}

	public String getFormName() { return JSP_NAME_PAYMENT ; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public Payment getEntityObject(){ return payment; }

	public void requestEntityObject(Payment payment) {
		try{
			this.requestParam();
			payment.setSales_id(getLong(JSP_SALES_ID));
                        payment.setCurrency_id(getLong(JSP_CURRENCY_ID));
                        payment.setPay_date(getDate(JSP_PAY_DATE));
			payment.setPay_type(getInt(JSP_PAY_TYPE));
			payment.setAmount(getDouble(JSP_AMOUNT));
                        payment.setRate(getDouble(JSP_RATE));
			payment.setCost_card_amount(getDouble(JSP_COST_CARD_AMOUNT));
                        payment.setCost_card_percent(getDouble(JSP_COST_CARD_PERCENT));
                        payment.setBankId(getLong(JSP_BANK_ID));
                        payment.setMerchantId(getLong(JSP_MERCHANT_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
