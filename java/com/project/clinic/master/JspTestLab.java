package com.project.clinic.master;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspTestLab extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private TestLab testLab;

	public static final String JSP_NAME_TESTLAB		=  "JSP_NAME_TESTLAB" ;

	public static final int JSP_FIELD_TEST_LAB_ID			=  0 ;
	public static final int JSP_FIELD_TEST_NAME			=  1 ;

	public static String[] colNames = {
		"JSP_FIELD_TEST_LAB_ID",  "JSP_FIELD_TEST_NAME"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspTestLab(){
	}
	public JspTestLab(TestLab testLab){
		this.testLab = testLab;
	}

	public JspTestLab(HttpServletRequest request, TestLab testLab){
		super(new JspTestLab(testLab), request);
		this.testLab = testLab;
	}

	public String getFormName() { return JSP_NAME_TESTLAB; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public TestLab getEntityObject(){ return testLab; }

	public void requestEntityObject(TestLab testLab) {
		try{
			this.requestParam();
			testLab.setTestName(getString(JSP_FIELD_TEST_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
