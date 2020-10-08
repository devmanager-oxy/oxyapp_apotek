
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

public class DbItemCategory extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_ITEM_CATEGORY = "pos_item_category";

	public static final  int COL_ITEM_CATEGORY_ID = 0;
	public static final  int COL_ITEM_GROUP_ID = 1;
	public static final  int COL_NAME = 2;
	public static final  int COL_PRIORITY = 3;
	public static final  int COL_ACCOUNT_CODE = 4;
        public static final  int COL_CODE = 5;
        public static final  int COL_GROUP_CODE = 6;
        public static final  int COL_GROUP_TYPE = 7;
        

	public static final  String[] colNames = {
		"item_category_id",
		"item_group_id",
		"name",
		"priority",
		"account_code",
                "group_code",
                "code",
                "group_type"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_INT,
		TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_INT
	 }; 

	public DbItemCategory(){
	}

	public DbItemCategory(int i) throws CONException { 
		super(new DbItemCategory()); 
	}

	public DbItemCategory(String sOid) throws CONException { 
		super(new DbItemCategory(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbItemCategory(long lOid) throws CONException { 
		super(new DbItemCategory(0)); 
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
		return DB_ITEM_CATEGORY;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbItemCategory().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		ItemCategory itemcategory = fetchExc(ent.getOID()); 
		ent = (Entity)itemcategory; 
		return itemcategory.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((ItemCategory) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((ItemCategory) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static ItemCategory fetchExc(long oid) throws CONException{ 
		try{ 
			ItemCategory itemcategory = new ItemCategory();
			DbItemCategory pstItemCategory = new DbItemCategory(oid); 
			itemcategory.setOID(oid);

			itemcategory.setItemGroupId(pstItemCategory.getlong(COL_ITEM_GROUP_ID));
			itemcategory.setName(pstItemCategory.getString(COL_NAME));
			itemcategory.setPriority(pstItemCategory.getInt(COL_PRIORITY));
			itemcategory.setAccountCode(pstItemCategory.getString(COL_ACCOUNT_CODE));
                        itemcategory.setCode(pstItemCategory.getString(COL_CODE));
                        itemcategory.setGroupCode(pstItemCategory.getString(COL_GROUP_CODE));
                        itemcategory.setGroupType(pstItemCategory.getInt(COL_GROUP_TYPE));
                        
			return itemcategory; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemCategory(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(ItemCategory itemcategory) throws CONException{ 
		try{ 
			DbItemCategory pstItemCategory = new DbItemCategory(0);

			pstItemCategory.setLong(COL_ITEM_GROUP_ID, itemcategory.getItemGroupId());
			pstItemCategory.setString(COL_NAME, itemcategory.getName());
			pstItemCategory.setInt(COL_PRIORITY, itemcategory.getPriority());
			pstItemCategory.setString(COL_ACCOUNT_CODE, itemcategory.getAccountCode());
                        pstItemCategory.setString(COL_CODE, itemcategory.getCode());
                        pstItemCategory.setString(COL_GROUP_CODE, itemcategory.getGroupCode());
                        pstItemCategory.setInt(COL_GROUP_TYPE, itemcategory.getGroupType());
                        

			pstItemCategory.insert(); 
			itemcategory.setOID(pstItemCategory.getlong(COL_ITEM_CATEGORY_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemCategory(0),CONException.UNKNOWN); 
		}
		return itemcategory.getOID();
	}

	public static long updateExc(ItemCategory itemcategory) throws CONException{ 
		try{ 
			if(itemcategory.getOID() != 0){ 
				DbItemCategory pstItemCategory = new DbItemCategory(itemcategory.getOID());

				pstItemCategory.setLong(COL_ITEM_GROUP_ID, itemcategory.getItemGroupId());
				pstItemCategory.setString(COL_NAME, itemcategory.getName());
				pstItemCategory.setInt(COL_PRIORITY, itemcategory.getPriority());
				pstItemCategory.setString(COL_ACCOUNT_CODE, itemcategory.getAccountCode());
                                pstItemCategory.setString(COL_CODE, itemcategory.getCode());
                                pstItemCategory.setString(COL_GROUP_CODE, itemcategory.getGroupCode());
                                pstItemCategory.setInt(COL_GROUP_TYPE, itemcategory.getGroupType());

				pstItemCategory.update(); 
				return itemcategory.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemCategory(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbItemCategory pstItemCategory = new DbItemCategory(oid);
			pstItemCategory.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbItemCategory(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_ITEM_CATEGORY; 
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
				ItemCategory itemcategory = new ItemCategory();
				resultToObject(rs, itemcategory);
				lists.add(itemcategory);
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

	public static void resultToObject(ResultSet rs, ItemCategory itemcategory){
		try{
			itemcategory.setOID(rs.getLong(DbItemCategory.colNames[DbItemCategory.COL_ITEM_CATEGORY_ID]));
			itemcategory.setItemGroupId(rs.getLong(DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID]));
			itemcategory.setName(rs.getString(DbItemCategory.colNames[DbItemCategory.COL_NAME]));
			itemcategory.setPriority(rs.getInt(DbItemCategory.colNames[DbItemCategory.COL_PRIORITY]));
			itemcategory.setAccountCode(rs.getString(DbItemCategory.colNames[DbItemCategory.COL_ACCOUNT_CODE]));
                        itemcategory.setCode(rs.getString(DbItemCategory.colNames[DbItemCategory.COL_CODE]));
                        itemcategory.setGroupCode(rs.getString(DbItemCategory.colNames[DbItemCategory.COL_GROUP_CODE]));
                        itemcategory.setGroupType(rs.getInt(DbItemCategory.colNames[DbItemCategory.COL_GROUP_TYPE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long itemCategoryId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_ITEM_CATEGORY + " WHERE " + 
						DbItemCategory.colNames[DbItemCategory.COL_ITEM_CATEGORY_ID] + " = " + itemCategoryId;

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
			String sql = "SELECT COUNT("+ DbItemCategory.colNames[DbItemCategory.COL_ITEM_CATEGORY_ID] + ") FROM " + DB_ITEM_CATEGORY;
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
			  	   ItemCategory itemcategory = (ItemCategory)list.get(ls);
				   if(oid == itemcategory.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
