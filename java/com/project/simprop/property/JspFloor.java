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
public class JspFloor extends JSPHandler implements I_JSPInterface, I_JSPType{
    
    private Floor floor;
    
    public static final String JSP_NAME_FLOOR = "JSP_FLOOR";
    
    public static final int JSP_FLOOR_ID = 0;
    public static final int JSP_NO = 1;
    public static final int JSP_NAME = 2;
    public static final int JSP_DISCRIPTION = 3;
    public static final int JSP_FACILITIES = 4;
    public static final int JSP_LOT_QTY = 5;
    public static final int JSP_CURRENCY_ID = 6;
    public static final int JSP_LOT_PRICE = 7;
    public static final int JSP_PROPERTY_ID = 8;
    public static final int JSP_NAME_PIC = 9;
    public static final int JSP_BOOKED_RATE = 10;
    public static final int JSP_FOREIGN_AMOUNT = 11;
    public static final int JSP_BUILDING_ID = 12;
    
    public static final String[] colNames = {
        "JSP_FLOOR_ID",
        "JSP_NO",
        "JSP_NAME",
        "JSP_DISCRIPTION",        
        "JSP_FACILITIES",
        "JSP_LOT_QTY",
        "JSP_CURRENCY_ID",
        "JSP_LOT_PRICE",
        "JSP_PROPERTY_ID",
        "JSP_NAME_PIC",
        "JSP_BOOKED_RATE",
        "JSP_FOREIGN_AMOUNT",
        "JSP_BUILDING_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_INT + ENTRY_REQUIRED ,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG
    };

    public JspFloor() {
    }

    public JspFloor(Floor floor) {
        this.floor = floor;
    }

    public JspFloor(HttpServletRequest request, Floor floor) {
        super(new JspFloor(floor), request);
        this.floor = floor;
    }

    public String getFormName() {
        return JSP_NAME_FLOOR;
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

    public Floor getEntityObject() {
        return floor;
    }

    public void requestEntityObject(Floor floor) {
        try {
            this.requestParam();
            
            floor.setNo(getInt(JSP_NO));
            floor.setName(getString(JSP_NAME));
            floor.setDiscription(getString(JSP_DISCRIPTION));
            floor.setFacilities(getString(JSP_FACILITIES));
            floor.setLotQty(getInt(JSP_LOT_QTY));
            floor.setCurrencyId(getLong(JSP_CURRENCY_ID));
            floor.setLotPrice(getDouble(JSP_LOT_PRICE));
            floor.setPropertyId(getLong(JSP_PROPERTY_ID));
            floor.setNamePic(getString(JSP_NAME_PIC));            
            floor.setBookedRate(getDouble(JSP_BOOKED_RATE));
            floor.setForeignAmount(getDouble(JSP_FOREIGN_AMOUNT));
            floor.setBuildingId(getLong(JSP_BUILDING_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}



