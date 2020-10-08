package com.project.ccs.postransaction.adjusment;

import com.project.util.JSPFormater;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import java.util.Date;

public class JspAdjusment extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Adjusment opname;
    public static final String JSP_NAME_OPNAME = "JSP_NAME_OPNAME";
    public static final int JSP_OPNAME_ID = 0;
    public static final int JSP_COUNTER = 1;
    public static final int JSP_NUMBER = 2;
    public static final int JSP_DATE = 3;
    public static final int JSP_STATUS = 4;
    public static final int JSP_NOTE = 5;
    public static final int JSP_APPROVAL_1 = 6;
    public static final int JSP_APPROVAL_2 = 7;
    public static final int JSP_APPROVAL_3 = 8;
    public static final int JSP_USER_ID = 9;
    public static final int JSP_LOCATION_ID = 10;
    public static final int JSP_TYPE = 11;
    public static final int JSP_COMPANY_ID = 12;
    public static final int JSP_POSTED_STATUS = 13;
    public static final int JSP_POSTED_BY_ID = 14;
    public static final int JSP_POSTED_DATE = 15;
    public static final int JSP_EFFECTIVE_DATE = 16;
    
    public static String[] colNames = {
        "JSP_OPNAME_ID", "JSP_COUNTER",
        "JSP_NUMBER", "JSP_DATE",
        "JSP_STATUS", "JSP_NOTE",
        "JSP_APPROVAL_1", "JSP_APPROVAL_2",
        "JSP_APPROVAL_3", "JSP_USER_ID",
        "JSP_LOCATION_ID", "JSP_TYPE", "JSP_COMPANY_ID",
        "JSP_POSTED_STATUS", "JSP_POSTED_BY_ID","JSP_POSTED_DATE",
        "JSP_EFFECTIVE_DATE"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_INT,
        TYPE_INT, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_INT, TYPE_INT,
        TYPE_INT, TYPE_LONG,
        TYPE_LONG, TYPE_INT, TYPE_LONG,
        TYPE_INT, TYPE_LONG,TYPE_DATE,
        TYPE_DATE
    };

    public JspAdjusment() {
    }

    public JspAdjusment(Adjusment opname) {
        this.opname = opname;
    }

    public JspAdjusment(HttpServletRequest request, Adjusment opname) {
        super(new JspAdjusment(opname), request);
        this.opname = opname;
    }

    public String getFormName() {
        return JSP_NAME_OPNAME;
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

    public Adjusment getEntityObject() {
        return opname;
    }

    public void requestEntityObject(Adjusment opname) {
        try {
            this.requestParam();
            //opname.setCounter(getInt(JSP_COUNTER));
            //opname.setNumber(getInt(JSP_NUMBER));
            opname.setDate(JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy"));
            Date newDate = new Date();
            newDate = JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy");
            newDate.setHours(new Date().getHours());
            newDate.setMinutes(new Date().getMinutes());
            newDate.setSeconds(new Date().getSeconds());
            opname.setDate(newDate);
            opname.setStatus(getString(JSP_STATUS));
            opname.setNote(getString(JSP_NOTE));
            // opname.setApproval1(getInt(JSP_APPROVAL_1));
            // opname.setApproval2(getInt(JSP_APPROVAL_2));
            // opname.setApproval3(getInt(JSP_APPROVAL_3));
            opname.setUserId(getLong(JSP_USER_ID));
            opname.setLocationId(getLong(JSP_LOCATION_ID));
            opname.setType(getInt(JSP_TYPE));
            opname.setCompany_id(getLong(JSP_COMPANY_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
