/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.master;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;

/**
 *
 * @author Roy Andika
 */
public class JspCoaOpeningBalanceLocation extends JSPHandler implements I_JSPInterface, I_JSPType {

    private CoaOpeningBalanceLocation coaOpeningBalanceLocation;
    
    public static final String JSP_NAME_COAOPENINGBALANCELOCATION = "JSP_NAME_COA_OPENING_BALANCE_LOCATION";
    
    public static final int JSP_COA_OPENING_BALANCE_ID = 0;
    public static final int JSP_COA_ID = 1;
    public static final int JSP_PERIODE_ID = 2;
    public static final int JSP_OPENING_BALANCE = 3;
    public static final int JSP_SEGMENT1_ID = 4;
    
    public static String[] colNames = {
        "JSP_COA_OPENING_BALANCE_ID", "JSP_COA_ID",
        "JSP_PERIODE_ID", "JSP_OPENING_BALANCE","JSP_SEGMENT1_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG, TYPE_FLOAT,
        TYPE_LONG
    };

    public JspCoaOpeningBalanceLocation() {
    }

    public JspCoaOpeningBalanceLocation(CoaOpeningBalanceLocation coaOpeningBalanceLocation) {
        this.coaOpeningBalanceLocation = coaOpeningBalanceLocation;
    }

    public JspCoaOpeningBalanceLocation(HttpServletRequest request, CoaOpeningBalanceLocation coaOpeningBalanceLocation) {
        super(new JspCoaOpeningBalanceLocation(coaOpeningBalanceLocation), request);
        this.coaOpeningBalanceLocation = coaOpeningBalanceLocation;
    }

    public String getFormName() {
        return JSP_NAME_COAOPENINGBALANCELOCATION;
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

    public CoaOpeningBalanceLocation getEntityObject() {
        return coaOpeningBalanceLocation;
    }

    public void requestEntityObject(CoaOpeningBalanceLocation coaOpeningBalanceLocation){
        try {
            this.requestParam();
            coaOpeningBalanceLocation.setCoaId(getLong(JSP_COA_ID));
            coaOpeningBalanceLocation.setPeriodeId(getLong(JSP_PERIODE_ID));
            coaOpeningBalanceLocation.setOpeningBalance(getDouble(JSP_OPENING_BALANCE));
            coaOpeningBalanceLocation.setSegment1Id(getLong(JSP_SEGMENT1_ID));            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
