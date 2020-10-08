package com.project.admin;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;

public class DbUserGroup extends CONHandler implements I_CONInterface, I_CONType, I_Persintent {

    public static final String DB_USER_GROUP = "user_group";
    public static final int COL_USER_ID = 0;
    public static final int COL_GROUP_ID = 1;
    public static final String[] colNames = {
        "user_id", "group_id"
    };
    public static int[] fieldTypes = {
        TYPE_PK + TYPE_FK + TYPE_LONG,
        TYPE_PK + TYPE_FK + TYPE_LONG
    };

    /** Creates new DbUserGroup */
    public DbUserGroup() {
    }

    public DbUserGroup(int i) throws CONException {
        super(new DbUserGroup());
    }

    public DbUserGroup(String sOid) throws CONException {
        super(new DbUserGroup(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbUserGroup(long userOID, long groupOID) throws CONException {
        super(new DbUserGroup(0));

        if (!locate(userOID, groupOID)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    /**
     *	Implemanting I_Entity interface methods
     */
    public int getFieldSize() {
        return colNames.length;
    }

    public String getTableName() {
        return DB_USER_GROUP;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbUserGroup().getClass().getName();
    }

    /**
     *	Implementing I_CONInterface interface methods
     */
    public long fetch(Entity ent) {
        UserGroup entObj = DbUserGroup.fetch(ent.getOID(0), ent.getOID(1));
        ent = (Entity) entObj;
        return entObj.getOID();
    }

    public long insert(Entity ent) {
        return DbUserGroup.insert((UserGroup) ent);
    }

    public long update(Entity ent) {
        return update((UserGroup) ent);
    }

    public long delete(Entity ent) {
        return delete((UserGroup) ent);
    }

    public static UserGroup fetch(long userID, long groupID) {
        UserGroup entObj = new UserGroup();
        try {
            DbUserGroup pstObj = new DbUserGroup(userID, groupID);
            entObj.setUserID(userID);
            entObj.setGroupID(groupID);
        } catch (CONException e) {
            System.out.println(e);
        }
        return entObj;
    }

    public static long insert(UserGroup entObj) {
        try {
            DbUserGroup pstObj = new DbUserGroup(0);

            pstObj.setLong(COL_USER_ID, entObj.getUserID());
            pstObj.setLong(COL_GROUP_ID, entObj.getGroupID());

            pstObj.insert();
            return entObj.getUserID();
        } catch (CONException e) {
            System.out.println(e);
        }
        return 0;
    }

    public static long deleteByUser(long oid) {
        DbUserGroup pstObj = new DbUserGroup();
        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + pstObj.getTableName() +
                    " WHERE " + DbUserGroup.colNames[DbUserGroup.COL_USER_ID] +
                    " = '" + oid + "'";
            
            int status = CONHandler.execUpdate(sql);
            return oid;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static long deleteByGroup(long oid) {
        DbUserGroup pstObj = new DbUserGroup();
        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + pstObj.getTableName() +
                    " WHERE " + DbUserGroup.colNames[DbUserGroup.COL_GROUP_ID] +
                    " = '" + oid + "'";
            
            int status = CONHandler.execUpdate(sql);
            return oid;
        } catch (Exception e) {
            System.out.println(" DbUserGroup.deleteByPriv " + e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static long update(UserGroup entObj) {
        if (entObj != null && entObj.getUserID() != 0) {
            try {
                DbUserGroup pstObj = new DbUserGroup(entObj.getUserID(), entObj.getGroupID());

                pstObj.update();
                return entObj.getUserID();
            } catch (Exception e) {
                System.out.println(e);
            }
        }
        return 0;
    }

    public static Vector listAll() {
        return list(0, 0, null, null);
    }

    public static void resultToObject(ResultSet rs, UserGroup entObj) {
        try {            
            entObj.setUserID(rs.getLong(colNames[COL_USER_ID]));
            entObj.setGroupID(rs.getLong(colNames[COL_GROUP_ID]));

        } catch (Exception e) {
            System.out.println("resultToObject() appuser -> : " + e.toString());
        }
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_USER_GROUP;

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
                UserGroup appPriv = new UserGroup();
                resultToObject(rs, appPriv);
                lists.add(appPriv);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }


        return new Vector();
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        int count = 0;
        try {

            String sql = " SELECT COUNT(" + colNames[COL_USER_ID] + ") AS NRCOUNT" +
                    " FROM " + DB_USER_GROUP;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception exc) {
            System.out.println("getCount " + exc);
        } finally {
            CONResultSet.close(dbrs);
        }

        return count;

    }
}
