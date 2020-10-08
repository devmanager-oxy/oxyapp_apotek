/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;


import java.io.*;
import java.sql.*;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;
/**
 *
 * @author Roy
 */
public class DbBgMaster extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_MASTER_BG = "bg_master";
    
    public static final int COL_MASTER_BG_ID = 0;
    public static final int COL_CREATE_DATE = 1;
    public static final int COL_USER_ID = 2;
    public static final int COL_NUMBER = 3;
    public static final int COL_TYPE = 4;
    public static final int COL_COA_ID = 5;
    public static final int COL_REF_ID = 6;    
    public static final int COL_AMOUNT = 7;  
    public static final int COL_DUE_DATE = 8;  
    
    public static final String[] colNames = {
        "master_bg_id",
        "create_date",
        "user_id",
        "number",
        "type",
        "coa_id",
        "ref_id",
        "amount",
        "due_date"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,        
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_DATE
    };
    
    public static final int TYPE_BG = 0;    
    public static final int TYPE_CHECK = 1;
    
    public static final String[] strType = {"BG","Check"};

    public DbBgMaster() {
    }

    public DbBgMaster(int i) throws CONException {
        super(new DbBgMaster());
    }

    public DbBgMaster(String sOid) throws CONException {
        super(new DbBgMaster(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBgMaster(long lOid) throws CONException {
        super(new DbBgMaster(0));
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
        return DB_MASTER_BG;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBgMaster().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BgMaster bgMaster = fetchExc(ent.getOID());
        ent = (Entity) bgMaster;
        return bgMaster.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BgMaster) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BgMaster) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BgMaster fetchExc(long oid) throws CONException {
        try {
            BgMaster bgMaster = new BgMaster();
            DbBgMaster pstBgMaster = new DbBgMaster(oid);
            bgMaster.setOID(oid);

            bgMaster.setCreateDate(pstBgMaster.getDate(COL_CREATE_DATE));
            bgMaster.setUserId(pstBgMaster.getlong(COL_USER_ID));
            bgMaster.setNumber(pstBgMaster.getString(COL_NUMBER));
            bgMaster.setType(pstBgMaster.getInt(COL_TYPE));
            bgMaster.setCoaId(pstBgMaster.getlong(COL_COA_ID));
            bgMaster.setRefId(pstBgMaster.getlong(COL_REF_ID));
            bgMaster.setRefId(pstBgMaster.getlong(COL_REF_ID));
            bgMaster.setAmount(pstBgMaster.getlong(COL_AMOUNT));
            bgMaster.setDueDate(pstBgMaster.getDate(COL_DUE_DATE));
            
            return bgMaster;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBgMaster(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BgMaster bgMaster) throws CONException {
        try {
            DbBgMaster pstBgMaster = new DbBgMaster(0);
            pstBgMaster.setDate(COL_CREATE_DATE, bgMaster.getCreateDate());
            pstBgMaster.setLong(COL_USER_ID, bgMaster.getUserId());
            pstBgMaster.setString(COL_NUMBER, bgMaster.getNumber());
            pstBgMaster.setInt(COL_TYPE, bgMaster.getType());            
            pstBgMaster.setLong(COL_COA_ID, bgMaster.getCoaId());
            pstBgMaster.setLong(COL_REF_ID, bgMaster.getRefId());            
            pstBgMaster.setDouble(COL_AMOUNT, bgMaster.getAmount());  
            pstBgMaster.setDate(COL_DUE_DATE, bgMaster.getDueDate());  
            pstBgMaster.insert();
            bgMaster.setOID(pstBgMaster.getlong(COL_MASTER_BG_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBgMaster(0), CONException.UNKNOWN);
        }
        return bgMaster.getOID();
    }

    public static long updateExc(BgMaster bgMaster) throws CONException {
        try {
            if (bgMaster.getOID() != 0) {
                DbBgMaster pstBgMaster = new DbBgMaster(bgMaster.getOID());
                pstBgMaster.setDate(COL_CREATE_DATE, bgMaster.getCreateDate());
                pstBgMaster.setLong(COL_USER_ID, bgMaster.getUserId());
                pstBgMaster.setString(COL_NUMBER, bgMaster.getNumber());
                pstBgMaster.setInt(COL_TYPE, bgMaster.getType());            
                pstBgMaster.setLong(COL_COA_ID, bgMaster.getCoaId());
                pstBgMaster.setLong(COL_REF_ID, bgMaster.getRefId());            
                pstBgMaster.setDouble(COL_AMOUNT, bgMaster.getAmount());  
                pstBgMaster.setDate(COL_DUE_DATE, bgMaster.getDueDate());  
                pstBgMaster.update();
                return bgMaster.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBgMaster(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBgMaster pstBgMaster = new DbBgMaster(oid);
            pstBgMaster.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBgMaster(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_MASTER_BG;
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
                BgMaster bgMaster = new BgMaster();
                resultToObject(rs, bgMaster);
                lists.add(bgMaster);
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

    private static void resultToObject(ResultSet rs, BgMaster bgMaster) {
        try {
            bgMaster.setOID(rs.getLong(DbBgMaster.colNames[DbBgMaster.COL_MASTER_BG_ID]));            
            bgMaster.setCreateDate(rs.getDate(DbBgMaster.colNames[DbBgMaster.COL_CREATE_DATE]));            
            Date tm = CONHandler.convertDate(rs.getDate(DbBgMaster.colNames[DbBgMaster.COL_CREATE_DATE]), rs.getTime(DbBgMaster.colNames[DbBgMaster.COL_CREATE_DATE]));
            bgMaster.setCreateDate(tm);
            bgMaster.setUserId(rs.getLong(DbBgMaster.colNames[DbBgMaster.COL_USER_ID]));
            bgMaster.setNumber(rs.getString(DbBgMaster.colNames[DbBgMaster.COL_NUMBER]));            
            bgMaster.setType(rs.getInt(DbBgMaster.colNames[DbBgMaster.COL_TYPE]));
            bgMaster.setCoaId(rs.getLong(DbBgMaster.colNames[DbBgMaster.COL_COA_ID]));
            bgMaster.setRefId(rs.getLong(DbBgMaster.colNames[DbBgMaster.COL_REF_ID]));
            bgMaster.setAmount(rs.getDouble(DbBgMaster.colNames[DbBgMaster.COL_AMOUNT]));
            bgMaster.setDueDate(rs.getDate(DbBgMaster.colNames[DbBgMaster.COL_DUE_DATE]));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static boolean checkOID(long masterBgId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_MASTER_BG + " WHERE " +
                    DbBgMaster.colNames[DbBgMaster.COL_MASTER_BG_ID] + " = " + masterBgId;

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
            String sql = "SELECT COUNT(" + DbBgMaster.colNames[DbBgMaster.COL_MASTER_BG_ID] + ") FROM " + DB_MASTER_BG;
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
                    BgMaster bgMaster = (BgMaster) list.get(ls);
                    if (oid == bgMaster.getOID()) {
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
    
    public static long getId(String number,long coaId){
        CONResultSet dbrs = null;
        long oid = 0;
        try {
            String sql = "select " +DbBgMaster.colNames[DbBgMaster.COL_MASTER_BG_ID]+" from "+ DB_MASTER_BG+                    
                    " where "+DbBgMaster.colNames[DbBgMaster.COL_NUMBER]+" = '"+number+"' and "+DbBgMaster.colNames[DbBgMaster.COL_COA_ID]+" = "+coaId;            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                oid = rs.getLong(DbBgMaster.colNames[DbBgMaster.COL_MASTER_BG_ID]);
            }
            
        } catch (Exception e) {
            
        } finally {
            CONResultSet.close(dbrs);
        }
        return oid;
    }
    
    public static void updateRefId(long oid,long refId,Date dueDate,double amount) {
        CONResultSet dbrs = null;
        try {
            String sql = "update " + DB_MASTER_BG+" set "+DbBgMaster.colNames[DbBgMaster.COL_REF_ID]+" = "+refId+","+
                    DbBgMaster.colNames[DbBgMaster.COL_DUE_DATE]+" = '"+JSPFormater.formatDate(dueDate,"yyyy-MM-dd HH:mm:ss")+"',"+
                    DbBgMaster.colNames[DbBgMaster.COL_AMOUNT]+" = '"+JSPFormater.formatNumber(amount,"###.##")+"' "+
                    " where "+DbBgMaster.colNames[DbBgMaster.COL_MASTER_BG_ID]+" = "+oid;            
            CONHandler.execUpdate(sql);
            
        } catch (Exception e) {
            
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static void updateRefIdByNumb(String number,int type,long refId,Date dueDate,double amount) {
        CONResultSet dbrs = null;
        try {
            String sql = "update " + DB_MASTER_BG+" set "+DbBgMaster.colNames[DbBgMaster.COL_REF_ID]+" = "+refId+","+
                    DbBgMaster.colNames[DbBgMaster.COL_DUE_DATE]+" = '"+JSPFormater.formatDate(dueDate,"yyyy-MM-dd HH:mm:ss")+"',"+
                    DbBgMaster.colNames[DbBgMaster.COL_AMOUNT]+" = '"+JSPFormater.formatNumber(amount,"###.##")+"' "+
                    " where "+DbBgMaster.colNames[DbBgMaster.COL_NUMBER]+" = '"+number.trim()+"' and "+DbBgMaster.colNames[DbBgMaster.COL_TYPE]+"="+type;            
            CONHandler.execUpdate(sql);
            
        } catch (Exception e) {
            
        } finally {
            CONResultSet.close(dbrs);
        }
    }
}
