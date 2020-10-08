
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

public class DbSewaTanahBenefitDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CRM_SEWA_TANAH_BENEFIT_DETAIL = "crm_sewa_tanah_benefit_detail";

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

	public DbSewaTanahBenefitDetail(){
	}

	public DbSewaTanahBenefitDetail(int i) throws CONException { 
		super(new DbSewaTanahBenefitDetail()); 
	}

	public DbSewaTanahBenefitDetail(String sOid) throws CONException { 
		super(new DbSewaTanahBenefitDetail(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSewaTanahBenefitDetail(long lOid) throws CONException { 
		super(new DbSewaTanahBenefitDetail(0)); 
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
		return DB_CRM_SEWA_TANAH_BENEFIT_DETAIL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSewaTanahBenefitDetail().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SewaTanahBenefitDetail sewatanahbenefitdetail = fetchExc(ent.getOID()); 
		ent = (Entity)sewatanahbenefitdetail; 
		return sewatanahbenefitdetail.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SewaTanahBenefitDetail) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SewaTanahBenefitDetail) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SewaTanahBenefitDetail fetchExc(long oid) throws CONException{ 
		try{ 
			SewaTanahBenefitDetail sewatanahbenefitdetail = new SewaTanahBenefitDetail();
			DbSewaTanahBenefitDetail pstSewaTanahBenefitDetail = new DbSewaTanahBenefitDetail(oid); 
			sewatanahbenefitdetail.setOID(oid);

			sewatanahbenefitdetail.setSewaTanahBenefitId(pstSewaTanahBenefitDetail.getlong(COL_SEWA_TANAH_BENEFIT_ID));
			sewatanahbenefitdetail.setSewaTanahKomperId(pstSewaTanahBenefitDetail.getlong(COL_SEWA_TANAH_KOMPER_ID));
			sewatanahbenefitdetail.setCurrencyId(pstSewaTanahBenefitDetail.getlong(COL_CURRENCY_ID));
			sewatanahbenefitdetail.setJumlah(pstSewaTanahBenefitDetail.getdouble(COL_JUMLAH));
			sewatanahbenefitdetail.setKeterangan(pstSewaTanahBenefitDetail.getString(COL_KETERANGAN));
			sewatanahbenefitdetail.setKategori(pstSewaTanahBenefitDetail.getInt(COL_KATEGORI));
			sewatanahbenefitdetail.setPersenKomper(pstSewaTanahBenefitDetail.getdouble(COL_PERSEN_KOMPER));

			return sewatanahbenefitdetail; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBenefitDetail(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SewaTanahBenefitDetail sewatanahbenefitdetail) throws CONException{ 
		try{ 
			DbSewaTanahBenefitDetail pstSewaTanahBenefitDetail = new DbSewaTanahBenefitDetail(0);

			pstSewaTanahBenefitDetail.setLong(COL_SEWA_TANAH_BENEFIT_ID, sewatanahbenefitdetail.getSewaTanahBenefitId());
			pstSewaTanahBenefitDetail.setLong(COL_SEWA_TANAH_KOMPER_ID, sewatanahbenefitdetail.getSewaTanahKomperId());
			pstSewaTanahBenefitDetail.setLong(COL_CURRENCY_ID, sewatanahbenefitdetail.getCurrencyId());
			pstSewaTanahBenefitDetail.setDouble(COL_JUMLAH, sewatanahbenefitdetail.getJumlah());
			pstSewaTanahBenefitDetail.setString(COL_KETERANGAN, sewatanahbenefitdetail.getKeterangan());
			pstSewaTanahBenefitDetail.setInt(COL_KATEGORI, sewatanahbenefitdetail.getKategori());
			pstSewaTanahBenefitDetail.setDouble(COL_PERSEN_KOMPER, sewatanahbenefitdetail.getPersenKomper());

			pstSewaTanahBenefitDetail.insert(); 
			sewatanahbenefitdetail.setOID(pstSewaTanahBenefitDetail.getlong(COL_SEWA_TANAH_BENEFIT_DETAIL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBenefitDetail(0),CONException.UNKNOWN); 
		}
		return sewatanahbenefitdetail.getOID();
	}

	public static long updateExc(SewaTanahBenefitDetail sewatanahbenefitdetail) throws CONException{ 
		try{ 
			if(sewatanahbenefitdetail.getOID() != 0){ 
				DbSewaTanahBenefitDetail pstSewaTanahBenefitDetail = new DbSewaTanahBenefitDetail(sewatanahbenefitdetail.getOID());

				pstSewaTanahBenefitDetail.setLong(COL_SEWA_TANAH_BENEFIT_ID, sewatanahbenefitdetail.getSewaTanahBenefitId());
				pstSewaTanahBenefitDetail.setLong(COL_SEWA_TANAH_KOMPER_ID, sewatanahbenefitdetail.getSewaTanahKomperId());
				pstSewaTanahBenefitDetail.setLong(COL_CURRENCY_ID, sewatanahbenefitdetail.getCurrencyId());
				pstSewaTanahBenefitDetail.setDouble(COL_JUMLAH, sewatanahbenefitdetail.getJumlah());
				pstSewaTanahBenefitDetail.setString(COL_KETERANGAN, sewatanahbenefitdetail.getKeterangan());
				pstSewaTanahBenefitDetail.setInt(COL_KATEGORI, sewatanahbenefitdetail.getKategori());
				pstSewaTanahBenefitDetail.setDouble(COL_PERSEN_KOMPER, sewatanahbenefitdetail.getPersenKomper());

				pstSewaTanahBenefitDetail.update(); 
				return sewatanahbenefitdetail.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBenefitDetail(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSewaTanahBenefitDetail pstSewaTanahBenefitDetail = new DbSewaTanahBenefitDetail(oid);
			pstSewaTanahBenefitDetail.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBenefitDetail(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_BENEFIT_DETAIL; 
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
				SewaTanahBenefitDetail sewatanahbenefitdetail = new SewaTanahBenefitDetail();
				resultToObject(rs, sewatanahbenefitdetail);
				lists.add(sewatanahbenefitdetail);
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

	private static void resultToObject(ResultSet rs, SewaTanahBenefitDetail sewatanahbenefitdetail){
		try{
			sewatanahbenefitdetail.setOID(rs.getLong(DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_SEWA_TANAH_BENEFIT_DETAIL_ID]));
			sewatanahbenefitdetail.setSewaTanahBenefitId(rs.getLong(DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_SEWA_TANAH_BENEFIT_ID]));
			sewatanahbenefitdetail.setSewaTanahKomperId(rs.getLong(DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_SEWA_TANAH_KOMPER_ID]));
			sewatanahbenefitdetail.setCurrencyId(rs.getLong(DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_CURRENCY_ID]));
			sewatanahbenefitdetail.setJumlah(rs.getDouble(DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_JUMLAH]));
			sewatanahbenefitdetail.setKeterangan(rs.getString(DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_KETERANGAN]));
			sewatanahbenefitdetail.setKategori(rs.getInt(DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_KATEGORI]));
			sewatanahbenefitdetail.setPersenKomper(rs.getDouble(DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_PERSEN_KOMPER]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long sewaTanahBenefitDetailId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_BENEFIT_DETAIL + " WHERE " + 
						DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_SEWA_TANAH_BENEFIT_DETAIL_ID] + " = " + sewaTanahBenefitDetailId;

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
			String sql = "SELECT COUNT("+ DbSewaTanahBenefitDetail.colNames[DbSewaTanahBenefitDetail.COL_SEWA_TANAH_BENEFIT_DETAIL_ID] + ") FROM " + DB_CRM_SEWA_TANAH_BENEFIT_DETAIL;
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
			  	   SewaTanahBenefitDetail sewatanahbenefitdetail = (SewaTanahBenefitDetail)list.get(ls);
				   if(oid == sewatanahbenefitdetail.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
	public static void resetDetailData(long oid){
		
		String sql = "delete from "+DB_CRM_SEWA_TANAH_BENEFIT_DETAIL+
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
				SewaTanahBenefitDetail stb = (SewaTanahBenefitDetail)temp.get(i);
				
				SewaTanahKomper stk = getKomper(oidSewaTanah, stb.getKategori());
				//jika ada setupnya
				if(stk.getOID()!=0){				
					stb.setSewaTanahKomperId(stk.getOID());
					stb.setPersenKomper(stk.getPersentase());
					stb.setSewaTanahBenefitId(oid);
					try{
						DbSewaTanahBenefitDetail.insertExc(stb);
					}
					catch(Exception e){
					
					}
				}
			}
		}
		
	}
	
	public static SewaTanahBenefitDetail getDetail(long oidBenefit, int kategori){
				
		Vector temp = list(0,1, colNames[COL_SEWA_TANAH_BENEFIT_ID]+"="+oidBenefit+" and "+colNames[COL_KATEGORI]+"="+kategori, "");		
		if(temp!=null && temp.size()>0){
			return (SewaTanahBenefitDetail)temp.get(0);
		}
		
		return new SewaTanahBenefitDetail();	
			
	}
	
	
	public static SewaTanahKomper getKomper(long sewaTanahId, int kategori){
				
		Vector temp = DbSewaTanahKomper.list(0,1, DbSewaTanahKomper.colNames[DbSewaTanahKomper.COL_SEWA_TANAH_ID]+"="+sewaTanahId+" and "+DbSewaTanahKomper.colNames[DbSewaTanahKomper.COL_KATEGORI]+"="+kategori, "");		
		if(temp!=null && temp.size()>0){
			return (SewaTanahKomper)temp.get(0);
		}
		
		return new SewaTanahKomper();	
			
	}
	
	public static double getTotalInvoice(long oidBenefit){
		
		SewaTanahInvoice sti = new SewaTanahInvoice();
		try{
			sti = DbSewaTanahInvoice.fetchExc(oidBenefit);
		}
		catch(Exception e){
			
		}
		
    	String sql = "SELECT sum("+colNames[COL_JUMLAH]+
    		" * "+colNames[COL_PERSEN_KOMPER]+"/100) "+
    		" FROM "+DB_CRM_SEWA_TANAH_BENEFIT_DETAIL+
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
