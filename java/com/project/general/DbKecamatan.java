/*
 * DbKecamatan.java
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

public class DbKecamatan extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_KECAMATAN = "kecamatan";

	public static final  int COL_KECAMATAN_ID = 0;
	//public static final  int COL_KABUPATEN_ID = 1;
	public static final  int COL_KODE = 1;
	public static final  int COL_NAMA = 2;
	
	public static final  String[] colNames = {
		"kecamatan_id",
		//"kabupaten_id",
		"kode",
		"nama"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		//TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbKecamatan(){
	}

	public DbKecamatan(int i) throws CONException { 
		super(new DbKecamatan()); 
	}

	public DbKecamatan(String sOid) throws CONException { 
		super(new DbKecamatan(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbKecamatan(long lOid) throws CONException { 
		super(new DbKecamatan(0)); 
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
		return DB_KECAMATAN;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbKecamatan().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Kecamatan kabupaten = fetchExc(ent.getOID()); 
		ent = (Entity)kabupaten; 
		return kabupaten.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Kecamatan) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Kecamatan) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Kecamatan fetchExc(long oid) throws CONException{ 
		try{ 
			Kecamatan kabupaten = new Kecamatan();
			DbKecamatan pstKecamatan = new DbKecamatan(oid); 
			kabupaten.setOID(oid);

			//kabupaten.setKabupatenId(pstKecamatan.getlong(COL_KABUPATEN_ID));
			kabupaten.setKode(pstKecamatan.getString(COL_KODE));
			kabupaten.setNama(pstKecamatan.getString(COL_NAMA));
                        
			return kabupaten; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbKecamatan(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Kecamatan kabupaten) throws CONException{ 
		try{ 
			DbKecamatan pstKecamatan = new DbKecamatan(0);

			//pstKecamatan.setLong(COL_KABUPATEN_ID, kabupaten.getKabupatenId());
			pstKecamatan.setString(COL_KODE, kabupaten.getKode());
			pstKecamatan.setString(COL_NAMA, kabupaten.getNama());

			pstKecamatan.insert(); 
			kabupaten.setOID(pstKecamatan.getlong(COL_KECAMATAN_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbKecamatan(0),CONException.UNKNOWN); 
		}
		return kabupaten.getOID();
	}

	public static long updateExc(Kecamatan kabupaten) throws CONException{ 
		try{ 
			if(kabupaten.getOID() != 0){ 
				DbKecamatan pstKecamatan = new DbKecamatan(kabupaten.getOID());

				//pstKecamatan.setLong(COL_KABUPATEN_ID, kabupaten.getKabupatenId());
				pstKecamatan.setString(COL_KODE, kabupaten.getKode());
				pstKecamatan.setString(COL_NAMA, kabupaten.getNama());

				pstKecamatan.update(); 
				return kabupaten.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbKecamatan(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbKecamatan pstKecamatan = new DbKecamatan(oid);
			pstKecamatan.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbKecamatan(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_KECAMATAN; 
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
				Kecamatan kabupaten = new Kecamatan();
				resultToObject(rs, kabupaten);
				lists.add(kabupaten);
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

	private static void resultToObject(ResultSet rs, Kecamatan kabupaten){
		try{
			kabupaten.setOID(rs.getLong(DbKecamatan.colNames[DbKecamatan.COL_KECAMATAN_ID]));
			//kabupaten.setKabupatenId(rs.getLong(DbKecamatan.colNames[DbKecamatan.COL_KABUPATEN_ID]));
			kabupaten.setKode(rs.getString(DbKecamatan.colNames[DbKecamatan.COL_KODE]));
			kabupaten.setNama(rs.getString(DbKecamatan.colNames[DbKecamatan.COL_NAMA]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long telpChargeId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_KECAMATAN + " WHERE " + 
						DbKecamatan.colNames[DbKecamatan.COL_KECAMATAN_ID] + " = " + telpChargeId;

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
			String sql = "SELECT COUNT("+ DbKecamatan.colNames[DbKecamatan.COL_KECAMATAN_ID] + ") FROM " + DB_KECAMATAN;
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
			  	   Kecamatan kabupaten = (Kecamatan)list.get(ls);
				   if(oid == kabupaten.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
