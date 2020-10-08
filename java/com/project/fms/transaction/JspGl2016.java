/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

/* java package */
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
/* qdep package */
import com.project.util.jsp.*;
import com.project.util.*;
/**
 *
 * @author Roy
 */

public class JspGl2016 extends JSPHandler implements I_JSPInterface, I_JSPType {
    
    private Gl2016 gl2016;
    
    public static final String JSP_NAME_GL2016 = "JSP_NAME_GL2016";
    
    public static final int JSP_GL_ID = 0;
    public static final int JSP_JOURNAL_NUMBER = 1;
    public static final int JSP_JOURNAL_COUNTER = 2;
    public static final int JSP_JOURNAL_PREFIX = 3;
    public static final int JSP_DATE = 4;
    public static final int JSP_TRANS_DATE = 5;
    public static final int JSP_OPERATOR_ID = 6;
    public static final int JSP_OPERATOR_NAME = 7;
    public static final int JSP_JOURNAL_TYPE = 8;
    public static final int JSP_OWNER_ID = 9;
    public static final int JSP_REF_NUMBER = 10;
    public static final int JSP_CURRENCY_ID = 11;
    public static final int JSP_MEMO = 12;
    public static final int JSP_IS_REVERSAL = 13;
    public static final int JSP_REVERSAL_DATE = 14;
    public static final int JSP_REVERSAL_TYPE = 15;
    public static final int JSP_REVERSAL_STATUS = 16;    
    public static final int JSP_POSTED_STATUS		=  17 ;
    public static final int JSP_POSTED_BY_ID		=  18 ;
    public static final int JSP_POSTED_DATE		=  19 ;
    public static final int JSP_EFFECTIVE_DATE		=  20 ;
    public static final int JSP_REFERENSI_ID		=  21 ;
    public static final int JSP_PERIOD_ID		=  22 ;
    
    public static String[] colNames = {
        "JSP_GL_ID", "JSP_JOURNAL_NUMBER",
        "JSP_JOURNAL_COUNTER", "JSP_JOURNAL_PREFIX",
        "JSP_DATE", "JSP_TRANS_DATE",
        "JSP_OPERATOR_ID", "JSP_OPERATOR_NAME",
        "JSP_JOURNAL_TYPE", "JSP_OWNER_ID",
        "JSP_REF_NUMBER", "JSP_CURRENCY_ID",
        "JSP_MEMO",
        "JSP_IS_REVERSAL", "JSP_REVERSAL_DATE",
        "JSP_REVERSAL_TYPE", "JSP_REVERSAL_STATUS",
        "JSP_POSTED_STATUS","JSP_POSTED_BY_ID",
        "JSP_POSTED_DATE","JSP_EFFECTIVE_DATE",
        "JSP_REFERENSI_ID","PERIOD_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_STRING,
        TYPE_INT, TYPE_STRING,
        TYPE_DATE, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_STRING,
        TYPE_INT, TYPE_LONG,
        TYPE_STRING, TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_INT, TYPE_DATE, TYPE_INT, TYPE_INT,
        TYPE_INT, TYPE_LONG,
        TYPE_DATE, TYPE_DATE,TYPE_LONG,TYPE_LONG        
    };

    public JspGl2016() {
    }

    public JspGl2016(Gl2016 gl2016) {
        this.gl2016 = gl2016;
    }

    public JspGl2016(HttpServletRequest request, Gl2016 gl2016) {
        super(new JspGl2016(gl2016), request);
        this.gl2016 = gl2016;
    }

    public String getFormName() {
        return JSP_NAME_GL2016;
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

    public Gl2016 getEntityObject() {
        return gl2016;
    }

    public void requestEntityObject(Gl2016 gl2016) {
        try {
            this.requestParam();            
            gl2016.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE), "dd/MM/yyyy"));
            gl2016.setOperatorId(getLong(JSP_OPERATOR_ID));
            gl2016.setOperatorName(getString(JSP_OPERATOR_NAME));
            gl2016.setJournalType(getInt(JSP_JOURNAL_TYPE));
            gl2016.setOwnerId(getLong(JSP_OWNER_ID));
            gl2016.setRefNumber(getString(JSP_REF_NUMBER));
            gl2016.setCurrencyId(getLong(JSP_CURRENCY_ID));
            gl2016.setMemo(getString(JSP_MEMO));
            gl2016.setIsReversal(getInt(JSP_IS_REVERSAL));
            gl2016.setReversalDate(JSPFormater.formatDate(getString(JSP_REVERSAL_DATE), "dd/MM/yyyy"));
            gl2016.setReversalType(getInt(JSP_REVERSAL_TYPE));
            gl2016.setReversalStatus(getInt(JSP_REVERSAL_STATUS));            
            gl2016.setPostedStatus(getInt(JSP_POSTED_STATUS));
            gl2016.setPostedById(getLong(JSP_POSTED_BY_ID));
            gl2016.setPostedDate(getDate(JSP_POSTED_DATE));
            gl2016.setEffectiveDate(getDate(JSP_EFFECTIVE_DATE));
            gl2016.setReferensiId(getLong(JSP_REFERENSI_ID));            
            gl2016.setPeriodId(getLong(JSP_PERIOD_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }

}
