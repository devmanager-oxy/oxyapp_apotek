

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
import com.project.payroll.*;
import com.project.*;

public class DbPurchaseItemShare extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_PURCHASE_ITEM_SHARE = "purchase_item_share";

	public static final  int COL_PURCHASE_ITEM_SHARE_ID = 0;
	public static final  int COL_PURCHASE_ITEM_ID = 1;
	public static final  int COL_PERCENT = 2;
	public static final  int COL_AMOUNT = 3;
	public static final  int COL_COA_ID = 4;
	public static final  int COL_DATE = 5;
	public static final  int COL_TOTAL_AMOUNT = 6;
	public static final  int COL_PURCHASE_ID = 7;
	public static final  int COL_USER_ID = 8;        
        public static final  int COL_ROOM_CLASS_ID = 9;        
        public static final  int COL_HOTEL_ROOM_ID = 10;
        public static final  int COL_COA_CREDIT_ID = 11;

	public static final  String[] colNames = {
		"purchase_item_share_id",		
		"purchase_item_id",
		"percent",
		"amount",
                "coa_id",
		"date",
		"total_amount",
		"purchase_id",
		"user_id",
		"room_class_id",
                "hotel_room_id",
                "coa_credit_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	 }; 

	public DbPurchaseItemShare(){
	}

	public DbPurchaseItemShare(int i) throws CONException { 
		super(new DbPurchaseItemShare()); 
	}

	public DbPurchaseItemShare(String sOid) throws CONException { 
		super(new DbPurchaseItemShare(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPurchaseItemShare(long lOid) throws CONException { 
		super(new DbPurchaseItemShare(0)); 
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
		return DB_PURCHASE_ITEM_SHARE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPurchaseItemShare().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PurchaseItemShare purchaseItemShare = fetchExc(ent.getOID()); 
		ent = (Entity)purchaseItemShare; 
		return purchaseItemShare.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PurchaseItemShare) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PurchaseItemShare) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PurchaseItemShare fetchExc(long oid) throws CONException{ 
		try{ 
			PurchaseItemShare purchaseItemShare = new PurchaseItemShare();
			DbPurchaseItemShare pstPurchaseItemShare = new DbPurchaseItemShare(oid); 
			purchaseItemShare.setOID(oid);

			purchaseItemShare.setPurchaseItemId(pstPurchaseItemShare.getlong(COL_PURCHASE_ITEM_ID));
			purchaseItemShare.setPercent(pstPurchaseItemShare.getdouble(COL_PERCENT));
			purchaseItemShare.setAmount(pstPurchaseItemShare.getdouble(COL_AMOUNT));
			purchaseItemShare.setCoaId(pstPurchaseItemShare.getlong(COL_COA_ID));
			purchaseItemShare.setDate(pstPurchaseItemShare.getDate(COL_DATE));
			purchaseItemShare.setTotalAmount(pstPurchaseItemShare.getdouble(COL_TOTAL_AMOUNT));
			purchaseItemShare.setPurchaseId(pstPurchaseItemShare.getlong(COL_PURCHASE_ID));
			purchaseItemShare.setUserId(pstPurchaseItemShare.getlong(COL_USER_ID));
			purchaseItemShare.setRoomClassId(pstPurchaseItemShare.getlong(COL_ROOM_CLASS_ID));                        
                        purchaseItemShare.setHotelRoomId(pstPurchaseItemShare.getlong(COL_HOTEL_ROOM_ID));
                        purchaseItemShare.setCoaCreditId(pstPurchaseItemShare.getlong(COL_COA_CREDIT_ID));

			return purchaseItemShare; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchaseItemShare(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PurchaseItemShare purchaseItemShare) throws CONException{ 
		try{ 
			DbPurchaseItemShare pstPurchaseItemShare = new DbPurchaseItemShare(0);

			pstPurchaseItemShare.setLong(COL_PURCHASE_ITEM_ID, purchaseItemShare.getPurchaseItemId());
			pstPurchaseItemShare.setDouble(COL_PERCENT, purchaseItemShare.getPercent());
			pstPurchaseItemShare.setDouble(COL_AMOUNT, purchaseItemShare.getAmount());
			pstPurchaseItemShare.setLong(COL_COA_ID, purchaseItemShare.getCoaId());
			pstPurchaseItemShare.setDate(COL_DATE, purchaseItemShare.getDate());
			pstPurchaseItemShare.setDouble(COL_TOTAL_AMOUNT, purchaseItemShare.getTotalAmount());
			pstPurchaseItemShare.setLong(COL_PURCHASE_ID, purchaseItemShare.getPurchaseId());
			pstPurchaseItemShare.setLong(COL_USER_ID, purchaseItemShare.getUserId());                        
                        pstPurchaseItemShare.setLong(COL_ROOM_CLASS_ID, purchaseItemShare.getRoomClassId());
                        pstPurchaseItemShare.setLong(COL_HOTEL_ROOM_ID, purchaseItemShare.getHotelRoomId());
                        pstPurchaseItemShare.setLong(COL_COA_CREDIT_ID, purchaseItemShare.getCoaCreditId());

			pstPurchaseItemShare.insert(); 
			purchaseItemShare.setOID(pstPurchaseItemShare.getlong(COL_PURCHASE_ITEM_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchaseItemShare(0),CONException.UNKNOWN); 
		}
		return purchaseItemShare.getOID();
	}

	public static long updateExc(PurchaseItemShare purchaseItemShare) throws CONException{ 
		try{ 
			if(purchaseItemShare.getOID() != 0){ 
				DbPurchaseItemShare pstPurchaseItemShare = new DbPurchaseItemShare(purchaseItemShare.getOID());

				pstPurchaseItemShare.setLong(COL_PURCHASE_ITEM_ID, purchaseItemShare.getPurchaseItemId());
                                pstPurchaseItemShare.setDouble(COL_PERCENT, purchaseItemShare.getPercent());
                                pstPurchaseItemShare.setDouble(COL_AMOUNT, purchaseItemShare.getAmount());
                                pstPurchaseItemShare.setLong(COL_COA_ID, purchaseItemShare.getCoaId());
                                pstPurchaseItemShare.setDate(COL_DATE, purchaseItemShare.getDate());
                                pstPurchaseItemShare.setDouble(COL_TOTAL_AMOUNT, purchaseItemShare.getTotalAmount());
                                pstPurchaseItemShare.setLong(COL_PURCHASE_ID, purchaseItemShare.getPurchaseId());
                                pstPurchaseItemShare.setLong(COL_USER_ID, purchaseItemShare.getUserId());                        
                                pstPurchaseItemShare.setLong(COL_ROOM_CLASS_ID, purchaseItemShare.getRoomClassId());
                                pstPurchaseItemShare.setLong(COL_HOTEL_ROOM_ID, purchaseItemShare.getHotelRoomId());
                                pstPurchaseItemShare.setLong(COL_COA_CREDIT_ID, purchaseItemShare.getCoaCreditId());

				pstPurchaseItemShare.update(); 
				return purchaseItemShare.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchaseItemShare(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPurchaseItemShare pstPurchaseItemShare = new DbPurchaseItemShare(oid);
			pstPurchaseItemShare.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchaseItemShare(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PURCHASE_ITEM_SHARE; 
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
				PurchaseItemShare purchaseItemShare = new PurchaseItemShare();
				resultToObject(rs, purchaseItemShare);
				lists.add(purchaseItemShare);
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

	private static void resultToObject(ResultSet rs, PurchaseItemShare purchaseItemShare){
		try{
			purchaseItemShare.setOID(rs.getLong(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_PURCHASE_ITEM_SHARE_ID]));
			purchaseItemShare.setPurchaseItemId(rs.getLong(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_PURCHASE_ITEM_ID]));
			purchaseItemShare.setPercent(rs.getDouble(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_PERCENT]));
			purchaseItemShare.setAmount(rs.getDouble(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_AMOUNT]));
                        purchaseItemShare.setCoaId(rs.getLong(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_COA_ID]));
			purchaseItemShare.setDate(rs.getDate(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_DATE]));
			purchaseItemShare.setTotalAmount(rs.getDouble(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_TOTAL_AMOUNT]));
			purchaseItemShare.setPurchaseId(rs.getLong(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_PURCHASE_ID]));
			purchaseItemShare.setUserId(rs.getLong(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_USER_ID]));
			purchaseItemShare.setRoomClassId(rs.getLong(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_ROOM_CLASS_ID]));                        
                        purchaseItemShare.setHotelRoomId(rs.getLong(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_HOTEL_ROOM_ID]));
                        purchaseItemShare.setCoaCreditId(rs.getLong(DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_COA_CREDIT_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long purchaseItemId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PURCHASE_ITEM_SHARE + " WHERE " + 
						DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_PURCHASE_ITEM_ID] + " = " + purchaseItemId;

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
			String sql = "SELECT COUNT("+ DbPurchaseItemShare.colNames[DbPurchaseItemShare.COL_PURCHASE_ITEM_ID] + ") FROM " + DB_PURCHASE_ITEM_SHARE;
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
			  	   PurchaseItemShare purchaseItemShare = (PurchaseItemShare)list.get(ls);
				   if(oid == purchaseItemShare.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static void deleteItemByPurchaseItemId(long oidPurchaseItem){
                
		try{
                    CONHandler.execUpdate("delete from "+DB_PURCHASE_ITEM_SHARE+" where purchase_item_id="+oidPurchaseItem);
                }
                catch(Exception e){
                    
                }

        }
        
        public static void postJournal(Purchase purchase){
            
            if(purchase.getOID()!=0){
                
                Company comp = DbCompany.getCompany();
                
                ExchangeRate er = DbExchangeRate.getStandardRate();
                
                
                //journal main
                String memo = "Pembelian barang, no : "+purchase.getJournalNumber();
                long oid = DbGl.postJournalMain(0, purchase.getDate(), DbGl.getNextCounter(), DbGl.getNextNumber(DbGl.getNextCounter()), DbGl.getNumberPrefix(), 
                            I_Project.JOURNAL_TYPE_PURCHASE_ORDER, 
                            memo, purchase.getOperatorId(), "", purchase.getOID(), "", purchase.getDate());

                if(oid!=0){
                    
                    Vector items = DbPurchaseItem.list(0,0, DbPurchaseItem.colNames[DbPurchaseItem.COL_PURCHASE_ID]+"="+purchase.getOID(), "");
                    if(items!=null && items.size()>0){
                        for(int ax=0; ax<items.size(); ax++){
                            
                            PurchaseItem pi = (PurchaseItem)items.get(ax);
                            
                            Vector temp = list(0,0, colNames[COL_PURCHASE_ITEM_ID]+"="+pi.getOID(), "");
                            if(temp!=null && temp.size()>0){
                                
                                double payout = 0;
                                
                                for(int x=0; x<temp.size(); x++){                                
                                    
                                    PurchaseItemShare pis = (PurchaseItemShare)temp.get(x);                                    
                                    
                                    Department dep = new Department();
                                    try{
                                        dep = DbDepartment.fetchExc(pis.getHotelRoomId());
                                    }
                                    catch(Exception e){
                                    }
                                    
                                    if(x!=(temp.size()-1)){
                                        //debet expense
                                        memo = "Biaya pembelian : "+pi.getItemName()+", "+dep.getName();
                                        DbGl.postJournalDetail(er.getValueIdr(), pis.getCoaId(), 0, pis.getAmount(),             
                                                    pis.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                                        //journal credit cash
                                        memo = "";
                                        DbGl.postJournalDetail(er.getValueIdr(), pis.getCoaCreditId(), pis.getAmount(), 0,             
                                                pis.getAmount(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                                    }
                                    //yang terakhir
                                    else{
                                        //debet expense
                                        memo = "Biaya pembelian : "+pi.getItemName()+", "+dep.getName();
                                        DbGl.postJournalDetail(er.getValueIdr(), pis.getCoaId(), 0, pis.getTotalAmount()-payout,             
                                                    pis.getTotalAmount()-payout, comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                                        //journal credit cash
                                        memo = "";
                                        DbGl.postJournalDetail(er.getValueIdr(), pis.getCoaCreditId(), pis.getTotalAmount()-payout, 0,             
                                                pis.getTotalAmount()-payout, comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                                    }
                                    
                                    payout = payout + pis.getAmount();

                                }
                            }

                        }
                    }
                    
                }
                
                DbGl.optimizeJournal(oid);
            }
        }
}

