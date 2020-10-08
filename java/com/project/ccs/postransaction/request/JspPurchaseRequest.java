package com.project.ccs.postransaction.request;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;


public class JspPurchaseRequest extends JSPHandler implements I_JSPInterface, I_JSPType {

    private PurchaseRequest purchaseRequest;
    public static final String JSP_NAME_PURCHASE_REQUEST = "JSP_NAME_PURCHASE_REQUEST";
    public static final int JSP_DATE = 0;
    public static final int JSP_APPROVAL_1 = 1;
    public static final int JSP_APPROVAL_2 = 2;
    public static final int JSP_APPROVAL_3 = 3;
    public static final int JSP_STATUS = 4;
    public static final int JSP_USER_ID = 5;
    public static final int JSP_NOTE = 6;
    public static final int JSP_NUMBER = 7;
    public static final int JSP_COUNTER = 8;
    public static final int JSP_DEPARTMENT_ID = 9;
    public static final int JSP_CLOSED_REASON = 10;
    
    public static String[] colNames = { 
        "JSP_DATE", "JSP_APPROVAL_1",
        "JSP_APPROVAL_2", "JSP_APPROVAL_3",
        "JSP_STATUS", "JSP_USER_ID",
        "JSP_NOTE", "JSP_NUMBER",
        "JSP_COUNTER", "JSP_DEPARTMENT_ID",
        "JSP_CLOSED_REASON"
    };
    public static int[] fieldTypes = {
        TYPE_STRING, TYPE_INT,
        TYPE_INT, TYPE_INT,
        TYPE_STRING, TYPE_LONG,
        TYPE_STRING, TYPE_STRING,
        TYPE_INT, TYPE_LONG,
        TYPE_STRING
    };

    public JspPurchaseRequest() {
    }

    public JspPurchaseRequest(PurchaseRequest purchaseRequest) {
        this.purchaseRequest = purchaseRequest;
    }

    public JspPurchaseRequest(HttpServletRequest request, PurchaseRequest purchaseRequest) {
        super(new JspPurchaseRequest(purchaseRequest), request);
        
        this.purchaseRequest = purchaseRequest;
    }

    public String getFormName() {
        return JSP_NAME_PURCHASE_REQUEST;
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

    public PurchaseRequest getEntityObject() {
        return purchaseRequest;
    }

    public void requestEntityObject(PurchaseRequest purchaseRequest) {
        try {
            this.requestParam();

            //purchaseRequest.setApproval_1(getInt(JSP_APPROVAL_1));
            //purchaseRequest.setApproval_2(getInt(JSP_APPROVAL_2));
            //purchaseRequest.setApproval_3(getInt(JSP_APPROVAL_3));
            //purchaseRequest.setCounter(getInt(JSP_COUNTER));
            purchaseRequest.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
            purchaseRequest.setNote(getString(JSP_NOTE));
            //purchaseRequest.setNumber(getString(JSP_NUMBER));            
            purchaseRequest.setDate(JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy"));
            purchaseRequest.setStatus(getString(JSP_STATUS));
            purchaseRequest.setUserId(getLong(JSP_USER_ID));
            purchaseRequest.setClosedReason(getString(JSP_CLOSED_REASON));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
