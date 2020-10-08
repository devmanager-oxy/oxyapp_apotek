/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.master;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.util.*;
import com.project.system.*;

/**
 *
 * @author Roy Andika
 */
public class DbCoaOpeningBalanceLocation extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_COA_OPENING_BALANCE_LOCATION = "coa_opening_balance_location";
    
    public static final int FLD_COA_OPENING_BALANCE_LOCATION_ID = 0;
    public static final int FLD_COA_ID = 1;
    public static final int FLD_PERIODE_ID = 2;
    public static final int FLD_OPENING_BALANCE = 3;
    public static final int FLD_SEGMENT1_ID = 4;    
    public static final int FLD_COA_LEVEL1_ID = 5;
    public static final int FLD_COA_LEVEL2_ID = 6;
    public static final int FLD_COA_LEVEL3_ID = 7;
    public static final int FLD_COA_LEVEL4_ID = 8;
    public static final int FLD_COA_LEVEL5_ID = 9;
    public static final int FLD_COA_LEVEL6_ID = 10;
    public static final int FLD_COA_LEVEL7_ID = 11;
    
    public static final String[] colNames = {
        "coa_opening_balance_location_id",
        "coa_id",
        "periode_id",
        "opening_balance",
        "segment1_id",
        "coa_level1_id",
        "coa_level2_id",
        "coa_level3_id",
        "coa_level4_id",
        "coa_level5_id",
        "coa_level6_id",
        "coa_level7_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbCoaOpeningBalanceLocation() {
    }

    public DbCoaOpeningBalanceLocation(int i) throws CONException {
        super(new DbCoaOpeningBalanceLocation());
    }

    public DbCoaOpeningBalanceLocation(String sOid) throws CONException {
        super(new DbCoaOpeningBalanceLocation(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCoaOpeningBalanceLocation(long lOid) throws CONException {
        super(new DbCoaOpeningBalanceLocation(0));
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
        return DB_COA_OPENING_BALANCE_LOCATION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCoaOpeningBalanceLocation().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CoaOpeningBalanceLocation coaopeningbalancelocation = fetchExc(ent.getOID());
        ent = (Entity) coaopeningbalancelocation;
        return coaopeningbalancelocation.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CoaOpeningBalanceLocation) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CoaOpeningBalanceLocation) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CoaOpeningBalanceLocation fetchExc(long oid) throws CONException {
        try {
            CoaOpeningBalanceLocation coaopeningbalancelocation = new CoaOpeningBalanceLocation();
            DbCoaOpeningBalanceLocation pstCoaOpeningBalance = new DbCoaOpeningBalanceLocation(oid);
            coaopeningbalancelocation.setOID(oid);
            coaopeningbalancelocation.setCoaId(pstCoaOpeningBalance.getlong(FLD_COA_ID));
            coaopeningbalancelocation.setPeriodeId(pstCoaOpeningBalance.getlong(FLD_PERIODE_ID));
            coaopeningbalancelocation.setOpeningBalance(pstCoaOpeningBalance.getdouble(FLD_OPENING_BALANCE));
            coaopeningbalancelocation.setSegment1Id(pstCoaOpeningBalance.getlong(FLD_SEGMENT1_ID));
            
            coaopeningbalancelocation.setCoaLevel1Id(pstCoaOpeningBalance.getlong(FLD_COA_LEVEL1_ID));
            coaopeningbalancelocation.setCoaLevel2Id(pstCoaOpeningBalance.getlong(FLD_COA_LEVEL2_ID));
            coaopeningbalancelocation.setCoaLevel3Id(pstCoaOpeningBalance.getlong(FLD_COA_LEVEL3_ID));
            coaopeningbalancelocation.setCoaLevel4Id(pstCoaOpeningBalance.getlong(FLD_COA_LEVEL4_ID));
            coaopeningbalancelocation.setCoaLevel5Id(pstCoaOpeningBalance.getlong(FLD_COA_LEVEL5_ID));
            coaopeningbalancelocation.setCoaLevel6Id(pstCoaOpeningBalance.getlong(FLD_COA_LEVEL6_ID));
            coaopeningbalancelocation.setCoaLevel7Id(pstCoaOpeningBalance.getlong(FLD_COA_LEVEL7_ID));
            
            return coaopeningbalancelocation;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoaOpeningBalanceLocation(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(CoaOpeningBalanceLocation coaopeningbalancelocation) throws CONException {
        try {
            DbCoaOpeningBalanceLocation pstCoaOpeningBalance = new DbCoaOpeningBalanceLocation(0);

            pstCoaOpeningBalance.setLong(FLD_COA_ID, coaopeningbalancelocation.getCoaId());
            pstCoaOpeningBalance.setLong(FLD_PERIODE_ID, coaopeningbalancelocation.getPeriodeId());
            pstCoaOpeningBalance.setDouble(FLD_OPENING_BALANCE, coaopeningbalancelocation.getOpeningBalance());
            pstCoaOpeningBalance.setLong(FLD_SEGMENT1_ID, coaopeningbalancelocation.getSegment1Id());
            
            pstCoaOpeningBalance.setLong(FLD_COA_LEVEL1_ID, coaopeningbalancelocation.getCoaLevel1Id());
            pstCoaOpeningBalance.setLong(FLD_COA_LEVEL2_ID, coaopeningbalancelocation.getCoaLevel2Id());
            pstCoaOpeningBalance.setLong(FLD_COA_LEVEL3_ID, coaopeningbalancelocation.getCoaLevel3Id());
            pstCoaOpeningBalance.setLong(FLD_COA_LEVEL4_ID, coaopeningbalancelocation.getCoaLevel4Id());
            pstCoaOpeningBalance.setLong(FLD_COA_LEVEL5_ID, coaopeningbalancelocation.getCoaLevel5Id());
            pstCoaOpeningBalance.setLong(FLD_COA_LEVEL6_ID, coaopeningbalancelocation.getCoaLevel6Id());
            pstCoaOpeningBalance.setLong(FLD_COA_LEVEL7_ID, coaopeningbalancelocation.getCoaLevel7Id());

            pstCoaOpeningBalance.insert();
            coaopeningbalancelocation.setOID(pstCoaOpeningBalance.getlong(FLD_COA_OPENING_BALANCE_LOCATION_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoaOpeningBalanceLocation(0), CONException.UNKNOWN);
        }
        return coaopeningbalancelocation.getOID();
    }

    public static long updateExc(CoaOpeningBalanceLocation coaopeningbalancelocation) throws CONException {
        try {
            if (coaopeningbalancelocation.getOID() != 0) {
                DbCoaOpeningBalanceLocation pstCoaOpeningBalance = new DbCoaOpeningBalanceLocation(coaopeningbalancelocation.getOID());

                pstCoaOpeningBalance.setLong(FLD_COA_ID, coaopeningbalancelocation.getCoaId());
                pstCoaOpeningBalance.setLong(FLD_PERIODE_ID, coaopeningbalancelocation.getPeriodeId());
                pstCoaOpeningBalance.setDouble(FLD_OPENING_BALANCE, coaopeningbalancelocation.getOpeningBalance());
                pstCoaOpeningBalance.setLong(FLD_SEGMENT1_ID, coaopeningbalancelocation.getSegment1Id());
                pstCoaOpeningBalance.setLong(FLD_COA_LEVEL1_ID, coaopeningbalancelocation.getCoaLevel1Id());
                pstCoaOpeningBalance.setLong(FLD_COA_LEVEL2_ID, coaopeningbalancelocation.getCoaLevel2Id());
                pstCoaOpeningBalance.setLong(FLD_COA_LEVEL3_ID, coaopeningbalancelocation.getCoaLevel3Id());
                pstCoaOpeningBalance.setLong(FLD_COA_LEVEL4_ID, coaopeningbalancelocation.getCoaLevel4Id());
                pstCoaOpeningBalance.setLong(FLD_COA_LEVEL5_ID, coaopeningbalancelocation.getCoaLevel5Id());
                pstCoaOpeningBalance.setLong(FLD_COA_LEVEL6_ID, coaopeningbalancelocation.getCoaLevel6Id());
                pstCoaOpeningBalance.setLong(FLD_COA_LEVEL7_ID, coaopeningbalancelocation.getCoaLevel7Id());
                pstCoaOpeningBalance.update();
                return coaopeningbalancelocation.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoaOpeningBalanceLocation(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCoaOpeningBalanceLocation pstCoaOpeningBalance = new DbCoaOpeningBalanceLocation(oid);
            pstCoaOpeningBalance.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoaOpeningBalanceLocation(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_COA_OPENING_BALANCE_LOCATION;
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
                CoaOpeningBalanceLocation coaopeningbalancelocation = new CoaOpeningBalanceLocation();
                resultToObject(rs, coaopeningbalancelocation);
                lists.add(coaopeningbalancelocation);
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

    private static void resultToObject(ResultSet rs, CoaOpeningBalanceLocation coaopeningbalancelocation) {
        try {
            coaopeningbalancelocation.setOID(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_OPENING_BALANCE_LOCATION_ID]));
            coaopeningbalancelocation.setCoaId(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_ID]));
            coaopeningbalancelocation.setPeriodeId(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_PERIODE_ID]));
            coaopeningbalancelocation.setOpeningBalance(rs.getDouble(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_OPENING_BALANCE]));
            coaopeningbalancelocation.setSegment1Id(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_SEGMENT1_ID]));
            coaopeningbalancelocation.setCoaLevel1Id(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_LEVEL1_ID]));
            coaopeningbalancelocation.setCoaLevel2Id(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_LEVEL2_ID]));
            coaopeningbalancelocation.setCoaLevel3Id(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_LEVEL3_ID]));
            coaopeningbalancelocation.setCoaLevel4Id(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_LEVEL4_ID]));
            coaopeningbalancelocation.setCoaLevel5Id(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_LEVEL5_ID]));
            coaopeningbalancelocation.setCoaLevel6Id(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_LEVEL6_ID]));
            coaopeningbalancelocation.setCoaLevel7Id(rs.getLong(DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_LEVEL7_ID]));            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long coaOpeningBalanceId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_COA_OPENING_BALANCE_LOCATION + " WHERE " +
                    DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_OPENING_BALANCE_LOCATION_ID] + " = " + coaOpeningBalanceId;

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
            String sql = "SELECT COUNT(" + DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_OPENING_BALANCE_LOCATION_ID] + ") FROM " + DB_COA_OPENING_BALANCE_LOCATION;
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
                    CoaOpeningBalanceLocation coaopeningbalancelocation = (CoaOpeningBalanceLocation) list.get(ls);
                    if (oid == coaopeningbalancelocation.getOID()) {
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

    //ambil opening balance dari coa pada periode tertentu, retur double
    public static double getOpeningBalanceLastYear(Periode openPeriod, long coaId) {

        Periode pLastYear = new Periode();

        try {

            if (openPeriod.getOID() != 0) {

                if (openPeriod.getStartDate() != null) {

                    int previousYear = openPeriod.getStartDate().getYear() + 1900 - 1;
                    int month = openPeriod.getStartDate().getMonth() + 1;
                    int date = openPeriod.getStartDate().getDate();
                    String strPreviousYear = "" + previousYear + "-" + month + "-" + date;

                    String wherePreviousperiod = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " = '" + strPreviousYear + "'";

                    Vector listPrevPeriode = DbPeriode.list(0, 0, wherePreviousperiod, null);

                    if (listPrevPeriode != null && listPrevPeriode.size() > 0) {
                        pLastYear = (Periode) listPrevPeriode.get(0);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        Vector v = list(0, 0, "periode_id=" + pLastYear.getOID() + " and coa_id=" + coaId, "");
        if (v != null && v.size() > 0) {
            CoaOpeningBalanceLocation cob = (CoaOpeningBalanceLocation) v.get(0);
            return cob.getOpeningBalance();
        }
        return 0;
    }

    //ambil opening balance dari coa pada periode tertentu, retur double
    public static double getOpeningBalance(Periode openPeriod, long coaId) {        
        Vector v = list(0, 0, "periode_id=" + openPeriod.getOID() + " and coa_id=" + coaId, "");        
        if (v != null && v.size() > 0) {
            CoaOpeningBalanceLocation cob = (CoaOpeningBalanceLocation) v.get(0);
            return cob.getOpeningBalance();
        }
        return 0;        
    }

    //ambil opening balance dari coa pada periode tertentu, retur double
    public static double getOpeningBalanceByHeader(Periode openPeriod, long coaId) {

        double result = 0;
        Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coaId, "");
        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);
                if (coa.getStatus().equals("HEADER")) {
                    result = result + getOpeningBalanceByHeader(openPeriod, coa.getOID());
                } else {
                    result = result + getOpeningBalance(openPeriod, coa.getOID());
                }
            }
        }

        return result;

    }

    public static double getOpeningBalanceByHeader(Periode openPeriod, long coaId, int accClass) {

        double result = 0;
        Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coaId, "");
        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);
                if (coa.getStatus().equals("HEADER")) {
                    result = result + getOpeningBalanceByHeader(openPeriod, coa.getOID());
                } else {

                    boolean ok = false;

                    if (accClass == DbCoa.ACCOUNT_CLASS_SP) {
                        if (coa.getAccountClass() == accClass) {
                            ok = true;
                        }
                    } else {
                        if (coa.getAccountClass() != DbCoa.ACCOUNT_CLASS_SP) {
                            ok = true;
                        }
                    }

                    if (ok) {
                        result = result + getOpeningBalance(openPeriod, coa.getOID());
                    }
                }
            }
        }

        return result;

    }

    //ambil opening balance dari coa pada periode tertentu, retur double
    public static double getOpeningBalanceByHeaderPrevYear(Periode openPeriod, long coaId) {

        Periode periode = new Periode();
        Date dt = openPeriod.getStartDate();
        dt.setYear(dt.getYear() - 1);
        Vector v = DbPeriode.list(0, 0, "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " + DbPeriode.colNames[DbPeriode.COL_END_DATE], "");
        if (v != null && v.size() > 0) {
            periode = (Periode) v.get(0);
        }

        double result = 0;
        Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coaId, "");
        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);
                if (coa.getStatus().equals("HEADER")) {
                    result = result + getOpeningBalanceByHeader(periode, coa.getOID());
                } else {
                    result = result + getOpeningBalance(periode, coa.getOID());
                }
            }
        }

        return result;

    }

    //ambil opening balance dari coa pada periode tertentu, retur double
    public static double getOpeningBalanceByHeaderPrevYear(Periode openPeriod, long coaId, int accClass) {

        Periode periode = new Periode();
        Date dt = openPeriod.getStartDate();
        dt.setYear(dt.getYear() - 1);
        Vector v = DbPeriode.list(0, 0, "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " + DbPeriode.colNames[DbPeriode.COL_END_DATE], "");
        if (v != null && v.size() > 0) {
            periode = (Periode) v.get(0);
        }

        double result = 0;
        Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coaId, "");
        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);
                if (coa.getStatus().equals("HEADER")) {
                    result = result + getOpeningBalanceByHeader(periode, coa.getOID());
                } else {
                    boolean ok = false;

                    if (accClass == DbCoa.ACCOUNT_CLASS_SP) {
                        if (coa.getAccountClass() == accClass) {
                            ok = true;
                        }
                    } else {
                        if (coa.getAccountClass() != DbCoa.ACCOUNT_CLASS_SP) {
                            ok = true;
                        }
                    }

                    if (ok) {
                        result = result + getOpeningBalance(periode, coa.getOID());
                    }
                }
            }
        }

        return result;

    }

    public static double getSumOpeningBalance() {
        double result = 0;
        CONResultSet crs = null;
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }
        
        try {
            String sql = "select sum(" + DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_OPENING_BALANCE] + ") from " + DbCoaOpeningBalanceLocation.DB_COA_OPENING_BALANCE_LOCATION + " where " + DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_PERIODE_ID] + "=" + p.getOID();
         
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getSumOpeningBalancePrevYear() {
        double result = 0;
        CONResultSet crs = null;
        
        Periode p = new Periode();
        Date dt = new Date();
        try {
            p = DbPeriode.getOpenPeriod();
            dt = p.getStartDate();
            dt.setYear(dt.getYear() - 1);

            Vector v = DbPeriode.list(0, 0, "'" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "' between " + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " and " + DbPeriode.colNames[DbPeriode.COL_END_DATE], "");
            if (v != null && v.size() > 0) {
                p = (Periode) v.get(0);
            } else {
                p = new Periode();
            }

        } catch (Exception e) {
            System.out.println(e);
        }

        if (p.getOID() != 0) {            
            try {
                String sql = "select sum(" + DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_OPENING_BALANCE] + ") from " + DbCoaOpeningBalanceLocation.DB_COA_OPENING_BALANCE_LOCATION + " where " + DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_PERIODE_ID] + "=" + p.getOID();
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }

    public static CoaOpeningBalanceLocation getObjectByCodePeriod(String code, long periodId) {

        String sql = "";
        CoaOpeningBalanceLocation co = new CoaOpeningBalanceLocation();
        CONResultSet crs = null;
        try {
            sql = " SELECT c.* FROM " + DB_COA_OPENING_BALANCE_LOCATION + " c " +
                    " inner join " + DbCoa.DB_COA + " co on co." + DbCoa.colNames[DbCoa.COL_COA_ID] + " = c." + colNames[FLD_COA_ID] +
                    " where co." + DbCoa.colNames[DbCoa.COL_CODE] + "='" + code + "'" +
                    " and c." + colNames[FLD_PERIODE_ID] + " = " + periodId;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                DbCoaOpeningBalanceLocation.resultToObject(rs, co);
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return co;

    }

    public static void updateOpeningBalanceRecursif(long coaId, double amount, long oidPeriod) {

        if (amount != 0) {

            CoaOpeningBalanceLocation cob = new CoaOpeningBalanceLocation();

            Vector temp = list(0, 1, colNames[FLD_COA_ID] + "=" + coaId + " and " + colNames[FLD_PERIODE_ID] + "=" + oidPeriod, "");

            if (temp != null && temp.size() > 0) {
                cob = (CoaOpeningBalanceLocation) temp.get(0);
            }

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(coaId);
            } catch (Exception e) {}

            Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
            Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

            //update
            if (cob.getOID() != 0) {

                cob.setOpeningBalance(cob.getOpeningBalance() + amount);

                try {
                    long oid = updateExc(cob);
                    if (oid != 0 && !coa.getCode().equals(coaLabaBerjalan.getCode()) && !coa.getCode().equals(coaLabaLalu.getCode())) {
                        if (coa.getAccRefId() != 0) {
                            updateOpeningBalanceRecursif(coa.getAccRefId(), amount, oidPeriod);
                        }
                    }
                } catch (Exception e) {}
            } //new
            else {
                cob.setCoaId(coaId);
                cob.setPeriodeId(oidPeriod);
                cob.setOpeningBalance(amount);
                try {
                    long oid = insertExc(cob);
                    if (oid != 0 && !coa.getCode().equals(coaLabaBerjalan.getCode()) && !coa.getCode().equals(coaLabaLalu.getCode())) {
                        if (coa.getAccRefId() != 0) {
                            updateOpeningBalanceRecursif(coa.getAccRefId(), amount, oidPeriod);
                        }
                    }
                } catch (Exception e) {}
            }
        }
    }
    
    public static double getOpeningBalance(Periode openPeriod, long coaId,long segment1Id) {        
        CONResultSet crs = null;        
        try{            
            String sql = "select sum("+DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_OPENING_BALANCE]+") "+
                    " from "+DbCoaOpeningBalanceLocation.DB_COA_OPENING_BALANCE_LOCATION+
                    " where "+DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_PERIODE_ID]+" = "+openPeriod.getOID()+" and "+
                    DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_ID]+" = "+coaId;                    
            
            if(segment1Id != 0){
                sql = sql + " and "+DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_SEGMENT1_ID]+" = "+segment1Id;
            }
        
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){                 
                double amount = rs.getDouble(1);
                return amount;
            }
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return 0;
    }
    
    public static double getOpeningBalance(Periode openPeriod,long coaId,String whereLoc) {        
        CONResultSet crs = null;        
        try{            
            String sql = "select sum("+DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_OPENING_BALANCE]+") "+
                    " from "+DbCoaOpeningBalanceLocation.DB_COA_OPENING_BALANCE_LOCATION+
                    " where "+DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_PERIODE_ID]+" = "+openPeriod.getOID()+" and "+
                    DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_COA_ID]+" = "+coaId;
            
            if(whereLoc != null && whereLoc.length() > 0){
                sql = sql + " and "+whereLoc;
            }
        
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){                 
                double amount = rs.getDouble(1);
                return amount;
            }
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        return 0;
    }
    
    public static void updateOpeningBalanceRecursif(long coaId, double amount, long oidPeriod,long segment1Id){

        if (amount != 0){
            
            CoaOpeningBalanceLocation cob = new CoaOpeningBalanceLocation();
            Vector temp = list(0, 1, colNames[FLD_COA_ID] + "=" + coaId + " and " + colNames[FLD_PERIODE_ID] + "=" + oidPeriod+" and " + colNames[FLD_SEGMENT1_ID] + "=" + segment1Id , "");

            if (temp != null && temp.size() > 0){
                cob = (CoaOpeningBalanceLocation) temp.get(0);
            }

            Coa coa = new Coa();            
            try {
                coa = DbCoa.fetchExc(coaId);
            } catch (Exception e) {}

            Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
            Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

            //update
            if(cob.getOID() != 0){                
                cob.setOpeningBalance(cob.getOpeningBalance() + amount);
                try {
                    long oid = updateExc(cob);
                    if (oid != 0 && !coa.getCode().equals(coaLabaBerjalan.getCode()) && !coa.getCode().equals(coaLabaLalu.getCode())){
                        if (coa.getAccRefId() != 0) {
                            updateOpeningBalanceRecursif(coa.getAccRefId(), amount, oidPeriod, segment1Id );
                        }
                    }
                } catch (Exception e){}
            } //new
            else {
                cob.setCoaId(coaId);
                cob.setPeriodeId(oidPeriod);
                cob.setOpeningBalance(amount);  
                cob.setSegment1Id(segment1Id);
                try {
                    long oid = insertExc(cob);
                    if (oid != 0 && !coa.getCode().equals(coaLabaBerjalan.getCode()) && !coa.getCode().equals(coaLabaLalu.getCode())) {
                        if (coa.getAccRefId() != 0) {
                            updateOpeningBalanceRecursif(coa.getAccRefId(), amount, oidPeriod,segment1Id);
                        }
                    }
                } catch (Exception e) {
                    System.out.println("[exception] "+e.toString());
                }
            }
        }
    }
    
    public static void deleteByPeriod(long periodId,int flag){
        CONResultSet crs = null;        
        try{
            String sql = "delete from "+DbCoaOpeningBalanceLocation.DB_COA_OPENING_BALANCE_LOCATION+" where "+DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_PERIODE_ID]+" = "+periodId;
            
            if(flag!=-1){
                sql = sql+" and "+DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_OPENING_BALANCE]+"="+flag;
            }
            
            CONHandler.execUpdate(sql);
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
    }
}
