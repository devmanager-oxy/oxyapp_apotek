package com.project.ccs.postransaction.opname;

import javax.servlet.http.*;
import com.project.util.jsp.*;
import java.util.Date;
import com.project.util.JSPFormater;

public class JspOpnameItem extends JSPHandler implements I_JSPInterface, I_JSPType {

    private OpnameItem opnameItem; 
    public static final String JSP_NAME_OPNAMEITEM = "JSP_NAME_OPNAMEITEM";
    public static final int JSP_OPNAME_ITEM_ID = 0;
    public static final int JSP_OPNAME_ID = 1;
    public static final int JSP_ITEM_MASTER_ID = 2;
    public static final int JSP_QTY_SYSTEM = 3;
    public static final int JSP_QTY_REAL = 4;
    public static final int JSP_PRICE = 5;
    public static final int JSP_AMOUNT = 6;
    public static final int JSP_NOTE = 7;
    public static final int JSP_TYPE = 8;
    public static final int JSP_DATE = 9;

    public static String[] colNames = {
        "JSP_OPNAME_ITEM_ID", "JSP_OPNAME_ID",
        "JSP_ITEM_MASTER_ID", "JSP_QTY_SYSTEM",
        "JSP_QTY_REAL","JSP_PRICE",
        "JSP_AMOUNT", "JSP_NOTE", "JSP_TYPE", "JSP_DATE"
    };

    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_STRING, TYPE_INT, TYPE_STRING
    };

    public JspOpnameItem() {
    }

    public JspOpnameItem(OpnameItem opnameItem) {
        this.opnameItem = opnameItem;
    }

    public JspOpnameItem(HttpServletRequest request, OpnameItem opnameItem) {
        super(new JspOpnameItem(opnameItem), request);
        this.opnameItem = opnameItem;
    }

    public String getFormName() {
        return JSP_NAME_OPNAMEITEM;
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

    public OpnameItem getEntityObject() {
        return opnameItem;
    }

    public void requestEntityObject(OpnameItem opnameItem) {
        try {
            this.requestParam();
            Date newDate = new Date();
            newDate= JSPFormater.formatDate(getString(JSP_DATE), "dd/MM/yyyy");
            newDate.setHours(new Date().getHours());
            newDate.setMinutes(new Date().getMinutes());
            newDate.setSeconds(new Date().getSeconds());
            opnameItem.setDate(newDate);
            opnameItem.setOpnameId(getLong(JSP_OPNAME_ID));
            opnameItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            opnameItem.setQtyReal(getDouble(JSP_QTY_REAL));
            opnameItem.setQtySystem(getDouble(JSP_QTY_SYSTEM));
            opnameItem.setPrice(getDouble(JSP_PRICE));
            opnameItem.setAmount(getDouble(JSP_AMOUNT));
            opnameItem.setNote(getString(JSP_NOTE));
            opnameItem.setType(getInt(JSP_TYPE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
