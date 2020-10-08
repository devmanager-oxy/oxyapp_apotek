/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.journal;

import com.project.fms.master.Periode;
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
public class DbBalanceNeraca extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BALANCE_NERACA = "balance_neraca";
    
    public static final int CL_BALANCE_NERACA_ID = 0;    
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
        "balance_neraca_id",
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
    public static int TYPE_NERACA = 1;

    public DbBalanceNeraca() {
    }

    public DbBalanceNeraca(int i) throws CONException {
        super(new DbBalanceNeraca());
    }

    public DbBalanceNeraca(String sOid) throws CONException {
        super(new DbBalanceNeraca(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBalanceNeraca(long lOid) throws CONException {
        super(new DbBalanceNeraca(0));
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
        return DB_BALANCE_NERACA;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBalanceNeraca().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        BalanceNeraca balanceNeraca = fetchExc(ent.getOID());
        ent = (Entity) balanceNeraca;
        return balanceNeraca.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((BalanceNeraca) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((BalanceNeraca) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static BalanceNeraca fetchExc(long oid) throws CONException {
        try {
            BalanceNeraca balanceNeraca = new BalanceNeraca();
            DbBalanceNeraca pstBalanceNeraca = new DbBalanceNeraca(oid);
            balanceNeraca.setOID(oid);

            balanceNeraca.setPeriodId(pstBalanceNeraca.getlong(CL_PERIOD_ID));
            balanceNeraca.setAmount(pstBalanceNeraca.getdouble(CL_AMOUNT));
            balanceNeraca.setCoaId(pstBalanceNeraca.getlong(CL_COA_ID));
            balanceNeraca.setCoaLevel1Id(pstBalanceNeraca.getlong(CL_COA_LEVEL_1_ID));
            balanceNeraca.setCoaLevel2Id(pstBalanceNeraca.getlong(CL_COA_LEVEL_2_ID));
            balanceNeraca.setCoaLevel3Id(pstBalanceNeraca.getlong(CL_COA_LEVEL_3_ID));
            balanceNeraca.setCoaLevel4Id(pstBalanceNeraca.getlong(CL_COA_LEVEL_4_ID));
            balanceNeraca.setCoaLevel5Id(pstBalanceNeraca.getlong(CL_COA_LEVEL_5_ID));
            balanceNeraca.setCoaLevel6Id(pstBalanceNeraca.getlong(CL_COA_LEVEL_6_ID));
            balanceNeraca.setCoaLevel7Id(pstBalanceNeraca.getlong(CL_COA_LEVEL_7_ID));
            balanceNeraca.setSegment1Id(pstBalanceNeraca.getlong(CL_SEGMENT_1_ID));
            balanceNeraca.setSegment2Id(pstBalanceNeraca.getlong(CL_SEGMENT_2_ID));
            balanceNeraca.setSegment3Id(pstBalanceNeraca.getlong(CL_SEGMENT_3_ID));
            balanceNeraca.setSegment4Id(pstBalanceNeraca.getlong(CL_SEGMENT_4_ID));
            balanceNeraca.setSegment5Id(pstBalanceNeraca.getlong(CL_SEGMENT_5_ID));
            balanceNeraca.setBalanceType(pstBalanceNeraca.getInt(CL_BALANCE_TYPE));
            balanceNeraca.setUserId(pstBalanceNeraca.getlong(CL_USER_ID));

            return balanceNeraca;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceNeraca(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(BalanceNeraca balanceNeraca) throws CONException {
        try {
            DbBalanceNeraca pstBalanceNeraca = new DbBalanceNeraca(0);

            pstBalanceNeraca.setLong(CL_PERIOD_ID, balanceNeraca.getPeriodId());
            pstBalanceNeraca.setDouble(CL_AMOUNT, balanceNeraca.getAmount());
            pstBalanceNeraca.setLong(CL_COA_ID, balanceNeraca.getCoaId());
            pstBalanceNeraca.setLong(CL_COA_LEVEL_1_ID, balanceNeraca.getCoaLevel1Id());
            pstBalanceNeraca.setLong(CL_COA_LEVEL_2_ID, balanceNeraca.getCoaLevel2Id());
            pstBalanceNeraca.setLong(CL_COA_LEVEL_3_ID, balanceNeraca.getCoaLevel3Id());
            pstBalanceNeraca.setLong(CL_COA_LEVEL_4_ID, balanceNeraca.getCoaLevel4Id());
            pstBalanceNeraca.setLong(CL_COA_LEVEL_5_ID, balanceNeraca.getCoaLevel5Id());
            pstBalanceNeraca.setLong(CL_COA_LEVEL_6_ID, balanceNeraca.getCoaLevel6Id());
            pstBalanceNeraca.setLong(CL_COA_LEVEL_7_ID, balanceNeraca.getCoaLevel7Id());
            pstBalanceNeraca.setLong(CL_SEGMENT_1_ID, balanceNeraca.getSegment1Id());
            pstBalanceNeraca.setLong(CL_SEGMENT_2_ID, balanceNeraca.getSegment2Id());
            pstBalanceNeraca.setLong(CL_SEGMENT_3_ID, balanceNeraca.getSegment3Id());
            pstBalanceNeraca.setLong(CL_SEGMENT_4_ID, balanceNeraca.getSegment4Id());
            pstBalanceNeraca.setLong(CL_SEGMENT_5_ID, balanceNeraca.getSegment5Id());
            pstBalanceNeraca.setInt(CL_BALANCE_TYPE, balanceNeraca.getBalanceType());
            pstBalanceNeraca.setLong(CL_USER_ID, balanceNeraca.getUserId());

            pstBalanceNeraca.insert();
            balanceNeraca.setOID(pstBalanceNeraca.getlong(CL_BALANCE_NERACA_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceNeraca(0), CONException.UNKNOWN);
        }
        return balanceNeraca.getOID();
    }

    public static long updateExc(BalanceNeraca balanceNeraca) throws CONException {
        try {
            if (balanceNeraca.getOID() != 0) {
                DbBalanceNeraca pstBalanceNeraca = new DbBalanceNeraca(balanceNeraca.getOID());

                pstBalanceNeraca.setLong(CL_PERIOD_ID, balanceNeraca.getPeriodId());
                pstBalanceNeraca.setDouble(CL_AMOUNT, balanceNeraca.getAmount());
                pstBalanceNeraca.setLong(CL_COA_ID, balanceNeraca.getCoaId());
                pstBalanceNeraca.setLong(CL_COA_LEVEL_1_ID, balanceNeraca.getCoaLevel1Id());
                pstBalanceNeraca.setLong(CL_COA_LEVEL_2_ID, balanceNeraca.getCoaLevel2Id());
                pstBalanceNeraca.setLong(CL_COA_LEVEL_3_ID, balanceNeraca.getCoaLevel3Id());
                pstBalanceNeraca.setLong(CL_COA_LEVEL_4_ID, balanceNeraca.getCoaLevel4Id());
                pstBalanceNeraca.setLong(CL_COA_LEVEL_5_ID, balanceNeraca.getCoaLevel5Id());
                pstBalanceNeraca.setLong(CL_COA_LEVEL_6_ID, balanceNeraca.getCoaLevel6Id());
                pstBalanceNeraca.setLong(CL_COA_LEVEL_7_ID, balanceNeraca.getCoaLevel7Id());
                pstBalanceNeraca.setLong(CL_SEGMENT_1_ID, balanceNeraca.getSegment1Id());
                pstBalanceNeraca.setLong(CL_SEGMENT_2_ID, balanceNeraca.getSegment2Id());
                pstBalanceNeraca.setLong(CL_SEGMENT_3_ID, balanceNeraca.getSegment3Id());
                pstBalanceNeraca.setLong(CL_SEGMENT_4_ID, balanceNeraca.getSegment4Id());
                pstBalanceNeraca.setLong(CL_SEGMENT_5_ID, balanceNeraca.getSegment5Id());
                pstBalanceNeraca.setInt(CL_BALANCE_TYPE, balanceNeraca.getBalanceType());
                pstBalanceNeraca.setLong(CL_USER_ID, balanceNeraca.getUserId());

                pstBalanceNeraca.update();
                return balanceNeraca.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceNeraca(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBalanceNeraca pstBalanceNeraca = new DbBalanceNeraca(oid);
            pstBalanceNeraca.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBalanceNeraca(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BALANCE_NERACA;

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
                BalanceNeraca balanceNeraca = new BalanceNeraca();
                resultToObject(rs, balanceNeraca);
                lists.add(balanceNeraca);
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

    private static void resultToObject(ResultSet rs, BalanceNeraca balanceNeraca) {
        try {

            balanceNeraca.setOID(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_BALANCE_NERACA_ID]));
            balanceNeraca.setPeriodId(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_PERIOD_ID]));
            balanceNeraca.setAmount(rs.getDouble(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_AMOUNT]));
            balanceNeraca.setCoaId(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_ID]));
            balanceNeraca.setCoaLevel1Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_1_ID]));
            balanceNeraca.setCoaLevel2Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_2_ID]));
            balanceNeraca.setCoaLevel3Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_3_ID]));
            balanceNeraca.setCoaLevel4Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_4_ID]));
            balanceNeraca.setCoaLevel5Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_5_ID]));
            balanceNeraca.setCoaLevel6Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_6_ID]));
            balanceNeraca.setCoaLevel7Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_7_ID]));
            balanceNeraca.setCoaLevel7Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_COA_LEVEL_7_ID]));
            balanceNeraca.setSegment1Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_SEGMENT_1_ID]));
            balanceNeraca.setSegment2Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_SEGMENT_2_ID]));
            balanceNeraca.setSegment3Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_SEGMENT_3_ID]));
            balanceNeraca.setSegment4Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_SEGMENT_4_ID]));
            balanceNeraca.setSegment5Id(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_SEGMENT_5_ID]));
            balanceNeraca.setBalanceType(rs.getInt(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_BALANCE_TYPE]));
            balanceNeraca.setUserId(rs.getLong(DbBalanceNeraca.colNames[DbBalanceNeraca.CL_USER_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long balanceNeracaId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BALANCE_NERACA + " WHERE " +
                    DbBalanceNeraca.colNames[DbBalanceNeraca.CL_BALANCE_NERACA_ID] + " = " + balanceNeracaId;

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
            String sql = "SELECT COUNT(" + DbBalanceNeraca.colNames[DbBalanceNeraca.CL_BALANCE_NERACA_ID] + ") FROM " + DB_BALANCE_NERACA;
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
                    BalanceNeraca balanceNeraca = (BalanceNeraca) list.get(ls);
                    if (oid == balanceNeraca.getOID()) {
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
    
    public static void clearGenerate(long segment1Id, Periode p){
        CONResultSet dbrs = null;
        try{
            String sql = "delete from "+DB_BALANCE_NERACA+" where period_id="+p.getOID()+" and "+DbBalanceNeraca.colNames[DbBalanceNeraca.CL_BALANCE_TYPE]+" = "+DbBalanceNeraca.TYPE_NERACA;
            
            if(segment1Id != 0){
                sql = sql + " and segment_1_id="+segment1Id;
            }
            CONHandler.execUpdate(sql);
            
        }catch(Exception e){}        
        finally {
            CONResultSet.close(dbrs);
        }
        
    }
}
