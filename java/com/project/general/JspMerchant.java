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
 * @author Roy Andika
 */

public class JspMerchant extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Merchant merchant;
    public static final String JSP_NAME_MERCHANT = "JSP_NAME_MERCHANT";
    public static final int JSP_MERCHANT_ID = 0;
    public static final int JSP_BANK_ID = 1;
    public static final int JSP_LOCATION_ID = 2;
    public static final int JSP_CODE_MERCHANT = 3;
    public static final int JSP_PERSEN_EXPENSE = 4;
    public static final int JSP_DESCRIPTION = 5; 
    public static final int JSP_COA_ID = 6; 
    public static final int JSP_COA_EXPENSE_ID = 7; 
    public static final int JSP_TYPE_PAYMENT = 8; 
    public static final int JSP_PERSEN_DISKON = 9; 
    public static final int JSP_COA_DISKON_ID = 10; 
    public static final int JSP_PAYMENT_BY = 11;     
    public static final int JSP_PENDAPATAN_MERCHANT = 12; 
    public static final int JSP_POSTING_EXPENSE = 13; 
    
    public static String[] colNames = {
        "JSP_MERCHANT_ID", 
        "JSP_BANK_ID",
        "JSP_LOCATION", 
        "JSP_CODE_MERCHANT",
        "JSP_PERSEN_EXPENSE", 
        "JSP_DESCRIPTION",
        "JSP_COA_ID",
        "JSP_COA_EXPENSE_ID",
        "JSP_TYPE_PAYMENT",
        "JSP_PERSEN_DISKON",
        "JSP_COA_DISKON_ID",
        "JSP_PAYMENT_BY",
        "JSP_PENDAPATAN_MERCHANT",
        "JSP_POSTING_EXPENSE"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG ,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_STRING, 
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_LONG, 
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT
    };

    public JspMerchant() {
    }

    public JspMerchant(Merchant merchant) {
        this.merchant = merchant;
    }

    public JspMerchant(HttpServletRequest request, Merchant merchant) {
        super(new JspMerchant(merchant), request);
        this.merchant = merchant;
    }

    public String getFormName() {
        return JSP_NAME_MERCHANT;
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

    public Merchant getEntityObject() {
        return merchant;
    }

    public void requestEntityObject(Merchant merchant) {
        try {            
            this.requestParam();            
            merchant.setBankId(getLong(JSP_BANK_ID));
            merchant.setLocationId(getLong(JSP_LOCATION_ID));
            merchant.setCodeMerchant(getString(JSP_CODE_MERCHANT));
            merchant.setPersenExpense(getDouble(JSP_PERSEN_EXPENSE));
            merchant.setDescription(getString(JSP_DESCRIPTION));
            merchant.setCoaId(getLong(JSP_COA_ID));
            merchant.setCoaExpenseId(getLong(JSP_COA_EXPENSE_ID));
            merchant.setTypePayment(getInt(JSP_TYPE_PAYMENT));
            merchant.setPersenDiskon(getDouble(JSP_PERSEN_DISKON));
            merchant.setCoaDiskonId(getLong(JSP_COA_DISKON_ID));
            merchant.setPaymentBy(getInt(JSP_PAYMENT_BY));
            merchant.setPendapatanMerchant(getLong(JSP_PENDAPATAN_MERCHANT));
            merchant.setPostingExpense(getInt(JSP_POSTING_EXPENSE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}


