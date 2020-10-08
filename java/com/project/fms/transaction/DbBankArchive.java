/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  1/3/2008 11:46:59 AM
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


public class DbBankArchive extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc {

	public static final  String DB_BANKARCHIVE = "bankarchive";

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

	public DbBankArchive(){
	}

	public DbBankArchive(int i) throws CONException {
		super(new DbBankArchive());
	}

	public DbBankArchive(String sOid) throws CONException {
		super(new DbBankArchive(0));
		if(!locate(sOid))
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		else
			return;
	}

	public DbBankArchive(long lOid) throws CONException {
		super(new DbBankArchive(0));
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
		return DB_BANKARCHIVE;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbBankArchive().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception {
		BankArchive bankarchive = fetchExc(ent.getOID());
		ent = (Entity)bankarchive;
		return bankarchive.getOID();
	}

	public long insertExc(Entity ent) throws Exception {
		return insertExc((BankArchive) ent);
	}

	public long updateExc(Entity ent) throws Exception {
		return updateExc((BankArchive) ent);
	}

	public long deleteExc(Entity ent) throws Exception {
		if(ent==null){
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		}
			return deleteExc(ent.getOID());
	}

	public static BankArchive fetchExc(long oid) throws CONException{
		try{
			BankArchive bankarchive = new BankArchive();
			DbBankArchive dbBankArchive = new DbBankArchive(oid);
			bankarchive.setOID(oid);

			bankarchive.setSearchFor(dbBankArchive.getString(COL_SEARCH_FOR));
			bankarchive.setStartDate(dbBankArchive.getDate(COL_START_DATE));
			bankarchive.setEndDate(dbBankArchive.getDate(COL_END_DATE));
			bankarchive.setIgnoreInputDate(dbBankArchive.getInt(COL_IGNORE_INPUT_DATE));
			bankarchive.setTransactionDate(dbBankArchive.getDate(COL_TRANSACTION_DATE));
			bankarchive.setIgnoreTransactionDate(dbBankArchive.getInt(COL_IGNORE_TRANSACTION_DATE));
			bankarchive.setJournalNumber(dbBankArchive.getString(COL_JOURNAL_NUMBER));
			bankarchive.setBlankJournalNumber(dbBankArchive.getInt(COL_BLANK_JOURNAL_NUMBER));
			bankarchive.setPeriodeId(dbBankArchive.getlong(COL_PERIODE_ID));

			return bankarchive;
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbBankArchive(0),CONException.UNKNOWN);
		}
	}

	public static long insertExc(BankArchive bankarchive) throws CONException{
		try{
			DbBankArchive dbBankArchive = new DbBankArchive(0);

			dbBankArchive.setString(COL_SEARCH_FOR, bankarchive.getSearchFor());
			dbBankArchive.setDate(COL_START_DATE, bankarchive.getStartDate());
			dbBankArchive.setDate(COL_END_DATE, bankarchive.getEndDate());
			dbBankArchive.setInt(COL_IGNORE_INPUT_DATE, bankarchive.getIgnoreInputDate());
			dbBankArchive.setDate(COL_TRANSACTION_DATE, bankarchive.getTransactionDate());
			dbBankArchive.setInt(COL_IGNORE_TRANSACTION_DATE, bankarchive.getIgnoreTransactionDate());
			dbBankArchive.setString(COL_JOURNAL_NUMBER, bankarchive.getJournalNumber());
			dbBankArchive.setInt(COL_BLANK_JOURNAL_NUMBER, bankarchive.getBlankJournalNumber());
			dbBankArchive.setLong(COL_PERIODE_ID, bankarchive.getPeriodeId());

			dbBankArchive.insert();
			bankarchive.setOID(dbBankArchive.getlong(COL_ARCHIVE_ID));
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbBankArchive(0),CONException.UNKNOWN);
		}
		return bankarchive.getOID();
	}

	public static long updateExc(BankArchive bankarchive) throws CONException{
		try{
			if(bankarchive.getOID() != 0){
				DbBankArchive dbBankArchive = new DbBankArchive(bankarchive.getOID());

				dbBankArchive.setString(COL_SEARCH_FOR, bankarchive.getSearchFor());
				dbBankArchive.setDate(COL_START_DATE, bankarchive.getStartDate());
				dbBankArchive.setDate(COL_END_DATE, bankarchive.getEndDate());
				dbBankArchive.setInt(COL_IGNORE_INPUT_DATE, bankarchive.getIgnoreInputDate());
				dbBankArchive.setDate(COL_TRANSACTION_DATE, bankarchive.getTransactionDate());
				dbBankArchive.setInt(COL_IGNORE_TRANSACTION_DATE, bankarchive.getIgnoreTransactionDate());
				dbBankArchive.setString(COL_JOURNAL_NUMBER, bankarchive.getJournalNumber());
				dbBankArchive.setInt(COL_BLANK_JOURNAL_NUMBER, bankarchive.getBlankJournalNumber());
				dbBankArchive.setLong(COL_PERIODE_ID, bankarchive.getPeriodeId());

				dbBankArchive.update();
				return bankarchive.getOID();

			}
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbBankArchive(0),CONException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{
		try{
			DbBankArchive dbBankArchive = new DbBankArchive(oid);
			dbBankArchive.delete();
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbBankArchive(0),CONException.UNKNOWN);
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
			String sql = "SELECT * FROM " + DB_BANKARCHIVE;
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
				BankArchive bankarchive = new BankArchive();
				resultToObject(rs, bankarchive);
				lists.add(bankarchive);
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

	private static void resultToObject(ResultSet rs, BankArchive bankarchive){
		try{

			bankarchive.setOID(rs.getLong(DbBankArchive.colNames[DbBankArchive.COL_ARCHIVE_ID]));
			bankarchive.setSearchFor(rs.getString(DbBankArchive.colNames[DbBankArchive.COL_SEARCH_FOR]));
			bankarchive.setStartDate(rs.getDate(DbBankArchive.colNames[DbBankArchive.COL_START_DATE]));
			bankarchive.setEndDate(rs.getDate(DbBankArchive.colNames[DbBankArchive.COL_END_DATE]));
			bankarchive.setIgnoreInputDate(rs.getInt(DbBankArchive.colNames[DbBankArchive.COL_IGNORE_INPUT_DATE]));
			bankarchive.setTransactionDate(rs.getDate(DbBankArchive.colNames[DbBankArchive.COL_TRANSACTION_DATE]));
			bankarchive.setIgnoreTransactionDate(rs.getInt(DbBankArchive.colNames[DbBankArchive.COL_IGNORE_TRANSACTION_DATE]));
			bankarchive.setJournalNumber(rs.getString(DbBankArchive.colNames[DbBankArchive.COL_JOURNAL_NUMBER]));
			bankarchive.setBlankJournalNumber(rs.getInt(DbBankArchive.colNames[DbBankArchive.COL_BLANK_JOURNAL_NUMBER]));
			bankarchive.setPeriodeId(rs.getLong(DbBankArchive.colNames[DbBankArchive.COL_PERIODE_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long archiveId)
	{
		CONResultSet dbrs = null;
		boolean result = false;
		try
		{
			String sql = "SELECT * FROM " + DB_BANKARCHIVE + " WHERE " + 
				DbBankArchive.colNames[DbBankArchive.COL_ARCHIVE_ID] + " = " + archiveId;
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
			String sql = "SELECT COUNT("+ DbBankArchive.colNames[DbBankArchive.COL_ARCHIVE_ID] + ") FROM " + DB_BANKARCHIVE;
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
				BankArchive bankarchive = (BankArchive)list.get(ls);
				if(oid == bankarchive.getOID())
					found=true;
				}
			}
		}
		if((start >= size) && (size > 0))
			start = start - recordToGet;

		return start;
	}

}
