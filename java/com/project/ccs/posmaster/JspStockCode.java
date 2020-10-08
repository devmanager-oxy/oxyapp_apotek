/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class JspStockCode extends JSPHandler implements I_JSPInterface, I_JSPType {

    private StockCode stockCode;
    
    public static final String JSP_NAME_STOCK_CODE = "JSP_STOCK_CODE";        
    
    public static final int JSP_STOCK_CODE_ID   = 0;
    public static final int JSP_CODE            = 1;
    public static final int JSP_LOCATION_ID     = 2;
    public static final int JSP_ITEM_MASTER_ID  = 3;
    public static final int JSP_IN_OUT          = 4;
    public static final int JSP_TYPE            = 5;
    public static final int JSP_RECEIVE_ID      = 6;
    public static final int JSP_RETUR_ID        = 7;
    public static final int JSP_TRANSFER_ID     = 8;
    public static final int JSP_QTY             = 9;
    public static final int JSP_STATUS          = 10;    
    public static final int JSP_RECEIVE_ITEM_ID = 11;
    public static final int JSP_TRANSFER_ITEM_ID= 12;
    public static final int JSP_RETUR_ITEM_ID   = 13;
    public static final int JSP_TYPE_ITEM   = 14;
    public static final int JSP_SALES_ID =15;
    public static final int JSP_SALES_DETAIL_ID =16;
    
    public static String[] colNames = {
        "JSP_STOCK_CODE_ID", 
        "JSP_STOCK",
        "JSP_LOCATION_ID",
        "JSP_ITEM_MASTER_ID",
        "JSP_IN_OUT",
        "JSP_TYPE",
        "JSP_RECEIVE_ID",
        "JSP_RETUR_ID",
        "JSP_TRANSFER_ID",
        "JSP_QTY",
        "JSP_STATUS",
        "JSP_RECEIVE_ITEM_ID",
        "JSP_TRANSFER_ITEM_ID",
        "JSP_RETUR_ITEM_ID",
        "JSP_TYPE_ITEM",
        "JSP_SALES_ID",
        "JSP_SALES_DETAIL_ID"
    };
    
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG
    
    };
    
    
    public JspStockCode() {
    }

    public JspStockCode(StockCode stockCode) {
        this.stockCode = stockCode;
    }

    public JspStockCode(HttpServletRequest request, StockCode stockCode) {
        super(new JspStockCode(stockCode), request);
        this.stockCode = stockCode;
    }

    public String getFormName() {
        return JSP_NAME_STOCK_CODE;
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

    public StockCode getEntityObject() {
        return stockCode;
    }

    public void requestEntityObject(StockCode stockCode) {
        try {
            this.requestParam();
         
            stockCode.setCode(getString(JSP_CODE));
            stockCode.setLocationId(getLong(JSP_LOCATION_ID));
            stockCode.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            stockCode.setInOut(getInt(JSP_IN_OUT));
            stockCode.setType(getInt(JSP_TYPE));
            stockCode.setReceiveId(getLong(JSP_RECEIVE_ID));
            stockCode.setReturId(getLong(JSP_RETUR_ID));
            stockCode.setTransferId(getLong(JSP_TRANSFER_ID));
            stockCode.setQty(getDouble(JSP_QTY));
            stockCode.setReceiveItemId(getLong(JSP_RECEIVE_ITEM_ID));
            stockCode.setTransferItemId(getLong(JSP_TRANSFER_ITEM_ID));
            stockCode.setReturItemId(getLong(JSP_RETUR_ITEM_ID));            
            
            stockCode.setStatus(getInt(JSP_STATUS));
            stockCode.setType_item(getInt(JSP_TYPE_ITEM));
            stockCode.setSalesId(getLong(JSP_SALES_ID));
            stockCode.setSalesDetailId(getLong(JSP_SALES_DETAIL_ID));
            
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
