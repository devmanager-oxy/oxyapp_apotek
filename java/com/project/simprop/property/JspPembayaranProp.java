/* 
 * @author  	:  Eka Ds
 * @version  	:  1.0
 */
package com.project.simprop.property;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspPembayaranProp extends JSPHandler implements I_JSPInterface, I_JSPType {

    private PembayaranProp pembayaranProp;
    public static final String JSP_NAME_PEMBAYARANPROP = "JSP_NAME_PEMBAYARANPROP";
    public static final int JSP_PEMBAYARAN_ID = 0;
    public static final int JSP_TRANSACTION_SOURCE = 1;
    public static final int JSP_TYPE = 2;
    public static final int JSP_NO_BKM = 3;
    public static final int JSP_COUNTER = 4;
    public static final int JSP_NO_KWITANSI = 5;
    public static final int JSP_NO_INVOICE = 6;
    public static final int JSP_TANGGAL_INVOICE = 7;
    public static final int JSP_TANGGAL = 8;
    public static final int JSP_MATA_UANG_ID = 9;
    public static final int JSP_EXCHANGE_RATE = 10;
    public static final int JSP_CUSTOMER_ID = 11;
    public static final int JSP_IRIGASI_TRANSACTION_ID = 12;
    public static final int JSP_LIMBAH_TRANSACTION_ID = 13;
    public static final int JSP_JUMLAH = 14;
    public static final int JSP_CREATE_BY_ID = 15;
    public static final int JSP_POSTED_BY_ID = 16;
    public static final int JSP_POSTED_DATE = 17;
    public static final int JSP_PERIOD_ID = 18;
    public static final int JSP_GL_ID = 19;
    public static final int JSP_STATUS = 20;
    public static final int JSP_PAYMENT_ACCOUNT_ID = 21;
    public static final int JSP_SEWA_TANAH_INVOICE_ID = 22;
    public static final int JSP_SEWA_TANAH_BENEFIT_ID = 23;
    public static final int JSP_DENDA_ID = 24;
    public static final int JSP_FOREIGN_AMOUNT = 25;
    public static final int JSP_MEMO = 26;
    
    public static String[] colNames = {
        "JSP_PEMBAYARAN_ID",
        "JSP_TRANSACTION_SOURCE",
        "JSP_TYPE",
        "JSP_NO_BKM",
        "JSP_COUNTER",
        "JSP_NO_KWITANSI",
        "JSP_NO_INVOICE",
        "JSP_TANGGAL_INVOICE",
        "JSP_TANGGAL",
        "JSP_MATA_UANG_ID",
        "JSP_EXCHANGE_RATE",
        "JSP_CUSTOMER_ID",
        "JSP_IRIGASI_TRANSACTION_ID",
        "JSP_LIMBAH_TRANSACTION_ID",
        "JSP_JUMLAH",
        "JSP_CREATE_BY_ID",
        "JSP_POSTED_BY_ID",
        "JSP_POSTED_DATE",
        "JSP_PERIOD_ID",
        "JSP_GL_ID",
        "JSP_STATUS",
        "JSP_PAYMENT_ACCOUNT_ID",
        "JSP_SEWA_TANAH_INVOICE_ID",
        "JSP_SEWA_TANAH_BENEFIT_ID",
        "JSP_DENDA_ID",
        "JSP_FOREIGN_AMOUNT",
        "JSP_MEMO"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING + ENTRY_REQUIRED, //JSP_NO_INVOICE
        TYPE_DATE,
        TYPE_STRING + ENTRY_REQUIRED, //JSP_TANGGAL
        TYPE_LONG,
        TYPE_FLOAT, //JSP_EXCHANGE_RATE
        TYPE_LONG + ENTRY_REQUIRED, //JSP_CUSTOMER_ID
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT + ENTRY_REQUIRED, //JSP_JUMLAH
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG + ENTRY_REQUIRED, //JSP_PAYMENT_ACCOUNT_ID
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING
    };

    public JspPembayaranProp() {
    }

    public JspPembayaranProp(PembayaranProp pembayaranProp) {
        this.pembayaranProp = pembayaranProp;
    }

    public JspPembayaranProp(HttpServletRequest request, PembayaranProp pembayaranProp) {
        super(new JspPembayaranProp(pembayaranProp), request);
        this.pembayaranProp = pembayaranProp;
    }

    public String getFormName() {
        return JSP_NAME_PEMBAYARANPROP;
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

    public PembayaranProp getEntityObject() {
        return pembayaranProp;
    }

    public void requestEntityObject(PembayaranProp pembayaranProp) {
        try {
            this.requestParam();
            pembayaranProp.setTransactionSource(getInt(JSP_TRANSACTION_SOURCE));
            pembayaranProp.setType(getInt(JSP_TYPE));            
            pembayaranProp.setNoKwitansi(getString(JSP_NO_KWITANSI));
            pembayaranProp.setNoInvoice(getString(JSP_NO_INVOICE));
            pembayaranProp.setTanggalInvoice(getDate(JSP_TANGGAL_INVOICE));
            pembayaranProp.setTanggal(JSPFormater.formatDate(getString(JSP_TANGGAL), "dd/MM/yyyy"));
            pembayaranProp.setMataUangId(getLong(JSP_MATA_UANG_ID));
            pembayaranProp.setExchangeRate(getDouble(JSP_EXCHANGE_RATE));
            pembayaranProp.setCustomerId(getLong(JSP_CUSTOMER_ID));
            pembayaranProp.setIrigasiTransactionId(getLong(JSP_IRIGASI_TRANSACTION_ID));
            pembayaranProp.setLimbahTransactionId(getLong(JSP_LIMBAH_TRANSACTION_ID));
            pembayaranProp.setJumlah(getDouble(JSP_JUMLAH));
            pembayaranProp.setCreateById(getLong(JSP_CREATE_BY_ID));
            pembayaranProp.setPostedById(getLong(JSP_POSTED_BY_ID));
            pembayaranProp.setPostedDate(getDate(JSP_POSTED_DATE));
            pembayaranProp.setPeriodId(getLong(JSP_PERIOD_ID));
            pembayaranProp.setGlId(getLong(JSP_GL_ID));
            pembayaranProp.setStatus(getInt(JSP_STATUS));
            pembayaranProp.setPaymentAccountId(getLong(JSP_PAYMENT_ACCOUNT_ID));
            pembayaranProp.setSewaTanahInvoiceId(getLong(JSP_SEWA_TANAH_INVOICE_ID));
            pembayaranProp.setSewaTanahBenefitId(getLong(JSP_SEWA_TANAH_BENEFIT_ID));
            pembayaranProp.setDendaId(getLong(JSP_DENDA_ID));
            pembayaranProp.setForeignAmount(getDouble(JSP_FOREIGN_AMOUNT));
            pembayaranProp.setMemo(getString(JSP_MEMO));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
