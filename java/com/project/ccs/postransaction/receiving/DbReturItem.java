/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.receiving;

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
import java.util.*;
import com.project.ccs.postransaction.stock.*;

public class DbReturItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_RETUR_ITEM = "pos_retur_item";
    public static final int COL_RETUR_ITEM_ID = 0;
    public static final int COL_RETUR_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_QTY = 3;
    public static final int COL_AMOUNT = 4;
    public static final int COL_TOTAL_AMOUNT = 5;
    public static final int COL_TOTAL_DISCOUNT = 6;
    public static final int COL_DELIVERY_DATE = 7;
    public static final int COL_UOM_ID = 8;
    public static final int COL_STATUS = 9;
    
    public static final int COL_PURCHASE_ITEM_ID = 10;
    public static final int COL_EXPIRED_DATE = 11;
    public static final int COL_RECEIVE_ITEM_ID = 12;
    
    public static final String[] colNames = {
        "retur_item_id",
        "retur_id",
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
        "receive_item_id"
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
        
        TYPE_LONG,
        TYPE_DATE,
        TYPE_LONG
    };

    public DbReturItem() {
    }

    public DbReturItem(int i) throws CONException {
        super(new DbReturItem());
    }

    public DbReturItem(String sOid) throws CONException {
        super(new DbReturItem(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbReturItem(long lOid) throws CONException {
        super(new DbReturItem(0));
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
        return DB_RETUR_ITEM;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbReturItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ReturItem returItem = fetchExc(ent.getOID());
        ent = (Entity) returItem;
        return returItem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ReturItem) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ReturItem) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ReturItem fetchExc(long oid) throws CONException {
        try {
            ReturItem returItem = new ReturItem();
            DbReturItem dbReturItem = new DbReturItem(oid);
            returItem.setOID(oid);

            returItem.setReturId(dbReturItem.getlong(COL_RETUR_ID));
            returItem.setItemMasterId(dbReturItem.getlong(COL_ITEM_MASTER_ID));
            returItem.setQty(dbReturItem.getdouble(COL_QTY));
            returItem.setUomId(dbReturItem.getlong(COL_UOM_ID));
            returItem.setStatus(dbReturItem.getString(COL_STATUS));

            returItem.setAmount(dbReturItem.getdouble(COL_AMOUNT));
            returItem.setTotalAmount(dbReturItem.getdouble(COL_TOTAL_AMOUNT));
            returItem.setTotalDiscount(dbReturItem.getdouble(COL_TOTAL_DISCOUNT));
            returItem.setDeliveryDate(dbReturItem.getDate(COL_DELIVERY_DATE));
            
            returItem.setPurchaseItemId(dbReturItem.getlong(COL_PURCHASE_ITEM_ID));
            returItem.setExpiredDate(dbReturItem.getDate(COL_EXPIRED_DATE));
            returItem.setReceiveItemId(dbReturItem.getlong(COL_RECEIVE_ITEM_ID));

            return returItem;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReturItem(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(ReturItem returItem) throws CONException {
        try {
            DbReturItem dbReturItem = new DbReturItem(0);

            dbReturItem.setLong(COL_RETUR_ID, returItem.getReturId());
            dbReturItem.setLong(COL_ITEM_MASTER_ID, returItem.getItemMasterId());
            dbReturItem.setDouble(COL_QTY, returItem.getQty());
            dbReturItem.setLong(COL_UOM_ID, returItem.getUomId());
            dbReturItem.setString(COL_STATUS, returItem.getStatus());

            dbReturItem.setDouble(COL_AMOUNT, returItem.getAmount());
            dbReturItem.setDouble(COL_TOTAL_AMOUNT, returItem.getTotalAmount());
            dbReturItem.setDouble(COL_TOTAL_DISCOUNT, returItem.getTotalDiscount());
            dbReturItem.setDate(COL_DELIVERY_DATE, returItem.getDeliveryDate());
            
            dbReturItem.setLong(COL_PURCHASE_ITEM_ID, returItem.getPurchaseItemId());
            dbReturItem.setDate(COL_EXPIRED_DATE, returItem.getExpiredDate());
            dbReturItem.setLong(COL_RECEIVE_ITEM_ID, returItem.getReceiveItemId());

            dbReturItem.insert();
            returItem.setOID(dbReturItem.getlong(COL_RETUR_ITEM_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReturItem(0), CONException.UNKNOWN);
        }
        return returItem.getOID();
    }

    public static long updateExc(ReturItem returItem) throws CONException {
        try {
            if (returItem.getOID() != 0) {
                DbReturItem dbReturItem = new DbReturItem(returItem.getOID());

                dbReturItem.setLong(COL_RETUR_ID, returItem.getReturId());
                dbReturItem.setLong(COL_ITEM_MASTER_ID, returItem.getItemMasterId());
                dbReturItem.setDouble(COL_QTY, returItem.getQty());
                dbReturItem.setLong(COL_UOM_ID, returItem.getUomId());
                dbReturItem.setString(COL_STATUS, returItem.getStatus());

                dbReturItem.setDouble(COL_AMOUNT, returItem.getAmount());
                dbReturItem.setDouble(COL_TOTAL_AMOUNT, returItem.getTotalAmount());
                dbReturItem.setDouble(COL_TOTAL_DISCOUNT, returItem.getTotalDiscount());
                dbReturItem.setDate(COL_DELIVERY_DATE, returItem.getDeliveryDate());
                
                dbReturItem.setLong(COL_PURCHASE_ITEM_ID, returItem.getPurchaseItemId());
                dbReturItem.setDate(COL_EXPIRED_DATE, returItem.getExpiredDate());
                dbReturItem.setLong(COL_RECEIVE_ITEM_ID, returItem.getReceiveItemId());

                dbReturItem.update();
                return returItem.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReturItem(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbReturItem dbReturItem = new DbReturItem(oid);
            dbReturItem.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReturItem(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static long deleteAllItem(long oidMain) throws CONException {
        try {
            String sql = "DELETE FROM " + DB_RETUR_ITEM +
                    " WHERE " + colNames[COL_RETUR_ID] + "=" + oidMain;
            CONHandler.execUpdate(sql);
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReturItem(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_RETUR_ITEM;
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
                ReturItem returItem = new ReturItem();
                resultToObject(rs, returItem);
                lists.add(returItem);
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

    public static void resultToObject(ResultSet rs, ReturItem returItem) {
        try {
            returItem.setOID(rs.getLong(DbReturItem.colNames[DbReturItem.COL_RETUR_ITEM_ID]));
            returItem.setReturId(rs.getLong(DbReturItem.colNames[DbReturItem.COL_RETUR_ID]));
            returItem.setItemMasterId(rs.getLong(DbReturItem.colNames[DbReturItem.COL_ITEM_MASTER_ID]));
            returItem.setQty(rs.getDouble(DbReturItem.colNames[DbReturItem.COL_QTY]));
            returItem.setUomId(rs.getLong(DbReturItem.colNames[DbReturItem.COL_UOM_ID]));
            returItem.setStatus(rs.getString(DbReturItem.colNames[DbReturItem.COL_STATUS]));

            returItem.setAmount(rs.getDouble(DbReturItem.colNames[DbReturItem.COL_AMOUNT]));
            returItem.setTotalAmount(rs.getDouble(DbReturItem.colNames[DbReturItem.COL_TOTAL_AMOUNT]));
            returItem.setTotalDiscount(rs.getDouble(DbReturItem.colNames[DbReturItem.COL_TOTAL_DISCOUNT]));
            returItem.setDeliveryDate(rs.getDate(DbReturItem.colNames[DbReturItem.COL_DELIVERY_DATE]));
            
            returItem.setPurchaseItemId(rs.getLong(DbReturItem.colNames[DbReturItem.COL_PURCHASE_ITEM_ID]));
            returItem.setExpiredDate(rs.getDate(DbReturItem.colNames[DbReturItem.COL_EXPIRED_DATE]));
            returItem.setReceiveItemId(rs.getLong(DbReturItem.colNames[DbReturItem.COL_RECEIVE_ITEM_ID]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long returItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_RETUR_ITEM + " WHERE " +
                    DbReturItem.colNames[DbReturItem.COL_RETUR_ITEM_ID] + " = " + returItemId;

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
            String sql = "SELECT COUNT(" + DbReturItem.colNames[DbReturItem.COL_RETUR_ID] + ") FROM " + DB_RETUR_ITEM;
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
                    ReturItem returItem = (ReturItem) list.get(ls);
                    if (oid == returItem.getOID()) {
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
    
    public static double getTotalReturAmount(long poOID){
        double result = 0;
        CONResultSet crs = null;
        try{
            String sql = " select sum("+DbReturItem.colNames[DbReturItem.COL_TOTAL_AMOUNT]+") from "+DB_RETUR_ITEM+
                         " where "+colNames[COL_RETUR_ID]+"="+poOID;
            
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
    
    public static void deleteByReturId(long returId){
        try{
            CONHandler.execUpdate("delete from "+DB_RETUR_ITEM+" where "+colNames[COL_RETUR_ID]+"="+returId);            
        }
        catch(Exception e){
            
        }
    }
    
    public static int insertByItem(long oidRetur, long itemMasterId, long prItemId, double qty, double amount, 
    double discout, double totAmount, long uomId, long recItemId){
        
        System.out.println("oidRetur : "+oidRetur+", itemMasterId : "+itemMasterId+", recItemId : "+recItemId+", qty : "+qty);
        
        if(oidRetur==0 || itemMasterId==0 || recItemId==0 || qty==0){
            System.out.println("tidak bisa save item -> insertByItem : oidRetur==0 || itemMasterId==0 || recItemId==0 || qty==0");
            return -1;            
        }
        else{
            try{
                ReturItem ri = new ReturItem();
                ri.setAmount(amount);
                ri.setItemMasterId(itemMasterId);
                ri.setPurchaseItemId(prItemId);
                ri.setReceiveItemId(recItemId);
                ri.setQty(qty);
                ri.setReturId(oidRetur);
                ri.setTotalAmount(totAmount);
                ri.setTotalDiscount(discout);
                ri.setUomId(uomId);
                ri.setDeliveryDate(new Date());
               
                DbReturItem.insertExc(ri);
            }
            catch(Exception e){
            }
        }
        
        return 0;
        
    }
    
    public static double getTotalQtyRetur(long recItemId){
        
        String sql = "select sum("+colNames[COL_QTY]+") from "+DB_RETUR_ITEM+" where "+colNames[COL_RECEIVE_ITEM_ID]+"="+recItemId;
        
        double result = 0;
        
        CONResultSet crs = null;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                result = rs.getInt(1);
            }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
    }
    
    public static ReturItem getReturItem(long recItemId, long oidRetur){
        String where = colNames[COL_RECEIVE_ITEM_ID]+"="+recItemId+" and "+colNames[COL_RETUR_ID]+"="+oidRetur;
        Vector v = DbReturItem.list(0,0, where, "");
        if(v!=null && v.size()>0){
            return (ReturItem)v.get(0);
        }
        return new ReturItem();
    }
    
    public static void proceedStock(Retur retur){
        
        System.out.println("in inserting stock ...");    
            
        Vector temp = DbReturItem.list(0,0, colNames[COL_RETUR_ID]+"="+retur.getOID(), "");
        
        System.out.println("temp : "+temp);    
        
        if(temp!=null && temp.size()>0){
            for(int i=0; i<temp.size(); i++){
                ReturItem ri = (ReturItem)temp.get(i);                
                DbStock.insertReturGoods(retur, ri);                
            }            
        }
        
    }    
    
}
