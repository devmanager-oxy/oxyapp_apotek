/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.ga;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;

/**
 *
 * @author Roy
 */
public class JspGeneralAffairDetail extends JSPHandler implements I_JSPInterface, I_JSPType {

    private GeneralAffairDetail generalAffairDetail;
    
    public static final String JSP_NAME_GENERALAFFAIRDETAIL = "JSP_NAME_GENERALAFFAIRDETAIL";
    
    public static final int JSP_GENERAL_AFFAIR_DETAIL_ID = 0;
    public static final int JSP_GENERAL_AFFAIR_ID = 1;
    public static final int JSP_ITEM_MASTER_ID = 2;
    public static final int JSP_QTY = 3;
    public static final int JSP_PRICE = 4;
    public static final int JSP_AMOUNT = 5;
    
    public static String[] colNames = {
        "JSP_GENERAL_AFFAIR_DETAIL_ID", 
        "JSP_GENERAL_AFFAIR_ID",
        "JSP_ITEM_MASTER_ID", "JSP_QTY",
        "JSP_PRICE", "JSP_AMOUNT"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_FLOAT, TYPE_FLOAT
    };

    public JspGeneralAffairDetail() {
    }

    public JspGeneralAffairDetail(GeneralAffairDetail generalAffairDetail) {
        this.generalAffairDetail = generalAffairDetail;
    }

    public JspGeneralAffairDetail(HttpServletRequest request, GeneralAffairDetail generalAffairDetail) {
        super(new JspGeneralAffairDetail(generalAffairDetail), request);
        this.generalAffairDetail = generalAffairDetail;
    }

    public String getFormName() {
        return JSP_NAME_GENERALAFFAIRDETAIL;
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

    public GeneralAffairDetail getEntityObject() {
        return generalAffairDetail;
    }

    public void requestEntityObject(GeneralAffairDetail generalAffairDetail) {
        try {
            this.requestParam();
            generalAffairDetail.setGeneralAffairId(getLong(JSP_GENERAL_AFFAIR_ID));
            generalAffairDetail.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            generalAffairDetail.setQty(getDouble(JSP_QTY));
            generalAffairDetail.setPrice(getDouble(JSP_PRICE));
            generalAffairDetail.setAmount(getDouble(JSP_AMOUNT));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
