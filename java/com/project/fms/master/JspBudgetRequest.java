/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;
import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy
 */
public class JspBudgetRequest extends JSPHandler implements I_JSPInterface, I_JSPType {
    
    private BudgetRequest budgetRequest;
    
    public static final String JSP_NAME_BUDGET_REQUEST = "JSP_BUDGET_REQUEST";
    
    public static final int JSP_BUDGET_REQUEST_ID = 0;    
    public static final int JSP_JOURNAL_NUMBER = 1;
    public static final int JSP_JOURNAL_PREFIX = 2;
    public static final int JSP_JOURNAL_COUNTER = 3;
    public static final int JSP_DATE = 4;
    public static final int JSP_TRANS_DATE = 5;
    public static final int JSP_PERIODE_ID = 6;
    public static final int JSP_MEMO = 7;    
    public static final int JSP_USER_ID = 8;
    
    public static final int JSP_APPROVAL1_ID = 9;
    public static final int JSP_APPROVAL1_DATE = 10;    
    public static final int JSP_APPROVAL2_ID = 11;
    public static final int JSP_APPROVAL2_DATE = 12;
    public static final int JSP_APPROVAL3_ID = 13;
    public static final int JSP_APPROVAL3_DATE = 14;
    
    public static final int JSP_POSTED_STATUS = 15;
    public static final int JSP_POSTED_BY_ID = 16;
    public static final int JSP_POSTED_DATE = 17;
    public static final int JSP_DEPARTMENT_ID = 18;
    public static final int JSP_COA_ID = 19;
    public static final int JSP_SEGMENT1_ID = 20;
    public static final int JSP_SEGMENT2_ID = 21;
    public static final int JSP_SEGMENT3_ID = 22;
    public static final int JSP_SEGMENT4_ID = 23;
    public static final int JSP_SEGMENT5_ID = 24;
    public static final int JSP_SEGMENT6_ID = 25;
    public static final int JSP_SEGMENT7_ID = 26;
    public static final int JSP_SEGMENT8_ID = 27;
    public static final int JSP_SEGMENT9_ID = 28;
    public static final int JSP_SEGMENT10_ID = 29;
    public static final int JSP_SEGMENT11_ID = 30;
    public static final int JSP_SEGMENT12_ID = 31;
    public static final int JSP_SEGMENT13_ID = 32;
    public static final int JSP_SEGMENT14_ID = 33;
    public static final int JSP_SEGMENT15_ID = 34;
    public static final int JSP_UNIQ_KEY_ID = 35;
    public static final int JSP_STATUS = 36;
    
    public static String[] colNames = {
        "jsp_budget_request_id",
        "jsp_journal_number",
        "jsp_journal_prefix",
        "jsp_journal_counter",
        "jsp_date",
        "jsp_trans_date",
        "jsp_periode_id",
        "jsp_memo",//7        
        "jsp_user_id",        
        "jsp_approval1_id",
        "jsp_approval1_date",        
        "jsp_approval2_id",
        "jsp_approval2_date",        
        "jsp_approval3_id",
        "jsp_approval3_date",
        "jsp_posted_status",
        "jsp_posted_by_id",
        "jsp_posted_date",
        "jsp_department_id",
        "jsp_coa_id",//19                
        "jsp_segment1_id",
        "jsp_segment2_id",
        "jsp_segment3_id",
        "jsp_segment4_id",
        "jsp_segment5_id",
        "jsp_segment6_id",
        "jsp_segment7_id",
        "jsp_segment8_id",
        "jsp_segment9_id",
        "jsp_segment10_id",
        "jsp_segment11_id",
        "jsp_segment12_id",
        "jsp_segment13_id",
        "jsp_segment14_id",
        "jsp_segment15_id", //34
        "jsp_uniq_key_id",
        "jsp_status"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,        
        
        //segment
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
        TYPE_INT
    };

    public JspBudgetRequest() {
    }

    public JspBudgetRequest(BudgetRequest budgetRequest) {
        this.budgetRequest = budgetRequest;
    }

    public JspBudgetRequest(HttpServletRequest request, BudgetRequest budgetRequest) {
        super(new JspBudgetRequest(budgetRequest), request);
        this.budgetRequest = budgetRequest;
    }

    public String getFormName() {
        return JSP_NAME_BUDGET_REQUEST;
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

    public BudgetRequest getEntityObject() {
        return budgetRequest;
    }

    public void requestEntityObject(BudgetRequest budgetRequest) {
        try {
            this.requestParam();
            budgetRequest.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE), "dd/MM/yyyy"));
            budgetRequest.setPeriodeId(getLong(JSP_PERIODE_ID));
            budgetRequest.setMemo(getString(JSP_MEMO));            
            budgetRequest.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
            budgetRequest.setCoaId(getLong(JSP_COA_ID));            
            budgetRequest.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            budgetRequest.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            budgetRequest.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            budgetRequest.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            budgetRequest.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            budgetRequest.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            budgetRequest.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            budgetRequest.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            budgetRequest.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            budgetRequest.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            budgetRequest.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            budgetRequest.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            budgetRequest.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            budgetRequest.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            budgetRequest.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            budgetRequest.setStatus(getInt(JSP_STATUS));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
