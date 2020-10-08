package com.project.fms.activity;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspModule extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Module module;
    public static final String JSP_NAME_MODULE = "module";
    
    public static final int JSP_MODULE_ID = 0;
    public static final int JSP_PARENT_ID = 1;
    public static final int JSP_CODE = 2;
    public static final int JSP_LEVEL = 3;
    public static final int JSP_DESCRIPTION = 4;
    public static final int JSP_OUTPUT_DELIVER = 5;
    public static final int JSP_PERFORM_INDICATOR = 6;
    public static final int JSP_ASSUM_RISK = 7;
    public static final int JSP_STATUS = 8;
    public static final int JSP_TYPE = 9;    
    public static final int JSP_COST_IMPLICATION = 10;
    public static final int JSP_PARENT_ID_M = 11;
    public static final int JSP_PARENT_ID_S = 12;
    public static final int JSP_PARENT_ID_SH = 13;
    public static final int JSP_PARENT_ID_A = 14;
    public static final int JSP_STATUS_POST = 15;
    public static final int JSP_INITIAL = 16;
    public static final int JSP_EXPIRED_DATE = 17;
    public static final int JSP_POSITION_LEVEL = 18;
    public static final int JSP_ACTIVITY_PERIOD_ID = 19;
    public static final int JSP_PARENT_ID_SA = 20;    
    
    public static final int JSP_SEGMENT1_ID = 21;
    public static final int JSP_SEGMENT2_ID = 22;
    public static final int JSP_SEGMENT3_ID = 23;
    public static final int JSP_SEGMENT4_ID = 24;
    public static final int JSP_SEGMENT5_ID = 25;
    public static final int JSP_SEGMENT6_ID = 26;
    public static final int JSP_SEGMENT7_ID = 27;
    public static final int JSP_SEGMENT8_ID = 28;
    public static final int JSP_SEGMENT9_ID = 29;
    public static final int JSP_SEGMENT10_ID = 30;
    public static final int JSP_SEGMENT11_ID = 31;
    public static final int JSP_SEGMENT12_ID = 32;
    public static final int JSP_SEGMENT13_ID = 33;
    public static final int JSP_SEGMENT14_ID = 34;
    public static final int JSP_SEGMENT15_ID = 35;
    
    public static final int JSP_ACT_DAY = 36;
    public static final int JSP_ACT_TIME = 37;
    public static final int JSP_ACT_DATE = 38;
    public static final int JSP_NOTE = 39;
    public static final int JSP_MODULE_LEVEL = 40;
    
    public static final int JSP_DOC_STATUS = 41;
    public static final int JSP_CREATE_ID = 42;
    public static final int JSP_CREATE_DATE = 43;
    public static final int JSP_APPROVAL1_ID = 44;
    public static final int JSP_APPROVAL1_DATE = 45;
    
    public static String[] colNames = {
        "x_module_id", //0
        "x_parent_id",
        "x_code", 
        "x_level",        
        "x_description", 
        "x_output_deliver",
        "x_perform_indicator", 
        "x_assum_risk",
        "x_status", 
        "x_type",//9        
        "x_cimp",
        "M", 
        "S", 
        "SH", 
        "A", //14        
        "postab",
        "JSP_INITIAL", 
        "JSP_EXPIRED_DATE",
        "JSP_POSITION_LEVEL", 
        "JSP_ACTIVITY_PERIOD_ID",//19        
        "SA", //20
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
        "JSP_SEGMENT15_ID", //35        
        "JSP_ACT_DAY",
        "JSP_ACT_TIME",
        "JSP_ACT_DATE",
        "JSP_NOTE",
        "JSP_MODULE_LEVEL",
        "JSP_DOC_STATUS",
        "JSP_CREATE_ID",
        "JSP_CREATE_DATE",
        "JSP_APPROVAL1_ID",
        "JSP_APPROVAL1_DATE"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG,
        TYPE_STRING, 
        TYPE_STRING,
        TYPE_STRING + ENTRY_REQUIRED, 
        TYPE_STRING,
        TYPE_STRING, 
        TYPE_STRING,
        TYPE_STRING, 
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG, 
        TYPE_LONG, 
        TYPE_LONG, 
        TYPE_LONG, 
        TYPE_STRING,
        TYPE_STRING, 
        TYPE_STRING,
        TYPE_STRING, 
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
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_DATE
    };

    public JspModule() {
    }

    public JspModule(Module module) {
        this.module = module;
    }

    public JspModule(HttpServletRequest request, Module module) {
        super(new JspModule(module), request);
        this.module = module;
    }

    public String getFormName() {
        return JSP_NAME_MODULE;
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

    public Module getEntityObject() {
        return module;
    }

    public void requestEntityObject(Module module) {
        try {
            this.requestParamExcTitikKoma();
            module.setParentId(getLong(JSP_PARENT_ID));
            module.setCode(getString(JSP_CODE));
            module.setLevel(getString(JSP_LEVEL));
            module.setDescription(getString(JSP_DESCRIPTION));
            module.setOutputDeliver(getString(JSP_OUTPUT_DELIVER));
            module.setPerformIndicator(getString(JSP_PERFORM_INDICATOR));
            module.setAssumRisk(getString(JSP_ASSUM_RISK));
            module.setStatus(getString(JSP_STATUS));
            module.setType(getString(JSP_TYPE));
            module.setCostImplication(getString(JSP_COST_IMPLICATION));

            module.setParentIdM(getLong(JSP_PARENT_ID_M));
            module.setParentIdS(getLong(JSP_PARENT_ID_S));
            module.setParentIdSH(getLong(JSP_PARENT_ID_SH));
            module.setParentIdA(getLong(JSP_PARENT_ID_A));
            module.setStatusPost(getString(JSP_STATUS_POST));

            module.setInitial(getString(JSP_INITIAL));
            module.setExpiredDate(JSPFormater.formatDate(getString(JSP_EXPIRED_DATE), "dd/MM/yyyy"));
            module.setPositionLevel(getString(JSP_POSITION_LEVEL));
            module.setActivityPeriodId(getLong(JSP_ACTIVITY_PERIOD_ID));

            module.setParentIdSA(getLong(JSP_PARENT_ID_SA));

            module.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            module.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            module.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            module.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            module.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            module.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            module.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            module.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            module.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            module.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            module.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            module.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            module.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            module.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            module.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            module.setActDay(getString(JSP_ACT_DAY));
            module.setActTime(getString(JSP_ACT_TIME));
            module.setActDate(getString(JSP_ACT_DATE));
            module.setNote(getString(JSP_NOTE));
            module.setModuleLevel(getInt(JSP_MODULE_LEVEL));
            
            module.setDocStatus(getInt(JSP_DOC_STATUS));
            module.setCreateId(getLong(JSP_CREATE_ID));
            module.setApproval1Id(getLong(JSP_APPROVAL1_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
