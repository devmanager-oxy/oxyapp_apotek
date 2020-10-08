/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy
 */
public class JspHistoryUser extends JSPHandler implements I_JSPInterface, I_JSPType {

    private HistoryUser historyUser;
    
    public static final String JSP_NAME_HISTORY_USER = "JSP_NAME_HISTORY_USER";
    
    public static final int JSP_HISTORY_USER_ID = 0;
    public static final int JSP_TYPE = 1;
    public static final int JSP_USER_ID = 2;
    public static final int JSP_EMPLOYEE_ID = 3;
    public static final int JSP_DESCRIPTION = 4;
    public static final int JSP_REF_ID = 5;
    public static final int JSP_DATE = 6;
    
    public static String[] fieldNames = {
        "JSP_HISTORY_USER_ID",
        "JSP_TYPE",
        "JSP_USER_ID",
        "JSP_EMPLOYEE_ID",
        "JSP_DESCRIPTION",
        "JSP_REF_ID",
        "JSP_DATE"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_INT + ENTRY_REQUIRED,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_DATE + ENTRY_REQUIRED
    };

    public JspHistoryUser() {
    }

    public JspHistoryUser(HistoryUser historyUser) {
        this.historyUser = historyUser;
    }

    public JspHistoryUser(HttpServletRequest request, HistoryUser historyUser) {
        super(new JspHistoryUser(historyUser), request);
        this.historyUser = historyUser;
    }

    public String getFormName() {
        return JSP_NAME_HISTORY_USER;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public HistoryUser getEntityObject() {
        return historyUser;
    }

    public void requestEntityObject(HistoryUser historyUser) {
        try {
            this.requestParam();
            historyUser.setType(getInt(JSP_TYPE));
            historyUser.setUserId(getLong(JSP_USER_ID));
            historyUser.setEmployeeId(getLong(JSP_EMPLOYEE_ID));
            historyUser.setDescription(getString(JSP_DESCRIPTION));
            historyUser.setRefId(getLong(JSP_REF_ID));
            historyUser.setDate(getDate(JSP_DATE));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
