/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.util.*; 
import com.project.crm.master.*;

/**
 *
 * @author Roy Andika
 */
public class DbSewaTanahRincianPiutangProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
    public static final  String DB_PROP_SEWA_TANAH_RINCIAN_PIUTANG = "prop_sewa_tanah_rincian_piutang";

	public static final  int COL_SEWA_TANAH_RINCIAN_PIUTANG_ID = 0;
	public static final  int COL_SARANA_ID = 1;
	public static final  int COL_INVESTOR_ID = 2;
	public static final  int COL_SEWA_TANAH_ID = 3;
	public static final  int COL_LUAS_LAHAN = 4;
	public static final  int COL_MULAI_SEWA = 5;
	public static final  int COL_LOT_ID = 6;
	public static final  int COL_KOMIN_CURRENCY_ID = 7;
	public static final  int COL_PERIODE_TAHUN = 8;
	public static final  int COL_NILAI_KOMIN_TH = 9;
	public static final  int COL_MASA_KOMIN_ID = 10;
	public static final  int COL_MASA_KOMIN_JML_BULAN = 11;
	public static final  int COL_MASA_ASSES_ID = 12;
	public static final  int COL_MASA_ASSES_JML_BULAN = 13;
	public static final  int COL_NILAI_ASSES_TH = 14;
	public static final  int COL_PERHITUNGAN_ASSES_NOTE = 15;
	public static final  int COL_PERHITUNGAN_KOMIN_NOTE = 16;
	public static final  int COL_ASSES_CURRENCY_ID = 17;
	public static final  int COL_KETERANGAN = 18;
	public static final  int COL_PERHITUNGAN_ASSES1 = 19;
	public static final  int COL_PERHITUNGAN_ASSES2 = 20;
	public static final  int COL_PERHITUNGAN_KOMIN1 = 21;
	public static final  int COL_PERHITUNGAN_KOMIN2 = 22;

	public static final  String[] colNames = {
		"sewa_tanah_rincian_piutang_id",
		"sarana_id",
		"investor_id",
		"sewa_tanah_id",
		"luas_lahan",
		"mulai_sewa",
		"lot_id",
		"komin_currency_id",
		"periode_tahun",
		"nilai_komin_th",
		"masa_komin_id",
		"masa_komin_jml_bulan",
		"masa_asses_id",
		"masa_asses_jml_bulan",
		"nilai_asses_th",
		"perhitungan_asses_note",
		"perhitungan_komin_note",
		"asses_currency_id",
		"keterangan",
		"perhitungan_asses1",
		"perhitungan_asses2",
		"perhitungan_komin1",
		"perhitungan_komin2"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_INT,
		TYPE_LONG,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT
	 }; 

	public DbSewaTanahRincianPiutangProp(){
	}

	public DbSewaTanahRincianPiutangProp(int i) throws CONException { 
		super(new DbSewaTanahRincianPiutangProp()); 
	}

	public DbSewaTanahRincianPiutangProp(String sOid) throws CONException { 
		super(new DbSewaTanahRincianPiutangProp(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSewaTanahRincianPiutangProp(long lOid) throws CONException { 
		super(new DbSewaTanahRincianPiutangProp(0)); 
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
		return DB_PROP_SEWA_TANAH_RINCIAN_PIUTANG;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSewaTanahRincianPiutangProp().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SewaTanahRincianPiutangProp sewaTanahRincianPiutangProp = fetchExc(ent.getOID()); 
		ent = (Entity)sewaTanahRincianPiutangProp; 
		return sewaTanahRincianPiutangProp.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SewaTanahRincianPiutangProp) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SewaTanahRincianPiutangProp) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SewaTanahRincianPiutangProp fetchExc(long oid) throws CONException{ 
		try{ 
			SewaTanahRincianPiutangProp sewaTanahRincianPiutangProp = new SewaTanahRincianPiutangProp();
			DbSewaTanahRincianPiutangProp pstSewaTanahRincianPiutang = new DbSewaTanahRincianPiutangProp(oid); 
			sewaTanahRincianPiutangProp.setOID(oid);

			sewaTanahRincianPiutangProp.setSaranaId(pstSewaTanahRincianPiutang.getlong(COL_SARANA_ID));
			sewaTanahRincianPiutangProp.setInvestorId(pstSewaTanahRincianPiutang.getlong(COL_INVESTOR_ID));
			sewaTanahRincianPiutangProp.setSewaTanahId(pstSewaTanahRincianPiutang.getlong(COL_SEWA_TANAH_ID));
			sewaTanahRincianPiutangProp.setLuasLahan(pstSewaTanahRincianPiutang.getdouble(COL_LUAS_LAHAN));
			sewaTanahRincianPiutangProp.setMulaiSewa(pstSewaTanahRincianPiutang.getDate(COL_MULAI_SEWA));
			sewaTanahRincianPiutangProp.setLotId(pstSewaTanahRincianPiutang.getlong(COL_LOT_ID));
			sewaTanahRincianPiutangProp.setKominCurrencyId(pstSewaTanahRincianPiutang.getlong(COL_KOMIN_CURRENCY_ID));
			sewaTanahRincianPiutangProp.setPeriodeTahun(pstSewaTanahRincianPiutang.getInt(COL_PERIODE_TAHUN));
			sewaTanahRincianPiutangProp.setNilaiKominTh(pstSewaTanahRincianPiutang.getdouble(COL_NILAI_KOMIN_TH));
			sewaTanahRincianPiutangProp.setMasaKominId(pstSewaTanahRincianPiutang.getlong(COL_MASA_KOMIN_ID));
			sewaTanahRincianPiutangProp.setMasaKominJmlBulan(pstSewaTanahRincianPiutang.getInt(COL_MASA_KOMIN_JML_BULAN));
			sewaTanahRincianPiutangProp.setMasaAssesId(pstSewaTanahRincianPiutang.getlong(COL_MASA_ASSES_ID));
			sewaTanahRincianPiutangProp.setMasaAssesJmlBulan(pstSewaTanahRincianPiutang.getInt(COL_MASA_ASSES_JML_BULAN));
			sewaTanahRincianPiutangProp.setNilaiAssesTh(pstSewaTanahRincianPiutang.getdouble(COL_NILAI_ASSES_TH));
			sewaTanahRincianPiutangProp.setPerhitunganAssesNote(pstSewaTanahRincianPiutang.getString(COL_PERHITUNGAN_ASSES_NOTE));
			sewaTanahRincianPiutangProp.setPerhitunganKominNote(pstSewaTanahRincianPiutang.getString(COL_PERHITUNGAN_KOMIN_NOTE));
			sewaTanahRincianPiutangProp.setAssesCurrencyId(pstSewaTanahRincianPiutang.getlong(COL_ASSES_CURRENCY_ID));
			sewaTanahRincianPiutangProp.setKeterangan(pstSewaTanahRincianPiutang.getString(COL_KETERANGAN));
			sewaTanahRincianPiutangProp.setPerhitunganAsses1(pstSewaTanahRincianPiutang.getdouble(COL_PERHITUNGAN_ASSES1));
			sewaTanahRincianPiutangProp.setPerhitunganAsses2(pstSewaTanahRincianPiutang.getdouble(COL_PERHITUNGAN_ASSES2));
			sewaTanahRincianPiutangProp.setPerhitunganKomin1(pstSewaTanahRincianPiutang.getdouble(COL_PERHITUNGAN_KOMIN1));
			sewaTanahRincianPiutangProp.setPerhitunganKomin2(pstSewaTanahRincianPiutang.getdouble(COL_PERHITUNGAN_KOMIN2));

			return sewaTanahRincianPiutangProp; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahRincianPiutangProp(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SewaTanahRincianPiutangProp sewaTanahRincianPiutangProp) throws CONException{ 
		try{ 
			DbSewaTanahRincianPiutangProp pstSewaTanahRincianPiutang = new DbSewaTanahRincianPiutangProp(0);

			pstSewaTanahRincianPiutang.setLong(COL_SARANA_ID, sewaTanahRincianPiutangProp.getSaranaId());
			pstSewaTanahRincianPiutang.setLong(COL_INVESTOR_ID, sewaTanahRincianPiutangProp.getInvestorId());
			pstSewaTanahRincianPiutang.setLong(COL_SEWA_TANAH_ID, sewaTanahRincianPiutangProp.getSewaTanahId());
			pstSewaTanahRincianPiutang.setDouble(COL_LUAS_LAHAN, sewaTanahRincianPiutangProp.getLuasLahan());
			pstSewaTanahRincianPiutang.setDate(COL_MULAI_SEWA, sewaTanahRincianPiutangProp.getMulaiSewa());
			pstSewaTanahRincianPiutang.setLong(COL_LOT_ID, sewaTanahRincianPiutangProp.getLotId());
			pstSewaTanahRincianPiutang.setLong(COL_KOMIN_CURRENCY_ID, sewaTanahRincianPiutangProp.getKominCurrencyId());
			pstSewaTanahRincianPiutang.setInt(COL_PERIODE_TAHUN, sewaTanahRincianPiutangProp.getPeriodeTahun());
			pstSewaTanahRincianPiutang.setDouble(COL_NILAI_KOMIN_TH, sewaTanahRincianPiutangProp.getNilaiKominTh());
			pstSewaTanahRincianPiutang.setLong(COL_MASA_KOMIN_ID, sewaTanahRincianPiutangProp.getMasaKominId());
			pstSewaTanahRincianPiutang.setInt(COL_MASA_KOMIN_JML_BULAN, sewaTanahRincianPiutangProp.getMasaKominJmlBulan());
			pstSewaTanahRincianPiutang.setLong(COL_MASA_ASSES_ID, sewaTanahRincianPiutangProp.getMasaAssesId());
			pstSewaTanahRincianPiutang.setInt(COL_MASA_ASSES_JML_BULAN, sewaTanahRincianPiutangProp.getMasaAssesJmlBulan());
			pstSewaTanahRincianPiutang.setDouble(COL_NILAI_ASSES_TH, sewaTanahRincianPiutangProp.getNilaiAssesTh());
			pstSewaTanahRincianPiutang.setString(COL_PERHITUNGAN_ASSES_NOTE, sewaTanahRincianPiutangProp.getPerhitunganAssesNote());
			pstSewaTanahRincianPiutang.setString(COL_PERHITUNGAN_KOMIN_NOTE, sewaTanahRincianPiutangProp.getPerhitunganKominNote());
			pstSewaTanahRincianPiutang.setLong(COL_ASSES_CURRENCY_ID, sewaTanahRincianPiutangProp.getAssesCurrencyId());
			pstSewaTanahRincianPiutang.setString(COL_KETERANGAN, sewaTanahRincianPiutangProp.getKeterangan());
			pstSewaTanahRincianPiutang.setDouble(COL_PERHITUNGAN_ASSES1, sewaTanahRincianPiutangProp.getPerhitunganAsses1());
			pstSewaTanahRincianPiutang.setDouble(COL_PERHITUNGAN_ASSES2, sewaTanahRincianPiutangProp.getPerhitunganAsses2());
			pstSewaTanahRincianPiutang.setDouble(COL_PERHITUNGAN_KOMIN1, sewaTanahRincianPiutangProp.getPerhitunganKomin1());
			pstSewaTanahRincianPiutang.setDouble(COL_PERHITUNGAN_KOMIN2, sewaTanahRincianPiutangProp.getPerhitunganKomin2());

			pstSewaTanahRincianPiutang.insert(); 
			sewaTanahRincianPiutangProp.setOID(pstSewaTanahRincianPiutang.getlong(COL_SEWA_TANAH_RINCIAN_PIUTANG_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahRincianPiutangProp(0),CONException.UNKNOWN); 
		}
		return sewaTanahRincianPiutangProp.getOID();
	}

	public static long updateExc(SewaTanahRincianPiutangProp sewaTanahRincianPiutangProp) throws CONException{ 
		try{ 
			if(sewaTanahRincianPiutangProp.getOID() != 0){ 
				DbSewaTanahRincianPiutangProp pstSewaTanahRincianPiutang = new DbSewaTanahRincianPiutangProp(sewaTanahRincianPiutangProp.getOID());

				pstSewaTanahRincianPiutang.setLong(COL_SARANA_ID, sewaTanahRincianPiutangProp.getSaranaId());
				pstSewaTanahRincianPiutang.setLong(COL_INVESTOR_ID, sewaTanahRincianPiutangProp.getInvestorId());
				pstSewaTanahRincianPiutang.setLong(COL_SEWA_TANAH_ID, sewaTanahRincianPiutangProp.getSewaTanahId());
				pstSewaTanahRincianPiutang.setDouble(COL_LUAS_LAHAN, sewaTanahRincianPiutangProp.getLuasLahan());
				pstSewaTanahRincianPiutang.setDate(COL_MULAI_SEWA, sewaTanahRincianPiutangProp.getMulaiSewa());
				pstSewaTanahRincianPiutang.setLong(COL_LOT_ID, sewaTanahRincianPiutangProp.getLotId());
				pstSewaTanahRincianPiutang.setLong(COL_KOMIN_CURRENCY_ID, sewaTanahRincianPiutangProp.getKominCurrencyId());
				pstSewaTanahRincianPiutang.setInt(COL_PERIODE_TAHUN, sewaTanahRincianPiutangProp.getPeriodeTahun());
				pstSewaTanahRincianPiutang.setDouble(COL_NILAI_KOMIN_TH, sewaTanahRincianPiutangProp.getNilaiKominTh());
				pstSewaTanahRincianPiutang.setLong(COL_MASA_KOMIN_ID, sewaTanahRincianPiutangProp.getMasaKominId());
				pstSewaTanahRincianPiutang.setInt(COL_MASA_KOMIN_JML_BULAN, sewaTanahRincianPiutangProp.getMasaKominJmlBulan());
				pstSewaTanahRincianPiutang.setLong(COL_MASA_ASSES_ID, sewaTanahRincianPiutangProp.getMasaAssesId());
				pstSewaTanahRincianPiutang.setInt(COL_MASA_ASSES_JML_BULAN, sewaTanahRincianPiutangProp.getMasaAssesJmlBulan());
				pstSewaTanahRincianPiutang.setDouble(COL_NILAI_ASSES_TH, sewaTanahRincianPiutangProp.getNilaiAssesTh());
				pstSewaTanahRincianPiutang.setString(COL_PERHITUNGAN_ASSES_NOTE, sewaTanahRincianPiutangProp.getPerhitunganAssesNote());
				pstSewaTanahRincianPiutang.setString(COL_PERHITUNGAN_KOMIN_NOTE, sewaTanahRincianPiutangProp.getPerhitunganKominNote());
				pstSewaTanahRincianPiutang.setLong(COL_ASSES_CURRENCY_ID, sewaTanahRincianPiutangProp.getAssesCurrencyId());
				pstSewaTanahRincianPiutang.setString(COL_KETERANGAN, sewaTanahRincianPiutangProp.getKeterangan());
				pstSewaTanahRincianPiutang.setDouble(COL_PERHITUNGAN_ASSES1, sewaTanahRincianPiutangProp.getPerhitunganAsses1());
				pstSewaTanahRincianPiutang.setDouble(COL_PERHITUNGAN_ASSES2, sewaTanahRincianPiutangProp.getPerhitunganAsses2());
				pstSewaTanahRincianPiutang.setDouble(COL_PERHITUNGAN_KOMIN1, sewaTanahRincianPiutangProp.getPerhitunganKomin1());
				pstSewaTanahRincianPiutang.setDouble(COL_PERHITUNGAN_KOMIN2, sewaTanahRincianPiutangProp.getPerhitunganKomin2());

				pstSewaTanahRincianPiutang.update(); 
				return sewaTanahRincianPiutangProp.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahRincianPiutangProp(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSewaTanahRincianPiutangProp pstSewaTanahRincianPiutang = new DbSewaTanahRincianPiutangProp(oid);
			pstSewaTanahRincianPiutang.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahRincianPiutangProp(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_RINCIAN_PIUTANG; 
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
				SewaTanahRincianPiutangProp sewaTanahRincianPiutangProp = new SewaTanahRincianPiutangProp();
				resultToObject(rs, sewaTanahRincianPiutangProp);
				lists.add(sewaTanahRincianPiutangProp);
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

	private static void resultToObject(ResultSet rs, SewaTanahRincianPiutangProp sewaTanahRincianPiutangProp){
		try{
			sewaTanahRincianPiutangProp.setOID(rs.getLong(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_SEWA_TANAH_RINCIAN_PIUTANG_ID]));
			sewaTanahRincianPiutangProp.setSaranaId(rs.getLong(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_SARANA_ID]));
			sewaTanahRincianPiutangProp.setInvestorId(rs.getLong(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_INVESTOR_ID]));
			sewaTanahRincianPiutangProp.setSewaTanahId(rs.getLong(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_SEWA_TANAH_ID]));
			sewaTanahRincianPiutangProp.setLuasLahan(rs.getDouble(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_LUAS_LAHAN]));
			sewaTanahRincianPiutangProp.setMulaiSewa(rs.getDate(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_MULAI_SEWA]));
			sewaTanahRincianPiutangProp.setLotId(rs.getLong(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_LOT_ID]));
			sewaTanahRincianPiutangProp.setKominCurrencyId(rs.getLong(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_KOMIN_CURRENCY_ID]));
			sewaTanahRincianPiutangProp.setPeriodeTahun(rs.getInt(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_PERIODE_TAHUN]));
			sewaTanahRincianPiutangProp.setNilaiKominTh(rs.getDouble(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_NILAI_KOMIN_TH]));
			sewaTanahRincianPiutangProp.setMasaKominId(rs.getLong(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_MASA_KOMIN_ID]));
			sewaTanahRincianPiutangProp.setMasaKominJmlBulan(rs.getInt(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_MASA_KOMIN_JML_BULAN]));
			sewaTanahRincianPiutangProp.setMasaAssesId(rs.getLong(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_MASA_ASSES_ID]));
			sewaTanahRincianPiutangProp.setMasaAssesJmlBulan(rs.getInt(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_MASA_ASSES_JML_BULAN]));
			sewaTanahRincianPiutangProp.setNilaiAssesTh(rs.getDouble(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_NILAI_ASSES_TH]));
			sewaTanahRincianPiutangProp.setPerhitunganAssesNote(rs.getString(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_PERHITUNGAN_ASSES_NOTE]));
			sewaTanahRincianPiutangProp.setPerhitunganKominNote(rs.getString(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_PERHITUNGAN_KOMIN_NOTE]));
			sewaTanahRincianPiutangProp.setAssesCurrencyId(rs.getLong(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_ASSES_CURRENCY_ID]));
			sewaTanahRincianPiutangProp.setKeterangan(rs.getString(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_KETERANGAN]));
			sewaTanahRincianPiutangProp.setPerhitunganAsses1(rs.getDouble(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_PERHITUNGAN_ASSES1]));
			sewaTanahRincianPiutangProp.setPerhitunganAsses2(rs.getDouble(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_PERHITUNGAN_ASSES2]));
			sewaTanahRincianPiutangProp.setPerhitunganKomin1(rs.getDouble(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_PERHITUNGAN_KOMIN1]));
			sewaTanahRincianPiutangProp.setPerhitunganKomin2(rs.getDouble(DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_PERHITUNGAN_KOMIN2]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long sewaTanahRincianPiutangId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_RINCIAN_PIUTANG + " WHERE " + 
						DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_SEWA_TANAH_RINCIAN_PIUTANG_ID] + " = " + sewaTanahRincianPiutangId;

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
			String sql = "SELECT COUNT("+ DbSewaTanahRincianPiutangProp.colNames[DbSewaTanahRincianPiutangProp.COL_SEWA_TANAH_RINCIAN_PIUTANG_ID] + ") FROM " + DB_PROP_SEWA_TANAH_RINCIAN_PIUTANG;
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
			  	   SewaTanahRincianPiutangProp sewaTanahRincianPiutangProp = (SewaTanahRincianPiutangProp)list.get(ls);
				   if(oid == sewaTanahRincianPiutangProp.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
	
    public static Vector getSaranRincianPiutang(int year) {

        //Vector temp = list(0,0, colNames[COL_PERIODE_TAHUN]+"="+year, ""); [codeA]

        //mengambil daftar kontrak yang belum memiliki daftar piutang
        Vector list = DbSewaTanahProp.getSewaTanahList(year);

        // kalau sudah ada rincian tahunan, return message
        //if(temp!=null && temp.size()>0){ [codeA]
        if (list == null && list.size() == 0) {
            Vector v = new Vector();
            v.add("" + 1);
            v.add("Sudah ada rincian tahun " + year);
            v.add(new Vector());

            return v;
        } else {
            Vector v = new Vector();
            v.add("0");
            v.add("belum ada");

            Vector xval = new Vector();
            v.add(xval);

            Vector aktifKontrak = list; //DbSewaTanahProp.list(0,0, DbSewaTanahProp.colNames[DbSewaTanahProp.COL_STATUS]+"="+DbSewaTanahProp.STATUS_AKTIF, "");

            if (aktifKontrak != null && aktifKontrak.size() > 0) {

                String keteranganKomin = "";
                String keteranganAsses = "";
                UnitContract uc = new UnitContract();

                for (int x = 0; x < aktifKontrak.size(); x++) {
                    keteranganKomin = "";
                    keteranganAsses = "";

                    SewaTanahProp st = (SewaTanahProp) aktifKontrak.get(x);
                    SewaTanahRincianPiutangProp stp = new SewaTanahRincianPiutangProp();
                    stp.setKominCurrencyId(st.getCurrencyId());
                    stp.setInvestorId(st.getInvestorId());
                    stp.setLotId(st.getLotId());
                    stp.setLuasLahan(st.getLuas());
                    stp.setSaranaId(st.getCustomerId());
                    stp.setSewaTanahId(st.getOID());
                    stp.setPeriodeTahun(year);
                    stp.setMulaiSewa(st.getTanggalMulai());

                    //komin
                    SewaTanahKominProp stk = DbSewaTanahKominProp.getActifKomin(year, st.getOID());

                    if (stk.getOID() != 0) {
                        
                        try {
                            uc = DbUnitContract.fetchExc(stk.getUnitKontrakId());
                        } catch (Exception e) {
                        }
                        
                        double yrx = 12 / uc.getJmlBulan();

                        stp.setPerhitunganKomin1(stk.getRate() * yrx);
                        stp.setMasaKominId(stk.getUnitKontrakId());
                        stp.setMasaKominJmlBulan(uc.getJmlBulan());

                        String kominnote = "";

                        if (stk.getDasarPerhitungan() == DbSewaTanahKominProp.KOMIN_BY_SQUARE) {
                            stp.setPerhitunganKomin2(st.getLuas());
                            stp.setNilaiKominTh(stk.getRate() * st.getLuas());
                            kominnote = stk.getRate() + " X " + JSPFormater.formatNumber(st.getLuas(), "#,###") + " m2";
                        } else if(stk.getDasarPerhitungan() == DbSewaTanahKominProp.KOMIN_BY_ROOM) {
                            stp.setPerhitunganKomin2(st.getJmlKamar());
                            stp.setNilaiKominTh(stk.getRate() * st.getJmlKamar());
                            kominnote = stk.getRate() + " X " + JSPFormater.formatNumber(st.getJmlKamar(), "#,###") + " AR";
                        } else if(stk.getDasarPerhitungan() == DbSewaTanahKominProp.KOMIN_BY_TOTAL) {
                            stp.setPerhitunganKomin2(1);
                            stp.setNilaiKominTh(stk.getRate());
                            kominnote = "1 X " + stk.getRate();
                        }

                        stp.setPerhitunganKominNote(kominnote);
                    } else {
                        keteranganKomin = "Tidak ada komin aktif.";
                    }
                    
                    //assesment
                    SewaTanahAssesmentProp stass = DbSewaTanahAssesmentProp.getActifAssesment(year, st.getOID());
                    
                    if (stass.getOID() != 0) {
                        try {
                            uc = DbUnitContract.fetchExc(stass.getUnitKontrakId());
                        } catch (Exception e) {
                        }

                        double yrx1 = 12 / uc.getJmlBulan();

                        stp.setPerhitunganAsses1(stass.getRate() * yrx1);
                        stp.setMasaAssesId(stass.getUnitKontrakId());
                        stp.setMasaAssesJmlBulan(uc.getJmlBulan());
                        stp.setAssesCurrencyId(stass.getCurrencyId());

                        String assesmentnote = "";

                        if (stass.getDasarPerhitungan() == DbSewaTanahAssesmentProp.DASAR_LUAS) {
                            stp.setPerhitunganAsses2(st.getLuas());
                            stp.setNilaiAssesTh(stass.getRate() * st.getLuas());
                            assesmentnote = stass.getRate() + " X " + JSPFormater.formatNumber(st.getLuas(), "#,###") + " m2";
                        } else if (stass.getDasarPerhitungan() == DbSewaTanahAssesmentProp.DASAR_KAMAR) {
                            stp.setPerhitunganAsses2(st.getJmlKamar());
                            stp.setNilaiAssesTh(stass.getRate() * st.getJmlKamar());
                            assesmentnote = stass.getRate() + " X " + JSPFormater.formatNumber(stp.getPerhitunganAsses2(), "#,###") + " AR";
                        } else {
                            stp.setPerhitunganAsses2(1);
                            stp.setNilaiAssesTh(stass.getRate());
                            assesmentnote = "1 X " + stass.getRate();
                        }

                        stp.setPerhitunganAssesNote(assesmentnote);
                    } else {
                        keteranganAsses = "Tidak ada assesment aktif.";
                    }

                    stp.setKeterangan(keteranganKomin + " " + keteranganAsses);
                    xval.add(stp);
                }
            }
            return v;
        }
    }
    
    public static Vector getRincianPiutang(int year){
        
        //mengambil daftar kontrak yang belum memiliki daftar piutang
        Vector list = DbSewaTanahProp.getSewaTanahList(year);

        // kalau sudah ada rincian tahunan, return message
        //if(temp!=null && temp.size()>0){ [codeA]
        if (list == null && list.size() == 0) {
            Vector v = new Vector();
            v.add("" + 1);
            v.add("Sudah ada rincian tahun " + year);
            v.add(new Vector());

            return v;
            
        } else {
            
            Vector v = new Vector();
            v.add("0");
            v.add("belum ada");

            Vector xval = new Vector();
            v.add(xval);

            Vector aktifKontrak = list;

            if (aktifKontrak != null && aktifKontrak.size() > 0) {

                String keteranganKomin = "";
                
                UnitContract uc = new UnitContract();

                for (int x = 0; x < aktifKontrak.size(); x++) {
                    
                    keteranganKomin = "";

                    SewaTanahProp st = (SewaTanahProp) aktifKontrak.get(x);
                    SewaTanahRincianPiutangProp stp = new SewaTanahRincianPiutangProp();
                    stp.setKominCurrencyId(st.getCurrencyId());
                    stp.setInvestorId(st.getInvestorId());
                    stp.setLotId(st.getLotId());
                    stp.setLuasLahan(st.getLuas());
                    stp.setSaranaId(st.getCustomerId());
                    stp.setSewaTanahId(st.getOID());
                    stp.setPeriodeTahun(year);
                    stp.setMulaiSewa(st.getTanggalMulai());

                    //komin
                    SewaTanahKominProp stk = DbSewaTanahKominProp.getActifKomin(year, st.getOID());

                    if (stk.getOID() != 0) {
                        
                        try {
                            uc = DbUnitContract.fetchExc(stk.getUnitKontrakId());
                        } catch (Exception e) {
                        }
                        
                        double yrx = 12 / uc.getJmlBulan();

                        stp.setPerhitunganKomin1(stk.getRate() * yrx);
                        stp.setMasaKominId(stk.getUnitKontrakId());
                        stp.setMasaKominJmlBulan(uc.getJmlBulan());

                        String kominnote = "";

                        if (stk.getDasarPerhitungan() == DbSewaTanahKominProp.KOMIN_BY_SQUARE) {
                            stp.setPerhitunganKomin2(st.getLuas());
                            stp.setNilaiKominTh(stk.getRate() * st.getLuas());
                            kominnote = stk.getRate() + " X " + JSPFormater.formatNumber(st.getLuas(), "#,###.##") + " m2";
                        } else if(stk.getDasarPerhitungan() == DbSewaTanahKominProp.KOMIN_BY_ROOM) {
                            stp.setPerhitunganKomin2(st.getJmlKamar());
                            stp.setNilaiKominTh(stk.getRate() * st.getJmlKamar());
                            kominnote = stk.getRate() + " X " + JSPFormater.formatNumber(st.getJmlKamar(), "#,###.##") + " AR";
                        } else if(stk.getDasarPerhitungan() == DbSewaTanahKominProp.KOMIN_BY_TOTAL) {
                            stp.setPerhitunganKomin2(1);
                            stp.setNilaiKominTh(stk.getRate());
                            kominnote = "1 X " + JSPFormater.formatNumber(stk.getRate(),"#,###.##");
                        }

                        stp.setPerhitunganKominNote(kominnote);
                    } else {
                        keteranganKomin = "Tidak ada sewa aktif.";
                    }

                    stp.setKeterangan(keteranganKomin);
                    xval.add(stp);
                }
            }
            return v;
        }
    }
}
