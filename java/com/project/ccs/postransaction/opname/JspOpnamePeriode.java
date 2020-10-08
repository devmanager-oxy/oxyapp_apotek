package com.project.ccs.postransaction.opname;

import com.project.util.JSPFormater;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspOpnamePeriode extends JSPHandler implements I_JSPInterface, I_JSPType {

    private OpnamePeriode opnamePeriode;
    public static final String JSP_NAME_OPNAME_PERIODE = "JSP_NAME_OPNAME_PERIODE";
    public static final int JSP_OPNAME_PERIODE_ID = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_START_DATE = 2;
    public static final int JSP_END_DATE = 3;
    public static final int JSP_STATUS = 4;
    
    public static String[] colNames = {
        "JSP_OPNAME_PERIODE_ID", "JSP_NAME",
        "JSP_START_DATE", "JSP_END_DATE",
        "JSP_STATUS"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_STRING,
        TYPE_STRING, TYPE_STRING,
        TYPE_STRING
    };

    public JspOpnamePeriode() {
    }

    public JspOpnamePeriode(OpnamePeriode opname) {
        this.opnamePeriode = opname;
    }

    public JspOpnamePeriode(HttpServletRequest request, OpnamePeriode opname) {
        super(new JspOpnamePeriode(opname), request);
        this.opnamePeriode = opname;
    }

    public String getFormName() {
        return JSP_NAME_OPNAME_PERIODE;
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

    public OpnamePeriode getEntityObject() {
        return opnamePeriode;
    }

    public void requestEntityObject(OpnamePeriode opname) {
        try {
            this.requestParam();
            //opname.setCounter(getInt(JSP_COUNTER));
            //opname.setNumber(getInt(JSP_NUMBER));
            opname.setName(getString(JSP_NAME));
            opname.setStartDate(JSPFormater.formatDate(getString(JSP_START_DATE), "dd/MM/yyyy"));
            opname.setEndDate(JSPFormater.formatDate(getString(JSP_END_DATE), "dd/MM/yyyy"));
            opname.setStatus(getString(JSP_STATUS));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
