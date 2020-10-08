/* 
 * Form Name  	:  JspPettycashReplenishment.java 
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

public class JspPettycashReplenishment extends JSPHandler implements I_JSPInterface, I_JSPType {

    private PettycashReplenishment pettycashReplenishment;
    public static final String JSP_NAME_PETTYCASHREPLENISHMENT = "JSP_NAME_PETTYCASHREPLENISHMENT";
    public static final int JSP_PETTYCASH_REPLENISHMENT_ID = 0;
    public static final int JSP_REPLACE_COA_ID = 1;
    public static final int JSP_REPLACE_FROM_COA_ID = 2;
    public static final int JSP_MEMO = 3;
    public static final int JSP_DATE = 4;
    public static final int JSP_TRANS_DATE = 5;
    public static final int JSP_OPERATOR_ID = 6;
    public static final int JSP_OPERATOR_NAME = 7;
    public static final int JSP_REPLACE_AMOUNT = 8;
    public static final int JSP_JOURNAL_NUMBER = 9;
    public static final int JSP_JOURNAL_PREFIX = 10;
    public static final int JSP_JOURNAL_COUNTER = 11;
    public static final int JSP_CUSTOMER_ID = 12;
    
    public static final int JSP_SEGMENT1_ID   		=  13 ;    
    public static final int JSP_SEGMENT2_ID   		=  14 ; 
    public static final int JSP_SEGMENT3_ID   		=  15 ;    
    public static final int JSP_SEGMENT4_ID   		=  16 ;    
    public static final int JSP_SEGMENT5_ID   		=  17 ;   
    public static final int JSP_SEGMENT6_ID   		=  18 ;    
    public static final int JSP_SEGMENT7_ID   		=  19 ;    
    public static final int JSP_SEGMENT8_ID   		=  20 ;    
    public static final int JSP_SEGMENT9_ID   		=  21 ;    
    public static final int JSP_SEGMENT10_ID   		=  22 ;    
    public static final int JSP_SEGMENT11_ID   		=  23 ;    
    public static final int JSP_SEGMENT12_ID   		=  24 ;    
    public static final int JSP_SEGMENT13_ID   		=  25 ;    
    public static final int JSP_SEGMENT14_ID   		=  26 ;    
    public static final int JSP_SEGMENT15_ID   		=  27 ; 
    
    public static String[] colNames = {
        "JSP_PETTYCASH_REPLENISHMENT_ID", "JSP_REPLACE_COA_ID",
        "JSP_REPLACE_FROM_COA_ID", "JSP_MEMO",
        "JSP_DATE", "JSP_TRANS_DATE",
        "JSP_OPERATOR_ID", "JSP_OPERATOR_NAME",
        "JSP_REPLACE_AMOUNT", "JSP_JOURNAL_NUMBER",
        "JSP_JOURNAL_PREFIX", "JSP_JOURNAL_COUNTER",
        "JSP_CUSTOMER_ID",
        
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
        "JSP_SEGMENT15_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_DATE, TYPE_STRING,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_STRING,
        TYPE_FLOAT + ENTRY_REQUIRED, TYPE_STRING,
        TYPE_STRING, TYPE_INT,TYPE_LONG,
        
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

    public JspPettycashReplenishment() {
    }

    public JspPettycashReplenishment(PettycashReplenishment pettycashReplenishment) {
        this.pettycashReplenishment = pettycashReplenishment;
    }

    public JspPettycashReplenishment(HttpServletRequest request, PettycashReplenishment pettycashReplenishment) {
        super(new JspPettycashReplenishment(pettycashReplenishment), request);
        this.pettycashReplenishment = pettycashReplenishment;
    }

    public String getFormName() {
        return JSP_NAME_PETTYCASHREPLENISHMENT;
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

    public PettycashReplenishment getEntityObject() {
        return pettycashReplenishment;
    }

    public void requestEntityObject(PettycashReplenishment pettycashReplenishment) {
        try {
            
            this.requestParam();
            pettycashReplenishment.setReplaceCoaId(getLong(JSP_REPLACE_COA_ID));
            pettycashReplenishment.setReplaceFromCoaId(getLong(JSP_REPLACE_FROM_COA_ID));
            pettycashReplenishment.setMemo(getString(JSP_MEMO));
            //pettycashReplenishment.setDate(getDate(JSP_DATE));
            pettycashReplenishment.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE), "dd/MM/yyyy"));
            pettycashReplenishment.setOperatorId(getLong(JSP_OPERATOR_ID));
            pettycashReplenishment.setOperatorName(getString(JSP_OPERATOR_NAME));
            pettycashReplenishment.setReplaceAmount(getDouble(JSP_REPLACE_AMOUNT));
            //pettycashReplenishment.setJournalNumber(getString(JSP_JOURNAL_NUMBER));
            //pettycashReplenishment.setJournalPrefix(getString(JSP_JOURNAL_PREFIX));
            //pettycashReplenishment.setJournalCounter(getInt(JSP_JOURNAL_COUNTER));
            pettycashReplenishment.setCustomerId(getLong(JSP_CUSTOMER_ID));
            
            pettycashReplenishment.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            pettycashReplenishment.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            pettycashReplenishment.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            pettycashReplenishment.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            pettycashReplenishment.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            pettycashReplenishment.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            pettycashReplenishment.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            pettycashReplenishment.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            pettycashReplenishment.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            pettycashReplenishment.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            pettycashReplenishment.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            pettycashReplenishment.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            pettycashReplenishment.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            pettycashReplenishment.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            pettycashReplenishment.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
