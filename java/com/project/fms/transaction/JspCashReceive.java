package com.project.fms.transaction;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.util.*;

public class JspCashReceive extends JSPHandler implements I_JSPInterface, I_JSPType {

    private CashReceive cashReceive;
    public static final String JSP_NAME_CASHRECEIVE = "JSP_NAME_CASHRECEIVE";
    public static final int JSP_CASH_RECEIVE_ID = 0;
    public static final int JSP_COA_ID = 1;
    public static final int JSP_JOURNAL_NUMBER = 2;
    public static final int JSP_JOURNAL_COUNTER = 3;
    public static final int JSP_JOURNAL_PREFIX = 4;
    public static final int JSP_DATE = 5;
    public static final int JSP_TRANS_DATE = 6;
    public static final int JSP_MEMO = 7;
    public static final int JSP_OPERATOR_ID = 8;
    public static final int JSP_OPERATOR_NAME = 9;
    public static final int JSP_AMOUNT = 10;
    public static final int JSP_RECEIVE_FROM_ID = 11;
    public static final int JSP_RECEIVE_FROM_NAME = 12;
    public static final int JSP_TYPE = 13;
    public static final int JSP_CUSTOMER_ID = 14;
    public static final int JSP_REFERENSI_ID = 15;
    public static final int JSP_SEGMENT1_ID = 16;
    public static final int JSP_SEGMENT2_ID = 17;
    public static final int JSP_SEGMENT3_ID = 18;
    public static final int JSP_SEGMENT4_ID = 19;
    public static final int JSP_SEGMENT5_ID = 20;
    public static final int JSP_SEGMENT6_ID = 21;
    public static final int JSP_SEGMENT7_ID = 22;
    public static final int JSP_SEGMENT8_ID = 23;
    public static final int JSP_SEGMENT9_ID = 24;
    public static final int JSP_SEGMENT10_ID = 25;
    public static final int JSP_SEGMENT11_ID = 26;
    public static final int JSP_SEGMENT12_ID = 27;
    public static final int JSP_SEGMENT13_ID = 28;
    public static final int JSP_SEGMENT14_ID = 29;
    public static final int JSP_SEGMENT15_ID = 30;
    public static final int JSP_REF_PEMBAYARAN_ID = 31;        
    public static final int JSP_PERIODE_ID = 32;    
    
    public static String[] colNames = {
        "JSP_CASH_RECEIVE_ID", "JSP_COA_ID",
        "JSP_JOURNAL_NUMBER", "JSP_JOURNAL_COUNTER",
        "JSP_JOURNAL_PREFIX", "JSP_DATE",
        "JSP_TRANS_DATE", "JSP_MEMO_MAIN",
        "JSP_OPERATOR_ID", "JSP_OPERATOR_NAME",
        "JSP_AMOUNT_MAIN", "JSP_RECEIVE_FROM_ID",
        "JSP_RECEIVE_FROM_NAME",
        "JSP_TYPE", "JSP_CUSTOMER_ID",
        "JSP_REFERENSI_ID",
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
        "JSP_REF_PEMBAYARAN_ID",
        "JSP_PERIODE_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_INT,
        TYPE_STRING, TYPE_DATE,
        TYPE_STRING, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_STRING,
        TYPE_FLOAT + ENTRY_REQUIRED, TYPE_LONG,
        TYPE_STRING, TYPE_INT,
        TYPE_LONG, TYPE_LONG,
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
        TYPE_LONG
    };

    public JspCashReceive() {
    }

    public JspCashReceive(CashReceive cashReceive) {
        this.cashReceive = cashReceive;
    }

    public JspCashReceive(HttpServletRequest request, CashReceive cashReceive) {
        super(new JspCashReceive(cashReceive), request);
        this.cashReceive = cashReceive;
    }

    public String getFormName() {
        return JSP_NAME_CASHRECEIVE;
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

    public CashReceive getEntityObject() {
        return cashReceive;
    }

    public void requestEntityObject(CashReceive cashReceive) {
        try {
            this.requestParam();
            cashReceive.setCoaId(getLong(JSP_COA_ID));
         
            cashReceive.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE), "dd/MM/yyyy"));
            cashReceive.setMemo(getString(JSP_MEMO));
            cashReceive.setOperatorId(getLong(JSP_OPERATOR_ID));
            cashReceive.setOperatorName(getString(JSP_OPERATOR_NAME));
            cashReceive.setAmount(getDouble(JSP_AMOUNT));
            cashReceive.setReceiveFromId(getLong(JSP_RECEIVE_FROM_ID));
            cashReceive.setReceiveFromName(getString(JSP_RECEIVE_FROM_NAME));
            cashReceive.setType(getInt(JSP_TYPE));
            cashReceive.setCustomerId(getLong(JSP_CUSTOMER_ID));
            cashReceive.setReferensiId(getLong(JSP_REFERENSI_ID));
            cashReceive.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            cashReceive.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            cashReceive.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            cashReceive.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            cashReceive.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            cashReceive.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            cashReceive.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            cashReceive.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            cashReceive.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            cashReceive.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            cashReceive.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            cashReceive.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            cashReceive.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            cashReceive.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            cashReceive.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            cashReceive.setRefPembayaranId(getLong(JSP_REF_PEMBAYARAN_ID));
            cashReceive.setPeriodeId(getLong(JSP_PERIODE_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
