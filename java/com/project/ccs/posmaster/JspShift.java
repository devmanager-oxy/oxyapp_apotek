
package com.project.ccs.posmaster;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.ccs.posmaster.*;

public class JspShift extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Shift shift;

	public static final String JSP_NAME_SHIFT		=  "JSP_NAME_SHIFT" ;

	public static final int JSP_SHIFT_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_START_TIME			=  2 ;
	public static final int JSP_END_TIME			=  3 ;
        
        public static final int JSP_START_HOURS			=  4 ;
        public static final int JSP_START_MINUTES			=  5 ;
        public static final int JSP_END_HOURS			=  6 ;
        public static final int JSP_END_MINUTES			=  7 ;

	public static String[] colNames = {
		"JSP_SHIFT_ID",  "JSP_NAME",
		"JSP_START_TIME",  "JSP_END_TIME",
                
                "JSP_START_HOURS", "JSP_START_MINUTES",
                "JSP_END_HOURS", "JSP_END_MINUTES"
                
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_DATE,  TYPE_DATE,
                
                TYPE_INT, TYPE_INT,
                TYPE_INT, TYPE_INT
	} ;

	public JspShift(){
	}
	public JspShift(Shift shift){
		this.shift = shift;
	}

	public JspShift(HttpServletRequest request, Shift shift){
		super(new JspShift(shift), request);
		this.shift = shift;
	}

	public String getFormName() { return JSP_NAME_SHIFT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Shift getEntityObject(){ return shift; }

	public void requestEntityObject(Shift shift) {
		try{
			this.requestParam();
			shift.setName(getString(JSP_NAME));
			shift.setStartTime(getDate(JSP_START_TIME));
			shift.setEndTime(getDate(JSP_END_TIME));
                        
                        shift.setStartHours(getInt(JSP_START_HOURS));
                        shift.setStartMinutes(getInt(JSP_START_MINUTES));
                        shift.setEndHours(getInt(JSP_END_HOURS));
                        shift.setEndMinutes(getInt(JSP_END_MINUTES));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
