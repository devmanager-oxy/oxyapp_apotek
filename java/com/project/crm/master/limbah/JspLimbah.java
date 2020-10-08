/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.crm.master.limbah;

/**
 *
 * @author Tu Roy
 */
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.crm.master.*;

public class JspLimbah extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Limbah limbah;
    public static final String JSP_NAME_LIMBAH = "crm_master_limbah";
    public static final int JSP_MASTER_LIMBAH_ID = 0;
    public static final int JSP_RATE = 1;
    public static final int JSP_UNIT = 2;
    public static final int JSP_STATUS = 3;
    public static final int JSP_PERCENTAGE_USED = 4;
    public static final int JSP_PERIODE_ID = 5;
    public static final int JSP_PPN_PERCENT = 6;
    public static final int JSP_PRICE_TYPE = 7;
    
    public static String[] colNames = {
        "JSP_MASTER_IRIGASI_ID",
        "JSP_RATE",
        "JSP_UNIT",
        "JSP_STATUS",
        "JSP_PERCENTAGE_USED",
        "JSP_PERIODE_ID",
        "JSP_PPN_PERCENT",
        "JSP_PRICE_TYPE"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_FLOAT,
        TYPE_INT
    };

    public JspLimbah() {
    }

    public JspLimbah(Limbah limbah) {
        this.limbah = limbah;
    }

    public JspLimbah(HttpServletRequest request, Limbah limbah) {
        super(new JspLimbah(limbah), request);
        this.limbah = limbah;
    }

    public String getFormName() {
        return JSP_NAME_LIMBAH;
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

    public Limbah getEntityObject() {
        return limbah;
    }

    public void requestEntityObject(Limbah limbah) {
        try {
            this.requestParam();

            limbah.setRate(getDouble(JSP_RATE));
            limbah.setUnit(getLong(JSP_UNIT));
            limbah.setStatus(getInt(JSP_STATUS));
            limbah.setPercentageUsed(getDouble(JSP_PERCENTAGE_USED));
            limbah.setPeriodeId(getLong(JSP_PERIODE_ID));
            limbah.setPpnPercent(getDouble(JSP_PPN_PERCENT));
            limbah.setPriceType(getInt(JSP_PRICE_TYPE));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
