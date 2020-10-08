

package com.project.ccs.postransaction.costing;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspCostingItem extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private CostingItem costingItem;

	public static final String JSP_NAME_COSTINGITEM		=  "JSP_NAME_COSTINGITEM" ;

	public static final int JSP_COSTING_ITEM_ID	=  0 ;
	public static final int JSP_COSTING_ID		=  1 ;
	public static final int JSP_ITEM_MASTER_ID	=  2 ;
	public static final int JSP_QTY			=  3 ;
	public static final int JSP_PRICE		=  4 ;
	public static final int JSP_AMOUNT		=  5 ;

	public static String[] colNames = {
		"JSP_COSTING_ITEM_ID",  "JSP_COSTING_ID",
		"JSP_ITEM_MASTER_ID",  "JSP_QTY",
		"JSP_PRICE", "JSP_AMOUNT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_FLOAT,
		TYPE_FLOAT, TYPE_FLOAT,
                TYPE_FLOAT
	} ;

	public JspCostingItem(){
	}
	public JspCostingItem(CostingItem costingItem){
		this.costingItem = costingItem;
	}

	public JspCostingItem(HttpServletRequest request, CostingItem costingItem){
		super(new JspCostingItem(costingItem), request);
		this.costingItem = costingItem;
	}

	public String getFormName() { return JSP_NAME_COSTINGITEM; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public CostingItem getEntityObject(){ return costingItem; }

	public void requestEntityObject(CostingItem costingItem) {
		try{
			this.requestParam();
			costingItem.setCostingId(getLong(JSP_COSTING_ID));
			costingItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
			costingItem.setQty(getDouble(JSP_QTY));
			costingItem.setPrice(getDouble(JSP_PRICE));
			costingItem.setAmount(getDouble(JSP_AMOUNT));                        	
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
