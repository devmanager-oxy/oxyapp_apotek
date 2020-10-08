package com.project.general;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;
import com.project.util.JSPFormater;

public class JspCustomerHistory extends JSPHandler implements I_JSPInterface, I_JSPType {
 
    private CustomerHistory customerHistory;
    public static final String JSP_NAME_CUSTOMER_HISTORY  = "JSP_NAME_CUSTOMER_HISTORY";

    public static final int JSP_CUSTOMER_HISTORY_ID = 0;
    public static final int JSP_TYPE               = 1;
    public static final int JSP_TYPE_HISTORY       = 2;
    public static final int JSP_CUSTOMER_ID        = 3;
    public static final int JSP_USER_ID            = 4;
    public static final int JSP_DATE               = 5;
    public static final int JSP_STATUS             = 6;
    public static final int JSP_STATUS_DATE        = 7;
    public static final int JSP_NOTE               = 8;
    public static final int JSP_BARCODE            = 9;
    public static final int JSP_NAME               = 10;
    public static final int JSP_SALES_ID           = 11;

    public static String[] colNames = {
        "JSP_CUSTOMER_HISTORY_ID",
        "JSP_TYPE",
        "JSP_TYPE_HISTORY",
        "JSP_CUSTOMER_ID",
        "JSP_USER_ID",
        "JSP_DATE",
        "JSP_STATUS",
        "JSP_STATUS_DATE",
        "JSP_NOTE",
        "JSP_BARCODE",
        "JSP_NAME",
        "JSP_SALES_ID"
    };
    
    public static int[] colTypes = {
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG      
    };
    
    public JspCustomerHistory() {
    }
    
    public JspCustomerHistory(CustomerHistory customerHistory) {
        this.customerHistory = customerHistory;
    }
    
    public JspCustomerHistory(HttpServletRequest request, CustomerHistory customerHistory) {
        super(new JspCustomerHistory(customerHistory), request);
        this.customerHistory = customerHistory;
    }
    
    public String getFormName() {
        return JSP_NAME_CUSTOMER_HISTORY;
    }
    
    public int[] getFieldTypes() {
        return colTypes;
    }
    
    public String[] getFieldNames() {
        return colNames;
    }
    
    public int getFieldSize() {
        return colNames.length;
    }
    
    public CustomerHistory getEntityObject() {
        return customerHistory;
    }
    
    public void requestEntityObject(CustomerHistory customerHistory) {
        try {
            this.requestParam();
            customerHistory.setType(getInt(JSP_TYPE));
            customerHistory.setTypeHistory(getInt(JSP_TYPE_HISTORY));
            customerHistory.setCustomerId(getLong(JSP_CUSTOMER_ID));
            customerHistory.setUserId(getLong(JSP_USER_ID));
            customerHistory.setStatus(getString(JSP_STATUS));
            customerHistory.setNote(getString(JSP_NOTE));
            customerHistory.setBarcode(getString(JSP_BARCODE));
            customerHistory.setName(getString(JSP_NAME));
            customerHistory.setSalesId(getLong(JSP_SALES_ID));
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
    }
}
    
