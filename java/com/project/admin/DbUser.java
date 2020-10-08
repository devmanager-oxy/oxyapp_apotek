package com.project.admin;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.system.DbSystemProperty;
import com.project.util.MD5;

public class DbUser extends CONHandler implements I_CONInterface, I_CONType, I_Persintent {

    public static final String DB_APP_USER = "sysuser";
    public static final int COL_USER_ID = 0;
    public static final int COL_LOGIN_ID = 1;
    public static final int COL_PASSWORD = 2;
    public static final int COL_FULL_NAME = 3;
    public static final int COL_EMAIL = 4;
    public static final int COL_DESCRIPTION = 5;
    public static final int COL_REG_DATE = 6;
    public static final int COL_UPDATE_DATE = 7;
    public static final int COL_USER_STATUS = 8;
    public static final int COL_LAST_LOGIN_DATE = 9;
    public static final int COL_LAST_LOGIN_IP = 10;
    public static final int COL_EMPLOYEE_ID = 11;
    public static final int COL_EMPLOYEE_NUM = 12;
    public static final int COL_USER_LEVEL = 13;
    public static final int COL_LAST_LOGIN_DATE1 = 14;
    public static final int COL_SEGMENT1_ID = 15;
    public static final int COL_SEGMENT2_ID = 16;
    public static final int COL_SEGMENT3_ID = 17;
    public static final int COL_SEGMENT4_ID = 18;
    public static final int COL_SEGMENT5_ID = 19;
    public static final int COL_SEGMENT6_ID = 20;
    public static final int COL_SEGMENT7_ID = 21;
    public static final int COL_SEGMENT8_ID = 22;
    public static final int COL_SEGMENT9_ID = 23;
    public static final int COL_SEGMENT10_ID = 24;
    public static final int COL_SEGMENT11_ID = 25;
    public static final int COL_SEGMENT12_ID = 26;
    public static final int COL_SEGMENT13_ID = 27;
    public static final int COL_SEGMENT14_ID = 28;
    public static final int COL_SEGMENT15_ID = 29;
    public static final int COL_COMPANY_ID = 30;
    public static final int COL_USER_KEY = 31;
    public static final int COL_RESET_PASSWORD = 32;
    
    public static final String[] colNames = {
        "user_id",
        "login_id",
        "password",
        "full_name",
        "email",
        "description",
        "reg_date",
        "update_date",
        "user_status",
        "last_login_date",
        "last_login_ip",
        "employee_id",
        "employee_num",
        "user_level",
        "last_login_date1",
        "segment1_id",
        "segment2_id",
        "segment3_id",
        "segment4_id",
        "segment5_id",
        "segment6_id",
        "segment7_id",
        "segment8_id",
        "segment9_id",
        "segment10_id",
        "segment11_id",
        "segment12_id",
        "segment13_id",
        "segment14_id",
        "segment15_id",
        "company_id",
        "user_key",
        "reset_password"
    ,
                                                                                                                                                                                                                           };
    public static  int   [] fieldTypes = {
        TYPE_PK + TYPE_LONG + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_INT,
        TYPE_DATE,
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
        TYPE_LONG,
        TYPE_STRING,
        TYPE_BOOL
    };
    
    public static final int LEVEL_OPERATOR = 0;
    public static final int LEVEL_SUPERVISOR = 1;
    public static final int LEVEL_MANAGER = 2;
    public static final int LEVEL_COMPANY_ADMINISTRATOR = 3;
    public static final int LEVEL_SYSTEM_ADMINISTRATOR = 1111111;
    public static final int LEVEL_SUPERVISOR_AREA = 4;
    public static final int LEVEL_ASSISTEN_MANAGER = 5;
    
    public static final String[] levelStr = {
        "Operator",
        "Supervisor",
        "Manager",
        "Company Administrator",
        "Supervisor Area",
        "Assisten Manager"
    };

    /** Creates new DbUser */
    public DbUser() {
    }

    public DbUser(int i) throws CONException {
        super(new DbUser());
    }

    public DbUser(String sOid) throws CONException {
        super(new DbUser(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbUser(long lOid) throws CONException {
        super(new DbUser(0));
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
        return DB_APP_USER;
    }

    public String getPersistentName() {
        return new DbUser().getClass().getName();
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public long delete(Entity ent) {
        return delete((User) ent);
    }

    public static void updateUserKey(long userId, String userKey) {
        try {
            CONHandler.execUpdate("update " + DB_APP_USER + " set " + colNames[COL_USER_KEY] + "='" + userKey + "' where " + colNames[COL_USER_ID] + "=" + userId);
        } catch (Exception e) {

        }
    }

    public long insert(Entity ent) {
        try {
            return DbUser.insert((User) ent);
        } catch (Exception e) {
            System.out.println(" EXC " + e);
            return 0;
        }
    }

    public long update(Entity ent) {
        return update((User) ent);
    }

    public long fetch(Entity ent) {
        User entObj = DbUser.fetch(ent.getOID());
        ent = (Entity) entObj;
        return ent.getOID();
    }

    public static User fetch(long oid) {
        User entObj = new User();
        try {
            DbUser pstObj = new DbUser(oid);
            entObj.setOID(oid);
            entObj.setLoginId(pstObj.getString(COL_LOGIN_ID));
            entObj.setPassword(pstObj.getString(COL_PASSWORD));
            entObj.setFullName(pstObj.getString(COL_FULL_NAME));
            entObj.setEmail(pstObj.getString(COL_EMAIL));
            entObj.setDescription(pstObj.getString(COL_DESCRIPTION));
            entObj.setRegDate(pstObj.getDate(COL_REG_DATE));
            entObj.setUpdateDate(pstObj.getDate(COL_UPDATE_DATE));
            entObj.setUserStatus(pstObj.getInt(COL_USER_STATUS));
            entObj.setLastLoginDate(pstObj.getDate(COL_LAST_LOGIN_DATE));
            entObj.setLastLoginIp(pstObj.getString(COL_LAST_LOGIN_IP));
            entObj.setEmployeeId(pstObj.getlong(COL_EMPLOYEE_ID));
            entObj.setEmployeeNum(pstObj.getString(COL_EMPLOYEE_NUM));
            entObj.setUserLevel(pstObj.getInt(COL_USER_LEVEL));
            entObj.setCompanyId(pstObj.getlong(COL_COMPANY_ID));
            entObj.setLastLoginDate1(pstObj.getDate(COL_LAST_LOGIN_DATE1));
            entObj.setSegment1Id(pstObj.getlong(COL_SEGMENT1_ID));
            entObj.setSegment2Id(pstObj.getlong(COL_SEGMENT2_ID));
            entObj.setSegment3Id(pstObj.getlong(COL_SEGMENT3_ID));
            entObj.setSegment4Id(pstObj.getlong(COL_SEGMENT4_ID));
            entObj.setSegment5Id(pstObj.getlong(COL_SEGMENT5_ID));
            entObj.setSegment6Id(pstObj.getlong(COL_SEGMENT6_ID));
            entObj.setSegment7Id(pstObj.getlong(COL_SEGMENT7_ID));
            entObj.setSegment8Id(pstObj.getlong(COL_SEGMENT8_ID));
            entObj.setSegment9Id(pstObj.getlong(COL_SEGMENT9_ID));
            entObj.setSegment10Id(pstObj.getlong(COL_SEGMENT10_ID));
            entObj.setSegment11Id(pstObj.getlong(COL_SEGMENT11_ID));
            entObj.setSegment12Id(pstObj.getlong(COL_SEGMENT12_ID));
            entObj.setSegment13Id(pstObj.getlong(COL_SEGMENT13_ID));
            entObj.setSegment14Id(pstObj.getlong(COL_SEGMENT14_ID));
            entObj.setSegment15Id(pstObj.getlong(COL_SEGMENT15_ID));
            entObj.setCompanyId(pstObj.getlong(COL_COMPANY_ID));
            entObj.setUserKey(pstObj.getString(COL_USER_KEY));
            entObj.setResetPassword(pstObj.getBoolean(COL_RESET_PASSWORD));
        } catch (CONException e) {
            System.out.println(e);
        }
        return entObj;
    }

    public static long insert(User entObj) throws CONException {
        DbUser pstObj = new DbUser(0);
        pstObj.setString(COL_LOGIN_ID, entObj.getLoginId());
        pstObj.setString(COL_PASSWORD, entObj.getPassword());
        pstObj.setString(COL_FULL_NAME, entObj.getFullName());
        pstObj.setString(COL_EMAIL, entObj.getEmail());
        pstObj.setString(COL_DESCRIPTION, entObj.getDescription());
        pstObj.setDate(COL_REG_DATE, new Date());
        pstObj.setDate(COL_UPDATE_DATE, new Date());
        pstObj.setInt(COL_USER_STATUS, entObj.getUserStatus());
        pstObj.setLong(COL_EMPLOYEE_ID, entObj.getEmployeeId());
        pstObj.setString(COL_EMPLOYEE_NUM, entObj.getEmployeeNum());
        pstObj.setInt(COL_USER_LEVEL, entObj.getUserLevel());
        pstObj.setDate(COL_LAST_LOGIN_DATE1, entObj.getLastLoginDate1());
        pstObj.setDate(COL_LAST_LOGIN_DATE, entObj.getLastLoginDate());
        pstObj.setString(COL_LAST_LOGIN_IP, entObj.getLastLoginIp());
        pstObj.setLong(COL_SEGMENT1_ID, entObj.getSegment1Id());
        pstObj.setLong(COL_SEGMENT2_ID, entObj.getSegment2Id());
        pstObj.setLong(COL_SEGMENT3_ID, entObj.getSegment3Id());
        pstObj.setLong(COL_SEGMENT4_ID, entObj.getSegment4Id());
        pstObj.setLong(COL_SEGMENT5_ID, entObj.getSegment5Id());
        pstObj.setLong(COL_SEGMENT6_ID, entObj.getSegment6Id());
        pstObj.setLong(COL_SEGMENT7_ID, entObj.getSegment7Id());
        pstObj.setLong(COL_SEGMENT8_ID, entObj.getSegment8Id());
        pstObj.setLong(COL_SEGMENT9_ID, entObj.getSegment9Id());
        pstObj.setLong(COL_SEGMENT10_ID, entObj.getSegment10Id());
        pstObj.setLong(COL_SEGMENT11_ID, entObj.getSegment11Id());
        pstObj.setLong(COL_SEGMENT12_ID, entObj.getSegment12Id());
        pstObj.setLong(COL_SEGMENT13_ID, entObj.getSegment13Id());
        pstObj.setLong(COL_SEGMENT14_ID, entObj.getSegment14Id());
        pstObj.setLong(COL_SEGMENT15_ID, entObj.getSegment15Id());
        pstObj.setLong(COL_COMPANY_ID, entObj.getCompanyId());
        pstObj.setString(COL_USER_KEY, entObj.getUserKey());
        pstObj.setBoolean(COL_RESET_PASSWORD, entObj.isResetPassword());
        
        pstObj.insert();
        entObj.setOID(pstObj.getlong(COL_USER_ID));
        return entObj.getOID();
    }

    public static long update(User entObj) {
        if ((entObj != null) && (entObj.getOID() != 0)) {
            try {
                DbUser pstObj = new DbUser(entObj.getOID());

                pstObj.setString(COL_LOGIN_ID, entObj.getLoginId());
                pstObj.setString(COL_PASSWORD, entObj.getPassword());
                pstObj.setString(COL_FULL_NAME, entObj.getFullName());
                pstObj.setString(COL_EMAIL, entObj.getEmail());
                pstObj.setString(COL_DESCRIPTION, entObj.getDescription());
                pstObj.setDate(COL_UPDATE_DATE, new Date());
                pstObj.setInt(COL_USER_STATUS, entObj.getUserStatus());
                pstObj.setDate(COL_LAST_LOGIN_DATE, entObj.getLastLoginDate());
                pstObj.setDate(COL_LAST_LOGIN_DATE1, entObj.getLastLoginDate1());
                pstObj.setString(COL_LAST_LOGIN_IP, entObj.getLastLoginIp());
                pstObj.setLong(COL_EMPLOYEE_ID, entObj.getEmployeeId());
                pstObj.setLong(COL_COMPANY_ID, entObj.getCompanyId());
                pstObj.setString(COL_EMPLOYEE_NUM, entObj.getEmployeeNum());
                pstObj.setInt(COL_USER_LEVEL, entObj.getUserLevel());
                pstObj.setLong(COL_SEGMENT1_ID, entObj.getSegment1Id());
                pstObj.setLong(COL_SEGMENT2_ID, entObj.getSegment2Id());
                pstObj.setLong(COL_SEGMENT3_ID, entObj.getSegment3Id());
                pstObj.setLong(COL_SEGMENT4_ID, entObj.getSegment4Id());
                pstObj.setLong(COL_SEGMENT5_ID, entObj.getSegment5Id());
                pstObj.setLong(COL_SEGMENT6_ID, entObj.getSegment6Id());
                pstObj.setLong(COL_SEGMENT7_ID, entObj.getSegment7Id());
                pstObj.setLong(COL_SEGMENT8_ID, entObj.getSegment8Id());
                pstObj.setLong(COL_SEGMENT9_ID, entObj.getSegment9Id());
                pstObj.setLong(COL_SEGMENT10_ID, entObj.getSegment10Id());
                pstObj.setLong(COL_SEGMENT11_ID, entObj.getSegment11Id());
                pstObj.setLong(COL_SEGMENT12_ID, entObj.getSegment12Id());
                pstObj.setLong(COL_SEGMENT13_ID, entObj.getSegment13Id());
                pstObj.setLong(COL_SEGMENT14_ID, entObj.getSegment14Id());
                pstObj.setLong(COL_SEGMENT15_ID, entObj.getSegment15Id());
                pstObj.setLong(COL_COMPANY_ID, entObj.getCompanyId());
                pstObj.setString(COL_USER_KEY, entObj.getUserKey());
                pstObj.setBoolean(COL_RESET_PASSWORD, entObj.isResetPassword());

                if ((entObj.getLoginId() != null && entObj.getLoginId().length() > 0 && !(entObj.getLoginId().equalsIgnoreCase("NULL"))) &&
                        (entObj.getPassword() != null && entObj.getPassword().length() > 0 && !(entObj.getPassword().equalsIgnoreCase("NULL")))) {
                    pstObj.updateLoginUser();
                }

                return entObj.getOID();
            } catch (Exception e) {
                System.out.println(e);
            }
        }
        return 0;
    }
    
    public static long updateUser(User entObj) {
        if ((entObj != null) && (entObj.getOID() != 0)) {
            try {
                DbUser pstObj = new DbUser(entObj.getOID());

                pstObj.setString(COL_LOGIN_ID, entObj.getLoginId());
                pstObj.setString(COL_PASSWORD, entObj.getPassword());
                pstObj.setString(COL_FULL_NAME, entObj.getFullName());
                pstObj.setString(COL_EMAIL, entObj.getEmail());
                pstObj.setString(COL_DESCRIPTION, entObj.getDescription());
                pstObj.setDate(COL_UPDATE_DATE, new Date());
                pstObj.setInt(COL_USER_STATUS, entObj.getUserStatus());
                pstObj.setDate(COL_LAST_LOGIN_DATE, entObj.getLastLoginDate());
                pstObj.setDate(COL_LAST_LOGIN_DATE1, entObj.getLastLoginDate1());
                pstObj.setString(COL_LAST_LOGIN_IP, entObj.getLastLoginIp());
                pstObj.setLong(COL_EMPLOYEE_ID, entObj.getEmployeeId());
                pstObj.setLong(COL_COMPANY_ID, entObj.getCompanyId());
                pstObj.setString(COL_EMPLOYEE_NUM, entObj.getEmployeeNum());
                pstObj.setInt(COL_USER_LEVEL, entObj.getUserLevel());
                pstObj.setLong(COL_SEGMENT1_ID, entObj.getSegment1Id());
                pstObj.setLong(COL_SEGMENT2_ID, entObj.getSegment2Id());
                pstObj.setLong(COL_SEGMENT3_ID, entObj.getSegment3Id());
                pstObj.setLong(COL_SEGMENT4_ID, entObj.getSegment4Id());
                pstObj.setLong(COL_SEGMENT5_ID, entObj.getSegment5Id());
                pstObj.setLong(COL_SEGMENT6_ID, entObj.getSegment6Id());
                pstObj.setLong(COL_SEGMENT7_ID, entObj.getSegment7Id());
                pstObj.setLong(COL_SEGMENT8_ID, entObj.getSegment8Id());
                pstObj.setLong(COL_SEGMENT9_ID, entObj.getSegment9Id());
                pstObj.setLong(COL_SEGMENT10_ID, entObj.getSegment10Id());
                pstObj.setLong(COL_SEGMENT11_ID, entObj.getSegment11Id());
                pstObj.setLong(COL_SEGMENT12_ID, entObj.getSegment12Id());
                pstObj.setLong(COL_SEGMENT13_ID, entObj.getSegment13Id());
                pstObj.setLong(COL_SEGMENT14_ID, entObj.getSegment14Id());
                pstObj.setLong(COL_SEGMENT15_ID, entObj.getSegment15Id());
                pstObj.setLong(COL_COMPANY_ID, entObj.getCompanyId());
                pstObj.setString(COL_USER_KEY, entObj.getUserKey());
                pstObj.setBoolean(COL_RESET_PASSWORD, entObj.isResetPassword());

                if ((entObj.getLoginId() != null && entObj.getLoginId().length() > 0 && !(entObj.getLoginId().equalsIgnoreCase("NULL"))) &&
                        (entObj.getPassword() != null && entObj.getPassword().length() > 0 && !(entObj.getPassword().equalsIgnoreCase("NULL")))) {
                    pstObj.update();
                }

                return entObj.getOID();
            } catch (Exception e) {
                System.out.println(e);
            }
        }
        return 0;
    }
    
    public void updateLoginUser()
            throws CONException {
        if (!hasData) {
            throw new CONException(this, CONException.NOT_OPEN);
        }
        if (!recordModified) {
            return;
        }
        Connection connection = null;
        Statement statement = null;
        try {
            connection = getConnection();
            checkConcurrency(connection);
            statement = getStatement(connection);
            String queryUpdate = getUpdateSQL();
            statement.executeUpdate(queryUpdate);

        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new CONException(this, sqlexception);
        } finally {
            closeStatement(statement);
            closeConnection(connection);
        }
    }
    

    public static long delete(long oid) {
        try {
            DbUser pstObj = new DbUser(oid);
            pstObj.delete();
            return oid;
        } catch (Exception e) {
            System.out.println(e);
        }
        return 0;
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            int count = 0;
            String sql = " SELECT COUNT(" + colNames[COL_USER_ID] + ") AS NRCOUNT" +
                    " FROM " + DB_APP_USER;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
            return count;
        } catch (Exception exc) {
            System.out.println("getCount " + exc);
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }

    }

    public static Vector listPartObj(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT " + colNames[COL_USER_ID] + 
                    ", " + colNames[COL_LOGIN_ID] + 
                    ", " + colNames[COL_FULL_NAME] + 
                    ", " + colNames[COL_EMAIL] + 
                    ", " + colNames[COL_USER_STATUS] + 
                    ", " + colNames[COL_EMPLOYEE_ID] + 
                    ", " + colNames[COL_DESCRIPTION] + 
                    ", " + colNames[COL_COMPANY_ID] + 
                    ", " + colNames[COL_EMPLOYEE_NUM] + 
                    ", " + colNames[COL_USER_LEVEL] + 
                    ", " + colNames[COL_USER_KEY] + " FROM " + DB_APP_USER;

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
                User appUser = new User();
                
                appUser.setOID(rs.getLong(colNames[COL_USER_ID]));
                appUser.setLoginId(rs.getString(colNames[COL_LOGIN_ID]));
                appUser.setFullName(rs.getString(colNames[COL_FULL_NAME]));
                appUser.setEmail(rs.getString(colNames[COL_EMAIL]));
                appUser.setUserStatus(rs.getInt(colNames[COL_USER_STATUS]));
                appUser.setEmployeeId(rs.getLong(colNames[COL_EMPLOYEE_ID]));
                appUser.setDescription(rs.getString(colNames[COL_DESCRIPTION]));
                appUser.setCompanyId(rs.getLong(colNames[COL_COMPANY_ID]));
                appUser.setEmployeeNum(rs.getString(colNames[COL_EMPLOYEE_NUM]));
                appUser.setUserLevel(rs.getInt(colNames[COL_USER_LEVEL]));
                appUser.setUserKey(rs.getString(colNames[COL_USER_KEY]));
                
                lists.add(appUser);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, User entObj) {
        try {
            entObj.setOID(rs.getLong(colNames[COL_USER_ID]));
            entObj.setLoginId(rs.getString(colNames[COL_LOGIN_ID]));
            entObj.setFullName(rs.getString(colNames[COL_FULL_NAME]));
            entObj.setEmail(rs.getString(colNames[COL_EMAIL]));
            entObj.setUserStatus(rs.getInt(colNames[COL_USER_STATUS]));
            entObj.setEmployeeId(rs.getLong(colNames[COL_EMPLOYEE_ID]));
            entObj.setDescription(rs.getString(colNames[COL_DESCRIPTION]));
            entObj.setEmployeeNum(rs.getString(colNames[COL_EMPLOYEE_NUM]));
            entObj.setUserLevel(rs.getInt(colNames[COL_USER_LEVEL]));
            entObj.setSegment1Id(rs.getLong(colNames[COL_SEGMENT1_ID]));
            entObj.setSegment2Id(rs.getLong(colNames[COL_SEGMENT2_ID]));
            entObj.setSegment3Id(rs.getLong(colNames[COL_SEGMENT3_ID]));
            entObj.setSegment4Id(rs.getLong(colNames[COL_SEGMENT4_ID]));
            entObj.setSegment5Id(rs.getLong(colNames[COL_SEGMENT5_ID]));
            entObj.setSegment6Id(rs.getLong(colNames[COL_SEGMENT6_ID]));
            entObj.setSegment7Id(rs.getLong(colNames[COL_SEGMENT7_ID]));
            entObj.setSegment8Id(rs.getLong(colNames[COL_SEGMENT8_ID]));
            entObj.setSegment9Id(rs.getLong(colNames[COL_SEGMENT9_ID]));
            entObj.setSegment10Id(rs.getLong(colNames[COL_SEGMENT10_ID]));
            entObj.setSegment11Id(rs.getLong(colNames[COL_SEGMENT11_ID]));
            entObj.setSegment12Id(rs.getLong(colNames[COL_SEGMENT12_ID]));
            entObj.setSegment13Id(rs.getLong(colNames[COL_SEGMENT13_ID]));
            entObj.setSegment14Id(rs.getLong(colNames[COL_SEGMENT14_ID]));
            entObj.setSegment15Id(rs.getLong(colNames[COL_SEGMENT15_ID]));
            entObj.setCompanyId(rs.getLong(colNames[COL_COMPANY_ID]));
            entObj.setUserKey(rs.getString(colNames[COL_USER_KEY]));
            entObj.setResetPassword(rs.getBoolean(colNames[COL_RESET_PASSWORD]));
            
        } catch (Exception e) {
            System.out.println("[Exception] DbUser.resultToObject() " + e.toString());
        }
    }

    public static Vector listFullObj(int start, int recordToGet, String whereClause, String loginId, String password) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT * from " + DB_APP_USER;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + colNames[COL_LOGIN_ID] + "='" + loginId + "' and " +
                        colNames[COL_PASSWORD] + "='" + password + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                User appUser = new User();
                DbUser.resultToObject(rs, appUser);
                lists.add(appUser);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listFullObj(int start, int recordToGet, String whereClause, String loginId, String password, String userKey) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * from " + DB_APP_USER;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + colNames[COL_LOGIN_ID] + "='" + loginId + "' and " +
                        colNames[COL_PASSWORD] + "='" + password + "' and " + colNames[COL_USER_KEY] + "='" + userKey + "'";
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                User appUser = new User();
                DbUser.resultToObject(rs, appUser);
                lists.add(appUser);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector getUserPrivObj(long userOID) {
        if (userOID == 0) {
            return new Vector(1, 1);
        }
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT DISTINCT(PO." + DbPrivilegeObj.colNames[DbPrivilegeObj.COL_CODE] + ") AS CODE FROM " + DbPrivilegeObj.DB_APP_PRIVILEGE_OBJ + " AS PO " + " INNER JOIN " + DbGroupPriv.DB_GROUP_PRIV + " AS GP ON GP." + DbGroupPriv.colNames[DbGroupPriv.COL_PRIV_ID] + "=PO." + DbPrivilegeObj.colNames[DbPrivilegeObj.COL_PRIV_ID] + " INNER JOIN " + DbUserGroup.DB_USER_GROUP + " AS UG ON UG." + DbUserGroup.colNames[DbUserGroup.COL_GROUP_ID] + "=GP." + DbGroupPriv.colNames[DbGroupPriv.COL_GROUP_ID] + " WHERE UG." + DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + "='" + userOID + "'";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            Vector privObjs = new Vector(10, 2);
            while (rs.next()) {
                privObjs.add(new Integer(rs.getInt("CODE")));
            }
            return privObjs;

        } catch (Exception e) {
            System.out.println("getUserPrivObj " + e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return new Vector(1, 1);
    }

    public static long updateUserStatus(long userOID, int status) {
        if (userOID == 0) {
            return 0;
        }

        CONResultSet dbrs = null;
        try {
            if (userOID != 0) {
                User auser = DbUser.fetch(userOID);
                auser.setUserStatus(status);

                if ((auser.getLoginId() != null && auser.getLoginId().length() > 0 && !(auser.getLoginId().equalsIgnoreCase("NULL"))) &&
                        (auser.getPassword() != null && auser.getPassword().length() > 0 && !(auser.getPassword().equalsIgnoreCase("NULL")))) {
                    DbUser.update(auser);
                }
            }
            return userOID;

        } catch (Exception e) {
            System.out.println("updateUserStatus " + e);
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static User getByLoginIDAndPassword(String loginID, String password) {

        if ((loginID == null) || (loginID.length() < 1) || (password == null) || (password.length() < 1)) {
            return null;
        }

        try {
            String whereClause = " " + colNames[COL_LOGIN_ID] + "= ? AND " + colNames[COL_PASSWORD] + "= ? ";
            
            String md5Password = "";
            String sysPswd = "N";
            try{
                sysPswd = DbSystemProperty.getValueByName("SYS_MD5");
            }catch(Exception e){}
                    
            if(sysPswd.equals("Y")){
                //encrypt password using MD5 Hash                        
                md5Password = MD5.getMD5Hash(password);
            }else{                    
                md5Password = password;
            }
            
            Vector appUsers = listFullObj(0, 0, whereClause, loginID, md5Password);

            if ((appUsers == null) || (appUsers.size() != 1)) {
                return new User();
            }

            return (User) appUsers.get(0);

        } catch (Exception e) {
            System.out.println("Exception " + e);
            return null;
        }
    }

    public static User getByLoginIDAndPassword(String loginID, String password, String userKey) {
        if ((loginID == null) || (loginID.length() < 1) || (password == null) || (password.length() < 1)) {
            return null;
        }

        try {
            String whereClause = " " + colNames[COL_LOGIN_ID] + "= ? AND " + colNames[COL_PASSWORD] + "= ? AND " + colNames[COL_USER_KEY] + "= ? ";
            Vector appUsers = listFullObj(0, 0, whereClause, loginID, password, userKey);

            if ((appUsers == null) || (appUsers.size() != 1)) {
                return new User();
            }
            return (User) appUsers.get(0);
            
        } catch (Exception e) {
            System.out.println("getByLoginIDAndPassword " + e);
            return null;
        }
    }

    public static String getOperatorName(long userOID) {
        try {
            if (userOID != 0) {
                User appUser = DbUser.fetch(userOID);
                return appUser.getFullName();
            }
            return "";

        } catch (Exception e) {
        }
        return "";
    }
    
    
    public static Vector listUpdateMd5() {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT " + colNames[COL_USER_ID] + 
                    ", " + colNames[COL_PASSWORD] + 
                     " FROM " + DB_APP_USER;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {                
                long userId = rs.getLong(colNames[COL_USER_ID]);
                String password = rs.getString(colNames[COL_PASSWORD]);
                updatePassword(userId,password);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    
    public static void updatePassword(long userId,String password){
        CONResultSet dbrs = null;
        try{
            String newPassword = MD5.getMD5Hash(password);            
            String sql = "update "+DB_APP_USER+" set "+colNames[COL_PASSWORD]+" = '"+newPassword+"' where "+colNames[COL_USER_ID]+" = "+userId;            
            CONHandler.execUpdate(sql);
            
        } catch (Exception e) {
            System.out.println("getUserPrivObj " + e);
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static int getCountUser(long userId,String user,String password){
        
        CONResultSet dbrs = null;
        int sum = 0;
        try{
            
            String where = "";
            if(userId != 0){
                where = where +" and "+colNames[COL_USER_ID]+" != "+userId; 
            }
            String sql = "select count(*) as tot from "+DB_APP_USER+" where "+colNames[COL_LOGIN_ID]+" = '"+user+"' and "+colNames[COL_PASSWORD]+" = '"+password+"' "+where;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {                
                sum = rs.getInt("tot");
            }
            
        } catch (Exception e) {
            System.out.println("excption " + e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return sum;
        
    }
    
}
