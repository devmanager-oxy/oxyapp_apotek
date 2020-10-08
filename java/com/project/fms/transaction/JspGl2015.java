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
public class JspGl2015 extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Gl2015 gl2015;
    
    public static final String JSP_NAME_GL2015 = "JSP_NAME_GL2015";
    
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

    public JspGl2015() {
    }

    public JspGl2015(Gl2015 gl2015) {
        this.gl2015 = gl2015;
    }

    public JspGl2015(HttpServletRequest request, Gl2015 gl2015) {
        super(new JspGl2015(gl2015), request);
        this.gl2015 = gl2015;
    }

    public String getFormName() {
        return JSP_NAME_GL2015;
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

    public Gl2015 getEntityObject() {
        return gl2015;
    }

    public void requestEntityObject(Gl2015 gl2015) {
        try {
            this.requestParam();            
            gl2015.setTransDate(JSPFormater.formatDate(getString(JSP_TRANS_DATE), "dd/MM/yyyy"));
            gl2015.setOperatorId(getLong(JSP_OPERATOR_ID));
            gl2015.setOperatorName(getString(JSP_OPERATOR_NAME));
            gl2015.setJournalType(getInt(JSP_JOURNAL_TYPE));
            gl2015.setOwnerId(getLong(JSP_OWNER_ID));
            gl2015.setRefNumber(getString(JSP_REF_NUMBER));
            gl2015.setCurrencyId(getLong(JSP_CURRENCY_ID));
            gl2015.setMemo(getString(JSP_MEMO));
            gl2015.setIsReversal(getInt(JSP_IS_REVERSAL));
            gl2015.setReversalDate(JSPFormater.formatDate(getString(JSP_REVERSAL_DATE), "dd/MM/yyyy"));
            gl2015.setReversalType(getInt(JSP_REVERSAL_TYPE));
            gl2015.setReversalStatus(getInt(JSP_REVERSAL_STATUS));            
            gl2015.setPostedStatus(getInt(JSP_POSTED_STATUS));
            gl2015.setPostedById(getLong(JSP_POSTED_BY_ID));
            gl2015.setPostedDate(getDate(JSP_POSTED_DATE));
            gl2015.setEffectiveDate(getDate(JSP_EFFECTIVE_DATE));
            gl2015.setReferensiId(getLong(JSP_REFERENSI_ID));            
            gl2015.setPeriodId(getLong(JSP_PERIOD_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
