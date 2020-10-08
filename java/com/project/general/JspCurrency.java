
package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspCurrency extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Currency currency;

	public static final String JSP_NAME_CURRENCY		=  "frmcurrency" ;

	public static final int JSP_CURRENCY_CODE		=  0 ;
	public static final int JSP_DESCRIPTION			=  1 ;
	public static final int JSP_CURRENCY_ID			=  2 ;
        public static final int JSP_RATE			=  3 ;
        public static final int JSP_COA_ID			=  4 ;

	public static String[] colNames = {
		"code",  
                "descrip",
		"curr_id",
                "curr_rate",
                "coa_id"
	};

	public static int[] fieldTypes = {
		TYPE_STRING + ENTRY_REQUIRED,  
                TYPE_STRING,
		TYPE_LONG,
                TYPE_FLOAT,
                TYPE_LONG
	};

	public JspCurrency(){
	}
	public JspCurrency(Currency currency){
		this.currency = currency;
	}

	public JspCurrency(HttpServletRequest request, Currency currency){
		super(new JspCurrency(currency), request);
		this.currency = currency;
	}

	public String getFormName() { return JSP_NAME_CURRENCY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Currency getEntityObject(){ return currency; }

	public void requestEntityObject(Currency currency) {
		try{
			this.requestParam();
			currency.setCurrencyCode(getString(JSP_CURRENCY_CODE));
			currency.setDescription(getString(JSP_DESCRIPTION));
                        currency.setRate(getDouble(JSP_RATE));
                        currency.setCoaId(getLong(JSP_COA_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
