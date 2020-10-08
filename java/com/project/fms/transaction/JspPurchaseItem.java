/* 
 * Form Name  	:  JspPurchaseItem.java 
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

public class JspPurchaseItem extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PurchaseItem purchaseItem;

	public static final String JSP_NAME_PURCHASEITEM		=  "JSP_NAME_PURCHASEITEM" ;

	public static final int JSP_PURCHASE_ID			=  0 ;
	public static final int JSP_PURCHASE_ITEM_ID			=  1 ;
	public static final int JSP_ITEM_NAME			=  2 ;
	public static final int JSP_QTY			=  3 ;
	public static final int JSP_PRICE			=  4 ;
	public static final int JSP_TOTAL_AMOUNT			=  5 ;
	public static final int JSP_DISCOUNT			=  6 ;
	public static final int JSP_ITEM_TYPE			=  7 ;
	public static final int JSP_COA_ID			=  8 ;
        public static final int JSP_COA_ID_2			=  9 ;
        
        public static final int JSP_DEPARTMENT_ID			=  10 ;
        

	public static String[] colNames = {
		"itemJSP_PURCHASE_ID",  "itemJSP_PURCHASE_ITEM_ID",
		"itemJSP_ITEM_NAME",  "itemJSP_QTY",
		"itemJSP_PRICE",  "itemJSP_TOTAL_AMOUNT",
		"itemJSP_DISCOUNT",  "itemJSP_ITEM_TYPE",
		"itemJSP_COA_ID", "itemJSP_COA_ID2",
                "itemJSP_DEPARTMENT_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_STRING,
		TYPE_LONG, TYPE_LONG, 
                TYPE_LONG
	} ;

	public JspPurchaseItem(){
	}
	public JspPurchaseItem(PurchaseItem purchaseItem){
		this.purchaseItem = purchaseItem;
	}

	public JspPurchaseItem(HttpServletRequest request, PurchaseItem purchaseItem){
		super(new JspPurchaseItem(purchaseItem), request);
		this.purchaseItem = purchaseItem;
	}

	public String getFormName() { return JSP_NAME_PURCHASEITEM; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PurchaseItem getEntityObject(){ return purchaseItem; }

	public void requestEntityObject(PurchaseItem purchaseItem) {
		try{
			this.requestParam();
			purchaseItem.setPurchaseId(getLong(JSP_PURCHASE_ID));
			purchaseItem.setItemName(getString(JSP_ITEM_NAME));
			purchaseItem.setQty(getDouble(JSP_QTY));
			purchaseItem.setPrice(getDouble(JSP_PRICE));
			purchaseItem.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));
			purchaseItem.setDiscount(getDouble(JSP_DISCOUNT));
			purchaseItem.setItemType(getString(JSP_ITEM_TYPE));
			purchaseItem.setCoaId(getLong(JSP_COA_ID));
                        purchaseItem.setCoaId2(getLong(JSP_COA_ID_2));
                        
                        purchaseItem.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
