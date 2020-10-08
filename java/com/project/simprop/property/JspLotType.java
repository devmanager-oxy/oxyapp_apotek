/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy Andika
 */
public class JspLotType extends JSPHandler implements I_JSPInterface, I_JSPType {

    private LotType lotType;
    public static final String JSP_NAME_LOT_TYPE = "JSP_LOT_TYPE";
    public static final int JSP_LOT_TYPE_ID = 0;
    public static final int JSP_AMOUNT_HARD_CASH = 1;
    public static final int JSP_AMOUNT_CASH_BY_TERMIN = 2;
    public static final int JSP_AMOUNT_KPA = 3;
    public static final int JSP_LOT_TYPE = 4;
    public static final int JSP_RENTAL_RATE = 5;
    public static final int JSP_SALES_TYPE = 6;
    public static final int JSP_NAME_PIC = 7;
    
    public static final String[] colNames = {
        "JSP_LOT_TYPE_ID",
        "JSP_AMOUNT_HARD_CASH",
        "JSP_AMOUNT_CASH_BY_TERMIN",
        "JSP_AMOUNT_KPR",
        "JSP_LOT_TYPE",
        "JSP_RENTAL_RATE",
        "JSP_SALES_TYPE",
        "JSP_NAME_PIC"
        
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_STRING
    };

    public JspLotType() {
    }

    public JspLotType(LotType lotType) {
        this.lotType = lotType;
    }

    public JspLotType(HttpServletRequest request, LotType lotType) {
        super(new JspLotType(lotType), request);
        this.lotType = lotType;
    }

    public String getFormName() {
        return JSP_NAME_LOT_TYPE;
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

    public LotType getEntityObject() {
        return lotType;
    }

    public void requestEntityObject(LotType lotType) {
        try {
            this.requestParam();

            lotType.setAmountHardCash(getDouble(JSP_AMOUNT_HARD_CASH));
            lotType.setAmountCashByTermin(getDouble(JSP_AMOUNT_CASH_BY_TERMIN));
            lotType.setAmountKPA(getDouble(JSP_AMOUNT_KPA));
            lotType.setLotType(getString(JSP_LOT_TYPE));            
            lotType.setRentalRate(getDouble(JSP_RENTAL_RATE));
            lotType.setSalesType(getInt(JSP_SALES_TYPE));
            lotType.setNamePic(getString(JSP_NAME_PIC));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
