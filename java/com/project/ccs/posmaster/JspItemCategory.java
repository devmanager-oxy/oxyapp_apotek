
package com.project.ccs.posmaster;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.ccs.posmaster.*;

public class JspItemCategory extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ItemCategory itemCategory;

	public static final String JSP_NAME_ITEMCATEGORY		=  "JSP_NAME_ITEMCATEGORY" ;

	public static final int JSP_ITEM_CATEGORY_ID			=  0 ;
	public static final int JSP_ITEM_GROUP_ID			=  1 ;
	public static final int JSP_NAME			=  2 ;
	public static final int JSP_PRIORITY			=  3 ;
	public static final int JSP_ACCOUNT_CODE			=  4 ;
        public static final int JSP_CODE			=  5 ;

	public static String[] colNames = {
		"JSP_ITEM_CATEGORY_ID",  "JSP_ITEM_GROUP_ID",
		"JSP_NAME",  "JSP_PRIORITY",
		"JSP_ACCOUNT_CODE", "JSP_CODE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_INT,
		TYPE_STRING, TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspItemCategory(){
	}
	public JspItemCategory(ItemCategory itemCategory){
		this.itemCategory = itemCategory;
	}

	public JspItemCategory(HttpServletRequest request, ItemCategory itemCategory){
		super(new JspItemCategory(itemCategory), request);
		this.itemCategory = itemCategory;
	}

	public String getFormName() { return JSP_NAME_ITEMCATEGORY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ItemCategory getEntityObject(){ return itemCategory; }

	public void requestEntityObject(ItemCategory itemCategory) {
		try{
			this.requestParam();
			itemCategory.setItemGroupId(getLong(JSP_ITEM_GROUP_ID));
			itemCategory.setName(getString(JSP_NAME));
			itemCategory.setPriority(getInt(JSP_PRIORITY));
			itemCategory.setAccountCode(getString(JSP_ACCOUNT_CODE));
                        itemCategory.setCode(getString(JSP_CODE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
