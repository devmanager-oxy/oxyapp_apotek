
package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspCountry extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Country country;

	public static final String JSP_NAME_COUNTRY		=  "country" ;

	public static final int JSP_COUNTY_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_NATIONALITY			=  2 ;
	public static final int JSP_CONTINENT			=  3 ;
	public static final int JSP_HUB			=  4 ;

	public static String[] fieldNames = {
		"x_country_id",  "x_name",
		"x_nationality",  "x_continent",
		"x_hub"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING
	} ;

	public JspCountry(){
	}
	public JspCountry(Country country){
		this.country = country;
	}

	public JspCountry(HttpServletRequest request, Country country){
		super(new JspCountry(country), request);
		this.country = country;
	}

	public String getFormName() { return JSP_NAME_COUNTRY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public Country getEntityObject(){ return country; }

	public void requestEntityObject(Country country) {
		try{
			this.requestParam();
			country.setName(getString(JSP_NAME));
			country.setNationality(getString(JSP_NATIONALITY));
			country.setContinent(getString(JSP_CONTINENT));
			country.setHub(getString(JSP_HUB));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
