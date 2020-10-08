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

public class DbOpnameSubLocation extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_POS_OPNAME_SUB_LOCATION = "pos_opname_sub_location";
    public static final int COL_OPNAME_SUB_LOCATION_ID = 0;
    public static final int COL_OPNAME_ID = 1;
    public static final int COL_SUB_LOCATION_ID = 2;
    public static final int COL_SUB_LOCATION_NAME = 3;
    public static final int COL_STATUS = 4;
    public static final int COL_USER_ID = 5;
    public static final int COL_FORM_NUMBER = 6;
    public static final int COL_DATE = 7;
    
    public static final String[] colNames = {
        "opname_sub_location_id",
        "opname_id",
        "sub_location_id",
        "sub_location_name",
        "status",
        "user_id",
        "form_number",
        "date"
                
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_DATE
        
    };

    public static final int TYPE_NON_CONSIGMENT = 0;
    public static final int TYPE_CONSIGMENT = 1;
    
    public DbOpnameSubLocation() {
    }

    public DbOpnameSubLocation(int i) throws CONException {
        super(new DbOpnameSubLocation());
    }

    public DbOpnameSubLocation(String sOid) throws CONException {
        super(new DbOpnameSubLocation(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbOpnameSubLocation(long lOid) throws CONException {
        super(new DbOpnameSubLocation(0));
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
        return DB_POS_OPNAME_SUB_LOCATION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbOpnameSubLocation().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        OpnameSubLocation opnamesub = fetchExc(ent.getOID());
        ent = (Entity) opnamesub;
        return opnamesub.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((OpnameSubLocation) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((OpnameSubLocation) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static OpnameSubLocation fetchExc(long oid) throws CONException {
        try {
            OpnameSubLocation opnamesub = new OpnameSubLocation();
            DbOpnameSubLocation pstOpname = new DbOpnameSubLocation(oid);
            opnamesub.setOID(oid);

            opnamesub.setOpnameId(pstOpname.getlong(COL_OPNAME_ID));
            opnamesub.setSubLocationId(pstOpname.getlong(COL_SUB_LOCATION_ID));
            opnamesub.setSubLocationName(pstOpname.getString(COL_SUB_LOCATION_NAME));
            opnamesub.setStatus(pstOpname.getString(COL_STATUS));
            opnamesub.setUserId(pstOpname.getlong(COL_USER_ID));
            opnamesub.setFormNumber(pstOpname.getString(COL_FORM_NUMBER));
            opnamesub.setDate(pstOpname.getDate(COL_DATE));
            return opnamesub;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnameSubLocation(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(OpnameSubLocation opnamesub) throws CONException {
        try {
            DbOpnameSubLocation pstOpname = new DbOpnameSubLocation(0);
            
            
            pstOpname.setLong(COL_OPNAME_ID, opnamesub.getOpnameId());
            pstOpname.setLong(COL_SUB_LOCATION_ID, opnamesub.getSubLocationId());
            pstOpname.setString(COL_SUB_LOCATION_NAME, opnamesub.getSubLocationName());
            pstOpname.setString(COL_STATUS, opnamesub.getStatus());
            pstOpname.setLong(COL_USER_ID, opnamesub.getUserId());
            pstOpname.setString(COL_FORM_NUMBER, opnamesub.getFormNumber());
            pstOpname.setString(COL_STATUS, opnamesub.getStatus());
            pstOpname.setDate(COL_DATE, opnamesub.getDate());
                        
            pstOpname.insert();
            opnamesub.setOID(pstOpname.getlong(COL_OPNAME_SUB_LOCATION_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnameSubLocation(0), CONException.UNKNOWN);
        }
        return opnamesub.getOID();
    }

    public static long updateExc(OpnameSubLocation opnamesub) throws CONException {
        try {
            if (opnamesub.getOID() != 0) {
                DbOpnameSubLocation pstOpname = new DbOpnameSubLocation(opnamesub.getOID());

                pstOpname.setLong(COL_OPNAME_ID, opnamesub.getOpnameId());
                pstOpname.setLong(COL_SUB_LOCATION_ID, opnamesub.getSubLocationId());
                pstOpname.setString(COL_SUB_LOCATION_NAME, opnamesub.getSubLocationName());
                pstOpname.setString(COL_STATUS, opnamesub.getStatus());
                pstOpname.setLong(COL_USER_ID, opnamesub.getUserId());
                pstOpname.setString(COL_FORM_NUMBER, opnamesub.getFormNumber());
                pstOpname.setString(COL_STATUS, opnamesub.getStatus());
                pstOpname.setDate(COL_DATE, opnamesub.getDate());
                pstOpname.update();
                return opnamesub.getOID();

            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnameSubLocation(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbOpnameSubLocation pstOpname = new DbOpnameSubLocation(oid);
            pstOpname.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOpnameSubLocation(0), CONException.UNKNOWN);
        }
        return oid;
    }
   // public static int deleteAllItem(long oidOpname){
        
      //  int result = 0;
        
      //  String sql = "delete from "+DB_POS_OPNAME_SUB_LOCATION+" where "+colNames[COL_OPNAME_ID]+" = "+oidOpname;
    //    try{
     //       CONHandler.execUpdate(sql);
    //    }
    //    catch(Exception e){
      //      result = -1;
      //  }
        
    //    return result;
  //  }
     public static int updateStatusAll(long oidOpname, String status){
        
        int result = 0;
        
        String sql = "update  "+DB_POS_OPNAME_SUB_LOCATION+" set " + colNames[COL_STATUS] + "='" + status + 
                "' where "+colNames[COL_OPNAME_ID]+" = "+oidOpname;
        try{
            CONHandler.execUpdate(sql);
        }
        catch(Exception e){
            result = -1;
        }
        
        return result;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_POS_OPNAME_SUB_LOCATION;
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
                OpnameSubLocation opnamesub = new OpnameSubLocation();
                resultToObject(rs, opnamesub);
                lists.add(opnamesub);
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

    private static void resultToObject(ResultSet rs, OpnameSubLocation opnamesub) {
        try {
            opnamesub.setOID(rs.getLong(DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_SUB_LOCATION_ID]));
            opnamesub.setOpnameId(rs.getLong(DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_ID]));
            opnamesub.setSubLocationId(rs.getLong(DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_SUB_LOCATION_ID]));
            opnamesub.setSubLocationName(rs.getString(DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_SUB_LOCATION_NAME]));
            opnamesub.setStatus(rs.getString(DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_STATUS]));
            opnamesub.setUserId(rs.getLong(DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_USER_ID]));
            opnamesub.setFormNumber(rs.getString(DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_FORM_NUMBER]));
            opnamesub.setDate(rs.getDate(DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_DATE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long opnamePeriodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_POS_OPNAME_SUB_LOCATION + " WHERE " +
                    DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_SUB_LOCATION_ID] + " = " + opnamePeriodeId;

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

    public static int getCount(String whereClause){
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbOpnameSubLocation.colNames[DbOpnameSubLocation.COL_OPNAME_SUB_LOCATION_ID] + ") FROM " + DB_POS_OPNAME_SUB_LOCATION;
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
                    OpnameSubLocation opnamesub = (OpnameSubLocation) list.get(ls);
                    if (oid == opnamesub.getOID()) {
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

    /*public static int getNextCounter() {
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
    }*/

   /* public static String getNumberPrefix() {
        String code = "";
        Company sysCompany = DbCompany.getCompany();
        code = code + sysCompany.getOpnameCode();

        code = code + JSPFormater.formatDate(new Date(), "MMyy");

        return code;
    }*/

   /* public static String getNextNumber(int ctr) {

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
    }*/
}
