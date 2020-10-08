
package com.project.ccs.postransaction.promotion;

import com.project.ccs.postransaction.promotion.*;
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.util.JSPFormater;

public class JspPromotion extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Promotion promotion;

	public static final String JSP_NAME_PROMOTION		=  "JSP_NAME_PROMOTION" ;

	public static final int JSP_PROMOTION_ID			=  0 ;
	public static final int JSP_START_DATE			=  1 ;
	public static final int JSP_END_DATE			=  2 ;
	public static final int JSP_USER_ID			=  3 ;
	public static final int JSP_USER_NAME			=  4 ;
	public static final int JSP_PROMO_DESC			=  5 ;
	public static final int JSP_COUNTER			=  6 ;
        public static final int JSP_NUMBER			=  7 ;
        public static final int JSP_STATUS			=  8 ;
        public static final int JSP_PREFIX_NUMBER               =  9 ;
        public static final int JSP_TIPE               =  10 ;
        public static final int JSP_JENIS               =  11 ;

	public static String[] colNames = {
		"JSP_PROMOTION_ID",  "JSP_START_DATE",
		"JSP_END_DATE",  "JSP_USER_ID",
		"JSP_USER_NAME",  "JSP_PROMO_DESC",
                "JSP_COUNTER", "JSP_NUMBER", "JSP_STATUS", "JSP_PREFIX_NUMBER","JSP_TIPE_PROMO","JSP_JENIS"
		
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
		TYPE_STRING,TYPE_STRING,
                TYPE_INT, TYPE_STRING,
                TYPE_STRING, TYPE_STRING, TYPE_STRING, TYPE_STRING
	} ;

	public JspPromotion(){
	}
	public JspPromotion(Promotion promotion){
		this.promotion = promotion;
	}

	public JspPromotion(HttpServletRequest request, Promotion promotion){
		super(new JspPromotion(promotion), request);
		this.promotion = promotion;
	}

	public String getFormName() { return JSP_NAME_PROMOTION; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Promotion getEntityObject(){ return promotion; }

	public void requestEntityObject(Promotion promotion) {
		try{
			this.requestParam();
			promotion.setStartDate(JSPFormater.formatDate(getString(JSP_START_DATE), "dd/MM/yyyy"));
                        promotion.setEndDate(JSPFormater.formatDate(getString(JSP_END_DATE), "dd/MM/yyyy"));
                        promotion.setUserId(getLong(JSP_USER_ID));
			promotion.setUserName(getString(JSP_USER_ID));
			promotion.setPromoDesc(getString(JSP_PROMO_DESC));
			//promotion.setCounter(getInt(JSP_COUNTER));
			//promotion.setNumber(getString(JSP_NUMBER));
			promotion.setStatus(getString(JSP_STATUS));
                       // promotion.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
                        promotion.setTipe(getInt(JSP_TIPE));
                        promotion.setJenis(getInt(JSP_JENIS));
			
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
