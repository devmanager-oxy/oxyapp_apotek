/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy Andika
 */
public class JspProperty extends JSPHandler implements I_JSPInterface, I_JSPType, I_Language {

    private Property property;
    public static final String JSP_NAME_PROPERTY = "JSP_PROPERTY";
    
    public static final int JSP_PROPERTY_ID = 0;
    public static final int JSP_SALES_TYPE = 1;
    public static final int JSP_BUILDING_NAME = 2;
    public static final int JSP_LOCATION_ID = 3;
    public static final int JSP_ADDRESS = 4;
    public static final int JSP_PROPERTY_TYPE = 5;
    public static final int JSP_IMB_NUMBER = 6;
    public static final int JSP_OWNER = 7;
    public static final int JSP_LAND_SERTIFICATE_NUMBER = 8;
    public static final int JSP_NUMBER_OF_FLOOR = 9;
    public static final int JSP_SELECT_FACILITIES_OTHER = 10;
    public static final int JSP_NAME_FACILITIES_OTHER = 11;
    public static final int JSP_DESCRIPTION = 12;
    public static final int JSP_PROPERTY_STATUS = 13;
    public static final int JSP_LOCATION_MAP = 14;
    public static final int JSP_CITY = 15;    
    public static final int JSP_LAND_AREA = 16;
    public static final int JSP_BUILDING_AREA = 17;
    public static final int JSP_COMMENCEMENT = 18;
    public static final int JSP_COMPLETION = 19;
    public static final int JSP_DEVELOPER = 20;
    
    int language = I_Language.LANGUAGE_DEFAULT;
    
    public static final String[] colNames = {
        "JSP_PROPERTY_ID",
        "JSP_SALES_TYPE",
        "JSP_BUILDING_NAME",
        "JSP_LOCATION_ID",
        "JSP_ADDRESS",
        "JSP_PROPERTY_TYPE",
        "JSP_IMB_NUMBER",
        "JSP_OWNER",
        "JSP_LAND_SERTIFICATE_NUMBER",
        "JSP_NUMBER_OF_FLOOR",
        "JSP_SELETC_FACILITIES_NUMBER",
        "JSP_NAME_FACILITIES_OTHER",
        "JSP_DESCRIPTION",
        "JSP_PROPERTY_STATUS",
        "JSP_LOCATION_MAP",
        "JSP_CITY",
        "JSP_LAND_AREA",
        "JSP_BUILDING_AREA",
        "JSP_COMMENCEMENT",
        "JSP_COMPLETION",
        "JSP_DEVELOPER"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    public JspProperty() {
    }

    public JspProperty(
            Property property) {
        this.property = property;
    }

    public JspProperty(HttpServletRequest request, Property property) {
        super(new JspProperty(property), request);
        this.property = property;
    }
    
    public JspProperty(HttpServletRequest request, Property property, int lang) {
        super(new JspProperty(property), request, lang);
        this.property = property;        
    }

    public String getFormName() {
        return JSP_NAME_PROPERTY;
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

    public Property getEntityObject() {
        return property;
    }

    public void requestEntityObject(Property property) {
        try {
            this.requestParam();
            
            property.setSalesType(getInt(JSP_SALES_TYPE));
            property.setBuildingName(getString(JSP_BUILDING_NAME));
            property.setLocationId(getLong(JSP_LOCATION_ID));
            property.setAddress(getString(JSP_ADDRESS));
            property.setPropertyType(getInt(JSP_PROPERTY_TYPE));
            property.setImbNumber(getString(JSP_IMB_NUMBER));
            property.setOwner(getString(JSP_OWNER));
            property.setLandSertificateNumber(getString(JSP_LAND_SERTIFICATE_NUMBER));
            property.setNumberOfFloor(getInt(JSP_NUMBER_OF_FLOOR));
            property.setSelectFacilitiesOther(getInt(JSP_SELECT_FACILITIES_OTHER));
            property.setNameFacilitiesOther(getString(JSP_NAME_FACILITIES_OTHER));
            property.setDescription(getString(JSP_DESCRIPTION));
            property.setPropertyStatus(getInt(JSP_PROPERTY_STATUS));
            property.setLocationMap(getString(JSP_LOCATION_MAP));
            property.setCity(getString(JSP_CITY));            
            property.setLandArea(getString(JSP_LAND_AREA));
            property.setBuildingArea(getString(JSP_BUILDING_AREA));
            property.setCommencement(JSPFormater.formatDate(getString(JSP_COMMENCEMENT), "dd/MM/yyyy"));
            property.setCompletion(JSPFormater.formatDate(getString(JSP_COMPLETION), "dd/MM/yyyy"));
            property.setDeveloper(getString(JSP_DEVELOPER));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

