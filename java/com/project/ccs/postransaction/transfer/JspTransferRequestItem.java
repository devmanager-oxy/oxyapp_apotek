/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.transfer;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Roy Andika
 */
public class JspTransferRequestItem extends JSPHandler implements I_JSPInterface, I_JSPType {

    private TransferRequestItem transferRequestItem;
    
    public static final String JSP_NAME_TRANSFERREQUESTITEM = "JSP_NAME_TRANSFER_REQUEST_ITEM";
    
    public static final int JSP_TRANSFER_REQUEST_ID = 0;
    public static final int JSP_ITEM_MASTER_ID = 1;
    public static final int JSP_QTY = 2;
    public static final int JSP_ITEM_BARCODE = 3;
    
    public static String[] colNames = {
        "JSP_TRANSFER_REQUEST_ID",
        "JSP_ITEM_MASTER_ID", 
        "JSP_QTY",
        "JSP_ITEM_BARCODE"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED, 
        TYPE_FLOAT,
        TYPE_STRING
    };

    public JspTransferRequestItem() {
    }

    public JspTransferRequestItem(TransferRequestItem transferRequestItem) {
        this.transferRequestItem = transferRequestItem;
    }

    public JspTransferRequestItem(HttpServletRequest request, TransferRequestItem transferRequestItem) {
        super(new JspTransferRequestItem(transferRequestItem), request);
        this.transferRequestItem = transferRequestItem;
    }

    public String getFormName() {
        return JSP_NAME_TRANSFERREQUESTITEM;
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

    public TransferRequestItem getEntityObject() {
        return transferRequestItem;
    }

    public void requestEntityObject(TransferRequestItem transferRequestItem) {
        try {
            this.requestParam();
            transferRequestItem.setTransferRequestId(getLong(JSP_TRANSFER_REQUEST_ID));
            transferRequestItem.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            transferRequestItem.setQty(getDouble(JSP_QTY));            
            transferRequestItem.setItemBarcode(getString(JSP_ITEM_BARCODE));            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
