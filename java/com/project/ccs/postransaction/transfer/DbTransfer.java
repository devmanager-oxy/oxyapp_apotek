package com.project.ccs.postransaction.transfer;

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
import com.project.ccs.postransaction.*;
import com.project.general.*;
import com.project.util.*;


public class DbTransfer extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_TRANSFER = "pos_transfer";
    public static final int COL_TRANSFER_ID = 0;
    public static final int COL_DATE = 1;
    public static final int COL_STATUS = 2;
    public static final int COL_FROM_LOCATION_ID = 3;
    public static final int COL_TO_LOCATION_ID = 4;
    public static final int COL_NOTE = 5;
    public static final int COL_COUNTER = 6;
    public static final int COL_NUMBER = 7;
    public static final int COL_APPROVAL_1 = 8;
    public static final int COL_APPROVAL_2 = 9;
    public static final int COL_APPROVAL_3 = 10;
    public static final int COL_USER_ID = 11;
    public static final int COL_PREFIX_NUMBER = 12;
    public static final int COL_APPROVAL_1_DATE = 13;
    public static final int COL_APPROVAL_2_DATE = 14;
    public static final int COL_APPROVAL_3_DATE = 15;
    public static final int COL_TYPE = 16;

    public static final String[] colNames = {
        "TRANSFER_ID",
        "DATE",
        "STATUS",
        "FROM_LOCATION_ID",
        "TO_LOCATION_ID",
        "NOTE",
        "COUNTER",
        "NUMBER",
        "APPROVAL_1",
        "APPROVAL_2",
        "APPROVAL_3",
        "USER_ID",
        "PREFIX_NUMBER",
        "APPROVAL_1_DATE",
        "APPROVAL_2_DATE",
        "APPROVAL_3_DATE",
        "TYPE"
    };
    public static final int TYPE_NON_CONSIGMENT = 0;
    public static final int TYPE_CONSIGMENT = 1;
    
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
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT
    };

    public DbTransfer() {
    }

    public DbTransfer(int i) throws CONException {
        super(new DbTransfer());
    }

    public DbTransfer(String sOid) throws CONException {
        super(new DbTransfer(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbTransfer(long lOid) throws CONException {
        super(new DbTransfer(0));
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
        return DB_POS_TRANSFER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbTransfer().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Transfer transfer = fetchExc(ent.getOID());
        ent = (Entity) transfer;
        return transfer.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Transfer) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Transfer) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Transfer fetchExc(long oid) throws CONException {
        try {
            Transfer transfer = new Transfer();
            DbTransfer pstTransfer = new DbTransfer(oid);
            transfer.setOID(oid);

            transfer.setDate(pstTransfer.getDate(COL_DATE));
            transfer.setStatus(pstTransfer.getString(COL_STATUS));
            transfer.setFromLocationId(pstTransfer.getlong(COL_FROM_LOCATION_ID));
            transfer.setToLocationId(pstTransfer.getlong(COL_TO_LOCATION_ID));
            transfer.setNote(pstTransfer.getString(COL_NOTE));
            transfer.setCounter(pstTransfer.getInt(COL_COUNTER));
            transfer.setNumber(pstTransfer.getString(COL_NUMBER));
            transfer.setApproval1(pstTransfer.getlong(COL_APPROVAL_1));
            transfer.setApproval2(pstTransfer.getlong(COL_APPROVAL_2));
            transfer.setApproval3(pstTransfer.getlong(COL_APPROVAL_3));
            transfer.setUserId(pstTransfer.getlong(COL_USER_ID));
            transfer.setPrefixNumber(pstTransfer.getString(COL_PREFIX_NUMBER));

            transfer.setApproval1Date(pstTransfer.getDate(COL_APPROVAL_1_DATE));
            transfer.setApproval2Date(pstTransfer.getDate(COL_APPROVAL_2_DATE));
            transfer.setApproval3Date(pstTransfer.getDate(COL_APPROVAL_3_DATE));
            transfer.setType(pstTransfer.getInt(COL_TYPE));

            return transfer;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransfer(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Transfer transfer) throws CONException {
        try {
            DbTransfer pstTransfer = new DbTransfer(0);

            pstTransfer.setDate(COL_DATE, transfer.getDate());
            pstTransfer.setString(COL_STATUS, transfer.getStatus());
            pstTransfer.setLong(COL_FROM_LOCATION_ID, transfer.getFromLocationId());
            pstTransfer.setLong(COL_TO_LOCATION_ID, transfer.getToLocationId());
            pstTransfer.setString(COL_NOTE, transfer.getNote());
            pstTransfer.setInt(COL_COUNTER, transfer.getCounter());
            pstTransfer.setString(COL_NUMBER, transfer.getNumber());
            pstTransfer.setLong(COL_APPROVAL_1, transfer.getApproval1());
            pstTransfer.setLong(COL_APPROVAL_2, transfer.getApproval2());
            pstTransfer.setLong(COL_APPROVAL_3, transfer.getApproval3());
            pstTransfer.setLong(COL_USER_ID, transfer.getUserId());
            pstTransfer.setString(COL_PREFIX_NUMBER, transfer.getPrefixNumber());

            pstTransfer.setDate(COL_APPROVAL_1_DATE, transfer.getApproval1Date());
            pstTransfer.setDate(COL_APPROVAL_2_DATE, transfer.getApproval2Date());
            pstTransfer.setDate(COL_APPROVAL_3_DATE, transfer.getApproval3Date());
            pstTransfer.setInt(COL_TYPE, transfer.getType());
            
            pstTransfer.insert();
            transfer.setOID(pstTransfer.getlong(COL_TRANSFER_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransfer(0), CONException.UNKNOWN);
        }
        return transfer.getOID();
    }

    public static long updateExc(Transfer transfer) throws CONException {
        try {
            if (transfer.getOID() != 0) {
                DbTransfer pstTransfer = new DbTransfer(transfer.getOID());

                pstTransfer.setDate(COL_DATE, transfer.getDate());
                pstTransfer.setString(COL_STATUS, transfer.getStatus());
                pstTransfer.setLong(COL_FROM_LOCATION_ID, transfer.getFromLocationId());
                pstTransfer.setLong(COL_TO_LOCATION_ID, transfer.getToLocationId());
                pstTransfer.setString(COL_NOTE, transfer.getNote());
                pstTransfer.setInt(COL_COUNTER, transfer.getCounter());
                pstTransfer.setString(COL_NUMBER, transfer.getNumber());
                pstTransfer.setLong(COL_APPROVAL_1, transfer.getApproval1());
                pstTransfer.setLong(COL_APPROVAL_2, transfer.getApproval2());
                pstTransfer.setLong(COL_APPROVAL_3, transfer.getApproval3());
                pstTransfer.setLong(COL_USER_ID, transfer.getUserId());
                pstTransfer.setString(COL_PREFIX_NUMBER, transfer.getPrefixNumber());

                pstTransfer.setDate(COL_APPROVAL_1_DATE, transfer.getApproval1Date());
                pstTransfer.setDate(COL_APPROVAL_2_DATE, transfer.getApproval2Date());
                pstTransfer.setDate(COL_APPROVAL_3_DATE, transfer.getApproval3Date());
                pstTransfer.setInt(COL_TYPE, transfer.getType());
                
                
                pstTransfer.update();
                return transfer.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransfer(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbTransfer pstTransfer = new DbTransfer(oid);
            pstTransfer.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransfer(0), CONException.UNKNOWN);
        }
        return oid;
    }
    public static long getOidByNumber(String transferNumber) throws CONException {
         CONResultSet dbrs = null;
         long oid=0;
        try {
            
            String sql ="select transfer_id from pos_transfer where number ='" + transferNumber+"'";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()){
                
                oid= rs.getLong("transfer_id");
            }
            rs.close();
            return oid;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransfer(0), CONException.UNKNOWN);
        }
        
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_POS_TRANSFER;
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
                Transfer transfer = new Transfer();
                resultToObject(rs, transfer);
                lists.add(transfer);
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

    
    
    private static void resultToObject(ResultSet rs, Transfer transfer) {
        try {
            transfer.setOID(rs.getLong(DbTransfer.colNames[DbTransfer.COL_TRANSFER_ID]));
            transfer.setDate(rs.getDate(DbTransfer.colNames[DbTransfer.COL_DATE]));
            transfer.setStatus(rs.getString(DbTransfer.colNames[DbTransfer.COL_STATUS]));
            transfer.setFromLocationId(rs.getLong(DbTransfer.colNames[DbTransfer.COL_FROM_LOCATION_ID]));
            transfer.setToLocationId(rs.getLong(DbTransfer.colNames[DbTransfer.COL_TO_LOCATION_ID]));
            transfer.setNote(rs.getString(DbTransfer.colNames[DbTransfer.COL_NOTE]));
            transfer.setCounter(rs.getInt(DbTransfer.colNames[DbTransfer.COL_COUNTER]));
            transfer.setNumber(rs.getString(DbTransfer.colNames[DbTransfer.COL_NUMBER]));
            transfer.setApproval1(rs.getLong(DbTransfer.colNames[DbTransfer.COL_APPROVAL_1]));
            transfer.setApproval2(rs.getLong(DbTransfer.colNames[DbTransfer.COL_APPROVAL_2]));
            transfer.setApproval3(rs.getLong(DbTransfer.colNames[DbTransfer.COL_APPROVAL_3]));
            transfer.setUserId(rs.getLong(DbTransfer.colNames[DbTransfer.COL_USER_ID]));
            transfer.setPrefixNumber(rs.getString(DbTransfer.colNames[DbTransfer.COL_PREFIX_NUMBER]));

            transfer.setApproval1Date(rs.getDate(DbTransfer.colNames[DbTransfer.COL_APPROVAL_1_DATE]));
            transfer.setApproval2Date(rs.getDate(DbTransfer.colNames[DbTransfer.COL_APPROVAL_2_DATE]));
            transfer.setApproval3Date(rs.getDate(DbTransfer.colNames[DbTransfer.COL_APPROVAL_3_DATE]));
            transfer.setType(rs.getInt(DbTransfer.colNames[DbTransfer.COL_TYPE]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long transferId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_TRANSFER + " WHERE " +
                    DbTransfer.colNames[DbTransfer.COL_TRANSFER_ID] + " = " + transferId;

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
            String sql = "SELECT COUNT(" + DbTransfer.colNames[DbTransfer.COL_TRANSFER_ID] + ") FROM " + DB_POS_TRANSFER;
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

     public static double getTotalRequest(long tolocation_id, long item_master_id) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT sum(ti.qty) from pos_transfer_item ti inner join pos_transfer t on ti.transfer_id=t.transfer_id where t.to_location_id= " + tolocation_id + " and t.status!='APPROVED' and ti.item_master_id=" + item_master_id;
            

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
     
    public static long getOidSalesByNumber(String salesNumber) throws CONException {
         CONResultSet dbrs = null;
         long oid=0;
        try {
            
            String sql ="select sales_id from pos_sales where number ='" + salesNumber+"'";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()){
                
                oid= rs.getLong("sales_id");
            }
            rs.close();
            return oid;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTransfer(0), CONException.UNKNOWN);
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
                    Transfer transfer = (Transfer) list.get(ls);
                    if (oid == transfer.getOID()) {
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

   // public static int getNextCounter() {
   //     int result = 0;

    //    CONResultSet dbrs = null;
     //   try {
      //      String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_TRANSFER + " where " +
        //            colNames[COL_PREFIX_NUMBER] + "='" + getNumberPrefix() + "' ";

        //    System.out.println(sql);

        //    dbrs = CONHandler.execQueryResult(sql);
        //    ResultSet rs = dbrs.getResultSet();
          //  while (rs.next()) {
          //      result = rs.getInt(1);
         //   }

       //     result = result + 1;

      //  } catch (Exception e) {
      //  } finally {
      //      CONResultSet.close(dbrs);
       // }

      //  return result;
   // }
    
    public static int getNextCounter(long fromLocationId) {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_TRANSFER + " where " +
                    colNames[COL_PREFIX_NUMBER] + "='" + getNumberPrefix(fromLocationId) + "' ";

            System.out.println(sql);

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

    //public static String getNumberPrefix() {
      //  String code = "";
      //  Company sysCompany = DbCompany.getCompany();
       // code = code + sysCompany.getTransferGoodsCode();

      //  code = code + JSPFormater.formatDate(new Date(), "MMyy");

       // return code;
   // }
    public static String getNumberPrefix(long fromLocationId){
        String code = "";
        Location loc = new Location();
        try{
            loc = DbLocation.fetchExc(fromLocationId);
        }catch(Exception ex){
            
        }
        code = code + loc.getCode();

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }
    

    //public static String getNextNumber(int ctr) {

       // String code = getNumberPrefix();

       // if (ctr < 10) {
        //    code = code + "000" + ctr;
       // } else if (ctr < 100) {
       //     code = code + "00" + ctr;
       // } else if (ctr < 1000) {
       //     code = code + "0" + ctr;
       // } else {
       //     code = code + ctr;
       // }

      //  return code;

   // }
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
}
