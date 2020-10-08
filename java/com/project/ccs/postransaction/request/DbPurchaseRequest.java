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
import com.project.general.*;
import java.util.Date;
import com.project.util.*;

public class DbPurchaseRequest extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PURCHASE_REQUEST = "pos_purchase_request";
    
    public static final int COL_PURCHASE_REQUEST_ID = 0;
    public static final int COL_DATE = 1;
    public static final int COL_APPROVAL_1 = 2;
    public static final int COL_APPROVAL_2 = 3;
    public static final int COL_APPROVAL_3 = 4;
    public static final int COL_STATUS = 5;
    public static final int COL_USER_ID = 6;
    public static final int COL_NOTE = 7;
    public static final int COL_NUMBER = 8;
    public static final int COL_COUNTER = 9;
    public static final int COL_DEPARTMENT_ID = 10;
    public static final int COL_PREFIX_NUMBER = 11;
    public static final int COL_CLOSED_REASON = 12;
    public static final int COL_APPROVAL_1_DATE = 13;
    public static final int COL_APPROVAL_2_DATE = 14;
    public static final int COL_APPROVAL_3_DATE = 15;
    
    public static final String[] colNames = {
        "purchase_request_id",
        "date",
        "approval_1",
        "approval_2",
        "approval_3",
        "status",
        "user_id",
        "note",
        "number",
        "counter",
        "department_id",
        "prefix_number",
        "closed_reason",
        "approval_1_date",
        "approval_2_date",
        "approval_3_date"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE
        
    };
    
    public static int STATUS_DRAFT = 0;
    public static int STATUS_PROCESS = 1;
    public static int STATUS_CLOSE = 2;
    public static String[] strStatus = {"Draft", "Process", "Close"};

    public DbPurchaseRequest() {
    }

    public DbPurchaseRequest(int i) throws CONException {
        super(new DbPurchaseRequest());
    }

    public DbPurchaseRequest(String sOid) throws CONException {
        super(new DbPurchaseRequest(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPurchaseRequest(long lOid) throws CONException {
        super(new DbPurchaseRequest(0));
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
        return DB_PURCHASE_REQUEST;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPurchaseRequest().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        PurchaseRequest purchaseRequest = fetchExc(ent.getOID());
        ent = (Entity) purchaseRequest;
        return purchaseRequest.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((PurchaseRequest) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((PurchaseRequest) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static PurchaseRequest fetchExc(long oid) throws CONException {
        try {
            PurchaseRequest purchaseRequest = new PurchaseRequest();
            DbPurchaseRequest dbPurchaseRequest = new DbPurchaseRequest(oid);
            purchaseRequest.setOID(oid);
            purchaseRequest.setApproval1(dbPurchaseRequest.getlong(COL_APPROVAL_1));
            purchaseRequest.setApproval2(dbPurchaseRequest.getlong(COL_APPROVAL_2));
            purchaseRequest.setApproval3(dbPurchaseRequest.getlong(COL_APPROVAL_3));
            purchaseRequest.setCounter(dbPurchaseRequest.getInt(COL_COUNTER));
            purchaseRequest.setDepartmentId(dbPurchaseRequest.getlong(COL_DEPARTMENT_ID)); 
            purchaseRequest.setNote(dbPurchaseRequest.getString(COL_NOTE));
            purchaseRequest.setNumber(dbPurchaseRequest.getString(COL_NUMBER));
            purchaseRequest.setDate(dbPurchaseRequest.getDate(COL_DATE));
            //purchaseRequest.setRegDate(dbPurchaseRequest.getDate(COL_DATE));
            purchaseRequest.setStatus(dbPurchaseRequest.getString(COL_STATUS));
            purchaseRequest.setUserId(dbPurchaseRequest.getlong(COL_USER_ID));
            purchaseRequest.setPrefixNumber(dbPurchaseRequest.getString(COL_PREFIX_NUMBER));
            purchaseRequest.setClosedReason(dbPurchaseRequest.getString(COL_CLOSED_REASON));
            
            purchaseRequest.setApproval1Date(dbPurchaseRequest.getDate(COL_APPROVAL_1_DATE));
            purchaseRequest.setApproval2Date(dbPurchaseRequest.getDate(COL_APPROVAL_2_DATE));
            purchaseRequest.setApproval3Date(dbPurchaseRequest.getDate(COL_APPROVAL_3_DATE));

            return purchaseRequest;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseRequest(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(PurchaseRequest purchaseRequest) throws CONException {
        try {
            DbPurchaseRequest pstPurchaseRequest = new DbPurchaseRequest(0);

            pstPurchaseRequest.setLong(COL_APPROVAL_1, purchaseRequest.getApproval1());
            pstPurchaseRequest.setLong(COL_APPROVAL_2, purchaseRequest.getApproval2());
            pstPurchaseRequest.setLong(COL_APPROVAL_3, purchaseRequest.getApproval3());
            pstPurchaseRequest.setInt(COL_COUNTER, purchaseRequest.getCounter());
            pstPurchaseRequest.setLong(COL_DEPARTMENT_ID, purchaseRequest.getDepartmentId());
            pstPurchaseRequest.setString(COL_NOTE, purchaseRequest.getNote());
            pstPurchaseRequest.setString(COL_NUMBER, purchaseRequest.getNumber());
            pstPurchaseRequest.setDate(COL_DATE, purchaseRequest.getDate());
            pstPurchaseRequest.setString(COL_STATUS, purchaseRequest.getStatus());
            pstPurchaseRequest.setLong(COL_USER_ID, purchaseRequest.getUserId());
            
            pstPurchaseRequest.setString(COL_PREFIX_NUMBER, purchaseRequest.getPrefixNumber());
            pstPurchaseRequest.setString(COL_CLOSED_REASON, purchaseRequest.getClosedReason());
            
            pstPurchaseRequest.setDate(COL_APPROVAL_1_DATE, purchaseRequest.getApproval1Date());
            pstPurchaseRequest.setDate(COL_APPROVAL_2_DATE, purchaseRequest.getApproval2Date());
            pstPurchaseRequest.setDate(COL_APPROVAL_3_DATE, purchaseRequest.getApproval3Date());

            pstPurchaseRequest.insert();
            purchaseRequest.setOID(pstPurchaseRequest.getlong(COL_PURCHASE_REQUEST_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseRequest(0), CONException.UNKNOWN);
        }
        return purchaseRequest.getOID();
    }

    public static long updateExc(PurchaseRequest purchaseRequest) throws CONException {
        try {
            if (purchaseRequest.getOID() != 0) {
                DbPurchaseRequest pstPurchaseRequest = new DbPurchaseRequest(purchaseRequest.getOID());

                pstPurchaseRequest.setLong(COL_APPROVAL_1, purchaseRequest.getApproval1());
                pstPurchaseRequest.setLong(COL_APPROVAL_2, purchaseRequest.getApproval2());
                pstPurchaseRequest.setLong(COL_APPROVAL_3, purchaseRequest.getApproval3());
                pstPurchaseRequest.setInt(COL_COUNTER, purchaseRequest.getCounter());
                pstPurchaseRequest.setLong(COL_DEPARTMENT_ID, purchaseRequest.getDepartmentId());
                pstPurchaseRequest.setString(COL_NOTE, purchaseRequest.getNote());
                pstPurchaseRequest.setString(COL_NUMBER, purchaseRequest.getNumber());
                pstPurchaseRequest.setDate(COL_DATE, purchaseRequest.getDate());
                pstPurchaseRequest.setString(COL_STATUS, purchaseRequest.getStatus());
                
                pstPurchaseRequest.setString(COL_PREFIX_NUMBER, purchaseRequest.getPrefixNumber());
                pstPurchaseRequest.setString(COL_CLOSED_REASON, purchaseRequest.getClosedReason());
                
                pstPurchaseRequest.setDate(COL_APPROVAL_1_DATE, purchaseRequest.getApproval1Date());
                pstPurchaseRequest.setDate(COL_APPROVAL_2_DATE, purchaseRequest.getApproval2Date());
                pstPurchaseRequest.setDate(COL_APPROVAL_3_DATE, purchaseRequest.getApproval3Date());

                pstPurchaseRequest.update();
                return purchaseRequest.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseRequest(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPurchaseRequest pstPurchaseRequest = new DbPurchaseRequest(oid);
            pstPurchaseRequest.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchaseRequest(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PURCHASE_REQUEST;
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
                PurchaseRequest purchaseRequest = new PurchaseRequest();
                resultToObject(rs, purchaseRequest);
                lists.add(purchaseRequest);
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

    public static void resultToObject(ResultSet rs, PurchaseRequest purchaseRequest) {
        try {
            purchaseRequest.setOID(rs.getLong(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_PURCHASE_REQUEST_ID]));
            purchaseRequest.setApproval1(rs.getLong(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_APPROVAL_1]));
            purchaseRequest.setApproval2(rs.getLong(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_APPROVAL_2]));
            purchaseRequest.setApproval3(rs.getLong(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_APPROVAL_3]));
            purchaseRequest.setCounter(rs.getInt(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_COUNTER]));
            purchaseRequest.setDepartmentId(rs.getLong(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_DEPARTMENT_ID]));
            purchaseRequest.setNote(rs.getString(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_NOTE]));
            purchaseRequest.setNumber(rs.getString(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_NUMBER]));
            purchaseRequest.setDate(rs.getDate(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_DATE]));
            purchaseRequest.setStatus(rs.getString(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_STATUS]));
            purchaseRequest.setUserId(rs.getLong(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_USER_ID]));
            
            purchaseRequest.setPrefixNumber(rs.getString(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_PREFIX_NUMBER]));
            purchaseRequest.setClosedReason(rs.getString(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_CLOSED_REASON]));
            
            purchaseRequest.setApproval1Date(rs.getDate(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_APPROVAL_1_DATE]));
            purchaseRequest.setApproval2Date(rs.getDate(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_APPROVAL_2_DATE]));
            purchaseRequest.setApproval3Date(rs.getDate(DbPurchaseRequest.colNames[DbPurchaseRequest.COL_APPROVAL_3_DATE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long purchaseRequestId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PURCHASE_REQUEST + " WHERE " +
                    DbPurchaseRequest.colNames[DbPurchaseRequest.COL_PURCHASE_REQUEST_ID] + " = " + purchaseRequestId;

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
            String sql = "SELECT COUNT(" + DbPurchaseRequest.colNames[DbPurchaseRequest.COL_PURCHASE_REQUEST_ID] + ") FROM " + DB_PURCHASE_REQUEST;
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
                    PurchaseRequest purchaseRequest = (PurchaseRequest) list.get(ls);
                    if (oid == purchaseRequest.getOID()) {
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

    public static String generateNumber(int counter) {
        String strNumber = "";
        try {
            if (counter > 100000) {
                strNumber = "PR-" + "" + counter;
            } else if (counter > 10000) {
                strNumber = "PR-" + "0" + counter;
            } else if (counter > 1000) {
                strNumber = "PR-" + "00" + counter;
            } else if (counter > 100) {
                strNumber = "PR-" + "000" + counter;
            } else if (counter > 10) {
                strNumber = "PR-" + "0000" + counter;
            } else if (counter > 0) {
                strNumber = "PR-" + "00000" + counter;
            }
        } catch (Exception e) {
        }
        return strNumber;
    }
    
    public static int getNextCounter(){
                int result = 0;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_PURCHASE_REQUEST+" where "+
                        colNames[COL_PREFIX_NUMBER]+"='"+getNumberPrefix()+"' ";
                    
                    System.out.println(sql);
                    
                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while(rs.next()){
                        result = rs.getInt(1);
                    }
                    
                    result = result + 1;
                    
                }
                catch(Exception e){
                    
                }
                finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
        }
        
        public static String getNumberPrefix(){
                String code = "";
                Company sysCompany = DbCompany.getCompany();
                code = code + sysCompany.getPurchaseRequestCode(); 
                
                code = code + JSPFormater.formatDate(new Date(), "MMyy");
                
                return code;
        }
        
        
        public static String getNextNumber(int ctr){
            
                String code = getNumberPrefix();
                
                if(ctr<10){
                    code = code + "000"+ctr;
                }
                else if(ctr<100){
                    code = code + "00"+ctr;
                }
                else if(ctr<1000){
                    code = code + "0"+ctr;
                }
                else{
                    code = code + ctr;
                }
                
                return code;
                
        }

}
