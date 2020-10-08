/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;

/**
 *
 * @author Ngurah Wirata
 */
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspStockMin extends JSPHandler implements I_JSPInterface, I_JSPType {

    private StockMinItem stockMin;
    
    public static final String JSP_NAME_STOCK_MIN = "JSP_STOCK_MIN";        
    
    public static final int JSP_STOCK_MIN_ID   = 0;
    public static final int JSP_LOCATION_ID    = 1;
    public static final int JSP_ITEM_MASTER_ID   = 2;
    public static final int JSP_ITEM_NAME     = 3;
    public static final int JSP_CODE     = 4;
    public static final int JSP_BARCODE     = 5;
    public static final int JSP_MIN_STOCK     = 6;
    public static final int JSP_DELIVERY_UNIT =7;
    
    public static String[] colNames = {
        "JSP_STOCK_MIN_ID", 
        "JSP_LOCATION_ID",
        "JSP_ITEM_MASTER_ID",
        "JSP_ITEM_NAME",
        "JSP_CODE",
        "JSP_BARCODE",
        "JSP_MIN_STOCK",
        "JSP_DELIVERY_UNIT"
        
    };
    
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT
    };
    
    
    public JspStockMin() {
    }

    public JspStockMin(StockMinItem stockMin) {
        this.stockMin = stockMin;
    }

    public JspStockMin(HttpServletRequest request, StockMinItem stockMin) {
        super(new JspStockMin(stockMin), request);
        this.stockMin = stockMin;
    }

    public String getFormName() {
        return JSP_NAME_STOCK_MIN ;
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

    public StockMinItem getEntityObject() {
        return stockMin;
    }

    public void requestEntityObject(StockMinItem stockMin) {
        try {
            this.requestParam();
         
            stockMin.setLocationId(getLong(JSP_LOCATION_ID));
            stockMin.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            stockMin.setItemName(getString(JSP_ITEM_NAME));
            stockMin.setCode(getString(JSP_CODE));
            stockMin.setBarcode(getString(JSP_BARCODE));
            stockMin.setMinStock(getDouble(JSP_MIN_STOCK));
            stockMin.setDeliveryUnit(getDouble(JSP_DELIVERY_UNIT));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
