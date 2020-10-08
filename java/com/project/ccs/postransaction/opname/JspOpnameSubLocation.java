package com.project.ccs.postransaction.opname;

import com.project.util.JSPFormater;
import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspOpnameSubLocation extends JSPHandler implements I_JSPInterface, I_JSPType {

    private OpnameSubLocation opnameSubLocation;
    public static final String JSP_NAME_OPNAME_SUB_LOCATION = "JSP_OPNAME_SUB_LOCATION";
    public static final int JSP_OPNAME_SUB_LOCATION_ID = 0;
    public static final int JSP_OPNAME_ID = 1;
    public static final int JSP_SUB_LOCATION_ID = 2;
    public static final int JSP_SUB_LOCATION_NAME = 3;
    public static final int JSP_STATUS = 4;
    public static final int JSP_FORM_NUMBER = 5;
    public static final int JSP_DATE = 6;
    
    
    public static String[] colNames = {
        "JSP_OPNAME_SUB_LOCATION_ID", "OPNAME_ID",
        "JSP_SUB_LOCATION_ID", "JSP_SUB_LOCATION_NAME",
        "JSP_STATUS","JSP_FORM_NUMBER","JSP_DATE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG, TYPE_LONG,
        TYPE_STRING, TYPE_STRING,TYPE_STRING, TYPE_STRING
       
    };

    public JspOpnameSubLocation() {
    }

    public JspOpnameSubLocation(OpnameSubLocation opnameSubLocation) {
        this.opnameSubLocation = opnameSubLocation;
    }

    public JspOpnameSubLocation(HttpServletRequest request, OpnameSubLocation opnameSubLocation) {
        super(new JspOpnameSubLocation(opnameSubLocation), request);
        this.opnameSubLocation = opnameSubLocation;
    }

    public String getFormName() {
        return JSP_NAME_OPNAME_SUB_LOCATION;
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

    public OpnameSubLocation getEntityObject() {
        return opnameSubLocation;
    }

    public void requestEntityObject(OpnameSubLocation opnameSubLocation) {
        try {
            this.requestParam();
            
            opnameSubLocation.setSubLocationId(getLong(JSP_SUB_LOCATION_ID));
            //opnameSubLocation.setSubLocationName(getString(JSP_SUB_LOCATION_NAME));
            opnameSubLocation.setStatus(getString(JSP_STATUS));
            opnameSubLocation.setFormNumber(getString(JSP_FORM_NUMBER));
            opnameSubLocation.setDate(JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy"));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
