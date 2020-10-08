package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspDinasUnit extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private DinasUnit dinasUnit;

	public static final String JSP_NAME_DINASUNIT		=  "JSP_NAME_DINASUNIT" ;

	public static final int JSP_DINAS_ID			=  0 ;
	public static final int JSP_DINAS_UNIT_ID			=  1 ;
	public static final int JSP_NAMA			=  2 ;

	public static String[] colNames = {
		"JSP_DINAS_ID",  "JSP_DINAS_UNIT_ID",
		"JSP_NAMA"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspDinasUnit(){
	}
	public JspDinasUnit(DinasUnit dinasUnit){
		this.dinasUnit = dinasUnit;
	}

	public JspDinasUnit(HttpServletRequest request, DinasUnit dinasUnit){
		super(new JspDinasUnit(dinasUnit), request);
		this.dinasUnit = dinasUnit;
	}

	public String getFormName() { return JSP_NAME_DINASUNIT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public DinasUnit getEntityObject(){ return dinasUnit; }

	public void requestEntityObject(DinasUnit dinasUnit) {
		try{
			this.requestParam();
			dinasUnit.setDinasId(getLong(JSP_DINAS_ID));
			dinasUnit.setNama(getString(JSP_NAMA));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
