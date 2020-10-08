/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.sales;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class JspGiroTransaction extends JSPHandler implements I_JSPInterface, I_JSPType {

    private GiroTransaction giroTransaction;
    
    public static final String JSP_NAME_GIRO_TRANSACTION = "JSP_GIRO_TRANSACTION";
    
    public static final int JSP_GIRO_TRANSACTION_ID = 0;    
    public static final int JSP_TRANSACTION_TYPE = 1;
    public static final int JSP_SOURCE_ID = 2;
    public static final int JSP_COA_ID = 3;
    public static final int JSP_DATE_TRANSACTION = 4;
    public static final int JSP_DUE_DATE = 5;
    public static final int JSP_STATUS = 6;
    public static final int JSP_GIRO_ID = 7;
    public static final int JSP_AMOUNT = 8;    
    public static final int JSP_CUSTOMER_ID = 9;
    public static final int JSP_NUMBER = 10;
    public static final int JSP_SEGMENT1_ID = 11;
    public static final int JSP_NUMBER_PREFIX = 12;
    public static final int JSP_COUNTER = 13;
    public static final int JSP_SEGMENT1_ID_POSTED = 14;
    
    public static String[] colNames = {
        "JSP_GIRO_TRANSACTION_ID",
        "JSP_TRANSACTION_TYPE",
        "JSP_SOURCE_ID",
        "JSP_COA_ID",
        "JSP_DATE_TRANSACTION",
        "JSP_DUE_DATE",
        "JSP_STATUS",
        "JSP_GIRO_ID",
        "JSP_AMOUNT",
        "JSP_CUSTOMER_ID",
        "JSP_NUMBER",
        "JSP_SEGMENT1_ID",
        "JSP_NUMBER_PREFIX",
        "JSP_COUNTER",
        "JSP_SEGMENT1_ID_POSTED"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG
    };

    public JspGiroTransaction() {
    }

    public JspGiroTransaction(GiroTransaction giroTransaction) {
        this.giroTransaction = giroTransaction;
    }

    public JspGiroTransaction(HttpServletRequest request, GiroTransaction giroTransaction) {
        super(new JspGiroTransaction(giroTransaction), request);
        this.giroTransaction = giroTransaction;
    }

    public String getFormName() {
        return JSP_NAME_GIRO_TRANSACTION;
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

    public GiroTransaction getEntityObject() {
        return giroTransaction;
    }

    public void requestEntityObject(GiroTransaction giroTransaction) {
        try {
            this.requestParam();            
            giroTransaction.setTransactionType(getInt(JSP_TRANSACTION_TYPE));
            giroTransaction.setSourceId(getLong(JSP_SOURCE_ID));
            giroTransaction.setCoaId(getLong(JSP_COA_ID));
            giroTransaction.setDateTransaction(getDate(JSP_DATE_TRANSACTION));
            giroTransaction.setDueDate(getDate(JSP_DUE_DATE));
            giroTransaction.setStatus(getInt(JSP_STATUS));
            giroTransaction.setGiroId(getLong(JSP_GIRO_ID));
            giroTransaction.setAmount(getDouble(JSP_AMOUNT));            
            giroTransaction.setCustomerId(getLong(JSP_CUSTOMER_ID));
            giroTransaction.setNumber(getString(JSP_NUMBER));            
            giroTransaction.setSegmentId(getLong(JSP_SEGMENT1_ID));                  
            giroTransaction.setNumberPrefix(getString(JSP_NUMBER_PREFIX));  
            giroTransaction.setCounter(getInt(JSP_COUNTER));  
            giroTransaction.setSegment1IdPosted(getLong(JSP_SEGMENT1_ID_POSTED));  
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

