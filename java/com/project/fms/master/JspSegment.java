package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.util.*;

public class JspSegment extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Segment segment;

	public static final String JSP_NAME_SEGMENT		=  "JSP_NAME_SEGMENT" ;

	public static final int JSP_SEGMENT_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_TYPE			=  2 ;
	public static final int JSP_FUNCTION			=  3 ;
	public static final int JSP_COLUMN_NAME			=  4 ;
	public static final int JSP_COUNT			=  5 ;

	public static String[] colNames = {
		"JSP_SEGMENT_ID",  "JSP_NAME",
		"JSP_TYPE",  "JSP_FUNCTION",
		"JSP_COLUMN_NAME",  "JSP_COUNT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_INT
	} ;

	public JspSegment(){
	}
	public JspSegment(Segment segment){
		this.segment = segment;
	}

	public JspSegment(HttpServletRequest request, Segment segment){
		super(new JspSegment(segment), request);
		this.segment = segment;
	}

	public String getFormName() { return JSP_NAME_SEGMENT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Segment getEntityObject(){ return segment; }

	public void requestEntityObject(Segment segment) {
		try{
			this.requestParam();
			segment.setName(getString(JSP_NAME));
			segment.setType(getString(JSP_TYPE));
			segment.setFunction(getString(JSP_FUNCTION));
			//segment.setColumnName(getString(JSP_COLUMN_NAME));
			//segment.setCount(getInt(JSP_COUNT));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
