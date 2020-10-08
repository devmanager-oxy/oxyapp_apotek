/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.journal;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.*;
import com.project.util.*;
import com.project.system.*;
/**
 *
 * @author Roy
 */
public class DbMemorialKonsinyasiDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final String DB_MEMORIAL_KONSINYASI_DETAIL = "memorial_konsinyasi_detail";
    
    public static final int CL_MEMORIAL_KONSINYASI_DETAIL_ID = 0;
    public static final int CL_MEMORIAL_KONSINYASI_ID = 1;
    public static final int CL_COA_ID = 2;
    public static final int CL_AMOUNT = 3;
    public static final int CL_NOTE = 4;    
    
    public static final String[] colNames = {
        "memorial_konsinyasi_detail_id",
        "memorial_konsinyasi_id",
        "coa_id",
        "amount",
        "note"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_STRING
    };

    public DbMemorialKonsinyasiDetail() {
    }

    public DbMemorialKonsinyasiDetail(int i) throws CONException {
        super(new DbMemorialKonsinyasiDetail());
    }

    public DbMemorialKonsinyasiDetail(String sOid) throws CONException {
        super(new DbMemorialKonsinyasiDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbMemorialKonsinyasiDetail(long lOid) throws CONException {
        super(new DbMemorialKonsinyasiDetail(0));
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
        return DB_MEMORIAL_KONSINYASI_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbMemorialKonsinyasiDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        MemorialKonsinyasiDetail memorialKonsinyasiDetail = fetchExc(ent.getOID());
        ent = (Entity) memorialKonsinyasiDetail;
        return memorialKonsinyasiDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((MemorialKonsinyasiDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((MemorialKonsinyasiDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static MemorialKonsinyasiDetail fetchExc(long oid) throws CONException {
        try {
            MemorialKonsinyasiDetail memorialKonsinyasiDetail = new MemorialKonsinyasiDetail();
            DbMemorialKonsinyasiDetail pstJournal = new DbMemorialKonsinyasiDetail(oid);
            memorialKonsinyasiDetail.setOID(oid);

            memorialKonsinyasiDetail.setMemorialKonsinyasiId(pstJournal.getlong(CL_MEMORIAL_KONSINYASI_ID));
            memorialKonsinyasiDetail.setCoaId(pstJournal.getlong(CL_COA_ID));
            memorialKonsinyasiDetail.setAmount(pstJournal.getdouble(CL_AMOUNT));
            memorialKonsinyasiDetail.setNote(pstJournal.getString(CL_NOTE));

            return memorialKonsinyasiDetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialKonsinyasiDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(MemorialKonsinyasiDetail memorialKonsinyasiDetail) throws CONException {
        try {
            DbMemorialKonsinyasiDetail pstJournal = new DbMemorialKonsinyasiDetail(0);
            pstJournal.setLong(CL_MEMORIAL_KONSINYASI_ID, memorialKonsinyasiDetail.getMemorialKonsinyasiId());
            pstJournal.setLong(CL_COA_ID, memorialKonsinyasiDetail.getCoaId());
            pstJournal.setDouble(CL_AMOUNT, memorialKonsinyasiDetail.getAmount());
            pstJournal.setString(CL_NOTE, memorialKonsinyasiDetail.getNote());
            pstJournal.insert();
            memorialKonsinyasiDetail.setOID(pstJournal.getlong(CL_MEMORIAL_KONSINYASI_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialKonsinyasiDetail(0), CONException.UNKNOWN);
        }
        return memorialKonsinyasiDetail.getOID();
    }

    public static long updateExc(MemorialKonsinyasiDetail memorialKonsinyasiDetail) throws CONException {
        try {
            if (memorialKonsinyasiDetail.getOID() != 0) {
                DbMemorialKonsinyasiDetail pstJournal = new DbMemorialKonsinyasiDetail(memorialKonsinyasiDetail.getOID());
                pstJournal.setLong(CL_MEMORIAL_KONSINYASI_ID, memorialKonsinyasiDetail.getMemorialKonsinyasiId());
                pstJournal.setLong(CL_COA_ID, memorialKonsinyasiDetail.getCoaId());
                pstJournal.setDouble(CL_AMOUNT, memorialKonsinyasiDetail.getAmount());
                pstJournal.setString(CL_NOTE, memorialKonsinyasiDetail.getNote());
                pstJournal.update();
                return memorialKonsinyasiDetail.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialKonsinyasiDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbMemorialKonsinyasiDetail pstJournal = new DbMemorialKonsinyasiDetail(oid);
            pstJournal.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialKonsinyasiDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_MEMORIAL_KONSINYASI_DETAIL;
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
                MemorialKonsinyasiDetail memorialKonsinyasiDetail = new MemorialKonsinyasiDetail();
                resultToObject(rs, memorialKonsinyasiDetail);
                lists.add(memorialKonsinyasiDetail);
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

    private static void resultToObject(ResultSet rs, MemorialKonsinyasiDetail memorialKonsinyasiDetail) {
        try {
            memorialKonsinyasiDetail.setOID(rs.getLong(DbMemorialKonsinyasiDetail.colNames[DbMemorialKonsinyasiDetail.CL_MEMORIAL_KONSINYASI_DETAIL_ID]));
            memorialKonsinyasiDetail.setMemorialKonsinyasiId(rs.getLong(DbMemorialKonsinyasiDetail.colNames[DbMemorialKonsinyasiDetail.CL_MEMORIAL_KONSINYASI_ID]));
            memorialKonsinyasiDetail.setCoaId(rs.getLong(DbMemorialKonsinyasiDetail.colNames[DbMemorialKonsinyasiDetail.CL_COA_ID]));
            memorialKonsinyasiDetail.setAmount(rs.getDouble(DbMemorialKonsinyasiDetail.colNames[DbMemorialKonsinyasiDetail.CL_AMOUNT]));
            memorialKonsinyasiDetail.setNote(rs.getString(DbMemorialKonsinyasiDetail.colNames[DbMemorialKonsinyasiDetail.CL_NOTE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long memorialDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_MEMORIAL_KONSINYASI_DETAIL + " WHERE " +
                    DbMemorialKonsinyasiDetail.colNames[DbMemorialKonsinyasiDetail.CL_MEMORIAL_KONSINYASI_DETAIL_ID] + " = " + memorialDetailId;

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
            String sql = "SELECT COUNT(" + DbMemorialKonsinyasiDetail.colNames[DbMemorialKonsinyasiDetail.CL_MEMORIAL_KONSINYASI_DETAIL_ID] + ") FROM " + DB_MEMORIAL_KONSINYASI_DETAIL;
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
                    MemorialKonsinyasiDetail memorialKonsinyasiDetail = (MemorialKonsinyasiDetail) list.get(ls);
                    if (oid == memorialKonsinyasiDetail.getOID()) {
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
