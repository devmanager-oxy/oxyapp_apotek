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

/**
 *
 * @author Roy Andika
 */
public class JspSewaTanahKomperProp extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SewaTanahKomperProp sewaTanahKomperProp;
    
    public static final String JSP_NAME_SEWATANAHKOMPERPROP = "JSP_NAME_SEWATANAHKOMPERPROP";
    public static final int JSP_KATEGORI = 0;
    public static final int JSP_PERSENTASE = 1;
    public static final int JSP_SEWA_TANAH_ID = 2;
    
    public static String[] colNames = {
        "JSP_KATEGORI",
        "JSP_PERSENTASE",
        "JSP_SEWA_TANAH_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_INT,
        TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_LONG
    };

    public JspSewaTanahKomperProp() {
    }

    public JspSewaTanahKomperProp(SewaTanahKomperProp sewaTanahKomperProp) {
        this.sewaTanahKomperProp = sewaTanahKomperProp;
    }

    public JspSewaTanahKomperProp(HttpServletRequest request, SewaTanahKomperProp sewaTanahKomperProp) {
        super(new JspSewaTanahKomperProp(sewaTanahKomperProp), request);
        this.sewaTanahKomperProp = sewaTanahKomperProp;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAHKOMPERPROP;
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

    public SewaTanahKomperProp getEntityObject() {
        return sewaTanahKomperProp;
    }

    public void requestEntityObject(SewaTanahKomperProp sewaTanahKomperProp) {
        try {
            this.requestParam();
            sewaTanahKomperProp.setKategori(getInt(JSP_KATEGORI));
            sewaTanahKomperProp.setPersentase(getDouble(JSP_PERSENTASE));
            sewaTanahKomperProp.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
