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
import java.util.*;
import com.project.system.*;
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.order.DbOrder;
import com.project.ccs.postransaction.order.Order;
import com.project.ccs.postransaction.stock.*;
//import com.project.fms.session.SessReceiveJournal;
import com.project.general.DbHistoryUser;
import com.project.general.DbLocation;
//import com.project.general.DbLogUser;
import com.project.general.HistoryUser;
import com.project.general.Location;
//import com.project.general.LogUser;
import com.project.util.JSPFormater;

public class DbReceiveItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_RECEIVE_ITEM = "pos_receive_item";
    public static final int COL_RECEIVE_ITEM_ID = 0;
    public static final int COL_RECEIVE_ID = 1;
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
    public static final int COL_AP_COA_ID = 12;
    public static final int COL_TYPE = 13;
    public static final int COL_IS_BONUS=14;
    public static final int COL_MEMO = 15;
    public static final int COL_PRICE_IMPORT = 16;
    public static final int COL_TRANSPORT = 17;
    public static final int COL_BEA = 18;
    public static final int COL_KOMISI = 19;
    public static final int COL_LAIN_LAIN = 20;
    
    public static final String[] colNames = {
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
        "lain_lain"
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
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT
    };
    
    public static int NON_BONUS = 0;
    public static int BONUS     = 1;

    public DbReceiveItem() {
    }

    public DbReceiveItem(int i) throws CONException {
        super(new DbReceiveItem());
    }

    public DbReceiveItem(String sOid) throws CONException {
        super(new DbReceiveItem(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbReceiveItem(long lOid) throws CONException {
        super(new DbReceiveItem(0));
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
        return DB_RECEIVE_ITEM;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbReceiveItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        ReceiveItem receiveItem = fetchExc(ent.getOID());
        ent = (Entity) receiveItem;
        return receiveItem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((ReceiveItem) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((ReceiveItem) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static ReceiveItem fetchExc(long oid) throws CONException {
        try {
            ReceiveItem receiveItem = new ReceiveItem();
            DbReceiveItem dbReceiveItem = new DbReceiveItem(oid);
            receiveItem.setOID(oid);

            receiveItem.setReceiveId(dbReceiveItem.getlong(COL_RECEIVE_ID));
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
            return receiveItem;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReceiveItem(0), CONException.UNKNOWN);
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
            dbReceiveItem.insert();
            receiveItem.setOID(dbReceiveItem.getlong(COL_RECEIVE_ITEM_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReceiveItem(0), CONException.UNKNOWN);
        }
        return receiveItem.getOID();
    }

    public static long updateExc(ReceiveItem receiveItem) throws CONException {
        try {
            if (receiveItem.getOID() != 0) {
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
                dbReceiveItem.update();
                return receiveItem.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReceiveItem(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbReceiveItem dbReceiveItem = new DbReceiveItem(oid);
            dbReceiveItem.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReceiveItem(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static long deleteAllItem(long oidMain) throws CONException {
        try {
            String sql = "DELETE FROM " + DB_RECEIVE_ITEM +
                    " WHERE " + colNames[COL_RECEIVE_ID] + "=" + oidMain;
            CONHandler.execUpdate(sql);
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReceiveItem(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_RECEIVE_ITEM;
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
                ReceiveItem receiveItem = new ReceiveItem();
                resultToObject(rs, receiveItem);
                lists.add(receiveItem);
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
    
    public static Vector list(String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_RECEIVE_ITEM;
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

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, ReceiveItem receiveItem) {
        try {
            receiveItem.setOID(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID]));
            receiveItem.setReceiveId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]));
            receiveItem.setItemMasterId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_ITEM_MASTER_ID]));
            receiveItem.setQty(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_QTY]));
            receiveItem.setUomId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_UOM_ID]));
            receiveItem.setStatus(rs.getString(DbReceiveItem.colNames[DbReceiveItem.COL_STATUS]));
            receiveItem.setAmount(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_AMOUNT]));
            receiveItem.setTotalAmount(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_TOTAL_AMOUNT]));
            receiveItem.setTotalDiscount(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_TOTAL_DISCOUNT]));
            receiveItem.setDeliveryDate(rs.getDate(DbReceiveItem.colNames[DbReceiveItem.COL_DELIVERY_DATE]));            
            receiveItem.setPurchaseItemId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_PURCHASE_ITEM_ID]));
            receiveItem.setExpiredDate(rs.getDate(DbReceiveItem.colNames[DbReceiveItem.COL_EXPIRED_DATE]));
            receiveItem.setApCoaId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_AP_COA_ID]));
            receiveItem.setType(rs.getInt(DbReceiveItem.colNames[DbReceiveItem.COL_TYPE]));
            receiveItem.setIsBonus(rs.getInt(DbReceiveItem.colNames[DbReceiveItem.COL_IS_BONUS]));
            receiveItem.setMemo(rs.getString(DbReceiveItem.colNames[DbReceiveItem.COL_MEMO]));
            receiveItem.setPriceImport(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_PRICE_IMPORT]));
            receiveItem.setTransport(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_TRANSPORT]));
            receiveItem.setBea(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_BEA]));
            receiveItem.setKomisi(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_KOMISI]));
            receiveItem.setLainLain(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_LAIN_LAIN]));
        } catch (Exception e) {
        }
    }
    
    public static void resultToObjectx(ResultSet rs, ReceiveItem receiveItem) {
        try {
            receiveItem.setOID(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID]));
            receiveItem.setReceiveId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]));
            receiveItem.setItemMasterId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_ITEM_MASTER_ID]));
            receiveItem.setQty(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_QTY]));
            receiveItem.setUomId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_UOM_ID]));
            receiveItem.setStatus(rs.getString(DbReceiveItem.colNames[DbReceiveItem.COL_STATUS]));            
            double amount = rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_AMOUNT]);
            if(amount != 0){
                receiveItem.setAmount(-1 * rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_AMOUNT]));            
                receiveItem.setTotalAmount(-1 * rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_TOTAL_AMOUNT]));
            }            
            receiveItem.setTotalDiscount(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_TOTAL_DISCOUNT]));
            receiveItem.setDeliveryDate(rs.getDate(DbReceiveItem.colNames[DbReceiveItem.COL_DELIVERY_DATE]));            
            receiveItem.setPurchaseItemId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_PURCHASE_ITEM_ID]));
            receiveItem.setExpiredDate(rs.getDate(DbReceiveItem.colNames[DbReceiveItem.COL_EXPIRED_DATE]));
            receiveItem.setApCoaId(rs.getLong(DbReceiveItem.colNames[DbReceiveItem.COL_AP_COA_ID]));
            receiveItem.setType(rs.getInt(DbReceiveItem.colNames[DbReceiveItem.COL_TYPE]));
            receiveItem.setIsBonus(rs.getInt(DbReceiveItem.colNames[DbReceiveItem.COL_IS_BONUS]));
            receiveItem.setMemo(rs.getString(DbReceiveItem.colNames[DbReceiveItem.COL_MEMO]));
            receiveItem.setPriceImport(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_PRICE_IMPORT]));
            receiveItem.setTransport(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_TRANSPORT]));
            receiveItem.setBea(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_BEA]));
            receiveItem.setKomisi(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_KOMISI]));
            receiveItem.setLainLain(rs.getDouble(DbReceiveItem.colNames[DbReceiveItem.COL_LAIN_LAIN]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long receiveItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_RECEIVE_ITEM + " WHERE " +
                    DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID] + " = " + receiveItemId;

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
            String sql = "SELECT COUNT(" + DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + ") FROM " + DB_RECEIVE_ITEM;
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
                    ReceiveItem receiveItem = (ReceiveItem) list.get(ls);
                    if (oid == receiveItem.getOID()) {
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
    
    public static double getTotalReceiveAmount(long poOID){
        double result = 0;
        CONResultSet crs = null;
        try{
            String sql = " select sum("+DbReceiveItem.colNames[DbReceiveItem.COL_TOTAL_AMOUNT]+") from "+DB_RECEIVE_ITEM+
                         " where "+colNames[COL_RECEIVE_ID]+"="+poOID;
            
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
    
    public static double getTotalRecAmount(long poOID){
        double result = 0;
        CONResultSet crs = null;
        try{
            String sql = " select sum("+DbReceiveItem.colNames[DbReceiveItem.COL_TOTAL_AMOUNT]+") from "+DB_RECEIVE_ITEM+
                         " where "+colNames[COL_RECEIVE_ID]+"="+poOID;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                result = rs.getDouble(1);
                if(result != 0){
                    result = result * -1;
                }
            }
        }
        catch(Exception e){
            
        }
        finally{
            CONResultSet.close(crs);
        }
        return result;
    }
    
    public static void deleteByReceiveId(long receiveId){
        try{
            CONHandler.execUpdate("delete from "+DB_RECEIVE_ITEM+" where "+colNames[COL_RECEIVE_ID]+"="+receiveId);            
        }catch(Exception e){}
    }
    
    public static int insertByItem(long oidReceive, long itemMasterId, long prItemId, double qty, double amount, double discout, double totAmount, long uomId, Date expDate){
        
        if(oidReceive==0 || itemMasterId==0 || prItemId==0 || qty==0){
            return -1;
        }
        else{
            try{
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
                DbReceiveItem.insertExc(ri);
            }
            catch(Exception e){
            }
        }        
        return 0;
        
    }
    
    public static int insertByItem(long oidReceive, long itemMasterId, long prItemId, double qty, double amount, double discout, double totAmount, long uomId){
        
        if(oidReceive==0 || itemMasterId==0 || prItemId==0 || qty==0){
            return -1;
        }
        else{
            try{
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
                
                DbReceiveItem.insertExc(ri);
            }
            catch(Exception e){
            }
        }
        
        return 0;
        
    }
    
    public static double getTotalQtyRec(long prItemId){        
        String sql = "select sum("+colNames[COL_QTY]+") from "+DB_RECEIVE_ITEM+" where "+colNames[COL_PURCHASE_ITEM_ID]+"="+prItemId;        
        double result = 0;        
        CONResultSet crs = null;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                result = rs.getInt(1);
            }
        }catch(Exception e){}
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
    }
    
    public static ReceiveItem getReceiveItem(long prItemId, long oidReceive){
        String where = colNames[COL_PURCHASE_ITEM_ID]+"="+prItemId+" and "+colNames[COL_RECEIVE_ID]+"="+oidReceive;
        Vector v = DbReceiveItem.list(0,0, where, "");
        if(v!=null && v.size()>0){
            return (ReceiveItem)v.get(0);
        }
        return new ReceiveItem();
    }
    
    public static void proceedStock(Receive receive){        
        Vector temp = DbReceiveItem.list(0,0, colNames[COL_RECEIVE_ID]+"="+receive.getOID(), "");        
        if(temp!=null && temp.size()>0){              
            int stockType = Integer.parseInt(DbSystemProperty.getValueByName("STOCK_MANAGEMENT_TYPE"));               
            int cogsType = 0;
            try{
                cogsType = Integer.parseInt(DbSystemProperty.getValueByName("COGS_TYPE"));    
            }catch(Exception e){cogsType = 0;}
            
            //long oidx = SessReceiveJournal.journalCleareance(receive.getOID());
      
            /*if (oidx == 0) {
                LogUser logUser = new LogUser();
                logUser.setDate(new Date());
                logUser.setDescription("Error insert : " + receive.getOID() + "/" + receive.getNumber());
                logUser.setUserId(receive.getApproval1());
                logUser.setRefId(receive.getOID());
                logUser.setType(0);
                try {
                    DbLogUser.insertExc(logUser);
                }catch (Exception e) {}
            }*/
            
            for(int i=0; i<temp.size(); i++){                
                ReceiveItem ri = (ReceiveItem)temp.get(i);                 
                ItemMaster im = new ItemMaster();
                try{
                    im = DbItemMaster.fetchExc(ri.getItemMasterId());
                    //jika bukan jasa (stockable) lakukan proses penambahan stock
                    long oid = insertReceiveGoods(receive, ri, im); 
                    
                    //jika bukan jasa (stockable) lakukan pemrosesan
                    if(im.getNeedRecipe()==0){
                    
                        if(receive.getType()==DbReceive.TYPE_NON_CONSIGMENT){
                            //average
                            if(stockType==0){
                                if(cogsType == 0){ // pemrosesan dengan moving average
                                    updateItemAverageCost(ri, receive, im);
                                }else if(cogsType ==1){ //pemrosesan dengan pembelian rata-rata
                                    updateItemAvgSumIncoming(receive,ri,im);
                                }
                            }
                            //update dengan harga terakhir
                            else if(stockType==1){
                                updateItemLastPriceCost(ri);
                            }
                        }else if(receive.getType()==DbReceive.TYPE_CONSIGMENT){
                            //average
                            if(stockType==0){
                                updateItemAverageCostConsigment(ri);
                            }
                            //update dengan harga terakhir
                            else if(stockType==1){
                                updateItemLastPriceCostConsigment(ri);
                            }
                        }
                    }
                    
                }catch(Exception e){}                
            }
        }
    }
    
    public static long insertReceiveGoods(Receive rec, ReceiveItem ri, ItemMaster im){
        long oid = 0;        
        try{
            if(rec.getTypeAp() != DbReceive.TYPE_AP_REC_ADJ_BY_PRICE){                
                if(im.getNeedRecipe()==0){
                    Stock stock = new Stock();
                    stock.setIncomingId(ri.getReceiveId());
                    stock.setInOut(DbStock.STOCK_IN);
                    stock.setItemBarcode(im.getBarcode());
                    stock.setItemCode(im.getCode());
                    stock.setItemMasterId(im.getOID());
                    stock.setItemName(im.getName());
                    stock.setLocationId(rec.getLocationId());
                    stock.setDate(rec.getApproval1Date());//stock mengikuti tanggal jam approve - ED
                    stock.setNoFaktur(rec.getDoNumber());
                    stock.setPrice(ri.getTotalAmount()/ri.getQty());
                    stock.setTotal(ri.getTotalAmount());

                    stock.setQty((ri.getQty() * im.getUomPurchaseStockQty()));
                    if(rec.getTypeAp()==DbReceive.TYPE_AP_REC_ADJ_BY_QTY){
                        stock.setType(DbStock.TYPE_REC_ADJ);
                    }else{
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
        }catch(Exception e){
            System.out.println(e.toString());
        }
        return oid;
    }
    
    public static void checkRequestTransfer(long item_master_id, long location_id, ItemMaster im){

          if(im.getIsAutoOrder()==1){

             Location loc = new Location()   ;
             try{
                 loc = DbLocation.fetchExc(location_id); 
             }catch(Exception ex){}

             if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){ 

                double minStock = DbStockMin.getStockMinValue(location_id, item_master_id);                
                try{
                    DbOrder.deleteOrder(item_master_id, location_id);
                }catch(Exception ex){
                }   

                if(minStock > 0){

                    double totalStock = DbStock.getItemTotalStock(location_id, item_master_id);
                    
                    if(totalStock < 0){
                        totalStock = 0;
                    }

                    double totalPoPrev = DbStock.getTotalPo(location_id, item_master_id);// mencari total po yg masih outstanding
                    double totalRequest = DbOrder.getTotalOrder(location_id, item_master_id); // qty yg sudah pernah di order dengan status draft   
                    double totalTransferDraft = DbStock.getTotalTransfer(location_id, item_master_id);//mencari transfer ke lokasi ini yang masih out standing

                    if((totalStock + totalRequest + totalTransferDraft)<=(minStock - im.getDeliveryUnit())){

                        double qtyRequest;

                        qtyRequest=(((minStock-(totalRequest+totalStock + totalTransferDraft)))/im.getDeliveryUnit());
                        qtyRequest=Math.floor(qtyRequest)* im.getDeliveryUnit();

                        if(totalRequest > 0){//jika sebelumnya sudah ada order maka update qtynya dengan sejumlah order yg baru + qty order sebelumna
                            Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + item_master_id + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + location_id + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                            if(vOrder != null && vOrder.size()>0){
                                Order odrPrev = (Order)vOrder.get(0);
                                try{
                                    odrPrev.setQtyOrder(qtyRequest);
                                    odrPrev.setQtyStock((totalStock ));
                                    DbOrder.updateExc(odrPrev);
                                }catch(Exception ex) {

                                }
                            }
                        }else{
                        //otomatis buatkan order;
                        try{

                             int nextCounter;
                             nextCounter=DbOrder.getNextCounter();

                             Order order = new Order();
                             order.setCounter(nextCounter);
                             order.setPrefixNumber(DbOrder.getNumberPrefix());
                             order.setNumber(DbOrder.getNextNumber(nextCounter));
                             order.setQtyOrder(qtyRequest);
                             order.setDate(new Date());
                             order.setQtyStock((totalStock + totalRequest));
                             order.setQtyPoPrev(totalPoPrev);
                             order.setQtyStandar(minStock);
                             order.setLocationId(location_id);
                             order.setItemMasterId(item_master_id);
                             order.setStatus("DRAFT");
                             //order.setDate_proces(new Date()) ;

                             DbOrder.insertExc(order);

                         }catch(Exception ex){

                         }
                    }


                }else{
                    if((totalStock + totalTransferDraft) >= (minStock - im.getDeliveryUnit())){
                    Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + item_master_id + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + location_id + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                            if(vOrder != null && vOrder.size()>0){
                                Order odrPrev = (Order)vOrder.get(0);
                                try{
                                    odrPrev.setStatus("APPROVED");
                                    DbOrder.updateExc(odrPrev);
                                }catch(Exception ex) {

                                }
                            }
                    }else{


                        if(totalRequest!=0){
                            Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + item_master_id + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + location_id + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                            if(vOrder != null && vOrder.size()>0){
                                Order odrPrev = (Order)vOrder.get(0);
                                try{
                                    //jika terjadi perubahan poprev dan standar stock maka update order yg masih draft
                                    if((odrPrev.getQtyPoPrev()!=totalPoPrev) || (odrPrev.getQtyStandar()!=minStock)){

                                        double qtyRequest;

                                        qtyRequest=(((minStock-(totalRequest+totalStock+totalTransferDraft)))/im.getDeliveryUnit());
                                        qtyRequest=Math.floor(qtyRequest)* im.getDeliveryUnit();
                                        if(qtyRequest>0){
                                            odrPrev.setQtyPoPrev(totalPoPrev);
                                            odrPrev.setQtyOrder(qtyRequest);
                                            odrPrev.setQtyStock((totalStock ));
                                            odrPrev.setQtyStandar(minStock);

                                            odrPrev.setDate(new Date());
                                            DbOrder.updateExc(odrPrev);
                                        }
                                    }


                                }catch(Exception ex) {

                                }
                            }

                        }

                    }
                }

             }//min stock>0

          }//if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){

       }//if(im.getIsAutoOrder()==1){

    }
    
    public static void updateCogs(Receive receive){
            
        Vector temp = DbReceiveItem.list(0,0, colNames[COL_RECEIVE_ID]+"="+receive.getOID(), "");
        
        if(temp!=null && temp.size()>0){
            for(int i=0; i<temp.size(); i++){
                ReceiveItem ri = (ReceiveItem)temp.get(i); 
                
                ItemMaster im = new ItemMaster();
                try{
                    im = DbItemMaster.fetchExc(ri.getItemMasterId());
                }catch(Exception e){}
                
                //jika bukan jasa (stockable) lakukan proses penambahan stock
                if(im.getNeedRecipe()==0){
                    int stockType = Integer.parseInt(DbSystemProperty.getValueByName("STOCK_MANAGEMENT_TYPE")); 
                    int cogsType = 0;
                    try{
                        cogsType = Integer.parseInt(DbSystemProperty.getValueByName("COGS_TYPE"));    
                    }catch(Exception e){cogsType = 0;}
                    
                    if(receive.getType()==DbReceive.TYPE_NON_CONSIGMENT){
                        //average
                        if(stockType==0){                            
                            if(cogsType == 0){ // pemrosesan dengan moving average
                                updateItemAverageCost(ri, receive);
                            }else if(cogsType ==1){ //pemrosesan dengan pembelian rata-rata
                                updateItemAvgSumIncoming(receive,ri,im);
                            }
                        }
                        //update dengan harga terakhir
                        else if(stockType==1){
                            updateItemLastPriceCost(ri);
                        }
                    }
                    if(receive.getType()==DbReceive.TYPE_CONSIGMENT){
                        //average
                        if(stockType==0){
                            updateItemAverageCostConsigment(ri);
                        }
                        //update dengan harga terakhir
                        else if(stockType==1){
                            updateItemLastPriceCostConsigment(ri);
                        }
                    }                    
                }
            }            
        }        
    }     
    
    public static void updateItemAverageCost(ReceiveItem ri, Receive re){
        
        ItemMaster im = new ItemMaster();        
        try{
            im = DbItemMaster.fetchExc(ri.getItemMasterId());                
            double totalStock = 0;
            double stockAdd = 0;
            
            if(re.getTypeAp()==DbReceive.TYPE_AP_REC_ADJ_BY_PRICE){
                totalStock = DbStock.getItemTotalStock(im.getOID());           
            }else{
                totalStock = DbStock.getItemTotalStock(im.getOID()) - (ri.getQty() * im.getUomPurchaseStockQty());                  
                stockAdd = ri.getQty() * im.getUomPurchaseStockQty();
            }
            
            if(re.getDiscountPercent()!=0){
                ri.setTotalAmount(ri.getTotalAmount()-((re.getDiscountPercent() * ri.getTotalAmount())/100));
            }
            
            double totalCost = (totalStock * im.getCogs()) + (ri.getTotalAmount());               
            double cogs = 0;            
            
            if(re.getTypeAp()!=DbReceive.TYPE_AP_REC_ADJ_BY_PRICE){
                totalStock = totalStock + (ri.getQty() * im.getUomPurchaseStockQty() );
            }
            
            if(totalStock <= 0){
                cogs = ri.getTotalAmount()/(ri.getQty() * im.getUomPurchaseStockQty());
                updateCogs(im.getOID(),cogs);                
            }else{
                
                if((totalStock + stockAdd) > 0){                    
                    cogs = totalCost/(totalStock + stockAdd);
                    updateCogs(im.getOID(),cogs);                    
                }else{                                    
                    cogs = ri.getTotalAmount()/(ri.getQty() * im.getUomPurchaseStockQty());
                    updateCogs(im.getOID(),cogs);                    
                }
            }
            
             if(im.getOID() != 0){
                String memo = "Perhitungan System Moving Average, incoming : "+re.getNumber()+",Qty : "+JSPFormater.formatNumber(ri.getQty(),"###,###.##")+", harga :"+JSPFormater.formatNumber(ri.getAmount(),"###,###.##")+" cogs : "+JSPFormater.formatNumber(cogs,"###,###.##");
                HistoryUser hisUser = new HistoryUser();
                hisUser.setUserId(0);
                hisUser.setEmployeeId(0);
                hisUser.setRefId(im.getOID());
                hisUser.setDescription(memo);
                hisUser.setType(DbHistoryUser.TYPE_COGS_MASTER);
                hisUser.setDate(new Date());
                try {
                    DbHistoryUser.insertExc(hisUser);
                } catch (Exception e) {}
            }
        }
        catch(Exception e){
            System.out.println(e.toString());
        }        
    }
    
    
    
    public static void updateItemAverageCost(ReceiveItem ri, Receive re, ItemMaster im){        
        try{    
            double totalStock = 0;
            double stockAdd = 0;
            
            if(re.getTypeAp()==DbReceive.TYPE_AP_REC_ADJ_BY_PRICE){
                totalStock = DbStock.getItemTotalStock(im.getOID());           
            }else{
                totalStock = DbStock.getItemTotalStock(im.getOID()) - (ri.getQty() * im.getUomPurchaseStockQty());                  
                stockAdd = ri.getQty() * im.getUomPurchaseStockQty();
            }
            
            if(re.getDiscountPercent()!=0){
                ri.setTotalAmount(ri.getTotalAmount()-((re.getDiscountPercent() * ri.getTotalAmount())/100));
            }
            
            double totalCost = (totalStock * im.getCogs()) + (ri.getTotalAmount());               
            double cogs = 0;
            
            if(totalStock <= 0){
                cogs = ri.getTotalAmount()/(ri.getQty() * im.getUomPurchaseStockQty());
                updateCogs(im.getOID(),cogs);                
            }else{            
                if((totalStock + stockAdd) > 0){                    
                    cogs = totalCost/(totalStock + stockAdd);
                    updateCogs(im.getOID(),cogs);                    
                }else{                                    
                    cogs = ri.getTotalAmount()/(ri.getQty() * im.getUomPurchaseStockQty());
                    updateCogs(im.getOID(),cogs);                    
                }
            }
            if(im.getOID() != 0){
                String memo = "Perhitungan System Moving Average, incoming : "+re.getNumber()+",Qty : "+JSPFormater.formatNumber(ri.getQty(),"###,###.##")+", harga :"+JSPFormater.formatNumber(ri.getAmount(),"###,###.##")+" cogs : "+JSPFormater.formatNumber(cogs,"###,###.##");
                HistoryUser hisUser = new HistoryUser();
                hisUser.setUserId(0);
                hisUser.setEmployeeId(0);
                hisUser.setRefId(im.getOID());
                hisUser.setDescription(memo);
                hisUser.setType(DbHistoryUser.TYPE_COGS_MASTER);
                hisUser.setDate(new Date());
                try {
                    DbHistoryUser.insertExc(hisUser);
                } catch (Exception e) {}
            }
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
    }
    
    
    public static void updateItemAverageCostConsigment(ReceiveItem ri){        
        ItemMaster im = new ItemMaster();        
        try{
            im = DbItemMaster.fetchExc(ri.getItemMasterId());                
            double totalStock = DbStock.getItemTotalStockConsigment(im.getOID()); 
            double totalCost = (totalStock * im.getCogs_consigment()) + (ri.getTotalAmount());
            totalStock = totalStock + (ri.getQty() * im.getUomPurchaseStockQty() );
            im.setCogs_consigment(totalCost/totalStock);            
            DbItemMaster.updateExc(im);
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        
    }
    
    
    /***  
     * @author : Roy Andika     
     * @param im
     * @Desc : Perhitungan cogs berdasarkan rata-rata total pembelian yang sudah di approve
     */
    public static void updateItemAvgSumIncoming(Receive r,ReceiveItem ri,ItemMaster im){
        try{
            ReceiveItem obj = getReceive(r.getOID(),ri.getOID());
            Cogs cogs = getCogs(im.getOID());
            double cogsValue = 0;
            double qty = 0;
            if(cogs.getOID()==0){
                cogsValue = obj.getAmount()/obj.getQty();
                qty = obj.getQty();

                Cogs objCogs = new Cogs();
                objCogs.setItemMasterId(ri.getItemMasterId());
                objCogs.setCogs(cogsValue);
                objCogs.setQty(qty);
                objCogs.setLastUpdate(new Date());
                objCogs.setRefId(ri.getOID());
                try{
                    DbCogs.insertExc(objCogs);
                }catch(Exception e){}

            }else{
                cogsValue = ((cogs.getCogs()*cogs.getQty()) + (obj.getAmount()*obj.getQty())) / (cogs.getQty() + obj.getQty());
                qty = cogs.getQty() + obj.getQty();
                updateCogs(ri.getItemMasterId(),ri.getOID(),cogsValue,qty);
            }

            if(im.getCogs() != cogsValue && cogsValue != 0){
                try{
                    if(im.getOID() != 0){
                        if(cogsValue != 0){
                            updateCogs(im.getOID(),cogsValue);
                            String memo = "Perhitungan System Rata-rata pembelian, incoming : "+r.getNumber()+",Qty : "+JSPFormater.formatNumber(ri.getQty(),"###,###.##")+", harga :"+JSPFormater.formatNumber(ri.getAmount(),"###,###.##")+", cogs : "+JSPFormater.formatNumber(cogsValue,"###,###.##");
                            HistoryUser hisUser = new HistoryUser();
                            hisUser.setUserId(0);
                            hisUser.setEmployeeId(0);
                            hisUser.setRefId(im.getOID());
                            hisUser.setDescription(memo);
                            hisUser.setType(DbHistoryUser.TYPE_COGS_MASTER);
                            hisUser.setDate(new Date());
                            try {
                                DbHistoryUser.insertExc(hisUser);
                            } catch (Exception e) {
                            }
                        }
                    }
            }catch(Exception e){}
            }

        }catch(Exception e){}
        finally {

        }

    }

    public static void updateCogs(long itemId,long receieveItemId,double cogs,double qty){
        try{
            String sql = "update cogs set qty='"+qty+"',cogs='"+cogs+"',ref_id='"+receieveItemId+"' "+
                    ",last_update='"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd HH:mm:ss")+"' where item_master_id = "+itemId;
             CONHandler.execUpdate(sql);
        }catch(Exception e){}
    }

    public static void updateCogs(long itemOid,double cogs){
        CONResultSet dbrs = null;
        try{
             String sql = "update pos_item_master set cogs ='"+cogs+"' where item_master_id='"+itemOid+"'";
             CONHandler.execUpdate(sql);
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
    }

    public static double getDiscount(long receiveId){
        CONResultSet dbrs = null;
        double discount = 0;
        try{
            String sql = "select r.receive_id,sum(ri.total_amount),round((r.discount_total/sum(ri.total_amount))*100,2) as discount from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id where r.receive_id = "+receiveId+" group by r.receive_id";
            dbrs = CONHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
		discount = rs.getDouble("discount");
            }
            rs.close();
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
        return discount;
    }

    public static ReceiveItem getReceive(long receiveId,long receiveItemId){
        CONResultSet dbrs = null;
        ReceiveItem ri = new ReceiveItem();
        try{
            String sql = "select sum(qty) as qty,sum(amount) as amount from "+
                    " (select qty as qty,0 as amount from pos_receive_item where receive_item_id = "+receiveItemId+" union "+
                    " select 0 as qty,total_amount as amount from pos_receive_item where receive_item_id = "+receiveItemId+" and is_bonus=0 ) as tbl ";
            dbrs = CONHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
		double qty = rs.getDouble("qty");
                double amount = rs.getDouble("amount");
                if(amount != 0){
                    double percentDisc = getDiscount(receiveId);
                    if(percentDisc != 0){
                        double disc = (percentDisc*amount)/100;
                        amount = amount - disc;
                    }
                }
                ri.setQty(qty);
                ri.setAmount(amount);
            }
            rs.close();
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
        return ri;
    }

    public static Cogs getCogs(long itemId){
        CONResultSet dbrs = null;
        Cogs objCogs = new Cogs();
        try{
            String sql = "select cogs_id,qty,cogs from cogs where item_master_id = "+itemId;
            dbrs = CONHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                long oid = rs.getLong("cogs_id");
                double qty = rs.getDouble("qty");
                double cogs = rs.getDouble("cogs");
                objCogs.setOID(oid);
                objCogs.setQty(qty);
                objCogs.setCogs(cogs);
            }
            rs.close();

        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
        return objCogs;
    }


    public static void updateItemAvgSumIncoming2(Receive r,ReceiveItem ri,ItemMaster im){
        
        CONResultSet dbrs = null;
        double cogs = 0;
        double total = 0;
        double qty = 0;
        String whereStr = "";
        String strDate = "";
        try{
            strDate = DbSystemProperty.getValueByName("DATE_START_CALC_COGS");
        }catch(Exception e){}
        if(strDate != null && !strDate.equalsIgnoreCase("Not initialized") && strDate.length() > 0){
            whereStr = " and r.approval_1_date >= '"+strDate+" 00:00:00'";
        }
        
        try{
            
            String sql = "select sum(qty) as tot_qty,sum(cogs) as total from ( "+
                        " (select m.item_master_id as item_id,m.code as code,typex,m.name as name,sum(qty) as qty,sum(round(total_amount - (discount_percent*total_amount/100),2)) as cogs from "+
                        " (select r.receive_id,r.type as typex,round(r.discount_total/sum(ri.total_amount)*100,2) as discount_percent from "+
                        " ((select r.* from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where r.type_ap in (0) and r.status in ('APPROVED','CHECKED') "+whereStr+" and ri.item_master_id = "+im.getOID()+" group by r.receive_id )) r "+
                        " inner join pos_receive_item ri on r.receive_id = ri.receive_id where r.type_ap in (0) and r.status in ('APPROVED','CHECKED') "+whereStr+" group by r.receive_id) rc inner join pos_receive_item ri on rc.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.item_master_id = "+im.getOID()+" group by ri.item_master_id) "+
                        " union "+
                        " (select m.item_master_id as item_id,m.code as code,typex,m.name,0 as qty,sum(round(total_amount - (discount_percent*total_amount/100),2)) as cogs from "+
                        " (select r.receive_id,r.type as typex,round(r.discount_total/sum(ri.total_amount)*100,2) as discount_percent from "+
                        " ((select r.* from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where r.type_ap in (4) and r.status in ('APPROVED','CHECKED') and r.approval_1_date <= '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd HH:mm:ss")+"' and ri.item_master_id = "+im.getOID()+" group by r.receive_id )) r "+
                        " inner join pos_receive_item ri on r.receive_id = ri.receive_id where r.type_ap in (4) and r.status in ('APPROVED','CHECKED') "+whereStr+" group by r.receive_id) rc inner join pos_receive_item ri on rc.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.item_master_id = "+im.getOID()+" group by ri.item_master_id ) " +
                        
                        " union "+
                        " (select m.item_master_id as item_id,m.code as code,typex,m.name,sum(qty) as qty,0 as cogs from "+
                        " (select r.receive_id,r.type as typex,round(r.discount_total/sum(ri.total_amount)*100,2) as discount_percent from "+
                        " ((select r.* from pos_receive r inner join pos_receive_item ri on r.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where r.type_ap in (3) and r.status in ('APPROVED','CHECKED') "+whereStr+" and ri.item_master_id = "+im.getOID()+" group by r.receive_id )) r "+
                        " inner join pos_receive_item ri on r.receive_id = ri.receive_id where r.type_ap in (3) and r.status in ('APPROVED','CHECKED') "+whereStr+" group by r.receive_id) rc inner join pos_receive_item ri on rc.receive_id = ri.receive_id inner join pos_item_master m on ri.item_master_id = m.item_master_id where ri.item_master_id = "+im.getOID()+" group by ri.item_master_id ) " +
                        
                        " ) as x "; 
            
            dbrs = CONHandler.execQueryResult(sql);
	    ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
		total = rs.getDouble("total");		
                qty = rs.getDouble("tot_qty");	
                
                if(qty !=0){
                    cogs = total/qty;
                }
            }
            rs.close();            
            
        }catch(Exception e) {
            System.out.println(e);
        }finally {
            CONResultSet.close(dbrs);
        }
        
        if(im.getCogs() != cogs && cogs != 0){
            try{
                im.setCogs(cogs);
                DbItemMaster.updateExc(im);
                String memo = "Perhitungan System Rata-rata pembelian, incoming : "+r.getNumber()+",Qty : "+JSPFormater.formatNumber(ri.getQty(),"###,###.##")+", harga :"+JSPFormater.formatNumber(ri.getAmount(),"###,###.##")+". Total Pembelian Kesluruhan : "+JSPFormater.formatNumber(total,"###,###.##")+" dan qty : "+JSPFormater.formatNumber(qty,"###,###.##")+", cogs : "+JSPFormater.formatNumber(cogs,"###,###.##");
                HistoryUser hisUser = new HistoryUser();
                hisUser.setUserId(0);
                hisUser.setEmployeeId(0);
                hisUser.setRefId(im.getOID());
                hisUser.setDescription(memo);
                hisUser.setType(DbHistoryUser.TYPE_COGS_MASTER);
                hisUser.setDate(new Date());
                try {
                    DbHistoryUser.insertExc(hisUser);
                } catch (Exception e) {
                }
            }catch(Exception e){}    
        }
    }
    
    public static void updateItemAverageSummaryIncoming(ReceiveItem ri, ItemMaster im){        
        try{                
            double totalStock = DbStock.getItemTotalStockConsigment(im.getOID()); 
            double totalCost = (totalStock * im.getCogs_consigment()) + (ri.getTotalAmount());
            totalStock = totalStock + (ri.getQty() * im.getUomPurchaseStockQty() );
            im.setCogs_consigment(totalCost/totalStock);            
            DbItemMaster.updateExc(im);
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        
    }
    
    
    public static void updateItemLastPriceCost(ReceiveItem ri){
        
        ItemMaster im = new ItemMaster();
        
        try{
            im = DbItemMaster.fetchExc(ri.getItemMasterId());        
            double totalStock = ri.getQty();
            im.setCogs(ri.getTotalAmount()/totalStock);            
            DbItemMaster.updateExc(im);
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        
    }
    public static void updateItemLastPriceCostConsigment(ReceiveItem ri){
        
        ItemMaster im = new ItemMaster();
        
        try{
            im = DbItemMaster.fetchExc(ri.getItemMasterId());        
            double totalStock = ri.getQty();
            im.setCogs_consigment(ri.getTotalAmount()/totalStock);            
            DbItemMaster.updateExc(im);
        }
        catch(Exception e){
            System.out.println(e.toString());
        }        
    }
    
    public static void inesertReceiveItem(long receiveId,Vector vReceiveItem){
        if(receiveId != 0){
            try{                
                deleteAllItem(receiveId);    
                double total = 0;
                if(vReceiveItem != null && vReceiveItem.size() > 0){                    
                    for(int i = 0; i < vReceiveItem.size(); i++){                        
                        ReceiveItem ri = (ReceiveItem)vReceiveItem.get(i);   
                        total = total + ri.getAmount();
                        ri.setReceiveId(receiveId);
                        long oid = DbReceiveItem.insertExc(ri);
                        updateAmount(oid,ri.getAmount());
                    }
                }                
                try{
                    Receive receive = DbReceive.fetchExc(receiveId);
                    total = total * -1;
                    receive.setTotalAmount(total);
                    DbReceive.updateExc(receive);
                }catch(Exception e){}
            }catch(Exception e){
                System.out.print(e);
            }
        }
    }
    
    
    public static void updateAmount(long receiveItemId,double amount){
        CONResultSet dbrs = null;
        
        try{
            double x = amount * -1;
            String sql = "UPDATE "+DbReceiveItem.DB_RECEIVE_ITEM+" set "+DbReceiveItem.colNames[DbReceiveItem.COL_AMOUNT]+" = "+x+","+
                    DbReceiveItem.colNames[DbReceiveItem.COL_TOTAL_AMOUNT]+" = "+x+" where "+DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID]+" = "+receiveItemId;
            CONHandler.execUpdate(sql);
            
        }catch(Exception e){
            System.out.println("Exception");
        }finally{
            CONResultSet.close(dbrs);
        }
    }
    
    public static double getTotalAmount(long receiveId){
        
        String sql = "select sum("+colNames[COL_AMOUNT]+") from "+DB_RECEIVE_ITEM+" where "+colNames[COL_RECEIVE_ID]+"="+receiveId;
        
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
    
     public static Vector getTotalQty(long vendorId, long locationId, Date startDate, Date endDate){
		CONResultSet dbrs = null;
                Vector vt = new Vector();
		try {
			String sql = "SELECT SUM(pi.qty) as qtypo  , SUM(ri.qty) as qtyrec FROM pos_purchase p LEFT JOIN pos_receive r " +
                                " ON p.purchase_id=r.purchase_id inner join pos_purchase_item pi on p.purchase_id=pi.purchase_id " +
                                " LEFT JOIN pos_receive_item ri ON pi.purchase_item_id=ri.purchase_item_id " +
                                " where p.vendor_id="+ vendorId ;
                        if(locationId!=0){
                            sql = sql + " and p.location_id="+ locationId;
                        }
                        
                        sql = sql + " and to_days(p.purch_date) between to_days('" + JSPFormater.formatDate(startDate,"yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") +"')";       
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			
			while(rs.next()) {
                            vt.add(rs.getDouble("qtypo"));
                            vt.add(rs.getDouble("qtyrec"));
                        }

			rs.close();
			return vt;
		}catch(Exception e) {
			return vt;
		}finally {
			CONResultSet.close(dbrs);
		}
	}
     public static Vector getDetailServiceLevel(long vendorId, long locationId, Date startDate, Date endDate){
		CONResultSet dbrs = null;
                Vector vt = new Vector();
		try {
			String sql = "SELECT p.number as ponumber, r.number as recnumber, im.code, im.barcode, " +
                                " im.name, pi.qty as qtypo, ri.qty as qtyrec, p.purch_date as tanggal  FROM pos_purchase p LEFT JOIN pos_receive r " +
                                " ON p.purchase_id=r.purchase_id inner join pos_purchase_item pi on p.purchase_id=pi.purchase_id " +
                                " LEFT JOIN pos_receive_item ri ON pi.purchase_item_id=ri.purchase_item_id " +
                                " INNER JOIN pos_item_master im ON pi.item_master_id=im.item_master_id " +
                                " where  p.vendor_id="+ vendorId ;
                        if(locationId!=0){
                            sql = sql + " and p.location_id="+ locationId;
                        }
                        
                        sql = sql + " and to_days(p.purch_date) between to_days('" + JSPFormater.formatDate(startDate,"yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") +"')";       
                               
			sql= sql + " order by p.purchase_id";
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			
			while(rs.next()){
                            Vector vtdet = new Vector();
                            vtdet.add(rs.getString("ponumber"));
                            if(rs.getString("recnumber")!=null){
                                vtdet.add(rs.getString("recnumber"));
                            }else{
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
		}catch(Exception e) {
			return vt;
		}finally {
			CONResultSet.close(dbrs);
		}
	}
     
     
     public static Vector getReceiveKomisi(String whereClause){
		CONResultSet dbrs = null;
                Vector vt = new Vector();
		try {
			String sql = "SELECT sd.product_master_id, sum(sd.qty * sd.selling_price) as tot from pos_sales s inner join pos_sales_detail sd on s.sales_id=sd.sales_id where " + whereClause + " group by sd.product_master_id" ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			
			while(rs.next()){
                            Vector vtdet = new Vector();
                            vtdet.add(rs.getString("product_master_id"));
                            vtdet.add(rs.getString("tot"));
                            vt.add(vtdet);
                        }

			rs.close();
			return vt;
		}catch(Exception e) {
			return vt;
		}finally {
			CONResultSet.close(dbrs);
		}
    }
     
     
     
     
    public static int updateKomisi(Date start,Date end,long locationId,long itemId){
        
        if(start == null || end == null || locationId == 0 || itemId == 0){            
            return 0;
        }
        
        CONResultSet dbrs = null;
        try{
             
            String sql = "select sd.sales_detail_id as sd_id from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                    " where sd.product_master_id = "+itemId+" and s.date between '"+JSPFormater.formatDate(start, "yyyy-MM-dd")+" 00:00:00' and '"+JSPFormater.formatDate(end, "yyyy-MM-dd")+" 23:59:59' and s.location_id = "+locationId;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();            
			
            while(rs.next()){
                long salesDetailId = rs.getLong("sd_id");
                if(salesDetailId != 0){
                    updateStatusKomisi(salesDetailId);
                }
            }
            rs.close();
             
        }catch(Exception e){}        
        finally {
            CONResultSet.close(dbrs);
        }
        return 1;
    }
    
    public static void updateStatusKomisi(long salesDetailId){
        CONResultSet dbrs = null;
        try{
             String sql = "update pos_sales_detail set status_komisi=1 where sales_detail_id  = " + salesDetailId;             
             CONHandler.execUpdate(sql);
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
     }
    
}
