package com.project.ccs.postransaction.adjusment;

import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspAdjusmentItem extends JSPHandler implements I_JSPInterface, I_JSPType {

    private AdjusmentItem adjusmentItem;
    public static final String JSP_NAME_ADJUSMENTITEM = "JSP_NAME_ADJUSMENTITEM";
    public static final int JSP_ADJUSMENT_ITEM_ID = 0;
    public static final int JSP_ADJUSMENT_ID = 1;
    public static final int JSP_ITEM_MASTER_ID = 2;
    public static final int JSP_QTY_SYSTEM = 3;
    public static final int JSP_QTY_REAL = 4;
    public static final int JSP_PRICE = 5;
    public static final int JSP_AMOUNT = 6;
    public static final int JSP_TYPE = 7;
    public static final int JSP_QTY_BALANCE = 8;
    public static String[] colNames = {
        "JSP_ADJUSMENT_ITEM_ID", "JSP_ADJUSMENT_ID",
        "JSP_ITEM_MASTER_ID", "JSP_QTY_SYSTEM",
        "JSP_QTY_REAL", "JSP_PRICE",
        "JSP_AMOUNT","JSP_TYPE","QTY_BALANCE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_INT, TYPE_FLOAT
    };

    public JspAdjusmentItem() {
    }

    public JspAdjusmentItem(AdjusmentItem adjusmentItem) {
        this.adjusmentItem = adjusmentItem;
    }

    public JspAdjusmentItem(HttpServletRequest request, AdjusmentItem adjusmentItem) {
        super(new JspAdjusmentItem(adjusmentItem), request);
        this.adjusmentItem = adjusmentItem;
    }

    public String getFormName() {
        return JSP_NAME_ADJUSMENTITEM;
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

    public AdjusmentItem getEntityObject() {
        return adjusmentItem;
    }

    public void requestEntityObject(AdjusmentItem adjusmentItem) {
        try {
            this.requestParam();
            adjusmentItem.setAdjusmentId(getLong(JSP_ADJUSMENT_ID));
            adjusmentItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            adjusmentItem.setQtyReal(getDouble(JSP_QTY_REAL));
            adjusmentItem.setQtySystem(getDouble(JSP_QTY_SYSTEM));
            adjusmentItem.setPrice(getDouble(JSP_PRICE));
            adjusmentItem.setAmount(getDouble(JSP_AMOUNT));
            adjusmentItem.setQtyBalance(getDouble(JSP_QTY_BALANCE));
            adjusmentItem.setType(getInt(JSP_TYPE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
