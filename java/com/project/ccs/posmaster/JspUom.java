
package com.project.ccs.posmaster;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.ccs.posmaster.*;

public class JspUom extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Uom uom;

	public static final String JSP_NAME_UOM		=  "JSP_NAME_UOM" ;

	public static final int JSP_UOM_ID			=  0 ;
	public static final int JSP_UNIT			=  1 ;

	public static String[] colNames = {
		"JSP_UOM_ID",  "JSP_UNIT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspUom(){
	}
	public JspUom(Uom uom){
		this.uom = uom;
	}

	public JspUom(HttpServletRequest request, Uom uom){
		super(new JspUom(uom), request);
		this.uom = uom;
	}

	public String getFormName() { return JSP_NAME_UOM; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Uom getEntityObject(){ return uom; }

	public void requestEntityObject(Uom uom) {
		try{
			this.requestParam();
			uom.setUnit(getString(JSP_UNIT));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
