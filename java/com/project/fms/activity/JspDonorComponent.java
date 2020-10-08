
package com.project.fms.activity;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspDonorComponent extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private DonorComponent donorComponent;

	public static final String JSP_NAME_DONORCOMPONENT		=  "donorcomponent" ;

	public static final int JSP_DONOR_COMPONENT_ID			=  0 ;
	public static final int JSP_DONOR_ID			=  1 ;
	public static final int JSP_CODE			=  2 ;
	public static final int JSP_NAME			=  3 ;
	public static final int JSP_DESCRIPTION			=  4 ;
	public static final int JSP_DONOR_NAME			=  5 ;

	public static String[] colNames = {
		"x_donor_component_id",  "x_donor_id",
		"x_code",  "x_name",
		"x_description",  "x_donor_name"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_STRING
	} ;

	public JspDonorComponent(){
	}
	public JspDonorComponent(DonorComponent donorComponent){
		this.donorComponent = donorComponent;
	}

	public JspDonorComponent(HttpServletRequest request, DonorComponent donorComponent){
		super(new JspDonorComponent(donorComponent), request);
		this.donorComponent = donorComponent;
	}

	public String getFormName() { return JSP_NAME_DONORCOMPONENT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public DonorComponent getEntityObject(){ return donorComponent; }

	public void requestEntityObject(DonorComponent donorComponent) {
		try{
			this.requestParam();
			donorComponent.setDonorId(getLong(JSP_DONOR_ID));
			donorComponent.setCode(getString(JSP_CODE));
			donorComponent.setName(getString(JSP_NAME));
			donorComponent.setDescription(getString(JSP_DESCRIPTION));
			donorComponent.setDonorName(getString(JSP_DONOR_NAME));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
