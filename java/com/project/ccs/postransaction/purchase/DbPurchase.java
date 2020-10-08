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
import com.project.util.*;
import com.project.general.*;
import java.util.Date;
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.purchase.*;
import com.project.ccs.postransaction.receiving.*;
import com.project.*;

public class DbPurchase extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PURCHASE = "pos_purchase";
    public static final int COL_PURCHASE_ID = 0;
    public static final int COL_PURCH_DATE = 1;
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
    public static final int COL_EXPIRED_DATE = 25;
    
    public static final String[] colNames = {
        "purchase_id",
        "purch_date",
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
        "expired_date"
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
        TYPE_DATE
    };
    
    public static int INCLUDE_TAX_NO = 0;
    public static int INCLUDE_TAX_YES = 1;
    public static String[] strIncludeTax = {"No", "Yes"};

    public DbPurchase() {
    }

    public DbPurchase(int i) throws CONException {
        super(new DbPurchase());
    }

    public DbPurchase(String sOid) throws CONException {
        super(new DbPurchase(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPurchase(long lOid) throws CONException {
        super(new DbPurchase(0));
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
        return DB_PURCHASE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPurchase().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Purchase purchase = fetchExc(ent.getOID());
        ent = (Entity) purchase;
        return purchase.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Purchase) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Purchase) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Purchase fetchExc(long oid) throws CONException {
        try {
            Purchase purchase = new Purchase();
            DbPurchase dbPurchaseRequest = new DbPurchase(oid);
            purchase.setOID(oid);
            purchase.setApproval1(dbPurchaseRequest.getlong(COL_APPROVAL_1));
            purchase.setApproval2(dbPurchaseRequest.getlong(COL_APPROVAL_2));
            purchase.setApproval3(dbPurchaseRequest.getlong(COL_APPROVAL_3));
            purchase.setCounter(dbPurchaseRequest.getInt(COL_COUNTER));
            purchase.setIncluceTax(dbPurchaseRequest.getInt(COL_INCLUDE_TAX));
            purchase.setNote(dbPurchaseRequest.getString(COL_NOTE));
            purchase.setNumber(dbPurchaseRequest.getString(COL_NUMBER));
            purchase.setPurchDate(dbPurchaseRequest.getDate(COL_PURCH_DATE));
            purchase.setStatus(dbPurchaseRequest.getString(COL_STATUS));
            purchase.setUserId(dbPurchaseRequest.getlong(COL_USER_ID));
            purchase.setTotalTax(dbPurchaseRequest.getdouble(COL_TOTAL_TAX));
            purchase.setTotalAmount(dbPurchaseRequest.getdouble(COL_TOTAL_AMOUNT));
            purchase.setTaxPercent(dbPurchaseRequest.getdouble(COL_TAX_PERCENT));
            purchase.setDiscountTotal(dbPurchaseRequest.getdouble(COL_DISCOUNT_TOTAL));
            purchase.setDiscountPercent(dbPurchaseRequest.getdouble(COL_DISCOUNT_PERCENT));
            purchase.setPaymentType(dbPurchaseRequest.getString(COL_PAYMENT_TYPE));
            purchase.setLocationId(dbPurchaseRequest.getlong(COL_LOCATION_ID));
            purchase.setVendorId(dbPurchaseRequest.getlong(COL_VENDOR_ID));            
            purchase.setCurrencyId(dbPurchaseRequest.getlong(COL_CURRENCY_ID));
            purchase.setPrefixNumber(dbPurchaseRequest.getString(COL_PREFIX_NUMBER));
            purchase.setClosedReason(dbPurchaseRequest.getString(COL_CLOSED_REASON));
            
            purchase.setApproval1Date(dbPurchaseRequest.getDate(COL_APPROVAL_1_DATE));
            purchase.setApproval2Date(dbPurchaseRequest.getDate(COL_APPROVAL_2_DATE));
            purchase.setApproval3Date(dbPurchaseRequest.getDate(COL_APPROVAL_3_DATE));
            purchase.setExpiredDate(dbPurchaseRequest.getDate(COL_EXPIRED_DATE));
            return purchase;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchase(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Purchase purchase) throws CONException {
        try {
            DbPurchase dbPurchaseRequest = new DbPurchase(0);

            dbPurchaseRequest.setLong(COL_APPROVAL_1, purchase.getApproval1());
            dbPurchaseRequest.setLong(COL_APPROVAL_2, purchase.getApproval2());
            dbPurchaseRequest.setLong(COL_APPROVAL_3, purchase.getApproval3());
            dbPurchaseRequest.setInt(COL_COUNTER, purchase.getCounter());
            dbPurchaseRequest.setInt(COL_INCLUDE_TAX, purchase.getIncluceTax());
            dbPurchaseRequest.setString(COL_NOTE, purchase.getNote());
            dbPurchaseRequest.setString(COL_NUMBER, purchase.getNumber());
            dbPurchaseRequest.setDate(COL_PURCH_DATE, purchase.getPurchDate());
            dbPurchaseRequest.setString(COL_STATUS, purchase.getStatus());
            dbPurchaseRequest.setLong(COL_USER_ID, purchase.getUserId());
            dbPurchaseRequest.setDouble(COL_TOTAL_TAX, purchase.getTotalTax());
            dbPurchaseRequest.setDouble(COL_TOTAL_AMOUNT, purchase.getTotalAmount());
            dbPurchaseRequest.setDouble(COL_TAX_PERCENT, purchase.getTaxPercent());
            dbPurchaseRequest.setDouble(COL_DISCOUNT_TOTAL, purchase.getDiscountTotal());
            dbPurchaseRequest.setDouble(COL_DISCOUNT_PERCENT, purchase.getDiscountPercent());
            dbPurchaseRequest.setString(COL_PAYMENT_TYPE, purchase.getPaymentType());
            dbPurchaseRequest.setLong(COL_LOCATION_ID, purchase.getLocationId());
            dbPurchaseRequest.setLong(COL_VENDOR_ID, purchase.getVendorId());
            dbPurchaseRequest.setLong(COL_CURRENCY_ID, purchase.getCurrencyId());
            dbPurchaseRequest.setString(COL_PREFIX_NUMBER, purchase.getPrefixNumber());
            dbPurchaseRequest.setString(COL_CLOSED_REASON, purchase.getClosedReason());
            
            dbPurchaseRequest.setDate(COL_APPROVAL_1_DATE, purchase.getApproval1Date());
            dbPurchaseRequest.setDate(COL_APPROVAL_2_DATE, purchase.getApproval2Date());
            dbPurchaseRequest.setDate(COL_APPROVAL_3_DATE, purchase.getApproval3Date());
            dbPurchaseRequest.setDate(COL_EXPIRED_DATE, purchase.getExpiredDate());
            dbPurchaseRequest.insert();
            purchase.setOID(dbPurchaseRequest.getlong(COL_PURCHASE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchase(0), CONException.UNKNOWN);
        }
        return purchase.getOID();
    }

    public static long updateExc(Purchase purchase) throws CONException {
        try {
            if (purchase.getOID() != 0) {
                DbPurchase dbPurchaseRequest = new DbPurchase(purchase.getOID());

                dbPurchaseRequest.setLong(COL_APPROVAL_1, purchase.getApproval1());
                dbPurchaseRequest.setLong(COL_APPROVAL_2, purchase.getApproval2());
                dbPurchaseRequest.setLong(COL_APPROVAL_3, purchase.getApproval3());
                dbPurchaseRequest.setInt(COL_COUNTER, purchase.getCounter());
                dbPurchaseRequest.setInt(COL_INCLUDE_TAX, purchase.getIncluceTax());
                dbPurchaseRequest.setString(COL_NOTE, purchase.getNote());
                dbPurchaseRequest.setString(COL_NUMBER, purchase.getNumber());
                dbPurchaseRequest.setDate(COL_PURCH_DATE, purchase.getPurchDate());
                dbPurchaseRequest.setString(COL_STATUS, purchase.getStatus());
                dbPurchaseRequest.setLong(COL_USER_ID, purchase.getUserId());
                dbPurchaseRequest.setDouble(COL_TOTAL_TAX, purchase.getTotalTax());
                dbPurchaseRequest.setDouble(COL_TOTAL_AMOUNT, purchase.getTotalAmount());
                dbPurchaseRequest.setDouble(COL_TAX_PERCENT, purchase.getTaxPercent());
                dbPurchaseRequest.setDouble(COL_DISCOUNT_TOTAL, purchase.getDiscountTotal());
                dbPurchaseRequest.setDouble(COL_DISCOUNT_PERCENT, purchase.getDiscountPercent());
                dbPurchaseRequest.setString(COL_PAYMENT_TYPE, purchase.getPaymentType());
                dbPurchaseRequest.setLong(COL_LOCATION_ID, purchase.getLocationId());
                dbPurchaseRequest.setLong(COL_VENDOR_ID, purchase.getVendorId());
                dbPurchaseRequest.setLong(COL_CURRENCY_ID, purchase.getCurrencyId());
                dbPurchaseRequest.setString(COL_PREFIX_NUMBER, purchase.getPrefixNumber());
                dbPurchaseRequest.setString(COL_CLOSED_REASON, purchase.getClosedReason());
                
                dbPurchaseRequest.setDate(COL_APPROVAL_1_DATE, purchase.getApproval1Date());
                dbPurchaseRequest.setDate(COL_APPROVAL_2_DATE, purchase.getApproval2Date());
                dbPurchaseRequest.setDate(COL_APPROVAL_3_DATE, purchase.getApproval3Date());
                dbPurchaseRequest.setDate(COL_EXPIRED_DATE, purchase.getExpiredDate());
                dbPurchaseRequest.update();
                return purchase.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchase(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPurchase pstPurchaseRequest = new DbPurchase(oid);
            pstPurchaseRequest.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPurchase(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PURCHASE;
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
                Purchase purchase = new Purchase();
                resultToObject(rs, purchase);
                lists.add(purchase);
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

    public static void resultToObject(ResultSet rs, Purchase purchase) {
        try {
            purchase.setOID(rs.getLong(DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]));
            purchase.setApproval1(rs.getLong(DbPurchase.colNames[DbPurchase.COL_APPROVAL_1]));
            purchase.setApproval2(rs.getLong(DbPurchase.colNames[DbPurchase.COL_APPROVAL_2]));
            purchase.setApproval3(rs.getLong(DbPurchase.colNames[DbPurchase.COL_APPROVAL_3]));
            purchase.setCounter(rs.getInt(DbPurchase.colNames[DbPurchase.COL_COUNTER]));
            purchase.setIncluceTax(rs.getInt(DbPurchase.colNames[DbPurchase.COL_INCLUDE_TAX]));
            purchase.setNote(rs.getString(DbPurchase.colNames[DbPurchase.COL_NOTE]));
            purchase.setNumber(rs.getString(DbPurchase.colNames[DbPurchase.COL_NUMBER]));
            purchase.setPurchDate(rs.getDate(DbPurchase.colNames[DbPurchase.COL_PURCH_DATE]));
            purchase.setStatus(rs.getString(DbPurchase.colNames[DbPurchase.COL_STATUS]));
            purchase.setUserId(rs.getLong(DbPurchase.colNames[DbPurchase.COL_USER_ID]));
            purchase.setTotalTax(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_TOTAL_TAX]));
            purchase.setTotalAmount(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_TOTAL_AMOUNT]));
            purchase.setTaxPercent(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_TAX_PERCENT]));
            purchase.setDiscountTotal(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_DISCOUNT_TOTAL]));
            purchase.setDiscountPercent(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_DISCOUNT_PERCENT]));
            purchase.setPaymentType(rs.getString(DbPurchase.colNames[DbPurchase.COL_PAYMENT_TYPE]));
            purchase.setLocationId(rs.getLong(DbPurchase.colNames[DbPurchase.COL_LOCATION_ID]));
            purchase.setVendorId(rs.getLong(DbPurchase.colNames[DbPurchase.COL_VENDOR_ID]));
            purchase.setCurrencyId(rs.getLong(DbPurchase.colNames[DbPurchase.COL_CURRENCY_ID]));
            purchase.setPrefixNumber(rs.getString(DbPurchase.colNames[DbPurchase.COL_PREFIX_NUMBER]));
            purchase.setClosedReason(rs.getString(DbPurchase.colNames[DbPurchase.COL_CLOSED_REASON]));
            
            purchase.setApproval1Date(rs.getDate(DbPurchase.colNames[DbPurchase.COL_APPROVAL_1_DATE]));
            purchase.setApproval2Date(rs.getDate(DbPurchase.colNames[DbPurchase.COL_APPROVAL_2_DATE]));
            purchase.setApproval3Date(rs.getDate(DbPurchase.colNames[DbPurchase.COL_APPROVAL_3_DATE]));
            purchase.setExpiredDate(rs.getDate(DbPurchase.colNames[DbPurchase.COL_EXPIRED_DATE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long purchaseId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PURCHASE + " WHERE " +
                    DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID] + " = " + purchaseId;

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
            String sql = "SELECT COUNT(" + DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID] + ") FROM " + DB_PURCHASE;
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
                    Purchase purchase = (Purchase) list.get(ls);
                    if (oid == purchase.getOID()) {
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
                    String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_PURCHASE+" where "+
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
                code = code + sysCompany.getPurchaseOrderCode(); 
                
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
        
        
        public static void validatePurchaseItem(Purchase purchase){
                Vector outVendorItem = QrVendorItem.getOutVendorItems(purchase); 
                if(outVendorItem!=null && outVendorItem.size()>0){
                    for(int i=0; i<outVendorItem.size(); i++){
                        PurchaseItem pi = (PurchaseItem)outVendorItem.get(i);
                        try{
                            DbPurchaseItem.deleteExc(pi.getOID());
                        }
                        catch(Exception e){
                            System.out.println(e.toString());
                        }
                    }
                }
        }
        
        public static void fixGrandTotalAmount(long oidPurchase){
            
            if(oidPurchase!=0){
                Purchase p = new Purchase();
                try{
                    p = DbPurchase.fetchExc(oidPurchase);
                    p.setTotalAmount(DbPurchaseItem.getTotalPurchaseAmount(oidPurchase));
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
                    }
                    else{
                        p.setTaxPercent(0);
                        p.setTotalTax(0);
                    }
                    
                    DbPurchase.updateExc(p);
                    
                }
                catch(Exception e){

                }
            }
            
        }
        
        
        public static void checkPurchaseStatus(long purchaseId, long poClose){
            
            String sql = " select sum("+DbPurchaseItem.colNames[DbPurchaseItem.COL_QTY]+") from "+DbPurchaseItem.DB_PURCHASE_ITEM+
                         " where "+DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+" = "+purchaseId;
            
            CONResultSet crs = null;            
            double qty = 0;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    qty = rs.getDouble(1);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            sql = " select sum(ri."+DbReceiveItem.colNames[DbReceiveItem.COL_QTY]+") from "+DbPurchaseItem.DB_PURCHASE_ITEM+" pi "+
                  " inner join "+DbReceiveItem.DB_RECEIVE_ITEM+" ri "+
                  " on pi."+DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ITEM_ID]+" = ri."+DbReceiveItem.colNames[DbReceiveItem.COL_PURCHASE_ITEM_ID]+
                  " where pi."+DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+" = "+purchaseId;
            
            crs = null;            
            double qty1 = 0;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    qty1 = rs.getDouble(1);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            System.out.println("\n in update status : qty = "+qty+", qty1 = "+qty1);
            
            try{
                Purchase purchase = DbPurchase.fetchExc(purchaseId);
                //sudah closed
                if(poClose==1){
                    System.out.println("CLOSE PO !");
                    purchase.setStatus(I_Project.DOC_STATUS_CLOSE);
                    
                }else{
                    if(qty==qty1){
                        System.out.println("CLOSE PO !");
                        purchase.setStatus(I_Project.DOC_STATUS_CLOSE);
                    }
                    else{
                        System.out.println("NO CLOSE PO !");
                        purchase.setStatus(I_Project.DOC_STATUS_CHECKED);
                    }
                }
                
                
                DbPurchase.updateExc(purchase);
                
            }
            catch(Exception e){
                
            }
           
            
        }
        
        public static Vector getPuchaseOrderMainData(Date startDate, Date endDate, String vendorNames, int order, String status){
            
            String sql = "select * from "+DB_PURCHASE+" po "+
                        " inner join "+DbVendor.DB_VENDOR+
                        " v on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"=po."+colNames[COL_VENDOR_ID]+
                        " where po."+colNames[COL_PURCH_DATE]+ 
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
                        }
                        else{
                            sql = sql + " order by po."+colNames[COL_PURCH_DATE];
                        }
                        
                        System.out.println(sql);
                                                
            CONResultSet crs = null;
            Vector result = new Vector();
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Vector temp = new Vector();
                    Purchase pur = new Purchase();
                    Vendor ven = new Vendor();
                    DbPurchase.resultToObject(rs, pur);
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
        
        public static Vector getPuchaseOrderByItemGroup(Date startDate, Date endDate, String vendorNames, int order, String status, long itemGroupId){
            
            String sql = "select * from "+DB_PURCHASE+" po "+
                        " inner join "+DbPurchaseItem.DB_PURCHASE_ITEM+
                        " poi on poi."+DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+
                        " =po."+colNames[COL_PURCHASE_ID]+
                        " inner join "+DbItemMaster.DB_ITEM_MASTER+
                        " im on im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                        " =poi."+DbPurchaseItem.colNames[DbPurchaseItem.COL_ITEM_MASTER_ID]+
                        " inner join "+DbVendor.DB_VENDOR+
                        " v on v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+"=po."+colNames[COL_VENDOR_ID]+
                        " where po."+colNames[COL_PURCH_DATE]+ 
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
                            sql = sql + " order by po."+colNames[COL_PURCH_DATE];
                        }
                        else{
                            sql = sql + " order by im."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                        }
                        
                        System.out.println(sql);
                                                
            CONResultSet crs = null;
            Vector result = new Vector();
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Vector temp = new Vector();
                    Purchase pur = new Purchase();
                    PurchaseItem purItem = new PurchaseItem();
                    ItemMaster im = new ItemMaster();                    
                    Vendor ven = new Vendor();
                    DbPurchase.resultToObject(rs, pur);
                    DbPurchaseItem.resultToObject(rs, purItem);
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
        
        
}
