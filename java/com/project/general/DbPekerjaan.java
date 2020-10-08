/*
 * DbPekerjaan.java
 *
 * Created on September 17, 2008, 12:08 PM
 */

package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 

public class DbPekerjaan extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_PEKERJAAN = "pekerjaan";

	public static final  int COL_PEKERJAAN_ID = 0;
	public static final  int COL_KODE = 1;
	public static final  int COL_NAMA = 2;
      
        
	
	public static final  String[] colNames = {
		"pekerjaan_id",
		"kode",
		"nama"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbPekerjaan(){
	}

	public DbPekerjaan(int i) throws CONException { 
		super(new DbPekerjaan()); 
	}

	public DbPekerjaan(String sOid) throws CONException { 
		super(new DbPekerjaan(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPekerjaan(long lOid) throws CONException { 
		super(new DbPekerjaan(0)); 
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
		return DB_PEKERJAAN;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPekerjaan().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Pekerjaan pekerjaan = fetchExc(ent.getOID()); 
		ent = (Entity)pekerjaan; 
		return pekerjaan.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Pekerjaan) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Pekerjaan) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Pekerjaan fetchExc(long oid) throws CONException{ 
		try{ 
			Pekerjaan pekerjaan = new Pekerjaan();
			DbPekerjaan pstPekerjaan = new DbPekerjaan(oid); 
			pekerjaan.setOID(oid);
			
			pekerjaan.setKode(pstPekerjaan.getString(COL_KODE));
			pekerjaan.setNama(pstPekerjaan.getString(COL_NAMA));
                        
			return pekerjaan; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPekerjaan(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Pekerjaan pekerjaan) throws CONException{ 
		try{ 
			DbPekerjaan pstPekerjaan = new DbPekerjaan(0);
			
			pstPekerjaan.setString(COL_KODE, pekerjaan.getKode());
			pstPekerjaan.setString(COL_NAMA, pekerjaan.getNama());

			pstPekerjaan.insert(); 
			pekerjaan.setOID(pstPekerjaan.getlong(COL_PEKERJAAN_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPekerjaan(0),CONException.UNKNOWN); 
		}
		return pekerjaan.getOID();
	}

	public static long updateExc(Pekerjaan pekerjaan) throws CONException{ 
		try{ 
			if(pekerjaan.getOID() != 0){ 
				DbPekerjaan pstPekerjaan = new DbPekerjaan(pekerjaan.getOID());
				
				pstPekerjaan.setString(COL_KODE, pekerjaan.getKode());
				pstPekerjaan.setString(COL_NAMA, pekerjaan.getNama());

				pstPekerjaan.update(); 
				return pekerjaan.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPekerjaan(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPekerjaan pstPekerjaan = new DbPekerjaan(oid);
			pstPekerjaan.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPekerjaan(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PEKERJAAN; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			
                        switch (CONHandler.CONSVR_TYPE) {
                            case CONHandler.CONSVR_MYSQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                                break;

                            case CONHandler.CONSVR_POSTGRESQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;

                                break;

                            case CONHandler.CONSVR_SYBASE:
                                break;

                            case CONHandler.CONSVR_ORACLE:
                                break;

                            case CONHandler.CONSVR_MSSQL:
                                break;

                            default:
                                break;
                        }
                        
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				Pekerjaan pekerjaan = new Pekerjaan();
				resultToObject(rs, pekerjaan);
				lists.add(pekerjaan);
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

	private static void resultToObject(ResultSet rs, Pekerjaan pekerjaan){
		try{
			pekerjaan.setOID(rs.getLong(DbPekerjaan.colNames[DbPekerjaan.COL_PEKERJAAN_ID]));
			//pekerjaan.setProvinceId(rs.getLong(DbPekerjaan.colNames[DbPekerjaan.COL_PROVINCE_ID]));
			pekerjaan.setKode(rs.getString(DbPekerjaan.colNames[DbPekerjaan.COL_KODE]));
			pekerjaan.setNama(rs.getString(DbPekerjaan.colNames[DbPekerjaan.COL_NAMA]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long telpChargeId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PEKERJAAN + " WHERE " + 
						DbPekerjaan.colNames[DbPekerjaan.COL_PEKERJAAN_ID] + " = " + telpChargeId;

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
			String sql = "SELECT COUNT("+ DbPekerjaan.colNames[DbPekerjaan.COL_PEKERJAAN_ID] + ") FROM " + DB_PEKERJAAN;
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
			  	   Pekerjaan pekerjaan = (Pekerjaan)list.get(ls);
				   if(oid == pekerjaan.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
