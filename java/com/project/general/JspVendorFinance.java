/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy
 */
public class JspVendorFinance extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Vendor vendor;
    
    public static final String JSP_NAME_VENDOR = "jsp_vendor_finance";
    
    public static final int JSP_NAME        = 0;
    public static final int JSP_VENDOR_ID   = 1;
    public static final int JSP_CODE        = 2;
    public static final int JSP_ADDRESS     = 3;    
    public static final int JSP_CONTACT     = 4;    
    public static final int JSP_NO_REK      = 5;
    public static final int JSP_BANK_ID     = 6;
    public static final int JSP_PAYMENT_TYPE= 7;
    
    public static String[] colNames = {
        "JSP_NAME",
        "JSP_VENDOR_ID",
        "JSP_CODE",
        "JSP_ADDRESS",        
        "JSP_CONTACT",        
        "JSP_NO_REK",
        "JSP_BANK_ID",
        "JSP_PAYMENT_TYPE"
    };
    
    public static int[] fieldTypes = {
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING ,        
        TYPE_STRING,        
        TYPE_STRING,        
        TYPE_LONG,
        TYPE_INT
    };

    public JspVendorFinance() {
    }

    public JspVendorFinance(Vendor vendor) {
        this.vendor = vendor;
    }

    public JspVendorFinance(HttpServletRequest request, Vendor vendor) {
        super(new JspVendorFinance(vendor), request);
        this.vendor = vendor;
    }

    public String getFormName() {
        return JSP_NAME_VENDOR;
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

    public Vendor getEntityObject() {
        return vendor;
    }

    public void requestEntityObject(Vendor vendor) {
        try {
            this.requestParam();
            vendor.setName(getString(JSP_NAME));
            vendor.setCode(getString(JSP_CODE));
            vendor.setAddress(getString(JSP_ADDRESS));
            vendor.setContact(getString(JSP_CONTACT));
            vendor.setNoRek(getString(JSP_NO_REK));
            vendor.setBankId(getLong(JSP_BANK_ID));
            vendor.setPaymentType(getInt(JSP_PAYMENT_TYPE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
