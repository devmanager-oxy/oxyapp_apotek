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
public class JspFloorFac extends JSPHandler implements I_JSPInterface, I_JSPType{
    
    private FloorFac floorFac;
    public static final String JSP_NAME_FLOOR_FAC = "JSP_FLOOR_FAC";
    
    public static final int JSP_FLOOR_FAC_ID = 0;
    public static final int JSP_FLOOR_ID = 1;
    public static final int JSP_FLOOR_FACILITIES_ID = 2;
    public static final int JSP_QTY = 3;
    
    public static final String[] colNames = {
        "JSP_FLOOR_FAC_ID",
        "JSP_FLOOR_ID",
        "JSP_FLOOR_FACILITIES_ID",        
        "JSP_QTY"
    };     
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT
    };    
    
    public JspFloorFac() {
    }

    public JspFloorFac(FloorFac floorFac) {
        this.floorFac = floorFac;
    }

    public JspFloorFac(HttpServletRequest request, FloorFac floorFac) {
        super(new JspFloorFac(floorFac), request);
        this.floorFac = floorFac;
    }

    public String getFormName() {
        return JSP_NAME_FLOOR_FAC;
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

    public FloorFac getEntityObject() {
        return floorFac;
    }

    public void requestEntityObject(FloorFac floorFac) {
        try {
            this.requestParam();
            
            floorFac.setFloorId(getLong(JSP_FLOOR_ID));
            floorFac.setFloorFacilitiesId(getLong(JSP_FLOOR_FACILITIES_ID));            
            floorFac.setQty(getInt(JSP_QTY));            
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
