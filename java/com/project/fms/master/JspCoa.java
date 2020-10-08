package com.project.fms.master;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspCoa extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Coa coa;
    public static final String JSP_NAME_COA = "coa";
    public static final int JSP_COA_ID = 0;
    public static final int JSP_ACC_REF_ID = 1;
    public static final int JSP_DEPARTMENT_ID = 2;
    public static final int JSP_SECTION_ID = 3;
    public static final int JSP_ACCOUNT_GROUP = 4;
    public static final int JSP_CODE = 5;
    public static final int JSP_NAME = 6;
    public static final int JSP_LEVEL = 7;
    public static final int JSP_SALDO_NORMAL = 8;
    public static final int JSP_STATUS = 9;
    public static final int JSP_DEPARTMENT_NAME = 10;
    public static final int JSP_SECTION_NAME = 11;
    public static final int JSP_USER_ID = 12;
    public static final int JSP_OPENING_BALANCE = 13;
    public static final int JSP_LOCATION_ID = 14;
    public static final int JSP_DEPARTMENTAL_COA = 15;
    public static final int JSP_COA_CATEGORY_ID = 16;
    public static final int JSP_COA_GROUP_ALIAS_ID = 17;
    public static final int JSP_IS_NEED_EXTRA = 18;
    public static final int JSP_DEBET_PREFIX_CODE = 19;
    public static final int JSP_CREDIT_PREFIX_CODE = 20;
    public static final int JSP_ACCOUNT_CLASS = 21;
    public static final int JSP_AUTO_REVERSE = 22;
    public static final int JSP_SEGMENT1_ID = 23;
    public static final int JSP_SEGMENT2_ID = 24;
    public static final int JSP_SEGMENT3_ID = 25;
    public static final int JSP_SEGMENT4_ID = 26;
    public static final int JSP_SEGMENT5_ID = 27;
    
    public static String[] colNames = {
        "x_coa_id", "x_acc_ref_id",
        "x_department_id", "x_section_id",
        "x_account_group", "x_code",
        "x_name", "x_level",
        "x_saldo_normal", "x_status",
        "x_department_name", "x_section_name",
        "x_user_id", "x_obalance",
        "x_location_id", "x_departmental_coa",
        "x_coa_category_id", "x_coa_group_alias_id",
        "JSP_IS_NEED_EXTRA", "JSP_DEBET_PREFIX_CODE",
        "JSP_CREDIT_PREFIX_CODE", "JSP_ACCOUNT_CLASS",
        "JSP_AUTO_REVERSE",
        "JSP_SEGMENT1_ID", "JSP_SEGMENT2_ID", "JSP_SEGMENT3_ID", "JSP_SEGMENT4_ID", "JSP_SEGMENT5_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG, TYPE_LONG,
        TYPE_STRING, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED, TYPE_INT + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_LONG, TYPE_FLOAT,
        TYPE_LONG, TYPE_INT,
        TYPE_LONG, TYPE_LONG,
        TYPE_INT, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_INT, 
        TYPE_LONG, TYPE_LONG, TYPE_LONG, TYPE_LONG, TYPE_LONG
    };

    public JspCoa() {
    }

    public JspCoa(Coa coa) {
        this.coa = coa;
    }

    public JspCoa(HttpServletRequest request, Coa coa) {
        super(new JspCoa(coa), request);
        this.coa = coa;
    }

    public String getFormName() {
        return JSP_NAME_COA;
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

    public Coa getEntityObject() {
        return coa;
    }

    public void requestEntityObject(Coa coa) {
        try {
            this.requestParam();
            coa.setAccRefId(getLong(JSP_ACC_REF_ID));
            coa.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
            coa.setSectionId(getLong(JSP_SECTION_ID));
            coa.setAccountGroup(getString(JSP_ACCOUNT_GROUP));
            coa.setCode(getString(JSP_CODE));
            coa.setName(getString(JSP_NAME));
            coa.setLevel(getInt(JSP_LEVEL));
            coa.setSaldoNormal(getString(JSP_SALDO_NORMAL));
            coa.setStatus(getString(JSP_STATUS));
            coa.setDepartmentName(getString(JSP_DEPARTMENT_NAME));
            coa.setSectionName(getString(JSP_SECTION_NAME));
            coa.setUserId(getLong(JSP_USER_ID));
            coa.setOpeningBalance(getDouble(JSP_OPENING_BALANCE));
            coa.setLocationId(getLong(JSP_LOCATION_ID));
            coa.setDepartmentalCoa(getInt(JSP_DEPARTMENTAL_COA));
            coa.setDepartmentalCoa(getInt(JSP_DEPARTMENTAL_COA));
            coa.setCoaCategoryId(getLong(JSP_COA_CATEGORY_ID));
            coa.setCoaGroupAliasId(getLong(JSP_COA_GROUP_ALIAS_ID));
            coa.setAccountClass(getInt(JSP_ACCOUNT_CLASS));
            coa.setAutoReverse(getInt(JSP_AUTO_REVERSE));
            coa.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            coa.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            coa.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            coa.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            coa.setSegment5Id(getLong(JSP_SEGMENT5_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
