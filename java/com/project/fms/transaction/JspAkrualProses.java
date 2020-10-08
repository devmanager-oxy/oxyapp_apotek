package com.project.fms.transaction;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspAkrualProses extends JSPHandler implements I_JSPInterface, I_JSPType {

    private AkrualProses akrualProses;
    public static final String JSP_NAME_AKRUALPROSES = "JSP_NAME_AKRUALPROSES";
    public static final int JSP_FIELD_AKRUAL_PROSES_ID = 0;
    public static final int JSP_FIELD_REG_DATE = 1;
    public static final int JSP_FIELD_JUMLAH = 2;
    public static final int JSP_FIELD_CREDIT_COA_ID = 3;
    public static final int JSP_FIELD_DEBET_COA_ID = 4;
    public static final int JSP_FIELD_PERIODE_ID = 5;
    public static final int JSP_FIELD_USER_ID = 6;
    public static final int JSP_FIELD_AKRUAL_SETUP_ID = 7;
    public static final int JSP_FIELD_DEP_ID = 8;    
    public static final int JSP_SEGMENT1_ID   		=  9 ;    
    public static final int JSP_SEGMENT2_ID   		=  10 ; 
    public static final int JSP_SEGMENT3_ID   		=  11 ;    
    public static final int JSP_SEGMENT4_ID   		=  12 ;    
    public static final int JSP_SEGMENT5_ID   		=  13 ;   
    public static final int JSP_SEGMENT6_ID   		=  14 ;    
    public static final int JSP_SEGMENT7_ID   		=  15 ;    
    public static final int JSP_SEGMENT8_ID   		=  16 ;    
    public static final int JSP_SEGMENT9_ID   		=  17 ;    
    public static final int JSP_SEGMENT10_ID   		=  18 ;    
    public static final int JSP_SEGMENT11_ID   		=  19 ;    
    public static final int JSP_SEGMENT12_ID   		=  20 ;    
    public static final int JSP_SEGMENT13_ID   		=  21 ;    
    public static final int JSP_SEGMENT14_ID   		=  22 ;    
    public static final int JSP_SEGMENT15_ID   		=  23 ;  
    
    public static String[] colNames = {
        "JSP_FIELD_AKRUAL_PROSES_ID", "JSP_FIELD_REG_DATE",
        "JSP_FIELD_JUMLAH", "JSP_FIELD_CREDIT_COA_ID",
        "JSP_FIELD_DEBET_COA_ID", "JSP_FIELD_PERIODE_ID",
        "JSP_FIELD_USER_ID", "JSP_FIELD_AKRUAL_SETUP_ID", "JSP_FIELD_DEP_ID",
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
        TYPE_LONG, TYPE_DATE,
        TYPE_FLOAT + ENTRY_REQUIRED, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG, TYPE_LONG, TYPE_LONG,
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

    public JspAkrualProses() {
    }

    public JspAkrualProses(AkrualProses akrualProses) {
        this.akrualProses = akrualProses;
    }

    public JspAkrualProses(HttpServletRequest request, AkrualProses akrualProses) {
        super(new JspAkrualProses(akrualProses), request);
        this.akrualProses = akrualProses;
    }

    public String getFormName() {
        return JSP_NAME_AKRUALPROSES;
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

    public AkrualProses getEntityObject() {
        return akrualProses;
    }

    public void requestEntityObject(AkrualProses akrualProses) {
        try {
            this.requestParam();
            akrualProses.setRegDate(getDate(JSP_FIELD_REG_DATE));
            akrualProses.setJumlah(getDouble(JSP_FIELD_JUMLAH));
            akrualProses.setCreditCoaId(getLong(JSP_FIELD_CREDIT_COA_ID));
            akrualProses.setDebetCoaId(getLong(JSP_FIELD_DEBET_COA_ID));
            akrualProses.setPeriodeId(getLong(JSP_FIELD_PERIODE_ID));
            akrualProses.setUserId(getLong(JSP_FIELD_USER_ID));
            akrualProses.setAkrualSetupId(getLong(JSP_FIELD_AKRUAL_SETUP_ID));
            akrualProses.setDepId(getLong(JSP_FIELD_DEP_ID));
            akrualProses.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            akrualProses.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            akrualProses.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            akrualProses.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            akrualProses.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            akrualProses.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            akrualProses.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            akrualProses.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            akrualProses.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            akrualProses.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            akrualProses.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            akrualProses.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            akrualProses.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            akrualProses.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            akrualProses.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
