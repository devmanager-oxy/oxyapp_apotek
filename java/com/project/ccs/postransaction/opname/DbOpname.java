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

public class DbOpname extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_OPNAME = "pos_opname";
    public static final int COL_OPNAME_ID = 0;
    public static final int COL_COUNTER = 1;
    public static final int COL_NUMBER = 2;
    public static final int COL_DATE = 3;
    public static final int COL_STATUS = 4;
    public static final int COL_NOTE = 5;
    public static final int COL_APPROVAL_1 = 6;
    public static final int COL_APPROVAL_2 = 7;
    public static final int COL_APPROVAL_3 = 8;
    public static final int COL_USER_ID = 9;
    public static final int COL_LOCATION_ID = 10;
    public static final int COL_PREFIX_NUMBER = 11;
    public static final int COL_APPROVAL_1_DATE = 12;
    public static final int COL_APPROVAL_2_DATE = 13;
    public static final int COL_APPROVAL_3_DATE = 14;
    public static final int COL_TYPE = 15;
    public static final int COL_OPNAME_PERIODE_ID = 16;
    public static final int COL_TYPE_OPNAME = 17;
    public static final String[] colNames = {
        "opname_id",
        "counter",
        "number",
        "date",
        "status",
        "note",
        "approval_1",
        "approval_2",
        "approval_3",
        "user_id",
        "location_id",
        "prefix_number",
        "approval_1_date",
        "approval_2_date",
        "approval_3_date",
        "type",
        "opname_periode_id",
        "type_opname"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_INT
    };

    public static final int TYPE_NON_CONSIGMENT = 0;
    public static final int TYPE_CONSIGMENT = 1;
    
    public DbOpname() {
    }

    public DbOpname(int i) throws CONException {
        super(new DbOpname());
    }

    public DbOpname(String sOid) throws CONException {
        super(new DbOpname(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbOpname(long lOid) throws CONException {
        super(new DbOpname(0));
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
        return DB_POS_OPNAME;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbOpname().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Opname opname = fetchExc(ent.getOID());
        ent = (Entity) opname;
        return opname.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Opname) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Opname) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Opname fetchExc(long oid) throws CONException {
        try {
            Opname opname = new Opname();
            DbOpname pstOpname = new DbOpname(oid);
            opname.setOID(oid);

            opname.setCounter(pstOpname.getInt(COL_COUNTER));
            opname.setNumber(pstOpname.getString(COL_NUMBER));
            opname.setDate(pstOpname.getDate(COL_DATE));
            opname.setStatus(pstOpname.getString(COL_STATUS));
            opname.setNote(pstOpname.getString(COL_NOTE));
            opname.setApproval1(pstOpname.getlong(COL_APPROVAL_1));
            opname.setApproval2(pstOpname.getlong(COL_APPROVAL_2));
            opname.setApproval3(pstOpname.getlong(COL_APPROVAL_3));
            opname.setUserId(pstOpname.getlong(COL_USER_ID));

            opname.setLocationId(pstOpname.getlong(COL_LOCATION_ID));
            opname.setPrefixNumber(pstOpname.getString(COL_PREFIX_NUMBER));
            opname.setApproval1_date(pstOpname.getDate(COL_APPROVAL_1_DATE));
            opname.setApproval2_date(pstOpname.getDate(COL_APPROVAL_2_DATE));
            opname.setApproval3_date(pstOpname.getDate(COL_APPROVAL_3_DATE));
            opname.setType(pstOpname.getInt(COL_TYPE));
            opname.setOpnamePeriodeId(pstOpname.getlong(COL_OPNAME_PERIODE_ID));
            opname.setTypeOpname(pstOpname.getInt(COL_TYPE_OPNAME));
            return opname;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpname(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Opname opname) throws CONException {
        try {
            DbOpname pstOpname = new DbOpname(0);

            pstOpname.setInt(COL_COUNTER, opname.getCounter());
            pstOpname.setString(COL_NUMBER, opname.getNumber());
            pstOpname.setDate(COL_DATE, opname.getDate());
            pstOpname.setString(COL_STATUS, opname.getStatus());
            pstOpname.setString(COL_NOTE, opname.getNote());
            pstOpname.setLong(COL_APPROVAL_1, opname.getApproval1());
            pstOpname.setLong(COL_APPROVAL_2, opname.getApproval2());
            pstOpname.setLong(COL_APPROVAL_3, opname.getApproval3());
            pstOpname.setLong(COL_USER_ID, opname.getUserId());

            pstOpname.setLong(COL_LOCATION_ID, opname.getLocationId());
            pstOpname.setString(COL_PREFIX_NUMBER, opname.getPrefixNumber());
            pstOpname.setDate(COL_APPROVAL_1_DATE, opname.getApproval1_date());
            pstOpname.setDate(COL_APPROVAL_2_DATE, opname.getApproval2_date());
            pstOpname.setDate(COL_APPROVAL_3_DATE, opname.getApproval3_date());
            pstOpname.setInt(COL_TYPE, opname.getType());
            pstOpname.setLong(COL_OPNAME_PERIODE_ID, opname.getOpnamePeriodeId());
            pstOpname.setInt(COL_TYPE_OPNAME, opname.getTypeOpname());
            pstOpname.insert();
            opname.setOID(pstOpname.getlong(COL_OPNAME_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpname(0), CONException.UNKNOWN);
        }
        return opname.getOID();
    }

    public static long updateExc(Opname opname) throws CONException {
        try {
            if (opname.getOID() != 0) {
                DbOpname pstOpname = new DbOpname(opname.getOID());

                pstOpname.setInt(COL_COUNTER, opname.getCounter());
                pstOpname.setString(COL_NUMBER, opname.getNumber());
                //pstOpname.setDate(COL_DATE, opname.getDate());
                pstOpname.setString(COL_STATUS, opname.getStatus());
                pstOpname.setString(COL_NOTE, opname.getNote());
                pstOpname.setLong(COL_APPROVAL_1, opname.getApproval1());
                pstOpname.setLong(COL_APPROVAL_2, opname.getApproval2());
                pstOpname.setLong(COL_APPROVAL_3, opname.getApproval3());
                pstOpname.setLong(COL_USER_ID, opname.getUserId());

                pstOpname.setLong(COL_LOCATION_ID, opname.getLocationId());
                pstOpname.setString(COL_PREFIX_NUMBER, opname.getPrefixNumber());
                pstOpname.setDate(COL_APPROVAL_1_DATE, opname.getApproval1_date());
                pstOpname.setDate(COL_APPROVAL_2_DATE, opname.getApproval2_date());
                pstOpname.setDate(COL_APPROVAL_3_DATE, opname.getApproval3_date());
                pstOpname.setInt(COL_TYPE, opname.getType());
                pstOpname.setLong(COL_OPNAME_PERIODE_ID, opname.getOpnamePeriodeId());
                pstOpname.setInt(COL_TYPE_OPNAME, opname.getTypeOpname());
                pstOpname.update();
                return opname.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpname(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbOpname pstOpname = new DbOpname(oid);
            //pstOpname.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpname(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_POS_OPNAME;
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
                Opname opname = new Opname();
                resultToObject(rs, opname);
                lists.add(opname);
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

    private static void resultToObject(ResultSet rs, Opname opname) {
        try {
            opname.setOID(rs.getLong(DbOpname.colNames[DbOpname.COL_OPNAME_ID]));
            opname.setCounter(rs.getInt(DbOpname.colNames[DbOpname.COL_COUNTER]));
            opname.setNumber(rs.getString(DbOpname.colNames[DbOpname.COL_NUMBER]));
            opname.setDate(rs.getDate(DbOpname.colNames[DbOpname.COL_DATE]));
            opname.setStatus(rs.getString(DbOpname.colNames[DbOpname.COL_STATUS]));
            opname.setNote(rs.getString(DbOpname.colNames[DbOpname.COL_NOTE]));
            opname.setApproval1(rs.getLong(DbOpname.colNames[DbOpname.COL_APPROVAL_1]));
            opname.setApproval2(rs.getLong(DbOpname.colNames[DbOpname.COL_APPROVAL_2]));
            opname.setApproval3(rs.getLong(DbOpname.colNames[DbOpname.COL_APPROVAL_3]));
            opname.setUserId(rs.getLong(DbOpname.colNames[DbOpname.COL_USER_ID]));

            opname.setUserId(rs.getLong(DbOpname.colNames[DbOpname.COL_LOCATION_ID]));
            opname.setPrefixNumber(rs.getString(DbOpname.colNames[DbOpname.COL_PREFIX_NUMBER]));
            opname.setApproval1_date(rs.getDate(DbOpname.colNames[DbOpname.COL_APPROVAL_1_DATE]));
            opname.setApproval2_date(rs.getDate(DbOpname.colNames[DbOpname.COL_APPROVAL_2_DATE]));
            opname.setApproval3_date(rs.getDate(DbOpname.colNames[DbOpname.COL_APPROVAL_3_DATE]));
            opname.setLocationId(rs.getLong(DbOpname.colNames[DbOpname.COL_LOCATION_ID]));
            opname.setType(rs.getInt(DbOpname.colNames[DbOpname.COL_TYPE]));
            opname.setOpnamePeriodeId(rs.getLong(DbOpname.colNames[DbOpname.COL_OPNAME_PERIODE_ID]));
            opname.setTypeOpname(rs.getInt(DbOpname.colNames[DbOpname.COL_TYPE_OPNAME]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long opnameId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_OPNAME + " WHERE " +
                    DbOpname.colNames[DbOpname.COL_OPNAME_ID] + " = " + opnameId;

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
            String sql = "SELECT COUNT(" + DbOpname.colNames[DbOpname.COL_OPNAME_ID] + ") FROM " + DB_POS_OPNAME;
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
                    Opname opname = (Opname) list.get(ls);
                    if (oid == opname.getOID()) {
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

    public static int getNextCounter() {
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
    }

    public static String getNumberPrefix() {
        String code = "";
        Company sysCompany = DbCompany.getCompany();
        code = code + sysCompany.getOpnameCode();

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }

    public static String getNextNumber(int ctr) {

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
    }
}
