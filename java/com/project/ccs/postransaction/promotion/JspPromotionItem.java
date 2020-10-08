

package com.project.ccs.postransaction.promotion;

import com.project.ccs.postransaction.costing.*;
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspPromotionItem extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PromotionItem promotionItem;

	public static final String JSP_NAME_PROMOTION_ITEM=  "JSP_NAME_COSTINGITEM" ;

	public static final int JSP_PROMOTION_ITEM_ID			=  0 ;
	public static final int JSP_PROMOTION_ID		=  1 ;
	public static final int JSP_ITEM_MASTER_ID			=  2 ;
	public static final int JSP_ITEM_NAME	=  3 ;
	public static final int JSP_ITEM_CODE		=  4 ;
        public static final int JSP_ITEM_BARCODE		=  5 ;
	public static final int JSP_DISCOUNT_PERCENT			=  6 ;
        public static final int JSP_DISCOUNT_VALUE			=  7 ;

	public static String[] colNames = {
		"JSP_PROMOTION_ITEM_ID",  "JSP_PROMOTION_ID",
		"JSP_ITEM_MASTER_ID",  "JSP_ITEM_NAME",
		"JSP_ITEM_CODE","JSP_ITEM_BARCODE", "JSP_DISCOUNT_PERCENT",
                "JSP_DISCOUNT_VALUE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING, TYPE_STRING,
                TYPE_FLOAT, TYPE_FLOAT
	} ;

	public JspPromotionItem(){
	}
	public JspPromotionItem(PromotionItem promotionItem){
		this.promotionItem = promotionItem;
	}

	public JspPromotionItem(HttpServletRequest request, PromotionItem promotionItem){
		super(new JspPromotionItem(promotionItem), request);
		this.promotionItem = promotionItem;
	}

	public String getFormName() { return JSP_NAME_PROMOTION_ITEM; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PromotionItem getEntityObject(){ return promotionItem; }

	public void requestEntityObject(PromotionItem promotionItem) {
		try{
			this.requestParam();
			promotionItem.setPromotionId(getLong(JSP_PROMOTION_ID));
			promotionItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
			promotionItem.setItemName(getString(JSP_ITEM_NAME));
			promotionItem.setItemCode(getString(JSP_ITEM_CODE));
                        promotionItem.setItemBarcode(getString(JSP_ITEM_BARCODE));
			promotionItem.setDiscountPercent(getDouble(JSP_DISCOUNT_PERCENT));
                        promotionItem.setDiscountValue(getDouble(JSP_DISCOUNT_VALUE));
			
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
