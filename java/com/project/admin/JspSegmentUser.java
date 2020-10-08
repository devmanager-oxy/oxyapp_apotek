/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.admin;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.util.jsp.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Roy Andika
 */
public class JspSegmentUser extends JSPHandler implements I_JSPInterface, I_JSPType {

    private SegmentUser segmentUser;
    public static final String JSP_SEGMENT_USER = "segment_user";
    public static final int JSP_SEGMENT_USER_ID = 0;
    public static final int JSP_USER_ID = 1;
    public static final int JSP_SEGMENT_DETAIL_ID = 2;
    public static final String[] colNames = {
        "JSP_SEGMENT_USER_ID",
        "JSP_USER_ID",
        "JSP_SEGMENT_DETAIL_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public JspSegmentUser() {
    }

    public JspSegmentUser(SegmentUser segmentUser) {
        this.segmentUser = segmentUser;
    }

    public JspSegmentUser(HttpServletRequest request, SegmentUser segmentUser) {
        super(new JspSegmentUser(segmentUser), request);
        this.segmentUser = segmentUser;
    }

    public String getFormName() {
        return JSP_SEGMENT_USER;
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

    public SegmentUser getEntityObject() {
        return segmentUser;
    }

    public void requestEntityObject(SegmentUser entObj) {
        try {
            this.requestParam();
            entObj.setSegmentDetailId(this.getLong(JSP_SEGMENT_DETAIL_ID));
            entObj.setUserId(this.getLong(JSP_USER_ID));
        } catch (Exception e) {
            System.out.println("EXC... " + e);
        }
    }
}
