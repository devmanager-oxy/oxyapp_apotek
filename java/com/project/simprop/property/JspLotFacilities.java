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
public class JspLotFacilities extends JSPHandler implements I_JSPInterface, I_JSPType {

    private LotFacilities lotFacilities;
    public static final String JSP_NAME_LOT_FACILITIES = "JSP_LOT_FACILITIES";
    
    public static final int JSP_LOT_FACILITIES_ID = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_DESCRIPTION = 2;
    
    public static final String[] colNames = {
        "JSP_LOT_FACILITIES_ID",
        "JSP_NAME",
        "JSP_DESCRIPTION"
    };     
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING
    };    
    
    
    public JspLotFacilities() {
    }

    public JspLotFacilities(LotFacilities lotFacilities) {
        this.lotFacilities = lotFacilities;
    }

    public JspLotFacilities(HttpServletRequest request, LotFacilities lotFacilities) {
        super(new JspLotFacilities(lotFacilities), request);
        this.lotFacilities = lotFacilities;
    }

    public String getFormName() {
        return JSP_NAME_LOT_FACILITIES;
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

    public LotFacilities getEntityObject() {
        return lotFacilities;
    }

    public void requestEntityObject(LotFacilities lotFacilities) {
        try {
            this.requestParam();            
            lotFacilities.setName(getString(JSP_NAME));
            lotFacilities.setDescription(getString(JSP_DESCRIPTION));            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
