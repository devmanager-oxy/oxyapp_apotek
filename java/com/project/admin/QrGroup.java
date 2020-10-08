package com.project.admin;

import com.project.main.db.*;
import com.project.util.*;
import java.util.*;
import java.io.*;
import java.sql.*;

public class QrGroup {

    /** Creates new SessCOLGroup */
    public QrGroup() {
    }

    //-------------------Relation COLGroup and Priv--------------//
    public static Vector getGroupPriv(long groupID) {
        DbGroupPriv pstGroupPriv = new DbGroupPriv();
        DbPriv pstPriv = new DbPriv();
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {

            String sql = "SELECT AGP." + DbGroupPriv.colNames[DbGroupPriv.COL_GROUP_ID] +
                    ", AGP." + DbGroupPriv.colNames[DbGroupPriv.COL_PRIV_ID] +
                    ", AP." + DbPriv.colNames[DbPriv.COL_PRIV_NAME] +
                    ", AP." + DbPriv.colNames[DbPriv.COL_DESCRIPTION] +
                    " FROM " + pstGroupPriv.getTableName() + " AS AGP ," +
                    pstPriv.getTableName() + " AS AP " +
                    "WHERE AGP." + DbGroupPriv.colNames[DbGroupPriv.COL_GROUP_ID] + " = '" +
                    groupID + "'" +
                    " AND AGP." + DbGroupPriv.colNames[DbGroupPriv.COL_PRIV_ID] + " = " +
                    "AP." + DbPriv.colNames[DbPriv.COL_PRIV_ID];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Priv appPriv = new Priv();
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

    private static void resultToObject(ResultSet rs, Priv appPriv) {
        try {
            appPriv.setOID(rs.getLong(DbPriv.colNames[DbPriv.COL_PRIV_ID]));
            appPriv.setPrivName(rs.getString(DbPriv.colNames[DbPriv.COL_PRIV_NAME]));
            appPriv.setDescr(rs.getString(DbPriv.colNames[DbPriv.COL_DESCRIPTION]));

        } catch (Exception e) {
            System.out.println("resultToObject() " + e.toString());
        }
    }

    // PATERN ## INSERT WITH Vector of  GroupPriv
    /**
     * return false if error
     **/
    public static boolean setGroupPriv(long groupOID, Vector vector) {

        // do delete
        if (DbGroupPriv.deleteByGroup(groupOID) == 0) {
            return false;
        }

        if (vector == null || vector.size() == 0) {
            return true;
        }

        // than insert
        for (int i = 0; i < vector.size(); i++) {
            GroupPriv gp = (GroupPriv) vector.get(i);
            if (DbGroupPriv.insert(gp) == 0) {
                return false;
            }
        }
        return true;
    }
}
