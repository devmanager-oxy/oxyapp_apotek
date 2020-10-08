
package com.project.general; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.*;

public class DbLogOperation extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_LOG_OPERATION = "logs_operation";

	public static final  int COL_LOG_OPERATION_ID = 0;
	public static final  int COL_LOG_DESC = 1;
	public static final  int COL_USER_NAME = 2;
	public static final  int COL_USER_ID = 3;
        public static final  int COL_OWNER_ID = 4;
        public static final  int COL_DATE = 5;

	public static final  String[] colNames = {
		"log_operation_id",
		"log_desc",
		"user_name",
		"user_id",
                "owner_id",
                "date"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
                TYPE_LONG,
                TYPE_DATE
	 }; 

	public DbLogOperation(){
	}

	public DbLogOperation(int i) throws CONException { 
		super(new DbLogOperation()); 
	}

	public DbLogOperation(String sOid) throws CONException { 
		super(new DbLogOperation(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbLogOperation(long lOid) throws CONException { 
		super(new DbLogOperation(0)); 
		String sOid = "0"; 
		try { 
			sOid = String.valueOf(lOid); 
		}catch(Exception e) { 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	} 

	public int getFieldSize(){ 
		return colNames.length; 
	}

	public String getTableName(){ 
		return DB_LOG_OPERATION;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbLogOperation().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		LogOperation logOperation = fetchExc(ent.getOID()); 
		ent = (Entity)logOperation; 
		return logOperation.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((LogOperation) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((LogOperation) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static LogOperation fetchExc(long oid) throws CONException{ 
		try{ 
			LogOperation logOperation = new LogOperation();
			DbLogOperation pstLogOperation = new DbLogOperation(oid); 
			logOperation.setOID(oid);

			logOperation.setLogDesc(pstLogOperation.getString(COL_LOG_DESC));
			logOperation.setUserName(pstLogOperation.getString(COL_USER_NAME));
			logOperation.setUserId(pstLogOperation.getlong(COL_USER_ID));
                        logOperation.setDate(pstLogOperation.getDate(COL_DATE));
                        logOperation.setOwnerId(pstLogOperation.getlong(COL_OWNER_ID));

			return logOperation; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbLogOperation(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(LogOperation logOperation) throws CONException{ 
		try{ 
			DbLogOperation pstLogOperation = new DbLogOperation(0);

			pstLogOperation.setString(COL_LOG_DESC, logOperation.getLogDesc());
			pstLogOperation.setString(COL_USER_NAME, logOperation.getUserName());
			pstLogOperation.setLong(COL_USER_ID, logOperation.getUserId());
                        pstLogOperation.setDate(COL_DATE, logOperation.getDate());
                        pstLogOperation.setLong(COL_OWNER_ID, logOperation.getOwnerId());

			pstLogOperation.insert(); 
			logOperation.setOID(pstLogOperation.getlong(COL_LOG_OPERATION_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbLogOperation(0),CONException.UNKNOWN); 
		}
		return logOperation.getOID();
	}

	public static long updateExc(LogOperation logOperation) throws CONException{ 
		try{ 
			if(logOperation.getOID() != 0){ 
				DbLogOperation pstLogOperation = new DbLogOperation(logOperation.getOID());

				pstLogOperation.setString(COL_LOG_DESC, logOperation.getLogDesc());
				pstLogOperation.setString(COL_USER_NAME, logOperation.getUserName());
				pstLogOperation.setDouble(COL_USER_ID, logOperation.getUserId());
                                pstLogOperation.setDate(COL_DATE, logOperation.getDate());
                                pstLogOperation.setLong(COL_OWNER_ID, logOperation.getOwnerId());

				pstLogOperation.update(); 
				return logOperation.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbLogOperation(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbLogOperation pstLogOperation = new DbLogOperation(oid);
			pstLogOperation.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbLogOperation(0),CONException.UNKNOWN); 
		}
		return oid;
	}

	public static Vector listAll(){ 
		return list(0, 500, "",""); 
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_LOG_OPERATION; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				LogOperation logOperation = new LogOperation();
				resultToObject(rs, logOperation);
				lists.add(logOperation);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}

	private static void resultToObject(ResultSet rs, LogOperation logOperation){
		try{
			logOperation.setOID(rs.getLong(DbLogOperation.colNames[DbLogOperation.COL_LOG_OPERATION_ID]));
			logOperation.setLogDesc(rs.getString(DbLogOperation.colNames[DbLogOperation.COL_LOG_DESC]));
			logOperation.setUserName(rs.getString(DbLogOperation.colNames[DbLogOperation.COL_USER_NAME]));
			logOperation.setUserId(rs.getLong(DbLogOperation.colNames[DbLogOperation.COL_USER_ID]));
                        logOperation.setDate(rs.getDate(DbLogOperation.colNames[DbLogOperation.COL_DATE]));
                        logOperation.setOwnerId(rs.getLong(DbLogOperation.colNames[DbLogOperation.COL_OWNER_ID]));
                        Date dt = rs.getDate(DbLogOperation.colNames[DbLogOperation.COL_DATE]);
                        
                        //Time dttime = rs.getTimDe(DbLogOperation.colNames[DbLogOperation.COL_DATE]);
                        Date dttime = rs.getTime(DbLogOperation.colNames[DbLogOperation.COL_DATE]);
                        System.out.println(dttime);
                        
                        Date dtx = new Date();
                        
                        //dt.setTime(dttime.getTime());
                        dtx.setDate(dt.getDate());
                        dtx.setMonth(dt.getMonth());
                        dtx.setYear(dt.getYear());
                        dtx.setHours(dttime.getHours());
                        dtx.setMinutes(dttime.getMinutes());
                        dtx.setSeconds(dttime.getSeconds());
                        
                        logOperation.setDate(dtx);

		}catch(Exception e){ }
	}

	public static boolean checkOID(long logOperationId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_LOG_OPERATION + " WHERE " + 
						DbLogOperation.colNames[DbLogOperation.COL_LOG_OPERATION_ID] + " = " + logOperationId;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) { result = true; }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			CONResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbLogOperation.colNames[DbLogOperation.COL_LOG_OPERATION_ID] + ") FROM " + DB_LOG_OPERATION;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
	}


	/* This method used to find current data */
	public static int findLimitStart( long oid, int recordToGet, String whereClause){
		String order = "";
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, order); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   LogOperation logOperation = (LogOperation)list.get(ls);
				   if(oid == logOperation.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
