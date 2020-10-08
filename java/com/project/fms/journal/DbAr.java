
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

public class DbAr extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_AR = "ar";

	public static final  int CL_AR_ID = 0;
	public static final  int CL_DATE = 1;
	public static final  int CL_DUE_DATE = 2;
	public static final  int CL_INVOICE_NUMBER = 3;
	public static final  int CL_NUMBER_COUNTER = 4;
	public static final  int CL_AMOUNT = 5;
	public static final  int CL_STATUS = 6;
	public static final  int CL_PO_NUMBER = 7;
	public static final  int CL_CURRENCY = 8;
	public static final  int CL_PERIODE_ID = 9;
	public static final  int CL_EXCHANGE_RATE = 10;
	public static final  int CL_VOUCHER_NUMBER = 11;
	public static final  int CL_VOUCHER_DATE = 12;
	public static final  int CL_VOUCHER_COUNTER = 13;
	public static final  int CL_USER_ID = 14;
	public static final  int CL_CUSTOMER_ID = 15;
	public static final  int CL_MEMO = 16;
	public static final  int CL_TOTAL_PAYMENT = 17;

	public static final  String[] colNames = {
		"ar_id",
		"date",
		"due_date",
		"invoice_number",
		"number_counter",
		"amount",
		"status",
		"po_number",
		"currency",
		"period_id",
		"exchange_rate",
		"voucher_number",
		"voucher_date",
		"voucher_counter",
		"user_id",
		"customer",
		"memo",
		"total_payment"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_FLOAT
	 }; 

	public DbAr(){
	}

	public DbAr(int i) throws CONException { 
		super(new DbAr()); 
	}

	public DbAr(String sOid) throws CONException { 
		super(new DbAr(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbAr(long lOid) throws CONException { 
		super(new DbAr(0)); 
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
		return DB_AR;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbAr().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Ar ar = fetchExc(ent.getOID()); 
		ent = (Entity)ar; 
		return ar.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Ar) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Ar) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Ar fetchExc(long oid) throws CONException{ 
		try{ 
			Ar ar = new Ar();
			DbAr pstAr = new DbAr(oid); 
			ar.setOID(oid);

			ar.setDate(pstAr.getDate(CL_DATE));
			ar.setDueDate(pstAr.getDate(CL_DUE_DATE));
			ar.setInvoiceNumber(pstAr.getString(CL_INVOICE_NUMBER));
			ar.setNumberCounter(pstAr.getInt(CL_NUMBER_COUNTER));
			ar.setAmount(pstAr.getdouble(CL_AMOUNT));
			ar.setStatus(pstAr.getString(CL_STATUS));
			ar.setPoNumber(pstAr.getString(CL_PO_NUMBER));
			ar.setCurrency(pstAr.getString(CL_CURRENCY));
			ar.setPeriodeId(pstAr.getlong(CL_PERIODE_ID));
			ar.setExchangeRate(pstAr.getdouble(CL_EXCHANGE_RATE));
			ar.setVoucherNumber(pstAr.getString(CL_VOUCHER_NUMBER));
			ar.setVoucherDate(pstAr.getDate(CL_VOUCHER_DATE));
			ar.setVoucherCounter(pstAr.getInt(CL_VOUCHER_COUNTER));
			ar.setUserId(pstAr.getlong(CL_USER_ID));
			ar.setCustomerId(pstAr.getlong(CL_CUSTOMER_ID));
			ar.setMemo(pstAr.getString(CL_MEMO));
			ar.setTotalPayment(pstAr.getdouble(CL_TOTAL_PAYMENT));

			return ar; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAr(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Ar ar) throws CONException{ 
		try{ 
			DbAr pstAr = new DbAr(0);

			pstAr.setDate(CL_DATE, ar.getDate());
			pstAr.setDate(CL_DUE_DATE, ar.getDueDate());
			pstAr.setString(CL_INVOICE_NUMBER, ar.getInvoiceNumber());
			pstAr.setInt(CL_NUMBER_COUNTER, ar.getNumberCounter());
			pstAr.setDouble(CL_AMOUNT, ar.getAmount());
			pstAr.setString(CL_STATUS, ar.getStatus());
			pstAr.setString(CL_PO_NUMBER, ar.getPoNumber());
			pstAr.setString(CL_CURRENCY, ar.getCurrency());
			pstAr.setLong(CL_PERIODE_ID, ar.getPeriodeId());
			pstAr.setDouble(CL_EXCHANGE_RATE, ar.getExchangeRate());
			pstAr.setString(CL_VOUCHER_NUMBER, ar.getVoucherNumber());
			pstAr.setDate(CL_VOUCHER_DATE, ar.getVoucherDate());
			pstAr.setInt(CL_VOUCHER_COUNTER, ar.getVoucherCounter());
			pstAr.setLong(CL_USER_ID, ar.getUserId());
			pstAr.setLong(CL_CUSTOMER_ID, ar.getCustomerId());
			pstAr.setString(CL_MEMO, ar.getMemo());
			pstAr.setDouble(CL_TOTAL_PAYMENT, ar.getTotalPayment());

			pstAr.insert(); 
			ar.setOID(pstAr.getlong(CL_AR_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAr(0),CONException.UNKNOWN); 
		}
		return ar.getOID();
	}

	public static long updateExc(Ar ar) throws CONException{ 
		try{ 
			if(ar.getOID() != 0){ 
				DbAr pstAr = new DbAr(ar.getOID());

				pstAr.setDate(CL_DATE, ar.getDate());
				pstAr.setDate(CL_DUE_DATE, ar.getDueDate());
				pstAr.setString(CL_INVOICE_NUMBER, ar.getInvoiceNumber());
				pstAr.setInt(CL_NUMBER_COUNTER, ar.getNumberCounter());
				pstAr.setDouble(CL_AMOUNT, ar.getAmount());
				pstAr.setString(CL_STATUS, ar.getStatus());
				pstAr.setString(CL_PO_NUMBER, ar.getPoNumber());
				pstAr.setString(CL_CURRENCY, ar.getCurrency());
				pstAr.setLong(CL_PERIODE_ID, ar.getPeriodeId());
				pstAr.setDouble(CL_EXCHANGE_RATE, ar.getExchangeRate());
				pstAr.setString(CL_VOUCHER_NUMBER, ar.getVoucherNumber());
				pstAr.setDate(CL_VOUCHER_DATE, ar.getVoucherDate());
				pstAr.setInt(CL_VOUCHER_COUNTER, ar.getVoucherCounter());
				pstAr.setLong(CL_USER_ID, ar.getUserId());
				pstAr.setLong(CL_CUSTOMER_ID, ar.getCustomerId());
				pstAr.setString(CL_MEMO, ar.getMemo());
				pstAr.setDouble(CL_TOTAL_PAYMENT, ar.getTotalPayment());

				pstAr.update(); 
				return ar.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAr(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbAr pstAr = new DbAr(oid);
			pstAr.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAr(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_AR; 
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
				Ar ar = new Ar();
				resultToObject(rs, ar);
				lists.add(ar);
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

	private static void resultToObject(ResultSet rs, Ar ar){
		try{
			ar.setOID(rs.getLong(DbAr.colNames[DbAr.CL_AR_ID]));
			ar.setDate(rs.getDate(DbAr.colNames[DbAr.CL_DATE]));
			ar.setDueDate(rs.getDate(DbAr.colNames[DbAr.CL_DUE_DATE]));
			ar.setInvoiceNumber(rs.getString(DbAr.colNames[DbAr.CL_INVOICE_NUMBER]));
			ar.setNumberCounter(rs.getInt(DbAr.colNames[DbAr.CL_NUMBER_COUNTER]));
			ar.setAmount(rs.getDouble(DbAr.colNames[DbAr.CL_AMOUNT]));
			ar.setStatus(rs.getString(DbAr.colNames[DbAr.CL_STATUS]));
			ar.setPoNumber(rs.getString(DbAr.colNames[DbAr.CL_PO_NUMBER]));
			ar.setCurrency(rs.getString(DbAr.colNames[DbAr.CL_CURRENCY]));
			ar.setPeriodeId(rs.getLong(DbAr.colNames[DbAr.CL_PERIODE_ID]));
			ar.setExchangeRate(rs.getDouble(DbAr.colNames[DbAr.CL_EXCHANGE_RATE]));
			ar.setVoucherNumber(rs.getString(DbAr.colNames[DbAr.CL_VOUCHER_NUMBER]));
			ar.setVoucherDate(rs.getDate(DbAr.colNames[DbAr.CL_VOUCHER_DATE]));
			ar.setVoucherCounter(rs.getInt(DbAr.colNames[DbAr.CL_VOUCHER_COUNTER]));
			ar.setUserId(rs.getLong(DbAr.colNames[DbAr.CL_USER_ID]));
			ar.setCustomerId(rs.getLong(DbAr.colNames[DbAr.CL_CUSTOMER_ID]));
			ar.setMemo(rs.getString(DbAr.colNames[DbAr.CL_MEMO]));
			ar.setTotalPayment(rs.getDouble(DbAr.colNames[DbAr.CL_TOTAL_PAYMENT]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long arId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_AR + " WHERE " + 
						DbAr.colNames[DbAr.CL_AR_ID] + " = " + arId;

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
			String sql = "SELECT COUNT("+ DbAr.colNames[DbAr.CL_AR_ID] + ") FROM " + DB_AR;
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
			  	   Ar ar = (Ar)list.get(ls);
				   if(oid == ar.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
