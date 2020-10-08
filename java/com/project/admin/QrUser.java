package com.project.admin;

import java.util.*;
import java.io.*;
import java.sql.*;

import com.project.main.db.*;
import com.project.util.*;

public class QrUser {

    /** Creates new SessCOLUser */
    public QrUser() {
    }

    //-------------------Relation COLUser and Group--------------//
    public static Vector getUserGroup(long userID) {
        DbUserGroup pstUserGroup = new DbUserGroup();
        DbGroup pstGroup = new DbGroup();
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        
        try {

            String sql = "SELECT AUG." + DbUserGroup.colNames[DbUserGroup.COL_USER_ID] +
                    ", AUG." + DbUserGroup.colNames[DbUserGroup.COL_GROUP_ID] +
                    ", AG." + DbGroup.colNames[DbGroup.COL_GROUP_NAME] +
                    ", AG." + DbGroup.colNames[DbGroup.COL_DESCRIPTION] +
                    " FROM " + pstUserGroup.getTableName() + " AS AUG ," +
                    pstGroup.getTableName() + " AS AG " +
                    "WHERE AUG." + DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + " = '" +
                    userID + "'" +
                    " AND AUG." + DbUserGroup.colNames[DbUserGroup.COL_GROUP_ID] + " = " +
                    "AG." + DbGroup.colNames[DbGroup.COL_GROUP_ID];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Group appGroup = new Group();
                resultToObject(rs, appGroup);
                lists.add(appGroup);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return new Vector();
    }

    private static void resultToObject(ResultSet rs, Group appGroup) {
        try {
            appGroup.setOID(rs.getLong(DbGroup.colNames[DbGroup.COL_GROUP_ID]));
            appGroup.setGroupName(rs.getString(DbGroup.colNames[DbGroup.COL_GROUP_NAME]));
            appGroup.setDescription(rs.getString(DbGroup.colNames[DbGroup.COL_DESCRIPTION]));

        } catch (Exception e) {
            System.out.println("resultToObject() " + e.toString());
        }
    }

    // PATERN ## INSERT WITH Vector of  UserGroup
    /**
     * return false if error
     **/
    public static boolean setUserGroup(long userOID, Vector vector) {

        // do delete
        if (DbUserGroup.deleteByUser(userOID) == 0) {
            return false;
        }

        if (vector == null || vector.size() == 0) {
            return true;
        }

        // than insert
        for (int i = 0; i < vector.size(); i++) {
            UserGroup ug = (UserGroup) vector.get(i);
            if (DbUserGroup.insert(ug) == 0) {
                return false;
            }
        }
        return true;
    }
}
