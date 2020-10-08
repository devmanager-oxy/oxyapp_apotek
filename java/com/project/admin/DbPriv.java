

package com.project.admin;



import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.*;



public class DbPriv extends CONHandler implements I_CONInterface, I_CONType, I_Persintent  {
    
    public static final String DB_APP_PRIVILEGE = "privilege";

    public static final int COL_PRIV_ID			= 0;
    public static final int COL_PRIV_NAME		= 1;
    public static final int COL_REG_DATE 		= 2;
    public static final int COL_DESCRIPTION 		= 3;
    
    
    public static  final String[] colNames = {
        "priv_id", "priv_name", "reg_date", "description"
    } ;
    
    public static int[] fieldTypes = {
        TYPE_PK + TYPE_LONG + TYPE_ID, TYPE_STRING,  TYPE_DATE, TYPE_STRING
    };
    
    /** Creates new DbPriv */
    public DbPriv() {
    }
    
    public DbPriv(int i) throws CONException {
        super(new DbPriv());
    }
    
    
    public DbPriv(String sOid) throws CONException {
        super(new DbPriv(0));
        if(!locate(sOid))
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        else
            return;
    }
    
    
    public DbPriv(long lOid) throws CONException {
        super(new DbPriv(0));
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
        return DB_APP_PRIVILEGE;
    }
    
    public String getPersistentName() {
        return new DbPriv().getClass().getName();
    }
    
    
    public int[] getFieldTypes() {
        return fieldTypes;
    }
    
    public String[] getFieldNames() {
        return colNames;
    }
    
    
    public long delete(Entity ent) {
        return delete((Priv) ent);
    }
    
    public long insert(Entity ent) {
        return DbPriv.insert((Priv) ent);
    }
    
    
    public long update(Entity ent) {
        return update((Priv) ent);
    }
    
    public long fetch(Entity ent) {
        Priv entObj = DbPriv.fetch(ent.getOID());
        ent = (Entity)entObj;
        return ent.getOID();
    }
    
    
    public static Priv fetch(long oid) {
        Priv entObj = new Priv();
        try {
            DbPriv pstObj = new DbPriv(oid);
            entObj.setOID(oid);
            entObj.setPrivName(pstObj.getString(COL_PRIV_NAME));
            entObj.setDescr(pstObj.getString(COL_DESCRIPTION));
            entObj.setRegDate(pstObj.getDate(COL_REG_DATE));
        }
        catch(CONException e) {
            System.out.println(e);
        }
        return entObj;
    }
    
    
    public static long insert(Priv entObj) {
        try{
            DbPriv pstObj = new DbPriv(0);
            pstObj.setString(COL_PRIV_NAME, entObj.getPrivName());
            pstObj.setDate(COL_REG_DATE, entObj.getRegDate());
            pstObj.setString(COL_DESCRIPTION, entObj.getDescr());
            
            pstObj.insert();
            entObj.setOID(pstObj.getlong(COL_PRIV_ID));
            return entObj.getOID();
        }
        catch(CONException e) {
            System.out.println(e);
        }
        return 0;
    }
    
    
    public static long update(Priv entObj) {
        if( (entObj!=null) && (entObj.getOID() != 0)) {
            try {
                DbPriv pstObj = new DbPriv(entObj.getOID());
                pstObj.setString(COL_PRIV_NAME, entObj.getPrivName());
                pstObj.setDate(COL_REG_DATE, entObj.getRegDate());
                pstObj.setString(COL_DESCRIPTION, entObj.getDescr());
                
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
            DbPriv pstObj = new DbPriv(oid);
            pstObj.delete();
            return oid;
        }catch(Exception e) {
            System.out.println(e);
        }
        return 0;
    }
    
    public static int getCount(String whereClause){
        CONResultSet dbrs=null;
        try{
            int count = 0;
            String sql = " SELECT COUNT("+colNames[COL_PRIV_ID] +") AS NRCOUNT" + 
                         " FROM " + DB_APP_PRIVILEGE;


            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;

           // System.out.println(sql);
            dbrs=CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while(rs.next()) {
                count = rs.getInt(1);
            }             
            return count;
        }
        catch (Exception exc){
            System.out.println("getCount "+ exc);
            return 0;
        }
       finally{
            CONResultSet.close(dbrs);
       }
        
    }
    
    public static Vector list(int limitStart , int recordToGet, String whereClause, String order)
    {
        Vector lists = new Vector();        
        CONResultSet dbrs=null;
        try {
            String sql = "SELECT "+colNames[COL_PRIV_ID] +
                         ", " + colNames[COL_PRIV_NAME] +
                         ", " + colNames[COL_REG_DATE] +
                         ", " + colNames[COL_DESCRIPTION] +
                         " FROM " + DB_APP_PRIVILEGE;

            if(whereClause != null && whereClause.length() > 0)
                sql = sql + " WHERE " + whereClause;

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
                Priv appPriv = new Priv();
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

    
    private static void resultToObject(ResultSet rs, Priv appPriv) {
        try {
            appPriv.setOID(rs.getLong(colNames[COL_PRIV_ID]));
            appPriv.setPrivName(rs.getString(colNames[COL_PRIV_NAME]));
            String str = rs.getString(colNames[COL_REG_DATE])  ;
            Date dt = JSPFormater.formatDate(str, "yyyy-MM-dd HH:MM:SS");
            appPriv.setRegDate(dt);
            appPriv.setDescr(rs.getString(colNames[COL_DESCRIPTION]));
        }catch(Exception e){
            System.out.println("resultToObject() " + e.toString());
        }
    }
    
    	/* This method used to find current data */
	public static int findLimitStart( long oid, int recordToGet, String whereClause,String orderClause){		
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, orderClause); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   Priv appPriv = (Priv)list.get(ls);
				   if(oid == appPriv.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}


     public static int findLimitJSPCommand(int start, int recordToGet, int vectSize)
    {
        int cmd = JSPCommand.LIST;
        int mdl = vectSize % recordToGet;
        vectSize = vectSize + mdl;
    	if(start == 0)
            cmd =  JSPCommand.FIRST;
        else{
            if(start == (vectSize-recordToGet))
                cmd = JSPCommand.LAST;
            else{
            	start = start + recordToGet;
             	if(start <= (vectSize - recordToGet)){
                 	cmd = JSPCommand.NEXT;
                    System.out.println("next.......................");
             	}else{
                    start = start - recordToGet;
		             if(start > 0){
                         cmd = JSPCommand.PREV;
                         System.out.println("prev.......................");
		             }
                }
            }
        }

        return cmd;
    }

    
}
