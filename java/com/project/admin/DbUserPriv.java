package com.project.admin;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.*;

public class DbUserPriv extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_USER_PRIV = "user_priv";
    public static final int COL_PRIV_ID = 0;
    public static final int COL_MN_1 = 1;
    public static final int COL_MN_2 = 2;
    public static final int COL_CMD_ADD = 3;
    public static final int COL_CMD_EDIT = 4;
    public static final int COL_CMD_VIEW = 5;
    public static final int COL_CMD_DELETE = 6;
    public static final int COL_GROUP_ID = 7;
    public static final int COL_USER_ID = 8;
    public static final int COL_CMD_PRINT = 9;
    public static final int COL_CMD_POSTING = 10;
    
    public static final String[] colNames = {
        "priv_id",
        "mn_1",
        "mn_2",
        "cmd_add",
        "cmd_edit",
        "cmd_view",
        "cmd_delete",
        "group_id",
        "user_id",
        "cmd_print",
        "cmd_posting"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT
    };

    public DbUserPriv() {
    }

    public DbUserPriv(int i) throws CONException {
        super(new DbUserPriv());
    }

    public DbUserPriv(String sOid) throws CONException {
        super(new DbUserPriv(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbUserPriv(long lOid) throws CONException {
        super(new DbUserPriv(0));
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
        return DB_USER_PRIV;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbUserPriv().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        UserPriv userpriv = fetchExc(ent.getOID());
        ent = (Entity) userpriv;
        return userpriv.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((UserPriv) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((UserPriv) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static UserPriv fetchExc(long oid) throws CONException {
        try {
            UserPriv userpriv = new UserPriv();
            DbUserPriv pstUserPriv = new DbUserPriv(oid);
            userpriv.setOID(oid);

            userpriv.setMn1(pstUserPriv.getInt(COL_MN_1));
            userpriv.setMn2(pstUserPriv.getInt(COL_MN_2));
            userpriv.setCmdAdd(pstUserPriv.getInt(COL_CMD_ADD));
            userpriv.setCmdEdit(pstUserPriv.getInt(COL_CMD_EDIT));
            userpriv.setCmdView(pstUserPriv.getInt(COL_CMD_VIEW));
            userpriv.setCmdDelete(pstUserPriv.getInt(COL_CMD_DELETE));
            userpriv.setGroupId(pstUserPriv.getlong(COL_GROUP_ID));
            userpriv.setUserId(pstUserPriv.getlong(COL_USER_ID));
            userpriv.setCmdPrint(pstUserPriv.getInt(COL_CMD_PRINT));
            userpriv.setCmdPosting(pstUserPriv.getInt(COL_CMD_POSTING));

            return userpriv;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUserPriv(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(UserPriv userpriv) throws CONException {
        try {
            DbUserPriv pstUserPriv = new DbUserPriv(0);

            pstUserPriv.setInt(COL_MN_1, userpriv.getMn1());
            pstUserPriv.setInt(COL_MN_2, userpriv.getMn2());
            pstUserPriv.setInt(COL_CMD_ADD, userpriv.getCmdAdd());
            pstUserPriv.setInt(COL_CMD_EDIT, userpriv.getCmdEdit());
            pstUserPriv.setInt(COL_CMD_VIEW, userpriv.getCmdView());
            pstUserPriv.setInt(COL_CMD_DELETE, userpriv.getCmdDelete());
            pstUserPriv.setLong(COL_GROUP_ID, userpriv.getGroupId());
            pstUserPriv.setLong(COL_USER_ID, userpriv.getUserId());
            pstUserPriv.setInt(COL_CMD_PRINT, userpriv.getCmdPrint());
            pstUserPriv.setInt(COL_CMD_POSTING, userpriv.getCmdPosting());

            pstUserPriv.insert();
            userpriv.setOID(pstUserPriv.getlong(COL_PRIV_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUserPriv(0), CONException.UNKNOWN);
        }
        return userpriv.getOID();
    }

    public static long updateExc(UserPriv userpriv) throws CONException {
        try {
            if (userpriv.getOID() != 0) {
                DbUserPriv pstUserPriv = new DbUserPriv(userpriv.getOID());

                pstUserPriv.setInt(COL_MN_1, userpriv.getMn1());
                pstUserPriv.setInt(COL_MN_2, userpriv.getMn2());
                pstUserPriv.setInt(COL_CMD_ADD, userpriv.getCmdAdd());
                pstUserPriv.setInt(COL_CMD_EDIT, userpriv.getCmdEdit());
                pstUserPriv.setInt(COL_CMD_VIEW, userpriv.getCmdView());
                pstUserPriv.setInt(COL_CMD_DELETE, userpriv.getCmdDelete());
                pstUserPriv.setLong(COL_GROUP_ID, userpriv.getGroupId());
                pstUserPriv.setLong(COL_USER_ID, userpriv.getUserId());
                pstUserPriv.setInt(COL_CMD_PRINT, userpriv.getCmdPrint());
                pstUserPriv.setInt(COL_CMD_POSTING, userpriv.getCmdPosting());

                pstUserPriv.update();
                return userpriv.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUserPriv(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbUserPriv pstUserPriv = new DbUserPriv(oid);
            pstUserPriv.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbUserPriv(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_USER_PRIV;
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
                UserPriv userpriv = new UserPriv();
                resultToObject(rs, userpriv);
                lists.add(userpriv);
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

    public static void resultToObject(ResultSet rs, UserPriv userpriv) {
        try {
            userpriv.setOID(rs.getLong(DbUserPriv.colNames[DbUserPriv.COL_PRIV_ID]));
            userpriv.setMn1(rs.getInt(DbUserPriv.colNames[DbUserPriv.COL_MN_1]));
            userpriv.setMn2(rs.getInt(DbUserPriv.colNames[DbUserPriv.COL_MN_2]));
            userpriv.setCmdAdd(rs.getInt(DbUserPriv.colNames[DbUserPriv.COL_CMD_ADD]));
            userpriv.setCmdEdit(rs.getInt(DbUserPriv.colNames[DbUserPriv.COL_CMD_EDIT]));
            userpriv.setCmdView(rs.getInt(DbUserPriv.colNames[DbUserPriv.COL_CMD_VIEW]));
            userpriv.setCmdDelete(rs.getInt(DbUserPriv.colNames[DbUserPriv.COL_CMD_DELETE]));
            userpriv.setGroupId(rs.getLong(DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID]));
            userpriv.setUserId(rs.getLong(DbUserPriv.colNames[DbUserPriv.COL_USER_ID]));
            userpriv.setCmdPrint(rs.getInt(DbUserPriv.colNames[DbUserPriv.COL_CMD_PRINT]));
            userpriv.setCmdPosting(rs.getInt(DbUserPriv.colNames[DbUserPriv.COL_CMD_POSTING]));

        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long privId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_USER_PRIV + " WHERE " +
                    DbUserPriv.colNames[DbUserPriv.COL_PRIV_ID] + " = " + privId;

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
            String sql = "SELECT COUNT(" + DbUserPriv.colNames[DbUserPriv.COL_PRIV_ID] + ") FROM " + DB_USER_PRIV;
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
                    UserPriv userpriv = (UserPriv) list.get(ls);
                    if (oid == userpriv.getOID()) {
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

    public static void deleteByGroup(long groupId) {
        CONResultSet dbrs = null;
        try {
            String sql = "delete from " + DB_USER_PRIV + " where " + colNames[COL_GROUP_ID] + "=" + groupId +
                    " and  " + colNames[COL_MN_1] + ">=" + AppMenu.MENU_CONTSTAN_START + " and " +
                    colNames[COL_MN_1] + "<=" + AppMenu.MENU_CONTSTAN_END;

            CONHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }

    }

    //add by Roy Andika        
    public static void deleteByGroup(long groupId, int constanStart, int constanEnd) {
        CONResultSet dbrs = null;
        try {
            String sql = "delete from " + DB_USER_PRIV + " where " + colNames[COL_GROUP_ID] + "=" + groupId +
                    " and  " + colNames[COL_MN_1] + ">=" + constanStart + " and " +
                    colNames[COL_MN_1] + "<=" + constanEnd;
            CONHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
}
