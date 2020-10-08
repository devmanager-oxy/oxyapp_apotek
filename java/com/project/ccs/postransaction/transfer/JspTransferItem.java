package com.project.ccs.postransaction.transfer;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspTransferItem extends JSPHandler implements I_JSPInterface, I_JSPType {

    private TransferItem transferItem;
    public static final String JSP_NAME_TRANSFERITEM = "JSP_NAME_TRANSFERITEM";
    public static final int JSP_TRANSFER_ID = 0;
    public static final int JSP_ITEM_MASTER_ID = 1;
    public static final int JSP_QTY = 2;
    public static final int JSP_PRICE = 3;
    public static final int JSP_AMOUNT = 4;
    public static final int JSP_ITEM_NOTE = 5;
    public static final int JSP_EXP_DATE = 6;
    public static final int JSP_TYPE = 7;
    public static final int JSP_ITEM_BARCODE = 8;
    public static final int JSP_QTY_STOCK = 9;
    
    public static String[] colNames = {
        "JSP_TRANSFER_ID",
        "JSP_ITEM_MASTER_ID", "JSP_QTY",
        "JSP_PRICE", "JSP_AMOUNT",
        "JSP_ITEM_NOTE", "JSP_EXP_DATE","JSP_TYPE",
        "JSP_ITEM_BARCODE","JSP_QTY_STOCK"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_STRING, TYPE_STRING, TYPE_INT, TYPE_STRING, TYPE_FLOAT
    };

    public JspTransferItem() {
    }

    public JspTransferItem(TransferItem transferItem) {
        this.transferItem = transferItem;
    }

    public JspTransferItem(HttpServletRequest request, TransferItem transferItem) {
        super(new JspTransferItem(transferItem), request);
        this.transferItem = transferItem;
    }

    public String getFormName() {
        return JSP_NAME_TRANSFERITEM;
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

    public TransferItem getEntityObject() {
        return transferItem;
    }
 
    public void requestEntityObject(TransferItem transferItem){
        try {
            this.requestParam();  

            // transferItem.setTransferId(getLong(JSP_TRANSFER_ID));
            transferItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            transferItem.setQty(getDouble(JSP_QTY));
            transferItem.setPrice(getDouble(JSP_PRICE));
            transferItem.setAmount(getDouble(JSP_AMOUNT));
            transferItem.setType(getInt(JSP_TYPE));
            transferItem.setItemBarcode(getString(JSP_ITEM_BARCODE));
            transferItem.setQtyStock(getDouble(JSP_QTY_STOCK));
            // transferItem.setNote(getString(JSP_ITEM_NOTE));
            //transferItem.setExpDate(getDate(JSP_EXP_DATE));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
