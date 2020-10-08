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

public class JspGlDetail2016 extends JSPHandler implements I_JSPInterface, I_JSPType{
    
    private GlDetail2016 glDetail2016;
    
    public static final String JSP_NAME_GLDETAIL2016 = "JSP_NAME_GLDETAIL2016";
    
    public static final int JSP_GL_ID = 0;
    public static final int JSP_GL_DETAIL_ID = 1;
    public static final int JSP_COA_ID = 2;
    public static final int JSP_DEBET = 3;
    public static final int JSP_CREDIT = 4;
    public static final int JSP_FOREIGN_CURRENCY_ID = 5;
    public static final int JSP_FOREIGN_CURRENCY_AMOUNT = 6;
    public static final int JSP_MEMO = 7;
    public static final int JSP_BOOKED_RATE = 8;
    public static final int JSP_IS_DEBET = 9;
    public static final int JSP_DEPARTMENT_ID = 10;
    public static final int JSP_MODULE_ID = 11;
    public static final int JSP_SEGMENT1_ID = 12;
    public static final int JSP_SEGMENT2_ID = 13;
    public static final int JSP_SEGMENT3_ID = 14;
    public static final int JSP_SEGMENT4_ID = 15;
    public static final int JSP_SEGMENT5_ID = 16;
    public static final int JSP_SEGMENT6_ID = 17;
    public static final int JSP_SEGMENT7_ID = 18;
    public static final int JSP_SEGMENT8_ID = 19;
    public static final int JSP_SEGMENT9_ID = 20;
    public static final int JSP_SEGMENT10_ID = 21;
    public static final int JSP_SEGMENT11_ID = 22;
    public static final int JSP_SEGMENT12_ID = 23;
    public static final int JSP_SEGMENT13_ID = 24;
    public static final int JSP_SEGMENT14_ID = 25;
    public static final int JSP_SEGMENT15_ID = 26;
    
    public static String[] colNames = {
        "detailJSP_GL_ID",
        "detailJSP_GL_DETAIL_ID",
        "detailJSP_COA_ID",
        "detailJSP_DEBET",
        "detailJSP_CREDIT",
        "detailJSP_FOREIGN_CURRENCY_ID",
        "detailJSP_FOREIGN_CURRENCY_AMOUNT",
        "detailJSP_MEMO",
        "detailJSP_BOOKED_RATE",
        "JSP_IS_DEBET",
        "detailDEPARTMENT_ID",
        "JSP_MODULE_ID",
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
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_FLOAT,
        TYPE_FLOAT, TYPE_LONG,
        TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
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
        TYPE_LONG
    };

    public JspGlDetail2016() {
    }

    public JspGlDetail2016(GlDetail2016 glDetail2016) {
        this.glDetail2016 = glDetail2016;
    }

    public JspGlDetail2016(HttpServletRequest request, GlDetail2016 glDetail2016) {
        super(new JspGlDetail2016(glDetail2016), request);
        this.glDetail2016 = glDetail2016;
    }

    public String getFormName() {
        return JSP_NAME_GLDETAIL2016;
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

    public GlDetail2016 getEntityObject() {
        return glDetail2016;
    }

    public void requestEntityObject(GlDetail2016 glDetail2016) {
        try {
            this.requestParam();
            glDetail2016.setModuleId(getLong(JSP_MODULE_ID));
            glDetail2016.setGlId(getLong(JSP_GL_ID));
            glDetail2016.setCoaId(getLong(JSP_COA_ID));
            glDetail2016.setDebet(getDouble(JSP_DEBET));
            glDetail2016.setCredit(getDouble(JSP_CREDIT));
            glDetail2016.setForeignCurrencyId(getLong(JSP_FOREIGN_CURRENCY_ID));
            glDetail2016.setForeignCurrencyAmount(getDouble(JSP_FOREIGN_CURRENCY_AMOUNT));
            glDetail2016.setMemo(getString(JSP_MEMO));
            glDetail2016.setBookedRate(getDouble(JSP_BOOKED_RATE));
            glDetail2016.setIsDebet(getInt(JSP_IS_DEBET));
            glDetail2016.setDepartmentId(getLong(JSP_DEPARTMENT_ID));

            glDetail2016.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            glDetail2016.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            glDetail2016.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            glDetail2016.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            glDetail2016.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            glDetail2016.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            glDetail2016.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            glDetail2016.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            glDetail2016.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            glDetail2016.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            glDetail2016.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            glDetail2016.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            glDetail2016.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            glDetail2016.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            glDetail2016.setSegment15Id(getLong(JSP_SEGMENT15_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
