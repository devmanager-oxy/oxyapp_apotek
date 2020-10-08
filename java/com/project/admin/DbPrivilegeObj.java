

package com.project.admin;


import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;


public class DbPrivilegeObj extends CONHandler implements I_CONInterface, I_CONType, I_Persintent  {
    
    
    public static final String DB_APP_PRIVILEGE_OBJ = "privilege_obj";

    public static final int COL_PRIV_OBJ_ID	= 0;
    public static final int COL_PRIV_ID		= 1;
    public static final int COL_CODE		= 2;   
    
    public static  final String[] colNames = {
        "priv_obj_id", "priv_id", "code"
    } ;
    
    public static int[] fieldTypes = {
        TYPE_PK + TYPE_LONG + TYPE_ID, TYPE_LONG, TYPE_INT
    };
    
    
    public static final String strObjFilter = "0xFFFFFF00";
    public static final String strCmdFilter = "0x000000FF";
    public static final int intObjFilter = 0xFFFFFF00;
    public static final int intCmdFilter = 0x000000FF;
    
    /** Creates new DbPrivilegeObj */
    public DbPrivilegeObj() {
    }
    
    public DbPrivilegeObj(int i) throws CONException {
        super(new DbPrivilegeObj());
    }
    
    
    public DbPrivilegeObj(String sOid) throws CONException {
        super(new DbPrivilegeObj(0));
        if(!locate(sOid))
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        else
            return;
    }
    
    
    public DbPrivilegeObj(long lOid) throws CONException {
        super(new DbPrivilegeObj(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        }catch(Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        
        if(!locate(sOid))
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        else
            return;
        
    }
    
    public int getFieldSize() {
        return colNames.length;
    }
    
    public String getTableName() {
        return DB_APP_PRIVILEGE_OBJ;
    }
    
    public String getPersistentName() {
        return new DbPrivilegeObj().getClass().getName();
    }
    
    
    public int[] getFieldTypes() {
        return fieldTypes;
    }
    
    public String[] getFieldNames() {
        return colNames;
    }
    
    
    public long delete(Entity ent) {
        return delete((PrivilegeObj) ent);
    }
    
    public long insert(Entity ent) {
        return DbPrivilegeObj.insert((PrivilegeObj) ent);
    }
    
    
    public long update(Entity ent) {
        return update((PrivilegeObj) ent);
    }
    
    public long fetch(Entity ent) {
        PrivilegeObj entObj = DbPrivilegeObj.fetch(ent.getOID());
        ent = (Entity)entObj;
        return ent.getOID();
    }
    
    
    public static PrivilegeObj fetch(long oid) {
        PrivilegeObj entObj = new PrivilegeObj();
        try {
            DbPrivilegeObj pstObj = new DbPrivilegeObj(oid);
            entObj.setOID(oid);
            entObj.setPrivId(pstObj.getlong(COL_PRIV_ID));
            entObj.setCode(pstObj.getInt(COL_CODE));
            
            entObj.setCommands( pstObj.listCmd_ByPrivObj(entObj.getPrivId(), entObj.getCode()));
        }
        catch(CONException e) {
            System.out.println(e);
        }
        return entObj;
    }

    public static long insert(PrivilegeObj entObj) {
        try{
            int max = entObj.getCommandsSize();
            if(max<1)
                return 0;
            
            deleteByPrivOIDObjCode(entObj.getPrivId(), entObj.getCode() );
            
            int moduleObj = entObj.getCode() & intObjFilter;
            
            for(int i=0; i<max;i++){                
                PrivilegeObj objTmp =  new  PrivilegeObj();
                
                objTmp.setPrivId(entObj.getPrivId());
                objTmp.setCode(moduleObj + (entObj.getCommand(i) & intCmdFilter));
                
                long oid = DbPrivilegeObj.insertObj(objTmp);                
                if(oid>0)
                    entObj.setOID(objTmp.getOID());
            }
            return entObj.getOID();
        }
        catch(Exception e) {
            System.out.println(e);
        }
        return 0;
    }
    
    private static long insertObj(PrivilegeObj entObj) {
        try{
            DbPrivilegeObj pstObj = new DbPrivilegeObj(0);
            
            pstObj.setLong(COL_PRIV_ID, entObj.getPrivId());
            pstObj.setInt(COL_CODE , entObj.getCode());
            
            pstObj.insert();
            entObj.setOID(pstObj.getlong(COL_PRIV_OBJ_ID));
            return entObj.getOID();
        }
        catch(CONException e) {
            System.out.println(e);
        }
        return 0;
    }
    
    
    /**
     * update module priv. as group. Delete the group first then insert
     */
    public static long update(PrivilegeObj entObj) {
        try{      
            
            int max = entObj.getCommandsSize();
            
            deleteByPrivOIDObjCode(entObj.getPrivId(), entObj.getCode() );
            
            if(max<1){
                return entObj.getOID();
            }   
            
            int moduleObj = entObj.getCode() & intObjFilter;
            
            for(int i=0; i<max;i++){                
                PrivilegeObj objTmp =  new  PrivilegeObj();
                
                objTmp.setPrivId(entObj.getPrivId());
                objTmp.setCode(moduleObj + (entObj.getCommand(i) & intCmdFilter));
                objTmp.setOID(0);
                long oid = DbPrivilegeObj.insertObj(objTmp);                
                if(oid>0)
                    entObj.setOID(objTmp.getOID());
            }
            return entObj.getOID();
        }
        catch(Exception e) {
            System.out.println(e);
        }
        return 0;
    }
    
    private static long updateObj(PrivilegeObj entObj) {
        if( (entObj!=null) && (entObj.getOID() != 0)) {
            try {
                DbPrivilegeObj pstObj = new DbPrivilegeObj(entObj.getOID());
                pstObj.setLong(COL_PRIV_ID, entObj.getPrivId());
                pstObj.setInt(COL_CODE, entObj.getCode());
                
                pstObj.update();
                return entObj.getOID();
            }catch(Exception e) {
                System.out.println(e);
            }
        }
        return 0;
    }

    
    public static long delete(long oid) {
        try {
            DbPrivilegeObj pstObj = new DbPrivilegeObj(oid);
            pstObj.delete();
            return oid;
        }catch(Exception e) {
            System.out.println(e);
        }
        return 0;
    }
    
    public static long deleteByPrivOID(long privOID){
        CONResultSet dbrs=null;
        try{
            if(privOID==0)
                return 0;
            
            int count = 0;
            String sql = " DELETE " +
            " FROM " + DB_APP_PRIVILEGE_OBJ +
            " WHERE " + colNames[COL_PRIV_ID]+ " = '"+privOID+"'";
            
            System.out.println(sql);
            int status = CONHandler.execUpdate(sql);
            return 1;
        }
        catch (Exception exc){
            System.out.println( "DbPrivilegeObj.deleteByPrivOID "+ exc);
            return 0;
        } 
        finally{
            CONResultSet.close(dbrs);
        }

        
    }

    public static long deleteByPrivOIDObjCode(long privOID, int objCode){
        CONResultSet dbrs=null;
        try{
            if(privOID==0)
                return 0;
            System.out.println(" deleteByPrivOIDObjCode =>  ");
            String sql = " DELETE " +
            " FROM " + DB_APP_PRIVILEGE_OBJ +
            " WHERE " + colNames[COL_PRIV_ID]+ " = '"+privOID+"' AND ("+
                colNames[COL_CODE] + " & " + strObjFilter+ ") = '"+ 
                (objCode & intObjFilter ) +"'";
            
            System.out.println(sql);
            int status = CONHandler.execUpdate(sql);
            return privOID;
        }
        catch (Exception exc){
            System.out.println("deleteByPrivOID "+ exc);
        }
        finally {
            CONResultSet.close(dbrs);
        }
        return 0;
    }
    
/*
    public static int getCount(String whereClause){
        try{
            int count = 0;
            String sql = " SELECT COUNT("+colNames[COL_PRIV_OBJ_ID] +") AS NRCOUNT" +
                         " FROM " + DB_APP_PRIVILEGE_OBJ;
 
 
            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;
 
            System.out.println(sql);
            ResultSet rs = execQuery(sql);
 
            while(rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
 
            return count;
        }
        catch (Exception exc){
            System.out.println("getCount "+ exc);
            return 0;
        }
 
    }
 */
    
    public static int getCountByPrivOID_GroupByObj(long privOID){
        CONResultSet dbrs=null;
        try{
            int count = 0;
            /*
            String sql = " SELECT COUNT( DISTINCT("+  colNames[COL_CODE] +" & 0xFFFFFF00)) AS NRCOUNT" +
            " FROM " + DB_APP_PRIVILEGE_OBJ;
             **/
            
            String sql = " SELECT COUNT( DISTINCT(HEX("+  colNames[COL_CODE] +" & 0xFFFFFF00))) AS NRCOUNT" +
            " FROM " + DB_APP_PRIVILEGE_OBJ;
                        
            if(privOID!=0)
                sql = sql + " WHERE " + colNames[COL_PRIV_ID]+ " = '"+privOID+"'";
            
            //sql= sql + " GROUP BY ("+ colNames[COL_CODE] +" & "+ strObjFilter + ") ";            
            
            System.out.println(" getCountByPrivOID_GroupByObj => " +sql);
            
            dbrs=CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                count = rs.getInt(1);
            }            
            return count;
        }
        catch (Exception exc){
            System.out.println("getCountByPrivOID "+ exc);
            return 0;
        }
       finally{
            CONResultSet.close(dbrs);
       }
        
        
    }
    
    public static int getCountByPrivOID(long privOID){
        CONResultSet dbrs=null;
        try{
            int count = 0;
            String sql = " SELECT COUNT("+colNames[COL_PRIV_OBJ_ID] +") AS NRCOUNT" +
            " FROM " + DB_APP_PRIVILEGE_OBJ;
            
            
            if(privOID!=0)
                sql = sql + " WHERE " + colNames[COL_PRIV_ID]+ " = '"+privOID+"'";
            
            System.out.println(sql);
            dbrs=CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                count = rs.getInt(1);
            }
            
            return count;
        }
        catch (Exception exc){
            System.out.println("getCountByPrivOID "+ exc);
            return 0;
        }
       finally{
            CONResultSet.close(dbrs);
       }
        
        
    }
    
    public static Vector listCmd_ByPrivObj(long privOID, int objCode){
        Vector lists = new Vector();
        CONResultSet dbrs= null;
        try {
            String sql = "SELECT "+colNames[COL_CODE] +
            " FROM " + DB_APP_PRIVILEGE_OBJ +
            " WHERE " + colNames[COL_PRIV_ID]+ " = '"+privOID+"' AND ("+
                colNames[COL_CODE] + " & " + strObjFilter+ ") = '"+ (objCode & intObjFilter ) +"' " +
            " ORDER BY (" + colNames[COL_CODE] + " & " + strCmdFilter+ ")";
            
            dbrs=CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
                        
            while(rs.next()) {
                lists.add(new Integer(rs.getInt(colNames[COL_CODE]) & intCmdFilter ));
            }
            
            return lists;
            
        }catch(Exception e) {
            System.out.println(e);
        }
        finally{
            CONResultSet.close(dbrs);
        }
        return new Vector();
        
    }
    
    public static Vector listWithCmd_ByPrivOID_GroupByObj( int start , int recordToGet,
    long privOID, String order){
        
        Vector listObjs = listByPrivOID_GroupByObj(start , recordToGet, privOID, order);
        
        Vector lists = new Vector(1,1);
        if( (listObjs==null) || (listObjs.size()<1))
            return lists;
        int max= listObjs.size();
        for(int i=0; i<max; i++){
            PrivilegeObj appPrivObj = (PrivilegeObj)listObjs.get(i);
            appPrivObj.setCommands(listCmd_ByPrivObj(privOID, appPrivObj.getCode()));
            lists.add(appPrivObj);
        }
        return lists;
    }
    
    
    public static Vector listByPrivOID_GroupByObj( int limitStart , int recordToGet,
    long privOID, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs=null;
        try {
            String sql = "SELECT "+colNames[COL_PRIV_ID] +
            ", " + colNames[COL_CODE] +
            ", " + colNames[COL_PRIV_OBJ_ID] +
            " FROM " + DB_APP_PRIVILEGE_OBJ;
            
            if(privOID!=0)
                sql = sql + " WHERE " + colNames[COL_PRIV_ID]+ " = '"+privOID+"'";
            
            sql= sql + " GROUP BY ("+ colNames[COL_CODE] +" & "+ strObjFilter + ") ";
            
            if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;
            
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

            dbrs=CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                PrivilegeObj appPrivObj = new PrivilegeObj();
                resultToObject(rs, appPrivObj);
                lists.add(appPrivObj);
            }
            return lists;
            
        }catch(Exception e) {
            System.out.println(e);
        }
        finally{
            CONResultSet.close(dbrs);
        }        
        return new Vector();
    }
    
    
    public static Vector listByPrivOID(int limitStart , int recordToGet, long privOID, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs=null;
        try {
            String sql = "SELECT "+colNames[COL_PRIV_ID] +
            ", " + colNames[COL_CODE] +
            ", " + colNames[COL_PRIV_OBJ_ID] +
            " FROM " + DB_APP_PRIVILEGE_OBJ;
            
            if(privOID!=0)
                sql = sql + " WHERE " + colNames[COL_PRIV_ID]+ " = '"+privOID+"'";
            
            if(order != null && order.length() > 0)
                sql = sql + " ORDER BY " + order;
            
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
            
            dbrs=CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()) {
                PrivilegeObj appPriv = new PrivilegeObj();
                resultToObject(rs, appPriv);
                lists.add(appPriv);
            }
            return lists;
            
        }catch(Exception e) {
            System.out.println(e);
        }
        finally{
            CONResultSet.close(dbrs);
        }        
        
        
        return new Vector();
    }
    
    
    
    private static void resultToObject(ResultSet rs, PrivilegeObj entObj) {
        try {
            entObj.setOID(rs.getLong(colNames[COL_PRIV_OBJ_ID]));
            entObj.setPrivId(rs.getLong(colNames[COL_PRIV_ID]));
            entObj.setCode(rs.getInt(colNames[COL_CODE]));
        }catch(Exception e){
            System.out.println("resultToObject() " + e.toString());
        }
    }
    
    
    
}
