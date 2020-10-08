package com.project.crm.master.irigasi;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspIrigasi extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Irigasi irigasi;
    public static final String JSP_NAME_IRIGASI = "crm_master_irigasi";
    public static final int JSP_MASTER_IRIGASI_ID = 0;
    public static final int JSP_RATE = 1;
    public static final int JSP_UNIT = 2;
    public static final int JSP_STATUS = 3;
    public static final int JSP_PERIODE_ID = 4;
    public static final int JSP_PPN_PERCENT = 5;
    public static final int JSP_PRICE_TYPE = 6;
    
    public static String[] colNames = {
        "JSP_MASTER_IRIGASI_ID",
        "JSP_RATE",
        "JSP_UNIT",
        "JSP_STATUS",
        "JSP_PERIODE_ID",
        "JSP_PPN_PERCENT",
        "JSP_PRICE_TYPE"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_FLOAT,
        TYPE_INT
    };

    public JspIrigasi() {
    }

    public JspIrigasi(Irigasi irigasi) {
        this.irigasi = irigasi;
    }

    public JspIrigasi(HttpServletRequest request, Irigasi irigasi) {
        super(new JspIrigasi(irigasi), request);
        this.irigasi = irigasi;
    }

    public String getFormName() {
        return JSP_NAME_IRIGASI;
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

    public Irigasi getEntityObject() {
        return irigasi;
    }

    public void requestEntityObject(Irigasi irigasi) {
        try {

            this.requestParam();
            irigasi.setRate(getDouble(JSP_RATE));
            irigasi.setUnit(getLong(JSP_UNIT));
            irigasi.setStatus(getInt(JSP_STATUS));
            irigasi.setPeriodeId(getLong(JSP_PERIODE_ID));
            irigasi.setPpnPercent(getDouble(JSP_PPN_PERCENT));
            irigasi.setPriceType(getInt(JSP_PRICE_TYPE));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
