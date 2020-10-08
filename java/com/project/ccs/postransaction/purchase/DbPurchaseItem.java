/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.purchase;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

public class DbPurchaseItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PURCHASE_ITEM = "pos_purchase_item";
    public static final int COL_PURCHASE_ITEM_ID = 0;
    public static final int COL_PURCHASE_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_QTY = 3;
    public static final int COL_AMOUNT = 4;
    public static final int COL_TOTAL_AMOUNT = 5;
    public static final int COL_TOTAL_DISCOUNT = 6;
    public static final int COL_DELIVERY_DATE = 7;
    public static final int COL_UOM_ID = 8;
    public static final int COL_STATUS = 9;
    public static final int COL_LAST_DIS_PERCENT = 10;
    public static final int COL_REG_DIS_VAL = 11;
    public static final int COL_REG_DIS_PERCENT = 12;
    
    public static final String[] colNames = {
        "purchase_item_id",
        "purchase_id",
        "item_master_id",
        "qty",
        "amount", 
        "total_amount",
        "discount_amount",
        "delivery_date",
        "uom_id",
        "status",
        "last_dis_percent",
        "reg_dis_val",
        "reg_dis_percent"
    };
    
    public static final int[] fieldTypes = {
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
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT
    };

    public DbPurchaseItem() {
    }

    public DbPurchaseItem(int i) throws CONException {
        super(new DbPurchaseItem());
    }

    public DbPurchaseItem(String sOid) throws CONException {
        super(new DbPurchaseItem(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPurchaseItem(long lOid) throws CONException {
        super(new DbPurchaseItem(0));
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
        return DB_PURCHASE_ITEM;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPurchaseItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PurchaseItem purchaseItem = fetchExc(ent.getOID());
        ent = (Entity) purchaseItem;
        return purchaseItem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PurchaseItem) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PurchaseItem) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PurchaseItem fetchExc(long oid) throws CONException {
        try {
            PurchaseItem purchaseItem = new PurchaseItem();
            DbPurchaseItem dbPurchaseItem = new DbPurchaseItem(oid);
            purchaseItem.setOID(oid);

            purchaseItem.setPurchaseId(dbPurchaseItem.getlong(COL_PURCHASE_ID));
            purchaseItem.setItemMasterId(dbPurchaseItem.getlong(COL_ITEM_MASTER_ID));
            purchaseItem.setQty(dbPurchaseItem.getdouble(COL_QTY));
            purchaseItem.setUomId(dbPurchaseItem.getlong(COL_UOM_ID));
            purchaseItem.setStatus(dbPurchaseItem.getString(COL_STATUS));

            purchaseItem.setAmount(dbPurchaseItem.getdouble(COL_AMOUNT));
            purchaseItem.setTotalAmount(dbPurchaseItem.getdouble(COL_TOTAL_AMOUNT));
            purchaseItem.setTotalDiscount(dbPurchaseItem.getdouble(COL_TOTAL_DISCOUNT));
            purchaseItem.setDeliveryDate(dbPurchaseItem.getDate(COL_DELIVERY_DATE));
            
            
            purchaseItem.setRegDisVal(dbPurchaseItem.getdouble(COL_REG_DIS_VAL));
            purchaseItem.setRegDisPercent(dbPurchaseItem.getdouble(COL_REG_DIS_PERCENT));
            purchaseItem.setLastDisPercent(dbPurchaseItem.getdouble(COL_LAST_DIS_PERCENT));

            return purchaseItem;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseItem(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PurchaseItem purchaseItem) throws CONException {
        try {
            DbPurchaseItem dbPurchaseItem = new DbPurchaseItem(0);

            dbPurchaseItem.setLong(COL_PURCHASE_ID, purchaseItem.getPurchaseId());
            dbPurchaseItem.setLong(COL_ITEM_MASTER_ID, purchaseItem.getItemMasterId());
            dbPurchaseItem.setDouble(COL_QTY, purchaseItem.getQty());
            dbPurchaseItem.setLong(COL_UOM_ID, purchaseItem.getUomId());
            dbPurchaseItem.setString(COL_STATUS, purchaseItem.getStatus());

            dbPurchaseItem.setDouble(COL_AMOUNT, purchaseItem.getAmount());
            dbPurchaseItem.setDouble(COL_TOTAL_AMOUNT, purchaseItem.getTotalAmount());
            dbPurchaseItem.setDouble(COL_TOTAL_DISCOUNT, purchaseItem.getTotalDiscount());
            dbPurchaseItem.setDate(COL_DELIVERY_DATE, purchaseItem.getDeliveryDate());
            
            //dbPurchaseItem.setDouble(COL_LAST_DIS_VAL, purchaseItem.getLastDisVal());
            dbPurchaseItem.setDouble(COL_REG_DIS_VAL, purchaseItem.getRegDisVal());
            dbPurchaseItem.setDouble(COL_REG_DIS_PERCENT, purchaseItem.getRegDisPercent());
            dbPurchaseItem.setDouble(COL_LAST_DIS_PERCENT, purchaseItem.getLastDisPercent());
            dbPurchaseItem.insert();
            purchaseItem.setOID(dbPurchaseItem.getlong(COL_PURCHASE_ITEM_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseItem(0), CONException.UNKNOWN);
        }
        return purchaseItem.getOID();
    }

    public static long updateExc(PurchaseItem purchaseItem) throws CONException {
        try {
            if (purchaseItem.getOID() != 0) {
                DbPurchaseItem dbPurchaseItem = new DbPurchaseItem(purchaseItem.getOID());

                dbPurchaseItem.setLong(COL_PURCHASE_ID, purchaseItem.getPurchaseId());
                dbPurchaseItem.setLong(COL_ITEM_MASTER_ID, purchaseItem.getItemMasterId());
                dbPurchaseItem.setDouble(COL_QTY, purchaseItem.getQty());
                dbPurchaseItem.setLong(COL_UOM_ID, purchaseItem.getUomId());
                dbPurchaseItem.setString(COL_STATUS, purchaseItem.getStatus());

                dbPurchaseItem.setDouble(COL_AMOUNT, purchaseItem.getAmount());
                dbPurchaseItem.setDouble(COL_TOTAL_AMOUNT, purchaseItem.getTotalAmount());
                dbPurchaseItem.setDouble(COL_TOTAL_DISCOUNT, purchaseItem.getTotalDiscount());
                dbPurchaseItem.setDate(COL_DELIVERY_DATE, purchaseItem.getDeliveryDate());
                
                dbPurchaseItem.setDouble(COL_LAST_DIS_PERCENT, purchaseItem.getLastDisPercent());
                dbPurchaseItem.setDouble(COL_REG_DIS_VAL, purchaseItem.getRegDisVal());
                dbPurchaseItem.setDouble(COL_REG_DIS_PERCENT, purchaseItem.getRegDisPercent());

                dbPurchaseItem.update();
                return purchaseItem.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseItem(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPurchaseItem dbPurchaseItem = new DbPurchaseItem(oid);
            dbPurchaseItem.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseItem(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static long deleteAllItem(long oidMain) throws CONException {
        try {
            String sql = "DELETE FROM " + DB_PURCHASE_ITEM +
                    " WHERE " + colNames[COL_PURCHASE_ID] + "=" + oidMain;
            CONHandler.execUpdate(sql);
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseItem(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PURCHASE_ITEM;
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
                PurchaseItem purchaseItem = new PurchaseItem();
                resultToObject(rs, purchaseItem);
                lists.add(purchaseItem);
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

    public static void resultToObject(ResultSet rs, PurchaseItem purchaseItem) {
        try {
            purchaseItem.setOID(rs.getLong(DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ITEM_ID]));
            purchaseItem.setPurchaseId(rs.getLong(DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]));
            purchaseItem.setItemMasterId(rs.getLong(DbPurchaseItem.colNames[DbPurchaseItem.COL_ITEM_MASTER_ID]));
            purchaseItem.setQty(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_QTY]));
            purchaseItem.setUomId(rs.getLong(DbPurchaseItem.colNames[DbPurchaseItem.COL_UOM_ID]));
            purchaseItem.setStatus(rs.getString(DbPurchaseItem.colNames[DbPurchaseItem.COL_STATUS]));

            purchaseItem.setAmount(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_AMOUNT]));
            purchaseItem.setTotalAmount(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_TOTAL_AMOUNT]));
            purchaseItem.setTotalDiscount(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_TOTAL_DISCOUNT]));
            purchaseItem.setDeliveryDate(rs.getDate(DbPurchaseItem.colNames[DbPurchaseItem.COL_DELIVERY_DATE]));
            
            purchaseItem.setLastDisPercent(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_LAST_DIS_PERCENT]));
            purchaseItem.setRegDisVal(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_REG_DIS_VAL]));
            purchaseItem.setRegDisPercent(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_REG_DIS_PERCENT]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long purchaseItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PURCHASE_ITEM + " WHERE " +
                    DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ITEM_ID] + " = " + purchaseItemId;

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
            String sql = "SELECT COUNT(" + DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID] + ") FROM " + DB_PURCHASE_ITEM;
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
                    PurchaseItem purchaseItem = (PurchaseItem) list.get(ls);
                    if (oid == purchaseItem.getOID()) {
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
    
    public static double getTotalPurchaseAmount(long poOID){
        double result = 0;
        CONResultSet crs = null;
        try{
            String sql = " select sum("+DbPurchaseItem.colNames[DbPurchaseItem.COL_TOTAL_AMOUNT]+") from "+DB_PURCHASE_ITEM+
                         " where "+colNames[COL_PURCHASE_ID]+"="+poOID;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                result = rs.getDouble(1);
            }
        }
        catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        return result;
    }
    
    
    public static PurchaseItem getLastPurchaseItem(long vendorId, long itemId){
        String sql = " select * from "+DB_PURCHASE_ITEM+" pi "+
                     " inner join "+DbPurchase.DB_PURCHASE+" p "+
                     " on p."+DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]+" = pi."+colNames[COL_PURCHASE_ID]+
                     " where p."+DbPurchase.colNames[DbPurchase.COL_VENDOR_ID]+"="+vendorId+
                     " and pi."+colNames[COL_ITEM_MASTER_ID]+"="+itemId+
                     " order by p."+DbPurchase.colNames[DbPurchase.COL_PURCH_DATE]+" desc "+
                     " limit 0,1";
        
        System.out.println(sql);
        
        PurchaseItem pi = new PurchaseItem();
        
        CONResultSet crs = null;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                resultToObject(rs, pi);
            }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return pi;
        
    }
    
}
