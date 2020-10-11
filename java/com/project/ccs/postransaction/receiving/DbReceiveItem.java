
package com.project.ccs.postransaction.receiving;

import com.project.general.DbHistoryUser;
import com.project.general.HistoryUser;
import com.project.util.JSPFormater;
import com.project.ccs.session.SessStock;
import com.project.ccs.postransaction.order.Order;
import com.project.ccs.postransaction.order.DbOrder;
import com.project.ccs.posmaster.DbStockMin;
import com.project.general.DbLocation;
import com.project.general.Location;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.ccs.postransaction.stock.Stock;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemMaster;
import com.project.general.DbLogUser;
import com.project.general.LogUser;
import com.project.fms.session.SessReceiveJournal;
import com.project.system.DbSystemProperty;
import java.util.Date;
import java.sql.ResultSet;
import com.project.main.db.CONResultSet;
import java.util.Vector;
import com.project.main.entity.Entity;
import com.project.main.db.CONException;
import com.project.util.lang.I_Language;
import com.project.main.entity.I_PersintentExc;
import com.project.main.db.I_CONType;
import com.project.main.db.I_CONInterface;
import com.project.main.db.CONHandler;

public class DbReceiveItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language
{
    public static String DB_RECEIVE_ITEM = "pos_receive_item";
    public static int COL_RECEIVE_ITEM_ID = 0;
    public static int COL_RECEIVE_ID = 1;
    public static int COL_ITEM_MASTER_ID = 2;
    public static int COL_QTY = 3;
    public static int COL_AMOUNT = 4;
    public static int COL_TOTAL_AMOUNT = 5;
    public static int COL_TOTAL_DISCOUNT = 6;
    public static int COL_DELIVERY_DATE = 7;
    public static int COL_UOM_ID = 8;
    public static int COL_STATUS = 9;
    public static int COL_PURCHASE_ITEM_ID = 10;
    public static int COL_EXPIRED_DATE = 11;
    public static int COL_AP_COA_ID = 12;
    public static int COL_TYPE = 13;
    public static int COL_IS_BONUS = 14;
    public static int COL_MEMO = 15;
    public static int COL_PRICE_IMPORT = 16;
    public static int COL_TRANSPORT = 17;
    public static int COL_BEA = 18;
    public static int COL_KOMISI = 19;
    public static int COL_LAIN_LAIN = 20;
    public static int COL_UOM_PURCHASE_ID = 21;
    public static int COL_QTY_PURCHASE = 22;
    public static int COL_DIS_1_VAL = 23;
    public static int COL_DIS_2_VAL = 24;
    public static int COL_DIS_3_VAL = 25;
    public static int COL_DIS_4_VAL = 26;
    public static int COL_DIS_1_PERCENT = 27;
    public static int COL_DIS_2_PERCENT = 28;
    public static int COL_DIS_3_PERCENT = 29;
    public static int COL_DIS_4_PERCENT = 30;
    public static int COL_BATCH_NUMBER = 31;

    public static String[] colNames = {
        "receive_item_id",
        "receive_id",
        "item_master_id",
        "qty",
        "amount",
        "total_amount",
        "discount_amount",
        "delivery_date",
        "uom_id",
        "status",
        "purchase_item_id",
        "expired_date",
        "ap_coa_id",
        "type",
        "is_bonus",
        "memo",
        "price_import",
        "transport",
        "bea",
        "komisi",
        "lain_lain",
        "uom_purchase_id",
        "qty_purchase",
        "dis_1_val",
        "dis_2_val",
        "dis_3_val",
        "dis_4_val",
        "dis_1_percent",
        "dis_2_percent",
        "dis_3_percent",
        "dis_4_percent",
        "batch_number",
    };

    public static int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING
    };

    public static int NON_BONUS = 0;
    public static int BONUS     = 1;

    public DbReceiveItem() {
    }

    public DbReceiveItem(int i) throws CONException {
        super((I_CONInterface)new DbReceiveItem());
    }

    public DbReceiveItem(String sOid) throws CONException {
        super((I_CONInterface)new DbReceiveItem(0));
        if (!this.locate(sOid)) {
            throw new CONException((CONHandler)this, 14);
        }
    }

    public DbReceiveItem(long lOid) throws CONException {
        super((I_CONInterface)new DbReceiveItem(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        }
        catch (Exception e) {
            throw new CONException((CONHandler)this, 14);
        }
        if (!this.locate(sOid)) {
            throw new CONException((CONHandler)this, 14);
        }
    }

    public int getFieldSize() {
        return DbReceiveItem.colNames.length;
    }

    public String getTableName() {
        return "pos_receive_item";
    }

    public String[] getFieldNames() {
        return DbReceiveItem.colNames;
    }

    public int[] getFieldTypes() {
        return DbReceiveItem.fieldTypes;
    }

    public String getPersistentName() {
        return new DbReceiveItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ReceiveItem receiveItem = (ReceiveItem)(ent = (Entity)fetchExc(ent.getOID()));
        return receiveItem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ReceiveItem)ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ReceiveItem)ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException((CONHandler)this, 14);
        }
        return deleteExc(ent.getOID());
    }

    public static ReceiveItem fetchExc(long oid) throws CONException {
        try {
            ReceiveItem receiveItem = new ReceiveItem();
            DbReceiveItem dbReceiveItem = new DbReceiveItem(oid);
            receiveItem.setOID(oid);
            receiveItem.setReceiveId(dbReceiveItem.getlong(COL_RECEIVE_ID ));
            receiveItem.setItemMasterId(dbReceiveItem.getlong(COL_ITEM_MASTER_ID));
            receiveItem.setQty(dbReceiveItem.getdouble(COL_QTY));
            receiveItem.setUomId(dbReceiveItem.getlong(COL_UOM_ID));
            receiveItem.setStatus(dbReceiveItem.getString(COL_STATUS));
            receiveItem.setAmount(dbReceiveItem.getdouble(COL_AMOUNT));
            receiveItem.setTotalAmount(dbReceiveItem.getdouble(COL_TOTAL_AMOUNT));
            receiveItem.setTotalDiscount(dbReceiveItem.getdouble(COL_TOTAL_DISCOUNT));
            receiveItem.setDeliveryDate(dbReceiveItem.getDate(COL_DELIVERY_DATE));
            receiveItem.setPurchaseItemId(dbReceiveItem.getlong(COL_PURCHASE_ITEM_ID));
            receiveItem.setExpiredDate(dbReceiveItem.getDate(COL_EXPIRED_DATE));
            receiveItem.setApCoaId(dbReceiveItem.getlong(COL_AP_COA_ID));
            receiveItem.setType(dbReceiveItem.getInt(COL_TYPE));
            receiveItem.setIsBonus(dbReceiveItem.getInt(COL_IS_BONUS));
            receiveItem.setMemo(dbReceiveItem.getString(COL_MEMO));
            receiveItem.setPriceImport(dbReceiveItem.getdouble(COL_PRICE_IMPORT));
            receiveItem.setTransport(dbReceiveItem.getdouble(COL_TRANSPORT));
            receiveItem.setBea(dbReceiveItem.getdouble(COL_BEA));
            receiveItem.setKomisi(dbReceiveItem.getdouble(COL_KOMISI));
            receiveItem.setLainLain(dbReceiveItem.getdouble(COL_LAIN_LAIN));
            receiveItem.setUomPurchaseId(dbReceiveItem.getlong(COL_UOM_PURCHASE_ID));
            receiveItem.setQtyPurchase(dbReceiveItem.getdouble(COL_QTY_PURCHASE));
            receiveItem.setDis1Percent(dbReceiveItem.getdouble(COL_DIS_1_PERCENT));
            receiveItem.setDis1Val(dbReceiveItem.getdouble(COL_DIS_1_VAL));
            receiveItem.setDis2Percent(dbReceiveItem.getdouble(COL_DIS_2_PERCENT));
            receiveItem.setDis2Val(dbReceiveItem.getdouble(COL_DIS_2_VAL));
            receiveItem.setDis3Percent(dbReceiveItem.getdouble(COL_DIS_3_PERCENT));
            receiveItem.setDis3Val(dbReceiveItem.getdouble(COL_DIS_3_VAL));
            receiveItem.setDis4Percent(dbReceiveItem.getdouble(COL_DIS_4_PERCENT));
            receiveItem.setDis4Val(dbReceiveItem.getdouble(COL_DIS_4_VAL));
            receiveItem.setBatchNumber(dbReceiveItem.getString(COL_BATCH_NUMBER));
            return receiveItem;
        }
        catch (CONException dbe) {
            throw dbe;
        }
        catch (Exception e) {
            throw new CONException((CONHandler)new DbReceiveItem(0), 1);
        }
    }

    public static long insertExc(ReceiveItem receiveItem) throws CONException {
        try {
            DbReceiveItem dbReceiveItem = new DbReceiveItem(0);
            dbReceiveItem.setLong(COL_RECEIVE_ID, receiveItem.getReceiveId());
            dbReceiveItem.setLong(COL_ITEM_MASTER_ID, receiveItem.getItemMasterId());
            dbReceiveItem.setDouble(COL_QTY, receiveItem.getQty());
            dbReceiveItem.setLong(COL_UOM_ID, receiveItem.getUomId());
            dbReceiveItem.setString(COL_STATUS, receiveItem.getStatus());
            dbReceiveItem.setDouble(COL_AMOUNT, receiveItem.getAmount());
            dbReceiveItem.setDouble(COL_TOTAL_AMOUNT, receiveItem.getTotalAmount());
            dbReceiveItem.setDouble(COL_TOTAL_DISCOUNT, receiveItem.getTotalDiscount());
            dbReceiveItem.setDate(COL_DELIVERY_DATE, receiveItem.getDeliveryDate());
            dbReceiveItem.setLong(COL_PURCHASE_ITEM_ID, receiveItem.getPurchaseItemId());
            dbReceiveItem.setDate(COL_EXPIRED_DATE, receiveItem.getExpiredDate());
            dbReceiveItem.setLong(COL_AP_COA_ID, receiveItem.getApCoaId());
            dbReceiveItem.setInt(COL_TYPE, receiveItem.getType());
            dbReceiveItem.setInt(COL_IS_BONUS, receiveItem.getIsBonus());
            dbReceiveItem.setString(COL_MEMO, receiveItem.getMemo());
            dbReceiveItem.setDouble(COL_PRICE_IMPORT, receiveItem.getPriceImport());
            dbReceiveItem.setDouble(COL_TRANSPORT, receiveItem.getTransport());
            dbReceiveItem.setDouble(COL_BEA, receiveItem.getBea());
            dbReceiveItem.setDouble(COL_KOMISI, receiveItem.getKomisi());
            dbReceiveItem.setDouble(COL_LAIN_LAIN, receiveItem.getLainLain());
            dbReceiveItem.setLong(COL_UOM_PURCHASE_ID, receiveItem.getUomPurchaseId());
            dbReceiveItem.setDouble(COL_QTY_PURCHASE, receiveItem.getQtyPurchase());
            dbReceiveItem.setDouble(COL_DIS_1_PERCENT, receiveItem.getDis1Percent());
            dbReceiveItem.setDouble(COL_DIS_1_VAL, receiveItem.getDis1Val());
            dbReceiveItem.setDouble(COL_DIS_2_PERCENT, receiveItem.getDis2Percent());
            dbReceiveItem.setDouble(COL_DIS_2_VAL, receiveItem.getDis2Val());
            dbReceiveItem.setDouble(COL_DIS_3_PERCENT, receiveItem.getDis3Percent());
            dbReceiveItem.setDouble(COL_DIS_3_VAL, receiveItem.getDis3Val());
            dbReceiveItem.setDouble(COL_DIS_4_PERCENT , receiveItem.getDis4Percent());
            dbReceiveItem.setDouble(COL_DIS_4_VAL, receiveItem.getDis4Val());
            dbReceiveItem.setString(COL_BATCH_NUMBER, receiveItem.getBatchNumber());
            dbReceiveItem.insert();
            receiveItem.setOID(dbReceiveItem.getlong(0));
        }
        catch (CONException dbe) {
            throw dbe;
        }
        catch (Exception e) {
            throw new CONException((CONHandler)new DbReceiveItem(0), 1);
        }
        return receiveItem.getOID();
    }

    public static long updateExc(ReceiveItem receiveItem) throws CONException {
        try {
            if (receiveItem.getOID() != 0L) {
                DbReceiveItem dbReceiveItem = new DbReceiveItem(receiveItem.getOID());
                dbReceiveItem.setLong(COL_RECEIVE_ID, receiveItem.getReceiveId());
                dbReceiveItem.setLong(COL_ITEM_MASTER_ID, receiveItem.getItemMasterId());
                dbReceiveItem.setDouble(COL_QTY, receiveItem.getQty());
                dbReceiveItem.setLong(COL_UOM_ID, receiveItem.getUomId());
                dbReceiveItem.setString(COL_STATUS, receiveItem.getStatus());
                dbReceiveItem.setDouble(COL_AMOUNT, receiveItem.getAmount());
                dbReceiveItem.setDouble(COL_TOTAL_AMOUNT, receiveItem.getTotalAmount());
                dbReceiveItem.setDouble(COL_TOTAL_DISCOUNT, receiveItem.getTotalDiscount());
                dbReceiveItem.setDate(COL_DELIVERY_DATE, receiveItem.getDeliveryDate());
                dbReceiveItem.setLong(COL_PURCHASE_ITEM_ID, receiveItem.getPurchaseItemId());
                dbReceiveItem.setDate(COL_EXPIRED_DATE, receiveItem.getExpiredDate());
                dbReceiveItem.setLong(COL_AP_COA_ID, receiveItem.getApCoaId());
                dbReceiveItem.setInt(COL_TYPE, receiveItem.getType());
                dbReceiveItem.setInt(COL_IS_BONUS, receiveItem.getIsBonus());
                dbReceiveItem.setString(COL_MEMO, receiveItem.getMemo());
                dbReceiveItem.setDouble(COL_PRICE_IMPORT, receiveItem.getPriceImport());
                dbReceiveItem.setDouble(COL_TRANSPORT, receiveItem.getTransport());
                dbReceiveItem.setDouble(COL_BEA, receiveItem.getBea());
                dbReceiveItem.setDouble(COL_KOMISI, receiveItem.getKomisi());
                dbReceiveItem.setDouble(COL_LAIN_LAIN, receiveItem.getLainLain());
                dbReceiveItem.setLong(COL_UOM_PURCHASE_ID, receiveItem.getUomPurchaseId());
                dbReceiveItem.setDouble(COL_QTY_PURCHASE, receiveItem.getQtyPurchase());
                dbReceiveItem.setDouble(COL_DIS_1_PERCENT, receiveItem.getDis1Percent());
                dbReceiveItem.setDouble(COL_DIS_1_VAL, receiveItem.getDis1Val());
                dbReceiveItem.setDouble(COL_DIS_2_PERCENT, receiveItem.getDis2Percent());
                dbReceiveItem.setDouble(COL_DIS_2_VAL, receiveItem.getDis2Val());
                dbReceiveItem.setDouble(COL_DIS_3_PERCENT, receiveItem.getDis3Percent());
                dbReceiveItem.setDouble(COL_DIS_3_VAL, receiveItem.getDis3Val());
                dbReceiveItem.setDouble(COL_DIS_4_PERCENT , receiveItem.getDis4Percent());
                dbReceiveItem.setDouble(COL_DIS_4_VAL, receiveItem.getDis4Val());
                dbReceiveItem.setString(COL_BATCH_NUMBER, receiveItem.getBatchNumber());
                dbReceiveItem.update();
                return receiveItem.getOID();
            }
        }
        catch (CONException dbe) {
            throw dbe;
        }
        catch (Exception e) {
            throw new CONException((CONHandler)new DbReceiveItem(0), 1);
        }
        return 0L;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbReceiveItem dbReceiveItem = new DbReceiveItem(oid);
            dbReceiveItem.delete();
        }
        catch (CONException dbe) {
            throw dbe;
        }
        catch (Exception e) {
            throw new CONException((CONHandler)new DbReceiveItem(0), 1);
        }
        return oid;
    }

    public static long deleteAllItem(long oidMain) throws CONException {
        try {
            String sql = "DELETE FROM pos_receive_item WHERE " + DbReceiveItem.colNames[COL_RECEIVE_ID] + "=" + oidMain;
            CONHandler.execUpdate(sql);
        }
        catch (CONException dbe) {
            throw dbe;
        }
        catch (Exception e) {
            throw new CONException((CONHandler)new DbReceiveItem(0), 1);
        }
        return oidMain;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM pos_receive_item";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql += "";
            }
            else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ReceiveItem receiveItem = new ReceiveItem();
                resultToObject(rs, receiveItem);
                lists.add(receiveItem);
            }
            rs.close();
            return lists;
        }
        catch (Exception e) {
            System.out.println(e);
        }
        finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector list(String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM pos_receive_item";
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                ReceiveItem receiveItem = new ReceiveItem();
                resultToObjectx(rs, receiveItem);
                lists.add(receiveItem);
            }
            rs.close();
            return lists;
        }
        catch (Exception e) {
            System.out.println(e);
        }
        finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, ReceiveItem receiveItem) {
        try {
            receiveItem.setOID(rs.getLong(DbReceiveItem.colNames[COL_RECEIVE_ITEM_ID]));
            receiveItem.setReceiveId(rs.getLong(DbReceiveItem.colNames[COL_RECEIVE_ID]));
            receiveItem.setItemMasterId(rs.getLong(DbReceiveItem.colNames[COL_ITEM_MASTER_ID]));
            receiveItem.setQty(rs.getDouble(DbReceiveItem.colNames[COL_QTY]));
            receiveItem.setUomId(rs.getLong(DbReceiveItem.colNames[COL_UOM_ID]));
            receiveItem.setStatus(rs.getString(DbReceiveItem.colNames[COL_STATUS]));
            receiveItem.setAmount(rs.getDouble(DbReceiveItem.colNames[COL_AMOUNT]));
            receiveItem.setTotalAmount(rs.getDouble(DbReceiveItem.colNames[COL_TOTAL_AMOUNT]));
            receiveItem.setTotalDiscount(rs.getDouble(DbReceiveItem.colNames[COL_TOTAL_DISCOUNT]));
            receiveItem.setDeliveryDate((Date)rs.getDate(DbReceiveItem.colNames[COL_DELIVERY_DATE]));
            receiveItem.setPurchaseItemId(rs.getLong(DbReceiveItem.colNames[COL_PURCHASE_ITEM_ID]));
            receiveItem.setExpiredDate((Date)rs.getDate(DbReceiveItem.colNames[COL_EXPIRED_DATE]));
            receiveItem.setApCoaId(rs.getLong(DbReceiveItem.colNames[COL_AP_COA_ID]));
            receiveItem.setType(rs.getInt(DbReceiveItem.colNames[COL_TYPE]));
            receiveItem.setIsBonus(rs.getInt(DbReceiveItem.colNames[COL_IS_BONUS]));
            receiveItem.setMemo(rs.getString(DbReceiveItem.colNames[COL_MEMO]));
            receiveItem.setPriceImport(rs.getDouble(DbReceiveItem.colNames[COL_PRICE_IMPORT]));
            receiveItem.setTransport(rs.getDouble(DbReceiveItem.colNames[COL_TRANSPORT]));
            receiveItem.setBea(rs.getDouble(DbReceiveItem.colNames[COL_BEA]));
            receiveItem.setKomisi(rs.getDouble(DbReceiveItem.colNames[COL_KOMISI]));
            receiveItem.setLainLain(rs.getDouble(DbReceiveItem.colNames[COL_LAIN_LAIN]));
            receiveItem.setUomPurchaseId(rs.getLong(DbReceiveItem.colNames[COL_UOM_PURCHASE_ID]));
            receiveItem.setQtyPurchase(rs.getDouble(DbReceiveItem.colNames[COL_QTY_PURCHASE]));
            receiveItem.setDis1Percent(rs.getDouble(DbReceiveItem.colNames[COL_DIS_1_PERCENT]));
            receiveItem.setDis1Val(rs.getDouble(DbReceiveItem.colNames[COL_DIS_1_VAL]));
            receiveItem.setDis2Percent(rs.getDouble(DbReceiveItem.colNames[COL_DIS_2_PERCENT]));
            receiveItem.setDis2Val(rs.getDouble(DbReceiveItem.colNames[COL_DIS_2_VAL]));
            receiveItem.setDis3Percent(rs.getDouble(DbReceiveItem.colNames[COL_DIS_3_PERCENT]));
            receiveItem.setDis3Val(rs.getDouble(DbReceiveItem.colNames[COL_DIS_3_VAL]));
            receiveItem.setDis4Percent(rs.getDouble(DbReceiveItem.colNames[COL_DIS_4_PERCENT]));
            receiveItem.setDis4Val(rs.getDouble(DbReceiveItem.colNames[COL_DIS_4_VAL]));
            receiveItem.setBatchNumber(rs.getString(DbReceiveItem.colNames[COL_BATCH_NUMBER]));
        }
        catch (Exception ex) {}
    }

    public static void resultToObjectx(ResultSet rs, ReceiveItem receiveItem) {
        try {
            receiveItem.setOID(rs.getLong(DbReceiveItem.colNames[COL_RECEIVE_ITEM_ID]));
            receiveItem.setReceiveId(rs.getLong(DbReceiveItem.colNames[COL_RECEIVE_ID]));
            receiveItem.setItemMasterId(rs.getLong(DbReceiveItem.colNames[COL_ITEM_MASTER_ID]));
            receiveItem.setQty(rs.getDouble(DbReceiveItem.colNames[COL_QTY]));
            receiveItem.setUomId(rs.getLong(DbReceiveItem.colNames[COL_UOM_ID]));
            receiveItem.setStatus(rs.getString(DbReceiveItem.colNames[COL_STATUS]));
            double amount = rs.getDouble(DbReceiveItem.colNames[COL_AMOUNT]);
            if (amount != 0.0) {
                receiveItem.setAmount(-1.0 * rs.getDouble(DbReceiveItem.colNames[COL_AMOUNT]));
                receiveItem.setTotalAmount(-1.0 * rs.getDouble(DbReceiveItem.colNames[COL_TOTAL_AMOUNT]));
            }
            receiveItem.setTotalDiscount(rs.getDouble(DbReceiveItem.colNames[COL_TOTAL_DISCOUNT]));
            receiveItem.setDeliveryDate((Date)rs.getDate(DbReceiveItem.colNames[COL_DELIVERY_DATE]));
            receiveItem.setPurchaseItemId(rs.getLong(DbReceiveItem.colNames[COL_PURCHASE_ITEM_ID]));
            receiveItem.setExpiredDate((Date)rs.getDate(DbReceiveItem.colNames[COL_EXPIRED_DATE]));
            receiveItem.setApCoaId(rs.getLong(DbReceiveItem.colNames[COL_AP_COA_ID]));
            receiveItem.setType(rs.getInt(DbReceiveItem.colNames[COL_TYPE]));
            receiveItem.setIsBonus(rs.getInt(DbReceiveItem.colNames[COL_IS_BONUS]));
            receiveItem.setMemo(rs.getString(DbReceiveItem.colNames[COL_MEMO]));
            receiveItem.setPriceImport(rs.getDouble(DbReceiveItem.colNames[COL_PRICE_IMPORT]));
            receiveItem.setTransport(rs.getDouble(DbReceiveItem.colNames[COL_TRANSPORT]));
            receiveItem.setBea(rs.getDouble(DbReceiveItem.colNames[COL_BEA]));
            receiveItem.setKomisi(rs.getDouble(DbReceiveItem.colNames[COL_KOMISI]));
            receiveItem.setLainLain(rs.getDouble(DbReceiveItem.colNames[COL_LAIN_LAIN]));
            receiveItem.setUomPurchaseId(rs.getLong(DbReceiveItem.colNames[COL_UOM_PURCHASE_ID]));
            receiveItem.setQtyPurchase(rs.getDouble(DbReceiveItem.colNames[COL_QTY_PURCHASE]));
        }
        catch (Exception ex) {}
    }

    public static boolean checkOID(long receiveItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM pos_receive_item WHERE " + DbReceiveItem.colNames[COL_RECEIVE_ITEM_ID] + " = " + receiveItemId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = true;
            }
            rs.close();
        }
        catch (Exception e) {
            System.out.println("err : " + e.toString());
        }
        finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbReceiveItem.colNames[COL_RECEIVE_ID] + ") FROM " + "pos_receive_item";
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
        }
        catch (Exception e) {
            return 0;
        }
        finally {
            CONResultSet.close(dbrs);
        }
    }

    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; i < size && !found; i += recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ++ls) {
                    ReceiveItem receiveItem = (ReceiveItem) list.get(ls);
                    if (oid == receiveItem.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if (start >= size && size > 0) {
            start -= recordToGet;
        }
        return start;
    }

    public static double getTotalReceiveAmount(long poOID) {
        double result = 0.0;
        CONResultSet crs = null;
        try {
            String sql = " select sum(" + DbReceiveItem.colNames[COL_TOTAL_AMOUNT] + ") from " + "pos_receive_item" + " where " + DbReceiveItem.colNames[COL_IS_BONUS] + " <>1 and " + DbReceiveItem.colNames[COL_RECEIVE_ID] + "=" + poOID;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        }
        catch (Exception e) {}
        finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static double getTotalRecAmount(long poOID) {
        double result = 0.0;
        CONResultSet crs = null;
        try {
            String sql = " select sum(" + DbReceiveItem.colNames[COL_TOTAL_AMOUNT] + ") from " + "pos_receive_item" + " where " + DbReceiveItem.colNames[COL_RECEIVE_ID] + "=" + poOID;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
                if (result != 0.0) {
                    result *= -1.0;
                }
            }
        }
        catch (Exception e) {}
        finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static void deleteByReceiveId(long receiveId) {
        try {
            CONHandler.execUpdate("delete from pos_receive_item where " + DbReceiveItem.colNames[COL_RECEIVE_ID] + "=" + receiveId);
        }
        catch (Exception ex) {}
    }

    public static int insertByItem(long oidReceive, long itemMasterId, long prItemId, double qty, double amount, double discout, double totAmount, long uomId, Date expDate) {
        if (oidReceive == 0L || itemMasterId == 0L || prItemId == 0L || qty == 0.0) {
            return -1;
        }
        try {
            ReceiveItem ri = new ReceiveItem();
            ri.setAmount(amount);
            ri.setItemMasterId(itemMasterId);
            ri.setPurchaseItemId(prItemId);
            ri.setQty(qty);
            ri.setReceiveId(oidReceive);
            ri.setTotalAmount(totAmount);
            ri.setTotalDiscount(discout);
            ri.setUomId(uomId);
            ri.setDeliveryDate(new Date());
            ri.setExpiredDate(expDate);
            insertExc(ri);
        }
        catch (Exception ex) {}
        return 0;
    }

    public static int insertByItem(long oidReceive, long itemMasterId, long prItemId, double qty, double amount, double discout, double totAmount, long uomId) {
        if (oidReceive == 0L || itemMasterId == 0L || prItemId == 0L || qty == 0.0) {
            return -1;
        }
        try {
            ReceiveItem ri = new ReceiveItem();
            ri.setAmount(amount);
            ri.setItemMasterId(itemMasterId);
            ri.setPurchaseItemId(prItemId);
            ri.setQty(qty);
            ri.setReceiveId(oidReceive);
            ri.setTotalAmount(totAmount);
            ri.setTotalDiscount(discout);
            ri.setUomId(uomId);
            ri.setDeliveryDate(new Date());
            insertExc(ri);
        }
        catch (Exception ex) {}
        return 0;
    }

    public static double getTotalQtyRec(long prItemId) {
        String sql = "select sum(" + DbReceiveItem.colNames[COL_QTY] + ") from " + "pos_receive_item" + " where " + DbReceiveItem.colNames[COL_PURCHASE_ITEM_ID] + "=" + prItemId;
        double result = 0.0;
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }
        }
        catch (Exception e) {}
        finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static ReceiveItem getReceiveItem(long prItemId, long oidReceive) {
        String where = DbReceiveItem.colNames[COL_PURCHASE_ITEM_ID] + "=" + prItemId + " and " + DbReceiveItem.colNames[COL_RECEIVE_ID] + "=" + oidReceive;
        Vector v = list(0, 0, where, "");
        if (v != null && v.size() > 0) {
            return (ReceiveItem) v.get(0);
        }
        return new ReceiveItem();
    }

    public static void proceedStock(Receive receive) {
        Vector temp = list(0, 0, DbReceiveItem.colNames[COL_RECEIVE_ID] + "=" + receive.getOID(), "");
        if (temp != null && temp.size() > 0) {
            int stockType = Integer.parseInt(DbSystemProperty.getValueByName("STOCK_MANAGEMENT_TYPE"));
            int cogsType = 0;
            try {
                cogsType = Integer.parseInt(DbSystemProperty.getValueByName("COGS_TYPE"));
            }
            catch (Exception e) {
                cogsType = 0;
            }
            long oidx = SessReceiveJournal.journalCleareance(receive.getOID());
            if (oidx == 0L) {
                LogUser logUser = new LogUser();
                logUser.setDate(new Date());
                logUser.setDescription("Error insert : " + receive.getOID() + "/" + receive.getNumber());
                logUser.setUserId(receive.getApproval1());
                logUser.setRefId(receive.getOID());
                logUser.setType(0);
                try {
                    DbLogUser.insertExc(logUser);
                }
                catch (Exception ex) {}
            }
            for (int i = 0; i < temp.size(); ++i) {
                ReceiveItem ri = (ReceiveItem) temp.get(i);
                ItemMaster im = new ItemMaster();
                try {
                    im = DbItemMaster.fetchExc(ri.getItemMasterId());
                    long oid = insertReceiveGoods2(receive, ri, im);
                    if (im.getNeedRecipe() == 0) {
                        if (receive.getType() == DbReceive.TYPE_NON_CONSIGMENT) {
                            if (stockType == 0) {
                                if (cogsType == 0) {
                                    updateItemAverageCost(ri, receive, im);
                                }
                                else if (cogsType == 1) {
                                    updateItemAvgSumIncoming(receive, ri, im);
                                }
                            }
                            else if (stockType == 1) {
                                updateItemLastPriceCost(ri);
                            }
                        }
                        else if (receive.getType() == DbReceive.TYPE_CONSIGMENT) {
                            if (stockType == 0) {
                                updateItemAverageCostConsigment(ri);
                            }
                            else if (stockType == 1) {
                                updateItemLastPriceCostConsigment(ri);
                            }
                        }
                    }
                }
                catch (Exception ex2) {}
            }
        }
    }

    public static long insertReceiveGoods(Receive rec, ReceiveItem ri, ItemMaster im) {
        long oid = 0L;
        try {
            if (rec.getTypeAp() != DbReceive.TYPE_AP_REC_ADJ_BY_PRICE && im.getNeedRecipe() == 0) {
                Stock stock = new Stock();
                stock.setIncomingId(ri.getReceiveId());
                stock.setInOut(DbStock.STOCK_IN);
                stock.setItemBarcode(im.getBarcode());
                stock.setItemCode(im.getCode());
                stock.setItemMasterId(im.getOID());
                stock.setItemName(im.getName());
                stock.setLocationId(rec.getLocationId());
                stock.setDate(rec.getApproval1Date());
                stock.setNoFaktur(rec.getDoNumber());
                stock.setPrice(ri.getTotalAmount() / ri.getQty());
                stock.setTotal(ri.getTotalAmount());
                stock.setQty(ri.getQty() * im.getUomPurchaseStockQty());
                if (rec.getTypeAp() == DbReceive.TYPE_AP_REC_ADJ_BY_QTY) {
                    stock.setType(DbStock.TYPE_REC_ADJ);
                }
                else {
                    stock.setType(DbStock.TYPE_INCOMING_GOODS);
                }
                stock.setUnitId(im.getUomStockId());
                stock.setUserId(rec.getUserId());
                stock.setType_item(rec.getType());
                stock.setReceive_item_id(ri.getOID());
                stock.setStatus(rec.getStatus());
                oid = DbStock.insertExc(stock);
            }
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
        return oid;
    }

    public static long insertReceiveGoods2(Receive rec, ReceiveItem ri, ItemMaster im) {
        long oid = 0L;
        try {
            if (rec.getTypeAp() != DbReceive.TYPE_AP_REC_ADJ_BY_PRICE && im.getNeedRecipe() == 0) {
                Stock stock = new Stock();
                stock.setIncomingId(ri.getReceiveId());
                stock.setInOut(DbStock.STOCK_IN);
                stock.setItemBarcode(im.getBarcode());
                stock.setItemCode(im.getCode());
                stock.setItemMasterId(im.getOID());
                stock.setItemName(im.getName());
                stock.setLocationId(rec.getLocationId());
                stock.setDate(rec.getApproval1Date());
                stock.setNoFaktur(rec.getDoNumber());
                stock.setPrice(ri.getTotalAmount() / (ri.getQty() * ri.getQtyPurchase()));
                stock.setTotal(ri.getTotalAmount() / ri.getQtyPurchase());
                stock.setQty(ri.getQty() * ri.getQtyPurchase());
                if (rec.getTypeAp() == DbReceive.TYPE_AP_REC_ADJ_BY_QTY) {
                    stock.setType(DbStock.TYPE_REC_ADJ);
                }
                else {
                    stock.setType(DbStock.TYPE_INCOMING_GOODS);
                }
                stock.setUnitId(im.getUomStockId());
                stock.setUserId(rec.getUserId());
                stock.setType_item(rec.getType());
                stock.setReceive_item_id(ri.getOID());
                stock.setStatus(rec.getStatus());
                oid = DbStock.insertExc(stock);
            }
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
        return oid;
    }

    public static void checkRequestTransfer(long item_master_id, long location_id, ItemMaster im) {
        if (im.getIsAutoOrder() == 1) {
            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(location_id);
            }
            catch (Exception ex) {}
            if (loc.getAktifAutoOrder() == 1 && im.getIsActive() == 1 && im.getNeedRecipe() == 0) {
                double minStock = DbStockMin.getStockMinValue(location_id, item_master_id);
                try {
                    DbOrder.deleteOrder(item_master_id, location_id);
                }
                catch (Exception ex2) {}
                if (minStock > 0.0) {
                    double totalStock = DbStock.getItemTotalStock(location_id, item_master_id);
                    if (totalStock < 0.0) {
                        totalStock = 0.0;
                    }
                    double totalPoPrev = DbStock.getTotalPo(location_id, item_master_id);
                    double totalRequest = DbOrder.getTotalOrder(location_id, item_master_id);
                    double totalTransferDraft = DbStock.getTotalTransfer(location_id, item_master_id);
                    if (totalStock + totalRequest + totalTransferDraft <= minStock - im.getDeliveryUnit()) {
                        double qtyRequest = (minStock - (totalRequest + totalStock + totalTransferDraft)) / im.getDeliveryUnit();
                        qtyRequest = Math.floor(qtyRequest) * im.getDeliveryUnit();
                        if (totalRequest > 0.0) {
                            Vector vOrder = DbOrder.list(0, 0, "im." + DbOrder.colNames[COL_QTY] + "=" + item_master_id + " and ao." + DbOrder.colNames[COL_ITEM_MASTER_ID] + "=" + location_id + " and ao." + DbOrder.colNames[9] + "='DRAFT'", "");
                            if (vOrder != null && vOrder.size() > 0) {
                                Order odrPrev = (Order) vOrder.get(0);
                                try {
                                    odrPrev.setQtyOrder(qtyRequest);
                                    odrPrev.setQtyStock(totalStock);
                                    DbOrder.updateExc(odrPrev);
                                }
                                catch (Exception ex3) {}
                            }
                        }
                        else {
                            try {
                                int nextCounter = DbOrder.getNextCounter();
                                Order order = new Order();
                                order.setCounter(nextCounter);
                                order.setPrefixNumber(DbOrder.getNumberPrefix());
                                order.setNumber(DbOrder.getNextNumber(nextCounter));
                                order.setQtyOrder(qtyRequest);
                                order.setDate(new Date());
                                order.setQtyStock(totalStock + totalRequest);
                                order.setQtyPoPrev(totalPoPrev);
                                order.setQtyStandar(minStock);
                                order.setLocationId(location_id);
                                order.setItemMasterId(item_master_id);
                                order.setStatus("DRAFT");
                                DbOrder.insertExc(order);
                            }
                            catch (Exception ex4) {}
                        }
                    }
                    else if (totalStock + totalTransferDraft >= minStock - im.getDeliveryUnit()) {
                        Vector vOrder2 = DbOrder.list(0, 0, "im." + DbOrder.colNames[COL_QTY] + "=" + item_master_id + " and ao." + DbOrder.colNames[COL_ITEM_MASTER_ID] + "=" + location_id + " and ao." + DbOrder.colNames[9] + "='DRAFT'", "");
                        if (vOrder2 != null && vOrder2.size() > 0) {
                            Order odrPrev2 = (Order) vOrder2.get(0);
                            try {
                                odrPrev2.setStatus("APPROVED");
                                DbOrder.updateExc(odrPrev2);
                            }
                            catch (Exception ex5) {}
                        }
                    }
                    else if (totalRequest != 0.0) {
                        Vector vOrder2 = DbOrder.list(0, 0, "im." + DbOrder.colNames[COL_QTY] + "=" + item_master_id + " and ao." + DbOrder.colNames[COL_ITEM_MASTER_ID] + "=" + location_id + " and ao." + DbOrder.colNames[9] + "='DRAFT'", "");
                        if (vOrder2 != null && vOrder2.size() > 0) {
                            Order odrPrev2 = (Order) vOrder2.get(0);
                            try {
                                if (odrPrev2.getQtyPoPrev() != totalPoPrev || odrPrev2.getQtyStandar() != minStock) {
                                    double qtyRequest2 = (minStock - (totalRequest + totalStock + totalTransferDraft)) / im.getDeliveryUnit();
                                    qtyRequest2 = Math.floor(qtyRequest2) * im.getDeliveryUnit();
                                    if (qtyRequest2 > 0.0) {
                                        odrPrev2.setQtyPoPrev(totalPoPrev);
                                        odrPrev2.setQtyOrder(qtyRequest2);
                                        odrPrev2.setQtyStock(totalStock);
                                        odrPrev2.setQtyStandar(minStock);
                                        odrPrev2.setDate(new Date());
                                        DbOrder.updateExc(odrPrev2);
                                    }
                                }
                            }
                            catch (Exception ex6) {}
                        }
                    }
                }
            }
        }
    }

    public static void updateCogs(Receive receive) {
        Vector temp = list(0, 0, DbReceiveItem.colNames[COL_RECEIVE_ID] + "=" + receive.getOID(), "");
        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); ++i) {
                ReceiveItem ri = (ReceiveItem) temp.get(i);
                ItemMaster im = new ItemMaster();
                try {
                    im = DbItemMaster.fetchExc(ri.getItemMasterId());
                }
                catch (Exception ex) {}
                if (im.getNeedRecipe() == 0) {
                    int stockType = Integer.parseInt(DbSystemProperty.getValueByName("STOCK_MANAGEMENT_TYPE"));
                    int cogsType = 0;
                    try {
                        cogsType = Integer.parseInt(DbSystemProperty.getValueByName("COGS_TYPE"));
                    }
                    catch (Exception e) {
                        cogsType = 0;
                    }
                    if (receive.getType() == DbReceive.TYPE_NON_CONSIGMENT) {
                        if (stockType == 0) {
                            if (cogsType == 0) {
                                updateItemAverageCost(ri, receive);
                            }
                            else if (cogsType == 1) {
                                updateItemAvgSumIncoming(receive, ri, im);
                            }
                        }
                        else if (stockType == 1) {
                            updateItemLastPriceCost(ri);
                        }
                    }
                    if (receive.getType() == DbReceive.TYPE_CONSIGMENT) {
                        if (stockType == 0) {
                            updateItemAverageCostConsigment(ri);
                        }
                        else if (stockType == 1) {
                            updateItemLastPriceCostConsigment(ri);
                        }
                    }
                }
            }
        }
    }

    public static void updateItemAverageCost(ReceiveItem ri, Receive re) {
        ItemMaster im = new ItemMaster();
        try {
            im = DbItemMaster.fetchExc(ri.getItemMasterId());
            double totalStock = SessStock.getItemTotalStock(im.getOID());
            if (re.getDiscountPercent() != 0.0) {
                ri.setTotalAmount(ri.getTotalAmount() - re.getDiscountPercent() * ri.getTotalAmount() / 100.0);
            }
            double totalCost = totalStock * im.getCogs() + ri.getTotalAmount();
            if (re.getTypeAp() != DbReceive.TYPE_AP_REC_ADJ_BY_PRICE) {
                totalStock += ri.getQty() * im.getUomPurchaseStockQty();
            }
            if (totalStock > 0.0) {
                im.setCogs(totalCost / totalStock);
                DbItemMaster.updateExc(im);
            }
            else {
                im.setCogs(ri.getAmount() / (ri.getQty() * im.getUomPurchaseStockQty()));
                DbItemMaster.updateExc(im);
            }
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static void updateItemAverageCost(ReceiveItem ri, Receive re, ItemMaster im) {
        try {
            double totalStock = 0.0;
            double stockAdd = 0.0;
            if (re.getTypeAp() == DbReceive.TYPE_AP_REC_ADJ_BY_PRICE) {
                totalStock = DbStock.getItemTotalStock(im.getOID());
            }
            else {
                totalStock = DbStock.getItemTotalStock(im.getOID()) - ri.getQty() * ri.getQtyPurchase();
                stockAdd = ri.getQty() * ri.getQtyPurchase();
            }
            double amount = ri.getTotalAmount();
            if (re.getPriceIncludeTax() == 1) {
                amount = ri.getTotalAmount() * 100.0 / 110.0;
            }
            if (re.getDiscountPercent() != 0.0) {
                amount -= re.getDiscountPercent() * amount / 100.0;
                ri.setTotalAmount(amount);
            }
            double totalCost = totalStock * im.getCogs() + amount;
            long oid = 0L;
            if (totalStock <= 0.0) {
                im.setCogs(amount / (ri.getQty() * ri.getQtyPurchase()));
                oid = DbItemMaster.updateExc(im);
            }
            else if (totalStock + stockAdd > 0.0) {
                im.setCogs(totalCost / (totalStock + stockAdd));
                oid = DbItemMaster.updateExc(im);
            }
            else {
                im.setCogs(amount / (ri.getQty() * ri.getQtyPurchase()));
                oid = DbItemMaster.updateExc(im);
            }
            if (oid != 0L) {
                String memo = "Perhitungan System Moving Average, incoming : " + re.getNumber() + ",Qty : " + JSPFormater.formatNumber(ri.getQty() * ri.getQtyPurchase(), "###,###.##") + ", harga :" + JSPFormater.formatNumber(ri.getAmount(), "###,###.##") + ". Total value Keseluruhan : " + JSPFormater.formatNumber(totalCost, "###,###.##") + " dan qty keseluruhan : " + JSPFormater.formatNumber(totalStock + stockAdd, "###,###.##") + ", cogs : " + JSPFormater.formatNumber(im.getCogs(), "###,###.##");
                HistoryUser hisUser = new HistoryUser();
                hisUser.setUserId(0L);
                hisUser.setEmployeeId(0L);
                hisUser.setRefId(im.getOID());
                hisUser.setDescription(memo);
                hisUser.setType(3);
                hisUser.setDate(new Date());
                try {
                    DbHistoryUser.insertExc(hisUser);
                }
                catch (Exception ex) {}
            }
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static void updateItemAverageCostConsigment(ReceiveItem ri) {
        ItemMaster im = new ItemMaster();
        try {
            im = DbItemMaster.fetchExc(ri.getItemMasterId());
            double totalStock = DbStock.getItemTotalStockConsigment(im.getOID());
            double totalCost = totalStock * im.getCogs_consigment() + ri.getTotalAmount();
            totalStock += ri.getQty() * im.getUomPurchaseStockQty();
            im.setCogs_consigment(totalCost / totalStock);
            DbItemMaster.updateExc(im);
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static void updateItemAvgSumIncoming(Receive r, ReceiveItem ri, ItemMaster im) {
        CONResultSet dbrs = null;
        double cogs = 0.0;
        double total = 0.0;
        double qty = 0.0;
        String whereStr = "";
        String strDate = "";
        try {
            strDate = DbSystemProperty.getValueByName("DATE_START_CALC_COGS");
        }
        catch (Exception ex) {}
        if (strDate != null && !strDate.equalsIgnoreCase("Not initialized") && strDate.length() > 0) {
            whereStr = " and r.approval_1_date >= '" + strDate + " 00:00:00'";
        }
        try {
            String sql = "select sum(qty) as tot_qty,sum(cogs) as total from (  (select m.item_master_id as item_id,m.code as code,typex,m.name as name,sum(qty) as qty,sum(round(total_amount - (discount_percent*total_amount/100),2)) as cogs from  (select r.receive_id,r.type as typex,round(r.discount_total/sum(ri.total_amount)*100,2) as discount_percent from  ((select r.* from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where r.type_ap in (0) and r.status in ('APPROVED','CHECKED') " + whereStr + " and ri.item_master_id = " + im.getOID() + " group by r.receive_id )) r " + " inner join pos_receive_item ri on r.receive_id = ri.receive_id where r.type_ap in (0) and r.status in ('APPROVED','CHECKED') " + whereStr + " group by r.receive_id) rc inner join pos_receive_item ri on rc.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.item_master_id = " + im.getOID() + " group by ri.item_master_id) " + " union " + " (select m.item_master_id as item_id,m.code as code,typex,m.name,0 as qty,sum(round(total_amount - (discount_percent*total_amount/100),2)) as cogs from " + " (select r.receive_id,r.type as typex,round(r.discount_total/sum(ri.total_amount)*100,2) as discount_percent from " + " ((select r.* from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where r.type_ap in (4) and r.status in ('APPROVED','CHECKED') and r.approval_1_date <= '" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "' and ri.item_master_id = " + im.getOID() + " group by r.receive_id )) r " + " inner join pos_receive_item ri on r.receive_id = ri.receive_id where r.type_ap in (4) and r.status in ('APPROVED','CHECKED') " + whereStr + " group by r.receive_id) rc inner join pos_receive_item ri on rc.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.item_master_id = " + im.getOID() + " group by ri.item_master_id ) " + " union " + " (select m.item_master_id as item_id,m.code as code,typex,m.name,sum(qty) as qty,0 as cogs from " + " (select r.receive_id,r.type as typex,round(r.discount_total/sum(ri.total_amount)*100,2) as discount_percent from " + " ((select r.* from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where r.type_ap in (3) and r.status in ('APPROVED','CHECKED') " + whereStr + " and ri.item_master_id = " + im.getOID() + " group by r.receive_id )) r " + " inner join pos_receive_item ri on r.receive_id = ri.receive_id where r.type_ap in (3) and r.status in ('APPROVED','CHECKED') " + whereStr + " group by r.receive_id) rc inner join pos_receive_item ri on rc.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.item_master_id = " + im.getOID() + " group by ri.item_master_id ) " + " ) as x ";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                total = rs.getDouble("total");
                qty = rs.getDouble("tot_qty");
                if (qty != 0.0) {
                    cogs = total / qty;
                }
            }
            rs.close();
        }
        catch (Exception e) {
            System.out.println(e);
        }
        finally {
            CONResultSet.close(dbrs);
        }
        if (im.getCogs() != cogs && cogs != 0.0) {
            try {
                im.setCogs(cogs);
                DbItemMaster.updateExc(im);
                String memo = "Perhitungan System Rata-rata pembelian, incoming : " + r.getNumber() + ",Qty : " + JSPFormater.formatNumber(ri.getQty(), "###,###.##") + ", harga :" + JSPFormater.formatNumber(ri.getAmount(), "###,###.##") + ". Total Pembelian Kesluruhan : " + JSPFormater.formatNumber(total, "###,###.##") + " dan qty : " + JSPFormater.formatNumber(qty, "###,###.##") + ", cogs : " + JSPFormater.formatNumber(cogs, "###,###.##");
                HistoryUser hisUser = new HistoryUser();
                hisUser.setUserId(0L);
                hisUser.setEmployeeId(0L);
                hisUser.setRefId(im.getOID());
                hisUser.setDescription(memo);
                hisUser.setType(3);
                hisUser.setDate(new Date());
                try {
                    DbHistoryUser.insertExc(hisUser);
                }
                catch (Exception ex2) {}
            }
            catch (Exception ex3) {}
        }
    }

    public static void updateItemAverageSummaryIncoming(ReceiveItem ri, ItemMaster im) {
        try {
            double totalStock = DbStock.getItemTotalStockConsigment(im.getOID());
            double totalCost = totalStock * im.getCogs_consigment() + ri.getTotalAmount();
            totalStock += ri.getQty() * im.getUomPurchaseStockQty();
            im.setCogs_consigment(totalCost / totalStock);
            DbItemMaster.updateExc(im);
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static void updateItemLastPriceCost(ReceiveItem ri) {
        ItemMaster im = new ItemMaster();
        try {
            im = DbItemMaster.fetchExc(ri.getItemMasterId());
            double totalStock = ri.getQty();
            im.setCogs(ri.getTotalAmount() / totalStock);
            DbItemMaster.updateExc(im);
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static void updateItemLastPriceCostConsigment(ReceiveItem ri) {
        ItemMaster im = new ItemMaster();
        try {
            im = DbItemMaster.fetchExc(ri.getItemMasterId());
            double totalStock = ri.getQty();
            im.setCogs_consigment(ri.getTotalAmount() / totalStock);
            DbItemMaster.updateExc(im);
        }
        catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static void inesertReceiveItem(long receiveId, Vector vReceiveItem) {
        if (receiveId != 0L) {
            try {
                deleteAllItem(receiveId);
                double total = 0.0;
                if (vReceiveItem != null && vReceiveItem.size() > 0) {
                    for (int i = 0; i < vReceiveItem.size(); ++i) {
                        ReceiveItem ri = (ReceiveItem) vReceiveItem.get(i);
                        total += ri.getAmount();
                        ri.setReceiveId(receiveId);
                        long oid = insertExc(ri);
                        updateAmount(oid, ri.getAmount());
                    }
                }
                try {
                    Receive receive = DbReceive.fetchExc(receiveId);
                    total *= -1.0;
                    receive.setTotalAmount(total);
                    DbReceive.updateExc(receive);
                }
                catch (Exception ex) {}
            }
            catch (Exception e) {
                System.out.print(e);
            }
        }
    }

    public static void updateAmount(long receiveItemId, double amount) {
        CONResultSet dbrs = null;
        try {
            double x = amount * -1.0;
            String sql = "UPDATE pos_receive_item set " + DbReceiveItem.colNames[COL_AMOUNT] + " = " + x + "," + DbReceiveItem.colNames[COL_TOTAL_AMOUNT] + " = " + x + " where " + DbReceiveItem.colNames[COL_RECEIVE_ITEM_ID] + " = " + receiveItemId;
            CONHandler.execUpdate(sql);
        }
        catch (Exception e) {
            System.out.println("Exception");
        }
        finally {
            CONResultSet.close(dbrs);
        }
    }

    public static double getTotalAmount(long receiveId) {
        String sql = "select sum(" + DbReceiveItem.colNames[COL_AMOUNT] + ") from " + "pos_receive_item" + " where " + DbReceiveItem.colNames[COL_RECEIVE_ID] + "=" + receiveId;
        double result = 0.0;
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }
        }
        catch (Exception e) {}
        finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static Vector getTotalQty(long vendorId, long locationId, Date startDate, Date endDate) {
        CONResultSet dbrs = null;
        Vector vt = new Vector();
        try {
            String sql = "SELECT SUM(pi.qty) as qtypo  , SUM(ri.qty) as qtyrec FROM pos_purchase p LEFT JOIN pos_receive r  ON p.purchase_id=r.purchase_id inner join pos_purchase_item pi on p.purchase_id=pi.purchase_id  LEFT JOIN pos_receive_item ri ON pi.purchase_item_id=ri.purchase_item_id  where p.vendor_id=" + vendorId;
            if (locationId != 0L) {
                sql = sql + " and p.location_id=" + locationId;
            }
            sql = sql + " and to_days(p.purch_date) between to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                vt.add(rs.getDouble("qtypo"));
                vt.add(rs.getDouble("qtyrec"));
            }
            rs.close();
            return vt;
        }
        catch (Exception e) {
            return vt;
        }
        finally {
            CONResultSet.close(dbrs);
        }
    }

    public static Vector getDetailServiceLevel(long vendorId, long locationId, Date startDate, Date endDate) {
        CONResultSet dbrs = null;
        Vector vt = new Vector();
        try {
            String sql = "SELECT p.number as ponumber, r.number as recnumber, im.code, im.barcode,  im.name, pi.qty as qtypo, ri.qty as qtyrec, p.purch_date as tanggal  FROM pos_purchase p LEFT JOIN pos_receive r  ON p.purchase_id=r.purchase_id inner join pos_purchase_item pi on p.purchase_id=pi.purchase_id  LEFT JOIN pos_receive_item ri ON pi.purchase_item_id=ri.purchase_item_id  INNER JOIN pos_item_master im ON pi.item_master_id=im.item_master_id  where  p.vendor_id=" + vendorId;
            if (locationId != 0L) {
                sql = sql + " and p.location_id=" + locationId;
            }
            sql = sql + " and to_days(p.purch_date) between to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";
            sql += " order by p.purchase_id";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector vtdet = new Vector();
                vtdet.add(rs.getString("ponumber"));
                if (rs.getString("recnumber") != null) {
                    vtdet.add(rs.getString("recnumber"));
                }
                else {
                    vtdet.add("-");
                }
                vtdet.add(rs.getString("code"));
                vtdet.add(rs.getString("barcode"));
                vtdet.add(rs.getString("name"));
                vtdet.add(rs.getDouble("qtypo"));
                vtdet.add(rs.getDouble("qtyrec"));
                vtdet.add(rs.getDate("tanggal"));
                vt.add(vtdet);
            }
            rs.close();
            return vt;
        }
        catch (Exception e) {
            return vt;
        }
        finally {
            CONResultSet.close(dbrs);
        }
    }

    public static Vector getReceiveKomisi(String whereClause) {
        CONResultSet dbrs = null;
        Vector vt = new Vector();
        try {
            String sql = "SELECT sd.product_master_id, sum(sd.qty * sd.selling_price) as tot from pos_sales s inner join pos_sales_detail sd on s.sales_id=sd.sales_id where " + whereClause + " group by sd.product_master_id";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vector vtdet = new Vector();
                vtdet.add(rs.getString("product_master_id"));
                vtdet.add(rs.getString("tot"));
                vt.add(vtdet);
            }
            rs.close();
            return vt;
        }
        catch (Exception e) {
            return vt;
        }
        finally {
            CONResultSet.close(dbrs);
        }
    }

    public static int updateKomisi(Date start, Date end, long locationId, long itemId) {
        if (start == null || end == null || locationId == 0L || itemId == 0L) {
            return 0;
        }
        CONResultSet dbrs = null;
        try {
            String sql = "select sd.sales_detail_id as sd_id from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id  where sd.product_master_id = " + itemId + " and s.date between '" + JSPFormater.formatDate(start, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(end, "yyyy-MM-dd") + " 23:59:59' and s.location_id = " + locationId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long salesDetailId = rs.getLong("sd_id");
                if (salesDetailId != 0L) {
                    updateStatusKomisi(salesDetailId);
                }
            }
            rs.close();
        }
        catch (Exception e) {}
        finally {
            CONResultSet.close(dbrs);
        }
        return 1;
    }

    public static void updateStatusKomisi(long salesDetailId) {
        CONResultSet dbrs = null;
        try {
            String sql = "update pos_sales_detail set status_komisi=1 where sales_detail_id  = " + salesDetailId;
            CONHandler.execUpdate(sql);
        }
        catch (Exception e) {}
        finally {
            CONResultSet.close(dbrs);
        }
    }
}
