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
public class JspBuildingFacilities extends JSPHandler implements I_JSPInterface, I_JSPType {

    private BuildingFacilities buildingFacilities;
    public static final String JSP_NAME_BUILDING_FACILITIES = "JSP_BUILDING_FACILITIES";
    
    public static final int JSP_BUILDING_FACILITIES_ID = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_DESCRIPTION = 2;
    
    public static final String[] colNames = {
        "JSP_BUILDING_FACILITIES_ID",
        "JSP_NAME",
        "JSP_DESCRIPTION"
    };     
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING
    };    
    
    
    public JspBuildingFacilities() {
    }

    public JspBuildingFacilities(BuildingFacilities buildingFacilities) {
        this.buildingFacilities = buildingFacilities;
    }

    public JspBuildingFacilities(HttpServletRequest request, BuildingFacilities buildingFacilities) {
        super(new JspBuildingFacilities(buildingFacilities), request);
        this.buildingFacilities = buildingFacilities;
    }

    public String getFormName() {
        return JSP_NAME_BUILDING_FACILITIES;
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

    public BuildingFacilities getEntityObject() {
        return buildingFacilities;
    }

    public void requestEntityObject(BuildingFacilities buildingFacilities) {
        try {
            this.requestParam();            
            buildingFacilities.setName(getString(JSP_NAME));
            buildingFacilities.setDescription(getString(JSP_DESCRIPTION));            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
