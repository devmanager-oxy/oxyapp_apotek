/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.service;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class JspServiceConfiguration extends JSPHandler implements I_JSPInterface, I_JSPType {

    private ServiceConfiguration serviceConfiguration;
    public static final String JSP_SERVICE_CONF = "JSP_SERVICE_CONF";
    public static final int JSP_SERVICE_ID = 0;
    public static final int JSP_SERVICE_TYPE = 1;
    public static final int JSP_START_TIME = 2;
    public static final int JSP_PERIODE = 3;
    public static String[] fieldNames = {
        "JSP_SERVICE_ID",
        "JSP_SERVICE_TYPE",
        "JSP_START_TIME",
        "JSP_PERIODE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_INT,
        TYPE_DATE,
        TYPE_INT
    };

    public JspServiceConfiguration() {
    }

    public JspServiceConfiguration(ServiceConfiguration serviceConfiguration) {
        this.serviceConfiguration = serviceConfiguration;
    }

    public JspServiceConfiguration(HttpServletRequest request, ServiceConfiguration serviceConfiguration) {
        super(new JspServiceConfiguration(serviceConfiguration), request);
        this.serviceConfiguration = serviceConfiguration;
    }

    public String getFormName() {
        return JSP_SERVICE_CONF;
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

    public ServiceConfiguration getEntityObject() {
        return serviceConfiguration;
    }

    public void requestEntityObject(ServiceConfiguration serviceConfiguration) {
        try {
            this.requestParam();
            serviceConfiguration.setServiceType(getInt(JSP_SERVICE_TYPE));
            serviceConfiguration.setStartTime(getDate(JSP_START_TIME));
            serviceConfiguration.setPeriode(getInt(JSP_PERIODE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
