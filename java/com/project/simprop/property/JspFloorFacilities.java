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
public class JspFloorFacilities extends JSPHandler implements I_JSPInterface, I_JSPType {

    private FloorFacilities floorFacilities;
    public static final String JSP_NAME_FLOOR_FACILITIES = "JSP_FLOOR_FACILITIES";
    
    public static final int JSP_FLOOR_FACILITIES_ID = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_DESCRIPTION = 2;
    
    public static final String[] colNames = {
        "JSP_FLOOR_FACILITIES_ID",
        "JSP_NAME",
        "JSP_DESCRIPTION"
    };     
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING
    };    
    
    
    public JspFloorFacilities() {
    }

    public JspFloorFacilities(FloorFacilities floorFacilities) {
        this.floorFacilities = floorFacilities;
    }

    public JspFloorFacilities(HttpServletRequest request, FloorFacilities floorFacilities) {
        super(new JspFloorFacilities(floorFacilities), request);
        this.floorFacilities = floorFacilities;
    }

    public String getFormName() {
        return JSP_NAME_FLOOR_FACILITIES;
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

    public FloorFacilities getEntityObject() {
        return floorFacilities;
    }

    public void requestEntityObject(FloorFacilities floorFacilities) {
        try {
            this.requestParam();            
            floorFacilities.setName(getString(JSP_NAME));
            floorFacilities.setDescription(getString(JSP_DESCRIPTION));            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
