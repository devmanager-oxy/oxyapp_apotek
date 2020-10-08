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

public class JspSewaTanahBenefit extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SewaTanahBenefit sewaTanahBenefit;
    public static final String JSP_NAME_SEWATANAHBENEFIT = "JSP_NAME_SEWATANAHBENEFIT";
    public static final int JSP_SEWA_TANAH_BENEFIT_ID = 0;
    public static final int JSP_SEWA_TANAH_ID = 1;
    public static final int JSP_TANGGAL = 2;
    public static final int JSP_TANGGAL_BENEFIT = 3;
    public static final int JSP_INVESTOR_ID = 4;
    public static final int JSP_SARANA_ID = 5;
    public static final int JSP_COUNTER = 6;
    public static final int JSP_PREFIX_NUMBER = 7;
    public static final int JSP_NUMBER = 8;
    public static final int JSP_KETERANGAN = 9;
    public static final int JSP_STATUS = 10;
    public static final int JSP_CREATED_BY_ID = 11;
    public static final int JSP_APPROVED_BY_ID = 12;
    public static final int JSP_APPROVED_BY_DATE = 13;
    public static final int JSP_SEWA_TANAH_INVOICE_ID = 14;
    public static final int JSP_CURRENCY_ID = 15;
    public static final int JSP_JATUH_TEMPO = 16;
    public static final int JSP_NO_FP = 17;
    public static final int JSP_DENDA_DIAKUI = 18;
    public static final int JSP_DENDA_APPROVE_ID = 19;
    public static final int JSP_DENDA_APPROVE_DATE = 20;
    public static final int JSP_DENDA_KETERANGAN = 21;
    public static final int JSP_DENDA_POST_STATUS = 22;
    public static final int JSP_DENDA_CLIENT_NAME = 23;
    public static final int JSP_DENDA_CLIENT_POSITION = 24;
    
    
    public static String[] colNames = {
        "JSP_SEWA_TANAH_BENEFIT_ID",//0
        "JSP_SEWA_TANAH_ID",//1
        "JSP_TANGGAL",//2
        "JSP_TANGGAL_BENEFIT",//3
        "JSP_INVESTOR_ID",//4
        "JSP_SARANA_ID",//5
        "JSP_COUNTER",//6
        "JSP_PREFIX_NUMBER",//7
        "JSP_NUMBER",//8
        "JSP_KETERANGAN",//9
        "JSP_STATUS",//10
        "JSP_CREATED_BY_ID",//11
        "JSP_APPROVED_BY_ID",//12
        "JSP_APPROVED_BY_DATE",//13
        "JSP_SEWA_TANAH_INVOICE_ID",//14
        "JSP_CURRENCY_ID",//15
        "JSP_JATUH_TEMPO",//16
        "JSP_NO_FP",//17
        "JSP_DENDA_DIAKUI",//18        
        "JSP_DENDA_APPROVE_ID",//19
        "JSP_DENDA_APPROVE_DATE",//20
        "JSP_DENDA_KETERANGAN",//21
        "JSP_DENDA_POST_STATUS",//22
        "JSP_DENDA_CLIENT_NAME",//23
        "JSP_DENDA_CLIENT_POSITION"//24
    };
    public static int[] fieldTypes = {
        TYPE_LONG,//0
        TYPE_LONG,//1
        TYPE_DATE,//2
        TYPE_STRING + ENTRY_REQUIRED,//3
        TYPE_LONG + ENTRY_REQUIRED,//4
        TYPE_LONG + ENTRY_REQUIRED,//5
        TYPE_INT,//6
        TYPE_STRING,//7
        TYPE_STRING,//8
        TYPE_STRING,//9
        TYPE_STRING,//10
        TYPE_LONG,//11
        TYPE_LONG,//12
        TYPE_LONG,//13
        TYPE_LONG,//14
        TYPE_LONG,//15
        TYPE_STRING,//16
        TYPE_STRING,//17                
        TYPE_FLOAT,//18        
        TYPE_LONG,//19                
        TYPE_DATE,//20
        TYPE_STRING,//21
        TYPE_INT,//22
        TYPE_STRING,//23
        TYPE_STRING,//24
                
    };

    
    public JspSewaTanahBenefit() {
    }

    public JspSewaTanahBenefit(SewaTanahBenefit sewaTanahBenefit) {
        this.sewaTanahBenefit = sewaTanahBenefit;
    }

    public JspSewaTanahBenefit(HttpServletRequest request, SewaTanahBenefit sewaTanahBenefit) {
        super(new JspSewaTanahBenefit(sewaTanahBenefit), request);
        this.sewaTanahBenefit = sewaTanahBenefit;
    }

    public String getFormName() {
        return JSP_NAME_SEWATANAHBENEFIT;
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

    public SewaTanahBenefit getEntityObject() {
        return sewaTanahBenefit;
    }

    public void requestEntityObject(SewaTanahBenefit sewaTanahBenefit) {
        try {
            this.requestParam();
            sewaTanahBenefit.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
            //sewaTanahBenefit.setTanggal(getDate(JSP_TANGGAL));
            sewaTanahBenefit.setTanggalBenefit(JSPFormater.formatDate(getString(JSP_TANGGAL_BENEFIT), "dd/MM/yyyy"));
            sewaTanahBenefit.setJatuhTempo(JSPFormater.formatDate(getString(JSP_JATUH_TEMPO), "dd/MM/yyyy"));
            sewaTanahBenefit.setInvestorId(getLong(JSP_INVESTOR_ID));
            sewaTanahBenefit.setSaranaId(getLong(JSP_SARANA_ID));
            //sewaTanahBenefit.setCounter(getInt(JSP_COUNTER));
            //sewaTanahBenefit.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
            //sewaTanahBenefit.setNumber(getString(JSP_NUMBER));
            sewaTanahBenefit.setKeterangan(getString(JSP_KETERANGAN));
            //sewaTanahBenefit.setStatus(getString(JSP_STATUS));
            sewaTanahBenefit.setCreatedById(getLong(JSP_CREATED_BY_ID));
            //sewaTanahBenefit.setApprovedById(getLong(JSP_APPROVED_BY_ID));
            //sewaTanahBenefit.setApprovedByDate(getLong(JSP_APPROVED_BY_DATE));
            sewaTanahBenefit.setSewaTanahInvoiceId(getLong(JSP_SEWA_TANAH_INVOICE_ID));
            sewaTanahBenefit.setCurrencyId(getLong(JSP_CURRENCY_ID));
            sewaTanahBenefit.setNoFp(getString(JSP_NO_FP));
            sewaTanahBenefit.setDendaDiakui(getDouble(JSP_DENDA_DIAKUI));
            sewaTanahBenefit.setDendaApproveId(getLong(JSP_DENDA_APPROVE_ID));
            sewaTanahBenefit.setDendaApproveDate(getDate(JSP_DENDA_APPROVE_DATE));
            sewaTanahBenefit.setDendaKeterangan(getString(JSP_DENDA_KETERANGAN));
            sewaTanahBenefit.setDendaPostStatus(getInt(JSP_DENDA_POST_STATUS));
            sewaTanahBenefit.setDendaClientName(getString(JSP_DENDA_CLIENT_NAME));
            sewaTanahBenefit.setDendaClientPosition(getString(JSP_DENDA_CLIENT_POSITION));
            
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
