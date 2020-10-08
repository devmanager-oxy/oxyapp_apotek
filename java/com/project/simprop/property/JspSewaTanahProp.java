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
public class JspSewaTanahProp extends JSPHandler implements I_JSPInterface, I_JSPType{

    private SewaTanahProp sewaTanahProp;
    
    public static final String JSP_NAME_SEWATANAHPROP = "JSP_NAME_SEWATANAHPROP";
    public static final int JSP_SEWA_TANAH_ID = 0;
    public static final int JSP_NOMOR_KONTRAK = 1;
    public static final int JSP_INVESTOR_ID = 2;
    public static final int JSP_CUSTOMER_ID = 3;
    public static final int JSP_JENIS_BANGUNAN = 4;
    public static final int JSP_LOT_ID = 5;
    public static final int JSP_LUAS = 6;
    public static final int JSP_JML_KAMAR = 7;
    public static final int JSP_DASAR_KOMIN = 8;
    public static final int JSP_TANGGAL_MULAI = 9;
    public static final int JSP_TANGGAL_SELESAI = 10;
    public static final int JSP_STATUS = 11;
    public static final int JSP_TANGGAL_INPUT = 12;
    public static final int JSP_RATE = 13;
    public static final int JSP_PENAMBAHAN_KONTRAK = 14;
    public static final int JSP_CURRENCY_ID = 15;
    public static final int JSP_ASSESMENT_STATUS = 16;
    public static final int JSP_TGL_MULAI_KOMIN = 17;
    public static final int JSP_TGL_MULAI_KOMPER = 18;
    public static final int JSP_TGL_MULAI_ASSESMENT = 19;
    public static final int JSP_KETERANGAN_AMANDEMEN = 20;
    public static final int JSP_TGL_INVOICE_KOMIN = 21;
    public static final int JSP_TGL_INVOICE_ASSESMENT = 22;
    
    public static String[] colNames = {
        "JSP_SEWA_TANAH_ID",
        "JSP_NOMOR_KONTRAK",
        "JSP_INVESTOR_ID",
        "JSP_CUSTOMER_ID",
        "JSP_JENIS_BANGUNAN",
        "JSP_LOT_ID",
        "JSP_LUAS",
        "JSP_JML_KAMAR",
        "JSP_DASAR_KOMIN",
        "JSP_TANGGAL_MULAI",
        "JSP_TANGGAL_SELESAI",
        "JSP_STATUS",
        "JSP_TANGGAL_INPUT",
        "JSP_RATE",
        "JSP_PENAMBAHAN_KONTRAK",
        "JSP_CURRENCY_ID",
        "JSP_ASSESMENT_STATUS",
        "JSP_TGL_MULAI_KOMIN",
        "JSP_TGL_MILAI_KOMPER",
        "JSP_TGL_MULAI_ASSESMENT",
        "JSP_KETERANGAN_AMANDEMEN",
        "JSP_TGL_INVOICE_KOMIN",
        "JSP_TGL_INVOICE_ASSESMENT"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    public JspSewaTanahProp() {
    }

    public JspSewaTanahProp(SewaTanahProp sewaTanahProp) {
        this.sewaTanahProp = sewaTanahProp;
    }

    public JspSewaTanahProp(HttpServletRequest request, SewaTanahProp sewaTanahProp) {
        super(new JspSewaTanahProp(sewaTanahProp), request);
        this.sewaTanahProp = sewaTanahProp;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAHPROP;
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

    public SewaTanahProp getEntityObject() {
        return sewaTanahProp;
    }

    public void requestEntityObject(SewaTanahProp sewaTanahProp) {
        try {
            this.requestParam();
            sewaTanahProp.setNomorKontrak(getString(JSP_NOMOR_KONTRAK));
            sewaTanahProp.setInvestorId(getLong(JSP_INVESTOR_ID));
            sewaTanahProp.setCustomerId(getLong(JSP_CUSTOMER_ID));
            sewaTanahProp.setJenisBangunan(getInt(JSP_JENIS_BANGUNAN));
            sewaTanahProp.setLotId(getLong(JSP_LOT_ID));
            sewaTanahProp.setLuas(getDouble(JSP_LUAS));
            sewaTanahProp.setJmlKamar(getInt(JSP_JML_KAMAR));
            sewaTanahProp.setDasarKomin(getInt(JSP_DASAR_KOMIN));
            sewaTanahProp.setTanggalMulai(JSPFormater.formatDate(getString(JSP_TANGGAL_MULAI), "dd/MM/yyyy"));
            sewaTanahProp.setTanggalSelesai(JSPFormater.formatDate(getString(JSP_TANGGAL_SELESAI), "dd/MM/yyyy"));
            sewaTanahProp.setStatus(getInt(JSP_STATUS));
            sewaTanahProp.setTanggalInput(JSPFormater.formatDate(getString(JSP_TANGGAL_INPUT), "dd/MM/yyyy"));
            sewaTanahProp.setRate(getDouble(JSP_RATE));
            sewaTanahProp.setPenambahanKontrak(getInt(JSP_PENAMBAHAN_KONTRAK));
            sewaTanahProp.setCurrencyId(getLong(JSP_CURRENCY_ID));
            sewaTanahProp.setAssesmentStatus(getInt(JSP_ASSESMENT_STATUS));
            sewaTanahProp.setTglMulaiKomin(JSPFormater.formatDate(getString(JSP_TGL_MULAI_KOMIN), "dd/MM/yyyy"));
            sewaTanahProp.setTglMulaiKomper(JSPFormater.formatDate(getString(JSP_TGL_MULAI_KOMPER), "dd/MM/yyyy"));
            sewaTanahProp.setTglMulaiAssesment(JSPFormater.formatDate(getString(JSP_TGL_MULAI_ASSESMENT), "dd/MM/yyyy"));
            sewaTanahProp.setKeteranganAmandemen(getString(JSP_KETERANGAN_AMANDEMEN));
            sewaTanahProp.setTglInvoiceKomin(JSPFormater.formatDate(getString(JSP_TGL_INVOICE_KOMIN), "dd/MM/yyyy"));
            sewaTanahProp.setTglInvoiceAssesment(JSPFormater.formatDate(getString(JSP_TGL_INVOICE_ASSESMENT), "dd/MM/yyyy"));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
