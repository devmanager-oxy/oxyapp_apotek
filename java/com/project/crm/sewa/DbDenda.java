
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */

package com.project.crm.sewa; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.AccLink;
import com.project.fms.master.DbAccLink;
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.util.*;
import com.project.crm.transaction.*;
import com.project.system.*;
import com.project.general.Currency;
import com.project.general.DbCurrency;

public class DbDenda extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CRM_DENDA = "crm_denda";

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

	public DbDenda(){
	}

	public DbDenda(int i) throws CONException { 
		super(new DbDenda()); 
	}

	public DbDenda(String sOid) throws CONException { 
		super(new DbDenda(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbDenda(long lOid) throws CONException { 
		super(new DbDenda(0)); 
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
		return DB_CRM_DENDA;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbDenda().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Denda crmdenda = fetchExc(ent.getOID()); 
		ent = (Entity)crmdenda; 
		return crmdenda.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Denda) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Denda) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Denda fetchExc(long oid) throws CONException{ 
		try{ 
			Denda crmdenda = new Denda();
			DbDenda pstDenda = new DbDenda(oid); 
			crmdenda.setOID(oid);

			crmdenda.setSewaTanahId(pstDenda.getlong(COL_SEWA_TANAH_ID));
			crmdenda.setLimbahTransaksiId(pstDenda.getlong(COL_LIMBAH_TRANSAKSI_ID));
			crmdenda.setIrigasiTransaksiId(pstDenda.getlong(COL_IRIGASI_TRANSAKSI_ID));
			crmdenda.setTanggal(pstDenda.getDate(COL_TANGGAL));
			crmdenda.setAssesmentId(pstDenda.getlong(COL_ASSESMENT_ID));
			crmdenda.setCurrencyId(pstDenda.getlong(COL_CURRENCY_BIGINT));
			crmdenda.setJumlah(pstDenda.getdouble(COL_JUMLAH));
			crmdenda.setStatus(pstDenda.getString(COL_STATUS));
			crmdenda.setCreatedById(pstDenda.getlong(COL_CREATED_BY_ID));
			crmdenda.setCreatedDate(pstDenda.getDate(COL_CREATED_DATE));
			crmdenda.setPostedById(pstDenda.getlong(COL_POSTED_BY_ID));
			crmdenda.setPostedDate(pstDenda.getDate(COL_POSTED_DATE));
			crmdenda.setCounter(pstDenda.getInt(COL_COUNTER));
			crmdenda.setPrefixNumber(pstDenda.getString(COL_PREFIX_NUMBER));
			crmdenda.setNumber(pstDenda.getString(COL_NUMBER));
			crmdenda.setKeterangan(pstDenda.getString(COL_KETERANGAN));
			crmdenda.setNoFp(pstDenda.getString(COL_NO_FP));
			crmdenda.setSewaTanahInvoiceId(pstDenda.getlong(COL_SEWA_TANAH_INVOICE_ID));
			
			crmdenda.setInvestorId(pstDenda.getlong(COL_INVESTOR_ID));
			crmdenda.setSaranaId(pstDenda.getlong(COL_SARANA_ID));
			crmdenda.setType(pstDenda.getInt(COL_TYPE));

			return crmdenda; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDenda(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Denda crmdenda) throws CONException{ 
		try{ 
			DbDenda pstDenda = new DbDenda(0);

			pstDenda.setLong(COL_SEWA_TANAH_ID, crmdenda.getSewaTanahId());
			pstDenda.setLong(COL_LIMBAH_TRANSAKSI_ID, crmdenda.getLimbahTransaksiId());
			pstDenda.setLong(COL_IRIGASI_TRANSAKSI_ID, crmdenda.getIrigasiTransaksiId());
			pstDenda.setDate(COL_TANGGAL, crmdenda.getTanggal());
			pstDenda.setLong(COL_ASSESMENT_ID, crmdenda.getAssesmentId());
			pstDenda.setLong(COL_CURRENCY_BIGINT, crmdenda.getCurrencyId());
			pstDenda.setDouble(COL_JUMLAH, crmdenda.getJumlah());
			pstDenda.setString(COL_STATUS, crmdenda.getStatus());
			pstDenda.setLong(COL_CREATED_BY_ID, crmdenda.getCreatedById());
			pstDenda.setDate(COL_CREATED_DATE, crmdenda.getCreatedDate());
			pstDenda.setLong(COL_POSTED_BY_ID, crmdenda.getPostedById());
			pstDenda.setDate(COL_POSTED_DATE, crmdenda.getPostedDate());
			pstDenda.setInt(COL_COUNTER, crmdenda.getCounter());
			pstDenda.setString(COL_PREFIX_NUMBER, crmdenda.getPrefixNumber());
			pstDenda.setString(COL_NUMBER, crmdenda.getNumber());
			pstDenda.setString(COL_KETERANGAN, crmdenda.getKeterangan());
			pstDenda.setString(COL_NO_FP, crmdenda.getNoFp());
			pstDenda.setLong(COL_SEWA_TANAH_INVOICE_ID, crmdenda.getSewaTanahInvoiceId());
			
			pstDenda.setLong(COL_INVESTOR_ID, crmdenda.getInvestorId());
			pstDenda.setLong(COL_SARANA_ID, crmdenda.getSaranaId());
			pstDenda.setInt(COL_TYPE, crmdenda.getType());

			pstDenda.insert(); 
			crmdenda.setOID(pstDenda.getlong(COL_DENDA_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDenda(0),CONException.UNKNOWN); 
		}
		return crmdenda.getOID();
	}

	public static long updateExc(Denda crmdenda) throws CONException{ 
		try{ 
			if(crmdenda.getOID() != 0){ 
				DbDenda pstDenda = new DbDenda(crmdenda.getOID());

				pstDenda.setLong(COL_SEWA_TANAH_ID, crmdenda.getSewaTanahId());
				pstDenda.setLong(COL_LIMBAH_TRANSAKSI_ID, crmdenda.getLimbahTransaksiId());
				pstDenda.setLong(COL_IRIGASI_TRANSAKSI_ID, crmdenda.getIrigasiTransaksiId());
				pstDenda.setDate(COL_TANGGAL, crmdenda.getTanggal());
				pstDenda.setLong(COL_ASSESMENT_ID, crmdenda.getAssesmentId());
				pstDenda.setLong(COL_CURRENCY_BIGINT, crmdenda.getCurrencyId());
				pstDenda.setDouble(COL_JUMLAH, crmdenda.getJumlah());
				pstDenda.setString(COL_STATUS, crmdenda.getStatus());
				pstDenda.setLong(COL_CREATED_BY_ID, crmdenda.getCreatedById());
				pstDenda.setDate(COL_CREATED_DATE, crmdenda.getCreatedDate());
				pstDenda.setLong(COL_POSTED_BY_ID, crmdenda.getPostedById());
				pstDenda.setDate(COL_POSTED_DATE, crmdenda.getPostedDate());
				pstDenda.setInt(COL_COUNTER, crmdenda.getCounter());
				pstDenda.setString(COL_PREFIX_NUMBER, crmdenda.getPrefixNumber());
				pstDenda.setString(COL_NUMBER, crmdenda.getNumber());
				pstDenda.setString(COL_KETERANGAN, crmdenda.getKeterangan());
				pstDenda.setString(COL_NO_FP, crmdenda.getNoFp());
				pstDenda.setLong(COL_SEWA_TANAH_INVOICE_ID, crmdenda.getSewaTanahInvoiceId());
				
				pstDenda.setLong(COL_INVESTOR_ID, crmdenda.getInvestorId());
				pstDenda.setLong(COL_SARANA_ID, crmdenda.getSaranaId());
				pstDenda.setInt(COL_TYPE, crmdenda.getType());

				pstDenda.update(); 
				return crmdenda.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDenda(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbDenda pstDenda = new DbDenda(oid);
			pstDenda.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDenda(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CRM_DENDA; 
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
				Denda crmdenda = new Denda();
				resultToObject(rs, crmdenda);
				lists.add(crmdenda);
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

	private static void resultToObject(ResultSet rs, Denda crmdenda){
		try{
			crmdenda.setOID(rs.getLong(DbDenda.colNames[DbDenda.COL_DENDA_ID]));
			crmdenda.setSewaTanahId(rs.getLong(DbDenda.colNames[DbDenda.COL_SEWA_TANAH_ID]));
			crmdenda.setLimbahTransaksiId(rs.getLong(DbDenda.colNames[DbDenda.COL_LIMBAH_TRANSAKSI_ID]));
			crmdenda.setIrigasiTransaksiId(rs.getLong(DbDenda.colNames[DbDenda.COL_IRIGASI_TRANSAKSI_ID]));
			crmdenda.setTanggal(rs.getDate(DbDenda.colNames[DbDenda.COL_TANGGAL]));
			crmdenda.setAssesmentId(rs.getLong(DbDenda.colNames[DbDenda.COL_ASSESMENT_ID]));
			crmdenda.setCurrencyId(rs.getLong(DbDenda.colNames[DbDenda.COL_CURRENCY_BIGINT]));
			crmdenda.setJumlah(rs.getDouble(DbDenda.colNames[DbDenda.COL_JUMLAH]));
			crmdenda.setStatus(rs.getString(DbDenda.colNames[DbDenda.COL_STATUS]));
			crmdenda.setCreatedById(rs.getLong(DbDenda.colNames[DbDenda.COL_CREATED_BY_ID]));
			crmdenda.setCreatedDate(rs.getDate(DbDenda.colNames[DbDenda.COL_CREATED_DATE]));
			crmdenda.setPostedById(rs.getLong(DbDenda.colNames[DbDenda.COL_POSTED_BY_ID]));
			crmdenda.setPostedDate(rs.getDate(DbDenda.colNames[DbDenda.COL_POSTED_DATE]));
			crmdenda.setCounter(rs.getInt(DbDenda.colNames[DbDenda.COL_COUNTER]));
			crmdenda.setPrefixNumber(rs.getString(DbDenda.colNames[DbDenda.COL_PREFIX_NUMBER]));
			crmdenda.setNumber(rs.getString(DbDenda.colNames[DbDenda.COL_NUMBER]));
			crmdenda.setKeterangan(rs.getString(DbDenda.colNames[DbDenda.COL_KETERANGAN]));
			crmdenda.setNoFp(rs.getString(DbDenda.colNames[DbDenda.COL_NO_FP]));
			crmdenda.setSewaTanahInvoiceId(rs.getLong(DbDenda.colNames[DbDenda.COL_SEWA_TANAH_INVOICE_ID]));
			
			crmdenda.setInvestorId(rs.getLong(DbDenda.colNames[DbDenda.COL_INVESTOR_ID]));
			crmdenda.setSaranaId(rs.getLong(DbDenda.colNames[DbDenda.COL_SARANA_ID]));
			crmdenda.setType(rs.getInt(DbDenda.colNames[DbDenda.COL_TYPE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long dendaId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CRM_DENDA + " WHERE " + 
						DbDenda.colNames[DbDenda.COL_DENDA_ID] + " = " + dendaId;

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
			String sql = "SELECT COUNT("+ DbDenda.colNames[DbDenda.COL_DENDA_ID] + ") FROM " + DB_CRM_DENDA;
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
			  	   Denda crmdenda = (Denda)list.get(ls);
				   if(oid == crmdenda.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
	public static void hitungDendaHarian(Date dt){
		//Sementara denda hanya berlaku untuk Komin, Komper dan Assesment
		//hitungDendaHarianLimbah(dt);
		//hitungDendaHarianIrigasi(dt);
		hitungDendaHarianKomin(dt);
		hitungDendaHarianKomper(dt);
		hitungDendaHarianAssesment(dt);
		
	}
	
	//hitung denda komin
	public static void hitungDendaHarianKomin(Date dt){
		
		System.out.println("\n** start to calculate denda komin **");
		
		String where = DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JATUH_TEMPO]+"< '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"+
			" and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+"<>"+DbPembayaran.STATUS_BAYAR_LUNAS+
			" and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TYPE]+"="+DbSewaTanahInvoice.TYPE_INV_KOMIN;
			
		System.out.println("	where : "+where);	
		
		Vector temp = DbSewaTanahInvoice.list(0,0, where, "");
		
		if(temp!=null && temp.size()>0){
			for(int i=0; i<temp.size(); i++){
				
				SewaTanahInvoice lt = (SewaTanahInvoice)temp.get(i);
				
				double total = lt.getJumlah() + lt.getPpn() + lt.getPph();
				double payment = DbPembayaran.getTotPembayaran(0, DbPembayaran.PAYMENT_SOURCE_KOMIN, lt.getOID(), lt.getCurrencyId());
				double balance = total - payment;
				//proses denda
				if(balance > 0){
					
					int  jmlHariTahun = Integer.parseInt(DbSystemProperty.getValueByName("JML_HARI_DALAM_SETAHUN"));
					
					double dendaVal = (balance * 0.1)/jmlHariTahun;
						
					Denda denda = getDenda(lt.getOID(), DbPembayaran.PAYMENT_SOURCE_KOMIN, dt);
					if(denda.getOID()!=0){
						if(denda.getJumlah()!=dendaVal){
                                                    
							lt.setTotalDenda(lt.getTotalDenda()-denda.getJumlah()+dendaVal);
                                                        lt.setDendaDiakui(lt.getDendaDiakui()-denda.getJumlah()+dendaVal);
							denda.setJumlah(dendaVal);
							try{
								long oidx = DbDenda.updateExc(denda);
								if(oidx!=0){
									DbSewaTanahInvoice.updateExc(lt);
								}
							}
							catch(Exception e){}
						}
					}else{
						try{
							
							lt.setTotalDenda(lt.getTotalDenda()+dendaVal);
                                                        lt.setDendaDiakui(lt.getDendaDiakui()+dendaVal);
							
							Customer c = DbCustomer.fetchExc(lt.getSaranaId());						
							
							denda.setInvestorId(lt.getInvestorId());
							denda.setSaranaId(lt.getSaranaId());
							denda.setType(DbPembayaran.PAYMENT_SOURCE_KOMIN);
							denda.setSewaTanahInvoiceId(lt.getOID());
							denda.setTanggal(dt);
							denda.setStatus("Draft");
							denda.setCurrencyId(lt.getCurrencyId());
							
							Currency curr = DbCurrency.fetchExc(denda.getCurrencyId());
							denda.setJumlah(dendaVal);
							
							denda.setKeterangan(c.getName()+" : denda tagihan kompensasi minimum, tanggal"+JSPFormater.formatDate(dt, "dd/MM/yyyy")+", sisa tagihan "+curr.getCurrencyCode()+" "+JSPFormater.formatNumber(balance, "#,###.##"));
							
							
							long oidx = DbDenda.insertExc(denda);
							
							if(oidx!=0){
								DbSewaTanahInvoice.updateExc(lt);
							}
						}
						catch(Exception e){
						
						}
					}
				}				
			}
		}
		
				
	}
	
	//hitung denda assesment
	public static void hitungDendaHarianAssesment(Date dt){
		
		System.out.println("\n** start to calculate denda assesment **");
		
		String where = DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JATUH_TEMPO]+"< '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"+
			" and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]+"<>"+DbPembayaran.STATUS_BAYAR_LUNAS+
			" and "+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TYPE]+"="+DbSewaTanahInvoice.TYPE_INV_ASSESMENT;
			
		System.out.println("	where : "+where);	
		
		Vector temp = DbSewaTanahInvoice.list(0,0, where, "");
		
		if(temp!=null && temp.size()>0){
			for(int i=0; i<temp.size(); i++){
				
				SewaTanahInvoice lt = (SewaTanahInvoice)temp.get(i);
				
				double total = lt.getJumlah() + lt.getPpn() + lt.getPph();
				double payment = DbPembayaran.getTotPembayaran(0, DbPembayaran.PAYMENT_SOURCE_ASSESMENT, lt.getOID(), lt.getCurrencyId());
				double balance = total - payment;
				//proses denda
				if(balance > 0){
					
					int  jmlHariTahun = Integer.parseInt(DbSystemProperty.getValueByName("JML_HARI_DALAM_SETAHUN"));
					
					double dendaVal = (balance * 0.1)/jmlHariTahun;
						
					Denda denda = getDenda(lt.getOID(), DbPembayaran.PAYMENT_SOURCE_ASSESMENT, dt);
					if(denda.getOID()!=0){
						if(denda.getJumlah()!=dendaVal){
							lt.setTotalDenda(lt.getTotalDenda()-denda.getJumlah()+dendaVal);
                                                        lt.setDendaDiakui(lt.getDendaDiakui()-denda.getJumlah()+dendaVal);
							denda.setJumlah(dendaVal);
							try{
								long oidx = DbDenda.updateExc(denda);
								if(oidx!=0){
									DbSewaTanahInvoice.updateExc(lt);
								}
							}
							catch(Exception e){
							
							}
						}
					}
					else{
						try{
							
							lt.setTotalDenda(lt.getTotalDenda()+dendaVal);
                                                        lt.setDendaDiakui(lt.getDendaDiakui()+dendaVal);
							
							Customer c = DbCustomer.fetchExc(lt.getSaranaId());						
							
							denda.setInvestorId(lt.getInvestorId());
							denda.setSaranaId(lt.getSaranaId());
							denda.setType(DbPembayaran.PAYMENT_SOURCE_ASSESMENT);
							denda.setSewaTanahInvoiceId(lt.getOID());
							denda.setTanggal(dt);
							denda.setStatus("Draft");
							denda.setCurrencyId(lt.getCurrencyId());
							
							Currency curr = DbCurrency.fetchExc(denda.getCurrencyId());
							denda.setJumlah(dendaVal);
							
							denda.setKeterangan(c.getName()+" : denda tagihan assesment, tanggal"+JSPFormater.formatDate(dt, "dd/MM/yyyy")+", sisa tagihan "+curr.getCurrencyCode()+" "+JSPFormater.formatNumber(balance, "#,###.##"));
							
							long oidx = DbDenda.insertExc(denda);
							
							if(oidx!=0){
								DbSewaTanahInvoice.updateExc(lt);
							}
						}
						catch(Exception e){
						
						}
					}
				}				
			}
		}
		
				
	}
	
	//hitung denda komper
	public static void hitungDendaHarianKomper(Date dt){
		
		System.out.println("\n** start to calculate denda assesment **");
		
		String where = DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_JATUH_TEMPO]+"< '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"+
			" and "+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_STATUS_PEMBAYARAN]+"<>"+DbPembayaran.STATUS_BAYAR_LUNAS;
			//" and "+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TYPE]+"="+DbSewaTanahInvoice.TYPE_INV_ASSESMENT;
			
		System.out.println("	where : "+where);	
		
		Vector temp = DbSewaTanahBenefit.list(0,0, where, "");
		
		if(temp!=null && temp.size()>0){
			for(int i=0; i<temp.size(); i++){
				
				SewaTanahBenefit lt = (SewaTanahBenefit)temp.get(i);
				
				double total = lt.getTotalKomper() + lt.getPpn() + lt.getPph();
				double payment = DbPembayaran.getTotPembayaran(0, DbPembayaran.PAYMENT_SOURCE_KOMPER, lt.getOID(), lt.getCurrencyId());
				double balance = total - payment;
				//proses denda
				if(balance > 0){
					
					int  jmlHariTahun = Integer.parseInt(DbSystemProperty.getValueByName("JML_HARI_DALAM_SETAHUN"));
					
					double dendaVal = (balance * 0.1)/jmlHariTahun;
						
					Denda denda = getDenda(lt.getOID(), DbPembayaran.PAYMENT_SOURCE_KOMPER, dt);
                                        
					if(denda.getOID()!=0){
						if(denda.getJumlah()!=dendaVal){
							lt.setTotalDenda(lt.getTotalDenda()-denda.getJumlah()+dendaVal);
                                                        lt.setDendaDiakui(lt.getDendaDiakui()-denda.getJumlah()+dendaVal);
							denda.setJumlah(dendaVal);
							try{
								long oidx = DbDenda.updateExc(denda);
								if(oidx!=0){
									DbSewaTanahBenefit.updateExc(lt);
								}
							}
							catch(Exception e){
							
							}
						}
					}
					else{
						try{
							
							lt.setTotalDenda(lt.getTotalDenda()+dendaVal);
                                                        lt.setDendaDiakui(lt.getDendaDiakui()+dendaVal);
							
							Customer c = DbCustomer.fetchExc(lt.getSaranaId());						
							
							denda.setInvestorId(lt.getInvestorId());
							denda.setSaranaId(lt.getSaranaId());
							denda.setType(DbPembayaran.PAYMENT_SOURCE_KOMPER);
							denda.setSewaTanahInvoiceId(lt.getOID());
							denda.setTanggal(dt);
							denda.setStatus("Draft");
							denda.setCurrencyId(lt.getCurrencyId());
							
							Currency curr = DbCurrency.fetchExc(denda.getCurrencyId());
							denda.setJumlah(dendaVal);
							
							denda.setKeterangan(c.getName()+" : denda tagihan kompensasi persentase, tanggal"+JSPFormater.formatDate(dt, "dd/MM/yyyy")+", sisa tagihan "+curr.getCurrencyCode()+" "+JSPFormater.formatNumber(balance, "#,###.##"));
							
							long oidx = DbDenda.insertExc(denda);
							
							if(oidx!=0){
								DbSewaTanahBenefit.updateExc(lt);
							}
						}
						catch(Exception e){
						
						}
					}
				}				
			}
		}		
	}
	
	
	
	//hitung denda limbah
	public static void hitungDendaHarianLimbah(Date dt){
		
		System.out.println("\n** start to calculate denda limbah **");
		
		String where = DbLimbahTransaction.colNames[DbLimbahTransaction.COL_DUE_DATE]+"< '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"+
			" and "+DbLimbahTransaction.colNames[DbLimbahTransaction.COL_STATUS_PEMBAYARAN]+"<>"+DbPembayaran.STATUS_BAYAR_LUNAS;
			
		System.out.println("	where : "+where);	
		
		Vector temp = DbLimbahTransaction.list(0,0, where, "");
		
		if(temp!=null && temp.size()>0){
			for(int i=0; i<temp.size(); i++){
				LimbahTransaction lt = (LimbahTransaction)temp.get(i);
				double total = ((lt.getBulanIni()-lt.getBulanLalu()) * lt.getPercentageUsed()/100 * lt.getHarga()) + lt.getPpn() + lt.getPph();				
				double payment = DbPembayaran.getTotPembayaranLimbah(lt.getOID());//getTotPembayaran(0, DbPembayaran.PAYMENT_SOURCE_LIMBAH, lt.getOID());
				double balance = total - payment;
				//proses denda
				if(balance > 0){
					
					int  jmlHariTahun = Integer.parseInt(DbSystemProperty.getValueByName("JML_HARI_DALAM_SETAHUN"));
					
					double dendaVal = (balance * 0.1)/jmlHariTahun;
						
					Denda denda = getDenda(lt.getOID(), DbPembayaran.PAYMENT_SOURCE_LIMBAH, dt);
					if(denda.getOID()!=0){
						if(denda.getJumlah()!=dendaVal){
							
                                                        lt.setTotalDenda(lt.getTotalDenda()-denda.getJumlah()+dendaVal);
                                                        lt.setDendaDiakui(lt.getDendaDiakui()-denda.getJumlah()+dendaVal);
                                                        
							denda.setJumlah(dendaVal);
                                                        
							try{
								long oidx = DbDenda.updateExc(denda);
								if(oidx!=0){
									DbLimbahTransaction.updateExc(lt);
								}
							}
							catch(Exception e){
							
							}
						}
					}
					else{
						try{
							
							lt.setTotalDenda(lt.getTotalDenda()+dendaVal);
							lt.setDendaDiakui(lt.getDendaDiakui()+dendaVal);
                                                        
							Customer c = DbCustomer.fetchExc(lt.getCustomerId());						
							
							denda.setInvestorId(c.getIndukCustomerId());
							denda.setSaranaId(lt.getCustomerId());
							denda.setType(DbPembayaran.PAYMENT_SOURCE_LIMBAH);
							denda.setLimbahTransaksiId(lt.getOID());
							denda.setTanggal(dt);
							denda.setStatus("Draft");
							denda.setCurrencyId(Long.parseLong(DbSystemProperty.getValueByName("CURRENCY_LIMBAH")));
							
							Currency curr = DbCurrency.fetchExc(denda.getCurrencyId());
							denda.setJumlah(dendaVal);
							
							denda.setKeterangan(c.getName()+" : denda tagihan limbah, tanggal"+JSPFormater.formatDate(dt, "dd/MM/yyyy")+", sisa tagihan "+curr.getCurrencyCode()+" "+JSPFormater.formatNumber(balance, "#,###.##"));
							
							long oidx = DbDenda.insertExc(denda);
							
							if(oidx!=0){
								DbLimbahTransaction.updateExc(lt);
							}
						}
						catch(Exception e){
						
						}
					}
				}				
			}
		}
		
				
	}
	
	//hitung denda irigasi
	public static void hitungDendaHarianIrigasi(Date dt){
		
		System.out.println("\n** start to calculate denda irigasi **");
		
		String where = DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_DUE_DATE]+"< '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"+
			" and "+DbIrigasiTransaction.colNames[DbIrigasiTransaction.COL_STATUS_PEMBAYARAN]+"<>"+DbPembayaran.STATUS_BAYAR_LUNAS;
		
		Vector temp = DbIrigasiTransaction.list(0,0, where, "");
		
		if(temp!=null && temp.size()>0){
			for(int i=0; i<temp.size(); i++){
				
				IrigasiTransaction lt = (IrigasiTransaction)temp.get(i);
				
				double total = ((lt.getBulanIni()-lt.getBulanLalu()) * lt.getHarga()) + lt.getPpn() + lt.getPph();				
				double payment = DbPembayaran.getTotPembayaranIrigasi(lt.getOID());//getTotPembayaran(0, DbPembayaran.PAYMENT_SOURCE_IRIGASI, lt.getOID());
				double balance = total - payment;
				//proses denda
				if(balance > 0){
					
					int  jmlHariTahun = Integer.parseInt(DbSystemProperty.getValueByName("JML_HARI_DALAM_SETAHUN"));
					
					double dendaVal = (balance * 0.1)/jmlHariTahun;
						
					Denda denda = getDenda(lt.getOID(), DbPembayaran.PAYMENT_SOURCE_IRIGASI, dt);
					if(denda.getOID()!=0){
						if(denda.getJumlah()!=dendaVal){
                                                    
							lt.setTotalDenda(lt.getTotalDenda()-denda.getJumlah()+dendaVal);
                                                        lt.setDendaDiakui(lt.getDendaDiakui()-denda.getJumlah()+dendaVal);
                                                        
							denda.setJumlah(dendaVal);
							try{
								long oidx = DbDenda.updateExc(denda);
								if(oidx!=0){
									DbIrigasiTransaction.updateExc(lt);
								}
							}
							catch(Exception e){
							
							}
						}
					}
					else{
						try{
							
							lt.setTotalDenda(lt.getTotalDenda()+dendaVal);
							lt.setDendaDiakui(lt.getDendaDiakui()+dendaVal);
                                                        
							Customer c = new Customer();
							c = DbCustomer.fetchExc(lt.getCustumerId());						
							
							denda.setInvestorId(c.getIndukCustomerId());
							denda.setSaranaId(lt.getCustumerId());
							denda.setType(DbPembayaran.PAYMENT_SOURCE_IRIGASI);
							denda.setIrigasiTransaksiId(lt.getOID());
							denda.setTanggal(dt);
							denda.setStatus("Draft");
							denda.setCurrencyId(Long.parseLong(DbSystemProperty.getValueByName("CURRENCY_IRIGASI")));
							
							Currency curr = DbCurrency.fetchExc(denda.getCurrencyId());
							denda.setJumlah(dendaVal);
							
							denda.setKeterangan(c.getName()+" : denda tagihan irigasi, tanggal"+JSPFormater.formatDate(dt, "dd/MM/yyyy")+", sisa tagihan "+curr.getCurrencyCode()+" "+JSPFormater.formatNumber(balance, "#,###.##"));
							
							long oidx = DbDenda.insertExc(denda);
							
							if(oidx!=0){
								DbIrigasiTransaction.updateExc(lt);
							}
						}
						catch(Exception e){
						
						}
					}
				}				
			}
		}
		
	}
	
	public static Denda getDenda(long oid, int source, Date dt){
		
		String where = colNames[COL_TANGGAL]+"='"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"+
			" and ";
			if(source == DbPembayaran.PAYMENT_SOURCE_LIMBAH){
				where = where + colNames[COL_LIMBAH_TRANSAKSI_ID]+"="+oid;	
			}
			else if(source == DbPembayaran.PAYMENT_SOURCE_IRIGASI){                
                where = where + colNames[COL_IRIGASI_TRANSAKSI_ID]+"="+oid;	
                //sql = sql + " AND "+DbPembayaran.colNames[DbPembayaran.COL_LIMBAH_TRANSACTION_ID]+" = "+transactionId;                
            }
            else if(source == DbPembayaran.PAYMENT_SOURCE_KOMIN){
            	where = where + colNames[COL_SEWA_TANAH_INVOICE_ID]+"="+oid;	
            	//sql = sql + " AND "+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+" = "+transactionId;                
            }            
            else if(source == DbPembayaran.PAYMENT_SOURCE_ASSESMENT){
            	where = where + colNames[COL_SEWA_TANAH_INVOICE_ID]+"="+oid;	
            	//sql = sql + " AND "+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_INVOICE_ID]+" = "+transactionId;                
            }            
            else if(source == DbPembayaran.PAYMENT_SOURCE_DENDA){
            	//sql = sql + " AND "+DbPembayaran.colNames[DbPembayaran.COL_DENDA_ID]+" = "+transactionId;                
            }
            else if(source == DbPembayaran.PAYMENT_SOURCE_KOMPER){
            	where = where + colNames[COL_SEWA_TANAH_INVOICE_ID]+"="+oid;	
            	//sql = sql + " AND "+DbPembayaran.colNames[DbPembayaran.COL_SEWA_TANAH_BENEFIT_ID]+" = "+transactionId;                
            }
            
        Vector temp = DbDenda.list(0,1, where, "");
        if(temp!=null && temp.size()>0){
        	return (Denda)temp.get(0);
        }    
        	
		return new Denda();
	}
	
        
        
	
}
