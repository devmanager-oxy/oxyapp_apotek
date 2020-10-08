package com.project.fms.master;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.I_Project;
import com.project.fms.session.CoaReport;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbGlDetail;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.payroll.DbDepartment;
import com.project.payroll.Department;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;

public class DbCoa extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_COA = "coa";
    public static final int COL_COA_ID = 0;
    public static final int COL_ACC_REF_ID = 1;
    public static final int COL_DEPARTMENT_ID = 2;
    public static final int COL_SECTION_ID = 3;
    public static final int COL_ACCOUNT_GROUP = 4;
    public static final int COL_CODE = 5;
    public static final int COL_NAME = 6;
    public static final int COL_LEVEL = 7;
    public static final int COL_SALDO_NORMAL = 8;
    public static final int COL_STATUS = 9;
    public static final int COL_DEPARTMENT_NAME = 10;
    public static final int COL_SECTION_NAME = 11;
    public static final int COL_USER_ID = 12;
    public static final int COL_REG_DATE = 13;
    public static final int COL_OPENING_BALANCE = 14;
    public static final int COL_LOCATION_ID = 15;
    public static final int COL_DEPARTMENTAL_COA = 16;
    public static final int COL_COA_CATEGORY_ID = 17;
    public static final int COL_COA_GROUP_ALIAS_ID = 18;
    public static final int COL_IS_NEED_EXTRA = 19;
    public static final int COL_DEBET_PREFIX_CODE = 20;
    public static final int COL_CREDIT_PREFIX_CODE = 21;
    public static final int COL_COMPANY_ID = 22;
    public static final int COL_ACCOUNT_CLASS = 23;
    public static final int COL_AUTO_REVERSE = 24;
    public static final int COL_SEGMENT1_ID = 25;
    public static final int COL_SEGMENT2_ID = 26;
    public static final int COL_SEGMENT3_ID = 27;
    public static final int COL_SEGMENT4_ID = 28;
    public static final int COL_SEGMENT5_ID = 29;
    
    public static final String[] colNames = {
        "coa_id",
        "acc_ref_id",
        "department_id",
        "section_id",
        "account_group",
        "code",
        "name",
        "level",
        "saldo_normal",
        "status",
        "department_name",
        "section_name",
        "user_id",
        "reg_date",
        "opening_balance",
        "location_id",
        "departmental_coa",
        "coa_category_id",
        "coa_group_alias_id",
        "is_need_extra",
        "debet_prefix_code",
        "credit_prefix_code",
        "company_id",
        "account_class",
        "auto_reverse",
        "segment1_id",
        "segment2_id",
        "segment3_id",
        "segment4_id",
        "segment5_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };
    
    public static final int ACCOUNT_CLASS_GENERAL = 0;
    public static final int ACCOUNT_CLASS_NONSP = 1;
    public static final int ACCOUNT_CLASS_SP = 2;
    public static final String[] accClassStr = {"-", "Non SP", "SP"};
    public static final int NOT_AUTO_REVERSE = 0;
    public static final int AUTO_REVERSE = 1;

    public DbCoa() {
    }

    public DbCoa(int i) throws CONException {
        super(new DbCoa());
    }

    public DbCoa(String sOid) throws CONException {
        super(new DbCoa(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCoa(long lOid) throws CONException {
        super(new DbCoa(0));
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
        return DB_COA;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCoa().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Coa coa = fetchExc(ent.getOID());
        ent = (Entity) coa;
        return coa.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Coa) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Coa) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Coa fetchExc(long oid) throws CONException {
        try {
            Coa coa = new Coa();
            DbCoa dbCoa = new DbCoa(oid);
            coa.setOID(oid);

            coa.setAccRefId(dbCoa.getlong(COL_ACC_REF_ID));
            coa.setDepartmentId(dbCoa.getlong(COL_DEPARTMENT_ID));
            coa.setSectionId(dbCoa.getlong(COL_SECTION_ID));
            coa.setAccountGroup(dbCoa.getString(COL_ACCOUNT_GROUP));
            coa.setCode(dbCoa.getString(COL_CODE));
            coa.setName(dbCoa.getString(COL_NAME));
            coa.setLevel(dbCoa.getInt(COL_LEVEL));
            coa.setSaldoNormal(dbCoa.getString(COL_SALDO_NORMAL));
            coa.setStatus(dbCoa.getString(COL_STATUS));
            coa.setDepartmentName(dbCoa.getString(COL_DEPARTMENT_NAME));
            coa.setSectionName(dbCoa.getString(COL_SECTION_NAME));
            coa.setUserId(dbCoa.getlong(COL_USER_ID));
            coa.setRegDate(dbCoa.getDate(COL_REG_DATE));
            coa.setOpeningBalance(dbCoa.getdouble(COL_OPENING_BALANCE));
            coa.setLocationId(dbCoa.getlong(COL_LOCATION_ID));
            coa.setDepartmentalCoa(dbCoa.getInt(COL_DEPARTMENTAL_COA));
            coa.setCoaCategoryId(dbCoa.getlong(COL_COA_CATEGORY_ID));
            coa.setCoaGroupAliasId(dbCoa.getlong(COL_COA_GROUP_ALIAS_ID));
            coa.setIsNeedExtra(dbCoa.getInt(COL_IS_NEED_EXTRA));
            coa.setDebetPrefixCode(dbCoa.getString(COL_DEBET_PREFIX_CODE));
            coa.setCreditPrefixCode(dbCoa.getString(COL_CREDIT_PREFIX_CODE));
            coa.setCompanyId(dbCoa.getlong(COL_COMPANY_ID));
            coa.setAccountClass(dbCoa.getInt(COL_ACCOUNT_CLASS));
            coa.setAutoReverse(dbCoa.getInt(COL_AUTO_REVERSE));
            coa.setSegment1Id(dbCoa.getlong(COL_SEGMENT1_ID));
            coa.setSegment2Id(dbCoa.getlong(COL_SEGMENT2_ID));
            coa.setSegment3Id(dbCoa.getlong(COL_SEGMENT3_ID));
            coa.setSegment4Id(dbCoa.getlong(COL_SEGMENT4_ID));
            coa.setSegment5Id(dbCoa.getlong(COL_SEGMENT5_ID));

            return coa;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoa(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Coa coa) throws CONException {
        try {
            DbCoa dbCoa = new DbCoa(0);

            dbCoa.setLong(COL_ACC_REF_ID, coa.getAccRefId());
            dbCoa.setLong(COL_DEPARTMENT_ID, coa.getDepartmentId());
            dbCoa.setLong(COL_SECTION_ID, coa.getSectionId());
            dbCoa.setString(COL_ACCOUNT_GROUP, coa.getAccountGroup());
            dbCoa.setString(COL_CODE, coa.getCode());
            dbCoa.setString(COL_NAME, coa.getName());
            dbCoa.setInt(COL_LEVEL, coa.getLevel());
            dbCoa.setString(COL_SALDO_NORMAL, coa.getSaldoNormal());
            dbCoa.setString(COL_STATUS, coa.getStatus());
            dbCoa.setString(COL_DEPARTMENT_NAME, coa.getDepartmentName());
            dbCoa.setString(COL_SECTION_NAME, coa.getSectionName());
            dbCoa.setLong(COL_USER_ID, coa.getUserId());
            dbCoa.setDate(COL_REG_DATE, coa.getRegDate());
            dbCoa.setDouble(COL_OPENING_BALANCE, coa.getOpeningBalance());
            dbCoa.setLong(COL_LOCATION_ID, coa.getLocationId());
            dbCoa.setInt(COL_DEPARTMENTAL_COA, coa.getDepartmentalCoa());
            dbCoa.setLong(COL_COA_CATEGORY_ID, coa.getCoaCategoryId());
            dbCoa.setLong(COL_COA_GROUP_ALIAS_ID, coa.getCoaGroupAliasId());
            dbCoa.setInt(COL_IS_NEED_EXTRA, coa.getIsNeedExtra());
            dbCoa.setString(COL_DEBET_PREFIX_CODE, coa.getDebetPrefixCode());
            dbCoa.setString(COL_CREDIT_PREFIX_CODE, coa.getCreditPrefixCode());
            dbCoa.setLong(COL_COMPANY_ID, coa.getCompanyId());
            dbCoa.setInt(COL_ACCOUNT_CLASS, coa.getAccountClass());
            dbCoa.setInt(COL_AUTO_REVERSE, coa.getAutoReverse());
            dbCoa.setLong(COL_SEGMENT1_ID, coa.getSegment1Id());
            dbCoa.setLong(COL_SEGMENT2_ID, coa.getSegment2Id());
            dbCoa.setLong(COL_SEGMENT3_ID, coa.getSegment3Id());
            dbCoa.setLong(COL_SEGMENT4_ID, coa.getSegment4Id());
            dbCoa.setLong(COL_SEGMENT5_ID, coa.getSegment5Id());

            dbCoa.insert();
            coa.setOID(dbCoa.getlong(COL_COA_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoa(0), CONException.UNKNOWN);
        }
        return coa.getOID();
    }

    public static long updateExc(Coa coa) throws CONException {
        try {
            if (coa.getOID() != 0) {
                DbCoa dbCoa = new DbCoa(coa.getOID());

                dbCoa.setLong(COL_ACC_REF_ID, coa.getAccRefId());
                dbCoa.setLong(COL_DEPARTMENT_ID, coa.getDepartmentId());
                dbCoa.setLong(COL_SECTION_ID, coa.getSectionId());
                dbCoa.setString(COL_ACCOUNT_GROUP, coa.getAccountGroup());
                dbCoa.setString(COL_CODE, coa.getCode());
                dbCoa.setString(COL_NAME, coa.getName());
                dbCoa.setInt(COL_LEVEL, coa.getLevel());
                dbCoa.setString(COL_SALDO_NORMAL, coa.getSaldoNormal());
                dbCoa.setString(COL_STATUS, coa.getStatus());
                dbCoa.setString(COL_DEPARTMENT_NAME, coa.getDepartmentName());
                dbCoa.setString(COL_SECTION_NAME, coa.getSectionName());
                dbCoa.setLong(COL_USER_ID, coa.getUserId());
                dbCoa.setDate(COL_REG_DATE, coa.getRegDate());
                dbCoa.setDouble(COL_OPENING_BALANCE, coa.getOpeningBalance());
                dbCoa.setLong(COL_LOCATION_ID, coa.getLocationId());
                dbCoa.setInt(COL_DEPARTMENTAL_COA, coa.getDepartmentalCoa());
                dbCoa.setLong(COL_COA_CATEGORY_ID, coa.getCoaCategoryId());
                dbCoa.setLong(COL_COA_GROUP_ALIAS_ID, coa.getCoaGroupAliasId());
                dbCoa.setInt(COL_IS_NEED_EXTRA, coa.getIsNeedExtra());
                dbCoa.setString(COL_DEBET_PREFIX_CODE, coa.getDebetPrefixCode());
                dbCoa.setString(COL_CREDIT_PREFIX_CODE, coa.getCreditPrefixCode());
                dbCoa.setLong(COL_COMPANY_ID, coa.getCompanyId());
                dbCoa.setInt(COL_ACCOUNT_CLASS, coa.getAccountClass());
                dbCoa.setInt(COL_AUTO_REVERSE, coa.getAutoReverse());
                dbCoa.setLong(COL_SEGMENT1_ID, coa.getSegment1Id());
                dbCoa.setLong(COL_SEGMENT2_ID, coa.getSegment2Id());
                dbCoa.setLong(COL_SEGMENT3_ID, coa.getSegment3Id());
                dbCoa.setLong(COL_SEGMENT4_ID, coa.getSegment4Id());
                dbCoa.setLong(COL_SEGMENT5_ID, coa.getSegment5Id());

                dbCoa.update();
                return coa.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoa(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCoa dbCoa = new DbCoa(oid);
            dbCoa.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoa(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_COA;
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
                Coa coa = new Coa();
                resultToObject(rs, coa);
                lists.add(coa);
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

    public static void resultToObject(ResultSet rs, Coa coa) {
        try {
            coa.setOID(rs.getLong(DbCoa.colNames[DbCoa.COL_COA_ID]));
            coa.setAccRefId(rs.getLong(DbCoa.colNames[DbCoa.COL_ACC_REF_ID]));
            coa.setDepartmentId(rs.getLong(DbCoa.colNames[DbCoa.COL_DEPARTMENT_ID]));
            coa.setSectionId(rs.getLong(DbCoa.colNames[DbCoa.COL_SECTION_ID]));
            coa.setAccountGroup(rs.getString(DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]));
            coa.setCode(rs.getString(DbCoa.colNames[DbCoa.COL_CODE]));
            coa.setName(rs.getString(DbCoa.colNames[DbCoa.COL_NAME]));
            coa.setLevel(rs.getInt(DbCoa.colNames[DbCoa.COL_LEVEL]));
            coa.setSaldoNormal(rs.getString(DbCoa.colNames[DbCoa.COL_SALDO_NORMAL]));
            coa.setStatus(rs.getString(DbCoa.colNames[DbCoa.COL_STATUS]));
            coa.setDepartmentName(rs.getString(DbCoa.colNames[DbCoa.COL_DEPARTMENT_NAME]));
            coa.setSectionName(rs.getString(DbCoa.colNames[DbCoa.COL_SECTION_NAME]));
            coa.setUserId(rs.getLong(DbCoa.colNames[DbCoa.COL_USER_ID]));
            coa.setRegDate(rs.getDate(DbCoa.colNames[DbCoa.COL_REG_DATE]));
            coa.setOpeningBalance(rs.getDouble(DbCoa.colNames[DbCoa.COL_OPENING_BALANCE]));
            coa.setLocationId(rs.getLong(DbCoa.colNames[DbCoa.COL_LOCATION_ID]));
            coa.setDepartmentalCoa(rs.getInt(DbCoa.colNames[DbCoa.COL_DEPARTMENTAL_COA]));
            coa.setCoaCategoryId(rs.getLong(DbCoa.colNames[DbCoa.COL_COA_CATEGORY_ID]));
            coa.setCoaGroupAliasId(rs.getLong(DbCoa.colNames[DbCoa.COL_COA_GROUP_ALIAS_ID]));
            coa.setIsNeedExtra(rs.getInt(DbCoa.colNames[DbCoa.COL_IS_NEED_EXTRA]));
            coa.setDebetPrefixCode(rs.getString(DbCoa.colNames[DbCoa.COL_DEBET_PREFIX_CODE]));
            coa.setCreditPrefixCode(rs.getString(DbCoa.colNames[DbCoa.COL_CREDIT_PREFIX_CODE]));
            coa.setCompanyId(rs.getLong(DbCoa.colNames[DbCoa.COL_COMPANY_ID]));
            coa.setAccountClass(rs.getInt(DbCoa.colNames[DbCoa.COL_ACCOUNT_CLASS]));
            coa.setAutoReverse(rs.getInt(DbCoa.colNames[DbCoa.COL_AUTO_REVERSE]));
            coa.setSegment1Id(rs.getLong(colNames[COL_SEGMENT1_ID]));
            coa.setSegment2Id(rs.getLong(colNames[COL_SEGMENT2_ID]));
            coa.setSegment3Id(rs.getLong(colNames[COL_SEGMENT3_ID]));
            coa.setSegment4Id(rs.getLong(colNames[COL_SEGMENT4_ID]));
            coa.setSegment5Id(rs.getLong(colNames[COL_SEGMENT5_ID]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long coaId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_COA + " WHERE " +
                    DbCoa.colNames[DbCoa.COL_COA_ID] + " = " + coaId;

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
            String sql = "SELECT COUNT(" + DbCoa.colNames[DbCoa.COL_COA_ID] + ") FROM " + DB_COA;
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
                    Coa coa = (Coa) list.get(ls);
                    if (oid == coa.getOID()) {
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

    public static void updateLocation(long coaId, long locationId) {
        if (coaId != 0) {
            try {
                Coa coa = DbCoa.fetchExc(coaId);
                coa.setLocationId(locationId);
                DbCoa.updateExc(coa);
            } catch (Exception e) {
                System.out.println(e.toString());
            }
        }
    }

    public static double getCoaBalanceByGroup(String coaGroup, String type) {

        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                if (type.equals("CD")) {
                    result = result + DbCoa.getCoaBalanceCD(coa.getOID());
                } else {
                    result = result + DbCoa.getCoaBalance(coa.getOID());
                }
            }
        }
        return result;
    }

    public static double getCoaBalanceByGroup(String coaGroup, String type, String whereSd) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                if (type.equals("CD")) {
                    result = result + DbCoa.getCoaBalanceCD(coa.getOID(), whereSd);
                } else {
                    result = result + DbCoa.getCoaBalance(coa.getOID(), whereSd);
                }
            }
        }

        return result;
    }
    
    public static double getIsCoaBalanceByGroup(String coaGroup, String type, String whereSd,long periodId) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]+" = '" + coaGroup + "'", DbCoa.colNames[DbCoa.COL_CODE]);
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                if (type.equals("CD")) {
                    result = result + DbCoa.getCoaBalanceCD(coa.getOID(), whereSd, periodId);
                } else {
                    result = result + DbCoa.getCoaBalance(coa.getOID(), whereSd,periodId);
                }
                if(result != 0){
                    return result;
                }
            }
        }
        return result;
    }
    
    public static double getIsCoaBalanceByGroup(String coaGroup, String type, String whereSd,Periode p, String whereLoc) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]+" = '" + coaGroup + "'", DbCoa.colNames[DbCoa.COL_CODE]);
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                
                if (type.equals("CD")) {
                    result = result + DbCoa.getCoaBalanceCD(coa.getOID(), whereSd, p, whereLoc);
                } else {
                    result = result + DbCoa.getCoaBalance(coa.getOID(), whereSd,p, whereLoc);
                }
                if(result != 0){
                    return result;
                }
            }
        }
        return result;
    }
    
    public static double getIsCoaBalanceByGroupMTD(String coaGroup, String type, String whereSd,Periode p) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]+" = '" + coaGroup + "'", DbCoa.colNames[DbCoa.COL_CODE]);
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);               
                
                result = result + getCoaBalancePNLMTD(coa,whereSd, p,type);                    
                
                if(result != 0){
                    return result;
                }
            }
        }
        return result;
    }
    
    public static double getIsCoaBalanceByGroupMTD(Vector listCoa, String type, String whereSd,Periode p) {
        double result = 0;        
        Coa coa = new Coa();        
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);               
                
                result = result + getCoaBalancePNLMTD(coa,whereSd, p,type);                    
                
                if(result != 0){
                    return result;
                }
            }
        }
        return result;
    }
    

    public static double getCoaBalanceByGroupPrevYear(String coaGroup, String type) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                if (type.equals("CD")) {
                    result = result + DbCoa.getCoaBalanceCDPrevYear(coa.getOID());
                } else {
                    result = result + DbCoa.getCoaBalancePrevYear(coa.getOID());
                }
            }
        }

        return result;
    }

    public static double getCoaBalanceByGroup(String coaGroup, String type, Vector periods) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                if (type.equals("CD")) {
                    result = result + DbCoa.getCoaBalanceCD(coa.getOID(), periods);
                } else {
                    result = result + DbCoa.getCoaBalance(coa.getOID(), periods);
                }
            }
        }

        return result;
    }

    public static double getCoaOpeningBalanceByGroup(String coaGroup, String type) {
        double result = 0;
        Periode p = DbPeriode.getOpenPeriod();
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                result = result + DbCoaOpeningBalance.getOpeningBalance(p, coa.getOID());
            }
        }

        return result;
    }

    public static double getCoaOpeningBalanceByGroup(String coaGroup, String type, String whereMd) {
        double result = 0;
        Periode p = DbPeriode.getOpenPeriod();
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                result = result + DbGlDetail.getOpeningBalance(p, coa.getOID(), whereMd);
            }
        }
        return result;
    }

    public static double getCoaOpeningBalanceByGroupLev1(String coaGroup, String type, String whereMd) {
        double result = 0;
        Periode p = DbPeriode.getOpenPeriod();
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "' and level=1", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);                
                result = result + DbGlDetail.getOpeningBalancePrevious(p, coa.getOID(), whereMd);
            }
        }
        return result;
    }
    
    public static double getCoaOpeningBalanceByGroupLev1(String coaGroup, String whereMd,long periodeId) {
        double result = 0;
        
        Periode p = new Periode();
        try{
            p = DbPeriode.fetchExc(periodeId);
        }catch(Exception e){}
        
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "' and level=1", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);                
                result = result + DbGlDetail.getOpeningBalancePrevious(p, coa.getOID(), whereMd);
            }
        }
        return result;
    }
    
    public static double getCoaOpeningBalanceByGroupLev1(String coaGroup, Periode p, String whereLoc) {
        double result = 0;
        
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "' and level=1", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);                
                result = result + DbCoaOpeningBalanceLocation.getOpeningBalance(p, coa.getOID(), whereLoc);
            }
        }
        return result;
    }

    public static double getCoaBalanceByHeader(long coaId, String type) {

        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {
                        amount = DbCoa.getCoaBalanceCD(coa.getOID());

                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();
                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalance(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                }
                            }

                            amount = totalIncome;
                        }

                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalance(coa.getOID());
                    }
                }
            }
        }

        return result;
    }

    public static double getCoaBalanceByHeader(long coaId, String type, String whereMd) {

        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {

                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {

                        amount = DbCoa.getCoaBalanceCD(coa.getOID(), whereMd);

                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();
                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalance(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                }
                            }

                            amount = totalIncome;
                        }
                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalance(coa.getOID(), whereMd);
                    }
                }
            }
        }

        return result;
    }
    
    public static double getCoaBalanceByHeader(long coaId, String type, String whereMd,long periodeId) {

        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {

                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {

                        amount = DbCoa.getCoaBalanceCD(coa.getOID(), whereMd, periodeId);

                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();
                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), whereMd, periodeId);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalance(coax.getOID(), whereMd, periodeId);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), whereMd, periodeId);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), whereMd, periodeId);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), whereMd, periodeId);
                                }
                            }

                            amount = totalIncome;
                        }
                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalance(coa.getOID(), whereMd, periodeId);
                    }
                }
            }
        }

        return result;
    }
    
    public static double getCoaBalanceByHeader(long coaId, String type, String whereMd,Periode p, String whereLoc){

        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {

                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {

                        amount = DbCoa.getCoaBalanceCD(coa.getOID(), whereMd, p,whereLoc);

                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();
                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), whereMd, p, whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalance(coax.getOID(), whereMd, p,whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), whereMd, p,whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), whereMd, p,whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), whereMd, p,whereLoc);
                                }
                            }

                            amount = totalIncome;
                        }
                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalance(coa.getOID(), whereMd, p, whereLoc);
                    }
                }
            }
            
        }

        return result;
    }
    
    
    public static double getIsCoaBalanceByHeader(long coaId, String type, String whereMd,Periode p, String whereLoc){

        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();
        
        listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID]+" = '" + coaId + "'", DbCoa.colNames[DbCoa.COL_CODE]);

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {

                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {

                        amount = DbCoa.getCoaBalanceCD(coa.getOID(), whereMd, p, whereLoc);

                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();
                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), whereMd, p, whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalance(coax.getOID(), whereMd, p,whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), whereMd, p,whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), whereMd, p, whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), whereMd, p,whereLoc);
                                }
                            }

                            amount = totalIncome;
                        }
                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalance(coa.getOID(), whereMd, p, whereLoc);
                    }
                }
                
                if(result != 0){
                    return result;
                }
            }
        }

        return result;
    }
    
    public static double getIsCoaBalanceByHeaderMTD(long coaId, String type, String whereMd,Periode p){

        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();
        
        listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID]+" = '" + coaId + "'", DbCoa.colNames[DbCoa.COL_CODE]);

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {

                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {

                        amount = DbCoa.getCoaBalanceCDMTD(coa.getOID(), whereMd, p);

                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();
                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCDMTD(coax.getOID(), whereMd, p);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceMTD(coax.getOID(), whereMd, p);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalanceMTD(coax.getOID(), whereMd, p);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCDMTD(coax.getOID(), whereMd, p);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalanceMTD(coax.getOID(), whereMd, p);
                                }
                            }

                            amount = totalIncome;
                        }
                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalanceMTD(coa.getOID(), whereMd, p);
                    }
                }
                
                if(result != 0){
                    return result;
                }
            }
        }

        return result;
    }
    
    
    public static double getIsCoaBalanceByHeader(long coaId, String type, String whereMd,Vector p, String whereLoc){

        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {

                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {

                        amount = DbCoa.getCoaBalanceCD(coa.getOID(), p, whereMd, whereLoc);

                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();
                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), p, whereMd, whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalance(coax.getOID(), p, whereMd,whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), p, whereMd,whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(),p, whereMd,whereLoc);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(),p, whereMd,whereLoc);
                                }
                            }

                            amount = totalIncome;
                        }
                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalance(coa.getOID(), p, whereMd, whereLoc);
                    }
                }
                
                if(result != 0){
                    return result;
                }
            }
        }

        return result;
    }
    
    
    public static double getIsCoaBalanceByHeaderMTD(long coaId, String type, String whereMd,Vector p){

        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {

                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {

                        amount = DbCoa.getCoaBalanceMTDCD(coa.getOID(), p, whereMd);

                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();
                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceMTDCD(coax.getOID(), p, whereMd);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceMTD2(coax.getOID(), p, whereMd);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalanceMTD2(coax.getOID(), p, whereMd);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceMTDCD(coax.getOID(),p, whereMd);
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalanceMTD2(coax.getOID(),p, whereMd);
                                }
                            }

                            amount = totalIncome;
                        }
                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalanceMTD2(coa.getOID(), p, whereMd);
                    }
                }
                
                if(result != 0){
                    return result;
                }
            }
        }

        return result;
    }
    /**
     * @Author  Roy Andika
     * @Desc    Untuk mendapatkan Coa Balance Last Year
     * @param   coaId
     * @param   type
     * @return
     */
    public static double getCoaBalanceByHeaderLastYear(long coaId, String type) {

        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {
                        amount = DbCoa.getCoaBalanceCD(coa.getOID());

                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();

                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCDLastYear(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceLastYear(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalanceLastYear(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCDLastYear(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalanceLastYear(coax.getOID());
                                }
                            }

                            amount = totalIncome;

                        }

                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalanceLastYear(coa.getOID());
                    }
                }
            }
        }

        return result;
    }

    public static double getCoaBalanceByHeader(long coaId, String type, int accClass) {
        
        double result = 0;
        double amount = 0;

        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);

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
                    //jika bukan header lakukan penghitungan
                    if (!coa.getStatus().equals("HEADER")) {
                        if (type.equals("CD")) {
                            amount = DbCoa.getCoaBalanceCD(coa.getOID());
                            //Retained Earnings
                            if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                                double totalIncome = 0;
                                Coa coax = new Coa();
                                for (int ix = 0; ix < listCoa.size(); ix++) {
                                    coax = (Coa) listCoa.get(ix);
                                    if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                        totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                        totalIncome = totalIncome + DbCoa.getCoaBalance(coax.getOID());
                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                        totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                        totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                        totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                    }
                                }
                                amount = totalIncome;
                            }
                            // Bagining Balance                        
                            if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE"))) {
                                amount = DbCoaOpeningBalance.getSumOpeningBalance();
                            }

                            result = result + amount;
                        } else {
                            result = result + DbCoa.getCoaBalance(coa.getOID());
                        }
                    }
                }
            }
        }

        return result;
    }

    public static double getCoaBalanceByHeaderPrevYear(long coaId, String type) {

        double result = 0;
        double amount = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {

            for (int i = 0; i < listCoa.size(); i++) {

                coa = (Coa) listCoa.get(i);

                if (!coa.getStatus().equals("HEADER")) {

                    if (type.equals("CD")) {
                        amount = DbCoa.getCoaBalanceCDPrevYear(coa.getOID());
                        //Retained Earnings
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                            double totalIncome = 0;
                            Coa coax = new Coa();
                            for (int ix = 0; ix < listCoa.size(); ix++) {
                                coax = (Coa) listCoa.get(ix);
                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCDPrevYear(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalancePrevYear(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalancePrevYear(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCDPrevYear(coax.getOID());
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalancePrevYear(coax.getOID());
                                }
                            }
                            amount = totalIncome;
                        }
                        // Bagining Balance                        
                        if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE"))) {
                            amount = DbCoaOpeningBalance.getSumOpeningBalancePrevYear();
                        }

                        result = result + amount;
                    } else {
                        result = result + DbCoa.getCoaBalancePrevYear(coa.getOID());
                    }
                }

            }
        }

        return result;
    }

    public static double getCoaBalanceByHeaderPrevYear(long coaId, String type, int accClass) {

        double result = 0;
        double amount = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);

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

                    if (!coa.getStatus().equals("HEADER")) {

                        if (type.equals("CD")) {
                            amount = DbCoa.getCoaBalanceCDPrevYear(coa.getOID());
                            //Retained Earnings
                            if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                                double totalIncome = 0;
                                Coa coax = new Coa();
                                for (int ix = 0; ix < listCoa.size(); ix++) {
                                    coax = (Coa) listCoa.get(ix);
                                    if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                        totalIncome = totalIncome + DbCoa.getCoaBalanceCDPrevYear(coax.getOID());
                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                        totalIncome = totalIncome + DbCoa.getCoaBalancePrevYear(coax.getOID());
                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                        totalIncome = totalIncome - DbCoa.getCoaBalancePrevYear(coax.getOID());
                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                        totalIncome = totalIncome + DbCoa.getCoaBalanceCDPrevYear(coax.getOID());
                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                        totalIncome = totalIncome - DbCoa.getCoaBalancePrevYear(coax.getOID());
                                    }
                                }
                                amount = totalIncome;
                            }
                            // Bagining Balance                        
                            if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE"))) {
                                amount = DbCoaOpeningBalance.getSumOpeningBalancePrevYear();
                            }

                            result = result + amount;
                        } else {
                            result = result + DbCoa.getCoaBalancePrevYear(coa.getOID());
                        }
                    }
                }
            }
        }

        return result;
    }

    public static double getCoaBalanceByHeader(long coaId, String type, Vector periods) {
        double result = 0;
        double amount = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);

                if (type.equals("CD")) {

                    amount = amount + DbCoa.getCoaBalanceCD(coa.getOID(), periods);

                    //Retained Earnings
                    if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                        double totalIncome = 0;
                        Coa coax = new Coa();
                        for (int ix = 0; ix < listCoa.size(); ix++) {
                            coax = (Coa) listCoa.get(ix);
                            if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), periods);
                            } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                totalIncome = totalIncome + DbCoa.getCoaBalance(coax.getOID(), periods);
                            } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), periods);
                            } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), periods);
                            } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), periods);
                            }
                        }
                        amount = totalIncome;
                    }

                    // Bagining Balance                        
                    if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE"))) {
                        amount = DbCoaOpeningBalance.getSumOpeningBalance();
                    }

                    result = result + amount;

                } else {
                    result = result + DbCoa.getCoaBalance(coa.getOID(), periods);
                }

            }
        }

        return result;
    }

    public static double getCoaBalanceByHeader(long coaId, String type, Vector periods, String whereMd) {

        double result = 0;
        double amount = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();

        listCoa = DbCoa.list(0, 0, "acc_ref_id='" + coaId + "'", "code");

        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);

                if (type.equals("CD")) {

                    amount = amount + DbCoa.getCoaBalanceCD(coa.getOID(), periods, whereMd);

                    //Retained Earnings
                    if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                        double totalIncome = 0;
                        Coa coax = new Coa();
                        for (int ix = 0; ix < listCoa.size(); ix++) {
                            coax = (Coa) listCoa.get(ix);
                            if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), periods, whereMd);
                            } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                totalIncome = totalIncome + DbCoa.getCoaBalance(coax.getOID(), periods, whereMd);
                            } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), periods, whereMd);
                            } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID(), periods, whereMd);
                            } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID(), periods, whereMd);
                            }
                        }
                        amount = totalIncome;
                    }

                    // Bagining Balance                        
                    if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE"))) {
                        amount = DbGlDetail.getSumOpeningBalance(whereMd);
                    }

                    result = result + amount;

                } else {
                    result = result + DbCoa.getCoaBalance(coa.getOID(), periods, whereMd);
                }
            }
        }

        return result;
    }

    public static double getCoaBalance(long coaId) {
        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        //run query
        try {
            String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                    " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalance(long coaId, String whereSd) {

        double result = 0;
        CONResultSet crs = null;

        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        try {

            String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbGlDetail.getOpeningBalance(p, coaId, whereSd) + result;

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    public static double getCoaBalance(long coaId, String whereSd,long periodeId) {

        double result = 0;
        CONResultSet crs = null;

        Periode p = new Periode();
        try {
            p = DbPeriode.fetchExc(periodeId);
        } catch (Exception e) {
            System.out.println(e);
        }

        try {

            String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodeId;

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbGlDetail.getOpeningBalance(p, coaId, whereSd) + result;

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    
    public static double getCoaBalance(long coaId, String whereSd,Periode p, String whereLoc) {

        double result = 0;
        CONResultSet crs = null;

        try {

            String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
            
            result = DbCoaOpeningBalanceLocation.getOpeningBalance(p, coaId, whereLoc) + result; 

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
    
    public static double getCoaBalanceMTD(long coaId, String whereSd,Periode p) {

        double result = 0;
        CONResultSet crs = null;

        try {

            String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

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

    /**
     * @Author  Roy Andika
     * @Desc    Untuk mendapatkan ammount untuk tahun lalu
     * @param   coaId
     * @return
     */
    public static double getCoaBalanceLastYear(long coaId) {

        double result = 0;
        CONResultSet crs = null;

        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        Periode pLastYear = new Periode();

        try {
            if (p.getOID() != 0) {

                if (p.getStartDate() != null) {

                    int previousYear = p.getStartDate().getYear() + 1900 - 1;
                    int month = p.getStartDate().getMonth() + 1;
                    int date = p.getStartDate().getDate();
                    String strPreviousYear = "" + previousYear + "-" + month + "-" + date;
                    String wherePreviousperiod = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " = '" + strPreviousYear + "'";
                    Vector listPrevPeriode = DbPeriode.list(0, 0, wherePreviousperiod, null);

                    if (listPrevPeriode != null && listPrevPeriode.size() > 0) {
                        pLastYear = (Periode) listPrevPeriode.get(0);
                    } else {
                        pLastYear = null;
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        try {

            if (pLastYear != null && pLastYear.getOID() != 0) {

                String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ") - sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + pLastYear.getOID();

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } else {
                result = 0;
            }

            result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalanceRecursif(Coa coa) {
        double result = 0;

        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        if (coa.getStatus().equals("HEADER")) {
            Vector v = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (v != null && v.size() > 0) {
                for (int i = 0; i < v.size(); i++) {
                    Coa cx = (Coa) v.get(i);
                    result = result + getCoaBalanceRecursif(cx);
                }
            }
        } else {
            result = result + getCoaBalance(coa.getOID());
        }

        return result;
    }

    public static double getCoaBalancePrevYear(long coaId) {

        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        Date dt = new Date();
        try {
            p = DbPeriode.getOpenPeriod();
            dt = p.getStartDate();
            dt.setYear(dt.getYear() - 1);//set tahun lalu
            //dt.setMonth(11);//set bulan desember                
            //dt.setDate(15);//set pertengahan bulan

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

            //run query
            try {
                String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }

                result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }

    //untuk menghitung current year balance
    //untuk multiple balance sheet
    public static double getCYEarningCoaBalance(long coaId, Periode p) {
        double result = 0;
        CONResultSet crs = null;

        //run query
        try {
            String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                    " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    //untuk keperluan multiple period balance sheet
    public static double getCoaBalance(long coaId, Periode periode) {
        double result = 0;
        CONResultSet crs = null;

        //jika merupakan period open,
        //ambil seperti yang balance sheet standard
        if (periode.getStatus().equals(I_Project.STATUS_PERIOD_OPEN)) {
            result = getCoaBalance(coaId);
        } //jika tidak, ambil langsung pada coa opening balance
        else {
            String where = "to_days(" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + ")>to_days('" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "')";
            String order = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " asc";

            Vector v = new Vector();
            v = DbPeriode.list(0, 1, where, order);
            Periode abcPeriode = (Periode) v.get(0);

            java.util.Date currentStart = periode.getStartDate();
            Company company = DbCompany.getCompany();
            if (company.getEndFiscalMonth() == currentStart.getMonth()) {
                try {
                    Coa coa = DbCoa.fetchExc(coaId);
                    if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING"))) {
                        abcPeriode = periode;
                    }
                } catch (Exception e) {

                }
            }

            where = DbCoaOpeningBalance.colNames[DbCoaOpeningBalance.FLD_COA_ID] + "=" + coaId +
                    " and " + DbCoaOpeningBalance.colNames[DbCoaOpeningBalance.FLD_PERIODE_ID] + "=" + abcPeriode.getOID();

            v = new Vector();
            v = DbCoaOpeningBalance.list(0, 0, where, null);
            CoaOpeningBalance cob = (CoaOpeningBalance) v.get(0);

            result = cob.getOpeningBalance();

        }

        return result;

    }

    public static double getCoaBalance(long coaId, Vector periods) {
        double result = 0;

        for (int i = 0; i < periods.size(); i++) {

            //get open period id
            Periode p = (Periode) periods.get(i);

            CONResultSet crs = null;

            //run query
            try {
                String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = result + rs.getDouble(1);
                }

                result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }
    
    public static double getCoaBalance(long coaId, Vector periods,String whereSd,String whereLocation) {
        double result = 0;

        for (int i = 0; i < periods.size(); i++) {
            
            Periode p = (Periode) periods.get(i);
            CONResultSet crs = null;
            try {
                String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
                
                if (whereSd.length() > 0) {
                    sql = sql + " and " + whereSd;
                }

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = result + rs.getDouble(1);
                }

                result = DbCoaOpeningBalanceLocation.getOpeningBalance(p, coaId, whereLocation) + result;   
                
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }
    
    
    public static double getCoaBalanceMTD(long coaId, Vector periods,String whereSd) {
        double result = 0;

        for (int i = 0; i < periods.size(); i++) {
            
            Periode p = (Periode) periods.get(i);
            CONResultSet crs = null;
            try {
                String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
                
                if (whereSd.length() > 0) {
                    sql = sql + " and " + whereSd;
                }

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = result + rs.getDouble(1);
                }
                
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }
    
    public static double getCoaBalanceMTD2(long coaId, Vector periods,String whereSd) {
        double result = 0;

        for (int i = 0; i < periods.size(); i++) {
            
            Periode p = (Periode) periods.get(i);
            CONResultSet crs = null;
            try {
                String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
                
                if (whereSd.length() > 0) {
                    sql = sql + " and " + whereSd;
                }

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = result + rs.getDouble(1);
                }
                
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }

    public static double getCoaBalanceCD(long coaId) {
        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        try {
            String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                    " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalanceCD(long coaId, String whereSd) {

        double result = 0;
        CONResultSet crs = null;

        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        try {

            String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbGlDetail.getOpeningBalancePrevious(p, coaId, whereSd) + result;

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
    
    
     public static double getCoaBalanceCD(long coaId, String whereSd,long periodId){

        double result = 0;
        CONResultSet crs = null;
        Periode periode = new Periode();
        try{
            periode = DbPeriode.fetchExc(periodId);
        }catch(Exception e){}

        try {

            String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId;

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbGlDetail.getOpeningBalancePrevious(periode, coaId, whereSd) + result;

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
     
     public static double getCoaBalanceCD(long coaId, String whereSd,Periode periode,String whereLoc){

        double result = 0;
        CONResultSet crs = null;

        try {

            String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periode.getOID();

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalanceLocation.getOpeningBalance(periode, coaId, whereLoc) + result;            

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
     
     public static double getCoaBalanceCDMTD(long coaId, String whereSd,Periode periode){

        double result = 0;
        CONResultSet crs = null;

        try {

            String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periode.getOID();

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

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
     
     
     public static double getCoaBalancePNL(long coaId, String whereSd,Periode periode,String type){

        double result = 0;
        CONResultSet crs = null;

        try {
            
            String sql = "";
            
            if(type.equals("CD")){
                sql = sql +" select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) ";
            }else{
                sql = sql +" select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) ";
            }

            sql = sql +" from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periode.getOID()+" and gl."+DbGl.colNames[DbGl.COL_POSTED_STATUS]+" = 1 ";

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

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
     
     
     public static double getCoaBalancePNLYTD(long coaId, String whereSd,Periode p,String whereLoc, String type){

        double result = 0;
        CONResultSet crs = null;

        try {
            
            String sql = "";
            
            if (type.equals("DC")) {

                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            } else {

                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            }

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalanceLocation.getOpeningBalance(p, coaId, whereLoc) + result;            

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
     
     public static double getCoaBalancePNLYTDMTD(long coaId, String whereSd,Periode p,String whereLoc, String type){

        double result = 0;
        CONResultSet crs = null;

        try {
            
            String sql = "";            
            if (type.equals("DC")) {

                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            } else {

                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            }

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalanceLocation.getOpeningBalance(p, coaId, whereLoc) + result;            

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
     
     public static double getCoaBalancePNLMTD(long coaId, String whereSd,Periode p, String type){

        double result = 0;
        CONResultSet crs = null;
        try {
            
            String sql = "";            
            if (type.equals("DC")) {

                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            } else {

                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            }
            

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

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
     
     
     public static double getCoaBalanceCD(long coaId, String whereSd, Periode periode){
        double result = 0;
        CONResultSet crs = null;
        try {

            String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periode.getOID();

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalanceLocation.getOpeningBalance(periode, coaId) + result;

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }
     
     
     public static double getCoaBalancePNLMTD(Coa coa, String whereSd, Periode periode,String type){   
        
        double result = 0;        
        CONResultSet crs = null;
        
        try {
            
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) ";
            }else{
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) ";
            }        
            
            sql = sql + " from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where "+
                    " gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periode.getOID()+" and gl."+DbGl.colNames[DbGl.COL_POSTED_STATUS]+" = 1 ";
            
            if(coa.getLevel() == 1){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 2){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 3){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 4){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 5){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 6){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 7){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID]+" = "+coa.getOID();
            }
            
            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }
            
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
     
     public static String getStrPeriod(Periode periode){
         String str = "";
         CONResultSet crs = null;
         try{
            int year = periode.getEndDate().getYear()+1900;
            String sql  = "Select "+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" from "+DbPeriode.DB_PERIODE+" where year("+DbPeriode.colNames[DbPeriode.COL_END_DATE]+") = "+year+" and to_days("+DbPeriode.colNames[DbPeriode.COL_END_DATE]+") <= to_days('"+JSPFormater.formatDate(periode.getEndDate(),"yyyy-MM-dd")+"') ";
             
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                if(str != null && str.length() > 0){
                    str = str+",";
                }
                str = str+ rs.getLong(DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]);
            }
            
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return str;
     }
     
     public static double getCoaBalancePNLYTD(Coa coa, String whereSd, Periode periode,String type){   
        
        double result = 0;        
        CONResultSet crs = null;
        String strPeriode = getStrPeriod(periode);
        
        try {
            
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) ";
            }else{
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) ";
            }        
            
            sql = sql + " from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                    " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where "+
                    " gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " in (" + strPeriode +") and gl."+DbGl.colNames[DbGl.COL_POSTED_STATUS]+" = 1 ";
            
            if(coa.getLevel() == 1){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL1_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 2){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL2_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 3){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL3_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 4){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL4_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 5){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL5_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 6){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL6_ID]+" = "+coa.getOID();
            }else if(coa.getLevel() == 7){
                sql = sql + " and gd."+DbGlDetail.colNames[DbGlDetail.COL_COA_LEVEL7_ID]+" = "+coa.getOID();
            }
            
            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }
            
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

    /** 
     * @author  Roy Andika
     * @param   coaId
     * @return
     */
    public static double getCoaBalanceCDLastYear(long coaId) {

        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        Periode pLastYear = new Periode();

        try {

            if (p.getOID() != 0) {

                if (p.getStartDate() != null) {

                    int previousYear = p.getStartDate().getYear() + 1900 - 1;
                    int month = p.getStartDate().getMonth() + 1;
                    int date = p.getStartDate().getDate();
                    String strPreviousYear = "" + previousYear + "-" + month + "-" + date;
                    String wherePreviousperiod = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " = '" + strPreviousYear + "'";
                    Vector listPrevPeriode = DbPeriode.list(0, 0, wherePreviousperiod, null);

                    if (listPrevPeriode != null && listPrevPeriode.size() > 0) {
                        pLastYear = (Periode) listPrevPeriode.get(0);
                    } else {
                        pLastYear = null;
                    }
                }

            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        //run query
        try {

            if (pLastYear != null && pLastYear.getOID() != 0) {

                String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + pLastYear.getOID();

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    result = rs.getDouble(1);
                }

            } else {
                result = 0;
            }

            result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    /** 
     * @author  Roy Andika
     * @Description Untuk mendapatkan balance realisasi sampai bulan tertentu
     * @param   coaId
     * @return
     */
    public static double getCoaBalanceToPeriode(Periode periode, long coaId) {

        int yearP = periode.getStartDate().getYear() + 1900;
        int monthP = periode.getStartDate().getMonth() + 1;

        String wherePeriode = " YEAR(" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + ") = " + yearP + " AND " +
                " MONTH(" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + ") <= " + monthP;

        Vector vList = DbPeriode.list(0, 0, wherePeriode, null);

        double total = 0;
        CONResultSet crs = null;

        if (vList != null && vList.size() > 0) {

            for (int x = 0; x < vList.size(); x++) {

                Periode objPeriode = (Periode) vList.get(x);

                try {

                    String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                            " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                            " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + objPeriode.getOID();

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    double tmpResult = 0;

                    while (rs.next()) {
                        tmpResult = rs.getDouble(1);
                    }

                    total = total + tmpResult + DbCoaOpeningBalance.getOpeningBalance(objPeriode, coaId);


                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                } finally {
                    CONResultSet.close(crs);
                }

            }

        }

        return total;

    }

    public static double getCoaBalanceCDRecursif(Coa coa) {

        double result = 0;

        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        if (coa.getStatus().equals("HEADER")) {

            Vector v = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (v != null && v.size() > 0) {
                for (int i = 0; i < v.size(); i++) {
                    Coa cx = (Coa) v.get(i);
                    result = result + getCoaBalanceCDRecursif(cx);
                }
            }

        } else {
            result = result + getCoaBalanceCD(coa.getOID());
        }

        return result;
    }

    public static double getCoaBalanceYTD(long coaId, long periodId, String strType) {

        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.fetchExc(periodId);//DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        Date endDate = new Date();//p.getEndDate();
        Date startDate = p.getStartDate();
        startDate.setMonth(0);
        startDate.setDate(1);

        //ambil periode yang kena dari jan sampe terakhir
        Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_START_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(p.getEndDate(), "yyyy-MM-dd") + "'", "");
        String periodeWhere = "(";
        if (periods != null && periods.size() > 0) {
            for (int i = 0; i < periods.size(); i++) {
                Periode per = (Periode) periods.get(i);
                periodeWhere = periodeWhere + "gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + per.getOID() + " or ";
            }
            periodeWhere = periodeWhere.substring(0, periodeWhere.length() - 3) + ")";
        }

        //run query
        try {
            String sql = "";

            //income & other income
            if (strType.equals("CD")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and " + periodeWhere;
            //" and (gl."+DbGl.colNames[DbGl.COL_TRANS_DATE]+" between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
            //" and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";                        
            } //else
            else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and " + periodeWhere;
            //" and (gl."+DbGl.colNames[DbGl.COL_TRANS_DATE]+" between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
            //" and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

        //result = DbCoaOpeningBalance.getOpeningBalance(p, coaId)  + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalanceYTDRecursif(Coa coa, Periode periode, String strType) {

        double result = 0;

        CONResultSet crs = null;

        if (coa.getStatus().equals("HEADER")) {

            Vector v = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (v != null && v.size() > 0) {
                for (int i = 0; i < v.size(); i++) {
                    Coa cx = (Coa) v.get(i);
                    result = result + getCoaBalanceYTDRecursif(cx, periode, strType);
                }
            }

        } else {
            result = result + getCoaBalanceYTD(coa.getOID(), periode.getOID(), strType);
        }

        return result;
    }

    public static double getCoaBalanceMTD(long coaId, long periodId, String strType) {

        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.fetchExc(periodId);//DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        Date endDate = new Date();//p.getEndDate();
        Date startDate = p.getStartDate();

        //run query
        try {
            String sql = "";

            //income & other income
            if (strType.equals("CD")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            //" and (gl."+DbGl.colNames[DbGl.COL_TRANS_DATE]+" between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
            //" and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
            } //else
            else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            //" and (gl."+DbGl.colNames[DbGl.COL_TRANS_DATE]+" between '"+JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"'"+
            //" and '"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

        //result = DbCoaOpeningBalance.getOpeningBalance(p, coaId)  + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalanceMTDRecursif(Coa coa, Periode periode, String strType) {

        double result = 0;

        CONResultSet crs = null;

        if (coa.getStatus().equals("HEADER")) {

            Vector v = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (v != null && v.size() > 0) {
                for (int i = 0; i < v.size(); i++) {
                    Coa cx = (Coa) v.get(i);
                    result = result + getCoaBalanceMTDRecursif(cx, periode, strType);
                }
            }

        } else {
            result = result + getCoaBalanceMTD(coa.getOID(), periode.getOID(), strType);
        }

        return result;
    }

    public static double getCoaBalanceCDByClass(long coaId) {
        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }        

        //run query
        try {
            String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                    " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalanceCDPrevYear(long coaId) {
        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        Date dt = new Date();
        try {
            p = DbPeriode.getOpenPeriod();
            dt = p.getStartDate();
            dt.setYear(dt.getYear() - 1);//set tahun lalu
            //dt.setMonth(11);//set bulan desember                
            //dt.setDate(15);//set pertengahan bulan

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
            //run query
            try {
                String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }

                result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }

    //u multiple bs
    public static double getCYEarningCoaBalanceCD(long coaId, Periode p) {
        double result = 0;
        CONResultSet crs = null;

        //run query
        try {
            String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                    " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                    " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    //untuk keperluan multiple period balance sheet
    public static double getCoaBalanceCD(long coaId, Periode periode) {
        double result = 0;
        CONResultSet crs = null;

        //jika merupakan period open,
        //ambil seperti yang balance sheet standard
        if (periode.getStatus().equals(I_Project.STATUS_PERIOD_OPEN)) {
            result = getCoaBalanceCD(coaId);
        } //jika tidak, ambil langsung pada coa opening balance
        else {
            //jika desember maka pakai periode desember
            //jika tidak pke periode bulan selanjutnya
            String where = "to_days(" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + ")>to_days('" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "')";
            String order = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " asc";

            Vector v = new Vector();
            v = DbPeriode.list(0, 1, where, order);
            Periode abcPeriode = (Periode) v.get(0);

            java.util.Date currentStart = periode.getStartDate();
            Company company = DbCompany.getCompany();
            if (company.getEndFiscalMonth() == currentStart.getMonth()) {
                try {
                    Coa coa = DbCoa.fetchExc(coaId);
                    if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING"))) {
                        abcPeriode = periode;
                    }
                } catch (Exception e) {

                }
            }

            where = DbCoaOpeningBalance.colNames[DbCoaOpeningBalance.FLD_COA_ID] + "=" + coaId +
                    " and " + DbCoaOpeningBalance.colNames[DbCoaOpeningBalance.FLD_PERIODE_ID] + "=" + abcPeriode.getOID();

            v = new Vector();
            v = DbCoaOpeningBalance.list(0, 0, where, null);
            CoaOpeningBalance cob = (CoaOpeningBalance) v.get(0);

            result = cob.getOpeningBalance();

        }

        return result;

    }

    public static double getCoaBalanceCD(long coaId, Vector periods) {

        double result = 0;

        for (int i = 0; i < periods.size(); i++) {

            //get open period id
            Periode p = (Periode) periods.get(i);

            CONResultSet crs = null;

            //run query
            try {
                String sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = result + rs.getDouble(1);
                }

                result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }

    public static double getCoaBalanceCD(long coaId, Vector periods, String whereSd) {

        double result = 0;

        for (int i = 0; i < periods.size(); i++) {

            Periode p = (Periode) periods.get(i);
            CONResultSet crs = null;

            try {

                String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

                if (whereSd.length() > 0) {
                    sql = sql + " and " + whereSd;
                }

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    result = result + rs.getDouble(1);
                }
                
                result = DbGlDetail.getOpeningBalancePrevious(p, coaId, whereSd) + result;

            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }    
    
    public static double getCoaBalanceCD(long coaId, Vector periods, String whereSd,String whereLocation){

        double result = 0;

        for (int i = 0; i < periods.size(); i++) {

            Periode p = (Periode) periods.get(i);
            CONResultSet crs = null;

            try {

                String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

                if (whereSd.length() > 0) {
                    sql = sql + " and " + whereSd;
                }

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    result = result + rs.getDouble(1);
                }
                
                result = DbCoaOpeningBalanceLocation.getOpeningBalance(p, coaId, whereLocation) + result;   

            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }
    
    
    public static double getCoaBalanceMTDCD(long coaId, Vector periods, String whereSd){

        double result = 0;

        for (int i = 0; i < periods.size(); i++) {

            Periode p = (Periode) periods.get(i);
            CONResultSet crs = null;

            try {

                String sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();

                if (whereSd.length() > 0) {
                    sql = sql + " and " + whereSd;
                }

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                while (rs.next()) {
                    result = result + rs.getDouble(1);
                }

            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }

        return result;
    }

    public static double getCoaBalance(long coaId, long depId, String type) {
        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        //run query
        try {
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId;
            } else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId;
            }

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

    public static double getCoaBalance(long coaId, long depId, String type, String whereSd) {

        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        try {
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gd." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId;
            } else {
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gd." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId;
            }

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

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

    public static double getCoaBalance(long coaId, String type, String whereSd) {

        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        try {
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            } else {
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            }

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

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
    
    public static double getCoaBalance(long coaId, String type, String whereSd, long periodeId) {

        double result = 0;
        CONResultSet crs = null;

        try {
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodeId;
            } else {
                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodeId;
            }

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

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

    public static double getPnlBalance(long coaId, long depId, String type, Date startDate, Date endDate) {
        double result = 0;
        CONResultSet crs = null;

        //run query
        try {
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and (gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                        " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";

                if (depId != 0) {
                    sql = sql + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId;
                }
            } else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and (gl." + DbGl.colNames[DbGl.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'" +
                        " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";

                if (depId != 0) {
                    sql = sql + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId;
                }
            //" and gld."+DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID]+"="+depId;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

        //result = DbCoaOpeningBalance.getOpeningBalance(p, coaId)  + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalance(long coaId, long depId, long secId, String type) {
        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        //run query
        try {
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] + "=" + secId;
            } else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] + "=" + secId;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

        //result = DbCoaOpeningBalance.getOpeningBalance(p, coaId)  + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalance(long coaId, long depId, long secId, long subSecId, String type) {
        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        //run query
        try {
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] + "=" + secId +
                        " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] + "=" + subSecId;
            } else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] + "=" + secId +
                        " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] + "=" + subSecId;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

        //result = DbCoaOpeningBalance.getOpeningBalance(p, coaId)  + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalance(long coaId, long depId, long secId, long subSecId, long jobId, String type) {
        double result = 0;
        CONResultSet crs = null;

        //get open period id
        Periode p = new Periode();
        try {
            p = DbPeriode.getOpenPeriod();
        } catch (Exception e) {
            System.out.println(e);
        }

        //run query
        try {
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] + "=" + secId +
                        " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] + "=" + subSecId + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_JOB_ID] + "=" + jobId;
            } else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depId + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SECTION_ID] + "=" + secId +
                        " and gld." + DbGlDetail.colNames[DbGlDetail.COL_SUB_SECTION_ID] + "=" + subSecId + " and gld." + DbGlDetail.colNames[DbGlDetail.COL_JOB_ID] + "=" + jobId;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

        //result = DbCoaOpeningBalance.getOpeningBalance(p, coaId)  + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    public static double getCoaBalance(Vector listCoa, String accGroup, String type, long depId) {
        double result = 0;
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);
                if (coa.getAccountGroup().equals(accGroup)) {
                    double amount = 0;
                    if (type.equals("DC")) {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, type);
                    } else {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, type);
                    }

                    result = result + amount;
                }
            }
        }
        return result;
    }

    public static double getCoaBalance(Vector listCoa, String accGroup, String type) {
        double result = 0;
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);
                if (coa.getAccountGroup().equals(accGroup)) {
                    double amount = 0;
                    if (type.equals("DC")) {
                        amount = DbCoa.getCoaBalance(coa.getOID(), type);
                    } else {
                        amount = DbCoa.getCoaBalance(coa.getOID(), type);
                    }

                    result = result + amount;
                }
            }
        }
        return result;
    }

    public static double getCoaBalance(Vector listCoa, String accGroup, String type, long depId, String whereSd) {
        double result = 0;
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);
                if (coa.getAccountGroup().equals(accGroup)) {
                    double amount = 0;
                    if (type.equals("DC")) {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, type, whereSd);
                    } else {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, type, whereSd);
                    }
                    result = result + amount;
                }
            }
        }
        return result;
    }

    public static double getCoaBalance(Vector listCoa, String accGroup, String type, String whereSd) {
        double result = 0;
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);
                if (coa.getAccountGroup().equals(accGroup)) {
                    double amount = 0;
                    if (type.equals("DC")) {
                        amount = DbCoa.getCoaBalance(coa.getOID(), type, whereSd);
                    } else {
                        amount = DbCoa.getCoaBalance(coa.getOID(), type, whereSd);
                    }
                    result = result + amount;
                }
            }
        }
        return result;
    }
    
    public static double getCoaBalance(Vector listCoa, String accGroup, String type, String whereSd, long periodeId) {
        double result = 0;
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);
                if (coa.getAccountGroup().equals(accGroup)) {
                    double amount = 0;
                    if (type.equals("DC")) {
                        amount = DbCoa.getCoaBalance(coa.getOID(), type, whereSd,periodeId);
                    } else {
                        amount = DbCoa.getCoaBalance(coa.getOID(), type, whereSd,periodeId);
                    }
                    result = result + amount;
                }
            }
        }
        return result;
    }

    public static double getPnlBalance(Vector listCoa, String accGroup, String type, long depId, Date startDate, Date endDate) {
        double result = 0;
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);
                if (coa.getAccountGroup().equals(accGroup)) {
                    double amount = 0;
                    if (type.equals("DC")) {
                        amount = DbCoa.getPnlBalance(coa.getOID(), depId, type, startDate, endDate);
                    } else {
                        amount = DbCoa.getPnlBalance(coa.getOID(), depId, type, startDate, endDate);
                    }

                    result = result + amount;
                }
            }
        }
        return result;
    }

    public static double getCoaBalance(Vector listCoa, String accGroup, String type, long depId, long secId) {
        double result = 0;
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);
                if (coa.getAccountGroup().equals(accGroup)) {
                    double amount = 0;
                    if (type.equals("DC")) {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, secId, type);
                    } else {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, secId, type);
                    }

                    result = result + amount;
                }
            }
        }
        return result;
    }

    public static double getCoaBalance(Vector listCoa, String accGroup, String type, long depId, long secId, long subSecId) {
        double result = 0;
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);
                if (coa.getAccountGroup().equals(accGroup)) {
                    double amount = 0;
                    if (type.equals("DC")) {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, secId, subSecId, type);
                    } else {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, secId, subSecId, type);
                    }

                    result = result + amount;
                }
            }
        }
        return result;
    }

    public static double getCoaBalance(Vector listCoa, String accGroup, String type, long depId, long secId, long subSecId, long jobId) {
        double result = 0;
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);
                if (coa.getAccountGroup().equals(accGroup)) {
                    double amount = 0;
                    if (type.equals("DC")) {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, secId, subSecId, jobId, type);
                    } else {
                        amount = DbCoa.getCoaBalance(coa.getOID(), depId, secId, subSecId, jobId, type);
                    }

                    result = result + amount;
                }
            }
        }
        return result;
    }

    //ambil total transaksi + ditambah dengan opening balance
    public static double getCoaBalanceClosing(long coaId, Periode p, boolean isYearlyClosing, String type) {
        double result = 0;
        CONResultSet crs = null;

        //run query
        try {
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            } else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }

            result = DbCoaOpeningBalance.getOpeningBalance(p, coaId) + result;
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }

    //lakukan looping untuk menghitung saldo masing-masing account,
    //me-reset p&l dan mengeset opening balance pada periode baru.
    public static void getOpeningBalanceClosing(Periode preClosedPeriod, boolean isYearlyClosing) {

        Periode newPeriod = DbPeriode.getOpenPeriod();

        String where = colNames[COL_STATUS] + "='POSTABLE'";
        if (isYearlyClosing) {
            where = where + " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_REVENUE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_COST_OF_SALES + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_EXPENSE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_REVENUE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_EXPENSE + "'";
        }

        Vector temp = DbCoa.list(0, 0, where, "");
        if (temp != null && temp.size() > 0) {

            Coa coaLabaBerjalan = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
            Coa coaLabaLalu = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

            for (int i = 0; i < temp.size(); i++) {
                Coa coa = (Coa) temp.get(i);

                if (coa.getOID() != coaLabaBerjalan.getOID() && coa.getOID() != coaLabaLalu.getOID()) {

                    double balance = DbGlDetail.getClosingBalance(coa.getOID(), preClosedPeriod);                    
                    if (balance != 0) {
                        DbCoaOpeningBalance.updateOpeningBalanceRecursif(coa.getOID(), balance, newPeriod.getOID());
                    }

                } //jika laba tahun lalu, lakukan tanpa rekursif
                else if (coa.getOID() == coaLabaLalu.getOID()) {
                    double balance = DbGlDetail.getClosingBalance(coa.getOID(), preClosedPeriod);

                    //jika closing tahunan, maka tambahkan dengan laba berjalan
                    if (isYearlyClosing) {
                        Coa coaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
                        double labaBerjalan = DbGlDetail.getClosingCurrentEarning(coaBerjalan.getOID(), preClosedPeriod);
                        balance = balance + labaBerjalan;
                    }

                    if (balance != 0) {
                        CoaOpeningBalance cob = new CoaOpeningBalance();
                        cob.setCoaId(coa.getOID());
                        cob.setOpeningBalance(balance);
                        cob.setPeriodeId(newPeriod.getOID());
                        try {
                            long oid = DbCoaOpeningBalance.insertExc(cob);
                        } catch (Exception e) {

                        }
                    }

                } //tahun berjalan
                else {

                    if (!isYearlyClosing) {
                        double balance = DbGlDetail.getClosingCurrentEarning(coa.getOID(), preClosedPeriod);

                        if (balance != 0) {
                            CoaOpeningBalance cob = new CoaOpeningBalance();
                            cob.setCoaId(coa.getOID());
                            cob.setOpeningBalance(balance);
                            cob.setPeriodeId(newPeriod.getOID());
                            try {
                                long oid = DbCoaOpeningBalance.insertExc(cob);
                            } catch (Exception e) {

                            }
                        }
                    }
                }
            }
        }
    }
    
    
    public static void getOpeningBalanceClosingBySegment(Periode preClosedPeriod, boolean isYearlyClosing,long segment1Id){

        Periode newPeriod = DbPeriode.getOpenPeriod();

        String where = colNames[COL_STATUS] + "='POSTABLE'";
        if (isYearlyClosing) {
            where = where + " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_REVENUE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_COST_OF_SALES + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_EXPENSE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_REVENUE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_EXPENSE + "'";
        }

        Vector temp = DbCoa.list(0, 0, where, "");
        
        Segment segment = new Segment();
        try{
            segment = DbSegment.fetchExc(segment1Id);
        }catch(Exception e){}
        
        Vector vSegmentDetail = new Vector();
       
        if(segment.getOID() != 0){
            String whereSD = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID]+" = "+segment.getOID();
            vSegmentDetail = DbSegmentDetail.list(0, 0, whereSD, null);
        }
        
        if (temp != null && temp.size() > 0 && vSegmentDetail != null && vSegmentDetail.size() > 0) {

            Coa coaLabaBerjalan = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
            Coa coaLabaLalu = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

            for (int i = 0; i < temp.size(); i++) {
                
                Coa coa = (Coa) temp.get(i);

                if (coa.getOID() != coaLabaBerjalan.getOID() && coa.getOID() != coaLabaLalu.getOID()) {

                    if(vSegmentDetail != null && vSegmentDetail.size() > 0){
                        for(int t = 0 ; t < vSegmentDetail.size() ; t++){
                            SegmentDetail sd = (SegmentDetail)vSegmentDetail.get(t);                            
                            double balance = DbGlDetail.getClosingBalance(coa.getOID(), preClosedPeriod,sd.getOID());                            
                            if (balance != 0) {                                
                                DbCoaOpeningBalanceLocation.updateOpeningBalanceRecursif(coa.getOID(), balance, newPeriod.getOID(),sd.getOID());
                            }                            
                        }
                    }
                } //jika laba tahun lalu, lakukan tanpa rekursif
                else if (coa.getOID() == coaLabaLalu.getOID()){
                   
                    if(vSegmentDetail != null && vSegmentDetail.size() > 0){
                        
                        for(int t = 0 ; t < vSegmentDetail.size() ; t++){
                            
                            SegmentDetail sd = (SegmentDetail)vSegmentDetail.get(t);                     
                            double balance = DbGlDetail.getClosingBalance(coa.getOID(), preClosedPeriod, sd.getOID());

                            //jika closing tahunan, maka tambahkan dengan laba berjalan
                            if (isYearlyClosing) {
                                Coa coaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
                                double labaBerjalan = DbGlDetail.getClosingCurrentEarning(coaBerjalan.getOID(), preClosedPeriod, sd.getOID());
                                balance = balance + labaBerjalan;
                            }

                            if (balance != 0) {
                                CoaOpeningBalanceLocation cob = new CoaOpeningBalanceLocation();
                                cob.setCoaId(coa.getOID());
                                cob.setOpeningBalance(balance);
                                cob.setPeriodeId(newPeriod.getOID());
                                cob.setSegment1Id(sd.getOID());
                                try {
                                    long oid = DbCoaOpeningBalanceLocation.insertExc(cob);
                                } catch (Exception e) {}
                            }
                        }
                     }
                } //tahun berjalan
                else {

                    if (!isYearlyClosing){
                        if(vSegmentDetail != null && vSegmentDetail.size() > 0){                        
                            for(int t = 0 ; t < vSegmentDetail.size() ; t++){
                                
                                SegmentDetail sd = (SegmentDetail)vSegmentDetail.get(t);                                 
                                double balance = DbGlDetail.getClosingCurrentEarning(coa.getOID(), preClosedPeriod, sd.getOID());

                                if (balance != 0) {
                                    CoaOpeningBalanceLocation cob = new CoaOpeningBalanceLocation();
                                    cob.setCoaId(coa.getOID());
                                    cob.setOpeningBalance(balance);
                                    cob.setPeriodeId(newPeriod.getOID());
                                    cob.setSegment1Id(sd.getOID());
                                    try {
                                        long oid = DbCoaOpeningBalanceLocation.insertExc(cob);
                                    } catch (Exception e) {}
                                }
                            }
                         }
                    }
                }
            }
        }
    }
    

    //untuk open periode 13 lakukan bukan yearly closing
    //lakukan looping untuk menghitung saldo masing-masing account,
    //tidak me-reset p&l dan mengeset opening balance pada periode baru.
    public static void getOpeningBalanceClosingFor13(Periode periode12, Periode periode13, boolean isYearlyClosing){

        String where = colNames[COL_STATUS] + "='POSTABLE'";
        if (isYearlyClosing) {
            where = where + " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_REVENUE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_COST_OF_SALES + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_EXPENSE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_REVENUE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_EXPENSE + "'";
        }

        Vector temp = DbCoa.list(0, 0, where, "");
        if (temp != null && temp.size() > 0) {

            Coa coaLabaBerjalan = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
            Coa coaLabaLalu = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

            for (int i = 0; i < temp.size(); i++) {
                Coa coa = (Coa) temp.get(i);

                if (coa.getOID() != coaLabaBerjalan.getOID() && coa.getOID() != coaLabaLalu.getOID()) {

                    double balance = DbGlDetail.getClosingBalance(coa.getOID(), periode12);
                    if (balance != 0) {
                        DbCoaOpeningBalance.updateOpeningBalanceRecursif(coa.getOID(), balance, periode13.getOID());
                    }

                } //jika laba tahun lalu, lakukan tanpa rekursif
                else if (coa.getOID() == coaLabaLalu.getOID()) {
                    double balance = DbGlDetail.getClosingBalance(coa.getOID(), periode12);

                    //jika closing tahunan, maka tambahkan dengan laba berjalan
                    if (isYearlyClosing) {
                        Coa coaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
                        double labaBerjalan = DbGlDetail.getClosingCurrentEarning(coaBerjalan.getOID(), periode12);
                        balance = balance + labaBerjalan;
                    }

                    if (balance != 0) {                        
                        CoaOpeningBalance cob = new CoaOpeningBalance();
                        cob.setCoaId(coa.getOID());
                        cob.setOpeningBalance(balance);
                        cob.setPeriodeId(periode13.getOID());
                        try {
                            long oid = DbCoaOpeningBalance.insertExc(cob);
                        } catch (Exception e) {

                        }
                    }

                } //tahun berjalan
                else {
                    if (!isYearlyClosing) {
                        double balance = DbGlDetail.getClosingCurrentEarning(coa.getOID(), periode12);

                        if (balance != 0) {
                            CoaOpeningBalance cob = new CoaOpeningBalance();
                            cob.setCoaId(coa.getOID());
                            cob.setOpeningBalance(balance);
                            cob.setPeriodeId(periode13.getOID());
                            try {
                                long oid = DbCoaOpeningBalance.insertExc(cob);
                            } catch (Exception e) {

                            }
                        }
                    }
                }
            }
        }
    }
    
    public static void getOpeningBalanceClosingFor13BySegment(Periode periode12, Periode periode13, boolean isYearlyClosing, long segment1Id){

        String where = colNames[COL_STATUS] + "='POSTABLE'";
        if (isYearlyClosing) {
            where = where + " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_REVENUE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_COST_OF_SALES + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_EXPENSE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_REVENUE + "' " +
                    " and " + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_EXPENSE + "'";
        }
        
        //looping segment, untuk mendapatkan lokasi
        Segment segment = new Segment();
        try{
            segment = DbSegment.fetchExc(segment1Id);
        }catch(Exception e){}
        
        Vector vSegmentDetail = new Vector();
        
        if(segment.getOID() != 0){
            String whereSD = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID]+" = "+segment.getOID();
            vSegmentDetail = DbSegmentDetail.list(0, 0, whereSD, null);
        }

        Vector temp = DbCoa.list(0, 0, where, "");
        
        if (temp != null && temp.size() > 0 && vSegmentDetail != null && vSegmentDetail.size() > 0) {

            Coa coaLabaBerjalan = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
            Coa coaLabaLalu = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

            for (int i = 0; i < temp.size(); i++) {
                Coa coa = (Coa) temp.get(i);

                if (coa.getOID() != coaLabaBerjalan.getOID() && coa.getOID() != coaLabaLalu.getOID()) {
                    if(vSegmentDetail != null && vSegmentDetail.size() > 0){
                        for(int t = 0 ; t < vSegmentDetail.size() ; t++){
                            SegmentDetail sd = (SegmentDetail)vSegmentDetail.get(t); 
                            double balance = DbGlDetail.getClosingBalance(coa.getOID(), periode12,sd.getOID());
                            if (balance != 0) {
                                DbCoaOpeningBalanceLocation.updateOpeningBalanceRecursif(coa.getOID(), balance, periode13.getOID(), sd.getOID());
                            }
                        }
                    }
                } //jika laba tahun lalu, lakukan tanpa rekursif
                else if (coa.getOID() == coaLabaLalu.getOID()) {
                    
                    if(vSegmentDetail != null && vSegmentDetail.size() > 0){
                        
                        for(int t = 0 ; t < vSegmentDetail.size() ; t++){                            
                            SegmentDetail sd = (SegmentDetail)vSegmentDetail.get(t);                              
                            double balance = DbGlDetail.getClosingBalance(coa.getOID(), periode12, sd.getOID());

                            //jika closing tahunan, maka tambahkan dengan laba berjalan
                            if (isYearlyClosing) {
                                Coa coaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));                                
                                double labaBerjalan = DbGlDetail.getClosingCurrentEarning(coaBerjalan.getOID(), periode12,sd.getOID());                                
                                balance = balance + labaBerjalan;
                            }

                            if (balance != 0) {
                                CoaOpeningBalanceLocation cob = new CoaOpeningBalanceLocation();
                                cob.setCoaId(coa.getOID());
                                cob.setOpeningBalance(balance);
                                cob.setPeriodeId(periode13.getOID());
                                cob.setSegment1Id(sd.getOID());
                                try {
                                    long oid = DbCoaOpeningBalanceLocation.insertExc(cob);
                                } catch (Exception e) {}
                            }
                        }
                    }
                } //tahun berjalan
                else {
                    if (!isYearlyClosing) {                        
                        if(vSegmentDetail != null && vSegmentDetail.size() > 0){                        
                            for(int t = 0 ; t < vSegmentDetail.size() ; t++){
                                SegmentDetail sd = (SegmentDetail)vSegmentDetail.get(t);    
                                
                                double balance = DbGlDetail.getClosingCurrentEarning(coa.getOID(), periode12,sd.getOID());

                                if (balance != 0) {
                                    CoaOpeningBalanceLocation cob = new CoaOpeningBalanceLocation();
                                    cob.setCoaId(coa.getOID());
                                    cob.setOpeningBalance(balance);
                                    cob.setPeriodeId(periode13.getOID());
                                    cob.setSegment1Id(sd.getOID());
                                    try {
                                        long oid = DbCoaOpeningBalanceLocation.insertExc(cob);
                                    } catch (Exception e) {}
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     * Purpose to update opening balance first period from period 13th
     * by gwawan, june 2012
     * @param periode13
     * @param periode1
     */
    public static boolean updateOpeningBalanceFromPeriode13(Periode periode13, Periode periode1) {
        
        String sql = "SELECT DISTINCT coa.* FROM "+DbGl.DB_GL+" INNER JOIN "+DbGlDetail.DB_GL_DETAIL+" gld" +
                " ON gl."+DbGl.colNames[DbGl.COL_GL_ID]+"=gld."+DbGlDetail.colNames[DbGlDetail.COL_GL_ID] +
                " INNER JOIN "+DbCoa.DB_COA+" ON gld."+DbGlDetail.colNames[DbGlDetail.COL_COA_ID]+"=coa."+DbCoa.colNames[DbCoa.COL_COA_ID] +
                " WHERE gl."+DbGl.colNames[DbGl.COL_PERIOD_ID]+"="+periode13.getOID() +
                " AND coa."+DbCoa.colNames[DbCoa.COL_STATUS]+"='POSTABLE'";
        
        String whereCoa = " AND coa." + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_REVENUE + "' " +
                    " AND coa." + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_COST_OF_SALES + "' " +
                    " AND coa." + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_EXPENSE + "' " +
                    " AND coa." + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_REVENUE + "' " +
                    " AND coa." + colNames[COL_ACCOUNT_GROUP] + "<>'" + I_Project.ACC_GROUP_OTHER_EXPENSE + "'";
        
        sql += whereCoa;
        
        CONResultSet crs = null;
        Vector listCoa = new Vector();
        
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                Coa objCoa = new Coa();
                DbCoa.resultToObject(rs, objCoa);
                listCoa.add(objCoa);
            }
        } catch(Exception e) {
            return false;
        }
        
        if (listCoa != null && listCoa.size() > 0) {

            Coa coaLabaBerjalan = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
            Coa coaLabaLalu = getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

            for (int i = 0; i < listCoa.size(); i++) {
                Coa coa = (Coa) listCoa.get(i);

                if (coa.getOID() != coaLabaBerjalan.getOID() && coa.getOID() != coaLabaLalu.getOID()) {
                    double amount = DbGlDetail.getAmountInPeriod(periode13.getOID(), coa.getOID());
                    
                    if (amount != 0) {
                        DbCoaOpeningBalance.updateOpeningBalanceRecursif(coa.getOID(), amount, periode1.getOID());
                    }
                }
            }
            
            //update laba tahun lalu
            if(coaLabaLalu.getOID() != 0 && coaLabaBerjalan.getOID() != 0) {
                double balance = DbGlDetail.getClosingBalance(coaLabaLalu.getOID(), periode13);
                double labaBerjalan = DbGlDetail.getClosingCurrentEarning(coaLabaBerjalan.getOID(), periode13);
                balance += labaBerjalan; //laba tahun lalu + laba tahun berjalan
                
                if(balance != 0) {
                    CoaOpeningBalance cob = DbCoaOpeningBalance.getObjectByCodePeriod(coaLabaLalu.getCode(), periode1.getOID());
                    cob.setOpeningBalance(balance);
                    try {
                        long oid = DbCoaOpeningBalance.updateExc(cob);
                    } catch (Exception e) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    //lakukan looping untuk menghitung saldo masing-masing account,
    //me-reset p&l dan mengeset opening balance pada periode baru.
    public static void getOpeningBalanceClosing_DEFAULT(Periode p, boolean isYearlyClosing) {
        Periode newP = DbPeriode.getOpenPeriod();
        Vector c = new Vector();
        try {
            c = DbCoa.list(0, 0, "", "");
            double totalIncome = 0;

            if (c != null && c.size() > 0) {
                for (int i = 0; i < c.size(); i++) {
                    Coa coa = (Coa) c.get(i);
                    // Add new Opening Balance
                    CoaOpeningBalance cob = new CoaOpeningBalance();

                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                        //closing tahunan
                        if (isYearlyClosing) {
                            //get retained earning
                            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                cob.setOpeningBalance(0);
                            } //jika merupakan kode yearly earning, maka 0 kan, ID_RETAINED_EARNINGS => ada S
                            else if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")) || coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS_1"))) {
                                cob.setOpeningBalance(0);
                            } //jika coa adalah retained earning
                            else if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING")) || coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING_1")) || coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING_2"))) {
                                //cek apakah menggunakan account class(sp/nsp) atau hanya single retained earning
                                String code2 = DbSystemProperty.getValueByName("ID_RETAINED_EARNING_1");
                                String code3 = DbSystemProperty.getValueByName("ID_RETAINED_EARNING_2");
                                //reset total income
                                totalIncome = 0;
                                boolean isByAccClass = false;

                                if ((code2.length() > 0 && !code2.equals("-")) || (code3.length() > 0 && !code3.equals("-"))) {
                                    isByAccClass = true;
                                }

                                //loop coa, untuk mendapatkan saldo p&l, -> sebenarnya ga kurang bagus neh
                                for (int x = 0; x < c.size(); x++) {
                                    Coa coax = (Coa) c.get(x);
                                    boolean ok = true;
                                    
                                    if (isByAccClass) {
                                        if (coax.getAccountClass() != coa.getAccountClass()) {
                                            ok = false;
                                        }
                                    }

                                    if (ok) {
                                        if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                            totalIncome = totalIncome + DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "CD");
                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                            totalIncome = totalIncome - DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "DC");
                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                            totalIncome = totalIncome - DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "DC");
                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                            totalIncome = totalIncome + DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "CD");
                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                            totalIncome = totalIncome - DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "DC");
                                        } //--------- tambahan -----------
                                        else if (coax.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")) || coax.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS_1"))) {
                                            totalIncome = totalIncome + DbCoaOpeningBalance.getOpeningBalance(p, coax.getOID());
                                        }

                                    }

                                }

                                cob.setOpeningBalance(getCoaBalanceClosing(coa.getOID(), p, isYearlyClosing, "DC") + totalIncome);

                            } else {
                                cob.setOpeningBalance(getCoaBalanceClosing(coa.getOID(), p, isYearlyClosing, "DC"));
                            }

                        } //closing bulanan
                        else {
                            cob.setOpeningBalance(getCoaBalanceClosing(coa.getOID(), p, isYearlyClosing, "DC"));
                        }

                    } else if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES)) {

                        //jika closing tahunan
                        if (isYearlyClosing) {
                            //get retained earning
                            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                                cob.setOpeningBalance(0);

                            } //jika merupakan kode yearly earning, maka 0 kan, ID_RETAINED_EARNINGS => ada S
                            else if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")) || coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS_1"))) {

                                cob.setOpeningBalance(0);

                            } //ID_RETAINED_EARNING => reatined earning / bukan yearly earning
                            else if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING")) || coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING_1")) || coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING_2"))) {

                                //cek apakah menggunakan account class(sp/nsp) atau hanya single retained earning
                                String code2 = DbSystemProperty.getValueByName("ID_RETAINED_EARNING_1");
                                String code3 = DbSystemProperty.getValueByName("ID_RETAINED_EARNING_2");
                                //reset total income
                                totalIncome = 0;
                                boolean isByAccClass = false;
                                
                                if ((code2.length() > 0 && !code2.equals("-")) || (code3.length() > 0 && !code3.equals("-"))) {
                                    isByAccClass = true;
                                }
                                
                                for (int x = 0; x < c.size(); x++) {
                                    Coa coax = (Coa) c.get(x);
                                    boolean ok = true;
                                    
                                    if (isByAccClass) {
                                        if (coax.getAccountClass() != coa.getAccountClass()) {
                                            ok = false;
                                        }
                                    }

                                    if (ok) {
                                        if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                            totalIncome = totalIncome + DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "CD");
                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                            totalIncome = totalIncome - DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "DC");
                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                            totalIncome = totalIncome - DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "DC");
                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                            totalIncome = totalIncome + DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "CD");
                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                            totalIncome = totalIncome - DbCoa.getCoaBalanceClosing(coax.getOID(), p, isYearlyClosing, "DC");
                                        } //--------- tambahan -----------
                                        else if (coax.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")) || coax.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS_1"))) {
                                            totalIncome = totalIncome + DbCoaOpeningBalance.getOpeningBalance(p, coax.getOID());
                                        }
                                    }
                                }

                                //ambil balance dari retained earning + total p&l dan opening jika yearly earning
                                cob.setOpeningBalance(getCoaBalanceClosing(coa.getOID(), p, isYearlyClosing, "CD") + totalIncome);
                            } else {
                                cob.setOpeningBalance(getCoaBalanceClosing(coa.getOID(), p, isYearlyClosing, "CD"));
                            }

                        } //closing bulanan
                        else {
                            cob.setOpeningBalance(getCoaBalanceClosing(coa.getOID(), p, isYearlyClosing, "CD"));
                        }
                    }

                    cob.setPeriodeId(newP.getOID());
                    cob.setCoaId(coa.getOID());
                    long oid = DbCoaOpeningBalance.insertExc(cob);
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalance(long coaId, Periode p, String type) {
        double result = 0;
        CONResultSet crs = null;
        //run query
        try {
            //ambil transaksi bulan itu
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            } else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = result + rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    public static double getCoaBalance(long coaId, Periode p, String type, String whereSd) {

        double result = 0;
        CONResultSet crs = null;

        try {
            String sql = "";
            if (type.equals("DC")) {

                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            } else {

                sql = "select (sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gd." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gd " +
                        " inner join " + DbGl.DB_GL + " as gl on gd." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gd." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            }

            if (whereSd.length() > 0) {
                sql = sql + " and " + whereSd;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = result + rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalance(long coaId, Periode p, String type, long depOID) {
        double result = 0;
        CONResultSet crs = null;
        //run query
        try {
            //ambil transaksi bulan itu
            String sql = "";
            if (type.equals("DC")) {

                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() +
                        " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depOID;
            } else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID() +
                        " and gld." + DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "=" + depOID;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = result + rs.getDouble(1);
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalanceNonPL(long coaId, Periode p, String type) {
        double result = 0;
        CONResultSet crs = null;
        //run query
        try {
            //ambil transaksi bulan itu
            String sql = "";
            if (type.equals("DC")) {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            } else {
                sql = "select (sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_CREDIT] + ")-sum(gld." + DbGlDetail.colNames[DbGlDetail.COL_DEBET] + ")) from " + DbGlDetail.DB_GL_DETAIL + " as gld " +
                        " inner join " + DbGl.DB_GL + " as gl on gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=gl." + DbGl.colNames[DbGl.COL_GL_ID] + " where gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + "=" + coaId +
                        " and gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + p.getOID();
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = result + rs.getDouble(1);
            }

            //get opening balance
            result = result + DbCoaOpeningBalance.getOpeningBalance(p, coaId);

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalanceRecursif(Coa coa, Periode p, String type) {

        double result = 0;

        if (coa.getStatus().equals("HEADER")) {
            Vector v = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (v != null && v.size() > 0) {
                for (int i = 0; i < v.size(); i++) {
                    Coa cx = (Coa) v.get(i);
                    result = result + getCoaBalanceRecursif(cx, p, type);
                }
            }
        } else {
            result = result + getCoaBalance(coa.getOID(), p, type);
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalanceRecursifNonPL(Coa coa, Periode p, String type) {

        double result = 0;

        if (coa.getStatus().equals("HEADER")) {
            Vector v = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (v != null && v.size() > 0) {
                for (int i = 0; i < v.size(); i++) {
                    Coa cx = (Coa) v.get(i);
                    result = result + getCoaBalanceRecursifNonPL(cx, p, type);
                }
            }
        } else {
            result = result + getCoaBalanceNonPL(coa.getOID(), p, type);
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalance(long coaId, Vector periods, String type) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + getCoaBalance(coaId, p, type);
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalance(long coaId, Vector periods, String type, long depId) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + getCoaBalance(coaId, p, type, depId);
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalanceByGroup(String coaGroup, String type, Periode p) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                result = result + DbCoa.getCoaBalance(coa.getOID(), p, type);
            }
        }

        return result;
    }

    public static double getCoaBalanceByGroup(String coaGroup, String type, Periode p, String whereSd) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                result = result + DbCoa.getCoaBalance(coa.getOID(), p, type, whereSd);
            }
        }

        return result;
    }
    
    public static double getCoaBalanceByGroup(String coaGroup, String type, Periode p, String whereSd,String whereLoc) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);                
                result = result + DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereSd, p, whereLoc,type);
            }
        }

        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalanceByGroup(String coaGroup, String type, Periode p, long depOID) {
        double result = 0;
        Vector listCoa = new Vector();
        Coa coa = new Coa();
        listCoa = DbCoa.list(0, 0, "account_group='" + coaGroup + "'", "code");
        if (listCoa != null && listCoa.size() > 0) {
            for (int i = 0; i < listCoa.size(); i++) {
                coa = (Coa) listCoa.get(i);
                result = result + DbCoa.getCoaBalance(coa.getOID(), p, type, depOID);
            }
        }

        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalanceByGroup(String coaGroup, Vector periods, String type) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + DbCoa.getCoaBalanceByGroup(coaGroup, type, p);
        }
        return result;
    }

    public static double getCoaBalanceByGroup(String coaGroup, Vector periods, String type, String whereSd) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + DbCoa.getCoaBalanceByGroup(coaGroup, type, p, whereSd);
        }
        return result;
    }
    
    public static double getIsCoaBalanceByGroup(String coaGroup, Vector periods, String type, String whereSd,String whereLocation) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + DbCoa.getIsCoaBalanceByGroup(coaGroup, type, whereSd, p, whereLocation);
            if(result != 0){
                return result;
            }
        }
        return result;
    }    
    
    public static double getIsCoaBalanceByGroupMTD(String coaGroup, Vector periods, String type, String whereSd) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + DbCoa.getIsCoaBalanceByGroupMTD(coaGroup, type, whereSd, p);            
            if(result != 0){
                return result;
            }
        }
        return result;
    }
    
    public static double getIsCoaBalanceByGroupMTD(Vector coas, Vector periods, String type, String whereSd) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + DbCoa.getIsCoaBalanceByGroupMTD(coas, type, whereSd, p);   
              
            if(result != 0){
                return result;
            }
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getCoaBalanceByGroup(String coaGroup, Vector periods, String type, long depId) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + DbCoa.getCoaBalanceByGroup(coaGroup, type, p, depId);
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getNetIncomeByPeriod(Periode p) {
        double result = 0;
        result = DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD", p) -
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC", p) -
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC", p) +
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD", p) -
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC", p);
        return result;
    }

    public static double getNetIncomeByPeriod(Periode p, String whereMd) {
        double result = 0;
        result = DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD", p, whereMd) -
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC", p, whereMd) -
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC", p, whereMd) +
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD", p, whereMd) -
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC", p, whereMd);
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getNetIncomeByPeriod(Periode p, long depID) {
        double result = 0;
        result = DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD", p, depID) -
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC", p, depID) -
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC", p, depID) +
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD", p, depID) -
                DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC", p, depID);
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getNetIncomeByPeriod(Vector periods) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD", p) -
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC", p) -
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC", p) +
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD", p) -
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC", p);
        }
        return result;
    }

    public static double getNetIncomeByPeriod(Vector periods, String whereMd) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD", p, whereMd) -
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC", p, whereMd) -
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC", p, whereMd) +
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD", p, whereMd) -
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC", p, whereMd);
        }
        return result;
    }

    // dipakai pada P&L Multiple
    public static double getNetIncomeByPeriod(Vector periods, long depId) {
        double result = 0;
        for (int i = 0; i < periods.size(); i++) {
            Periode p = (Periode) periods.get(i);
            result = result + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD", p, depId) -
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC", p, depId) -
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC", p, depId) +
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD", p, depId) -
                    DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC", p, depId);
        }
        return result;
    }

    public static double getRatioCurrYR(String accGroup, Periode periode, String strType) {

        double result = 0;

        //ambil postable level 1            
        Vector v = DbCoa.list(0, 0, colNames[COL_ACCOUNT_GROUP] + "='" + accGroup + "' and " + colNames[COL_STATUS] + "='HEADER' and " + colNames[COL_LEVEL] + "=1", "");
        if (v != null && v.size() > 0) {
            for (int i = 0; i < v.size(); i++) {
                Coa coa = (Coa) v.get(i);
                result = result + DbCoa.getCoaBalanceRecursifNonPL(coa, periode, strType);
            }
        }

        return result;
    }

    public static double getRatioPrevYR(String accGroup, Periode periode, String strType) {

        Date dt = periode.getStartDate();
        Date dtx = (Date) dt.clone();
        dtx.setYear(dtx.getYear() - 1);

        Periode periode2 = DbPeriode.getPeriodByTransDate(dtx);

        double result = 0;
        if (periode.getOID() != 0) {
            //ambil postable level 1
            Vector v = DbCoa.list(0, 0, colNames[COL_ACCOUNT_GROUP] + "='" + accGroup + "' and " + colNames[COL_STATUS] + "='HEADER' and " + colNames[COL_LEVEL] + "=1", "");

            if (v != null && v.size() > 0) {
                for (int i = 0; i < v.size(); i++) {
                    Coa coa = (Coa) v.get(i);
                    result = result + DbCoa.getCoaBalanceRecursifNonPL(coa, periode2, strType);
                }
            }
        }

        return result;

    }

    public static double getEarningByPeriod(Periode periode) {
        //income
        String where = "(" + colNames[COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_REVENUE + "'" +
                " or " + colNames[COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_OTHER_REVENUE + "')" +
                " and " + colNames[COL_STATUS] + "='HEADER' and " + colNames[COL_LEVEL] + "=1";

        Vector sales = DbCoa.list(0, 0, where, "");
        double result = 0;
        if (sales != null && sales.size() > 0) {
            for (int i = 0; i < sales.size(); i++) {
                Coa coa = (Coa) sales.get(i);
                result = result + getCoaBalanceYTDRecursif(coa, periode, "CD");
            }
        }

        where = "(" + colNames[COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_EXPENSE + "'" +
                " or " + colNames[COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_OTHER_EXPENSE + "')" +
                " and " + colNames[COL_STATUS] + "='HEADER' and " + colNames[COL_LEVEL] + "=1";

        Vector expenses = DbCoa.list(0, 0, where, "");
        if (expenses != null && expenses.size() > 0) {
            for (int i = 0; i < expenses.size(); i++) {
                Coa coa = (Coa) expenses.get(i);
                result = result - getCoaBalanceYTDRecursif(coa, periode, "DC");
            }
        }

        return result;
    }

    public static Coa getCoaByCode(String code) {

        Vector v = list(0, 0, colNames[COL_CODE] + "='" + code + "'", "");
        if (v != null && v.size() > 0) {
            return (Coa) v.get(0);
        }

        return new Coa();
    }

    /**
     * @Author  : Roy Andika
     * @Desc    
     * @return  
     */
    public static double getCoaBudget(long coaId) {

        Vector listDepartment = DbDepartment.listAll();
        double amount = 0;

        if (listDepartment != null && listDepartment.size() > 0) {
            for (int i = 0; i < listDepartment.size(); i++) {
                Department department = (Department) listDepartment.get(i);
                Vector listCoaBudget = getCoaBudgetDepartment(department.getOID(), coaId);
                int levelMinimum = 0;

                if (listCoaBudget != null && listCoaBudget.size() > 0) {
                    for (int j = 0; j < listCoaBudget.size(); j++) {
                        BalanceSheet balanceSheet = (BalanceSheet) listCoaBudget.get(j);
                        if (levelMinimum >= balanceSheet.getLevel()) {
                            levelMinimum = 0;
                        }

                        if (balanceSheet.getLevel() == 1) {
                            if (balanceSheet.getAmount() != 0) {
                                levelMinimum = 1;
                                amount = amount + balanceSheet.getAmount();
                            }
                        }

                        if (levelMinimum != 1) {
                            if (balanceSheet.getLevel() == 2) {
                                if (balanceSheet.getAmount() != 0) {
                                    levelMinimum = 2;
                                    amount = amount + balanceSheet.getAmount();
                                }
                            }
                        }

                        if (levelMinimum != 1 || levelMinimum != 2) {
                            if (balanceSheet.getLevel() == 3) {
                                if (balanceSheet.getAmount() != 0) {
                                    levelMinimum = 3;
                                    amount = amount + balanceSheet.getAmount();
                                }
                            }
                        }

                        if (levelMinimum != 1 || levelMinimum != 2 || levelMinimum != 3) {
                            if (balanceSheet.getLevel() == 4) {
                                if (balanceSheet.getAmount() != 0) {
                                    levelMinimum = 4;
                                    amount = amount + balanceSheet.getAmount();
                                }
                            }
                        }
                    }
                }
            }
        }

        return 0;
    }

    public static double getCoaBudgetDetail(long coaId) {

        Vector listDepartment = DbDepartment.listAll();
        double amount = 0;

        if (listDepartment != null && listDepartment.size() > 0) {
            for (int i = 0; i < listDepartment.size(); i++) {
                Department department = (Department) listDepartment.get(i);
                Vector listCoaBudget = getCoaBudgetDepartment(department.getOID(), coaId);

                if (listCoaBudget != null && listCoaBudget.size() > 0) {
                    for (int j = 0; j < listCoaBudget.size(); j++) {
                        BalanceSheet balanceSheet = (BalanceSheet) listCoaBudget.get(j);
                        amount = amount + balanceSheet.getAmount();
                    }
                }
            }
            return amount;
        }

        return 0;
    }

    public static double getCoaBudgetDetailSD(Periode periode, long coaId) {

        Vector listDepartment = DbDepartment.listAll();
        double amount = 0;

        if (listDepartment != null && listDepartment.size() > 0) {
            for (int i = 0; i < listDepartment.size(); i++) {
                Department department = (Department) listDepartment.get(i);
                Vector listCoaBudget = getCoaBudgetDepartmentSD(periode, department.getOID(), coaId);

                if (listCoaBudget != null && listCoaBudget.size() > 0) {
                    for (int j = 0; j < listCoaBudget.size(); j++) {
                        BalanceSheet balanceSheet = (BalanceSheet) listCoaBudget.get(j);
                        amount = amount + balanceSheet.getAmount();
                    }
                }
            }
            return amount;
        }

        return 0;
    }

    public static Vector getCoaBudgetDepartment(long departmentId, long coaId) {

        CONResultSet crs = null;
        Periode periode = DbPeriode.getOpenPeriod();
        int month = periode.getStartDate().getMonth() + 1;
        int year = periode.getStartDate().getYear() + 1900;

        if (periode.getOID() != 0) {
            try {
                String sql = "SELECT BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT] + " as amount," +
                        " BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID] + " as departmentId," +
                        " COA." + DbCoa.colNames[DbCoa.COL_STATUS] + " as status," +
                        " COA." + DbCoa.colNames[DbCoa.COL_LEVEL] + " as level " +
                        " FROM " + DbCoa.DB_COA + " COA INNER JOIN " + DbCoaBudget.DB_COA_BUDGET + " BUDGET " +
                        " ON COA." + DbCoa.colNames[DbCoa.COL_COA_ID] + " = BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_COA_ID] +
                        " WHERE BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_BGT_YEAR] + " = " + year + " AND " +
                        " BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_BGT_MONTH] + " = " + month + " AND " +
                        " BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID] + " = " + departmentId + " AND " +
                        " COA." + DbCoa.colNames[DbCoa.COL_COA_ID] + " = " + coaId + " ORDER BY " +
                        " COA." + DbCoa.colNames[DbCoa.COL_CODE];

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                Vector list = new Vector();

                while (rs.next()) {

                    BalanceSheet balanceSheet = new BalanceSheet();

                    balanceSheet.setAmount(rs.getDouble("amount"));
                    balanceSheet.setDepartmentId(rs.getLong("departmentId"));
                    balanceSheet.setStatus(rs.getString("status"));
                    balanceSheet.setLevel(rs.getInt("amount"));

                    list.add(balanceSheet);
                }

                return list;

            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }
        return null;

    }

    public static Vector getCoaBudgetDepartmentSD(Periode periode, long departmentId, long coaId) {

        int yearP = periode.getStartDate().getYear() + 1900;
        int monthP = periode.getStartDate().getMonth() + 1;
        String wherePeriode = " YEAR(" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + ") = " + yearP + " AND " +
                " MONTH(" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + ") <= " + monthP;
        Vector vList = DbPeriode.list(0, 0, wherePeriode, null);

        if (vList != null && vList.size() > 0) {
            Vector list = new Vector();
            CONResultSet crs = null;

            for (int i = 0; i < vList.size(); i++) {
                Periode objPeriode = (Periode) vList.get(i);
                int month = objPeriode.getStartDate().getMonth() + 1;
                int year = objPeriode.getStartDate().getYear() + 1900;

                if (objPeriode.getOID() != 0) {
                    try {
                        String sql = "SELECT BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT] + " as amount," +
                                " BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID] + " as departmentId," +
                                " COA." + DbCoa.colNames[DbCoa.COL_STATUS] + " as status," +
                                " COA." + DbCoa.colNames[DbCoa.COL_LEVEL] + " as level " +
                                " FROM " + DbCoa.DB_COA + " COA INNER JOIN " + DbCoaBudget.DB_COA_BUDGET + " BUDGET " +
                                " ON COA." + DbCoa.colNames[DbCoa.COL_COA_ID] + " = BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_COA_ID] +
                                " WHERE BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_BGT_YEAR] + " = " + year + " AND " +
                                " BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_BGT_MONTH] + " = " + month + " AND " +
                                " BUDGET." + DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID] + " = " + departmentId + " AND " +
                                " COA." + DbCoa.colNames[DbCoa.COL_COA_ID] + " = " + coaId + " ORDER BY " +
                                " COA." + DbCoa.colNames[DbCoa.COL_CODE];

                        crs = CONHandler.execQueryResult(sql);
                        ResultSet rs = crs.getResultSet();

                        while (rs.next()) {

                            BalanceSheet balanceSheet = new BalanceSheet();
                            balanceSheet.setAmount(rs.getDouble("amount"));
                            balanceSheet.setDepartmentId(rs.getLong("departmentId"));
                            balanceSheet.setStatus(rs.getString("status"));
                            balanceSheet.setLevel(rs.getInt("amount"));

                            list.add(balanceSheet);
                        }
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    } finally {
                        CONResultSet.close(crs);
                    }
                }
            }

            return list;
        }

        return null;
    }

    public static String switchLevel(int level) {
        String str = "";
        switch (level) {
            case 1:
                break;
            case 2:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 3:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 4:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 5:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
        }
        return str;
    }

    public static String switchLevel1(int level) {
        String str = "";
        switch (level) {
            case 1:
                break;
            case 2:
                str = "       ";
                break;
            case 3:
                str = "              ";
                break;
            case 4:
                str = "                     ";
                break;
            case 5:
                str = "                            ";
                break;
        }
        return str;
    }

    public static String strDisplay(double amount, String coaStatus) {
        String displayStr = "";
        if (amount < 0) {
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
        } else if (amount > 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###.##");
        } else if (amount == 0) {
            displayStr = "";
        }
        if (coaStatus.equals("HEADER")) {
            displayStr = "";
        }
        return displayStr;
    }

    /**
     * @Author  Roy Andika
     * @param   coaId
     * @Desc    Untuk mendapatlan nomor rekening yang ada di report BKM / BKK
     * @return  
     */
    public static Vector getCodeCoa(long coaId) {

        CONResultSet dbrs = null;

        try {
            String sql = "SELECT " + DbCoa.colNames[DbCoa.COL_CODE] + "," + DbCoa.colNames[DbCoa.COL_NAME] + " FROM " + DbCoa.DB_COA + " WHERE " +
                    DbCoa.colNames[DbCoa.COL_COA_ID] + "=" + coaId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Vector result = new Vector();
                String code = rs.getString(DbCoa.colNames[DbCoa.COL_CODE]);
                String name = rs.getString(DbCoa.colNames[DbCoa.COL_NAME]);

                result.add("" + code);
                result.add("" + name);

                return result;
            }

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

        return null;

    }

    /**
     * Fungsi untuk mendapatkan daftar CoA yang berstatus AUTO REVERSE dan memiliki transaksi di GL
     * by gwawan 20110902
     * @return Vector
     */
    public static Vector listAutoReverseCoA(long periodeId) {
        Vector list = new Vector();
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT DISTINCT coa.* FROM " + DbGlDetail.DB_GL_DETAIL + " gld INNER JOIN " + DB_COA +
                    " ON gld." + DbGlDetail.colNames[DbGlDetail.COL_COA_ID] + " = coa." + colNames[COL_COA_ID] +
                    " INNER JOIN " + DbGl.DB_GL +
                    " ON gld." + DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + " = gl." + DbGl.colNames[DbGl.COL_GL_ID] +
                    " INNER JOIN " + DbPeriode.DB_PERIODE + " p" +
                    " ON gl." + DbGl.colNames[DbGl.COL_PERIOD_ID] + " = p." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] +
                    " WHERE coa." + colNames[COL_AUTO_REVERSE] + " = " + AUTO_REVERSE +
                    " AND gl." + DbGl.colNames[DbGl.COL_POSTED_STATUS] + " = " + DbGl.POSTED;

            if (periodeId != 0) {
                sql += " AND p." + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodeId;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Coa coa = new Coa();
                resultToObject(rs, coa);
                list.add(coa);
            }

        } catch (Exception e) {
            System.out.println("Exception on listAutoReverseCoA : " + e.toString());
        }

        return list;
    }
    
    public static Vector listCoaNeraca(String where,String order){
        
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT "+DbCoa.colNames[DbCoa.COL_COA_ID]+","+
                    DbCoa.colNames[DbCoa.COL_CODE]+","+
                    DbCoa.colNames[DbCoa.COL_NAME]+","+
                    DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]+","+
                    DbCoa.colNames[DbCoa.COL_STATUS]+","+
                    DbCoa.colNames[DbCoa.COL_LEVEL]+
                    " FROM " + DB_COA;
            
            if(where != null && where.length() > 0){
                sql = sql + " WHERE " + where;
            }
            
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                CoaReport coa = new CoaReport();                
                coa.setCoaId(rs.getLong(DbCoa.colNames[DbCoa.COL_COA_ID]));
                coa.setLevel(rs.getInt(DbCoa.colNames[DbCoa.COL_LEVEL]));            
                coa.setStatus(rs.getString(DbCoa.colNames[DbCoa.COL_STATUS]));
                coa.setAccountGroup(rs.getString(DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]));
                coa.setName(rs.getString(DbCoa.colNames[DbCoa.COL_NAME]));                
                coa.setCode(rs.getString(DbCoa.colNames[DbCoa.COL_CODE]));  
                lists.add(coa);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
}
