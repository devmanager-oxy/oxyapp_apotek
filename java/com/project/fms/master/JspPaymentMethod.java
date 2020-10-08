package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;


public class JspPaymentMethod extends JSPHandler implements I_JSPInterface, I_JSPType {
	private PaymentMethod paymentMethod;

	public static final String JSP_NAME_PAYMENTMETHOD   =  "JSP_NAME_PAYMENTMETHOD" ;

	public static final int JSP_PAYMENT_METHOD_ID	    = 0;
	public static final int JSP_DESCRIPTION		    = 1;
        public static final  int JSP_POS_CODE               = 2;
        public static final  int JSP_STATUS                 = 3;
        public static final  int JSP_ORDER                  = 4;
        public static final  int JSP_MERCHANT_PAYMENT       = 5;
        public static final  int JSP_MERCHANT_TYPE          = 6;
        public static final  int JSP_AP_STATUS              = 7;
        public static final  int JSP_SEGMENT1_ID            = 8;

	public static String[] colNames = {
		"JSP_PAYMENT_METHOD_ID",  
                "JSP_DESCRIPTION",
                "jsp_pos_code",
                "jsp_status",
                "jsp_order",
                "jsp_merchant_payment",
                "jsp_merchant_type",
                "JSP_AP_STATUS",
                "JSP_SEGMENT1_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  
                TYPE_STRING + ENTRY_REQUIRED,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_LONG                
	} ;

	public JspPaymentMethod(){
	}
	public JspPaymentMethod(PaymentMethod paymentMethod){
		this.paymentMethod = paymentMethod;
	}

	public JspPaymentMethod(HttpServletRequest request, PaymentMethod paymentMethod){
		super(new JspPaymentMethod(paymentMethod), request);
		this.paymentMethod = paymentMethod;
	}

	public String getFormName() { return JSP_NAME_PAYMENTMETHOD; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PaymentMethod getEntityObject(){ return paymentMethod; }

	public void requestEntityObject(PaymentMethod paymentMethod) {
		try{
			this.requestParam();
			paymentMethod.setDescription(getString(JSP_DESCRIPTION));
                        
                        paymentMethod.setPosCode(getInt(JSP_POS_CODE));
                        paymentMethod.setStatus(getInt(JSP_STATUS));
                        paymentMethod.setOrder(getInt(JSP_ORDER));
                        paymentMethod.setMerchantPayment(getInt(JSP_MERCHANT_PAYMENT));
                        paymentMethod.setMerchantType(getInt(JSP_MERCHANT_TYPE));
                        paymentMethod.setApStatus(getInt(JSP_AP_STATUS));
                        paymentMethod.setSegment1Id(getLong(JSP_SEGMENT1_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}