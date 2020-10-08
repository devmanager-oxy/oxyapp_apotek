/* 
 * Form Name  	:  JspBankDepositDetail.java 
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
import com.project.fms.transaction.*;
import com.project.util.*;

public class JspBankDepositDetail extends JSPHandler implements I_JSPInterface, I_JSPType {

    private BankDepositDetail bankDepositDetail;
    public static final String JSP_NAME_BANKDEPOSITDETAIL = "JSP_NAME_BANKDEPOSITDETAIL";
    public static final int JSP_BANK_DEPOSIT_DETAIL_ID = 0;
    public static final int JSP_BANK_DEPOSIT_ID = 1;
    public static final int JSP_COA_ID = 2;
    public static final int JSP_FOREIGN_CURRENCY_ID = 3;
    public static final int JSP_FOREIGN_AMOUNT = 4;
    public static final int JSP_BOOKED_RATE = 5;
    public static final int JSP_MEMO = 6;
    public static final int JSP_AMOUNT = 7;
    public static final int JSP_SEGMENT1_ID = 8;
    public static final int JSP_SEGMENT2_ID = 9;
    public static final int JSP_SEGMENT3_ID = 10;
    public static final int JSP_SEGMENT4_ID = 11;
    public static final int JSP_SEGMENT5_ID = 12;
    public static final int JSP_SEGMENT6_ID = 13;
    public static final int JSP_SEGMENT7_ID = 14;
    public static final int JSP_SEGMENT8_ID = 15;
    public static final int JSP_SEGMENT9_ID = 16;
    public static final int JSP_SEGMENT10_ID = 17;
    public static final int JSP_SEGMENT11_ID = 18;
    public static final int JSP_SEGMENT12_ID = 19;
    public static final int JSP_SEGMENT13_ID = 20;
    public static final int JSP_SEGMENT14_ID = 21;
    public static final int JSP_SEGMENT15_ID = 22;
    public static final int JSP_DEPARTMENT_ID = 23;
    public static final int JSP_FOREIGN_CREDIT_AMOUNT = 24;
    public static final int JSP_CREDIT_AMOUNT = 25;
    
    public static String[] colNames = {
        "detailJSP_BANK_DEPOSIT_DETAIL_ID", "detailJSP_BANK_DEPOSIT_ID",
        "detailJSP_COA_ID", "detailJSP_FOREIGN_CURRENCY_ID",
        "detailJSP_FOREIGN_AMOUNT", "detailSP_BOOKED_RATE",
        "detailJSP_MEMO", "detailJSP_AMOUNT",
        "JSP_SEGMENT1_DETAIL_ID",
        "JSP_SEGMENT2_DETAIL_ID",
        "JSP_SEGMENT3_DETAIL_ID",
        "JSP_SEGMENT4_DETAIL_ID",
        "JSP_SEGMENT5_DETAIL_ID",
        "JSP_SEGMENT6_DETAIL_ID",
        "JSP_SEGMENT7_DETAIL_ID",
        "JSP_SEGMENT8_DETAIL_ID",
        "JSP_SEGMENT9_DETAIL_ID",
        "JSP_SEGMENT10_DETAIL_ID",
        "JSP_SEGMENT11_DETAIL_ID",
        "JSP_SEGMENT12_DETAIL_ID",
        "JSP_SEGMENT13_DETAIL_ID",
        "JSP_SEGMENT14_DETAIL_ID",
        "JSP_SEGMENT15_DETAIL_ID",
        "JSP_DEPARTMENT_IDX",
        "JSP_FOREIGN_CREDIT_AMOUNT",
        "JSP_CREDIT_AMOUNT"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED, //JSP_COA_ID
        TYPE_LONG,
        TYPE_FLOAT ,  //JSP_FOREIGN_AMOUNT
        TYPE_FLOAT,
        TYPE_STRING, 
        TYPE_FLOAT,
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

    public JspBankDepositDetail() {
    }

    public JspBankDepositDetail(BankDepositDetail bankDepositDetail) {
        this.bankDepositDetail = bankDepositDetail;
    }

    public JspBankDepositDetail(HttpServletRequest request, BankDepositDetail bankDepositDetail) {
        super(new JspBankDepositDetail(bankDepositDetail), request);
        this.bankDepositDetail = bankDepositDetail;
    }

    public String getFormName() {
        return JSP_NAME_BANKDEPOSITDETAIL;
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

    public BankDepositDetail getEntityObject() {
        return bankDepositDetail;
    }

    public void requestEntityObject(BankDepositDetail bankDepositDetail) {
        try {
            this.requestParam();
            bankDepositDetail.setBankDepositId(getLong(JSP_BANK_DEPOSIT_ID));
            bankDepositDetail.setCoaId(getLong(JSP_COA_ID));
            bankDepositDetail.setForeignCurrencyId(getLong(JSP_FOREIGN_CURRENCY_ID));
            bankDepositDetail.setForeignAmount(getDouble(JSP_FOREIGN_AMOUNT));
            bankDepositDetail.setBookedRate(getDouble(JSP_BOOKED_RATE));
            bankDepositDetail.setMemo(getString(JSP_MEMO));
            bankDepositDetail.setAmount(getDouble(JSP_AMOUNT));

            bankDepositDetail.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            bankDepositDetail.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            bankDepositDetail.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            bankDepositDetail.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            bankDepositDetail.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            bankDepositDetail.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            bankDepositDetail.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            bankDepositDetail.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            bankDepositDetail.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            bankDepositDetail.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            bankDepositDetail.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            bankDepositDetail.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            bankDepositDetail.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            bankDepositDetail.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            bankDepositDetail.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            bankDepositDetail.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
            
            bankDepositDetail.setForeignCreditAmount(getDouble(JSP_FOREIGN_CREDIT_AMOUNT));
            bankDepositDetail.setCreditAmount(getDouble(JSP_CREDIT_AMOUNT));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
