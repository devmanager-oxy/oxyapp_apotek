package com.project.fms.reportform;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class JspRptFormatDetail extends JSPHandler implements I_JSPInterface, I_JSPType {

    private RptFormatDetail jspRptFormatDetail;
    public static final String JSP_NAME_FORMATDETAIL = "JSP_NAME_FORMATDETAIL";
    public static final int JSP_RPT_FORMAT_DETAIL_ID = 0;
    public static final int JSP_DESCRIPTION = 1;
    public static final int JSP_LEVEL = 2;
    public static final int JSP_REF_ID = 3;
    public static final int JSP_TYPE = 4;
    public static final int JSP_RPT_FORMAT_ID = 5;
    public static final int JSP_SQUENCE = 6;
    public static final int JSP_NEW_PAGE = 7;
    
    public static String[] colNames = {
        "JSP_RPT_FORMAT_DETAIL_ID", "JSP_DESCRIPTION",
        "JSP_LEVEL", "JSP_REF_ID",
        "JSP_TYPE", "JSP_RPT_FORMAT_ID",
        "JSP_SQUENCE", "JSP_NEW_PAGE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_INT, TYPE_LONG,
        TYPE_INT, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_INT, TYPE_BOOL
    };

    public JspRptFormatDetail() {
    }

    public JspRptFormatDetail(RptFormatDetail jspRptFormatDetail) {
        this.jspRptFormatDetail = jspRptFormatDetail;
    }

    public JspRptFormatDetail(HttpServletRequest request, RptFormatDetail jspRptFormatDetail) {
        super(new JspRptFormatDetail(jspRptFormatDetail), request);
        this.jspRptFormatDetail = jspRptFormatDetail;
    }

    public String getFormName() {
        return JSP_NAME_FORMATDETAIL;
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

    public RptFormatDetail getEntityObject() {
        return jspRptFormatDetail;
    }

    public void requestEntityObject(RptFormatDetail jspRptFormatDetail) {
        try {
            this.requestParam();
            jspRptFormatDetail.setDescription(getString(JSP_DESCRIPTION));
            //jspRptFormatDetail.setLevel(getInt(JSP_LEVEL));
            jspRptFormatDetail.setRefId(getLong(JSP_REF_ID));
            jspRptFormatDetail.setType(getInt(JSP_TYPE));
            jspRptFormatDetail.setRptFormatId(getLong(JSP_RPT_FORMAT_ID));
            jspRptFormatDetail.setSquence(getInt(JSP_SQUENCE));
            jspRptFormatDetail.setNewPage(getBoolean(JSP_NEW_PAGE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
