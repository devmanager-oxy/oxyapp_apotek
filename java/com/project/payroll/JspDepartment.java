package com.project.payroll; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.payroll.*; 

public class JspDepartment extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Department department;

	public static final String JSP_NAME_DEPARTMENT		=  "frmdepartment" ;

	public static final int JSP_DEPARTMENT_ID		=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_DESCRIPTION		=  2 ;
        
        public static final int JSP_CODE		=  3 ;
        public static final int JSP_LEVEL		=  4 ;
        public static final int JSP_REF_ID		=  5 ;
        
        public static final int JSP_TYPE		=  6 ;

	public static String[] colNames = {
		"x_0",  "x_1",
		"x_2", "JSP_CODE", 
                "JSP_LEVEL", "JSP_REF_ID",
                "x_type"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING, TYPE_STRING + ENTRY_REQUIRED,
                TYPE_INT, TYPE_LONG,
                TYPE_STRING
	} ;

	public JspDepartment(){
	}
	public JspDepartment(Department department){
		this.department = department;
	}

	public JspDepartment(HttpServletRequest request, Department department){
		super(new JspDepartment(department), request);
		this.department = department;
	}

	public String getFormName() { return JSP_NAME_DEPARTMENT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Department getEntityObject(){ return department; }

	public void requestEntityObject(Department department) {
		try{
			this.requestParam();
			department.setName(getString(JSP_NAME));
			department.setDescription(getString(JSP_DESCRIPTION));
                        
                        department.setCode(getString(JSP_CODE));
                        department.setLevel(getInt(JSP_LEVEL));
                        department.setRefId(getLong(JSP_REF_ID));
                        department.setType(getString(JSP_TYPE));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
