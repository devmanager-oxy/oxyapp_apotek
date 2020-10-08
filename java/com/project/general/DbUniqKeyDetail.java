/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
/**
 *
 * @author Roy
 */
public class DbUniqKeyDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_UNIQ_KEY_DETAIL = "uniq_key_detail";
    
    public static final int COL_UNIQ_KEY_DETAIL_ID = 0;
    public static final int COL_UNIQ_KEY_ID = 1;
    public static final int COL_UNIQ_DETAIL_ID = 2;
    
    public static final String[] colNames = {
        "uniq_key_detail_id",
        "uniq_key_id",
        "uniq_detail_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbUniqKeyDetail() {
    }

    public DbUniqKeyDetail(int i) throws CONException {
        super(new DbUniqKeyDetail());
    }

    public DbUniqKeyDetail(String sOid) throws CONException {
        super(new DbUniqKeyDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbUniqKeyDetail(long lOid) throws CONException {
        super(new DbUniqKeyDetail(0));
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
        return DB_UNIQ_KEY_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbUniqKeyDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        UniqKeyDetail uniqKeyDetail = fetchExc(ent.getOID());
        ent = (Entity) uniqKeyDetail;
        return uniqKeyDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((UniqKeyDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((UniqKeyDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static UniqKeyDetail fetchExc(long oid) throws CONException {
        try {
            UniqKeyDetail uniqKeyDetail = new UniqKeyDetail();
            DbUniqKeyDetail pstUniqKeyDetail = new DbUniqKeyDetail(oid);
            uniqKeyDetail.setOID(oid);
            uniqKeyDetail.setUniqKeyId(pstUniqKeyDetail.getlong(COL_UNIQ_KEY_ID));
            uniqKeyDetail.setUniqDetailId(pstUniqKeyDetail.getlong(COL_UNIQ_DETAIL_ID));
            return uniqKeyDetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUniqKeyDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(UniqKeyDetail uniqKeyDetail) throws CONException {
        try {
            DbUniqKeyDetail pstUniqKeyDetail = new DbUniqKeyDetail(0);
            pstUniqKeyDetail.setLong(COL_UNIQ_KEY_ID, uniqKeyDetail.getUniqKeyId());            
            pstUniqKeyDetail.setLong(COL_UNIQ_DETAIL_ID, uniqKeyDetail.getUniqDetailId());          
            pstUniqKeyDetail.insert();
            uniqKeyDetail.setOID(pstUniqKeyDetail.getlong(COL_UNIQ_KEY_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUniqKeyDetail(0), CONException.UNKNOWN);
        }
        return uniqKeyDetail.getOID();
    }

    public static long updateExc(UniqKeyDetail uniqKeyDetail) throws CONException {
        try {
            if (uniqKeyDetail.getOID() != 0) {
                DbUniqKeyDetail pstUniqKeyDetail = new DbUniqKeyDetail(uniqKeyDetail.getOID());
                pstUniqKeyDetail.setLong(COL_UNIQ_KEY_ID, uniqKeyDetail.getUniqKeyId());      
                pstUniqKeyDetail.setLong(COL_UNIQ_DETAIL_ID, uniqKeyDetail.getUniqDetailId());  
                pstUniqKeyDetail.update();
                return uniqKeyDetail.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUniqKeyDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbUniqKeyDetail pstUniqKeyDetail = new DbUniqKeyDetail(oid);
            pstUniqKeyDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUniqKeyDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_UNIQ_KEY_DETAIL;
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
                UniqKeyDetail uniqKeyDetail = new UniqKeyDetail();
                resultToObject(rs, uniqKeyDetail);
                lists.add(uniqKeyDetail);
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

    private static void resultToObject(ResultSet rs, UniqKeyDetail uniqKeyDetail) {
        try {
            uniqKeyDetail.setOID(rs.getLong(DbUniqKeyDetail.colNames[DbUniqKeyDetail.COL_UNIQ_KEY_DETAIL_ID]));
            uniqKeyDetail.setUniqKeyId(rs.getLong(DbUniqKeyDetail.colNames[DbUniqKeyDetail.COL_UNIQ_KEY_ID]));
            uniqKeyDetail.setUniqDetailId(rs.getLong(DbUniqKeyDetail.colNames[DbUniqKeyDetail.COL_UNIQ_DETAIL_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long uniqKeyDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_UNIQ_KEY_DETAIL + " WHERE " +
                    DbUniqKeyDetail.colNames[DbUniqKeyDetail.COL_UNIQ_KEY_DETAIL_ID] + " = " + uniqKeyDetailId;

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
            String sql = "SELECT COUNT(" + DbUniqKeyDetail.colNames[DbUniqKeyDetail.COL_UNIQ_KEY_DETAIL_ID] + ") FROM " + DB_UNIQ_KEY_DETAIL;
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
                    UniqKeyDetail uniqKeyDetail = (UniqKeyDetail) list.get(ls);
                    if (oid == uniqKeyDetail.getOID()) {
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
