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


public class JspReturnPayment extends JSPHandler implements I_JSPInterface, I_JSPType {

	private ReturnPayment returnPayment;

	public static final  String JSP_NAME_PAYMENT = "jsp_return_payment";

	public static final  int JSP_RETURN_PAYMENT_ID = 0;
	public static final  int JSP_SALES_ID = 1;
	public static final  int JSP_CURRENCY_ID = 2;
	public static final  int JSP_AMOUNT = 3;
	
	public static final  String[] colNames = {
		"x_return_payment_id",
		"x_sales_id",
		"x_currency_id",
		"x_amount_return_payment"
		
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT
		
	};

	public JspReturnPayment(){
	}

	public JspReturnPayment(ReturnPayment returnPayment) {
		this.returnPayment = returnPayment;
	}

	public JspReturnPayment(HttpServletRequest request, ReturnPayment returnPayment)
	{
		super(new JspReturnPayment(returnPayment), request);
		this.returnPayment = returnPayment;
	}

	public String getFormName() { return JSP_NAME_PAYMENT ; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public ReturnPayment getEntityObject(){ return returnPayment; }

	public void requestEntityObject(ReturnPayment returnPayment) {
		try{
			this.requestParam();

			returnPayment.setSales_id(getLong(JSP_SALES_ID));
                        returnPayment.setCurrency_id(getLong(JSP_CURRENCY_ID));
                        returnPayment.setAmount(getDouble(JSP_AMOUNT));
			
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
