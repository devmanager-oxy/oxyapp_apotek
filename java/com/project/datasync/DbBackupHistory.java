
package com.project.datasync; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.datasync.*; 
import com.project.util.lang.I_Language;

public class DbBackupHistory extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_BACKUP_HISTORY = "backup_history";

	public static final  int COL_BACKUP_HISTORY_ID = 0;
	public static final  int COL_DATE = 1;
	public static final  int COL_START_DATE = 2;
	public static final  int COL_END_DATE = 3;
	public static final  int COL_OPERATOR = 4;
	public static final  int COL_TYPE = 5;
	public static final  int COL_NOTE = 6;
        public static final  int COL_COMPANY_ID = 7;

	public static final  String[] colNames = {
		"backup_history_id",
		"date",
		"start_date",
		"end_date",
		"operator",
		"type",
		"note",
                "company_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_INT,
		TYPE_STRING,
                TYPE_LONG
	 }; 
         
         
        public static final int TYPE_BACKUP = 0;
        public static final int TYPE_UPLOAD = 1;

	public DbBackupHistory(){
	}

	public DbBackupHistory(int i) throws CONException { 
		super(new DbBackupHistory()); 
	}

	public DbBackupHistory(String sOid) throws CONException { 
		super(new DbBackupHistory(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbBackupHistory(long lOid) throws CONException { 
		super(new DbBackupHistory(0)); 
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
		return DB_BACKUP_HISTORY;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbBackupHistory().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		BackupHistory backuphistory = fetchExc(ent.getOID()); 
		ent = (Entity)backuphistory; 
		return backuphistory.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((BackupHistory) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((BackupHistory) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static BackupHistory fetchExc(long oid) throws CONException{ 
		try{ 
			BackupHistory backuphistory = new BackupHistory();
			DbBackupHistory pstBackupHistory = new DbBackupHistory(oid); 
			backuphistory.setOID(oid);

			backuphistory.setDate(pstBackupHistory.getDate(COL_DATE));
			backuphistory.setStartDate(pstBackupHistory.getDate(COL_START_DATE));
			backuphistory.setEndDate(pstBackupHistory.getDate(COL_END_DATE));
			backuphistory.setOperator(pstBackupHistory.getlong(COL_OPERATOR));
			backuphistory.setType(pstBackupHistory.getInt(COL_TYPE));
			backuphistory.setNote(pstBackupHistory.getString(COL_NOTE));
                        backuphistory.setCompanyId(pstBackupHistory.getlong(COL_COMPANY_ID)); 

			return backuphistory; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBackupHistory(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(BackupHistory backuphistory) throws CONException{ 
		try{ 
			DbBackupHistory pstBackupHistory = new DbBackupHistory(0);

			pstBackupHistory.setDate(COL_DATE, backuphistory.getDate());
			pstBackupHistory.setDate(COL_START_DATE, backuphistory.getStartDate());
			pstBackupHistory.setDate(COL_END_DATE, backuphistory.getEndDate());
			pstBackupHistory.setLong(COL_OPERATOR, backuphistory.getOperator());
			pstBackupHistory.setInt(COL_TYPE, backuphistory.getType());
			pstBackupHistory.setString(COL_NOTE, backuphistory.getNote());
                        pstBackupHistory.setLong(COL_COMPANY_ID, backuphistory.getCompanyId());

			pstBackupHistory.insert(); 
			backuphistory.setOID(pstBackupHistory.getlong(COL_BACKUP_HISTORY_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBackupHistory(0),CONException.UNKNOWN); 
		}
		return backuphistory.getOID();
	}

	public static long updateExc(BackupHistory backuphistory) throws CONException{ 
		try{ 
			if(backuphistory.getOID() != 0){ 
				DbBackupHistory pstBackupHistory = new DbBackupHistory(backuphistory.getOID());

				pstBackupHistory.setDate(COL_DATE, backuphistory.getDate());
				pstBackupHistory.setDate(COL_START_DATE, backuphistory.getStartDate());
				pstBackupHistory.setDate(COL_END_DATE, backuphistory.getEndDate());
				pstBackupHistory.setLong(COL_OPERATOR, backuphistory.getOperator());
				pstBackupHistory.setInt(COL_TYPE, backuphistory.getType());
				pstBackupHistory.setString(COL_NOTE, backuphistory.getNote());
                                pstBackupHistory.setLong(COL_COMPANY_ID, backuphistory.getCompanyId());

				pstBackupHistory.update(); 
				return backuphistory.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBackupHistory(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbBackupHistory pstBackupHistory = new DbBackupHistory(oid);
			pstBackupHistory.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBackupHistory(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_BACKUP_HISTORY; 
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
				BackupHistory backuphistory = new BackupHistory();
				resultToObject(rs, backuphistory);
				lists.add(backuphistory);
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

	private static void resultToObject(ResultSet rs, BackupHistory backuphistory){
		try{
			backuphistory.setOID(rs.getLong(DbBackupHistory.colNames[DbBackupHistory.COL_BACKUP_HISTORY_ID]));
			backuphistory.setDate(rs.getDate(DbBackupHistory.colNames[DbBackupHistory.COL_DATE]));
			backuphistory.setStartDate(rs.getDate(DbBackupHistory.colNames[DbBackupHistory.COL_START_DATE]));
			backuphistory.setEndDate(rs.getDate(DbBackupHistory.colNames[DbBackupHistory.COL_END_DATE]));
			backuphistory.setOperator(rs.getLong(DbBackupHistory.colNames[DbBackupHistory.COL_OPERATOR]));
			backuphistory.setType(rs.getInt(DbBackupHistory.colNames[DbBackupHistory.COL_TYPE]));
			backuphistory.setNote(rs.getString(DbBackupHistory.colNames[DbBackupHistory.COL_NOTE]));
                        backuphistory.setCompanyId(rs.getLong(DbBackupHistory.colNames[DbBackupHistory.COL_COMPANY_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long backupHistoryId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_BACKUP_HISTORY + " WHERE " + 
						DbBackupHistory.colNames[DbBackupHistory.COL_BACKUP_HISTORY_ID] + " = " + backupHistoryId;

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
			String sql = "SELECT COUNT("+ DbBackupHistory.colNames[DbBackupHistory.COL_BACKUP_HISTORY_ID] + ") FROM " + DB_BACKUP_HISTORY;
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
			  	   BackupHistory backuphistory = (BackupHistory)list.get(ls);
				   if(oid == backuphistory.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
