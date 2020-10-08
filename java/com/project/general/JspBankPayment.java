/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy
 */
public class JspBankPayment extends JSPHandler implements I_JSPInterface, I_JSPType {

    private BankPayment bankPayment;
    
    public static final String JSP_NAME_BANK_PAYMENT = "JSP_NAME_BANK_PAYMENT";
    
    public static final int JSP_BANK_PAYMENT_ID = 0;
    public static final int JSP_TYPE = 1;
    public static final int JSP_CREATE_DATE = 2;    
    public static final int JSP_JOURNAL_NUMBER = 3;
    public static final int JSP_JOURNAL_PREFIX = 4;
    public static final int JSP_JOURNAL_COUNTER = 5;
    public static final int JSP_CURRENCY_ID = 6;
    public static final int JSP_CREATE_ID = 7;
    public static final int JSP_DUE_DATE = 8;
    public static final int JSP_AMOUNT = 9;
    public static final int JSP_COA_ID = 10;
    public static final int JSP_COA_PAYMENT_ID = 11;
    public static final int JSP_PAYMENT_DATE = 12;
    public static final int JSP_REFERENSI_ID = 13;    
    public static final int JSP_STATUS = 14;
    public static final int JSP_SEGMENT1_ID = 15;
    public static final int JSP_SEGMENT2_ID = 16;
    public static final int JSP_SEGMENT3_ID = 17;
    public static final int JSP_SEGMENT4_ID = 18;    
    public static final int JSP_SEGMENT5_ID = 19;
    public static final int JSP_SEGMENT6_ID = 20;
    public static final int JSP_SEGMENT7_ID = 21;
    public static final int JSP_SEGMENT8_ID = 22;
    public static final int JSP_SEGMENT9_ID = 23;
    public static final int JSP_SEGMENT10_ID = 24;
    public static final int JSP_SEGMENT11_ID = 25;
    public static final int JSP_SEGMENT12_ID = 26;
    public static final int JSP_SEGMENT13_ID = 27;
    public static final int JSP_SEGMENT14_ID = 28;
    public static final int JSP_SEGMENT15_ID = 29;    
    public static final int JSP_TRANSACTION_DATE = 30;
    public static final int JSP_VENDOR_ID = 31;
    public static final int JSP_NUMBER = 32;
    public static final int JSP_BANK_ID = 33;
    public static final int JSP_SYSTEM_DOC_NUMBER_ID = 34;       
    
    public static String[] colNames = {
        "JSP_BANK_PAYMENT_ID",
        "JSP_TYPE",
        "JSP_CREATE_DATE",
        "JSP_JOURNAL_NUMBER",
        "JSP_JOURNAL_PREFIX",
        "JSP_JOURNAL_COUNTER",
        "JSP_CURRENCY_ID",
        "JSP_CREATE_ID",
        "JSP_DUE_DATE",
        "JSP_AMOUNT",
        "JSP_COA_ID",
        "JSP_COA_PAYMENT_ID",
        "JSP_PAYMENT_DATE",
        "JSP_REFERENSI_ID",
        "JSP_STATUS",
        "JSP_SEGMENT1_ID",
        "JSP_SEGMENT2_ID",
        "JSP_SEGMENT3_ID",
        "JSP_SEGMENT4_ID",
        "JSP_SEGMENT5_ID",
        "JSP_SEGMENT6_ID",
        "JSP_SEGMENT7_ID",
        "JSP_SEGMENT8_ID",
        "JSP_SEGMENT9_ID",
        "JSP_SEGMENT10_ID",
        "JSP_SEGMENT11_ID",
        "JSP_SEGMENT12_ID",
        "JSP_SEGMENT13_ID",
        "JSP_SEGMENT14_ID",
        "JSP_SEGMENT15_ID",
        "JSP_TRANSACTION_DATE",
        "JSP_VENDOR_ID",
        "JS_NUMBER",
        "JSP_BANK_ID",
        "JSP_SYSTEM_DOC_NUMBER_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_INT,
        TYPE_DATE,        
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,        
        TYPE_LONG,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG
    };

    public JspBankPayment() {
    }

    public JspBankPayment(BankPayment bankPayment) {
        this.bankPayment = bankPayment;
    }

    public JspBankPayment(HttpServletRequest request, BankPayment bankPayment) {
        super(new JspBankPayment(bankPayment), request);
        this.bankPayment = bankPayment;
    }

    public String getFormName() {
        return JSP_NAME_BANK_PAYMENT;
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

    public BankPayment getEntityObject() {
        return bankPayment;
    }

    public void requestEntityObject(BankPayment bankPayment) {
        try {
            this.requestParam();
            bankPayment.setType(getInt(JSP_TYPE));
            bankPayment.setCreateDate(getDate(JSP_CREATE_DATE));
            bankPayment.setCurrencyId(getLong(JSP_CURRENCY_ID));
            bankPayment.setCreateId(getLong(JSP_CREATE_ID));
            bankPayment.setDueDate(getDate(JSP_DUE_DATE));
            bankPayment.setAmount(getDouble(JSP_AMOUNT));
            bankPayment.setCoaId(getLong(JSP_COA_ID));
            bankPayment.setCoaPaymentId(getLong(JSP_COA_PAYMENT_ID));
            bankPayment.setPaymentDate(getDate(JSP_PAYMENT_DATE));
            bankPayment.setReferensiId(getLong(JSP_REFERENSI_ID));
            bankPayment.setStatus(getInt(JSP_STATUS));
            bankPayment.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            bankPayment.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            bankPayment.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            bankPayment.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            bankPayment.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            bankPayment.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            bankPayment.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            bankPayment.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            bankPayment.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            bankPayment.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            bankPayment.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            bankPayment.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            bankPayment.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            bankPayment.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            bankPayment.setSegment15Id(getLong(JSP_SEGMENT15_ID));            
            bankPayment.setTransactionDate(getDate(JSP_TRANSACTION_DATE));
            bankPayment.setVendorId(getLong(JSP_VENDOR_ID));
            bankPayment.setNumber(getString(JSP_NUMBER));
            bankPayment.setBankId(getLong(JSP_BANK_ID));
            bankPayment.setSystemDocNumberId(getLong(JSP_SYSTEM_DOC_NUMBER_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
