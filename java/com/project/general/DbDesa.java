/*
 * DbDesa.java
 *
 * Created on September 17, 2008, 12:22 PM
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

public class DbDesa extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_DESA = "desa";

	public static final  int COL_DESA_ID = 0;
	public static final  int COL_KECAMATAN_ID = 1;
	public static final  int COL_KODE = 2;
	public static final  int COL_NAMA = 3;
	
	public static final  String[] colNames = {
		"desa_id",
		"kecamatan_id",
		"kode",
		"nama"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbDesa(){
	}

	public DbDesa(int i) throws CONException { 
		super(new DbDesa()); 
	}

	public DbDesa(String sOid) throws CONException { 
		super(new DbDesa(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbDesa(long lOid) throws CONException { 
		super(new DbDesa(0)); 
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
		return DB_DESA;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbDesa().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Desa desa = fetchExc(ent.getOID()); 
		ent = (Entity)desa; 
		return desa.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Desa) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Desa) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Desa fetchExc(long oid) throws CONException{ 
		try{ 
			Desa desa = new Desa();
			DbDesa pstDesa = new DbDesa(oid); 
			desa.setOID(oid);

			desa.setKecamatanId(pstDesa.getlong(COL_KECAMATAN_ID));
			desa.setKode(pstDesa.getString(COL_KODE));
			desa.setNama(pstDesa.getString(COL_NAMA));
                        
			return desa; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDesa(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Desa desa) throws CONException{ 
		try{ 
			DbDesa pstDesa = new DbDesa(0);

			pstDesa.setLong(COL_KECAMATAN_ID, desa.getKecamatanId());
			pstDesa.setString(COL_KODE, desa.getKode());
			pstDesa.setString(COL_NAMA, desa.getNama());

			pstDesa.insert(); 
			desa.setOID(pstDesa.getlong(COL_DESA_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDesa(0),CONException.UNKNOWN); 
		}
		return desa.getOID();
	}

	public static long updateExc(Desa desa) throws CONException{ 
		try{ 
			if(desa.getOID() != 0){ 
				DbDesa pstDesa = new DbDesa(desa.getOID());

				pstDesa.setLong(COL_KECAMATAN_ID, desa.getKecamatanId());
				pstDesa.setString(COL_KODE, desa.getKode());
				pstDesa.setString(COL_NAMA, desa.getNama());

				pstDesa.update(); 
				return desa.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDesa(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbDesa pstDesa = new DbDesa(oid);
			pstDesa.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDesa(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_DESA; 
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
				Desa desa = new Desa();
				resultToObject(rs, desa);
				lists.add(desa);
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

	private static void resultToObject(ResultSet rs, Desa desa){
		try{
			desa.setOID(rs.getLong(DbDesa.colNames[DbDesa.COL_DESA_ID]));
			desa.setKecamatanId(rs.getLong(DbDesa.colNames[DbDesa.COL_KECAMATAN_ID]));
			desa.setKode(rs.getString(DbDesa.colNames[DbDesa.COL_KODE]));
			desa.setNama(rs.getString(DbDesa.colNames[DbDesa.COL_NAMA]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long telpChargeId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_DESA + " WHERE " + 
						DbDesa.colNames[DbDesa.COL_DESA_ID] + " = " + telpChargeId;

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
			String sql = "SELECT COUNT("+ DbDesa.colNames[DbDesa.COL_DESA_ID] + ") FROM " + DB_DESA;
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
			  	   Desa desa = (Desa)list.get(ls);
				   if(oid == desa.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
