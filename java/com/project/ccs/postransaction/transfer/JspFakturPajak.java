package com.project.ccs.postransaction.transfer;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspFakturPajak extends JSPHandler implements I_JSPInterface, I_JSPType {

    private FakturPajak fakturPajak;
    public static final String JSP_NAME_FAKTUR_PAJAK = "JSP_NAME_FAKTUR_PAJAK";
    public static final int JSP_FAKTUR_PAJAK_ID = 0;
    public static final int JSP_NAMA_PKP = 1;
    public static final int JSP_NUMBER = 2;
    public static final int JSP_COUNTER = 3;
    public static final int JSP_TRANSFER_NUMBER = 4;
    public static final int JSP_SALES_NUMBER = 5;
    public static final int JSP_DATE = 6;    
    public static final int JSP_PKP_ADDRESS = 7;
    public static final int JSP_NPWP_PKP = 8;
    public static final int JSP_CUSTOMER_ID = 9;
    public static final int JSP_CUSTOMER_ADDRESS = 10;
    public static final int JSP_NPWP_CUSTOMER = 11;
    public static final int JSP_SALES_ID = 12;
    public static final int JSP_PREFIX_NUMBER = 13;
    public static final int JSP_LOCATION_ID = 14;
    public static final int JSP_TYPE_FAKTUR = 15;
    public static final int JSP_LOCATION_TO_ID = 16;
    
    public static String[] colNames = {
        "JSP_FAKTUR_PAJAK_ID", "JSP_NAMA_PKP",
        "JSP_NUMBER", "JSP_COUNTER",        
        "JSP_TRANSFER_NUMBER", "JSP_SALES_NUMBER",
        "JSP_DATE",
        "JSP_PKP_ADDRESS","JSP_NPWP_PKP",
        "JSP_CUSTOMER_ID","JSP_CUSTOMER_ADDRESS",
        "JSP_NPWP_CUSTOMER","JSP_SALES_ID",        
        "JSP_PREFIX_NUMBER","JSP_LOCATION_ID",
        "JSP_TYPE_FAKTUR","JSP_LOCATION_TO_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING, TYPE_STRING,
        TYPE_INT, TYPE_STRING, 
        TYPE_STRING,
        TYPE_DATE,TYPE_STRING,
        TYPE_STRING,TYPE_LONG,        
        TYPE_STRING,TYPE_STRING,
        TYPE_LONG,TYPE_STRING,
        TYPE_LONG,TYPE_INT,
        TYPE_LONG
    };

    public JspFakturPajak() {
    }

    public JspFakturPajak(FakturPajak fakturPajak) {
        this.fakturPajak = fakturPajak;
    }

    public JspFakturPajak(HttpServletRequest request, FakturPajak fakturPajak) {
        super(new JspFakturPajak(fakturPajak), request);
        this.fakturPajak = fakturPajak;
    }

    public String getFormName() {
        return JSP_NAME_FAKTUR_PAJAK;
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

    public FakturPajak getEntityObject() {
        return fakturPajak;
    }

    public void requestEntityObject(FakturPajak fakturPajak) {
        try {
            
            this.requestParam(); 
            
            fakturPajak.setNama_pkp(getString(JSP_NAMA_PKP));
            fakturPajak.setTransfer_number(getString(JSP_TRANSFER_NUMBER));
            fakturPajak.setSalesNumber(getString(JSP_SALES_NUMBER));            
            fakturPajak.setDate(JSPFormater.formatDate(getString(JSP_DATE), "dd-MM-yyyy hh:mm:ss"));            
            fakturPajak.setSalesNumber(getString(JSP_SALES_NUMBER));            
            fakturPajak.setPkpAddress(getString(JSP_PKP_ADDRESS));            
            fakturPajak.setNpwpPkp(getString(JSP_NPWP_PKP));
            fakturPajak.setCustomerId(getLong(JSP_CUSTOMER_ID));
            fakturPajak.setNpwpCustomer(getString(JSP_NPWP_CUSTOMER));
            fakturPajak.setSalesId(getLong(JSP_SALES_ID));
            fakturPajak.setLocationId(getLong(JSP_LOCATION_ID));
            fakturPajak.setTypeFaktur(getInt(JSP_TYPE_FAKTUR));
            fakturPajak.setLocationToId(getLong(JSP_LOCATION_TO_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
