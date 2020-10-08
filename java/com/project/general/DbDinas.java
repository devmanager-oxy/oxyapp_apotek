package com.project.general;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.I_Language;

public class DbDinas extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_DINAS = "dinas";

	public static final  int COL_DINAS_ID = 0;
	public static final  int COL_NAMA = 1;

	public static final  String[] colNames = {
		"dinas_id",
		"nama"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
	 }; 

	public DbDinas(){
	}

	public DbDinas(int i) throws CONException { 
		super(new DbDinas()); 
	}

	public DbDinas(String sOid) throws CONException { 
		super(new DbDinas(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbDinas(long lOid) throws CONException { 
		super(new DbDinas(0)); 
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
		return DB_DINAS;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbDinas().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Dinas dinas = fetchExc(ent.getOID()); 
		ent = (Entity)dinas; 
		return dinas.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Dinas) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Dinas) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Dinas fetchExc(long oid) throws CONException{ 
		try{ 
			Dinas dinas = new Dinas();
			DbDinas DbDinas = new DbDinas(oid); 
			dinas.setOID(oid);

			dinas.setNama(DbDinas.getString(COL_NAMA));

			return dinas; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDinas(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Dinas dinas) throws CONException{ 
		try{ 
			DbDinas DbDinas = new DbDinas(0);

			DbDinas.setString(COL_NAMA, dinas.getNama());

			DbDinas.insert(); 
			dinas.setOID(DbDinas.getlong(COL_DINAS_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDinas(0),CONException.UNKNOWN); 
		}
		return dinas.getOID();
	}

	public static long updateExc(Dinas dinas) throws CONException{ 
		try{ 
			if(dinas.getOID() != 0){ 
				DbDinas DbDinas = new DbDinas(dinas.getOID());

				DbDinas.setString(COL_NAMA, dinas.getNama());

				DbDinas.update(); 
				return dinas.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDinas(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbDinas DbDinas = new DbDinas(oid);
			DbDinas.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDinas(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_DINAS; 
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
				Dinas dinas = new Dinas();
				resultToObject(rs, dinas);
				lists.add(dinas);
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

	private static void resultToObject(ResultSet rs, Dinas dinas){
		try{
			dinas.setOID(rs.getLong(DbDinas.colNames[DbDinas.COL_DINAS_ID]));
			dinas.setNama(rs.getString(DbDinas.colNames[DbDinas.COL_NAMA]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long dinasId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_DINAS + " WHERE " + 
						DbDinas.colNames[DbDinas.COL_DINAS_ID] + " = " + dinasId;

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
			String sql = "SELECT COUNT("+ DbDinas.colNames[DbDinas.COL_DINAS_ID] + ") FROM " + DB_DINAS;
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
			  	   Dinas dinas = (Dinas)list.get(ls);
				   if(oid == dinas.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
