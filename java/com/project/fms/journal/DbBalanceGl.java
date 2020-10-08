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

/**
 *
 * @author Roy
 */
public class DbBalanceGl extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BALANCE_GL = "balance_gl";
    public static final int CL_BALANCE_GL_ID = 0;
    public static final int CL_PERIOD_ID = 1;
    public static final int CL_AMOUNT = 2;
    public static final int CL_COA_ID = 3;
    public static final int CL_COA_LEVEL_1_ID = 4;
    public static final int CL_COA_LEVEL_2_ID = 5;
    public static final int CL_COA_LEVEL_3_ID = 6;
    public static final int CL_COA_LEVEL_4_ID = 7;
    public static final int CL_COA_LEVEL_5_ID = 8;
    public static final int CL_COA_LEVEL_6_ID = 9;
    public static final int CL_COA_LEVEL_7_ID = 10;
    public static final int CL_SEGMENT_1_ID = 11;
    public static final int CL_SEGMENT_2_ID = 12;
    public static final int CL_SEGMENT_3_ID = 13;
    public static final int CL_SEGMENT_4_ID = 14;
    public static final int CL_SEGMENT_5_ID = 15;
    public static final int CL_BALANCE_TYPE = 16;
    public static final int CL_USER_ID      = 17;
    
    public static final String[] colNames = {
        "balance_gl_id",
        "period_id",
        "amount",
        "coa_id",
        "coa_level_1_id",
        "coa_level_2_id",
        "coa_level_3_id",
        "coa_level_4_id",
        "coa_level_5_id",
        "coa_level_6_id",
        "coa_level_7_id",
        "segment_1_id",
        "segment_2_id",
        "segment_3_id",
        "segment_4_id",
        "segment_5_id",
        "balance_type",
        "user_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG
    };
    
    public static int TYPE_PNL = 1;

    public DbBalanceGl() {
    }

    public DbBalanceGl(int i) throws CONException {
        super(new DbBalanceGl());
    }

    public DbBalanceGl(String sOid) throws CONException {
        super(new DbBalanceGl(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBalanceGl(long lOid) throws CONException {
        super(new DbBalanceGl(0));
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
        return DB_BALANCE_GL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBalanceGl().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BalanceGl balanceGl = fetchExc(ent.getOID());
        ent = (Entity) balanceGl;
        return balanceGl.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BalanceGl) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BalanceGl) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BalanceGl fetchExc(long oid) throws CONException {
        try {
            BalanceGl balanceGl = new BalanceGl();
            DbBalanceGl pstBalanceGl = new DbBalanceGl(oid);
            balanceGl.setOID(oid);

            balanceGl.setPeriodId(pstBalanceGl.getlong(CL_PERIOD_ID));
            balanceGl.setAmount(pstBalanceGl.getdouble(CL_AMOUNT));
            balanceGl.setCoaId(pstBalanceGl.getlong(CL_COA_ID));
            balanceGl.setCoaLevel1Id(pstBalanceGl.getlong(CL_COA_LEVEL_1_ID));
            balanceGl.setCoaLevel2Id(pstBalanceGl.getlong(CL_COA_LEVEL_2_ID));
            balanceGl.setCoaLevel3Id(pstBalanceGl.getlong(CL_COA_LEVEL_3_ID));
            balanceGl.setCoaLevel4Id(pstBalanceGl.getlong(CL_COA_LEVEL_4_ID));
            balanceGl.setCoaLevel5Id(pstBalanceGl.getlong(CL_COA_LEVEL_5_ID));
            balanceGl.setCoaLevel6Id(pstBalanceGl.getlong(CL_COA_LEVEL_6_ID));
            balanceGl.setCoaLevel7Id(pstBalanceGl.getlong(CL_COA_LEVEL_7_ID));
            balanceGl.setSegment1Id(pstBalanceGl.getlong(CL_SEGMENT_1_ID));
            balanceGl.setSegment2Id(pstBalanceGl.getlong(CL_SEGMENT_2_ID));
            balanceGl.setSegment3Id(pstBalanceGl.getlong(CL_SEGMENT_3_ID));
            balanceGl.setSegment4Id(pstBalanceGl.getlong(CL_SEGMENT_4_ID));
            balanceGl.setSegment5Id(pstBalanceGl.getlong(CL_SEGMENT_5_ID));
            balanceGl.setBalanceType(pstBalanceGl.getInt(CL_BALANCE_TYPE));
            balanceGl.setUserId(pstBalanceGl.getlong(CL_USER_ID));
            
            return balanceGl;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceGl(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BalanceGl balanceGl) throws CONException {
        try {
            DbBalanceGl pstBalanceGl = new DbBalanceGl(0);

            pstBalanceGl.setLong(CL_PERIOD_ID, balanceGl.getPeriodId());
            pstBalanceGl.setDouble(CL_AMOUNT, balanceGl.getAmount());
            pstBalanceGl.setLong(CL_COA_ID, balanceGl.getCoaId());
            pstBalanceGl.setLong(CL_COA_LEVEL_1_ID, balanceGl.getCoaLevel1Id());
            pstBalanceGl.setLong(CL_COA_LEVEL_2_ID, balanceGl.getCoaLevel2Id());
            pstBalanceGl.setLong(CL_COA_LEVEL_3_ID, balanceGl.getCoaLevel3Id());
            pstBalanceGl.setLong(CL_COA_LEVEL_4_ID, balanceGl.getCoaLevel4Id());
            pstBalanceGl.setLong(CL_COA_LEVEL_5_ID, balanceGl.getCoaLevel5Id());
            pstBalanceGl.setLong(CL_COA_LEVEL_6_ID, balanceGl.getCoaLevel6Id());
            pstBalanceGl.setLong(CL_COA_LEVEL_7_ID, balanceGl.getCoaLevel7Id());
            pstBalanceGl.setLong(CL_SEGMENT_1_ID, balanceGl.getSegment1Id());
            pstBalanceGl.setLong(CL_SEGMENT_2_ID, balanceGl.getSegment2Id());
            pstBalanceGl.setLong(CL_SEGMENT_3_ID, balanceGl.getSegment3Id());
            pstBalanceGl.setLong(CL_SEGMENT_4_ID, balanceGl.getSegment4Id());
            pstBalanceGl.setLong(CL_SEGMENT_5_ID, balanceGl.getSegment5Id());
            pstBalanceGl.setInt(CL_BALANCE_TYPE, balanceGl.getBalanceType());
            pstBalanceGl.setLong(CL_USER_ID, balanceGl.getUserId());

            pstBalanceGl.insert();
            balanceGl.setOID(pstBalanceGl.getlong(CL_BALANCE_GL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceGl(0), CONException.UNKNOWN);
        }
        return balanceGl.getOID();
    }

    public static long updateExc(BalanceGl balanceGl) throws CONException {
        try {
            if (balanceGl.getOID() != 0) {
                DbBalanceGl pstBalanceGl = new DbBalanceGl(balanceGl.getOID());

                pstBalanceGl.setLong(CL_PERIOD_ID, balanceGl.getPeriodId());
                pstBalanceGl.setDouble(CL_AMOUNT, balanceGl.getAmount());
                pstBalanceGl.setLong(CL_COA_ID, balanceGl.getCoaId());
                pstBalanceGl.setLong(CL_COA_LEVEL_1_ID, balanceGl.getCoaLevel1Id());
                pstBalanceGl.setLong(CL_COA_LEVEL_2_ID, balanceGl.getCoaLevel2Id());
                pstBalanceGl.setLong(CL_COA_LEVEL_3_ID, balanceGl.getCoaLevel3Id());
                pstBalanceGl.setLong(CL_COA_LEVEL_4_ID, balanceGl.getCoaLevel4Id());
                pstBalanceGl.setLong(CL_COA_LEVEL_5_ID, balanceGl.getCoaLevel5Id());
                pstBalanceGl.setLong(CL_COA_LEVEL_6_ID, balanceGl.getCoaLevel6Id());
                pstBalanceGl.setLong(CL_COA_LEVEL_7_ID, balanceGl.getCoaLevel7Id());
                pstBalanceGl.setLong(CL_SEGMENT_1_ID, balanceGl.getSegment1Id());
                pstBalanceGl.setLong(CL_SEGMENT_2_ID, balanceGl.getSegment2Id());
                pstBalanceGl.setLong(CL_SEGMENT_3_ID, balanceGl.getSegment3Id());
                pstBalanceGl.setLong(CL_SEGMENT_4_ID, balanceGl.getSegment4Id());
                pstBalanceGl.setLong(CL_SEGMENT_5_ID, balanceGl.getSegment5Id());
                pstBalanceGl.setInt(CL_BALANCE_TYPE, balanceGl.getBalanceType());
                pstBalanceGl.setLong(CL_USER_ID, balanceGl.getUserId());

                pstBalanceGl.update();
                return balanceGl.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceGl(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBalanceGl pstBalanceGl = new DbBalanceGl(oid);
            pstBalanceGl.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceGl(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BALANCE_GL;

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
                BalanceGl balanceGl = new BalanceGl();
                resultToObject(rs, balanceGl);
                lists.add(balanceGl);
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

    private static void resultToObject(ResultSet rs, BalanceGl balanceGl) {
        try {

            balanceGl.setOID(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_BALANCE_GL_ID]));
            balanceGl.setPeriodId(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_PERIOD_ID]));
            balanceGl.setAmount(rs.getDouble(DbBalanceGl.colNames[DbBalanceGl.CL_AMOUNT]));
            balanceGl.setCoaId(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_COA_ID]));
            balanceGl.setCoaLevel1Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_1_ID]));
            balanceGl.setCoaLevel2Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_2_ID]));
            balanceGl.setCoaLevel3Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_3_ID]));
            balanceGl.setCoaLevel4Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_4_ID]));
            balanceGl.setCoaLevel5Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_5_ID]));
            balanceGl.setCoaLevel6Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_6_ID]));
            balanceGl.setCoaLevel7Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_7_ID]));
            balanceGl.setCoaLevel7Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_COA_LEVEL_7_ID]));
            balanceGl.setSegment1Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_SEGMENT_1_ID]));
            balanceGl.setSegment2Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_SEGMENT_2_ID]));
            balanceGl.setSegment3Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_SEGMENT_3_ID]));
            balanceGl.setSegment4Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_SEGMENT_4_ID]));
            balanceGl.setSegment5Id(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_SEGMENT_5_ID]));
            balanceGl.setBalanceType(rs.getInt(DbBalanceGl.colNames[DbBalanceGl.CL_BALANCE_TYPE]));
            balanceGl.setUserId(rs.getLong(DbBalanceGl.colNames[DbBalanceGl.CL_USER_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long balanceGlId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BALANCE_GL + " WHERE " +
                    DbBalanceGl.colNames[DbBalanceGl.CL_BALANCE_GL_ID] + " = " + balanceGlId;

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
            String sql = "SELECT COUNT(" + DbBalanceGl.colNames[DbBalanceGl.CL_BALANCE_GL_ID] + ") FROM " + DB_BALANCE_GL;
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
                    BalanceGl balanceGl = (BalanceGl) list.get(ls);
                    if (oid == balanceGl.getOID()) {
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
