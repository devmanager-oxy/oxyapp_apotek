/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.request;

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

public class DbPurchaseRequestItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PURCHASE_REQUEST_ITEM = "pos_purchase_request_item";
    public static final int COL_PURCHASE_REQUEST_ITEM_ID = 0;
    public static final int COL_PURCHASE_REQUEST_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_QTY = 3;
    public static final int COL_UOM_ID = 4;
    public static final int COL_STATUS = 5;
    public static final int COL_ITEM_STATUS = 6;
    public static final int COL_PROCESS_QTY = 7;
    
    public static final String[] colNames = {
        "purchase_request_item_id",
        "purchase_request_id",
        "item_master_id",
        "qty",
        "uom_id",
        "status",
        "item_status",
        "process_qty"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT
    };

    
    public static int STATUS_PENDING = 1;
    public static int STATUS_REFUSED = 2;
    public static String[] strItemStatus = {"-","Pending", "Refused"};
    
    public DbPurchaseRequestItem() {
    }

    public DbPurchaseRequestItem(int i) throws CONException {
        super(new DbPurchaseRequestItem());
    }

    public DbPurchaseRequestItem(String sOid) throws CONException {
        super(new DbPurchaseRequestItem(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPurchaseRequestItem(long lOid) throws CONException {
        super(new DbPurchaseRequestItem(0));
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
        return DB_PURCHASE_REQUEST_ITEM;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPurchaseRequestItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PurchaseRequestItem purchaseRequestItem = fetchExc(ent.getOID());
        ent = (Entity) purchaseRequestItem;
        return purchaseRequestItem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PurchaseRequestItem) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PurchaseRequestItem) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PurchaseRequestItem fetchExc(long oid) throws CONException {
        try {
            PurchaseRequestItem purchaseRequestItem = new PurchaseRequestItem();
            DbPurchaseRequestItem dbPurchaseRequestItem = new DbPurchaseRequestItem(oid);
            purchaseRequestItem.setOID(oid);

            purchaseRequestItem.setPurchaseRequestId(dbPurchaseRequestItem.getlong(COL_PURCHASE_REQUEST_ID));
            purchaseRequestItem.setItemMasterId(dbPurchaseRequestItem.getlong(COL_ITEM_MASTER_ID));
            purchaseRequestItem.setQty(dbPurchaseRequestItem.getdouble(COL_QTY));
            purchaseRequestItem.setUomId(dbPurchaseRequestItem.getlong(COL_UOM_ID));
            purchaseRequestItem.setStatus(dbPurchaseRequestItem.getString(COL_STATUS));
            purchaseRequestItem.setStatus(dbPurchaseRequestItem.getString(COL_STATUS));
            
            purchaseRequestItem.setItemStatus(dbPurchaseRequestItem.getInt(COL_ITEM_STATUS));
            purchaseRequestItem.setProcessQty(dbPurchaseRequestItem.getInt(COL_PROCESS_QTY));

            return purchaseRequestItem;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseRequestItem(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PurchaseRequestItem purchaseRequestItem) throws CONException {
        try {
            DbPurchaseRequestItem pstPurchaseRequestItem = new DbPurchaseRequestItem(0);

            pstPurchaseRequestItem.setLong(COL_PURCHASE_REQUEST_ID, purchaseRequestItem.getPurchaseRequestId());
            pstPurchaseRequestItem.setLong(COL_ITEM_MASTER_ID, purchaseRequestItem.getItemMasterId());
            pstPurchaseRequestItem.setDouble(COL_QTY, purchaseRequestItem.getQty());
            pstPurchaseRequestItem.setLong(COL_UOM_ID, purchaseRequestItem.getUomId());
            pstPurchaseRequestItem.setString(COL_STATUS, purchaseRequestItem.getStatus());
            
            pstPurchaseRequestItem.setInt(COL_ITEM_STATUS, purchaseRequestItem.getItemStatus());
            pstPurchaseRequestItem.setInt(COL_PROCESS_QTY, purchaseRequestItem.getProcessQty());

            pstPurchaseRequestItem.insert();
            purchaseRequestItem.setOID(pstPurchaseRequestItem.getlong(COL_PURCHASE_REQUEST_ITEM_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseRequestItem(0), CONException.UNKNOWN);
        }
        return purchaseRequestItem.getOID();
    }

    public static long updateExc(PurchaseRequestItem purchaseRequestItem) throws CONException {
        try {
            if (purchaseRequestItem.getOID() != 0) {
                DbPurchaseRequestItem pstPurchaseRequestItem = new DbPurchaseRequestItem(purchaseRequestItem.getOID());

                pstPurchaseRequestItem.setLong(COL_PURCHASE_REQUEST_ID, purchaseRequestItem.getPurchaseRequestId());
                pstPurchaseRequestItem.setLong(COL_ITEM_MASTER_ID, purchaseRequestItem.getItemMasterId());
                pstPurchaseRequestItem.setDouble(COL_QTY, purchaseRequestItem.getQty());
                pstPurchaseRequestItem.setLong(COL_UOM_ID, purchaseRequestItem.getUomId());
                pstPurchaseRequestItem.setString(COL_STATUS, purchaseRequestItem.getStatus());

                pstPurchaseRequestItem.setInt(COL_ITEM_STATUS, purchaseRequestItem.getItemStatus());
                pstPurchaseRequestItem.setInt(COL_PROCESS_QTY, purchaseRequestItem.getProcessQty());

                pstPurchaseRequestItem.update();
                return purchaseRequestItem.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseRequestItem(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPurchaseRequestItem pstPurchaseRequestItem = new DbPurchaseRequestItem(oid);
            pstPurchaseRequestItem.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseRequestItem(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static long deleteAllItem(long oidMain) throws CONException {
        try {
            String sql = "DELETE FROM " + DB_PURCHASE_REQUEST_ITEM +
                    " WHERE "+colNames[COL_PURCHASE_REQUEST_ID]+"="+oidMain;
            CONHandler.execUpdate(sql);
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseRequestItem(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PURCHASE_REQUEST_ITEM;
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
                PurchaseRequestItem purchaseRequestItem = new PurchaseRequestItem();
                resultToObject(rs, purchaseRequestItem);
                lists.add(purchaseRequestItem);
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

    public static void resultToObject(ResultSet rs, PurchaseRequestItem purchaseRequestItem) {
        try {
            purchaseRequestItem.setOID(rs.getLong(DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ITEM_ID]));
            purchaseRequestItem.setPurchaseRequestId(rs.getLong(DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID]));
            purchaseRequestItem.setItemMasterId(rs.getLong(DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_ITEM_MASTER_ID]));
            purchaseRequestItem.setQty(rs.getDouble(DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_QTY]));
            purchaseRequestItem.setUomId(rs.getLong(DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_UOM_ID]));
            purchaseRequestItem.setStatus(rs.getString(DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_STATUS]));
            
            purchaseRequestItem.setItemStatus(rs.getInt(DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_ITEM_STATUS]));
            purchaseRequestItem.setProcessQty(rs.getInt(DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PROCESS_QTY]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long purchaseRequestItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PURCHASE_REQUEST_ITEM + " WHERE " +
                    DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ITEM_ID] + " = " + purchaseRequestItemId;

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

    public static boolean checkPrToPOReadyClosed(long purchaseRequestId) {
        CONResultSet dbrs = null;
        boolean result = true;
        try {
            String sql = "SELECT * FROM " + DB_PURCHASE_REQUEST_ITEM + " WHERE " +
                    " " + DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID] + " = " + purchaseRequestId+
                    " AND " + DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_ITEM_STATUS] + " != " + STATUS_REFUSED+
                    " AND (" + DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_QTY]+" >= "+
                    DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PROCESS_QTY]+")";
            
            System.out.println("sql : "+sql);
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                result = false;
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
            String sql = "SELECT COUNT(" + DbPurchaseRequestItem.colNames[DbPurchaseRequestItem.COL_PURCHASE_REQUEST_ID] + ") FROM " + DB_PURCHASE_REQUEST_ITEM;
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
                    PurchaseRequestItem purchaseRequestItem = (PurchaseRequestItem) list.get(ls);
                    if (oid == purchaseRequestItem.getOID()) {
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
}
