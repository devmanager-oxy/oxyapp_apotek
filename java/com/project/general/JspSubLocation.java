
package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspSubLocation extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SubLocation subLocation;

	public static final String JSP_NAME_SUB_LOCATION		=  "JSP_NAME_SUB_LOCATION" ;

	public static final int JSP_SUB_LOCATION_ID			=  0 ;
	public static final int JSP_LOCATION_ID				=  1 ;
	public static final int JSP_NAME			=  2 ;
	public static final int JSP_DESCRIPTION			=  3 ;
        
        
	public static String[] colNames = {
		"JSP_SUB_LOCATION_ID",  "JSP_LOCATION_ID",
		"JSP_NAME",  "JSP_DESCRIPTION"
	};

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING, TYPE_STRING
	};

	public JspSubLocation(){
	}
	public JspSubLocation(SubLocation subLocation){
		this.subLocation = subLocation;
	}

	public JspSubLocation(HttpServletRequest request, SubLocation subLocation){
		super(new JspSubLocation(subLocation), request);
		this.subLocation = subLocation;
	}

	public String getFormName() { return JSP_NAME_SUB_LOCATION; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SubLocation getEntityObject(){ return subLocation; }
        
	public void requestEntityObject(SubLocation subLocation) {
		try{			
                        this.requestParam();
			subLocation.setLocation_id(getLong(JSP_LOCATION_ID));
			subLocation.setName(getString(JSP_NAME));
			subLocation.setDescription(getString(JSP_DESCRIPTION));
			
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
