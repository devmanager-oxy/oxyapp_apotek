package com.project.ccs.postransaction.purchase;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspPurchase extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Purchase purchase;
    public static final String JSP_NAME_PURCHASE = "JSP_NAME_PURCHASE";
    public static final int JSP_EXCHANGERATE_ID = 0;
    public static final int JSP_PURCH_DATE = 1;
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
    public static final int JSP_EXPIRED_DATE = 21;
    public static String[] colNames = {
        "JSP_EXCHANGERATE_ID", "JSP_PURCH_DATE",
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
        "JSP_EXPIRED_DATE"
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
        TYPE_STRING
    };

    public JspPurchase() {
    }

    public JspPurchase(Purchase purchase) {
        this.purchase = purchase;
        
        
    }

    public JspPurchase(HttpServletRequest request, Purchase purchase) {
        super(new JspPurchase(purchase), request);
        this.purchase = purchase;
    }

    public String getFormName() {
        return JSP_NAME_PURCHASE;
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

    public Purchase getEntityObject() {
        return purchase;
    }

    public void requestEntityObject(Purchase purchase) {
        try {
            this.requestParam();

            //purchase.setApproval_1(getInt(JSP_APPROVAL_1));
            //purchase.setApproval_2(getInt(JSP_APPROVAL_2));
            //purchase.setApproval_3(getInt(JSP_APPROVAL_3));
            //purchase.setCounter(getInt(JSP_COUNTER));
            purchase.setIncluceTax(getInt(JSP_INCLUDE_TAX));
            purchase.setNote(getString(JSP_NOTE));
            //purchase.setNumber(getString(JSP_NUMBER));
            purchase.setPurchDate(JSPFormater.formatDate(getString(JSP_PURCH_DATE), "dd/MM/yyyy"));
            purchase.setStatus(getString(JSP_STATUS));
            purchase.setUserId(getLong(JSP_USER_ID));
            purchase.setTotalTax(getDouble(JSP_TOTAL_TAX));
            purchase.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));
            purchase.setTaxPercent(getDouble(JSP_TAX_PERCENT));
            purchase.setDiscountTotal(getDouble(JSP_DISCOUNT_TOTAL));
            purchase.setDiscountPercent(getDouble(JSP_DISCOUNT_PERCENT));
            purchase.setPaymentType(getString(JSP_PAYMENT_TYPE));
            purchase.setLocationId(getLong(JSP_LOCATION_ID));
            purchase.setVendorId(getLong(JSP_VENDOR_ID));
            purchase.setCurrencyId(getLong(JSP_CURRENCY_ID));
            purchase.setClosedReason(getString(JSP_CLOSED_REASON));
            purchase.setExpiredDate(JSPFormater.formatDate(getString(JSP_EXPIRED_DATE), "dd/MM/yyyy"));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
