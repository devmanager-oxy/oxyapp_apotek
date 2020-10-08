package com.project.fms.master;

import com.project.fms.reportform.DbRptFormatDetailCoa;
import com.project.fms.reportform.RptFormatDetailCoa;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.payroll.DbDepartment;
import com.project.payroll.Department;
import com.project.util.lang.I_Language;

public class DbCoaBudget extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_COA_BUDGET = "coa_budget";
    public static final int CL_COA_ID = 0;
    public static final int CL_PERIODE_ID = 1;
    public static final int CL_COA_BUDGET_ID = 2;
    public static final int CL_AMOUNT = 3;
    public static final int CL_BGT_YEAR = 4;
    public static final int CL_BGT_MONTH = 5;
    public static final int CL_DIVISION_ID = 6;
    public static final int CL_DEPARTMENT_ID = 7;
    public static final int CL_DIREKTORAT_ID = 8;
    public static final int CL_COA_CODE = 9;
    public static final int CL_SECTION_ID = 10;
    public static final int CL_JOB_ID = 11;
    public static final int CL_COALEVEL_1_ID = 12;
    public static final int CL_COALEVEL_2_ID = 13;
    public static final int CL_COALEVEL_3_ID = 14;
    public static final int CL_COALEVEL_4_ID = 15;
    public static final int CL_COALEVEL_5_ID = 16;
    public static final int CL_COALEVEL_6_ID = 17;
    public static final int CL_COALEVEL_7_ID = 18;
    public static final int CL_SUB_SECTION_ID = 19;
    public static final int COL_SEGMENT1_ID = 20;
    public static final int COL_SEGMENT2_ID = 21;
    public static final int COL_SEGMENT3_ID = 22;
    public static final int COL_SEGMENT4_ID = 23;
    public static final int COL_SEGMENT5_ID = 24;
    
    public static final String[] colNames = {
        "coa_id",
        "periode_id",
        "coa_budget_id",
        "amount",
        "bgt_year",
        "bgt_month",
        "division_id",
        "department_id",
        "direktorat_id",
        "coa_code",
        "section_id",
        "job_id",
        "coa_level_1_id",
        "coa_level_2_id",
        "coa_level_3_id",
        "coa_level_4_id",
        "coa_level_5_id",
        "coa_level_6_id",
        "coa_level_7_id",
        "sub_section_id",
        "segment1_id",
        "segment2_id",
        "segment3_id",
        "segment4_id",
        "segment5_id"
    };
    
    
    public static final int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,        
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
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG        
    };
    
    public static final String[] key_Month = {
        "Januari",
        "Februari",
        "Maret",
        "April",
        "Mei",
        "Juni",
        "Juli",
        "Agustus",
        "September",
        "Oktober",
        "November",
        "Desember"
    };
    
    public static final String[] val_Month = {
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10",
        "11"
    };

    public DbCoaBudget() {
    }

    public DbCoaBudget(int i) throws CONException {
        super(new DbCoaBudget());
    }

    public DbCoaBudget(String sOid) throws CONException {
        super(new DbCoaBudget(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbCoaBudget(long lOid) throws CONException {
        super(new DbCoaBudget(0));
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
        return DB_COA_BUDGET;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbCoaBudget().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        CoaBudget coabudget = fetchExc(ent.getOID());
        ent = (Entity) coabudget;
        return coabudget.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((CoaBudget) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((CoaBudget) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static CoaBudget fetchExc(long oid) throws CONException {
        try {
            CoaBudget coabudget = new CoaBudget();
            DbCoaBudget pstCoaBudget = new DbCoaBudget(oid);
            coabudget.setOID(oid);

            coabudget.setCoaId(pstCoaBudget.getlong(CL_COA_ID));
            coabudget.setPeriodeId(pstCoaBudget.getlong(CL_PERIODE_ID));
            coabudget.setAmount(pstCoaBudget.getdouble(CL_AMOUNT));
            coabudget.setBgtYear(pstCoaBudget.getInt(CL_BGT_YEAR));
            coabudget.setBgtMonth(pstCoaBudget.getInt(CL_BGT_MONTH));
            coabudget.setDivisionId(pstCoaBudget.getlong(CL_DIVISION_ID));
            coabudget.setDepartmentId(pstCoaBudget.getlong(CL_DEPARTMENT_ID));
            coabudget.setDirektoratId(pstCoaBudget.getlong(CL_DIREKTORAT_ID));
            coabudget.setCoaCode(pstCoaBudget.getString(CL_COA_CODE));

            coabudget.setSectionId(pstCoaBudget.getlong(CL_SECTION_ID));
            coabudget.setJobId(pstCoaBudget.getlong(CL_JOB_ID));
            coabudget.setCoaLevel1Id(pstCoaBudget.getlong(CL_COALEVEL_1_ID));
            coabudget.setCoaLevel2Id(pstCoaBudget.getlong(CL_COALEVEL_2_ID));
            coabudget.setCoaLevel3Id(pstCoaBudget.getlong(CL_COALEVEL_3_ID));
            coabudget.setCoaLevel4Id(pstCoaBudget.getlong(CL_COALEVEL_4_ID));
            coabudget.setCoaLevel5Id(pstCoaBudget.getlong(CL_COALEVEL_5_ID));
            coabudget.setCoaLevel6Id(pstCoaBudget.getlong(CL_COALEVEL_6_ID));
            coabudget.setCoaLevel7Id(pstCoaBudget.getlong(CL_COALEVEL_7_ID));
            coabudget.setSubSectionId(pstCoaBudget.getlong(CL_SUB_SECTION_ID));
            coabudget.setSegment1Id(pstCoaBudget.getlong(COL_SEGMENT1_ID));
            coabudget.setSegment2Id(pstCoaBudget.getlong(COL_SEGMENT2_ID));
            coabudget.setSegment3Id(pstCoaBudget.getlong(COL_SEGMENT3_ID));
            coabudget.setSegment4Id(pstCoaBudget.getlong(COL_SEGMENT4_ID));
            coabudget.setSegment5Id(pstCoaBudget.getlong(COL_SEGMENT5_ID));
            
            return coabudget;

        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoaBudget(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(CoaBudget coabudget) throws CONException {
        try {
            DbCoaBudget pstCoaBudget = new DbCoaBudget(0);

            pstCoaBudget.setLong(CL_COA_ID, coabudget.getCoaId());
            pstCoaBudget.setLong(CL_PERIODE_ID, coabudget.getPeriodeId());
            pstCoaBudget.setDouble(CL_AMOUNT, coabudget.getAmount());
            pstCoaBudget.setInt(CL_BGT_YEAR, coabudget.getBgtYear());
            pstCoaBudget.setInt(CL_BGT_MONTH, coabudget.getBgtMonth());
            pstCoaBudget.setLong(CL_DEPARTMENT_ID, coabudget.getDepartmentId());
            pstCoaBudget.setLong(CL_DIVISION_ID, coabudget.getDivisionId());
            pstCoaBudget.setLong(CL_DIREKTORAT_ID, coabudget.getDirektoratId());
            pstCoaBudget.setString(CL_COA_CODE, coabudget.getCoaCode());

            pstCoaBudget.setLong(CL_SECTION_ID, coabudget.getSectionId());
            pstCoaBudget.setLong(CL_JOB_ID, coabudget.getJobId());
            pstCoaBudget.setLong(CL_COALEVEL_1_ID, coabudget.getCoaLevel1Id());
            pstCoaBudget.setLong(CL_COALEVEL_2_ID, coabudget.getCoaLevel2Id());
            pstCoaBudget.setLong(CL_COALEVEL_3_ID, coabudget.getCoaLevel3Id());
            pstCoaBudget.setLong(CL_COALEVEL_4_ID, coabudget.getCoaLevel4Id());
            pstCoaBudget.setLong(CL_COALEVEL_5_ID, coabudget.getCoaLevel5Id());
            pstCoaBudget.setLong(CL_COALEVEL_6_ID, coabudget.getCoaLevel6Id());
            pstCoaBudget.setLong(CL_COALEVEL_7_ID, coabudget.getCoaLevel7Id());
            pstCoaBudget.setLong(CL_SUB_SECTION_ID, coabudget.getSubSectionId());
            
            pstCoaBudget.setLong(COL_SEGMENT1_ID, coabudget.getSegment1Id());
            pstCoaBudget.setLong(COL_SEGMENT2_ID, coabudget.getSegment2Id());
            pstCoaBudget.setLong(COL_SEGMENT3_ID, coabudget.getSegment3Id());
            pstCoaBudget.setLong(COL_SEGMENT4_ID, coabudget.getSegment4Id());
            pstCoaBudget.setLong(COL_SEGMENT5_ID, coabudget.getSegment5Id());

            pstCoaBudget.insert();
            coabudget.setOID(pstCoaBudget.getlong(CL_COA_BUDGET_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoaBudget(0), CONException.UNKNOWN);
        }
        return coabudget.getOID();
    }

    public static long updateExc(CoaBudget coabudget) throws CONException {
        try {
            if (coabudget.getOID() != 0) {
                DbCoaBudget pstCoaBudget = new DbCoaBudget(coabudget.getOID());

                pstCoaBudget.setLong(CL_COA_ID, coabudget.getCoaId());
                pstCoaBudget.setLong(CL_PERIODE_ID, coabudget.getPeriodeId());
                pstCoaBudget.setDouble(CL_AMOUNT, coabudget.getAmount());
                pstCoaBudget.setInt(CL_BGT_YEAR, coabudget.getBgtYear());
                pstCoaBudget.setInt(CL_BGT_MONTH, coabudget.getBgtMonth());

                pstCoaBudget.setLong(CL_DEPARTMENT_ID, coabudget.getDepartmentId());
                pstCoaBudget.setLong(CL_DIVISION_ID, coabudget.getDivisionId());
                pstCoaBudget.setLong(CL_DIREKTORAT_ID, coabudget.getDirektoratId());
                pstCoaBudget.setString(CL_COA_CODE, coabudget.getCoaCode());

                pstCoaBudget.setLong(CL_SECTION_ID, coabudget.getSectionId());
                pstCoaBudget.setLong(CL_JOB_ID, coabudget.getJobId());
                pstCoaBudget.setLong(CL_COALEVEL_1_ID, coabudget.getCoaLevel1Id());
                pstCoaBudget.setLong(CL_COALEVEL_2_ID, coabudget.getCoaLevel2Id());
                pstCoaBudget.setLong(CL_COALEVEL_3_ID, coabudget.getCoaLevel3Id());
                pstCoaBudget.setLong(CL_COALEVEL_4_ID, coabudget.getCoaLevel4Id());
                pstCoaBudget.setLong(CL_COALEVEL_5_ID, coabudget.getCoaLevel5Id());
                pstCoaBudget.setLong(CL_COALEVEL_6_ID, coabudget.getCoaLevel6Id());
                pstCoaBudget.setLong(CL_COALEVEL_7_ID, coabudget.getCoaLevel7Id());
                pstCoaBudget.setLong(CL_SUB_SECTION_ID, coabudget.getSubSectionId());
                
                pstCoaBudget.setLong(COL_SEGMENT1_ID, coabudget.getSegment1Id());
                pstCoaBudget.setLong(COL_SEGMENT2_ID, coabudget.getSegment2Id());
                pstCoaBudget.setLong(COL_SEGMENT3_ID, coabudget.getSegment3Id());
                pstCoaBudget.setLong(COL_SEGMENT4_ID, coabudget.getSegment4Id());
                pstCoaBudget.setLong(COL_SEGMENT5_ID, coabudget.getSegment5Id());

                pstCoaBudget.update();
                return coabudget.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoaBudget(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbCoaBudget pstCoaBudget = new DbCoaBudget(oid);
            pstCoaBudget.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbCoaBudget(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_COA_BUDGET;
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
                CoaBudget coabudget = new CoaBudget();
                resultToObject(rs, coabudget);
                lists.add(coabudget);
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

    private static void resultToObject(ResultSet rs, CoaBudget coabudget) {
        try {
            coabudget.setOID(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COA_BUDGET_ID]));
            coabudget.setCoaId(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COA_ID]));
            coabudget.setPeriodeId(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_PERIODE_ID]));
            coabudget.setAmount(rs.getDouble(DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT]));
            coabudget.setBgtYear(rs.getInt(DbCoaBudget.colNames[DbCoaBudget.CL_BGT_YEAR]));
            coabudget.setBgtMonth(rs.getInt(DbCoaBudget.colNames[DbCoaBudget.CL_BGT_MONTH]));
            coabudget.setDepartmentId(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID]));
            coabudget.setDivisionId(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_DIVISION_ID]));
            coabudget.setDirektoratId(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_DIREKTORAT_ID]));
            coabudget.setCoaCode(rs.getString(DbCoaBudget.colNames[DbCoaBudget.CL_COA_CODE]));

            coabudget.setSectionId(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_SECTION_ID]));
            coabudget.setJobId(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_JOB_ID]));
            coabudget.setCoaLevel1Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COALEVEL_1_ID]));
            coabudget.setCoaLevel2Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COALEVEL_2_ID]));
            coabudget.setCoaLevel3Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COALEVEL_3_ID]));
            coabudget.setCoaLevel4Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COALEVEL_4_ID]));
            coabudget.setCoaLevel5Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COALEVEL_5_ID]));
            coabudget.setCoaLevel6Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COALEVEL_6_ID]));
            coabudget.setCoaLevel7Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COALEVEL_7_ID]));
            coabudget.setSubSectionId(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_SUB_SECTION_ID]));
            
            coabudget.setSegment1Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.COL_SEGMENT1_ID]));
            coabudget.setSegment2Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.COL_SEGMENT2_ID]));
            coabudget.setSegment3Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.COL_SEGMENT3_ID]));
            coabudget.setSegment4Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.COL_SEGMENT4_ID]));
            coabudget.setSegment5Id(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.COL_SEGMENT5_ID]));

        } catch (Exception e) {
        }
    }
    
    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbCoaBudget.colNames[DbCoaBudget.CL_COA_BUDGET_ID] + ") FROM " + DB_COA_BUDGET;
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
                    CoaBudget coabudget = (CoaBudget) list.get(ls);
                    if (oid == coabudget.getOID()) {
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

    public static CoaBudget getBudget(long coaId, long periodId) {

        String where = colNames[CL_COA_ID] + "=" + coaId + " and " + colNames[CL_PERIODE_ID] + "=" + periodId;
        Vector v = list(0, 0, where, null);
        if (v != null && v.size() > 0) {
            return (CoaBudget) v.get(0);
        }

        return new CoaBudget();

    }

    public static CoaBudget getBudget(long coaId, int year) {

        String where = colNames[CL_COA_ID] + "=" + coaId + " and " + colNames[CL_BGT_YEAR] + "=" + year;
        Vector v = list(0, 0, where, null);
        if (v != null && v.size() > 0) {
            return (CoaBudget) v.get(0);
        }

        return new CoaBudget();

    }

    public static CoaBudget getBudget(long coaId, int year, int month, long departmentId) {

        String where = colNames[CL_COA_ID] + "=" + coaId + " and " + colNames[CL_BGT_YEAR] + " = " + year + " and " +
                colNames[CL_BGT_MONTH] + " = " + month + " and " + colNames[CL_DEPARTMENT_ID] + " = " + departmentId;

        Vector v = list(0, 0, where, null);
        if (v != null && v.size() > 0) {
            return (CoaBudget) v.get(0);
        }

        return new CoaBudget();

    }
    
    public static CoaBudget getBudgetBySegment(long coaId, int year, int month, long segment1Id) {

        String where = colNames[CL_COA_ID] + "=" + coaId + " and " + colNames[CL_BGT_YEAR] + " = " + year + " and " +
                colNames[CL_BGT_MONTH] + " = " + month + " and " + colNames[COL_SEGMENT1_ID] + " = " + segment1Id;

        Vector v = list(0, 0, where, null);
        if (v != null && v.size() > 0) {
            return (CoaBudget) v.get(0);
        }

        return new CoaBudget();

    }

    public static CoaBudget getBudget(long coaId, int year, int month) {

        String where = colNames[CL_COA_ID] + "=" + coaId + " and " + colNames[CL_BGT_YEAR] + "=" + year + " and " + colNames[CL_BGT_MONTH] + "=" + month;
        Vector v = list(0, 0, where, null);
        if (v != null && v.size() > 0) {
            return (CoaBudget) v.get(0);
        }

        return new CoaBudget();

    }

    public static double getBudgetRecursif(Coa coa, long periodId) {

        double result = 0;

        if (coa.getStatus().equals("HEADER")) {
            Vector v = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (v != null && v.size() > 0) {
                for (int i = 0; i < v.size(); i++) {
                    Coa cx = (Coa) v.get(i);
                    result = result + getBudgetRecursif(cx, periodId);
                }
            }
        } else {
            CoaBudget cb = getBudget(coa.getOID(), periodId);
            result = result + cb.getAmount();
        }

        return result;

    }

    public static double getBudgetRecursif(Coa coa, int year) {

        double result = 0;

        if (coa.getStatus().equals("HEADER")) {
            Vector v = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (v != null && v.size() > 0) {
                for (int i = 0; i < v.size(); i++) {
                    Coa cx = (Coa) v.get(i);
                    result = result + getBudgetRecursif(cx, year);
                }
            }
        } else {
            CoaBudget cb = getBudget(coa.getOID(), year);
            result = result + cb.getAmount();
        }

        return result;

    }

    public static long processBudget(long coaId, long periodId, double amount) {

        CoaBudget cb = getBudget(coaId, periodId);
        long oid = 0;

        try {
            if (cb.getOID() != 0) {
                cb.setAmount(amount);
                oid = updateExc(cb);
            } else {
                cb.setCoaId(coaId);
                cb.setPeriodeId(periodId);
                cb.setAmount(amount);
                oid = insertExc(cb);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        return oid;

    }

    public static long processBudget(long coaId, int year, double amount) {

        CoaBudget cb = getBudget(coaId, year);
        long oid = 0;

        try {
            if (cb.getOID() != 0) {
                cb.setAmount(amount);
                oid = updateExc(cb);
            } else {
                cb.setCoaId(coaId);
                cb.setBgtYear(year);
                cb.setAmount(amount);
                oid = insertExc(cb);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        return oid;

    }

    /* 
     * @author  roy andika
     */
    public static long processBudget(long coaId, int year, int month, long departmentId, double amount, String code) {

        CoaBudget cb = getBudget(coaId, year, month, departmentId);

        long oid = 0;

        try {
            if (cb.getOID() != 0) {

                cb.setAmount(amount);
                oid = updateExc(cb);

            } else {

                Department department = new Department();

                try {
                    department = DbDepartment.fetchExc(departmentId);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }

                String whereRefDivision = DbDepartment.colNames[DbDepartment.COL_DEPARTMENT_ID] + " = " + department.getRefId();

                Vector listDivision = new Vector();

                listDivision = DbDepartment.list(0, 1, whereRefDivision, null);

                Department division = new Department();

                try {
                    if (listDivision != null && listDivision.size() > 0) {
                        division = (Department) listDivision.get(0);
                    }
                } catch (Exception e) {
                    System.out.println("[exception division] " + e.toString());
                }

                //String whereRefDirektorat = DbDepartment.colNames[DbDepartment.COL_DEPARTMENT_ID]+" = " +division.getRefId();

                //Vector listDirektorat = new Vector();

                //listDirektorat = DbDepartment.list(0, 1, whereRefDirektorat, null);

                /*
                Department direktorat = new Department();
                try{
                if(listDirektorat != null && listDirektorat.size() > 0){
                direktorat = (Department)listDirektorat.get(0);
                }
                }catch(Exception e){
                System.out.println("[exception direktorat] "+e.toString());
                }    
                 */
                cb.setCoaId(coaId);

                cb = setCoaBudgetLevel(cb);

                cb.setDepartmentId(departmentId);

                cb = setCoaDepartmentLevel(cb);

                cb.setBgtYear(year);
                cb.setBgtMonth(month);
                //cb.setDivisionId(division.getOID());
                //cb.setDirektoratId(direktorat.getOID());
                cb.setAmount(amount);
                cb.setCoaCode(code);

                oid = insertExc(cb);

            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        return oid;

    }
    
    public static long processBudgetBySegment(long coaId, int year, int month, long segment1Id, double amount, String code) {

        CoaBudget cb = getBudgetBySegment(coaId, year, month, segment1Id);

        long oid = 0;

        try {
            if (cb.getOID() != 0) {

                cb.setAmount(amount);
                oid = updateExc(cb);

            } else {
                
                cb.setCoaId(coaId);
                cb = setCoaBudgetLevel(cb);
                cb.setSegment1Id(segment1Id);                
                cb.setBgtYear(year);
                cb.setBgtMonth(month);                
                cb.setAmount(amount);
                cb.setCoaCode(code);
                oid = insertExc(cb);

            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        return oid;

    }

    public static long processBudget(long coaId, int year, double amount, int month) {

        CoaBudget cb = getBudget(coaId, year, month);
        long oid = 0;

        try {
            if (cb.getOID() != 0) {
                cb.setAmount(amount);
                oid = updateExc(cb);
            } else {
                cb.setCoaId(coaId);
                cb.setBgtYear(year);
                cb.setBgtMonth(month);
                cb.setAmount(amount);
                oid = insertExc(cb);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        return oid;

    }

    public static double getTMBudgetRecursif(Coa coa, int year, int month) {
        double result = 0;
        if (coa.getStatus().equals("HEADER")) {
            Vector temp = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (temp != null && temp.size() > 0) {
                for (int i = 0; i < temp.size(); i++) {
                    Coa c = (Coa) temp.get(i);
                    result = result + getTMBudgetRecursif(c, year, month);
                }
            }
        } else {
            Vector bgts = DbCoaBudget.list(0, 0, colNames[CL_COA_ID] + "=" + coa.getOID() +
                    " and " + colNames[CL_BGT_YEAR] + "=" + year +
                    " and " + colNames[CL_BGT_MONTH] + "=" + month, "");

            if (bgts != null && bgts.size() > 0) {
                CoaBudget cb = (CoaBudget) bgts.get(0);
                result = cb.getAmount();
            }
        }

        return result;
    }

    public static double getTYBudgetRecursif(Coa coa, int year) {
        double result = 0;
        if (coa.getStatus().equals("HEADER")) {
            Vector temp = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (temp != null && temp.size() > 0) {
                for (int i = 0; i < temp.size(); i++) {
                    Coa c = (Coa) temp.get(i);
                    result = result + getTYBudgetRecursif(c, year);
                }
            }
        } else {

            String sql = "select sum(" + colNames[CL_AMOUNT] + ") from " + DB_COA_BUDGET + " where " +
                    colNames[CL_COA_ID] + "=" + coa.getOID() + " and " + colNames[CL_BGT_YEAR] + "=" + year;

            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
            } finally {
                CONResultSet.close(crs);
            }

        }

        return result;
    }

    public static double getUntilTMBudgetRecusrsif(Coa coa, int year, int month) {
        double result = 0;
        if (coa.getStatus().equals("HEADER")) {
            Vector temp = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID] + "=" + coa.getOID(), "");
            if (temp != null && temp.size() > 0) {
                for (int i = 0; i < temp.size(); i++) {
                    Coa c = (Coa) temp.get(i);
                    result = result + getUntilTMBudgetRecusrsif(c, year, month);
                }
            }
        } else {

            String sql = "select sum(" + colNames[CL_AMOUNT] + ") from " + DB_COA_BUDGET + " where " +
                    colNames[CL_COA_ID] + "=" + coa.getOID() + " and " + colNames[CL_BGT_YEAR] + "=" + year + " and " +
                    colNames[CL_BGT_MONTH] + "<=" + month;

            CONResultSet crs = null;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
            } finally {
                CONResultSet.close(crs);
            }

        }

        return result;
    }

    public static CoaBudget getValueCoaBudget(long coaId, long departmentId, int month, int year) {

        CONResultSet crs = null;

        try {

            String sql = "SELECT " + DbCoaBudget.colNames[DbCoaBudget.CL_COA_BUDGET_ID] + "," +
                    DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT] +
                    " FROM " + DbCoaBudget.DB_COA_BUDGET + " WHERE " +
                    DbCoaBudget.colNames[DbCoaBudget.CL_COA_ID] + " = " + coaId + " AND " +
                    DbCoaBudget.colNames[DbCoaBudget.CL_BGT_MONTH] + " = " + month + " AND " +
                    DbCoaBudget.colNames[DbCoaBudget.CL_BGT_YEAR] + " = " + year;

            if (departmentId != 0) {
                sql = sql + " AND " + DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID] + " = " + departmentId;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            double tmp = 0;
            CoaBudget coaBudget = new CoaBudget();
            while (rs.next()) {
                
                try {
                    coaBudget.setOID(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COA_BUDGET_ID]));
                    coaBudget.setAmount(rs.getDouble(DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT]));
                    tmp = tmp + rs.getDouble(DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT]);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }

            }
            
            coaBudget.setAmount(tmp);
            return coaBudget;
                    
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }
    
    public static CoaBudget getValueCoaBudgetBySegment(long coaId, long segment1Id, int month, int year) {

        CONResultSet crs = null;

        try {

            String sql = "SELECT " + DbCoaBudget.colNames[DbCoaBudget.CL_COA_BUDGET_ID] + "," +
                    DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT] +
                    " FROM " + DbCoaBudget.DB_COA_BUDGET + " WHERE " +
                    DbCoaBudget.colNames[DbCoaBudget.CL_COA_ID] + " = " + coaId + " AND " +
                    DbCoaBudget.colNames[DbCoaBudget.CL_BGT_MONTH] + " = " + month + " AND " +
                    DbCoaBudget.colNames[DbCoaBudget.CL_BGT_YEAR] + " = " + year;

            if (segment1Id != 0) {
                sql = sql + " AND " + DbCoaBudget.colNames[DbCoaBudget.COL_SEGMENT1_ID] + " = " + segment1Id;
            }

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            double tmp = 0;
            CoaBudget coaBudget = new CoaBudget();
            while (rs.next()) {
                
                try {
                    coaBudget.setOID(rs.getLong(DbCoaBudget.colNames[DbCoaBudget.CL_COA_BUDGET_ID]));
                    coaBudget.setAmount(rs.getDouble(DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT]));
                    tmp = tmp + rs.getDouble(DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT]);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }

            }
            
            coaBudget.setAmount(tmp);
            return coaBudget;
                    
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return null;
    }

    public static CoaBudget setCoaBudgetLevel(CoaBudget coaBudget) {

        Coa coa = new Coa();

        try {
            coa = DbCoa.fetchExc(coaBudget.getCoaId());
        } catch (Exception e) {

        }

        switch (coa.getLevel()) {
            case 1:
                coaBudget.setCoaLevel7Id(coa.getOID());
                coaBudget.setCoaLevel6Id(coa.getOID());
                coaBudget.setCoaLevel5Id(coa.getOID());
                coaBudget.setCoaLevel4Id(coa.getOID());
                coaBudget.setCoaLevel3Id(coa.getOID());
                coaBudget.setCoaLevel2Id(coa.getOID());
                coaBudget.setCoaLevel1Id(coa.getOID());
                break;
            case 2:
                coaBudget.setCoaLevel7Id(coa.getOID());
                coaBudget.setCoaLevel6Id(coa.getOID());
                coaBudget.setCoaLevel5Id(coa.getOID());
                coaBudget.setCoaLevel4Id(coa.getOID());
                coaBudget.setCoaLevel3Id(coa.getOID());
                coaBudget.setCoaLevel2Id(coa.getOID());
                coaBudget.setCoaLevel1Id(coa.getAccRefId());
                break;
            case 3:
                coaBudget.setCoaLevel7Id(coa.getOID());
                coaBudget.setCoaLevel6Id(coa.getOID());
                coaBudget.setCoaLevel5Id(coa.getOID());
                coaBudget.setCoaLevel4Id(coa.getOID());
                coaBudget.setCoaLevel3Id(coa.getOID());
                coaBudget.setCoaLevel2Id(coa.getAccRefId());
                try {
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel1Id(coa.getAccRefId());
                } catch (Exception e) {
                }
                break;
            case 4:
                coaBudget.setCoaLevel7Id(coa.getOID());
                coaBudget.setCoaLevel6Id(coa.getOID());
                coaBudget.setCoaLevel5Id(coa.getOID());
                coaBudget.setCoaLevel4Id(coa.getOID());
                coaBudget.setCoaLevel3Id(coa.getAccRefId());
                try {
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel2Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel1Id(coa.getAccRefId());
                } catch (Exception e) {
                }
                break;
            case 5:
                coaBudget.setCoaLevel7Id(coa.getOID());
                coaBudget.setCoaLevel6Id(coa.getOID());
                coaBudget.setCoaLevel5Id(coa.getOID());
                coaBudget.setCoaLevel4Id(coa.getAccRefId());
                try {
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel3Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel2Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel1Id(coa.getAccRefId());
                } catch (Exception e) {
                }
                break;
            case 6:
                coaBudget.setCoaLevel7Id(coa.getOID());
                coaBudget.setCoaLevel6Id(coa.getOID());
                coaBudget.setCoaLevel5Id(coa.getAccRefId());
                try {
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel4Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel3Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel2Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel1Id(coa.getAccRefId());
                } catch (Exception e) {
                }
                break;
            case 7:
                coaBudget.setCoaLevel7Id(coa.getOID());
                coaBudget.setCoaLevel6Id(coa.getAccRefId());
                try {
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel5Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel4Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel3Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel2Id(coa.getAccRefId());
                    coa = DbCoa.fetchExc(coa.getAccRefId());
                    coaBudget.setCoaLevel1Id(coa.getAccRefId());
                } catch (Exception e) {
                }
                break;
        }

        return coaBudget;

    }

    public static CoaBudget setCoaDepartmentLevel(CoaBudget coaBudget) {

        Department department = new Department();

        try {
            department = DbDepartment.fetchExc(coaBudget.getDepartmentId());
        } catch (Exception e) {
        }

        switch (department.getLevel()) {
            case 1:
                coaBudget.setJobId(department.getOID());
                coaBudget.setSubSectionId(department.getOID());
                coaBudget.setSectionId(department.getOID());
                coaBudget.setDepartmentId(department.getOID());
                coaBudget.setDivisionId(department.getOID());
                coaBudget.setDirektoratId(department.getOID());
                break;

            case 2:
                coaBudget.setJobId(department.getOID());
                coaBudget.setSubSectionId(department.getOID());
                coaBudget.setSectionId(department.getOID());
                coaBudget.setDepartmentId(department.getOID());
                coaBudget.setDivisionId(department.getOID());
                coaBudget.setDirektoratId(department.getRefId());
                break;
            case 3:
                coaBudget.setJobId(department.getOID());
                coaBudget.setSubSectionId(department.getOID());
                coaBudget.setSectionId(department.getOID());
                coaBudget.setDepartmentId(department.getOID());
                coaBudget.setDivisionId(department.getRefId());
                try {
                    department = DbDepartment.fetchExc(department.getRefId());
                    coaBudget.setDirektoratId(department.getRefId());

                } catch (Exception e) {
                }
                break;

            case 4:
                coaBudget.setJobId(department.getOID());
                coaBudget.setSubSectionId(department.getOID());
                coaBudget.setSectionId(department.getOID());
                coaBudget.setDepartmentId(department.getRefId());

                try {

                    department = DbDepartment.fetchExc(department.getRefId());
                    coaBudget.setDivisionId(department.getRefId());
                    department = DbDepartment.fetchExc(department.getRefId());
                    coaBudget.setDirektoratId(department.getRefId());

                } catch (Exception e) {
                }

                break;

            case 5:
                coaBudget.setJobId(department.getOID());
                coaBudget.setSubSectionId(department.getOID());
                coaBudget.setSectionId(department.getRefId());

                try {
                    department = DbDepartment.fetchExc(department.getRefId());
                    coaBudget.setDepartmentId(department.getRefId());
                    department = DbDepartment.fetchExc(department.getRefId());
                    coaBudget.setDivisionId(department.getRefId());
                    department = DbDepartment.fetchExc(department.getRefId());
                    coaBudget.setDirektoratId(department.getRefId());

                } catch (Exception e) {
                }
                break;

            case 6:

                coaBudget.setJobId(department.getOID());
                coaBudget.setSubSectionId(department.getRefId());

                try {
                    department = DbDepartment.fetchExc(department.getRefId());
                    coaBudget.setSectionId(department.getRefId());
                    coaBudget.setDepartmentId(department.getRefId());
                    department = DbDepartment.fetchExc(department.getRefId());
                    coaBudget.setDivisionId(department.getRefId());
                    department = DbDepartment.fetchExc(department.getRefId());
                    coaBudget.setDirektoratId(department.getRefId());

                } catch (Exception e) {
                }
                break;

        }

        return coaBudget;

    }
    
     public static double getAmountInPeriod(long periodId, long coaId, long departmentId){

        double result = 0;

        Periode periode = new Periode();

        if (periodId == 0 || coaId == 0) {
            return 0;
        }

        try {
            periode = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        Department dept = new Department();        
        Vector vDepartment = new Vector();
        
        try{
            dept = DbDepartment.fetchExc(departmentId);
            
            if(dept.getLevel() == DbDepartment.LEVEL_DIREKTORAT){
                String where = DbDepartment.colNames[DbDepartment.COL_REF_ID]+" = "+dept.getOID();
                Vector vDiv = DbDepartment.list(0, 0, where, null);
                
                if(vDiv != null && vDiv.size() > 0){                    
                    for(int id = 0 ; id < vDiv.size() ; id++){                        
                        Department div = (Department)vDiv.get(id);                        
                        String whereDv = DbDepartment.colNames[DbDepartment.COL_REF_ID]+" = "+div.getOID();
                        Vector vDept = DbDepartment.list(0, 0, whereDv, null);                        
                        if(vDept != null && vDept.size() > 0){
                            for(int iDep = 0 ; iDep < vDept.size() ; iDep++){                            
                                Department deptx = (Department)vDept.get(iDep);     
                                vDepartment.add(deptx);
                            }                            
                        }
                    }
                }
                
            }else if(dept.getLevel() == DbDepartment.LEVEL_DIVISION){
                
                String whereDv = DbDepartment.colNames[DbDepartment.COL_REF_ID]+" = "+dept.getOID();
                Vector vDept = DbDepartment.list(0, 0, whereDv, null);                        
                if(vDept != null && vDept.size() > 0){
                    for(int iDep = 0 ; iDep < vDept.size() ; iDep++){                            
                        Department deptx = (Department)vDept.get(iDep);     
                        vDepartment.add(deptx);
                    }                            
                }
            }else if(dept.getLevel() == DbDepartment.LEVEL_DEPARTMENT){
                
                vDepartment.add(dept);
                
            }else if(dept.getLevel() == DbDepartment.LEVEL_SECTION){
                try{                    
                    Department deptx = DbDepartment.fetchExc(dept.getRefId());
                    vDepartment.add(deptx);
                }catch(Exception e){}
           
            }else if(dept.getLevel() == DbDepartment.LEVEL_SUB_SECTION){
                try{                    
                    Department depSec = DbDepartment.fetchExc(dept.getRefId());                    
                    if(depSec.getOID() != 0){
                        Department depx = DbDepartment.fetchExc(depSec.getRefId());                    
                        vDepartment.add(depx);
                    }
                }catch(Exception e){}
                
            }else if(dept.getLevel() == DbDepartment.LEVEL_JOB){
                
                try{                    
                    Department depSubSection = DbDepartment.fetchExc(dept.getRefId());  
                    Department depSec = DbDepartment.fetchExc(depSubSection.getRefId());
                    if(depSec.getOID() != 0){
                        Department depx = DbDepartment.fetchExc(depSec.getRefId());                    
                        vDepartment.add(depx);
                    }
                }catch(Exception e){}
            }    
            
        }catch(Exception e){}        

        String sql = "";

        int month = periode.getEndDate().getMonth();
        int year = periode.getEndDate().getYear() + 1900;
        
        if(vDepartment != null && vDepartment.size() > 0){
            
            for(int iD = 0; iD < vDepartment.size(); iD++){
                Department objDept = (Department)vDepartment.get(iD);

            sql = "SELECT SUM(" + colNames[CL_AMOUNT] + ") FROM " + DB_COA_BUDGET + " WHERE " + colNames[CL_BGT_MONTH] + " = " +
                month + " AND " + colNames[CL_BGT_YEAR] + " = " + year +" AND "+DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID]+" = "+objDept.getOID();

            switch (level){
                case 1:
                    sql = sql + " AND "+ colNames[CL_COALEVEL_1_ID] + "=" + coaId;
                break;
                case 2:
                    sql = sql + " AND "+ colNames[CL_COALEVEL_2_ID] + "=" + coaId;
                break;
                case 3:
                    sql = sql + " AND "+ colNames[CL_COALEVEL_3_ID] + "=" + coaId;
                break;
                case 4:
                    sql = sql + " AND "+ colNames[CL_COALEVEL_4_ID] + "=" + coaId;
                break;
                case 5:
                    sql = sql + " AND "+ colNames[CL_COALEVEL_5_ID] + "=" + coaId;
                break;
                case 6:
                    sql = sql + " AND "+ colNames[CL_COALEVEL_6_ID] + "=" + coaId;
                break;
                case 7:
                    sql = sql + " AND "+ colNames[CL_COALEVEL_7_ID] + "=" + coaId;
                break;
            }

                System.out.println(sql);

                CONResultSet crs = null;
        
                try {
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();
                    while (rs.next()) {
                        result = result + rs.getDouble(1);
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                } finally {
                    CONResultSet.close(crs);
                }
            }
        }

        return result;

    }
     
     public static double getAmountInPeriod(long periodId, long coaId){

        double result = 0;

        Periode periode = new Periode();

        if (periodId == 0 || coaId == 0) {
            return 0;
        }

        try {
            periode = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        String sql = "";

        int month = periode.getEndDate().getMonth();
        int year = periode.getEndDate().getYear() + 1900;

        sql = "SELECT SUM(" + colNames[CL_AMOUNT] + ") FROM " + DB_COA_BUDGET + " WHERE " + colNames[CL_BGT_MONTH] + " = " +
                month + " AND " + colNames[CL_BGT_YEAR] + " = " + year ;

        switch (level){
            case 1:
                sql = sql + " AND "+ colNames[CL_COALEVEL_1_ID] + "=" + coaId;
                break;
            case 2:
                sql = sql + " AND "+ colNames[CL_COALEVEL_2_ID] + "=" + coaId;
                break;
            case 3:
                sql = sql + " AND "+ colNames[CL_COALEVEL_3_ID] + "=" + coaId;
                break;
            case 4:
                sql = sql + " AND "+ colNames[CL_COALEVEL_4_ID] + "=" + coaId;
                break;
            case 5:
                sql = sql + " AND "+ colNames[CL_COALEVEL_5_ID] + "=" + coaId;
                break;
            case 6:
                sql = sql + " AND "+ colNames[CL_COALEVEL_6_ID] + "=" + coaId;
                break;
            case 7:
                sql = sql + " AND "+ colNames[CL_COALEVEL_7_ID] + "=" + coaId;
                break;
        }

        System.out.println(sql);

        CONResultSet crs = null;
        
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }
    
     public static double getAmountToPeriod(long periodId, long coaId, long departmentId){

        Periode periode = new Periode();

        if (periodId == 0 || coaId == 0) {
            return 0;
        }

        try {
            periode = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
        
        Department dept = new Department();        
        Vector vDepartment = new Vector();
        
        try{
            dept = DbDepartment.fetchExc(departmentId);
            
            if(dept.getLevel() == DbDepartment.LEVEL_DIREKTORAT){
                String where = DbDepartment.colNames[DbDepartment.COL_REF_ID]+" = "+dept.getOID();
                Vector vDiv = DbDepartment.list(0, 0, where, null);
                
                if(vDiv != null && vDiv.size() > 0){                    
                    for(int id = 0 ; id < vDiv.size() ; id++){                        
                        Department div = (Department)vDiv.get(id);                        
                        String whereDv = DbDepartment.colNames[DbDepartment.COL_REF_ID]+" = "+div.getOID();
                        Vector vDept = DbDepartment.list(0, 0, whereDv, null);                        
                        if(vDept != null && vDept.size() > 0){
                            for(int iDep = 0 ; iDep < vDept.size() ; iDep++){                            
                                Department deptx = (Department)vDept.get(iDep);     
                                vDepartment.add(deptx);
                            }                            
                        }
                    }
                }
                
            }else if(dept.getLevel() == DbDepartment.LEVEL_DIVISION){
                
                String whereDv = DbDepartment.colNames[DbDepartment.COL_REF_ID]+" = "+dept.getOID();
                Vector vDept = DbDepartment.list(0, 0, whereDv, null);                        
                if(vDept != null && vDept.size() > 0){
                    for(int iDep = 0 ; iDep < vDept.size() ; iDep++){                            
                        Department deptx = (Department)vDept.get(iDep);     
                        vDepartment.add(deptx);
                    }                            
                }
            }else if(dept.getLevel() == DbDepartment.LEVEL_DEPARTMENT){
                
                vDepartment.add(dept);
                
            }else if(dept.getLevel() == DbDepartment.LEVEL_SECTION){
                try{                    
                    Department deptx = DbDepartment.fetchExc(dept.getRefId());
                    vDepartment.add(deptx);
                }catch(Exception e){}
           
            }else if(dept.getLevel() == DbDepartment.LEVEL_SUB_SECTION){
                try{                    
                    Department depSec = DbDepartment.fetchExc(dept.getRefId());                    
                    if(depSec.getOID() != 0){
                        Department depx = DbDepartment.fetchExc(depSec.getRefId());                    
                        vDepartment.add(depx);
                    }
                }catch(Exception e){}
                
            }else if(dept.getLevel() == DbDepartment.LEVEL_JOB){
                
                try{                    
                    Department depSubSection = DbDepartment.fetchExc(dept.getRefId());  
                    Department depSec = DbDepartment.fetchExc(depSubSection.getRefId());
                    if(depSec.getOID() != 0){
                        Department depx = DbDepartment.fetchExc(depSec.getRefId());                    
                        vDepartment.add(depx);
                    }
                }catch(Exception e){}
            }    
            
        }catch(Exception e){}        

        String sql = "";

        int month = periode.getEndDate().getMonth();
        int year = periode.getEndDate().getYear() + 1900;
        
        double total = 0;
        
        if(vDepartment != null && vDepartment.size() > 0){
            
            for(int iD = 0; iD < vDepartment.size(); iD++){
                Department objDept = (Department)vDepartment.get(iD);
        
                if(month >= 0){
                
                    for(int i = 0 ; i <= month ; i++ ){
                        double result = 0;
                
                        sql = "SELECT SUM(" + colNames[CL_AMOUNT] + ") FROM " + DB_COA_BUDGET + " WHERE " + colNames[CL_BGT_MONTH] + " = " +
                            i + " AND " + colNames[CL_BGT_YEAR] + " = " + year +" AND "+DbCoaBudget.colNames[DbCoaBudget.CL_DEPARTMENT_ID]+" = "+objDept.getOID();
                
                        switch (level){
                            case 1:
                                sql = sql + " AND "+ colNames[CL_COALEVEL_1_ID] + "=" + coaId;
                                break;
                            case 2:
                                sql = sql + " AND "+ colNames[CL_COALEVEL_2_ID] + "=" + coaId;
                                break;
                            case 3:
                                sql = sql + " AND "+ colNames[CL_COALEVEL_3_ID] + "=" + coaId;
                                break;
                            case 4:
                                sql = sql + " AND "+ colNames[CL_COALEVEL_4_ID] + "=" + coaId;
                                break;
                            case 5: 
                                sql = sql + " AND "+ colNames[CL_COALEVEL_5_ID] + "=" + coaId;
                                break;
                            case 6:
                                sql = sql + " AND "+ colNames[CL_COALEVEL_6_ID] + "=" + coaId;
                                break;
                            case 7:
                                sql = sql + " AND "+ colNames[CL_COALEVEL_7_ID] + "=" + coaId;
                                break;
                        }
                
                        CONResultSet crs = null;
        
                        try {
                            crs = CONHandler.execQueryResult(sql);
                            ResultSet rs = crs.getResultSet();
                            while (rs.next()) {
                                result = rs.getDouble(1);
                                total = total + result;
                            }
                        } catch (Exception e) {
                            System.out.println("[exception] " + e.toString());
                        } finally {
                            CONResultSet.close(crs);
                        }
                    }
                }
            }
        }        
        return total;
    }
     
    
    public static double getAmountToPeriod(long periodId, long coaId){

        Periode periode = new Periode();

        if (periodId == 0 || coaId == 0) {
            return 0;
        }

        try {
            periode = DbPeriode.fetchExc(periodId);
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        int level = 0;
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(coaId);
            level = coa.getLevel();
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        String sql = "";

        int month = periode.getEndDate().getMonth();
        int year = periode.getEndDate().getYear() + 1900;
        
        double total = 0;
        
        if(month >= 0){
            for(int i = 0 ; i <= month ; i++ ){
                double result = 0;
                
                sql = "SELECT SUM(" + colNames[CL_AMOUNT] + ") FROM " + DB_COA_BUDGET + " WHERE " + colNames[CL_BGT_MONTH] + " = " +
                    i + " AND " + colNames[CL_BGT_YEAR] + " = " + year ;
                
                switch (level){
                    case 1:
                        sql = sql + " AND "+ colNames[CL_COALEVEL_1_ID] + "=" + coaId;
                        break;
                    case 2:
                        sql = sql + " AND "+ colNames[CL_COALEVEL_2_ID] + "=" + coaId;
                        break;
                    case 3:
                        sql = sql + " AND "+ colNames[CL_COALEVEL_3_ID] + "=" + coaId;
                        break;
                    case 4:
                        sql = sql + " AND "+ colNames[CL_COALEVEL_4_ID] + "=" + coaId;
                        break;
                    case 5: 
                        sql = sql + " AND "+ colNames[CL_COALEVEL_5_ID] + "=" + coaId;
                        break;
                    case 6:
                        sql = sql + " AND "+ colNames[CL_COALEVEL_6_ID] + "=" + coaId;
                        break;
                    case 7:
                        sql = sql + " AND "+ colNames[CL_COALEVEL_7_ID] + "=" + coaId;
                        break;
                }
                
                CONResultSet crs = null;
        
                try {
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();
                    while (rs.next()) {
                        result = rs.getDouble(1);
                        total = total + result;
                    }
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                } finally {
                    CONResultSet.close(crs);
                }
            }
        }
        
        return total;

    }

     public static double getRealisasiCurrentYear(long rptDetailId, Periode period) {

        double result = 0;

        System.out.println("----- current year period : " + period.getOID());

        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                if(rdc.getDepId() != 0){
                    result = result + getAmountInPeriod(period.getOID(), rdc.getCoaId(),rdc.getDepId());
                }else{
                    result = result + getAmountInPeriod(period.getOID(), rdc.getCoaId());
                }
            }
        }

        return result;

    }
     
     public static double getRealisasiCurrentYearToPeriod(long rptDetailId, Periode period) {

        double result = 0;

        System.out.println("----- current year period : " + period.getOID());

        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {

                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                if(rdc.getDepId() != 0){
                    if (rdc.getIsMinus() == 1) {
                        result = result - getAmountToPeriod(period.getOID(), rdc.getCoaId(), rdc.getDepId());
                    }else{
                        result = result + getAmountToPeriod(period.getOID(), rdc.getCoaId(), rdc.getDepId());
                    }
                }else{
                    if (rdc.getIsMinus() == 1) {
                        result = result - getAmountToPeriod(period.getOID(), rdc.getCoaId());
                    }else{
                        result = result + getAmountToPeriod(period.getOID(), rdc.getCoaId());
                    }    
                }
            }
        }

        return result;

    }
     
    
    public static double getRealisasiLastYear(long rptDetailId, Periode period) {

        double result = 0;

        Date endDate = period.getEndDate();
        endDate.setYear(endDate.getYear() - 1);
        endDate.setDate(endDate.getDate() + 10);

        System.out.println("\n\n----- realisasi last year : date in last year period : " + endDate);

        Periode per = DbPeriode.getPeriodByTransDate(endDate);

        System.out.println("----- last year period : " + per.getOID());

        if (per.getOID() != 0) {
            Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");
            if (temp != null && temp.size() > 0) {
                for (int i = 0; i < temp.size(); i++) {
                    RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                    result = result + getAmountInPeriod(per.getOID(), rdc.getCoaId());
                }
            }
        }

        return result;

    }
    
    
    //eka ds,
    //get total budget for BKK
    public static double getTotalBudgetByCoa(long coaId, long departmentId, Periode period){
    	
    	double result = 0;
    	
    	if(coaId!=0 && period.getOID()!=0){
    		
    		Date dt = period.getStartDate();
    		int month = dt.getMonth();
    		int yr = dt.getYear()+1900;
    		
    		String sql = " select sum("+colNames[CL_AMOUNT]+") from "+DB_COA_BUDGET+
    					 " where "+colNames[CL_COA_ID]+" = "+coaId;
    					 if(departmentId!=0){
    					 	sql = sql + 
    					 		" and "+colNames[CL_DEPARTMENT_ID]+"="+departmentId;    					 			
    					 }
    					 
    					 sql = sql + 
    					 " and "+colNames[CL_BGT_MONTH]+" <= "+month+
    					 " and "+colNames[CL_BGT_YEAR]+" = "+yr;
    					 
    		System.out.println(sql);			 
    			
    		CONResultSet crs = null;
    		try{
    			crs = CONHandler.execQueryResult(sql);
    			ResultSet rs = crs.getResultSet();
    			while(rs.next()){
    				result = rs.getDouble(1);
    			}
    		}
    		catch(Exception e){
    			System.out.println(e.toString());
    		}
    		finally{
    			CONResultSet.close(crs);
    		}
    			
    		
    	}
    	
    	return result;
    }
    
    
    public static double getTotalBudgetByCoaInMonth(long coaId, long departmentId, Periode period){
    	
    	double result = 0;
    	
    	if(coaId!=0 && period.getOID()!=0){
    		
    		Date dt = period.getStartDate();
    		int month = dt.getMonth();
    		int yr = dt.getYear()+1900;
    		
    		String sql = " select sum("+colNames[CL_AMOUNT]+") from "+DB_COA_BUDGET+
    					 " where "+colNames[CL_COA_ID]+" = "+coaId;
    					 if(departmentId!=0){
    					 	sql = sql + 
    					 		" and "+colNames[CL_DEPARTMENT_ID]+"="+departmentId;    					 			
    					 }
    					 
    					 sql = sql + 
    					 " and "+colNames[CL_BGT_MONTH]+" = "+month+
    					 " and "+colNames[CL_BGT_YEAR]+" = "+yr;
    					 
    		System.out.println(sql);			 
    			
    		CONResultSet crs = null;
    		try{
    			crs = CONHandler.execQueryResult(sql);
    			ResultSet rs = crs.getResultSet();
    			while(rs.next()){
    				result = rs.getDouble(1);
    			}
    		}
    		catch(Exception e){
    			System.out.println(e.toString());
    		}
    		finally{
    			CONResultSet.close(crs);
    		}
    			
    		
    	}
    	
    	return result;
    }
    
    
    public static double getTotalBudgetByCoaInPeriod(long coaId, long departmentId, Periode period){
    	
    	double result = 0;
    	
    	if(coaId!=0 && period.getOID()!=0){
    		
    		Date dt = period.getStartDate();
    		int month = dt.getMonth();
    		int yr = dt.getYear()+1900;
    		
    		String sql = " select sum("+colNames[CL_AMOUNT]+") from "+DB_COA_BUDGET+
    					 " where "+colNames[CL_COA_ID]+" = "+coaId;
    					 if(departmentId!=0){
    					 	sql = sql + 
    					 		" and "+colNames[CL_DEPARTMENT_ID]+"="+departmentId;    					 			
    					 }
    					 
    					 sql = sql + 
    					 " and "+colNames[CL_BGT_MONTH]+" = "+month+
    					 " and "+colNames[CL_BGT_YEAR]+" = "+yr;
    			
    		CONResultSet crs = null;
    		try{
    			crs = CONHandler.execQueryResult(sql);
    			ResultSet rs = crs.getResultSet();
    			while(rs.next()){
    				result = rs.getDouble(1);
    			}
    		}
    		catch(Exception e){
    			System.out.println(e.toString());
    		}
    		finally{
    			CONResultSet.close(crs);
    		}
    			
    		
    	}
    	
    	return result;
    }
    
    
    public static double getBudgetYTD(int year,long coaId,long segment1Id){
        CONResultSet crs = null;
        double result = 0;
        try{
            String sql = "select sum("+DbCoaBudget.colNames[DbCoaBudget.CL_AMOUNT]+") from "+DbCoaBudget.DB_COA_BUDGET+" where "+DbCoaBudget.colNames[DbCoaBudget.CL_BGT_YEAR]+" = "+year+" and "+DbCoaBudget.colNames[DbCoaBudget.CL_COA_ID]+" = "+coaId+" and "+DbCoaBudget.colNames[DbCoaBudget.COL_SEGMENT1_ID]+" = "+segment1Id;
            
            try{
                crs = CONHandler.execQueryResult(sql);
    		ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }catch(Exception e){
                System.out.println(e.toString());
            }finally{
    		CONResultSet.close(crs);
            }            
        }catch(Exception e){}
        
        return result;
    }
   
}

