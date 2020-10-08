/* 
 * Form Name  	:  JspBankpoPayment.java 
 * Created on 	:  [date] [time] AM/PM 
 * 
 * @author  	:  [authorName] 
 * @version  	:  [version] 
 */
/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/
package com.project.fms.transaction;

/* java package */
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* qdep package */
import com.project.util.jsp.*;
import com.project.util.*;

public class JspBankpoPayment extends JSPHandler implements I_JSPInterface, I_JSPType {

    private BankpoPayment bankpoPayment;
    public static final String JSP_NAME_BANKPOPAYMENT = "JSP_NAME_BANKPOPAYMENT";
    public static final int JSP_BANKPO_PAYMENT_ID = 0;
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
    public static final int JSP_REF_NUMBER = 11;
    public static final int JSP_VENDOR_ID = 12;
    public static final int JSP_CURRENCY_ID = 13;
    public static final int JSP_PAYMENT_METHOD = 14;
    public static final int JSP_PAYMENT_METHOD_ID = 15;
    public static final int JSP_STATUS = 16;
    public static final int JSP_POSTED_STATUS = 17;
    public static final int JSP_POSTED_BY_ID = 18;
    public static final int JSP_POSTED_DATE = 19;
    public static final int JSP_EFFECTIVE_DATE = 20;
    public static final int JSP_TYPE = 21;
    public static final int JSP_CUSTOMER_ID = 22;
    public static final int JSP_SEGMENT1_ID = 23;
    public static final int JSP_SEGMENT2_ID = 24;
    public static final int JSP_SEGMENT3_ID = 25;
    public static final int JSP_SEGMENT4_ID = 26;
    public static final int JSP_SEGMENT5_ID = 27;
    public static final int JSP_SEGMENT6_ID = 28;
    public static final int JSP_SEGMENT7_ID = 29;
    public static final int JSP_SEGMENT8_ID = 30;
    public static final int JSP_SEGMENT9_ID = 31;
    public static final int JSP_SEGMENT10_ID = 32;
    public static final int JSP_SEGMENT11_ID = 33;
    public static final int JSP_SEGMENT12_ID = 34;
    public static final int JSP_SEGMENT13_ID = 35;
    public static final int JSP_SEGMENT14_ID = 36;
    public static final int JSP_SEGMENT15_ID = 37;
    public static final int JSP_PERIODE_ID = 38;
    public static final int JSP_REF_ID = 39;
    public static final int JSP_DUE_DATE_BG = 40;
    
    public static String[] colNames = {
        "JSP_BANKPO_PAYMENT_ID", "JSP_COA_ID",
        "JSP_JOURNAL_NUMBER", "JSP_JOURNAL_COUNTER",
        "JSP_JOURNAL_PREFIX", "JSP_DATE",
        "JSP_TRANS_DATE", "JSP_MEMO",
        "JSP_OPERATOR_ID", "JSP_OPERATOR_NAME",
        "JSP_AMOUNT", "JSP_REF_NUMBER",
        "JSP_VENDOR_ID", "JSP_CURRENCY_ID",
        "JSP_PAYMENT_METHOD", "JSP_PAYMENT_METHOD_ID",
        "JSP_STATUS",
        "JSP_POSTED_STATUS", "JSP_POSTED_BY_ID",
        "JSP_POSTED_DATE", "JSP_EFFECTIVE_DATE",
        "JSP_TYPE", "JSP_CUSTOMER_ID",
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
        "JSP_PERIODE_ID",
        "JSP_REF_ID",
        "JSP_DUE_DATE_BG"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG,
        TYPE_STRING, TYPE_INT,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING + ENTRY_REQUIRED, 
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_LONG, TYPE_STRING,
        TYPE_FLOAT, TYPE_STRING,
        TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_LONG,
        TYPE_STRING,
        TYPE_INT, TYPE_LONG,
        TYPE_DATE, TYPE_DATE,
        TYPE_INT, TYPE_LONG,
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
        TYPE_STRING
    };

    public JspBankpoPayment() {
    }

    public JspBankpoPayment(BankpoPayment bankpoPayment) {
        this.bankpoPayment = bankpoPayment;
    }

    public JspBankpoPayment(HttpServletRequest request, BankpoPayment bankpoPayment) {
        super(new JspBankpoPayment(bankpoPayment), request);
        this.bankpoPayment = bankpoPayment;
    }

    public String getFormName() {
        return JSP_NAME_BANKPOPAYMENT;
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

    public BankpoPayment getEntityObject() {
        return bankpoPayment;
    }

    public void requestEntityObject(BankpoPayment bankpoPayment) {
        try {
            this.requestParam();
            bankpoPayment.setCoaId(getLong(JSP_COA_ID));
            
            bankpoPayment.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE), "dd/MM/yyyy"));
            bankpoPayment.setMemo(getString(JSP_MEMO));
            bankpoPayment.setOperatorId(getLong(JSP_OPERATOR_ID));
            bankpoPayment.setOperatorName(getString(JSP_OPERATOR_NAME));
            bankpoPayment.setAmount(getDouble(JSP_AMOUNT));
            bankpoPayment.setRefNumber(getString(JSP_REF_NUMBER));
            bankpoPayment.setVendorId(getLong(JSP_VENDOR_ID));
            bankpoPayment.setCurrencyId(getLong(JSP_CURRENCY_ID));
            bankpoPayment.setPaymentMethod(getString(JSP_PAYMENT_METHOD));
            bankpoPayment.setPaymentMethodId(getLong(JSP_PAYMENT_METHOD_ID));            
            bankpoPayment.setPostedStatus(getInt(JSP_POSTED_STATUS));
            bankpoPayment.setPostedById(getLong(JSP_POSTED_BY_ID));
            bankpoPayment.setPostedDate(getDate(JSP_POSTED_DATE));
            bankpoPayment.setEffectiveDate(getDate(JSP_EFFECTIVE_DATE));
            bankpoPayment.setType(getInt(JSP_TYPE));
            bankpoPayment.setCustomerId(getLong(JSP_CUSTOMER_ID));
            bankpoPayment.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            bankpoPayment.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            bankpoPayment.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            bankpoPayment.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            bankpoPayment.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            bankpoPayment.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            bankpoPayment.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            bankpoPayment.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            bankpoPayment.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            bankpoPayment.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            bankpoPayment.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            bankpoPayment.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            bankpoPayment.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            bankpoPayment.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            bankpoPayment.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            bankpoPayment.setPeriodeId(getLong(JSP_PERIODE_ID));
            bankpoPayment.setRefId(getLong(JSP_REF_ID));
            bankpoPayment.setDueDateBG(JSPFormater.formatDate(getString(JSP_DUE_DATE_BG), "dd/MM/yyyy"));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
