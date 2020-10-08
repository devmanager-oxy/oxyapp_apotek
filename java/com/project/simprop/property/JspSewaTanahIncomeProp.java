/* 
 * @author  	:  Eka Ds
 * @version  	:  1.0
 */
package com.project.simprop.property;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspSewaTanahIncomeProp extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SewaTanahIncomeProp sewaTanahIncomeProp;
    public static final String JSP_NAME_SEWATANAHINCOMEPROP = "JSP_NAME_SEWATANAHINCOMEPROP";
    public static final int JSP_SEWA_TANAH_INCOME_ID = 0;
    public static final int JSP_SEWA_TANAH_INVOICE_ID = 1;
    public static final int JSP_CURRENCY_ID = 2;
    public static final int JSP_JUMLAH = 3;
    public static final int JSP_STATUS = 4;
    public static final int JSP_CREATED_BY_ID = 5;
    public static final int JSP_POSTED_DATE = 6;
    public static final int JSP_TANGGAL = 7;
    public static final int JSP_COUNTER = 8;
    public static final int JSP_PREFIX_NUMBER = 9;
    public static final int JSP_NUMBER = 10;
    public static final int JSP_POSTED_BY_ID = 11;
    public static final int JSP_KETERANGAN = 12;
    public static final int JSP_GL_ID = 13;
    public static final int JSP_TYPE = 14;
    public static final int JSP_TANGGAL_INPUT = 15;
    public static final int JSP_INVESTOR_ID = 16;
    public static final int JSP_SARANA_ID = 17;
    public static String[] colNames = {
        "JSP_SEWA_TANAH_INCOME_ID", "JSP_SEWA_TANAH_INVOICE_ID",
        "JSP_CURRENCY_ID", "JSP_JUMLAH",
        "JSP_STATUS", "JSP_CREATED_BY_ID",
        "JSP_POSTED_DATE", "JSP_TANGGAL",
        "JSP_COUNTER", "JSP_PREFIX_NUMBER",
        "JSP_NUMBER", "JSP_POSTED_BY_ID",
        "JSP_KETERANGAN", "JSP_GL_ID",
        "JSP_TYPE", "JSP_TANGGAL_INPUT",
        "JSP_INVESTOR_ID", "JSP_SARANA_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG, TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_INT, TYPE_STRING,
        TYPE_DATE, TYPE_DATE,
        TYPE_INT, TYPE_STRING,
        TYPE_STRING, TYPE_LONG,
        TYPE_STRING, TYPE_LONG,
        TYPE_INT, TYPE_DATE,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_LONG + ENTRY_REQUIRED
    };

    public JspSewaTanahIncomeProp() {
    }

    public JspSewaTanahIncomeProp(SewaTanahIncomeProp sewaTanahIncomeProp) {
        this.sewaTanahIncomeProp = sewaTanahIncomeProp;
    }

    public JspSewaTanahIncomeProp(HttpServletRequest request, SewaTanahIncomeProp sewaTanahIncomeProp) {
        super(new JspSewaTanahIncomeProp(sewaTanahIncomeProp), request);
        this.sewaTanahIncomeProp = sewaTanahIncomeProp;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAHINCOMEPROP;
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

    public SewaTanahIncomeProp getEntityObject() {
        return sewaTanahIncomeProp;
    }

    public void requestEntityObject(SewaTanahIncomeProp sewaTanahIncomeProp) {
        try {
            this.requestParam();
            sewaTanahIncomeProp.setSewaTanahInvoiceId(getLong(JSP_SEWA_TANAH_INVOICE_ID));
            sewaTanahIncomeProp.setCurrencyId(getLong(JSP_CURRENCY_ID));
            sewaTanahIncomeProp.setJumlah(getDouble(JSP_JUMLAH));
            sewaTanahIncomeProp.setStatus(getInt(JSP_STATUS));
            sewaTanahIncomeProp.setCreatedById(getString(JSP_CREATED_BY_ID));
            sewaTanahIncomeProp.setPostedDate(getDate(JSP_POSTED_DATE));
            sewaTanahIncomeProp.setTanggal(getDate(JSP_TANGGAL));
            sewaTanahIncomeProp.setCounter(getInt(JSP_COUNTER));
            sewaTanahIncomeProp.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
            sewaTanahIncomeProp.setNumber(getString(JSP_NUMBER));
            sewaTanahIncomeProp.setPostedById(getLong(JSP_POSTED_BY_ID));
            sewaTanahIncomeProp.setKeterangan(getString(JSP_KETERANGAN));
            sewaTanahIncomeProp.setGlId(getLong(JSP_GL_ID));
            sewaTanahIncomeProp.setType(getInt(JSP_TYPE));
            sewaTanahIncomeProp.setTanggalInput(getDate(JSP_TANGGAL_INPUT));
            sewaTanahIncomeProp.setInvestorId(getLong(JSP_INVESTOR_ID));
            sewaTanahIncomeProp.setSaranaId(getLong(JSP_SARANA_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
