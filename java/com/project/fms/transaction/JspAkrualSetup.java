package com.project.fms.transaction;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspAkrualSetup extends JSPHandler implements I_JSPInterface, I_JSPType {

    private AkrualSetup akrualSetup;
    public static final String JSP_NAME_AKRUALSETUP = "JSP_NAME_AKRUALSETUP";
    public static final int JSP_FIELD_AKRUAL_SETUP_ID = 0;
    public static final int JSP_FIELD_NAMA = 1;
    public static final int JSP_FIELD_ANGGARAN = 2;
    public static final int JSP_FIELD_PEMBAGI = 3;
    public static final int JSP_FIELD_CREDIT_COA_ID = 4;
    public static final int JSP_FIELD_DEBET_COA_ID = 5;
    public static final int JSP_FIELD_REG_DATE = 6;
    public static final int JSP_FIELD_LAST_UPDATE = 7;
    public static final int JSP_FIELD_USER_ID = 8;
    public static final int JSP_FIELD_STATUS = 9;
    public static final int JSP_FIELD_DEP_ID = 10;    
    public static final int JSP_SEGMENT1_ID   		=  11 ;    
    public static final int JSP_SEGMENT2_ID   		=  12 ; 
    public static final int JSP_SEGMENT3_ID   		=  13 ;    
    public static final int JSP_SEGMENT4_ID   		=  14 ;    
    public static final int JSP_SEGMENT5_ID   		=  15 ;   
    public static final int JSP_SEGMENT6_ID   		=  16 ;    
    public static final int JSP_SEGMENT7_ID   		=  17 ;    
    public static final int JSP_SEGMENT8_ID   		=  18 ;    
    public static final int JSP_SEGMENT9_ID   		=  19 ;    
    public static final int JSP_SEGMENT10_ID   		=  20 ;    
    public static final int JSP_SEGMENT11_ID   		=  21 ;    
    public static final int JSP_SEGMENT12_ID   		=  22 ;    
    public static final int JSP_SEGMENT13_ID   		=  23 ;    
    public static final int JSP_SEGMENT14_ID   		=  24 ;    
    public static final int JSP_SEGMENT15_ID   		=  25 ;        
    
    public static String[] colNames = {
        "JSP_FIELD_AKRUAL_SETUP_ID", "JSP_FIELD_NAMA",
        "JSP_FIELD_ANGGARAN", "JSP_FIELD_PEMBAGI",
        "JSP_FIELD_CREDIT_COA_ID", "JSP_FIELD_DEBET_COA_ID",
        "JSP_FIELD_REG_DATE", "JSP_FIELD_LAST_UPDATE",
        "JSP_FIELD_USER_ID", "JSP_FIELD_STATUS", 
        "JSP_FIELD_DEP_ID",        
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
        TYPE_LONG, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_FLOAT + ENTRY_REQUIRED, TYPE_INT + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_DATE, TYPE_DATE,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_INT, TYPE_LONG,
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

    public JspAkrualSetup() {
    }

    public JspAkrualSetup(AkrualSetup akrualSetup) {
        this.akrualSetup = akrualSetup;
    }

    public JspAkrualSetup(HttpServletRequest request, AkrualSetup akrualSetup) {
        super(new JspAkrualSetup(akrualSetup), request);
        this.akrualSetup = akrualSetup;
    }

    public String getFormName() {
        return JSP_NAME_AKRUALSETUP;
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

    public AkrualSetup getEntityObject() {
        return akrualSetup;
    }

    public void requestEntityObject(AkrualSetup akrualSetup) {
        try {
            this.requestParam();
            akrualSetup.setNama(getString(JSP_FIELD_NAMA));
            akrualSetup.setAnggaran(getDouble(JSP_FIELD_ANGGARAN));
            akrualSetup.setPembagi(getInt(JSP_FIELD_PEMBAGI));
            akrualSetup.setCreditCoaId(getLong(JSP_FIELD_CREDIT_COA_ID));
            akrualSetup.setDebetCoaId(getLong(JSP_FIELD_DEBET_COA_ID));            
            akrualSetup.setLastUpdate(getDate(JSP_FIELD_LAST_UPDATE));
            akrualSetup.setUserId(getLong(JSP_FIELD_USER_ID));
            akrualSetup.setStatus(getInt(JSP_FIELD_STATUS));
            akrualSetup.setDepId(getLong(JSP_FIELD_DEP_ID));            
            akrualSetup.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            akrualSetup.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            akrualSetup.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            akrualSetup.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            akrualSetup.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            akrualSetup.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            akrualSetup.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            akrualSetup.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            akrualSetup.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            akrualSetup.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            akrualSetup.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            akrualSetup.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            akrualSetup.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            akrualSetup.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            akrualSetup.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            
        } catch (Exception e) {
            System.out.println("Excp : " + e.toString());
        }
    }
}
