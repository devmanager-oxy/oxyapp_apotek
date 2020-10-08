
package com.project.ccs.posmaster;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.ccs.posmaster.*;

public class JspWaiterTable extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private WaiterTable waiterTable;

	public static final String JSP_NAME_WAITERTABLE		=  "JSP_NAME_WAITERTABLE" ;

	public static final int JSP_NAME			=  0 ;
	public static final int JSP_PAX			=  1 ;
	public static final int JSP_WAITER_TABLE_ID			=  2 ;
	public static final int JSP_STATUS			=  3 ;
        public static final int JSP_LOCATION_ID			=  4 ;

	public static String[] colNames = {
		"JSP_NAME",  "JSP_PAX",
		"JSP_WAITER_TABLE_ID",  "JSP_STATUS",
                "JSP_LOCATION_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_INT + ENTRY_REQUIRED,
		TYPE_LONG,  TYPE_STRING,
                TYPE_LONG + ENTRY_REQUIRED
	} ;

	public JspWaiterTable(){
	}
	public JspWaiterTable(WaiterTable waiterTable){
		this.waiterTable = waiterTable;
	}

	public JspWaiterTable(HttpServletRequest request, WaiterTable waiterTable){
		super(new JspWaiterTable(waiterTable), request);
		this.waiterTable = waiterTable;
	}

	public String getFormName() { return JSP_NAME_WAITERTABLE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public WaiterTable getEntityObject(){ return waiterTable; }

	public void requestEntityObject(WaiterTable waiterTable) {
		try{
			this.requestParam();
			waiterTable.setName(getString(JSP_NAME));
			waiterTable.setPax(getInt(JSP_PAX));
			waiterTable.setStatus(getString(JSP_STATUS));
                        waiterTable.setLocationId(getLong(JSP_LOCATION_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
