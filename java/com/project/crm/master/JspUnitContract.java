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
public class JspUnitContract extends JSPHandler implements I_JSPInterface, I_JSPType {

    private UnitContract unitContract;
    
    public static final String JSP_NAME_UNIT_CONTRACT = "unit_contract";    
    
    public static final int JSP_NAMA        = 0;
    public static final int JSP_KODE        = 1;
    public static final int JSP_JML_BULAN   = 2;
    public static final int JSP_STATUS      = 3;
    
    public static String[] colNames = {
        "x_nama",
        "x_kode",
        "x_jml_bulan",
        "x_status"        
    };
    
    public static int[] fieldTypes = {
        TYPE_STRING     + ENTRY_REQUIRED,
        TYPE_STRING     + ENTRY_REQUIRED,
        TYPE_INT        + ENTRY_REQUIRED,                
        TYPE_INT
    };
    
    public JspUnitContract() {
    }

    public JspUnitContract(UnitContract unitContract) {
        this.unitContract = unitContract;
    }

    public JspUnitContract(HttpServletRequest request, UnitContract unitContract) {
        super(new JspUnitContract(unitContract), request);
        this.unitContract = unitContract;
    }

    public String getFormName() {
        return JSP_NAME_UNIT_CONTRACT;
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

    public UnitContract getEntityObject() {
        return unitContract;
    }

    public void requestEntityObject(UnitContract unitContract){
        try {

            this.requestParam();
            unitContract.setName(getString(JSP_NAMA));
            unitContract.setKode(getString(JSP_KODE));
            unitContract.setJmlBulan(getInt(JSP_JML_BULAN));            
            unitContract.setStatus(getInt(JSP_STATUS));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
    
}
