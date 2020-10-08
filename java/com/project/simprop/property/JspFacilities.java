/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class JspFacilities extends JSPHandler implements I_JSPInterface, I_JSPType {
    
    private Facilities facilities;
    public static final String JSP_NAME_FACILITIES = "JSP_FACILITIES";
    
    public static final int JSP_FACILITIES_ID = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_DISCRIPTION = 2;
    
    public static final String[] colNames = {
        "JSP_FACILITIES_ID",
        "JSP_NAME",
        "JSP_DISCRIPTION"
    };     
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING
    };    
    
    
    public JspFacilities() {
    }

    public JspFacilities(Facilities facilities) {
        this.facilities = facilities;
    }

    public JspFacilities(HttpServletRequest request, Facilities facilities) {
        super(new JspFacilities(facilities), request);
        this.facilities = facilities;
    }

    public String getFormName() {
        return JSP_NAME_FACILITIES;
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

    public Facilities getEntityObject() {
        return facilities;
    }

    public void requestEntityObject(Facilities facilities) {
        try {
            this.requestParam();            
            facilities.setName(getString(JSP_NAME));
            facilities.setDiscription(getString(JSP_DISCRIPTION));            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
