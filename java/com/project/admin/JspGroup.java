
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


public class JspGroup extends JSPHandler implements I_JSPInterface, I_JSPType {

    public static final String JSP_APP_GROUP = "group";
        
    public static final int JSP_GROUP_NAME 				= 0;
    public static final int JSP_REG_DATE	 			= 1;
    public static final int JSP_DESCRIPTION	 			= 2;
    public static final int JSP_GROUP_PRIV	 			= 3;

    public static String[] colNames = {
             "x_group_name", 
             "x_group_reg_date", 
             "x_group_desc", 
             "x_group_priv"
    } ;

    public static int[] fieldTypes = {
        	TYPE_STRING + ENTRY_REQUIRED,  TYPE_DATE, TYPE_STRING, TYPE_COLLECTION
    };

    private Group appGroup = new Group();
    
    
    
    /** Creates new JspGroup */
    public JspGroup() {
    }

    public JspGroup(HttpServletRequest request) {
        super(new JspGroup(), request);
    }
    
    public String getFormName() {
        return JSP_APP_GROUP;
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
    
    
    public Group getEntityObject()
    {
        return appGroup;
    }
    
        
    public void requestEntityObject(Group appGroup)
    {        
        try {
            this.requestParam();                    
            appGroup.setGroupName(this.getString(JSP_GROUP_NAME));
            appGroup.setDescription(this.getString(JSP_DESCRIPTION));
            appGroup.setRegDate(this.getDate(JSP_REG_DATE));

            this.appGroup = appGroup;
        }catch(Exception e) {
            System.out.println("EXC... "+e);
            appGroup = new Group();
        }       
    }
    /**
     * has to be call after requestEntityObject
     * return Vector of GroupPriv objects
     **/ 
    public Vector getGroupPriv(long groupOID){
        Vector groupPrivs = new Vector(1,1);
        
        Vector privOIDs = this.getVectorLong(this.colNames[JSP_GROUP_PRIV]);        
        
        if (privOIDs==null)
            return groupPrivs;
        int max = privOIDs.size();
        
        for(int i=0; i< max; i++){
            long privOID = ( (Long)privOIDs.get(i)).longValue();
            GroupPriv gp = new GroupPriv();
            gp.setGroupID(groupOID);
            gp.setPrivID(privOID);
            groupPrivs.add(gp);
        }
        return groupPrivs;
    }
    
}
