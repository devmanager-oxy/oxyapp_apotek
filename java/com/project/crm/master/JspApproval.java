/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.crm.master;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Tu Roy
 */
public class JspApproval extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Approval approval;
    public static final String JSP_NAME_APPROVAL = "approval";
    public static final int JSP_TYPE = 0;
    public static final int JSP_URUTAN = 1;
    public static final int JSP_KETERANGAN = 2;
    public static final int JSP_EMPLOYEE_ID = 3;
    
    public static final int JSP_JUMLAH_DARI = 4;
    public static final int JSP_JUMLAH_SAMPAI = 5;
    public static final int JSP_URUTAN_APPROVAL = 6;
    public static final int JSP_KETERANGAN_FOOTER = 7;
    
    public static String[] colNames = {
        "x_type",
        "x_urutan",
        "x_keterangan",
        "x_employee_id",
        "x_jumlah_dari",
        "x_jumlah_sampai",
        "x_urutan_approval",
        "x_keterangan_footer"        	
    };
    public static int[] fieldTypes = {
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_STRING
    };

    public JspApproval() {
    }

    public JspApproval(Approval approval) {
        this.approval = approval;
    }

    public JspApproval(HttpServletRequest request, Approval approval) {
        super(new JspApproval(approval), request);
        this.approval = approval;
    }

    public String getFormName() {
        return JSP_NAME_APPROVAL;
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

    public Approval getEntityObject() {
        return approval;
    }

    public void requestEntityObject(Approval approval) {
        try {

            this.requestParam();
            approval.setType(getInt(JSP_TYPE));
            approval.setUrutan(getInt(JSP_URUTAN));
            approval.setKeterangan(getString(JSP_KETERANGAN));
            approval.setEmployeeId(getLong(JSP_EMPLOYEE_ID));
            
            approval.setJumlahDari(getDouble(JSP_JUMLAH_DARI));
            approval.setJumlahSampai(getDouble(JSP_JUMLAH_SAMPAI));
            approval.setUrutanApproval(getInt(JSP_URUTAN_APPROVAL));
            approval.setKeteranganFooter(getString(JSP_KETERANGAN_FOOTER));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
