package com.project.ccs.postransaction.receiving;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspReceiveItem extends JSPHandler implements I_JSPInterface, I_JSPType {

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
    public static final int JSP_TYPE = 12;
    public static final int JSP_IS_BONUS = 13;
    public static final int JSP_MEMO = 14;
    public static final int JSP_PRICE_IMPORT = 15;
    public static final int JSP_TRANSPORT = 16;
    public static final int JSP_BEA = 17;
    public static final int JSP_KOMISI = 18;
    public static final int JSP_LAIN_LAIN = 19;
    public static final int JSP_UOM_PURCHASE_ID = 20;
    public static final int JSP_QTY_PURCHASE = 21;
    public static final int JSP_DIS_1_VAL = 22;
    public static final int JSP_DIS_2_VAL = 23;
    public static final int JSP_DIS_1_PERCENT = 24;
    public static final int JSP_DIS_2_PERCENT = 25;
    public static final int JSP_DIS_3_VAL = 26;
    public static final int JSP_DIS_4_VAL = 27;
    public static final int JSP_DIS_3_PERCENT = 28;
    public static final int JSP_DIS_4_PERCENT = 29;
    public static final int JSP_BACTH_NUMBER = 30;
    
    public static String[] colNames = {
        "itm_JSP_RECEIVE_ID", "itm_JSP_ITEM_MASTER_ID",
        "itm_JSP_QTY", "itm_JSP_UOM_ID",
        "itm_JSP_STATUS_ITEM", "itm_JSP_AMOUNT",
        "itm_JSP_TOTAL_AMOUNT", "itm_JSP_TOTAL_DISCOUNT",
        "itm_JSP_DELIVERY_DATE",        
        "ITM_JSP_PURCHASE_ITEM_ID", "ITM_JSP_EXPIRED_DATE",
        "JSP_AP_COA_ID","ITM_JSP_TYPE",
        "JSP_IS_BONUS","JSP_MEMO","JSP_PRICE_IMPORT",
        "JSP_TRANSPORT","JSP_BEA","JSP_KOMISI",
        "JSP_LAIN_LAIN",
        "JSP_UOM_PURCHASE_ID", "JSP_QTY_PURCHASE",
        "JSP_DIS_1_VAL", "JSP_DIS_2_VAL",
        "JSP_DIS_1_PERCENT", "JSP_DIS_2_PERCENT",
        "JSP_DIS_3_VAL", "JSP_DIS_4_VAL",
        "JSP_DIS_3_PERCENT", "JSP_DIS_4_PERCENT",
        "JSP_BATCH_NUMBER"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED,
        TYPE_FLOAT + ENTRY_REQUIRED, TYPE_LONG,
        TYPE_STRING, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_STRING, TYPE_LONG, 
        TYPE_STRING, TYPE_LONG, TYPE_INT,
        TYPE_INT,TYPE_STRING,
        TYPE_FLOAT,TYPE_FLOAT,
        TYPE_FLOAT,TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_STRING
    };

    public JspReceiveItem() {
    }

    public JspReceiveItem(ReceiveItem receiveItem) {
        this.receiveItem = receiveItem;
    }

    public JspReceiveItem(HttpServletRequest request, ReceiveItem receiveItem) {
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

            receiveItem.setReceiveId(getLong(JSP_RECEIVE_ID));
            receiveItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            receiveItem.setQty(getDouble(JSP_QTY));
            receiveItem.setUomId(getLong(JSP_UOM_ID));
            receiveItem.setAmount(getDouble(JSP_AMOUNT));
            receiveItem.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));
            receiveItem.setTotalDiscount(getDouble(JSP_TOTAL_DISCOUNT));
            receiveItem.setDeliveryDate(JSPFormater.formatDate(getString(JSP_DELIVERY_DATE), "dd/MM/yyyy"));            
            receiveItem.setPurchaseItemId(getLong(JSP_PURCHASE_ITEM_ID));
            receiveItem.setExpiredDate(JSPFormater.formatDate(getString(JSP_EXPIRED_DATE), "dd/MM/yyyy"));
            receiveItem.setApCoaId(getLong(JSP_AP_COA_ID));
            receiveItem.setType(getInt(JSP_TYPE));
            receiveItem.setIsBonus(getInt(JSP_IS_BONUS));
            receiveItem.setMemo(getString(JSP_MEMO));
            receiveItem.setPriceImport(getDouble(JSP_PRICE_IMPORT));
            receiveItem.setTransport(getDouble(JSP_TRANSPORT));
            receiveItem.setBea(getDouble(JSP_BEA));
            receiveItem.setKomisi(getDouble(JSP_KOMISI));
            receiveItem.setLainLain(getDouble(JSP_LAIN_LAIN));
            receiveItem.setUomPurchaseId(getLong(JSP_UOM_PURCHASE_ID));
            receiveItem.setQtyPurchase(getDouble(JSP_QTY_PURCHASE));
            receiveItem.setDis1Percent(getDouble(JSP_DIS_1_PERCENT));
            receiveItem.setDis1Val(getDouble(JSP_DIS_1_VAL));
            receiveItem.setDis2Percent(getDouble(JSP_DIS_2_PERCENT));
            receiveItem.setDis2Val(getDouble(JSP_DIS_2_VAL));
            receiveItem.setDis3Percent(getDouble(JSP_DIS_3_PERCENT));
            receiveItem.setDis3Val(getDouble(JSP_DIS_3_VAL));
            receiveItem.setDis4Percent(getDouble(JSP_DIS_4_PERCENT));
            receiveItem.setDis4Val(getDouble(JSP_DIS_4_VAL));
            receiveItem.setBatchNumber(getString(JSP_BACTH_NUMBER));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}

