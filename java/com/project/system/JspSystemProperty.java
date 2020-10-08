

package com.project.system;

import javax.servlet.*;
import javax.servlet.http.*;

import com.project.util.jsp.*;
import com.project.main.entity.*;

import com.project.system.*;


public class JspSystemProperty extends JSPHandler implements I_JSPInterface, I_JSPType
{

    public static final String JSP_SYSPROP = "SYSPROP";
        
    public static final int JSP_NAME 	= 0;
    public static final int JSP_VALUE 	= 1;
    public static final int JSP_VALTYPE	= 2;
    public static final int JSP_DISTYPE	= 3;
    public static final int JSP_GROUP	= 4;
    public static final int JSP_NOTE	= 5;
    
    
    public static String[] fieldNames = {
        "x_name",
        "x_val",
        "x_valtype",
        "x_disttype",
        "x_grp",
        "x_note"
    };
    
    public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING  + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING
    };    
    

    private SystemProperty sysProp;
    
    
    
    /** Creates new FrmSystemProperty */ 
    public JspSystemProperty(SystemProperty sysProp)     
    { 
        this.sysProp = sysProp;        
    }  
        
    
    public JspSystemProperty(HttpServletRequest request, SystemProperty sysProp) {
        super(new JspSystemProperty(sysProp), request);
        this.sysProp = sysProp; 
    }

    public String getFormName() {
        return JSP_SYSPROP;
    }    
    
    public int[] getFieldTypes() {
        return fieldTypes;
    }    
    
    public String[] getFieldNames() {
        return fieldNames;
    }
        
    
    public int getFieldSize() {
        return fieldNames.length;
    }
       
    
    

    public SystemProperty getEntityObject()
    {
        return sysProp;
    }
    
    public SystemProperty setEntityObject(SystemProperty sp)
    {
        return sysProp = sp;
    }
    
    
    public void requestEntityObject(SystemProperty sysProp)
    {        
        try {
            this.requestParam();                    
            sysProp.setName(this.getString(JSP_NAME));
            sysProp.setValue(this.getString(JSP_VALUE));
            sysProp.setValueType(this.getString(JSP_VALTYPE));
            sysProp.setDisplayType(this.getString(JSP_DISTYPE));
            sysProp.setGroup(this.getString(JSP_GROUP));
            sysProp.setNote(this.getString(JSP_NOTE));
            
            this.sysProp = sysProp;
        }catch(Exception e) { 
            System.out.println("***FrmSystemProperty.requestEntityObject() " + e.toString());
            sysProp = new SystemProperty();
        }       
    }

    
} 
