/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;
 
/**
 *
 * @author Tu Roy
 */
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspIndukCustomer extends JSPHandler implements I_JSPInterface, I_JSPType {

    private IndukCustomer indukCustomer;
    
    public static final String JSP_NAME_INDUK_CUSTOMER = "JSP_NAME_INDUK_CUSTOMER";
    
    public static final int JSP_NAME = 0;
    public static final int JSP_ADDRESS = 1;
    public static final int JSP_CITY = 2;
    public static final int JSP_COUNTRY_ID = 3;
    public static final int JSP_POSTAL_CODE = 4;
    public static final int JSP_CONTACT_PERSON = 5;
    public static final int JSP_POSISI_CONTACT_PERSON = 6;     
    public static final int JSP_COUNTRY_CODE = 7;
    public static final int JSP_AREA_CODE = 8;
    public static final int JSP_PHONE = 9;        
    public static final int JSP_WEBSITE = 10;
    public static final int JSP_EMAIL = 11;
    public static final int JSP_NPWP = 12;
    public static final int JSP_FAX = 13;
    
    public static String[] colNames = {
        "JSP_NAME",          
        "JSP_ADDRESS",
        "JSP_CITY",
        "JSP_COUNTRY_ID",
        "JSP_POSTAL_CODE",
        "JSP_CONTACT_PERSON",
        "JSP_POSISI_CONTACT_PERSON",
        "JSP_COUNTRY_CODE",
        "JSP_AREA_CODE",
        "JSP_PHONE",
        "JSP_WEBSITE",
        "JSP_EMAIL",
        "JSP_NPWP",
        "JSP_FAX"
    };
    
    public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    public JspIndukCustomer() {
    }

    public JspIndukCustomer(IndukCustomer indukCustomer) {
        this.indukCustomer = indukCustomer;
    }

    public JspIndukCustomer(HttpServletRequest request) {
        super(new JspIndukCustomer(), request);
    }
    
    public JspIndukCustomer(HttpServletRequest request, IndukCustomer indukCustomer) {
        super(new JspIndukCustomer(indukCustomer), request);
        this.indukCustomer = indukCustomer;
    }

    public String getFormName() {
        return JSP_NAME_INDUK_CUSTOMER;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public IndukCustomer getEntityObject() {
        return indukCustomer;
    }

    public void requestEntityObject(IndukCustomer indukCustomer) {
        try {
            
            this.requestParam();      
            indukCustomer.setName(getString(JSP_NAME));
            indukCustomer.setAddress(getString(JSP_ADDRESS));
            indukCustomer.setCity(getString(JSP_CITY)); 
            indukCustomer.setCountryId(getLong(JSP_COUNTRY_ID));
            indukCustomer.setPostalCode(getString(JSP_POSTAL_CODE));
            indukCustomer.setContactPerson(getString(JSP_CONTACT_PERSON));
            indukCustomer.setPosisiContactPerson(getString(JSP_POSISI_CONTACT_PERSON));
            indukCustomer.setCountryCode(getString(JSP_COUNTRY_CODE));  
            indukCustomer.setAreaCode(getString(JSP_AREA_CODE));  
            indukCustomer.setPhone(getString(JSP_PHONE));  
            indukCustomer.setWebsite(getString(JSP_WEBSITE));
            indukCustomer.setEmail(getString(JSP_EMAIL));
            indukCustomer.setNpwp(getString(JSP_NPWP));
            indukCustomer.setFax(getString(JSP_FAX));
			
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    } 
}
