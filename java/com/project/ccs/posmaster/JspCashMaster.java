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
public class JspCashMaster extends JSPHandler implements I_JSPInterface, I_JSPType {

    private CashMaster cashMaster;
    
    public static final String JSP_NAME_CASH_MASTER = "JSP_CASH_MASTER";        
    
    public static final int JSP_CASH_MASTER_ID   = 0;
    public static final int JSP_CASHIER_NUMBER            = 1;
    public static final int JSP_LOCATION_ID     = 2;
    
    
    public static String[] colNames = {
        "JSP_CASH_MASTER_ID", 
        "JSP_CASHIER_NUMBER",
        "JSP_LOCATION_ID"
        
    };
    
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_INT,
        TYPE_LONG
            
    };
    
    
    public JspCashMaster() {
    }

    public JspCashMaster(CashMaster cashMaster) {
        this.cashMaster = cashMaster;
    }

    public JspCashMaster(HttpServletRequest request, CashMaster cashMaster) {
        super(new JspCashMaster(cashMaster), request);
        this.cashMaster = cashMaster;
    }

    public String getFormName() {
        return JSP_NAME_CASH_MASTER ;
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

    public CashMaster getEntityObject() {
        return cashMaster;
    }

    public void requestEntityObject(CashMaster cashMaster) {
        try {
            this.requestParam();
         
            cashMaster.setCashierNumber(getInt(JSP_CASHIER_NUMBER));
            cashMaster.setLocationId(getLong(JSP_LOCATION_ID));
            
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
