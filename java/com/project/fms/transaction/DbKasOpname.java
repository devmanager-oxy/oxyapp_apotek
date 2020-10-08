/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.transaction;

/* package java */
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;


import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.fms.master.*;
import com.project.*;
import com.project.util.*;
import com.project.util.lang.*;

/**
 *
 * @author Roy Andika
 */
public class DbKasOpname extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_KAS_OPNAME = "kas_opname";
    public static final int COL_KAS_OPNAME_ID = 0;
    public static final int COL_CURRENCY_ID = 1;
    public static final int COL_AMOUNT = 2;
    public static final int COL_QTY = 3;
    public static final int COL_TYPE = 4;
    public static final int COL_MEMO = 5;
    public static final int COL_DATE_TRANSACTION = 6;
    
    public static final String[] colNames = {
        "kas_opname_id",
        "currency_id",
        "amount",
        "qty",
        "type",
        "memo",
        "date_transaction"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_DATE
    };
    
    public static int TYPE_NON_CHECK = 0;
    public static int TYPE_CHECK = 1;
    
    public static final String[] satMoney = {
        "Uang",
        "Dollars"
    };
    
    public static final String[] satCurrency = {
        "Rp.",
        "US $"
    };
    
    public static final String[] satQty = {
        "lembar",
        "/kurs"
    };
    
    public static final double[] valueRp = {
        100000,
        50000,
        20000,
        10000,
        5000,
        2000,
        1000,
        500,
        100,
        50        
    };
    

    public DbKasOpname() {
    }

    public DbKasOpname(int i) throws CONException {
        super(new DbKasOpname());
    }

    public DbKasOpname(String sOid) throws CONException {
        super(new DbKasOpname(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbKasOpname(long lOid) throws CONException {
        super(new DbKasOpname(0));
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
        return DB_KAS_OPNAME;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbKasOpname().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        KasOpname kasOpname = fetchExc(ent.getOID());
        ent = (Entity) kasOpname;
        return kasOpname.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((KasOpname) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((KasOpname) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static KasOpname fetchExc(long oid) throws CONException {
        try {
            KasOpname kasOpname = new KasOpname();
            DbKasOpname DbKasOpname = new DbKasOpname(oid);

            kasOpname.setOID(oid);

            kasOpname.setCurrencyId(DbKasOpname.getlong(COL_CURRENCY_ID));
            kasOpname.setAmount(DbKasOpname.getdouble(COL_AMOUNT));
            kasOpname.setQty(DbKasOpname.getInt(COL_QTY));
            kasOpname.setType(DbKasOpname.getInt(COL_TYPE));
            kasOpname.setMemo(DbKasOpname.getString(COL_MEMO));
            kasOpname.setDateTransaction(DbKasOpname.getDate(COL_DATE_TRANSACTION));

            return kasOpname;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbKasOpname(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(KasOpname kasOpname) throws CONException {
        try {
            DbKasOpname DbKasOpname = new DbKasOpname(0);

            DbKasOpname.setLong(COL_CURRENCY_ID, kasOpname.getCurrencyId());
            DbKasOpname.setDouble(COL_AMOUNT, kasOpname.getAmount());
            DbKasOpname.setInt(COL_QTY, kasOpname.getQty());
            DbKasOpname.setInt(COL_TYPE, kasOpname.getType());
            DbKasOpname.setString(COL_MEMO, kasOpname.getMemo());
            DbKasOpname.setDate(COL_DATE_TRANSACTION, kasOpname.getDateTransaction());

            DbKasOpname.insert();
            kasOpname.setOID(DbKasOpname.getlong(COL_CURRENCY_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbKasOpname(0), CONException.UNKNOWN);
        }
        return kasOpname.getOID();
    }

    public static long updateExc(KasOpname kasOpname) throws CONException {
        try {
            if (kasOpname.getOID() != 0) {
                
                DbKasOpname DbKasOpname = new DbKasOpname(kasOpname.getOID());
                
                DbKasOpname.setLong(COL_CURRENCY_ID, kasOpname.getCurrencyId());
                DbKasOpname.setDouble(COL_AMOUNT, kasOpname.getAmount());
                DbKasOpname.setInt(COL_QTY, kasOpname.getQty());
                DbKasOpname.setInt(COL_TYPE, kasOpname.getType());
                DbKasOpname.setString(COL_MEMO, kasOpname.getMemo());
                DbKasOpname.setDate(COL_DATE_TRANSACTION, kasOpname.getDateTransaction());

                DbKasOpname.update();
                return kasOpname.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbKasOpname(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbKasOpname DbKasOpname = new DbKasOpname(oid);
            DbKasOpname.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbKasOpname(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_KAS_OPNAME;
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
                KasOpname kasOpname = new KasOpname();
                resultToObject(rs, kasOpname);
                lists.add(kasOpname);
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

    private static void resultToObject(ResultSet rs, KasOpname kasOpname) {
        try {
            
            kasOpname.setOID(rs.getLong(DbKasOpname.colNames[DbKasOpname.COL_KAS_OPNAME_ID]));
            kasOpname.setAmount(rs.getDouble(DbKasOpname.colNames[DbKasOpname.COL_AMOUNT]));
            kasOpname.setQty(rs.getInt(DbKasOpname.colNames[DbKasOpname.COL_QTY]));
            kasOpname.setType(rs.getInt(DbKasOpname.colNames[DbKasOpname.COL_TYPE]));
            kasOpname.setMemo(rs.getString(DbKasOpname.colNames[DbKasOpname.COL_MEMO]));
            kasOpname.setDateTransaction(rs.getDate(DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION]));
            kasOpname.setCurrencyId(rs.getLong(DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID]));

        } catch (Exception e) {}
        
    }

    public static boolean checkOID(long kasOpnameId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_KAS_OPNAME + " WHERE " +
                    DbKasOpname.colNames[DbKasOpname.COL_KAS_OPNAME_ID] + " = " + kasOpnameId;

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
            String sql = "SELECT COUNT(" + DbKasOpname.colNames[DbKasOpname.COL_KAS_OPNAME_ID] + ") FROM " + DB_KAS_OPNAME;
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
                    KasOpname kasOpname = (KasOpname) list.get(ls);
                    if (oid == kasOpname.getOID()) {
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
    
    public static Vector listAmount(String whereClause, String order) {
        
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_KAS_OPNAME;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                KasOpname kasOpname = new KasOpname();
                resultToObject(rs, kasOpname);
                lists.add(kasOpname);
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
    
    public static Vector groupRp(Date dtTransaction){
        
        CONResultSet dbrs = null;
        
        try{
            
            String sql = "SELECT "+DbKasOpname.colNames[DbKasOpname.COL_AMOUNT]+" FROM "+DbKasOpname.DB_KAS_OPNAME+
                    " WHERE "+DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION]+" = '"+JSPFormater.formatDate(dtTransaction, "yyyy-MM-dd")+"' "+   
                    " ORDER BY "+DbKasOpname.colNames[DbKasOpname.COL_AMOUNT]+" DESC ";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            Vector result = new Vector();
            
            while(rs.next()){
                double amount = rs.getDouble(1);
                result.add(""+amount);
            }
            
            return result;
            
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        
        return null;
    }
    
    public static Vector groupRp(Vector vKasOpname){
        
        if(vKasOpname != null && vKasOpname.size() > 0){
            Vector result = new Vector();
            for(int i = 0 ; i < vKasOpname.size() ; i++){
                
                KasOpname kasOpname = (KasOpname)vKasOpname.get(i);
                result.add(""+kasOpname.getAmount());
            
            }
            return result;
        }
        return null;
    }
    
    
    public static Date transactionDate(Date dateInput){
        
        CONResultSet dbrs = null;
        
        try{
            
            //select max(date_transaction) from kas_opname where date_transaction < '2011-12-14';
            String sql = "SELECT MAX("+DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION]+") FROM "+DbKasOpname.DB_KAS_OPNAME+" WHERE "+
                    DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION]+" < '"+JSPFormater.formatDate(dateInput,"yyyy-MM-dd")+"'";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()){
                Date dtTrans = rs.getDate(1);
                return dtTrans;
            }
                    
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(dbrs);
        }
        
        return null;
        
    }
    
    public static Vector listPeriodeNotExist(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_KAS_OPNAME;
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
                
                KasOpname kasOpname = new KasOpname();
                kasOpname.setAmount(rs.getDouble(DbKasOpname.colNames[DbKasOpname.COL_AMOUNT]));
                kasOpname.setQty(rs.getInt(DbKasOpname.colNames[DbKasOpname.COL_QTY]));
                kasOpname.setType(rs.getInt(DbKasOpname.colNames[DbKasOpname.COL_TYPE]));
                kasOpname.setMemo(rs.getString(DbKasOpname.colNames[DbKasOpname.COL_MEMO]));
                kasOpname.setDateTransaction(rs.getDate(DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION]));
                kasOpname.setCurrencyId(rs.getLong(DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID]));
                
                lists.add(kasOpname);
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
    
}