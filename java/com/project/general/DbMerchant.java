/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import com.project.ccs.postransaction.sales.DbPayment;
import com.project.ccs.postransaction.sales.DbSales;
import com.project.ccs.session.PayMerchant; 
import java.io.*;
import java.sql.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import com.project.util.lang.*;
import java.util.Vector;

/**
 *
 * @author Roy Andika
 */
public class DbMerchant extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_MERCHANT = "merchant";
    
    public static final int COL_MERCHANT_ID = 0;
    public static final int COL_BANK_ID = 1;
    public static final int COL_LOCATION_ID = 2;
    public static final int COL_CODE_MERCHANT = 3;
    public static final int COL_PERSEN_EXPENSE = 4;
    public static final int COL_DESCRIPTION = 5;    
    public static final int COL_COA_ID = 6;    
    public static final int COL_COA_EXPENSE_ID = 7; 
    public static final int COL_TYPE_PAYMENT = 8; 
    public static final int COL_PERSEN_DISKON = 9;     
    public static final int COL_COA_DISKON_ID = 10; 
    public static final int COL_PAYMENT_BY = 11; 
    public static final int COL_PENDAPATAN_MERCHANT = 12;     
    public static final int COL_POSTING_EXPENSE = 13;     
 
    public static final String[] colNames = {
        "merchant_id",
        "bank_id",
        "location_id",
        "code_merchant",
        "persen_expense",
        "description",
        "coa_id",
        "coa_expense_id",
        "type_payment",
        "persen_diskon",
        "coa_diskon_id",
        "payment_by",
        "pendapatan_merchant",
        "posting_expense"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT
    };
    
    public static int PAYMENT_BY_COMPANY = 0;
    public static int PAYMENT_BY_CUSTOMER  = 1;       
    
    public static int TYPE_NONE = 0;
    public static int TYPE_CREDIT_CARD = 1;
    public static int TYPE_DEBIT_CARD  = 2; 
    public static int TYPE_FINANCE  = 3; 
    public static int TYPE_GIRO  = 4; 
    public static int TYPE_TRANSFER  = 5; 
    public static int TYPE_VOUCHER  = 6; 
    public static int TYPE_FINANCE_FIF  = 7; 
    public static int TYPE_VOUCHER_SATKER  = 8; 
    public static int TYPE_VOUCHER_PU  = 9; 
    public static int TYPE_VOUCHER_DPRD  = 10;
    public static int TYPE_VOUCHER_ASTRA  =11;
    public static int TYPE_VOUCHER_KUPON  = 12;
    public static int TYPE_DONASI  = 13;
    public static int TYPE_CASH_BACK  = 14;
    
    public static String[] strType = {"", "Credit Card", "Debit Card", "Finance", "Giro", "Transfer","Voucher","Finance FIF","Voucher Satker","Voucher PU","Voucher DPRD","Voucher ASTRA","Voucher Kupon","Donasi","Cash Back"};
    
    public static int POSTING_EXPENSE  = 0; 
    public static int NON_POSTING_EXPENSE  = 1; 
    
    public static String[] strPosting = {"Yes", "No",};

    public DbMerchant() {
    }

    public DbMerchant(int i) throws CONException {
        super(new DbMerchant());
    }

    public DbMerchant(String sOid) throws CONException {
        super(new DbMerchant(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbMerchant(long lOid) throws CONException {
        super(new DbMerchant(0));
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
        return DB_MERCHANT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbMerchant().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Merchant merchant = fetchExc(ent.getOID());
        ent = (Entity) merchant;
        return merchant.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Merchant) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Merchant) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Merchant fetchExc(long oid) throws CONException {
        try {
            Merchant merchant = new Merchant();
            DbMerchant pstMerchant = new DbMerchant(oid);
            merchant.setOID(oid);
            
            merchant.setBankId(pstMerchant.getlong(COL_BANK_ID));
            merchant.setLocationId(pstMerchant.getlong(COL_LOCATION_ID));
            merchant.setCodeMerchant(pstMerchant.getString(COL_CODE_MERCHANT));
            merchant.setPersenExpense(pstMerchant.getdouble(COL_PERSEN_EXPENSE));
            merchant.setDescription(pstMerchant.getString(COL_DESCRIPTION));
            merchant.setCoaId(pstMerchant.getlong(COL_COA_ID));
            merchant.setCoaExpenseId(pstMerchant.getlong(COL_COA_EXPENSE_ID));
            merchant.setTypePayment(pstMerchant.getInt(COL_TYPE_PAYMENT));
            merchant.setPersenDiskon(pstMerchant.getdouble(COL_PERSEN_DISKON));            
            merchant.setCoaDiskonId(pstMerchant.getlong(COL_COA_DISKON_ID));
            merchant.setPaymentBy(pstMerchant.getInt(COL_PAYMENT_BY));
            merchant.setPendapatanMerchant(pstMerchant.getlong(COL_PENDAPATAN_MERCHANT));
            merchant.setPostingExpense(pstMerchant.getInt(COL_POSTING_EXPENSE));

            return merchant;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMerchant(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Merchant merchant) throws CONException {
        try {
            DbMerchant pstMerchant = new DbMerchant(0);

            pstMerchant.setLong(COL_BANK_ID, merchant.getBankId());
            pstMerchant.setLong(COL_LOCATION_ID, merchant.getLocationId());
            pstMerchant.setString(COL_CODE_MERCHANT, merchant.getCodeMerchant());
            pstMerchant.setDouble(COL_PERSEN_EXPENSE, merchant.getPersenExpense());
            pstMerchant.setString(COL_DESCRIPTION, merchant.getDescription());
            pstMerchant.setLong(COL_COA_ID, merchant.getCoaId());
            pstMerchant.setLong(COL_COA_EXPENSE_ID, merchant.getCoaExpenseId());
            pstMerchant.setInt(COL_TYPE_PAYMENT, merchant.getTypePayment());
            pstMerchant.setDouble(COL_PERSEN_DISKON, merchant.getPersenDiskon());            
            pstMerchant.setLong(COL_COA_DISKON_ID, merchant.getCoaDiskonId());
            pstMerchant.setInt(COL_PAYMENT_BY, merchant.getPaymentBy());
            pstMerchant.setLong(COL_PENDAPATAN_MERCHANT, merchant.getPendapatanMerchant());
            pstMerchant.setInt(COL_POSTING_EXPENSE, merchant.getPostingExpense());

            pstMerchant.insert();
            merchant.setOID(pstMerchant.getlong(COL_BANK_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMerchant(0), CONException.UNKNOWN);
        }
        return merchant.getOID();
    }

    public static long updateExc(Merchant merchant) throws CONException {
        try {
            if (merchant.getOID() != 0) {
                DbMerchant pstMerchant = new DbMerchant(merchant.getOID());

                pstMerchant.setLong(COL_BANK_ID, merchant.getBankId());
                pstMerchant.setLong(COL_LOCATION_ID, merchant.getLocationId());
                pstMerchant.setString(COL_CODE_MERCHANT, merchant.getCodeMerchant());
                pstMerchant.setDouble(COL_PERSEN_EXPENSE, merchant.getPersenExpense());
                pstMerchant.setString(COL_DESCRIPTION, merchant.getDescription());
                pstMerchant.setLong(COL_COA_ID, merchant.getCoaId());
                pstMerchant.setLong(COL_COA_EXPENSE_ID, merchant.getCoaExpenseId());
                pstMerchant.setInt(COL_TYPE_PAYMENT, merchant.getTypePayment());
                pstMerchant.setDouble(COL_PERSEN_DISKON, merchant.getPersenDiskon());
                pstMerchant.setLong(COL_COA_DISKON_ID, merchant.getCoaDiskonId());
                pstMerchant.setInt(COL_PAYMENT_BY, merchant.getPaymentBy());
                pstMerchant.setLong(COL_PENDAPATAN_MERCHANT, merchant.getPendapatanMerchant());
                pstMerchant.setInt(COL_POSTING_EXPENSE, merchant.getPostingExpense());

                pstMerchant.update();
                return merchant.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMerchant(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbMerchant pstMerchant = new DbMerchant(oid);
            pstMerchant.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMerchant(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_MERCHANT;
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
                Merchant merchant = new Merchant();
                resultToObject(rs, merchant);
                lists.add(merchant);
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

    private static void resultToObject(ResultSet rs, Merchant merchant) {
        try {            
            merchant.setOID(rs.getLong(DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID]));
            merchant.setBankId(rs.getLong(DbMerchant.colNames[DbMerchant.COL_BANK_ID]));
            merchant.setLocationId(rs.getLong(DbMerchant.colNames[DbMerchant.COL_LOCATION_ID]));
            merchant.setCodeMerchant(rs.getString(DbMerchant.colNames[DbMerchant.COL_CODE_MERCHANT]));
            merchant.setPersenExpense(rs.getDouble(DbMerchant.colNames[DbMerchant.COL_PERSEN_EXPENSE]));
            merchant.setDescription(rs.getString(DbMerchant.colNames[DbMerchant.COL_DESCRIPTION]));
            merchant.setCoaId(rs.getLong(DbMerchant.colNames[DbMerchant.COL_COA_ID]));
            merchant.setCoaExpenseId(rs.getLong(DbMerchant.colNames[DbMerchant.COL_COA_EXPENSE_ID]));
            merchant.setTypePayment(rs.getInt(DbMerchant.colNames[DbMerchant.COL_TYPE_PAYMENT]));
            merchant.setPersenDiskon(rs.getDouble(DbMerchant.colNames[DbMerchant.COL_PERSEN_DISKON]));
            merchant.setCoaDiskonId(rs.getLong(DbMerchant.colNames[DbMerchant.COL_COA_DISKON_ID]));
            merchant.setPaymentBy(rs.getInt(DbMerchant.colNames[DbMerchant.COL_PAYMENT_BY]));
            merchant.setPendapatanMerchant(rs.getLong(DbMerchant.colNames[DbMerchant.COL_PENDAPATAN_MERCHANT]));
            merchant.setPostingExpense(rs.getInt(DbMerchant.colNames[DbMerchant.COL_POSTING_EXPENSE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long merchantId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_MERCHANT + " WHERE " +
                    DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID] + " = " + merchantId;

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
            String sql = "SELECT COUNT(" + DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID] + ") FROM " + DB_MERCHANT;
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
                    Merchant merchant = (Merchant) list.get(ls);
                    if (oid == merchant.getOID()) {
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
    
    public static Vector getPaymentMerchant(long locationId,Date start,Date end,String number,int type,int statusPosted) {       
        CONResultSet dbrs = null;
        try{
            
            String sql = "select s."+DbSales.colNames[DbSales.COL_SALES_ID]+" as sales_id," +
                    " s."+DbSales.colNames[DbSales.COL_NUMBER]+" as number," +
                    " s."+DbSales.colNames[DbSales.COL_DATE]+" as date," +
                    " s."+DbSales.colNames[DbSales.COL_POSTED_STATUS]+" as posted_status," +
                    " p."+DbPayment.colNames[DbPayment.COL_PAYMENT_ID]+" as payment_id, "+
                    " p."+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+" as pay_type, "+
                    " p."+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" as merchant_id "+
                    " from "+DbSales.DB_SALES+" s inner join "+DbPayment.DB_PAYMENT+" p on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = p."+DbPayment.colNames[DbPayment.COL_SALES_ID];
            
            String where = " to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") >= to_days('"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"') and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") <= to_days('"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"')";
            
            if(locationId != 0){
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId;
            }
            
            if(type != -1){
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" p."+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+" = "+type;
            }else{
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" p."+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+" in ("+DbPayment.PAY_TYPE_CREDIT_CARD+","+DbPayment.PAY_TYPE_DEBIT_CARD+","+DbPayment.PAY_TYPE_ADIRA+","+DbPayment.PAY_TYPE_FIF+")";
            }
            
            if(number != null && number.length() > 0){
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" s."+DbSales.colNames[DbSales.COL_NUMBER]+" like '%"+type+"%'";
            }
            
            if(statusPosted != -1){                
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" s."+DbSales.colNames[DbSales.COL_POSTED_STATUS]+" = "+statusPosted;
            }            
            
            sql = sql +" where "+where+" order by s."+DbSales.colNames[DbSales.COL_DATE];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();
            
            while (rs.next()) {
                PayMerchant pm = new PayMerchant();
                pm.setSalesId(rs.getLong("sales_id"));
                pm.setNumber(rs.getString("number"));
                pm.setDate(rs.getDate("date"));
                pm.setPostedStatus(rs.getInt("posted_status"));
                pm.setPayType(rs.getInt("pay_type"));
                pm.setMerchantId(rs.getLong("merchant_id"));
                pm.setPaymentId(rs.getLong("payment_id"));
                result.add(pm);
            }
            return result;
            
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    
    public static Vector getPaymentMerchant(long locationId,Date start,Date end,String number,int type,int statusPosted,long bankId) {       
        CONResultSet dbrs = null;
        try{
            
            String sql = "select s."+DbSales.colNames[DbSales.COL_SALES_ID]+" as sales_id," +
                    " s."+DbSales.colNames[DbSales.COL_NUMBER]+" as number," +
                    " s."+DbSales.colNames[DbSales.COL_DATE]+" as date," +
                    " s."+DbSales.colNames[DbSales.COL_POSTED_STATUS]+" as posted_status," +
                    " p."+DbPayment.colNames[DbPayment.COL_PAYMENT_ID]+" as payment_id, "+
                    " p."+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+" as pay_type, "+
                    " p."+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" as merchant_id, "+
                    " p."+DbPayment.colNames[DbPayment.COL_AMOUNT]+" as amount, "+
                    " m."+DbMerchant.colNames[DbMerchant.COL_PERSEN_EXPENSE]+" as exp "+
                    " from "+DbSales.DB_SALES+" s inner join "+DbPayment.DB_PAYMENT+" p on s."+DbSales.colNames[DbSales.COL_SALES_ID]+" = p."+DbPayment.colNames[DbPayment.COL_SALES_ID]+
                    " inner join "+DbMerchant.DB_MERCHANT+" m on p."+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" = m."+DbMerchant.colNames[DbMerchant.COL_MERCHANT_ID];
            
            String where = " to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") >= to_days('"+JSPFormater.formatDate(start,"yyyy-MM-dd")+"') and to_days(s."+DbSales.colNames[DbSales.COL_DATE]+") <= to_days('"+JSPFormater.formatDate(end,"yyyy-MM-dd")+"')";
            
            if(bankId != 0){
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" m."+DbMerchant.colNames[DbMerchant.COL_BANK_ID]+" = "+bankId;
            }
            
            if(locationId != 0){
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" s."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" = "+locationId;
            }
            
            if(type != -1){
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" p."+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+" = "+type;
            }else{
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" p."+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+" in ("+DbPayment.PAY_TYPE_CREDIT_CARD+","+DbPayment.PAY_TYPE_DEBIT_CARD+","+DbPayment.PAY_TYPE_ADIRA+","+DbPayment.PAY_TYPE_FIF+")";
            }
            
            if(number != null && number.length() > 0){
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" s."+DbSales.colNames[DbSales.COL_NUMBER]+" like '%"+type+"%'";
            }
            
            if(statusPosted != -1){                
                if(where != null && where.length() > 0){
                    where = where + " and ";
                }
                where = where +" s."+DbSales.colNames[DbSales.COL_POSTED_STATUS]+" = "+statusPosted;
            }            
            
            sql = sql +" where "+where+" order by s."+DbSales.colNames[DbSales.COL_DATE];
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            Vector result = new Vector();
            
            while (rs.next()) {
                PayMerchant pm = new PayMerchant();
                pm.setSalesId(rs.getLong("sales_id"));
                pm.setNumber(rs.getString("number"));
                pm.setDate(rs.getDate("date"));
                pm.setPostedStatus(rs.getInt("posted_status"));
                pm.setPayType(rs.getInt("pay_type"));
                pm.setMerchantId(rs.getLong("merchant_id"));
                pm.setPaymentId(rs.getLong("payment_id"));
                
                double amount = rs.getDouble("amount");                
                pm.setPersenExp(rs.getDouble("exp"));
                double biaya = pm.getPersenExp()* amount/100;
                double pay = amount - biaya;
                pm.setAmount(pay);
                pm.setBiaya(biaya);
                result.add(pm);
            }
            return result;
            
        }catch(Exception e){}
        finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static long updatePaymentMerchant(long paymentId,long merchantId) {       
        CONResultSet dbrs = null;
        try{
            
            Merchant m = DbMerchant.fetchExc(merchantId);
            int type = -1;
            if(m.getTypePayment() == DbMerchant.TYPE_CREDIT_CARD){
                type = DbPayment.PAY_TYPE_CREDIT_CARD;
            }else if(m.getTypePayment() == DbMerchant.TYPE_DEBIT_CARD){
                type = DbPayment.PAY_TYPE_DEBIT_CARD;
            }
            
            if(type != -1){
                String sql = "update "+DbPayment.DB_PAYMENT+" set "+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" = "+merchantId+","+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+" = "+type+
                    " where "+DbPayment.colNames[DbPayment.COL_PAYMENT_ID]+" = "+paymentId;
                long oid = CONHandler.execUpdate(sql);
                return oid;
            }else{
                String sql = "update "+DbPayment.DB_PAYMENT+" set "+DbPayment.colNames[DbPayment.COL_MERCHANT_ID]+" = "+merchantId+","+DbPayment.colNames[DbPayment.COL_PAY_TYPE]+" = "+type+
                    " where "+DbPayment.colNames[DbPayment.COL_PAYMENT_ID]+" = "+paymentId;
                long oid = CONHandler.execUpdate(sql);
                return oid;
            }
        }catch(Exception e){
        }finally{
            CONResultSet.close(dbrs);
        }
        return 0;
    }
    
}


