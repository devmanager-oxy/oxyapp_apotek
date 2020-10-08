package com.project.ccs.postransaction.transfer;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspFakturPajakDetail extends JSPHandler implements I_JSPInterface, I_JSPType {

    private FakturPajakDetail fakturDetail;
    
    public static final String JSP_NAME_TRANSFERITEM = "JSP_NAME_FAKTUR_PAJAK_DETAIL";
    
    public static final int JSP_FAKTUR_PAJAK_DETAIL_ID  = 0;
    public static final int JSP_FAKTUR_PAJAK_ID         = 1;
    public static final int JSP_ITEM_MASTER_ID          = 2;
    public static final int JSP_ITEM_NAME               = 3;
    public static final int JSP_TOTAL                   = 4;
    public static final int JSP_DISCOUNT                = 5;
    public static final int JSP_QTY                     = 6;
    public static final int JSP_TRANSFER_ID             = 7;
    public static final int JSP_SALES_ID                = 8;
    public static final int JSP_DATE                    = 9;
    public static final int JSP_COUNTER                 = 10;
    
    public static String[] colNames = {
        "JSP_FAKTUR_PAJAK_DETAIL_ID",
        "JSP_FAKTUR_PAJAK_ID", 
        "JSP_ITEM_MASTER_ID",
        "JSP_ITEM_NAME",
        "JSP_TOTAL",
        "JSP_DISCOUNT",
        "JSP_QTY",
        "JSP_TRANSFER_ID",
        "JSP_SALES_ID",
        "JSP_DATE",
        "JSP_COUNTER"
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_FLOAT + ENTRY_REQUIRED,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_INT
    };

    public JspFakturPajakDetail() {
    }

    public JspFakturPajakDetail(FakturPajakDetail fakturDetail) {
        this.fakturDetail = fakturDetail;
    }

    public JspFakturPajakDetail(HttpServletRequest request, FakturPajakDetail fakturDetail) {
        super(new JspFakturPajakDetail(fakturDetail), request);
        this.fakturDetail = fakturDetail;
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

    public FakturPajakDetail getEntityObject() {
        return fakturDetail;
    }
 
    public void requestEntityObject(FakturPajakDetail fakturDetail) {
        try {            
            this.requestParam();              
            fakturDetail.setFakturPajakId(getLong(JSP_FAKTUR_PAJAK_ID));
            fakturDetail.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
            fakturDetail.setItemName(getString(JSP_ITEM_NAME));
            fakturDetail.setTotal(getDouble(JSP_TOTAL));
            fakturDetail.setDiscount(getDouble(JSP_DISCOUNT));
            fakturDetail.setQty(getDouble(JSP_QTY));
            fakturDetail.setTransferId(getLong(JSP_TRANSFER_ID));
            fakturDetail.setSalesId(getLong(JSP_SALES_ID));
            fakturDetail.setDate(getDate(JSP_DATE));
            fakturDetail.setCounter(getInt(JSP_COUNTER));

        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
