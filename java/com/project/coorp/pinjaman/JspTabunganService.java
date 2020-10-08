
package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;
import com.project.coorp.pinjaman.*;

public class JspTabunganService extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private TabunganService tabunganService;

	public static final String JSP_NAME_TABUNGANSERVICE		=  "JSP_NAME_TABUNGANSERVICE" ;

	public static final int JSP_TABUNGAN_SERVICE_ID			=  0 ;
	public static final int JSP_PROCEED_DATE			=  1 ;

	public static String[] colNames = {
		"JSP_TABUNGAN_SERVICE_ID",  "JSP_PROCEED_DATE"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_DATE + ENTRY_REQUIRED
	} ;

	public JspTabunganService(){
	}
	public JspTabunganService(TabunganService tabunganService){
		this.tabunganService = tabunganService;
	}

	public JspTabunganService(HttpServletRequest request, TabunganService tabunganService){
		super(new JspTabunganService(tabunganService), request);
		this.tabunganService = tabunganService;
	}

	public String getFormName() { return JSP_NAME_TABUNGANSERVICE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public TabunganService getEntityObject(){ return tabunganService; }

	public void requestEntityObject(TabunganService tabunganService) {
		try{
			this.requestParam();
			tabunganService.setProceedDate(getDate(JSP_PROCEED_DATE));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
