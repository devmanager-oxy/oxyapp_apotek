/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.reportform;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;

/**
 *
 * @author Roy Andika
 */
public class JspRptFmsDetail extends JSPHandler implements I_JSPInterface, I_JSPType {

    private RptFmsDetail rptFmsDetail;
    public static final String JSP_NAME_RPTFMSDETAIL = "JSP_NAME_RPTFMSDETAIL";
    public static final int JSP_RPT_FMS_DETAIL_ID = 0;
    public static final int JSP_RPT_FMS_ID = 1;
    public static final int JSP_PERIOD_ID = 2;
    public static final int JSP_SQUENCE = 3;
    public static final int JSP_COA_ID = 4;
    public static final int JSP_AMOUNT = 5;
    public static final int JSP_TYPE = 6;
    public static final int JSP_LEVEL = 7;
    public static final int JSP_DESCRIPTION = 8;
    public static final int JSP_TYPE_DOC = 9;
    public static final int JSP_STATUS = 10;
    public static final int JSP_CURRENT_PERIOD = 11;
    
    public static String[] colNames = {
        "JSP_RPT_FMS_DETAIL_ID","JSP_RPT_FMS_ID",
        "JSP_PERIOD_ID",
        "JSP_SQUENCE", "JSP_COA_ID",
        "JSP_AMOUNT", "JSP_TYPE",
        "JSP_LEVEL", "JSP_DESCRIPTION",
        "JSP_TYPE_DOC",
        "JSP_STATUS","JSP_CURRENT_PERIOD"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG,
        TYPE_INT, TYPE_LONG,
        TYPE_FLOAT, TYPE_INT,
        TYPE_INT, TYPE_STRING,
        TYPE_INT, TYPE_STRING,
        TYPE_INT
    };

    public JspRptFmsDetail() {
    }

    public JspRptFmsDetail(RptFmsDetail rptFmsDetail) {
        this.rptFmsDetail = rptFmsDetail;
    }

    public JspRptFmsDetail(HttpServletRequest request, RptFmsDetail rptFmsDetail) {
        super(new JspRptFmsDetail(rptFmsDetail), request);
        this.rptFmsDetail = rptFmsDetail;
    }

    public String getFormName() {
        return JSP_NAME_RPTFMSDETAIL;
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

    public RptFmsDetail getEntityObject() {
        return rptFmsDetail;
    }

    public void requestEntityObject(RptFmsDetail rptFmsDetail) {
        try {
            this.requestParam();
            rptFmsDetail.setRptFmsId(getLong(JSP_RPT_FMS_ID));
            rptFmsDetail.setPeriodId(getLong(JSP_PERIOD_ID));
            rptFmsDetail.setSquence(getInt(JSP_SQUENCE));
            rptFmsDetail.setCoaId(getLong(JSP_COA_ID));
            rptFmsDetail.setAmount(getDouble(JSP_AMOUNT));
            rptFmsDetail.setType(getInt(JSP_TYPE));
            rptFmsDetail.setLevel(getInt(JSP_LEVEL));
            rptFmsDetail.setDescription(getString(JSP_DESCRIPTION));
            rptFmsDetail.setTypeDoc(getInt(JSP_TYPE_DOC));
            rptFmsDetail.setStatus(getString(JSP_STATUS));
            rptFmsDetail.setCurrentPeriod(getInt(JSP_CURRENT_PERIOD));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
