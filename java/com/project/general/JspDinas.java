package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspDinas extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Dinas dinas;

	public static final String JSP_NAME_DINAS		=  "JSP_NAME_DINAS" ;

	public static final int JSP_DINAS_ID			=  0 ;
	public static final int JSP_NAMA			=  1 ;

	public static String[] colNames = {
		"JSP_DINAS_ID",  "JSP_NAMA"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspDinas(){
	}
	public JspDinas(Dinas dinas){
		this.dinas = dinas;
	}

	public JspDinas(HttpServletRequest request, Dinas dinas){
		super(new JspDinas(dinas), request);
		this.dinas = dinas;
	}

	public String getFormName() { return JSP_NAME_DINAS; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Dinas getEntityObject(){ return dinas; }

	public void requestEntityObject(Dinas dinas) {
		try{
			this.requestParam();
			dinas.setNama(getString(JSP_NAMA));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
