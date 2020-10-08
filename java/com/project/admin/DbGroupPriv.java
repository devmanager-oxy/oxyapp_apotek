package com.project.admin;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;

public class DbGroupPriv extends CONHandler implements I_CONInterface, I_CONType, I_Persintent {

    public static final String DB_GROUP_PRIV = "group_priv";
    public static final int COL_GROUP_ID = 0;
    public static final int COL_PRIV_ID = 1;
    public static final String[] colNames = {
        "group_id", "priv_id"
    };
    public static int[] fieldTypes = {
        TYPE_PK + TYPE_FK + TYPE_LONG,
        TYPE_PK + TYPE_FK + TYPE_LONG
    };

    /** Creates new DbGroupPriv */
    public DbGroupPriv() {
    }

    public DbGroupPriv(int i) throws CONException {
        super(new DbGroupPriv());
    }

    public DbGroupPriv(String sOid) throws CONException {
        super(new DbGroupPriv(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGroupPriv(long groupOID, long privOID) throws CONException {
        super(new DbGroupPriv(0));

        if (!locate(groupOID, privOID)) {
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
        return DB_GROUP_PRIV;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGroupPriv().getClass().getName();
    }

    /**
     *	Implementing I_CONInterface interface methods
     */
    public long fetch(Entity ent) {
        GroupPriv entObj = DbGroupPriv.fetch(ent.getOID(0), ent.getOID(1));
        ent = (Entity) entObj;
        return entObj.getOID();
    }

    public long insert(Entity ent) {
        return DbGroupPriv.insert((GroupPriv) ent);
    }

    public long update(Entity ent) {
        return update((GroupPriv) ent);
    }

    public long delete(Entity ent) {
        return delete((GroupPriv) ent);
    }

    public static GroupPriv fetch(long groupID, long privID) {
        GroupPriv entObj = new GroupPriv();
        try {
            DbGroupPriv pstObj = new DbGroupPriv(groupID, privID);
            entObj.setGroupID(groupID);
            entObj.setPrivID(privID);
        } catch (CONException e) {
            System.out.println(e);
        }
        return entObj;
    }

    public static long insert(GroupPriv entObj) {
        try {
            DbGroupPriv pstObj = new DbGroupPriv(0);

            System.out.println("GroupID : " + entObj.getGroupID());
            System.out.println("POID : " + entObj.getPrivID());

            pstObj.setLong(COL_GROUP_ID, entObj.getGroupID());
            pstObj.setLong(COL_PRIV_ID, entObj.getPrivID());

            pstObj.insert();
            return entObj.getGroupID();
        } catch (CONException e) {
            System.out.println(e);
        }
        return 0;
    }

    public static long deleteByGroup(long oid) {
        DbGroupPriv pstObj = new DbGroupPriv();
        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + pstObj.getTableName() +
                    " WHERE " + DbGroupPriv.colNames[DbGroupPriv.COL_GROUP_ID] +
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

    public static long deleteByPriv(long oid) {
        DbGroupPriv pstObj = new DbGroupPriv();
        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + pstObj.getTableName() +
                    " WHERE " + DbGroupPriv.colNames[DbGroupPriv.COL_PRIV_ID] +
                    " = '" + oid + "'";
            System.out.println(sql);
            int status = CONHandler.execUpdate(sql);
            return oid;
        } catch (Exception e) {
            System.out.println(" DbGroupPriv.deleteByPriv " + e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static long update(GroupPriv entObj) {
        if (entObj != null && entObj.getGroupID() != 0) {
            try {
                DbGroupPriv pstObj = new DbGroupPriv(entObj.getGroupID(), entObj.getPrivID());

                pstObj.update();
                return entObj.getGroupID();
            } catch (Exception e) {
                System.out.println(e);
            }
        }
        return 0;
    }

    public static Vector listAll() {
        return list(0, 0, null, null);
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        return new Vector();
    }
}
