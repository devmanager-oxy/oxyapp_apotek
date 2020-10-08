package com.project.ccs.postransaction.promotion; 

import com.project.ccs.postransaction.costing.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.lang.I_Language;
import com.project.ccs.postransaction.stock.*;

public class DbPromotionItem extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 
	public static final  String DB_POS_PROMOTION_ITEM = "pos_promotion_item";

	public static final  int COL_PROMOTION_ITEM_ID = 0;
	public static final  int COL_PROMOTION_ID = 1;
	public static final  int COL_ITEM_MASTER_ID = 2;
	public static final  int COL_ITEM_NAME = 3;
        public static final  int COL_CODE = 4;
	public static final  int COL_BARCODE = 5;
	public static final  int COL_DISCOUNT_PERCENT = 6;
        public static final  int COL_DISCOUNT_VALUE = 7;
        public static final  int COL_SELLING_PRICE = 8;
        public static final  int COL_TIPE = 9;
        public static final  int COL_QTY_MIN = 10;
        public static final  int COL_QTY_BONUS = 11;
        public static final  int COL_IS_VARIANT = 12;
	public static final  String[] colNames = {
		"promotion_item_id",
		"promotion_id",
		"item_master_id",
		"item_name",
		"item_code",
                "item_barcode",
                "discount_percent",
                "discount_value",
                "selling_price",
                "tipe",
                "qty_min",
                "qty_bonus",
                "is_variant"
		
	 }; 
	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
		TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT
		
	 }; 

	public DbPromotionItem(){
	}

	public DbPromotionItem(int i) throws CONException { 
		super(new DbPromotionItem()); 
	}

	public DbPromotionItem(String sOid) throws CONException { 
		super(new DbPromotionItem(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPromotionItem(long lOid) throws CONException { 
		super(new DbPromotionItem(0)); 
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
		return DB_POS_PROMOTION_ITEM;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPromotionItem().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PromotionItem promotionItem = fetchExc(ent.getOID()); 
		ent = (Entity)promotionItem; 
		return promotionItem.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PromotionItem) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PromotionItem) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PromotionItem fetchExc(long oid) throws CONException{ 
		try{ 
			PromotionItem promotionItem = new PromotionItem();
			DbPromotionItem pstPromotionItem = new DbPromotionItem(oid); 
			promotionItem.setOID(oid);

			promotionItem.setPromotionId(pstPromotionItem.getlong(COL_PROMOTION_ID));
			promotionItem.setItemMasterId(pstPromotionItem.getlong(COL_ITEM_MASTER_ID));
			promotionItem.setItemName(pstPromotionItem.getString(COL_ITEM_NAME));
			promotionItem.setItemCode(pstPromotionItem.getString(COL_CODE));
                        promotionItem.setItemBarcode(pstPromotionItem.getString(COL_BARCODE));
			promotionItem.setDiscountPercent(pstPromotionItem.getdouble(COL_DISCOUNT_PERCENT));
                        promotionItem.setDiscountValue(pstPromotionItem.getdouble(COL_DISCOUNT_VALUE));
                        promotionItem.setSellingPrice(pstPromotionItem.getdouble(COL_SELLING_PRICE));
                        promotionItem.setTipe(pstPromotionItem.getInt(COL_TIPE));
                        promotionItem.setQtyMin(pstPromotionItem.getdouble(COL_QTY_MIN));
                        promotionItem.setQtyBonus(pstPromotionItem.getdouble(COL_QTY_BONUS));
                        promotionItem.setIsVariant(pstPromotionItem.getInt(COL_IS_VARIANT));
			return promotionItem; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPromotionItem(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PromotionItem promotionItem) throws CONException{ 
		try{ 
			DbPromotionItem pstPromotionItem = new DbPromotionItem(0);

			pstPromotionItem.setLong(COL_PROMOTION_ID, promotionItem.getPromotionId());
			pstPromotionItem.setLong(COL_ITEM_MASTER_ID, promotionItem.getItemMasterId());
			pstPromotionItem.setString(COL_ITEM_NAME, promotionItem.getItemName());
                        pstPromotionItem.setString(COL_CODE, promotionItem.getItemCode());
                        pstPromotionItem.setString(COL_BARCODE, promotionItem.getItemBarcode());
			pstPromotionItem.setDouble(COL_DISCOUNT_PERCENT, promotionItem.getDiscountPercent());
                        pstPromotionItem.setDouble(COL_DISCOUNT_VALUE, promotionItem.getDiscountValue());
                        pstPromotionItem.setDouble(COL_SELLING_PRICE, promotionItem.getSellingPrice());
                        pstPromotionItem.setInt(COL_TIPE, promotionItem.getTipe());
                        pstPromotionItem.setDouble(COL_QTY_MIN, promotionItem.getQtyMin());
                        pstPromotionItem.setDouble(COL_QTY_BONUS, promotionItem.getQtyBonus());
                        pstPromotionItem.setInt(COL_IS_VARIANT, promotionItem.getIsVariant());
			pstPromotionItem.insert(); 
			promotionItem.setOID(pstPromotionItem.getlong(COL_PROMOTION_ITEM_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPromotionItem(0),CONException.UNKNOWN); 
		}
		return promotionItem.getOID();
	}

	public static long updateExc(PromotionItem promotionItem) throws CONException{ 
		try{ 
			if(promotionItem.getOID() != 0){ 
				DbPromotionItem pstPromotionItem = new DbPromotionItem(promotionItem.getOID());

				pstPromotionItem.setLong(COL_PROMOTION_ID, promotionItem.getPromotionId());
                                pstPromotionItem.setLong(COL_ITEM_MASTER_ID, promotionItem.getItemMasterId());
                                pstPromotionItem.setString(COL_ITEM_NAME, promotionItem.getItemName());
                                pstPromotionItem.setString(COL_CODE, promotionItem.getItemCode());
                                pstPromotionItem.setString(COL_BARCODE, promotionItem.getItemBarcode());
                                pstPromotionItem.setDouble(COL_DISCOUNT_PERCENT, promotionItem.getDiscountPercent());
                                pstPromotionItem.setDouble(COL_DISCOUNT_VALUE, promotionItem.getDiscountValue());
                                pstPromotionItem.setDouble(COL_SELLING_PRICE, promotionItem.getSellingPrice());
                                pstPromotionItem.setInt(COL_TIPE, promotionItem.getTipe());
                                pstPromotionItem.setDouble(COL_QTY_MIN, promotionItem.getQtyMin());
                                pstPromotionItem.setDouble(COL_QTY_BONUS, promotionItem.getQtyBonus());
                                pstPromotionItem.setInt(COL_IS_VARIANT, promotionItem.getIsVariant());
				pstPromotionItem.update(); 
				return promotionItem.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPromotionItem(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPromotionItem pstPromotionItem = new DbPromotionItem(oid);
			pstPromotionItem.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPromotionItem(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_POS_PROMOTION_ITEM; 
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
				PromotionItem promotionItem = new PromotionItem();
				resultToObject(rs, promotionItem);
				lists.add(promotionItem);
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

	private static void resultToObject(ResultSet rs, PromotionItem promotionItem){
		try{
			promotionItem.setOID(rs.getLong(DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ITEM_ID]));
			promotionItem.setPromotionId(rs.getLong(DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ID]));
			promotionItem.setItemMasterId(rs.getLong(DbPromotionItem.colNames[DbPromotionItem.COL_ITEM_MASTER_ID]));
			promotionItem.setItemName(rs.getString(DbPromotionItem.colNames[DbPromotionItem.COL_ITEM_NAME]));
			promotionItem.setItemCode(rs.getString(DbPromotionItem.colNames[DbPromotionItem.COL_CODE]));
                        promotionItem.setItemBarcode(rs.getString(DbPromotionItem.colNames[DbPromotionItem.COL_BARCODE]));
                        promotionItem.setDiscountPercent(rs.getDouble(DbPromotionItem.colNames[DbPromotionItem.COL_DISCOUNT_PERCENT]));
                        promotionItem.setDiscountValue(rs.getDouble(DbPromotionItem.colNames[DbPromotionItem.COL_DISCOUNT_VALUE]));
                        promotionItem.setSellingPrice(rs.getDouble(DbPromotionItem.colNames[DbPromotionItem.COL_SELLING_PRICE]));
                        promotionItem.setTipe(rs.getInt(DbPromotionItem.colNames[DbPromotionItem.COL_TIPE]));
                        promotionItem. setQtyMin(rs.getDouble(DbPromotionItem.colNames[DbPromotionItem.COL_QTY_MIN]));
                        promotionItem.setQtyBonus(rs.getDouble(DbPromotionItem.colNames[DbPromotionItem.COL_QTY_BONUS]));
                        promotionItem.setIsVariant(rs.getInt(DbPromotionItem.colNames[DbPromotionItem.COL_IS_VARIANT]));
		}catch(Exception e){ }
	}

	public static boolean checkOID(long promotionItemId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_POS_PROMOTION_ITEM + " WHERE " + 
						DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ITEM_ID] + " = " + promotionItemId;

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
			String sql = "SELECT COUNT("+ DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ITEM_ID] + ") FROM " + DB_POS_PROMOTION_ITEM;
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
          

        public static int deleteAllItem(long oidPromotion){
        
            int result = 0;

            String sql = "delete from "+DB_POS_PROMOTION_ITEM+" where "+colNames[COL_PROMOTION_ID]+" = "+ oidPromotion;
            try{
                CONHandler.execUpdate(sql);
            }
            catch(Exception e){
                result = -1;
            }

            return result;
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
			  	   PromotionItem promotionItem = (PromotionItem)list.get(ls);
				   if(oid == promotionItem.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
}
