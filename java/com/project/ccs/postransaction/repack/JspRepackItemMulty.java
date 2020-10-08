

package com.project.ccs.postransaction.repack;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspRepackItemMulty extends JSPHandler implements I_JSPInterface, I_JSPType {
	private RepackItem repackItem;

	public static final String JSP_NAME_REPACKITEM		=  "JSP_NAME_REPACKITEM" ;

	public static final int JSP_REPACK_ITEM_ID	=  0 ;
	public static final int JSP_REPACK_ID		=  1 ;
	public static final int JSP_ITEM_MASTER_ID	=  2 ;
	public static final int JSP_QTY			=  3 ;
	public static final int JSP_TYPE		=  4 ;
        public static final int JSP_COGS		=  5 ;
        public static final int JSP_QTY_STOCK		=  6 ;
        public static final int JSP_PERCENT_COGS	=  7 ;

	public static String[] colNames = {
		"JSP_REPACK_ITEM_ID",  "JSP_REPACK_ID",
		"JSP_ITEM_MASTER_ID",  "JSP_QTY",
		"JSP_TYPE","JSP_COGS",
                "JSP_QTY_STOCK", "JSP_PERCENT_COGS"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_INT, TYPE_FLOAT,
                TYPE_FLOAT, TYPE_FLOAT
	} ;

	public JspRepackItemMulty(){
	}
	public JspRepackItemMulty(RepackItem repackItem){
		this.repackItem = repackItem;
	}

	public JspRepackItemMulty(HttpServletRequest request, RepackItem repackItem){
		super(new JspRepackItemMulty(repackItem), request);
		this.repackItem = repackItem;
	}

	public String getFormName() { return JSP_NAME_REPACKITEM; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public RepackItem getEntityObject(){ return repackItem; }

	public void requestEntityObject(RepackItem repackItem) {
		try{
			this.requestParam();
			repackItem.setRepackId(getLong(JSP_REPACK_ID));
			repackItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
			repackItem.setQty(getDouble(JSP_QTY));
			repackItem.setType(getInt(JSP_TYPE));
			repackItem.setCogs(getDouble(JSP_COGS));
                        repackItem.setQtyStock(getDouble(JSP_QTY_STOCK));
                        repackItem.setPercentCogs(getDouble(JSP_PERCENT_COGS));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
