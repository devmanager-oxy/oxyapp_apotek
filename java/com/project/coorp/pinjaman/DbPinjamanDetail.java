
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
import com.project.util.*;

public class DbPinjamanDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_PINJAMAN_DETAIL = "sp_pinjaman_detail";

	public static final  int COL_MEMBER_ID = 0;
	public static final  int COL_PINJAMAN_ID = 1;
	public static final  int COL_PINJAMAN_DETAIL_ID = 2;
	public static final  int COL_AMOUNT = 3;
	public static final  int COL_BUNGA = 4;
	public static final  int COL_CICILAN_KE = 5;
	public static final  int COL_JATUH_TEMPO = 6;
	public static final  int COL_STATUS = 7;
        
        public static final  int COL_BUNGA_BANK = 8;
        public static final  int COL_TOTAL_KOPERASI = 9;
        public static final  int COL_TOTAL_BANK = 10;
        
        public static final  int COL_AMOUNT_BANK = 11;
        public static final  int COL_SALDO_BANK = 12;
        public static final  int COL_SALDO_KOPERASI = 13;
        public static final  int COL_BUNGA_BANK_PERCENT = 14;
        public static final  int COL_BUNGA_KOPERASI_PERCENT = 15;
        

	public static final  String[] colNames = {
		"member_id",
                "pinjaman_id",
                "pinjaman_detail_id",
                "amount",
                "bunga",
                "cicilan_ke",
                "jatuh_tempo",
                "status",
                
                "bunga_bank",
                "total_koperasi",
                "total_bank",
                
                "amount_bank",
                "saldo_bank",
                "saldo_koperasi",
                "bunga_bank_percent",
                "bunga_koperasi_percent"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_DATE,
		TYPE_INT,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT
               
	 }; 

	public DbPinjamanDetail(){
	}

	public DbPinjamanDetail(int i) throws CONException { 
		super(new DbPinjamanDetail()); 
	}

	public DbPinjamanDetail(String sOid) throws CONException { 
		super(new DbPinjamanDetail(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPinjamanDetail(long lOid) throws CONException { 
		super(new DbPinjamanDetail(0)); 
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
		return DB_PINJAMAN_DETAIL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPinjamanDetail().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PinjamanDetail pinjamandetail = fetchExc(ent.getOID()); 
		ent = (Entity)pinjamandetail; 
		return pinjamandetail.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PinjamanDetail) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PinjamanDetail) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PinjamanDetail fetchExc(long oid) throws CONException{ 
		try{ 
			PinjamanDetail pinjamandetail = new PinjamanDetail();
			DbPinjamanDetail pstPinjamanDetail = new DbPinjamanDetail(oid); 
			pinjamandetail.setOID(oid);

			pinjamandetail.setMemberId(pstPinjamanDetail.getlong(COL_MEMBER_ID));
			pinjamandetail.setPinjamanId(pstPinjamanDetail.getlong(COL_PINJAMAN_ID));
			pinjamandetail.setAmount(pstPinjamanDetail.getdouble(COL_AMOUNT));
			pinjamandetail.setBunga(pstPinjamanDetail.getdouble(COL_BUNGA));
			pinjamandetail.setCicilanKe(pstPinjamanDetail.getInt(COL_CICILAN_KE));
			pinjamandetail.setJatuhTempo(pstPinjamanDetail.getDate(COL_JATUH_TEMPO));
			pinjamandetail.setStatus(pstPinjamanDetail.getInt(COL_STATUS));
                        
                        pinjamandetail.setBungaBank(pstPinjamanDetail.getdouble(COL_BUNGA_BANK));
                        pinjamandetail.setTotalKoperasi(pstPinjamanDetail.getdouble(COL_TOTAL_KOPERASI));
                        pinjamandetail.setTotalBank(pstPinjamanDetail.getdouble(COL_TOTAL_BANK));
                        
                        pinjamandetail.setAmountBank(pstPinjamanDetail.getdouble(COL_AMOUNT_BANK));
                        pinjamandetail.setSaldoBank(pstPinjamanDetail.getdouble(COL_SALDO_BANK));
                        pinjamandetail.setSaldoKoperasi(pstPinjamanDetail.getdouble(COL_SALDO_KOPERASI));
                        pinjamandetail.setBungaBankPercent(pstPinjamanDetail.getdouble(COL_BUNGA_BANK_PERCENT));
                        pinjamandetail.setBungaKoperasiPercent(pstPinjamanDetail.getdouble(COL_BUNGA_KOPERASI_PERCENT));

			return pinjamandetail; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPinjamanDetail(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PinjamanDetail pinjamandetail) throws CONException{ 
		try{ 
			DbPinjamanDetail pstPinjamanDetail = new DbPinjamanDetail(0);

			pstPinjamanDetail.setLong(COL_MEMBER_ID, pinjamandetail.getMemberId());
			pstPinjamanDetail.setLong(COL_PINJAMAN_ID, pinjamandetail.getPinjamanId());
			pstPinjamanDetail.setDouble(COL_AMOUNT, pinjamandetail.getAmount());
			pstPinjamanDetail.setDouble(COL_BUNGA, pinjamandetail.getBunga());
			pstPinjamanDetail.setInt(COL_CICILAN_KE, pinjamandetail.getCicilanKe());
			pstPinjamanDetail.setDate(COL_JATUH_TEMPO, pinjamandetail.getJatuhTempo());
			pstPinjamanDetail.setInt(COL_STATUS, pinjamandetail.getStatus());
                        
                        pstPinjamanDetail.setDouble(COL_BUNGA_BANK, pinjamandetail.getBungaBank());
                        pstPinjamanDetail.setDouble(COL_TOTAL_KOPERASI, pinjamandetail.getTotalKoperasi());
                        pstPinjamanDetail.setDouble(COL_TOTAL_BANK, pinjamandetail.getTotalBank());
                        
                        pstPinjamanDetail.setDouble(COL_AMOUNT_BANK, pinjamandetail.getAmountBank());
                        pstPinjamanDetail.setDouble(COL_SALDO_BANK, pinjamandetail.getSaldoBank());
                        pstPinjamanDetail.setDouble(COL_SALDO_KOPERASI, pinjamandetail.getSaldoKoperasi());
                        pstPinjamanDetail.setDouble(COL_BUNGA_BANK_PERCENT, pinjamandetail.getBungaBankPercent());
                        pstPinjamanDetail.setDouble(COL_BUNGA_KOPERASI_PERCENT, pinjamandetail.getBungaKoperasiPercent());

			pstPinjamanDetail.insert(); 
			pinjamandetail.setOID(pstPinjamanDetail.getlong(COL_PINJAMAN_DETAIL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPinjamanDetail(0),CONException.UNKNOWN); 
		}
		return pinjamandetail.getOID();
	}

	public static long updateExc(PinjamanDetail pinjamandetail) throws CONException{ 
		try{ 
			if(pinjamandetail.getOID() != 0){ 
				DbPinjamanDetail pstPinjamanDetail = new DbPinjamanDetail(pinjamandetail.getOID());

				pstPinjamanDetail.setLong(COL_MEMBER_ID, pinjamandetail.getMemberId());
				pstPinjamanDetail.setLong(COL_PINJAMAN_ID, pinjamandetail.getPinjamanId());
				pstPinjamanDetail.setDouble(COL_AMOUNT, pinjamandetail.getAmount());
				pstPinjamanDetail.setDouble(COL_BUNGA, pinjamandetail.getBunga());
				pstPinjamanDetail.setInt(COL_CICILAN_KE, pinjamandetail.getCicilanKe());
				pstPinjamanDetail.setDate(COL_JATUH_TEMPO, pinjamandetail.getJatuhTempo());
				pstPinjamanDetail.setInt(COL_STATUS, pinjamandetail.getStatus());
                                
                                pstPinjamanDetail.setDouble(COL_BUNGA_BANK, pinjamandetail.getBungaBank());
                                pstPinjamanDetail.setDouble(COL_TOTAL_KOPERASI, pinjamandetail.getTotalKoperasi());
                                pstPinjamanDetail.setDouble(COL_TOTAL_BANK, pinjamandetail.getTotalBank());
                                
                                pstPinjamanDetail.setDouble(COL_AMOUNT_BANK, pinjamandetail.getAmountBank());
                                pstPinjamanDetail.setDouble(COL_SALDO_BANK, pinjamandetail.getSaldoBank());
                                pstPinjamanDetail.setDouble(COL_SALDO_KOPERASI, pinjamandetail.getSaldoKoperasi());
                                pstPinjamanDetail.setDouble(COL_BUNGA_BANK_PERCENT, pinjamandetail.getBungaBankPercent());
                                pstPinjamanDetail.setDouble(COL_BUNGA_KOPERASI_PERCENT, pinjamandetail.getBungaKoperasiPercent());

				pstPinjamanDetail.update(); 
				return pinjamandetail.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPinjamanDetail(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPinjamanDetail pstPinjamanDetail = new DbPinjamanDetail(oid);
			pstPinjamanDetail.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPinjamanDetail(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PINJAMAN_DETAIL; 
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
				PinjamanDetail pinjamandetail = new PinjamanDetail();
				resultToObject(rs, pinjamandetail);
				lists.add(pinjamandetail);
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

	public static void resultToObject(ResultSet rs, PinjamanDetail pinjamandetail){
		try{
			pinjamandetail.setOID(rs.getLong(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_DETAIL_ID]));
			pinjamandetail.setMemberId(rs.getLong(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_MEMBER_ID]));
			pinjamandetail.setPinjamanId(rs.getLong(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_ID]));
			pinjamandetail.setAmount(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_AMOUNT]));
			pinjamandetail.setBunga(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_BUNGA]));
			pinjamandetail.setCicilanKe(rs.getInt(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_CICILAN_KE]));
			pinjamandetail.setJatuhTempo(rs.getDate(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_JATUH_TEMPO]));
			pinjamandetail.setStatus(rs.getInt(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_STATUS]));
                        
                        pinjamandetail.setBungaBank(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_BUNGA_BANK]));
                        pinjamandetail.setTotalKoperasi(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_TOTAL_KOPERASI]));
                        pinjamandetail.setTotalBank(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_TOTAL_BANK]));
                        
                        pinjamandetail.setAmountBank(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_AMOUNT_BANK]));
                        pinjamandetail.setSaldoBank(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_SALDO_BANK]));
                        pinjamandetail.setSaldoKoperasi(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_SALDO_KOPERASI]));
                        pinjamandetail.setBungaBankPercent(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_BUNGA_BANK_PERCENT]));
                        pinjamandetail.setBungaKoperasiPercent(rs.getDouble(DbPinjamanDetail.colNames[DbPinjamanDetail.COL_BUNGA_KOPERASI_PERCENT]));

		}catch(Exception e){ }
	}

	
	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_DETAIL_ID] + ") FROM " + DB_PINJAMAN_DETAIL;
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
			  	   PinjamanDetail pinjamandetail = (PinjamanDetail)list.get(ls);
				   if(oid == pinjamandetail.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static void setupDetailPinjaman(Pinjaman pinjaman){
            
            //delete detail dulu
            try{
                CONHandler.execUpdate("delete from "+DB_PINJAMAN_DETAIL+" where "+colNames[COL_PINJAMAN_ID]+"="+pinjaman.getOID());
            }
            catch(Exception e){
            }
            
            Date jatuhTempo = pinjaman.getDate();//new Date();
            jatuhTempo.setMonth(jatuhTempo.getMonth()+1);
            jatuhTempo.setDate(pinjaman.getTanggalJatuhTempo());
            
            double saldo = pinjaman.getTotalPinjaman();
            
            int angsuranTerbayar = pinjaman.getAngsuranTerakhir();
            
            if(pinjaman.getOID()!=0){
                for(int i=0; i<pinjaman.getLamaCicilan(); i++){                    
                    
                    PinjamanDetail pd = new PinjamanDetail();
                    pd.setMemberId(pinjaman.getMemberId());
                    pd.setPinjamanId(pinjaman.getOID());
                    pd.setAmount(pinjaman.getTotalPinjaman()/pinjaman.getLamaCicilan());
                    //pd.setBunga(((pinjaman.getTotalPinjaman()/pinjaman.getLamaCicilan())*pinjaman.getBunga())/100);
                    pd.setBunga(((pinjaman.getTotalPinjaman())*pinjaman.getBunga())/100);
                    pd.setTotalKoperasi(pd.getAmount()+pd.getBunga());
                    pd.setSaldoKoperasi(saldo - pd.getAmount());
                    
                    saldo = saldo - pd.getAmount();
                    
                    if(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_BANK){
                        pd.setBungaBank(((pinjaman.getTotalPinjaman()/pinjaman.getLamaCicilan())*pinjaman.getBungaBank())/100);
                        pd.setTotalBank(pd.getAmount()+pd.getBungaBank());
                    }
                    pd.setCicilanKe(i+1);
                    pd.setJatuhTempo(jatuhTempo);
                    
                    //proses untuk data awal
                    if(angsuranTerbayar>0){
                        if(i<angsuranTerbayar){
                            pd.setStatus(DbPinjaman.PAYMENT_STATUS_LUNAS);
                        }
                    }
                    
                    try{
                        long oidx = DbPinjamanDetail.insertExc(pd);
                        
                        //jika sudah terbayar buatkan paymentnya
                        if(oidx!=0 && pd.getStatus()==DbPinjaman.PAYMENT_STATUS_LUNAS){
                            DbBayarPinjaman.insertAndPostPaymentAuto(pinjaman, pd);
                        }  
                    }
                    catch(Exception e){
                    }
                    
                    jatuhTempo = (Date)jatuhTempo.clone();
                    jatuhTempo.setMonth(jatuhTempo.getMonth()+1);                    
                }                    
            }        
        }
        
        public static void setupDetailPinjamanWOJurnal(Pinjaman pinjaman){
            
            //delete gl detail
            String sql = "delete from gl_detail where gl_id in (select gl_id from gl where owner_id in (select bayar_pinjaman_id from sp_bayar_pinjaman where pinjaman_id="+pinjaman.getOID()+"))";
            try{
                CONHandler.execUpdate(sql);
            }
            catch(Exception e){
            }
            
            //delete gl 
            sql = "delete from gl where owner_id in (select bayar_pinjaman_id from sp_bayar_pinjaman where pinjaman_id="+pinjaman.getOID()+")";
            try{
                CONHandler.execUpdate(sql);
            }
            catch(Exception e){
            }
            
            //delete bayar pinjaman 
            sql = "delete from sp_bayar_pinjaman where pinjaman_id="+pinjaman.getOID();
            try{
                CONHandler.execUpdate(sql);
            }
            catch(Exception e){
            }
            
            //delete detail 
            try{
                CONHandler.execUpdate("delete from "+DB_PINJAMAN_DETAIL+" where "+colNames[COL_PINJAMAN_ID]+"="+pinjaman.getOID());
            }
            catch(Exception e){
            }
            
            Date jatuhTempo = pinjaman.getDate();//new Date();
            jatuhTempo.setMonth(jatuhTempo.getMonth()+1);
            jatuhTempo.setDate(pinjaman.getTanggalJatuhTempo());
            
            double saldo = pinjaman.getTotalPinjaman();
            
            int angsuranTerbayar = pinjaman.getAngsuranTerakhir();
            
            if(pinjaman.getOID()!=0){
                for(int i=0; i<pinjaman.getLamaCicilan(); i++){                    
                    
                    PinjamanDetail pd = new PinjamanDetail();
                    pd.setMemberId(pinjaman.getMemberId());
                    pd.setPinjamanId(pinjaman.getOID());
                    pd.setAmount(pinjaman.getTotalPinjaman()/pinjaman.getLamaCicilan());
                    //pd.setBunga(((pinjaman.getTotalPinjaman()/pinjaman.getLamaCicilan())*pinjaman.getBunga())/100);
                    pd.setBunga(((pinjaman.getTotalPinjaman())*pinjaman.getBunga())/100);
                    pd.setTotalKoperasi(pd.getAmount()+pd.getBunga());
                    pd.setSaldoKoperasi(saldo - pd.getAmount());
                    
                    saldo = saldo - pd.getAmount();
                    
                    if(pinjaman.getType()==DbPinjaman.TYPE_PINJAMAN_BANK){
                        pd.setBungaBank(((pinjaman.getTotalPinjaman()/pinjaman.getLamaCicilan())*pinjaman.getBungaBank())/100);
                        pd.setTotalBank(pd.getAmount()+pd.getBungaBank());
                    }
                    pd.setCicilanKe(i+1);
                    pd.setJatuhTempo(jatuhTempo);
                    
                    //proses untuk data awal
                    if(angsuranTerbayar>0){
                        if(i<angsuranTerbayar){
                            pd.setStatus(DbPinjaman.PAYMENT_STATUS_LUNAS);
                        }
                    }
                    
                    try{
                        long oidx = DbPinjamanDetail.insertExc(pd);
                        
                        //jika sudah terbayar buatkan paymentnya
                        if(oidx!=0 && pd.getStatus()==DbPinjaman.PAYMENT_STATUS_LUNAS){
                            DbBayarPinjaman.insertAndPostPaymentAutoWOJurnal(pinjaman, pd); 
                        }  
                    }
                    catch(Exception e){
                    }
                    
                    jatuhTempo = (Date)jatuhTempo.clone();
                    jatuhTempo.setMonth(jatuhTempo.getMonth()+1);                    
                }                    
            }        
        }
        
        
        public static void setupDetailPinjamanAnuitas(Pinjaman pinjaman){
            
            //delete detail dulu
            try{
                CONHandler.execUpdate("delete from "+DB_PINJAMAN_DETAIL+" where "+colNames[COL_PINJAMAN_ID]+"="+pinjaman.getOID());
            }
            catch(Exception e){
            }
            
            double bungaKoperasiBulan = pinjaman.getBunga()/12;
            double bungaBankBulan = 0;
            //jika bukan pinjaman koperasi ke bank set bunganya sama
            if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
                bungaBankBulan = pinjaman.getBungaBank()/12;
            }
            else{
                bungaBankBulan = bungaKoperasiBulan;
            }
            
            double cicilanKoperasi = 0;
            if(pinjaman.getBunga()>0){
                double x = Math.pow(1/(1+(bungaKoperasiBulan/100)),(pinjaman.getLamaCicilan()));
                double y = ((1-x))/(bungaKoperasiBulan/100);
                cicilanKoperasi = pinjaman.getTotalPinjaman()/y;
            }
            
            System.out.println("cicilanKoperasi : "+cicilanKoperasi);
            
            double cicilanBank = 0;
            if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
                if(pinjaman.getBungaBank()>0){
                    double x = Math.pow(1/(1+(bungaBankBulan/100)),(pinjaman.getLamaCicilan()));
                    double y = ((1-x))/(bungaBankBulan/100);
                    cicilanBank = pinjaman.getTotalPinjaman()/y;
                }
            }
            //jika pinjaman koperasi ke bank
            //set cicilan banknya sama denga koperasi
            else{
                cicilanBank = cicilanKoperasi;
            }
            
            System.out.println("cicilanBank : "+cicilanBank);
            
            
            Date jatuhTempo = pinjaman.getDate();//new Date();
            jatuhTempo.setMonth(jatuhTempo.getMonth()+1);
            jatuhTempo.setDate(pinjaman.getTanggalJatuhTempo());
            
            double saldoKop = pinjaman.getTotalPinjaman();
            double saldoBank = pinjaman.getTotalPinjaman();
            
            int angsuranTerbayar = pinjaman.getAngsuranTerakhir();
            
            if(pinjaman.getOID()!=0){
                
                for(int i=0; i<pinjaman.getLamaCicilan(); i++){                    
                    
                    PinjamanDetail pd = new PinjamanDetail();
                    pd.setMemberId(pinjaman.getMemberId());
                    pd.setPinjamanId(pinjaman.getOID());
                    
                    //member ke koperasi
                    pd.setTotalKoperasi(cicilanKoperasi);
                    pd.setBunga(saldoKop * (bungaKoperasiBulan/100));                    
                    pd.setAmount(cicilanKoperasi - pd.getBunga());                    
                    pd.setSaldoKoperasi(saldoKop - pd.getAmount());
                    pd.setBungaKoperasiPercent(bungaKoperasiBulan);
                    
                    saldoKop = pd.getSaldoKoperasi();
                    
                    //member ke bank
                    pd.setTotalBank(cicilanBank);
                    pd.setBungaBank(saldoBank * (bungaBankBulan/100));                    
                    pd.setAmountBank(cicilanBank - pd.getBungaBank());                    
                    pd.setSaldoBank(saldoBank - pd.getAmountBank());
                    pd.setBungaBankPercent(bungaBankBulan);
                    
                    saldoBank = pd.getSaldoBank();
                    
                    pd.setCicilanKe(i+1);
                    pd.setJatuhTempo(jatuhTempo);
                    
                    //proses untuk data awal
                    if(angsuranTerbayar>0){
                        if(i<angsuranTerbayar){
                            pd.setStatus(DbPinjaman.PAYMENT_STATUS_LUNAS);
                        }
                    }
                    
                    try{
                        
                        long oidx = DbPinjamanDetail.insertExc(pd);
                        
                        //jika sudah terbayar buatkan paymentnya
                        if(oidx!=0 && pd.getStatus()==DbPinjaman.PAYMENT_STATUS_LUNAS){
                            DbBayarPinjaman.insertAndPostPaymentAuto(pinjaman, pd);
                        }  
                    }
                    catch(Exception e){
                    }
                    
                                      
                    
                    jatuhTempo = (Date)jatuhTempo.clone();
                    jatuhTempo.setMonth(jatuhTempo.getMonth()+1);                    
                }                    
            }        
        }
        
        
        public static void updateDetailPinjamanAnuitas(PinjamanDetail pinjamanDetail, double bungaKoperasi, double bungaBank){
            
            //delete detail dulu
            String where = colNames[COL_CICILAN_KE]+"="+(pinjamanDetail.getCicilanKe()-1)+
                " and "+colNames[COL_PINJAMAN_ID]+"="+pinjamanDetail.getPinjamanId();
            
            System.out.println("\n\n>>>> =================\nwhere : "+where);
            
            Vector temp = list(0,0, where, "");
            PinjamanDetail pdx = new PinjamanDetail();
            if(temp!=null && temp.size()>0){
                pdx = (PinjamanDetail)temp.get(0);               
            }
            
            System.out.println("prev detail : "+pdx.getOID()+", cicilan ke : "+pdx.getCicilanKe());
            
            Pinjaman pinjaman = new Pinjaman();            
            pinjaman.setOID(pinjamanDetail.getPinjamanId());
            
            try{
                pinjaman = DbPinjaman.fetchExc(pinjaman.getOID());
            }
            catch(Exception e){
            }
            
            pinjaman.setBunga(bungaKoperasi);
            pinjaman.setBungaBank(bungaBank);
            pinjaman.setTotalPinjaman(pdx.getSaldoKoperasi());
            
            double bungaKoperasiBulan = pinjaman.getBunga()/12;
            double bungaBankBulan = 0;
            //jika pinjaman koperasi ke bank, set bunga banknya sama
            if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
                bungaBankBulan = pinjaman.getBungaBank()/12;
            }
            else{
                pinjaman.setBungaBank(bungaKoperasi);
                bungaBankBulan = bungaKoperasiBulan;
            }
            
            //besar angsuran - tetap
            double cicilanKoperasi = 0;
            if(pinjaman.getBunga()>0){
                double x = Math.pow(1/(1+(bungaKoperasiBulan/100)),(pinjaman.getLamaCicilan()-pdx.getCicilanKe()));
                double y = ((1-x))/(bungaKoperasiBulan/100);
                cicilanKoperasi = pdx.getSaldoKoperasi()/y;
            }
                
            double cicilanBank = 0;//pdx.getTotalBank();
            if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
                if(pinjaman.getBungaBank()>0){
                    double x = Math.pow(1/(1+(bungaBankBulan/100)),(pinjaman.getLamaCicilan()-pdx.getCicilanKe()));
                    double y = ((1-x))/(bungaBankBulan/100);
                    cicilanBank = pdx.getSaldoBank()/y;
                }
            }
            else{
                cicilanBank = cicilanKoperasi;
            }
            
            System.out.println("\n\n=================================================\ncicilanKoperasi : "+cicilanKoperasi);
            
            System.out.println("\npinjaman : "+pinjaman.getOID()+", pinjamanDetail : "+pinjamanDetail.getOID()+", bungaKoperasi : "+bungaKoperasi+", bungaBank : "+bungaBank);
            
            System.out.println("\ncicilanKoperasi : "+cicilanKoperasi);
            System.out.println("\ncicilanBank : "+cicilanBank);
            System.out.println("\npdx index : "+pdx.getCicilanKe());
            
            try{
                CONHandler.execUpdate("delete from "+DB_PINJAMAN_DETAIL+" where "+colNames[COL_PINJAMAN_ID]+"="+pinjaman.getOID()+" and "+colNames[COL_CICILAN_KE]+">="+pinjamanDetail.getCicilanKe());
            }
            catch(Exception e){
            }
            
            
            Date jatuhTempo = new Date();
            jatuhTempo.setMonth(jatuhTempo.getMonth()+1);
            jatuhTempo.setDate(pinjaman.getTanggalJatuhTempo());
            
            double saldoKop = pdx.getSaldoKoperasi();
            double saldoBank = pdx.getSaldoBank();
            
            System.out.println("\nsaldoKop : "+saldoKop);
            System.out.println("\nsaldoBank : "+saldoBank);
            
            if(pinjamanDetail.getOID()!=0){
                
                //int i = pdx.getCicilanKe();
                
                jatuhTempo = pinjamanDetail.getJatuhTempo();
                
                //while(saldoKop>0 && saldoBank>0){                    
                for(int i=pdx.getCicilanKe(); i<pinjaman.getLamaCicilan(); i++){
                //while(i<25){                    
                    
                    PinjamanDetail pd = new PinjamanDetail();
                    pd.setMemberId(pinjaman.getMemberId());
                    pd.setPinjamanId(pinjaman.getOID());
                    
                    //member ke koperasi
                    pd.setTotalKoperasi(cicilanKoperasi);
                    pd.setBunga(saldoKop * (bungaKoperasiBulan/100));                    
                    pd.setAmount(cicilanKoperasi - pd.getBunga());                    
                    pd.setSaldoKoperasi(saldoKop - pd.getAmount());
                    pd.setBungaKoperasiPercent(bungaKoperasiBulan);
                    
                    saldoKop = pd.getSaldoKoperasi();
                    
                    //member ke bank
                    pd.setTotalBank(cicilanBank);
                    pd.setBungaBank(saldoBank * (bungaBankBulan/100));                    
                    pd.setAmountBank(cicilanBank - pd.getBungaBank());                    
                    pd.setSaldoBank(saldoBank - pd.getAmountBank());
                    pd.setBungaBankPercent(bungaBankBulan);
                    
                    saldoBank = pd.getSaldoBank();
                    
                    pd.setCicilanKe(i+1);
                    
                    //i = i + 1;
                    
                    pd.setJatuhTempo(jatuhTempo);
                    try{
                        DbPinjamanDetail.insertExc(pd);
                    }
                    catch(Exception e){
                    }
                    
                    jatuhTempo = (Date)jatuhTempo.clone();
                    jatuhTempo.setMonth(jatuhTempo.getMonth()+1);                    
                }                    
            }        
        }
        
        
        public static void updateDetailPinjamanTetapByPayment(PinjamanDetail pinjamanDetail, double bungaKoperasi, double bungaBank){
            
            //delete detail sebelumnya
            String where = colNames[COL_CICILAN_KE]+"="+(pinjamanDetail.getCicilanKe()-1)+
                " and "+colNames[COL_PINJAMAN_ID]+"="+pinjamanDetail.getPinjamanId();
            
            System.out.println("\n\n>>>> =================\nwhere : "+where);
            
            Vector temp = list(0,0, where, "");
            PinjamanDetail pdx = new PinjamanDetail();
            if(temp!=null && temp.size()>0){
                pdx = (PinjamanDetail)temp.get(0);               
            }
            
            System.out.println("prev detail : "+pdx.getOID()+", cicilan ke : "+pdx.getCicilanKe());
            
            //ambil pinjaman
            Pinjaman pinjaman = new Pinjaman();            
            pinjaman.setOID(pinjamanDetail.getPinjamanId());
            
            try{
                pinjaman = DbPinjaman.fetchExc(pinjaman.getOID());
            }
            catch(Exception e){
            }
            
            pinjaman.setBunga(bungaKoperasi);
            pinjaman.setBungaBank(bungaBank);
            pinjaman.setTotalPinjaman(pdx.getSaldoKoperasi());
            
            double bungaKoperasiBulan = pinjaman.getBunga();///12;
            double bungaBankBulan = pinjaman.getBungaBank();
            //jika pinjaman koperasi ke bank, set bunga banknya sama
            /*if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
                bungaBankBulan = pinjaman.getBungaBank()/12;
            }
            else{
                pinjaman.setBungaBank(bungaKoperasi);
                bungaBankBulan = bungaKoperasiBulan;
            }
             */
            
            //besar angsuran - tetap
            double cicilanKoperasi = pdx.getSaldoKoperasi()/(pinjaman.getLamaCicilan()-pdx.getCicilanKe());
            
            /*if(pinjaman.getBunga()>0){
                double x = Math.pow(1/(1+(bungaKoperasiBulan/100)),(pinjaman.getLamaCicilan()-pdx.getCicilanKe()));
                double y = ((1-x))/(bungaKoperasiBulan/100);
                cicilanKoperasi = pdx.getSaldoKoperasi()/y;
            }
             */
                
            double cicilanBank = 0;//pdx.getTotalBank();
            if(bungaBank>0){
                
            }
            
            if(pinjaman.getType()!=DbPinjaman.TYPE_PINJAMAN_KOPERASI_KE_BANK){
                if(pinjaman.getBungaBank()>0){
                    double x = Math.pow(1/(1+(bungaBankBulan/100)),(pinjaman.getLamaCicilan()-pdx.getCicilanKe()));
                    double y = ((1-x))/(bungaBankBulan/100);
                    cicilanBank = pdx.getSaldoBank()/y;
                }
            }
            else{
                cicilanBank = cicilanKoperasi;
            }
            
            System.out.println("\n\n=================================================\ncicilanKoperasi : "+cicilanKoperasi);
            
            System.out.println("\npinjaman : "+pinjaman.getOID()+", pinjamanDetail : "+pinjamanDetail.getOID()+", bungaKoperasi : "+bungaKoperasi+", bungaBank : "+bungaBank);
            
            System.out.println("\ncicilanKoperasi : "+cicilanKoperasi);
            System.out.println("\ncicilanBank : "+cicilanBank);
            System.out.println("\npdx index : "+pdx.getCicilanKe());
            
            try{
                CONHandler.execUpdate("delete from "+DB_PINJAMAN_DETAIL+" where "+colNames[COL_PINJAMAN_ID]+"="+pinjaman.getOID()+" and "+colNames[COL_CICILAN_KE]+">="+pinjamanDetail.getCicilanKe());
            }
            catch(Exception e){
            }
            
            
            Date jatuhTempo = new Date();
            jatuhTempo.setMonth(jatuhTempo.getMonth()+1);
            jatuhTempo.setDate(pinjaman.getTanggalJatuhTempo());
            
            double saldoKop = pdx.getSaldoKoperasi();
            double saldoBank = pdx.getSaldoBank();
            
            System.out.println("\nsaldoKop : "+saldoKop);
            System.out.println("\nsaldoBank : "+saldoBank);
            
            if(pinjamanDetail.getOID()!=0){
                
                //int i = pdx.getCicilanKe();
                
                jatuhTempo = pinjamanDetail.getJatuhTempo();
                
                //while(saldoKop>0 && saldoBank>0){                    
                for(int i=pdx.getCicilanKe(); i<pinjaman.getLamaCicilan(); i++){
                //while(i<25){                    
                    
                    PinjamanDetail pd = new PinjamanDetail();
                    pd.setMemberId(pinjaman.getMemberId());
                    pd.setPinjamanId(pinjaman.getOID());
                    
                    //member ke koperasi
                    pd.setTotalKoperasi(cicilanKoperasi);
                    pd.setBunga(saldoKop * (bungaKoperasiBulan/100));                    
                    pd.setAmount(cicilanKoperasi - pd.getBunga());                    
                    pd.setSaldoKoperasi(saldoKop - pd.getAmount());
                    pd.setBungaKoperasiPercent(bungaKoperasiBulan);
                    
                    saldoKop = pd.getSaldoKoperasi();
                    
                    //member ke bank
                    pd.setTotalBank(cicilanBank);
                    pd.setBungaBank(saldoBank * (bungaBankBulan/100));                    
                    pd.setAmountBank(cicilanBank - pd.getBungaBank());                    
                    pd.setSaldoBank(saldoBank - pd.getAmountBank());
                    pd.setBungaBankPercent(bungaBankBulan);
                    
                    saldoBank = pd.getSaldoBank();
                    
                    pd.setCicilanKe(i+1);
                    
                    //i = i + 1;
                    
                    pd.setJatuhTempo(jatuhTempo);
                    try{
                        DbPinjamanDetail.insertExc(pd);
                    }
                    catch(Exception e){
                    }
                    
                    jatuhTempo = (Date)jatuhTempo.clone();
                    jatuhTempo.setMonth(jatuhTempo.getMonth()+1);                    
                }                    
            }        
        }
        
        
        public static void updateJatuhTempo(long pinjamanId, String strDate){
            
            if(strDate!=null && strDate.length()>0){
                
                Date dt = JSPFormater.formatDate(strDate, "dd/MM/yyyy");
                
                int tgl = dt.getDate();
                
                Vector v = list(0,0, colNames[COL_PINJAMAN_ID]+"="+pinjamanId, colNames[COL_CICILAN_KE]+" asc");
                if(v!=null && v.size()>0){
                    for(int i=0; i<v.size(); i++){
                        PinjamanDetail pd = (PinjamanDetail)v.get(i);
                        try{
                            
                            Date jtDate = (Date)dt.clone();
                            jtDate.setDate(1);
                            jtDate.setMonth(jtDate.getMonth()+1);
                            
                            dt = (Date)jtDate.clone();
                            
                            jtDate.setDate(jtDate.getDate()-1);
                            if(jtDate.getDate()!=tgl){
                                if(jtDate.getDate()>tgl){
                                    jtDate.setDate(tgl);
                                }
                            }
                            
                            pd.setJatuhTempo(jtDate);
                            DbPinjamanDetail.updateExc(pd);
                                                        
                        }
                        catch(Exception e){
                            
                        }
                    }
                }
                
            }
            
        }
        
        
}
