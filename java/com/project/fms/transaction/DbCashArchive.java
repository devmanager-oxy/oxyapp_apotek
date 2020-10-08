/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  1/7/2008 2:36:52 PM
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


public class DbCashArchive extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

	public static final  String DB_CASHARCHIVE = "casharchive";

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

	public DbCashArchive(){
	}

	public DbCashArchive(int i) throws CONException {
		super(new DbCashArchive());
	}

	public DbCashArchive(String sOid) throws CONException {
		super(new DbCashArchive(0));
		if(!locate(sOid))
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		else
			return;
	}

	public DbCashArchive(long lOid) throws CONException {
		super(new DbCashArchive(0));
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
		return DB_CASHARCHIVE;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbCashArchive().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception {
		CashArchive casharchive = fetchExc(ent.getOID());
		ent = (Entity)casharchive;
		return casharchive.getOID();
	}

	public long insertExc(Entity ent) throws Exception {
		return insertExc((CashArchive) ent);
	}

	public long updateExc(Entity ent) throws Exception {
		return updateExc((CashArchive) ent);
	}

	public long deleteExc(Entity ent) throws Exception {
		if(ent==null){
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		}
			return deleteExc(ent.getOID());
	}

	public static CashArchive fetchExc(long oid) throws CONException{
		try{
			CashArchive casharchive = new CashArchive();
			DbCashArchive dbCashArchive = new DbCashArchive(oid);
			casharchive.setOID(oid);

			casharchive.setSearchFor(dbCashArchive.getString(COL_SEARCH_FOR));
			casharchive.setStartDate(dbCashArchive.getDate(COL_START_DATE));
			casharchive.setEndDate(dbCashArchive.getDate(COL_END_DATE));
			casharchive.setIgnoreInputDate(dbCashArchive.getInt(COL_IGNORE_INPUT_DATE));
			casharchive.setTransactionDate(dbCashArchive.getDate(COL_TRANSACTION_DATE));
			casharchive.setIgnoreTransactionDate(dbCashArchive.getInt(COL_IGNORE_TRANSACTION_DATE));
			casharchive.setJournalNumber(dbCashArchive.getString(COL_JOURNAL_NUMBER));
			casharchive.setBlankJournalNumber(dbCashArchive.getInt(COL_BLANK_JOURNAL_NUMBER));
			casharchive.setPeriodeId(dbCashArchive.getlong(COL_PERIODE_ID));

			return casharchive;
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbCashArchive(0),CONException.UNKNOWN);
		}
	}

	public static long insertExc(CashArchive casharchive) throws CONException{
		try{
			DbCashArchive dbCashArchive = new DbCashArchive(0);

			dbCashArchive.setString(COL_SEARCH_FOR, casharchive.getSearchFor());
			dbCashArchive.setDate(COL_START_DATE, casharchive.getStartDate());
			dbCashArchive.setDate(COL_END_DATE, casharchive.getEndDate());
			dbCashArchive.setInt(COL_IGNORE_INPUT_DATE, casharchive.getIgnoreInputDate());
			dbCashArchive.setDate(COL_TRANSACTION_DATE, casharchive.getTransactionDate());
			dbCashArchive.setInt(COL_IGNORE_TRANSACTION_DATE, casharchive.getIgnoreTransactionDate());
			dbCashArchive.setString(COL_JOURNAL_NUMBER, casharchive.getJournalNumber());
			dbCashArchive.setInt(COL_BLANK_JOURNAL_NUMBER, casharchive.getBlankJournalNumber());
			dbCashArchive.setLong(COL_PERIODE_ID, casharchive.getPeriodeId());

			dbCashArchive.insert();
			casharchive.setOID(dbCashArchive.getlong(COL_ARCHIVE_ID));
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbCashArchive(0),CONException.UNKNOWN);
		}
		return casharchive.getOID();
	}

	public static long updateExc(CashArchive casharchive) throws CONException{
		try{
			if(casharchive.getOID() != 0){
				DbCashArchive dbCashArchive = new DbCashArchive(casharchive.getOID());

				dbCashArchive.setString(COL_SEARCH_FOR, casharchive.getSearchFor());
				dbCashArchive.setDate(COL_START_DATE, casharchive.getStartDate());
				dbCashArchive.setDate(COL_END_DATE, casharchive.getEndDate());
				dbCashArchive.setInt(COL_IGNORE_INPUT_DATE, casharchive.getIgnoreInputDate());
				dbCashArchive.setDate(COL_TRANSACTION_DATE, casharchive.getTransactionDate());
				dbCashArchive.setInt(COL_IGNORE_TRANSACTION_DATE, casharchive.getIgnoreTransactionDate());
				dbCashArchive.setString(COL_JOURNAL_NUMBER, casharchive.getJournalNumber());
				dbCashArchive.setInt(COL_BLANK_JOURNAL_NUMBER, casharchive.getBlankJournalNumber());
				dbCashArchive.setLong(COL_PERIODE_ID, casharchive.getPeriodeId());

				dbCashArchive.update();
				return casharchive.getOID();

			}
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbCashArchive(0),CONException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{
		try{
			DbCashArchive dbCashArchive = new DbCashArchive(oid);
			dbCashArchive.delete();
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbCashArchive(0),CONException.UNKNOWN);
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
			String sql = "SELECT * FROM " + DB_CASHARCHIVE;
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
				CashArchive casharchive = new CashArchive();
				resultToObject(rs, casharchive);
				lists.add(casharchive);
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

	private static void resultToObject(ResultSet rs, CashArchive casharchive){
		try{

			casharchive.setOID(rs.getLong(DbCashArchive.colNames[DbCashArchive.COL_ARCHIVE_ID]));
			casharchive.setSearchFor(rs.getString(DbCashArchive.colNames[DbCashArchive.COL_SEARCH_FOR]));
			casharchive.setStartDate(rs.getDate(DbCashArchive.colNames[DbCashArchive.COL_START_DATE]));
			casharchive.setEndDate(rs.getDate(DbCashArchive.colNames[DbCashArchive.COL_END_DATE]));
			casharchive.setIgnoreInputDate(rs.getInt(DbCashArchive.colNames[DbCashArchive.COL_IGNORE_INPUT_DATE]));
			casharchive.setTransactionDate(rs.getDate(DbCashArchive.colNames[DbCashArchive.COL_TRANSACTION_DATE]));
			casharchive.setIgnoreTransactionDate(rs.getInt(DbCashArchive.colNames[DbCashArchive.COL_IGNORE_TRANSACTION_DATE]));
			casharchive.setJournalNumber(rs.getString(DbCashArchive.colNames[DbCashArchive.COL_JOURNAL_NUMBER]));
			casharchive.setBlankJournalNumber(rs.getInt(DbCashArchive.colNames[DbCashArchive.COL_BLANK_JOURNAL_NUMBER]));
			casharchive.setPeriodeId(rs.getLong(DbCashArchive.colNames[DbCashArchive.COL_PERIODE_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long archiveId)
	{
		CONResultSet dbrs = null;
		boolean result = false;
		try
		{
			String sql = "SELECT * FROM " + DB_CASHARCHIVE + " WHERE " + 
				DbCashArchive.colNames[DbCashArchive.COL_ARCHIVE_ID] + " = " + archiveId;
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
			String sql = "SELECT COUNT("+ DbCashArchive.colNames[DbCashArchive.COL_ARCHIVE_ID] + ") FROM " + DB_CASHARCHIVE;
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
				CashArchive casharchive = (CashArchive)list.get(ls);
				if(oid == casharchive.getOID())
					found=true;
				}
			}
		}
		if((start >= size) && (size > 0))
			start = start - recordToGet;

		return start;
	}

}
