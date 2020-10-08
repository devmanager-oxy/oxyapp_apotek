package com.project.ccs.postransaction.adjusment;

import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.DbUom;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.posmaster.Uom;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;
import com.project.ccs.postransaction.stock.*;

public class DbAdjusmentItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_ADJUSMENT_ITEM = "pos_adjusment_item";
    public static final int COL_ADJUSMENT_ITEM_ID = 0;
    public static final int COL_ADJUSMENT_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_QTY_SYSTEM = 3;
    public static final int COL_QTY_REAL = 4;
    public static final int COL_QTY_BALANCE = 5;
    public static final int COL_PRICE = 6;
    public static final int COL_AMOUNT = 7;
    public static final int COL_TYPE = 8;
    public static final int COL_COMPANY_ID = 9;
    
    public static final String[] colNames = {
        "adjusment_item_id",
        "adjusment_id",
        "item_master_id",
        "qty_system",
        "qty_real",
        "qty_balance",
        "price",
        "amount", 
        "type",
        "company_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT3,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_LONG
    };

    public static final int TYPE_NON_CONSIGMENT = 0;
    public static final int TYPE_CONSIGMENT = 1;
    
    public DbAdjusmentItem() {
    }

    public DbAdjusmentItem(int i) throws CONException {
        super(new DbAdjusmentItem());
    }

    public DbAdjusmentItem(String sOid) throws CONException {
        super(new DbAdjusmentItem(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbAdjusmentItem(long lOid) throws CONException {
        super(new DbAdjusmentItem(0));
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
        return DB_POS_ADJUSMENT_ITEM;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbAdjusmentItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        AdjusmentItem adjusmentitem = fetchExc(ent.getOID());
        ent = (Entity) adjusmentitem;
        return adjusmentitem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((AdjusmentItem) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((AdjusmentItem) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static AdjusmentItem fetchExc(long oid) throws CONException {
        try {
            AdjusmentItem adjusmentitem = new AdjusmentItem();
            DbAdjusmentItem pstAdjusmentItem = new DbAdjusmentItem(oid);
            adjusmentitem.setOID(oid);

            adjusmentitem.setAdjusmentId(pstAdjusmentItem.getlong(COL_ADJUSMENT_ID));
            adjusmentitem.setItemMasterId(pstAdjusmentItem.getlong(COL_ITEM_MASTER_ID));
            adjusmentitem.setQtySystem(pstAdjusmentItem.getdouble(COL_QTY_SYSTEM));
            adjusmentitem.setQtyReal(pstAdjusmentItem.getdouble(COL_QTY_REAL));
            
            adjusmentitem.setQtyBalance(pstAdjusmentItem.getdouble(COL_QTY_BALANCE));
            adjusmentitem.setPrice(pstAdjusmentItem.getdouble(COL_PRICE));
            adjusmentitem.setAmount(pstAdjusmentItem.getdouble(COL_AMOUNT));
            adjusmentitem.setType(pstAdjusmentItem.getInt(COL_TYPE));
            adjusmentitem.setCompany_id(pstAdjusmentItem.getlong(COL_COMPANY_ID));
            
            return adjusmentitem;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAdjusmentItem(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(AdjusmentItem adjusmentitem) throws CONException {
        try {
            DbAdjusmentItem pstAdjusmentItem = new DbAdjusmentItem(0);

            pstAdjusmentItem.setLong(COL_ADJUSMENT_ID, adjusmentitem.getAdjusmentId());
            pstAdjusmentItem.setLong(COL_ITEM_MASTER_ID, adjusmentitem.getItemMasterId());
            pstAdjusmentItem.setDouble(COL_QTY_SYSTEM, adjusmentitem.getQtySystem());
            pstAdjusmentItem.setDouble(COL_QTY_REAL, adjusmentitem.getQtyReal());

            pstAdjusmentItem.setDouble(COL_QTY_BALANCE, adjusmentitem.getQtyBalance());
            pstAdjusmentItem.setDouble(COL_PRICE, adjusmentitem.getPrice());
            pstAdjusmentItem.setDouble(COL_AMOUNT, adjusmentitem.getAmount());
            pstAdjusmentItem.setInt(COL_TYPE, adjusmentitem.getType());
            pstAdjusmentItem.setLong(COL_COMPANY_ID, adjusmentitem.getCompany_id());
            
            pstAdjusmentItem.insert();
            adjusmentitem.setOID(pstAdjusmentItem.getlong(COL_ADJUSMENT_ITEM_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAdjusmentItem(0), CONException.UNKNOWN);
        }
        return adjusmentitem.getOID();
    }

    public static long updateExc(AdjusmentItem adjusmentitem) throws CONException {
        try {
            if (adjusmentitem.getOID() != 0) {
                DbAdjusmentItem pstAdjusmentItem = new DbAdjusmentItem(adjusmentitem.getOID());

                pstAdjusmentItem.setLong(COL_ADJUSMENT_ID, adjusmentitem.getAdjusmentId());
                pstAdjusmentItem.setLong(COL_ITEM_MASTER_ID, adjusmentitem.getItemMasterId());
                pstAdjusmentItem.setDouble(COL_QTY_REAL, adjusmentitem.getQtyReal());
                pstAdjusmentItem.setDouble(COL_QTY_SYSTEM, adjusmentitem.getQtySystem());
                
                pstAdjusmentItem.setDouble(COL_QTY_BALANCE, adjusmentitem.getQtyBalance());
                pstAdjusmentItem.setDouble(COL_PRICE, adjusmentitem.getPrice());
                pstAdjusmentItem.setDouble(COL_AMOUNT, adjusmentitem.getAmount());
                pstAdjusmentItem.setInt(COL_TYPE, adjusmentitem.getType());
                
                pstAdjusmentItem.update();
                return adjusmentitem.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAdjusmentItem(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbAdjusmentItem pstAdjusmentItem = new DbAdjusmentItem(oid);
            pstAdjusmentItem.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbAdjusmentItem(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_ADJUSMENT_ITEM;
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
                AdjusmentItem adjusmentitem = new AdjusmentItem();
                resultToObject(rs, adjusmentitem);
                lists.add(adjusmentitem);
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

    private static void resultToObject(ResultSet rs, AdjusmentItem adjusmentitem) {
        try {
            adjusmentitem.setOID(rs.getLong(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ITEM_ID]));
            adjusmentitem.setAdjusmentId(rs.getLong(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ID]));
            adjusmentitem.setItemMasterId(rs.getLong(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ITEM_MASTER_ID]));
            adjusmentitem.setQtyReal(rs.getDouble(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_QTY_REAL]));
            adjusmentitem.setQtySystem(rs.getDouble(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_QTY_SYSTEM]));
            
            adjusmentitem.setQtyBalance(rs.getDouble(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_QTY_BALANCE]));
            adjusmentitem.setPrice(rs.getDouble(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_PRICE]));
            adjusmentitem.setAmount(rs.getDouble(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_AMOUNT]));
            adjusmentitem.setType(rs.getInt(DbAdjusmentItem.colNames[DbAdjusmentItem.COL_TYPE]));
            
        } catch (Exception e) {
            System.out.println("Err >>> "+e.toString());
        }
    }

    public static boolean checkOID(long adjusmentItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_ADJUSMENT_ITEM + " WHERE " +
                    DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ITEM_ID] + " = " + adjusmentItemId;

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

    public static double getTotalQtyAdjusment(long adjusmentId, String colNames) {
        CONResultSet dbrs = null;
        double totalQty = 0.0; 
        try {
            String sql = "SELECT SUM("+colNames+") as TOTALQTY FROM " + DB_POS_ADJUSMENT_ITEM + " WHERE " +
                    DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ID] + " = " + adjusmentId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                totalQty = rs.getDouble("TOTALQTY");
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return totalQty;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ITEM_ID] + ") FROM " + DB_POS_ADJUSMENT_ITEM;
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
                    AdjusmentItem adjusmentitem = (AdjusmentItem) list.get(ls);
                    if (oid == adjusmentitem.getOID()) {
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
    
    
    public static int deleteAllItem(long oidAdjusment){
        
        int result = 0;
        
        String sql = "delete from "+DB_POS_ADJUSMENT_ITEM+" where "+colNames[COL_ADJUSMENT_ID]+" = "+oidAdjusment;
        try{
            CONHandler.execUpdate(sql);
        }
        catch(Exception e){
            result = -1;
        }
        
        return result;
    }
    
    
    public static void proceedStock(Adjusment adjustment){
        
        System.out.println("in/out stock - adjusment ...");    
            
        Vector temp = DbAdjusmentItem.list(0,0, colNames[COL_ADJUSMENT_ID]+"="+adjustment.getOID(), "");
        
        //System.out.println("temp : "+temp);    
        
        if(temp!=null && temp.size()>0){
            for(int i=0; i<temp.size(); i++){
                AdjusmentItem ri = (AdjusmentItem)temp.get(i);                
                insertAdjustmentGoods(adjustment, ri);                
            }            
        }
        
    } 
    
    public static void insertAdjustmentGoods(Adjusment ret, AdjusmentItem ri){
            
        try{

            //System.out.println("inserting new retur stock ...");

            ItemMaster im = new ItemMaster();
            im = DbItemMaster.fetchExc(ri.getItemMasterId());
            Uom uom = DbUom.fetchExc(im.getUomStockId());

            Stock stock = new Stock();
            stock.setAdjustmentId(ret.getOID());
            double adj = ri.getQtyBalance();
            if(adj<0){
                stock.setInOut(DbStock.STOCK_OUT);
                adj = adj * -1;
            }
            else{
                stock.setInOut(DbStock.STOCK_IN);
            }
            stock.setItemBarcode(im.getBarcode());
            stock.setItemCode(im.getCode());
            stock.setItemMasterId(im.getOID());
            stock.setItemName(im.getName());
            stock.setLocationId(ret.getLocationId());
            stock.setDate(new java.util.Date());//ret.getDate());
            stock.setNoFaktur(ret.getNumber());
            stock.setPrice(im.getCogs());
            stock.setTotal(im.getCogs() * adj);
            stock.setQty(adj);
            stock.setType(DbStock.TYPE_ADJUSTMENT);
            stock.setUnitId(im.getUomStockId());
            stock.setUnit(uom.getUnit());
            stock.setUserId(ret.getUserId());
            stock.setType_item(ret.getType());
            stock.setAdjustment_item_id(ri.getOID());
            stock.setStatus(ret.getStatus());

            DbStock.insertExc(stock);


        }
        catch(Exception e){

        }

    }
    
    
    public static double getTotalAdjustmentAmount(long adjId){
        
        String sql = "SELECT sum("+colNames[COL_AMOUNT]+") "+
                " FROM "+DB_POS_ADJUSMENT_ITEM+
                " where "+colNames[COL_ADJUSMENT_ID]+"="+adjId;
        
        double result = 0; 
        
        CONResultSet crs = null;
        try{
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
    
}
