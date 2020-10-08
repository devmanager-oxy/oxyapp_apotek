
package com.project.coorp.pinjaman; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.*;
import com.project.fms.master.*;
import com.project.util.*;
import com.project.coorp.member.*;
import com.project.fms.transaction.*;
import com.project.*;
import com.project.general.Location;
import com.project.general.DbLocation;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.system.*;

public class DbBayarPinjaman extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_BAYAR_PINJAMAN = "sp_bayar_pinjaman";

	public static final  int COL_MEMBER_ID = 0;
	public static final  int COL_PINJAMAN_ID = 1;
	public static final  int COL_PINJAMAN_DETAIL_ID = 2;
	public static final  int COL_BAYAR_PINJAMAN_ID = 3;
	public static final  int COL_TANGGAL = 4;
	public static final  int COL_AMOUNT = 5;
	public static final  int COL_BUNGA = 6;
	public static final  int COL_DENDA = 7;
	public static final  int COL_STATUS = 8;
	public static final  int COL_TYPE = 9;
	public static final  int COL_CICILAN_KE = 10;
	public static final  int COL_PINALTI = 11;
	public static final  int COL_NO_TRANSAKSI = 12;
	public static final  int COL_COUNTER = 13;
	public static final  int COL_PREFIX_NUMBER = 14;
        public static final  int COL_USER_ID = 15;
        
        public static final  int COL_TYPE_PINJAMAN = 16;
        
        public static final  int COL_COA_POKOK_DEBET_ID = 17;
        public static final  int COL_COA_POKOK_CREDIT_ID = 18;
        public static final  int COL_COA_BUNGA_DEBET_ID = 19;
        public static final  int COL_COA_BUNGA_CREDIT_ID = 20;
        public static final  int COL_COA_DENDA_DEBET_ID = 21;
        public static final  int COL_COA_DENDA_CREDIT_ID = 22;
        public static final  int COL_COA_PINALTI_DEBET_ID = 23;
        public static final  int COL_COA_PINALTI_CREDIT_ID = 24;

	public static final  String[] colNames = {
		"member_id",
                "pinjaman_id",
                "pinjaman_detail_id",
                "bayar_pinjaman_id",                
                "tanggal",
                "amount",
                "bunga",
                "denda",
                "status",
                "type",
                "cicilan_ke",
                "pinalti",
                "no_transaksi",
                "counter",
                "prefix_number",
                "user_id",
                "type_pinjaman",
                
                "coa_pokok_debet_id",
                "coa_pokok_credit_id",
                "coa_bunga_debet_id",
                "coa_bunga_credit_id",
                "coa_denda_debet_id",
                "coa_denda_credit_id",
                "coa_pinalti_debet_id",
                "coa_pinalti_credit_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_INT,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_INT,
		TYPE_STRING,
                TYPE_LONG,
                TYPE_INT,
                
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	 }; 

	public DbBayarPinjaman(){
	}
        
        public static final int TYPE_ANGSURAN = 0;
        public static final int TYPE_PELUNASAN = 1;
        
	public DbBayarPinjaman(int i) throws CONException { 
		super(new DbBayarPinjaman()); 
	}

	public DbBayarPinjaman(String sOid) throws CONException { 
		super(new DbBayarPinjaman(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbBayarPinjaman(long lOid) throws CONException { 
		super(new DbBayarPinjaman(0)); 
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
		return DB_BAYAR_PINJAMAN;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbBayarPinjaman().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		BayarPinjaman bayarpinjaman = fetchExc(ent.getOID()); 
		ent = (Entity)bayarpinjaman; 
		return bayarpinjaman.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((BayarPinjaman) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((BayarPinjaman) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static BayarPinjaman fetchExc(long oid) throws CONException{ 
		try{ 
			BayarPinjaman bayarpinjaman = new BayarPinjaman();
			DbBayarPinjaman pstBayarPinjaman = new DbBayarPinjaman(oid); 
			bayarpinjaman.setOID(oid);

			bayarpinjaman.setMemberId(pstBayarPinjaman.getlong(COL_MEMBER_ID));
			bayarpinjaman.setPinjamanId(pstBayarPinjaman.getlong(COL_PINJAMAN_ID));
			bayarpinjaman.setPinjamanDetailId(pstBayarPinjaman.getlong(COL_PINJAMAN_DETAIL_ID));
			bayarpinjaman.setTanggal(pstBayarPinjaman.getDate(COL_TANGGAL));
			bayarpinjaman.setAmount(pstBayarPinjaman.getdouble(COL_AMOUNT));
			bayarpinjaman.setBunga(pstBayarPinjaman.getdouble(COL_BUNGA));
			bayarpinjaman.setDenda(pstBayarPinjaman.getdouble(COL_DENDA));
			bayarpinjaman.setStatus(pstBayarPinjaman.getInt(COL_STATUS));
			bayarpinjaman.setType(pstBayarPinjaman.getInt(COL_TYPE));
			bayarpinjaman.setCicilanKe(pstBayarPinjaman.getInt(COL_CICILAN_KE));
			bayarpinjaman.setPinalti(pstBayarPinjaman.getdouble(COL_PINALTI));
			bayarpinjaman.setNoTransaksi(pstBayarPinjaman.getString(COL_NO_TRANSAKSI));
			bayarpinjaman.setCounter(pstBayarPinjaman.getInt(COL_COUNTER));
			bayarpinjaman.setPrefixNumber(pstBayarPinjaman.getString(COL_PREFIX_NUMBER));
                        bayarpinjaman.setUserId(pstBayarPinjaman.getlong(COL_USER_ID));
                        bayarpinjaman.setTypePinjaman(pstBayarPinjaman.getInt(COL_TYPE_PINJAMAN));
                        
                        bayarpinjaman.setCoaPokokDebetId(pstBayarPinjaman.getlong(COL_COA_POKOK_DEBET_ID));
                        bayarpinjaman.setCoaPokokCreditId(pstBayarPinjaman.getlong(COL_COA_POKOK_CREDIT_ID));
                        bayarpinjaman.setCoaBungaDebetId(pstBayarPinjaman.getlong(COL_COA_BUNGA_DEBET_ID));
                        bayarpinjaman.setCoaBungaCreditId(pstBayarPinjaman.getlong(COL_COA_BUNGA_CREDIT_ID));
                        bayarpinjaman.setCoaDendaDebetId(pstBayarPinjaman.getlong(COL_COA_DENDA_DEBET_ID));
                        bayarpinjaman.setCoaDendaCreditId(pstBayarPinjaman.getlong(COL_COA_DENDA_CREDIT_ID));
                        bayarpinjaman.setCoaPinaltiDebetId(pstBayarPinjaman.getlong(COL_COA_PINALTI_DEBET_ID));
                        bayarpinjaman.setCoaPinaltiCreditId(pstBayarPinjaman.getlong(COL_COA_PINALTI_CREDIT_ID));

			return bayarpinjaman; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBayarPinjaman(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(BayarPinjaman bayarpinjaman) throws CONException{ 
		try{ 
			DbBayarPinjaman pstBayarPinjaman = new DbBayarPinjaman(0);

			pstBayarPinjaman.setLong(COL_MEMBER_ID, bayarpinjaman.getMemberId());
			pstBayarPinjaman.setLong(COL_PINJAMAN_ID, bayarpinjaman.getPinjamanId());
			pstBayarPinjaman.setLong(COL_PINJAMAN_DETAIL_ID, bayarpinjaman.getPinjamanDetailId());
			pstBayarPinjaman.setDate(COL_TANGGAL, bayarpinjaman.getTanggal());
			pstBayarPinjaman.setDouble(COL_AMOUNT, bayarpinjaman.getAmount());
			pstBayarPinjaman.setDouble(COL_BUNGA, bayarpinjaman.getBunga());
			pstBayarPinjaman.setDouble(COL_DENDA, bayarpinjaman.getDenda());
			pstBayarPinjaman.setInt(COL_STATUS, bayarpinjaman.getStatus());
			pstBayarPinjaman.setInt(COL_TYPE, bayarpinjaman.getType());
			pstBayarPinjaman.setInt(COL_CICILAN_KE, bayarpinjaman.getCicilanKe());
			pstBayarPinjaman.setDouble(COL_PINALTI, bayarpinjaman.getPinalti());
			pstBayarPinjaman.setString(COL_NO_TRANSAKSI, bayarpinjaman.getNoTransaksi());
			pstBayarPinjaman.setInt(COL_COUNTER, bayarpinjaman.getCounter());
			pstBayarPinjaman.setString(COL_PREFIX_NUMBER, bayarpinjaman.getPrefixNumber());
                        pstBayarPinjaman.setLong(COL_USER_ID, bayarpinjaman.getUserId());
                        pstBayarPinjaman.setInt(COL_TYPE_PINJAMAN, bayarpinjaman.getTypePinjaman());
                        
                        pstBayarPinjaman.setLong(COL_COA_POKOK_DEBET_ID, bayarpinjaman.getCoaPokokDebetId());
                        pstBayarPinjaman.setLong(COL_COA_POKOK_CREDIT_ID, bayarpinjaman.getCoaPokokCreditId());
                        pstBayarPinjaman.setLong(COL_COA_BUNGA_DEBET_ID, bayarpinjaman.getCoaBungaDebetId());
                        pstBayarPinjaman.setLong(COL_COA_BUNGA_CREDIT_ID, bayarpinjaman.getCoaBungaCreditId());
                        pstBayarPinjaman.setLong(COL_COA_DENDA_DEBET_ID, bayarpinjaman.getCoaDendaDebetId());
                        pstBayarPinjaman.setLong(COL_COA_DENDA_CREDIT_ID, bayarpinjaman.getCoaDendaCreditId());
                        pstBayarPinjaman.setLong(COL_COA_PINALTI_DEBET_ID, bayarpinjaman.getCoaPinaltiDebetId());
                        pstBayarPinjaman.setLong(COL_COA_PINALTI_CREDIT_ID, bayarpinjaman.getCoaPinaltiCreditId());

			pstBayarPinjaman.insert(); 
			bayarpinjaman.setOID(pstBayarPinjaman.getlong(COL_BAYAR_PINJAMAN_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBayarPinjaman(0),CONException.UNKNOWN); 
		}
		return bayarpinjaman.getOID();
	}

	public static long updateExc(BayarPinjaman bayarpinjaman) throws CONException{ 
		try{ 
			if(bayarpinjaman.getOID() != 0){ 
				DbBayarPinjaman pstBayarPinjaman = new DbBayarPinjaman(bayarpinjaman.getOID());

				pstBayarPinjaman.setLong(COL_MEMBER_ID, bayarpinjaman.getMemberId());
				pstBayarPinjaman.setLong(COL_PINJAMAN_ID, bayarpinjaman.getPinjamanId());
				pstBayarPinjaman.setLong(COL_PINJAMAN_DETAIL_ID, bayarpinjaman.getPinjamanDetailId());
				pstBayarPinjaman.setDate(COL_TANGGAL, bayarpinjaman.getTanggal());
				pstBayarPinjaman.setDouble(COL_AMOUNT, bayarpinjaman.getAmount());
				pstBayarPinjaman.setDouble(COL_BUNGA, bayarpinjaman.getBunga());
				pstBayarPinjaman.setDouble(COL_DENDA, bayarpinjaman.getDenda());
				pstBayarPinjaman.setInt(COL_STATUS, bayarpinjaman.getStatus());
				pstBayarPinjaman.setInt(COL_TYPE, bayarpinjaman.getType());
				pstBayarPinjaman.setInt(COL_CICILAN_KE, bayarpinjaman.getCicilanKe());
				pstBayarPinjaman.setDouble(COL_PINALTI, bayarpinjaman.getPinalti());
				pstBayarPinjaman.setString(COL_NO_TRANSAKSI, bayarpinjaman.getNoTransaksi());
				pstBayarPinjaman.setInt(COL_COUNTER, bayarpinjaman.getCounter());
				pstBayarPinjaman.setString(COL_PREFIX_NUMBER, bayarpinjaman.getPrefixNumber());
                                pstBayarPinjaman.setLong(COL_USER_ID, bayarpinjaman.getUserId());
                                pstBayarPinjaman.setInt(COL_TYPE_PINJAMAN, bayarpinjaman.getTypePinjaman());
                                
                                pstBayarPinjaman.setLong(COL_COA_POKOK_DEBET_ID, bayarpinjaman.getCoaPokokDebetId());
                                pstBayarPinjaman.setLong(COL_COA_POKOK_CREDIT_ID, bayarpinjaman.getCoaPokokCreditId());
                                pstBayarPinjaman.setLong(COL_COA_BUNGA_DEBET_ID, bayarpinjaman.getCoaBungaDebetId());
                                pstBayarPinjaman.setLong(COL_COA_BUNGA_CREDIT_ID, bayarpinjaman.getCoaBungaCreditId());
                                pstBayarPinjaman.setLong(COL_COA_DENDA_DEBET_ID, bayarpinjaman.getCoaDendaDebetId());
                                pstBayarPinjaman.setLong(COL_COA_DENDA_CREDIT_ID, bayarpinjaman.getCoaDendaCreditId());
                                pstBayarPinjaman.setLong(COL_COA_PINALTI_DEBET_ID, bayarpinjaman.getCoaPinaltiDebetId());
                                pstBayarPinjaman.setLong(COL_COA_PINALTI_CREDIT_ID, bayarpinjaman.getCoaPinaltiCreditId());

				pstBayarPinjaman.update(); 
				return bayarpinjaman.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBayarPinjaman(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbBayarPinjaman pstBayarPinjaman = new DbBayarPinjaman(oid);
			pstBayarPinjaman.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBayarPinjaman(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_BAYAR_PINJAMAN; 
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
				BayarPinjaman bayarpinjaman = new BayarPinjaman();
				resultToObject(rs, bayarpinjaman);
				lists.add(bayarpinjaman);
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

	private static void resultToObject(ResultSet rs, BayarPinjaman bayarpinjaman){
		try{
			bayarpinjaman.setOID(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_BAYAR_PINJAMAN_ID]));
			bayarpinjaman.setMemberId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_MEMBER_ID]));
			bayarpinjaman.setPinjamanId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_PINJAMAN_ID]));
			bayarpinjaman.setPinjamanDetailId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_PINJAMAN_DETAIL_ID]));
			bayarpinjaman.setTanggal(rs.getDate(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_TANGGAL]));
			bayarpinjaman.setAmount(rs.getDouble(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_AMOUNT]));
			bayarpinjaman.setBunga(rs.getDouble(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_BUNGA]));
			bayarpinjaman.setDenda(rs.getDouble(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_DENDA]));
			bayarpinjaman.setStatus(rs.getInt(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_STATUS]));
			bayarpinjaman.setType(rs.getInt(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_TYPE]));
			bayarpinjaman.setCicilanKe(rs.getInt(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_CICILAN_KE]));
			bayarpinjaman.setPinalti(rs.getDouble(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_PINALTI]));
			bayarpinjaman.setNoTransaksi(rs.getString(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_NO_TRANSAKSI]));
			bayarpinjaman.setCounter(rs.getInt(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_COUNTER]));
			bayarpinjaman.setPrefixNumber(rs.getString(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_PREFIX_NUMBER]));
                        bayarpinjaman.setUserId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_USER_ID]));
                        bayarpinjaman.setTypePinjaman(rs.getInt(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_TYPE_PINJAMAN]));
                        
                        bayarpinjaman.setCoaPokokDebetId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_COA_POKOK_DEBET_ID]));
                        bayarpinjaman.setCoaPokokCreditId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_COA_POKOK_CREDIT_ID]));
                        bayarpinjaman.setCoaBungaDebetId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_COA_BUNGA_DEBET_ID]));
                        bayarpinjaman.setCoaBungaCreditId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_COA_BUNGA_CREDIT_ID]));
                        bayarpinjaman.setCoaDendaDebetId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_COA_DENDA_DEBET_ID]));
                        bayarpinjaman.setCoaDendaCreditId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_COA_DENDA_CREDIT_ID]));
                        bayarpinjaman.setCoaPinaltiDebetId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_COA_PINALTI_DEBET_ID]));
                        bayarpinjaman.setCoaPinaltiCreditId(rs.getLong(DbBayarPinjaman.colNames[DbBayarPinjaman.COL_COA_PINALTI_CREDIT_ID]));

		}catch(Exception e){ }
	}

	
	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbBayarPinjaman.colNames[DbBayarPinjaman.COL_BAYAR_PINJAMAN_ID] + ") FROM " + DB_BAYAR_PINJAMAN;
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
			  	   BayarPinjaman bayarpinjaman = (BayarPinjaman)list.get(ls);
				   if(oid == bayarpinjaman.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static int getNextCounter(int type){
                int result = 0;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_BAYAR_PINJAMAN+" where "+
                        colNames[COL_PREFIX_NUMBER]+"='"+getNumberPrefix(type)+"' and "+colNames[COL_TYPE_PINJAMAN]+"="+type;
                    
                    System.out.println(sql);
                    
                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while(rs.next()){
                        result = rs.getInt(1);
                    }
                    
                    if(result==0){
                        result = result + 1;
                    }
                    else{
                        result = result + 1;
                    }
                    
                }
                catch(Exception e){
                    
                }
                finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
        }
        
        public static String getNumberPrefix(int type){
            
                Company sysCompany = DbCompany.getCompany();
                
                String code = "";
                if(type==DbPinjaman.TYPE_PINJAMAN_KOPERASI){
                    code = code + sysCompany.getBayarAngsuranCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");
                }
                else if(type==DbPinjaman.TYPE_PINJAMAN_BANK){
                    code = code + sysCompany.getBayarAngsuranBankCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");
                }
                else{
                    code = code + sysCompany.getBayarAngsuranKopBankCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");
                }
                
                code = code + JSPFormater.formatDate(new Date(), "MMyy");
                
                return code;
        }
        
        
        public static String getNextNumber(int ctr, int type){
            
                String code = getNumberPrefix(type);
                
                if(ctr<10){
                    code = code + "000"+ctr;
                }
                else if(ctr<100){
                    code = code + "00"+ctr;
                }
                else if(ctr<1000){
                    code = code + "0"+ctr;
                }
                else{
                    code = code + ctr;
                }
                
                return code;
                
        }
        
        //POSTING ke journal - pembayaran hutang oleh member
        public static void postJournal_bad(Pinjaman cr, BayarPinjaman bayarPinjaman){
                
                Company comp = DbCompany.getCompany();
                
                ExchangeRate er = DbExchangeRate.getStandardRate();
                
                Member member = new Member();
                try{
                    member = DbMember.fetchExc(cr.getMemberId());
                }
                catch(Exception e){
                }
                
                Bank bn = new Bank();
                try{
                    bn = DbBank.fetchExc(cr.getBankId());
                }
                catch(Exception e){
                    
                }
                
                String memo = "";
                if(bayarPinjaman.getType()==DbBayarPinjaman.TYPE_ANGSURAN){
                    memo = "Pembayaran angsuran ke "+bayarPinjaman.getCicilanKe();
                }
                else{
                    memo = "Pelunasan";
                }
                
                memo = memo + ", pinjaman "+((cr.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? "Koperasi" : "BANK "+bn.getName())+" oleh anggota : "+member.getNoMember()+"/"+member.getNama() + " - No Rekening Pinjaman : "+cr.getNumber()+", No Transaksi : "+bayarPinjaman.getNoTransaksi();
                               
                if(bayarPinjaman.getOID()!=0){
                    
                    //jurnal main
                    long oid = DbGl.postJournalMain(0, bayarPinjaman.getTanggal(), bayarPinjaman.getCounter(), bayarPinjaman.getNoTransaksi(), bayarPinjaman.getPrefixNumber(), 
                        (bayarPinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? I_Project.JOURNAL_TYPE_PEMBAYARAN_PINJAMAN_KOPERASI : I_Project.JOURNAL_TYPE_PEMBAYARAN_PINJAMAN_BANK, 
                        memo, bayarPinjaman.getUserId(), "", bayarPinjaman.getOID(), "", bayarPinjaman.getTanggal());
                    
                    //pengakuan pihutang    
                    if(oid!=0){
                        
                        memo = ""; 
                        
                        //====================== jurnal pembayaran pokok ===================
                        
                        //journal debet pada cash 
                        memo = "Penambahan pada cash/bank pembayaran piutang anggota : "+member.getNoMember()+"/"+member.getNama();
                        
                        //debet digabung jadi 1 karena akunnya sama
                        if(bayarPinjaman.getCoaPokokDebetId()==bayarPinjaman.getCoaBungaDebetId() 
                        && bayarPinjaman.getCoaPokokDebetId()==bayarPinjaman.getCoaDendaDebetId()
                        && bayarPinjaman.getCoaPokokDebetId()==bayarPinjaman.getCoaPinaltiDebetId()
                        ){
                                memo = memo +"("+bayarPinjaman.getAmount()+")";
                                if(bayarPinjaman.getBunga()>0){
                                    memo = memo + ", bunga pinjaman ("+bayarPinjaman.getBunga()+")";
                                }
                                if(bayarPinjaman.getDenda()>0){
                                    memo = memo +", denda keterlambatan angsuran ("+bayarPinjaman.getDenda()+")";
                                }
                                if(bayarPinjaman.getPinalti()>0){
                                    memo = memo +", pinalty sebesar ("+bayarPinjaman.getPinalti()+")"; 
                                }

                                DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPokokDebetId(), 0, (bayarPinjaman.getAmount()+bayarPinjaman.getBunga()+bayarPinjaman.getDenda()+bayarPinjaman.getPinalti()),             
                                        (bayarPinjaman.getAmount()+bayarPinjaman.getBunga()+bayarPinjaman.getDenda()+bayarPinjaman.getPinalti()), comp.getBookingCurrencyId(), oid, memo, 0);
                        }
                        //pokok dan bunga dan denda akun sama
                        else if(bayarPinjaman.getCoaPokokDebetId()==bayarPinjaman.getCoaBungaDebetId() 
                        && bayarPinjaman.getCoaPokokDebetId()==bayarPinjaman.getCoaDendaDebetId()                        
                        ){
                                memo = memo +"("+bayarPinjaman.getAmount()+")";
                                if(bayarPinjaman.getBunga()>0){
                                    memo = memo + ", bunga pinjaman ("+bayarPinjaman.getBunga()+")";
                                }
                                if(bayarPinjaman.getDenda()>0){
                                    memo = memo +", denda keterlambatan angsuran ("+bayarPinjaman.getDenda()+")";
                                }                            

                                DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPokokDebetId(), 0, (bayarPinjaman.getAmount()+bayarPinjaman.getBunga()+bayarPinjaman.getDenda()),             
                                        (bayarPinjaman.getAmount()+bayarPinjaman.getBunga()+bayarPinjaman.getDenda()), comp.getBookingCurrencyId(), oid, memo, 0);

                                if(bayarPinjaman.getPinalti()>0){
                                    memo = "Pinalti pelunasan angsuran";

                                    DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiDebetId(), 0, (bayarPinjaman.getPinalti()),             
                                            (bayarPinjaman.getPinalti()), comp.getBookingCurrencyId(), oid, memo, 0);
                                }
                        }
                        //pokok dan bunga sama, denda dan pinalti mungkin sama
                        else if(bayarPinjaman.getCoaPokokDebetId()==bayarPinjaman.getCoaBungaDebetId()                         
                        ){
                                memo = memo +"("+bayarPinjaman.getAmount()+")";
                                if(bayarPinjaman.getBunga()>0){
                                    memo = memo + ", bunga pinjaman ("+bayarPinjaman.getBunga()+")";
                                }

                                //jurnal pokok dan bunga
                                DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPokokDebetId(), 0, (bayarPinjaman.getAmount()+bayarPinjaman.getBunga()),             
                                        (bayarPinjaman.getAmount()+bayarPinjaman.getBunga()), comp.getBookingCurrencyId(), oid, memo, 0);

                                //jurnal denda dan pinalti
                                if(bayarPinjaman.getCoaDendaDebetId()==bayarPinjaman.getCoaPinaltiDebetId()){
                                    if(bayarPinjaman.getDenda()>0 || bayarPinjaman.getPinalti()>0){
                                        memo = "Denda keterlambatan angsuran("+bayarPinjaman.getDenda()+"), pinalti ("+bayarPinjaman.getPinalti()+")";

                                        DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaDendaDebetId(), 0, (bayarPinjaman.getDenda()+bayarPinjaman.getPinalti()),             
                                                (bayarPinjaman.getDenda()+bayarPinjaman.getPinalti()), comp.getBookingCurrencyId(), oid, memo, 0);
                                    }
                                }
                                else{
                                    if(bayarPinjaman.getDenda()>0){
                                        memo = "Denda keterlambatan angsuran";

                                        DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaDendaDebetId(), 0, (bayarPinjaman.getDenda()),             
                                                (bayarPinjaman.getDenda()), comp.getBookingCurrencyId(), oid, memo, 0);
                                    }

                                    if(bayarPinjaman.getPinalti()>0){
                                        memo = "Pinalti angsuran";

                                        DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiDebetId(), 0, (bayarPinjaman.getPinalti()),             
                                                (bayarPinjaman.getPinalti()), comp.getBookingCurrencyId(), oid, memo, 0);
                                    }
                                }
                        }
                        //ga sama
                        else{
                            //journal credit pada ar
                            memo = "Pemotongan pinjaman/pihutang anggota : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPokokDebetId(), bayarPinjaman.getAmount(), 0,             
                                    bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                            
                            //bunga sama dengan denda dan pinalti
                            if(bayarPinjaman.getCoaBungaDebetId()==bayarPinjaman.getCoaDendaDebetId()
                            && bayarPinjaman.getCoaBungaDebetId()==bayarPinjaman.getCoaPinaltiDebetId()){
                                    
                                    memo = "";
                                    if(bayarPinjaman.getBunga()>0){
                                        memo = memo + "Bunga pinjaman ("+bayarPinjaman.getBunga()+")";
                                    }
                                    if(bayarPinjaman.getDenda()>0){
                                        memo = memo +", denda keterlambatan angsuran ("+bayarPinjaman.getDenda()+")";
                                    }
                                    if(bayarPinjaman.getPinalti()>0){
                                        memo = memo +", pinalty sebesar ("+bayarPinjaman.getPinalti()+")"; 
                                    }

                                    DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaBungaDebetId(), 0, (bayarPinjaman.getBunga()+bayarPinjaman.getDenda()+bayarPinjaman.getPinalti()),             
                                            (bayarPinjaman.getBunga()+bayarPinjaman.getDenda()+bayarPinjaman.getPinalti()), comp.getBookingCurrencyId(), oid, memo, 0);
                                    
                            }
                            //bunga sama dengan denda
                            else if(bayarPinjaman.getCoaBungaDebetId()==bayarPinjaman.getCoaDendaDebetId()){
                                    
                                    memo = "";
                                    if(bayarPinjaman.getBunga()>0){
                                        memo = memo + "Bunga pinjaman ("+bayarPinjaman.getBunga()+")";
                                    }
                                    if(bayarPinjaman.getDenda()>0){
                                        memo = memo +", denda keterlambatan angsuran ("+bayarPinjaman.getDenda()+")";
                                    }                                    

                                    DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaBungaDebetId(), 0, (bayarPinjaman.getBunga()+bayarPinjaman.getDenda()),             
                                            (bayarPinjaman.getBunga()+bayarPinjaman.getDenda()), comp.getBookingCurrencyId(), oid, memo, 0);
                                    
                                    if(bayarPinjaman.getPinalti()>0){
                                            memo = memo +"Pinalti angsuran";
                                            
                                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiDebetId(), 0, (bayarPinjaman.getPinalti()),             
                                                    (bayarPinjaman.getPinalti()), comp.getBookingCurrencyId(), oid, memo, 0);

                                    }
                                    
                            }
                            //ga ada sama
                            else{
                                    memo = "";
                                    memo = memo + "Bunga pinjaman";
                                                                        
                                    DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaBungaDebetId(), 0, (bayarPinjaman.getBunga()),             
                                            (bayarPinjaman.getBunga()), comp.getBookingCurrencyId(), oid, memo, 0);
                                    
                                    if(bayarPinjaman.getCoaDendaDebetId()==bayarPinjaman.getCoaPinaltiDebetId()){
                                        
                                    }
                                    else{
                                        
                                    }
                                    
                                    if(bayarPinjaman.getPinalti()>0){
                                            memo = memo +"Pinalti angsuran";
                                            
                                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiDebetId(), 0, (bayarPinjaman.getPinalti()),             
                                                    (bayarPinjaman.getPinalti()), comp.getBookingCurrencyId(), oid, memo, 0);

                                    }
                            }
                            
                            
                        }
                        
                        
                        
                        
                        
                        //journal credit pada ar
                        memo = "Pemotongan pinjaman/pihutang anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPokokCreditId(), bayarPinjaman.getAmount(), 0,             
                                bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                        
                        
                        //=============================== jurnal pendapatan bunga koperasi ==================================
                        
                        //jika ada biaya bunga bukukan sebagai pendapatan
                        if(bayarPinjaman.getBunga()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //debet pada cash
                            memo = "Penambahan cash dari pendapatan bunga pinjaman : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getBunga(),             
                                        bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari bunga pinjaman : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getBunga(), 0,             
                                    bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                             */
                            
                            //debet pada cash
                            memo = "Penambahan cash/bank dari pendapatan bunga pinjaman : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaBungaDebetId(), 0, bayarPinjaman.getBunga(),             
                                        bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                            
                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari bunga pinjaman : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaBungaCreditId(), bayarPinjaman.getBunga(), 0,             
                                    bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                        }
                        
                        //=============================== jurnal pendapatan denda koperasi ==================================
                        
                        //jika ada biaya denda bukukan sebagai pendapatan
                        if(bayarPinjaman.getDenda()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DENDA_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //debet pada cash
                            memo = "Penambahan cash dari pendapatan denda keterlambatan angsuran : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getDenda(),             
                                        bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DENDA_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari denda keterlambatan angsuran : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getDenda(), 0,             
                                    bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
                            
                            //debet pada cash
                            memo = "Penambahan cash/bank dari pendapatan denda keterlambatan angsuran : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaDendaDebetId(), 0, bayarPinjaman.getDenda(),             
                                        bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari denda keterlambatan angsuran : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaDendaCreditId(), bayarPinjaman.getDenda(), 0,             
                                    bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                            

                        }
                        
                        //=============================== jurnal pendapatan pinalti ==================================
                        
                        //jika ada biaya pinalti bukukan sebagai pendapatan
                        if(bayarPinjaman.getPinalti()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_PINALTI_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //debet pada cash
                            memo = "Penambahan cash dari pendapatan pinalti angsuran : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getPinalti(),             
                                        bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_PINALTI_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari pinalti angsuran : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getPinalti(), 0,             
                                    bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
                            
                            //debet pada cash
                            memo = "Penambahan cash dari pendapatan pinalti angsuran : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiDebetId(), 0, bayarPinjaman.getPinalti(),             
                                        bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari pinalti angsuran : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiCreditId(), bayarPinjaman.getPinalti(), 0,             
                                    bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                        }
                        
                    }
                }
        }
        
        public static void postJournal(Pinjaman cr, BayarPinjaman bayarPinjaman){
                
                Company comp = DbCompany.getCompany();
                
                ExchangeRate er = DbExchangeRate.getStandardRate();
                
                Member member = new Member();
                try{
                    member = DbMember.fetchExc(cr.getMemberId());
                }
                catch(Exception e){
                }
                
                Bank bn = new Bank();
                try{
                    bn = DbBank.fetchExc(cr.getBankId());
                }
                catch(Exception e){
                    
                }
                
                String memo = "";
                if(bayarPinjaman.getType()==DbBayarPinjaman.TYPE_ANGSURAN){
                    memo = "Pembayaran angsuran ke "+bayarPinjaman.getCicilanKe();
                }
                else{
                    memo = "Pelunasan";
                }
                
                memo = memo + ", pinjaman "+((cr.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? "Koperasi" : "BANK "+bn.getName())+" oleh anggota : "+member.getNoMember()+"/"+member.getNama() + " - No Rekening Pinjaman : "+cr.getNumber()+", No Transaksi : "+bayarPinjaman.getNoTransaksi();
                               
                if(bayarPinjaman.getOID()!=0){
                    
                    //jurnal main
                    long oid = DbGl.postJournalMain(0, bayarPinjaman.getTanggal(), bayarPinjaman.getCounter(), bayarPinjaman.getNoTransaksi(), bayarPinjaman.getPrefixNumber(), 
                        (bayarPinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? I_Project.JOURNAL_TYPE_PEMBAYARAN_PINJAMAN_KOPERASI : I_Project.JOURNAL_TYPE_PEMBAYARAN_PINJAMAN_BANK, 
                        memo, bayarPinjaman.getUserId(), "", bayarPinjaman.getOID(), "", bayarPinjaman.getTanggal());
                    
                    //pengakuan pihutang    
                    if(oid!=0){
                        
                        memo = ""; 
                        
                        //====================== jurnal pembayaran pokok ===================
                        
                        //ambil coa cash acc link pinjaman
                        //sebagai debet - sebelumnya di acc link pada posisi credit - mengacu ke pinjaman (jurnal dibalik)
                        //yang lama
                        /*
                        Vector temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_CREDIT+"'", "");
                        AccLink al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        
                        //journal debet pada cash 
                        memo = "Penambahan pada cash/bank pembayaran piutang anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getAmount(),             
                                    bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0);

                        temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DEBET+"'", "");
                        al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        //journal credit pada ar
                        memo = "Pemotongan pinjaman anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getAmount(), 0,             
                                bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                         */
                        
                        //journal debet pada cash 
                        memo = "Penambahan pada cash/bank pembayaran piutang anggota";
                        DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPokokDebetId(), 0, bayarPinjaman.getAmount(),             
                                    bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0);
                        
                        //journal credit pada ar
                        memo = "Pemotongan pinjaman/pihutang anggota";
                        DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPokokCreditId(), bayarPinjaman.getAmount(), 0,             
                                bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                        
                        
                        //=============================== jurnal pendapatan bunga koperasi ==================================
                        
                        //jika ada biaya bunga bukukan sebagai pendapatan
                        if(bayarPinjaman.getBunga()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //debet pada cash
                            memo = "Penambahan cash dari pendapatan bunga pinjaman : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getBunga(),             
                                        bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari bunga pinjaman : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getBunga(), 0,             
                                    bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                             */
                            
                            //debet pada cash
                            memo = "Penambahan cash/bank dari pendapatan bunga pinjaman";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaBungaDebetId(), 0, bayarPinjaman.getBunga(),             
                                        bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                            
                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari bunga pinjaman";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaBungaCreditId(), bayarPinjaman.getBunga(), 0,             
                                    bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                        }
                        
                        //=============================== jurnal pendapatan denda koperasi ==================================
                        
                        //jika ada biaya denda bukukan sebagai pendapatan
                        if(bayarPinjaman.getDenda()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DENDA_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //debet pada cash
                            memo = "Penambahan cash dari pendapatan denda keterlambatan angsuran : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getDenda(),             
                                        bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DENDA_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari denda keterlambatan angsuran : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getDenda(), 0,             
                                    bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
                            
                            //debet pada cash
                            memo = "Penambahan cash/bank dari pendapatan denda keterlambatan angsuran";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaDendaDebetId(), 0, bayarPinjaman.getDenda(),             
                                        bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari denda keterlambatan angsuran";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaDendaCreditId(), bayarPinjaman.getDenda(), 0,             
                                    bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                            

                        }
                        
                        //=============================== jurnal pendapatan pinalti ==================================
                        
                        //jika ada biaya pinalti bukukan sebagai pendapatan
                        if(bayarPinjaman.getPinalti()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_PINALTI_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //debet pada cash
                            memo = "Penambahan cash dari pendapatan pinalti angsuran : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getPinalti(),             
                                        bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_PINALTI_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari pinalti angsuran : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getPinalti(), 0,             
                                    bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
                            
                            //debet pada cash
                            memo = "Penambahan cash dari pendapatan pinalti angsuran";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiDebetId(), 0, bayarPinjaman.getPinalti(),             
                                        bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit pendapatan
                            memo = "Penambahan pendapatan dari pinalti angsuran";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiCreditId(), bayarPinjaman.getPinalti(), 0,             
                                    bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                        }
                        
                    }
                        
                    DbGl.optimizeJournal(oid);    
                }
        }
        
        
        //POSTING ke journal - pembayaran hutang oleh member
        public static void postJournalPaymenKop(Pinjaman cr, BayarPinjaman bayarPinjaman){
                
                Company comp = DbCompany.getCompany();
                
                ExchangeRate er = DbExchangeRate.getStandardRate();
                
                Member member = new Member();
                try{
                    member = DbMember.fetchExc(cr.getMemberId());
                }
                catch(Exception e){
                }
                
                Bank bn = new Bank();
                try{
                    bn = DbBank.fetchExc(cr.getBankId());
                }
                catch(Exception e){
                    
                }
                
                String memo = "";
                if(bayarPinjaman.getType()==DbBayarPinjaman.TYPE_ANGSURAN){
                    memo = "Pembayaran angsuran ke "+bayarPinjaman.getCicilanKe();
                }
                else{
                    memo = "Pelunasan";
                }
                
                memo = memo + ", pinjaman "+((cr.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? "Koperasi" : "BANK "+bn.getName())+" oleh Koperasi - No Rekening Pinjaman : "+cr.getNumber()+", No Transaksi : "+bayarPinjaman.getNoTransaksi();
                               
                if(bayarPinjaman.getOID()!=0){
                    
                    //jurnal main
                    long oid = DbGl.postJournalMain(0, bayarPinjaman.getTanggal(), bayarPinjaman.getCounter(), bayarPinjaman.getNoTransaksi(), bayarPinjaman.getPrefixNumber(), 
                        (bayarPinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? I_Project.JOURNAL_TYPE_PEMBAYARAN_PINJAMAN_KOPERASI : I_Project.JOURNAL_TYPE_PEMBAYARAN_PINJAMAN_BANK, 
                        memo, bayarPinjaman.getUserId(), "", bayarPinjaman.getOID(), "", bayarPinjaman.getTanggal());
                    
                    //pengakuan pihutang    
                    if(oid!=0){
                        
                        memo = ""; 
                        
                        //====================== jurnal pembayaran pokok ===================
                        
                        /*Vector temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BANK_CREDIT+"'", "");
                        AccLink al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        
                        //journal debet pada cash 
                        memo = "Debit - Pemotongan pinjaman koperasi";
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getAmount(),             
                                    bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0);

                        
                        
                        //ambil coa cash acc link pinjaman
                        //sebagai debet - sebelumnya di acc link pada posisi credit - mengacu ke pinjaman (jurnal dibalik)
                        temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BANK_DEBET+"'", "");
                        al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        
                        //journal credit pada ar
                        memo = "Credit - pengurangan cash untuk pembayaran";
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getAmount(), 0,             
                                bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                        
                         */
                        
                        //journal debet pada cash 
                        memo = "Pemotongan pinjaman koperasi";
                        DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPokokDebetId(), 0, bayarPinjaman.getAmount(),             
                                    bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0);

                        //journal credit pada ar
                        memo = "Pembayaran hutang";
                        DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPokokCreditId(), bayarPinjaman.getAmount(), 0,             
                                bayarPinjaman.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                        
                         
                        
                        //=============================== jurnal pendapatan bunga koperasi ==================================
                        
                        
                        
                        //jika ada biaya bunga bukukan sebagai pengeluaran
                        if(bayarPinjaman.getBunga()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //debet pada cash
                            memo = "Debit - Penambahan biaya bunga pinjaman koperasi ke bank"; 
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getBunga(),             
                                        bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0                            
                            
                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //journal credit pendapatan
                            memo = "Credit - pengurangan cash untuk pembayaran bunga";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getBunga(), 0,             
                                    bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                             */
                            
                            //debet pada cash
                            memo = "Biaya bunga bank"; 
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaBungaDebetId(), 0, bayarPinjaman.getBunga(),             
                                        bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0                            
                            
                            //journal credit pendapatan
                            memo = "Pembayaran bunga";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaBungaCreditId(), bayarPinjaman.getBunga(), 0,             
                                    bayarPinjaman.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                            
                        }
                        
                        //=============================== jurnal pengeluaran denda koperasi ==================================
                        
                        //jika ada biaya denda bukukan sebagai biaya
                        if(bayarPinjaman.getDenda()>0){
                            
                            /*                           
                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DENDA_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //debet pada cash
                            memo = "Debit - Biaya denda keterlambatan angsuran koperasi ke bank";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getDenda(),             
                                        bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DENDA_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //journal credit pendapatan
                            memo = "Credit - Biaya denda keterlambatan angsuran koperasi ke bank";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getDenda(), 0,             
                                    bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
                            
                            //debet pada cash
                            memo = "Biaya denda";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaDendaDebetId(), 0, bayarPinjaman.getDenda(),             
                                        bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit pendapatan
                            memo = "Biaya denda";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaDendaCreditId(), bayarPinjaman.getDenda(), 0,             
                                    bayarPinjaman.getDenda(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                            

                        }
                        
                        //=============================== jurnal pendapatan pinalti ==================================
                        
                        //jika ada biaya pinalti bukukan sebagai pendapatan
                        if(bayarPinjaman.getPinalti()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_PINALTI_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //debet pada cash
                            memo = "Debit - biaya pinalti angsuran koperasi ke bank";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, bayarPinjaman.getPinalti(),             
                                        bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_PINALTI_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //journal credit pendapatan
                            memo = "Credit - biaya pinalti angsuran koperasi ke bank";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), bayarPinjaman.getPinalti(), 0,             
                                    bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                             */
                            //debet pada cash
                            memo = "Biaya pinalti";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiDebetId(), 0, bayarPinjaman.getPinalti(),             
                                        bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit pendapatan
                            memo = "Biaya pinalti";
                            DbGl.postJournalDetail(er.getValueIdr(), bayarPinjaman.getCoaPinaltiCreditId(), bayarPinjaman.getPinalti(), 0,             
                                    bayarPinjaman.getPinalti(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                        }
                        
                    }
                        
                    //optimalkan, jika akunnya sama digabung    
                    DbGl.optimizeJournal(oid);
                }
        }
        
        
        public static double getTotalPayment(long pinjamanId){
            
            String sql = "select sum(bp."+colNames[COL_AMOUNT]+") from "+DB_BAYAR_PINJAMAN+" bp "+
                " inner join "+DbPinjamanDetail.DB_PINJAMAN_DETAIL+" pd "+
                " on pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_DETAIL_ID]+
                " = bp."+colNames[COL_PINJAMAN_DETAIL_ID]+
                " where bp."+colNames[COL_PINJAMAN_ID]+"="+pinjamanId;
                
            System.out.println(sql);
            
            
            CONResultSet crs = null;
            double result = 0;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);                
            }
            
            return result;
        }
        
        
        
        public static double getTotalPaymentByMember(long memberId){
            String sql = "select sum(bp."+colNames[COL_AMOUNT]+") from "+DB_BAYAR_PINJAMAN+" bp "+
		" inner join "+DbPinjaman.DB_PINJAMAM+" p on "+
                " p."+DbPinjaman.colNames[DbPinjaman.COL_PINJAMAN_ID]+"= bp."+colNames[COL_PINJAMAN_ID]+
                " where p."+DbPinjaman.colNames[DbPinjaman.COL_STATUS]+"="+DbPinjaman.STATUS_APPROVE+
                " and bp."+colNames[COL_MEMBER_ID]+"="+memberId;
            
            CONResultSet crs = null;
            double result = 0;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);                
            }
            
            return result;
        }
        
        public static double getTotalPaymentByMember(long memberId, int jenisBarang, int jenisPinjaman){
            
            /*String sql = "select sum(bp."+colNames[COL_AMOUNT]+") from "+DB_BAYAR_PINJAMAN+" bp "+
		" inner join "+DbPinjaman.DB_PINJAMAM+" p on "+
                " p."+DbPinjaman.colNames[DbPinjaman.COL_PINJAMAN_ID]+"= bp."+colNames[COL_PINJAMAN_ID]+
                " where p."+DbPinjaman.colNames[DbPinjaman.COL_STATUS]+"="+DbPinjaman.STATUS_APPROVE+
                " and p."+DbPinjaman.colNames[DbPinjaman.COL_JENIS_BARANG]+"="+jenisBarang+
                " and bp."+colNames[COL_MEMBER_ID]+"="+memberId;
            
            CONResultSet crs = null;
            double result = 0;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);                
            }
            
            return result;
             */
            
            double result = 0;
            String where = DbPinjaman.colNames[DbPinjaman.COL_MEMBER_ID]+"="+memberId+
                " and "+DbPinjaman.colNames[DbPinjaman.COL_JENIS_BARANG]+"="+jenisBarang+
                " and "+DbPinjaman.colNames[DbPinjaman.COL_STATUS]+"="+DbPinjaman.STATUS_APPROVE;
            
            if(jenisPinjaman!=-1){
                where = where + " and "+DbPinjaman.colNames[DbPinjaman.COL_TYPE]+"="+jenisPinjaman;
            }
            
            Vector temp = DbPinjaman.list(0,0, where, "");
            if(temp!=null && temp.size()>0){
                for(int i=0; i<temp.size(); i++){
                    Pinjaman p = (Pinjaman)temp.get(i);
                    result = result + DbBayarPinjaman.getTotalPayment(p.getOID());
                }
            }
            
            return result;
            
        }
        
        
        public static void insertAndPostPaymentAuto(Pinjaman pinjaman, PinjamanDetail pd){
            
            BayarPinjaman bp = new BayarPinjaman();
            bp.setPinjamanId(pinjaman.getOID());
            bp.setPinjamanDetailId(pd.getOID());
            bp.setCicilanKe(pd.getCicilanKe());
            bp.setCounter(getNextCounter(pinjaman.getType()));
            bp.setPrefixNumber(getNumberPrefix(pinjaman.getType()));
            bp.setNoTransaksi(getNextNumber(bp.getCounter(), pinjaman.getType()));
            bp.setMemberId(pinjaman.getMemberId());
            bp.setTanggal(pd.getJatuhTempo());
            bp.setUserId(pinjaman.getUserId());
            bp.setType(DbBayarPinjaman.TYPE_ANGSURAN);
            bp.setTypePinjaman(pinjaman.getType());
            
            bp.setAmount(pd.getAmount());
            bp.setBunga(pd.getBunga());
            bp.setDenda(0);
            
            //get system property
            long spCoaPokokDebet = 0;
            long spCoaPokokCredit = 0;
            long spCoaBungaDebet = 0;
            long spCoaBungaCredit = 0;
            
            if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
                Coa coa = new Coa();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_ANG_PAY_POKOK_DEBET"));
                spCoaPokokDebet = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_ANG_PAY_POKOK_CREDIT"));
                spCoaPokokCredit = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_ANG_PAY_BUNGA_DEBET"));
                spCoaBungaDebet = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_ANG_PAY_BUNGA_CREDIT"));
                spCoaBungaCredit = coa.getOID();                    
            }else{		
                Coa coa = new Coa();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_KOP_POKOK_DEBET"));
                spCoaPokokDebet = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_KOP_POKOK_CREDIT"));
                spCoaPokokCredit = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_KOP_BUNGA_DEBET"));
                spCoaBungaDebet = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_KOP_BUNGA_CREDIT"));
                spCoaBungaCredit = coa.getOID();
            }
            
            bp.setCoaPokokCreditId(spCoaPokokCredit);
            bp.setCoaPokokDebetId(spCoaPokokDebet);
            bp.setCoaBungaCreditId(spCoaBungaCredit);
            bp.setCoaBungaDebetId(spCoaBungaDebet);
            
            bp.setCoaDendaCreditId(0);
            bp.setCoaDendaDebetId(0);
            bp.setCoaPinaltiCreditId(0);
            bp.setCoaPinaltiDebetId(0);
            
            
            try{
                long oidx = insertExc(bp);
                
                if(oidx!=0){
                    if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
			DbBayarPinjaman.postJournal(pinjaman, bp);
                    }else{		
                        DbBayarPinjaman.postJournalPaymenKop(pinjaman, bp);
                    }
                }
                
            }
            catch(Exception e){
            }                        
            
        }
        
        public static void insertAndPostPaymentAutoWOJurnal(Pinjaman pinjaman, PinjamanDetail pd){
            
            BayarPinjaman bp = new BayarPinjaman();
            bp.setPinjamanId(pinjaman.getOID());
            bp.setPinjamanDetailId(pd.getOID());
            bp.setCicilanKe(pd.getCicilanKe());
            bp.setCounter(getNextCounter(pinjaman.getType()));
            bp.setPrefixNumber(getNumberPrefix(pinjaman.getType()));
            bp.setNoTransaksi(getNextNumber(bp.getCounter(), pinjaman.getType()));
            bp.setMemberId(pinjaman.getMemberId());
            bp.setTanggal(pd.getJatuhTempo());
            bp.setUserId(pinjaman.getUserId());
            bp.setType(DbBayarPinjaman.TYPE_ANGSURAN);
            bp.setTypePinjaman(pinjaman.getType());
            
            bp.setAmount(pd.getAmount());
            bp.setBunga(pd.getBunga());
            bp.setDenda(0);
            
            //get system property
            long spCoaPokokDebet = 0;
            long spCoaPokokCredit = 0;
            long spCoaBungaDebet = 0;
            long spCoaBungaCredit = 0;
            
            if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
                Coa coa = new Coa();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_ANG_PAY_POKOK_DEBET"));
                spCoaPokokDebet = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_ANG_PAY_POKOK_CREDIT"));
                spCoaPokokCredit = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_ANG_PAY_BUNGA_DEBET"));
                spCoaBungaDebet = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_ANG_PAY_BUNGA_CREDIT"));
                spCoaBungaCredit = coa.getOID();                    
            }else{		
                Coa coa = new Coa();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_KOP_POKOK_DEBET"));
                spCoaPokokDebet = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_KOP_POKOK_CREDIT"));
                spCoaPokokCredit = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_KOP_BUNGA_DEBET"));
                spCoaBungaDebet = coa.getOID();
                coa = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("XSP_KOP_BUNGA_CREDIT"));
                spCoaBungaCredit = coa.getOID();
            }
            
            bp.setCoaPokokCreditId(spCoaPokokCredit);
            bp.setCoaPokokDebetId(spCoaPokokDebet);
            bp.setCoaBungaCreditId(spCoaBungaCredit);
            bp.setCoaBungaDebetId(spCoaBungaDebet);
            
            bp.setCoaDendaCreditId(0);
            bp.setCoaDendaDebetId(0);
            bp.setCoaPinaltiCreditId(0);
            bp.setCoaPinaltiDebetId(0);
            
            
            try{
                long oidx = insertExc(bp);
                
                /*if(oidx!=0){
                    if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
			DbBayarPinjaman.postJournal(pinjaman, bp);
                    }else{		
                        DbBayarPinjaman.postJournalPaymenKop(pinjaman, bp);
                    }
                }
                 */
                
            }
            catch(Exception e){
            }                        
            
        }
        
        public static Vector getPembayaran(int type, int jenisBarang, long periodId, String nama, String no, int order){
            
            String sql = "select bp.* from "+DB_BAYAR_PINJAMAN+" bp "+
                        " inner join "+DbGl.DB_GL+" g on g."+DbGl.colNames[DbGl.COL_OWNER_ID]+
                        " =bp."+colNames[COL_BAYAR_PINJAMAN_ID]+                        
                        " inner join "+DbPinjaman.DB_PINJAMAM+" p on p."+DbPinjaman.colNames[DbPinjaman.COL_PINJAMAN_ID]+
                        " =bp."+colNames[COL_PINJAMAN_ID]+
                        " inner join "+DbMember.DB_MEMBER+" m on m."+DbMember.colNames[DbMember.COL_MEMBER_ID]+
                        " =bp."+colNames[COL_MEMBER_ID]+
                        " where g."+DbGl.colNames[DbGl.COL_PERIOD_ID]+"="+periodId;
            
                        if(type>-1){
                            sql = sql + " and p."+DbPinjaman.colNames[DbPinjaman.COL_TYPE]+"="+type;
                        }
            
                        if(jenisBarang>-1){
                            sql = sql + " and p."+DbPinjaman.colNames[DbPinjaman.COL_JENIS_BARANG]+"="+jenisBarang;
                        }
            
                        if(nama!=null && nama.length()>0){
                            sql = sql + " and m."+DbMember.colNames[DbMember.COL_NAMA]+" like '%"+nama+"%'";
                        }
            
                        if(no!=null && no.length()>0){
                            sql = sql + " and m."+DbMember.colNames[DbMember.COL_NO_MEMBER]+" like '%"+no+"%'";
                        }
                        
                        if(order==0){
                            sql = sql + " order by bp."+colNames[COL_TANGGAL];
                        }
                        else if(order==1){
                            sql = sql + " order by m."+DbMember.colNames[DbMember.COL_NAMA];
                        }
                        else{
                            sql = sql + " order by m."+DbMember.colNames[DbMember.COL_NO_MEMBER];
                        }
                       
            System.out.println(sql);
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    BayarPinjaman bp = new BayarPinjaman();
                    DbBayarPinjaman.resultToObject(rs,  bp);
                    result.add(bp);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        
}
