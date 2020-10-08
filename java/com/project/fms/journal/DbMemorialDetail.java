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
public class DbMemorialDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_MEMORIAL_DETAIL = "memorial_detail";
    
    public static final int CL_MEMORIAL_DETAIL_ID = 0;
    public static final int CL_MEMORIAL_ID = 1;
    public static final int CL_COA_ID = 2;
    public static final int CL_AMOUNT = 3;
    public static final int CL_NOTE = 4;    
    
    public static final String[] colNames = {
        "memorial_detail_id",
        "memorial_id",
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

    public DbMemorialDetail() {
    }

    public DbMemorialDetail(int i) throws CONException {
        super(new DbMemorialDetail());
    }

    public DbMemorialDetail(String sOid) throws CONException {
        super(new DbMemorialDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbMemorialDetail(long lOid) throws CONException {
        super(new DbMemorialDetail(0));
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
        return DB_MEMORIAL_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbMemorialDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        MemorialDetail memorialDetail = fetchExc(ent.getOID());
        ent = (Entity) memorialDetail;
        return memorialDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((MemorialDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((MemorialDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static MemorialDetail fetchExc(long oid) throws CONException {
        try {
            MemorialDetail memorialDetail = new MemorialDetail();
            DbMemorialDetail pstJournal = new DbMemorialDetail(oid);
            memorialDetail.setOID(oid);

            memorialDetail.setMemorialId(pstJournal.getlong(CL_MEMORIAL_ID));
            memorialDetail.setCoaId(pstJournal.getlong(CL_COA_ID));
            memorialDetail.setAmount(pstJournal.getdouble(CL_AMOUNT));
            memorialDetail.setNote(pstJournal.getString(CL_NOTE));

            return memorialDetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(MemorialDetail memorialDetail) throws CONException {
        try {
            DbMemorialDetail pstJournal = new DbMemorialDetail(0);
            pstJournal.setLong(CL_MEMORIAL_ID, memorialDetail.getMemorialId());
            pstJournal.setLong(CL_COA_ID, memorialDetail.getCoaId());
            pstJournal.setDouble(CL_AMOUNT, memorialDetail.getAmount());
            pstJournal.setString(CL_NOTE, memorialDetail.getNote());
            pstJournal.insert();
            memorialDetail.setOID(pstJournal.getlong(CL_MEMORIAL_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialDetail(0), CONException.UNKNOWN);
        }
        return memorialDetail.getOID();
    }

    public static long updateExc(MemorialDetail memorialDetail) throws CONException {
        try {
            if (memorialDetail.getOID() != 0) {
                DbMemorialDetail pstJournal = new DbMemorialDetail(memorialDetail.getOID());
                pstJournal.setLong(CL_MEMORIAL_ID, memorialDetail.getMemorialId());
                pstJournal.setLong(CL_COA_ID, memorialDetail.getCoaId());
                pstJournal.setDouble(CL_AMOUNT, memorialDetail.getAmount());
                pstJournal.setString(CL_NOTE, memorialDetail.getNote());
                pstJournal.update();
                return memorialDetail.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbMemorialDetail pstJournal = new DbMemorialDetail(oid);
            pstJournal.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbMemorialDetail(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_MEMORIAL_DETAIL;
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
                MemorialDetail memorialDetail = new MemorialDetail();
                resultToObject(rs, memorialDetail);
                lists.add(memorialDetail);
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

    private static void resultToObject(ResultSet rs, MemorialDetail memorialDetail) {
        try {
            memorialDetail.setOID(rs.getLong(DbMemorialDetail.colNames[DbMemorialDetail.CL_MEMORIAL_DETAIL_ID]));
            memorialDetail.setMemorialId(rs.getLong(DbMemorialDetail.colNames[DbMemorialDetail.CL_MEMORIAL_ID]));
            memorialDetail.setCoaId(rs.getLong(DbMemorialDetail.colNames[DbMemorialDetail.CL_COA_ID]));
            memorialDetail.setAmount(rs.getDouble(DbMemorialDetail.colNames[DbMemorialDetail.CL_AMOUNT]));
            memorialDetail.setNote(rs.getString(DbMemorialDetail.colNames[DbMemorialDetail.CL_NOTE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long memorialDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_MEMORIAL_DETAIL + " WHERE " +
                    DbMemorialDetail.colNames[DbMemorialDetail.CL_MEMORIAL_DETAIL_ID] + " = " + memorialDetailId;

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
            String sql = "SELECT COUNT(" + DbMemorialDetail.colNames[DbMemorialDetail.CL_MEMORIAL_DETAIL_ID] + ") FROM " + DB_MEMORIAL_DETAIL;
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
                    MemorialDetail memorialDetail = (MemorialDetail) list.get(ls);
                    if (oid == memorialDetail.getOID()) {
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
