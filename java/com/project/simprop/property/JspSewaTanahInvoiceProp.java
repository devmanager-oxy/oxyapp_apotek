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
public class JspSewaTanahInvoiceProp extends JSPHandler implements I_JSPInterface, I_JSPType  {
    
    private SewaTanahInvoiceProp sewaTanahInvoiceProp;
    
    public static final String JSP_NAME_SEWATANAHINVOICEPROP = "JSP_NAME_SEWATANAHINVOICEPROP";
    public static final int JSP_SEWA_TANAH_INVOICE_ID = 0;
    public static final int JSP_TANGGAL = 1;
    public static final int JSP_INVESTOR_ID = 2;
    public static final int JSP_SARANA_ID = 3;
    public static final int JSP_CURRENCY_ID = 4;
    public static final int JSP_JUMLAH = 5;
    public static final int JSP_KETERANGAN = 6;
    public static final int JSP_JATUH_TEMPO = 7;
    public static final int JSP_SEWA_TANAH_ID = 8;
    public static final int JSP_USER_ID = 9;
    public static final int JSP_STATUS = 10;
    public static final int JSP_TANGGAL_INPUT = 11;
    public static final int JSP_COUNTER = 12;
    public static final int JSP_PREFIX_NUMBER = 13;
    public static final int JSP_NUMBER = 14;
    public static final int JSP_TYPE = 15;
    public static final int JSP_MASA_INVOICE_ID = 16;
    public static final int JSP_JML_BULAN = 17;
    public static final int JSP_NO_FP = 18;
    public static final int JSP_TOTAL_DENDA = 19;
    public static final int JSP_DENDA_DIAKUI = 20;
    public static final int JSP_DENDA_APPROVE_ID = 21;
    public static final int JSP_DENDA_APPROVE_DATE = 22;
    public static final int JSP_DENDA_KETERANGAN = 23;
    public static final int JSP_DENDA_POST_STATUS = 24;
    public static final int JSP_DENDA_CLIENT_NAME = 25;
    public static final int JSP_DENDA_CLIENT_POSITION = 26;
    public static final int JSP_PAYMENT_TYPE = 27;
    public static final int JSP_PAYMENT_SIMULATION_ID = 28;
    public static final int JSP_SALES_DATA_ID = 29;    
    public static final int JSP_STS_PRINT_XLS = 30;
    public static final int JSP_STS_PRINT_PDF = 31;
    
    public static String[] colNames = {
        "JSP_SEWA_TANAH_INVOICE_ID", "JSP_TANGGAL",
        "JSP_INVESTOR_ID", "JSP_SARANA_ID",
        "JSP_CURRENCY_ID", "JSP_JUMLAH",
        "JSP_KETERANGAN", "JSP_JATUH_TEMPO",
        "JSP_SEWA_TANAH_ID", "JSP_USER_ID",
        "JSP_STATUS", "JSP_TANGGAL_INPUT",
        "JSP_COUNTER", "JSP_PREFIX_NUMBER",
        "JSP_NUMBER", "JSP_TYPE",
        "JSP_MASA_INVOICE_ID", "JSP_JML_BULAN",
        "JSP_NO_FP", "JSP_TOTAL_DENDA",
        "JSP_DENDA_DIAKUI", "JSP_DENDA_APPROVE_ID",
        "JSP_DENDA_APPROVE_DATE", "JSP_DENDA_KETERANGAN",
        "JSP_DENDA_POST_STATUS", "JSP_DENDA_CLIENT_NAME",
        "JSP_DENDA_CLIENT_POSITION","PAYMENT_TYPE","JSP_PAYMENT_SIMULATION_ID",
        "JSP_SALES_DATA_ID","JSP_PRINT_XLS","JSP_PRINT_PDF"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_DATE,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG, TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_DATE + ENTRY_REQUIRED,
        TYPE_LONG, TYPE_LONG,
        TYPE_INT, TYPE_DATE,
        TYPE_INT, TYPE_STRING,
        TYPE_STRING, TYPE_INT,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_INT + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_LONG,
        TYPE_DATE, TYPE_STRING,
        TYPE_INT, TYPE_STRING, TYPE_STRING,TYPE_INT,TYPE_LONG,
        TYPE_LONG,TYPE_INT,TYPE_INT
    };

    public JspSewaTanahInvoiceProp() {
    }

    public JspSewaTanahInvoiceProp(SewaTanahInvoiceProp sewaTanahInvoiceProp) {
        this.sewaTanahInvoiceProp = sewaTanahInvoiceProp;
    }

    public JspSewaTanahInvoiceProp(HttpServletRequest request, SewaTanahInvoiceProp sewaTanahInvoiceProp) {
        super(new JspSewaTanahInvoiceProp(sewaTanahInvoiceProp), request);
        this.sewaTanahInvoiceProp = sewaTanahInvoiceProp;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAHINVOICEPROP;
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

    public SewaTanahInvoiceProp getEntityObject() {
        return sewaTanahInvoiceProp;
    }

    public void requestEntityObject(SewaTanahInvoiceProp sewaTanahInvoiceProp) {
        try {
            this.requestParam();
            sewaTanahInvoiceProp.setTanggal(getDate(JSP_TANGGAL));
            sewaTanahInvoiceProp.setInvestorId(getLong(JSP_INVESTOR_ID));
            sewaTanahInvoiceProp.setSaranaId(getLong(JSP_SARANA_ID));
            sewaTanahInvoiceProp.setCurrencyId(getLong(JSP_CURRENCY_ID));
            sewaTanahInvoiceProp.setJumlah(getDouble(JSP_JUMLAH));
            sewaTanahInvoiceProp.setKeterangan(getString(JSP_KETERANGAN));
            sewaTanahInvoiceProp.setJatuhTempo(getDate(JSP_JATUH_TEMPO));
            sewaTanahInvoiceProp.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
            sewaTanahInvoiceProp.setUserId(getLong(JSP_USER_ID));
            sewaTanahInvoiceProp.setStatus(getInt(JSP_STATUS));
            sewaTanahInvoiceProp.setTanggalInput(getDate(JSP_TANGGAL_INPUT));
            sewaTanahInvoiceProp.setCounter(getInt(JSP_COUNTER));
            sewaTanahInvoiceProp.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
            sewaTanahInvoiceProp.setNumber(getString(JSP_NUMBER));
            sewaTanahInvoiceProp.setType(getInt(JSP_TYPE));
            sewaTanahInvoiceProp.setMasaInvoiceId(getLong(JSP_MASA_INVOICE_ID));
            sewaTanahInvoiceProp.setJmlBulan(getInt(JSP_JML_BULAN));
            sewaTanahInvoiceProp.setNoFp(getString(JSP_NO_FP));
            sewaTanahInvoiceProp.setTotalDenda(getDouble(JSP_TOTAL_DENDA));
            sewaTanahInvoiceProp.setDendaDiakui(getDouble(JSP_DENDA_DIAKUI));
            sewaTanahInvoiceProp.setDendaApproveId(getLong(JSP_DENDA_APPROVE_ID));
            sewaTanahInvoiceProp.setDendaApproveDate(getDate(JSP_DENDA_APPROVE_DATE));
            sewaTanahInvoiceProp.setDendaKeterangan(getString(JSP_DENDA_KETERANGAN));
            sewaTanahInvoiceProp.setDendaPostStatus(getInt(JSP_DENDA_POST_STATUS));
            sewaTanahInvoiceProp.setDendaClientName(getString(JSP_DENDA_CLIENT_NAME));
            sewaTanahInvoiceProp.setDendaClientPosition(getString(JSP_DENDA_CLIENT_POSITION));
            sewaTanahInvoiceProp.setPaymentType(getInt(JSP_PAYMENT_TYPE));
            sewaTanahInvoiceProp.setPaymentSimulationId(getLong(JSP_PAYMENT_SIMULATION_ID));
            sewaTanahInvoiceProp.setSalesDataId(getLong(JSP_SALES_DATA_ID));
            sewaTanahInvoiceProp.setStsPrintXls(getInt(JSP_STS_PRINT_XLS));
            sewaTanahInvoiceProp.setStsPrintPdf(getInt(JSP_STS_PRINT_PDF));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
