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
public class JspLotValue extends JSPHandler implements I_JSPInterface, I_JSPType {

    private LotValue lotValue;
    public static final String JSP_NAME_LOT_VALUE = "JSP_LOT_VALUE";
    public static final int JSP_LOT_VALUE_ID = 0;
    public static final int JSP_AMOUNT_HARD_CASH = 1;
    public static final int JSP_AMOUNT_CASH_BY_TERMIN = 2;
    public static final int JSP_AMOUNT_KPA = 3;
    public static final int JSP_LOT_TYPE = 4;
    public static final int JSP_LOT_QTY = 5;
    public static final int JSP_FLOOR_ID = 6;
    public static final int JSP_LOT_ID = 7;
    public static final int JSP_LOT_FROM = 8;
    public static final int JSP_LOT_TO = 9;
    public static final int JSP_RENTAL_RATE = 10;
    
    public static final String[] colNames = {
        "JSP_XLOT_VALUE_ID",
        "JSP_XAMOUNT_HARD_CASH",
        "JSP_XAMOUNT_CASH_BY_TERMIN",
        "JSP_XAMOUNT_KPA",
        "JSP_XLOT_TYPE",
        "JSP_XLOT_QTY",
        "JSP_XFLOOR_ID",
        "JSP_XLOT_ID",
        "JSP_XLOT_FROM",
        "JSP_XLOT_TO",
        "JSP_XRENTAL_RATE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT
    };

    public JspLotValue() {
    }

    public JspLotValue(LotValue lotValue) {
        this.lotValue = lotValue;
    }

    public JspLotValue(HttpServletRequest request, LotValue lotValue) {
        super(new JspLotValue(lotValue), request);
        this.lotValue = lotValue;
    }

    public String getFormName() {
        return JSP_NAME_LOT_VALUE;
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

    public LotValue getEntityObject() {
        return lotValue;
    }

    public void requestEntityObject(LotValue lotValue) {
        try {
            this.requestParam();
            lotValue.setAmountHardCash(getDouble(JSP_AMOUNT_HARD_CASH));
            lotValue.setAmountCashByTermin(getDouble(JSP_AMOUNT_CASH_BY_TERMIN));
            lotValue.setAmountKPA(getDouble(JSP_AMOUNT_KPA));
            lotValue.setLotType(getLong(JSP_LOT_TYPE));
            lotValue.setLotQty(getInt(JSP_LOT_QTY));
            lotValue.setFloorId(getLong(JSP_FLOOR_ID));
            lotValue.setLotId(getLong(JSP_LOT_ID));
            lotValue.setLotFrom(getInt(JSP_LOT_FROM));
            lotValue.setLotTo(getInt(JSP_LOT_TO));
            lotValue.setRentalRate(getDouble(JSP_RENTAL_RATE));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
