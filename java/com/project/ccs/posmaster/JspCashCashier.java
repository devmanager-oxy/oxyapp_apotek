/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy Andika
 */
public class JspCashCashier extends JSPHandler implements I_JSPInterface, I_JSPType {

    private CashCashier cashCashier;
    
    public static final String JSP_NAME_CASH_CASHIER = "JSP_CASH_CASHIER";        
    
    public static final int JSP_CASH_CASHIER_ID = 0;
    public static final int JSP_CASH_MASTER_ID  = 1;
    public static final int JSP_USER_ID         = 2;
    public static final int JSP_SHIFT_ID        = 3;
    public static final int JSP_DATE_OPEN           = 4;
    public static final int JSP_CURRENCY_ID_OPEN            = 5;
    public static final int JSP_RATE_OPEN     = 6;
    public static final int JSP_AMOUNT_OPEN          = 7;
    public static final int JSP_DATE_CLOSING           = 8;
    public static final int JSP_CURRENCY_ID_CLOSING            = 9;
    public static final int JSP_RATE_CLOSING     = 10;
    public static final int JSP_AMOUNT_CLOSING          = 11;
    public static final int JSP_STATUS         = 12;
    public static String[] colNames = {
        "JSP_CASH_CASHIER_ID",
        "JSP_CASH_MASTER_ID", 
        "JSP_USER_ID",
        "JSP_SHIFT_ID",
        "JSP_DATE_OPEN",
        "JSP_CURRENCY_ID_OPEN",
        "JSP_RATE_OPEN",
        "JSP_AMOUNT_OPEN",
        "JSP_DATE_CLOSING",
        "JSP_CURRENCY_ID_CLOSING",
        "JSP_RATE_CLOSING",
        "JSP_AMOUNT_CLOSING",
        "JSP_STATUS"
    };
    
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT
    };
    
    
    public JspCashCashier() {
    }

    public JspCashCashier(CashCashier cashCashier) {
        this.cashCashier = cashCashier;
    }

    public JspCashCashier(HttpServletRequest request, CashCashier cashCashier) {
        super(new JspCashCashier(cashCashier), request);
        this.cashCashier = cashCashier;
    }

    public String getFormName() {
        return JSP_NAME_CASH_CASHIER ;
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

    public CashCashier getEntityObject() {
        return cashCashier;
    }

    public void requestEntityObject(CashCashier cashCashier) {
        try {
            this.requestParam();
         
            cashCashier.setCashMasterId(getLong(JSP_CASH_MASTER_ID));
            cashCashier.setUserId(getLong(JSP_USER_ID));
            cashCashier.setShiftId(getLong(JSP_SHIFT_ID));
            cashCashier.setDateOpen(JSPFormater.formatDate(getString(JSP_DATE_OPEN), "dd/MM/yyyy"));
            cashCashier.setCurrencyIdOpen(getLong(JSP_CURRENCY_ID_OPEN));
            cashCashier.setRateOpen(getDouble(JSP_RATE_OPEN));
            cashCashier.setAmountOpen(getDouble(JSP_AMOUNT_OPEN));
            cashCashier.setDateClosing(getDate(JSP_DATE_CLOSING));
            cashCashier.setDateClosing(JSPFormater.formatDate(getString(JSP_DATE_CLOSING), "dd/MM/yyyy"));
            cashCashier.setCurrencyIdClosing(getLong(JSP_CURRENCY_ID_CLOSING));
            cashCashier.setRateClosing(getDouble(JSP_RATE_CLOSING));
            cashCashier.setAmountClosing(getDouble(JSP_AMOUNT_CLOSING));
            cashCashier.setStatus(getInt(JSP_AMOUNT_CLOSING));
            
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
