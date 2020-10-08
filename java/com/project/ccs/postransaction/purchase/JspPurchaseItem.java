package com.project.ccs.postransaction.purchase;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspPurchaseItem extends JSPHandler implements I_JSPInterface, I_JSPType {

    private PurchaseItem purchaseItem;
    public static final String JSP_NAME_PURCHASE_ITEM = "JSP_PURCHASE_ITEM";
    public static final int JSP_PURCHASE_ID = 0;
    public static final int JSP_ITEM_MASTER_ID = 1;
    public static final int JSP_QTY = 2;
    public static final int JSP_UOM_ID = 3;
    public static final int JSP_STATUS_ITEM = 4;
    public static final int JSP_AMOUNT = 5;
    public static final int JSP_TOTAL_AMOUNT = 6;
    public static final int JSP_TOTAL_DISCOUNT = 7;
    public static final int JSP_DELIVERY_DATE = 8;
    public static final int JSP_LAST_DIS_PERCENT = 9;
    public static final int JSP_REG_DIS_VAL = 10;
    public static final int JSP_REG_DIS_PERCENT = 11;
    
    public static String[] colNames = {
        "itm_JSP_PURCHASE_ID", "itm_JSP_ITEM_MASTER_ID",
        "itm_JSP_QTY", "itm_JSP_UOM_ID",
        "itm_JSP_STATUS_ITEM", "itm_JSP_AMOUNT",
        "itm_JSP_TOTAL_AMOUNT", "itm_JSP_TOTAL_DISCOUNT",
        "itm_JSP_DELIVERY_DATE", "itm_JSP_LAST_DIS_PERCENT",
        "itm_JSP_REG_DIS_VAL", "itm_JSP_REG_DIS_PERCENT"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_FLOAT + ENTRY_REQUIRED, TYPE_LONG,
        TYPE_STRING, TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_STRING, TYPE_FLOAT, TYPE_FLOAT, TYPE_FLOAT
    };

    public JspPurchaseItem() {
    }

    public JspPurchaseItem(PurchaseItem purchaseItem) {
        this.purchaseItem = purchaseItem;
    }

    public JspPurchaseItem(HttpServletRequest request, PurchaseItem purchaseItem) {
        super(new JspPurchaseItem(purchaseItem), request);
        this.purchaseItem = purchaseItem;
    }

    public String getFormName() {
        return JSP_NAME_PURCHASE_ITEM;
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

    public PurchaseItem getEntityObject() {
        return purchaseItem;
    }

    public void requestEntityObject(PurchaseItem purchaseItem) {
        try {
            this.requestParam();

            purchaseItem.setPurchaseId(getLong(JSP_PURCHASE_ID));
            purchaseItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            purchaseItem.setQty(getDouble(JSP_QTY));
            purchaseItem.setUomId(getLong(JSP_UOM_ID));
            //purchaseItem.setStatus(getString(JSP_STATUS));

            purchaseItem.setAmount(getDouble(JSP_AMOUNT));
            purchaseItem.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));
            purchaseItem.setTotalDiscount(getDouble(JSP_TOTAL_DISCOUNT));
            purchaseItem.setDeliveryDate(JSPFormater.formatDate(getString(JSP_DELIVERY_DATE), "dd/MM/yyyy"));
            purchaseItem.setLastDisPercent(getDouble(JSP_LAST_DIS_PERCENT));
            purchaseItem.setRegDisVal(getDouble(JSP_REG_DIS_VAL));
            purchaseItem.setRegDisPercent(getDouble(JSP_REG_DIS_PERCENT));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
