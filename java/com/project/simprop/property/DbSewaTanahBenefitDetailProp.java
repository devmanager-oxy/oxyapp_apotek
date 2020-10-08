
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

public class DbSewaTanahBenefitDetailProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_PROP_SEWA_TANAH_BENEFIT_DETAIL = "prop_sewa_tanah_benefit_detail";

	public static final  int COL_SEWA_TANAH_BENEFIT_DETAIL_ID = 0;
	public static final  int COL_SEWA_TANAH_BENEFIT_ID = 1;
	public static final  int COL_SEWA_TANAH_KOMPER_ID = 2;
	public static final  int COL_CURRENCY_ID = 3;
	public static final  int COL_JUMLAH = 4;
	public static final  int COL_KETERANGAN = 5;
	public static final  int COL_KATEGORI = 6;
	public static final  int COL_PERSEN_KOMPER = 7;

	public static final  String[] colNames = {
		"sewa_tanah_benefit_detail_id",
		"sewa_tanah_benefit_id",
		"sewa_tanah_komper_id",
		"currency_id",
		"jumlah",
		"keterangan",
		"kategori",
		"persen_komper"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_INT,
		TYPE_FLOAT
	 }; 

	public DbSewaTanahBenefitDetailProp(){
	}

	public DbSewaTanahBenefitDetailProp(int i) throws CONException { 
		super(new DbSewaTanahBenefitDetailProp()); 
	}

	public DbSewaTanahBenefitDetailProp(String sOid) throws CONException { 
		super(new DbSewaTanahBenefitDetailProp(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSewaTanahBenefitDetailProp(long lOid) throws CONException { 
		super(new DbSewaTanahBenefitDetailProp(0)); 
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
		return DB_PROP_SEWA_TANAH_BENEFIT_DETAIL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSewaTanahBenefitDetailProp().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp = fetchExc(ent.getOID()); 
		ent = (Entity)sewaTanahBenefitDetailProp; 
		return sewaTanahBenefitDetailProp.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SewaTanahBenefitDetailProp) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SewaTanahBenefitDetailProp) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SewaTanahBenefitDetailProp fetchExc(long oid) throws CONException{ 
		try{ 
			SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp = new SewaTanahBenefitDetailProp();
			DbSewaTanahBenefitDetailProp pstSewaTanahBenefitDetail = new DbSewaTanahBenefitDetailProp(oid); 
			sewaTanahBenefitDetailProp.setOID(oid);
			sewaTanahBenefitDetailProp.setSewaTanahBenefitId(pstSewaTanahBenefitDetail.getlong(COL_SEWA_TANAH_BENEFIT_ID));
			sewaTanahBenefitDetailProp.setSewaTanahKomperId(pstSewaTanahBenefitDetail.getlong(COL_SEWA_TANAH_KOMPER_ID));
			sewaTanahBenefitDetailProp.setCurrencyId(pstSewaTanahBenefitDetail.getlong(COL_CURRENCY_ID));
			sewaTanahBenefitDetailProp.setJumlah(pstSewaTanahBenefitDetail.getdouble(COL_JUMLAH));
			sewaTanahBenefitDetailProp.setKeterangan(pstSewaTanahBenefitDetail.getString(COL_KETERANGAN));
			sewaTanahBenefitDetailProp.setKategori(pstSewaTanahBenefitDetail.getInt(COL_KATEGORI));
			sewaTanahBenefitDetailProp.setPersenKomper(pstSewaTanahBenefitDetail.getdouble(COL_PERSEN_KOMPER));

			return sewaTanahBenefitDetailProp; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBenefitDetailProp(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp) throws CONException{ 
		try{ 
			DbSewaTanahBenefitDetailProp pstSewaTanahBenefitDetail = new DbSewaTanahBenefitDetailProp(0);

			pstSewaTanahBenefitDetail.setLong(COL_SEWA_TANAH_BENEFIT_ID, sewaTanahBenefitDetailProp.getSewaTanahBenefitId());
			pstSewaTanahBenefitDetail.setLong(COL_SEWA_TANAH_KOMPER_ID, sewaTanahBenefitDetailProp.getSewaTanahKomperId());
			pstSewaTanahBenefitDetail.setLong(COL_CURRENCY_ID, sewaTanahBenefitDetailProp.getCurrencyId());
			pstSewaTanahBenefitDetail.setDouble(COL_JUMLAH, sewaTanahBenefitDetailProp.getJumlah());
			pstSewaTanahBenefitDetail.setString(COL_KETERANGAN, sewaTanahBenefitDetailProp.getKeterangan());
			pstSewaTanahBenefitDetail.setInt(COL_KATEGORI, sewaTanahBenefitDetailProp.getKategori());
			pstSewaTanahBenefitDetail.setDouble(COL_PERSEN_KOMPER, sewaTanahBenefitDetailProp.getPersenKomper());

			pstSewaTanahBenefitDetail.insert(); 
			sewaTanahBenefitDetailProp.setOID(pstSewaTanahBenefitDetail.getlong(COL_SEWA_TANAH_BENEFIT_DETAIL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBenefitDetailProp(0),CONException.UNKNOWN); 
		}
		return sewaTanahBenefitDetailProp.getOID();
	}

	public static long updateExc(SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp) throws CONException{ 
		try{ 
			if(sewaTanahBenefitDetailProp.getOID() != 0){ 
				DbSewaTanahBenefitDetailProp pstSewaTanahBenefitDetail = new DbSewaTanahBenefitDetailProp(sewaTanahBenefitDetailProp.getOID());

				pstSewaTanahBenefitDetail.setLong(COL_SEWA_TANAH_BENEFIT_ID, sewaTanahBenefitDetailProp.getSewaTanahBenefitId());
				pstSewaTanahBenefitDetail.setLong(COL_SEWA_TANAH_KOMPER_ID, sewaTanahBenefitDetailProp.getSewaTanahKomperId());
				pstSewaTanahBenefitDetail.setLong(COL_CURRENCY_ID, sewaTanahBenefitDetailProp.getCurrencyId());
				pstSewaTanahBenefitDetail.setDouble(COL_JUMLAH, sewaTanahBenefitDetailProp.getJumlah());
				pstSewaTanahBenefitDetail.setString(COL_KETERANGAN, sewaTanahBenefitDetailProp.getKeterangan());
				pstSewaTanahBenefitDetail.setInt(COL_KATEGORI, sewaTanahBenefitDetailProp.getKategori());
				pstSewaTanahBenefitDetail.setDouble(COL_PERSEN_KOMPER, sewaTanahBenefitDetailProp.getPersenKomper());

				pstSewaTanahBenefitDetail.update(); 
				return sewaTanahBenefitDetailProp.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBenefitDetailProp(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSewaTanahBenefitDetailProp pstSewaTanahBenefitDetail = new DbSewaTanahBenefitDetailProp(oid);
			pstSewaTanahBenefitDetail.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBenefitDetailProp(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_BENEFIT_DETAIL; 
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
				SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp = new SewaTanahBenefitDetailProp();
				resultToObject(rs, sewaTanahBenefitDetailProp);
				lists.add(sewaTanahBenefitDetailProp);
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

	private static void resultToObject(ResultSet rs, SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp){
		try{
			sewaTanahBenefitDetailProp.setOID(rs.getLong(DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_SEWA_TANAH_BENEFIT_DETAIL_ID]));
			sewaTanahBenefitDetailProp.setSewaTanahBenefitId(rs.getLong(DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_SEWA_TANAH_BENEFIT_ID]));
			sewaTanahBenefitDetailProp.setSewaTanahKomperId(rs.getLong(DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_SEWA_TANAH_KOMPER_ID]));
			sewaTanahBenefitDetailProp.setCurrencyId(rs.getLong(DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_CURRENCY_ID]));
			sewaTanahBenefitDetailProp.setJumlah(rs.getDouble(DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_JUMLAH]));
			sewaTanahBenefitDetailProp.setKeterangan(rs.getString(DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_KETERANGAN]));
			sewaTanahBenefitDetailProp.setKategori(rs.getInt(DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_KATEGORI]));
			sewaTanahBenefitDetailProp.setPersenKomper(rs.getDouble(DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_PERSEN_KOMPER]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long sewaTanahBenefitDetailId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_BENEFIT_DETAIL + " WHERE " + 
						DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_SEWA_TANAH_BENEFIT_DETAIL_ID] + " = " + sewaTanahBenefitDetailId;

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
			String sql = "SELECT COUNT("+ DbSewaTanahBenefitDetailProp.colNames[DbSewaTanahBenefitDetailProp.COL_SEWA_TANAH_BENEFIT_DETAIL_ID] + ") FROM " + DB_PROP_SEWA_TANAH_BENEFIT_DETAIL;
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
			  	   SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp = (SewaTanahBenefitDetailProp)list.get(ls);
				   if(oid == sewaTanahBenefitDetailProp.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
	public static void resetDetailData(long oid){
		
		String sql = "delete from "+DB_PROP_SEWA_TANAH_BENEFIT_DETAIL+
			" where "+colNames[COL_SEWA_TANAH_BENEFIT_ID]+"="+oid;
			
		try{
			CONHandler.execUpdate(sql);
		}
		catch(Exception e){
		
		}	
		
	}
	
	public static void updateDetailData(long oid, long oidSewaTanah, Vector temp){
		
		resetDetailData(oid);
		
		if(temp!=null && temp.size()>0){
			for(int i=0; i<temp.size(); i++){
				SewaTanahBenefitDetailProp stb = (SewaTanahBenefitDetailProp)temp.get(i);
				
				SewaTanahKomperProp stk = getKomper(oidSewaTanah, stb.getKategori());
				//jika ada setupnya
				if(stk.getOID()!=0){				
					stb.setSewaTanahKomperId(stk.getOID());
					stb.setPersenKomper(stk.getPersentase());
					stb.setSewaTanahBenefitId(oid);
					try{
						DbSewaTanahBenefitDetailProp.insertExc(stb);
					}
					catch(Exception e){
					
					}
				}
			}
		}
		
	}
	
	public static SewaTanahBenefitDetailProp getDetail(long oidBenefit, int kategori){
				
		Vector temp = list(0,1, colNames[COL_SEWA_TANAH_BENEFIT_ID]+"="+oidBenefit+" and "+colNames[COL_KATEGORI]+"="+kategori, "");		
		if(temp!=null && temp.size()>0){
			return (SewaTanahBenefitDetailProp)temp.get(0);
		}
		
		return new SewaTanahBenefitDetailProp();	
			
	}
	
	
	public static SewaTanahKomperProp getKomper(long sewaTanahId, int kategori){
				
		Vector temp = DbSewaTanahKomperProp.list(0,1, DbSewaTanahKomperProp.colNames[DbSewaTanahKomperProp.COL_SEWA_TANAH_ID]+"="+sewaTanahId+" and "+DbSewaTanahKomperProp.colNames[DbSewaTanahKomperProp.COL_KATEGORI]+"="+kategori, "");		
		if(temp!=null && temp.size()>0){
			return (SewaTanahKomperProp)temp.get(0);
		}
		
		return new SewaTanahKomperProp();	
			
	}
	
	public static double getTotalInvoice(long oidBenefit){
		
		SewaTanahInvoiceProp sti = new SewaTanahInvoiceProp();
		try{
			sti = DbSewaTanahInvoiceProp.fetchExc(oidBenefit);
		}
		catch(Exception e){
			
		}
		
    	String sql = "SELECT sum("+colNames[COL_JUMLAH]+
    		" * "+colNames[COL_PERSEN_KOMPER]+"/100) "+
    		" FROM "+DB_PROP_SEWA_TANAH_BENEFIT_DETAIL+
    		" where "+colNames[COL_SEWA_TANAH_BENEFIT_ID]+"="+oidBenefit;
    		
    	System.out.println(sql);	
    	
    	double result = 0;	
    	CONResultSet crs = null;
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
    	
    	result = result - sti.getJumlah();
    	if(result<0){
    		result = 0;
    	}	
    		
    	return result;	
    }
    
    
	
}
