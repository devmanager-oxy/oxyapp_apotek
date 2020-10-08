/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.util.*;
/**
 *
 * @author Roy
 */
public class JspSetoranKasir extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SetoranKasir setoranKasir;
    
    public static final String JSP_NAME_SETORANKASIR = "JSP_NAME_SETORANKASIR";
    
    public static final int JSP_SETORAN_KASIR_ID = 0;
    public static final int JSP_COA_ID = 1;
    public static final int JSP_JOURNAL_NUMBER = 2;
    public static final int JSP_JOURNAL_COUNTER = 3;
    public static final int JSP_LOCATION_ID = 4;
    public static final int JSP_JOURNAL_PREFIX = 5;
    public static final int JSP_DATE = 6;
    public static final int JSP_TRANSACTION_DATE = 7;
    public static final int JSP_MEMO = 8;
    public static final int JSP_OPERATOR_ID = 9;
    public static final int JSP_AMOUNT = 10;
    public static final int JSP_POSTED_STATUS = 11;
    public static final int JSP_POSTED_BY_ID = 12;
    public static final int JSP_POSTED_DATE = 13;
    public static final int JSP_EFECTIVE_DATE = 14;
    public static final int JSP_PERIODE_ID = 15;
    public static final int JSP_SEGMENT1_ID = 16;    
    
    public static String[] colNames = {
        "JSP_SETORAN_KASIR_ID",
        "JSP_COA_ID",
        "JSP_JOURNAL_NUMBER",
        "JSP_JOURNAL_COUNTER",
        "JSP_LOCATION_ID",
        "JSP_JOURNAL_PREFIX",
        "JSP_DATE",
        "JSP_TRANSACTION_DATE",
        "JSP_MEMO",
        "JSP_OPERATOR_ID",
        "JSP_AMOUNT",
        "JSP_POSTED_STATUS",
        "JSP_POSTED_BY_ID",
        "JSP_POSTED_DATE",
        "JSP_EFECTIVE_DATE",
        "JSP_PERIODE_ID",
        "JSP_SEGMENT1_ID"        
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG        
    };

    public JspSetoranKasir() {
    }

    public JspSetoranKasir(SetoranKasir setoranKasir) {
        this.setoranKasir = setoranKasir;
    }

    public JspSetoranKasir(HttpServletRequest request, SetoranKasir setoranKasir) {
        super(new JspSetoranKasir(setoranKasir), request);
        this.setoranKasir = setoranKasir;
    }

    public String getFormName() {
        return JSP_NAME_SETORANKASIR;
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

    public SetoranKasir getEntityObject() {
        return setoranKasir;
    }

    public void requestEntityObject(SetoranKasir setoranKasir) {
        try {
            this.requestParam();
            setoranKasir.setCoaId(getLong(JSP_COA_ID));
            setoranKasir.setLocationId(getLong(JSP_LOCATION_ID));            
            setoranKasir.setTransDate(JSPFormater.formatDate(getString(JSP_TRANSACTION_DATE), "dd/MM/yyyy"));
            setoranKasir.setMemo(getString(JSP_MEMO));
            setoranKasir.setOperatorId(getLong(JSP_OPERATOR_ID));            
            setoranKasir.setAmount(getDouble(JSP_AMOUNT));
            setoranKasir.setPostedStatus(getInt(JSP_POSTED_STATUS));
            setoranKasir.setPostedById(getLong(JSP_POSTED_BY_ID));
            setoranKasir.setPostedDate(getDate(JSP_POSTED_DATE));
            setoranKasir.setEffectiveDate(getDate(JSP_EFECTIVE_DATE));
            setoranKasir.setPeriodeId(getLong(JSP_PERIODE_ID));
            setoranKasir.setSegment1Id(getLong(JSP_SEGMENT1_ID));            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
