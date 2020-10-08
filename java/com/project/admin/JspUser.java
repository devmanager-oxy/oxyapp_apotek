package com.project.admin;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.util.jsp.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class JspUser extends JSPHandler implements I_JSPInterface, I_JSPType {

    public static final String JSP_APP_USER = "user";
    public static final int JSP_LOGIN_ID = 0;
    public static final int JSP_PASSWORD = 1;
    public static final int JSP_CJSP_PASSWORD = 2;
    public static final int JSP_FULL_NAME = 3;
    public static final int JSP_EMAIL = 4;
    public static final int JSP_DESCRIPTION = 5;
    public static final int JSP_REG_DATE = 6;
    public static final int JSP_UPDATE_DATE = 7;
    public static final int JSP_USER_STATUS = 8;
    public static final int JSP_LAST_LOGIN_DATE = 9;
    public static final int JSP_LAST_LOGIN_IP = 10;
    public static final int JSP_USER_GROUP = 11;
    public static final int JSP_EMPLOYEE_ID = 12;
    public static final int JSP_EMPLOYEE_NUM = 13;
    public static final int JSP_USER_LEVEL = 14;
    public static final int JSP_SEGMENT1_ID = 15;
    public static final int JSP_SEGMENT2_ID = 16;
    public static final int JSP_SEGMENT3_ID = 17;
    public static final int JSP_SEGMENT4_ID = 18;
    public static final int JSP_SEGMENT5_ID = 19;
    public static final int JSP_SEGMENT6_ID = 20;
    public static final int JSP_SEGMENT7_ID = 21;
    public static final int JSP_SEGMENT8_ID = 21;
    public static final int JSP_SEGMENT9_ID = 23;
    public static final int JSP_SEGMENT10_ID = 24;
    public static final int JSP_SEGMENT11_ID = 25;
    public static final int JSP_SEGMENT12_ID = 26;
    public static final int JSP_SEGMENT13_ID = 27;
    public static final int JSP_SEGMENT14_ID = 28;
    public static final int JSP_SEGMENT15_ID = 29;
    public static final int JSP_COMPANY_ID = 30;
    public static final int JSP_USER_KEY = 31;
    
    public static final String[] colNames = {
        "x_loginid", "x_password",
        "x_cpassword", "x_fullname",
        "x_email", "x_description",
        "x_regdate", "x_updatedate",
        "x_userstatus", "x_lastlogindate",
        "x_loginip", "x_group",
        "x_empid", "x_empnum",
        "x_level","x_SEGMENT1_ID",
        "x_SEGMENT2_ID",
        "x_SEGMENT3_ID",
        "x_SEGMENT4_ID",
        "x_SEGMENT5_ID",
        "x_SEGMENT6_ID",
        "x_SEGMENT7_ID",
        "x_SEGMENT8_ID",
        "x_SEGMENT9_ID",
        "x_SEGMENT10_ID",
        "x_SEGMENT11_ID",
        "x_SEGMENT12_ID",
        "x_SEGMENT13_ID",
        "x_SEGMENT14_ID",
        "x_SEGMENT15_ID",
        "x_COMPANY_ID",
        "x_USER_KEY"
    };
    public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED, //x_loginid
        TYPE_STRING + ENTRY_REQUIRED, //x_password
        TYPE_STRING + ENTRY_REQUIRED, //x_cpassword
        TYPE_STRING, //x_fullname
        TYPE_STRING + FORMAT_EMAIL, //x_email
        TYPE_STRING, //x_description
        TYPE_DATE, //x_regdate
        TYPE_DATE, //x_updatedate
        TYPE_INT, //x_userstatus
        TYPE_DATE, //x_lastlogindate
        TYPE_STRING, //x_loginip
        TYPE_COLLECTION, //x_group
        TYPE_LONG + ENTRY_REQUIRED, //x_empid
        TYPE_STRING, //x_empnum
        TYPE_INT, //x_level
        TYPE_LONG, //x_SEGMENT1_ID
        TYPE_LONG, //x_SEGMENT2_ID
        TYPE_LONG, //x_SEGMENT3_ID
        TYPE_LONG, //x_SEGMENT4_ID
        TYPE_LONG, //x_SEGMENT5_ID
        TYPE_LONG, //x_SEGMENT6_ID
        TYPE_LONG, //x_SEGMENT7_ID
        TYPE_LONG, //x_SEGMENT8_ID
        TYPE_LONG, //x_SEGMENT9_ID
        TYPE_LONG, //x_SEGMENT10_ID
        TYPE_LONG, //x_SEGMENT11_ID
        TYPE_LONG, //x_SEGMENT12_ID
        TYPE_LONG, //x_SEGMENT13_ID
        TYPE_LONG, //x_SEGMENT14_ID
        TYPE_LONG, //x_SEGMENT15_ID
        TYPE_LONG, //x_COMPANY_ID
        TYPE_STRING //x_USER_KEY
    };
    private User appUser = new User();

    /** Creates new JspUser */
    public JspUser() {
    }

    public JspUser(HttpServletRequest request) {
        super(new JspUser(), request);
    }

    public String getFormName() {
        return JSP_APP_USER;
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

    public User getEntityObject() {
        return appUser;
    }

    public void requestEntityObject(User entObj) {
        try {
            this.requestParam();
            entObj.setLoginId(this.getString(JSP_LOGIN_ID));
            entObj.setPassword(this.getString(JSP_PASSWORD));
            entObj.setFullName(this.getString(JSP_FULL_NAME));
            entObj.setEmail(this.getString(JSP_EMAIL));
            entObj.setDescription(this.getString(JSP_DESCRIPTION));            
            entObj.setUserStatus(this.getInt(JSP_USER_STATUS));            
            entObj.setLastLoginIp(this.getString(JSP_LAST_LOGIN_IP));
            entObj.setEmployeeId(this.getLong(JSP_EMPLOYEE_ID));
            entObj.setEmployeeNum(this.getString(JSP_EMPLOYEE_NUM));
            entObj.setUserLevel(this.getInt(JSP_USER_LEVEL));
            entObj.setSegment1Id(getLong(JSP_SEGMENT1_ID));
            entObj.setSegment2Id(getLong(JSP_SEGMENT2_ID));
            entObj.setSegment3Id(getLong(JSP_SEGMENT3_ID));
            entObj.setSegment4Id(getLong(JSP_SEGMENT4_ID));
            entObj.setSegment5Id(getLong(JSP_SEGMENT5_ID));
            entObj.setSegment6Id(getLong(JSP_SEGMENT6_ID));
            entObj.setSegment7Id(getLong(JSP_SEGMENT7_ID));
            entObj.setSegment8Id(getLong(JSP_SEGMENT8_ID));
            entObj.setSegment9Id(getLong(JSP_SEGMENT9_ID));
            entObj.setSegment10Id(getLong(JSP_SEGMENT10_ID));
            entObj.setSegment11Id(getLong(JSP_SEGMENT11_ID));
            entObj.setSegment12Id(getLong(JSP_SEGMENT12_ID));
            entObj.setSegment13Id(getLong(JSP_SEGMENT13_ID));
            entObj.setSegment14Id(getLong(JSP_SEGMENT14_ID));
            entObj.setSegment15Id(getLong(JSP_SEGMENT15_ID));
            entObj.setCompanyId(getLong(JSP_COMPANY_ID));
            entObj.setUserKey(getString(JSP_USER_KEY));
            
            this.appUser = entObj;
            
        } catch (Exception e) {
            System.out.println("EXC... " + e);
            entObj = new User();
        }
    }

    /**
     * has to be call after requestEntityObject
     * return Vector of UserGroup objects
     **/
    public Vector getUserGroup(long userOID) {
        Vector userGroups = new Vector(1, 1);

        Vector groupOIDs = this.getVectorLong(this.colNames[JSP_USER_GROUP]);

        if (groupOIDs == null) {
            return userGroups;
        }
        int max = groupOIDs.size();

        for (int i = 0; i < max; i++) {
            long groupOID = ((Long) groupOIDs.get(i)).longValue();
            UserGroup ug = new UserGroup();
            ug.setUserID(userOID);
            ug.setGroupID(groupOID);
            userGroups.add(ug);
        }
        return userGroups;
    }
}

