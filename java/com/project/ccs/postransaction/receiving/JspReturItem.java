package com.project.ccs.postransaction.receiving;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspReturItem extends JSPHandler implements I_JSPInterface, I_JSPType {

    private ReturItem returItem;
    
    public static final String JSP_NAME_RETUR_ITEM = "JSP_RETUR_ITEM";
    
    public static final int JSP_RETUR_ID = 0;
    public static final int JSP_ITEM_MASTER_ID = 1;
    public static final int JSP_QTY = 2;
    public static final int JSP_UOM_ID = 3;
    public static final int JSP_STATUS_ITEM = 4;
    public static final int JSP_AMOUNT = 5;
    public static final int JSP_TOTAL_AMOUNT = 6;
    public static final int JSP_TOTAL_DISCOUNT = 7;
    public static final int JSP_DELIVERY_DATE = 8;    
    public static final int JSP_PURCHASE_ITEM_ID = 9;
    public static final int JSP_EXPIRED_DATE = 10;
    public static final int JSP_RECEIVE_ITEM_ID = 11;
    
    public static String[] colNames = {
        "itm_JSP_RETUR_ID", 
        "itm_JSP_ITEM_MASTER_ID",
        "itm_JSP_QTY", 
        "itm_JSP_UOM_ID",
        "itm_JSP_STATUS_ITEM", 
        "itm_JSP_AMOUNT",
        "itm_JSP_TOTAL_AMOUNT", 
        "itm_JSP_TOTAL_DISCOUNT",
        "itm_JSP_DELIVERY_DATE",        
        "ITM_JSP_PURCHASE_ITEM_ID", 
        "ITM_JSP_EXPIRED_DATE",
        "JSP_RECEIVE_ITEM_ID"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, 
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_FLOAT + ENTRY_REQUIRED, 
        TYPE_LONG,
        TYPE_STRING, 
        TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_FLOAT, 
        TYPE_FLOAT,
        TYPE_STRING,        
        TYPE_LONG, 
        TYPE_STRING,
        TYPE_LONG
    };

    public JspReturItem() {
    }

    public JspReturItem(ReturItem returItem) {
        this.returItem = returItem;
    }

    public JspReturItem(HttpServletRequest request, ReturItem returItem) {
        super(new JspReturItem(returItem), request);
        this.returItem = returItem;
    }

    public String getFormName() {
        return JSP_NAME_RETUR_ITEM;
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

    public ReturItem getEntityObject() {
        return returItem;
    }

    public void requestEntityObject(ReturItem returItem) {
        try {
            this.requestParam();

            returItem.setReturId(getLong(JSP_RETUR_ID));
            returItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            returItem.setQty(getDouble(JSP_QTY));
            returItem.setUomId(getLong(JSP_UOM_ID));
            returItem.setAmount(getDouble(JSP_AMOUNT));
            returItem.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));
            returItem.setTotalDiscount(getDouble(JSP_TOTAL_DISCOUNT));
            returItem.setDeliveryDate(JSPFormater.formatDate(getString(JSP_DELIVERY_DATE), "dd/MM/yyyy"));
            returItem.setPurchaseItemId(getLong(JSP_PURCHASE_ITEM_ID));
            returItem.setExpiredDate(JSPFormater.formatDate(getString(JSP_EXPIRED_DATE), "dd/MM/yyyy"));
            returItem.setReceiveItemId(getLong(JSP_RECEIVE_ITEM_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
