package com.project.fms.transaction;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.util.*;

public class JspCashReceiveDetail extends JSPHandler implements I_JSPInterface, I_JSPType {

    private CashReceiveDetail cashReceiveDetail;
    
    public static final String JSP_NAME_CASHRECEIVEDETAIL = "JSP_NAME_CASHRECEIVEDETAIL";
    public static final int JSP_CASH_RECEIVE_ID = 0;
    public static final int JSP_CASH_RECEIVE_DETAIL_ID = 1;
    public static final int JSP_COA_ID = 2;
    public static final int JSP_FOREIGN_CURRENCY_ID = 3;
    public static final int JSP_FOREIGN_AMOUNT = 4;
    public static final int JSP_BOOKED_RATE = 5;
    public static final int JSP_AMOUNT = 6;
    public static final int JSP_MEMO = 7;
    public static final int JSP_CUSTOMER_ID = 8;
    public static final int JSP_SEGMENT1_ID = 9;
    public static final int JSP_SEGMENT2_ID = 10;
    public static final int JSP_SEGMENT3_ID = 11;
    public static final int JSP_SEGMENT4_ID = 12;
    public static final int JSP_SEGMENT5_ID = 13;
    public static final int JSP_SEGMENT6_ID = 14;
    public static final int JSP_SEGMENT7_ID = 15;
    public static final int JSP_SEGMENT8_ID = 16;
    public static final int JSP_SEGMENT9_ID = 17;
    public static final int JSP_SEGMENT10_ID = 18;
    public static final int JSP_SEGMENT11_ID = 19;
    public static final int JSP_SEGMENT12_ID = 20;
    public static final int JSP_SEGMENT13_ID = 21;
    public static final int JSP_SEGMENT14_ID = 22;
    public static final int JSP_SEGMENT15_ID = 23;
    public static final int JSP_DEPARTMENT_ID = 24;
    public static final int JSP_FOREIGN_CREDIT_AMOUNT = 25;
    public static final int JSP_CREDIT_AMOUNT = 26;
    
    public static String[] colNames = {
        "xxJSP_CASH_RECEIVE_ID", 
        "xxJSP_CASH_RECEIVE_DETAIL_ID",
        "xxJSP_COA_ID", 
        "xxJSP_FOREIGN_CURRENCY_ID",
        "xxJSP_FOREIGN_AMOUNT", 
        "xxJSP_BOOKED_RATE",
        "xxJSP_AMOUNT", 
        "xxJSP_MEMO",
        "xx_JSP_CUSTOMER_ID",
        "JSP_SEGMENT1_ID_DETAIL",
        "JSP_SEGMENT2_ID_DETAIL",
        "JSP_SEGMENT3_ID_DETAIL",
        "JSP_SEGMENT4_ID_DETAIL",
        "JSP_SEGMENT5_ID_DETAIL",
        "JSP_SEGMENT6_ID_DETAIL",
        "JSP_SEGMENT7_ID_DETAIL",
        "JSP_SEGMENT8_ID_DETAIL",
        "JSP_SEGMENT9_ID_DETAIL",
        "JSP_SEGMENT10_ID_DETAIL",
        "JSP_SEGMENT11_ID_DETAIL",
        "JSP_SEGMENT12_ID_DETAIL",
        "JSP_SEGMENT13_ID_DETAIL",
        "JSP_SEGMENT14_ID_DETAIL",
        "JSP_SEGMENT15_ID_DETAIL",
        "JSP_xDEPARTMENT_ID",
        "JSP_FPREIGN_CREDIT_AMOUNT",
        "JSP_CREDIT_AMOUNT"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED,  //JSP_COA_ID
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
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
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    public JspCashReceiveDetail() {
    }

    public JspCashReceiveDetail(CashReceiveDetail cashReceiveDetail) {
        this.cashReceiveDetail = cashReceiveDetail;
    }

    public JspCashReceiveDetail(HttpServletRequest request, CashReceiveDetail cashReceiveDetail) {
        super(new JspCashReceiveDetail(cashReceiveDetail), request);
        this.cashReceiveDetail = cashReceiveDetail;
    }

    public String getFormName() {
        return JSP_NAME_CASHRECEIVEDETAIL;
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

    public CashReceiveDetail getEntityObject() {
        return cashReceiveDetail;
    }

    public void requestEntityObject(CashReceiveDetail cashReceiveDetail) {
        try {
            this.requestParam();
            cashReceiveDetail.setCashReceiveId(getLong(JSP_CASH_RECEIVE_ID));
            cashReceiveDetail.setCoaId(getLong(JSP_COA_ID));
            cashReceiveDetail.setForeignCurrencyId(getLong(JSP_FOREIGN_CURRENCY_ID));
            cashReceiveDetail.setForeignAmount(getDouble(JSP_FOREIGN_AMOUNT));
            cashReceiveDetail.setBookedRate(getDouble(JSP_BOOKED_RATE));
            cashReceiveDetail.setAmount(getDouble(JSP_AMOUNT));
            cashReceiveDetail.setMemo(getString(JSP_MEMO));
            cashReceiveDetail.setCustomerId(getLong(JSP_CUSTOMER_ID));
            cashReceiveDetail.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            cashReceiveDetail.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            cashReceiveDetail.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            cashReceiveDetail.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            cashReceiveDetail.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            cashReceiveDetail.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            cashReceiveDetail.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            cashReceiveDetail.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            cashReceiveDetail.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            cashReceiveDetail.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            cashReceiveDetail.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            cashReceiveDetail.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            cashReceiveDetail.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            cashReceiveDetail.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            cashReceiveDetail.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            cashReceiveDetail.setDepartmentId(getLong(JSP_DEPARTMENT_ID));            
            cashReceiveDetail.setForeignCreditAmount(getDouble(JSP_FOREIGN_CREDIT_AMOUNT));
            cashReceiveDetail.setCreditAmount(getDouble(JSP_CREDIT_AMOUNT));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
