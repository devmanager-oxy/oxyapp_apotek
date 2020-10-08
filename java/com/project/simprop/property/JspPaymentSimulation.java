/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import com.project.util.JSPFormater;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class JspPaymentSimulation extends JSPHandler implements I_JSPInterface, I_JSPType {

    private PaymentSimulation paymentSimulation;
    
    public static final String JSP_PAYMENT_SIMULATION = "JSP_PAYMENT_SIMULATION";
    
    public static final int JSP_PAYMENT_SIMULATION_ID = 0;
    public static final int JSP_SALES_DATA_ID = 1;
    public static final int JSP_TYPE_PAYMENT = 2;
    public static final int JSP_NAME = 3;
    public static final int JSP_SALDO = 4;
    public static final int JSP_BUNGA = 5;
    public static final int JSP_AMOUNT = 6;
    public static final int JSP_TOTAL_AMOUNT = 7;
    public static final int JSP_DUE_DATE = 8;
    public static final int JSP_CUSTOMER_ID = 9;
    public static final int JSP_STATUS_GEN = 10;
    public static final int JSP_STATUS = 11;
    public static final int JSP_USER_ID = 12;
    public static final int JSP_PAYMENT = 13;
    
    public static final String[] colNames = {
        "jsp_payment_simulaton_id",
        "jsp_sales_data_id",
        "jsp_type_payment",
        "jsp_name",
        "jsp_saldo",
        "jsp_bunga",
        "jsp_amount",
        "jsp_total_amount",
        "jsp_due_date",
        "jsp_customer_id",
        "jsp_status_gen",
        "jsp_status",
        "jsp_user_id",
        "jsp_payment"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT
    };

    public JspPaymentSimulation() {
    }

    public JspPaymentSimulation(PaymentSimulation paymentSimulation) {
        this.paymentSimulation = paymentSimulation;
    }

    public JspPaymentSimulation(HttpServletRequest request, PaymentSimulation paymentSimulation) {
        super(new JspPaymentSimulation(paymentSimulation), request);
        this.paymentSimulation = paymentSimulation;
    }

    public String getFormName() {
        return JSP_PAYMENT_SIMULATION;
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

    public PaymentSimulation getEntityObject() {
        return paymentSimulation;
    }

    public void requestEntityObject(PaymentSimulation paymentSimulation) {
        try {
            this.requestParam();            
            
            paymentSimulation.setSalesDataId(getLong(JSP_SALES_DATA_ID));
            paymentSimulation.setName(getString(JSP_NAME));
            paymentSimulation.setSaldo(getDouble(JSP_SALDO));
            paymentSimulation.setBunga(getDouble(JSP_BUNGA));
            paymentSimulation.setAmount(getDouble(JSP_AMOUNT));
            paymentSimulation.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));            
            paymentSimulation.setDueDate(JSPFormater.formatDate(getString(JSP_DUE_DATE), "dd/MM/yyyy"));            
            paymentSimulation.setCustomerId(getLong(JSP_CUSTOMER_ID));            
            paymentSimulation.setStatusGen(getInt(JSP_STATUS_GEN));            
            paymentSimulation.setStatus(getInt(JSP_STATUS));           
            paymentSimulation.setUserId(getLong(JSP_USER_ID));          
            paymentSimulation.setPayment(getInt(JSP_PAYMENT));          
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}


