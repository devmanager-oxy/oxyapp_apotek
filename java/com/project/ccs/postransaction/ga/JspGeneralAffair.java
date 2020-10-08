/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.ga;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.util.JSPFormater;

/**
 *
 * @author Roy
 */
public class JspGeneralAffair extends JSPHandler implements I_JSPInterface, I_JSPType {

    private GeneralAffair generalAffair;
    
    public static final String JSP_NAME_GENERAL_AFFAIR = "JSP_NAME_GENERAL_AFFAIR";
    
    public static final int JSP_GENERAL_AFFAIR_ID = 0;    
    public static final int JSP_TRANSACTION_DATE = 1;
    public static final int JSP_COUNTER = 2;
    public static final int JSP_NUMBER = 3;
    public static final int JSP_NOTE = 4;
    public static final int JSP_APPROVAL_1 = 5;    
    public static final int JSP_APPROVAL_1_DATE = 6;    
    public static final int JSP_STATUS = 7;    
    public static final int JSP_LOCATION_ID = 8;
    public static final int JSP_USER_ID = 9;
    public static final int JSP_PREFIX_NUMBER = 10;
    public static final int JSP_POSTED_STATUS = 11;
    public static final int JSP_POSTED_BY_ID = 12;
    public static final int JSP_POSTED_DATE = 13;    
    public static final int JSP_LOCATION_POST_ID = 14;
    
    public static String[] colNames = {
        "JSP_GENERAL_AFFAIR_ID",         
        "JSP_TRANSACTION_DATE",
        "JSP_COUNTER", 
        "JSP_NUMBER",
        "JSP_NOTE",         
        "JSP_APPROVAL_1",
        "JSP_APPROVAL_1_DATE",        
        "JSP_STATUS", 
        "JSP_LOCATION_ID",
        "JSP_USER_ID", 
        "JSP_PREFIX_NUMBER",
        "JSP_POSTED_STATUS", 
        "JSP_POSTED_BY_ID",
        "JSP_POSTED_DATE",         
        "JSP_LOCATION_POST_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_STRING,
        TYPE_INT, 
        TYPE_STRING,
        TYPE_STRING + ENTRY_REQUIRED,         
        TYPE_LONG,
        TYPE_DATE, 
        TYPE_STRING,
        TYPE_LONG + ENTRY_REQUIRED, 
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,   
        TYPE_DATE,
        TYPE_LONG + ENTRY_REQUIRED       
    };

    public JspGeneralAffair() {
    }

    public JspGeneralAffair(GeneralAffair generalAffair) {
        this.generalAffair = generalAffair;
    }

    public JspGeneralAffair(HttpServletRequest request, GeneralAffair generalAffair) {
        super(new JspGeneralAffair(generalAffair), request);
        this.generalAffair = generalAffair;
    }

    public String getFormName() {
        return JSP_NAME_GENERAL_AFFAIR;
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

    public GeneralAffair getEntityObject() {
        return generalAffair;
    }

    public void requestEntityObject(GeneralAffair generalAffair) {
        try {
            this.requestParam();
            Date newDate = new Date();
            newDate = JSPFormater.formatDate(getString(JSP_TRANSACTION_DATE), "dd/MM/yyyy");
            newDate.setHours(new Date().getHours());
            newDate.setMinutes(new Date().getMinutes());
            newDate.setSeconds(new Date().getSeconds());
            generalAffair.setTransactionDate(newDate);
            generalAffair.setNote(getString(JSP_NOTE));
            generalAffair.setStatus(getString(JSP_STATUS));
            generalAffair.setLocationId(getLong(JSP_LOCATION_ID));
            generalAffair.setUserId(getLong(JSP_USER_ID));
            generalAffair.setLocationPostId(getLong(JSP_LOCATION_POST_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
