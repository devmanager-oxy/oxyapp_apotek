/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class JspSewaTanahKominProp extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SewaTanahKominProp sewaTanahKominProp;
    
    public static final String JSP_NAME_SEWATANAHKOMINPROP = "JSP_NAME_SEWATANAHKOMINPROP";
    
    public static final int JSP_SEWA_TANAH_KOMIN_ID = 0;
    public static final int JSP_NAMA = 1;
    public static final int JSP_TYPE = 2;
    public static final int JSP_MULAI = 3;
    public static final int JSP_SELESAI = 4;
    public static final int JSP_RATE = 5;
    public static final int JSP_UNIT_KONTRAK_ID = 6;
    public static final int JSP_KETERANGAN = 7;
    public static final int JSP_SEWA_TANAH_ID = 8;
    public static final int JSP_DASAR_PERHITUNGAN = 9;
    
    public static String[] colNames = {
        "JSP_SEWA_TANAH_KOMIN_ID",
        "JSP_NAMA",
        "JSP_TYPE",
        "JSP_MULAI",
        "JSP_SELESAI",
        "JSP_RATE",
        "JSP_UNIT_KONTRAK_ID",
        "JSP_KETERANGAN",
        "JSP_SEWA_TANAH_ID",
        "JSP_DASAR_PERHITUNGAN"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_INT + ENTRY_REQUIRED
    };

    public JspSewaTanahKominProp() {
    }

    public JspSewaTanahKominProp(SewaTanahKominProp sewaTanahKominProp) {
        this.sewaTanahKominProp = sewaTanahKominProp;
    }

    public JspSewaTanahKominProp(HttpServletRequest request, SewaTanahKominProp sewaTanahKominProp) {
        super(new JspSewaTanahKominProp(sewaTanahKominProp), request);
        this.sewaTanahKominProp = sewaTanahKominProp;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAHKOMINPROP;
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

    public SewaTanahKominProp getEntityObject() {
        return sewaTanahKominProp;
    }

    public void requestEntityObject(SewaTanahKominProp sewaTanahKominProp) {
        try {
            this.requestParam();
            sewaTanahKominProp.setNama(getString(JSP_NAMA));
            sewaTanahKominProp.setType(getInt(JSP_TYPE));
            sewaTanahKominProp.setMulai(JSPFormater.formatDate(getString(JSP_MULAI), "dd/MM/yyyy"));
            sewaTanahKominProp.setSelesai(JSPFormater.formatDate(getString(JSP_SELESAI), "dd/MM/yyyy"));
            sewaTanahKominProp.setRate(getDouble(JSP_RATE));
            sewaTanahKominProp.setUnitKontrakId(getLong(JSP_UNIT_KONTRAK_ID));
            sewaTanahKominProp.setKeterangan(getString(JSP_KETERANGAN));
            sewaTanahKominProp.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
            sewaTanahKominProp.setDasarPerhitungan(getInt(JSP_DASAR_PERHITUNGAN));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
