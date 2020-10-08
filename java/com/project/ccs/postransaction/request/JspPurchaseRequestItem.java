package com.project.ccs.postransaction.request;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler; 
import javax.servlet.http.HttpServletRequest;

public class JspPurchaseRequestItem extends JSPHandler implements I_JSPInterface, I_JSPType {

    private PurchaseRequestItem purchaseRequestItem;
    
    public static final String JSP_NAME_PURCHASE_REQUEST_ITEM = "JSP_PURCHASE_REQUEST_ITEM";
    
    public static final int JSP_PURCHASE_REQUEST_ID = 0;
    public static final int JSP_ITEM_MASTER_ID = 1;
    public static final int JSP_QTY = 2;
    public static final int JSP_UOM_ID = 3;
    public static final int JSP_STATUS = 4;
    
    public static String[] colNames = {
        "JSP_PURCHASE_REQUEST_ID", "JSP_ITEM_MASTER_ID",
        "JSP_QTY", "JSP_UOM_ID",
        "JSP_ITEM_STATUS"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG,
        TYPE_FLOAT + ENTRY_REQUIRED, TYPE_LONG,
        TYPE_STRING
    };

    public JspPurchaseRequestItem() {
    }

    public JspPurchaseRequestItem(PurchaseRequestItem purchaseRequestItem) {
        this.purchaseRequestItem = purchaseRequestItem;
    }

    public JspPurchaseRequestItem(HttpServletRequest request, PurchaseRequestItem purchaseRequestItem) {
        super(new JspPurchaseRequestItem(purchaseRequestItem), request);
        this.purchaseRequestItem = purchaseRequestItem;
    }

    public String getFormName() {
        return JSP_NAME_PURCHASE_REQUEST_ITEM;
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

    public PurchaseRequestItem getEntityObject() {
        return purchaseRequestItem;
    }

    public void requestEntityObject(PurchaseRequestItem purchaseRequestItem) {
        try {
            this.requestParam();

            purchaseRequestItem.setPurchaseRequestId(getLong(JSP_PURCHASE_REQUEST_ID));
            purchaseRequestItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            purchaseRequestItem.setQty(getDouble(JSP_QTY));
            purchaseRequestItem.setUomId(getLong(JSP_UOM_ID));
            purchaseRequestItem.setStatus(getString(JSP_STATUS));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
