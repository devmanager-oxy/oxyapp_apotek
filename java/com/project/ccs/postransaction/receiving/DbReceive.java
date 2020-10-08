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
import com.project.util.*;
import com.project.general.*;
import java.util.Date;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.ccs.postransaction.purchase.DbPurchase;
import com.project.ccs.session.OnePendingPO;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.AccLink;
import com.project.fms.master.DbAccLink;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
import com.project.fms.master.SegmentDetail;
import com.project.fms.session.SessOptimizedJournal;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.BankpoPaymentDetail;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbGlDetail;
import com.project.fms.transaction.InvoiceSrc;
import com.project.fms.transaction.QrInvoice;
import java.util.Hashtable;


public class DbReceive extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_RECEIVE = "pos_receive";
    
    public static final int COL_RECEIVE_ID = 0;
    public static final int COL_DATE = 1;
    public static final int COL_APPROVAL_1 = 2;
    public static final int COL_APPROVAL_2 = 3;
    public static final int COL_APPROVAL_3 = 4;
    public static final int COL_STATUS = 5;
    public static final int COL_USER_ID = 6;
    public static final int COL_NOTE = 7;
    public static final int COL_NUMBER = 8;
    public static final int COL_COUNTER = 9;
    public static final int COL_INCLUDE_TAX = 10;
    public static final int COL_TOTAL_TAX = 11;
    public static final int COL_TOTAL_AMOUNT = 12;
    public static final int COL_TAX_PERCENT = 13;
    public static final int COL_DISCOUNT_TOTAL = 14;
    public static final int COL_DISCOUNT_PERCENT = 15;
    public static final int COL_PAYMENT_TYPE = 16;
    public static final int COL_LOCATION_ID = 17;
    public static final int COL_VENDOR_ID = 18;
    public static final int COL_CURRENCY_ID = 19;
    public static final int COL_PREFIX_NUMBER = 20;
    public static final int COL_CLOSED_REASON = 21;    
    public static final int COL_APPROVAL_1_DATE = 22;
    public static final int COL_APPROVAL_2_DATE = 23;
    public static final int COL_APPROVAL_3_DATE = 24;    
    public static final int COL_PURCHASE_ID     = 25;
    public static final int COL_DUE_DATE        = 26;
    public static final int COL_PAYMENT_AMOUNT  = 27;
    public static final int COL_DO_NUMBER       = 28;
    public static final int COL_INVOICE_NUMBER  = 29;
    public static final int COL_PAYMENT_STATUS  = 30;
    public static final int COL_UNIT_USAHA_ID  = 31;  
    public static final int COL_TYPE = 32;    
    public static final int COL_PERIOD_ID = 33;
    public static final int COL_COA_ID = 34;
    public static final int COL_TYPE_AP = 35;
    public static final int COL_PAYMENT_STATUS_POSTED = 36;
    public static final int COL_NO_PAJAK = 37;
    public static final int COL_TYPE_INC = 38;
    public static final int COL_REFERENCE_ID = 39;    
    
    public static final String[] colNames = {
        "receive_id",
        "date",
        "approval_1",
        "approval_2",
        "approval_3",
        "status",
        "user_id",
        "note",
        "number",
        "counter",
        "include_tax",
        "total_tax",
        "total_amount",
        "tax_percent",
        "discount_total",
        "discount_percent",
        "payment_type",
        "location_id",
        "vendor_id",        
        "currency_id",
        "prefix_number",
        "closed_reason",
        "approval_1_date",
        "approval_2_date",
        "approval_3_date",        
        "purchase_id",
        "due_date",
        "payment_amount",
        "do_number",
        "invoice_number",
        "payment_status",        
        "unit_usaha_id",
        "type",
        "period_id",
        "coa_id",
        "type_ap",
        "payment_status_posted",
        "no_pajak",
        "type_inc",
        "reference_id"        
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
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,        
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,        
        TYPE_LONG,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,        
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT, TYPE_LONG        
    };
    
    public static int INCLUDE_TAX_NO = 0;
    public static int INCLUDE_TAX_YES = 1;
    public static String[] strIncludeTax = {"No", "Yes"};    
    
    public static int TYPE_NON_CONSIGMENT = 0;
    public static int TYPE_CONSIGMENT =1;
    
    public static int TYPE_REC_ADJ = 1;
    
    public static int TYPE_AP_NO = 0;
    public static int TYPE_AP_YES = 1;
    public static int TYPE_RETUR = 2;
    public static int TYPE_AP_REC_ADJ_BY_QTY = 3;
    public static int TYPE_AP_REC_ADJ_BY_PRICE = 4;
    
    public static int STATUS_DRAFT_POSTED           = 0;
    public static int STATUS_PARTIAL_PAID_POSTED    = 1;
    public static int STATUS_FULL_PAID_POSTED       = 2;

    public DbReceive() {
    }

    public DbReceive(int i) throws CONException {
        super(new DbReceive());
    }

    public DbReceive(String sOid) throws CONException {
        super(new DbReceive(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbReceive(long lOid) throws CONException {
        super(new DbReceive(0));
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
        return DB_RECEIVE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbReceive().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Receive receive = fetchExc(ent.getOID());
        ent = (Entity) receive;
        return receive.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Receive) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Receive) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Receive fetchExc(long oid) throws CONException {
        try {
            Receive receive = new Receive();
            DbReceive dbReceiveRequest = new DbReceive(oid);
            receive.setOID(oid);
            receive.setApproval1(dbReceiveRequest.getlong(COL_APPROVAL_1));
            receive.setApproval2(dbReceiveRequest.getlong(COL_APPROVAL_2));
            receive.setApproval3(dbReceiveRequest.getlong(COL_APPROVAL_3));
            receive.setCounter(dbReceiveRequest.getInt(COL_COUNTER));
            receive.setIncluceTax(dbReceiveRequest.getInt(COL_INCLUDE_TAX));
            receive.setNote(dbReceiveRequest.getString(COL_NOTE));
            receive.setNumber(dbReceiveRequest.getString(COL_NUMBER));
            receive.setDate(dbReceiveRequest.getDate(COL_DATE));
            receive.setStatus(dbReceiveRequest.getString(COL_STATUS));
            receive.setUserId(dbReceiveRequest.getlong(COL_USER_ID));
            receive.setTotalTax(dbReceiveRequest.getdouble(COL_TOTAL_TAX));
            receive.setTotalAmount(dbReceiveRequest.getdouble(COL_TOTAL_AMOUNT));
            receive.setTaxPercent(dbReceiveRequest.getdouble(COL_TAX_PERCENT));
            receive.setDiscountTotal(dbReceiveRequest.getdouble(COL_DISCOUNT_TOTAL));
            receive.setDiscountPercent(dbReceiveRequest.getdouble(COL_DISCOUNT_PERCENT));
            receive.setPaymentType(dbReceiveRequest.getString(COL_PAYMENT_TYPE));
            receive.setLocationId(dbReceiveRequest.getlong(COL_LOCATION_ID));
            receive.setVendorId(dbReceiveRequest.getlong(COL_VENDOR_ID));            
            receive.setCurrencyId(dbReceiveRequest.getlong(COL_CURRENCY_ID));
            receive.setPrefixNumber(dbReceiveRequest.getString(COL_PREFIX_NUMBER));
            receive.setClosedReason(dbReceiveRequest.getString(COL_CLOSED_REASON));            
            receive.setApproval1Date(dbReceiveRequest.getDate(COL_APPROVAL_1_DATE));
            receive.setApproval2Date(dbReceiveRequest.getDate(COL_APPROVAL_2_DATE));
            receive.setApproval3Date(dbReceiveRequest.getDate(COL_APPROVAL_3_DATE));            
            receive.setPurchaseId(dbReceiveRequest.getlong(COL_PURCHASE_ID));
            receive.setDueDate(dbReceiveRequest.getDate(COL_DUE_DATE));
            receive.setPaymentAmount(dbReceiveRequest.getdouble(COL_PAYMENT_AMOUNT));
            receive.setDoNumber(dbReceiveRequest.getString(COL_DO_NUMBER));
            receive.setInvoiceNumber(dbReceiveRequest.getString(COL_INVOICE_NUMBER));
            receive.setPaymentStatus(dbReceiveRequest.getInt(COL_PAYMENT_STATUS));            
            receive.setUnitUsahaId(dbReceiveRequest.getlong(COL_UNIT_USAHA_ID));
            receive.setType(dbReceiveRequest.getInt(COL_TYPE));
            receive.setPeriodId(dbReceiveRequest.getlong(COL_PERIOD_ID));            
            receive.setCoaId(dbReceiveRequest.getlong(COL_COA_ID));
            receive.setTypeAp(dbReceiveRequest.getInt(COL_TYPE_AP));
            receive.setPaymentStatusPosted(dbReceiveRequest.getInt(COL_PAYMENT_STATUS_POSTED));
            receive.setNoPajak(dbReceiveRequest.getString(COL_NO_PAJAK));
            receive.setTypeInc(dbReceiveRequest.getInt(COL_TYPE_INC));
            receive.setReferenceId(dbReceiveRequest.getlong(COL_REFERENCE_ID));               
            return receive;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReceive(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Receive receive) throws CONException {
        try {
            DbReceive dbReceiveRequest = new DbReceive(0);

            dbReceiveRequest.setLong(COL_APPROVAL_1, receive.getApproval1());
            dbReceiveRequest.setLong(COL_APPROVAL_2, receive.getApproval2());
            dbReceiveRequest.setLong(COL_APPROVAL_3, receive.getApproval3());
            dbReceiveRequest.setInt(COL_COUNTER, receive.getCounter());
            dbReceiveRequest.setInt(COL_INCLUDE_TAX, receive.getIncluceTax());
            dbReceiveRequest.setString(COL_NOTE, receive.getNote());
            dbReceiveRequest.setString(COL_NUMBER, receive.getNumber());
            dbReceiveRequest.setDate(COL_DATE, receive.getDate());
            dbReceiveRequest.setString(COL_STATUS, receive.getStatus());
            dbReceiveRequest.setLong(COL_USER_ID, receive.getUserId());
            dbReceiveRequest.setDouble(COL_TOTAL_TAX, receive.getTotalTax());
            dbReceiveRequest.setDouble(COL_TOTAL_AMOUNT, receive.getTotalAmount());
            dbReceiveRequest.setDouble(COL_TAX_PERCENT, receive.getTaxPercent());
            dbReceiveRequest.setDouble(COL_DISCOUNT_TOTAL, receive.getDiscountTotal());
            dbReceiveRequest.setDouble(COL_DISCOUNT_PERCENT, receive.getDiscountPercent());
            dbReceiveRequest.setString(COL_PAYMENT_TYPE, receive.getPaymentType());
            dbReceiveRequest.setLong(COL_LOCATION_ID, receive.getLocationId());
            dbReceiveRequest.setLong(COL_VENDOR_ID, receive.getVendorId());
            dbReceiveRequest.setLong(COL_CURRENCY_ID, receive.getCurrencyId());
            dbReceiveRequest.setString(COL_PREFIX_NUMBER, receive.getPrefixNumber());
            dbReceiveRequest.setString(COL_CLOSED_REASON, receive.getClosedReason());            
            dbReceiveRequest.setDate(COL_APPROVAL_1_DATE, receive.getApproval1Date());
            dbReceiveRequest.setDate(COL_APPROVAL_2_DATE, receive.getApproval2Date());
            dbReceiveRequest.setDate(COL_APPROVAL_3_DATE, receive.getApproval3Date());            
            dbReceiveRequest.setLong(COL_PURCHASE_ID, receive.getPurchaseId());
            dbReceiveRequest.setDate(COL_DUE_DATE, receive.getDueDate());
            dbReceiveRequest.setDouble(COL_PAYMENT_AMOUNT, receive.getPaymentAmount());
            dbReceiveRequest.setString(COL_DO_NUMBER, receive.getDoNumber());
            dbReceiveRequest.setString(COL_INVOICE_NUMBER, receive.getInvoiceNumber());
            dbReceiveRequest.setInt(COL_PAYMENT_STATUS, receive.getPaymentStatus());            
            dbReceiveRequest.setLong(COL_UNIT_USAHA_ID, receive.getUnitUsahaId());            
            dbReceiveRequest.setInt(COL_TYPE, receive.getType());            
            dbReceiveRequest.setLong(COL_PERIOD_ID, receive.getPeriodId());
            dbReceiveRequest.setLong(COL_COA_ID, receive.getCoaId());
            dbReceiveRequest.setInt(COL_TYPE_AP, receive.getTypeAp());            
            dbReceiveRequest.setInt(COL_PAYMENT_STATUS_POSTED, receive.getPaymentStatusPosted());
            dbReceiveRequest.setString(COL_NO_PAJAK, receive.getNoPajak());
            dbReceiveRequest.setInt(COL_TYPE_INC, receive.getTypeInc());
            dbReceiveRequest.setLong(COL_REFERENCE_ID, receive.getReferenceId()); 
            dbReceiveRequest.insert();
            receive.setOID(dbReceiveRequest.getlong(COL_RECEIVE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReceive(0), CONException.UNKNOWN);
        }
        return receive.getOID();
    }

    public static long updateExc(Receive receive) throws CONException {
        try {
            if (receive.getOID() != 0) {
                DbReceive dbReceiveRequest = new DbReceive(receive.getOID());

                dbReceiveRequest.setLong(COL_APPROVAL_1, receive.getApproval1());
                dbReceiveRequest.setLong(COL_APPROVAL_2, receive.getApproval2());
                dbReceiveRequest.setLong(COL_APPROVAL_3, receive.getApproval3());
                dbReceiveRequest.setInt(COL_COUNTER, receive.getCounter());
                dbReceiveRequest.setInt(COL_INCLUDE_TAX, receive.getIncluceTax());
                dbReceiveRequest.setString(COL_NOTE, receive.getNote());
                dbReceiveRequest.setString(COL_NUMBER, receive.getNumber());
                dbReceiveRequest.setDate(COL_DATE, receive.getDate());
                dbReceiveRequest.setString(COL_STATUS, receive.getStatus());
                dbReceiveRequest.setLong(COL_USER_ID, receive.getUserId());
                dbReceiveRequest.setDouble(COL_TOTAL_TAX, receive.getTotalTax());
                dbReceiveRequest.setDouble(COL_TOTAL_AMOUNT, receive.getTotalAmount());
                dbReceiveRequest.setDouble(COL_TAX_PERCENT, receive.getTaxPercent());
                dbReceiveRequest.setDouble(COL_DISCOUNT_TOTAL, receive.getDiscountTotal());
                dbReceiveRequest.setDouble(COL_DISCOUNT_PERCENT, receive.getDiscountPercent());
                dbReceiveRequest.setString(COL_PAYMENT_TYPE, receive.getPaymentType());
                dbReceiveRequest.setLong(COL_LOCATION_ID, receive.getLocationId());
                dbReceiveRequest.setLong(COL_VENDOR_ID, receive.getVendorId());
                dbReceiveRequest.setLong(COL_CURRENCY_ID, receive.getCurrencyId());
                dbReceiveRequest.setString(COL_PREFIX_NUMBER, receive.getPrefixNumber());
                dbReceiveRequest.setString(COL_CLOSED_REASON, receive.getClosedReason());                
                dbReceiveRequest.setDate(COL_APPROVAL_1_DATE, receive.getApproval1Date());
                dbReceiveRequest.setDate(COL_APPROVAL_2_DATE, receive.getApproval2Date());
                dbReceiveRequest.setDate(COL_APPROVAL_3_DATE, receive.getApproval3Date());                
                dbReceiveRequest.setLong(COL_PURCHASE_ID, receive.getPurchaseId());
                dbReceiveRequest.setDate(COL_DUE_DATE, receive.getDueDate());
                dbReceiveRequest.setDouble(COL_PAYMENT_AMOUNT, receive.getPaymentAmount());
                dbReceiveRequest.setString(COL_DO_NUMBER, receive.getDoNumber());
                dbReceiveRequest.setString(COL_INVOICE_NUMBER, receive.getInvoiceNumber()); 
                dbReceiveRequest.setInt(COL_PAYMENT_STATUS, receive.getPaymentStatus());                
                dbReceiveRequest.setLong(COL_UNIT_USAHA_ID, receive.getUnitUsahaId());
                dbReceiveRequest.setInt(COL_TYPE, receive.getType());
                dbReceiveRequest.setLong(COL_PERIOD_ID, receive.getPeriodId());
                dbReceiveRequest.setInt(COL_TYPE_AP, receive.getTypeAp());
                dbReceiveRequest.setInt(COL_PAYMENT_STATUS_POSTED, receive.getPaymentStatusPosted());
                dbReceiveRequest.setString(COL_NO_PAJAK, receive.getNoPajak()); 
                dbReceiveRequest.setInt(COL_TYPE_INC, receive.getTypeInc()); 
                dbReceiveRequest.setLong(COL_REFERENCE_ID, receive.getReferenceId()); 
                dbReceiveRequest.update();
                return receive.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReceive(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbReceive pstReceiveRequest = new DbReceive(oid);
            pstReceiveRequest.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbReceive(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_RECEIVE;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            
            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                    }
                    break;

                case CONHandler.CONSVR_POSTGRESQL:
                    if (limitStart == 0 && recordToGet == 0) {
                        sql = sql + "";
                    } else {
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                    }

                    break;

                case CONHandler.CONSVR_SYBASE:
                    break;

                case CONHandler.CONSVR_ORACLE:
                    break;

                case CONHandler.CONSVR_MSSQL:
                    break;

                default:
                    break;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Receive receive = new Receive();
                resultToObject(rs, receive);
                lists.add(receive);
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
    
    
    public static Vector list(int limitStart, int recordToGet, String status, long vendorId, 
        int ignore, Date startDate, Date endDate, long unitUsahaId) {
            
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select distinct pr.* from "+DB_RECEIVE+" pr "+
                        " where pr."+colNames[COL_STATUS]+" = '"+status+"'";
            
                        if(vendorId!=0){
                            sql = sql + " and "+colNames[COL_VENDOR_ID]+"="+vendorId;
                        }
                        if(ignore==0){
                            sql = sql + " and (pr."+colNames[COL_DATE]+" between "+
                                "'"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
                                " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
                        }
                        if(unitUsahaId!=0){
                            sql = sql + " and pr."+colNames[COL_UNIT_USAHA_ID]+"="+unitUsahaId;
                        }
            
                        sql = sql + " order by pr."+colNames[COL_DATE];
                        
                        if (limitStart == 0 && recordToGet == 0) {
                            sql = sql + "";
                        } else {
                            sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                        }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Receive receive = new Receive();
                resultToObject(rs, receive);
                lists.add(receive);
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
    
    public static int getCount(String status, long vendorId, 
        int ignore, Date startDate, Date endDate, long unitUsahaId) {
            
        int result = 0;
        CONResultSet dbrs = null;
        try {
            String sql = "select distinct count(pr."+colNames[COL_RECEIVE_ID]+") from "+DB_RECEIVE+" pr "+
                        " where pr."+colNames[COL_STATUS]+" = '"+status+"'";
            
                        if(vendorId!=0){
                            sql = sql + " and "+colNames[COL_VENDOR_ID]+"="+vendorId;
                        }
                        if(ignore==0){
                            sql = sql + " and (pr."+colNames[COL_DATE]+" between "+
                                "'"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
                                " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
                        }
                        if(unitUsahaId!=0){
                            sql = sql + " and pr."+colNames[COL_UNIT_USAHA_ID]+"="+unitUsahaId;
                        }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }
            rs.close();
            return result;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }
    
    public static Vector listVendorForAging(long vendorId, long unitUsahaId) {
            
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select distinct v.* from " +DbVendor.DB_VENDOR+" v "+
                        " inner join "+DB_RECEIVE+" pr "+
                        " on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+" = pr."+colNames[COL_VENDOR_ID]+
                        " where pr."+colNames[COL_STATUS]+" = '"+I_Project.DOC_STATUS_CHECKED+"'";
            
                        if(vendorId!=0){
                            sql = sql + " and pr."+colNames[COL_VENDOR_ID]+"="+vendorId;
                        }
                        
                        if(unitUsahaId!=0){
                            sql = sql + " and pr."+colNames[COL_UNIT_USAHA_ID]+"="+unitUsahaId;
                        }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Vendor vnd = new Vendor();
                DbVendor.resultToObject(rs, vnd);
                lists.add(vnd);
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
    

    public static void resultToObject(ResultSet rs, Receive receive) {
        try {
            receive.setOID(rs.getLong(DbReceive.colNames[DbReceive.COL_RECEIVE_ID]));
            receive.setApproval1(rs.getLong(DbReceive.colNames[DbReceive.COL_APPROVAL_1]));
            receive.setApproval2(rs.getLong(DbReceive.colNames[DbReceive.COL_APPROVAL_2]));
            receive.setApproval3(rs.getLong(DbReceive.colNames[DbReceive.COL_APPROVAL_3]));
            receive.setCounter(rs.getInt(DbReceive.colNames[DbReceive.COL_COUNTER]));
            receive.setIncluceTax(rs.getInt(DbReceive.colNames[DbReceive.COL_INCLUDE_TAX]));
            receive.setNote(rs.getString(DbReceive.colNames[DbReceive.COL_NOTE]));
            receive.setNumber(rs.getString(DbReceive.colNames[DbReceive.COL_NUMBER]));
            receive.setDate(rs.getDate(DbReceive.colNames[DbReceive.COL_DATE]));
            receive.setStatus(rs.getString(DbReceive.colNames[DbReceive.COL_STATUS]));
            receive.setUserId(rs.getLong(DbReceive.colNames[DbReceive.COL_USER_ID]));
            receive.setTotalTax(rs.getDouble(DbReceive.colNames[DbReceive.COL_TOTAL_TAX]));
            receive.setTotalAmount(rs.getDouble(DbReceive.colNames[DbReceive.COL_TOTAL_AMOUNT]));
            receive.setTaxPercent(rs.getDouble(DbReceive.colNames[DbReceive.COL_TAX_PERCENT]));
            receive.setDiscountTotal(rs.getDouble(DbReceive.colNames[DbReceive.COL_DISCOUNT_TOTAL]));
            receive.setDiscountPercent(rs.getDouble(DbReceive.colNames[DbReceive.COL_DISCOUNT_PERCENT]));
            receive.setPaymentType(rs.getString(DbReceive.colNames[DbReceive.COL_PAYMENT_TYPE]));
            receive.setLocationId(rs.getLong(DbReceive.colNames[DbReceive.COL_LOCATION_ID]));
            receive.setVendorId(rs.getLong(DbReceive.colNames[DbReceive.COL_VENDOR_ID]));
            receive.setCurrencyId(rs.getLong(DbReceive.colNames[DbReceive.COL_CURRENCY_ID]));
            receive.setPrefixNumber(rs.getString(DbReceive.colNames[DbReceive.COL_PREFIX_NUMBER]));
            receive.setClosedReason(rs.getString(DbReceive.colNames[DbReceive.COL_CLOSED_REASON]));            
            receive.setApproval1Date(rs.getDate(DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]));
            receive.setApproval2Date(rs.getDate(DbReceive.colNames[DbReceive.COL_APPROVAL_2_DATE]));
            receive.setApproval3Date(rs.getDate(DbReceive.colNames[DbReceive.COL_APPROVAL_3_DATE]));            
            receive.setPurchaseId(rs.getLong(DbReceive.colNames[DbReceive.COL_PURCHASE_ID]));
            receive.setDueDate(rs.getDate(DbReceive.colNames[DbReceive.COL_DUE_DATE]));
            receive.setPaymentAmount(rs.getDouble(DbReceive.colNames[DbReceive.COL_PAYMENT_AMOUNT]));
            receive.setDoNumber(rs.getString(DbReceive.colNames[DbReceive.COL_DO_NUMBER]));
            receive.setInvoiceNumber(rs.getString(DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]));
            receive.setPaymentStatus(rs.getInt(DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]));            
            receive.setUnitUsahaId(rs.getLong(DbReceive.colNames[DbReceive.COL_UNIT_USAHA_ID]));
            receive.setType(rs.getInt(DbReceive.colNames[DbReceive.COL_TYPE]));
            receive.setPeriodId(rs.getLong(DbReceive.colNames[DbReceive.COL_PERIOD_ID]));
            receive.setCoaId(rs.getLong(DbReceive.colNames[DbReceive.COL_COA_ID]));
            receive.setTypeAp(rs.getInt(DbReceive.colNames[DbReceive.COL_TYPE_AP]));
            receive.setPaymentStatusPosted(rs.getInt(DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS_POSTED]));
            receive.setNoPajak(rs.getString(DbReceive.colNames[DbReceive.COL_NO_PAJAK]));
            receive.setTypeInc(rs.getInt(DbReceive.colNames[DbReceive.COL_TYPE_INC]));
            receive.setReferenceId(rs.getLong(DbReceive.colNames[DbReceive.COL_REFERENCE_ID]));
        } catch (Exception e) {}
    }

    public static boolean checkOID(long receiveId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_RECEIVE + " WHERE " +
                    DbReceive.colNames[DbReceive.COL_RECEIVE_ID] + " = " + receiveId;

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
            String sql = "SELECT COUNT(" + DbReceive.colNames[DbReceive.COL_RECEIVE_ID] + ") FROM " + DB_RECEIVE;
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
                    Receive receive = (Receive) list.get(ls);
                    if (oid == receive.getOID()) {
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

    public static int getNextCounter(){
                int result = 0;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_RECEIVE+" where "+
                        colNames[COL_PREFIX_NUMBER]+"='"+getNumberPrefix()+"' ";
                    
                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while(rs.next()){
                        result = rs.getInt(1);
                    }                    
                    result = result + 1;
                    
                }catch(Exception e){                    
                }finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
        }
        
     public static int getNextCounterRecAdj(){
                int result = 0;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_RECEIVE+" where "+
                        colNames[COL_PREFIX_NUMBER]+"='"+getNumberPrefixRecAdjusment()+"' ";
                    
                    System.out.println(sql);
                    
                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while(rs.next()){
                        result = rs.getInt(1);
                    }                    
                    result = result + 1;
                    
                }catch(Exception e){                    
                }finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
        }
    
        public static String getNumberPrefix(){
                String code = "";
                Company sysCompany = DbCompany.getCompany();
                code = code + sysCompany.getInvoiceCode(); 
                
                code = code + JSPFormater.formatDate(new Date(), "MMyy");
                
                return code;
        }
        
        public static String getNumberPrefixRecAdjusment(){
                String code = "RADJ";
                
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
        
        public static String getNextNumberRecAdj(int ctr){
            
                String code = getNumberPrefixRecAdjusment();
                
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
        
        
        public static void validateReceiveItem(Receive receive){
                Vector outVendorItem = QrVendorItem.getOutVendorItems(receive); 
                if(outVendorItem!=null && outVendorItem.size()>0){
                    for(int i=0; i<outVendorItem.size(); i++){
                        ReceiveItem pi = (ReceiveItem)outVendorItem.get(i);
                        try{
                            DbReceiveItem.deleteExc(pi.getOID());
                        }
                        catch(Exception e){
                            System.out.println(e.toString());
                        }
                    }
                }
        }
        
        public static void fixGrandTotalAmount(long oidReceive){
            
            if(oidReceive!=0){
                Receive p = new Receive();
                try{
                    p = DbReceive.fetchExc(oidReceive);
                    p.setTotalAmount(DbReceiveItem.getTotalReceiveAmount(oidReceive));
                    double disPercent = p.getDiscountPercent();
                    double taxPercent = p.getTaxPercent();
                    if(disPercent>0){
                        p.setDiscountTotal((disPercent/100) * p.getTotalAmount());
                    }
                    else{
                        p.setDiscountPercent(0);
                        p.setDiscountTotal(0);
                    }
                    if(taxPercent>0){
                        p.setTotalTax((p.getTotalAmount()-p.getDiscountTotal()) * taxPercent/100);
                    }else{
                        p.setTaxPercent(0);
                        p.setTotalTax(0);
                    }
                    
                    DbReceive.updateExc(p);
                    
                }
                catch(Exception e){

                }
            }
            
        }
        
        public static long postJournal(Receive cr,long periodId, Company comp, ExchangeRate er){
                
                String memo = "Pembelian Barang : "+cr.getNumber();                
                long segment1_id = 0;                
                boolean coaComplete = true;                
                Vector vck = DbReceiveItem.list(0,0, colNames[COL_RECEIVE_ID]+"="+cr.getOID(), "");                       
                Periode p = new Periode();
                
                if(periodId == 0){                    
                    p = DbPeriode.getPeriodByTransDate(cr.getApproval1Date());                                        
                }else{
                    try{
                        p = DbPeriode.fetchExc(periodId);
                    }catch(Exception e){}
                }
                
                if(p.getOID() == 0 || p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0){
                    coaComplete = false;
                    return 0;
                }else{
                    periodId = p.getOID();
                }                
                
                Vendor vendor = new Vendor();
                try {
                    vendor = DbVendor.fetchExc(cr.getVendorId());
                } catch (Exception e) {}
                
                Location loc = new Location();
                try {
                    loc = DbLocation.fetchExc(cr.getLocationId());
                    if (vendor.getLiabilitiesType() == DbVendor.LIABILITIES_TYPE_GROSIR) {
                        if (loc.getCoaApGrosirId() == 0) {
                            coaComplete = false;
                        }
                    } else {
                        if (loc.getCoaApId() == 0) {
                            coaComplete = false;
                        }
                    }   
                } catch (Exception e) {
                    System.out.println("[exception] "+e.toString());
                }
                
                if (loc.getOID() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + loc.getOID();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        if (sd.getRefSegmentDetailId() != 0) {
                            segment1_id = sd.getRefSegmentDetailId();
                        } else {
                            segment1_id = sd.getOID();
                        }
                    }else{
                        coaComplete = false;
                    }
                }
                
                if(vck != null && vck.size() > 0){
                    
                    for(int ick = 0 ; ick < vck.size(); ick++){
                        
                        ReceiveItem rick = (ReceiveItem)vck.get(ick);
                        ItemMaster imck = new ItemMaster();
                        ItemGroup igck = new ItemGroup();
                        
                        try{                                    
                            imck = QrInvoice.getItem(rick.getItemMasterId());                        
                            igck = QrInvoice.getGroup(imck.getItemGroupId());                               
                        }catch(Exception e){
                             System.out.println("[exception] "+e.toString());
                        }           
                        
                        Vector invCoack = new Vector();
                                    
                        if(imck.getNeedRecipe()==0){
                            invCoack = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountInv()+"'", "");                            
                            if(invCoack == null || invCoack.size() <= 0){
                                coaComplete = false;
                                return 0;
                            }                            
                        }else{
                            if(igck.getAccountExpenseJasa()!=null && igck.getAccountExpenseJasa().length()>0){
                                invCoack = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountExpenseJasa()+"'", "");
                            }else{
                                invCoack = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountInv()+"'", "");
                            }
                            if (invCoack == null || invCoack.size() <= 0) {
                                coaComplete = false;
                                return 0;
                            }                                                       
                        }
                        
                        if(rick.getIsBonus() == DbReceiveItem.BONUS){                            
                            Vector invCoaOI = DbCoa.list(0,1, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountBonusIncome()+"'", "");
                            if (invCoaOI == null || invCoaOI.size() <= 0){
                                coaComplete = false;
                                return 0;
                            }
                        }
                        
                        if(rick.getApCoaId() != 0){
                            Coa coack = new Coa();
                            try{
                                coack = DbCoa.fetchExc(rick.getApCoaId());
                            }catch(Exception e){}
                            
                            if(coack.getOID() == 0){
                                coaComplete = false;
                                return 0;
                            }
                        }                   
                    }
                }    
                
                Vector tempck = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_GROUP_PURCHASING_TAX+"'", "");                        
                if(tempck==null || tempck.size() <= 0){
                    coaComplete = false;
                    return 0;
                }    
                
                if(coaComplete == false){
                    return 0;
                }
                               
                if(coaComplete && cr.getOID()!=0 && cr.getStatus().equals(I_Project.DOC_STATUS_CHECKED)){
                    Date approval1Date = cr.getApproval1Date();
                    long uid = cr.getApproval2();
                    if(cr.getApproval2Date() == null){
                        approval1Date = cr.getDate();
                        uid = cr.getApproval2();
                    }
                    
                    long oid = DbGl.postJournalMain(p.getTableName(),cr.getCurrencyId(), approval1Date, cr.getCounter(), cr.getNumber(), cr.getPrefixNumber(), 
                        I_Project.JOURNAL_TYPE_PURCHASE_ORDER, 
                        memo, uid, "", cr.getOID(), "", cr.getDate(), periodId);   
                    
                    boolean isALLBonus = true;
                    long coaAllOtherIncome = 0;
                    double totalBonus = 0;
                    long oidDebetAdjustment = 0;      
                    //pengakuan hutang    
                    
                    if(oid!=0){
                        
                        memo = "";                         
                        Vector v = DbReceiveItem.list(0,0, colNames[COL_RECEIVE_ID]+"="+cr.getOID(), "");                           
                        Receive recTotal = QrInvoice.getIncoming(cr.getOID()); 
                        
                        //double subTotal = DbReceiveItem.getTotalReceiveAmount(cr.getOID());                                                
                        double subTotal = recTotal.getTotalAmount();
                        
                        double credit  = 0;                         
                        long coaApId = loc.getCoaApId();   
                        if (vendor.getLiabilitiesType() == DbVendor.LIABILITIES_TYPE_GROSIR) {
                            coaApId = loc.getCoaApGrosirId();   
                        }else{
                            coaApId = loc.getCoaApId();   
                        }
                        
                        if(v!=null && v.size()>0){
                            
                            for(int i=0; i<v.size(); i++){                                
                                ReceiveItem ri = (ReceiveItem)v.get(i);                                
                                try{                                                                                
                                    ItemMaster im = QrInvoice.getItem(ri.getItemMasterId());
                                    ItemGroup ig = QrInvoice.getGroup(im.getItemGroupId());
                                    
                                    Vector invCoa = new Vector();
                                    
                                    //if it is stock - tambah stock
                                    if(im.getNeedRecipe()==0){
                                        invCoa = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+ig.getAccountInv()+"'", "");
                                    }
                                    //kalau bukan stock - lakukan ke biaya
                                    else{
                                        //jika belum diisi, larikan ke inventory saja
                                        if(ig.getAccountExpenseJasa()!=null && ig.getAccountExpenseJasa().length()>0){
                                            invCoa = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+ig.getAccountExpenseJasa()+"'", "");
                                        }else{
                                            invCoa = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+ig.getAccountInv()+"'", "");
                                        }
                                    }
                                    
                                    Coa coa = new Coa();
                                    if(invCoa!=null && invCoa.size()>0){
                                        coa = (Coa)invCoa.get(0);
                                    }

                                    double amount = 0;
                                    if(ri.getIsBonus() == DbReceiveItem.BONUS){
                                        if(ri.getAmount() != 0){
                                            amount = (ri.getQty() * ri.getAmount())-ri.getTotalDiscount();
                                        }else{
                                            amount = im.getCogs() * ri.getQty();
                                        }                                        
                                    }else{
                                        isALLBonus = false;
                                        amount = (ri.getQty() * ri.getAmount())-ri.getTotalDiscount();
                                    }                                    
                                    
                                    if(recTotal.getDiscountTotal() != 0){
                                        amount = ((ri.getQty() * ri.getAmount())-ri.getTotalDiscount()) - ((((ri.getQty() * ri.getAmount())-ri.getTotalDiscount())/subTotal) * recTotal.getDiscountTotal());
                                    }
                                    
                                    memo = "Purchase : "+ig.getName()+"/"+im.getCode()+"-"+im.getName();
                                    credit = credit + amount;
                                    
                                    if(amount != 0){
                                        if(amount > 0){
                                            DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coa.getOID(), 0, amount,             
                                                amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0); //non departmenttal item, department id = 0   
                                        }else{
                                            DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coa.getOID(), (amount*-1), 0,             
                                                (amount*-1), comp.getBookingCurrencyId(), oid, memo, 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0); //non departmenttal item, department id = 0   
                                        }
                                    }
                                    
                                    
                                    if(ri.getIsBonus() == DbReceiveItem.BONUS){                                        
                                        Vector vOtherIncome = DbCoa.list(0,1, DbCoa.colNames[DbCoa.COL_CODE]+"='"+ig.getAccountBonusIncome()+"'", "");
                                        Coa coaOtherIncome = new Coa();
                                        if(vOtherIncome!=null && vOtherIncome.size()>0){
                                            coaOtherIncome = (Coa)vOtherIncome.get(0);
                                        }
                                        
                                        memo = "Bonus income : "+ig.getName()+"/"+im.getCode()+"-"+im.getName();
                                        coaAllOtherIncome = coaOtherIncome.getOID();
                                        totalBonus = totalBonus + amount;
                                        if(amount != 0){
                                            if(amount > 0){
                                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coaOtherIncome.getOID(), amount, 0,             
                                                    amount, comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0); //non departmenttal item, department id = 0 
                                            }else{
                                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coaOtherIncome.getOID(), 0, (amount*-1),             
                                                    (amount*-1), comp.getBookingCurrencyId(), oid, memo, 0,
                                                    segment1_id, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0); //non departmenttal item, department id = 0 
                                            }
                                        }    
                                    }
                                    
                                }catch(Exception e){
                                    System.out.println("[exception] "+e.toString());
                                }                                
                            }
                        }
                        
                        //jika ada pajak, masukkan ke pajak masukan                        
                        AccLink al = new AccLink();                        
                        if(recTotal.getTotalTax()!=0){
                            
                            Vector temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_GROUP_PURCHASING_TAX+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }

                            //journal debet tax
                            memo = "Pajak pembelian "+cr.getNumber();                                   
                            credit = credit + recTotal.getTotalTax();
                            
                            if(recTotal.getTotalTax() > 0){
                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), al.getCoaId(), 0, recTotal.getTotalTax(),             
                                            recTotal.getTotalTax(), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0); //non departmenttal item, department id = 0                            
                            }else{
                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), al.getCoaId(), (recTotal.getTotalTax()*-1), 0,             
                                            (recTotal.getTotalTax()*-1), comp.getBookingCurrencyId(), oid, memo, 0,
                                            segment1_id, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0,
                                            0, 0, 0, 0); //non departmenttal item, department id = 0                            
                            }
                            oidDebetAdjustment = al.getCoaId();
                            
                        }     
                            
                        if(isALLBonus){                            
                            credit = credit - totalBonus;                  
                            if(credit > 0){
                                memo = "Bonus Income Pembelian "+cr.getNumber();       
                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coaAllOtherIncome, credit, 0,             
                                    credit, comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0); //non departmenttal item, department id = 0                                 
                            }                                
                        }else{                            
                            credit = credit - totalBonus;                  
                            if(credit > 0){
                                memo = "Hutang Pembelian :"+cr.getNumber();                        
                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coaApId, credit, 0,             
                                    credit, comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0); //non departmenttal item, department id = 0  
                            }else{
                                memo = "Hutang Pembelian :"+cr.getNumber();                        
                                DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coaApId, 0, (credit*-1),             
                                    (credit*-1), comp.getBookingCurrencyId(), oid, memo, 0,
                                    segment1_id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0); //non departmenttal item, department id = 0  
                            }
                        }
                        
                        if(isALLBonus){          
                            //jika semua barang bonus, maka langsung update incoming menjadi lunas
                            updatePaymentPaid(cr.getOID());                                                     
                        }
                    }                    
                    
                    SessOptimizedJournal.optimizeJournalGl(p, oid, "Purchase ("+cr.getNumber()+") ", "Purchase ("+cr.getNumber()+") ", 1); 
                    
                    try{
                        if(oidDebetAdjustment != 0){
                            Vector debKred = valueDebetCredit(oid);
                            double debi = Double.parseDouble(""+debKred.get(0));
                            double kred = Double.parseDouble(""+debKred.get(1));
                        
                            if(debi != kred){                            
                                double valAdjustment = debi - kred;
                                long oidAdj = oidAdjustmentDebet(oid,oidDebetAdjustment);
                                double val = valueDebet(oidAdj);                            
                                double finalAmount = val - valAdjustment;                            
                                adjustmentValue(oidAdj,finalAmount);
                            }
                        }
                    }catch(Exception e){}
                    
                    return 1;
                }
                return 0;
        }
        
        
        public static Vector valueDebetCredit(long glId){
            CONResultSet dbrs = null;
            try{
                String sql = "select sum("+DbGlDetail.colNames[DbGlDetail.COL_DEBET]+"),sum("+DbGlDetail.colNames[DbGlDetail.COL_CREDIT]+") from "+
                        DbGlDetail.DB_GL_DETAIL+" where "+DbGlDetail.colNames[DbGlDetail.COL_GL_ID]+" = "+glId;
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {
                    Vector result = new Vector();
                    result.add(""+rs.getDouble(1));
                    result.add(""+rs.getDouble(2));
                    return result;
                }
                rs.close();
                
            }catch(Exception e){
                
            }finally {
                CONResultSet.close(dbrs);
            }
            
            return null;
        }
        
        
         public static long oidAdjustmentDebet(long glId,long coaId){
            CONResultSet dbrs = null;
            try{
                String sql = "select "+DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID]+" from "+
                        DbGlDetail.DB_GL_DETAIL+" where "+DbGlDetail.colNames[DbGlDetail.COL_GL_ID]+" = "+glId+" and "+
                        DbGlDetail.colNames[DbGlDetail.COL_COA_ID]+" = "+coaId;
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
                while (rs.next()) {                                         
                    long glDetailId = rs.getLong(1);
                    return glDetailId;
                }
                rs.close();
                
            }catch(Exception e){
                
            }finally {
                CONResultSet.close(dbrs);
            }
            
            return 0;
        }
        
        public static double valueDebet(long glDetailId){
            CONResultSet dbrs = null;
            try{
                String sql = "select "+DbGlDetail.colNames[DbGlDetail.COL_DEBET]+" from "+
                        DbGlDetail.DB_GL_DETAIL+" where "+DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID]+" = "+glDetailId;
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
                while (rs.next()) {                    
                    double amount = 0;
                    amount = rs.getDouble(1);
                    return amount;
                }
                rs.close();
                
            }catch(Exception e){
                
            }finally {
                CONResultSet.close(dbrs);
            }
            
            return 0;
        }
        
        
        public static Vector adjustmentValue(long glDetailId,double amount){
            CONResultSet dbrs = null;
            try{
                String sql = "update "+DbGlDetail.DB_GL_DETAIL+" set "+DbGlDetail.colNames[DbGlDetail.COL_DEBET]+" = "+amount+","+
                        DbGlDetail.colNames[DbGlDetail.COL_FOREIGN_CURRENCY_AMOUNT]+" = "+amount+
                        " where "+DbGlDetail.colNames[DbGlDetail.COL_GL_DETAIL_ID]+" = "+glDetailId;                
                
                CONHandler.execUpdate(sql);
                
            }catch(Exception e){                
            }finally {
                CONResultSet.close(dbrs);
            }
            
            return null;
        }
        
        
        public static double getInvoiceBalance(long recOID){            
            double result = 0;         
            Receive recTotal = QrInvoice.getIncoming(recOID);        
            result = recTotal.getTotalAmount() + recTotal.getTotalTax() - recTotal.getDiscountTotal();            
            double totalAdj = 0;
            try{
                totalAdj = QrInvoice.getIncomingByReference(recOID); 
            }catch(Exception e){}            
            double payment = DbBankpoPayment.getTotalPaymentByInvoiceFin(recOID);            
            return (result - payment + totalAdj);
            
        }
        
        public static double getInvoiceRecAjustment(long recOID){
            double result = 0;
            
            Vector incomings = DbReceive.list(0, 0, DbReceive.colNames[DbReceive.COL_REFERENCE_ID]+" = "+recOID+" and "+DbReceive.colNames[DbReceive.COL_STATUS]+" = '"+I_Project.DOC_STATUS_CHECKED+"'", null);            
            if(incomings != null && incomings.size() > 0){
                
                for(int ix = 0; ix < incomings.size() ; ix++){
                    
                    try{
                        Receive r = (Receive)incomings.get(ix);
                
                        String where = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+" = "+r.getOID();
                        Vector vRD = DbReceiveItem.list(0, 0, where, null);
                
                        if(vRD != null && vRD.size() > 0){
                    
                            double subTotal = DbReceiveItem.getTotalReceiveAmount(recOID);                    
                            for(int i = 0 ; i < vRD.size() ; i++){
                                ReceiveItem ri = new ReceiveItem();
                                ri = (ReceiveItem)vRD.get(i);
                                double summary = 0;
                                summary = ri.getTotalAmount();
                        
                                if(r.getDiscountTotal() != 0 ){
                                    summary = ri.getTotalAmount() - ((ri.getTotalAmount()/subTotal) * r.getDiscountTotal());
                                }
                        
                                result = result + summary;
                            }
                    
                            result = result + r.getTotalTax();
                        }                
                    }catch(Exception e){}
                }
            }
            
            return result;
            
        }
        
        public static double getTotInvoice(long recOID){
            
            double result = 0;         
            Receive recTotal = QrInvoice.getIncoming(recOID);        
            result = recTotal.getTotalAmount() + recTotal.getTotalTax() - recTotal.getDiscountTotal();
            
            double totalAdj = 0;
            try{
                totalAdj = QrInvoice.getIncomingByReference(recOID);
            }catch(Exception e){}
            
            result = result + totalAdj;
            
            return result;
            
        }
        
        public static double getInvoiceBalanceEdt(long recOID,long bpdId){            
            double result = getTotInvoice(recOID);
            double payment = getTotalPaymentByInvoiceFinEdt(recOID,bpdId);        
            return result - payment;
            
        }
        
        public static double getTotalPaymentByInvoiceFinEdt(long invId,long bpdId) {
            double result = 0;
            CONResultSet crs = null;
            try {

                String sql = "SELECT sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] +
                    ") FROM " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL + " bpd " +
                    " where bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + " = " + invId+" and bpd."+
                    DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_DETAIL_ID]+" != "+bpdId;

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {                
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
            return result;
        }
        
        
        public static void checkForClosed(long bankpoPaymantId, Vector bpoDetails){
            if(bpoDetails!=null && bpoDetails.size()>0){
                for(int i=0; i<bpoDetails.size(); i++){
                    BankpoPaymentDetail bpod = (BankpoPaymentDetail)bpoDetails.get(i);                    
                    Receive r = new Receive();
                    try{
                        r = DbReceive.fetchExc(bpod.getInvoiceId());
                        double payment = DbBankpoPayment.getTotalPaymentByInvoiceFin(bpod.getInvoiceId());                        
                        double amount = DbReceive.getTotInvoice(r.getOID());
                        
                        if(payment!=0){
                            if(amount>payment){
                                r.setPaymentStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                            }
                            else{
                                r.setPaymentStatus(I_Project.INV_STATUS_FULL_PAID);
                            }
                            
                            DbReceive.updateExc(r);
                        }
                    }
                    catch(Exception e){                    
                    }                    
                }
            }
        }
        
        
        public static void checkForClosed(long bankpoPaymantId){
            CONResultSet crs = null;
            try{
                String sql = "select r.receive_id as receive_id from bankpo_payment_detail bd inner join pos_receive r on bd.invoice_id = r.receive_id where bd.bankpo_payment_id = "+bankpoPaymantId;
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {                
                    try{
                        long receiveId = rs.getLong("receive_id");
                        double balanceTotal = DbBankpoPayment.getTotalPaymentByInvoiceFin(receiveId);                                             
                        double total = DbReceive.getTotInvoice(receiveId);
                    
                        int statusPayment = 0;
                        if(total > 0){                    
                            if(balanceTotal == 0){
                                statusPayment = I_Project.INV_STATUS_DRAFT;
                            }else{
                                if(balanceTotal >= total){
                                    statusPayment = I_Project.INV_STATUS_FULL_PAID;                                                
                                }else{
                                    statusPayment = I_Project.INV_STATUS_PARTIALY_PAID;                                                
                                }                                        
                            }                                        
                        }else{
                                if(balanceTotal == 0){
                                    statusPayment = I_Project.INV_STATUS_DRAFT;
                                }else{
                                    if(balanceTotal <= total){
                                        statusPayment = I_Project.INV_STATUS_FULL_PAID;                                                
                                    }else{
                                        statusPayment = I_Project.INV_STATUS_PARTIALY_PAID;
                                    }    
                                } 
                        }    
                        DbBankpoPaymentDetail.updatePayment(receiveId,statusPayment);  
                        
                    }catch(Exception e){}
                }
                
            }catch(Exception e){
                 System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
    
        }
        
        
        public static double getTotalInvoiceByVendor(long oidVendor, Date startDate, Date endDate){
            
            String sql = "SELECT sum("+colNames[COL_TOTAL_AMOUNT]+"-"+colNames[COL_DISCOUNT_TOTAL]+"+"+colNames[COL_TOTAL_TAX]+")"+
                        " FROM "+DB_RECEIVE+" where "+colNames[COL_STATUS]+"='"+I_Project.DOC_STATUS_CHECKED+"'"+
                        
                        " and "+colNames[COL_VENDOR_ID]+"="+ oidVendor;

                        if(startDate!=null && endDate!=null){
                            sql = sql + " and "+colNames[COL_DUE_DATE]+
                                " >= '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
                                " and "+colNames[COL_DUE_DATE]+"<='"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"'";
                        }else if(startDate!=null){
                            sql = sql + " and "+colNames[COL_DUE_DATE]+
                                "<='"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'";
                        }else if(endDate!=null){
                            sql = sql + " and "+colNames[COL_DUE_DATE]+
                                ">='"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"'";
                        }
                       
                        
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
        
        
        
        public static double getTotalInvoiceByVendor(long oidVendor, Date startDate, Date endDate, long unitUsahaId){
            
            String sql = "SELECT sum("+colNames[COL_TOTAL_AMOUNT]+"-"+colNames[COL_DISCOUNT_TOTAL]+"+"+colNames[COL_TOTAL_TAX]+")"+
                        " FROM "+DB_RECEIVE+" where "+colNames[COL_STATUS]+"='"+I_Project.DOC_STATUS_CHECKED+"'"+
                        
                        " and "+colNames[COL_VENDOR_ID]+"="+ oidVendor;

                        if(startDate!=null && endDate!=null){
                            sql = sql + " and "+colNames[COL_DUE_DATE]+
                                " >= '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
                                " and "+colNames[COL_DUE_DATE]+"<='"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"'";
                        }else if(startDate!=null){
                            sql = sql + " and "+colNames[COL_DUE_DATE]+
                                "<='"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'";
                        }else if(endDate!=null){
                            sql = sql + " and "+colNames[COL_DUE_DATE]+
                                ">='"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"'";
                        }
                        if(unitUsahaId!=0){
                            sql = sql + " and "+colNames[COL_UNIT_USAHA_ID]+"="+unitUsahaId;
                        }
                        
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
        
        public static Vector getReceiveMainData(Date startDate, Date endDate, String vendorNames, int order, String status){
            
            String sql = "select * from "+DB_RECEIVE+" po "+
                        " inner join "+DbVendor.DB_VENDOR+
                        " v on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"=po."+colNames[COL_VENDOR_ID]+
                        " where po."+colNames[COL_DATE]+ 
                        " between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+" 00:00:00'"+
                        " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+" 23:59:59' ";
                        
                        if(vendorNames!=null && vendorNames.length()>0){
                            sql = sql + " and v."+DbVendor.colNames[DbVendor.COL_NAME]+" like '%"+vendorNames+"%' ";
                        }
            
                        if(status!=null && status.length()>0){
                            sql = sql + " and po."+colNames[COL_STATUS]+" = '"+status+"' ";
                        }
            
                        if(order==0){
                            sql = sql + " order by v."+DbVendor.colNames[DbVendor.COL_NAME];
                        }else{
                            sql = sql + " order by po."+colNames[COL_DATE];
                        }
                                                
            CONResultSet crs = null;
            Vector result = new Vector();
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Vector temp = new Vector();
                    Receive pur = new Receive();
                    Vendor ven = new Vendor();
                    resultToObject(rs, pur);
                    DbVendor.resultToObject(rs, ven);
                    temp.add(pur);
                    temp.add(ven);
                    result.add(temp);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                        
        }
        
        public static Vector getReceiveMainData(Date startDate, Date endDate, String vendorNames, int order, String status, long locationId){
            String sql;
            if(locationId!=0){
                sql = "select * from "+DB_RECEIVE+" po "+
                        " inner join "+DbVendor.DB_VENDOR+
                        " v on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"=po."+colNames[COL_VENDOR_ID]+
                        " where po." + colNames[COL_LOCATION_ID] + "=" + locationId + " and po."+colNames[COL_DATE]+ 
                        " between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+" 00:00:00'"+
                        " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+" 23:59:59' ";
            }else{
                sql = "select * from "+DB_RECEIVE+" po "+
                        " inner join "+DbVendor.DB_VENDOR+
                        " v on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"=po."+colNames[COL_VENDOR_ID]+
                        " where po."+colNames[COL_DATE]+ 
                        " between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+" 00:00:00'"+
                        " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+" 23:59:59' ";
            }
                        
                        if(vendorNames!=null && vendorNames.length()>0){
                            sql = sql + " and v."+DbVendor.colNames[DbVendor.COL_NAME]+" like '%"+vendorNames+"%' ";
                        }
            
                        if(status!=null && status.length()>0){
                            sql = sql + " and po."+colNames[COL_STATUS]+" = '"+status+"' ";
                        }
            
                        if(order==0){
                            sql = sql + " order by v."+DbVendor.colNames[DbVendor.COL_NAME];
                        }
                        else{
                            sql = sql + " order by po."+colNames[COL_DATE];
                        }
                        
                        System.out.println(sql);
                                                
            CONResultSet crs = null;
            Vector result = new Vector();
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Vector temp = new Vector();
                    Receive pur = new Receive();
                    Vendor ven = new Vendor();
                    resultToObject(rs, pur);
                    DbVendor.resultToObject(rs, ven);
                    temp.add(pur);
                    temp.add(ven);
                    result.add(temp);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                        
        }
        
        public static Vector getReceiveByItemGroup(Date startDate, Date endDate, String vendorNames, int order, String status, long itemGroupId){
            
            String sql = "select * from "+DB_RECEIVE+" po "+
                        " inner join "+DbReceiveItem.DB_RECEIVE_ITEM+
                        " poi on poi."+DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+
                        " =po."+colNames[COL_RECEIVE_ID]+
                        " inner join "+DbItemMaster.DB_ITEM_MASTER+
                        " im on im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                        " =poi."+DbReceiveItem.colNames[DbReceiveItem.COL_ITEM_MASTER_ID]+
                        " inner join "+DbVendor.DB_VENDOR+
                        " v on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"=po."+colNames[COL_VENDOR_ID]+
                        " where po."+colNames[COL_DATE]+ 
                        " between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+" 00:00:00'"+
                        " and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+" 23:59:59' ";
                        
                        if(vendorNames!=null && vendorNames.length()>0){
                            sql = sql + " and v."+DbVendor.colNames[DbVendor.COL_NAME]+" like '%"+vendorNames+"%' ";
                        }
            
                        if(status!=null && status.length()>0){
                            sql = sql + " and po."+colNames[COL_STATUS]+" = '"+status+"' ";
                        }
            
                        if(itemGroupId!=0){
                            sql = sql + " and im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+itemGroupId;
                        }                        
            
                        if(order==0){
                            sql = sql + " order by v."+DbVendor.colNames[DbVendor.COL_NAME];
                        }
                        else if(order==1){
                            sql = sql + " order by po."+colNames[COL_DATE];
                        }
                        else{
                            sql = sql + " order by im."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                        }
                                                
            CONResultSet crs = null;
            Vector result = new Vector();
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Vector temp = new Vector();
                    Receive pur = new Receive();
                    ReceiveItem purItem = new ReceiveItem();
                    ItemMaster im = new ItemMaster();                    
                    Vendor ven = new Vendor();
                    resultToObject(rs, pur);
                    DbReceiveItem.resultToObject(rs, purItem);
                    DbVendor.resultToObject(rs, ven);
                    DbItemMaster.resultToObject(rs, im);
                    temp.add(pur);
                    temp.add(ven);
                    temp.add(im);
                    temp.add(purItem);
                    result.add(temp);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                        
        }
        
        public static void postJournalAPMemo(Receive receive, long userId) {
        
            ExchangeRate er = DbExchangeRate.getStandardRate();
            try {
                receive = DbReceive.fetchExc(receive.getOID());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }
            Periode periode = new Periode();
            try{
                periode = DbPeriode.fetchExc(receive.getPeriodId());
            }catch(Exception e){}
        
            String where = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID]+" = "+receive.getLocationId();        
            Vector vSd = DbSegmentDetail.list(0, 1, where, null);        
            SegmentDetail sd = new SegmentDetail(); 
            long segment1Id = 0;
            
            if(vSd != null && vSd.size() > 0){
                sd = (SegmentDetail)vSd.get(0);
                if (sd.getRefSegmentDetailId() != 0) {
                    segment1Id = sd.getRefSegmentDetailId();
                } else {
                    segment1Id = sd.getOID();
                }
            }

            if (receive.getOID() != 0 && periode.getOID() != 0 && segment1Id != 0 && periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {
                String memo = receive.getNote();
                long oid = DbGl.postJournalMain(periode.getTableName(),0, receive.getDate(), receive.getCounter(), receive.getNumber(), receive.getPrefixNumber(), I_Project.JOURNAL_TYPE_AP_MEMO,
                        memo, userId, "", receive.getOID(), "", receive.getDate(), receive.getPeriodId());

                if (oid != 0) {
                
                    //Hutang pada other income
                    Vector vRi = DbReceiveItem.list(0, 0,DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+" = "+receive.getOID(),null);
                
                    double amount = 0;
                    if(vRi != null && vRi.size() > 0){
                        String memox = "";
                        for(int i = 0 ; i < vRi.size(); i++){
                            ReceiveItem ri = (ReceiveItem)vRi.get(i);                        
                            memo = ri.getMemo();
                            double amountItem = ri.getTotalAmount()*-1;                        
                            if(i==0){
                                memox = ri.getMemo();
                            }else{
                                memox = memox+", "+ri.getMemo();
                            }
                        
                            if(ri.getTotalAmount() <= 0){
                                DbGl.postJournalDetail(periode.getTableName(),er.getValueIdr(), ri.getApCoaId(), amountItem, 0,
                                    amountItem, er.getCurrencyIdrId(), oid, memo, 0,
                                    segment1Id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            }else{
                                DbGl.postJournalDetail(periode.getTableName(),er.getValueIdr(), ri.getApCoaId(), 0, ri.getTotalAmount(),
                                    ri.getTotalAmount(), er.getCurrencyIdrId(), oid, memo, 0,
                                    segment1Id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            }
                            amount = amount + amountItem;
                        }
                    
                        if(amount <= 0){
                            DbGl.postJournalDetail(periode.getTableName(),er.getValueIdr(), receive.getCoaId(), amount*-1, 0,
                                amount, receive.getCurrencyId(), oid, memox, 0,
                                segment1Id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);
                        }else{
                            DbGl.postJournalDetail(periode.getTableName(),er.getValueIdr(), receive.getCoaId(), 0, amount,
                                amount*-1, receive.getCurrencyId(), oid, memox, 0,
                                segment1Id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);
                        }                    
                    }
                }

                //update status
                if (oid != 0) {
                    try {
                        updateChecked(receive.getOID(),userId);                        
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
            }
        }
        
        public static void postJournalAutoKomisi(Receive receive, long userId) {
        
            ExchangeRate er = DbExchangeRate.getStandardRate();
            try {
                receive = DbReceive.fetchExc(receive.getOID());
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }
            Periode periode = new Periode();
            try{
                periode = DbPeriode.fetchExc(receive.getPeriodId());
            }catch(Exception e){}
        
            String where = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID]+" = "+receive.getLocationId();        
            Vector vSd = DbSegmentDetail.list(0, 1, where, null);        
            SegmentDetail sd = new SegmentDetail(); 
            long segment1Id = 0;
            
            if(vSd != null && vSd.size() > 0){
                sd = (SegmentDetail)vSd.get(0);
                if (sd.getRefSegmentDetailId() != 0) {
                    segment1Id = sd.getRefSegmentDetailId();
                } else {
                    segment1Id = sd.getOID();
                }
            }
            
            Vendor v = new Vendor();
            String addMemo = "";
            try{
                v = DbVendor.fetchExc(receive.getVendorId());
                addMemo = v.getName()+"-";
            }catch(Exception r){}

            if (receive.getOID() != 0 && periode.getOID() != 0 && segment1Id != 0 && periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {
                String memo = addMemo+receive.getNote();
                long oid = DbGl.postJournalMain(periode.getTableName(),0, receive.getDate(), receive.getCounter(), receive.getNumber(), receive.getPrefixNumber(), I_Project.JOURNAL_TYPE_AP_MEMO,
                        memo, userId, "", receive.getOID(), "", receive.getDate(), receive.getPeriodId());

                if (oid != 0) {
                
                    //Hutang pada other income
                    Vector vRi = DbReceiveItem.list(0, 0,DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+" = "+receive.getOID(),null);
                
                    double amount = 0;
                    if(vRi != null && vRi.size() > 0){
                        String memox = "";
                        for(int i = 0 ; i < vRi.size(); i++){
                            ReceiveItem ri = (ReceiveItem)vRi.get(i);                        
                            memo = ri.getMemo();
                            double amountItem = ri.getTotalAmount()*-1;                        
                            if(i==0){
                                memox = ri.getMemo();
                            }else{
                                memox = memox+", "+ri.getMemo();
                            }
                        
                            if(ri.getTotalAmount() <= 0){
                                DbGl.postJournalDetail(periode.getTableName(),er.getValueIdr(), ri.getApCoaId(), amountItem, 0,
                                    amountItem, er.getCurrencyIdrId(), oid, addMemo+""+memo, 0,
                                    segment1Id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            }else{
                                DbGl.postJournalDetail(periode.getTableName(),er.getValueIdr(), ri.getApCoaId(), 0, ri.getTotalAmount(),
                                    ri.getTotalAmount(), er.getCurrencyIdrId(), oid, addMemo+""+memo, 0,
                                    segment1Id, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0,
                                    0, 0, 0, 0);
                            }
                            amount = amount + amountItem;
                        }
                    
                        if(amount <= 0){
                            DbGl.postJournalDetail(periode.getTableName(),er.getValueIdr(), receive.getCoaId(), amount*-1, 0,
                                amount, receive.getCurrencyId(), oid, addMemo+memox, 0,
                                segment1Id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);
                        }else{
                            DbGl.postJournalDetail(periode.getTableName(),er.getValueIdr(), receive.getCoaId(), 0, amount,
                                amount*-1, receive.getCurrencyId(), oid, addMemo+memox, 0,
                                segment1Id, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0,
                                0, 0, 0, 0);
                        }                    
                    }
                }

                //update status
                if (oid != 0) {
                    try {
                        updateChecked(receive.getOID(),userId);                        
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
            }
        }
        
        
        public static void updateLoc(){            
            String sql = "select gd.gl_detail_id as glId,g.journal_number as number from gl_detail gd inner join gl g on gd.gl_id = g.gl_id where gd.segment1_id = 0 and g.journal_type = 6 ";            
            CONResultSet crs = null;            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();                
                while(rs.next()){
                    long glId = rs.getLong("glId");
                    String numb = rs.getString("number");
                    getLoc(glId,numb);
                    
                }
            }catch(Exception e){}finally{
                CONResultSet.close(crs);
            }       
        }
        
        
        public static void getLoc(long glDId,String numb){            
            String where = DbReceive.colNames[DbReceive.COL_NUMBER]+" = '"+numb+"'";
            Vector list = DbReceive.list(0, 1, where, null);
            
            long segment1_id;
            if(list != null && list.size() > 0){
                Receive receive = (Receive)list.get(0);
                if(receive.getLocationId() != 0){
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + receive.getLocationId();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        segment1_id = sd.getOID();
                        CONResultSet crs = null;
                        try{
                            String sql = "update gl_detail set segment1_id ="+segment1_id+" where gl_detail_id = "+glDId;
                            System.out.println(sql);
                            CONHandler.execUpdate(sql);
                        }catch(Exception e){}finally{
                            CONResultSet.close(crs);
                        }   
                    }
                }
            }
        }
        
        public static void updatePaymentPosted(){            
            String where = DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE]+" = "+1;
            Vector list = DbBankpoPayment.list(0, 0, where, null);
            if(list != null && list.size() > 0){
                for(int i = 0 ; i < list.size() ; i++){
                    BankpoPayment bpp = (BankpoPayment)list.get(i);
                    try{
                        BankpoPayment bpInduk = DbBankpoPayment.fetchExc(bpp.getRefId());
                        if(bpInduk.getOID() != 0){                            
                            Vector vBppDetail = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = "+bpInduk.getOID(), null);                            
                            if(vBppDetail != null && vBppDetail.size() > 0){
                                for(int x = 0; x < vBppDetail.size() ; x ++){                                    
                                    BankpoPaymentDetail bpd = (BankpoPaymentDetail)vBppDetail.get(x);                            
                                    String sql = "update pos_receive set payment_status_posted = 2 where receive_id = "+bpd.getInvoiceId()+";";
                                    System.out.println(sql);
                                }
                            }
                        }    
                    }catch(Exception e){}
                }
            }
        }
        
        public static Hashtable getReceiveOPP(long purchaseId){
            CONResultSet crs = null;
            try{
                String sql = "select "+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" from "+DbReceive.DB_RECEIVE+" where "+
                        DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" = "+purchaseId;
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();                
                Hashtable result = new Hashtable();     
                
                while(rs.next()){    
                    long receiveId = rs.getLong(1);
                    OnePendingPO onePendingPO = new OnePendingPO();
                    onePendingPO.setReceiveId(rs.getLong(1));
                    result.put(""+receiveId,onePendingPO);                    
                }    
                        
                return result;
                
            }catch(Exception e){}
            
            return null;
        }
        
        public static Hashtable getOnePendingPO(InvoiceSrc invSrc,long VendorId){
            
            CONResultSet crs = null;
            Hashtable result = new Hashtable();
            
            try{
                
                String where = "";
                
                if(VendorId != 0){                    
                    where = where +" and pr."+DbReceive.colNames[DbReceive.COL_VENDOR_ID]+"="+VendorId;
                }
        
                if(invSrc.getOverDue()==0){                    
                    where = where + " and pr."+DbReceive.colNames[DbReceive.COL_DUE_DATE]+"='"+JSPFormater.formatDate(invSrc.getDueDate(), "yyyy-MM-dd")+"'";            
                }
        
                if(invSrc.getVndInvNumber().length()>0){                    
                    where = where + " and (pr."+DbReceive.colNames[DbReceive.COL_INVOICE_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%'"+
                        " or pr."+DbReceive.colNames[DbReceive.COL_DO_NUMBER]+" like '%"+invSrc.getVndInvNumber()+"%')";            
                }
                
                String sql = "select ppid,recid,appdate from ("+                        
                    " select pp."+DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]+" as ppid, pr."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" as recid,pp."+DbPurchase.colNames[DbPurchase.COL_APPROVAL_2_DATE]+" as appdate from "+DbReceive.DB_RECEIVE+" pr inner join "+DbPurchase.DB_PURCHASE+" pp on pr."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" = pp."+DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]+" where pr."+DbReceive.colNames[DbReceive.COL_TYPE_AP]+" = "+DbReceive.TYPE_AP_NO+" and pr."+DbReceive.colNames[DbReceive.COL_STATUS]+" = 'CHECKED' and pr."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+" != 2 and pr."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" != 0 and pp."+DbPurchase.colNames[DbPurchase.COL_APPROVAL_2_DATE]+" is not null "+where+" union "+
                    " select 0 as ppid,pr."+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" as recid,pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" as appdate from "+DbReceive.DB_RECEIVE+" pr where pr."+DbReceive.colNames[DbReceive.COL_TYPE_AP]+" = "+DbReceive.TYPE_AP_NO+" and pr."+DbReceive.colNames[DbReceive.COL_STATUS]+" = 'CHECKED' and pr."+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+" != 2 and pr."+DbReceive.colNames[DbReceive.COL_PURCHASE_ID]+" = 0 and pr."+DbReceive.colNames[DbReceive.COL_APPROVAL_1_DATE]+" is not null "+where+") as r order by appdate desc";
                        
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                long tmpPurchaseId = 0;
                long tmpReceiveId = 0;
                
                while(rs.next()){    
                    
                    tmpPurchaseId = rs.getLong("ppid");
                    tmpReceiveId = rs.getLong("recid");
                    
                    if(tmpPurchaseId != 0){
                        result = getReceiveOPP(tmpPurchaseId);
                        return result;
                    }else{                        
                        OnePendingPO onePendingPO = new OnePendingPO();
                        onePendingPO.setReceiveId(tmpReceiveId);
                        result.put(""+tmpReceiveId,onePendingPO);
                        return result;
                    }
                }
                
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }
            return result;
        }
        
        public static void updateChecked(long receiveId,long userId){
            CONResultSet crs = null;
            try{                
                String sql = "update "+DbReceive.DB_RECEIVE+" set "+DbReceive.colNames[DbReceive.COL_STATUS]+" = '"+I_Project.DOC_STATUS_CHECKED+"',"+
                        DbReceive.colNames[DbReceive.COL_APPROVAL_3]+" = "+userId+","+
                        DbReceive.colNames[DbReceive.COL_APPROVAL_3_DATE]+" = '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd HH:mm:ss")+"' where "+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" = "+receiveId;
                        
                CONHandler.execUpdate(sql);
                
            }catch(Exception e){}            
            finally{
                CONResultSet.close(crs);
            }    
        }
        
        public static void updatePaymentPaid(long receiveId){
            CONResultSet crs = null;
            try{
                String sql = "update "+DbReceive.DB_RECEIVE+" set "+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+" = '"+I_Project.INV_STATUS_FULL_PAID+"',"+
                        DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS_POSTED]+" = '"+STATUS_FULL_PAID_POSTED+"' "+
                        " where "+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" = "+receiveId;
                        
                CONHandler.execUpdate(sql);
                
            }catch(Exception e){}
            
            finally{
                CONResultSet.close(crs);
            }    
        }
        
}
