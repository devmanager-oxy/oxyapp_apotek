package com.project.ccs.posmaster;

import com.project.ccs.postransaction.receiving.*;
import com.project.ccs.session.MasterGroup;
import com.project.ccs.session.MasterOid;
import com.project.fms.master.DbCoa;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.general.*;
import com.project.system.DbSystemProperty;
import com.project.util.*;

public class DbItemMaster extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_ITEM_MASTER = "pos_item_master";
    public static final int COL_ITEM_MASTER_ID = 0;
    public static final int COL_ITEM_GROUP_ID = 1;
    public static final int COL_ITEM_CATEGORY_ID = 2;
    public static final int COL_UOM_PURCHASE_ID = 3;
    public static final int COL_UOM_RECIPE_ID = 4;
    public static final int COL_UOM_STOCK_ID = 5;
    public static final int COL_UOM_SALES_ID = 6;
    public static final int COL_CODE = 7;
    public static final int COL_BARCODE = 8;
    public static final int COL_NAME = 9;
    public static final int COL_UOM_PURCHASE_STOCK_QTY = 10;
    public static final int COL_UOM_STOCK_RECIPE_QTY = 11;
    public static final int COL_UOM_STOCK_SALES_QTY = 12;
    public static final int COL_FOR_SALE = 13;
    public static final int COL_FOR_BUY = 14;
    public static final int COL_IS_ACTIVE = 15;
    public static final int COL_SELLING_PRICE = 16;
    public static final int COL_COGS = 17;
    public static final int COL_RECIPE_ITEM = 18;
    public static final int COL_NEED_RECIPE = 19;
    public static final int COL_DEFAULT_VENDOR_ID = 20;
    public static final int COL_MIN_STOCK = 21;
    public static final int COL_TYPE = 22;
    public static final int COL_APPLY_STOCK_CODE = 23;
    public static final int COL_IS_SERVICE = 24;
    public static final int COL_COGS_CONSIGMENT = 25;
    public static final int COL_APPLY_STOCK_CODE_SALES = 26;
    public static final int COL_USE_EXPIRED_DATE = 27;
    public static final int COL_MERK_ID = 28;
    public static final int COL_NEW_COGS = 29;
    public static final int COL_ACTIVE_DATE = 30;
    public static final int COL_IS_BKP = 31;
    public static final int COL_IS_KOMISI = 32;
    public static final int COL_BARCODE_2 = 33;
    public static final int COL_BARCODE_3 = 34;
    public static final int COL_COUNTER_SKU = 35;
    public static final int COL_REGISTER_DATE = 36;
    public static final int COL_TYPE_ITEM = 37;
    public static final int COL_UOM_STOCK_SALES1_QTY = 38;
    public static final int COL_UOM_SALES2_ID = 39;
    public static final int COL_UOM_STOCK_SALES2_QTY = 40;
    public static final int COL_UOM_SALES3_ID = 41;
    public static final int COL_UOM_STOCK_SALES3_QTY = 42;
    public static final int COL_UOM_SALES4_ID = 43;
    public static final int COL_UOM_STOCK_SALES4_QTY = 44;
    public static final int COL_UOM_SALES5_ID = 45;
    public static final int COL_UOM_STOCK_SALES5_QTY = 46;
    public static final int COL_DELIVERY_UNIT = 47;
    public static final int COL_LOCATION_ORDER = 48;
    public static final int COL_IS_AUTO_ORDER = 49;
    public static final int COL_NEED_BOM = 50;
    public static final int COL_STATUS = 51;
    public static final int COL_APPROVED_DATE = 52;
    public static final int COL_USER_ID_APPROVED = 53;
    public static final String[] colNames = {
        "item_master_id",
        "item_group_id",
        "item_category_id",
        "uom_purchase_id",
        "uom_recipe_id",
        "uom_stock_id",
        "uom_sales_id",
        "code",
        "barcode",
        "name",
        "uom_purchase_stock_qty",
        "uom_stock_recipe_qty",
        "uom_stock_sales_qty",
        "for_sales",
        "for_buy",
        "is_active",
        "selling_price",
        "cogs",
        "recipe_item",
        "need_recipe",
        "default_vendor_id",
        "min_stock",
        "type",
        "apply_stock_code",
        "is_service",
        "cogs_consigment",
        "apply_stock_code_sales",
        "use_expired_date",
        "merk_id",
        "new_cogs",
        "active_date",
        "is_bkp",
        "is_komisi",
        "barcode_2",
        "barcode_3",
        "counter_sku",
        "register_date",
        "type_item",
        "uom_stock_sales1_qty",
        "uom_sales2_id",
        "uom_stock_sales2_qty",
        "uom_sales3_id",
        "uom_stock_sales3_qty",
        "uom_sales4_id",
        "uom_stock_sales4_qty",
        "uom_sales5_id",
        "uom_stock_sales5_qty",
        "delivery_unit",
        "location_order",
        "is_auto_order",
        "need_bom",
        "status",
        "approved_date",
        "user_id_approved"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_DATE,
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
        TYPE_DATE,
        TYPE_LONG
    };
    public static int NON_APPLY_STOCK_CODE = 0;
    public static int APPLY_STOCK_CODE = 1;
    public static int OPTIONAL_STOCK_CODE = 2;
    public static int NON_APPLY_STOCK_CODE_SALES = 0;
    public static int APPLY_STOCK_CODE_SALES = 1;
    public static int OPTIONAL_STOCK_CODE_SALES = 2;
    public static int SERVICE = 1;
    public static int NON_SERVICE = 0;
    public static int BKP = 1;
    public static int NON_BKP = 0;
    public static int USE_EXPIRED_DATE = 1;
    public static int NOT_USE_EXPIRED_DATE = 0;
    public static int TYPE_ITEM_BELI_PUTUS = 0;
    public static int TYPE_ITEM_KONSINYASI = 1;
    public static int TYPE_ITEM_KOMISI = 2;
    public static int NON_BOM = 0;
    public static int BOM = 1;

    public DbItemMaster() {
    }

    public DbItemMaster(int i) throws CONException {
        super(new DbItemMaster());
    }

    public DbItemMaster(String sOid) throws CONException {
        super(new DbItemMaster(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }
    public static final String[] golPrice = {
        "gol_1",
        "gol_2",
        "gol_3",
        "gol_4",
        "gol_5",
        "gol_6"
    };

    public DbItemMaster(long lOid) throws CONException {
        super(new DbItemMaster(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public String getTableName() {
        return DB_ITEM_MASTER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbItemMaster().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ItemMaster itemmaster = fetchExc(ent.getOID());
        ent = (Entity) itemmaster;
        return itemmaster.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ItemMaster) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ItemMaster) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ItemMaster fetchExc(long oid) throws CONException {
        try {
            ItemMaster itemmaster = new ItemMaster();
            DbItemMaster pstItemMaster = new DbItemMaster(oid);
            itemmaster.setOID(oid);

            itemmaster.setItemGroupId(pstItemMaster.getlong(COL_ITEM_GROUP_ID));
            itemmaster.setItemCategoryId(pstItemMaster.getlong(COL_ITEM_CATEGORY_ID));
            itemmaster.setUomPurchaseId(pstItemMaster.getlong(COL_UOM_PURCHASE_ID));
            itemmaster.setUomRecipeId(pstItemMaster.getlong(COL_UOM_RECIPE_ID));
            itemmaster.setUomStockId(pstItemMaster.getlong(COL_UOM_STOCK_ID));
            itemmaster.setUomSalesId(pstItemMaster.getlong(COL_UOM_SALES_ID));
            itemmaster.setCode(pstItemMaster.getString(COL_CODE));
            itemmaster.setBarcode(pstItemMaster.getString(COL_BARCODE));
            itemmaster.setName(pstItemMaster.getString(COL_NAME));
            itemmaster.setUomPurchaseStockQty(pstItemMaster.getdouble(COL_UOM_PURCHASE_STOCK_QTY));
            itemmaster.setUomStockRecipeQty(pstItemMaster.getdouble(COL_UOM_STOCK_RECIPE_QTY));
            itemmaster.setUomStockSalesQty(pstItemMaster.getdouble(COL_UOM_STOCK_SALES_QTY));
            itemmaster.setForSale(pstItemMaster.getInt(COL_FOR_SALE));
            itemmaster.setForBuy(pstItemMaster.getInt(COL_FOR_BUY));
            itemmaster.setIsActive(pstItemMaster.getInt(COL_IS_ACTIVE));
            itemmaster.setSellingPrice(pstItemMaster.getdouble(COL_SELLING_PRICE));
            itemmaster.setCogs(pstItemMaster.getdouble(COL_COGS));
            itemmaster.setRecipeItem(pstItemMaster.getInt(COL_RECIPE_ITEM));
            itemmaster.setNeedRecipe(pstItemMaster.getInt(COL_NEED_RECIPE));

            itemmaster.setDefaultVendorId(pstItemMaster.getlong(COL_DEFAULT_VENDOR_ID));
            itemmaster.setMinStock(pstItemMaster.getdouble(COL_MIN_STOCK));
            itemmaster.setType(pstItemMaster.getInt(COL_TYPE));
            itemmaster.setApplyStockCode(pstItemMaster.getInt(COL_APPLY_STOCK_CODE));
            itemmaster.setIs_service(pstItemMaster.getInt(COL_IS_SERVICE));
            itemmaster.setCogs_consigment(pstItemMaster.getdouble(COL_COGS_CONSIGMENT));
            itemmaster.setApplyStockCodeSales(pstItemMaster.getInt(COL_APPLY_STOCK_CODE_SALES));
            itemmaster.setUseExpiredDate(pstItemMaster.getInt(COL_USE_EXPIRED_DATE));
            itemmaster.setMerk_id(pstItemMaster.getlong(COL_MERK_ID));
            itemmaster.setNew_cogs(pstItemMaster.getlong(COL_NEW_COGS));
            itemmaster.setActive_date(pstItemMaster.getDate(COL_ACTIVE_DATE));
            itemmaster.setIs_bkp(pstItemMaster.getInt(COL_IS_BKP));
            itemmaster.setIsKomisi(pstItemMaster.getInt(COL_IS_KOMISI));
            itemmaster.setBarcode2(pstItemMaster.getString(COL_BARCODE_2));
            itemmaster.setBarcode3(pstItemMaster.getString(COL_BARCODE_3));
            itemmaster.setCounterSku(pstItemMaster.getInt(COL_COUNTER_SKU));
            itemmaster.setRegisterDate(pstItemMaster.getDate(COL_REGISTER_DATE));
            itemmaster.setTypeItem(pstItemMaster.getInt(COL_TYPE_ITEM));

            itemmaster.setUomStockSales1Qty(pstItemMaster.getdouble(COL_UOM_STOCK_SALES1_QTY));
            itemmaster.setUomSales2Id(pstItemMaster.getlong(COL_UOM_SALES2_ID));
            itemmaster.setUomStockSales2Qty(pstItemMaster.getdouble(COL_UOM_STOCK_SALES2_QTY));
            itemmaster.setUomSales3Id(pstItemMaster.getlong(COL_UOM_SALES3_ID));
            itemmaster.setUomStockSales3Qty(pstItemMaster.getdouble(COL_UOM_STOCK_SALES3_QTY));
            itemmaster.setUomSales4Id(pstItemMaster.getlong(COL_UOM_SALES4_ID));
            itemmaster.setUomStockSales4Qty(pstItemMaster.getdouble(COL_UOM_STOCK_SALES4_QTY));
            itemmaster.setUomSales5Id(pstItemMaster.getlong(COL_UOM_SALES5_ID));
            itemmaster.setUomStockSales5Qty(pstItemMaster.getdouble(COL_UOM_STOCK_SALES5_QTY));
            itemmaster.setDeliveryUnit(pstItemMaster.getdouble(COL_DELIVERY_UNIT));
            itemmaster.setLocationOrder(pstItemMaster.getlong(COL_LOCATION_ORDER));
            itemmaster.setIsAutoOrder(pstItemMaster.getInt(COL_IS_AUTO_ORDER));
            itemmaster.setNeedBom(pstItemMaster.getInt(COL_NEED_BOM));
            itemmaster.setStatus(pstItemMaster.getString(COL_STATUS));
            itemmaster.setApprovedDate(pstItemMaster.getDate(COL_APPROVED_DATE));
            itemmaster.setUserIdAproved(pstItemMaster.getlong(COL_USER_ID_APPROVED));

            return itemmaster;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbItemMaster(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(ItemMaster itemmaster) throws CONException {
        try {
            DbItemMaster pstItemMaster = new DbItemMaster(0);

            pstItemMaster.setLong(COL_ITEM_GROUP_ID, itemmaster.getItemGroupId());
            pstItemMaster.setLong(COL_ITEM_CATEGORY_ID, itemmaster.getItemCategoryId());
            pstItemMaster.setLong(COL_UOM_PURCHASE_ID, itemmaster.getUomPurchaseId());
            pstItemMaster.setLong(COL_UOM_RECIPE_ID, itemmaster.getUomRecipeId());
            pstItemMaster.setLong(COL_UOM_STOCK_ID, itemmaster.getUomStockId());
            pstItemMaster.setLong(COL_UOM_SALES_ID, itemmaster.getUomSalesId());
            pstItemMaster.setString(COL_CODE, itemmaster.getCode());
            pstItemMaster.setString(COL_BARCODE, itemmaster.getBarcode());
            pstItemMaster.setString(COL_NAME, itemmaster.getName());
            pstItemMaster.setDouble(COL_UOM_PURCHASE_STOCK_QTY, itemmaster.getUomPurchaseStockQty());
            pstItemMaster.setDouble(COL_UOM_STOCK_RECIPE_QTY, itemmaster.getUomStockRecipeQty());
            pstItemMaster.setDouble(COL_UOM_STOCK_SALES_QTY, itemmaster.getUomStockSalesQty());
            pstItemMaster.setInt(COL_FOR_SALE, itemmaster.getForSale());
            pstItemMaster.setInt(COL_FOR_BUY, itemmaster.getForBuy());
            pstItemMaster.setInt(COL_IS_ACTIVE, itemmaster.getIsActive());
            pstItemMaster.setDouble(COL_SELLING_PRICE, itemmaster.getSellingPrice());
            pstItemMaster.setDouble(COL_COGS, itemmaster.getCogs());
            pstItemMaster.setInt(COL_RECIPE_ITEM, itemmaster.getRecipeItem());
            pstItemMaster.setInt(COL_NEED_RECIPE, itemmaster.getNeedRecipe());

            pstItemMaster.setLong(COL_DEFAULT_VENDOR_ID, itemmaster.getDefaultVendorId());
            pstItemMaster.setDouble(COL_MIN_STOCK, itemmaster.getMinStock());
            pstItemMaster.setInt(COL_TYPE, itemmaster.getType());
            pstItemMaster.setInt(COL_APPLY_STOCK_CODE, itemmaster.getApplyStockCode());
            pstItemMaster.setInt(COL_IS_SERVICE, itemmaster.getIs_service());
            pstItemMaster.setFloat(COL_COGS_CONSIGMENT, itemmaster.getCogs_consigment());
            pstItemMaster.setInt(COL_APPLY_STOCK_CODE_SALES, itemmaster.getApplyStockCodeSales());
            pstItemMaster.setInt(COL_USE_EXPIRED_DATE, itemmaster.getUseExpiredDate());
            pstItemMaster.setLong(COL_MERK_ID, itemmaster.getMerk_id());
            pstItemMaster.setDouble(COL_NEW_COGS, itemmaster.getNew_cogs());
            pstItemMaster.setDate(COL_ACTIVE_DATE, itemmaster.getActive_date());
            pstItemMaster.setInt(COL_IS_BKP, itemmaster.getIs_bkp());
            pstItemMaster.setInt(COL_IS_KOMISI, itemmaster.getIsKomisi());
            pstItemMaster.setString(COL_BARCODE_2, itemmaster.getBarcode2());
            pstItemMaster.setString(COL_BARCODE_3, itemmaster.getBarcode3());
            pstItemMaster.setInt(COL_COUNTER_SKU, itemmaster.getCounterSku());
            pstItemMaster.setDate(COL_REGISTER_DATE, itemmaster.getRegisterDate());
            pstItemMaster.setInt(COL_TYPE_ITEM, itemmaster.getTypeItem());

            pstItemMaster.setDouble(COL_UOM_STOCK_SALES1_QTY, itemmaster.getUomStockSales1Qty());
            pstItemMaster.setLong(COL_UOM_SALES2_ID, itemmaster.getUomSales2Id());
            pstItemMaster.setDouble(COL_UOM_STOCK_SALES2_QTY, itemmaster.getUomStockSales2Qty());
            pstItemMaster.setLong(COL_UOM_SALES3_ID, itemmaster.getUomSales3Id());
            pstItemMaster.setDouble(COL_UOM_STOCK_SALES3_QTY, itemmaster.getUomStockSales3Qty());
            pstItemMaster.setLong(COL_UOM_SALES4_ID, itemmaster.getUomSales4Id());
            pstItemMaster.setDouble(COL_UOM_STOCK_SALES4_QTY, itemmaster.getUomStockSales4Qty());
            pstItemMaster.setLong(COL_UOM_SALES5_ID, itemmaster.getUomSales5Id());
            pstItemMaster.setDouble(COL_UOM_STOCK_SALES5_QTY, itemmaster.getUomStockSales5Qty());
            pstItemMaster.setDouble(COL_DELIVERY_UNIT, itemmaster.getDeliveryUnit());
            pstItemMaster.setLong(COL_LOCATION_ORDER, itemmaster.getLocationOrder());
            pstItemMaster.setInt(COL_IS_AUTO_ORDER, itemmaster.getIsAutoOrder());
            pstItemMaster.setInt(COL_NEED_BOM, itemmaster.getNeedBom());
            pstItemMaster.setString(COL_STATUS, itemmaster.getStatus());
            pstItemMaster.setDate(COL_APPROVED_DATE, itemmaster.getApprovedDate());
            pstItemMaster.setLong(COL_USER_ID_APPROVED, itemmaster.getUserIdAproved());
            pstItemMaster.insert();
            itemmaster.setOID(pstItemMaster.getlong(COL_ITEM_MASTER_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbItemMaster(0), CONException.UNKNOWN);
        }
        return itemmaster.getOID();
    }

    public static long updateExc(ItemMaster itemmaster) throws CONException {
        try {
            if (itemmaster.getOID() != 0) {
                DbItemMaster pstItemMaster = new DbItemMaster(itemmaster.getOID());

                pstItemMaster.setLong(COL_ITEM_GROUP_ID, itemmaster.getItemGroupId());
                pstItemMaster.setLong(COL_ITEM_CATEGORY_ID, itemmaster.getItemCategoryId());
                pstItemMaster.setLong(COL_UOM_PURCHASE_ID, itemmaster.getUomPurchaseId());
                pstItemMaster.setLong(COL_UOM_RECIPE_ID, itemmaster.getUomRecipeId());
                pstItemMaster.setLong(COL_UOM_STOCK_ID, itemmaster.getUomStockId());
                pstItemMaster.setLong(COL_UOM_SALES_ID, itemmaster.getUomSalesId());
                pstItemMaster.setString(COL_CODE, itemmaster.getCode());
                pstItemMaster.setString(COL_BARCODE, itemmaster.getBarcode());
                pstItemMaster.setString(COL_NAME, itemmaster.getName());
                pstItemMaster.setDouble(COL_UOM_PURCHASE_STOCK_QTY, itemmaster.getUomPurchaseStockQty());
                pstItemMaster.setDouble(COL_UOM_STOCK_RECIPE_QTY, itemmaster.getUomStockRecipeQty());
                pstItemMaster.setDouble(COL_UOM_STOCK_SALES_QTY, itemmaster.getUomStockSalesQty());
                pstItemMaster.setInt(COL_FOR_SALE, itemmaster.getForSale());
                pstItemMaster.setInt(COL_FOR_BUY, itemmaster.getForBuy());
                pstItemMaster.setInt(COL_IS_ACTIVE, itemmaster.getIsActive());
                pstItemMaster.setDouble(COL_SELLING_PRICE, itemmaster.getSellingPrice());
                pstItemMaster.setDouble(COL_COGS, itemmaster.getCogs());
                pstItemMaster.setInt(COL_RECIPE_ITEM, itemmaster.getRecipeItem());
                pstItemMaster.setInt(COL_NEED_RECIPE, itemmaster.getNeedRecipe());

                pstItemMaster.setLong(COL_DEFAULT_VENDOR_ID, itemmaster.getDefaultVendorId());
                pstItemMaster.setDouble(COL_MIN_STOCK, itemmaster.getMinStock());
                pstItemMaster.setInt(COL_TYPE, itemmaster.getType());
                pstItemMaster.setInt(COL_APPLY_STOCK_CODE, itemmaster.getApplyStockCode());
                pstItemMaster.setInt(COL_IS_SERVICE, itemmaster.getIs_service());
                pstItemMaster.setFloat(COL_COGS_CONSIGMENT, itemmaster.getCogs_consigment());
                pstItemMaster.setInt(COL_APPLY_STOCK_CODE_SALES, itemmaster.getApplyStockCodeSales());
                pstItemMaster.setFloat(COL_USE_EXPIRED_DATE, itemmaster.getUseExpiredDate());
                pstItemMaster.setLong(COL_MERK_ID, itemmaster.getMerk_id());
                pstItemMaster.setDouble(COL_NEW_COGS, itemmaster.getNew_cogs());
                pstItemMaster.setDate(COL_ACTIVE_DATE, itemmaster.getActive_date());
                pstItemMaster.setInt(COL_IS_BKP, itemmaster.getIs_bkp());
                pstItemMaster.setInt(COL_IS_KOMISI, itemmaster.getIsKomisi());
                pstItemMaster.setString(COL_BARCODE_2, itemmaster.getBarcode2());
                pstItemMaster.setString(COL_BARCODE_3, itemmaster.getBarcode3());
                pstItemMaster.setInt(COL_COUNTER_SKU, itemmaster.getCounterSku());
                pstItemMaster.setDate(COL_REGISTER_DATE, itemmaster.getRegisterDate());
                pstItemMaster.setInt(COL_TYPE_ITEM, itemmaster.getTypeItem());

                pstItemMaster.setDouble(COL_UOM_STOCK_SALES1_QTY, itemmaster.getUomStockSales1Qty());
                pstItemMaster.setLong(COL_UOM_SALES2_ID, itemmaster.getUomSales2Id());
                pstItemMaster.setDouble(COL_UOM_STOCK_SALES2_QTY, itemmaster.getUomStockSales2Qty());
                pstItemMaster.setLong(COL_UOM_SALES3_ID, itemmaster.getUomSales3Id());
                pstItemMaster.setDouble(COL_UOM_STOCK_SALES3_QTY, itemmaster.getUomStockSales3Qty());
                pstItemMaster.setLong(COL_UOM_SALES4_ID, itemmaster.getUomSales4Id());
                pstItemMaster.setDouble(COL_UOM_STOCK_SALES4_QTY, itemmaster.getUomStockSales4Qty());
                pstItemMaster.setLong(COL_UOM_SALES5_ID, itemmaster.getUomSales5Id());
                pstItemMaster.setDouble(COL_UOM_STOCK_SALES5_QTY, itemmaster.getUomStockSales5Qty());
                pstItemMaster.setDouble(COL_DELIVERY_UNIT, itemmaster.getDeliveryUnit());
                pstItemMaster.setLong(COL_LOCATION_ORDER, itemmaster.getLocationOrder());
                pstItemMaster.setInt(COL_IS_AUTO_ORDER, itemmaster.getIsAutoOrder());
                pstItemMaster.setInt(COL_NEED_BOM, itemmaster.getNeedBom());
                pstItemMaster.setString(COL_STATUS, itemmaster.getStatus());
                pstItemMaster.setDate(COL_APPROVED_DATE, itemmaster.getApprovedDate());
                pstItemMaster.setLong(COL_USER_ID_APPROVED, itemmaster.getUserIdAproved());
                pstItemMaster.update();
                return itemmaster.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbItemMaster(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbItemMaster pstItemMaster = new DbItemMaster(oid);
            pstItemMaster.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbItemMaster(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_ITEM_MASTER;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }


            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;
                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }
                    break;
                case CONHandler.CONSVR_SYBASE:

                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ItemMaster itemmaster = new ItemMaster();
                resultToObject(rs, itemmaster);
                lists.add(itemmaster);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listByVendor(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_ITEM_MASTER + " INNER JOIN pos_vendor_item ON pos_item_master.item_master_id=pos_vendor_item.item_master_id ";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ItemMaster itemmaster = new ItemMaster();
                resultToObject(rs, itemmaster);
                lists.add(itemmaster);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listConsigment(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_ITEM_MASTER + " inner join " + DbReceiveItem.DB_RECEIVE_ITEM + " on " + DbItemMaster.DB_ITEM_MASTER + "." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + "=" + DbReceiveItem.DB_RECEIVE_ITEM + "." + DbReceiveItem.colNames[DbReceiveItem.COL_ITEM_MASTER_ID];
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause + " and " + DbReceiveItem.DB_RECEIVE_ITEM + "." + DbReceiveItem.colNames[DbReceiveItem.COL_TYPE] + "=" + DbReceive.TYPE_CONSIGMENT;
            }
            sql = sql + " group by " + DbItemMaster.DB_ITEM_MASTER + "." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID];
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ItemMaster itemmaster = new ItemMaster();
                resultToObject(rs, itemmaster);
                lists.add(itemmaster);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, ItemMaster itemmaster) {
        try {
            itemmaster.setOID(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]));
            itemmaster.setItemGroupId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]));
            itemmaster.setItemCategoryId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]));
            itemmaster.setUomPurchaseId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_PURCHASE_ID]));
            itemmaster.setUomRecipeId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_RECIPE_ID]));
            itemmaster.setUomStockId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_ID]));
            itemmaster.setUomSalesId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES_ID]));
            itemmaster.setCode(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_CODE]));
            itemmaster.setBarcode(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_BARCODE]));
            itemmaster.setName(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_NAME]));
            itemmaster.setUomPurchaseStockQty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_PURCHASE_STOCK_QTY]));
            itemmaster.setUomStockRecipeQty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_RECIPE_QTY]));
            itemmaster.setUomStockSalesQty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES_QTY]));
            itemmaster.setForSale(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_FOR_SALE]));
            itemmaster.setForBuy(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_FOR_BUY]));
            itemmaster.setIsActive(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_ACTIVE]));
            itemmaster.setSellingPrice(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE]));
            itemmaster.setCogs(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_COGS]));
            itemmaster.setRecipeItem(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_RECIPE_ITEM]));
            itemmaster.setNeedRecipe(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE]));

            itemmaster.setDefaultVendorId(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID]));
            itemmaster.setMinStock(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_MIN_STOCK]));
            itemmaster.setType(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_TYPE]));
            itemmaster.setApplyStockCode(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_APPLY_STOCK_CODE]));
            itemmaster.setIs_service(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_SERVICE]));
            itemmaster.setCogs_consigment(rs.getFloat(DbItemMaster.colNames[DbItemMaster.COL_COGS_CONSIGMENT]));
            itemmaster.setApplyStockCodeSales(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_APPLY_STOCK_CODE_SALES]));
            itemmaster.setUseExpiredDate(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_USE_EXPIRED_DATE]));
            itemmaster.setMerk_id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_MERK_ID]));
            itemmaster.setNew_cogs(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_NEW_COGS]));
            itemmaster.setActive_date(rs.getDate(DbItemMaster.colNames[DbItemMaster.COL_ACTIVE_DATE]));
            itemmaster.setIs_bkp(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_BKP]));
            itemmaster.setIsKomisi(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_KOMISI]));
            itemmaster.setBarcode2(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2]));
            itemmaster.setBarcode3(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3]));
            itemmaster.setCounterSku(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_COUNTER_SKU]));
            itemmaster.setRegisterDate(rs.getDate(DbItemMaster.colNames[DbItemMaster.COL_REGISTER_DATE]));
            itemmaster.setTypeItem(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_TYPE_ITEM]));

            itemmaster.setUomStockSales1Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES1_QTY]));
            itemmaster.setUomSales2Id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES2_ID]));
            itemmaster.setUomStockSales2Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES2_QTY]));
            itemmaster.setUomSales3Id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES3_ID]));
            itemmaster.setUomStockSales3Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES3_QTY]));
            itemmaster.setUomSales4Id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES4_ID]));
            itemmaster.setUomStockSales4Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES4_QTY]));
            itemmaster.setUomSales5Id(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_UOM_SALES5_ID]));
            itemmaster.setUomStockSales5Qty(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_UOM_STOCK_SALES5_QTY]));
            itemmaster.setDeliveryUnit(rs.getDouble(DbItemMaster.colNames[DbItemMaster.COL_DELIVERY_UNIT]));
            itemmaster.setLocationOrder(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_LOCATION_ORDER]));
            itemmaster.setIsAutoOrder(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_IS_AUTO_ORDER]));
            itemmaster.setNeedBom(rs.getInt(DbItemMaster.colNames[DbItemMaster.COL_NEED_BOM]));
            itemmaster.setStatus(rs.getString(DbItemMaster.colNames[DbItemMaster.COL_STATUS]));
            itemmaster.setApprovedDate(rs.getDate(DbItemMaster.colNames[DbItemMaster.COL_APPROVED_DATE]));
            itemmaster.setUserIdAproved(rs.getLong(DbItemMaster.colNames[DbItemMaster.COL_USER_ID_APPROVED]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long itemMasterId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_ITEM_MASTER + " WHERE " +
                    DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " = " + itemMasterId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static boolean checkBarcode(String barcode) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT " + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " FROM " + DB_ITEM_MASTER + " WHERE " +
                    DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " = '" + barcode + "'";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static boolean checkSKU(String sku) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT item_master_id FROM " + DB_ITEM_MASTER + " WHERE " +
                    DbItemMaster.colNames[DbItemMaster.COL_CODE] + " = '" + sku + "'";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ") FROM " + DB_ITEM_MASTER;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static int getCountBySupplier(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(pos_item_master." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + ") FROM " + DB_ITEM_MASTER + " INNER JOIN pos_vendor_item ON pos_item_master.item_master_id=pos_vendor_item.item_master_id ";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    /* This method used to find current data */
    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    ItemMaster itemmaster = (ItemMaster) list.get(ls);
                    if (oid == itemmaster.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }

        return start;
    }

    public static int getNextCounter(long itemGroupId) {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER_SKU] + ") from " + DB_ITEM_MASTER + " where " +
                    colNames[COL_ITEM_GROUP_ID] + "=" + itemGroupId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            int ctr = 0;
            while (rs.next()) {

                ctr = rs.getInt(1);

                int x = 0;
                ItemGroup itemGroup = new ItemGroup();
                try {
                    itemGroup = DbItemGroup.fetchExc(itemGroupId);
                } catch (Exception e) {
                }

                String counterS = DbSystemProperty.getValueByName("DIGIT_SKU");
                int digitC = 4;
                if (!(counterS.equalsIgnoreCase("Not initialized"))) {
                    digitC = Integer.parseInt(counterS);
                }
                String code = "";
                int loop = 0;
                do {
                    ctr++;
                    code = itemGroup.getCode();
                    if (digitC == 4) {
                        if (ctr < 10) {
                            code = code + "000" + ctr;
                        } else if (ctr < 100) {
                            code = code + "00" + ctr;
                        } else if (ctr < 1000) {
                            code = code + "0" + ctr;
                        } else {
                            code = code + ctr;
                        }
                    } else if (digitC == 3) {
                        if (ctr < 10) {
                            code = code + "00" + ctr;
                        } else if (ctr < 100) {
                            code = code + "0" + ctr;
                        } else {
                            code = code + ctr;
                        }
                    }

                    x = getCount(DbItemMaster.colNames[DbItemMaster.COL_CODE] + " = '" + code + "'");
                    loop++;                                        
                } while (x > 0 && loop <= 100);

            }

            result = ctr;

        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

    public static boolean isItemSales(long itemMasterId) {
        boolean result = false;
        String sql = "";
        CONResultSet dbrs = null;
        try {
            sql = "select product_master_id from pos_sales_detail where product_master_id=" + itemMasterId + " limit 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return result;

    }

    public static boolean isItemPurchase(long itemMasterId) {
        boolean result = false;
        String sql = "";
        CONResultSet dbrs = null;
        try {
            sql = "select item_master_id from pos_purchase_item where item_master_id=" + itemMasterId + " limit 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return result;

    }

    public static boolean isItemReceive(long itemMasterId) {
        boolean result = false;
        String sql = "";
        CONResultSet dbrs = null;
        try {
            sql = "select item_master_id from pos_receive_item where item_master_id=" + itemMasterId + " limit 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return result;

    }

    public static boolean isItemTransfer(long itemMasterId) {
        boolean result = false;
        String sql = "";
        CONResultSet dbrs = null;
        try {
            sql = "select item_master_id from pos_transfer_item where item_master_id=" + itemMasterId + " limit 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return result;

    }

    public static boolean isItemCosting(long itemMasterId) {
        boolean result = false;
        String sql = "";
        CONResultSet dbrs = null;
        try {
            sql = "select item_master_id from pos_costing_item where item_master_id=" + itemMasterId + " limit 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return result;

    }

    public static boolean isItemRepack(long itemMasterId) {
        boolean result = false;
        String sql = "";
        CONResultSet dbrs = null;
        try {
            sql = "select item_master_id from pos_repack_item where item_master_id=" + itemMasterId + " limit 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return result;

    }

    public static boolean isItemOpname(long itemMasterId) {
        boolean result = false;
        String sql = "";
        CONResultSet dbrs = null;
        try {
            sql = "select item_master_id from pos_opname_item where item_master_id=" + itemMasterId + " limit 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return result;

    }

    public static boolean isItemAdjusment(long itemMasterId) {
        boolean result = false;
        String sql = "";
        CONResultSet dbrs = null;
        try {
            sql = "select item_master_id from pos_adjusment_item where item_master_id=" + itemMasterId + " limit 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {

        } finally {
            CONResultSet.close(dbrs);
        }
        return result;

    }

    public static boolean isItemUsed(long itemMasterId) {
        boolean result = false;

        result = isItemSales(itemMasterId);
        if (result) {
            return true;
        }
        result = isItemPurchase(itemMasterId);
        if (result) {
            return true;
        }

        result = isItemReceive(itemMasterId);
        if (result) {
            return true;
        }

        result = isItemTransfer(itemMasterId);
        if (result) {
            return true;
        }

        result = isItemCosting(itemMasterId);
        if (result) {
            return true;
        }

        result = isItemRepack(itemMasterId);
        if (result) {
            return true;
        }

        result = isItemOpname(itemMasterId);
        if (result) {
            return true;
        }

        result = isItemAdjusment(itemMasterId);
        if (result) {
            return true;
        }

        return result;
    }

    public static synchronized String getNextCode(long itemGroupId) {
        int ctr = getNextCounter(itemGroupId);
        ItemGroup itemGroup = new ItemGroup();
        try {
            itemGroup = DbItemGroup.fetchExc(itemGroupId);
        } catch (Exception e) {
        }

        String counterS = DbSystemProperty.getValueByName("DIGIT_SKU");
        int digitC = 4;
        if (!(counterS.equalsIgnoreCase("Not initialized"))) {
            digitC = Integer.parseInt(counterS);
        }
        String code = itemGroup.getCode();
        if (digitC == 4) {
            if (ctr < 10) {
                code = code + "000" + ctr;
            } else if (ctr < 100) {
                code = code + "00" + ctr;
            } else if (ctr < 1000) {
                code = code + "0" + ctr;
            } else {
                code = code + ctr;
            }
        } else if (digitC == 3) {
            if (ctr < 10) {
                code = code + "00" + ctr;
            } else if (ctr < 100) {
                code = code + "0" + ctr;
            } else {
                code = code + ctr;
            }
        }

        return code;

    }

    //Eka Ds
    //========================== operation log management ==============================================
    //insert logs for new item
    public static void insertOperationLog(long oid, long userId, String userName, ItemMaster itemMaster) {

        LogOperation lo = new LogOperation();
        lo.setDate(new java.util.Date());
        lo.setOwnerId(oid);
        lo.setUserId(userId);
        lo.setUserName(userName);
        lo.setLogDesc("Insert new item master : " + itemMaster.getName() + ", barcode :" + itemMaster.getBarcode());

        try {
            DbLogOperation.insertExc(lo);
        } catch (Exception e) {

        }
    }

    //insert logs for update item
    public static void insertOperationLog(long oid, long userId, String userName, ItemMaster oldItemMaster, ItemMaster itemMaster) {

        String logDesc = getLogDesc(oldItemMaster, itemMaster);

        if (logDesc.length() > 0) {

            LogOperation lo = new LogOperation();
            lo.setDate(new java.util.Date());
            lo.setOwnerId(oid);
            lo.setUserId(userId);
            lo.setUserName(userName);
            lo.setLogDesc(logDesc);

            try {
                DbLogOperation.insertExc(lo);
            } catch (Exception e) {

            }
        }
    }

    public static String getLogDesc(ItemMaster oldItemmaster, ItemMaster itemmaster) {
        String logDesc = "";

        if (oldItemmaster.getItemGroupId() != itemmaster.getItemGroupId()) {
            logDesc = "group :";
            try {
                ItemGroup ig = DbItemGroup.fetchExc(oldItemmaster.getItemGroupId());
                logDesc = logDesc + " " + ig.getName();
                ItemGroup ig2 = DbItemGroup.fetchExc(itemmaster.getItemGroupId());
                logDesc = logDesc + " > " + ig2.getName();
            } catch (Exception e) {
            }
        }

        if (oldItemmaster.getItemCategoryId() != itemmaster.getItemCategoryId()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "category :";
            try {
                ItemCategory ic = DbItemCategory.fetchExc(oldItemmaster.getItemCategoryId());
                logDesc = logDesc + " " + ic.getName();
                ItemCategory ic2 = DbItemCategory.fetchExc(itemmaster.getItemCategoryId());
                logDesc = logDesc + " > " + ic2.getName();
            } catch (Exception e) {
            }
        }

        if (oldItemmaster.getUomPurchaseId() != itemmaster.getUomPurchaseId()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "purchase unit :";
            try {
                Uom ic = DbUom.fetchExc(oldItemmaster.getUomPurchaseId());
                logDesc = logDesc + " " + ic.getUnit();
                Uom ic2 = DbUom.fetchExc(itemmaster.getUomPurchaseId());
                logDesc = logDesc + " > " + ic2.getUnit();
            } catch (Exception e) {
            }
        }

        if (oldItemmaster.getUomRecipeId() != itemmaster.getUomRecipeId()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "recipe unit :";
            try {
                Uom ic = DbUom.fetchExc(oldItemmaster.getUomRecipeId());
                logDesc = logDesc + " " + ic.getUnit();
                Uom ic2 = DbUom.fetchExc(itemmaster.getUomRecipeId());
                logDesc = logDesc + " > " + ic2.getUnit();
            } catch (Exception e) {
            }
        }

        if (oldItemmaster.getUomStockId() != itemmaster.getUomStockId()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "stock unit :";
            try {
                Uom ic = DbUom.fetchExc(oldItemmaster.getUomStockId());
                logDesc = logDesc + " " + ic.getUnit();
                Uom ic2 = DbUom.fetchExc(itemmaster.getUomStockId());
                logDesc = logDesc + " > " + ic2.getUnit();
            } catch (Exception e) {
            }
        }

        if (oldItemmaster.getUomSalesId() != itemmaster.getUomSalesId()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "sales unit :";
            try {
                Uom ic = DbUom.fetchExc(oldItemmaster.getUomSalesId());
                logDesc = logDesc + " " + ic.getUnit();
                Uom ic2 = DbUom.fetchExc(itemmaster.getUomSalesId());
                logDesc = logDesc + " > " + ic2.getUnit();
            } catch (Exception e) {
            }
        }

        if (!(oldItemmaster.getCode().equalsIgnoreCase(itemmaster.getCode()))) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "code : " + oldItemmaster.getCode() + " > " + itemmaster.getCode();
        }

        if (!(oldItemmaster.getBarcode().equalsIgnoreCase(itemmaster.getBarcode()))) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "barcode : " + oldItemmaster.getBarcode() + " > " + itemmaster.getBarcode();
        }

        if (!(oldItemmaster.getName().equalsIgnoreCase(itemmaster.getName()))) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "name : " + oldItemmaster.getName() + " > " + itemmaster.getName();
        }

        if (oldItemmaster.getUomPurchaseStockQty() != itemmaster.getUomPurchaseStockQty()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "qty puchase to stock : " + oldItemmaster.getUomPurchaseStockQty() + " > " + itemmaster.getUomPurchaseStockQty();
        }

        if (oldItemmaster.getUomStockRecipeQty() != itemmaster.getUomStockRecipeQty()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "qty stock to recipe : " + oldItemmaster.getUomStockRecipeQty() + " > " + itemmaster.getUomStockRecipeQty();
        }

        if (oldItemmaster.getUomStockSalesQty() != itemmaster.getUomStockSalesQty()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "qty stock to sales : " + oldItemmaster.getUomStockSalesQty() + " > " + itemmaster.getUomStockSalesQty();
        }

        if (oldItemmaster.getForSale() != itemmaster.getForSale()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "for sale flag : " + ((oldItemmaster.getForSale() == 1) ? "YES" : "NO") + " > " + ((itemmaster.getForSale() == 1) ? "YES" : "NO");
        }

        if (oldItemmaster.getForBuy() != itemmaster.getForBuy()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "for puchase flag : " + ((oldItemmaster.getForBuy() == 1) ? "YES" : "NO") + " > " + ((itemmaster.getForBuy() == 1) ? "YES" : "NO");
        }

        if (oldItemmaster.getIsActive() != itemmaster.getIsActive()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "is active flag : " + ((oldItemmaster.getIsActive() == 1) ? "YES" : "NO") + " > " + ((itemmaster.getIsActive() == 1) ? "YES" : "NO");
        }

        if (oldItemmaster.getRecipeItem() != itemmaster.getRecipeItem()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "include in BOM flag : " + ((oldItemmaster.getRecipeItem() == 1) ? "YES" : "NO") + " > " + ((itemmaster.getRecipeItem() == 1) ? "YES" : "NO");
        }

        if (oldItemmaster.getCogs() != itemmaster.getCogs()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "current cogs/hpp : " + oldItemmaster.getCogs() + " > " + itemmaster.getCogs();
        }

        if (oldItemmaster.getNeedRecipe() != itemmaster.getNeedRecipe()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "stockable flag : " + ((oldItemmaster.getRecipeItem() == 1) ? "Stockable" : "Non Stockable") + " > " + ((itemmaster.getRecipeItem() == 1) ? "Stockable" : "Non Stockable");
        }

        if (oldItemmaster.getDefaultVendorId() != itemmaster.getDefaultVendorId()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "stock unit :";
            try {
                Vendor ic = DbVendor.fetchExc(oldItemmaster.getDefaultVendorId());
                logDesc = logDesc + " " + ic.getName();
                Vendor ic2 = DbVendor.fetchExc(itemmaster.getDefaultVendorId());
                logDesc = logDesc + " > " + ic2.getName();
            } catch (Exception e) {
            }
        }

        if (oldItemmaster.getIs_service() != itemmaster.getIs_service()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "is service flag : " + ((oldItemmaster.getIs_service() == 1) ? "YES" : "NO") + " > " + ((itemmaster.getIs_service() == 1) ? "YES" : "NO");
        }

        if (oldItemmaster.getApplyStockCode() != itemmaster.getApplyStockCode()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "stock code flag : ";
            if (oldItemmaster.getApplyStockCode() == NON_APPLY_STOCK_CODE) {
                logDesc = logDesc + "Non Stock Code";
            } else if (oldItemmaster.getApplyStockCode() == APPLY_STOCK_CODE) {
                logDesc = logDesc + "Apply Stock Code";
            } else {
                logDesc = logDesc + "Optional Stock Code";
            }

            if (itemmaster.getApplyStockCode() == NON_APPLY_STOCK_CODE) {
                logDesc = logDesc + " > Non Stock Code";
            } else if (itemmaster.getApplyStockCode() == APPLY_STOCK_CODE) {
                logDesc = logDesc + " > Apply Stock Code";
            } else {
                logDesc = logDesc + " > Optional Stock Code";
            }
        }

        if (oldItemmaster.getApplyStockCodeSales() != itemmaster.getApplyStockCodeSales()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "stock code sales flag : ";
            if (oldItemmaster.getApplyStockCodeSales() == NON_APPLY_STOCK_CODE) {
                logDesc = logDesc + "Non Stock Code";
            } else if (oldItemmaster.getApplyStockCodeSales() == APPLY_STOCK_CODE) {
                logDesc = logDesc + "Apply Stock Code";
            } else {
                logDesc = logDesc + "Optional Stock Code";
            }

            if (itemmaster.getApplyStockCodeSales() == NON_APPLY_STOCK_CODE) {
                logDesc = logDesc + " > Non Stock Code";
            } else if (itemmaster.getApplyStockCodeSales() == APPLY_STOCK_CODE) {
                logDesc = logDesc + " > Apply Stock Code";
            } else {
                logDesc = logDesc + " > Optional Stock Code";
            }
        }

        if (oldItemmaster.getUseExpiredDate() != itemmaster.getUseExpiredDate()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "expired date flag : " + ((oldItemmaster.getUseExpiredDate() == 1) ? "YES" : "NO") + " > " + ((itemmaster.getUseExpiredDate() == 1) ? "YES" : "NO");
        }

        if (oldItemmaster.getMerk_id() != itemmaster.getMerk_id()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "merk :";
            try {
                Merk ic = DbMerk.fetchExc(oldItemmaster.getMerk_id());
                logDesc = logDesc + " " + ic.getName();
                Merk ic2 = DbMerk.fetchExc(itemmaster.getMerk_id());
                logDesc = logDesc + " > " + ic2.getName();
            } catch (Exception e) {
            }
        }

        if (oldItemmaster.getNew_cogs() != itemmaster.getNew_cogs()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "new cogs/hpp : " + oldItemmaster.getNew_cogs() + " > " + itemmaster.getNew_cogs();
        }

        if ((oldItemmaster.getActive_date().compareTo(itemmaster.getActive_date())) != 0) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "new cogs/hpp active date : " + JSPFormater.formatDate(oldItemmaster.getActive_date(), "dd/MM/yyyy") + " > " + JSPFormater.formatDate(itemmaster.getActive_date(), "dd/MM/yyyy");
        }

        if (oldItemmaster.getIs_bkp() != itemmaster.getIs_bkp()) {
            logDesc = logDesc + ((logDesc.length() > 0) ? ", " : "") + "BKP flag : " + ((oldItemmaster.getIs_bkp() == 1) ? "YES" : "NO") + " > " + ((itemmaster.getIs_bkp() == 1) ? "YES" : "NO");
        }

        if (logDesc.length() > 0) {
            logDesc = "Update data >> " + logDesc;
        }

        return logDesc;
    }

    public static MasterGroup getItemGroup(long itemId) {
        CONResultSet crs = null;
        MasterGroup mg = new MasterGroup();
        try {
            String sql = "select im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " item_id ," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " name," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_COGS] + " cogs," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_IS_BKP] + " is_bkp," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NEED_RECIPE] + " service," +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_NEED_BOM] + " bom," +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES_CASH] + " acc_sales_cash, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COGS] + " acc_cogs, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_INV] + " acc_inv, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_SALES] + " acc_sales, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_CASH_INCOME] + " acc_cash_income, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_CREDIT_INCOME] + " acc_credit_income, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_VAT] + " acc_vat, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_COSTING] + " acc_costing, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_BONUS_INCOME] + " acc_bonus, " +
                    " ig." + DbItemGroup.colNames[DbItemGroup.COL_ACCOUNT_OTHER_INCOME] + " acc_other_income " +
                    " from " + DbItemMaster.DB_ITEM_MASTER + " im inner join " + DbItemGroup.DB_ITEM_GROUP + " ig on " +
                    " im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " = ig." + DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID] +
                    " where im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " = " + itemId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                mg.setItemMasterId(rs.getLong("item_id"));
                mg.setName(rs.getString("name"));
                mg.setCogs(rs.getDouble("cogs"));
                mg.setIsBkp(rs.getInt("is_bkp"));
                mg.setAccSalesCash(rs.getString("acc_sales_cash"));
                mg.setAccCogs(rs.getString("acc_cogs"));
                mg.setAccInv(rs.getString("acc_inv"));
                mg.setAccSales(rs.getString("acc_sales"));
                mg.setAccCashIncome(rs.getString("acc_cash_income"));
                mg.setAccCreditIncome(rs.getString("acc_credit_income"));
                mg.setAccVat(rs.getString("acc_vat"));
                mg.setAccCosting(rs.getString("acc_costing"));
                mg.setAccBonusIncome(rs.getString("acc_bonus"));
                mg.setService(rs.getInt("service"));
                mg.setNeedBom(rs.getInt("bom"));
                mg.setAccOtherIncome(rs.getString("acc_other_income"));
                return mg;
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return mg;
    }

    public static MasterOid getOidByCode(String code) {
        CONResultSet crs = null;
        MasterOid mo = new MasterOid();
        try {
            String sql = "select " + DbCoa.colNames[DbCoa.COL_COA_ID] + " from " + DbCoa.DB_COA + " where " + DbCoa.colNames[DbCoa.COL_CODE] + "='" + code + "'";
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                mo.setOidMaster(rs.getLong(DbCoa.colNames[DbCoa.COL_COA_ID]));
                return mo;
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return mo;
    }
}
