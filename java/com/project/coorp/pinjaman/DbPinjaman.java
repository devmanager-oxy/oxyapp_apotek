
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
import com.project.general.*;
import com.project.fms.master.*;
import com.project.util.*;
import com.project.coorp.member.*;
import com.project.fms.transaction.*;
import com.project.*;
import com.project.fms.master.*;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;

public class DbPinjaman extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_PINJAMAM = "sp_pinjaman";

	public static final  int COL_MEMBER_ID = 0;
	public static final  int COL_PINJAMAN_ID = 1;
	public static final  int COL_COUNTER = 2;
	public static final  int COL_PREFIX_NUMBER = 3;
	public static final  int COL_NUMBER = 4;
	public static final  int COL_DATE = 5;
	public static final  int COL_NOTE = 6;
	public static final  int COL_TOTAL_PINJAMAN = 7;
	public static final  int COL_BUNGA = 8;
	public static final  int COL_STATUS = 9;
	public static final  int COL_USER_ID = 10;
	public static final  int COL_BIAYA_ADMINISTRASI = 11;
	public static final  int COL_JENIS_BARANG = 12;
	public static final  int COL_DETAIL_JENIS_BARANG = 13;
	public static final  int COL_LAMA_CICILAN = 14;
	public static final  int COL_TYPE = 15;
	public static final  int COL_BANK_ID = 16;
        
        public static final  int COL_TANGGAL_JATUH_TEMPO = 17;
        public static final  int COL_APPROVE_BY_ID = 18;
        public static final  int COL_APPROVE_DATE = 19;
        
        public static final  int COL_BUNGA_BANK = 20;
        public static final  int COL_PROVISI     = 21;
        public static final  int COL_ASURANSI = 22;
        public static final  int COL_CICILAN = 23;
        public static final  int COL_JENIS_CICILAN = 24;
        
        public static final  int COL_COA_AR_DEBET_ID = 25;
        public static final  int COL_COA_AR_CREDIT_ID = 26;
        public static final  int COL_COA_ADMIN_DEBET_ID = 27;
        public static final  int COL_COA_ADMIN_CREDIT_ID = 28;
        public static final  int COL_COA_PROVISI_DEBET_ID = 29;
        public static final  int COL_COA_PROVISI_CREDIT_ID = 30;
        public static final  int COL_COA_ASURANSI_DEBET_ID = 31;
        public static final  int COL_COA_ASURANSI_CREDIT_ID = 32;
        public static final  int COL_COA_TITIPAN_DEBET_ID = 33;
        public static final  int COL_COA_TITIPAN_CREDIT_ID = 34;
        
        public static final  int COL_ANGSURAN_TERAKHIR = 35;
        
        

	public static final  String[] colNames = {
		"member_id",
                "pinjaman_id",
                "counter",
                "prefix_number",
                "number",
                "date",
                "note",
                "total_pinjaman",
                "bunga",
                "status",
                "user_id",
                "biaya_administrasi",
                "jenis_barang",
                "detail_jenis_barang",
                "lama_cicilan",
                "type",
                "bank_id",
                "tanggal_jatuh_tempo",
                "approve_by_id",
                "approve_date",
                
                "bunga_bank",
                "provisi",
                "asuransi",
                "cicilan",
                "jenis_cicilan",
                
                "coa_ar_debet_id",
                "coa_ar_credit_id",
                "coa_admin_debet_id",
                "coa_admin_credit_id",
                "coa_provisi_debet_id",
                "coa_provisi_credit_id",
                "coa_asuransi_debet_id",
                "coa_asuransi_credit_id",
                "coa_titipan_debet_id",
                "coa_titipan_credit_id",
                "angsuran_terakhir"
                

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_INT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_STRING,
		TYPE_INT,
		TYPE_INT,
		TYPE_LONG,
                TYPE_INT, 
                TYPE_LONG,
                TYPE_DATE,
                TYPE_FLOAT,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_INT
	 }; 
         
         public static final int TYPE_PINJAMAN_KOPERASI = 0;
         public static final int TYPE_PINJAMAN_BANK = 1;
         public static final int TYPE_PINJAMAN_KOPERASI_KE_BANK = 2;
         
         public static final int JENIS_BARANG_CASH  = 0;
         public static final int JENIS_BARANG_ELEKTRONIK  = 1;
         public static final int JENIS_BARANG_KENDARAAN  = 2;
         public static final int JENIS_BARANG_MINIMARKET  = 3;
         
         public static final String[] strJenisBarang = {
            "CASH", "ELEKTRONIK", "MOTOR", "MINIMARKET"
         };
         
         public static final int JENIS_CICILAN_TETAP  = 0;
         public static final int JENIS_CICILAN_ANUITAS  = 1;
         
         public static final String[] strJenisCicilan = {
            "Cicilan Tetap", "Bunga Anuitas"
         };
         
         public static final int STATUS_DRAFT  = 0;
         public static final int STATUS_APPROVE  = 1;
         public static final int STATUS_LUNAS  = 2;
         public static final int STATUS_DITOLAK  = 3;

         public static final String[] strStatus = {
            "Baru", "Disetujui", "Lunas", "Ditolak"
         };
         
         
         public static final int PAYMENT_STATUS_DRAFT  = 0;
         public static final int PAYMENT_STATUS_LUNAS  = 1;
         
         public static final String[] strPaymentStatus  = {
            "-", "Lunas"
         };

	public DbPinjaman(){
	}

	public DbPinjaman(int i) throws CONException { 
		super(new DbPinjaman()); 
	}

	public DbPinjaman(String sOid) throws CONException { 
		super(new DbPinjaman(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPinjaman(long lOid) throws CONException { 
		super(new DbPinjaman(0)); 
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
		return DB_PINJAMAM;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPinjaman().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Pinjaman pinjaman = fetchExc(ent.getOID()); 
		ent = (Entity)pinjaman; 
		return pinjaman.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Pinjaman) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Pinjaman) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Pinjaman fetchExc(long oid) throws CONException{ 
		try{ 
			Pinjaman pinjaman = new Pinjaman();
			DbPinjaman pstPinjaman = new DbPinjaman(oid); 
			pinjaman.setOID(oid);

			pinjaman.setMemberId(pstPinjaman.getlong(COL_MEMBER_ID));
			pinjaman.setCounter(pstPinjaman.getInt(COL_COUNTER));
			pinjaman.setPrefixNumber(pstPinjaman.getString(COL_PREFIX_NUMBER));
			pinjaman.setNumber(pstPinjaman.getString(COL_NUMBER));
			pinjaman.setDate(pstPinjaman.getDate(COL_DATE));
			pinjaman.setNote(pstPinjaman.getString(COL_NOTE));
			pinjaman.setTotalPinjaman(pstPinjaman.getdouble(COL_TOTAL_PINJAMAN));
			pinjaman.setBunga(pstPinjaman.getdouble(COL_BUNGA));
			pinjaman.setStatus(pstPinjaman.getInt(COL_STATUS));
			pinjaman.setUserId(pstPinjaman.getlong(COL_USER_ID));
			pinjaman.setBiayaAdministrasi(pstPinjaman.getdouble(COL_BIAYA_ADMINISTRASI));
			pinjaman.setJenisBarang(pstPinjaman.getInt(COL_JENIS_BARANG));
			pinjaman.setDetailJenisBarang(pstPinjaman.getString(COL_DETAIL_JENIS_BARANG));
			pinjaman.setLamaCicilan(pstPinjaman.getInt(COL_LAMA_CICILAN));
			pinjaman.setType(pstPinjaman.getInt(COL_TYPE));
			pinjaman.setBankId(pstPinjaman.getlong(COL_BANK_ID));
                        
                        pinjaman.setTanggalJatuhTempo(pstPinjaman.getInt(COL_TANGGAL_JATUH_TEMPO));
                        pinjaman.setApproveById(pstPinjaman.getlong(COL_APPROVE_BY_ID));
                        pinjaman.setApproveDate(pstPinjaman.getDate(COL_APPROVE_DATE));
                        
                        pinjaman.setBungaBank(pstPinjaman.getdouble(COL_BUNGA_BANK));
                        
                        pinjaman.setProvisi(pstPinjaman.getdouble(COL_PROVISI));
                        pinjaman.setAsuransi(pstPinjaman.getdouble(COL_ASURANSI));
                        pinjaman.setCicilan(pstPinjaman.getdouble(COL_CICILAN));
                        pinjaman.setJenisCicilan(pstPinjaman.getInt(COL_JENIS_CICILAN));
                        
                        pinjaman.setCoaArDebetId(pstPinjaman.getlong(COL_COA_AR_DEBET_ID));
                        pinjaman.setCoaArCreditId(pstPinjaman.getlong(COL_COA_AR_CREDIT_ID));
                        pinjaman.setCoaAdminDebetId(pstPinjaman.getlong(COL_COA_ADMIN_DEBET_ID));
                        pinjaman.setCoaAdminCreditId(pstPinjaman.getlong(COL_COA_ADMIN_CREDIT_ID));
                        pinjaman.setCoaProvisiDebetId(pstPinjaman.getlong(COL_COA_PROVISI_DEBET_ID));
                        pinjaman.setCoaProvisiCreditId(pstPinjaman.getlong(COL_COA_PROVISI_CREDIT_ID));
                        pinjaman.setCoaAsuransiDebetId(pstPinjaman.getlong(COL_COA_ASURANSI_DEBET_ID));
                        pinjaman.setCoaAsuransiCreditId(pstPinjaman.getlong(COL_COA_ASURANSI_CREDIT_ID));
                        pinjaman.setCoaTitipanDebetId(pstPinjaman.getlong(COL_COA_TITIPAN_DEBET_ID));
                        pinjaman.setCoaTitipanCreditId(pstPinjaman.getlong(COL_COA_TITIPAN_CREDIT_ID));
                        pinjaman.setAngsuranTerakhir(pstPinjaman.getInt(COL_ANGSURAN_TERAKHIR));

			return pinjaman; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPinjaman(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Pinjaman pinjaman) throws CONException{ 
		try{ 
			DbPinjaman pstPinjaman = new DbPinjaman(0);

			pstPinjaman.setLong(COL_MEMBER_ID, pinjaman.getMemberId());
			pstPinjaman.setInt(COL_COUNTER, pinjaman.getCounter());
			pstPinjaman.setString(COL_PREFIX_NUMBER, pinjaman.getPrefixNumber());
			pstPinjaman.setString(COL_NUMBER, pinjaman.getNumber());
			pstPinjaman.setDate(COL_DATE, pinjaman.getDate());
			pstPinjaman.setString(COL_NOTE, pinjaman.getNote());
			pstPinjaman.setDouble(COL_TOTAL_PINJAMAN, pinjaman.getTotalPinjaman());
			pstPinjaman.setDouble(COL_BUNGA, pinjaman.getBunga());
			pstPinjaman.setInt(COL_STATUS, pinjaman.getStatus());
			pstPinjaman.setLong(COL_USER_ID, pinjaman.getUserId());
			pstPinjaman.setDouble(COL_BIAYA_ADMINISTRASI, pinjaman.getBiayaAdministrasi());
			pstPinjaman.setInt(COL_JENIS_BARANG, pinjaman.getJenisBarang());
			pstPinjaman.setString(COL_DETAIL_JENIS_BARANG, pinjaman.getDetailJenisBarang());
			pstPinjaman.setInt(COL_LAMA_CICILAN, pinjaman.getLamaCicilan());
			pstPinjaman.setInt(COL_TYPE, pinjaman.getType());
			pstPinjaman.setLong(COL_BANK_ID, pinjaman.getBankId());
                        
                        pstPinjaman.setInt(COL_TANGGAL_JATUH_TEMPO, pinjaman.getTanggalJatuhTempo());
                        pstPinjaman.setLong(COL_APPROVE_BY_ID, pinjaman.getApproveById());
                        pstPinjaman.setDate(COL_APPROVE_DATE, pinjaman.getApproveDate());
                        
                        pstPinjaman.setDouble(COL_BUNGA_BANK, pinjaman.getBungaBank());
                        
                        pstPinjaman.setDouble(COL_PROVISI, pinjaman.getProvisi());
                        pstPinjaman.setDouble(COL_ASURANSI, pinjaman.getAsuransi());
                        pstPinjaman.setDouble(COL_CICILAN, pinjaman.getCicilan());
                        pstPinjaman.setInt(COL_JENIS_CICILAN, pinjaman.getJenisCicilan());
                        
                        pstPinjaman.setLong(COL_COA_AR_DEBET_ID, pinjaman.getCoaArDebetId());
                        pstPinjaman.setLong(COL_COA_AR_CREDIT_ID, pinjaman.getCoaArCreditId());
                        pstPinjaman.setLong(COL_COA_ADMIN_DEBET_ID, pinjaman.getCoaAdminDebetId());
                        pstPinjaman.setLong(COL_COA_ADMIN_CREDIT_ID, pinjaman.getCoaAdminCreditId());
                        pstPinjaman.setLong(COL_COA_PROVISI_DEBET_ID, pinjaman.getCoaProvisiDebetId());
                        pstPinjaman.setLong(COL_COA_PROVISI_CREDIT_ID, pinjaman.getCoaProvisiCreditId());
                        pstPinjaman.setLong(COL_COA_ASURANSI_DEBET_ID, pinjaman.getCoaAsuransiDebetId());
                        pstPinjaman.setLong(COL_COA_ASURANSI_CREDIT_ID, pinjaman.getCoaAsuransiCreditId());
                        pstPinjaman.setLong(COL_COA_TITIPAN_DEBET_ID, pinjaman.getCoaTitipanDebetId());
                        pstPinjaman.setLong(COL_COA_TITIPAN_CREDIT_ID, pinjaman.getCoaTitipanCreditId());
                        pstPinjaman.setInt(COL_ANGSURAN_TERAKHIR, pinjaman.getAngsuranTerakhir());

			pstPinjaman.insert(); 
			pinjaman.setOID(pstPinjaman.getlong(COL_PINJAMAN_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPinjaman(0),CONException.UNKNOWN); 
		}
		return pinjaman.getOID();
	}

	public static long updateExc(Pinjaman pinjaman) throws CONException{ 
		try{ 
			if(pinjaman.getOID() != 0){ 
				DbPinjaman pstPinjaman = new DbPinjaman(pinjaman.getOID());

				pstPinjaman.setLong(COL_MEMBER_ID, pinjaman.getMemberId());
				pstPinjaman.setInt(COL_COUNTER, pinjaman.getCounter());
				pstPinjaman.setString(COL_PREFIX_NUMBER, pinjaman.getPrefixNumber());
				pstPinjaman.setString(COL_NUMBER, pinjaman.getNumber());
				pstPinjaman.setDate(COL_DATE, pinjaman.getDate());
				pstPinjaman.setString(COL_NOTE, pinjaman.getNote());
				pstPinjaman.setDouble(COL_TOTAL_PINJAMAN, pinjaman.getTotalPinjaman());
				pstPinjaman.setDouble(COL_BUNGA, pinjaman.getBunga());
				pstPinjaman.setInt(COL_STATUS, pinjaman.getStatus());
				pstPinjaman.setLong(COL_USER_ID, pinjaman.getUserId());
				pstPinjaman.setDouble(COL_BIAYA_ADMINISTRASI, pinjaman.getBiayaAdministrasi());
				pstPinjaman.setInt(COL_JENIS_BARANG, pinjaman.getJenisBarang());
				pstPinjaman.setString(COL_DETAIL_JENIS_BARANG, pinjaman.getDetailJenisBarang());
				pstPinjaman.setInt(COL_LAMA_CICILAN, pinjaman.getLamaCicilan());
				pstPinjaman.setInt(COL_TYPE, pinjaman.getType());
				pstPinjaman.setLong(COL_BANK_ID, pinjaman.getBankId());
                                
                                pstPinjaman.setInt(COL_TANGGAL_JATUH_TEMPO, pinjaman.getTanggalJatuhTempo());
                                pstPinjaman.setLong(COL_APPROVE_BY_ID, pinjaman.getApproveById());
                                pstPinjaman.setDate(COL_APPROVE_DATE, pinjaman.getApproveDate());
                                
                                pstPinjaman.setDouble(COL_BUNGA_BANK, pinjaman.getBungaBank());
                                
                                pstPinjaman.setDouble(COL_PROVISI, pinjaman.getProvisi());
                                pstPinjaman.setDouble(COL_ASURANSI, pinjaman.getAsuransi());
                                pstPinjaman.setDouble(COL_CICILAN, pinjaman.getCicilan());
                                pstPinjaman.setInt(COL_JENIS_CICILAN, pinjaman.getJenisCicilan());
                                
                                pstPinjaman.setLong(COL_COA_AR_DEBET_ID, pinjaman.getCoaArDebetId());
                                pstPinjaman.setLong(COL_COA_AR_CREDIT_ID, pinjaman.getCoaArCreditId());
                                pstPinjaman.setLong(COL_COA_ADMIN_DEBET_ID, pinjaman.getCoaAdminDebetId());
                                pstPinjaman.setLong(COL_COA_ADMIN_CREDIT_ID, pinjaman.getCoaAdminCreditId());
                                pstPinjaman.setLong(COL_COA_PROVISI_DEBET_ID, pinjaman.getCoaProvisiDebetId());
                                pstPinjaman.setLong(COL_COA_PROVISI_CREDIT_ID, pinjaman.getCoaProvisiCreditId());
                                pstPinjaman.setLong(COL_COA_ASURANSI_DEBET_ID, pinjaman.getCoaAsuransiDebetId());
                                pstPinjaman.setLong(COL_COA_ASURANSI_CREDIT_ID, pinjaman.getCoaAsuransiCreditId());
                                pstPinjaman.setLong(COL_COA_TITIPAN_DEBET_ID, pinjaman.getCoaTitipanDebetId());
                                pstPinjaman.setLong(COL_COA_TITIPAN_CREDIT_ID, pinjaman.getCoaTitipanCreditId());
                                pstPinjaman.setInt(COL_ANGSURAN_TERAKHIR, pinjaman.getAngsuranTerakhir());

				pstPinjaman.update(); 
				return pinjaman.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPinjaman(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPinjaman pstPinjaman = new DbPinjaman(oid);
			pstPinjaman.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPinjaman(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PINJAMAM; 
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
				Pinjaman pinjaman = new Pinjaman();
				resultToObject(rs, pinjaman);
				lists.add(pinjaman);
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

	public static void resultToObject(ResultSet rs, Pinjaman pinjaman){
		try{
			pinjaman.setOID(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_PINJAMAN_ID]));
			pinjaman.setMemberId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_MEMBER_ID]));
			pinjaman.setCounter(rs.getInt(DbPinjaman.colNames[DbPinjaman.COL_COUNTER]));
			pinjaman.setPrefixNumber(rs.getString(DbPinjaman.colNames[DbPinjaman.COL_PREFIX_NUMBER]));
			pinjaman.setNumber(rs.getString(DbPinjaman.colNames[DbPinjaman.COL_NUMBER]));
			pinjaman.setDate(rs.getDate(DbPinjaman.colNames[DbPinjaman.COL_DATE]));
			pinjaman.setNote(rs.getString(DbPinjaman.colNames[DbPinjaman.COL_NOTE]));
			pinjaman.setTotalPinjaman(rs.getDouble(DbPinjaman.colNames[DbPinjaman.COL_TOTAL_PINJAMAN]));
			pinjaman.setBunga(rs.getDouble(DbPinjaman.colNames[DbPinjaman.COL_BUNGA]));
			pinjaman.setStatus(rs.getInt(DbPinjaman.colNames[DbPinjaman.COL_STATUS]));
			pinjaman.setUserId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_USER_ID]));
			pinjaman.setBiayaAdministrasi(rs.getDouble(DbPinjaman.colNames[DbPinjaman.COL_BIAYA_ADMINISTRASI]));
			pinjaman.setJenisBarang(rs.getInt(DbPinjaman.colNames[DbPinjaman.COL_JENIS_BARANG]));
			pinjaman.setDetailJenisBarang(rs.getString(DbPinjaman.colNames[DbPinjaman.COL_DETAIL_JENIS_BARANG]));
			pinjaman.setLamaCicilan(rs.getInt(DbPinjaman.colNames[DbPinjaman.COL_LAMA_CICILAN]));
			pinjaman.setType(rs.getInt(DbPinjaman.colNames[DbPinjaman.COL_TYPE]));
			pinjaman.setBankId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_BANK_ID]));
                        
                        pinjaman.setTanggalJatuhTempo(rs.getInt(DbPinjaman.colNames[DbPinjaman.COL_TANGGAL_JATUH_TEMPO]));
                        pinjaman.setApproveById(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_APPROVE_BY_ID]));
                        pinjaman.setApproveDate(rs.getDate(DbPinjaman.colNames[DbPinjaman.COL_APPROVE_DATE]));
                        
                        pinjaman.setBungaBank(rs.getDouble(DbPinjaman.colNames[DbPinjaman.COL_BUNGA_BANK]));
                        
                        pinjaman.setProvisi(rs.getDouble(DbPinjaman.colNames[DbPinjaman.COL_PROVISI]));
                        pinjaman.setAsuransi(rs.getDouble(DbPinjaman.colNames[DbPinjaman.COL_ASURANSI]));
                        pinjaman.setCicilan(rs.getDouble(DbPinjaman.colNames[DbPinjaman.COL_CICILAN]));
                        pinjaman.setJenisCicilan(rs.getInt(DbPinjaman.colNames[DbPinjaman.COL_JENIS_CICILAN]));
                        
                        pinjaman.setCoaArDebetId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_AR_DEBET_ID]));
                        pinjaman.setCoaArCreditId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_AR_CREDIT_ID]));                        
                        pinjaman.setCoaAdminDebetId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_ADMIN_DEBET_ID]));
                        pinjaman.setCoaAdminCreditId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_ADMIN_CREDIT_ID]));
                        pinjaman.setCoaProvisiDebetId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_PROVISI_DEBET_ID]));
                        pinjaman.setCoaProvisiCreditId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_PROVISI_CREDIT_ID]));
                        pinjaman.setCoaAsuransiDebetId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_ASURANSI_DEBET_ID]));
                        pinjaman.setCoaAsuransiCreditId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_ASURANSI_CREDIT_ID]));
                        pinjaman.setCoaTitipanDebetId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_TITIPAN_DEBET_ID]));
                        pinjaman.setCoaTitipanCreditId(rs.getLong(DbPinjaman.colNames[DbPinjaman.COL_COA_TITIPAN_CREDIT_ID]));
                        pinjaman.setAngsuranTerakhir(rs.getInt(DbPinjaman.colNames[DbPinjaman.COL_ANGSURAN_TERAKHIR]));

		}catch(Exception e){ }
	}

	
	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbPinjaman.colNames[DbPinjaman.COL_PINJAMAN_ID] + ") FROM " + DB_PINJAMAM;
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
			  	   Pinjaman pinjaman = (Pinjaman)list.get(ls);
				   if(oid == pinjaman.getOID())
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
                    String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_PINJAMAM+" where "+
                        colNames[COL_PREFIX_NUMBER]+"='"+getNumberPrefix(type)+"' and "+colNames[COL_TYPE]+"="+type;
                    
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
                if(type==TYPE_PINJAMAN_KOPERASI){
                    code = code + sysCompany.getPinjamanKoperasiCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");
                }
                else if(type==TYPE_PINJAMAN_BANK){
                    code = code + sysCompany.getPinjamanBankCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");
                }
                else{
                    code = code + sysCompany.getPinjamanKoperasiBankCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");
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
        
        //POSTING ke journal - pengakuan pihutang
        public static void postJournal(Pinjaman cr){
                
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
                
                
                String memo = "Pinjaman "+((cr.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? "Kopegtel" : "BANK "+bn.getName())+" untuk anggota : "+member.getNoMember()+"/"+member.getNama() + ((cr.getNote().length()>0) ? " - "+cr.getNote() : "") + ", No Rekening Pinjaman : "+cr.getNumber();
                               
                if(cr.getOID()!=0 && cr.getStatus()==DbPinjaman.STATUS_APPROVE){
                    
                    long oid = DbGl.postJournalMain(0, cr.getApproveDate(), cr.getCounter(), cr.getNumber(), cr.getPrefixNumber(), 
                        (cr.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? I_Project.JOURNAL_TYPE_PINJAMAN_KOPERASI : I_Project.JOURNAL_TYPE_PINJAMAN_BANK, 
                        memo, cr.getApproveById(), "", cr.getOID(), "", cr.getDate());
                    
                    //pengakuan pihutang    
                    if(oid!=0){
                        
                        
                        memo = ""; 
                        
                        //yang lama
                        //ambil coa cash acc link pinjaman
                        /*Vector temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DEBET+"'", "");
                        AccLink al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        
                        //journal debet pada pihutang 
                        memo = "Pihutang koperasi kepada anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getTotalPinjaman(),             
                                    cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                        temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_CREDIT+"'", "");
                        al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        //journal credit cash
                        memo = "Pemotongan cash untuk pinjaman anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getTotalPinjaman(), 0,             
                                cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                        
                         */
                        
                        //journal debet pada pihutang 
                        memo = "Pihutang koperasi kepada anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaArDebetId(), 0, cr.getTotalPinjaman(),             
                                    cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                        //journal credit cash
                        memo = "Pinjaman anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaArCreditId(), cr.getTotalPinjaman(), 0,             
                                cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                        
                         
                        //=============================== jurnal biaya admin ==================================
                        
                        //jika ada biaya admin bukukan sebagai pendapatan
                        if(cr.getBiayaAdministrasi()>0){
                            
                            //yang lama
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            memo = "Penambahan cash dari pendapatan biaya admin : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getBiayaAdministrasi(),             
                                        cr.getBiayaAdministrasi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            //journal credit cash
                            memo = "Pendapatan dari biaya admin pinjaman : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getBiayaAdministrasi(), 0,             
                                    cr.getBiayaAdministrasi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
			    
                            memo = "Pendapatan biaya admin : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAdminDebetId(), 0, cr.getBiayaAdministrasi(),             
                                        cr.getBiayaAdministrasi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit cash
                            memo = "Pendapatan biaya admin : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAdminCreditId(), cr.getBiayaAdministrasi(), 0,             
                                    cr.getBiayaAdministrasi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0		

                        }
                        
                        
                        //jika ada biaya admin bukukan sebagai pendapatan
                        if(cr.getProvisi()>0){
                            
                            memo = "Pendapatan provisi : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaProvisiDebetId(), 0, cr.getProvisi(),             
                                        cr.getProvisi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit cash
                            memo = "Pendapatan provisi : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaProvisiCreditId(), cr.getProvisi(), 0,             
                                    cr.getProvisi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0		

                        }
                        
                        //jika ada biaya admin bukukan sebagai pendapatan
                        if(cr.getAsuransi()>0){
                            
                            memo = "Pendapatan asuransi : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAsuransiDebetId(), 0, cr.getAsuransi(),             
                                        cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit cash
                            memo = "Pendapatan asuransi : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAsuransiCreditId(), cr.getAsuransi(), 0,             
                                    cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0		

                        }
                        
                    }
                     
                    //optimalkan, jika akunnya sama digabung    
                    DbGl.optimizeJournal(oid);
                    
                }
                
                
        }
        
        
        //POSTING ke journal - pengakuan pihutang
        public static void postJournalPinjamanBankAnggota(Pinjaman cr){
                
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
                
                
                String memo = "Pinjaman BANK "+bn.getName()+" untuk anggota : "+member.getNoMember()+"/"+member.getNama() + ((cr.getNote().length()>0) ? " - "+cr.getNote() : "") + ", No Rekening Pinjaman : "+cr.getNumber();
                               
                if(cr.getOID()!=0 && cr.getStatus()==DbPinjaman.STATUS_APPROVE){
                    
                    long oid = DbGl.postJournalMain(0, cr.getApproveDate(), cr.getCounter(), cr.getNumber(), cr.getPrefixNumber(), 
                        (cr.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? I_Project.JOURNAL_TYPE_PINJAMAN_KOPERASI : I_Project.JOURNAL_TYPE_PINJAMAN_BANK, 
                        memo, cr.getApproveById(), "", cr.getOID(), "", cr.getDate());
                    
                    //pengakuan pihutang    
                    if(oid!=0){
                        
                        
                        //====================== jurnal hutang bank ======================
                        
                        memo = ""; 
                        
                        /*
                        if(cr.getType()==DbPinjaman.TYPE_PINJAMAN_BANK){
                            //ambil coa cash acc link pinjaman
                            Vector temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BANK_DEBET+"'", "");
                            AccLink al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }

                            //journal debet pada cash 
                            
                            memo = "Debit - Penambahan cash dari pinjaman koperasi kepada Bank : "+bn.getName();                            
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getTotalPinjaman(),             
                                        cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BANK_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            //journal credit hutang
                            memo = "Credit - Penambahan hutang koperasi ke Bank : "+bn.getName();                            
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getTotalPinjaman(), 0,             
                                    cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                        }
                         */
                        
                        //====================== jurnal pihutang anggota ===================
                        
                        //ambil coa cash acc link pinjaman
                        /*
                        Vector temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DEBET+"'", "");
                        AccLink al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        
                        //journal debet pada pihutang 
                        memo = "Pihutang koperasi kepada anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getTotalPinjaman(),             
                                    cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                        temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_CREDIT+"'", "");
                        al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        //journal credit cash
                        memo = "Pinjaman anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getTotalPinjaman(), 0,             
                                cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                         */
                        
                        //journal debet pada pihutang 
                        memo = "Pihutang koperasi kepada anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaArDebetId(), 0, cr.getTotalPinjaman(),             
                                    cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                        //journal credit cash
                        memo = "Pinjaman anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaArCreditId(), cr.getTotalPinjaman(), 0,             
                                cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                        
                        
                        //=============================== jurnal biaya admin ==================================
                        
                        //jika ada biaya admin bukukan sebagai pendapatan
                        if(cr.getBiayaAdministrasi()>0){
                            /*
                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            memo = "Pendapatan biaya admin, provisi dan asuransi : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(),             
                                        cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            //journal credit cash
                            memo = "Credit - Pendapatan dari biaya admin pinjaman : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), 0,             
                                    cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
                            
                            memo = "Biaya admin : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAdminDebetId(), 0, cr.getBiayaAdministrasi(),             
                                        cr.getBiayaAdministrasi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                            
                            //journal credit cash
                            memo = "Biaya admin : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAdminCreditId(), cr.getBiayaAdministrasi(), 0,             
                                    cr.getBiayaAdministrasi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                        }
                        
                        if(cr.getProvisi()>0){
                            
                            
                            memo = "Biaya provisi : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaProvisiDebetId(), 0, cr.getProvisi(),             
                                        cr.getProvisi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                            
                            //journal credit cash
                            memo = "Biaya provisi : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaProvisiCreditId(), cr.getProvisi(), 0,             
                                    cr.getProvisi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                        }
                        
                        if(cr.getAsuransi()>0){
                            
                            
                            memo = "Biaya provisi : "+member.getNoMember()+"/"+member.getNama();
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAsuransiDebetId(), 0, cr.getAsuransi(),             
                                        cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                            
                            //journal credit cash
                            memo = "Biaya provisi : "+member.getNoMember()+"/"+member.getNama();;
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAsuransiCreditId(), cr.getAsuransi(), 0,             
                                    cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                        }
                        
                        //titipan 
                        Vector vx = DbPinjamanDetail.list(0,0, DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_ID]+"="+cr.getOID()+" and "+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_CICILAN_KE]+"=1", "");
                        if(vx!=null && vx.size()>0){
                            PinjamanDetail pd = (PinjamanDetail)vx.get(0);
                            
                            memo = "Titipan 1 kali angsuran";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaTitipanDebetId(), 0, pd.getAmount()+pd.getBunga(),             
                                        pd.getAmount()+pd.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0
                            
                            //journal credit cash
                            memo = "Titipan 1 kali angsuran";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaTitipanCreditId(), pd.getAmount()+pd.getBunga(), 0,             
                                    pd.getAmount()+pd.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                            
                            //*************
                            //*************
                            //posting cash receive agar muncul dalam titipan
                            postCashReceive(cr, (pd.getAmount()+pd.getBunga()), comp);

                        }  
                        
                        
                        
                    }
                        
                    //optimalisasi jurnal
                    DbGl.optimizeJournal(oid);
                    
                    
                }
        }
        
        public static void postCashReceive(Pinjaman p, double amount, Company comp){
            
            //get member
            Member m = new Member();
            try{
                m = DbMember.fetchExc(p.getMemberId());
            }
            catch(Exception e){
                
            }
            
            //get penitip = get vendor
            String where  = DbVendor.colNames[DbVendor.COL_CODE]+"='"+m.getNoMember()+"'"+
                            " and "+DbVendor.colNames[DbVendor.COL_NAME]+"='"+m.getNama()+"'"+
                            " and "+DbVendor.colNames[DbVendor.COL_TYPE]+"="+DbVendor.VENDOR_TYPE_PENITIP;
            
            Vector vnds = DbVendor.list(0,0, where, "");
            Vendor vnd = new Vendor();
            if(vnds!=null && vnds.size()>0){
                vnd = (Vendor)vnds.get(0);
            }
            else{
                //insert baru
                vnd.setCode(m.getNoMember());
                vnd.setName(m.getNama());
                vnd.setAddress(m.getAlamat());
                vnd.setPhone(m.getPhone());
                vnd.setType(DbVendor.VENDOR_TYPE_PENITIP);                
                
                try{
                    DbVendor.insertExc(vnd);
                }
                catch(Exception e){
                }
            }
            
            //buat cash receive
            CashReceive cr = new CashReceive();
            cr.setType(DbCashReceive.TYPE_CASH_LIABILITY);
            cr.setAmount(amount);
            cr.setCustomerId(vnd.getOID());
            cr.setDate(new Date());
            cr.setTransDate(p.getDate());
            cr.setCoaId(p.getCoaTitipanDebetId());
            cr.setMemo("Auto Posting - dari pinjaman anggota ke bank, no Rek : "+p.getNumber()+", total : "+JSPFormater.formatNumber(p.getTotalPinjaman(),"#,###.##"));
            cr.setOperatorId(p.getUserId());
            int cnt = DbCashReceive.getNextCounter(DbCashReceive.TYPE_CASH_LIABILITY);
            cr.setJournalCounter(cnt);
            cr.setJournalPrefix(DbCashReceive.getNumberPrefix(DbCashReceive.TYPE_CASH_LIABILITY));
            cr.setJournalNumber(DbCashReceive.getNextNumber(cnt, DbCashReceive.TYPE_CASH_LIABILITY));
            cr.setReceiveFromId(p.getUserId());
            cr.setInOut(1);
            
            long oid = 0;
            try{
                oid = DbCashReceive.insertExc(cr);
            }
            catch(Exception e){            
            }
            
            //posting cash receive detail
            CashReceiveDetail crd = new CashReceiveDetail();
            crd.setCashReceiveId(oid);
            crd.setAmount(amount);
            crd.setForeignAmount(amount);
            crd.setMemo("Auto - dari pinjaman anggota ke bank");
            crd.setCoaId(p.getCoaTitipanCreditId());
            crd.setBookedRate(1);
            crd.setForeignCurrencyId(comp.getBookingCurrencyId());
            
            try{
                oid = DbCashReceiveDetail.insertExc(crd);
            }
            catch(Exception e){            
            }
            
            
        }
        
        
        //POSTING ke journal - pengakuan hutang
        public static void postJournalPinjamanKoperasiBank(Pinjaman cr){
                
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
                
                System.out.println("\n\n************************* \n\n");
                System.out.println("admin : "+cr.getBiayaAdministrasi()+", provisi : "+cr.getProvisi()+", ass : "+cr.getAsuransi());
                System.out.println("\n\n************************* \n\n");
                
                
                String memo = "Pinjaman Koperasi ke BANK "+bn.getName()+ ((cr.getNote().length()>0) ? " - "+cr.getNote() : "") + ", No Rekening Pinjaman : "+cr.getNumber();
                               
                if(cr.getOID()!=0 && cr.getStatus()==DbPinjaman.STATUS_APPROVE){
                    
                    long oid = DbGl.postJournalMain(0, cr.getApproveDate(), cr.getCounter(), cr.getNumber(), cr.getPrefixNumber(), 
                        (cr.getType()==DbPinjaman.TYPE_PINJAMAN_KOPERASI) ? I_Project.JOURNAL_TYPE_PINJAMAN_KOPERASI : I_Project.JOURNAL_TYPE_PINJAMAN_BANK, 
                        memo, cr.getApproveById(), "", cr.getOID(), "", cr.getDate());
                    
                    //pengakuan pihutang    
                    if(oid!=0){
                        
                        
                        //====================== jurnal hutang bank ======================
                        
                        memo = ""; 
                                                
                        /*
                        //ambil coa cash acc link pinjaman
                        Vector temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BANK_DEBET+"'", "");
                        AccLink al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }

                        //journal debet pada cash 

                        memo = "Pinjaman koperasi kepada Bank : "+bn.getName();                            
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getTotalPinjaman(),             
                                    cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                        temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BANK_CREDIT+"'", "");
                        al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        //journal credit hutang
                        memo = "Hutang koperasi ke Bank : "+bn.getName();                            
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getTotalPinjaman(), 0,             
                                cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                         
                         */
                        //ambil coa cash acc link pinjaman
                        
                        //journal debet pada cash 

                        memo = "Pinjaman koperasi kepada Bank : "+bn.getName();                            
                        DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaArDebetId(), 0, cr.getTotalPinjaman(),             
                                    cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                        //journal credit hutang
                        memo = "Hutang koperasi ke Bank : "+bn.getName();                            
                        DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaArCreditId(), cr.getTotalPinjaman(), 0,             
                                cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                        
                        //====================== jurnal pihutang anggota ===================
                        /*
                        //ambil coa cash acc link pinjaman
                        Vector temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DEBET+"'", "");
                        AccLink al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        
                        //journal debet pada pihutang 
                        memo = "Debit - Pihutang koperasi kepada anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getTotalPinjaman(),             
                                    cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                        temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_CREDIT+"'", "");
                        al = new AccLink();
                        if(temp!=null && temp.size()>0){
                            al = (AccLink)temp.get(0);
                        }
                        //journal credit cash
                        memo = "Credit - Pemotongan cash untuk pinjaman anggota : "+member.getNoMember()+"/"+member.getNama();
                        DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getTotalPinjaman(), 0,             
                                cr.getTotalPinjaman(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                         *
                         **/
                        
                        //=============================== jurnal biaya admin ==================================
                        
                        //jika ada biaya admin bukukan sebagai pendapatan
                        if(cr.getBiayaAdministrasi()>0){// || cr.getProvisi()>0 && cr.getAsuransi()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            memo = "Debit - Penambahan biaya admin, provisi dan asuransi pinjaman koperasi";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(),             
                                        cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //journal credit cash
                            memo = "Credit - pengurangan cash dari biaya admin, provisi dan asuransi pinjaman koperasi";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), 0,             
                                    cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
                            
                            memo = "biaya admin";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAdminDebetId(), 0, cr.getBiayaAdministrasi(),             
                                        cr.getBiayaAdministrasi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit cash
                            memo = "biaya admin";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAdminCreditId(), cr.getBiayaAdministrasi(), 0,             
                                    cr.getBiayaAdministrasi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             

                        }
                        
                        //jika ada biaya admin bukukan sebagai pendapatan
                        if(cr.getProvisi()>0){// || cr.getProvisi()>0 && cr.getAsuransi()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            memo = "Debit - Penambahan biaya admin, provisi dan asuransi pinjaman koperasi";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(),             
                                        cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //journal credit cash
                            memo = "Credit - pengurangan cash dari biaya admin, provisi dan asuransi pinjaman koperasi";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), 0,             
                                    cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
                            
                            memo = "biaya provisi";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaProvisiDebetId(), 0, cr.getProvisi(),             
                                        cr.getProvisi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit cash
                            memo = "biaya provisi";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaProvisiCreditId(), cr.getProvisi(), 0,             
                                    cr.getProvisi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             

                        }
                        
                        //jika ada biaya admin bukukan sebagai pendapatan
                        if(cr.getAsuransi()>0){// || cr.getProvisi()>0 && cr.getAsuransi()>0){
                            
                            /*temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_CREDIT+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            memo = "Debit - Penambahan biaya admin, provisi dan asuransi pinjaman koperasi";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), 0, cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(),             
                                        cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_ADM_DEBET+"'", "");
                            al = new AccLink();
                            if(temp!=null && temp.size()>0){
                                al = (AccLink)temp.get(0);
                            }
                            
                            //journal credit cash
                            memo = "Credit - pengurangan cash dari biaya admin, provisi dan asuransi pinjaman koperasi";
                            DbGl.postJournalDetail(er.getValueIdr(), al.getCoaId(), cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), 0,             
                                    cr.getBiayaAdministrasi()+cr.getProvisi()+cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             */
                            
                            memo = "biaya asuransi";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAsuransiDebetId(), 0, cr.getAsuransi(),             
                                        cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit cash
                            memo = "biaya asuransi";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaAsuransiCreditId(), cr.getAsuransi(), 0,             
                                    cr.getAsuransi(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             

                        }
                        
                        //jurnal titipan 1 angsuran di bank
                        Vector vx = DbPinjamanDetail.list(0,0,DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_ID]+"="+cr.getOID()+" and "+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_CICILAN_KE]+"=1", "");
                        if(vx!=null && vx.size()>0){
                            PinjamanDetail pd = (PinjamanDetail)vx.get(0);
                            
                            memo = "titipan 1 kali angsuran";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaTitipanDebetId(), 0, pd.getAmount()+pd.getBunga(),             
                                         pd.getAmount()+pd.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                            //journal credit cash
                            memo = "titipan 1 kali angsuran";
                            DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaTitipanCreditId(), pd.getAmount()+pd.getBunga(), 0,             
                                    pd.getAmount()+pd.getBunga(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                             
                            
                        }
                        
                        
                    }
                        
                    //optimalkan, jika akunnya sama digabung    
                    DbGl.optimizeJournal(oid);
                }
        }
        
        
        public static PinjamanDetail getTotalTagihanPinjaman(long memberId, Date dt, int jenisBarang){
            
            String sql = " select sum(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_AMOUNT]+"), "+
                         " sum(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_BUNGA]+") "+
                         " from "+DbPinjamanDetail.DB_PINJAMAN_DETAIL+" pd "+
                         " inner join "+DB_PINJAMAM+" p on p."+colNames[COL_PINJAMAN_ID]+
                         " = pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_ID]+
                         " where "+
                         " p."+colNames[COL_STATUS]+"="+STATUS_APPROVE+
                         " and p."+colNames[COL_TYPE]+" = "+TYPE_PINJAMAN_KOPERASI+
                         " and p."+colNames[COL_JENIS_BARANG]+" = "+jenisBarang+
                         " and pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_MEMBER_ID]+" = "+memberId+
                         " and pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_STATUS]+"="+DbPinjaman.PAYMENT_STATUS_DRAFT+
                         " and (month(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_JATUH_TEMPO]+")"+
                         " <= month('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"') "+
                         " and year(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_JATUH_TEMPO]+")"+
                         " <=year('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'))";
            
            System.out.println("\n\n==========================>>> "+sql+"\n******************\n");
            
            PinjamanDetail result = new PinjamanDetail();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    //result = rs.getDouble(1);
                    result.setAmount(rs.getDouble(1));
                    result.setBunga(rs.getDouble(2));
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        public static void getPaidForPinjamanByPotongGaji(long memberId, Date dt, int jenisBarang){
            
            String sql = " select pd.* "+
                         " from "+DbPinjamanDetail.DB_PINJAMAN_DETAIL+" pd "+
                         " inner join "+DB_PINJAMAM+" p on p."+colNames[COL_PINJAMAN_ID]+
                         " = pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_ID]+
                         " where "+
                         " p."+colNames[COL_STATUS]+"="+STATUS_APPROVE+
                         " and p."+colNames[COL_TYPE]+" = "+TYPE_PINJAMAN_KOPERASI+
                         " and p."+colNames[COL_JENIS_BARANG]+" = "+jenisBarang+
                         " and pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_MEMBER_ID]+" = "+memberId+
                         " and pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_STATUS]+"="+DbPinjaman.PAYMENT_STATUS_DRAFT+
                         " and (month(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_JATUH_TEMPO]+")"+
                         " <= month('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"') "+
                         " and year(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_JATUH_TEMPO]+")"+
                         " <=year('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'))";
            
            System.out.println(sql);
            
            Vector v = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    PinjamanDetail pd = new PinjamanDetail();    
                    DbPinjamanDetail.resultToObject(rs, pd);
                    v.add(pd);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            if(v!=null && v.size()>0){
                for(int i=0; i<v.size(); i++){
                    PinjamanDetail pd = (PinjamanDetail)v.get(i);
                    
                    Pinjaman p = new Pinjaman();
                    try{
                        p = DbPinjaman.fetchExc(pd.getPinjamanId());
                    }
                    catch(Exception e){
                        
                    }
                    
                    BayarPinjaman bp = new BayarPinjaman();
                    bp.setAmount(pd.getAmount());
                    bp.setBunga(pd.getBunga());
                    bp.setCicilanKe(pd.getCicilanKe());
                    bp.setPinjamanDetailId(pd.getOID());
                    bp.setPinjamanId(p.getOID());
                    //bp.setType(p.getType());
                    bp.setTypePinjaman(p.getType());
                    bp.setTanggal(new Date());
                    bp.setCounter(DbBayarPinjaman.getNextCounter(p.getType()));
                    bp.setPrefixNumber(DbBayarPinjaman.getNumberPrefix(p.getType()));
                    bp.setNoTransaksi(DbBayarPinjaman.getNextNumber(bp.getCounter(), p.getType()));
                    
                    try{
                        DbBayarPinjaman.insertExc(bp);
                    }
                    catch(Exception e){
                    }
                    
                    try{
                        pd.setStatus(DbPinjaman.PAYMENT_STATUS_LUNAS);
                        DbPinjamanDetail.updateExc(pd);
                    }
                    catch(Exception e){
                    }
                    
                }
            }
            
            //return result;
            
        }
        
        
        public static PinjamanDetail getTotalTagihanBank(long memberId, Date dt){
            
            String sql = " select sum(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_AMOUNT]+"),"+
                         " sum(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_BUNGA]+") "+
                         " from "+DbPinjamanDetail.DB_PINJAMAN_DETAIL+" pd "+
                         " inner join "+DB_PINJAMAM+" p on p."+colNames[COL_PINJAMAN_ID]+
                         " = pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_ID]+
                         " where "+
                         " p."+colNames[COL_STATUS]+"="+STATUS_APPROVE+
                         " and p."+colNames[COL_TYPE]+" = "+TYPE_PINJAMAN_BANK+                         
                         " and pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_MEMBER_ID]+" = "+memberId+
                         " and pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_STATUS]+"="+DbPinjaman.PAYMENT_STATUS_DRAFT+
                         " and (month(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_JATUH_TEMPO]+")"+
                         " <= month('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"') "+
                         " and year(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_JATUH_TEMPO]+")"+
                         " <=year('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'))";
            
            System.out.println(sql);
            
            PinjamanDetail result = new PinjamanDetail();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    //result = rs.getDouble(1);
                    result.setAmount(rs.getDouble(1)); 
                    result.setBunga(rs.getDouble(2));
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        
        public static void getPaidTagihanBankByPotongGaji(long memberId, Date dt){
            
            String sql = " select pd.* "+
                         " from "+DbPinjamanDetail.DB_PINJAMAN_DETAIL+" pd "+
                         " inner join "+DB_PINJAMAM+" p on p."+colNames[COL_PINJAMAN_ID]+
                         " = pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_PINJAMAN_ID]+
                         " where "+
                         " p."+colNames[COL_STATUS]+"="+STATUS_APPROVE+
                         " and p."+colNames[COL_TYPE]+" = "+TYPE_PINJAMAN_BANK+                         
                         " and pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_MEMBER_ID]+" = "+memberId+
                         " and pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_STATUS]+"="+DbPinjaman.PAYMENT_STATUS_DRAFT+
                         " and (month(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_JATUH_TEMPO]+")"+
                         " <= month('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"') "+
                         " and year(pd."+DbPinjamanDetail.colNames[DbPinjamanDetail.COL_JATUH_TEMPO]+")"+
                         " <=year('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'))";
            
            System.out.println("\n\n================== \n"+sql);
            
            Vector v = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    PinjamanDetail result = new PinjamanDetail();
                    DbPinjamanDetail.resultToObject(rs, result);
                    v.add(result);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            if(v!=null && v.size()>0){
                for(int i=0; i<v.size(); i++){
                    PinjamanDetail pd = (PinjamanDetail)v.get(i);
                    
                    Pinjaman p = new Pinjaman();
                    try{
                        p = DbPinjaman.fetchExc(pd.getPinjamanId());
                    }
                    catch(Exception e){
                        
                    }
                    
                    BayarPinjaman bp = new BayarPinjaman();
                    bp.setAmount(pd.getAmount());
                    bp.setBunga(pd.getBunga());
                    bp.setCicilanKe(pd.getCicilanKe());
                    bp.setPinjamanDetailId(pd.getOID());
                    bp.setPinjamanId(p.getOID());
                    //bp.setType(p.getType());
                    bp.setTypePinjaman(p.getType());
                    bp.setTanggal(new Date());
                    bp.setCounter(DbBayarPinjaman.getNextCounter(p.getType()));
                    bp.setPrefixNumber(DbBayarPinjaman.getNumberPrefix(p.getType()));
                    bp.setNoTransaksi(DbBayarPinjaman.getNextNumber(bp.getCounter(), p.getType()));
                    
                    try{
                        DbBayarPinjaman.insertExc(bp);
                    }
                    catch(Exception e){
                    }
                    
                    try{
                        pd.setStatus(DbPinjaman.PAYMENT_STATUS_LUNAS);
                        DbPinjamanDetail.updateExc(pd);
                    }
                    catch(Exception e){
                    }
                    
                }
            }
            
        }
        
        
        public static Vector getSaldoPiutang(int type){
            
            String sql = "select p."+colNames[COL_MEMBER_ID];
                        
                        //detail
                        if(type==1){
                            sql = sql + ", p."+colNames[COL_PINJAMAN_ID]+", p."+colNames[COL_NUMBER]+", p."+colNames[COL_DATE]+
                            ", p."+colNames[COL_TOTAL_PINJAMAN];
                        }
                        else{
                            sql = sql + ", sum(p."+colNames[COL_TOTAL_PINJAMAN]+") as "+colNames[COL_TOTAL_PINJAMAN];
                        }
            
                        sql = sql +                        
                        " from "+DB_PINJAMAM+" p "+
                        " where p."+colNames[COL_STATUS]+"="+STATUS_APPROVE+" and p."+colNames[COL_MEMBER_ID]+"!=0 ";
                        
                        
                        if(type==0){
                            sql = sql + " group by p."+colNames[COL_MEMBER_ID];                           
                        }
                        
                        sql = sql + " order by p."+colNames[COL_MEMBER_ID]+", p."+colNames[COL_DATE]+", p."+colNames[COL_NUMBER];
                        
                        System.out.println("===========\n"+sql);
            
            CONResultSet crs = null;
            Vector result = new Vector();
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Pinjaman p = new Pinjaman();
                    p.setMemberId(rs.getLong(1));
                    if(type==1){
                        p.setOID(rs.getLong(2));
                        p.setNumber(rs.getString(3));
                        p.setDate(rs.getDate(4));
                        p.setTotalPinjaman(rs.getDouble(5));
                        //p.setCicilan(rs.getDouble(6));
                    }
                    else{
                        p.setTotalPinjaman(rs.getDouble(2));
                        //p.setCicilan(rs.getDouble(3));
                    }
                    //DbPinjaman.resultToObject(rs,p);
                    result.add(p);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            //get Total Payment
            if(result!=null && result.size()>0){
                for(int i=0; i<result.size(); i++){
                    
                    Pinjaman p = (Pinjaman)result.get(i);
                    
                    if(type==0){
                        p.setCicilan(DbBayarPinjaman.getTotalPaymentByMember(p.getMemberId()));
                    }
                    else{
                        p.setCicilan(DbBayarPinjaman.getTotalPayment(p.getOID()));
                    }
                    
                }
            }
            
            return result;
            
        }
        
        
        public static Vector getSaldoPiutang(int type, int jenisBarang, int jenisPinjaman){
            
            String sql = "select p."+colNames[COL_MEMBER_ID];
                        
                        //detail per rekening
                        if(type==1){
                            sql = sql + ", p."+colNames[COL_PINJAMAN_ID]+", p."+colNames[COL_NUMBER]+", p."+colNames[COL_DATE]+
                            ", p."+colNames[COL_TOTAL_PINJAMAN];
                        }
                        //per member
                        else{
                            sql = sql + ", sum(p."+colNames[COL_TOTAL_PINJAMAN]+") as "+colNames[COL_TOTAL_PINJAMAN];
                        }
            
                        sql = sql +                        
                        " from "+DB_PINJAMAM+" p "+
                        " where p."+colNames[COL_STATUS]+"="+STATUS_APPROVE+" and p."+colNames[COL_MEMBER_ID]+"!=0 "+
                        " and p."+colNames[COL_JENIS_BARANG]+"="+jenisBarang;
                        
                        if(jenisPinjaman!=-1){
                            sql = sql + " and p."+colNames[COL_TYPE]+"="+jenisPinjaman;
                        }
                        
                        if(type==0){
                            sql = sql + " group by p."+colNames[COL_MEMBER_ID];                           
                        }
                        
                        sql = sql + " order by p."+colNames[COL_MEMBER_ID]+", p."+colNames[COL_DATE]+", p."+colNames[COL_NUMBER];
                        
                        System.out.println("===========\n"+sql);
            
            CONResultSet crs = null;
            Vector result = new Vector();
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Pinjaman p = new Pinjaman();
                    p.setMemberId(rs.getLong(1));
                    if(type==1){
                        p.setOID(rs.getLong(2));
                        p.setNumber(rs.getString(3));
                        p.setDate(rs.getDate(4));
                        p.setTotalPinjaman(rs.getDouble(5));
                        //p.setCicilan(rs.getDouble(6));
                    }
                    else{
                        p.setTotalPinjaman(rs.getDouble(2));
                        //p.setCicilan(rs.getDouble(3));
                    }
                    //DbPinjaman.resultToObject(rs,p);
                    result.add(p);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            //get Total Payment
            if(result!=null && result.size()>0){
                for(int i=0; i<result.size(); i++){
                    
                    Pinjaman p = (Pinjaman)result.get(i);
                    
                    if(type==0){
                        p.setCicilan(DbBayarPinjaman.getTotalPaymentByMember(p.getMemberId(), jenisBarang, jenisPinjaman));
                    }
                    else{
                        p.setCicilan(DbBayarPinjaman.getTotalPayment(p.getOID())); 
                    }
                    
                }
            }
            
            return result;
            
        }
        
        
        public static Vector getSaldoHutang(int type){
            
            String sql = "select p."+colNames[COL_MEMBER_ID];
                        
                        //detail
                        if(type==1){
                            sql = sql + ", p."+colNames[COL_PINJAMAN_ID]+", p."+colNames[COL_NUMBER]+", p."+colNames[COL_DATE]+
                            ", p."+colNames[COL_TOTAL_PINJAMAN]+", p."+colNames[COL_BANK_ID];
                        }
                        else{
                            sql = sql + ", sum(p."+colNames[COL_TOTAL_PINJAMAN]+") as "+colNames[COL_TOTAL_PINJAMAN];
                        }
            
                        sql = sql +                        
                        " from "+DB_PINJAMAM+" p "+
                        " where p."+colNames[COL_STATUS]+"="+STATUS_APPROVE+" and p."+colNames[COL_MEMBER_ID]+"=0 ";
                        
                        
                        if(type==0){
                            sql = sql + " group by p."+colNames[COL_MEMBER_ID];                           
                        }
                        
                        sql = sql + " order by p."+colNames[COL_MEMBER_ID]+", p."+colNames[COL_DATE]+", p."+colNames[COL_NUMBER];
                        
                        System.out.println("===========\n"+sql);
            
            CONResultSet crs = null;
            Vector result = new Vector();
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Pinjaman p = new Pinjaman();
                    p.setMemberId(rs.getLong(1));
                    if(type==1){
                        p.setOID(rs.getLong(2));
                        p.setNumber(rs.getString(3));
                        p.setDate(rs.getDate(4));
                        p.setTotalPinjaman(rs.getDouble(5));
                        p.setBankId(rs.getLong(6));
                    }
                    else{
                        p.setTotalPinjaman(rs.getDouble(2));
                        //p.setCicilan(rs.getDouble(3));
                    }
                    //DbPinjaman.resultToObject(rs,p);
                    result.add(p);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            //get Total Payment
            if(result!=null && result.size()>0){
                for(int i=0; i<result.size(); i++){
                    
                    Pinjaman p = (Pinjaman)result.get(i);
                    
                    if(type==0){
                        p.setCicilan(DbBayarPinjaman.getTotalPaymentByMember(p.getMemberId()));
                    }
                    else{
                        p.setCicilan(DbBayarPinjaman.getTotalPayment(p.getOID()));
                    }
                    
                }
            }
            
            return result;
            
        }
    
        
        
}

