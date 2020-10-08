
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

public class DbSewaTanahKomin extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CRM_SEWA_TANAH_KOMIN = "crm_sewa_tanah_komin";

	public static final  int COL_SEWA_TANAH_KOMIN_ID = 0;
	public static final  int COL_NAMA = 1;
	public static final  int COL_TYPE = 2;
	public static final  int COL_MULAI = 3;
	public static final  int COL_SELESAI = 4;
	public static final  int COL_RATE = 5;
	public static final  int COL_UNIT_KONTRAK_ID = 6;
	public static final  int COL_KETERANGAN = 7;
	public static final  int COL_SEWA_TANAH_ID = 8;
        public static final int COL_DASAR_PERHITUNGAN = 9;

	public static final  String[] colNames = {
		"sewa_tanah_komin_id",
		"nama",
		"type",
		"mulai",
		"selesai",
		"rate",
		"unit_kontrak_id",
		"keterangan",
		"sewa_tanah_id",
		"dasar_perhitungan"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_INT,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_FLOAT3,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_LONG,
                TYPE_INT
	 }; 
        
        public static int KOMIN_BY_ROOM = 1;
        public static int KOMIN_BY_SQUARE = 2;
        public static int KOMIN_BY_TOTAL = 3;
        public static String[] strKominBy = {"", "Kamar", "Luas", "Total"};

	public DbSewaTanahKomin(){
	}

	public DbSewaTanahKomin(int i) throws CONException { 
		super(new DbSewaTanahKomin()); 
	}

	public DbSewaTanahKomin(String sOid) throws CONException { 
		super(new DbSewaTanahKomin(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSewaTanahKomin(long lOid) throws CONException { 
		super(new DbSewaTanahKomin(0)); 
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
		return DB_CRM_SEWA_TANAH_KOMIN;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSewaTanahKomin().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SewaTanahKomin sewatanahkomin = fetchExc(ent.getOID()); 
		ent = (Entity)sewatanahkomin; 
		return sewatanahkomin.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SewaTanahKomin) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SewaTanahKomin) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SewaTanahKomin fetchExc(long oid) throws CONException{ 
		try{ 
			SewaTanahKomin sewatanahkomin = new SewaTanahKomin();
			DbSewaTanahKomin pstSewaTanahKomin = new DbSewaTanahKomin(oid); 
			sewatanahkomin.setOID(oid);

			sewatanahkomin.setNama(pstSewaTanahKomin.getString(COL_NAMA));
			sewatanahkomin.setType(pstSewaTanahKomin.getInt(COL_TYPE));
			sewatanahkomin.setMulai(pstSewaTanahKomin.getDate(COL_MULAI));
			sewatanahkomin.setSelesai(pstSewaTanahKomin.getDate(COL_SELESAI));
			sewatanahkomin.setRate(pstSewaTanahKomin.getdouble(COL_RATE));
			sewatanahkomin.setUnitKontrakId(pstSewaTanahKomin.getlong(COL_UNIT_KONTRAK_ID));
			sewatanahkomin.setKeterangan(pstSewaTanahKomin.getString(COL_KETERANGAN));
			sewatanahkomin.setSewaTanahId(pstSewaTanahKomin.getlong(COL_SEWA_TANAH_ID));
                        sewatanahkomin.setDasarPerhitungan(pstSewaTanahKomin.getInt(COL_DASAR_PERHITUNGAN));

			return sewatanahkomin; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomin(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SewaTanahKomin sewatanahkomin) throws CONException{ 
		try{ 
			DbSewaTanahKomin pstSewaTanahKomin = new DbSewaTanahKomin(0);

			pstSewaTanahKomin.setString(COL_NAMA, sewatanahkomin.getNama());
			pstSewaTanahKomin.setInt(COL_TYPE, sewatanahkomin.getType());
			pstSewaTanahKomin.setDate(COL_MULAI, sewatanahkomin.getMulai());
			pstSewaTanahKomin.setDate(COL_SELESAI, sewatanahkomin.getSelesai());
			pstSewaTanahKomin.setDouble(COL_RATE, sewatanahkomin.getRate());
			pstSewaTanahKomin.setLong(COL_UNIT_KONTRAK_ID, sewatanahkomin.getUnitKontrakId());
			pstSewaTanahKomin.setString(COL_KETERANGAN, sewatanahkomin.getKeterangan());
			pstSewaTanahKomin.setLong(COL_SEWA_TANAH_ID, sewatanahkomin.getSewaTanahId());
                        pstSewaTanahKomin.setInt(COL_DASAR_PERHITUNGAN, sewatanahkomin.getDasarPerhitungan());

			pstSewaTanahKomin.insert(); 
			sewatanahkomin.setOID(pstSewaTanahKomin.getlong(COL_SEWA_TANAH_KOMIN_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomin(0),CONException.UNKNOWN); 
		}
		return sewatanahkomin.getOID();
	}

	public static long updateExc(SewaTanahKomin sewatanahkomin) throws CONException{ 
		try{ 
			if(sewatanahkomin.getOID() != 0){ 
				DbSewaTanahKomin pstSewaTanahKomin = new DbSewaTanahKomin(sewatanahkomin.getOID());

				pstSewaTanahKomin.setString(COL_NAMA, sewatanahkomin.getNama());
				pstSewaTanahKomin.setInt(COL_TYPE, sewatanahkomin.getType());
				pstSewaTanahKomin.setDate(COL_MULAI, sewatanahkomin.getMulai());
				pstSewaTanahKomin.setDate(COL_SELESAI, sewatanahkomin.getSelesai());
				pstSewaTanahKomin.setDouble(COL_RATE, sewatanahkomin.getRate());
				pstSewaTanahKomin.setLong(COL_UNIT_KONTRAK_ID, sewatanahkomin.getUnitKontrakId());
				pstSewaTanahKomin.setString(COL_KETERANGAN, sewatanahkomin.getKeterangan());
				pstSewaTanahKomin.setLong(COL_SEWA_TANAH_ID, sewatanahkomin.getSewaTanahId());
                                pstSewaTanahKomin.setInt(COL_DASAR_PERHITUNGAN, sewatanahkomin.getDasarPerhitungan());

				pstSewaTanahKomin.update(); 
				return sewatanahkomin.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomin(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSewaTanahKomin pstSewaTanahKomin = new DbSewaTanahKomin(oid);
			pstSewaTanahKomin.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomin(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_KOMIN; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                        System.out.println("sql "+sql);
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				SewaTanahKomin sewatanahkomin = new SewaTanahKomin();
				resultToObject(rs, sewatanahkomin);
				lists.add(sewatanahkomin);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println("List DbSewaTanahKomin() : "+e.toString());
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}

	private static void resultToObject(ResultSet rs, SewaTanahKomin sewatanahkomin){
		try{
			sewatanahkomin.setOID(rs.getLong(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_SEWA_TANAH_KOMIN_ID]));
			sewatanahkomin.setNama(rs.getString(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_NAMA]));
			sewatanahkomin.setType(rs.getInt(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_TYPE]));
			sewatanahkomin.setMulai(rs.getDate(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_MULAI]));
			sewatanahkomin.setSelesai(rs.getDate(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_SELESAI]));
			sewatanahkomin.setRate(rs.getDouble(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_RATE]));
			sewatanahkomin.setUnitKontrakId(rs.getLong(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_UNIT_KONTRAK_ID]));
			sewatanahkomin.setKeterangan(rs.getString(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_KETERANGAN]));
			sewatanahkomin.setSewaTanahId(rs.getLong(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_SEWA_TANAH_ID]));
                        sewatanahkomin.setDasarPerhitungan(rs.getInt(DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_DASAR_PERHITUNGAN]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long sewaTanahKominId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_KOMIN + " WHERE " + 
						DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_SEWA_TANAH_KOMIN_ID] + " = " + sewaTanahKominId;

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
			String sql = "SELECT COUNT("+ DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_SEWA_TANAH_KOMIN_ID] + ") FROM " + DB_CRM_SEWA_TANAH_KOMIN;
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
			  	   SewaTanahKomin sewatanahkomin = (SewaTanahKomin)list.get(ls);
				   if(oid == sewatanahkomin.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static Vector list(int limitStart,int recordToGet, String whereClause, String order,String group){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_KOMIN; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
                        if(group != null && group.length() > 0)
                                sql = sql + " GROUP BY " + group;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				SewaTanahKomin sewatanahkomin = new SewaTanahKomin();
				resultToObject(rs, sewatanahkomin);
				lists.add(sewatanahkomin);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println("List DbSewaTanahKomin() : "+e.toString());
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}
        
        
        public static Date getMulai(String period){
            
            CONResultSet dbrs = null;
            
            try{
                
                String sql = "SELECT MIN("+DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_MULAI]+") FROM "+
                        DbSewaTanahKomin.DB_CRM_SEWA_TANAH_KOMIN+" WHERE "+
                        DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_NAMA]+" = '"+period+"'";
                
                System.out.println("sql "+sql);
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
		while(rs.next()) {
                    return rs.getDate(1);
		}
                
            }catch(Exception E){
                System.out.println("");
            }
            
            return null;
            
        }
        
        public static Date getSelesai(String period){
            
            CONResultSet dbrs = null;
            
            try{
                
                String sql = "SELECT MAX("+DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_SELESAI]+") FROM "+
                        DbSewaTanahKomin.DB_CRM_SEWA_TANAH_KOMIN+" WHERE "+
                        DbSewaTanahKomin.colNames[DbSewaTanahKomin.COL_NAMA]+" = '"+period+"'";
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
		while(rs.next()) {
                    return rs.getDate(1);
		}
                
            }catch(Exception E){
                System.out.println("");
            }
            
            return null;
            
        }
        
        
        public static SewaTanahKomin getActifKomin(int year, long sewaTanahId){
        	
        	Date dt = new Date();
        	dt.setYear(year-1900);
        	
        	String sql = "select * from "+DB_CRM_SEWA_TANAH_KOMIN+
        		" where '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"+
        		" between "+colNames[COL_MULAI]+
        		" and "+colNames[COL_SELESAI]+" and "+colNames[COL_SEWA_TANAH_ID]+"="+sewaTanahId;
        		
        	System.out.println(sql);	
        		
        	SewaTanahKomin stk = new SewaTanahKomin();	
        	CONResultSet crs = null;
        	try{
        		crs = CONHandler.execQueryResult(sql);
        		ResultSet rs = crs.getResultSet();
        		while(rs.next()){
        			resultToObject(rs, stk);
        		}	
        	}catch(Exception e){
        		
        	}
        	finally{
        		CONResultSet.close(crs);
        	}	
        		
        	return stk;	
        		
        }
        
}
