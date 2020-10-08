/* 
 * @author  	:  Eka Ds
 * @version  	:  1.0
 */
package com.project.crm.sewa;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspSewaTanah extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SewaTanah sewaTanah;
    public static final String JSP_NAME_SEWATANAH = "JSP_NAME_SEWATANAH";
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

    public JspSewaTanah() {
    }

    public JspSewaTanah(SewaTanah sewaTanah) {
        this.sewaTanah = sewaTanah;
    }

    public JspSewaTanah(HttpServletRequest request, SewaTanah sewaTanah) {
        super(new JspSewaTanah(sewaTanah), request);
        this.sewaTanah = sewaTanah;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAH;
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

    public SewaTanah getEntityObject() {
        return sewaTanah;
    }

    public void requestEntityObject(SewaTanah sewaTanah) {
        try {
            this.requestParam();
            sewaTanah.setNomorKontrak(getString(JSP_NOMOR_KONTRAK));
            sewaTanah.setInvestorId(getLong(JSP_INVESTOR_ID));
            sewaTanah.setCustomerId(getLong(JSP_CUSTOMER_ID));
            sewaTanah.setJenisBangunan(getInt(JSP_JENIS_BANGUNAN));
            sewaTanah.setLotId(getLong(JSP_LOT_ID));
            sewaTanah.setLuas(getDouble(JSP_LUAS));
            sewaTanah.setJmlKamar(getInt(JSP_JML_KAMAR));
            sewaTanah.setDasarKomin(getInt(JSP_DASAR_KOMIN));
            sewaTanah.setTanggalMulai(JSPFormater.formatDate(getString(JSP_TANGGAL_MULAI), "dd/MM/yyyy"));
            sewaTanah.setTanggalSelesai(JSPFormater.formatDate(getString(JSP_TANGGAL_SELESAI), "dd/MM/yyyy"));
            sewaTanah.setStatus(getInt(JSP_STATUS));
            sewaTanah.setTanggalInput(JSPFormater.formatDate(getString(JSP_TANGGAL_INPUT), "dd/MM/yyyy"));
            sewaTanah.setRate(getDouble(JSP_RATE));
            sewaTanah.setPenambahanKontrak(getInt(JSP_PENAMBAHAN_KONTRAK));
            sewaTanah.setCurrencyId(getLong(JSP_CURRENCY_ID));
            sewaTanah.setAssesmentStatus(getInt(JSP_ASSESMENT_STATUS));
            sewaTanah.setTglMulaiKomin(JSPFormater.formatDate(getString(JSP_TGL_MULAI_KOMIN), "dd/MM/yyyy"));
            sewaTanah.setTglMulaiKomper(JSPFormater.formatDate(getString(JSP_TGL_MULAI_KOMPER), "dd/MM/yyyy"));
            sewaTanah.setTglMulaiAssesment(JSPFormater.formatDate(getString(JSP_TGL_MULAI_ASSESMENT), "dd/MM/yyyy"));
            sewaTanah.setKeteranganAmandemen(getString(JSP_KETERANGAN_AMANDEMEN));
            sewaTanah.setTglInvoiceKomin(JSPFormater.formatDate(getString(JSP_TGL_INVOICE_KOMIN), "dd/MM/yyyy"));
            sewaTanah.setTglInvoiceAssesment(JSPFormater.formatDate(getString(JSP_TGL_INVOICE_ASSESMENT), "dd/MM/yyyy"));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
