package com.project.fms.ar;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspArapMemo extends JSPHandler implements I_JSPInterface, I_JSPType {

    private ArapMemo arapMemo;
    public static final String JSP_NAME_AR_AP_MEMO = "JSP_NAME_AR_AP_MEMO";
    
    public static final int JSP_ARAP_MEMO_ID = 0;
    public static final int JSP_DATE = 1;
    public static final int JSP_POSTED_DATE = 2;
    public static final int JSP_USER_ID = 3;
    public static final int JSP_POSTED_BY_ID = 4;
    public static final int JSP_MEMO = 5;
    public static final int JSP_AMOUNT = 6;
    public static final int JSP_STATUS = 7;
    public static final int JSP_POSTED_STATUS = 8;
    public static final int JSP_PAYMENT_STATUS = 9;
    public static final int JSP_TYPE = 10;
    public static final int JSP_REF_ID = 11;
    public static final int JSP_COA_ID = 12;
    public static final int JSP_VENDOR_ID = 13;    
    public static final int JSP_COUNTER = 14;
    public static final int JSP_PREFIX_NUMBER = 15;
    public static final int JSP_NUMBER = 16;
    public static final int JSP_PERIODE_ID = 17;
    public static final int JSP_APPROVAL1 = 18;
    public static final int JSP_APPROVAL2 = 19;
    public static final int JSP_DATE_APP1 = 20;
    public static final int JSP_DATE_APP2 = 21;
    public static final int JSP_CURRENCY_ID = 22;
    public static final int JSP_LOCATION_ID = 23;
    public static final int JSP_COA_AP_ID = 24;
    
    public static String[] colNames = {
            "JSP_ARAP_MEMO_ID",
            "JSP_DATE",
            "JSP_POSTED_DATE",
            "JSP_USER_ID",
            "JSP_POSTED_BY_ID",
            "JSP_MEMO",
            "JSP_AMOUNT",
            "JSP_STATUS",
            "JSP_POSTED_STATUS",
            "JSP_PAYMENT_STATUS",
            "JSP_TYPE",
            "JSP_REF_ID",
            "JSP_COA_ID",
            "JSP_VENDOR_ID",
            "JSP_COUNTER",
            "JSP_PREFIX_NUMBER",
            "JSP_NUMBER",
            "JSP_PERIODE_ID",
            "JSP_APPROVAL1",
            "JSP_APPROVAL2",
            "JSP_DATE_APP1",
            "JSP_DATE_APP2",
            "JSP_CURRENCY_ID",
            "JSP_LOCATION_ID",
            "JSP_COA_AP_ID"
    };
    public static int[] fieldTypes = {
            TYPE_LONG, //"JSP_ARAP_MEMO_ID",
            TYPE_STRING, //"JSP_DATE",
            TYPE_DATE, //"JSP_POSTED_DATE",
            TYPE_LONG, //"JSP_USER_ID",
            TYPE_LONG, //"JSP_POSTED_BY_ID",
            TYPE_STRING + ENTRY_REQUIRED, //"JSP_MEMO",
            TYPE_FLOAT, //"JSP_AMOUNT",
            TYPE_INT, //"JSP_STATUS",
            TYPE_INT, //"JSP_POSTED_STATUS",
            TYPE_INT, //"JSP_PAYMENT_STATUS",
            TYPE_INT, //"JSP_TYPE",
            TYPE_LONG, //"JSP_REF_ID",
            TYPE_LONG + ENTRY_REQUIRED, //"JSP_COA_ID",
            TYPE_LONG + ENTRY_REQUIRED, //"JSP_VENDOR_ID"
            TYPE_INT,
            TYPE_STRING,
            TYPE_STRING,
            TYPE_LONG,
            TYPE_LONG,
            TYPE_LONG,
            TYPE_DATE,
            TYPE_DATE,
            TYPE_LONG,
            TYPE_LONG,
            TYPE_LONG + ENTRY_REQUIRED
    };

    public JspArapMemo() {
    }

    public JspArapMemo(ArapMemo arapMemo) {
        this.arapMemo = arapMemo;
    }

    public JspArapMemo(HttpServletRequest request, ArapMemo arapMemo) {
        super(new JspArapMemo(arapMemo), request);
        this.arapMemo = arapMemo;
    }

    public String getFormName() {
        return JSP_NAME_AR_AP_MEMO;
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

    public ArapMemo getEntityObject() {
        return arapMemo;
    }

    public void requestEntityObject(ArapMemo arapMemo) {
        try {
            
            this.requestParam();
            
            arapMemo.setDate(JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy"));
            arapMemo.setPostedDate(JSPFormater.formatDate(getString(JSP_POSTED_DATE), "dd/MM/yyyy"));            
            arapMemo.setUserId(getLong(JSP_USER_ID));
            arapMemo.setPostedById(getLong(JSP_POSTED_BY_ID));
            arapMemo.setMemo(getString(JSP_MEMO));
            arapMemo.setAmount(getDouble(JSP_AMOUNT));
            arapMemo.setStatus(getInt(JSP_STATUS));
            arapMemo.setPostedStatus(getInt(JSP_POSTED_STATUS));
            arapMemo.setPaymentStatus(getInt(JSP_PAYMENT_STATUS));
            arapMemo.setType(getInt(JSP_TYPE));
            arapMemo.setRefId(getLong(JSP_REF_ID));
            arapMemo.setCoaId(getLong(JSP_COA_ID));
            arapMemo.setVendorId(getLong(JSP_VENDOR_ID));
            arapMemo.setPeriodeId(getLong(JSP_PERIODE_ID));            
            arapMemo.setApproval1(getLong(JSP_APPROVAL1));
            arapMemo.setApproval2(getLong(JSP_APPROVAL2));            
            arapMemo.setDateApp1(getDate(JSP_DATE_APP1));
            arapMemo.setDateApp2(getDate(JSP_DATE_APP2));
            arapMemo.setCurrencyId(getLong(JSP_CURRENCY_ID));
            arapMemo.setLocationId(getLong(JSP_LOCATION_ID));
            arapMemo.setCoaApId(getLong(JSP_COA_AP_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

