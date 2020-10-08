

package com.project.fms.transaction; 

/* package java */ 
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.fms.transaction.*;

public class DbPurchaseItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_PURCHASE_ITEM = "purchase_item";

	public static final  int COL_PURCHASE_ID = 0;
	public static final  int COL_PURCHASE_ITEM_ID = 1;
	public static final  int COL_ITEM_NAME = 2;
	public static final  int COL_QTY = 3;
	public static final  int COL_PRICE = 4;
	public static final  int COL_TOTAL_AMOUNT = 5;
	public static final  int COL_DISCOUNT = 6;
	public static final  int COL_ITEM_TYPE = 7;
	public static final  int COL_COA_ID = 8;
        
        public static final  int COL_DEPARTMENT_ID = 9;

	public static final  String[] colNames = {
		"purchase_id",		
		"purchase_item_id",
		"item_name",
		"qty",
		"price",
		"total_amount",
		"discount",
		"item_type",
		"coa_id",
                "department_id"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_LONG,
                TYPE_LONG
	 }; 

	public DbPurchaseItem(){
	}

	public DbPurchaseItem(int i) throws CONException { 
		super(new DbPurchaseItem()); 
	}

	public DbPurchaseItem(String sOid) throws CONException { 
		super(new DbPurchaseItem(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPurchaseItem(long lOid) throws CONException { 
		super(new DbPurchaseItem(0)); 
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
		return DB_PURCHASE_ITEM;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPurchaseItem().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PurchaseItem purchaseitem = fetchExc(ent.getOID()); 
		ent = (Entity)purchaseitem; 
		return purchaseitem.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PurchaseItem) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PurchaseItem) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PurchaseItem fetchExc(long oid) throws CONException{ 
		try{ 
			PurchaseItem purchaseitem = new PurchaseItem();
			DbPurchaseItem pstPurchaseItem = new DbPurchaseItem(oid); 
			purchaseitem.setOID(oid);

			purchaseitem.setPurchaseId(pstPurchaseItem.getlong(COL_PURCHASE_ID));
			purchaseitem.setItemName(pstPurchaseItem.getString(COL_ITEM_NAME));
			purchaseitem.setQty(pstPurchaseItem.getdouble(COL_QTY));
			purchaseitem.setPrice(pstPurchaseItem.getdouble(COL_PRICE));
			purchaseitem.setTotalAmount(pstPurchaseItem.getdouble(COL_TOTAL_AMOUNT));
			purchaseitem.setDiscount(pstPurchaseItem.getdouble(COL_DISCOUNT));
			purchaseitem.setItemType(pstPurchaseItem.getString(COL_ITEM_TYPE));
			purchaseitem.setCoaId(pstPurchaseItem.getlong(COL_COA_ID));
                        
                        purchaseitem.setDepartmentId(pstPurchaseItem.getlong(COL_DEPARTMENT_ID));

			return purchaseitem; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchaseItem(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PurchaseItem purchaseitem) throws CONException{ 
		try{ 
			DbPurchaseItem pstPurchaseItem = new DbPurchaseItem(0);

			pstPurchaseItem.setLong(COL_PURCHASE_ID, purchaseitem.getPurchaseId());
			pstPurchaseItem.setString(COL_ITEM_NAME, purchaseitem.getItemName());
			pstPurchaseItem.setDouble(COL_QTY, purchaseitem.getQty());
			pstPurchaseItem.setDouble(COL_PRICE, purchaseitem.getPrice());
			pstPurchaseItem.setDouble(COL_TOTAL_AMOUNT, purchaseitem.getTotalAmount());
			pstPurchaseItem.setDouble(COL_DISCOUNT, purchaseitem.getDiscount());
			pstPurchaseItem.setString(COL_ITEM_TYPE, purchaseitem.getItemType());
			pstPurchaseItem.setLong(COL_COA_ID, purchaseitem.getCoaId());
                        
                        pstPurchaseItem.setLong(COL_DEPARTMENT_ID, purchaseitem.getDepartmentId());
                        

			pstPurchaseItem.insert(); 
			purchaseitem.setOID(pstPurchaseItem.getlong(COL_PURCHASE_ITEM_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchaseItem(0),CONException.UNKNOWN); 
		}
		return purchaseitem.getOID();
	}

	public static long updateExc(PurchaseItem purchaseitem) throws CONException{ 
		try{ 
			if(purchaseitem.getOID() != 0){ 
				DbPurchaseItem pstPurchaseItem = new DbPurchaseItem(purchaseitem.getOID());

				pstPurchaseItem.setLong(COL_PURCHASE_ID, purchaseitem.getPurchaseId());
				pstPurchaseItem.setString(COL_ITEM_NAME, purchaseitem.getItemName());
				pstPurchaseItem.setDouble(COL_QTY, purchaseitem.getQty());
				pstPurchaseItem.setDouble(COL_PRICE, purchaseitem.getPrice());
				pstPurchaseItem.setDouble(COL_TOTAL_AMOUNT, purchaseitem.getTotalAmount());
				pstPurchaseItem.setDouble(COL_DISCOUNT, purchaseitem.getDiscount());
				pstPurchaseItem.setString(COL_ITEM_TYPE, purchaseitem.getItemType());
				pstPurchaseItem.setLong(COL_COA_ID, purchaseitem.getCoaId());
                                
                                pstPurchaseItem.setLong(COL_DEPARTMENT_ID, purchaseitem.getDepartmentId());

				pstPurchaseItem.update(); 
				return purchaseitem.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchaseItem(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPurchaseItem pstPurchaseItem = new DbPurchaseItem(oid);
			pstPurchaseItem.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchaseItem(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PURCHASE_ITEM; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                        
                        System.out.println(sql);
                        
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				PurchaseItem purchaseitem = new PurchaseItem();
				resultToObject(rs, purchaseitem);
				lists.add(purchaseitem);
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

	private static void resultToObject(ResultSet rs, PurchaseItem purchaseitem){
		try{
			purchaseitem.setOID(rs.getLong(DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ITEM_ID]));
			purchaseitem.setPurchaseId(rs.getLong(DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]));
			purchaseitem.setItemName(rs.getString(DbPurchaseItem.colNames[DbPurchaseItem.COL_ITEM_NAME]));
			purchaseitem.setQty(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_QTY]));
			purchaseitem.setPrice(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_PRICE]));
			purchaseitem.setTotalAmount(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_TOTAL_AMOUNT]));
			purchaseitem.setDiscount(rs.getDouble(DbPurchaseItem.colNames[DbPurchaseItem.COL_DISCOUNT]));
			purchaseitem.setItemType(rs.getString(DbPurchaseItem.colNames[DbPurchaseItem.COL_ITEM_TYPE]));
			purchaseitem.setCoaId(rs.getLong(DbPurchaseItem.colNames[DbPurchaseItem.COL_COA_ID]));
                        
                        purchaseitem.setDepartmentId(rs.getLong(DbPurchaseItem.colNames[DbPurchaseItem.COL_DEPARTMENT_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long purchaseItemId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PURCHASE_ITEM + " WHERE " + 
						DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID] + " = " + purchaseItemId;

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
			String sql = "SELECT COUNT("+ DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ITEM_ID] + ") FROM " + DB_PURCHASE_ITEM;
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
			  	   PurchaseItem purchaseitem = (PurchaseItem)list.get(ls);
				   if(oid == purchaseitem.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static void deleteItemByPurchaseId(long oidPurchase){
                
		try{
                    CONHandler.execUpdate("delete from "+DB_PURCHASE_ITEM+" where purchase_id="+oidPurchase);
                }
                catch(Exception e){
                    
                }

        }
}
