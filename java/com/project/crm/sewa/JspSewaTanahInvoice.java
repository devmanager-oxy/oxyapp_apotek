/* 
 * @author  	:  Eka Ds
 * @version  	:  1.0
 */
package com.project.crm.sewa;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspSewaTanahInvoice extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SewaTanahInvoice sewaTanahInvoice;
    public static final String JSP_NAME_SEWATANAHINVOICE = "JSP_NAME_SEWATANAHINVOICE";
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
    
    public static final int JSP_CREATE_ID = 32;
    public static final int JSP_APPROVE_ID = 33;
    public static final int JSP_CREATE_DATE = 34;
    public static final int JSP_APPROVE_DATE = 35;
    
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
        "JSP_SALES_DATA_ID","JSP_PRINT_XLS","JSP_PRINT_PDF",
        "JSP_CREATE_ID","JSP_APPROVE_ID","JSP_CREATE_DATE","JSP_APPROVE_DATE"
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
        TYPE_LONG,TYPE_INT,TYPE_INT,
        TYPE_LONG,TYPE_LONG,TYPE_DATE,TYPE_DATE
    };

    public JspSewaTanahInvoice() {
    }

    public JspSewaTanahInvoice(SewaTanahInvoice sewaTanahInvoice) {
        this.sewaTanahInvoice = sewaTanahInvoice;
    }

    public JspSewaTanahInvoice(HttpServletRequest request, SewaTanahInvoice sewaTanahInvoice) {
        super(new JspSewaTanahInvoice(sewaTanahInvoice), request);
        this.sewaTanahInvoice = sewaTanahInvoice;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAHINVOICE;
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

    public SewaTanahInvoice getEntityObject() {
        return sewaTanahInvoice;
    }

    public void requestEntityObject(SewaTanahInvoice sewaTanahInvoice) {
        try {
            this.requestParam();
            sewaTanahInvoice.setTanggal(getDate(JSP_TANGGAL));
            sewaTanahInvoice.setInvestorId(getLong(JSP_INVESTOR_ID));
            sewaTanahInvoice.setSaranaId(getLong(JSP_SARANA_ID));
            sewaTanahInvoice.setCurrencyId(getLong(JSP_CURRENCY_ID));
            sewaTanahInvoice.setJumlah(getDouble(JSP_JUMLAH));
            sewaTanahInvoice.setKeterangan(getString(JSP_KETERANGAN));
            sewaTanahInvoice.setJatuhTempo(getDate(JSP_JATUH_TEMPO));
            sewaTanahInvoice.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
            sewaTanahInvoice.setUserId(getLong(JSP_USER_ID));
            sewaTanahInvoice.setStatus(getInt(JSP_STATUS));
            sewaTanahInvoice.setTanggalInput(getDate(JSP_TANGGAL_INPUT));
            sewaTanahInvoice.setCounter(getInt(JSP_COUNTER));
            sewaTanahInvoice.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
            sewaTanahInvoice.setNumber(getString(JSP_NUMBER));
            sewaTanahInvoice.setType(getInt(JSP_TYPE));
            sewaTanahInvoice.setMasaInvoiceId(getLong(JSP_MASA_INVOICE_ID));
            sewaTanahInvoice.setJmlBulan(getInt(JSP_JML_BULAN));
            sewaTanahInvoice.setNoFp(getString(JSP_NO_FP));
            sewaTanahInvoice.setTotalDenda(getDouble(JSP_TOTAL_DENDA));
            sewaTanahInvoice.setDendaDiakui(getDouble(JSP_DENDA_DIAKUI));
            sewaTanahInvoice.setDendaApproveId(getLong(JSP_DENDA_APPROVE_ID));
            sewaTanahInvoice.setDendaApproveDate(getDate(JSP_DENDA_APPROVE_DATE));
            sewaTanahInvoice.setDendaKeterangan(getString(JSP_DENDA_KETERANGAN));
            sewaTanahInvoice.setDendaPostStatus(getInt(JSP_DENDA_POST_STATUS));
            sewaTanahInvoice.setDendaClientName(getString(JSP_DENDA_CLIENT_NAME));
            sewaTanahInvoice.setDendaClientPosition(getString(JSP_DENDA_CLIENT_POSITION));
            sewaTanahInvoice.setPaymentType(getInt(JSP_PAYMENT_TYPE));
            sewaTanahInvoice.setPaymentSimulationId(getLong(JSP_PAYMENT_SIMULATION_ID));
            sewaTanahInvoice.setSalesDataId(getLong(JSP_SALES_DATA_ID));
            sewaTanahInvoice.setStsPrintXls(getInt(JSP_STS_PRINT_XLS));
            sewaTanahInvoice.setStsPrintPdf(getInt(JSP_STS_PRINT_PDF));
            
            sewaTanahInvoice.setCreateId(getLong(JSP_CREATE_ID));
            sewaTanahInvoice.setApproveId(getLong(JSP_APPROVE_ID));
            sewaTanahInvoice.setCreateDate(getDate(JSP_CREATE_DATE));
            sewaTanahInvoice.setApproveDate(getDate(JSP_APPROVE_DATE));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
