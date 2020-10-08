package com.project.ccs.postransaction.transfer;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;

public class JspTransfer extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Transfer transfer;
    public static final String JSP_NAME_TRANSFER = "JSP_NAME_TRANSFER";
    public static final int JSP_TRANSFER_ID = 0;
    public static final int JSP_DATE = 1;
    public static final int JSP_STATUS = 2;
    public static final int JSP_FROM_LOCATION_ID = 3;
    public static final int JSP_TO_LOCATION_ID = 4;
    public static final int JSP_NOTE = 5;
    public static final int JSP_COUNTER = 6;
    public static final int JSP_NUMBER = 7;
    public static final int JSP_APPROVAL_1 = 8;
    public static final int JSP_APPROVAL_2 = 9;
    public static final int JSP_APPROVAL_3 = 10;
    public static final int JSP_USER_ID = 11;
    public static final int JSP_PREFIX_NUMBER = 12;
    public static final int JSP_TYPE = 13;
    
    public static String[] colNames = {
        "JSP_TRANSFER_ID", "JSP_DATE",
        "JSP_STATUS", "JSP_FROM_LOCATION_ID",
        "JSP_TO_LOCATION_ID", "JSP_NOTE",
        "JSP_COUNTER", "JSP_NUMBER",
        "JSP_APPROVAL_1", "JSP_APPROVAL_2", 
        "JSP_APPROVAL_3", "JSP_USER_ID",
        "JSP_PREFIX_NUMBER","JSP_TYPE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_STRING,
        TYPE_STRING, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_STRING,
        TYPE_INT, TYPE_STRING,
        TYPE_INT, TYPE_INT,
        TYPE_INT, TYPE_LONG,
        TYPE_STRING, TYPE_INT
    };

    public JspTransfer() {
    }

    public JspTransfer(Transfer transfer) {
        this.transfer = transfer;
    }

    public JspTransfer(HttpServletRequest request, Transfer transfer) {
        super(new JspTransfer(transfer), request);
        this.transfer = transfer;
    }

    public String getFormName() {
        return JSP_NAME_TRANSFER;
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

    public Transfer getEntityObject() {
        return transfer;
    }

    public void requestEntityObject(Transfer transfer) {
        try {
            this.requestParam(); 
            Date newDate = new Date();
            newDate= JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy");
            newDate.setHours(new Date().getHours());
            newDate.setMinutes(new Date().getMinutes());
            newDate.setSeconds(new Date().getSeconds());
            transfer.setDate(newDate);
            transfer.setStatus(getString(JSP_STATUS));
            transfer.setFromLocationId(getLong(JSP_FROM_LOCATION_ID));
            transfer.setToLocationId(getLong(JSP_TO_LOCATION_ID));
            transfer.setNote(getString(JSP_NOTE));
            //transfer.setCounter(getInt(JSP_COUNTER));
            //transfer.setNumber(getString(JSP_NUMBER));
            //transfer.setApproval1(getInt(JSP_APPROVAL_1));
            //transfer.setApproval2(getInt(JSP_APPROVAL_2));
            //transfer.setApproval3(getInt(JSP_APPROVAL_3));
            transfer.setUserId(getLong(JSP_USER_ID));
            transfer.setType(getInt(JSP_TYPE));
            //transfer.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
