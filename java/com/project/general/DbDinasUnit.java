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

public class DbDinasUnit extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_DINAS_UNIT = "dinas_unit";

	public static final  int COL_DINAS_ID = 0;
	public static final  int COL_DINAS_UNIT_ID = 1;
	public static final  int COL_NAMA = 2;

	public static final  String[] colNames = {
		"dinas_id",
		"dinas_unit_id",
		"nama"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
	 }; 

	public DbDinasUnit(){
	}

	public DbDinasUnit(int i) throws CONException { 
		super(new DbDinasUnit()); 
	}

	public DbDinasUnit(String sOid) throws CONException { 
		super(new DbDinasUnit(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbDinasUnit(long lOid) throws CONException { 
		super(new DbDinasUnit(0)); 
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
		return DB_DINAS_UNIT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbDinasUnit().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		DinasUnit dinasunit = fetchExc(ent.getOID()); 
		ent = (Entity)dinasunit; 
		return dinasunit.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((DinasUnit) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((DinasUnit) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static DinasUnit fetchExc(long oid) throws CONException{ 
		try{ 
			DinasUnit dinasunit = new DinasUnit();
			DbDinasUnit DbDinasUnit = new DbDinasUnit(oid); 
			dinasunit.setOID(oid);

			dinasunit.setDinasId(DbDinasUnit.getlong(COL_DINAS_ID));
			dinasunit.setNama(DbDinasUnit.getString(COL_NAMA));

			return dinasunit; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDinasUnit(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(DinasUnit dinasunit) throws CONException{ 
		try{ 
			DbDinasUnit DbDinasUnit = new DbDinasUnit(0);

			DbDinasUnit.setLong(COL_DINAS_ID, dinasunit.getDinasId());
			DbDinasUnit.setString(COL_NAMA, dinasunit.getNama());

			DbDinasUnit.insert(); 
			dinasunit.setOID(DbDinasUnit.getlong(COL_DINAS_UNIT_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDinasUnit(0),CONException.UNKNOWN); 
		}
		return dinasunit.getOID();
	}

	public static long updateExc(DinasUnit dinasunit) throws CONException{ 
		try{ 
			if(dinasunit.getOID() != 0){ 
				DbDinasUnit DbDinasUnit = new DbDinasUnit(dinasunit.getOID());

				DbDinasUnit.setLong(COL_DINAS_ID, dinasunit.getDinasId());
				DbDinasUnit.setString(COL_NAMA, dinasunit.getNama());

				DbDinasUnit.update(); 
				return dinasunit.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDinasUnit(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbDinasUnit DbDinasUnit = new DbDinasUnit(oid);
			DbDinasUnit.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDinasUnit(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_DINAS_UNIT; 
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
				DinasUnit dinasunit = new DinasUnit();
				resultToObject(rs, dinasunit);
				lists.add(dinasunit);
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

	private static void resultToObject(ResultSet rs, DinasUnit dinasunit){
		try{
			dinasunit.setOID(rs.getLong(DbDinasUnit.colNames[DbDinasUnit.COL_DINAS_UNIT_ID]));
			dinasunit.setDinasId(rs.getLong(DbDinasUnit.colNames[DbDinasUnit.COL_DINAS_ID]));
			dinasunit.setNama(rs.getString(DbDinasUnit.colNames[DbDinasUnit.COL_NAMA]));

		}catch(Exception e){ }
	}

	

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbDinasUnit.colNames[DbDinasUnit.COL_DINAS_UNIT_ID] + ") FROM " + DB_DINAS_UNIT;
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
			  	   DinasUnit dinasunit = (DinasUnit)list.get(ls);
				   if(oid == dinasunit.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
