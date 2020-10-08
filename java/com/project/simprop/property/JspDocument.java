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
public class JspDocument extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Document document;
    public static final String JSP_NAME_DOCUMENT = "JSP_DOCUMENT";
    
    public static final int JSP_DOCUMENT_ID = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_TYPE_KARYAWAN = 2;
    public static final int JSP_TYPE_PENGUSAHA = 3;
    public static final int JSP_TYPE_PROFESI = 4;
    
    public static final String[] colNames = {
        "JSP_DOCUMENT_ID",
        "JSP_NAME_DOCUMENT",
        "JSP_TYPE_KARYAWAN",
        "JSP_TYPE_PENGUSAHA",
        "JSP_TYPE_PROFESI"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT ,
        TYPE_INT ,
        TYPE_INT
    };
    
    public JspDocument() {
    }

    public JspDocument(Document document) {
        this.document = document;
    }

    public JspDocument(HttpServletRequest request, Document document) {
        super(new JspDocument(document), request);
        this.document = document;
    }

    public String getFormName() {
        return JSP_NAME_DOCUMENT;
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

    public Document getEntityObject() {
        return document;
    }

    public void requestEntityObject(Document document) {
        try {
            this.requestParam();
            document.setNameDocument(getString(JSP_NAME));
            document.setTypeKaryawan(getInt(JSP_TYPE_KARYAWAN));
            document.setTypePengusaha(getInt(JSP_TYPE_PENGUSAHA));
            document.setTypeProfesi(getInt(JSP_TYPE_PROFESI));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
