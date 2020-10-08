/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.transfer;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Roy Andika
 */
public class JspTransferRequest extends JSPHandler implements I_JSPInterface, I_JSPType {

    private TransferRequest transferRequest;
    
    public static final String JSP_NAME_TRANSFER_REQUEST = "JSP_NAME_TRANSFER_REQUEST";
    
    public static final int JSP_TRANSFER_REQUEST_ID = 0;
    public static final int JSP_DATE = 1;
    public static final int JSP_STATUS = 2;
    public static final int JSP_FROM_LOCATION_ID = 3;
    public static final int JSP_TO_LOCATION_ID = 4;
    public static final int JSP_NOTE = 5;
    public static final int JSP_COUNTER = 6;
    public static final int JSP_NUMBER = 7;
    public static final int JSP_APPROVAL_1 = 8;    
    public static final int JSP_USER_ID = 9;
    public static final int JSP_PREFIX_NUMBER = 10;
    
    
    public static String[] colNames = {
        "JSP_TRANSFER_REQUEST_ID", "JSP_DATE",
        "JSP_STATUS", "JSP_FROM_LOCATION_ID",
        "JSP_TO_LOCATION_ID", "JSP_NOTE",
        "JSP_COUNTER", "JSP_NUMBER",
        "JSP_APPROVAL_1","JSP_USER_ID",
        "JSP_PREFIX_NUMBER",
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_STRING,
        TYPE_STRING, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_STRING,
        TYPE_INT, TYPE_STRING,
        TYPE_LONG,TYPE_LONG,
        TYPE_STRING
    };

    public JspTransferRequest() {
    }

    public JspTransferRequest(TransferRequest transferRequest) {
        this.transferRequest = transferRequest;
    }

    public JspTransferRequest(HttpServletRequest request, TransferRequest transferRequest) {
        super(new JspTransferRequest(transferRequest), request);
        this.transferRequest = transferRequest;
    }

    public String getFormName() {
        return JSP_NAME_TRANSFER_REQUEST;
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

    public TransferRequest getEntityObject() {
        return transferRequest;
    }

    public void requestEntityObject(TransferRequest transferRequest) {
        try {
            this.requestParam();
            Date newDate = new Date();
            newDate = JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy");
            newDate.setHours(new Date().getHours());
            newDate.setMinutes(new Date().getMinutes());
            newDate.setSeconds(new Date().getSeconds());
            transferRequest.setDate(newDate);
            transferRequest.setStatus(getString(JSP_STATUS));
            transferRequest.setFromLocationId(getLong(JSP_FROM_LOCATION_ID));
            transferRequest.setToLocationId(getLong(JSP_TO_LOCATION_ID));
            transferRequest.setNote(getString(JSP_NOTE));            
                       
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
