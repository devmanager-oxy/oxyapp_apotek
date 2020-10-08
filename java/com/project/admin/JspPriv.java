

package com.project.admin;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.util.jsp.*;
import com.project.admin.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class JspPriv extends JSPHandler implements I_JSPInterface, I_JSPType {

    public static final String JSP_APP_PRIVILEGE = "privilege";
        
    public static final int JSP_PRIV_NAME 				= 0;
    public static final int JSP_REG_DATE	 			= 1;
    public static final int JSP_DESCRIPTION	 			= 2;

    public static String[] colNames = {
             "x_priv_name", 
             "x_priv_reg_date", 
             "x_priv_desc"
    } ;

    public static int[] fieldTypes = {
        	TYPE_STRING + ENTRY_REQUIRED,  TYPE_DATE, TYPE_STRING
    };

    private Priv appPriv = new Priv();
    
    
    
    /** Creates new JspPriv */
    public JspPriv() {
    }

    public JspPriv(HttpServletRequest request) {
        super(new JspPriv(), request);
    }
    
    public String getFormName() {
        return JSP_APP_PRIVILEGE;
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
    
    
    public Priv getEntityObject()
    {
        return appPriv;
    }
    
        
    public void requestEntityObject(Priv appPriv)
    {        
        try {
            this.requestParam();                    
            appPriv.setPrivName(this.getString(JSP_PRIV_NAME));
            appPriv.setDescr(this.getString(JSP_DESCRIPTION));
            appPriv.setRegDate(this.getDate(JSP_REG_DATE));

            this.appPriv = appPriv;
        }catch(Exception e) {
            System.out.println("EXC... "+e);
            appPriv = new Priv();
        }       
    }
    
    
}
