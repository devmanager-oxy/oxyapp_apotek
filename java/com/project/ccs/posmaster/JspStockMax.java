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

public class JspStockMax extends JSPHandler implements I_JSPInterface, I_JSPType {

    private StockMax stockMax;
    
    public static final String JSP_NAME_STOCK_MAX = "JSP_STOCK_MAX";        
    
    public static final int JSP_STOCK_MAX_ID   = 0;
    public static final int JSP_LOCATION_ID    = 1;
    public static final int JSP_ITEM_MASTER_ID   = 2;
    public static final int JSP_ITEM_NAME     = 3;
    public static final int JSP_CODE     = 4;
    public static final int JSP_BARCODE     = 5;
    public static final int JSP_MAX_STOCK     = 6;
    
    
    public static String[] colNames = {
        "JSP_STOCK_MAX_ID", 
        "JSP_LOCATION_ID",
        "JSP_ITEM_MASTER_ID",
        "JSP_ITEM_NAME",
        "JSP_CODE",
        "JSP_BARCODE",
        "JSP_MAX_STOCK"
        
    };
    
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT + ENTRY_REQUIRED
    };
    
    
    public JspStockMax() {
    }

    public JspStockMax(StockMax stockMax) {
        this.stockMax = stockMax;
    }

    public JspStockMax(HttpServletRequest request, StockMax stockMax) {
        super(new JspStockMax(stockMax), request);
        this.stockMax = stockMax;
    }

    public String getFormName() {
        return JSP_NAME_STOCK_MAX ;
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

    public StockMax getEntityObject() {
        return stockMax;
    }

    public void requestEntityObject(StockMax stockMax) {
        try {
            this.requestParam();
         
            stockMax.setLocationId(getLong(JSP_LOCATION_ID));
            stockMax.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            stockMax.setItemName(getString(JSP_ITEM_NAME));
            stockMax.setCode(getString(JSP_CODE));
            stockMax.setBarcode(getString(JSP_BARCODE));
            stockMax.setMaxStock(getDouble(JSP_MAX_STOCK));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
