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
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.util.*;

public class DbSewaTanahAssesment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CRM_SEWA_TANAH_ASSESMENT = "crm_sewa_tanah_assesment";

	public static final  int COL_SEWA_TANAH_ASSESMENT_ID = 0;
	public static final  int COL_MULAI = 1;
	public static final  int COL_SELESAI = 2;
	public static final  int COL_RATE = 3;
	public static final  int COL_UNIT_KONTRAK_ID = 4;
	public static final  int COL_DASAR_PERHITUNGAN = 5;
	public static final  int COL_SEWA_TANAH_ID = 6;
	public static final  int COL_CURRENCY_ID = 7;

	public static final  String[] colNames = {
		"sewa_tanah_assesment_id",
		"mulai",
		"selesai",
		"rate",
		"unit_kontrak_id",		
		"dasar_perhitungan",
		"sewa_tanah_id",
		"currency_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_FLOAT3,
		TYPE_LONG,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG
	 }; 

	public static final int DASAR_LUAS			=  0 ;
	public static final int DASAR_KAMAR			=  1 ;
	public static final int DASAR_TOTAL			=  2 ;
	public static String[] dasarPerhitungan = {"Luas","Kamar","Total"};

	public DbSewaTanahAssesment(){
	}

	public DbSewaTanahAssesment(int i) throws CONException { 
		super(new DbSewaTanahAssesment()); 
	}

	public DbSewaTanahAssesment(String sOid) throws CONException { 
		super(new DbSewaTanahAssesment(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSewaTanahAssesment(long lOid) throws CONException { 
		super(new DbSewaTanahAssesment(0)); 
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
		return DB_CRM_SEWA_TANAH_ASSESMENT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSewaTanahAssesment().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SewaTanahAssesment sewatanahassesment = fetchExc(ent.getOID()); 
		ent = (Entity)sewatanahassesment; 
		return sewatanahassesment.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SewaTanahAssesment) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SewaTanahAssesment) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SewaTanahAssesment fetchExc(long oid) throws CONException{ 
		try{ 
			SewaTanahAssesment sewatanahassesment = new SewaTanahAssesment();
			DbSewaTanahAssesment pstSewaTanahAssesment = new DbSewaTanahAssesment(oid); 
			sewatanahassesment.setOID(oid);

			sewatanahassesment.setMulai(pstSewaTanahAssesment.getDate(COL_MULAI));
			sewatanahassesment.setSelesai(pstSewaTanahAssesment.getDate(COL_SELESAI));
			sewatanahassesment.setRate(pstSewaTanahAssesment.getdouble(COL_RATE));
			sewatanahassesment.setUnitKontrakId(pstSewaTanahAssesment.getlong(COL_UNIT_KONTRAK_ID));
			sewatanahassesment.setDasarPerhitungan(pstSewaTanahAssesment.getInt(COL_DASAR_PERHITUNGAN));
			sewatanahassesment.setSewaTanahId(pstSewaTanahAssesment.getlong(COL_SEWA_TANAH_ID));
			sewatanahassesment.setCurrencyId(pstSewaTanahAssesment.getlong(COL_CURRENCY_ID));

			return sewatanahassesment; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahAssesment(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SewaTanahAssesment sewatanahassesment) throws CONException{ 
		try{ 
			DbSewaTanahAssesment pstSewaTanahAssesment = new DbSewaTanahAssesment(0);

			pstSewaTanahAssesment.setDate(COL_MULAI, sewatanahassesment.getMulai());
			pstSewaTanahAssesment.setDate(COL_SELESAI, sewatanahassesment.getSelesai());
			pstSewaTanahAssesment.setDouble(COL_RATE, sewatanahassesment.getRate());
			pstSewaTanahAssesment.setLong(COL_UNIT_KONTRAK_ID, sewatanahassesment.getUnitKontrakId());
			pstSewaTanahAssesment.setInt(COL_DASAR_PERHITUNGAN, sewatanahassesment.getDasarPerhitungan());
			pstSewaTanahAssesment.setLong(COL_SEWA_TANAH_ID, sewatanahassesment.getSewaTanahId());
			pstSewaTanahAssesment.setLong(COL_CURRENCY_ID, sewatanahassesment.getCurrencyId());

			pstSewaTanahAssesment.insert(); 
			sewatanahassesment.setOID(pstSewaTanahAssesment.getlong(COL_SEWA_TANAH_ASSESMENT_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahAssesment(0),CONException.UNKNOWN); 
		}
		return sewatanahassesment.getOID();
	}

	public static long updateExc(SewaTanahAssesment sewatanahassesment) throws CONException{ 
		try{ 
			if(sewatanahassesment.getOID() != 0){ 
				DbSewaTanahAssesment pstSewaTanahAssesment = new DbSewaTanahAssesment(sewatanahassesment.getOID());

				pstSewaTanahAssesment.setDate(COL_MULAI, sewatanahassesment.getMulai());
				pstSewaTanahAssesment.setDate(COL_SELESAI, sewatanahassesment.getSelesai());
				pstSewaTanahAssesment.setDouble(COL_RATE, sewatanahassesment.getRate());
				pstSewaTanahAssesment.setLong(COL_UNIT_KONTRAK_ID, sewatanahassesment.getUnitKontrakId());
				pstSewaTanahAssesment.setInt(COL_DASAR_PERHITUNGAN, sewatanahassesment.getDasarPerhitungan());
				pstSewaTanahAssesment.setLong(COL_SEWA_TANAH_ID, sewatanahassesment.getSewaTanahId());
				pstSewaTanahAssesment.setLong(COL_CURRENCY_ID, sewatanahassesment.getCurrencyId());

				pstSewaTanahAssesment.update(); 
				return sewatanahassesment.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahAssesment(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSewaTanahAssesment pstSewaTanahAssesment = new DbSewaTanahAssesment(oid);
			pstSewaTanahAssesment.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahAssesment(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_ASSESMENT; 
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
				SewaTanahAssesment sewatanahassesment = new SewaTanahAssesment();
				resultToObject(rs, sewatanahassesment);
				lists.add(sewatanahassesment);
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

	private static void resultToObject(ResultSet rs, SewaTanahAssesment sewatanahassesment){
		try{
			sewatanahassesment.setOID(rs.getLong(DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_SEWA_TANAH_ASSESMENT_ID]));
			sewatanahassesment.setMulai(rs.getDate(DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_MULAI]));
			sewatanahassesment.setSelesai(rs.getDate(DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_SELESAI]));
			sewatanahassesment.setRate(rs.getDouble(DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_RATE]));
			sewatanahassesment.setUnitKontrakId(rs.getLong(DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_UNIT_KONTRAK_ID]));
			sewatanahassesment.setDasarPerhitungan(rs.getInt(DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_DASAR_PERHITUNGAN]));
			sewatanahassesment.setSewaTanahId(rs.getLong(DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_SEWA_TANAH_ID]));
			sewatanahassesment.setCurrencyId(rs.getLong(DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_CURRENCY_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long sewaTanahAssesmentId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_ASSESMENT + " WHERE " + 
						DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_SEWA_TANAH_ASSESMENT_ID] + " = " + sewaTanahAssesmentId;

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
			String sql = "SELECT COUNT("+ DbSewaTanahAssesment.colNames[DbSewaTanahAssesment.COL_SEWA_TANAH_ASSESMENT_ID] + ") FROM " + DB_CRM_SEWA_TANAH_ASSESMENT;
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
			  	   SewaTanahAssesment sewatanahassesment = (SewaTanahAssesment)list.get(ls);
				   if(oid == sewatanahassesment.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
	public static SewaTanahAssesment getActifAssesment(int year, long sewaTanahId){
        	
    	Date dt = new Date();
    	dt.setYear(year-1900);
    	
    	String sql = "select * from "+DB_CRM_SEWA_TANAH_ASSESMENT+
    		" where '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"+
    		" between "+colNames[COL_MULAI]+
    		" and "+colNames[COL_SELESAI]+" and "+colNames[COL_SEWA_TANAH_ID]+"="+sewaTanahId;
    		
    	SewaTanahAssesment sta = new SewaTanahAssesment();	
    	CONResultSet crs = null;
    	try{
    		crs = CONHandler.execQueryResult(sql);
    		ResultSet rs = crs.getResultSet();
    		while(rs.next()){
    			resultToObject(rs, sta);
    		}	
    	}catch(Exception e){
    		
    	}
    	finally{
    		CONResultSet.close(crs);
    	}	
    		
    	return sta;	
    		
    }
	
}
