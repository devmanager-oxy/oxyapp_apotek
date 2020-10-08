package com.project.ccs.postransaction.stock; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.math.*;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;
import com.project.util.*;
import com.project.ccs.posmaster.*;
import com.project.ccs.postransaction.receiving.*;
import com.project.ccs.postransaction.transfer.*;
import com.project.ccs.postransaction.adjusment.*;
import com.project.ccs.postransaction.opname.*;
import com.project.ccs.postransaction.costing.*;
import com.project.general.*;
import com.project.ccs.*;
import com.project.ccs.postransaction.order.DbOrder;
import com.project.ccs.postransaction.order.Order;
import com.project.ccs.postransaction.purchase.DbPurchaseItem;
import com.project.ccs.postransaction.repack.DbRepackItem;
import com.project.ccs.postransaction.repack.Repack;
import com.project.ccs.postransaction.repack.RepackItem;
import com.project.fms.asset.*;
import com.project.ccs.postransaction.sales.*;
import com.project.system.*;

public class DbStock extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_POS_STOCK = "pos_stock";

	public static final  int COL_STOCK_ID = 0;
	public static final  int COL_LOCATION_ID = 1;
	public static final  int COL_TYPE = 2;
	public static final  int COL_QTY = 3;
	public static final  int COL_PRICE = 4;
	public static final  int COL_TOTAL = 5;
	public static final  int COL_ITEM_MASTER_ID = 6;
	public static final  int COL_ITEM_CODE = 7;
	public static final  int COL_ITEM_BARCODE = 8;
	public static final  int COL_ITEM_NAME = 9;
	public static final  int COL_UNIT_ID = 10;
	public static final  int COL_UNIT = 11;
	public static final  int COL_IN_OUT = 12;
	public static final  int COL_DATE = 13;
	public static final  int COL_USER_ID = 14;
	public static final  int COL_NO_FAKTUR = 15;
	public static final  int COL_INCOMING_ID = 16;
	public static final  int COL_RETUR_ID = 17;
	public static final  int COL_TRANSFER_ID = 18;
	public static final  int COL_TRANSFER_IN_ID = 19;
	public static final  int COL_ADJUSTMENT_ID = 20;
        
        public static final  int COL_OPNAME_ID = 21;
        public static final  int COL_SALES_DETAIL_ID = 22;
        public static final  int COL_TYPE_ITEM = 23;
        public static final  int COL_RECEIVE_ITEM_ID = 24;
        public static final  int COL_RETUR_ITEM_ID = 25;
        public static final  int COL_TRANSFER_ITEM_ID = 26;
        public static final  int COL_ADJUSTMENT_ITEM_ID = 27;
        public static final  int COL_COSTING_ID = 28;
        public static final  int COL_COSTING_ITEM_ID = 29;
        public static final  int COL_REPACK_ID = 30;
        public static final  int COL_REPACK_ITEM_ID = 31;
        public static final int COL_LOT_NUMBER =32;
        public static final int COL_EXPIRED_DATE =33;
        public static final int COL_STATUS =34;
        //public static final int COL_STS_UPDATE =35;
        
	public static final  String[] colNames = {
		"stock_id",
                "location_id",
                "type",
                "qty",
                "price",
                "total",
                "item_master_id",
                "item_code",
                "item_barcode",
                "item_name",
                "unit_id",
                "unit",
                "in_out",
                "date",
                "user_id",
                "no_faktur",
                "incoming_id",
                "retur_id",
                "transfer_id",
                "transfer_in_id",
                "adjustment_id",
                "opname_id",
                "sales_detail_id",
                "type_item",
                "receive_item_id",
                "retur_item_id",
                "transfer_item_id",
                "adjustment_item_id",
                "costing_id",
                "costing_item_id",
                "repack_id",
                "repack_item_id",
                "lot_number",
                "expired_date",
                "status"
          //      "sts_update"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_INT,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_STRING,
                TYPE_DATE,
                TYPE_STRING
            //    TYPE_INT
	 }; 
         
        public static int TYPE_INCOMING_GOODS   = 0;
        public static int TYPE_RETUR_GOODS      = 1;
        public static int TYPE_TRANSFER         = 2;
        public static int TYPE_TRANSFER_IN      = 3;
        public static int TYPE_ADJUSTMENT       = 4;
        public static int TYPE_OPNAME       = 5;
        public static int TYPE_PROJECT_INSTALL  = 6;
        public static int TYPE_SALES  = 7;
        public static int TYPE_COSTING =8;
        public static int TYPE_REPACK=9;
        public static int TYPE_REC_ADJ=10;
        
        public static int TYPE_CONSIGMENT = 1;
        public static int TYPE_NON_CONSIGMENT = 0;
        
        public static String[] strType = {
            "Incoming Goods", "Retur PO", "Transfer Out", "Transfer In", "Adjustment", "Opname","Project Instal", "Sales", "Costing","Repack"
        };
        
        public static int STOCK_IN       = 1;
        public static int STOCK_OUT      = -1;        
        
	public DbStock(){
	}

	public DbStock(int i) throws CONException { 
		super(new DbStock()); 
	}

	public DbStock(String sOid) throws CONException { 
		super(new DbStock(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbStock(long lOid) throws CONException { 
		super(new DbStock(0)); 
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
		return DB_POS_STOCK;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbStock().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Stock stock = fetchExc(ent.getOID()); 
		ent = (Entity)stock; 
		return stock.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Stock) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Stock) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Stock fetchExc(long oid) throws CONException{ 
		try{ 
			Stock stock = new Stock();
			DbStock pstStock = new DbStock(oid); 
			stock.setOID(oid);

			stock.setLocationId(pstStock.getlong(COL_LOCATION_ID));
			stock.setType(pstStock.getInt(COL_TYPE));
			stock.setQty(pstStock.getdouble(COL_QTY));
			stock.setPrice(pstStock.getdouble(COL_PRICE));
			stock.setTotal(pstStock.getdouble(COL_TOTAL));
			stock.setItemMasterId(pstStock.getlong(COL_ITEM_MASTER_ID));
			stock.setItemCode(pstStock.getString(COL_ITEM_CODE));
			stock.setItemBarcode(pstStock.getString(COL_ITEM_BARCODE));
			stock.setItemName(pstStock.getString(COL_ITEM_NAME));
			stock.setUnitId(pstStock.getlong(COL_UNIT_ID));
			stock.setUnit(pstStock.getString(COL_UNIT));
			stock.setInOut(pstStock.getInt(COL_IN_OUT));
			stock.setDate(pstStock.getDate(COL_DATE));
			stock.setUserId(pstStock.getlong(COL_USER_ID));
			stock.setNoFaktur(pstStock.getString(COL_NO_FAKTUR));
			stock.setIncomingId(pstStock.getlong(COL_INCOMING_ID));
			stock.setReturId(pstStock.getlong(COL_RETUR_ID));
			stock.setTransferId(pstStock.getlong(COL_TRANSFER_ID));
			stock.setTransferInId(pstStock.getlong(COL_TRANSFER_IN_ID));
			stock.setAdjustmentId(pstStock.getlong(COL_ADJUSTMENT_ID));
                        stock.setOpnameId(pstStock.getlong(COL_OPNAME_ID));
                        stock.setSalesDetailId(pstStock.getlong(COL_SALES_DETAIL_ID));
                        stock.setType_item(pstStock.getInt(COL_TYPE_ITEM));
                        stock.setReceive_item_id(pstStock.getlong(COL_RECEIVE_ITEM_ID));
                        stock.setRetur_item_id(pstStock.getlong(COL_RETUR_ITEM_ID));
                        stock.setTransfer_item_id(pstStock.getlong(COL_TRANSFER_ITEM_ID));
                        stock.setAdjustment_item_id(pstStock.getlong(COL_ADJUSTMENT_ITEM_ID));
                        stock.setCostingId(pstStock.getlong(COL_COSTING_ID));
                        stock.setCostingItemId(pstStock.getlong(COL_COSTING_ITEM_ID));
                        stock.setRepackId(pstStock.getlong(COL_REPACK_ID));
                        stock.setRepackItemId(pstStock.getlong(COL_REPACK_ITEM_ID));
                        stock.setLot_number(pstStock.getString(COL_LOT_NUMBER));
                        stock.setExpired_date(pstStock.getDate(COL_EXPIRED_DATE));
                        stock.setStatus(pstStock.getString(COL_STATUS));
                        //stock.setStsUpdate(pstStock.getInt(COL_STS_UPDATE));
			return stock; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStock(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Stock stock) throws CONException{ 
		try{ 
			DbStock pstStock = new DbStock(0);

			pstStock.setLong(COL_LOCATION_ID, stock.getLocationId());
			pstStock.setInt(COL_TYPE, stock.getType());
			pstStock.setDouble(COL_QTY, stock.getQty());
			pstStock.setDouble(COL_PRICE, stock.getPrice());
			pstStock.setDouble(COL_TOTAL, stock.getTotal());
			pstStock.setLong(COL_ITEM_MASTER_ID, stock.getItemMasterId());
			pstStock.setString(COL_ITEM_CODE, stock.getItemCode());
			pstStock.setString(COL_ITEM_BARCODE, stock.getItemBarcode());
			pstStock.setString(COL_ITEM_NAME, stock.getItemName());
			pstStock.setLong(COL_UNIT_ID, stock.getUnitId());
			pstStock.setString(COL_UNIT, stock.getUnit());
			pstStock.setInt(COL_IN_OUT, stock.getInOut());
			pstStock.setDate(COL_DATE, stock.getDate());
			pstStock.setLong(COL_USER_ID, stock.getUserId());
			pstStock.setString(COL_NO_FAKTUR, stock.getNoFaktur());
			pstStock.setLong(COL_INCOMING_ID, stock.getIncomingId());
			pstStock.setLong(COL_RETUR_ID, stock.getReturId());
			pstStock.setLong(COL_TRANSFER_ID, stock.getTransferId());
			pstStock.setLong(COL_TRANSFER_IN_ID, stock.getTransferInId());
			pstStock.setLong(COL_ADJUSTMENT_ID, stock.getAdjustmentId());
                        pstStock.setLong(COL_OPNAME_ID, stock.getOpnameId());
                        pstStock.setLong(COL_SALES_DETAIL_ID, stock.getSalesDetailId());
                        pstStock.setInt(COL_TYPE_ITEM, stock.getType_item());
                        pstStock.setLong(COL_RECEIVE_ITEM_ID, stock.getReceive_item_id());
                        pstStock.setLong(COL_RETUR_ITEM_ID, stock.getRetur_item_id());
                        pstStock.setLong(COL_TRANSFER_ITEM_ID, stock.getTransfer_item_id());
                        pstStock.setLong(COL_ADJUSTMENT_ITEM_ID, stock.getAdjustment_item_id());
                        pstStock.setLong(COL_COSTING_ID, stock.getCostingId());
                        pstStock.setLong(COL_COSTING_ITEM_ID, stock.getCostingItemId());
                        pstStock.setLong(COL_REPACK_ID, stock.getRepackId());
                        pstStock.setLong(COL_REPACK_ITEM_ID, stock.getRepackItemId());
                        pstStock.setString(COL_LOT_NUMBER, stock.getLot_number());
                        pstStock.setDate(COL_EXPIRED_DATE, stock.getExpired_date());
                        pstStock.setString(COL_STATUS, stock.getStatus());
                        //pstStock.setInt(COL_STS_UPDATE, stock.getStsUpdate());
			pstStock.insert(); 
			stock.setOID(pstStock.getlong(COL_STOCK_ID));
                        
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStock(0),CONException.UNKNOWN); 
		}
		return stock.getOID();
	}

	public static long updateExc(Stock stock) throws CONException{ 
		try{ 
			if(stock.getOID() != 0){ 
				DbStock pstStock = new DbStock(stock.getOID());

				pstStock.setLong(COL_LOCATION_ID, stock.getLocationId());
				pstStock.setInt(COL_TYPE, stock.getType());
				pstStock.setDouble(COL_QTY, stock.getQty());
				pstStock.setDouble(COL_PRICE, stock.getPrice());
				pstStock.setDouble(COL_TOTAL, stock.getTotal());
				pstStock.setLong(COL_ITEM_MASTER_ID, stock.getItemMasterId());
				pstStock.setString(COL_ITEM_CODE, stock.getItemCode());
				pstStock.setString(COL_ITEM_BARCODE, stock.getItemBarcode());
				pstStock.setString(COL_ITEM_NAME, stock.getItemName());
				pstStock.setLong(COL_UNIT_ID, stock.getUnitId());
				pstStock.setString(COL_UNIT, stock.getUnit());
				pstStock.setInt(COL_IN_OUT, stock.getInOut());
				pstStock.setDate(COL_DATE, stock.getDate());
				pstStock.setLong(COL_USER_ID, stock.getUserId());
				pstStock.setString(COL_NO_FAKTUR, stock.getNoFaktur());
				pstStock.setLong(COL_INCOMING_ID, stock.getIncomingId());
				pstStock.setLong(COL_RETUR_ID, stock.getReturId());
				pstStock.setLong(COL_TRANSFER_ID, stock.getTransferId());
				pstStock.setLong(COL_TRANSFER_IN_ID, stock.getTransferInId());
				pstStock.setLong(COL_ADJUSTMENT_ID, stock.getAdjustmentId());
                                pstStock.setLong(COL_OPNAME_ID, stock.getOpnameId());
                                pstStock.setLong(COL_SALES_DETAIL_ID, stock.getSalesDetailId());
                                pstStock.setInt(COL_TYPE_ITEM, stock.getType_item());
                                pstStock.setLong(COL_RECEIVE_ITEM_ID, stock.getReceive_item_id());
                                pstStock.setLong(COL_RETUR_ITEM_ID, stock.getRetur_item_id());
                                pstStock.setLong(COL_TRANSFER_ITEM_ID, stock.getTransfer_item_id());
                                pstStock.setLong(COL_ADJUSTMENT_ITEM_ID, stock.getAdjustment_item_id());
                                pstStock.setLong(COL_COSTING_ID, stock.getCostingId());
                                pstStock.setLong(COL_COSTING_ITEM_ID, stock.getCostingItemId());
                                pstStock.setLong(COL_REPACK_ID, stock.getRepackId());
                                pstStock.setLong(COL_REPACK_ITEM_ID, stock.getRepackItemId());
                                pstStock.setString(COL_LOT_NUMBER, stock.getLot_number());
                                pstStock.setDate(COL_EXPIRED_DATE, stock.getExpired_date());
                                pstStock.setString(COL_STATUS, stock.getStatus());
                               // pstStock.setInt(COL_STS_UPDATE, stock.getStsUpdate());
				pstStock.update(); 
				return stock.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStock(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbStock pstStock = new DbStock(oid);
			pstStock.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStock(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_POS_STOCK; 
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
				Stock stock = new Stock();
				resultToObject(rs, stock);
				lists.add(stock);
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

	public static void resultToObject(ResultSet rs, Stock stock){
		try{
			stock.setOID(rs.getLong(DbStock.colNames[DbStock.COL_STOCK_ID]));
			stock.setLocationId(rs.getLong(DbStock.colNames[DbStock.COL_LOCATION_ID]));
			stock.setType(rs.getInt(DbStock.colNames[DbStock.COL_TYPE]));
			stock.setQty(rs.getDouble(DbStock.colNames[DbStock.COL_QTY]));
			stock.setPrice(rs.getDouble(DbStock.colNames[DbStock.COL_PRICE]));
			stock.setTotal(rs.getDouble(DbStock.colNames[DbStock.COL_TOTAL]));
			stock.setItemMasterId(rs.getLong(DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]));
			stock.setItemCode(rs.getString(DbStock.colNames[DbStock.COL_ITEM_CODE]));
			stock.setItemBarcode(rs.getString(DbStock.colNames[DbStock.COL_ITEM_BARCODE]));
			stock.setItemName(rs.getString(DbStock.colNames[DbStock.COL_ITEM_NAME]));
			stock.setUnitId(rs.getLong(DbStock.colNames[DbStock.COL_UNIT_ID]));
			stock.setUnit(rs.getString(DbStock.colNames[DbStock.COL_UNIT]));
			stock.setInOut(rs.getInt(DbStock.colNames[DbStock.COL_IN_OUT]));
			stock.setDate(rs.getDate(DbStock.colNames[DbStock.COL_DATE]));
			stock.setUserId(rs.getLong(DbStock.colNames[DbStock.COL_USER_ID]));
			stock.setNoFaktur(rs.getString(DbStock.colNames[DbStock.COL_NO_FAKTUR]));
			stock.setIncomingId(rs.getLong(DbStock.colNames[DbStock.COL_INCOMING_ID]));
			stock.setReturId(rs.getLong(DbStock.colNames[DbStock.COL_RETUR_ID]));
			stock.setTransferId(rs.getLong(DbStock.colNames[DbStock.COL_TRANSFER_ID]));
			stock.setTransferInId(rs.getLong(DbStock.colNames[DbStock.COL_TRANSFER_IN_ID]));
			stock.setAdjustmentId(rs.getLong(DbStock.colNames[DbStock.COL_ADJUSTMENT_ID]));
                        stock.setOpnameId(rs.getLong(DbStock.colNames[DbStock.COL_OPNAME_ID]));
                        stock.setSalesDetailId(rs.getLong(DbStock.colNames[DbStock.COL_SALES_DETAIL_ID]));
                        stock.setType_item(rs.getInt(DbStock.colNames[DbStock.COL_TYPE_ITEM]));
                        stock.setReceive_item_id(rs.getLong(DbStock.colNames[DbStock.COL_RECEIVE_ITEM_ID]));
                        stock.setRetur_item_id(rs.getLong(DbStock.colNames[DbStock.COL_RETUR_ITEM_ID]));
                        stock.setTransfer_item_id(rs.getLong(DbStock.colNames[DbStock.COL_TRANSFER_ITEM_ID]));
                        stock.setAdjustment_item_id(rs.getLong(DbStock.colNames[DbStock.COL_ADJUSTMENT_ITEM_ID]));
                        stock.setCostingId(rs.getLong(DbStock.colNames[DbStock.COL_COSTING_ID]));
                        stock.setCostingItemId(rs.getLong(DbStock.colNames[DbStock.COL_COSTING_ITEM_ID]));
                        stock.setRepackId(rs.getLong(DbStock.colNames[DbStock.COL_REPACK_ID]));
                        stock.setRepackItemId(rs.getLong(DbStock.colNames[DbStock.COL_REPACK_ITEM_ID]));
                        stock.setLot_number(rs.getString(DbStock.colNames[DbStock.COL_LOT_NUMBER]));
                        stock.setExpired_date(rs.getDate(DbStock.colNames[DbStock.COL_EXPIRED_DATE]));
                        stock.setStatus(rs.getString(DbStock.colNames[DbStock.COL_STATUS]));
                       // stock.setStsUpdate(rs.getInt(DbStock.colNames[DbStock.COL_STS_UPDATE]));
		}catch(Exception e){ }
	}

	public static boolean checkOID(long stockId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_POS_STOCK + " WHERE " + 
						DbStock.colNames[DbStock.COL_STOCK_ID] + " = " + stockId;

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
			String sql = "SELECT COUNT("+ DbStock.colNames[DbStock.COL_STOCK_ID] + ") FROM " + DB_POS_STOCK;
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
			  	   Stock stock = (Stock)list.get(ls);
				   if(oid == stock.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static void insertReceiveGoods(Receive rec, ReceiveItem ri){
            
            try{
                
                System.out.println("inserting new stock ...");
                
                ItemMaster im = new ItemMaster();
                im = DbItemMaster.fetchExc(ri.getItemMasterId());
                if(rec.getTypeAp() != DbReceive.TYPE_AP_REC_ADJ_BY_PRICE){
                    if(im.getNeedRecipe()==0){
                        Uom uom = DbUom.fetchExc(im.getUomStockId());

                        Stock stock = new Stock();
                        stock.setIncomingId(ri.getReceiveId());

                        stock.setInOut(STOCK_IN);
                        stock.setItemBarcode(im.getBarcode());
                        stock.setItemCode(im.getCode());
                        stock.setItemMasterId(im.getOID());
                        stock.setItemName(im.getName());
                        stock.setLocationId(rec.getLocationId());
                        stock.setDate(rec.getDate());
                        stock.setNoFaktur(rec.getDoNumber());
                        stock.setPrice(ri.getTotalAmount()/ri.getQty());

                        stock.setTotal(ri.getTotalAmount());

                        stock.setQty((ri.getQty() * im.getUomPurchaseStockQty()));
                        if(rec.getTypeAp()==DbReceive.TYPE_AP_REC_ADJ_BY_QTY){
                            stock.setType(TYPE_REC_ADJ);
                        }else{
                            stock.setType(TYPE_INCOMING_GOODS);
                        }
                        stock.setUnitId(im.getUomStockId());
                        stock.setUnit(uom.getUnit());
                        stock.setUserId(rec.getUserId());
                        stock.setType_item(rec.getType());
                        stock.setReceive_item_id(ri.getOID());
                        stock.setStatus(rec.getStatus());

                        if(ri.getOID()!= 0){
                            delete(colNames[COL_RECEIVE_ITEM_ID]+"="+ri.getOID());
                        }
                        
                        DbStock.insertExc(stock);

                        System.out.println("inserting new stock ... done ");
                        
                        DbStock.checkRequestTransfer(ri.getItemMasterId() ,rec.getLocationId());
                    }
                }
            }
            catch(Exception e){
                
            }
            
        }
        
        public static void updateStockReceive(Receive rec){
            
            try{
                Vector vStok = new Vector();
                vStok= DbStock.list(0, 0, DbStock.colNames[DbStock.COL_INCOMING_ID]+ "="+rec.getOID(),"");
                for(int i=0;i<vStok.size();i++){
                    Stock st = (Stock)vStok.get(i);
                    st.setStatus(rec.getStatus());
                    DbStock.updateExc(st);
                    DbStock.checkRequestTransfer(st.getItemMasterId() ,st.getLocationId());
                }
                
            }
            catch(Exception e){
                
            }
            
        }
        
         public static void updateStockTransfer(Transfer rec){
            
            try{
                Vector vStok = new Vector();
                vStok= DbStock.list(0, 0, DbStock.colNames[DbStock.COL_TRANSFER_ID]+ "="+rec.getOID(),"");
                for(int i=0;i<vStok.size();i++){
                    Stock st = (Stock)vStok.get(i);
                    
                    st= fetchExc(st.getOID());
                    st.setStatus(rec.getStatus());
                    if(st.getType()==2){
                        st.setLocationId(rec.getFromLocationId());
                    }
                    DbStock.updateExc(st);
                    DbStock.checkRequestTransfer(st.getItemMasterId() ,st.getLocationId());
                }
                
            }
            catch(Exception e){
                
            }
            
        }
         public static void updateStockRepack(Repack rec){
            
            try{
                Vector vStok = new Vector();
                vStok= DbStock.list(0, 0, DbStock.colNames[DbStock.COL_REPACK_ID]+ "="+rec.getOID(),"");
                for(int i=0;i<vStok.size();i++){
                    Stock st = (Stock)vStok.get(i);
                    st.setStatus(rec.getStatus());
                    DbStock.updateExc(st);
                    
                    DbStock.checkRequestTransfer(st.getItemMasterId() ,st.getLocationId());
                }
                
            }
            catch(Exception e){
                
            }
            
        }
         public static void updateStockRetur(Retur rec){
            
            try{
                Vector vStok = new Vector();
                vStok= DbStock.list(0, 0, DbStock.colNames[DbStock.COL_RETUR_ID]+ "="+rec.getOID(),"");
                for(int i=0;i<vStok.size();i++){
                    Stock st = (Stock)vStok.get(i);
                    st.setStatus(rec.getStatus());
                    DbStock.updateExc(st);
                    DbStock.checkRequestTransfer(st.getItemMasterId() ,st.getLocationId());
                }
                
            }
            catch(Exception e){
                
            }
            
        }
         public static void updateStockCosting(Costing rec){
            
            try{
                Vector vStok = new Vector();
                vStok= DbStock.list(0, 0, DbStock.colNames[DbStock.COL_COSTING_ID]+ "="+rec.getOID(),"");
                for(int i=0;i<vStok.size();i++){
                    Stock st = (Stock)vStok.get(i);
                    st.setStatus(rec.getStatus());
                    DbStock.updateExc(st);
                    DbStock.checkRequestTransfer(st.getItemMasterId() ,st.getLocationId());
                }
                
            }
            catch(Exception e){
                
            }
            
        } 
        
        public static void insertCostingGoods(Costing cos, CostingItem ci){
            
            ItemMaster im = new ItemMaster();
            Uom uom = new Uom();
            
            //---- keluarkan stock karena pemakaian internal--------
            
            try{
                
                System.out.println("inserting new stock ...");
                
                im = DbItemMaster.fetchExc(ci.getItemMasterId());
                uom = DbUom.fetchExc(im.getUomStockId());
                
                Stock stock = new Stock();
                stock.setCostingId(cos.getOID());
                stock.setCostingItemId(ci.getOID());
                stock.setInOut(STOCK_OUT);
                stock.setItemBarcode(im.getBarcode());
                stock.setItemCode(im.getCode());
                stock.setItemMasterId(im.getOID());
                stock.setItemName(im.getName());
                stock.setLocationId(cos.getLocationId());
                stock.setDate(cos.getDate());
                //stock.setNoFaktur(rec.getNumber());
                
                //harga ambil harga average terakhir
                stock.setPrice(im.getCogs());
                stock.setTotal(im.getCogs()*ci.getQty());
                
                stock.setQty(ci.getQty());
                stock.setType(TYPE_COSTING);
                stock.setUnitId(im.getUomStockId());
                stock.setUnit(uom.getUnit());
                stock.setUserId(cos.getUserId());
                stock.setStatus(cos.getStatus());
                
                if(ci.getOID()!= 0){
                    delete(colNames[COL_COSTING_ITEM_ID]+"="+ci.getOID());
                }
                
                DbStock.insertExc(stock);
                
                System.out.println("inserting new stock ... done ");
                
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            
        }
        
        public static void insertRepackGoods(Repack re, RepackItem ri){
            
            ItemMaster im = new ItemMaster();
            Uom uom = new Uom();
            
            //---- keluarkan stock karena pemakaian internal--------
            
            try{
                
                System.out.println("inserting new stock ...");
                
                im = DbItemMaster.fetchExc(ri.getItemMasterId());
                uom = DbUom.fetchExc(im.getUomStockId());
                
                Stock stock = new Stock();
                stock.setRepackId(re.getOID());
                stock.setRepackItemId(ri.getOID());
                if(ri.getType()==DbRepackItem.TYPE_INPUT){
                    stock.setInOut(STOCK_OUT);
                }else if(ri.getType()==DbRepackItem.TYPE_OUTPUT){
                    stock.setInOut(STOCK_IN);
                }
                
                stock.setItemBarcode(im.getBarcode());
                stock.setItemCode(im.getCode());
                stock.setItemMasterId(im.getOID());
                stock.setItemName(im.getName());
                stock.setLocationId(re.getLocationId());
                stock.setDate(re.getDate());
                //stock.setNoFaktur(rec.getNumber());
                
                //harga ambil harga average terakhir
                stock.setPrice(im.getCogs());
                stock.setTotal(im.getCogs()*ri.getQty());
                
                stock.setQty(ri.getQty());
                stock.setType(TYPE_REPACK);
                stock.setUnitId(im.getUomStockId());
                stock.setUnit(uom.getUnit());
                stock.setUserId(re.getUserId());
                //stock.setType_item(rec.getType());
                //stock.setTransfer_item_id(ri.getOID());
                stock.setRepackId(re.getOID());
                stock.setRepackItemId(ri.getOID());
                stock.setStatus(re.getStatus());
                
                DbStock.insertExc(stock);
                
                System.out.println("inserting new stock ... done ");
                
                if(re.getStatus().equals("APPROVED")){
                    DbStock.checkRequestTransfer(ri.getItemMasterId() ,re.getLocationId());
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            
        }
        
        
        
        
        public static void insertTransferGoods(Transfer rec, TransferItem ri){
            
            ItemMaster im = new ItemMaster();
            Uom uom = new Uom();
            
            //---- keluarkan stock --------
            
            try{
                
                //System.out.println("inserting new stock ...");
                
                im = DbItemMaster.fetchExc(ri.getItemMasterId());
                uom = DbUom.fetchExc(im.getUomStockId());
                
                Stock stock = new Stock();
                stock.setTransferId(ri.getTransferId());
                stock.setInOut(STOCK_OUT);
                stock.setItemBarcode(im.getBarcode());
                stock.setItemCode(im.getCode());
                stock.setItemMasterId(im.getOID());
                stock.setItemName(im.getName());
                stock.setLocationId(rec.getFromLocationId());
                stock.setDate(rec.getDate());
                stock.setNoFaktur(rec.getNumber());
                
                //harga ambil harga average terakhir
                stock.setPrice(im.getCogs());
                stock.setTotal(im.getCogs()*ri.getQty());
                
                stock.setQty(ri.getQty());
                stock.setType(TYPE_TRANSFER);
                stock.setUnitId(im.getUomStockId());
                stock.setUnit(uom.getUnit());
                stock.setUserId(rec.getUserId());
                stock.setType_item(rec.getType());
                stock.setTransfer_item_id(ri.getOID());
                stock.setStatus(rec.getStatus());
                DbStock.insertExc(stock);
                
                //System.out.println("inserting new stock ... done ");
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            
            //---------- masukkan stock ----------------
            if(rec.getStatus().equalsIgnoreCase("APPROVED")){
                try{

                    //System.out.println("inserting new stock ...");

                    Stock stock = new Stock();
                    stock.setTransferId(ri.getTransferId());
                    stock.setInOut(STOCK_IN);
                    stock.setItemBarcode(im.getBarcode());
                    stock.setItemCode(im.getCode());
                    stock.setItemMasterId(im.getOID());
                    stock.setItemName(im.getName());
                    stock.setLocationId(rec.getToLocationId());
                    stock.setDate(rec.getDate());
                    stock.setNoFaktur(rec.getNumber());

                    //harga ambil harga average terakhir
                    stock.setPrice(im.getCogs());
                    stock.setTotal(im.getCogs()*ri.getQty());

                    stock.setQty(ri.getQty());
                    stock.setType(TYPE_TRANSFER_IN);
                    stock.setUnitId(im.getUomStockId());
                    stock.setUnit(uom.getUnit());
                    stock.setUserId(rec.getUserId());
                    stock.setType_item(rec.getType());
                    stock.setTransfer_item_id(ri.getOID());
                    stock.setStatus(rec.getStatus());
                    DbStock.insertExc(stock);

                    //System.out.println("inserting new stock ... done ");
                }
                catch(Exception e){

                    System.out.println(e.toString());
                }
            }
            //DbStock.checkRequestTransfer(ri.getItemMasterId(),rec.getToLocationId());
            //DbStock.checkRequestTransfer(ri.getItemMasterId(),rec.getFromLocationId());
            
        }
        
        
        public static void insertReturGoods(Retur ret, ReturItem ri){
            
            try{
                
                System.out.println("inserting new retur stock ...");
                
                ItemMaster im = new ItemMaster();
                im = DbItemMaster.fetchExc(ri.getItemMasterId());
                
                //jika stockable
                if(im.getNeedRecipe()==0){
                    Uom uom = DbUom.fetchExc(ri.getUomId());

                    Stock stock = new Stock();
                    stock.setReturId(ret.getOID());
                    stock.setInOut(STOCK_OUT);
                    stock.setItemBarcode(im.getBarcode());
                    stock.setItemCode(im.getCode());
                    stock.setItemMasterId(im.getOID());
                    stock.setItemName(im.getName());
                    stock.setLocationId(ret.getLocationId());
                    stock.setDate(ret.getDate());
                    stock.setNoFaktur(ret.getDoNumber());
                    stock.setPrice(ri.getTotalAmount()/ri.getQty());
                    stock.setTotal(ri.getTotalAmount());
                    stock.setQty(ri.getQty() * im.getUomPurchaseStockQty());
                    stock.setType(TYPE_RETUR_GOODS);
                    stock.setUnitId(ri.getUomId());
                    stock.setUnit(uom.getUnit());
                    stock.setUserId(ret.getUserId());
                    //stock.setType_item(ret.getType());
                    stock.setRetur_item_id(ri.getOID());
                    stock.setStatus(ret.getStatus());
                    DbStock.insertExc(stock);
                    if(!ret.getStatus().equals("DRAFT")){
                        System.out.println("retur check request ");
                        DbStock.checkRequestTransfer(stock.getItemMasterId() ,stock.getLocationId());
                    }
                    System.out.println("inserting new stock ... done ");
                }
            }
            catch(Exception e){
                
            }
            
        }
        
        public static void insertProjectInstall(long itemId, long installLocId, long userId, Date installDate, double qty){
            
            try{
                
                System.out.println("inserting new insertProjectInstall stock ...");
                
                ItemMaster im = new ItemMaster();
                im = DbItemMaster.fetchExc(itemId);
                
                //jika bukan jasa
                if(im.getNeedRecipe()==0){
                    Uom uom = DbUom.fetchExc(im.getUomStockId());

                    Stock stock = new Stock();
                    //stock.setReturId(ret.getOID());
                    stock.setInOut(STOCK_OUT);
                    stock.setItemBarcode(im.getBarcode());
                    stock.setItemCode(im.getCode());
                    stock.setItemMasterId(im.getOID());
                    stock.setItemName(im.getName());
                    stock.setLocationId(installLocId);
                    stock.setDate(installDate);
                    stock.setNoFaktur("[auto] prj install");
                    stock.setPrice(im.getCogs());
                    stock.setTotal(im.getCogs()*qty);
                    stock.setQty(qty);
                    stock.setType(TYPE_PROJECT_INSTALL);
                    stock.setUnitId(im.getUomStockId());
                    stock.setUnit(uom.getUnit());
                    stock.setUserId(userId);

                    DbStock.insertExc(stock);

                    System.out.println("inserting new stock for install product out... done ");
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            
        }
        
        public static void insertProjectInstallRevised(long itemId, long installLocId, long userId, Date installDate, double qty){
            
            try{
                
                System.out.println("inserting new insertProjectInstallRevised stock ...");
                
                ItemMaster im = new ItemMaster();
                im = DbItemMaster.fetchExc(itemId);
                //jika bukan jasa
                if(im.getNeedRecipe()==0){
                    Uom uom = DbUom.fetchExc(im.getUomStockId());

                    Stock stock = new Stock();
                    //stock.setReturId(ret.getOID());
                    stock.setInOut(STOCK_IN);
                    stock.setItemBarcode(im.getBarcode());
                    stock.setItemCode(im.getCode());
                    stock.setItemMasterId(im.getOID());
                    stock.setItemName(im.getName());
                    stock.setLocationId(installLocId);
                    stock.setDate(installDate);
                    stock.setNoFaktur("[auto] prj install - rev");
                    stock.setPrice(im.getCogs());
                    stock.setTotal(im.getCogs()*qty);
                    stock.setQty(qty);
                    stock.setType(TYPE_PROJECT_INSTALL);
                    stock.setUnitId(im.getUomStockId());
                    stock.setUnit(uom.getUnit());
                    stock.setUserId(userId);

                    DbStock.insertExc(stock);

                    System.out.println("inserting new stock for install product out... done ");
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            
        }
        
        
        public static void insertAdjustmentGoods(Adjusment ret, AdjusmentItem ri){
            
            try{
                
                //System.out.println("inserting new retur stock ...");
                
                ItemMaster im = new ItemMaster();
                im = DbItemMaster.fetchExc(ri.getItemMasterId());
                Uom uom = DbUom.fetchExc(im.getUomStockId());
                
                Stock stock = new Stock();
                stock.setAdjustmentId(ret.getOID());
                double adj = ri.getQtyBalance();
                if(adj<0){
                    stock.setInOut(STOCK_OUT);
                    adj = adj * -1;
                }
                else{
                    stock.setInOut(STOCK_IN);
                }
                stock.setItemBarcode(im.getBarcode());
                stock.setItemCode(im.getCode());
                stock.setItemMasterId(im.getOID());
                stock.setItemName(im.getName());
                stock.setLocationId(ret.getLocationId());
                stock.setDate(ret.getDate());
                stock.setNoFaktur(ret.getNumber());
                stock.setPrice(im.getCogs());
                stock.setTotal(im.getCogs() * adj);
                stock.setQty(adj);
                stock.setType(TYPE_ADJUSTMENT);
                stock.setUnitId(im.getUomStockId());
                stock.setUnit(uom.getUnit());
                stock.setUserId(ret.getUserId());
                stock.setType_item(ret.getType());
                stock.setAdjustment_item_id(ri.getOID());
                stock.setStatus(ret.getStatus());
                
                DbStock.insertExc(stock);
                
                
            }
            catch(Exception e){
                
            }
            
        }
        
        public static void insertOpnameGoods(Opname ret, OpnameItem ri){
            
            try{
                
                System.out.println("inserting new opname stock ...");
                
                //jika ada selisih lakukan proses stock
                double adj = ri.getQtyReal() - ri.getQtySystem();
                
                if(adj!=0){
                    
                    ItemMaster im = new ItemMaster();
                    im = DbItemMaster.fetchExc(ri.getItemMasterId());
                    Uom uom = DbUom.fetchExc(im.getUomStockId());

                    Stock stock = new Stock();
                    stock.setOpnameId(ret.getOID());

                    if(adj<0){
                        stock.setInOut(STOCK_OUT);
                        adj = adj * -1;
                    }
                    else{
                        stock.setInOut(STOCK_IN);
                    }
                    stock.setItemBarcode(im.getBarcode());
                    stock.setItemCode(im.getCode());
                    stock.setItemMasterId(im.getOID());
                    stock.setItemName(im.getName());
                    stock.setLocationId(ret.getLocationId());
                    stock.setDate(ret.getDate());
                    stock.setNoFaktur(ret.getNumber());
                    stock.setPrice(im.getCogs());
                    stock.setTotal(im.getCogs() * adj);
                    stock.setQty(adj);
                    stock.setType(TYPE_OPNAME);
                    stock.setUnitId(im.getUomStockId());
                    stock.setUnit(uom.getUnit());
                    stock.setUserId(ret.getUserId());
                    stock.setType_item(ret.getType());
                    DbStock.insertExc(stock);
                }
                
                System.out.println("inserting new stock ... done ");
            }
            catch(Exception e){
                
            }
            
        }
        
        public static void insertOpnameGoods(Opname ret, OpnameItem ri, double variant){
            
            try{
                
                //System.out.println("inserting new opname stock ...");
                
                //jika ada selisih lakukan proses stock
                //double adj = ri.getQtyReal() - ri.getQtySystem();
                
                if(variant!=0){
                    
                    ItemMaster im = new ItemMaster();
                    im = DbItemMaster.fetchExc(ri.getItemMasterId());
                    Uom uom = DbUom.fetchExc(im.getUomStockId());

                    Stock stock = new Stock();
                    stock.setOpnameId(ret.getOID());

                    if(variant<0){
                        stock.setInOut(STOCK_OUT);
                        variant = variant * -1;
                    }
                    else{
                        stock.setInOut(STOCK_IN);
                    }
                    stock.setItemBarcode(im.getBarcode());
                    stock.setItemCode(im.getCode());
                    stock.setItemMasterId(im.getOID());
                    stock.setItemName(im.getName());
                    stock.setLocationId(ret.getLocationId());
                    stock.setDate(ret.getDate());
                    stock.setNoFaktur(ret.getNumber());
                    stock.setPrice(im.getCogs());
                    stock.setTotal(im.getCogs() * variant);
                    stock.setQty(variant);
                    stock.setType(TYPE_OPNAME);
                    stock.setUnitId(im.getUomStockId());
                    stock.setUnit(uom.getUnit());
                    stock.setUserId(ret.getUserId());
                    stock.setType_item(ret.getType());
                    stock.setStatus("APPROVED");
                    DbStock.insertExc(stock);
                }
                
                //System.out.println("inserting new stock ... done ");
            }
            catch(Exception e){
                
            }
            
        }
        
        //commandType = 0, insert new
        
        public static void procedStockSales(){
            Vector vSales = new Vector();
            try{
                vSales = DbSales.list(0, 0, " status_stock!=1", "");
                if(vSales != null && vSales.size()>0){
                    for(int i=0; i < vSales.size(); i++){
                        Sales sal = (Sales) vSales.get(i);
                        Vector vSalesItem = DbSalesDetail.list(0, 0, " sales_id=" + sal.getOID(), "");
                        if(vSalesItem!=null && vSalesItem.size()>0){
                            for(int j=0; j<vSalesItem.size(); j++){
                                SalesDetail salDet = (SalesDetail) vSalesItem.get(j);
                                delete(" sales_detail_id=" + salDet.getOID());
                                DbStock.insertSalesItem(sal, salDet);
                            }
                            
                        }
                        sal.setStatus_stock(1);
                        DbSales.updateExc(sal);
                    }
                }
            }catch(Exception e){
                
            }
        }
        
        public static void insertSalesItem(Sales ret, SalesDetail ri){
            
            try{
                
                    System.out.println("\n\n\n=============== inserting new sales item ========================\n");
                    System.out.println("\n\n\n=================================================================\n");
                
                    ItemMaster im = new ItemMaster();
                    im = DbItemMaster.fetchExc(ri.getProductMasterId());
                    
                    //jika stockable ---------0=barang, 1=jasa-------
                    if(im.getNeedBom()==0){
                        
                        Uom uom = DbUom.fetchExc(im.getUomStockId());

                        Stock stock = new Stock();
                        stock.setOpnameId(ret.getOID());

                        stock.setInOut(STOCK_OUT);

                        //long locId = Long.parseLong(DbSystemProperty.getValueByName("SALES_LOCATION_ID"));
                        
                        stock.setSalesDetailId(ri.getOID());
                        stock.setItemBarcode(im.getBarcode());
                        stock.setItemCode(im.getCode());
                        stock.setItemMasterId(im.getOID());
                        stock.setItemName(im.getName());
                        stock.setLocationId(ret.getLocation_id());
                        stock.setDate(ret.getDate());
                        stock.setNoFaktur(ret.getNumber());
                        stock.setPrice(im.getCogs());
                        stock.setTotal(im.getCogs() * ri.getQty());
                        stock.setQty(ri.getQty());
                        stock.setType(TYPE_SALES);
                        stock.setUnitId(im.getUomStockId());
                        stock.setUnit(uom.getUnit());
                        stock.setUserId(ret.getUserId());

                        DbStock.insertExc(stock);

                        System.out.println("inserting new stock ... done ");
                    }
                    //jika merupakan barang resep 
                    //--- by Eka D ---
                    else{
                        
                        Vector v = DbRecipe.list(0,0, DbRecipe.colNames[DbRecipe.COL_ITEM_MASTER_ID]+"="+im.getOID(), "");
                        
                        //loop pengurangan stock ketika punya resep
                        if(v!=null && v.size()>0){
                            
                            for(int i=0; i<v.size(); i++){
                                Recipe recp = (Recipe)v.get(i);
                                
                                im = new ItemMaster();
                                im = DbItemMaster.fetchExc(recp.getItemMasterId());
                                
                                Uom uom = DbUom.fetchExc(im.getUomStockId());

                                Stock stock = new Stock();
                                stock.setOpnameId(0);//ret.getOID());

                                stock.setInOut(STOCK_OUT);

                                //long locId = Long.parseLong(DbSystemProperty.getValueByName("SALES_LOCATION_ID"));

                                stock.setSalesDetailId(ri.getOID());
                                stock.setItemBarcode(im.getBarcode());
                                stock.setItemCode(im.getCode());
                                stock.setItemMasterId(im.getOID());
                                stock.setItemName(im.getName());
                                stock.setLocationId(ret.getLocation_id());
                                stock.setDate(ret.getDate());
                                stock.setNoFaktur(ret.getNumber());
                                stock.setPrice(im.getCogs());
                                stock.setTotal(im.getCogs() * recp.getQty());
                                stock.setQty(recp.getQty());
                                stock.setType(TYPE_SALES);
                                stock.setUnitId(im.getUomStockId());
                                stock.setUnit(uom.getUnit());
                                stock.setUserId(ret.getUserId());

                                DbStock.insertExc(stock);

                                System.out.println("inserting new stock recipe... done ");
                            }
                        }
                        //jika barang resep tetapi tidak memiliki BOM
                        //contoh jual minuman - teh botol, lakukan sama seperti bukan barang BOM
                        else{
                            Uom uom = DbUom.fetchExc(im.getUomStockId());

                            Stock stock = new Stock();
                            stock.setOpnameId(ret.getOID());

                            stock.setInOut(STOCK_OUT);

                            //long locId = Long.parseLong(DbSystemProperty.getValueByName("SALES_LOCATION_ID"));

                            stock.setSalesDetailId(ri.getOID());
                            stock.setItemBarcode(im.getBarcode());
                            stock.setItemCode(im.getCode());
                            stock.setItemMasterId(im.getOID());
                            stock.setItemName(im.getName());
                            stock.setLocationId(ret.getLocation_id());
                            stock.setDate(ret.getDate());
                            stock.setNoFaktur(ret.getNumber());
                            stock.setPrice(im.getCogs());
                            stock.setTotal(im.getCogs() * ri.getQty());
                            stock.setQty(ri.getQty());
                            stock.setType(TYPE_SALES);
                            stock.setUnitId(im.getUomStockId());
                            stock.setUnit(uom.getUnit());
                            stock.setUserId(ret.getUserId());

                            DbStock.insertExc(stock);

                            System.out.println("inserting new stock ... done ");
                        }
                    }
                    
            }
            catch(Exception e){
                
            }
            
        }
        
        public static Vector getStock(long locationId, int type){
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                String sql = "select s."+colNames[COL_ITEM_MASTER_ID]+", s."+colNames[COL_ITEM_CODE]+", s."+
                    colNames[COL_ITEM_NAME]+", s."+colNames[COL_LOCATION_ID]+", "+
                    " sum(s."+colNames[COL_QTY]+" * s."+colNames[COL_IN_OUT]+") as qty, s."+colNames[COL_UNIT]+ 
                    " from "+DB_POS_STOCK+" s "+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " =s."+colNames[COL_ITEM_MASTER_ID]+
                    " where s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                    " group by s."+colNames[COL_ITEM_MASTER_ID]+
                    " order by " +
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                    
                
                
                System.out.println("\n\n----- getting stock ----- \n"+sql+"\n------------------------\n\n");
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setItemCode(rs.getString(2));
                    s.setItemName(rs.getString(3));
                    s.setLocationId(rs.getLong(4));
                    s.setQty(rs.getDouble(5));
                    s.setUnit(rs.getString(6));
                    //DbStock.resultToObject(rs, s);
                    result.add(s);
                }
                
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;            
        }
        
        
        
                
        public static Vector getStockByGroup(long locationId, int type, long itemGroupId){
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                String sql = "select s."+colNames[COL_ITEM_MASTER_ID]+", s."+colNames[COL_ITEM_CODE]+", s."+
                    colNames[COL_ITEM_NAME]+", s."+colNames[COL_LOCATION_ID]+", "+
                    " sum(s."+colNames[COL_QTY]+" * s."+colNames[COL_IN_OUT]+") as qty, s."+colNames[COL_UNIT]+ 
                    " from "+DB_POS_STOCK+" s "+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " =s."+colNames[COL_ITEM_MASTER_ID]+
                    " where s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and s." + colNames[COL_TYPE_ITEM] + "=" + type+ " and m.item_group_id=" + itemGroupId +
                    " group by s."+colNames[COL_ITEM_MASTER_ID]+
                    " order by " +
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                    
                
                
                System.out.println("\n\n----- getting stock ----- \n"+sql+"\n------------------------\n\n");
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setItemCode(rs.getString(2));
                    s.setItemName(rs.getString(3));
                    s.setLocationId(rs.getLong(4));
                    s.setQty(rs.getDouble(5));
                    s.setUnit(rs.getString(6));
                    //DbStock.resultToObject(rs, s);
                    result.add(s);
                }
                
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;            
        }
        
        
        public static Vector getStockByOpnameId(long opnameId){
            Vector result = new Vector();
                        
            try{
                
                Vector vOpnameItem = new Vector();
                Opname opname = DbOpname.fetchExc(opnameId);
                vOpnameItem = DbOpnameItem.list(0, 0, " opname_id=" + opnameId, "");
                for(int i=0; i<vOpnameItem.size();i++){
                    OpnameItem opItem = (OpnameItem)vOpnameItem.get(i);
                    Stock s = new Stock();
                    ItemMaster im = new ItemMaster();
                    try{
                        im = DbItemMaster.fetchExc(opItem.getItemMasterId());
                    }catch(Exception ex){
                        
                    }
                    Uom um = new Uom();
                    try{
                        um = DbUom.fetchExc(im.getUomStockId());
                    }catch(Exception e){
                        
                    }
                    
                    s.setItemMasterId(opItem.getItemMasterId());
                    s.setItemCode(im.getCode());
                    s.setItemName(im.getName());
                    s.setLocationId(opname.getLocationId());
                    s.setQty(opItem.getQtySystem());
                    s.setUnit(um.getUnit());
                    result.add(s);
                }         
                //ResultSet rs = crs.getResultSet();
                //while(rs.next()){
                  //  Stock s = new Stock();
                    //s.setItemMasterId(rs.getLong(1));
                    //s.setItemCode(rs.getString(2));
                    //s.setItemName(rs.getString(3));
                    //s.setLocationId(rs.getLong(4));
                    //s.setQty(rs.getDouble(5));
                    //s.setUnit(rs.getString(6));
                    //DbStock.resultToObject(rs, s);
                  //  
                //}
                
            }
            catch(Exception e){
            }
            finally{
                
            }
            
            return result;            
        }
        
        public static double getTotalPo(long location_id, long item_master_id) {
            CONResultSet dbrs = null;
            try {
                String sql = "SELECT sum(pi.qty) from pos_purchase_item pi inner join pos_purchase p on pi.purchase_id=p.purchase_id where p.location_id= " + location_id + " and pi.item_master_id=" + item_master_id + " and p.status != 'CLOSED' ";

                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();

                double count = 0;
                while (rs.next()) {
                    count = rs.getDouble(1);
                }

                rs.close();
                return count;
            } catch (Exception e) {
                return 0;
            } finally {
                CONResultSet.close(dbrs);
            }
        }
        
        
        public static void checkRequestTransfer(long item_master_id, long location_id){
              
              ItemMaster im = new ItemMaster();
              try{
                 im= DbItemMaster.fetchExc(item_master_id);
              }catch(Exception ex){

              }
              
              try{
                 DbOrder.deleteOrder(item_master_id, location_id);
              }catch(Exception ex){
              }  
              
              if(im.getIsAutoOrder()==1){
                  
                 Location loc = new Location()   ;
                 try{
                     loc = DbLocation.fetchExc(location_id);
                 }catch(Exception ex)   {

                 }

                 if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){
                    
                    double minStock = DbStockMin.getStockMinValue(location_id, item_master_id);
                    try{
                        DbOrder.deleteOrder(item_master_id, location_id);
                    }catch(Exception ex){
                    }   
                    
                    if(minStock > 0){

                        double totalStock = DbStock.getItemTotalStock(location_id, item_master_id);
                        if(totalStock < 0){
                            totalStock =0;
                        }

                        double totalPoPrev = DbStock.getTotalPo(location_id, item_master_id);// mencari total po yg masih outstanding
                        double totalRequest = DbOrder.getTotalOrder(location_id, item_master_id); // qty yg sudah pernah di order dengan status draft   
                        double totalTransferDraft = DbStock.getTotalTransfer(location_id, item_master_id);//mencari transfer ke lokasi ini yang masih out standing

                        if((totalStock + totalRequest + totalTransferDraft)<=(minStock - im.getDeliveryUnit())){

                            double qtyRequest;

                            qtyRequest=(((minStock-(totalRequest+totalStock + totalTransferDraft)))/im.getDeliveryUnit());
                            qtyRequest=Math.floor(qtyRequest)* im.getDeliveryUnit();

                            if(totalRequest > 0){//jika sebelumnya sudah ada order maka update qtynya dengan sejumlah order yg baru + qty order sebelumna
                                Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + item_master_id + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + location_id + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                                if(vOrder != null && vOrder.size()>0){
                                    Order odrPrev = (Order)vOrder.get(0);
                                    try{
                                        odrPrev.setQtyOrder(qtyRequest);
                                        odrPrev.setQtyStock((totalStock ));
                                        DbOrder.updateExc(odrPrev);
                                    }catch(Exception ex) {

                                    }
                                }
                            }else{
                            //otomatis buatkan order;
                            try{

                                 int nextCounter;
                                 nextCounter=DbOrder.getNextCounter();

                                 Order order = new Order();
                                 order.setCounter(nextCounter);
                                 order.setPrefixNumber(DbOrder.getNumberPrefix());
                                 order.setNumber(DbOrder.getNextNumber(nextCounter));
                                 order.setQtyOrder(qtyRequest);
                                 order.setDate(new Date());
                                 order.setQtyStock((totalStock + totalRequest));
                                 order.setQtyPoPrev(totalPoPrev);
                                 order.setQtyStandar(minStock);
                                 order.setLocationId(location_id);
                                 order.setItemMasterId(item_master_id);
                                 order.setStatus("DRAFT");
                                 //order.setDate_proces(new Date()) ;

                                 DbOrder.insertExc(order);

                             }catch(Exception ex){

                             }
                        }


                    }else{
                        if((totalStock + totalTransferDraft) >= (minStock - im.getDeliveryUnit())){
                        Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + item_master_id + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + location_id + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                                if(vOrder != null && vOrder.size()>0){
                                    Order odrPrev = (Order)vOrder.get(0);
                                    try{
                                        odrPrev.setStatus("APPROVED");
                                        DbOrder.updateExc(odrPrev);
                                    }catch(Exception ex) {

                                    }
                                }
                        }else{


                            if(totalRequest!=0){
                                Vector vOrder = DbOrder.list(0, 0, "im."+DbOrder.colNames[DbOrder.COL_ITEM_MASTER_ID] + "=" + item_master_id + " and ao."+ DbOrder.colNames[DbOrder.COL_LOCATION_ID] + "=" + location_id + " and ao."+ DbOrder.colNames[DbOrder.COL_STATUS] + "='DRAFT'", "");
                                if(vOrder != null && vOrder.size()>0){
                                    Order odrPrev = (Order)vOrder.get(0);
                                    try{
                                        //jika terjadi perubahan poprev dan standar stock maka update order yg masih draft
                                        if((odrPrev.getQtyPoPrev()!=totalPoPrev) || (odrPrev.getQtyStandar()!=minStock)){

                                            double qtyRequest;

                                            qtyRequest=(((minStock-(totalRequest+totalStock+totalTransferDraft)))/im.getDeliveryUnit());
                                            qtyRequest=Math.floor(qtyRequest)* im.getDeliveryUnit();
                                            if(qtyRequest>0){
                                                odrPrev.setQtyPoPrev(totalPoPrev);
                                                odrPrev.setQtyOrder(qtyRequest);
                                                odrPrev.setQtyStock((totalStock ));
                                                odrPrev.setQtyStandar(minStock);

                                                odrPrev.setDate(new Date());
                                                DbOrder.updateExc(odrPrev);
                                            }
                                        }


                                    }catch(Exception ex) {

                                    }
                                }

                            }

                        }
                    }

                 }//min stock>0

              }//if(loc.getAktifAutoOrder()==1 && im.getIsActive()==1 &&  im.getNeedRecipe()==0){

           }//if(im.getIsAutoOrder()==1){
        
        }
        
        public static Vector getStockList(int limitStart,int recordToGet, long locationId, int type, long srcGroupId, long srcCategoryId, String srcName, String srcCode ){
            Vector result = new Vector();
            String whereClause ="";
            String sql="";
            CONResultSet crs = null;
            try{
                
                if(srcGroupId!=0){
                        whereClause = "m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+srcGroupId;
                }
                if(srcCategoryId!=0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "m."+ DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+srcCategoryId;
                }
                if(srcCode!=null && srcCode.length()>0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "(m." + DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+srcCode+"%' or m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" like '%"+srcCode+"%' or m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2] + " like '%" + srcCode + "%' or m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3] + " like '%" + srcCode + "%')" ;
                }
                if(srcName!=null && srcName.length()>0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "m." + DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+srcName+"%'";
                }

                if(whereClause!=null && whereClause.length()>0){
                    sql = "select s."+colNames[COL_ITEM_MASTER_ID]+", s."+colNames[COL_ITEM_CODE]+", s."+
                        colNames[COL_ITEM_NAME]+", s."+colNames[COL_LOCATION_ID]+", "+
                        " sum(s."+colNames[COL_QTY]+" * s."+colNames[COL_IN_OUT]+") as qty, s."+colNames[COL_UNIT]+ 
                        " from "+DB_POS_STOCK+" s "+
                        " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                        " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                        " =s."+colNames[COL_ITEM_MASTER_ID]+
                        " where "+ whereClause + " and s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                        " group by s."+colNames[COL_ITEM_MASTER_ID]+
                        " order by " +
                        " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                        ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                    
                
                }else{
                    sql = "select s."+colNames[COL_ITEM_MASTER_ID]+", s."+colNames[COL_ITEM_CODE]+", s."+
                        colNames[COL_ITEM_NAME]+", s."+colNames[COL_LOCATION_ID]+", "+
                        " sum(s."+colNames[COL_QTY]+" * s."+colNames[COL_IN_OUT]+") as qty, s."+colNames[COL_UNIT]+ 
                        " from "+DB_POS_STOCK+" s "+
                        " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                        " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                        " =s."+colNames[COL_ITEM_MASTER_ID]+
                        " where s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                        " group by s."+colNames[COL_ITEM_MASTER_ID]+
                        " order by " +
                        " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                        ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                    
                }
                
                if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
                }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                }
                    
		System.out.println("\n\n----- getting stock ----- \n"+sql+"\n------------------------\n\n");
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setItemCode(rs.getString(2));
                    s.setItemName(rs.getString(3));
                    s.setLocationId(rs.getLong(4));
                    s.setQty(rs.getDouble(5));
                    s.setUnit(rs.getString(6));
                    //DbStock.resultToObject(rs, s);
                    result.add(s);
                }
                
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;            
        }
        
        public static Vector getStockListByBarcode(int limitStart,int recordToGet, long locationId, int type, long srcGroupId, long srcCategoryId, String srcName, String srcCode ){
            Vector result = new Vector();
            String whereClause ="";
            String sql="";
            CONResultSet crs = null;
            try{
                
                if(srcGroupId!=0){
                        whereClause = "m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+srcGroupId;
                }
                if(srcCategoryId!=0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "m."+ DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+srcCategoryId;
                }
                if(srcCode!=null && srcCode.length()>0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "(m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" like '%"+srcCode+"%' or m." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode + "%' or m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2] + " like '%" + srcCode + "%' or m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3] + " like '%" + srcCode + "%' )";
                }
                if(srcName!=null && srcName.length()>0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "m." + DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+srcName+"%'";
                }

                if(whereClause!=null && whereClause.length()>0){
                    sql = "select s."+colNames[COL_ITEM_MASTER_ID]+", s."+colNames[COL_ITEM_CODE]+", s."+
                        colNames[COL_ITEM_NAME]+", s."+colNames[COL_LOCATION_ID]+", "+
                        " sum(s."+colNames[COL_QTY]+" * s."+colNames[COL_IN_OUT]+") as qty, s."+colNames[COL_UNIT]+ 
                        " from "+DB_POS_STOCK+" s "+
                        " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                        " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                        " =s."+colNames[COL_ITEM_MASTER_ID]+
                        " where "+ whereClause + " and s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                        " group by s."+colNames[COL_ITEM_MASTER_ID]+
                        " order by " +
                        " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                        ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                    
                
                }else{
                    sql = "select s."+colNames[COL_ITEM_MASTER_ID]+", s."+colNames[COL_ITEM_CODE]+", s."+
                        colNames[COL_ITEM_NAME]+", s."+colNames[COL_LOCATION_ID]+", "+
                        " sum(s."+colNames[COL_QTY]+" * s."+colNames[COL_IN_OUT]+") as qty, s."+colNames[COL_UNIT]+ 
                        " from "+DB_POS_STOCK+" s "+
                        " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                        " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                        " =s."+colNames[COL_ITEM_MASTER_ID]+
                        " where s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                        " group by s."+colNames[COL_ITEM_MASTER_ID]+
                        " order by " +
                        " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                        ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                    
                }
                
                if(limitStart == 0 && recordToGet == 0){
                    		sql = sql + "";
                }else{
                    sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
                }
                    
		System.out.println("\n\n----- getting stock ----- \n"+sql+"\n------------------------\n\n");
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setItemCode(rs.getString(2));
                    s.setItemName(rs.getString(3));
                    s.setLocationId(rs.getLong(4));
                    s.setQty(rs.getDouble(5));
                    s.setUnit(rs.getString(6));
                    //DbStock.resultToObject(rs, s);
                    result.add(s);
                }
                
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;            
        }
        
        
        public static int getStockItemCount(long locationId, int type){
                        
            CONResultSet crs = null;
            try{
                String sql = "select s."+colNames[COL_ITEM_MASTER_ID]+
                    " from "+DB_POS_STOCK+" s "+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " =s."+colNames[COL_ITEM_MASTER_ID]+
                    " where s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                    " group by s."+colNames[COL_ITEM_MASTER_ID]+
                    " order by " +
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                    
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    int count = 0;
                    while(rs.next()) { 
                        count = count + 1;
                    }

                    rs.close();
                    return count;
                
            }
            catch(Exception e){
                return 0;
            }
            finally{
                CONResultSet.close(crs);
            }
          
           
        }
        
        public static int getStockItemCountByLocation(long locationId, int type){
                        
            CONResultSet crs = null;
            try{
                String sql = "select count("+ DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+") as qty from " + DB_POS_STOCK+ 
                    " where "+ DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+ locationId +
                    " and " +DbStock.colNames[DbStock.COL_TYPE_ITEM]+"="+type;
                    
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    int count = 0;
                    while(rs.next()) { count = rs.getInt(1); }

		rs.close();
		return count;
                
            }
            catch(Exception e){
                return 0;
            }
            finally{
                CONResultSet.close(crs);
            }
          
           
        }
        
        public static int getStockItemCount(long locationId, int type, long srcGroupId, long srcCategoryId, String srcName, String srcCode){
                        
            String whereClause ="";
            CONResultSet crs = null;
            try{
                if(srcGroupId!=0){
                        whereClause = "m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+srcGroupId;
                }
                if(srcCategoryId!=0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "m."+ DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+srcCategoryId;
                }
                if(srcCode!=null && srcCode.length()>0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "(m." + DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+srcCode+"%' or m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" like '%"+srcCode+"%')" ;
                }
                if(srcName!=null && srcName.length()>0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "m." + DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+srcName+"%'";
                }
                
                String sql="";
                if(whereClause!=null && whereClause.length()>0){
                 sql = "select s."+colNames[COL_ITEM_MASTER_ID]+
                    " from "+DB_POS_STOCK+" s "+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " =s."+colNames[COL_ITEM_MASTER_ID]+
                    " where s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and  " + whereClause + " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                    " group by s."+colNames[COL_ITEM_MASTER_ID]+
                    " order by " +
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                }else{
                    sql = "select s."+colNames[COL_ITEM_MASTER_ID]+
                    " from "+DB_POS_STOCK+" s "+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " =s."+colNames[COL_ITEM_MASTER_ID]+
                    " where s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                    " group by s."+colNames[COL_ITEM_MASTER_ID]+
                    " order by " +
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                }    
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    int count = 0;
                    while(rs.next()) { 
                        count = count + 1;
                    }

                    rs.close();
                    return count;
                
            }
            catch(Exception e){
                return 0;
            }
            finally{
                CONResultSet.close(crs);
            }
          
           
        }
        
        public static int getStockItemCountByBarcode(long locationId, int type, long srcGroupId, long srcCategoryId, String srcName, String srcCode){
                        
            String whereClause ="";
            CONResultSet crs = null;
            try{
                if(srcGroupId!=0){
                        whereClause = "m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+srcGroupId;
                }
                if(srcCategoryId!=0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "m."+ DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+srcCategoryId;
                }
                if(srcCode!=null && srcCode.length()>0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "(m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE]+" like '%"+srcCode+"%' or m." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode + "%' or m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2] + " like '%" + srcCode + "%' or m." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3] + " like '%" + srcCode + "%' )";
                }
                if(srcName!=null && srcName.length()>0){
                        if(whereClause.length()>0){
                                whereClause = whereClause +" and ";
                        }
                        whereClause = whereClause + "m." + DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+srcName+"%'";
                }
                
                String sql="";
                if(whereClause!=null && whereClause.length()>0){
                 sql = "select s."+colNames[COL_ITEM_MASTER_ID]+
                    " from "+DB_POS_STOCK+" s "+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " =s."+colNames[COL_ITEM_MASTER_ID]+
                    " where s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and  " + whereClause + " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                    " group by s."+colNames[COL_ITEM_MASTER_ID]+
                    " order by " +
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                }else{
                    sql = "select s."+colNames[COL_ITEM_MASTER_ID]+
                    " from "+DB_POS_STOCK+" s "+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " =s."+colNames[COL_ITEM_MASTER_ID]+
                    " where s."+colNames[COL_LOCATION_ID]+"="+locationId+ " and s." + colNames[COL_TYPE_ITEM] + "=" + type+
                    " group by s."+colNames[COL_ITEM_MASTER_ID]+
                    " order by " +
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                }    
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    int count = 0;
                    while(rs.next()) { 
                        count = count + 1;
                    }

                    rs.close();
                    return count;
                
            }
            catch(Exception e){
                return 0;
            }
            finally{
                CONResultSet.close(crs);
            }
          
           
        }
        
        public static Vector getStock(long locationId){
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                String sql = "select s."+colNames[COL_ITEM_MASTER_ID]+", s."+colNames[COL_ITEM_CODE]+", s."+
                    colNames[COL_ITEM_NAME]+", s."+colNames[COL_LOCATION_ID]+", "+
                    " sum(s."+colNames[COL_QTY]+" * s."+colNames[COL_IN_OUT]+") as qty, s."+colNames[COL_UNIT]+ 
                    " from "+DB_POS_STOCK+" s "+
                    " inner join "+DbItemMaster.DB_ITEM_MASTER+" m on "+
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                    " =s."+colNames[COL_ITEM_MASTER_ID]+
                    " where s."+colNames[COL_LOCATION_ID]+"="+locationId+
                    " group by s."+colNames[COL_ITEM_MASTER_ID]+
                    " order by " +
                    " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                    ", m."+DbItemMaster.colNames[DbItemMaster.COL_NAME];
                    
                
                
                System.out.println("\n\n----- getting stock ----- \n"+sql+"\n------------------------\n\n");
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setItemCode(rs.getString(2));
                    s.setItemName(rs.getString(3));
                    s.setLocationId(rs.getLong(4));
                    s.setQty(rs.getDouble(5));
                    s.setUnit(rs.getString(6));
                    //DbStock.resultToObject(rs, s);
                    result.add(s);
                }
                
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;            
        }
        
        
        
        public static Vector getStockList(int start, int recordToGet, String code, String name, long groupid, long categoryid){
            
            String sql = "select st."+colNames[COL_ITEM_MASTER_ID]+", st."+colNames[COL_ITEM_CODE]+
                " , st."+colNames[COL_ITEM_NAME]+", sum(st."+colNames[COL_QTY]+" * st."+colNames[COL_IN_OUT]+") as qty "+
                " from "+DB_POS_STOCK+" st "+
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
                " on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = st."+colNames[COL_ITEM_MASTER_ID]+
                " where st."+colNames[COL_QTY]+">0";
                
                if(code!=null && code.length()>0){
                    sql = sql + " and st."+colNames[COL_ITEM_CODE]+" like '%"+code+"%'"; 
                }
                if(name!=null && name.length()>0){
                    sql = sql + " and st."+colNames[COL_ITEM_NAME]+" like '%"+name+"%'"; 
                }
                if(groupid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+groupid;
                }
                if(categoryid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+categoryid;
                }
              
                sql = sql + " group by st."+colNames[COL_ITEM_MASTER_ID];
                
                if(recordToGet!=0){
                    sql = sql + " limit "+start+","+recordToGet;
                }
                
                System.out.println("\n=================\n"+sql);
                
            CONResultSet crs = null;
            Vector result = new Vector();            
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setItemCode(rs.getString(2));
                    s.setItemName(rs.getString(3));
                    s.setQty(rs.getDouble(4));
                    result.add(s);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                
        }
        
        
        public static Vector getStockList(String barcode, String code, String name, long groupid, long categoryid, long locationId, long locationOrder){
            
            String sql = "select st."+colNames[COL_ITEM_MASTER_ID]+", st."+colNames[COL_LOCATION_ID]+
                " from "+DB_POS_STOCK+" st "+
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
                " on st."+colNames[COL_ITEM_MASTER_ID]+ "=m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " inner join "+DbStockMin.DB_STOCK_MIN + " sm "+
                " on st."+colNames[COL_ITEM_MASTER_ID]+ "=sm." + DbStockMin.colNames[DbStockMin.COL_ITEM_MASTER_ID]+
                " where st."+colNames[COL_LOCATION_ID]+"=" + locationId +
                " and sm." + DbStockMin.colNames[DbStockMin.COL_LOCATION_ID] + "="+ locationId +
                " and sm."+ DbStockMin.colNames[DbStockMin.COL_MIN_STOCK] + " >0 " ;
            
                
                if(code!=null && code.length()>0){
                    sql = sql + " and m.code like '%"+code+"%'"; 
                }
                
                if(barcode!=null && barcode.length()>0){
                    sql = sql + " and m.barcode like '%"+barcode+"%'"; 
                }
                if(name!=null && name.length()>0){
                    sql = sql + " and m.name like '%"+name+"%'"; 
                }
                if(groupid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+groupid;
                }
                if(locationOrder!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_LOCATION_ORDER]+"="+locationOrder;
                }
                if(categoryid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+categoryid;
                }
                
                sql = sql + " group by st."+colNames[COL_ITEM_MASTER_ID];
                
                
                
               
                
            CONResultSet crs = null;
            Vector result = new Vector();            
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setLocationId(rs.getLong(2));
                    result.add(s);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                
        }
        
        public static Vector getStockListByVendor(String barcode, String code, String name, long groupid, long categoryid, long locationId, long locationOrder, long vendorId){
            
            String sql = "select st."+colNames[COL_ITEM_MASTER_ID]+", st."+colNames[COL_LOCATION_ID]+
                " from "+DB_POS_STOCK+" st "+
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
                " on st."+colNames[COL_ITEM_MASTER_ID]+ "=m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " inner join "+DbVendorItem.DB_VENDOR_ITEM+" vi "+
                " on st."+colNames[COL_ITEM_MASTER_ID]+" = vi."+DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+
                " inner join "+DbStockMin.DB_STOCK_MIN + " sm "+
                " on st."+colNames[COL_ITEM_MASTER_ID]+ "=sm." + DbStockMin.colNames[DbStockMin.COL_ITEM_MASTER_ID]+
                " where st."+colNames[COL_LOCATION_ID]+"=" + locationId +
                " and sm." + DbStockMin.colNames[DbStockMin.COL_LOCATION_ID] + "="+ locationId +
                " and sm."+ DbStockMin.colNames[DbStockMin.COL_MIN_STOCK] + " >0 " ;
                
                if(code!=null && code.length()>0){
                    sql = sql + " and m.code like '%"+code+"%'"; 
                }
                if(barcode!=null && barcode.length()>0){
                    sql = sql + " and m.barcode like '%"+barcode+"%'"; 
                }
                if(name!=null && name.length()>0){
                    sql = sql + " and m.name like '%"+name+"%'"; 
                }
                if(groupid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+groupid;
                }
                if(locationOrder!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_LOCATION_ORDER]+"="+locationOrder;
                }
                if(vendorId!=0){
                    sql = sql + " and vi."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+"="+vendorId;
                }
                if(categoryid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+categoryid;
                }
                
              
                sql = sql + " group by st."+colNames[COL_ITEM_MASTER_ID];
                
                
                
                
                
            CONResultSet crs = null;
            Vector result = new Vector();            
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setLocationId(rs.getLong(2));
                    result.add(s);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                
        }
        
        
        
        
        public static double getItemTotalStock(long itemOID){
            
            String sql = " select sum("+colNames[COL_QTY]+" * "+colNames[COL_IN_OUT]+") "+
                         " from "+DB_POS_STOCK+" where "+colNames[COL_ITEM_MASTER_ID]+"= "+itemOID +
                         " and " + colNames[COL_TYPE_ITEM]+ "=" + TYPE_NON_CONSIGMENT + " and status!='DRAFT'" ;
            double result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        
        public static double getItemTotalStockConsigment(long itemOID){
            
            String sql = " select sum("+colNames[COL_QTY]+" * "+colNames[COL_IN_OUT]+") "+
                         " from "+DB_POS_STOCK+" where "+colNames[COL_ITEM_MASTER_ID]+"= "+itemOID +
                         " and " + colNames[COL_TYPE_ITEM]+ "=" + TYPE_CONSIGMENT ;
            
            double result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        public static Vector getAssetList(){
            
            Vector result = new Vector();
            
            String sql = "select g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                "g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as group_name, " +
                "im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as item_id, " +
                "im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as item_code, " +
                "im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as item_name, " +
                "im."+DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE]+" as item_price, " +
                "im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as item_cost, " +
                "l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" as loc_id, " +
                "l."+DbLocation.colNames[DbLocation.COL_NAME]+" as loc_name, " +
                "s."+DbStock.colNames[DbStock.COL_STOCK_ID]+" as stock_id, " +
                "s."+DbStock.colNames[DbStock.COL_DATE]+" as stock_date, " +
                "sum(s."+colNames[COL_QTY]+" * s."+colNames[COL_IN_OUT]+") as qtya "+
                " from "+DB_POS_STOCK+" s "+
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" im "+
                " on im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = s."+colNames[COL_ITEM_MASTER_ID]+
                " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
                " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                " inner join "+DbLocation.DB_LOCATION+" l "+
                " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+"= s."+colNames[COL_LOCATION_ID]+
                " where g."+DbItemGroup.colNames[DbItemGroup.COL_TYPE]+"="+I_Ccs.TYPE_CATEGORY_ASSET+
                " group by g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+", s."+colNames[COL_LOCATION_ID]+", s."+colNames[COL_ITEM_MASTER_ID]+
                " order by g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+", s."+colNames[COL_LOCATION_ID];
            
            System.out.println("\n\nget asset sql : "+sql);
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    ItemGroup ig = new ItemGroup();
                    ig.setOID(rs.getLong("group_id"));
                    ig.setName(rs.getString("group_name"));
                    //DbItemGroup.resultToObject(rs, ig);
                    ItemMaster im = new ItemMaster();
                    im.setOID(rs.getLong("item_id"));
                    im.setCode(rs.getString("item_code"));
                    im.setName(rs.getString("item_name"));
                    im.setSellingPrice(rs.getDouble("item_price"));
                    im.setCogs(rs.getDouble("item_cost"));
                    //DbItemMaster.resultToObject(rs, im);
                    Location loc = new Location();
                    loc.setOID(rs.getLong("loc_id"));
                    loc.setName(rs.getString("loc_name"));
                    //DbLocation.resultToObject(rs, loc);
                    Stock s = new Stock();
                    s.setOID(rs.getLong("stock_id"));
                    s.setQty(rs.getDouble("qtya"));
                    s.setDate(rs.getDate("stock_date"));
                    
                    if(s.getQty()>0){
                    
                        Vector temp = new Vector();
                        temp.add(ig);
                        temp.add(im);
                        temp.add(loc);
                        temp.add(s);

                        result.add(temp);
                    }
                    
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        
        public static Vector getAssetListDepreciation(long oidPeriode){
            
            Vector result = new Vector();
            
            String sql = "select g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" as group_id, " +
                " g."+DbItemGroup.colNames[DbItemGroup.COL_NAME]+" as group_name, " +
                " im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" as item_id, " +
                " im."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" as item_code, " +
                " im."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" as item_name, " +
                " im."+DbItemMaster.colNames[DbItemMaster.COL_SELLING_PRICE]+" as item_price, " +
                " im."+DbItemMaster.colNames[DbItemMaster.COL_COGS]+" as item_cost, " +
                " l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" as loc_id, " +
                " l."+DbLocation.colNames[DbLocation.COL_NAME]+" as loc_name, " +
                " s."+DbStock.colNames[DbStock.COL_STOCK_ID]+" as stock_id, " +
                " s."+DbStock.colNames[DbStock.COL_DATE]+" as stock_date, " +
                " sum(s."+colNames[COL_QTY]+" * s."+colNames[COL_IN_OUT]+") as qtya "+
                " from "+DbAssetDataDepresiasi.DB_ASSET_DATA_DEPRESIASI+" ass "+
                " inner join "+DbAssetData.DB_ASSET_DATA+" ad "+
                " on ass."+DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_ASSET_DATA_ID]+
                " = ad."+DbAssetData.colNames[DbAssetData.COL_ASSET_DATA_ID]+                                
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" im "+
                " on im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = ad."+colNames[COL_ITEM_MASTER_ID]+
                " inner join "+DbStock.DB_POS_STOCK+" s "+
                " on im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+"= s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
                " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
                " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = im."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
                " inner join "+DbLocation.DB_LOCATION+" l "+
                " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+"= s."+colNames[COL_LOCATION_ID]+
                " where g."+DbItemGroup.colNames[DbItemGroup.COL_TYPE]+"="+I_Ccs.TYPE_CATEGORY_ASSET+
                " and ass."+DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_PERIODE_ID]+"="+oidPeriode+
                " group by g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+", s."+colNames[COL_LOCATION_ID]+", s."+colNames[COL_ITEM_MASTER_ID]+
                " order by g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+", s."+colNames[COL_LOCATION_ID];
            
            System.out.println("\n\nget asset sql : "+sql);
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    ItemGroup ig = new ItemGroup();
                    ig.setOID(rs.getLong("group_id"));
                    ig.setName(rs.getString("group_name"));
                    //DbItemGroup.resultToObject(rs, ig);
                    ItemMaster im = new ItemMaster();
                    im.setOID(rs.getLong("item_id"));
                    im.setCode(rs.getString("item_code"));
                    im.setName(rs.getString("item_name"));
                    im.setSellingPrice(rs.getDouble("item_price"));
                    im.setCogs(rs.getDouble("item_cost"));
                    //DbItemMaster.resultToObject(rs, im);
                    Location loc = new Location();
                    loc.setOID(rs.getLong("loc_id"));
                    loc.setName(rs.getString("loc_name"));
                    //DbLocation.resultToObject(rs, loc);
                    Stock s = new Stock();
                    s.setOID(rs.getLong("stock_id"));
                    s.setQty(rs.getDouble("qtya"));
                    s.setDate(rs.getDate("stock_date"));
                    
                    if(s.getQty()>0){
                    
                        Vector temp = new Vector();
                        temp.add(ig);
                        temp.add(im);
                        temp.add(loc);
                        temp.add(s);

                        result.add(temp);
                    }
                    
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
         public static long delete(String where ) throws CONException {
            try {
                String sql = "DELETE FROM " + DB_POS_STOCK +
                        " WHERE " + where;
                CONHandler.execUpdate(sql);
            } catch (CONException dbe) {
                throw dbe;
            } catch (Exception e) {
                throw new CONException(new DbStockCode(0), CONException.UNKNOWN);
            }
            return 1;
        }
        
         public static Vector getItemMasterStock(long itemGroupId,long locationId){
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                String sql="";
                if(itemGroupId!=0){
                    sql = "select item_master_id, code, name from pos_item_master where item_group_id=" + itemGroupId + " order by name";
                    
                }else{
                    sql = "select item_master_id, code, name from pos_item_master order by name";
                }    
                
                
                System.out.println("\n\n----- getting stock ----- \n"+sql+"\n------------------------\n\n");
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                
                while(rs.next()){
                    
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setItemCode(rs.getString(2));
                    s.setItemName(rs.getString(3));
                    s.setLocationId(locationId);
                    s.setQty(DbStock.getItemTotalStock(locationId, rs.getLong(1)));
                    //s.setUnit(rs.getString(6));
                    //DbStock.resultToObject(rs, s);
                    result.add(s);
                }
                
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;            
        }
        public static double getItemTotalStock(long locationId, long itemOID){
            
            String sql = " select sum("+colNames[COL_QTY]+" * "+colNames[COL_IN_OUT]+") "+
                         " from "+DB_POS_STOCK+" where "+colNames[COL_ITEM_MASTER_ID]+"= "+itemOID +
                         " and " + colNames[COL_LOCATION_ID]+ "=" + locationId + " and " + colNames[COL_TYPE_ITEM]+ "=" + TYPE_NON_CONSIGMENT;
            double result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        public static double getTotalStockPrev(long locationId, long itemOID, Date dt){
            
            String sql = " select sum("+colNames[COL_QTY]+" * "+colNames[COL_IN_OUT]+") "+
                         " from "+DB_POS_STOCK+" where "+colNames[COL_ITEM_MASTER_ID]+"= "+itemOID +
                         " and " + colNames[COL_LOCATION_ID]+ "=" + locationId + " and " + colNames[COL_TYPE_ITEM]+ "=" + TYPE_NON_CONSIGMENT + 
                         " and to_days(date) < to_days('" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "')";
            double result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        public static double getTotalStockSales(long locationId, Date dt){
            
            String sql = " select count(stock_id) from pos_stock where location_id=" + locationId +
                    " and type=7 and to_days(date) = to_days('" + JSPFormater.formatDate(dt,"yyyy-MM-dd") + "')";
                    
                         
            double result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
         public static double getTotalRecordSales(long locationId, Date dt){
            
            String sql = " select count(sd.sales_detail_id) from pos_sales_detail sd inner join pos_sales" + 
                   " s on sd.sales_id=s.sales_id inner join pos_item_master im on sd.product_master_id=im.item_master_id " +
                   " where im.is_service <> 1 and to_days(s.date) = to_days('" +  JSPFormater.formatDate(dt,"yyyy-MM-dd")+"') and s.location_id="+ locationId ; 
                   
            
            double result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        
        public static int getItemTotalStockCosting(long locationId, long itemOID){
            
            String sql = " select sum("+colNames[COL_QTY]+" * "+colNames[COL_IN_OUT]+") "+
                         " from "+DB_POS_STOCK+" where "+colNames[COL_ITEM_MASTER_ID]+"= "+itemOID +
                         " and " + colNames[COL_LOCATION_ID]+ "=" + locationId + " and " + colNames[COL_TYPE_ITEM]+ "=" + TYPE_NON_CONSIGMENT ;
            int result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getInt(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        public static int getTotalStockByTransaksi(String whereClause){
            
            String sql = " select count(stock_id) from pos_stock where " + whereClause ;
            
            int result = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getInt(1);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        public static Vector getStockByOpnameIdAdjusment(long opnameId){
            Vector result = new Vector();
                        
            try{
                
                Vector vOpnameItem = new Vector();
                Opname opname = DbOpname.fetchExc(opnameId);
                vOpnameItem = DbOpnameItem.list(0, 0, " opname_id=" + opnameId, "");
                for(int i=0; i<vOpnameItem.size();i++){
                    OpnameItem opItem = (OpnameItem)vOpnameItem.get(i);
                    if (opItem.getQtyReal()!= opItem.getQtySystem()){
                        Stock s = new Stock();
                        ItemMaster im = DbItemMaster.fetchExc(opItem.getItemMasterId());
                        Uom um = DbUom.fetchExc(im.getUomStockId());
                        s.setItemMasterId(opItem.getItemMasterId());
                        s.setItemCode(im.getCode());
                        s.setItemName(im.getName());
                        s.setLocationId(opname.getLocationId());
                        s.setQty(opItem.getQtySystem());
                        s.setUnit(um.getUnit());
                        result.add(s);
                    }
                }         
                //ResultSet rs = crs.getResultSet();
                //while(rs.next()){
                  //  Stock s = new Stock();
                    //s.setItemMasterId(rs.getLong(1));
                    //s.setItemCode(rs.getString(2));
                    //s.setItemName(rs.getString(3));
                    //s.setLocationId(rs.getLong(4));
                    //s.setQty(rs.getDouble(5));
                    //s.setUnit(rs.getString(6));
                    //DbStock.resultToObject(rs, s);
                  //  
                //}
                
            }
            catch(Exception e){
            }
            finally{
                
            }
            
            return result;            
        }
        
        public static Vector getDetailStockClosing(long locationId, String startDate, String endDate){
           
            CONResultSet crs = null;
            Vector list = new Vector();
               try{
                    String sql = "select item_master_id, sum(qty * in_out) as incoming, 0 as retur, " +
                        " 0 as transferout, 0 as transferin, 0 as sales, 0 as costing, 0 as repack, 0 as opname, 0 as adjusment " +
                        " from pos_stock as pd where to_days(date) between to_days('" + startDate + "') and to_days('" +
                        endDate + "') and location_id=" + locationId + " and type=0 ";
                        sql = sql + " group by item_master_id ";

                sql = sql + "union select item_master_id, 0,sum(qty * in_out) as retur, " +
                        " 0,0,0,0,0,0,0 from pos_stock as pd where to_days(date) between to_days('" + startDate + "') and to_days('" +
                         endDate + "') and location_id=" + locationId + " and type=1 ";
                         sql = sql + " group by item_master_id ";

                sql = sql + "union select item_master_id, 0,0,sum(qty * in_out) as transferout, " +
                        " 0,0,0,0,0,0 from pos_stock as pd where to_days(date) between to_days('" + startDate + "') and to_days('" +
                         endDate + "') and location_id=" + locationId + " and type=2 ";
                         sql = sql + " group by item_master_id ";
                         
                sql = sql + "union select item_master_id, 0,0,0,sum(qty * in_out) as transferin, " +
                        " 0,0,0,0,0 from pos_stock as pd where to_days(date) between to_days('" + startDate + "') and to_days('" +
                         endDate + "') and location_id=" + locationId + " and type=3 ";
                         sql = sql + " group by item_master_id ";

                sql = sql + "union select item_master_id, 0,0,0,0,sum(qty * in_out) as sales, " +
                        " 0,0,0,0 from pos_stock as pd where to_days(date) between to_days('" + startDate + "') and to_days('" +
                         endDate + "') and location_id=" + locationId + " and type=7 ";
                         sql = sql + " group by item_master_id ";

                sql = sql + "union select item_master_id, 0,0,0,0,0,sum(qty * in_out) as costing, " +
                        " 0,0,0 from pos_stock as pd where to_days(date) between to_days('" + startDate + "') and to_days('" +
                         endDate + "') and location_id=" + locationId + " and type=8 ";
                         sql = sql + " group by item_master_id ";

                sql = sql + "union select item_master_id, 0,0,0,0,0,0,sum(qty * in_out) as repack, " +
                        " 0,0 from pos_stock as pd where to_days(date) between to_days('" + startDate + "') and to_days('" +
                         endDate + "') and location_id=" + locationId + " and type=9 ";
                         sql = sql + " group by item_master_id ";

                         
                sql = sql + "union select item_master_id, 0,0,0,0,0,0,0,sum(qty * in_out) as opname, " +
                        " 0 from pos_stock as pd where to_days(date) between to_days('" + startDate + "') and to_days('" +
                         endDate + "') and location_id=" + locationId + " and type=5 ";
                         sql = sql + " group by item_master_id ";
                         

                sql = sql + "union select item_master_id, 0,0,0,0,0,0,0,0,sum(qty * in_out) as adjusment " +
                        " from pos_stock as pd where to_days(date) between to_days('" + startDate + "') and to_days('" +
                         endDate + "') and location_id=" + locationId + " and type=4 ";
                         sql = sql + " group by item_master_id ";

                String sqlGabung = "select item_master_id, sum(incoming),sum(retur), sum(transferout), sum(transferin),sum(sales),sum(costing), " +
                                    " sum(repack), sum(opname), sum(adjusment)" +
                                    " from ("+sql+") as tabel group by item_master_id" ;//limit 1000,1000";


            crs = CONHandler.execQueryResult(sqlGabung);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                StockOpeningBalance stockOpeningBalance = new StockOpeningBalance();
                if(rs.getDouble("sum(incoming)")==0){
                    stockOpeningBalance.setIncoming(0);
                }else{
                    stockOpeningBalance.setIncoming(rs.getDouble("sum(incoming)"));
                }

                if(rs.getDouble("sum(retur)")==0){
                    stockOpeningBalance.setReturVendor(0);
                }else{
                    stockOpeningBalance.setReturVendor(rs.getDouble("sum(retur)"));
                }

                if(rs.getDouble("sum(transferout)")==0){
                    stockOpeningBalance.setTransferOut(0);
                }else{
                    stockOpeningBalance.setTransferOut(rs.getDouble("sum(retur)"));
                }

                if(rs.getDouble("sum(transferin)")==0){
                    stockOpeningBalance.setTransferIn(0);
                }else{
                    stockOpeningBalance.setTransferIn(rs.getDouble("sum(transferin)"));
                }
                
                if(rs.getDouble("sum(sales)")==0){
                    stockOpeningBalance.setSales(0);
                }else{
                    stockOpeningBalance.setSales(rs.getDouble("sum(sales)"));
                }
                
                if(rs.getDouble("sum(costing)")==0){
                    stockOpeningBalance.setCosting(0);
                }else{
                    stockOpeningBalance.setCosting(rs.getDouble("sum(costing)"));
                }

                if(rs.getDouble("sum(repack)")==0){
                    stockOpeningBalance.setRepack(0);
                }else{
                    stockOpeningBalance.setRepack(rs.getDouble("sum(repack)"));
                }

                if(rs.getDouble("sum(opname)")==0){
                    stockOpeningBalance.setOpname(0);
                }else{
                    stockOpeningBalance.setOpname(rs.getDouble("sum(opname)"));
                }

                if(rs.getDouble("sum(adjusment)")==0){
                    stockOpeningBalance.setAdjusment(0);
                }else{
                    stockOpeningBalance.setAdjusment(rs.getDouble("sum(opname)"));
                }
                list.add(stockOpeningBalance);
            }
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }

        return list;
    }
    public static void doClosingOpname(long locationId,long itemGroupId, long itemCategoryId, long vendorId, long opnameId ){
           
            CONResultSet crs = null;
            
            
               try{
                   String whereclause="";
                   String sql="";
                   double stock=DbStock.getCount("location_id="+locationId);
                    if (stock==0){
                        sql = "select im.item_master_id, im.cogs from pos_item_master im " ;
                    }else{
                        sql = "select im.item_master_id, sum(ps.qty * ps.in_out) as tot, im.cogs from pos_stock ps inner join pos_item_master im on ps.item_master_id=im.item_master_id" ;
                    }
                    
                    //String whereclause="";
                    if(itemGroupId!=0){
                        sql = sql + " inner join pos_item_group ig on im.item_group_id=ig.item_group_id ";
                    }
                    if(itemCategoryId!=0){
                        sql = sql + " inner join pos_item_category ic on im.item_category_id=ic.item_category_id ";
                    }
                    if (stock >0){
                        if(whereclause.length()>0 && whereclause !=null){
                            whereclause = whereclause + " and ";
                        }
                        whereclause = whereclause + " ps.location_id=" + locationId;
                    }                           
                    
                    
                    if(itemGroupId!=0){
                        if(whereclause.length()>0 && whereclause !=null){
                            whereclause = whereclause + " and ";
                        }
                        whereclause = whereclause + " ig.item_group_id=" + itemGroupId;
                    }
                    
                    if(itemCategoryId!=0){
                        if(whereclause.length()>0 && whereclause !=null){
                            whereclause = whereclause + " and ";
                        }
                        whereclause  =  whereclause + " ic.item_category_id=" + itemCategoryId;
                    }
                    
                    if(vendorId!=0){
                        if(whereclause.length()>0 && whereclause !=null){
                            whereclause = whereclause + " and ";
                        }
                        whereclause = whereclause + " im.default_vendor_id=" + vendorId;
                    }
                    
                   if(whereclause.length()>0 && whereclause !=null){
                            whereclause = " where " + whereclause ;
                   }
                   
                   sql = sql + whereclause + " group by im.item_master_id";
                    
               
            Location loc = new Location();
            try{
                loc = DbLocation.fetchExc(locationId);
            }catch(Exception ex){
                
            }
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                ClosingOpname co = new ClosingOpname();
                co.setDate(new Date());
                co.setItemMasterId(rs.getLong("item_master_id"));
                co.setLocationId(locationId);
                if(stock>0){
                    co.setQty(rs.getDouble("tot"));
                }else{
                    co.setQty(0);
                }
                co.setOpnameId(opnameId);
                co.setHpp(rs.getDouble("cogs"));
                //DbPriceType.getPriceType(itemCategoryId);
                co.setHarga_jual(DbPriceType.getPrice(1, loc.getGol_price(), rs.getLong("item_master_id")));
                    
                
                DbClosingOpname.insertExc(co);
            }
            
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }

        
    }
    public static void doClosingOpname(long locationId,String itemGroupId, long itemCategoryId, long vendorId, long opnameId ){
           
            CONResultSet crs = null;
            
            
               try{
                   String whereclause="";
                   String sql="";
                   double stock=DbStock.getCount("location_id="+locationId);
                    if (stock==0){
                        sql = "select im.item_master_id, im.cogs from pos_item_master im " ;
                    }else{
                        sql = "select im.item_master_id, sum(ps.qty * ps.in_out) as tot, im.cogs from pos_stock ps inner join pos_item_master im on ps.item_master_id=im.item_master_id" ;
                    }
                    
                    //String whereclause="";
                    if(itemGroupId.length()>0){
                        sql = sql + " inner join pos_item_group ig on im.item_group_id=ig.item_group_id ";
                    }
                    if(itemCategoryId!=0){
                        sql = sql + " inner join pos_item_category ic on im.item_category_id=ic.item_category_id ";
                    }
                    if (stock >0){
                        if(whereclause.length()>0 && whereclause !=null){
                            whereclause = whereclause + " and ";
                        }
                        whereclause = whereclause + " ps.location_id=" + locationId;
                    }                           
                    
                    
                    if(itemGroupId.length()>0){
                        if(whereclause.length()>0 && whereclause !=null){
                            whereclause = whereclause + " and ";
                        }
                        whereclause = whereclause + " ig.item_group_id in (" + itemGroupId + ") ";
                    }
                    
                    if(itemCategoryId!=0){
                        if(whereclause.length()>0 && whereclause !=null){
                            whereclause = whereclause + " and ";
                        }
                        whereclause  =  whereclause + " ic.item_category_id=" + itemCategoryId;
                    }
                    
                    if(vendorId!=0){
                        if(whereclause.length()>0 && whereclause !=null){
                            whereclause = whereclause + " and ";
                        }
                        whereclause = whereclause + " im.default_vendor_id=" + vendorId;
                    }
                    
                   if(whereclause.length()>0 && whereclause !=null){
                            whereclause = " where " + whereclause ;
                   }
                   
                   sql = sql + whereclause + " group by im.item_master_id";
                    
               
            Location loc = new Location();
            try{
                loc = DbLocation.fetchExc(locationId);
            }catch(Exception ex){
                
            }
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                ClosingOpname co = new ClosingOpname();
                co.setDate(new Date());
                co.setItemMasterId(rs.getLong("item_master_id"));
                co.setLocationId(locationId);
                if(stock>0){
                    co.setQty(rs.getDouble("tot"));
                }else{
                    co.setQty(0);
                }
                co.setOpnameId(opnameId);
                co.setHpp(rs.getDouble("cogs"));
                //DbPriceType.getPriceType(itemCategoryId);
                co.setHarga_jual(DbPriceType.getPrice(1, loc.getGol_price(), rs.getLong("item_master_id")));
                    
                
                DbClosingOpname.insertExc(co);
            }
            
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }

        
    }
    
    public static void insertTransferGoodsIn(Transfer rec, TransferItem ri){
            
            ItemMaster im = new ItemMaster();
            Uom uom = new Uom();
            
           
            
            //---------- masukkan stock ----------------
            if(rec.getStatus().equalsIgnoreCase("APPROVED")){
                try{

                    //System.out.println("inserting new stock ...");
                    im = DbItemMaster.fetchExc(ri.getItemMasterId());
                    uom = DbUom.fetchExc(im.getUomStockId());
                    
                    Stock stock = new Stock();
                    stock.setTransferId(ri.getTransferId());
                    stock.setInOut(STOCK_IN);
                    stock.setItemBarcode(im.getBarcode());
                    stock.setItemCode(im.getCode());
                    stock.setItemMasterId(im.getOID());
                    stock.setItemName(im.getName());
                    stock.setLocationId(rec.getToLocationId());
                    stock.setDate(rec.getApproval1Date());
                    stock.setNoFaktur(rec.getNumber());

                    //harga ambil harga average terakhir
                    stock.setPrice(im.getCogs());
                    stock.setTotal(im.getCogs()*ri.getQty());

                    stock.setQty(ri.getQty());
                    stock.setType(TYPE_TRANSFER_IN);
                    stock.setUnitId(im.getUomStockId());
                    stock.setUnit(uom.getUnit());
                    stock.setUserId(rec.getUserId());
                    stock.setType_item(rec.getType());
                    stock.setTransfer_item_id(ri.getOID());
                    stock.setStatus(rec.getStatus());
                    DbStock.insertExc(stock);

                    //System.out.println("inserting new stock ... done ");
                }
                catch(Exception e){

                    System.out.println(e.toString());
                }
            }
            //DbStock.checkRequestTransfer(ri.getItemMasterId(),rec.getToLocationId());
            //DbStock.checkRequestTransfer(ri.getItemMasterId(),rec.getFromLocationId());
            
        }
      public static Vector getStockListByVendorPO(String barcode, String code, String name, long groupid, long categoryid, long locationId, long locationOrder, long vendorId, int days){
            
            String sql = "select st."+colNames[COL_ITEM_MASTER_ID]+", st."+colNames[COL_LOCATION_ID]+
                " from "+DB_POS_STOCK+" st "+
                " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
                " on st."+colNames[COL_ITEM_MASTER_ID]+ "=m." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+
                " inner join "+DbVendorItem.DB_VENDOR_ITEM+" vi "+
                " on st."+colNames[COL_ITEM_MASTER_ID]+" = vi."+DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+
                " inner join "+DbVendor.DB_VENDOR + " v " +
                " on vi." + DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+ "=v."+DbVendor.colNames[DbVendor.COL_VENDOR_ID]+
                " where st."+colNames[COL_LOCATION_ID]+"=" + locationId;
                
                if(code!=null && code.length()>0){
                    sql = sql + " and m.code like '%"+code+"%'"; 
                }
                if(barcode!=null && barcode.length()>0){
                    sql = sql + " and m.barcode like '%"+barcode+"%'"; 
                }
                if(name!=null && name.length()>0){
                    sql = sql + " and m.name like '%"+name+"%'"; 
                }
                if(groupid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+"="+groupid;
                }
                if(locationOrder!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_LOCATION_ORDER]+"="+locationOrder;
                }
                if(vendorId!=0){
                    sql = sql + " and vi."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+"="+vendorId;
                }
                if(categoryid!=0){
                    sql = sql + " and m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+"="+categoryid;
                }
                if(days!=0){
                    if(days==1){
                        sql = sql + " and v.odr_senin=1";
                    }else if(days==2){
                        sql = sql + " and v.odr_selasa=1";
                    }else if(days==3){
                        sql = sql + " and v.odr_rabu=1";
                    }else if(days==4){
                        sql = sql + " and v.odr_kamis=1";
                    }else if(days==5){
                        sql = sql + " and v.odr_jumat=1";
                    }else if(days==6){
                        sql = sql + " and v.odr_sabtu=1";
                    }else if(days==7){
                        sql = sql + " and v.odr_minggu=1";
                    }
                    
                }
              
                sql = sql + " group by st."+colNames[COL_ITEM_MASTER_ID];
                
                
                
                //System.out.println("\n=================\n"+sql);
                
            CONResultSet crs = null;
            Vector result = new Vector();            
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Stock s = new Stock();
                    s.setItemMasterId(rs.getLong(1));
                    s.setLocationId(rs.getLong(2));
                    result.add(s);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                
        }
      
        public static double getTotalTransfer(long location_id, long item_master_id) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT sum(pi.qty) from pos_transfer_item pi inner join pos_transfer p on pi.transfer_id=p.transfer_id where p.to_location_id= " + location_id + " and pi.item_master_id=" + item_master_id + " and p.status = 'DRAFT' ";
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
    
  public static double getTotalQtySales(long location_id, long item_master_id, Date startDate, Date endDate){
        CONResultSet dbrs = null;
        try {
            String sql ="";
            if(location_id!=0){
                sql = "select sum(qty) from pos_stock where location_id="+location_id + " and item_master_id="+ item_master_id + " and type=7 and to_days(date) between to_days('"+ JSPFormater.formatDate(startDate, "yyyy-MM-dd") +"') and to_days('"+ JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
            }else{
                sql = "select sum(qty) from pos_stock where item_master_id="+ item_master_id + " and type=7 and to_days(date) between to_days('"+ JSPFormater.formatDate(startDate, "yyyy-MM-dd") +"') and to_days('"+ JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double count = 0;
            while (rs.next()){
                count = rs.getDouble(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
  
        
      
        
}
