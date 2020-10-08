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
/**
 *
 * @author Roy Andika
 */
public class JspBuildingFac extends JSPHandler implements I_JSPInterface, I_JSPType{
    
    private BuildingFac buildingFac;
    public static final String JSP_NAME_BUILDING_FAC = "JSP_BUILDING_FAC";
    
    public static final int JSP_BUILDING_FAC_ID = 0;
    public static final int JSP_BUILDING_ID = 1;
    public static final int JSP_BUILDING_FACILITIES_ID = 2;
    public static final int JSP_QTY = 3;
    
    public static final String[] colNames = {
        "JSP_BUILDING_FAC_ID",
        "JSP_BUILDING_ID",
        "JSP_BUILDING_FACILITIES_ID",        
        "JSP_QTY"
    };     
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT
    };    
    
    
    public JspBuildingFac() {
    }

    public JspBuildingFac(BuildingFac buildingFac) {
        this.buildingFac = buildingFac;
    }

    public JspBuildingFac(HttpServletRequest request, BuildingFac buildingFac) {
        super(new JspBuildingFac(buildingFac), request);
        this.buildingFac = buildingFac;
    }

    public String getFormName() {
        return JSP_NAME_BUILDING_FAC;
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

    public BuildingFac getEntityObject() {
        return buildingFac;
    }

    public void requestEntityObject(BuildingFac buildingFac) {
        try {
            this.requestParam();
            
            buildingFac.setBuildingId(getLong(JSP_BUILDING_ID));
            buildingFac.setBuildingFacilitiesId(getLong(JSP_BUILDING_FACILITIES_ID));            
            buildingFac.setQty(getInt(JSP_QTY));            
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
