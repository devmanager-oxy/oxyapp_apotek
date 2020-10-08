/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.util.JSPFormater;

/**
 *
 * @author Roy Andika
 */
public class JspSewaTanahAssesmentProp extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SewaTanahAssesmentProp sewaTanahAssesmentProp;
    public static final String JSP_NAME_SEWATANAHASSESMENTPROP = "JSP_NAME_SEWATANAHASSESMENTPROP";
    public static final int JSP_MULAI = 0;
    public static final int JSP_SELESAI = 1;
    public static final int JSP_RATE = 2;
    public static final int JSP_UNIT_KONTRAK_ID = 3;
    public static final int JSP_DASAR_PERHITUNGAN = 4;
    public static final int JSP_SEWA_TANAH_ID = 5;
    public static final int JSP_CURRENCY_ID = 6;
    public static String[] colNames = {
        "JSP_MULAI", "JSP_SELESAI", "JSP_RATE",
        "JSP_UNIT_KONTRAK_ID", "JSP_DASAR_PERHITUNGAN",
        "JSP_SEWA_TANAH_ID", "JSP_CURR_ID"
    };
    public static int[] fieldTypes = {
        TYPE_STRING, TYPE_STRING, TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_INT,
        TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED
    };

    public JspSewaTanahAssesmentProp() {
    }

    public JspSewaTanahAssesmentProp(SewaTanahAssesmentProp sewaTanahAssesmentProp) {
        this.sewaTanahAssesmentProp = sewaTanahAssesmentProp;
    }

    public JspSewaTanahAssesmentProp(HttpServletRequest request, SewaTanahAssesmentProp sewaTanahAssesmentProp) {
        super(new JspSewaTanahAssesmentProp(sewaTanahAssesmentProp), request);
        this.sewaTanahAssesmentProp = sewaTanahAssesmentProp;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAHASSESMENTPROP;
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

    public SewaTanahAssesmentProp getEntityObject() {
        return sewaTanahAssesmentProp;
    }

    public void requestEntityObject(SewaTanahAssesmentProp sewaTanahAssesmentProp) {
        try {
            this.requestParam();
            sewaTanahAssesmentProp.setMulai(JSPFormater.formatDate(getString(JSP_MULAI), "dd/MM/yyyy"));
            sewaTanahAssesmentProp.setSelesai(JSPFormater.formatDate(getString(JSP_SELESAI), "dd/MM/yyyy"));
            sewaTanahAssesmentProp.setRate(getDouble(JSP_RATE));
            sewaTanahAssesmentProp.setUnitKontrakId(getLong(JSP_UNIT_KONTRAK_ID));
            sewaTanahAssesmentProp.setDasarPerhitungan(getInt(JSP_DASAR_PERHITUNGAN));
            sewaTanahAssesmentProp.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
            sewaTanahAssesmentProp.setCurrencyId(getLong(JSP_CURRENCY_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
