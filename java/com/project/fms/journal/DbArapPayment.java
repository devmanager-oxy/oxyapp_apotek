
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

public class DbArapPayment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_ARAP_PAYMENT = "arap_payment";

	public static final  int CL_ARAP_PAYMENT_ID = 0;
	public static final  int CL_AP_ID = 1;
	public static final  int CL_PERIODE_ID = 2;
	public static final  int CL_DATE = 3;
	public static final  int CL_PAID_BY = 4;
	public static final  int CL_REC_BY = 5;
	public static final  int CL_PAY_METHOD = 6;
	public static final  int CL_AMOUNT = 7;
	public static final  int CL_CURRENCY = 8;
	public static final  int CL_EXCHANGE_RATE = 9;
	public static final  int CL_VOUCHER_NUMBER = 10;
	public static final  int CL_VOUCHER_DATE = 11;
	public static final  int CL_VOUCHER_COUNTER = 12;
	public static final  int CL_STATUS = 13;
	public static final  int CL_USER_ID = 14;
	public static final  int CL_AR_ID = 15;
	public static final  int CL_MEMO = 16;

	public static final  String[] colNames = {
		"arap_payment_id",
		"ap_id",
		"period_id",
		"date",
		"paid_by",
		"rec_by",
		"pay_method",
		"amount",
		"currency",
		"exhange_rate",
		"voucher_number",
		"voucher_date",
		"voucher_counter",
		"status",
		"user_id",
		"ar_id",
		"memo"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_INT,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING
	 }; 

	public DbArapPayment(){
	}

	public DbArapPayment(int i) throws CONException { 
		super(new DbArapPayment()); 
	}

	public DbArapPayment(String sOid) throws CONException { 
		super(new DbArapPayment(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbArapPayment(long lOid) throws CONException { 
		super(new DbArapPayment(0)); 
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
		return DB_ARAP_PAYMENT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbArapPayment().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		ArapPayment arappayment = fetchExc(ent.getOID()); 
		ent = (Entity)arappayment; 
		return arappayment.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((ArapPayment) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((ArapPayment) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static ArapPayment fetchExc(long oid) throws CONException{ 
		try{ 
			ArapPayment arappayment = new ArapPayment();
			DbArapPayment pstArapPayment = new DbArapPayment(oid); 
			arappayment.setOID(oid);

			arappayment.setApId(pstArapPayment.getlong(CL_AP_ID));
			arappayment.setPeriodeId(pstArapPayment.getlong(CL_PERIODE_ID));
			arappayment.setDate(pstArapPayment.getDate(CL_DATE));
			arappayment.setPaidBy(pstArapPayment.getString(CL_PAID_BY));
			arappayment.setRecBy(pstArapPayment.getString(CL_REC_BY));
			arappayment.setPayMethod(pstArapPayment.getString(CL_PAY_METHOD));
			arappayment.setAmount(pstArapPayment.getdouble(CL_AMOUNT));
			arappayment.setCurrency(pstArapPayment.getString(CL_CURRENCY));
			arappayment.setExchangeRate(pstArapPayment.getdouble(CL_EXCHANGE_RATE));
			arappayment.setVoucherNumber(pstArapPayment.getString(CL_VOUCHER_NUMBER));
			arappayment.setVoucherDate(pstArapPayment.getDate(CL_VOUCHER_DATE));
			arappayment.setVoucherCounter(pstArapPayment.getInt(CL_VOUCHER_COUNTER));
			arappayment.setStatus(pstArapPayment.getString(CL_STATUS));
			arappayment.setUserId(pstArapPayment.getlong(CL_USER_ID));
			arappayment.setArId(pstArapPayment.getlong(CL_AR_ID));
			arappayment.setMemo(pstArapPayment.getString(CL_MEMO));

			return arappayment; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbArapPayment(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(ArapPayment arappayment) throws CONException{ 
		try{ 
			DbArapPayment pstArapPayment = new DbArapPayment(0);

			pstArapPayment.setLong(CL_AP_ID, arappayment.getApId());
			pstArapPayment.setLong(CL_PERIODE_ID, arappayment.getPeriodeId());
			pstArapPayment.setDate(CL_DATE, arappayment.getDate());
			pstArapPayment.setString(CL_PAID_BY, arappayment.getPaidBy());
			pstArapPayment.setString(CL_REC_BY, arappayment.getRecBy());
			pstArapPayment.setString(CL_PAY_METHOD, arappayment.getPayMethod());
			pstArapPayment.setDouble(CL_AMOUNT, arappayment.getAmount());
			pstArapPayment.setString(CL_CURRENCY, arappayment.getCurrency());
			pstArapPayment.setDouble(CL_EXCHANGE_RATE, arappayment.getExchangeRate());
			pstArapPayment.setString(CL_VOUCHER_NUMBER, arappayment.getVoucherNumber());
			pstArapPayment.setDate(CL_VOUCHER_DATE, arappayment.getVoucherDate());
			pstArapPayment.setInt(CL_VOUCHER_COUNTER, arappayment.getVoucherCounter());
			pstArapPayment.setString(CL_STATUS, arappayment.getStatus());
			pstArapPayment.setLong(CL_USER_ID, arappayment.getUserId());
			pstArapPayment.setLong(CL_AR_ID, arappayment.getArId());
			pstArapPayment.setString(CL_MEMO, arappayment.getMemo());

			pstArapPayment.insert(); 
			arappayment.setOID(pstArapPayment.getlong(CL_ARAP_PAYMENT_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbArapPayment(0),CONException.UNKNOWN); 
		}
		return arappayment.getOID();
	}

	public static long updateExc(ArapPayment arappayment) throws CONException{ 
		try{ 
			if(arappayment.getOID() != 0){ 
				DbArapPayment pstArapPayment = new DbArapPayment(arappayment.getOID());

				pstArapPayment.setLong(CL_AP_ID, arappayment.getApId());
				pstArapPayment.setLong(CL_PERIODE_ID, arappayment.getPeriodeId());
				pstArapPayment.setDate(CL_DATE, arappayment.getDate());
				pstArapPayment.setString(CL_PAID_BY, arappayment.getPaidBy());
				pstArapPayment.setString(CL_REC_BY, arappayment.getRecBy());
				pstArapPayment.setString(CL_PAY_METHOD, arappayment.getPayMethod());
				pstArapPayment.setDouble(CL_AMOUNT, arappayment.getAmount());
				pstArapPayment.setString(CL_CURRENCY, arappayment.getCurrency());
				pstArapPayment.setDouble(CL_EXCHANGE_RATE, arappayment.getExchangeRate());
				pstArapPayment.setString(CL_VOUCHER_NUMBER, arappayment.getVoucherNumber());
				pstArapPayment.setDate(CL_VOUCHER_DATE, arappayment.getVoucherDate());
				pstArapPayment.setInt(CL_VOUCHER_COUNTER, arappayment.getVoucherCounter());
				pstArapPayment.setString(CL_STATUS, arappayment.getStatus());
				pstArapPayment.setLong(CL_USER_ID, arappayment.getUserId());
				pstArapPayment.setLong(CL_AR_ID, arappayment.getArId());
				pstArapPayment.setString(CL_MEMO, arappayment.getMemo());

				pstArapPayment.update(); 
				return arappayment.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbArapPayment(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbArapPayment pstArapPayment = new DbArapPayment(oid);
			pstArapPayment.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbArapPayment(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_ARAP_PAYMENT; 
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
				ArapPayment arappayment = new ArapPayment();
				resultToObject(rs, arappayment);
				lists.add(arappayment);
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

	private static void resultToObject(ResultSet rs, ArapPayment arappayment){
		try{
			arappayment.setOID(rs.getLong(DbArapPayment.colNames[DbArapPayment.CL_ARAP_PAYMENT_ID]));
			arappayment.setApId(rs.getLong(DbArapPayment.colNames[DbArapPayment.CL_AP_ID]));
			arappayment.setPeriodeId(rs.getLong(DbArapPayment.colNames[DbArapPayment.CL_PERIODE_ID]));
			arappayment.setDate(rs.getDate(DbArapPayment.colNames[DbArapPayment.CL_DATE]));
			arappayment.setPaidBy(rs.getString(DbArapPayment.colNames[DbArapPayment.CL_PAID_BY]));
			arappayment.setRecBy(rs.getString(DbArapPayment.colNames[DbArapPayment.CL_REC_BY]));
			arappayment.setPayMethod(rs.getString(DbArapPayment.colNames[DbArapPayment.CL_PAY_METHOD]));
			arappayment.setAmount(rs.getDouble(DbArapPayment.colNames[DbArapPayment.CL_AMOUNT]));
			arappayment.setCurrency(rs.getString(DbArapPayment.colNames[DbArapPayment.CL_CURRENCY]));
			arappayment.setExchangeRate(rs.getDouble(DbArapPayment.colNames[DbArapPayment.CL_EXCHANGE_RATE]));
			arappayment.setVoucherNumber(rs.getString(DbArapPayment.colNames[DbArapPayment.CL_VOUCHER_NUMBER]));
			arappayment.setVoucherDate(rs.getDate(DbArapPayment.colNames[DbArapPayment.CL_VOUCHER_DATE]));
			arappayment.setVoucherCounter(rs.getInt(DbArapPayment.colNames[DbArapPayment.CL_VOUCHER_COUNTER]));
			arappayment.setStatus(rs.getString(DbArapPayment.colNames[DbArapPayment.CL_STATUS]));
			arappayment.setUserId(rs.getLong(DbArapPayment.colNames[DbArapPayment.CL_USER_ID]));
			arappayment.setArId(rs.getLong(DbArapPayment.colNames[DbArapPayment.CL_AR_ID]));
			arappayment.setMemo(rs.getString(DbArapPayment.colNames[DbArapPayment.CL_MEMO]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long arapPaymentId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_ARAP_PAYMENT + " WHERE " + 
						DbArapPayment.colNames[DbArapPayment.CL_ARAP_PAYMENT_ID] + " = " + arapPaymentId;

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
			String sql = "SELECT COUNT("+ DbArapPayment.colNames[DbArapPayment.CL_ARAP_PAYMENT_ID] + ") FROM " + DB_ARAP_PAYMENT;
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
			  	   ArapPayment arappayment = (ArapPayment)list.get(ls);
				   if(oid == arappayment.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
