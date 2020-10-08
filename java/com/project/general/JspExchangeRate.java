

package com.project.general;

/* java package */ 
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
/* project package */
import com.project.util.jsp.*;

public class JspExchangeRate extends JSPHandler implements I_JSPInterface, I_JSPType {
    
	private ExchangeRate exchangeRate;

	public static final String JSP_NAME_EXCHANGERATE		=  "excrate" ;

	public static final int JSP_EXCHANGERATE_ID			=  0 ;
	public static final int JSP_DATE                                =  1 ;
	public static final int JSP_VALUE                               =  2 ;
	public static final int JSP_STATUS                              =  3 ;
	public static final int JSP_CURRENCY_ID                         =  4 ;
	public static final int JSP_USER_ID                             =  5 ;
        
        public static final int JSP_CURRENCY_IDR_ID			=  6 ;
        public static final int JSP_CURRENCY_USD_ID			=  7 ;
        public static final int JSP_CURRENCY_EURO_ID			=  8 ;
        
        public static final int JSP_VALUE_YEN			=  9 ;
        public static final int JSP_VALUE_ASD			=  10 ;
        
        public static final int JSP_CURRENCY_YEN_ID			=  11 ;
        public static final int JSP_CURRENCY_ASD_ID			=  12 ;

	public static String[] fieldNames = {
		"x_id",  "x_date",
		"x_value",  "x_status",
		"x_curr_id",  "x_uid",
                "x_curr_idr_id", "x_curr_usd_id",
                "x_curr_eur_id",
                "x_value_yen","x_value_asd",
                "x_curr_yen_id","x_curr_asd_id"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_DATE,
		TYPE_FLOAT,  TYPE_INT,
		TYPE_LONG,  TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_FLOAT,
                TYPE_FLOAT,TYPE_LONG,
                TYPE_LONG
	};

	public JspExchangeRate(){
	}
	public JspExchangeRate(ExchangeRate exchangeRate){
		this.exchangeRate = exchangeRate;
	}

	public JspExchangeRate(HttpServletRequest request, ExchangeRate exchangeRate){
		super(new JspExchangeRate(exchangeRate), request);
		this.exchangeRate = exchangeRate;
	}

	public String getFormName() { return JSP_NAME_EXCHANGERATE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public ExchangeRate getEntityObject(){ return exchangeRate; }

	public void requestEntityObject(ExchangeRate exchangeRate) {
		try{
			this.requestParam();
			exchangeRate.setDate(getDate(JSP_DATE));
			exchangeRate.setValueUsd(getDouble(JSP_VALUE));
			exchangeRate.setStatus(getInt(JSP_STATUS));			
			exchangeRate.setUserId(getLong(JSP_USER_ID));
                        
                        exchangeRate.setCurrencyEuroId(getLong(JSP_CURRENCY_EURO_ID));
                        exchangeRate.setCurrencyIdrId(getLong(JSP_CURRENCY_IDR_ID));
                        exchangeRate.setCurrencyUsdId(getLong(JSP_CURRENCY_USD_ID));
                        
                        exchangeRate.setValueYen(getDouble(JSP_VALUE_YEN));
                        exchangeRate.setValueAsd(getDouble(JSP_VALUE_ASD));                        
                        exchangeRate.setCurrencyYenId(getLong(JSP_CURRENCY_YEN_ID));
                        exchangeRate.setCurrencyAsdId(getLong(JSP_CURRENCY_ASD_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
