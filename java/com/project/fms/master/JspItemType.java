
package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class JspItemType extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ItemType itemType;

	public static final String JSP_NAME_ITEMTYPE		=  "JSP_NAME_ITEMTYPE" ;

	public static final int JSP_ITEM_TYPE_ID			=  0 ;
	public static final int JSP_DESCRIPTION			=  1 ;

	public static String[] colNames = {
		"JSP_ITEM_TYPE_ID",  "JSP_DESCRIPTION"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspItemType(){
	}
	public JspItemType(ItemType itemType){
		this.itemType = itemType;
	}

	public JspItemType(HttpServletRequest request, ItemType itemType){
		super(new JspItemType(itemType), request);
		this.itemType = itemType;
	}

	public String getFormName() { return JSP_NAME_ITEMTYPE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ItemType getEntityObject(){ return itemType; }

	public void requestEntityObject(ItemType itemType) {
		try{
			this.requestParam();
			itemType.setDescription(getString(JSP_DESCRIPTION));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
