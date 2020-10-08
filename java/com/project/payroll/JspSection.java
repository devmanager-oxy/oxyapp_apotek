package com.project.payroll; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.payroll.*; 

public class JspSection extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Section section;

	public static final String JSP_NAME_SECTION		=  "frmsection" ;

	public static final int JSP_SECTION_ID			=  0 ;
	public static final int JSP_DEPARTMENT_ID			=  1 ;
	public static final int JSP_NAME			=  2 ;
	public static final int JSP_DESCRIPTION			=  3 ;

	public static String[] colNames = {
		"x_secid",  "x_depid",
		"x_name",  "x_desc"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING
	} ;

	public JspSection(){
	}
	public JspSection(Section section){
		this.section = section;
	}

	public JspSection(HttpServletRequest request, Section section){
		super(new JspSection(section), request);
		this.section = section;
	}

	public String getFormName() { return JSP_NAME_SECTION; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Section getEntityObject(){ return section; }

	public void requestEntityObject(Section section) {
		try{
			this.requestParam();
			section.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
			section.setName(getString(JSP_NAME));
			section.setDescription(getString(JSP_DESCRIPTION));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
