/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
/**
 *
 * @author Roy
 */
public class JspBudgetRequestDetail extends JSPHandler implements I_JSPInterface, I_JSPType {
    
    private BudgetRequestDetail budgetRequestDetail;
    
    public static final String JSP_NAME_BUDGET_REQUEST_DETAIL = "JSP_BUDGET_REQUEST_DETAIL";
    
    public static final int JSP_BUDGET_REQUEST_DETAIL_ID = 0; 
    public static final int JSP_BUDGET_REQUEST_ID = 1;        
    public static final int JSP_COA_ID = 2;
    public static final int JSP_MEMO = 3;
    public static final int JSP_REQUEST = 4;
    public static final int JSP_SEGMENT1_ID = 5;
    public static final int JSP_SEGMENT2_ID = 6;
    public static final int JSP_SEGMENT3_ID = 7;
    public static final int JSP_SEGMENT4_ID = 8;
    public static final int JSP_SEGMENT5_ID = 9;
    public static final int JSP_SEGMENT6_ID = 10;
    public static final int JSP_SEGMENT7_ID = 11;
    public static final int JSP_SEGMENT8_ID = 12;
    public static final int JSP_SEGMENT9_ID = 13;
    public static final int JSP_SEGMENT10_ID = 14;
    public static final int JSP_SEGMENT11_ID = 15;
    public static final int JSP_SEGMENT12_ID = 16;
    public static final int JSP_SEGMENT13_ID = 17;
    public static final int JSP_SEGMENT14_ID = 18;
    public static final int JSP_SEGMENT15_ID = 19;
    public static final int JSP_UNIQ_KEY_ID = 20;
    public static final int JSP_STATUS = 21;
    
    public static String[] colNames = {
        "det_jsp_budget_request_detail_id",
        "det_jsp_budget_request_id",
        "det_jsp_coa_id",
        "det_jsp_memo",
        "det_jsp_request",
        
        "det_jsp_segment1_id",
        "det_jsp_segment2_id",
        "det_jsp_segment3_id",
        "det_jsp_segment4_id",
        "det_jsp_segment5_id",
        "det_jsp_segment6_id",
        "det_jsp_segment7_id",
        "det_jsp_segment8_id",
        "det_jsp_segment9_id",
        "det_jsp_segment10_id",
        "det_jsp_segment11_id",
        "det_jsp_segment12_id",
        "det_jsp_segment13_id",
        "det_jsp_segment14_id",
        "det_jsp_segment15_id",
        "det_jsp_uniq_key_id",
        "det_jsp_status"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT,               
        
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

    public JspBudgetRequestDetail() {
    }

    public JspBudgetRequestDetail(BudgetRequestDetail budgetRequestDetail) {
        this.budgetRequestDetail = budgetRequestDetail;
    }

    public JspBudgetRequestDetail(HttpServletRequest request, BudgetRequestDetail budgetRequestDetail) {
        super(new JspBudgetRequestDetail(budgetRequestDetail), request);
        this.budgetRequestDetail = budgetRequestDetail;
    }

    public String getFormName() {
        return JSP_NAME_BUDGET_REQUEST_DETAIL;
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

    public BudgetRequestDetail getEntityObject() {
        return budgetRequestDetail;
    }

    public void requestEntityObject(BudgetRequestDetail budgetRequestDetail) {
        try {
            this.requestParam();            
            budgetRequestDetail.setBudgetRequestId(getLong(JSP_BUDGET_REQUEST_ID));
            budgetRequestDetail.setCoaId(getLong(JSP_COA_ID));
            budgetRequestDetail.setMemo(getString(JSP_MEMO));            
            budgetRequestDetail.setRequest(getDouble(JSP_REQUEST));             
            budgetRequestDetail.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            budgetRequestDetail.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            budgetRequestDetail.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            budgetRequestDetail.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            budgetRequestDetail.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            budgetRequestDetail.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            budgetRequestDetail.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            budgetRequestDetail.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            budgetRequestDetail.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            budgetRequestDetail.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            budgetRequestDetail.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            budgetRequestDetail.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            budgetRequestDetail.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            budgetRequestDetail.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            budgetRequestDetail.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            budgetRequestDetail.setUniqKeyId(getLong(JSP_UNIQ_KEY_ID));
            budgetRequestDetail.setStatus(getInt(JSP_STATUS));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
