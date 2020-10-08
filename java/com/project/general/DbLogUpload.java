/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import com.project.admin.DbSegmentUser;
import com.project.admin.DbUser;
import com.project.admin.DbUserGroup;
import com.project.admin.DbUserPriv;
import com.project.ccs.postransaction.memberpoint.DbMemberPoint;
import com.project.ccs.postransaction.stock.DbStock;
import com.project.interfaces.DbUploader;
import java.io.*;
import java.sql.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import com.project.util.lang.*;
import java.util.StringTokenizer;
import java.util.Vector;

/**
 *
 * @author Roy
 */
public class DbLogUpload extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_LOG_UPLOAD = "logs_upload";
    public static final int COL_LOG_UPLOAD_ID = 0;
    public static final int COL_LOG_DATE = 1;
    public static final int COL_USER_ID = 2;
    public static final int COL_TABLE_NAME = 3;
    public static final int COL_QUERY_STRING = 4;
    public static final int COL_UPDATE_STATUS = 5;
    public static final int COL_STATUS = 6;
    public static final String[] colNames = {
        "log_upload_id",
        "log_date",
        "user_id",
        "table_name",
        "query_string",
        "update_status",
        "status"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_INT
    };

    public DbLogUpload() {
    }

    public DbLogUpload(int i) throws CONException {
        super(new DbLogUpload());
    }

    public DbLogUpload(String sOid) throws CONException {
        super(new DbLogUpload(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLogUpload(long lOid) throws CONException {
        super(new DbLogUpload(0));
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
        return DB_LOG_UPLOAD;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLogUpload().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LogUpload logUpload = fetchExc(ent.getOID());
        ent = (Entity) logUpload;
        return logUpload.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LogUpload) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LogUpload) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static LogUpload fetchExc(long oid) throws CONException {
        try {
            LogUpload logUpload = new LogUpload();
            DbLogUpload pstLogUpload = new DbLogUpload(oid);
            logUpload.setOID(oid);
            logUpload.setLogDate(pstLogUpload.getDate(COL_LOG_DATE));
            logUpload.setUserId(pstLogUpload.getlong(COL_USER_ID));
            logUpload.setTableName(pstLogUpload.getString(COL_TABLE_NAME));
            logUpload.setQueryString(pstLogUpload.getString(COL_QUERY_STRING));
            logUpload.setUpdateStatus(pstLogUpload.getDate(COL_UPDATE_STATUS));
            logUpload.setStatus(pstLogUpload.getInt(COL_STATUS));
            return logUpload;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogUpload(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LogUpload logUpload) throws CONException {
        try {
            DbLogUpload pstLogUpload = new DbLogUpload(0);
            pstLogUpload.setDate(COL_LOG_DATE, logUpload.getLogDate());
            pstLogUpload.setLong(COL_USER_ID, logUpload.getUserId());
            pstLogUpload.setString(COL_TABLE_NAME, logUpload.getTableName());
            pstLogUpload.setString(COL_QUERY_STRING, logUpload.getQueryString());
            pstLogUpload.setDate(COL_UPDATE_STATUS, logUpload.getUpdateStatus());
            pstLogUpload.setInt(COL_STATUS, logUpload.getStatus());
            pstLogUpload.insert();
            logUpload.setOID(pstLogUpload.getlong(COL_LOG_UPLOAD_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogUpload(0), CONException.UNKNOWN);
        }
        return logUpload.getOID();
    }

    public static long updateExc(LogUpload logUpload) throws CONException {
        try {
            if (logUpload.getOID() != 0) {
                DbLogUpload pstLogUpload = new DbLogUpload(logUpload.getOID());

                pstLogUpload.setDate(COL_LOG_DATE, logUpload.getLogDate());
                pstLogUpload.setLong(COL_USER_ID, logUpload.getUserId());
                pstLogUpload.setString(COL_TABLE_NAME, logUpload.getTableName());
                pstLogUpload.setString(COL_QUERY_STRING, logUpload.getQueryString());
                pstLogUpload.setDate(COL_UPDATE_STATUS, logUpload.getUpdateStatus());
                pstLogUpload.setInt(COL_STATUS, logUpload.getStatus());

                pstLogUpload.update();
                return logUpload.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogUpload(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLogUpload pstLogUpload = new DbLogUpload(oid);
            pstLogUpload.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogUpload(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_LOG_UPLOAD;
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
                LogUpload logUpload = new LogUpload();
                resultToObject(rs, logUpload);
                lists.add(logUpload);
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

    private static void resultToObject(ResultSet rs, LogUpload logUpload) {
        try {
            logUpload.setOID(rs.getLong(DbLogUpload.colNames[DbLogUpload.COL_LOG_UPLOAD_ID]));
            Date tm = CONHandler.convertDate(rs.getDate(DbLogUpload.colNames[DbLogUpload.COL_LOG_DATE]), rs.getTime(DbLogUpload.colNames[DbLogUpload.COL_LOG_DATE]));
            logUpload.setLogDate(tm);
            logUpload.setUserId(rs.getLong(DbLogUpload.colNames[DbLogUpload.COL_USER_ID]));
            logUpload.setTableName(rs.getString(DbLogUpload.colNames[DbLogUpload.COL_TABLE_NAME]));
            logUpload.setQueryString(rs.getString(DbLogUpload.colNames[DbLogUpload.COL_QUERY_STRING]));
            Date tm2 = CONHandler.convertDate(rs.getDate(DbLogUpload.colNames[DbLogUpload.COL_UPDATE_STATUS]), rs.getTime(DbLogUpload.colNames[DbLogUpload.COL_UPDATE_STATUS]));
            logUpload.setUpdateStatus(tm2);            
            logUpload.setStatus(rs.getInt(DbLogUpload.colNames[DbLogUpload.COL_STATUS]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long logUploadId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_LOG_UPLOAD + " WHERE " +
                    DbLogUpload.colNames[DbLogUpload.COL_LOG_UPLOAD_ID] + " = " + logUploadId;

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
            String sql = "SELECT COUNT(" + DbLogUpload.colNames[DbLogUpload.COL_LOG_UPLOAD_ID] + ") FROM " + DB_LOG_UPLOAD;
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
                    LogUpload logUpload = (LogUpload) list.get(ls);
                    if (oid == logUpload.getOID()) {
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

    public static boolean logTable(String tableName) {

        String logTable = DbSystemProperty.getValueByName("LOGS_TABLES");
        StringTokenizer strTok = new StringTokenizer(logTable, ",");
        Vector temp = new Vector();

        while (strTok.hasMoreTokens()) {
            temp.add((String) strTok.nextToken().trim());
        }
        if (temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                String s = (String) temp.get(i);
                if (s.equalsIgnoreCase(tableName)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static void insertLogs(String queryInsert, String tableName) {
        try {
            if (logTable(tableName)) {                
                long log_id = OIDGenerator.generateOID();
                String sql = "insert into " + DbLogUpload.DB_LOG_UPLOAD + " (" + DbLogUpload.colNames[DbLogUpload.COL_LOG_UPLOAD_ID] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_LOG_DATE] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_USER_ID] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_TABLE_NAME] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_QUERY_STRING] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_UPDATE_STATUS] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_STATUS] + ") values ('" +
                        log_id + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','0'," +
                        "'" + tableName + "','" + (queryInsert.replace("'", "\\'")) + "',null,'0') ";
                        
                int y = CONHandler.execUpdate(sql);
                if(y!= 0){
                    int x = DbUploader.Upload(queryInsert);                      
                    if(x==1){
                        updateSatusLog(log_id);
                    }else{
                        updateSatusLogFaild(log_id);
                    }
                }
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
    
     public static void insertLogs(String queryInsert) {
        try {
            
            int idx = queryInsert.indexOf("pos_stock");
            int idx1 = queryInsert.indexOf("insert into pos_member_point");
            int idInsert = queryInsert.indexOf("insert into customer(");
            int idUpdate = queryInsert.indexOf("update customer set");
            int idDelete = queryInsert.indexOf("delete from customer where");            
            int idUser = queryInsert.indexOf("delete from "+DbSegmentUser.DB_SEGMENT_USER);            
            int idUserPriv = queryInsert.indexOf("delete from "+DbUserPriv.DB_USER_PRIV);    
            int idDelGrp = queryInsert.indexOf("DELETE FROM "+DbUserGroup.DB_USER_GROUP);                
            
            String tableName ="";
            //pengecekan jika tablenya pos_stock
            if (idx > -1) {
                tableName = DbStock.DB_POS_STOCK;
            }else if(idx1 > -1){
                tableName = DbMemberPoint.DB_POS_MEMBER_POINT;
            }else if(idUser >-1){    
                tableName = DbSegmentUser.DB_SEGMENT_USER;
            }else if(idUserPriv >-1){
                tableName = DbUserPriv.DB_USER_PRIV;
            }else if(idDelGrp > -1){
                tableName = DbUserGroup.DB_USER_GROUP;
            }else{
                if(idInsert > -1 || idUpdate > -1 || idDelete > -1){
                    tableName = DbCustomer.DB_CUSTOMER;
                }
            }            
                
            if (idx > -1 || idx1 > -1 || idInsert > -1 || idUpdate > -1 || idDelete > -1 || idUser > -1 || idUserPriv > -1 || idDelGrp > -1) {                
                long log_id = OIDGenerator.generateOID();
                String sql = "insert into " + DbLogUpload.DB_LOG_UPLOAD + " (" + DbLogUpload.colNames[DbLogUpload.COL_LOG_UPLOAD_ID] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_LOG_DATE] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_USER_ID] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_TABLE_NAME] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_QUERY_STRING] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_UPDATE_STATUS] + "," +
                        DbLogUpload.colNames[DbLogUpload.COL_STATUS] + ") values ('" +
                        log_id + "','" + JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss") + "','0'," +
                        "'" + tableName + "','" + (queryInsert.replace("'", "\\'")) + "',null,'0') ";
                System.out.println("log >> "+sql);
                int y = CONHandler.execUpdateLogOnly(sql);                
                if(y!= 0){
                    int x = DbUploader.Upload(queryInsert);                      
                    if(x==1){
                        updateSatusLog(log_id);
                    }else{
                        updateSatusLogFaild(log_id);
                    }
                }
            }

        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
    
    public static void updateSatusLog(long oid){
        try{
            String sql = "update "+DbLogUpload.DB_LOG_UPLOAD+" set "+DbLogUpload.colNames[DbLogUpload.COL_UPDATE_STATUS]+" = '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss")+"',"+
                    DbLogUpload.colNames[DbLogUpload.COL_STATUS]+"=1 where "+DbLogUpload.colNames[DbLogUpload.COL_LOG_UPLOAD_ID]+"="+oid;
            int y = CONHandler.execUpdate(sql);            
        }catch(Exception e){}        
    }
    
    public static void updateSatusLogFaild(long oid){
        try{
            String sql = "update "+DbLogUpload.DB_LOG_UPLOAD+" set "+DbLogUpload.colNames[DbLogUpload.COL_UPDATE_STATUS]+" = '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss")+"',"+
                    DbLogUpload.colNames[DbLogUpload.COL_STATUS]+"=-1 where "+DbLogUpload.colNames[DbLogUpload.COL_LOG_UPLOAD_ID]+"="+oid;
            int y = CONHandler.execUpdate(sql);            
        }catch(Exception e){}        
    }
    
    public static void updateSatusLogSecondProcess(long oid){
        try{
            String sql = "update "+DbLogUpload.DB_LOG_UPLOAD+" set "+DbLogUpload.colNames[DbLogUpload.COL_UPDATE_STATUS]+" = '"+JSPFormater.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss")+"',"+
                    DbLogUpload.colNames[DbLogUpload.COL_STATUS]+"=2 where "+DbLogUpload.colNames[DbLogUpload.COL_LOG_UPLOAD_ID]+"="+oid;
            int y = CONHandler.execUpdate(sql);            
        }catch(Exception e){}        
    }
    
}
