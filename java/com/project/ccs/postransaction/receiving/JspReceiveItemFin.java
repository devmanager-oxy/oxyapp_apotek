package com.project.ccs.postransaction.receiving;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspReceiveItemFin extends JSPHandler implements I_JSPInterface, I_JSPType {

    private ReceiveItem receiveItem;
    
    public static final String JSP_NAME_RECEIVE_ITEM = "JSP_RECEIVE_ITEM";
    
    public static final int JSP_RECEIVE_ID = 0;
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
    public static final int JSP_AP_COA_ID = 11;
    
    public static String[] colNames = {
        "itm_JSP_RECEIVE_ID", "itm_JSP_ITEM_MASTER_ID",
        "itm_JSP_QTY", "itm_JSP_UOM_ID",
        "itm_JSP_STATUS_ITEM", "itm_JSP_AMOUNT",
        "itm_JSP_TOTAL_AMOUNT", "itm_JSP_TOTAL_DISCOUNT",
        "itm_JSP_DELIVERY_DATE",
        
        "ITM_JSP_PURCHASE_ITEM_ID", "ITM_JSP_EXPIRED_DATE",
        "JSP_AP_COA_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_FLOAT + ENTRY_REQUIRED, TYPE_LONG,
        TYPE_STRING, TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_STRING,
        
        TYPE_LONG, TYPE_STRING,
        TYPE_LONG
    };

    public JspReceiveItemFin() {
    }

    public JspReceiveItemFin(ReceiveItem receiveItem) {
        this.receiveItem = receiveItem;
    }

    public JspReceiveItemFin(HttpServletRequest request, ReceiveItem receiveItem) {
        super(new JspReceiveItem(receiveItem), request);
        this.receiveItem = receiveItem;
    }

    public String getFormName() {
        return JSP_NAME_RECEIVE_ITEM;
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

    public ReceiveItem getEntityObject() {
        return receiveItem;
    }

    public void requestEntityObject(ReceiveItem receiveItem) {
        try {
            this.requestParam();

            /*receiveItem.setReceiveId(getLong(JSP_RECEIVE_ID));
            receiveItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            receiveItem.setQty(getDouble(JSP_QTY));
            receiveItem.setUomId(getLong(JSP_UOM_ID));
            //receiveItem.setStatus(getString(JSP_STATUS));

            receiveItem.setAmount(getDouble(JSP_AMOUNT));
            receiveItem.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));
            receiveItem.setTotalDiscount(getDouble(JSP_TOTAL_DISCOUNT));
            receiveItem.setDeliveryDate(JSPFormater.formatDate(getString(JSP_DELIVERY_DATE), "dd/MM/yyyy"));
            
            receiveItem.setPurchaseItemId(getLong(JSP_PURCHASE_ITEM_ID));
            receiveItem.setExpiredDate(JSPFormater.formatDate(getString(JSP_EXPIRED_DATE), "dd/MM/yyyy"));
             */
            receiveItem.setApCoaId(getLong(JSP_AP_COA_ID));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
