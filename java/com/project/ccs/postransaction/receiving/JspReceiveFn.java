/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.receiving;


import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;
/**
 *
 * @author Roy
 */
public class JspReceiveFn extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Receive receive;
    public static final String JSP_NAME_RECEIVE_FN = "JSP_NAME_RECEIVE_FN";
    
    public static final int JSP_EXCHANGERATE_ID = 0;
    public static final int JSP_DATE = 1;
    public static final int JSP_APPROVAL_1 = 2;
    public static final int JSP_APPROVAL_2 = 3;
    public static final int JSP_APPROVAL_3 = 4;
    public static final int JSP_STATUS = 5;
    public static final int JSP_USER_ID = 6;
    public static final int JSP_NOTE = 7;
    public static final int JSP_NUMBER = 8;
    public static final int JSP_COUNTER = 9;
    public static final int JSP_INCLUDE_TAX = 10;
    public static final int JSP_TOTAL_TAX = 11;
    public static final int JSP_TOTAL_AMOUNT = 12;
    public static final int JSP_TAX_PERCENT = 13;
    public static final int JSP_DISCOUNT_TOTAL = 14;
    public static final int JSP_DISCOUNT_PERCENT = 15;
    public static final int JSP_PAYMENT_TYPE = 16;
    public static final int JSP_LOCATION_ID = 17;
    public static final int JSP_VENDOR_ID = 18;
    public static final int JSP_CURRENCY_ID = 19;
    public static final int JSP_CLOSED_REASON = 20;    
    public static final int JSP_PURCHASE_ID = 21;
    public static final int JSP_DUE_DATE = 22;
    public static final int JSP_PAYMENT_AMOUNT = 23;
    public static final int JSP_DO_NUMBER = 24;
    public static final int JSP_INVOICE_NUMBER = 25;    
    public static final int JSP_UNIT_USAHA_ID = 26;
    public static final int JSP_TYPE = 27;
    public static final int JSP_PERIOD_ID = 28;
    public static final int JSP_COA_ID = 29;
    public static final int JSP_TYPE_AP = 30;    
    public static final int JSP_PAYMENT_STATUS_POSTED = 31;    
    public static final int JSP_NO_PAJAK = 32;
    public static final int JSP_TYPE_INC = 33;    
    public static final int JSP_REFERENCE_ID = 34;    
    
    
    public static String[] colNames = {
        "JSP_EXCHANGERATE_ID", "JSP_DATE",
        "JSP_APPROVAL_1", "JSP_APPROVAL_2",
        "JSP_APPROVAL_3", "JSP_STATUS",
        "JSP_USER_ID", "JSP_NOTE",
        "JSP_NUMBER", "JSP_COUNTER",
        "JSP_INCLUDE_TAX", "JSP_TOTAL_TAX",
        "JSP_TOTAL_AMOUNT", "JSP_TAX_PERCENT",
        "JSP_DISCOUNT_TOTAL", "JSP_DISCOUNT_PERCENT",
        "JSP_PAYMENT_TYPE", "JSP_LOCATION_ID",
        "JSP_VENDOR_ID","JSP_CURRENCY_ID",
        "JSP_CLOSED_REASON",        
        "JSP_PURCHASE_ID", "JSP_DUE_DATE",
        "JSP_PAYMENT_AMOUNT",
        "JSP_DO_NUMBER", "JSP_INVOICE_NUMBER",
        "JSP_UNIT_USAHA_ID", "JSP_TYPE",
        "JSP_PERIOD_ID","JSP_COA_ID",
        "JSP_TYPE_AP","JSP_PAYMENT_STATUS_POSTED",
        "JSP_NO_PAJAK","JSP_TYPE_INC"
    };    
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING, TYPE_LONG,
        TYPE_LONG, TYPE_LONG,
        TYPE_STRING, TYPE_LONG,
        TYPE_STRING, TYPE_STRING,
        TYPE_INT, TYPE_INT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_STRING,
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG, 
        TYPE_STRING,        
        TYPE_LONG, TYPE_STRING,
        TYPE_FLOAT,
        TYPE_STRING, TYPE_STRING,
        TYPE_LONG, TYPE_INT,
        TYPE_LONG,TYPE_LONG,
        TYPE_INT, TYPE_INT,
        TYPE_STRING, TYPE_INT
    };

    public JspReceiveFn() {
    }

    public JspReceiveFn(Receive receive) {
        this.receive = receive;
    }

    public JspReceiveFn(HttpServletRequest request, Receive receive) {
        super(new JspReceiveFn(receive), request);
        this.receive = receive;
    }

    public String getFormName() {
        return JSP_NAME_RECEIVE_FN;
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

    public Receive getEntityObject() {
        return receive;
    }

    public void requestEntityObject(Receive receive) {
        try {
            this.requestParam();
            receive.setStatus(getString(JSP_STATUS));           
            receive.setPeriodId(getLong(JSP_PERIOD_ID));
            receive.setCoaId(getLong(JSP_COA_ID));            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
