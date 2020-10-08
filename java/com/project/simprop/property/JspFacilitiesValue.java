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
public class JspFacilitiesValue extends JSPHandler implements I_JSPInterface, I_JSPType {

    
    private FacilitiesValue facilitiesValue;
    
    public static final String JSP_NAME_FACILITIES_VALUE = "JSP_FACILITIES_VALUE";
    
    public static final int JSP_FACILITIES_VALUE_ID = 0;
    public static final int JSP_FLOOR_ID = 1;
    public static final int JSP_FACILITIES_ID = 2;
    public static final int JSP_URUTAN = 3;    
    public static final int JSP_DESCRIPTION = 4;
    public static final int JSP_VALUE = 5;
    
    public static final String[] colNames = {
        "JSP_XXFACILITIES_VALUE_ID",
        "JSP_XXFLOOR_ID",
        "JSP_XXFACILITIES_ID",
        "JSP_XXURUTAN",      
        "JSP_XXDESCRIPTION",        
        "JSP_XXVALUE"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG, 
        TYPE_LONG, 
        TYPE_INT,        
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING        
    };

    public JspFacilitiesValue() {
    }

    public JspFacilitiesValue(
            FacilitiesValue facilitiesValue) {
        this.facilitiesValue = facilitiesValue;
    }

    public JspFacilitiesValue(HttpServletRequest request, FacilitiesValue facilitiesValue) {
        super(new JspFacilitiesValue(facilitiesValue), request);
        this.facilitiesValue = facilitiesValue;
    }

    public String getFormName() {
        return JSP_NAME_FACILITIES_VALUE;
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

    public FacilitiesValue getEntityObject() {
        return facilitiesValue;
    }

    public void requestEntityObject(FacilitiesValue facilitiesValue) {
        try {
            this.requestParam();

            facilitiesValue.setFloorId(getLong(JSP_FLOOR_ID));
            facilitiesValue.setFacilitiesId(getLong(JSP_FACILITIES_ID));
            facilitiesValue.setUrutan(getInt(JSP_URUTAN));            
            facilitiesValue.setDescription(getString(JSP_DESCRIPTION));            
            facilitiesValue.setValue(getString(JSP_VALUE));            

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
