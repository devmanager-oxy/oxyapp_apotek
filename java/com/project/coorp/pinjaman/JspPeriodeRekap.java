
package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.util.*;

public class JspPeriodeRekap extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PeriodeRekap periode;

	public static final String JSP_NAME_PERIODE		=  "periode" ;

	public static final int JSP_PERIODE_ID			=  0 ;
	public static final int JSP_START_DATE			=  1 ;
	public static final int JSP_END_DATE			=  2 ;
	public static final int JSP_STATUS			=  3 ;
	public static final int JSP_NAME			=  4 ;
        public static final int JSP_INPUT_TOLERANCE			=  5 ;

	public static String[] colNames = {
		"x_periode_id",  "x_start_date",
		"x_end_date",  "x_status",
		"x_name", "x_inptolerance"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING + ENTRY_REQUIRED,
                TYPE_STRING
	} ;

	public JspPeriodeRekap(){
	}
	public JspPeriodeRekap(PeriodeRekap periode){
		this.periode = periode;
	}

	public JspPeriodeRekap(HttpServletRequest request, PeriodeRekap periode){
		super(new JspPeriodeRekap(periode), request);
		this.periode = periode;
	}

	public String getFormName() { return JSP_NAME_PERIODE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PeriodeRekap getEntityObject(){ return periode; }

	public void requestEntityObject(PeriodeRekap periode) {
		try{
			this.requestParam();
			periode.setStartDate(JSPFormater.formatDate(getString(JSP_START_DATE), "dd/MM/yyyy"));
			periode.setEndDate(JSPFormater.formatDate(getString(JSP_END_DATE), "dd/MM/yyyy"));
			//periode.setStatus(getString(JSP_STATUS));
			periode.setName(getString(JSP_NAME));
			periode.setInputTolerance(JSPFormater.formatDate(getString(JSP_INPUT_TOLERANCE), "dd/MM/yyyy"));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
