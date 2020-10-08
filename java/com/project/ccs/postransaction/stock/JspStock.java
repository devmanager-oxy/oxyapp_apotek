
package com.project.ccs.postransaction.stock;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspStock extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Stock stock;

	public static final String JSP_NAME_STOCK		=  "JSP_NAME_STOCK" ;

	public static final int JSP_STOCK_ID			=  0 ;
	public static final int JSP_LOCATION_ID			=  1 ;
	public static final int JSP_TYPE			=  2 ;
	public static final int JSP_QTY			=  3 ;
	public static final int JSP_PRICE			=  4 ;
	public static final int JSP_TOTAL			=  5 ;
	public static final int JSP_ITEM_MASTER_ID			=  6 ;
	public static final int JSP_ITEM_CODE			=  7 ;
	public static final int JSP_ITEM_BARCODE			=  8 ;
	public static final int JSP_ITEM_NAME			=  9 ;
	public static final int JSP_UNIT_ID			=  10 ;
	public static final int JSP_UNIT			=  11 ;
	public static final int JSP_IN_OUT			=  12 ;
	public static final int JSP_DATE			=  13 ;
	public static final int JSP_USER_ID			=  14 ;
	public static final int JSP_NO_FAKTUR			=  15 ;
	public static final int JSP_INCOMING_ID			=  16 ;
	public static final int JSP_RETUR_ID			=  17 ;
	public static final int JSP_TRANSFER_ID			=  18 ;
	public static final int JSP_TRANSFER_IN_ID			=  19 ;
	public static final int JSP_ADJUSTMENT_ID			=  20 ;
        public static final int JSP_TYPE_ITEM			=  21 ;
        public static final int JSP_RECEIVE_ITEM_ID		=  22 ;
        public static final int JSP_RETUR_ITEM_ID		=  23 ;
        public static final int JSP_TRANSFER_ITEM_ID		=  24 ;
        public static final int JSP_ADJUSTMENT_ITEM_ID		=  25 ;
        
	public static String[] colNames = {
		"JSP_STOCK_ID",  "JSP_LOCATION_ID",
		"JSP_TYPE",  "JSP_QTY",
		"JSP_PRICE",  "JSP_TOTAL",
		"JSP_ITEM_MASTER_ID",  "JSP_ITEM_CODE",
		"JSP_ITEM_BARCODE",  "JSP_ITEM_NAME",
		"JSP_UNIT_ID",  "JSP_UNIT",
		"JSP_IN_OUT",  "JSP_DATE",
		"JSP_USER_ID",  "JSP_NO_FAKTUR",
		"JSP_INCOMING_ID",  "JSP_RETUR_ID",
		"JSP_TRANSFER_ID",  "JSP_TRANSFER_IN_ID",
		"JSP_ADJUSTMENT_ID","JSP_TYPE_ITEM", "JSP_RECEIVE_ITEM_ID",
                "JSP_RETUR_ITEM_ID","JSP_TRANSFER_ITEM_ID",
                "JSP_ADJUSTMENT_ITEM_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_INT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_LONG,  TYPE_STRING,
		TYPE_INT,  TYPE_DATE,
		TYPE_LONG,  TYPE_STRING,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG, TYPE_INT,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG
	} ;

	public JspStock(){
	}
	public JspStock(Stock stock){
		this.stock = stock;
	}

	public JspStock(HttpServletRequest request, Stock stock){
		super(new JspStock(stock), request);
		this.stock = stock;
	}

	public String getFormName() { return JSP_NAME_STOCK; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Stock getEntityObject(){ return stock; }

	public void requestEntityObject(Stock stock) {
		try{
			this.requestParam();
			stock.setLocationId(getLong(JSP_LOCATION_ID));
			stock.setType(getInt(JSP_TYPE));
			stock.setQty(getDouble(JSP_QTY));
			stock.setPrice(getDouble(JSP_PRICE));
			stock.setTotal(getDouble(JSP_TOTAL));
			stock.setItemMasterId(getLong(JSP_ITEM_MASTER_ID));
			stock.setItemCode(getString(JSP_ITEM_CODE));
			stock.setItemBarcode(getString(JSP_ITEM_BARCODE));
			stock.setItemName(getString(JSP_ITEM_NAME));
			stock.setUnitId(getLong(JSP_UNIT_ID));
			stock.setUnit(getString(JSP_UNIT));
			stock.setInOut(getInt(JSP_IN_OUT));
			stock.setDate(getDate(JSP_DATE));
			stock.setUserId(getLong(JSP_USER_ID));
			stock.setNoFaktur(getString(JSP_NO_FAKTUR));
			stock.setIncomingId(getLong(JSP_INCOMING_ID));
			stock.setReturId(getLong(JSP_RETUR_ID));
			stock.setTransferId(getLong(JSP_TRANSFER_ID));
			stock.setTransferInId(getLong(JSP_TRANSFER_IN_ID));
			stock.setAdjustmentId(getLong(JSP_ADJUSTMENT_ID));
                        stock.setType_item(getInt(JSP_TYPE_ITEM));
                        stock.setReceive_item_id(getLong(JSP_RECEIVE_ITEM_ID));
                        stock.setRetur_item_id(getLong(JSP_RETUR_ITEM_ID));
                        stock.setTransfer_item_id(getLong(JSP_TRANSFER_ITEM_ID));
                        stock.setAdjustment_item_id(getLong(JSP_ADJUSTMENT_ITEM_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
