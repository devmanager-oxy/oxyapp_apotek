/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy
 */
public class JspVendorGroup extends JSPHandler implements I_JSPInterface, I_JSPType {

    private VendorGroup vendorGroup;
    public static final String JSP_NAME_VENDOR = "jsp_vendor_group";
    public static final int JSP_VENDOR_GROUP_ID = 0;
    public static final int JSP_GROUP_NAME = 1;
    public static final int JSP_VENDOR_ID = 2;
    public static String[] colNames = {
        "JSP_VENDOR_GROUP_ID",
        "JSP_GROUP_NAME",
        "JSP_VENDOR_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED
    };

    public JspVendorGroup() {
    }

    public JspVendorGroup(VendorGroup vendorGroup) {
        this.vendorGroup = vendorGroup;
    }

    public JspVendorGroup(HttpServletRequest request, VendorGroup vendorGroup) {
        super(new JspVendorGroup(vendorGroup), request);
        this.vendorGroup = vendorGroup;
    }

    public String getFormName() {
        return JSP_NAME_VENDOR;
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

    public VendorGroup getEntityObject() {
        return vendorGroup;
    }

    public void requestEntityObject(VendorGroup vendorGroup) {
        try {
            this.requestParam();
            vendorGroup.setGroupName(getString(JSP_GROUP_NAME));
            vendorGroup.setVendorId(getLong(JSP_VENDOR_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
