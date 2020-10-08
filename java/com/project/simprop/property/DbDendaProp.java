
package com.project.simprop.property;

import java.io.*;
import java.sql.*;
import java.util.*;

import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.*;
import com.project.general.*;
import com.project.util.*;
import com.project.system.*;


public class DbDendaProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_PROP_DENDA = "prop_denda";

	public static final  int COL_DENDA_ID = 0;
	public static final  int COL_SEWA_TANAH_ID = 1;
	public static final  int COL_LIMBAH_TRANSAKSI_ID = 2;
	public static final  int COL_IRIGASI_TRANSAKSI_ID = 3;
	public static final  int COL_TANGGAL = 4;
	public static final  int COL_ASSESMENT_ID = 5;
	public static final  int COL_CURRENCY_BIGINT = 6;
	public static final  int COL_JUMLAH = 7;
	public static final  int COL_STATUS = 8;
	public static final  int COL_CREATED_BY_ID = 9;
	public static final  int COL_CREATED_DATE = 10;
	public static final  int COL_POSTED_BY_ID = 11;
	public static final  int COL_POSTED_DATE = 12;
	public static final  int COL_COUNTER = 13;
	public static final  int COL_PREFIX_NUMBER = 14;
	public static final  int COL_NUMBER = 15;
	public static final  int COL_KETERANGAN = 16;
	public static final  int COL_NO_FP = 17;
	public static final  int COL_SEWA_TANAH_INVOICE_ID = 18;	
	public static final  int COL_INVESTOR_ID = 19;
	public static final  int COL_SARANA_ID = 20;
	public static final  int COL_TYPE = 21;

	public static final  String[] colNames = {			
		"denda_id",
		"sewa_tanah_id",
		"limbah_transaksi_id",
		"irigasi_transaksi_id",
		"tanggal",
		"assesment_id",
		"currency_id",
		"jumlah",
		"status",
		"created_by_id",
		"created_date",
		"posted_by_id",
		"posted_date",
		"counter",
		"prefix_number",
		"number",
		"keterangan",
		"no_fp",
		"sewa_tanah_invoice_id",		
		"investor_id",
		"sarana_id",
		"type"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_INT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		
		TYPE_LONG,
		TYPE_LONG,
		TYPE_INT
	 }; 

	public DbDendaProp(){
	}

	public DbDendaProp(int i) throws CONException { 
		super(new DbDendaProp()); 
	}

	public DbDendaProp(String sOid) throws CONException { 
		super(new DbDendaProp(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbDendaProp(long lOid) throws CONException { 
		super(new DbDendaProp(0)); 
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
		return DB_PROP_DENDA;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbDendaProp().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		DendaProp dendaProp = fetchExc(ent.getOID()); 
		ent = (Entity)dendaProp; 
		return dendaProp.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((DendaProp) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((DendaProp) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static DendaProp fetchExc(long oid) throws CONException{ 
		try{ 
			DendaProp dendaProp = new DendaProp();
			DbDendaProp pstDenda = new DbDendaProp(oid); 
			dendaProp.setOID(oid);
			dendaProp.setSewaTanahId(pstDenda.getlong(COL_SEWA_TANAH_ID));
			dendaProp.setLimbahTransaksiId(pstDenda.getlong(COL_LIMBAH_TRANSAKSI_ID));
			dendaProp.setIrigasiTransaksiId(pstDenda.getlong(COL_IRIGASI_TRANSAKSI_ID));
			dendaProp.setTanggal(pstDenda.getDate(COL_TANGGAL));
			dendaProp.setAssesmentId(pstDenda.getlong(COL_ASSESMENT_ID));
			dendaProp.setCurrencyId(pstDenda.getlong(COL_CURRENCY_BIGINT));
			dendaProp.setJumlah(pstDenda.getdouble(COL_JUMLAH));
			dendaProp.setStatus(pstDenda.getString(COL_STATUS));
			dendaProp.setCreatedById(pstDenda.getlong(COL_CREATED_BY_ID));
			dendaProp.setCreatedDate(pstDenda.getDate(COL_CREATED_DATE));
			dendaProp.setPostedById(pstDenda.getlong(COL_POSTED_BY_ID));
			dendaProp.setPostedDate(pstDenda.getDate(COL_POSTED_DATE));
			dendaProp.setCounter(pstDenda.getInt(COL_COUNTER));
			dendaProp.setPrefixNumber(pstDenda.getString(COL_PREFIX_NUMBER));
			dendaProp.setNumber(pstDenda.getString(COL_NUMBER));
			dendaProp.setKeterangan(pstDenda.getString(COL_KETERANGAN));
			dendaProp.setNoFp(pstDenda.getString(COL_NO_FP));
			dendaProp.setSewaTanahInvoiceId(pstDenda.getlong(COL_SEWA_TANAH_INVOICE_ID));
			
			dendaProp.setInvestorId(pstDenda.getlong(COL_INVESTOR_ID));
			dendaProp.setSaranaId(pstDenda.getlong(COL_SARANA_ID));
			dendaProp.setType(pstDenda.getInt(COL_TYPE));

			return dendaProp; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDendaProp(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(DendaProp dendaProp) throws CONException{ 
		try{ 
			DbDendaProp pstDenda = new DbDendaProp(0);

			pstDenda.setLong(COL_SEWA_TANAH_ID, dendaProp.getSewaTanahId());
			pstDenda.setLong(COL_LIMBAH_TRANSAKSI_ID, dendaProp.getLimbahTransaksiId());
			pstDenda.setLong(COL_IRIGASI_TRANSAKSI_ID, dendaProp.getIrigasiTransaksiId());
			pstDenda.setDate(COL_TANGGAL, dendaProp.getTanggal());
			pstDenda.setLong(COL_ASSESMENT_ID, dendaProp.getAssesmentId());
			pstDenda.setLong(COL_CURRENCY_BIGINT, dendaProp.getCurrencyId());
			pstDenda.setDouble(COL_JUMLAH, dendaProp.getJumlah());
			pstDenda.setString(COL_STATUS, dendaProp.getStatus());
			pstDenda.setLong(COL_CREATED_BY_ID, dendaProp.getCreatedById());
			pstDenda.setDate(COL_CREATED_DATE, dendaProp.getCreatedDate());
			pstDenda.setLong(COL_POSTED_BY_ID, dendaProp.getPostedById());
			pstDenda.setDate(COL_POSTED_DATE, dendaProp.getPostedDate());
			pstDenda.setInt(COL_COUNTER, dendaProp.getCounter());
			pstDenda.setString(COL_PREFIX_NUMBER, dendaProp.getPrefixNumber());
			pstDenda.setString(COL_NUMBER, dendaProp.getNumber());
			pstDenda.setString(COL_KETERANGAN, dendaProp.getKeterangan());
			pstDenda.setString(COL_NO_FP, dendaProp.getNoFp());
			pstDenda.setLong(COL_SEWA_TANAH_INVOICE_ID, dendaProp.getSewaTanahInvoiceId());
			
			pstDenda.setLong(COL_INVESTOR_ID, dendaProp.getInvestorId());
			pstDenda.setLong(COL_SARANA_ID, dendaProp.getSaranaId());
			pstDenda.setInt(COL_TYPE, dendaProp.getType());

			pstDenda.insert(); 
			dendaProp.setOID(pstDenda.getlong(COL_DENDA_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDendaProp(0),CONException.UNKNOWN); 
		}
		return dendaProp.getOID();
	}

	public static long updateExc(DendaProp dendaProp) throws CONException{ 
		try{ 
			if(dendaProp.getOID() != 0){ 
				DbDendaProp pstDenda = new DbDendaProp(dendaProp.getOID());

				pstDenda.setLong(COL_SEWA_TANAH_ID, dendaProp.getSewaTanahId());
				pstDenda.setLong(COL_LIMBAH_TRANSAKSI_ID, dendaProp.getLimbahTransaksiId());
				pstDenda.setLong(COL_IRIGASI_TRANSAKSI_ID, dendaProp.getIrigasiTransaksiId());
				pstDenda.setDate(COL_TANGGAL, dendaProp.getTanggal());
				pstDenda.setLong(COL_ASSESMENT_ID, dendaProp.getAssesmentId());
				pstDenda.setLong(COL_CURRENCY_BIGINT, dendaProp.getCurrencyId());
				pstDenda.setDouble(COL_JUMLAH, dendaProp.getJumlah());
				pstDenda.setString(COL_STATUS, dendaProp.getStatus());
				pstDenda.setLong(COL_CREATED_BY_ID, dendaProp.getCreatedById());
				pstDenda.setDate(COL_CREATED_DATE, dendaProp.getCreatedDate());
				pstDenda.setLong(COL_POSTED_BY_ID, dendaProp.getPostedById());
				pstDenda.setDate(COL_POSTED_DATE, dendaProp.getPostedDate());
				pstDenda.setInt(COL_COUNTER, dendaProp.getCounter());
				pstDenda.setString(COL_PREFIX_NUMBER, dendaProp.getPrefixNumber());
				pstDenda.setString(COL_NUMBER, dendaProp.getNumber());
				pstDenda.setString(COL_KETERANGAN, dendaProp.getKeterangan());
				pstDenda.setString(COL_NO_FP, dendaProp.getNoFp());
				pstDenda.setLong(COL_SEWA_TANAH_INVOICE_ID, dendaProp.getSewaTanahInvoiceId());
				
				pstDenda.setLong(COL_INVESTOR_ID, dendaProp.getInvestorId());
				pstDenda.setLong(COL_SARANA_ID, dendaProp.getSaranaId());
				pstDenda.setInt(COL_TYPE, dendaProp.getType());

				pstDenda.update(); 
				return dendaProp.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDendaProp(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbDendaProp pstDenda = new DbDendaProp(oid);
			pstDenda.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDendaProp(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PROP_DENDA; 
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
				DendaProp dendaProp = new DendaProp();
				resultToObject(rs, dendaProp);
				lists.add(dendaProp);
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

	private static void resultToObject(ResultSet rs, DendaProp dendaProp){
		try{
			dendaProp.setOID(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_DENDA_ID]));
			dendaProp.setSewaTanahId(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_SEWA_TANAH_ID]));
			dendaProp.setLimbahTransaksiId(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_LIMBAH_TRANSAKSI_ID]));
			dendaProp.setIrigasiTransaksiId(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_IRIGASI_TRANSAKSI_ID]));
			dendaProp.setTanggal(rs.getDate(DbDendaProp.colNames[DbDendaProp.COL_TANGGAL]));
			dendaProp.setAssesmentId(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_ASSESMENT_ID]));
			dendaProp.setCurrencyId(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_CURRENCY_BIGINT]));
			dendaProp.setJumlah(rs.getDouble(DbDendaProp.colNames[DbDendaProp.COL_JUMLAH]));
			dendaProp.setStatus(rs.getString(DbDendaProp.colNames[DbDendaProp.COL_STATUS]));
			dendaProp.setCreatedById(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_CREATED_BY_ID]));
			dendaProp.setCreatedDate(rs.getDate(DbDendaProp.colNames[DbDendaProp.COL_CREATED_DATE]));
			dendaProp.setPostedById(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_POSTED_BY_ID]));
			dendaProp.setPostedDate(rs.getDate(DbDendaProp.colNames[DbDendaProp.COL_POSTED_DATE]));
			dendaProp.setCounter(rs.getInt(DbDendaProp.colNames[DbDendaProp.COL_COUNTER]));
			dendaProp.setPrefixNumber(rs.getString(DbDendaProp.colNames[DbDendaProp.COL_PREFIX_NUMBER]));
			dendaProp.setNumber(rs.getString(DbDendaProp.colNames[DbDendaProp.COL_NUMBER]));
			dendaProp.setKeterangan(rs.getString(DbDendaProp.colNames[DbDendaProp.COL_KETERANGAN]));
			dendaProp.setNoFp(rs.getString(DbDendaProp.colNames[DbDendaProp.COL_NO_FP]));
			dendaProp.setSewaTanahInvoiceId(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_SEWA_TANAH_INVOICE_ID]));
			
			dendaProp.setInvestorId(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_INVESTOR_ID]));
			dendaProp.setSaranaId(rs.getLong(DbDendaProp.colNames[DbDendaProp.COL_SARANA_ID]));
			dendaProp.setType(rs.getInt(DbDendaProp.colNames[DbDendaProp.COL_TYPE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long dendaId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PROP_DENDA + " WHERE " + 
						DbDendaProp.colNames[DbDendaProp.COL_DENDA_ID] + " = " + dendaId;

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
			String sql = "SELECT COUNT("+ DbDendaProp.colNames[DbDendaProp.COL_DENDA_ID] + ") FROM " + DB_PROP_DENDA;
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
			  	   DendaProp dendaProp = (DendaProp)list.get(ls);
				   if(oid == dendaProp.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	

	
}
