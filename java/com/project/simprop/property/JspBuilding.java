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
public class JspBuilding extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Building building;
    public static final String JSP_NAME_BUILDING = "JSP_BUILDING";
    public static final int JSP_BUILDING_ID = 0;
    public static final int JSP_PROPERTY_ID = 1;
    public static final int JSP_SALES_TYPE = 2;
    public static final int JSP_BUILDING_NAME = 3;    
    public static final int JSP_BUILDING_TYPE = 4;
    public static final int JSP_NUMBER_OF_FLOOR = 5;
    public static final int JSP_SELECT_FACILITIES_OTHER = 6;
    public static final int JSP_NAME_FACILITIES_OTHER = 7;
    public static final int JSP_DESCRIPTION = 8;
    public static final int JSP_BUILDING_STATUS = 9;
    public static final int JSP_NAME_PIC = 10;
    
    public static final String[] colNames = {
        "JSP_BUILDING_ID",
        "JSP_PROPERTY_ID",
        "JSP_SALES_TYPE",
        "JSP_BUILDING_NAME",      
        "JSP_BUILDING_TYPE",        
        "JSP_NUMBER_OF_FLOOR",
        "JSP_SELECT_FACILITIES_NUMBER",
        "JSP_NAME_FACILITIES_OTHER",
        "JSP_DESCRIPTION",
        "JSP_BULDING_STATUS",
        "JSP_NAME_PIC"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED, 
        TYPE_INT,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_INT,        
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING        
    };

    public JspBuilding() {
    }

    public JspBuilding(
            Building building) {
        this.building = building;
    }

    public JspBuilding(HttpServletRequest request, Building building) {
        super(new JspBuilding(building), request);
        this.building = building;
    }

    public String getFormName() {
        return JSP_NAME_BUILDING;
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

    public Building getEntityObject() {
        return building;
    }

    public void requestEntityObject(Building building) {
        try {
            this.requestParam();

            building.setPropertyId(getLong(JSP_PROPERTY_ID));
            building.setSalesType(getInt(JSP_SALES_TYPE));
            building.setBuildingName(getString(JSP_BUILDING_NAME));            
            building.setBuildingType(getInt(JSP_BUILDING_TYPE));            
            building.setNumberOfFloor(getInt(JSP_NUMBER_OF_FLOOR));
            building.setSelectFacilitiesOther(getInt(JSP_SELECT_FACILITIES_OTHER));
            building.setNameFacilitiesOther(getString(JSP_NAME_FACILITIES_OTHER));
            building.setDescription(getString(JSP_DESCRIPTION));
            building.setBuildingStatus(getInt(JSP_BUILDING_STATUS));
            building.setNamePic(getString(JSP_NAME_PIC));            

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
