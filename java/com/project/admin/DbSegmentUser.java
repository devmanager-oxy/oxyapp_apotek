/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.admin;

import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.SegmentDetail;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;

/**
 *
 * @author Roy Andika
 */
public class DbSegmentUser extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SEGMENT_USER = "segment_user";
    
    public static final int COL_SEGMENT_USER_ID = 0;
    public static final int COL_USER_ID = 1;
    public static final int COL_SEGMENT_DETAIL_ID = 2;   
    public static final int COL_LOCATION_ID = 3;   
    
    public static final String[] colNames = {
        "segment_user_id",
        "user_id",
        "segment_detail_id",
        "location_id"
    };
    
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbSegmentUser() {
    }

    public DbSegmentUser(int i) throws CONException {
        super(new DbSegmentUser());
    }

    public DbSegmentUser(String sOid) throws CONException {
        super(new DbSegmentUser(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSegmentUser(long lOid) throws CONException {
        super(new DbSegmentUser(0));
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
        return DB_SEGMENT_USER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSegmentUser().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        SegmentUser segmentUser = fetchExc(ent.getOID());
        ent = (Entity) segmentUser;
        return segmentUser.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((SegmentUser) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((SegmentUser) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static SegmentUser fetchExc(long oid) throws CONException {
        try {
            SegmentUser segmentUser = new SegmentUser();
            DbSegmentUser dbSegmentUser = new DbSegmentUser(oid);
            segmentUser.setOID(oid);
            segmentUser.setSegmentDetailId(dbSegmentUser.getlong(COL_SEGMENT_DETAIL_ID));
            segmentUser.setUserId(dbSegmentUser.getlong(COL_USER_ID));
            segmentUser.setLocationId(dbSegmentUser.getlong(COL_LOCATION_ID));
            return segmentUser;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSegmentUser(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(SegmentUser segmentUser) throws CONException {
        try {
            DbSegmentUser dbSegmentUser = new DbSegmentUser(0);
            dbSegmentUser.setLong(COL_SEGMENT_DETAIL_ID, segmentUser.getSegmentDetailId());
            dbSegmentUser.setLong(COL_USER_ID, segmentUser.getUserId());
            dbSegmentUser.setLong(COL_LOCATION_ID, segmentUser.getLocationId());
            dbSegmentUser.insert();
            segmentUser.setOID(dbSegmentUser.getlong(COL_SEGMENT_USER_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSegmentUser(0), CONException.UNKNOWN);
        }
        return segmentUser.getOID();
    }

    public static long updateExc(SegmentUser segmentUser) throws CONException {
        try {
            if (segmentUser.getOID() != 0) {
                DbSegmentUser dbSegmentUser = new DbSegmentUser(segmentUser.getOID());
                dbSegmentUser.setLong(COL_SEGMENT_DETAIL_ID, segmentUser.getSegmentDetailId());
                dbSegmentUser.setLong(COL_USER_ID, segmentUser.getUserId());
                dbSegmentUser.setLong(COL_LOCATION_ID, segmentUser.getLocationId());
                dbSegmentUser.update();
                return segmentUser.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSegmentUser(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSegmentUser dbSegmentUser = new DbSegmentUser(oid);
            dbSegmentUser.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSegmentUser(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SEGMENT_USER;
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
                SegmentUser segmentUser = new SegmentUser();
                resultToObject(rs, segmentUser);
                lists.add(segmentUser);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, SegmentUser segmentUser) {
        try {
            segmentUser.setOID(rs.getLong(DbSegmentUser.colNames[DbSegmentUser.COL_SEGMENT_USER_ID]));
            segmentUser.setSegmentDetailId(rs.getLong(DbSegmentUser.colNames[DbSegmentUser.COL_SEGMENT_DETAIL_ID]));
            segmentUser.setUserId(rs.getLong(DbSegmentUser.colNames[DbSegmentUser.COL_USER_ID]));
            segmentUser.setLocationId(rs.getLong(DbSegmentUser.colNames[DbSegmentUser.COL_LOCATION_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long periodeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SEGMENT_USER + " WHERE " +
                    DbSegmentUser.colNames[DbSegmentUser.COL_SEGMENT_USER_ID] + " = " + periodeId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause){
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbSegmentUser.colNames[DbSegmentUser.COL_SEGMENT_USER_ID] + ") FROM " + DB_SEGMENT_USER;
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
                    SegmentUser segmentUser = (SegmentUser) list.get(ls);
                    if (oid == segmentUser.getOID()) {
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
    
    public static void delUserSegment(long userId) {
        CONResultSet dbrs = null;
        try {
            String sql = "delete from "+DbSegmentUser.DB_SEGMENT_USER+" where "+DbSegmentUser.colNames[DbSegmentUser.COL_USER_ID]+" = "+userId;
            CONHandler.execUpdate(sql);            
        } catch (Exception e) {
            System.out.println("e :"+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
    public static void proceedSegment(Vector temp, long userId){
        if(userId!=0){
            delUserSegment(userId);
            if(temp!=null && temp.size()>0){                        
                for(int i=0; i<temp.size(); i++){
                    long oidSd = Long.parseLong((String)temp.get(i));
                    try{
                        SegmentDetail sd = DbSegmentDetail.fetchExc(oidSd);
                        SegmentUser su = new SegmentUser();
                        su.setSegmentDetailId(oidSd);
                        su.setLocationId(sd.getLocationId());
                        su.setUserId(userId);
                        DbSegmentUser.insertExc(su);
                    }catch(Exception e){}
                }
            
                try{
                    User u = DbUser.fetch(userId);
                    u.setSegment1Id(0);
                    DbUser.update(u);
                }catch(Exception e){}
            }
        }
    }
    
    public static Vector getSegmentDetailLocation(){
        
        String sql = "select sd.* from segment_detail sd inner join segment s "+
                " on s.segment_id=sd.segment_id "+
                " where s.count = 1";
        
        Vector result = new Vector();
        CONResultSet dbrs = null;
        try {
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                SegmentDetail sd = new SegmentDetail();
                sd.setOID(rs.getLong("segment_detail_id"));
                sd.setLocationId(rs.getLong("location_id"));
                sd.setName(rs.getString("name"));
                sd.setSegmentId(rs.getLong("segment_id"));
                
                result.add(sd);
                
            }

            rs.close();
            
        } catch (Exception e) {
            
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return result;
                
    }
    
    public static Hashtable userSegment(long userId) {
        CONResultSet dbrs = null;
        Hashtable hash = new Hashtable();
        try {
            String sql = "select " +DbSegmentUser.colNames[DbSegmentUser.COL_SEGMENT_DETAIL_ID]+","
                    +DbSegmentUser.colNames[DbSegmentUser.COL_USER_ID]+
                    " from "+
                    DbSegmentUser.DB_SEGMENT_USER+" where "+DbSegmentUser.colNames[DbSegmentUser.COL_USER_ID]+" = "+userId;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                long segmentId = rs.getLong(DbSegmentUser.colNames[DbSegmentUser.COL_SEGMENT_DETAIL_ID]);                
                SegmentDetail sd = new SegmentDetail();
                sd.setOID(segmentId);
                hash.put(""+segmentId, sd);
            }
            return hash;            
        } catch (Exception e) {
            System.out.println("e :"+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static Vector userLocations(long userId) {
        CONResultSet dbrs = null;
        Vector result = new Vector();
        try {
            String sql = "select loc.* from "+
                    DbSegmentUser.DB_SEGMENT_USER+" sg " +
                    " inner join pos_location loc on loc.location_id=sg.location_id "+
                    "where "+DbSegmentUser.colNames[DbSegmentUser.COL_USER_ID]+" = "+userId+" order by loc.name";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Location l = new Location();
                l.setOID(rs.getLong("location_id"));
                l.setName(rs.getString("name"));
                l.setType(rs.getString("type"));
                result.add(l);
            }
                    
        } catch (Exception e) {
            System.out.println("e :"+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return result;
    }
    
    public static Vector userSegments(long userId,int status) {
        CONResultSet dbrs = null;
        Vector result = new Vector();
        try {
            String sql = "select sd.* from segment_user s inner join segment_detail sd on s.segment_detail_id = sd.segment_detail_id where user_id = "+userId;
            
            if(status != -1){
                sql = sql +" and sd.status = "+status;
            }
            
            sql = sql +  " order by sd.code";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                SegmentDetail sd = new SegmentDetail();
                sd.setOID(rs.getLong(DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID]));
                sd.setName(rs.getString(DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]));
                result.add(sd);
            }
                    
        } catch (Exception e) {
            System.out.println("e :"+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return result;
    }
    
}
