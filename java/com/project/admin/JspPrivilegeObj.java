

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


public class JspPrivilegeObj extends JSPHandler implements I_JSPInterface, I_JSPType {

    public static final String JSP_APP_PRIVILEGE_OBJ = "privilegeobj";
        
    public static final int JSP_PRIV_ID 				= 0;
    public static final int JSP_G1_IDX  	 			= 1;
    public static final int JSP_G2_IDX	 			= 2;
    public static final int JSP_OBJ_IDX	 			= 3;
    public static final int JSP_COMMANDS	 			= 4;

    public static String[] colNames = {
             "x_priv_id", "x_g1_idx", "x_g2_idx", "x_obj_idx", "x_commands"
    } ;

    public static int[] fieldTypes = {
        	TYPE_LONG+ ENTRY_REQUIRED, TYPE_INT, TYPE_INT,
                TYPE_INT, TYPE_INT + TYPE_COLLECTION
    };

    private PrivilegeObj appPrivObj = new PrivilegeObj();
    
    
    
    /** Creates new JspPriv */
    public JspPrivilegeObj() {
    }

    public JspPrivilegeObj(HttpServletRequest request) {
        super(new JspPrivilegeObj(), request);
    }
    
    public String getFormName() {
        return JSP_APP_PRIVILEGE_OBJ;
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
    
    
    public PrivilegeObj getEntityObject(){
        return appPrivObj;
    }
    
        
    public void requestEntityObject(PrivilegeObj appPrivObj)
    {        
        try {
            this.requestParam();                    
            
            appPrivObj.setPrivId(this.getLong(JSP_PRIV_ID));
            
            int g1 = this.getInt(JSP_G1_IDX);
            int g2 = this.getInt(JSP_G2_IDX);
            int oidx = this.getInt(JSP_OBJ_IDX);            
            //System.out.println(" composeCode("+g1+","+g2+","+oidx+","+ObjInfo.COMMAND_VIEW);
            int code = ObjInfo.composeCode(g1,g2, oidx, ObjInfo.COMMAND_VIEW);            
            //System.out.println("code="+code);
            appPrivObj.setCode(code);
            
            Vector cmds = this.getVectorInt(this.colNames[JSP_COMMANDS]);
            appPrivObj.setCommands(cmds);
            this.appPrivObj = appPrivObj;
            
        }catch(Exception e) {
            System.out.println("EXC... "+e);
            appPrivObj = new PrivilegeObj();
        }       
    }
    
    
}
