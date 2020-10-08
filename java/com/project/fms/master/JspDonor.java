
package com.project.fms.master;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspDonor extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Donor donor;

	public static final String JSP_NAME_DONOR		=  "donor" ;

	public static final int JSP_DONOR_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_ADDRESS			=  2 ;
	public static final int JSP_CITY			=  3 ;
	public static final int JSP_STATE			=  4 ;
	public static final int JSP_COUNTRY_NAME			=  5 ;
	public static final int JSP_DESCRIPTION			=  6 ;
	public static final int JSP_COUNTRY_ID			=  7 ;
	public static final int JSP_PHONE			=  8 ;
	public static final int JSP_FAX			=  9 ;
	public static final int JSP_HP			=  10 ;
	public static final int JSP_CODE			=  11 ;
        public static final int JSP_CONTACT_PERSON			=  12 ;
        
	public static String[] colNames = {
		"x_donor_id",  "x_name",
		"x_address",  "x_city",
		"x_state",  "x_country_name",
		"x_description",  "x_country_id",
		"x_phone",  "x_fax",
		"x_hp",  "x_code",
                "x_contact_person"
	} ;

	/*public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING
	} ;
         */
        
        public static int[] fieldTypes = {
                TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
                TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING + ENTRY_REQUIRED,
                TYPE_STRING,  TYPE_STRING,
                TYPE_STRING,  TYPE_LONG,
                TYPE_STRING,  TYPE_STRING,
                TYPE_STRING,  TYPE_STRING + ENTRY_REQUIRED,
                TYPE_STRING
        } ;

	public JspDonor(){
	}
	public JspDonor(Donor donor){
		this.donor = donor;
	}

	public JspDonor(HttpServletRequest request, Donor donor){
		super(new JspDonor(donor), request);
		this.donor = donor;
	}

	public String getFormName() { return JSP_NAME_DONOR; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Donor getEntityObject(){ return donor; }

	public void requestEntityObject(Donor donor) {
		try{
			this.requestParam();
			donor.setName(getString(JSP_NAME));
			donor.setAddress(getString(JSP_ADDRESS));
			donor.setCity(getString(JSP_CITY));
			donor.setState(getString(JSP_STATE));
			donor.setCountryName(getString(JSP_COUNTRY_NAME));
			donor.setDescription(getString(JSP_DESCRIPTION));
			donor.setCountryId(getLong(JSP_COUNTRY_ID));
			donor.setPhone(getString(JSP_PHONE));
			donor.setFax(getString(JSP_FAX));
			donor.setHp(getString(JSP_HP));
			donor.setCode(getString(JSP_CODE));
                        donor.setContactPerson(getString(JSP_CONTACT_PERSON));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
