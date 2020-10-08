package com.project.payroll;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.system.DbSystemProperty;

public class DbDepartment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

    public static final String DB_DEPARTMET = "department";
    public static final int COL_DEPARTMENT_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_DESCRIPTION = 2;
    public static final int COL_CODE = 3;
    public static final int COL_LEVEL = 4;
    public static final int COL_REF_ID = 5;
    public static final int COL_TYPE = 6;
    public static final String[] colNames = {
        "department_id",
        "name",
        "description",
        "code",
        "level",
        "ref_id",
        "type"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_LONG,
        TYPE_STRING
    };
    public static final int LEVEL_DIREKTORAT = 0;
    public static final int LEVEL_DIVISION = 1;
    public static final int LEVEL_DEPARTMENT = 2;
    public static final int LEVEL_SECTION = 3;
    public static final int LEVEL_SUB_SECTION = 4;
    public static final int LEVEL_JOB = 5;
    public static String[] strLevel = {"Direktorat", "Division", "Department", "Section", "Sub Section", "Job"};

    public DbDepartment() {
    }

    public DbDepartment(int i) throws CONException {
        super(new DbDepartment());
    }

    public DbDepartment(String sOid) throws CONException {
        super(new DbDepartment(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbDepartment(long lOid) throws CONException {
        super(new DbDepartment(0));
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
        return DB_DEPARTMET;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbDepartment().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Department department = fetchExc(ent.getOID());
        ent = (Entity) department;
        return department.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Department) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Department) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Department fetchExc(long oid) throws CONException {
        try {
            Department department = new Department();
            DbDepartment pstDepartment = new DbDepartment(oid);
            department.setOID(oid);

            department.setName(pstDepartment.getString(COL_NAME));
            department.setDescription(pstDepartment.getString(COL_DESCRIPTION));

            department.setCode(pstDepartment.getString(COL_CODE));
            department.setLevel(pstDepartment.getInt(COL_LEVEL));
            department.setRefId(pstDepartment.getlong(COL_REF_ID));

            department.setType(pstDepartment.getString(COL_TYPE));

            return department;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDepartment(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Department department) throws CONException {
        try {
            DbDepartment pstDepartment = new DbDepartment(0);

            pstDepartment.setString(COL_NAME, department.getName());
            pstDepartment.setString(COL_DESCRIPTION, department.getDescription());

            pstDepartment.setString(COL_CODE, department.getCode());
            pstDepartment.setInt(COL_LEVEL, department.getLevel());
            pstDepartment.setLong(COL_REF_ID, department.getRefId());

            pstDepartment.setString(COL_TYPE, department.getType());

            pstDepartment.insert();
            department.setOID(pstDepartment.getlong(COL_DEPARTMENT_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDepartment(0), CONException.UNKNOWN);
        }
        return department.getOID();
    }

    public static long updateExc(Department department) throws CONException {
        try {
            if (department.getOID() != 0) {
                DbDepartment pstDepartment = new DbDepartment(department.getOID());

                pstDepartment.setString(COL_NAME, department.getName());
                pstDepartment.setString(COL_DESCRIPTION, department.getDescription());

                pstDepartment.setString(COL_CODE, department.getCode());
                pstDepartment.setInt(COL_LEVEL, department.getLevel());
                pstDepartment.setLong(COL_REF_ID, department.getRefId());

                pstDepartment.setString(COL_TYPE, department.getType());

                pstDepartment.update();
                return department.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDepartment(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbDepartment pstDepartment = new DbDepartment(oid);
            pstDepartment.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDepartment(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_DEPARTMET;
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
                Department department = new Department();
                resultToObject(rs, department);
                lists.add(department);
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

    private static void resultToObject(ResultSet rs, Department department) {
        try {
            department.setOID(rs.getLong(DbDepartment.colNames[DbDepartment.COL_DEPARTMENT_ID]));
            department.setName(rs.getString(DbDepartment.colNames[DbDepartment.COL_NAME]));
            department.setDescription(rs.getString(DbDepartment.colNames[DbDepartment.COL_DESCRIPTION]));

            department.setCode(rs.getString(DbDepartment.colNames[DbDepartment.COL_CODE]));
            department.setLevel(rs.getInt(DbDepartment.colNames[DbDepartment.COL_LEVEL]));
            department.setRefId(rs.getLong(DbDepartment.colNames[DbDepartment.COL_REF_ID]));
            department.setType(rs.getString(DbDepartment.colNames[DbDepartment.COL_TYPE]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long departmentId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_DEPARTMET + " WHERE " +
                    DbDepartment.colNames[DbDepartment.COL_DEPARTMENT_ID] + " = " + departmentId;

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
            String sql = "SELECT COUNT(" + DbDepartment.colNames[DbDepartment.COL_DEPARTMENT_ID] + ") FROM " + DB_DEPARTMET;
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
                    Department department = (Department) list.get(ls);
                    if (oid == department.getOID()) {
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

    public static Vector getHirarkiDepartment() {

        int org_rpt_level = 2; //default level department

        try {
            org_rpt_level = Integer.parseInt(DbSystemProperty.getValueByName("ORGANIZATION_REPORT_LEVEL"));
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }

        Vector listDepartment = new Vector();
        String order = colNames[COL_CODE];

        switch (org_rpt_level) {

            case 0:

                Vector tmpDeptA = DbDepartment.list(0, 0, "" + colNames[COL_LEVEL] + "=" + LEVEL_DIREKTORAT, order);

                for (int i = 0; i < tmpDeptA.size(); i++) {

                    Department dept = (Department) tmpDeptA.get(i);
                    dept.setName(dept.getCode() + " - " + dept.getName());
                    listDepartment.add(dept);

                }

                break;

            case 1:

                String where = "( " + colNames[COL_LEVEL] + " = " + LEVEL_DIREKTORAT + ")";

                Vector tmpDept = DbDepartment.list(0, 0, where, order);

                for (int i = 0; i < tmpDept.size(); i++) {

                    Department dept = (Department) tmpDept.get(i);

                    dept.setName(dept.getCode() + " - " + dept.getName());
                    listDepartment.add(dept);

                    String whereRef = colNames[COL_REF_ID] + " = " + dept.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_DIVISION;

                    Vector tmp2Dept = DbDepartment.list(0, 0, whereRef, order);

                    for (int j = 0; j < tmp2Dept.size(); j++) {

                        Department dept2 = (Department) tmp2Dept.get(j);
                        dept2.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept2.getCode() + " - " + dept2.getName());

                        listDepartment.add(dept2);
                    }
                }

                break;

            case 2:

                String whereC = "( " + colNames[COL_LEVEL] + " = " + LEVEL_DIREKTORAT + ")";

                Vector tmpDeptC = DbDepartment.list(0, 0, whereC, order);

                for (int i = 0; i < tmpDeptC.size(); i++) {

                    Department dept = (Department) tmpDeptC.get(i);

                    dept.setName(dept.getCode() + " - " + dept.getName());
                    listDepartment.add(dept);

                    String whereRef = colNames[COL_REF_ID] + " = " + dept.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_DIVISION;

                    Vector tmp2Dept = DbDepartment.list(0, 0, whereRef, order);

                    for (int j = 0; j < tmp2Dept.size(); j++) {

                        Department dept2 = (Department) tmp2Dept.get(j);
                        dept2.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept2.getCode() + " - " + dept2.getName());

                        listDepartment.add(dept2);

                        String whereRef2 = colNames[COL_REF_ID] + " = " + dept2.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_DEPARTMENT;

                        Vector tmp2Dept2 = DbDepartment.list(0, 0, whereRef2, order);

                        for (int x = 0; x < tmp2Dept2.size(); x++) {

                            Department dept3 = (Department) tmp2Dept2.get(x);
                            dept3.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept3.getCode() + " - " + dept3.getName());

                            listDepartment.add(dept3);
                        }

                    }

                }

                break;

            case 3:

                String whereD = "( " + colNames[COL_LEVEL] + " = " + LEVEL_DIREKTORAT + ")";

                Vector tmpDeptD = DbDepartment.list(0, 0, whereD, order);

                for (int i = 0; i < tmpDeptD.size(); i++) {

                    Department dept = (Department) tmpDeptD.get(i);

                    dept.setName(dept.getCode() + " - " + dept.getName());
                    listDepartment.add(dept);

                    String whereRef = colNames[COL_REF_ID] + " = " + dept.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_DIVISION;

                    Vector tmp2Dept = DbDepartment.list(0, 0, whereRef, order);

                    for (int j = 0; j < tmp2Dept.size(); j++) {

                        Department dept2 = (Department) tmp2Dept.get(j);
                        dept2.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept2.getCode() + " - " + dept2.getName());

                        listDepartment.add(dept2);

                        String whereRef2 = colNames[COL_REF_ID] + " = " + dept2.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_DEPARTMENT;

                        Vector tmp2Dept2 = DbDepartment.list(0, 0, whereRef2, order);

                        for (int x = 0; x < tmp2Dept2.size(); x++) {

                            Department dept3 = (Department) tmp2Dept2.get(x);
                            dept3.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept3.getCode() + " - " + dept3.getName());

                            listDepartment.add(dept3);

                            String whereRef3 = colNames[COL_REF_ID] + " = " + dept3.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_SECTION;

                            Vector tmp2Dept3 = DbDepartment.list(0, 0, whereRef3, order);

                            for (int z = 0; z < tmp2Dept3.size(); z++) {

                                Department dept4 = (Department) tmp2Dept3.get(z);
                                dept3.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept4.getCode() + " - " + dept4.getName());

                                listDepartment.add(dept4);

                            }

                        }

                    }

                }

                break;

            case 4:

                String whereE = "( " + colNames[COL_LEVEL] + " = " + LEVEL_DIREKTORAT + ")";

                Vector tmpDeptE = DbDepartment.list(0, 0, whereE, order);

                for (int i = 0; i < tmpDeptE.size(); i++) {

                    Department dept = (Department) tmpDeptE.get(i);

                    dept.setName(dept.getCode() + " - " + dept.getName());
                    listDepartment.add(dept);

                    String whereRef = colNames[COL_REF_ID] + " = " + dept.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_DIVISION;

                    Vector tmp2Dept = DbDepartment.list(0, 0, whereRef, order);

                    for (int j = 0; j < tmp2Dept.size(); j++) {

                        Department dept2 = (Department) tmp2Dept.get(j);
                        dept2.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept2.getCode() + " - " + dept2.getName());

                        listDepartment.add(dept2);

                        String whereRef2 = colNames[COL_REF_ID] + " = " + dept2.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_DEPARTMENT;

                        Vector tmp2Dept2 = DbDepartment.list(0, 0, whereRef2, order);

                        for (int x = 0; x < tmp2Dept2.size(); x++) {

                            Department dept3 = (Department) tmp2Dept2.get(x);
                            dept3.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept3.getCode() + " - " + dept3.getName());

                            listDepartment.add(dept3);

                            String whereRef3 = colNames[COL_REF_ID] + " = " + dept3.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_SECTION;

                            Vector tmp2Dept3 = DbDepartment.list(0, 0, whereRef3, order);

                            for (int z = 0; z < tmp2Dept3.size(); z++) {

                                Department dept4 = (Department) tmp2Dept3.get(z);
                                dept4.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept4.getCode() + " - " + dept4.getName());

                                listDepartment.add(dept4);

                                String whereRef4 = colNames[COL_REF_ID] + " = " + dept4.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_SUB_SECTION;

                                Vector tmp2Dept4 = DbDepartment.list(0, 0, whereRef4, order);

                                for (int f = 0; f < tmp2Dept4.size(); f++) {

                                    Department dept5 = (Department) tmp2Dept4.get(x);
                                    dept5.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept5.getCode() + " - " + dept5.getName());

                                    listDepartment.add(dept5);
                                }

                            }

                        }

                    }

                }

                break;


            case 5:

                String whereF = "( " + colNames[COL_LEVEL] + " = " + LEVEL_DIREKTORAT + ")";

                Vector tmpDeptF = DbDepartment.list(0, 0, whereF, order);

                for (int i = 0; i < tmpDeptF.size(); i++) {

                    Department dept = (Department) tmpDeptF.get(i);

                    dept.setName(dept.getCode() + " - " + dept.getName());
                    listDepartment.add(dept);

                    String whereRef = colNames[COL_REF_ID] + " = " + dept.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_DIVISION;

                    Vector tmp2Dept = DbDepartment.list(0, 0, whereRef, order);

                    for (int j = 0; j < tmp2Dept.size(); j++) {

                        Department dept2 = (Department) tmp2Dept.get(j);
                        dept2.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept2.getCode() + " - " + dept2.getName());

                        listDepartment.add(dept2);

                        String whereRef2 = colNames[COL_REF_ID] + " = " + dept2.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_DEPARTMENT;

                        Vector tmp2Dept2 = DbDepartment.list(0, 0, whereRef2, order);

                        for (int x = 0; x < tmp2Dept2.size(); x++) {

                            Department dept3 = (Department) tmp2Dept2.get(x);
                            dept3.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept3.getCode() + " - " + dept3.getName());

                            listDepartment.add(dept3);

                            String whereRef3 = colNames[COL_REF_ID] + " = " + dept3.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_SECTION;

                            Vector tmp2Dept3 = DbDepartment.list(0, 0, whereRef3, order);

                            for (int z = 0; z < tmp2Dept3.size(); z++) {

                                Department dept4 = (Department) tmp2Dept3.get(z);
                                dept4.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept4.getCode() + " - " + dept4.getName());

                                listDepartment.add(dept4);

                                String whereRef4 = colNames[COL_REF_ID] + " = " + dept4.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_SUB_SECTION;

                                Vector tmp2Dept4 = DbDepartment.list(0, 0, whereRef4, order);

                                for (int f = 0; f < tmp2Dept4.size(); f++) {

                                    Department dept5 = (Department) tmp2Dept4.get(f);
                                    dept5.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept5.getCode() + " - " + dept5.getName());

                                    listDepartment.add(dept5);

                                    String whereRef5 = colNames[COL_REF_ID] + " = " + dept5.getOID() + " AND " + colNames[COL_LEVEL] + " = " + LEVEL_JOB;

                                    Vector tmp2Dept5 = DbDepartment.list(0, 0, whereRef5, order);

                                    for (int v = 0; v < tmp2Dept5.size(); v++) {

                                        Department dept6 = (Department) tmp2Dept5.get(v);
                                        dept6.setName("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + dept6.getCode() + " - " + dept6.getName());

                                        listDepartment.add(dept6);

                                    }

                                }

                            }

                        }

                    }

                }

        }

        return listDepartment;

    }
}
