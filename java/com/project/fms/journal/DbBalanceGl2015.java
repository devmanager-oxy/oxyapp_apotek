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
public class DbBalanceGl2015 extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BALANCE_GL_2015 = "balance_gl_2015";
    
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
    public static final int CL_USER_ID = 17;
    
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
        TYPE_LONG,
    };
    
    public static int TYPE_PNL = 1;

    public DbBalanceGl2015() {
    }

    public DbBalanceGl2015(int i) throws CONException {
        super(new DbBalanceGl2015());
    }

    public DbBalanceGl2015(String sOid) throws CONException {
        super(new DbBalanceGl2015(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBalanceGl2015(long lOid) throws CONException {
        super(new DbBalanceGl2015(0));
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
        return DB_BALANCE_GL_2015;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBalanceGl2015().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BalanceGl2015 balanceGl2015 = fetchExc(ent.getOID());
        ent = (Entity) balanceGl2015;
        return balanceGl2015.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BalanceGl2015) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BalanceGl2015) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BalanceGl2015 fetchExc(long oid) throws CONException {
        try {
            BalanceGl2015 balanceGl2015 = new BalanceGl2015();
            DbBalanceGl2015 pstBalanceGl2015 = new DbBalanceGl2015(oid);
            balanceGl2015.setOID(oid);

            balanceGl2015.setPeriodId(pstBalanceGl2015.getlong(CL_PERIOD_ID));
            balanceGl2015.setAmount(pstBalanceGl2015.getdouble(CL_AMOUNT));
            balanceGl2015.setCoaId(pstBalanceGl2015.getlong(CL_COA_ID));
            balanceGl2015.setCoaLevel1Id(pstBalanceGl2015.getlong(CL_COA_LEVEL_1_ID));
            balanceGl2015.setCoaLevel2Id(pstBalanceGl2015.getlong(CL_COA_LEVEL_2_ID));
            balanceGl2015.setCoaLevel3Id(pstBalanceGl2015.getlong(CL_COA_LEVEL_3_ID));
            balanceGl2015.setCoaLevel4Id(pstBalanceGl2015.getlong(CL_COA_LEVEL_4_ID));
            balanceGl2015.setCoaLevel5Id(pstBalanceGl2015.getlong(CL_COA_LEVEL_5_ID));
            balanceGl2015.setCoaLevel6Id(pstBalanceGl2015.getlong(CL_COA_LEVEL_6_ID));
            balanceGl2015.setCoaLevel7Id(pstBalanceGl2015.getlong(CL_COA_LEVEL_7_ID));
            balanceGl2015.setSegment1Id(pstBalanceGl2015.getlong(CL_SEGMENT_1_ID));
            balanceGl2015.setSegment2Id(pstBalanceGl2015.getlong(CL_SEGMENT_2_ID));
            balanceGl2015.setSegment3Id(pstBalanceGl2015.getlong(CL_SEGMENT_3_ID));
            balanceGl2015.setSegment4Id(pstBalanceGl2015.getlong(CL_SEGMENT_4_ID));
            balanceGl2015.setSegment5Id(pstBalanceGl2015.getlong(CL_SEGMENT_5_ID));
            balanceGl2015.setBalanceType(pstBalanceGl2015.getInt(CL_BALANCE_TYPE));
            balanceGl2015.setUserId(pstBalanceGl2015.getlong(CL_USER_ID));

            return balanceGl2015;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceGl2015(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BalanceGl2015 balanceGl2015) throws CONException {
        try {
            DbBalanceGl2015 pstBalanceGl2015 = new DbBalanceGl2015(0);

            pstBalanceGl2015.setLong(CL_PERIOD_ID, balanceGl2015.getPeriodId());
            pstBalanceGl2015.setDouble(CL_AMOUNT, balanceGl2015.getAmount());
            pstBalanceGl2015.setLong(CL_COA_ID, balanceGl2015.getCoaId());
            pstBalanceGl2015.setLong(CL_COA_LEVEL_1_ID, balanceGl2015.getCoaLevel1Id());
            pstBalanceGl2015.setLong(CL_COA_LEVEL_2_ID, balanceGl2015.getCoaLevel2Id());
            pstBalanceGl2015.setLong(CL_COA_LEVEL_3_ID, balanceGl2015.getCoaLevel3Id());
            pstBalanceGl2015.setLong(CL_COA_LEVEL_4_ID, balanceGl2015.getCoaLevel4Id());
            pstBalanceGl2015.setLong(CL_COA_LEVEL_5_ID, balanceGl2015.getCoaLevel5Id());
            pstBalanceGl2015.setLong(CL_COA_LEVEL_6_ID, balanceGl2015.getCoaLevel6Id());
            pstBalanceGl2015.setLong(CL_COA_LEVEL_7_ID, balanceGl2015.getCoaLevel7Id());
            pstBalanceGl2015.setLong(CL_SEGMENT_1_ID, balanceGl2015.getSegment1Id());
            pstBalanceGl2015.setLong(CL_SEGMENT_2_ID, balanceGl2015.getSegment2Id());
            pstBalanceGl2015.setLong(CL_SEGMENT_3_ID, balanceGl2015.getSegment3Id());
            pstBalanceGl2015.setLong(CL_SEGMENT_4_ID, balanceGl2015.getSegment4Id());
            pstBalanceGl2015.setLong(CL_SEGMENT_5_ID, balanceGl2015.getSegment5Id());
            pstBalanceGl2015.setInt(CL_BALANCE_TYPE, balanceGl2015.getBalanceType());
            pstBalanceGl2015.setLong(CL_USER_ID, balanceGl2015.getUserId());
            
            pstBalanceGl2015.insert();
            balanceGl2015.setOID(pstBalanceGl2015.getlong(CL_BALANCE_GL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceGl2015(0), CONException.UNKNOWN);
        }
        return balanceGl2015.getOID();
    }

    public static long updateExc(BalanceGl2015 balanceGl2015) throws CONException {
        try {
            if (balanceGl2015.getOID() != 0) {
                DbBalanceGl2015 pstBalanceGl2015 = new DbBalanceGl2015(balanceGl2015.getOID());

                pstBalanceGl2015.setLong(CL_PERIOD_ID, balanceGl2015.getPeriodId());
                pstBalanceGl2015.setDouble(CL_AMOUNT, balanceGl2015.getAmount());
                pstBalanceGl2015.setLong(CL_COA_ID, balanceGl2015.getCoaId());
                pstBalanceGl2015.setLong(CL_COA_LEVEL_1_ID, balanceGl2015.getCoaLevel1Id());
                pstBalanceGl2015.setLong(CL_COA_LEVEL_2_ID, balanceGl2015.getCoaLevel2Id());
                pstBalanceGl2015.setLong(CL_COA_LEVEL_3_ID, balanceGl2015.getCoaLevel3Id());
                pstBalanceGl2015.setLong(CL_COA_LEVEL_4_ID, balanceGl2015.getCoaLevel4Id());
                pstBalanceGl2015.setLong(CL_COA_LEVEL_5_ID, balanceGl2015.getCoaLevel5Id());
                pstBalanceGl2015.setLong(CL_COA_LEVEL_6_ID, balanceGl2015.getCoaLevel6Id());
                pstBalanceGl2015.setLong(CL_COA_LEVEL_7_ID, balanceGl2015.getCoaLevel7Id());
                pstBalanceGl2015.setLong(CL_SEGMENT_1_ID, balanceGl2015.getSegment1Id());
                pstBalanceGl2015.setLong(CL_SEGMENT_2_ID, balanceGl2015.getSegment2Id());
                pstBalanceGl2015.setLong(CL_SEGMENT_3_ID, balanceGl2015.getSegment3Id());
                pstBalanceGl2015.setLong(CL_SEGMENT_4_ID, balanceGl2015.getSegment4Id());
                pstBalanceGl2015.setLong(CL_SEGMENT_5_ID, balanceGl2015.getSegment5Id());
                pstBalanceGl2015.setInt(CL_BALANCE_TYPE, balanceGl2015.getBalanceType());
                pstBalanceGl2015.setLong(CL_USER_ID, balanceGl2015.getUserId());

                pstBalanceGl2015.update();
                return balanceGl2015.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceGl2015(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBalanceGl2015 pstBalanceGl2015 = new DbBalanceGl2015(oid);
            pstBalanceGl2015.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceGl2015(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BALANCE_GL_2015;

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
                BalanceGl2015 balanceGl2015 = new BalanceGl2015();
                resultToObject(rs, balanceGl2015);
                lists.add(balanceGl2015);
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

    private static void resultToObject(ResultSet rs, BalanceGl2015 balanceGl2015) {
        try {

            balanceGl2015.setOID(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_BALANCE_GL_ID]));
            balanceGl2015.setPeriodId(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_PERIOD_ID]));
            balanceGl2015.setAmount(rs.getDouble(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_AMOUNT]));
            balanceGl2015.setCoaId(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_COA_ID]));
            balanceGl2015.setCoaLevel1Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_COA_LEVEL_1_ID]));
            balanceGl2015.setCoaLevel2Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_COA_LEVEL_2_ID]));
            balanceGl2015.setCoaLevel3Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_COA_LEVEL_3_ID]));
            balanceGl2015.setCoaLevel4Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_COA_LEVEL_4_ID]));
            balanceGl2015.setCoaLevel5Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_COA_LEVEL_5_ID]));
            balanceGl2015.setCoaLevel6Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_COA_LEVEL_6_ID]));
            balanceGl2015.setCoaLevel7Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_COA_LEVEL_7_ID]));
            balanceGl2015.setCoaLevel7Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_COA_LEVEL_7_ID]));
            balanceGl2015.setSegment1Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_SEGMENT_1_ID]));
            balanceGl2015.setSegment2Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_SEGMENT_2_ID]));
            balanceGl2015.setSegment3Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_SEGMENT_3_ID]));
            balanceGl2015.setSegment4Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_SEGMENT_4_ID]));
            balanceGl2015.setSegment5Id(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_SEGMENT_5_ID]));
            balanceGl2015.setBalanceType(rs.getInt(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_BALANCE_TYPE]));
            balanceGl2015.setUserId(rs.getLong(DbBalanceGl2015.colNames[DbBalanceGl2015.CL_USER_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long balanceGlId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BALANCE_GL_2015 + " WHERE " +
                    DbBalanceGl2015.colNames[DbBalanceGl2015.CL_BALANCE_GL_ID] + " = " + balanceGlId;

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
            String sql = "SELECT COUNT(" + DbBalanceGl2015.colNames[DbBalanceGl2015.CL_BALANCE_GL_ID] + ") FROM " + DB_BALANCE_GL_2015;
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
                    BalanceGl2015 balanceGl2015 = (BalanceGl2015) list.get(ls);
                    if (oid == balanceGl2015.getOID()) {
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
