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
public class JspDocumentSales extends JSPHandler implements I_JSPInterface, I_JSPType{
    private DocumentSales documentSales;
    public static final String JSP_NAME_DOCUMENT_SALES = "JSP_DOCUMENT_SALES";
    
    public static final int JSP_DOCUMENT_SALES_ID = 0;
    public static final int JSP_DOCUMENT_ID = 1;
    public static final int JSP_SALES_DATA_ID = 2;
    public static final int JSP_TYPE_KARYAWAN = 3;
    public static final int JSP_TYPE_PENGUSAHA = 4;
    public static final int JSP_TYPE_PROFESI = 5;
    
    public static final String[] colNames = {
        "JSP_DOCUMENT_SALES_ID",
        "JSP_DOCUMENT_ID",
        "JSP_SALES_DATA_ID",
        "JSP_TYPE_KARYAWAN",
        "JSP_TYPE_PENGUSAHA",
        "JSP_TYPE_PROFESI"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,        
        TYPE_INT ,
        TYPE_INT ,
        TYPE_INT
    };
    
    public JspDocumentSales() {
    }

    public JspDocumentSales(DocumentSales documentSales) {
        this.documentSales = documentSales;
    }

    public JspDocumentSales(HttpServletRequest request, DocumentSales documentSales) {
        super(new JspDocumentSales(documentSales), request);
        this.documentSales = documentSales;
    }

    public String getFormName() {
        return JSP_NAME_DOCUMENT_SALES;
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

    public DocumentSales getEntityObject() {
        return documentSales;
    }

    public void requestEntityObject(DocumentSales documentSales) {
        try {
            this.requestParam();
            documentSales.setDocumentId(getLong(JSP_DOCUMENT_ID));
            documentSales.setSalesDataId(getLong(JSP_SALES_DATA_ID));
            documentSales.setTypeKaryawan(getInt(JSP_TYPE_KARYAWAN));
            documentSales.setTypePengusaha(getInt(JSP_TYPE_PENGUSAHA));
            documentSales.setTypeProfesi(getInt(JSP_TYPE_PROFESI));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
