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
public class JspLotFac extends JSPHandler implements I_JSPInterface, I_JSPType{
    
    private LotFac lotFac;
    public static final String JSP_NAME_LOT_FAC = "JSP_LOT_FAC";
    
    public static final int JSP_LOT_FAC_ID = 0;
    public static final int JSP_LOT_ID = 1;
    public static final int JSP_LOT_FACILITIES_ID = 2;
    public static final int JSP_QTY = 3;
    
    public static final String[] colNames = {
        "JSP_LOT_FAC_ID",
        "JSP_LOT_ID",
        "JSP_LOT_FACILITIES_ID",        
        "JSP_QTY"
    };     
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT
    };    
    
    
    public JspLotFac() {
    }

    public JspLotFac(LotFac lotFac) {
        this.lotFac = lotFac;
    }

    public JspLotFac(HttpServletRequest request, LotFac lotFac) {
        super(new JspLotFac(lotFac), request);
        this.lotFac = lotFac;
    }

    public String getFormName() {
        return JSP_NAME_LOT_FAC;
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

    public LotFac getEntityObject() {
        return lotFac;
    }

    public void requestEntityObject(LotFac lotFac) {
        try {
            this.requestParam();
            
            lotFac.setLotId(getLong(JSP_LOT_ID));
            lotFac.setLotFacilitiesId(getLong(JSP_LOT_FACILITIES_ID));            
            lotFac.setQty(getInt(JSP_QTY));            
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
