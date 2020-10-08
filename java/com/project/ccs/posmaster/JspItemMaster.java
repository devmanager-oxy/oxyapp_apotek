package com.project.ccs.posmaster;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.util.JSPFormater;

public class JspItemMaster extends JSPHandler implements I_JSPInterface, I_JSPType {

    private ItemMaster itemMaster;
    public static final String JSP_NAME_ITEMMASTER = "JSP_NAME_ITEMMASTER";
    public static final int JSP_ITEM_MASTER_ID = 0;
    public static final int JSP_ITEM_GROUP_ID = 1;
    public static final int JSP_ITEM_CATEGORY_ID = 2;    
    public static final int JSP_UOM_PURCHASE_ID = 3;
    public static final int JSP_UOM_RECIPE_ID = 4;
    public static final int JSP_UOM_STOCK_ID = 5;
    public static final int JSP_UOM_SALES_ID = 6;
    public static final int JSP_CODE = 7;
    public static final int JSP_BARCODE = 8;
    public static final int JSP_NAME = 9;
    public static final int JSP_UOM_PURCHASE_STOCK_QTY = 10;
    public static final int JSP_UOM_STOCK_RECIPE_QTY = 11;
    public static final int JSP_UOM_STOCK_SALES_QTY = 12;
    public static final int JSP_FOR_SALE = 13;
    public static final int JSP_FOR_BUY = 14;
    public static final int JSP_IS_ACTIVE = 15;
    public static final int JSP_SELLING_PRICE = 16;
    public static final int JSP_COGS = 17;
    public static final int JSP_RECIPE_ITEM = 18;
    public static final int JSP_NEED_RECIPE = 19;
    public static final int JSP_DEFAULT_VENDOR_ID = 20;
    public static final int JSP_MIN_STOCK = 21;
    public static final int JSP_APPLY_STOCK_CODE = 22;
    public static final int JSP_IS_SERVICE = 23;
    public static final int JSP_COGS_CONSIGMENT = 24;
    public static final int JSP_APPLY_STOCK_CODE_SALES = 25;
    public static final int JSP_USE_EXPIRED_DATE = 26;
    public static final int JSP_MERK_ID = 27;
    public static final int JSP_NEW_COGS= 28;
    public static final int JSP_ACTIVE_DATE= 29;
    public static final int JSP_IS_BKP= 30;
    public static final int JSP_IS_KOMISI= 31;
    public static final int JSP_BARCODE_2= 32;
    public static final int JSP_BARCODE_3= 33;
    public static final int JSP_TYPE_ITEM= 34;
    
    public static final  int JSP_UOM_STOCK_SALES1_QTY=35;        
    public static final  int JSP_UOM_SALES2_ID=36;
    public static final  int JSP_UOM_STOCK_SALES2_QTY=37;
    public static final  int JSP_UOM_SALES3_ID=38;
    public static final  int JSP_UOM_STOCK_SALES3_QTY=39;
    public static final  int JSP_UOM_SALES4_ID=40;
    public static final  int JSP_UOM_STOCK_SALES4_QTY=41;
    public static final  int JSP_UOM_SALES5_ID=42;
    public static final  int JSP_UOM_STOCK_SALES5_QTY=43;
    public static final  int JSP_DELIVERY_UNIT=44;
    public static final  int JSP_LOCATION_ORDER=45;
    public static final  int JSP_IS_AUTO_ORDER=46;
    public static final  int JSP_NEED_BOM=47;
    public static final  int JSP_STATUS=48;
    public static final  int JSP_APPROVED_DATE=49;
    
    public static String[] colNames = {
        "JSP_ITEM_MASTER_ID", "JSP_ITEM_GROUP_ID",
        "JSP_ITEM_CATEGORY_ID", "JSP_UOM_PURCHASE_ID",
        "JSP_UOM_RECIPE_ID", "JSP_UOM_STOCK_ID",
        "JSP_UOM_SALES_ID", "JSP_CODE",
        "JSP_BARCODE", "JSP_NAME",
        "JSP_UOM_PURCHASE_STOCK_QTY", "JSP_UOM_STOCK_RECIPE_QTY",
        "JSP_UOM_STOCK_SALES_QTY", "JSP_FOR_SALE",
        "JSP_FOR_BUY", "JSP_IS_ACTIVE",
        "JSP_SELLING_PRICE", "JSP_COGS",
        "JSP_RECIPE_ITEM", "JSP_NEED_RECIPE",
        "JSP_DEFAULT_VENDOR_ID", "JSP_MIN_STOCK",
        "JSP_APPLY_STOCK_CODE",
        "JSP_IS_SERVICE",
        "JSP_COGS_CONSIGMENT",
        "JSP_APPLY_STOCK_CODE_SALES",
        "JSP_USE_EXPIRED_DATE",
        "JSP_MERK_ID",
        "JSP_NEW_COGS",
        "JSP_ACTIVE_DATE",
        "JSP_IS_BKP",
        "JSP_IS_KOMISI",
        "JSP_BARCODE_2",
        "JSP_BARCODE_3",
        "JSP_TYPE_ITEM",
        
        "JSP_UOM_STOCK_SALES1_QTY",
        "JSP_UOM_SALES2_ID",
        "JSP_UOM_STOCK_SALES2_QTY",
        "JSP_UOM_SALES3_ID",
        "JSP_UOM_STOCK_SALES3_QTY",
        "JSP_UOM_SALES4_ID",
        "JSP_UOM_STOCK_SALES4_QTY",
        "JSP_UOM_SALES5_ID",
        "JSP_UOM_STOCK_SALES5_QTY",
        "JSP_DELIVERY_UNIT",
        "JSP_LOCATION_ORDER",
        "JSP_IS_AUTO_ORDER",
        "JSP_NEED_BOM",
        "JSP_STATUS",
        "JSP_APPROVED_DATE"
        
        
    };
    
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED, TYPE_LONG,
        TYPE_LONG, TYPE_LONG,
        TYPE_LONG, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING, TYPE_STRING + ENTRY_REQUIRED,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_FLOAT, TYPE_INT,
        TYPE_INT, TYPE_INT,
        TYPE_FLOAT, TYPE_FLOAT,
        TYPE_INT, TYPE_INT,
        TYPE_LONG, TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING
        
    };

    public JspItemMaster() {
    }

    public JspItemMaster(ItemMaster itemMaster) {
        this.itemMaster = itemMaster;
    }

    public JspItemMaster(HttpServletRequest request, ItemMaster itemMaster) {
        super(new JspItemMaster(itemMaster), request);
        this.itemMaster = itemMaster;
    }

    public String getFormName() {
        return JSP_NAME_ITEMMASTER;
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

    public ItemMaster getEntityObject() {
        return itemMaster;
    }

    public void requestEntityObject(ItemMaster itemMaster) {
        try {
            this.requestParam();
            itemMaster.setItemGroupId(getLong(JSP_ITEM_GROUP_ID));
            itemMaster.setItemCategoryId(getLong(JSP_ITEM_CATEGORY_ID));
            itemMaster.setUomPurchaseId(getLong(JSP_UOM_PURCHASE_ID));
            itemMaster.setUomRecipeId(getLong(JSP_UOM_RECIPE_ID));
            itemMaster.setUomStockId(getLong(JSP_UOM_STOCK_ID));
            itemMaster.setUomSalesId(getLong(JSP_UOM_SALES_ID));
            itemMaster.setCode(getString(JSP_CODE));
            itemMaster.setBarcode(getString(JSP_BARCODE));
            itemMaster.setName(getString(JSP_NAME));
            itemMaster.setUomPurchaseStockQty(getDouble(JSP_UOM_PURCHASE_STOCK_QTY));
            itemMaster.setUomStockRecipeQty(getDouble(JSP_UOM_STOCK_RECIPE_QTY));
            itemMaster.setUomStockSalesQty(getDouble(JSP_UOM_STOCK_SALES_QTY));
            itemMaster.setForSale(getInt(JSP_FOR_SALE));
            itemMaster.setForBuy(getInt(JSP_FOR_BUY));
            itemMaster.setIsActive(getInt(JSP_IS_ACTIVE));
            itemMaster.setSellingPrice(getDouble(JSP_SELLING_PRICE));
            itemMaster.setCogs(getDouble(JSP_COGS));
            itemMaster.setRecipeItem(getInt(JSP_RECIPE_ITEM));
            itemMaster.setNeedRecipe(getInt(JSP_NEED_RECIPE));

            itemMaster.setDefaultVendorId(getLong(JSP_DEFAULT_VENDOR_ID));
            itemMaster.setMinStock(getDouble(JSP_MIN_STOCK));
            itemMaster.setApplyStockCode(getInt(JSP_APPLY_STOCK_CODE));
            itemMaster.setIs_service(getInt(JSP_IS_SERVICE));
            itemMaster.setCogs_consigment(getFloat(JSP_COGS_CONSIGMENT));
            itemMaster.setApplyStockCodeSales(getInt(JSP_APPLY_STOCK_CODE_SALES));
            itemMaster.setUseExpiredDate(getInt(JSP_USE_EXPIRED_DATE));
            itemMaster.setMerk_id(getLong(JSP_MERK_ID));
            itemMaster.setNew_cogs(getDouble(JSP_NEW_COGS));
            itemMaster.setActive_date(JSPFormater.formatDate(getString(JSP_ACTIVE_DATE), "dd/MM/yyyy"));
            itemMaster.setIs_bkp(getInt(JSP_IS_BKP));
            itemMaster.setIsKomisi(getInt(JSP_IS_KOMISI));
            itemMaster.setBarcode2(getString(JSP_BARCODE_2));
            itemMaster.setBarcode3(getString(JSP_BARCODE_3));
            itemMaster.setTypeItem(getInt(JSP_TYPE_ITEM));
            itemMaster.setIs_bkp(getInt(JSP_IS_BKP));
            
            itemMaster.setUomStockSales1Qty(getDouble(JSP_UOM_STOCK_SALES1_QTY));            
            itemMaster.setUomSales2Id(getLong(JSP_UOM_SALES2_ID));            
            itemMaster.setUomStockSales2Qty(getDouble(JSP_UOM_STOCK_SALES2_QTY));
            itemMaster.setUomSales3Id(getLong(JSP_UOM_SALES3_ID));
            itemMaster.setUomStockSales3Qty(getDouble(JSP_UOM_STOCK_SALES3_QTY));
            itemMaster.setUomSales4Id(getLong(JSP_UOM_SALES4_ID));
            itemMaster.setUomStockSales4Qty(getDouble(JSP_UOM_STOCK_SALES4_QTY));
            itemMaster.setUomSales5Id(getLong(JSP_UOM_SALES5_ID));
            itemMaster.setUomStockSales5Qty(getDouble(JSP_UOM_STOCK_SALES5_QTY));
            itemMaster.setDeliveryUnit(getDouble(JSP_DELIVERY_UNIT));
            itemMaster.setLocationOrder(getLong(JSP_LOCATION_ORDER));
            itemMaster.setIsAutoOrder(getInt(JSP_IS_AUTO_ORDER));
            itemMaster.setNeedBom(getInt(JSP_NEED_BOM));
            itemMaster.setStatus(getString(JSP_STATUS));
            itemMaster.setApprovedDate(JSPFormater.formatDate(getString(JSP_APPROVED_DATE), "dd/MM/yyyy"));
            
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
