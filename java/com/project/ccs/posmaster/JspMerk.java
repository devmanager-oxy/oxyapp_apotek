
package com.project.ccs.posmaster;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.ccs.posmaster.*;

public class JspMerk extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Merk merk;

	public static final String JSP_NAME_MERK		=  "JSP_NAME_MERK" ;

	public static final int JSP_MERK_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
	
	public static String[] colNames = {
		"JSP_MERK_ID",  "JSP_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED
		
	} ;

	public JspMerk(){
	}
	public JspMerk(Merk merk){
		this.merk = merk ;
	}

	public JspMerk(HttpServletRequest request, Merk merk){
		super(new JspMerk(merk), request);
		this.merk = merk;
	}

	public String getFormName() { return JSP_NAME_MERK; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Merk getEntityObject(){ return merk; }

	public void requestEntityObject(Merk merk) {
		try{
			this.requestParam();
			merk.setName(getString(JSP_NAME));
			
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
