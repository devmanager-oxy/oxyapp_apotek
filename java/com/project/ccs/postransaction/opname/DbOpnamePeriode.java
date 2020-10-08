package com.project.ccs.postransaction.opname;

import com.project.general.Company;
import com.project.general.DbCompany;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;
import java.util.Date;

public class DbOpnamePeriode extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_OPNAME_PERIODE = "pos_opname_periode";
    public static final int COL_OPNAME_PERIODE_ID = 0;
    public static final int COL_START_DATE = 1;
    public static final int COL_END_DATE = 2;
    public static final int COL_NAME = 3;
    public static final int COL_STATUS = 4;
    public static final int COL_USER_ID = 5;
    
    public static final String[] colNames = {
        "opname_periode_id",
        "name",
        "start_date",
        "end_date",
        "status",
        "user_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG
        
    };

    public static final int TYPE_NON_CONSIGMENT = 0;
    public static final int TYPE_CONSIGMENT = 1;
    
    public DbOpnamePeriode() {
    }

    public DbOpnamePeriode(int i) throws CONException {
        super(new DbOpnamePeriode());
    }

    public DbOpnamePeriode(String sOid) throws CONException {
        super(new DbOpnamePeriode(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbOpnamePeriode(long lOid) throws CONException {
        super(new DbOpnamePeriode(0));
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
        return DB_POS_OPNAME_PERIODE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbOpnamePeriode().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        OpnamePeriode opnamePeriode = fetchExc(ent.getOID());
        ent = (Entity) opnamePeriode;
        return opnamePeriode.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((OpnamePeriode) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((OpnamePeriode) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static OpnamePeriode fetchExc(long oid) throws CONException {
        try {
            OpnamePeriode opnamePeriode = new OpnamePeriode();
            DbOpnamePeriode pstOpname = new DbOpnamePeriode(oid);
            opnamePeriode.setOID(oid);

            opnamePeriode.setName(pstOpname.getString(COL_NAME));
            opnamePeriode.setStartDate(pstOpname.getDate(COL_START_DATE));
            opnamePeriode.setEndDate(pstOpname.getDate(COL_END_DATE));
            opnamePeriode.setStatus(pstOpname.getString(COL_STATUS));
            opnamePeriode.setUserId(pstOpname.getlong(COL_USER_ID));
            
            return opnamePeriode;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnamePeriode(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(OpnamePeriode opnamePeriode) throws CONException {
        try {
            DbOpnamePeriode pstOpname = new DbOpnamePeriode(0);

            pstOpname.setString(COL_NAME, opnamePeriode.getName());
            pstOpname.setDate(COL_START_DATE, opnamePeriode.getStartDate());
            pstOpname.setDate(COL_END_DATE, opnamePeriode.getEndDate());
            pstOpname.setString(COL_STATUS, opnamePeriode.getStatus());
            pstOpname.setLong(COL_USER_ID, opnamePeriode.getUserId());
            
            pstOpname.insert();
            opnamePeriode.setOID(pstOpname.getlong(COL_OPNAME_PERIODE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnamePeriode(0), CONException.UNKNOWN);
        }
        return opnamePeriode.getOID();
    }

    public static long updateExc(OpnamePeriode opnamePeriode) throws CONException {
        try {
            if (opnamePeriode.getOID() != 0) {
                DbOpnamePeriode pstOpname = new DbOpnamePeriode(opnamePeriode.getOID());

                pstOpname.setString(COL_NAME, opnamePeriode.getName());
                pstOpname.setDate(COL_START_DATE, opnamePeriode.getStartDate());
                pstOpname.setDate(COL_END_DATE, opnamePeriode.getEndDate());
                pstOpname.setString(COL_STATUS, opnamePeriode.getStatus());
                pstOpname.setLong(COL_USER_ID, opnamePeriode.getUserId());
                pstOpname.update();
                return opnamePeriode.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnamePeriode(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbOpnamePeriode pstOpname = new DbOpnamePeriode(oid);
            pstOpname.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnamePeriode(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_OPNAME_PERIODE;
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
                OpnamePeriode opnamePeriode = new OpnamePeriode();
                resultToObject(rs, opnamePeriode);
                lists.add(opnamePeriode);
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

    private static void resultToObject(ResultSet rs, OpnamePeriode opnamePeriode) {
        try {
            opnamePeriode.setOID(rs.getLong(DbOpnamePeriode.colNames[DbOpnamePeriode.COL_OPNAME_PERIODE_ID]));
            opnamePeriode.setName(rs.getString(DbOpnamePeriode.colNames[DbOpnamePeriode.COL_NAME]));
            opnamePeriode.setStartDate(rs.getDate(DbOpnamePeriode.colNames[DbOpnamePeriode.COL_START_DATE]));
            opnamePeriode.setEndDate(rs.getDate(DbOpnamePeriode.colNames[DbOpnamePeriode.COL_END_DATE]));
            opnamePeriode.setStatus(rs.getString(DbOpnamePeriode.colNames[DbOpnamePeriode.COL_STATUS]));
            opnamePeriode.setUserId(rs.getLong(DbOpnamePeriode.colNames[DbOpnamePeriode.COL_USER_ID]));
            
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long opnamePeriodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_OPNAME_PERIODE + " WHERE " +
                    DbOpnamePeriode.colNames[DbOpnamePeriode.COL_OPNAME_PERIODE_ID] + " = " + opnamePeriodeId;

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

    public static int getCount(String whereClause){
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbOpnamePeriode.colNames[DbOpnamePeriode.COL_OPNAME_PERIODE_ID] + ") FROM " + DB_POS_OPNAME_PERIODE;
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
                    OpnamePeriode opnamePeriode = (OpnamePeriode) list.get(ls);
                    if (oid == opnamePeriode.getOID()) {
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

    /*public static int getNextCounter() {
        int result = 0;

        CONResultSet dbrs = null;
        try {
            String sql = "select max(" + colNames[COL_COUNTER] + ") from " + DB_POS_OPNAME + " where " +
                    colNames[COL_PREFIX_NUMBER] + "='" + getNumberPrefix() + "' ";

            System.out.println(sql);

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                result = rs.getInt(1);
            }

            result = result + 1;

        } catch (Exception e) {
        } finally {
            CONResultSet.close(dbrs);
        }

        return result;
    }*/

   /* public static String getNumberPrefix() {
        String code = "";
        Company sysCompany = DbCompany.getCompany();
        code = code + sysCompany.getOpnameCode();

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }*/

   /* public static String getNextNumber(int ctr) {

        String code = getNumberPrefix();   

        if (ctr < 10) {
            code = code + "000" + ctr;
        } else if (ctr < 100) {
            code = code + "00" + ctr;
        } else if (ctr < 1000) {
            code = code + "0" + ctr;
        } else {
            code = code + ctr;
        }
        return code;
    }*/
}
