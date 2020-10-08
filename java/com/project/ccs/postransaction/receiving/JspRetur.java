package com.project.ccs.postransaction.receiving;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspRetur extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Retur retur;
    public static final String JSP_NAME_RETUR = "JSP_NAME_RETUR";
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
    public static final int JSP_RECEIVE_ID = 26;
    
    public static String[] colNames = {
        "JSP_EXCHANGERATE_ID", "JSP_DATE",
        "JSP_APPROVAL_1", "JSP_APPROVAL_2",
        "JSP_APPROVAL_3", "JSP_STATUS",
        "JSP_USER_ID", "JSP_NOTE",
        "JSP_NUMBER", "JSP_COUNTER",
        "JSP_INCLUDE_TAX", "xxJSP_TOTAL_TAX",
        "xxJSP_TOTAL_AMOUNT", "xxJSP_TAX_PERCENT",
        "xxJSP_DISCOUNT_TOTAL", "xxJSP_DISCOUNT_PERCENT",
        "JSP_PAYMENT_TYPE", "JSP_LOCATION_ID",
        "JSP_VENDOR_ID","JSP_CURRENCY_ID",
        "JSP_CLOSED_REASON",
        
        "JSP_PURCHASE_ID", "JSP_DUE_DATE",
        "JSP_PAYMENT_AMOUNT",
        "JSP_DO_NUMBER", "JSP_INVOICE_NUMBER",
        "JSP_RECEIVE_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING, TYPE_INT,
        TYPE_INT, TYPE_INT,
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
        TYPE_LONG + ENTRY_REQUIRED
    };

    public JspRetur() {
    }

    public JspRetur(Retur retur) {
        this.retur = retur;
    }

    public JspRetur(HttpServletRequest request, Retur retur) {
        super(new JspRetur(retur), request);
        this.retur = retur;
    }

    public String getFormName() {
        return JSP_NAME_RETUR;
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

    public Retur getEntityObject() {
        return retur;
    }

    public void requestEntityObject(Retur retur) {
        try {
            this.requestParam();

            //retur.setApproval_1(getInt(JSP_APPROVAL_1));
            //retur.setApproval_2(getInt(JSP_APPROVAL_2));
            //retur.setApproval_3(getInt(JSP_APPROVAL_3));
            //retur.setCounter(getInt(JSP_COUNTER));
            retur.setIncluceTax(getInt(JSP_INCLUDE_TAX));
            retur.setNote(getString(JSP_NOTE));
            //retur.setNumber(getString(JSP_NUMBER));
            retur.setDate(JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy"));
            retur.setStatus(getString(JSP_STATUS));
            retur.setUserId(getLong(JSP_USER_ID));
            retur.setTotalTax(getDouble(JSP_TOTAL_TAX));
            retur.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));
            retur.setTaxPercent(getDouble(JSP_TAX_PERCENT));
            retur.setDiscountTotal(getDouble(JSP_DISCOUNT_TOTAL));
            retur.setDiscountPercent(getDouble(JSP_DISCOUNT_PERCENT));
            retur.setPaymentType(getString(JSP_PAYMENT_TYPE));
            retur.setLocationId(getLong(JSP_LOCATION_ID));
            retur.setVendorId(getLong(JSP_VENDOR_ID));
            retur.setCurrencyId(getLong(JSP_CURRENCY_ID));
            retur.setClosedReason(getString(JSP_CLOSED_REASON));
            
            retur.setPurchaseId(getLong(JSP_PURCHASE_ID));
            retur.setDueDate(JSPFormater.formatDate(getString(JSP_DUE_DATE), "dd/MM/yyyy"));
            retur.setPaymentAmount(getDouble(JSP_PAYMENT_AMOUNT));
            
            retur.setDoNumber(getString(JSP_DO_NUMBER));
            retur.setInvoiceNumber(getString(JSP_INVOICE_NUMBER));
            
            retur.setReceiveId(getLong(JSP_RECEIVE_ID));
            

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
