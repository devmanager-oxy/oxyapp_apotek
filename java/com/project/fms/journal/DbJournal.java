
package com.project.fms.journal; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.journal.*;  
import com.project.util.lang.*;
import com.project.util.*;
import com.project.system.*;

public class DbJournal extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_JOURNAL = "journal";

	public static final  int CL_JOURNAL_ID = 0;
	public static final  int CL_DATE = 1;
	public static final  int CL_PIC_BY = 2;
	public static final  int CL_CURRENCY = 3;
	public static final  int CL_MEMO = 4;
	public static final  int CL_PIC_FROM = 5;
	public static final  int CL_USER_BY_ID = 6;
	public static final  int CL_USER_FROM_ID = 7;
	public static final  int CL_PERIODE_ID = 8;
	public static final  int CL_STATUS = 9;
	public static final  int CL_AMOUNT = 10;
	public static final  int CL_REFF_NO = 11;
	public static final  int CL_VOUCHER_NUMBER = 12;
	public static final  int CL_VOUCHER_COUNTER = 13;
	public static final  int CL_VOUCHER_DATE = 14;
	public static final  int CL_EXCHANGE_RATE = 15;
	public static final  int CL_USER_ID = 16;
	public static final  int CL_JOURNAL_TYPE = 17;
	public static final  int CL_AP_ID = 18;
	public static final  int CL_ARAP_PAYMENT_ID = 19;
	public static final  int CL_AR_ID = 20;

	public static final  String[] colNames = {
		"journal_id",
		"date",
		"pic_by",
		"currency",
		"memo",
		"pic_from",
		"user_by_id",
		"user_from_id",
		"period_id",
		"status",
		"amount",
		"reff_no",
		"voucher_number",
		"voucher_counter",
		"voucher_date",
		"exchange_date",
		"user_id",
		"journal_type",
		"ap_id",
		"arap_payment_id",
		"ar_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_DATE,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG
	 }; 

	public DbJournal(){
	}

	public DbJournal(int i) throws CONException { 
		super(new DbJournal()); 
	}

	public DbJournal(String sOid) throws CONException { 
		super(new DbJournal(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbJournal(long lOid) throws CONException { 
		super(new DbJournal(0)); 
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
		return DB_JOURNAL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbJournal().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Journal journal = fetchExc(ent.getOID()); 
		ent = (Entity)journal; 
		return journal.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Journal) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Journal) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Journal fetchExc(long oid) throws CONException{ 
		try{ 
			Journal journal = new Journal();
			DbJournal pstJournal = new DbJournal(oid); 
			journal.setOID(oid);

			journal.setDate(pstJournal.getDate(CL_DATE));
			journal.setPicBy(pstJournal.getString(CL_PIC_BY));
			journal.setCurrency(pstJournal.getString(CL_CURRENCY));
			journal.setMemo(pstJournal.getString(CL_MEMO));
			journal.setPicFrom(pstJournal.getString(CL_PIC_FROM));
			journal.setUserById(pstJournal.getlong(CL_USER_BY_ID));
			journal.setUserFromId(pstJournal.getlong(CL_USER_FROM_ID));
			journal.setPeriodeId(pstJournal.getlong(CL_PERIODE_ID));
			journal.setStatus(pstJournal.getString(CL_STATUS));
			journal.setAmount(pstJournal.getdouble(CL_AMOUNT));
			journal.setReffNo(pstJournal.getString(CL_REFF_NO));
			journal.setVoucherNumber(pstJournal.getString(CL_VOUCHER_NUMBER));
			journal.setVoucherCounter(pstJournal.getInt(CL_VOUCHER_COUNTER));
			journal.setVoucherDate(pstJournal.getDate(CL_VOUCHER_DATE));
			journal.setExchangeRate(pstJournal.getdouble(CL_EXCHANGE_RATE));
			journal.setUserId(pstJournal.getlong(CL_USER_ID));
			journal.setJournalType(pstJournal.getString(CL_JOURNAL_TYPE));
			journal.setApId(pstJournal.getlong(CL_AP_ID));
			journal.setArapPaymentId(pstJournal.getlong(CL_ARAP_PAYMENT_ID));
			journal.setArId(pstJournal.getlong(CL_AR_ID));

			return journal; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbJournal(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Journal journal) throws CONException{ 
		try{ 
			DbJournal pstJournal = new DbJournal(0);

			pstJournal.setDate(CL_DATE, journal.getDate());
			pstJournal.setString(CL_PIC_BY, journal.getPicBy());
			pstJournal.setString(CL_CURRENCY, journal.getCurrency());
			pstJournal.setString(CL_MEMO, journal.getMemo());
			pstJournal.setString(CL_PIC_FROM, journal.getPicFrom());
			pstJournal.setLong(CL_USER_BY_ID, journal.getUserById());
			pstJournal.setLong(CL_USER_FROM_ID, journal.getUserFromId());
			pstJournal.setLong(CL_PERIODE_ID, journal.getPeriodeId());
			pstJournal.setString(CL_STATUS, journal.getStatus());
			pstJournal.setDouble(CL_AMOUNT, journal.getAmount());
			pstJournal.setString(CL_REFF_NO, journal.getReffNo());
			pstJournal.setString(CL_VOUCHER_NUMBER, journal.getVoucherNumber());
			pstJournal.setInt(CL_VOUCHER_COUNTER, journal.getVoucherCounter());
			pstJournal.setDate(CL_VOUCHER_DATE, journal.getVoucherDate());
			pstJournal.setDouble(CL_EXCHANGE_RATE, journal.getExchangeRate());
			pstJournal.setLong(CL_USER_ID, journal.getUserId());
			pstJournal.setString(CL_JOURNAL_TYPE, journal.getJournalType());
			pstJournal.setLong(CL_AP_ID, journal.getApId());
			pstJournal.setLong(CL_ARAP_PAYMENT_ID, journal.getArapPaymentId());
			pstJournal.setLong(CL_AR_ID, journal.getArId());

			pstJournal.insert(); 
			journal.setOID(pstJournal.getlong(CL_JOURNAL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbJournal(0),CONException.UNKNOWN); 
		}
		return journal.getOID();
	}

	public static long updateExc(Journal journal) throws CONException{ 
		try{ 
			if(journal.getOID() != 0){ 
				DbJournal pstJournal = new DbJournal(journal.getOID());

				pstJournal.setDate(CL_DATE, journal.getDate());
				pstJournal.setString(CL_PIC_BY, journal.getPicBy());
				pstJournal.setString(CL_CURRENCY, journal.getCurrency());
				pstJournal.setString(CL_MEMO, journal.getMemo());
				pstJournal.setString(CL_PIC_FROM, journal.getPicFrom());
				pstJournal.setLong(CL_USER_BY_ID, journal.getUserById());
				pstJournal.setLong(CL_USER_FROM_ID, journal.getUserFromId());
				pstJournal.setLong(CL_PERIODE_ID, journal.getPeriodeId());
				pstJournal.setString(CL_STATUS, journal.getStatus());
				pstJournal.setDouble(CL_AMOUNT, journal.getAmount());
				pstJournal.setString(CL_REFF_NO, journal.getReffNo());
				pstJournal.setString(CL_VOUCHER_NUMBER, journal.getVoucherNumber());
				pstJournal.setInt(CL_VOUCHER_COUNTER, journal.getVoucherCounter());
				pstJournal.setDate(CL_VOUCHER_DATE, journal.getVoucherDate());
				pstJournal.setDouble(CL_EXCHANGE_RATE, journal.getExchangeRate());
				pstJournal.setLong(CL_USER_ID, journal.getUserId());
				pstJournal.setString(CL_JOURNAL_TYPE, journal.getJournalType());
				pstJournal.setLong(CL_AP_ID, journal.getApId());
				pstJournal.setLong(CL_ARAP_PAYMENT_ID, journal.getArapPaymentId());
				pstJournal.setLong(CL_AR_ID, journal.getArId());

				pstJournal.update(); 
				return journal.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbJournal(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbJournal pstJournal = new DbJournal(oid);
			pstJournal.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbJournal(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_JOURNAL; 
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
				Journal journal = new Journal();
				resultToObject(rs, journal);
				lists.add(journal);
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

	private static void resultToObject(ResultSet rs, Journal journal){
		try{
			journal.setOID(rs.getLong(DbJournal.colNames[DbJournal.CL_JOURNAL_ID]));
			journal.setDate(rs.getDate(DbJournal.colNames[DbJournal.CL_DATE]));
			journal.setPicBy(rs.getString(DbJournal.colNames[DbJournal.CL_PIC_BY]));
			journal.setCurrency(rs.getString(DbJournal.colNames[DbJournal.CL_CURRENCY]));
			journal.setMemo(rs.getString(DbJournal.colNames[DbJournal.CL_MEMO]));
			journal.setPicFrom(rs.getString(DbJournal.colNames[DbJournal.CL_PIC_FROM]));
			journal.setUserById(rs.getLong(DbJournal.colNames[DbJournal.CL_USER_BY_ID]));
			journal.setUserFromId(rs.getLong(DbJournal.colNames[DbJournal.CL_USER_FROM_ID]));
			journal.setPeriodeId(rs.getLong(DbJournal.colNames[DbJournal.CL_PERIODE_ID]));
			journal.setStatus(rs.getString(DbJournal.colNames[DbJournal.CL_STATUS]));
			journal.setAmount(rs.getDouble(DbJournal.colNames[DbJournal.CL_AMOUNT]));
			journal.setReffNo(rs.getString(DbJournal.colNames[DbJournal.CL_REFF_NO]));
			journal.setVoucherNumber(rs.getString(DbJournal.colNames[DbJournal.CL_VOUCHER_NUMBER]));
			journal.setVoucherCounter(rs.getInt(DbJournal.colNames[DbJournal.CL_VOUCHER_COUNTER]));
			journal.setVoucherDate(rs.getDate(DbJournal.colNames[DbJournal.CL_VOUCHER_DATE]));
			journal.setExchangeRate(rs.getDouble(DbJournal.colNames[DbJournal.CL_EXCHANGE_RATE]));
			journal.setUserId(rs.getLong(DbJournal.colNames[DbJournal.CL_USER_ID]));
			journal.setJournalType(rs.getString(DbJournal.colNames[DbJournal.CL_JOURNAL_TYPE]));
			journal.setApId(rs.getLong(DbJournal.colNames[DbJournal.CL_AP_ID]));
			journal.setArapPaymentId(rs.getLong(DbJournal.colNames[DbJournal.CL_ARAP_PAYMENT_ID]));
			journal.setArId(rs.getLong(DbJournal.colNames[DbJournal.CL_AR_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long journalId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_JOURNAL + " WHERE " + 
						DbJournal.colNames[DbJournal.CL_JOURNAL_ID] + " = " + journalId;

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
			String sql = "SELECT COUNT("+ DbJournal.colNames[DbJournal.CL_JOURNAL_ID] + ") FROM " + DB_JOURNAL;
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
			  	   Journal journal = (Journal)list.get(ls);
				   if(oid == journal.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static int getNextVoucherCounter(Date dt){
               String sql = "select max("+colNames[CL_VOUCHER_COUNTER]+") from "+DB_JOURNAL+
                    " where "+colNames[CL_DATE]+ " between '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+
                    "' and '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"; 
               
               int count = 0;
               CONResultSet crs = null;
               try{
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();
                    while(rs.next()){
                        count = rs.getInt(1);
                    }
               }
               catch(Exception e){
                    System.out.println(e.toString());
               }
               finally{
                    CONResultSet.close(crs);
               }
               
               if(count==0){
                   count = 1;
               }
               else{
                   count = count + 1;
               }
               
               return count;
            
        }
        
        public static String getNextVoucherNumber(Date dt, int counter){
                String code = DbSystemProperty.getValueByName("SYSTEM_CODE");
                
                code = code +"-"+ JSPFormater.formatDate(dt, "yyMM");
                
                if(counter<10){
                    return code +"-000"+counter;
                }
                else if(counter<10){
                    return code +"-00"+counter;
                }
                else if(counter<100){
                    return code +"-0"+counter;
                }
                else{
                    return code +"-"+counter;
                }                
        }
        
     
        
}
