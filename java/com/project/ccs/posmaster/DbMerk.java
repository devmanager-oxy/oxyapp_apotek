
package com.project.ccs.posmaster; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*; 

public class DbMerk extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_MERK = "pos_merk";

	public static final  int COL_MERK_ID = 0;
	public static final  int COL_NAME = 1;
	
	public static final  String[] colNames = {
		"merk_id",
		"name"
		
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
		
	 }; 

	public DbMerk(){
	}

	public DbMerk(int i) throws CONException { 
		super(new DbMerk()); 
	}

	public DbMerk(String sOid) throws CONException { 
		super(new DbMerk(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbMerk(long lOid) throws CONException { 
		super(new DbMerk(0)); 
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
		return DB_MERK;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbMerk().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Merk merk = fetchExc(ent.getOID()); 
		ent = (Entity)merk; 
		return merk.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Merk) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Merk) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Merk fetchExc(long oid) throws CONException{ 
		try{ 
			Merk merk = new Merk();
			DbMerk dbMerk = new DbMerk(oid); 
			merk.setOID(oid);

			merk.setName(dbMerk.getString(COL_NAME));
			

			return merk; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMerk(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Merk merk) throws CONException{ 
		try{ 
			DbMerk dbMerk = new DbMerk(0);

			dbMerk.setString(COL_NAME, merk.getName());
			
                        

			dbMerk.insert(); 
			merk.setOID(dbMerk.getlong(COL_MERK_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMerk(0),CONException.UNKNOWN); 
		}
		return merk.getOID();
	}

	public static long updateExc(Merk merk) throws CONException{ 
		try{ 
			if(merk.getOID() != 0){ 
				DbMerk dbMerk = new DbMerk(merk.getOID());

				dbMerk.setString(COL_NAME, merk.getName());
				
				dbMerk.update(); 
				return merk.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbShift(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbMerk dbMerk = new DbMerk(oid);
			dbMerk.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMerk(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_MERK; 
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
				Merk merk = new Merk();
				resultToObject(rs, merk);
				lists.add(merk);
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

	private static void resultToObject(ResultSet rs, Merk merk){
		try{
                    merk.setName(rs.getString(DbMerk.colNames[DbMerk.COL_NAME]));
                    merk.setOID(rs.getLong(DbMerk.colNames[DbMerk.COL_MERK_ID]));
						
		}catch(Exception e){ }
	}

	public static boolean checkOID(long merkId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_MERK + " WHERE " + 
						DbMerk.colNames[DbMerk.COL_MERK_ID] + " = " + merkId;

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
			String sql = "SELECT COUNT("+ DbMerk.colNames[DbMerk.COL_MERK_ID] + ") FROM " + DB_MERK;
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
			  	   Merk merk = (Merk)list.get(ls);
				   if(oid == merk.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
