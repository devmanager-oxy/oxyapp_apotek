/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  1/6/2008 9:19:08 PM
\***********************************/

package com.project.fms.transaction;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;


public class DbGlArchive extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

	public static final  String DB_GLARCHIVE = "glarchive";

	public static final  int COL_ARCHIVE_ID = 0;
	public static final  int COL_SEARCH_FOR = 1;
	public static final  int COL_START_DATE = 2;
	public static final  int COL_END_DATE = 3;
	public static final  int COL_IGNORE_INPUT_DATE = 4;
	public static final  int COL_TRANSACTION_DATE = 5;
	public static final  int COL_IGNORE_TRANSACTION_DATE = 6;
	public static final  int COL_JOURNAL_NUMBER = 7;
	public static final  int COL_BLANK_JOURNAL_NUMBER = 8;
	public static final  int COL_PERIODE_ID = 9;

	public static final  String[] colNames = {
		"archive_id",
		"search_for",
		"start_date",
		"end_date",
		"ignore_input_date",
		"transaction_date",
		"ignore_transaction_date",
		"journal_number",
		"blank_journal_number",
		"periode_id"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_INT,
		TYPE_DATE,
		TYPE_INT,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG
	};

	public DbGlArchive(){
	}

	public DbGlArchive(int i) throws CONException {
		super(new DbGlArchive());
	}

	public DbGlArchive(String sOid) throws CONException {
		super(new DbGlArchive(0));
		if(!locate(sOid))
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		else
			return;
	}

	public DbGlArchive(long lOid) throws CONException {
		super(new DbGlArchive(0));
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
		return DB_GLARCHIVE;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbGlArchive().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception {
		GlArchive glarchive = fetchExc(ent.getOID());
		ent = (Entity)glarchive;
		return glarchive.getOID();
	}

	public long insertExc(Entity ent) throws Exception {
		return insertExc((GlArchive) ent);
	}

	public long updateExc(Entity ent) throws Exception {
		return updateExc((GlArchive) ent);
	}

	public long deleteExc(Entity ent) throws Exception {
		if(ent==null){
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		}
			return deleteExc(ent.getOID());
	}

	public static GlArchive fetchExc(long oid) throws CONException{
		try{
			GlArchive glarchive = new GlArchive();
			DbGlArchive dbGlArchive = new DbGlArchive(oid);
			glarchive.setOID(oid);

			glarchive.setSearchFor(dbGlArchive.getString(COL_SEARCH_FOR));
			glarchive.setStartDate(dbGlArchive.getDate(COL_START_DATE));
			glarchive.setEndDate(dbGlArchive.getDate(COL_END_DATE));
			glarchive.setIgnoreInputDate(dbGlArchive.getInt(COL_IGNORE_INPUT_DATE));
			glarchive.setTransactionDate(dbGlArchive.getDate(COL_TRANSACTION_DATE));
			glarchive.setIgnoreTransactionDate(dbGlArchive.getInt(COL_IGNORE_TRANSACTION_DATE));
			glarchive.setJournalNumber(dbGlArchive.getString(COL_JOURNAL_NUMBER));
			glarchive.setBlankJournalNumber(dbGlArchive.getInt(COL_BLANK_JOURNAL_NUMBER));
			glarchive.setPeriodeId(dbGlArchive.getlong(COL_PERIODE_ID));

			return glarchive;
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbGlArchive(0),CONException.UNKNOWN);
		}
	}

	public static long insertExc(GlArchive glarchive) throws CONException{
		try{
			DbGlArchive dbGlArchive = new DbGlArchive(0);

			dbGlArchive.setString(COL_SEARCH_FOR, glarchive.getSearchFor());
			dbGlArchive.setDate(COL_START_DATE, glarchive.getStartDate());
			dbGlArchive.setDate(COL_END_DATE, glarchive.getEndDate());
			dbGlArchive.setInt(COL_IGNORE_INPUT_DATE, glarchive.getIgnoreInputDate());
			dbGlArchive.setDate(COL_TRANSACTION_DATE, glarchive.getTransactionDate());
			dbGlArchive.setInt(COL_IGNORE_TRANSACTION_DATE, glarchive.getIgnoreTransactionDate());
			dbGlArchive.setString(COL_JOURNAL_NUMBER, glarchive.getJournalNumber());
			dbGlArchive.setInt(COL_BLANK_JOURNAL_NUMBER, glarchive.getBlankJournalNumber());
			dbGlArchive.setLong(COL_PERIODE_ID, glarchive.getPeriodeId());

			dbGlArchive.insert();
			glarchive.setOID(dbGlArchive.getlong(COL_ARCHIVE_ID));
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbGlArchive(0),CONException.UNKNOWN);
		}
		return glarchive.getOID();
	}

	public static long updateExc(GlArchive glarchive) throws CONException{
		try{
			if(glarchive.getOID() != 0){
				DbGlArchive dbGlArchive = new DbGlArchive(glarchive.getOID());

				dbGlArchive.setString(COL_SEARCH_FOR, glarchive.getSearchFor());
				dbGlArchive.setDate(COL_START_DATE, glarchive.getStartDate());
				dbGlArchive.setDate(COL_END_DATE, glarchive.getEndDate());
				dbGlArchive.setInt(COL_IGNORE_INPUT_DATE, glarchive.getIgnoreInputDate());
				dbGlArchive.setDate(COL_TRANSACTION_DATE, glarchive.getTransactionDate());
				dbGlArchive.setInt(COL_IGNORE_TRANSACTION_DATE, glarchive.getIgnoreTransactionDate());
				dbGlArchive.setString(COL_JOURNAL_NUMBER, glarchive.getJournalNumber());
				dbGlArchive.setInt(COL_BLANK_JOURNAL_NUMBER, glarchive.getBlankJournalNumber());
				dbGlArchive.setLong(COL_PERIODE_ID, glarchive.getPeriodeId());

				dbGlArchive.update();
				return glarchive.getOID();

			}
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbGlArchive(0),CONException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{
		try{
			DbGlArchive dbGlArchive = new DbGlArchive(oid);
			dbGlArchive.delete();
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbGlArchive(0),CONException.UNKNOWN);
		}
		return oid;
	}

	public static Vector listAll()
	{
		return list(0, 500, "","");
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector();
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_GLARCHIVE;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;

						switch (CONHandler.CONSVR_TYPE) {
							case CONHandler.CONSVR_MYSQL:
								if (limitStart == 0 && recordToGet == 0)
									sql = sql + "";
								else
									sql = sql + " LIMIT " + limitStart + "," + recordToGet;
								break;

							case CONHandler.CONSVR_POSTGRESQL:
								if (limitStart == 0 && recordToGet == 0)
									sql = sql + "";
								else
									sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
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
			while(rs.next()) {
				GlArchive glarchive = new GlArchive();
				resultToObject(rs, glarchive);
				lists.add(glarchive);
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

	private static void resultToObject(ResultSet rs, GlArchive glarchive){
		try{

			glarchive.setOID(rs.getLong(DbGlArchive.colNames[DbGlArchive.COL_ARCHIVE_ID]));
			glarchive.setSearchFor(rs.getString(DbGlArchive.colNames[DbGlArchive.COL_SEARCH_FOR]));
			glarchive.setStartDate(rs.getDate(DbGlArchive.colNames[DbGlArchive.COL_START_DATE]));
			glarchive.setEndDate(rs.getDate(DbGlArchive.colNames[DbGlArchive.COL_END_DATE]));
			glarchive.setIgnoreInputDate(rs.getInt(DbGlArchive.colNames[DbGlArchive.COL_IGNORE_INPUT_DATE]));
			glarchive.setTransactionDate(rs.getDate(DbGlArchive.colNames[DbGlArchive.COL_TRANSACTION_DATE]));
			glarchive.setIgnoreTransactionDate(rs.getInt(DbGlArchive.colNames[DbGlArchive.COL_IGNORE_TRANSACTION_DATE]));
			glarchive.setJournalNumber(rs.getString(DbGlArchive.colNames[DbGlArchive.COL_JOURNAL_NUMBER]));
			glarchive.setBlankJournalNumber(rs.getInt(DbGlArchive.colNames[DbGlArchive.COL_BLANK_JOURNAL_NUMBER]));
			glarchive.setPeriodeId(rs.getLong(DbGlArchive.colNames[DbGlArchive.COL_PERIODE_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long archiveId)
	{
		CONResultSet dbrs = null;
		boolean result = false;
		try
		{
			String sql = "SELECT * FROM " + DB_GLARCHIVE + " WHERE " + 
				DbGlArchive.colNames[DbGlArchive.COL_ARCHIVE_ID] + " = " + archiveId;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) { result = true; }
			rs.close();
		}
		catch(Exception e)
		{
			System.out.println("err : "+e.toString());
		}
		finally
		{
			CONResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbGlArchive.colNames[DbGlArchive.COL_ARCHIVE_ID] + ") FROM " + DB_GLARCHIVE;
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
				GlArchive glarchive = (GlArchive)list.get(ls);
				if(oid == glarchive.getOID())
					found=true;
				}
			}
		}
		if((start >= size) && (size > 0))
			start = start - recordToGet;

		return start;
	}

}
