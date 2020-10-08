
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

public class DbAp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_AP = "ap";

	public static final  int CL_AP_ID = 0;
	public static final  int CL_DATE = 1;
	public static final  int CL_DUE_DATE = 2;
	public static final  int CL_VENDOR_ID = 3;
	public static final  int CL_INVOICE_NUMBER = 4;
	public static final  int CL_NUMBER_COUNTER = 5;
	public static final  int CL_AMOUNT = 6;
	public static final  int CL_STATUS = 7;
	public static final  int CL_CURRENCY = 8;
	public static final  int CL_PERIODE_ID = 9;
	public static final  int CL_EXCHANGE_RATE = 10;
	public static final  int CL_VOUCHER_NUMBER = 11;
	public static final  int CL_VOUCHER_DATE = 12;
	public static final  int CL_VOUCHER_COUNTER = 13;
	public static final  int CL_USER_ID = 14;
	public static final  int CL_MEMO = 15;
	public static final  int CL_TOTAL_PAYMENT = 16;

	public static final  String[] colNames = {
		"ap_id",
		"date",
		"due_date",
		"vendor_id",
		"invoice_number",
		"number_counter",
		"amount",
		"status",
		"currency",
		"period_id",
		"exchange_rate",
		"voucher_number",
		"voucher_date",
		"voucher_counter",
		"user_id",
		"memo",
		"total_payment"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_INT,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_FLOAT
	 }; 

	public DbAp(){
	}

	public DbAp(int i) throws CONException { 
		super(new DbAp()); 
	}

	public DbAp(String sOid) throws CONException { 
		super(new DbAp(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbAp(long lOid) throws CONException { 
		super(new DbAp(0)); 
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
		return DB_AP;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbAp().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Ap ap = fetchExc(ent.getOID()); 
		ent = (Entity)ap; 
		return ap.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Ap) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Ap) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Ap fetchExc(long oid) throws CONException{ 
		try{ 
			Ap ap = new Ap();
			DbAp pstAp = new DbAp(oid); 
			ap.setOID(oid);

			ap.setDate(pstAp.getDate(CL_DATE));
			ap.setDueDate(pstAp.getDate(CL_DUE_DATE));
			ap.setVendorId(pstAp.getlong(CL_VENDOR_ID));
			ap.setInvoiceNumber(pstAp.getString(CL_INVOICE_NUMBER));
			ap.setNumberCounter(pstAp.getInt(CL_NUMBER_COUNTER));
			ap.setAmount(pstAp.getdouble(CL_AMOUNT));
			ap.setStatus(pstAp.getString(CL_STATUS));
			ap.setCurrency(pstAp.getString(CL_CURRENCY));
			ap.setPeriodeId(pstAp.getlong(CL_PERIODE_ID));
			ap.setExchangeRate(pstAp.getdouble(CL_EXCHANGE_RATE));
			ap.setVoucherNumber(pstAp.getString(CL_VOUCHER_NUMBER));
			ap.setVoucherDate(pstAp.getDate(CL_VOUCHER_DATE));
			ap.setVoucherCounter(pstAp.getInt(CL_VOUCHER_COUNTER));
			ap.setUserId(pstAp.getlong(CL_USER_ID));
			ap.setMemo(pstAp.getString(CL_MEMO));
			ap.setTotalPayment(pstAp.getdouble(CL_TOTAL_PAYMENT));

			return ap; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAp(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Ap ap) throws CONException{ 
		try{ 
			DbAp pstAp = new DbAp(0);

			pstAp.setDate(CL_DATE, ap.getDate());
			pstAp.setDate(CL_DUE_DATE, ap.getDueDate());
			pstAp.setLong(CL_VENDOR_ID, ap.getVendorId());
			pstAp.setString(CL_INVOICE_NUMBER, ap.getInvoiceNumber());
			pstAp.setInt(CL_NUMBER_COUNTER, ap.getNumberCounter());
			pstAp.setDouble(CL_AMOUNT, ap.getAmount());
			pstAp.setString(CL_STATUS, ap.getStatus());
			pstAp.setString(CL_CURRENCY, ap.getCurrency());
			pstAp.setLong(CL_PERIODE_ID, ap.getPeriodeId());
			pstAp.setDouble(CL_EXCHANGE_RATE, ap.getExchangeRate());
			pstAp.setString(CL_VOUCHER_NUMBER, ap.getVoucherNumber());
			pstAp.setDate(CL_VOUCHER_DATE, ap.getVoucherDate());
			pstAp.setInt(CL_VOUCHER_COUNTER, ap.getVoucherCounter());
			pstAp.setLong(CL_USER_ID, ap.getUserId());
			pstAp.setString(CL_MEMO, ap.getMemo());
			pstAp.setDouble(CL_TOTAL_PAYMENT, ap.getTotalPayment());

			pstAp.insert(); 
			ap.setOID(pstAp.getlong(CL_AP_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAp(0),CONException.UNKNOWN); 
		}
		return ap.getOID();
	}

	public static long updateExc(Ap ap) throws CONException{ 
		try{ 
			if(ap.getOID() != 0){ 
				DbAp pstAp = new DbAp(ap.getOID());

				pstAp.setDate(CL_DATE, ap.getDate());
				pstAp.setDate(CL_DUE_DATE, ap.getDueDate());
				pstAp.setLong(CL_VENDOR_ID, ap.getVendorId());
				pstAp.setString(CL_INVOICE_NUMBER, ap.getInvoiceNumber());
				pstAp.setInt(CL_NUMBER_COUNTER, ap.getNumberCounter());
				pstAp.setDouble(CL_AMOUNT, ap.getAmount());
				pstAp.setString(CL_STATUS, ap.getStatus());
				pstAp.setString(CL_CURRENCY, ap.getCurrency());
				pstAp.setLong(CL_PERIODE_ID, ap.getPeriodeId());
				pstAp.setDouble(CL_EXCHANGE_RATE, ap.getExchangeRate());
				pstAp.setString(CL_VOUCHER_NUMBER, ap.getVoucherNumber());
				pstAp.setDate(CL_VOUCHER_DATE, ap.getVoucherDate());
				pstAp.setInt(CL_VOUCHER_COUNTER, ap.getVoucherCounter());
				pstAp.setLong(CL_USER_ID, ap.getUserId());
				pstAp.setString(CL_MEMO, ap.getMemo());
				pstAp.setDouble(CL_TOTAL_PAYMENT, ap.getTotalPayment());

				pstAp.update(); 
				return ap.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAp(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbAp pstAp = new DbAp(oid);
			pstAp.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAp(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_AP; 
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
				Ap ap = new Ap();
				resultToObject(rs, ap);
				lists.add(ap);
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

	private static void resultToObject(ResultSet rs, Ap ap){
		try{
			ap.setOID(rs.getLong(DbAp.colNames[DbAp.CL_AP_ID]));
			ap.setDate(rs.getDate(DbAp.colNames[DbAp.CL_DATE]));
			ap.setDueDate(rs.getDate(DbAp.colNames[DbAp.CL_DUE_DATE]));
			ap.setVendorId(rs.getLong(DbAp.colNames[DbAp.CL_VENDOR_ID]));
			ap.setInvoiceNumber(rs.getString(DbAp.colNames[DbAp.CL_INVOICE_NUMBER]));
			ap.setNumberCounter(rs.getInt(DbAp.colNames[DbAp.CL_NUMBER_COUNTER]));
			ap.setAmount(rs.getDouble(DbAp.colNames[DbAp.CL_AMOUNT]));
			ap.setStatus(rs.getString(DbAp.colNames[DbAp.CL_STATUS]));
			ap.setCurrency(rs.getString(DbAp.colNames[DbAp.CL_CURRENCY]));
			ap.setPeriodeId(rs.getLong(DbAp.colNames[DbAp.CL_PERIODE_ID]));
			ap.setExchangeRate(rs.getDouble(DbAp.colNames[DbAp.CL_EXCHANGE_RATE]));
			ap.setVoucherNumber(rs.getString(DbAp.colNames[DbAp.CL_VOUCHER_NUMBER]));
			ap.setVoucherDate(rs.getDate(DbAp.colNames[DbAp.CL_VOUCHER_DATE]));
			ap.setVoucherCounter(rs.getInt(DbAp.colNames[DbAp.CL_VOUCHER_COUNTER]));
			ap.setUserId(rs.getLong(DbAp.colNames[DbAp.CL_USER_ID]));
			ap.setMemo(rs.getString(DbAp.colNames[DbAp.CL_MEMO]));
			ap.setTotalPayment(rs.getDouble(DbAp.colNames[DbAp.CL_TOTAL_PAYMENT]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long apId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_AP + " WHERE " + 
						DbAp.colNames[DbAp.CL_AP_ID] + " = " + apId;

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
			String sql = "SELECT COUNT("+ DbAp.colNames[DbAp.CL_AP_ID] + ") FROM " + DB_AP;
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
			  	   Ap ap = (Ap)list.get(ls);
				   if(oid == ap.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
      
        
}
