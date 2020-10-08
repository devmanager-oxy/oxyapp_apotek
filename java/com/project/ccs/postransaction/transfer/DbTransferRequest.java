/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.transfer;
import com.project.I_Project;

import com.project.ccs.postransaction.stock.DbStock;
import java.util.Date;
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
import com.project.general.*;
import com.project.util.*;
/**
 *
 * @author Roy Andika
 */
public class DbTransferRequest extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_TRANSFER_REQUEST = "pos_transfer_request";
    
    public static final int COL_TRANSFER_REQUEST_ID = 0;
    public static final int COL_DATE = 1;
    public static final int COL_STATUS = 2;
    public static final int COL_FROM_LOCATION_ID = 3;
    public static final int COL_TO_LOCATION_ID = 4;
    public static final int COL_NOTE = 5;
    public static final int COL_COUNTER = 6;
    public static final int COL_NUMBER = 7;
    public static final int COL_APPROVAL_1 = 8;    
    public static final int COL_USER_ID = 9;
    public static final int COL_PREFIX_NUMBER = 10;
    public static final int COL_APPROVAL_1_DATE = 11;    
    public static final int COL_GEN_ID = 12;    
    public static final int COL_CREATE_DATE = 13;    
    
    public static final String[] colNames = {
        "transfer_request_id",
        "date",
        "status",
        "from_location_id",
        "to_location_id",
        "note",
        "counter",
        "number",
        "approval_1",        
        "user_id",
        "prefix_number",
        "approval_1_date",
        "gen_id",
        "create_date"
    };        
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_DATE
    };

    public DbTransferRequest() {
    }

    public DbTransferRequest(int i) throws CONException {
        super(new DbTransferRequest());
    }

    public DbTransferRequest(String sOid) throws CONException {
        super(new DbTransferRequest(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbTransferRequest(long lOid) throws CONException {
        super(new DbTransferRequest(0));
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
        return DB_POS_TRANSFER_REQUEST;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbTransferRequest().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        TransferRequest transferRequest = fetchExc(ent.getOID());
        ent = (Entity) transferRequest; 
        return transferRequest.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((TransferRequest) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((TransferRequest) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static TransferRequest fetchExc(long oid) throws CONException {
        try {
            TransferRequest transferRequest = new TransferRequest();
            DbTransferRequest pstTransferRequest = new DbTransferRequest(oid);
            transferRequest.setOID(oid);  

            transferRequest.setDate(pstTransferRequest.getDate(COL_DATE));
            transferRequest.setStatus(pstTransferRequest.getString(COL_STATUS));
            transferRequest.setFromLocationId(pstTransferRequest.getlong(COL_FROM_LOCATION_ID));
            transferRequest.setToLocationId(pstTransferRequest.getlong(COL_TO_LOCATION_ID));
            transferRequest.setNote(pstTransferRequest.getString(COL_NOTE));
            transferRequest.setCounter(pstTransferRequest.getInt(COL_COUNTER));
            transferRequest.setNumber(pstTransferRequest.getString(COL_NUMBER));
            transferRequest.setApproval1(pstTransferRequest.getlong(COL_APPROVAL_1));            
            transferRequest.setUserId(pstTransferRequest.getlong(COL_USER_ID));
            transferRequest.setPrefixNumber(pstTransferRequest.getString(COL_PREFIX_NUMBER));
            transferRequest.setApproval1Date(pstTransferRequest.getDate(COL_APPROVAL_1_DATE));            
            transferRequest.setGenId(pstTransferRequest.getlong(COL_GEN_ID));
            transferRequest.setCreateDate(pstTransferRequest.getDate(COL_CREATE_DATE));
            return transferRequest;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferRequest(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(TransferRequest transferRequest) throws CONException {
        try {
            DbTransferRequest pstTransferRequest = new DbTransferRequest(0);

            pstTransferRequest.setDate(COL_DATE, transferRequest.getDate());
            pstTransferRequest.setString(COL_STATUS, transferRequest.getStatus());
            pstTransferRequest.setLong(COL_FROM_LOCATION_ID, transferRequest.getFromLocationId());
            pstTransferRequest.setLong(COL_TO_LOCATION_ID, transferRequest.getToLocationId());
            pstTransferRequest.setString(COL_NOTE, transferRequest.getNote());
            pstTransferRequest.setInt(COL_COUNTER, transferRequest.getCounter());
            pstTransferRequest.setString(COL_NUMBER, transferRequest.getNumber());
            pstTransferRequest.setLong(COL_APPROVAL_1, transferRequest.getApproval1());            
            pstTransferRequest.setLong(COL_USER_ID, transferRequest.getUserId());
            pstTransferRequest.setString(COL_PREFIX_NUMBER, transferRequest.getPrefixNumber());
            pstTransferRequest.setDate(COL_APPROVAL_1_DATE, transferRequest.getApproval1Date());   
            pstTransferRequest.setLong(COL_GEN_ID, transferRequest.getGenId());
            pstTransferRequest.setDate(COL_CREATE_DATE, transferRequest.getCreateDate());
            pstTransferRequest.insert();
            transferRequest.setOID(pstTransferRequest.getlong(COL_TRANSFER_REQUEST_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferRequest(0), CONException.UNKNOWN);
        }
        return transferRequest.getOID();
    }

    public static long updateExc(TransferRequest transferRequest) throws CONException {
        try {
            if (transferRequest.getOID() != 0) {
                DbTransferRequest pstTransferRequest = new DbTransferRequest(transferRequest.getOID());

                pstTransferRequest.setDate(COL_DATE, transferRequest.getDate());
                pstTransferRequest.setString(COL_STATUS, transferRequest.getStatus());
                pstTransferRequest.setLong(COL_FROM_LOCATION_ID, transferRequest.getFromLocationId());
                pstTransferRequest.setLong(COL_TO_LOCATION_ID, transferRequest.getToLocationId());
                pstTransferRequest.setString(COL_NOTE, transferRequest.getNote());
                pstTransferRequest.setInt(COL_COUNTER, transferRequest.getCounter());
                pstTransferRequest.setString(COL_NUMBER, transferRequest.getNumber());
                pstTransferRequest.setLong(COL_APPROVAL_1, transferRequest.getApproval1());                
                pstTransferRequest.setLong(COL_USER_ID, transferRequest.getUserId());
                pstTransferRequest.setString(COL_PREFIX_NUMBER, transferRequest.getPrefixNumber());
                pstTransferRequest.setDate(COL_APPROVAL_1_DATE, transferRequest.getApproval1Date());   
                pstTransferRequest.setLong(COL_GEN_ID, transferRequest.getGenId());
                pstTransferRequest.setDate(COL_CREATE_DATE, transferRequest.getCreateDate());
                pstTransferRequest.update();
                return transferRequest.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferRequest(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbTransferRequest pstTransferRequest = new DbTransferRequest(oid);
            pstTransferRequest.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransferRequest(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_TRANSFER_REQUEST;
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
                TransferRequest transferRequest = new TransferRequest();
                resultToObject(rs, transferRequest);
                lists.add(transferRequest);
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
    
    private static void resultToObject(ResultSet rs, TransferRequest transferRequest) {
        try {
            transferRequest.setOID(rs.getLong(DbTransferRequest.colNames[DbTransferRequest.COL_TRANSFER_REQUEST_ID]));
            transferRequest.setDate(rs.getDate(DbTransferRequest.colNames[DbTransferRequest.COL_DATE]));
            transferRequest.setStatus(rs.getString(DbTransferRequest.colNames[DbTransferRequest.COL_STATUS]));
            transferRequest.setFromLocationId(rs.getLong(DbTransferRequest.colNames[DbTransferRequest.COL_FROM_LOCATION_ID]));
            transferRequest.setToLocationId(rs.getLong(DbTransferRequest.colNames[DbTransferRequest.COL_TO_LOCATION_ID]));
            transferRequest.setNote(rs.getString(DbTransferRequest.colNames[DbTransferRequest.COL_NOTE]));
            transferRequest.setCounter(rs.getInt(DbTransferRequest.colNames[DbTransferRequest.COL_COUNTER]));
            transferRequest.setNumber(rs.getString(DbTransferRequest.colNames[DbTransferRequest.COL_NUMBER]));
            transferRequest.setApproval1(rs.getLong(DbTransferRequest.colNames[DbTransferRequest.COL_APPROVAL_1]));            
            transferRequest.setUserId(rs.getLong(DbTransferRequest.colNames[DbTransferRequest.COL_USER_ID]));
            transferRequest.setPrefixNumber(rs.getString(DbTransferRequest.colNames[DbTransferRequest.COL_PREFIX_NUMBER]));
            transferRequest.setApproval1Date(rs.getDate(DbTransferRequest.colNames[DbTransferRequest.COL_APPROVAL_1_DATE]));
            transferRequest.setGenId(rs.getLong(DbTransferRequest.colNames[DbTransferRequest.COL_GEN_ID]));
            transferRequest.setCreateDate(rs.getDate(DbTransferRequest.colNames[DbTransferRequest.COL_CREATE_DATE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long transferRequestId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_TRANSFER_REQUEST + " WHERE " +
                    DbTransferRequest.colNames[DbTransferRequest.COL_TRANSFER_REQUEST_ID] + " = " + transferRequestId;

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
            String sql = "SELECT COUNT(" + DbTransferRequest.colNames[DbTransferRequest.COL_TRANSFER_REQUEST_ID] + ") FROM " + DB_POS_TRANSFER_REQUEST;
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
                    TransferRequest transferRequest = (TransferRequest) list.get(ls);
                    if (oid == transferRequest.getOID()) { 
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
    
    public static int getNextCounter(long fromLocationId) {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_TRANSFER_REQUEST + " where " +
                    colNames[COL_PREFIX_NUMBER] + "='" + getNumberPrefix(fromLocationId) + "' ";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }

            result = result + 1;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }

   
    public static String getNumberPrefix(long fromLocationId){
        String code = "REQ";
        Location loc = new Location();
        try{
            loc = DbLocation.fetchExc(fromLocationId);
        }catch(Exception ex){            
        }
        code = code + loc.getCode();
        code = code + JSPFormater.formatDate(new Date(), "MMyy");
        return code;
    }
   
    public static String getNextNumber(int ctr, long locationId) {

        String code = getNumberPrefix(locationId);

        if (ctr < 10) {
            code = code + "000" + ctr;
        } else if (ctr < 100) {
            code = code + "00" + ctr;
        } else if (ctr < 1000) {
            code = code + "0" + ctr;
        } else {
            code = code + ctr;
        }

        return code;

    }    
    
    
    public static synchronized long generateTransfer(TransferRequest tr){
        long oid = 0;
        Vector list = DbTransferRequestItem.list(0, 0, DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ID]+" = "+tr.getOID(),null);
        if(list != null && list.size() > 0){
            Transfer transfer = new Transfer();
            transfer.setFromLocationId(tr.getFromLocationId());
            transfer.setToLocationId(tr.getToLocationId());
            int ctr = DbTransfer.getNextCounter(transfer.getFromLocationId());
            transfer.setCounter(ctr);
            transfer.setPrefixNumber(DbTransfer.getNumberPrefix(transfer.getFromLocationId()));
            transfer.setNumber(DbTransfer.getNextNumber(ctr, transfer.getFromLocationId()));
            transfer.setStatus(I_Project.DOC_STATUS_DRAFT);
            transfer.setUserId(tr.getApproval1());
            transfer.setDate(new Date());
            transfer.setNote(tr.getNote());
            
            try{
                oid = DbTransfer.insertExc(transfer);
                
                if(oid != 0){
                    updateGenId(tr.getOID(),oid);
                    for(int i = 0 ; i < list.size(); i++){
                        TransferRequestItem tri = (TransferRequestItem)list.get(i);
                        TransferItem ti = new TransferItem();
                        ti.setTransferId(oid);
                        ti.setItemMasterId(tri.getItemMasterId());
                        ti.setItemBarcode(tri.getItemBarcode());
                        ti.setQty(tri.getQty());
                        ti.setNote("");
                        ti.setQtyRequest(0);
                        ti.setQtyStock(0);
                        long oidDetail = DbTransferItem.insertExc(ti);
                        
                        DbStock.delete(DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID] + "=" + oidDetail);
                        DbStock.insertTransferGoods(transfer, ti);
                        
                    }
                }
            }catch(Exception e){}
        }
        return oid;
        
    }
    
    public static void updateGenId(long oid,long transferId){
        try{
            String sql = "update "+DbTransferRequest.DB_POS_TRANSFER_REQUEST+" set "+DbTransferRequest.colNames[DbTransferRequest.COL_GEN_ID]+" = "+transferId+
                    " where "+DbTransferRequest.colNames[DbTransferRequest.COL_TRANSFER_REQUEST_ID]+" = "+oid;
            System.out.println("sql update "+sql);
            CONHandler.execUpdate(sql);
        }catch(Exception e){}
    }
}
