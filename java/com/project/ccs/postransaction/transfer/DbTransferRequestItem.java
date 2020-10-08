/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.transfer;


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
import com.project.ccs.postransaction.*;
import com.project.general.*;
import com.project.util.*;

/**
 *
 * @author Roy Andika
 */
public class DbTransferRequestItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_TRANSFER_REQUEST_ITEM = "pos_transfer_request_item";
    
    public static final int COL_TRANSFER_REQUEST_ITEM_ID = 0;
    public static final int COL_TRANSFER_REQUEST_ID = 1;
    public static final int COL_ITEM_MASTER_ID = 2;
    public static final int COL_QTY = 3;
    public static final int COL_DATE = 4;    
    public static final int COL_USER_ID = 5;   
    public static final int COL_ITEM_BARCODE = 6;   
    
    public static final String[] colNames = {
        "transfer_request_item_id",
        "transfer_request_id",
        "item_master_id",
        "qty",
        "date",
        "user_id",
        "item_barcode"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,        
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING
    };

    public DbTransferRequestItem() {
    }

    public DbTransferRequestItem(int i) throws CONException {
        super(new DbTransferRequestItem());
    }

    public DbTransferRequestItem(String sOid) throws CONException {
        super(new DbTransferRequestItem(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbTransferRequestItem(long lOid) throws CONException {
        super(new DbTransferRequestItem(0));
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
        return DB_POS_TRANSFER_REQUEST_ITEM;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbTransferRequestItem().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        TransferRequestItem transferRequestItem = fetchExc(ent.getOID());
        ent = (Entity) transferRequestItem;
        return transferRequestItem.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((TransferRequestItem) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((TransferRequestItem) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static TransferRequestItem fetchExc(long oid) throws CONException {
        try {
            TransferRequestItem transferRequestItem = new TransferRequestItem();
            DbTransferRequestItem pstTransferRequestItem = new DbTransferRequestItem(oid);
            transferRequestItem.setOID(oid);
            transferRequestItem.setTransferRequestId(pstTransferRequestItem.getlong(COL_TRANSFER_REQUEST_ID)); 
            transferRequestItem.setItemMasterId(pstTransferRequestItem.getlong(COL_ITEM_MASTER_ID));
            transferRequestItem.setQty(pstTransferRequestItem.getdouble(COL_QTY));
            transferRequestItem.setDate(pstTransferRequestItem.getDate(COL_DATE));
            transferRequestItem.setUserId(pstTransferRequestItem.getlong(COL_USER_ID));            
            transferRequestItem.setItemBarcode(pstTransferRequestItem.getString(COL_ITEM_BARCODE));           
            return transferRequestItem;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferRequestItem(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(TransferRequestItem transferRequestItem) throws CONException {
        try {
            DbTransferRequestItem pstTransferRequestItem = new DbTransferRequestItem(0);
            pstTransferRequestItem.setLong(COL_TRANSFER_REQUEST_ID, transferRequestItem.getTransferRequestId());
            pstTransferRequestItem.setLong(COL_ITEM_MASTER_ID, transferRequestItem.getItemMasterId());
            pstTransferRequestItem.setDouble(COL_QTY, transferRequestItem.getQty());
            pstTransferRequestItem.setDate(COL_DATE, transferRequestItem.getDate());
            pstTransferRequestItem.setLong(COL_USER_ID, transferRequestItem.getUserId());
            pstTransferRequestItem.setString(COL_ITEM_BARCODE, transferRequestItem.getItemBarcode());
            pstTransferRequestItem.insert();
            transferRequestItem.setOID(pstTransferRequestItem.getlong(COL_TRANSFER_REQUEST_ITEM_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferRequestItem(0), CONException.UNKNOWN);
        }
        return transferRequestItem.getOID();
    }

    public static long updateExc(TransferRequestItem transferRequestItem) throws CONException {
        try {
            if (transferRequestItem.getOID() != 0) {
                DbTransferRequestItem pstTransferRequestItem = new DbTransferRequestItem(transferRequestItem.getOID());
                pstTransferRequestItem.setLong(COL_TRANSFER_REQUEST_ID, transferRequestItem.getTransferRequestId());
                pstTransferRequestItem.setLong(COL_ITEM_MASTER_ID, transferRequestItem.getItemMasterId());
                pstTransferRequestItem.setDouble(COL_QTY, transferRequestItem.getQty());
                pstTransferRequestItem.setDate(COL_DATE, transferRequestItem.getDate());
                pstTransferRequestItem.setLong(COL_USER_ID, transferRequestItem.getUserId());
                pstTransferRequestItem.setString(COL_ITEM_BARCODE, transferRequestItem.getItemBarcode());
                pstTransferRequestItem.update();
                return transferRequestItem.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferRequestItem(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbTransferRequestItem pstTransferRequestItem = new DbTransferRequestItem(oid);
            pstTransferRequestItem.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferRequestItem(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_TRANSFER_REQUEST_ITEM;
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
                TransferRequestItem transferRequestItem = new TransferRequestItem();
                resultToObject(rs, transferRequestItem);
                lists.add(transferRequestItem);
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

    private static void resultToObject(ResultSet rs, TransferRequestItem transferRequestItem) {
        try {
            transferRequestItem.setOID(rs.getLong(DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ITEM_ID]));
            transferRequestItem.setTransferRequestId(rs.getLong(DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ID]));
            transferRequestItem.setItemMasterId(rs.getLong(DbTransferRequestItem.colNames[DbTransferRequestItem.COL_ITEM_MASTER_ID]));
            transferRequestItem.setQty(rs.getDouble(DbTransferRequestItem.colNames[DbTransferRequestItem.COL_QTY]));
            transferRequestItem.setDate(rs.getDate(DbTransferRequestItem.colNames[DbTransferRequestItem.COL_DATE]));
            transferRequestItem.setUserId(rs.getLong(DbTransferRequestItem.colNames[DbTransferRequestItem.COL_USER_ID]));
            transferRequestItem.setItemBarcode(rs.getString(DbTransferRequestItem.colNames[DbTransferRequestItem.COL_ITEM_BARCODE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long transferRequestItemId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_TRANSFER_REQUEST_ITEM + " WHERE " +
                    DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ITEM_ID] + " = " + transferRequestItemId;

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
            String sql = "SELECT COUNT(" + DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ITEM_ID] + ") FROM " + DB_POS_TRANSFER_REQUEST_ITEM;
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
                    TransferRequestItem transferRequestItem = (TransferRequestItem) list.get(ls);
                    if (oid == transferRequestItem.getOID()) {
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
