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
 * @author Roy Andika
 */
public class JspGiro extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Giro giro;
    
    public static final String JSP_NAME_GIRO = "JSP_NAME_GIRO";
    public static final int JSP_GIRO_ID = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_COA_ID = 2;
    
    public static String[] colNames = {
        "JSP_GIRO_ID", "JSP_NAME","JSP_COA_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_STRING + ENTRY_REQUIRED,TYPE_LONG + ENTRY_REQUIRED
    };

    public JspGiro() {
    }

    public JspGiro(Giro giro) {
        this.giro = giro;
    }

    public JspGiro(HttpServletRequest request, Giro giro) {
        super(new JspGiro(giro), request);
        this.giro = giro;
    }

    public String getFormName() {
        return JSP_NAME_GIRO;
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

    public Giro getEntityObject() {
        return giro;
    }

    public void requestEntityObject(Giro giro) {
        try {
            this.requestParam();
            giro.setName(getString(JSP_NAME));
            giro.setCoaId(getLong(JSP_COA_ID));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
