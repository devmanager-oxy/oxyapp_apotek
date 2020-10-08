
package com.project.fms.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class DbItemType extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_ITEM_TYPE = "item_type";

	public static final  int CL_ITEM_TYPE_ID = 0;
	public static final  int CL_DESCRIPTION = 1;

	public static final  String[] colNames = {
		"item_type_id",
		"description"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
	 }; 

	public DbItemType(){
	}

	public DbItemType(int i) throws CONException { 
		super(new DbItemType()); 
	}

	public DbItemType(String sOid) throws CONException { 
		super(new DbItemType(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbItemType(long lOid) throws CONException { 
		super(new DbItemType(0)); 
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
		return DB_ITEM_TYPE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbItemType().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		ItemType itemtype = fetchExc(ent.getOID()); 
		ent = (Entity)itemtype; 
		return itemtype.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((ItemType) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((ItemType) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static ItemType fetchExc(long oid) throws CONException{ 
		try{ 
			ItemType itemtype = new ItemType();
			DbItemType pstItemType = new DbItemType(oid); 
			itemtype.setOID(oid);

			itemtype.setDescription(pstItemType.getString(CL_DESCRIPTION));

			return itemtype; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemType(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(ItemType itemtype) throws CONException{ 
		try{ 
			DbItemType pstItemType = new DbItemType(0);

			pstItemType.setString(CL_DESCRIPTION, itemtype.getDescription());

			pstItemType.insert(); 
			itemtype.setOID(pstItemType.getlong(CL_ITEM_TYPE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemType(0),CONException.UNKNOWN); 
		}
		return itemtype.getOID();
	}

	public static long updateExc(ItemType itemtype) throws CONException{ 
		try{ 
			if(itemtype.getOID() != 0){ 
				DbItemType pstItemType = new DbItemType(itemtype.getOID());

				pstItemType.setString(CL_DESCRIPTION, itemtype.getDescription());

				pstItemType.update(); 
				return itemtype.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemType(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbItemType pstItemType = new DbItemType(oid);
			pstItemType.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemType(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_ITEM_TYPE; 
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
				ItemType itemtype = new ItemType();
				resultToObject(rs, itemtype);
				lists.add(itemtype);
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

	private static void resultToObject(ResultSet rs, ItemType itemtype){
		try{
			itemtype.setOID(rs.getLong(DbItemType.colNames[DbItemType.CL_ITEM_TYPE_ID]));
			itemtype.setDescription(rs.getString(DbItemType.colNames[DbItemType.CL_DESCRIPTION]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long itemTypeId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_ITEM_TYPE + " WHERE " + 
						DbItemType.colNames[DbItemType.CL_ITEM_TYPE_ID] + " = " + itemTypeId;

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
			String sql = "SELECT COUNT("+ DbItemType.colNames[DbItemType.CL_ITEM_TYPE_ID] + ") FROM " + DB_ITEM_TYPE;
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
			  	   ItemType itemtype = (ItemType)list.get(ls);
				   if(oid == itemtype.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
   
        
}
