package com.project.ccs.posmaster;

import javax.servlet.http.*;
import com.project.util.jsp.*;

public class JspVendorItem extends JSPHandler implements I_JSPInterface, I_JSPType {

    private VendorItem vendorItem;
    public static final String JSP_NAME_VENDORITEM = "JSP_NAME_VENDORITEM";
    public static final int JSP_VENDOR_ITEM_ID = 0;
    public static final int JSP_ITEM_MASTER_ID = 1;
    public static final int JSP_VENDOR_ID = 2;
    public static final int JSP_LAST_PRICE = 3;
    public static final int JSP_LAST_DISCOUNT = 4;
    public static final int JSP_UPDATE_DATE = 5;
    public static final int JSP_LAST_DIS_VAL = 6;
    public static final int JSP_REG_DIS_VAL = 7;
    public static final int JSP_REG_DIS_PERCENT = 8;

    public static final int JSP_REAL_PRICE = 9;
    public static final int JSP_MARGIN_PRICE = 10;

    public static final int JSP_ITEM_VENDOR_CODE = 11;
    public static final int JSP_UOM_PURCHASE = 12;
    public static final int JSP_DELIVERY_UNIT = 13;
    public static final int JSP_CONV_QTY = 14;

    public static String[] colNames = {
        "JSP_VENDOR_ITEM_ID", "JSP_ITEM_MASTER_ID",
        "JSP_VENDOR_ID", "JSP_LAST_PRICE",
        "JSP_LAST_DISCOUNT", "JSP_UPDATE_DATE",
        "JSP_LAST_DIS_PERCENT", "JSP_REG_DIS_VAL",
        "JSP_REG_DIS_PERCENT","JSP_REAL_PRICE",
        "JSP_MARGIN_PRICE",
        "JSP_ITEM_VENDOR_CODE", "JSP_UOM_PURCHASE",
        "JSP_DELIVERY_UNIT", "JSP_CONV_QTY"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_DATE, 
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING, TYPE_LONG,
        TYPE_INT ,TYPE_FLOAT
    };

    public JspVendorItem() {
    }

    public JspVendorItem(VendorItem vendorItem) {
        this.vendorItem = vendorItem;
    }

    public JspVendorItem(HttpServletRequest request, VendorItem vendorItem) {
        super(new JspVendorItem(vendorItem), request);
        this.vendorItem = vendorItem;
    }

    public String getFormName() {
        return JSP_NAME_VENDORITEM;
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

    public VendorItem getEntityObject() {
        return vendorItem;
    }

    public void requestEntityObject(VendorItem vendorItem) {
        try {
            this.requestParam();
            vendorItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            vendorItem.setVendorId(getLong(JSP_VENDOR_ID));
            vendorItem.setLastPrice(getDouble(JSP_LAST_PRICE));
            vendorItem.setLastDiscount(getDouble(JSP_LAST_DISCOUNT));
            vendorItem.setUpdateDate(getDate(JSP_UPDATE_DATE));
            vendorItem.setLastDisVal(getDouble(JSP_LAST_DIS_VAL));
            vendorItem.setRegDisValue(getDouble(JSP_REG_DIS_VAL));
            vendorItem.setRegDisPercent(getDouble(JSP_REG_DIS_PERCENT));

            vendorItem.setRealPrice(getDouble(JSP_REAL_PRICE));
            vendorItem.setMarginPrice(getDouble(JSP_MARGIN_PRICE));

            vendorItem.setItemVendorCode(getString(JSP_ITEM_VENDOR_CODE));
            vendorItem.setUomPurchase(getLong(JSP_UOM_PURCHASE));
            vendorItem.setDeliveryUnit(getInt(JSP_DELIVERY_UNIT));
            vendorItem.setConvQty(getDouble(JSP_CONV_QTY));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
