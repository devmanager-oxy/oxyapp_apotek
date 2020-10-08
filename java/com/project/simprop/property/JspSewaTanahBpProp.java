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
public class JspSewaTanahBpProp extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SewaTanahBpProp sewaTanahBpProp;
    public static final String JSP_NAME_SEWATANAHBPPROP = "JSP_NAME_SEWATANAHBPPROP";
    public static final int JSP_TANGGAL = 0;
    public static final int JSP_KETERANGAN = 1;
    public static final int JSP_REFNUMBER = 2;
    public static final int JSP_MEM = 3;
    public static final int JSP_DEBET = 4;
    public static final int JSP_CREDIT = 5;
    public static final int JSP_SEWA_TANAH_ID = 6;
    public static final int JSP_SEWA_TANAH_INV_ID = 7;
    public static final int JSP_MATA_UANG_ID = 8;
    public static final int JSP_CUSTOMER_ID = 9;
    public static final int JSP_LIMBAH_TRANSACTION_ID = 10;
    public static final int JSP_IRIGASI_TRANSACTION_ID = 11;
    public static String[] colNames = {
        "JSP_TANGGAL",
        "JSP_KETERANGAN",
        "JSP_REFNUMBER",
        "JSP_MEM",
        "JSP_DEBET",
        "JSP_CREDIT",
        "JSP_SEWA_TANAH_ID",
        "JSP_SEWA_TANAH_INV_ID",
        "JSP_MATA_UANG_ID",
        "JSP_CUSTOMER_ID",
        "JSP_LIMBAH_TRANSACTION_ID",
        "JSP_CUSTOMER_ID"
    };
    public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_LONG,
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG
    };

    public JspSewaTanahBpProp() {
    }

    public JspSewaTanahBpProp(SewaTanahBpProp sewaTanahBpProp) {
        this.sewaTanahBpProp = sewaTanahBpProp;
    }

    public JspSewaTanahBpProp(HttpServletRequest request, SewaTanahBpProp sewaTanahBpProp) {
        super(new JspSewaTanahBpProp(sewaTanahBpProp), request);
        this.sewaTanahBpProp = sewaTanahBpProp;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAHBPPROP;
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

    public SewaTanahBpProp getEntityObject() {
        return sewaTanahBpProp;
    }

    public void requestEntityObject(SewaTanahBpProp sewaTanahBpProp) {
        try {
            this.requestParam();
            sewaTanahBpProp.setTanggal(JSPFormater.formatDate(getString(JSP_TANGGAL), "dd/MM/yyyy"));
            sewaTanahBpProp.setKeterangan(getString(JSP_KETERANGAN));
            sewaTanahBpProp.setRefnumber(getString(JSP_REFNUMBER));
            sewaTanahBpProp.setMem(getString(JSP_MEM));
            sewaTanahBpProp.setDebet(getDouble(JSP_DEBET));
            sewaTanahBpProp.setCredit(getDouble(JSP_CREDIT));
            sewaTanahBpProp.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
            sewaTanahBpProp.setSewaTanahInvId(getLong(JSP_SEWA_TANAH_INV_ID));
            sewaTanahBpProp.setMataUangId(getLong(JSP_MATA_UANG_ID));
            sewaTanahBpProp.setCustomerId(getLong(JSP_CUSTOMER_ID));
            sewaTanahBpProp.setLimbahTransactionId(getLong(JSP_LIMBAH_TRANSACTION_ID));
            sewaTanahBpProp.setIrigasiTransactionId(getLong(JSP_IRIGASI_TRANSACTION_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
