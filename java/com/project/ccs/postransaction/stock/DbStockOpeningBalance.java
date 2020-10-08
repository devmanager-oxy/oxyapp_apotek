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

public class DbStockOpeningBalance extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_POS_STOCK_OPENING_BALANCE = "pos_stock_opening_balance";

	public static final  int COL_STOCK_OPENING_BALANCE_ID = 0;
        public static final  int COL_ITEM_MASTER_ID = 1;
	public static final  int COL_STOCK_PERIODE_ID = 2;
        public static final  int COL_LOCATION_ID = 3;
        public static final  int COL_INCOMING = 4;
	public static final  int COL_TRANSFER_OUT = 5;
	public static final  int COL_TRANSFER_IN = 6;
	
	public static final  int COL_SALES = 7;
	public static final  int COL_RETUR_VENDOR = 8;
	public static final  int COL_OPNAME = 9;
	public static final  int COL_ADJUSMENT = 10;
	public static final  int COL_COSTING = 11;
	public static final  int COL_REPACK = 12;
	public static final  int COL_BALANCE_STOCK = 13;
	
        
	public static final  String[] colNames = {
		"stock_opening_balance_id",
                "item_master_id",
                "stockOpneingBalance_periode_id",
                "location_id",
                "incoming",
                "transfer_out",
                "transfer_in",
                "sales",
                "retur_vendor",
                "opname",
                "adjusment",
                "costing",
                "repack",
                "balance_stockOpneingBalance"
                
	}; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
                TYPE_FLOAT,
		TYPE_FLOAT,
                TYPE_FLOAT,
		TYPE_FLOAT,
                TYPE_FLOAT,
		TYPE_FLOAT
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
        
        public static int TYPE_CONSIGMENT = 1;
        public static int TYPE_NON_CONSIGMENT = 0;
        
           
        
	public DbStockOpeningBalance(){
	}

	public DbStockOpeningBalance(int i) throws CONException { 
		super(new DbStockOpeningBalance()); 
	}

	public DbStockOpeningBalance(String sOid) throws CONException { 
		super(new DbStockOpeningBalance(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbStockOpeningBalance(long lOid) throws CONException { 
		super(new DbStockOpeningBalance(0)); 
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
		return DB_POS_STOCK_OPENING_BALANCE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbStockOpeningBalance().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		StockOpeningBalance stockOpneingBalance = fetchExc(ent.getOID()); 
		ent = (Entity)stockOpneingBalance; 
		return stockOpneingBalance.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((StockOpeningBalance) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((StockOpeningBalance) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static StockOpeningBalance fetchExc(long oid) throws CONException{ 
		try{ 
			StockOpeningBalance stockOpneingBalance = new StockOpeningBalance();
			DbStockOpeningBalance pstStock = new DbStockOpeningBalance(oid); 
			stockOpneingBalance.setOID(oid);

			stockOpneingBalance.setItemMasterId(pstStock.getlong(COL_ITEM_MASTER_ID));
			stockOpneingBalance.setStockPeriodeId(pstStock.getlong(COL_STOCK_PERIODE_ID));
			stockOpneingBalance.setLocationId(pstStock.getlong(COL_LOCATION_ID));
			stockOpneingBalance.setIncoming(pstStock.getdouble(COL_INCOMING));
			stockOpneingBalance.setTransferOut(pstStock.getdouble(COL_TRANSFER_OUT));
                        stockOpneingBalance.setSales(pstStock.getdouble(COL_SALES));
                        stockOpneingBalance.setReturVendor(pstStock.getdouble(COL_RETUR_VENDOR));
                        stockOpneingBalance.setOpname(pstStock.getdouble(COL_OPNAME));
                        stockOpneingBalance.setAdjusment(pstStock.getdouble(COL_ADJUSMENT));
                        stockOpneingBalance.setCosting(pstStock.getdouble(COL_COSTING));
                        stockOpneingBalance.setRepack(pstStock.getdouble(COL_REPACK));
                        stockOpneingBalance.setBalanceStock(pstStock.getdouble(COL_BALANCE_STOCK));
			return stockOpneingBalance; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStockOpeningBalance(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(StockOpeningBalance stockOpneingBalance) throws CONException{ 
		try{ 
			DbStockOpeningBalance pstStock = new DbStockOpeningBalance(0);

			pstStock.setLong(COL_ITEM_MASTER_ID, stockOpneingBalance.getItemMasterId());
			pstStock.setLong(COL_STOCK_PERIODE_ID, stockOpneingBalance.getStockPeriodeId());
			pstStock.setLong(COL_LOCATION_ID, stockOpneingBalance.getLocationId());
			pstStock.setDouble(COL_INCOMING, stockOpneingBalance.getIncoming());
			pstStock.setDouble(COL_TRANSFER_OUT, stockOpneingBalance.getTransferOut());
			pstStock.setDouble(COL_TRANSFER_IN, stockOpneingBalance.getTransferIn());
                        pstStock.setDouble(COL_SALES, stockOpneingBalance.getSales());
                        pstStock.setDouble(COL_RETUR_VENDOR, stockOpneingBalance.getReturVendor());
                        pstStock.setDouble(COL_OPNAME, stockOpneingBalance.getOpname());
                        pstStock.setDouble(COL_ADJUSMENT, stockOpneingBalance.getAdjusment());
                        pstStock.setDouble(COL_COSTING, stockOpneingBalance.getCosting());
                        pstStock.setDouble(COL_REPACK, stockOpneingBalance.getRepack());
                        pstStock.setDouble(COL_BALANCE_STOCK, stockOpneingBalance.getBalanceStock());
			pstStock.insert(); 
			stockOpneingBalance.setOID(pstStock.getlong(COL_STOCK_OPENING_BALANCE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStockOpeningBalance(0),CONException.UNKNOWN); 
		}
		return stockOpneingBalance.getOID();
	}

	public static long updateExc(StockOpeningBalance stockOpneingBalance) throws CONException{ 
		try{ 
			if(stockOpneingBalance.getOID() != 0){ 
				DbStockOpeningBalance pstStock = new DbStockOpeningBalance(stockOpneingBalance.getOID());

				pstStock.setLong(COL_ITEM_MASTER_ID, stockOpneingBalance.getItemMasterId());
				pstStock.setLong(COL_STOCK_PERIODE_ID, stockOpneingBalance.getStockPeriodeId());
				pstStock.setLong(COL_LOCATION_ID, stockOpneingBalance.getLocationId());
				pstStock.setDouble(COL_INCOMING, stockOpneingBalance.getIncoming());
                                pstStock.setDouble(COL_TRANSFER_OUT, stockOpneingBalance.getTransferOut());
                                pstStock.setDouble(COL_TRANSFER_IN, stockOpneingBalance.getTransferIn());
                                pstStock.setDouble(COL_SALES, stockOpneingBalance.getSales());
                                pstStock.setDouble(COL_RETUR_VENDOR, stockOpneingBalance.getReturVendor());
                                pstStock.setDouble(COL_OPNAME, stockOpneingBalance.getOpname());
                                pstStock.setDouble(COL_ADJUSMENT, stockOpneingBalance.getAdjusment());
                                pstStock.setDouble(COL_COSTING, stockOpneingBalance.getCosting());
                                pstStock.setDouble(COL_REPACK, stockOpneingBalance.getRepack());
                                pstStock.setDouble(COL_BALANCE_STOCK, stockOpneingBalance.getBalanceStock());
				pstStock.update(); 
				return stockOpneingBalance.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStockOpeningBalance(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbStockOpeningBalance pstStock = new DbStockOpeningBalance(oid);
			pstStock.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStockOpeningBalance(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_POS_STOCK_OPENING_BALANCE; 
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
				StockOpeningBalance stockOpneingBalance = new StockOpeningBalance();
				resultToObject(rs, stockOpneingBalance);
				lists.add(stockOpneingBalance);
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

	public static void resultToObject(ResultSet rs, StockOpeningBalance stockOpneingBalance){
		try{
			stockOpneingBalance.setOID(rs.getLong(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_STOCK_OPENING_BALANCE_ID]));
			stockOpneingBalance.setItemMasterId(rs.getLong(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_ITEM_MASTER_ID]));
			stockOpneingBalance.setStockPeriodeId(rs.getLong(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_STOCK_PERIODE_ID]));
			stockOpneingBalance.setLocationId(rs.getLong(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_LOCATION_ID]));
			stockOpneingBalance.setIncoming(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_INCOMING]));
                        stockOpneingBalance.setTransferOut(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_TRANSFER_OUT]));
                        stockOpneingBalance.setTransferIn(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_TRANSFER_IN]));
                        stockOpneingBalance.setSales(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_SALES]));
                        stockOpneingBalance.setReturVendor(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_RETUR_VENDOR]));
                        stockOpneingBalance.setOpname(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_OPNAME]));
                        stockOpneingBalance.setAdjusment(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_ADJUSMENT]));
                        stockOpneingBalance.setCosting(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_COSTING]));
                        stockOpneingBalance.setRepack(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_REPACK]));
                        stockOpneingBalance.setBalanceStock(rs.getDouble(DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_BALANCE_STOCK]));
		}catch(Exception e){ }
	}

	public static boolean checkOID(long stockId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_POS_STOCK_OPENING_BALANCE + " WHERE " + 
						DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_STOCK_OPENING_BALANCE_ID] + " = " + stockId;

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
			String sql = "SELECT COUNT("+ DbStockOpeningBalance.colNames[DbStockOpeningBalance.COL_STOCK_OPENING_BALANCE_ID] + ") FROM " + DB_POS_STOCK_OPENING_BALANCE;
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
			  	   StockOpeningBalance stockOpneingBalance = (StockOpeningBalance)list.get(ls);
				   if(oid == stockOpneingBalance.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
       
       public static void closingStock(long itemMasterId, long stockPeriodeId, long locationId){
		try{
                    StockPeriode stockPer = new StockPeriode();
                    stockPer= DbStockPeriode.fetchExc(stockPeriodeId);
                    
                    
		}catch(Exception e){ }
       }
        
           
        
}
