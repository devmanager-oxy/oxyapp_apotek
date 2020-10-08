
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

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
import com.project.fms.master.*;
import com.project.general.*;
import com.project.util.*;
import com.project.*;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;

public class DbPurchase extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_PURCHASES = "purchases";

	public static final  int COL_PURCHASE_ID = 0;
	public static final  int COL_VENDOR_ID = 1;
	public static final  int COL_CURRENCY_ID = 2;
	public static final  int COL_VENDOR_INVOICE_NUMBER = 3;
	public static final  int COL_TERM_OF_PAYMENT_ID = 4;
	public static final  int COL_DATE = 5;
	public static final  int COL_TRANS_DATE = 6;
	public static final  int COL_JOURNAL_NUMBER = 7;
	public static final  int COL_JOURNAL_PREFIX = 8;
	public static final  int COL_JOURNAL_COUNTER = 9;
	public static final  int COL_DUE_DATE = 10;
	public static final  int COL_VAT = 11;
	public static final  int COL_MEMO = 12;
	public static final  int COL_SHIP_ADDRESS_ID = 13;
	public static final  int COL_SHIP_ADDRESS = 14;
	public static final  int COL_DISCOUNT_PERCENT = 15;
	public static final  int COL_DISCOUNT = 16;
	public static final  int COL_VAT_PERCENT = 17;
	public static final  int COL_VAT_AMOUNT = 18;
	public static final  int COL_TOTAL = 19;
	public static final  int COL_STATUS = 20;
        
        public static final  int COL_OPERATOR_ID = 21; 
        public static final  int COL_CLOSING_REASON = 22; 
        public static final  int COL_CLOSED_BY = 23; 
        

	public static final  String[] colNames = {
		"purchase_id",		
		"vendor_id",
		"currency_id",
		"vendor_invoice_number",
		"term_of_payment_id",
		"date",
		"trans_date",
		"journal_number",
		"journal_prefix",
		"journal_counter",
		"due_date",
		"vat",
		"memo",
		"ship_address_id",
		"ship_address",
		"discount_percent",
		"discount",
		"vat_percent",
		"vat_amount",
		"total",
		"status",
                
                "operator_id",
                "closing_reason",
                "closed_by"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_DATE,
		TYPE_INT,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_STRING,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING
	 }; 

	public DbPurchase(){
	}

	public DbPurchase(int i) throws CONException { 
		super(new DbPurchase()); 
	}

	public DbPurchase(String sOid) throws CONException { 
		super(new DbPurchase(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPurchase(long lOid) throws CONException { 
		super(new DbPurchase(0)); 
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
		return DB_PURCHASES;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPurchase().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Purchase purchases = fetchExc(ent.getOID()); 
		ent = (Entity)purchases; 
		return purchases.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Purchase) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Purchase) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Purchase fetchExc(long oid) throws CONException{ 
		try{ 
			Purchase purchases = new Purchase();
			DbPurchase pstPurchase = new DbPurchase(oid); 
			purchases.setOID(oid);

			purchases.setVendorId(pstPurchase.getlong(COL_VENDOR_ID));
			purchases.setCurrencyId(pstPurchase.getlong(COL_CURRENCY_ID));
			purchases.setVendorInvoiceNumber(pstPurchase.getString(COL_VENDOR_INVOICE_NUMBER));
			purchases.setTermOfPaymentId(pstPurchase.getlong(COL_TERM_OF_PAYMENT_ID));
			purchases.setDate(pstPurchase.getDate(COL_DATE));
			purchases.setTransDate(pstPurchase.getDate(COL_TRANS_DATE));
			purchases.setJournalNumber(pstPurchase.getString(COL_JOURNAL_NUMBER));
			purchases.setJournalPrefix(pstPurchase.getString(COL_JOURNAL_PREFIX));
			purchases.setJournalCounter(pstPurchase.getInt(COL_JOURNAL_COUNTER));
			purchases.setDueDate(pstPurchase.getDate(COL_DUE_DATE));
			purchases.setVat(pstPurchase.getInt(COL_VAT));
			purchases.setMemo(pstPurchase.getString(COL_MEMO));
			purchases.setShipAddressId(pstPurchase.getlong(COL_SHIP_ADDRESS_ID));
			purchases.setShipAddress(pstPurchase.getString(COL_SHIP_ADDRESS));
			purchases.setDiscountPercent(pstPurchase.getdouble(COL_DISCOUNT_PERCENT));
			purchases.setDiscount(pstPurchase.getdouble(COL_DISCOUNT));
			purchases.setVatPercent(pstPurchase.getdouble(COL_VAT_PERCENT));
			purchases.setVatAmount(pstPurchase.getdouble(COL_VAT_AMOUNT));
			purchases.setTotal(pstPurchase.getdouble(COL_TOTAL));
			purchases.setStatus(pstPurchase.getString(COL_STATUS));
                        purchases.setOperatorId(pstPurchase.getlong(COL_OPERATOR_ID));
                        
                        purchases.setClosingReason(pstPurchase.getString(COL_CLOSING_REASON));
                        purchases.setClosedBy(pstPurchase.getString(COL_CLOSED_BY));

			return purchases; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchase(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Purchase purchases) throws CONException{ 
		try{ 
			DbPurchase pstPurchase = new DbPurchase(0);

			pstPurchase.setLong(COL_VENDOR_ID, purchases.getVendorId());
			pstPurchase.setLong(COL_CURRENCY_ID, purchases.getCurrencyId());
			pstPurchase.setString(COL_VENDOR_INVOICE_NUMBER, purchases.getVendorInvoiceNumber());
			pstPurchase.setLong(COL_TERM_OF_PAYMENT_ID, purchases.getTermOfPaymentId());
			pstPurchase.setDate(COL_DATE, purchases.getDate());
			pstPurchase.setDate(COL_TRANS_DATE, purchases.getTransDate());
			pstPurchase.setString(COL_JOURNAL_NUMBER, purchases.getJournalNumber());
			pstPurchase.setString(COL_JOURNAL_PREFIX, purchases.getJournalPrefix());
			pstPurchase.setInt(COL_JOURNAL_COUNTER, purchases.getJournalCounter());
			pstPurchase.setDate(COL_DUE_DATE, purchases.getDueDate());
			pstPurchase.setInt(COL_VAT, purchases.getVat());
			pstPurchase.setString(COL_MEMO, purchases.getMemo());
			pstPurchase.setLong(COL_SHIP_ADDRESS_ID, purchases.getShipAddressId());
			pstPurchase.setString(COL_SHIP_ADDRESS, purchases.getShipAddress());
			pstPurchase.setDouble(COL_DISCOUNT_PERCENT, purchases.getDiscountPercent());
			pstPurchase.setDouble(COL_DISCOUNT, purchases.getDiscount());
			pstPurchase.setDouble(COL_VAT_PERCENT, purchases.getVatPercent());
			pstPurchase.setDouble(COL_VAT_AMOUNT, purchases.getVatAmount());
			pstPurchase.setDouble(COL_TOTAL, purchases.getTotal());
			pstPurchase.setString(COL_STATUS, purchases.getStatus());
                        pstPurchase.setLong(COL_OPERATOR_ID, purchases.getOperatorId());
                        
                        pstPurchase.setString(COL_CLOSING_REASON, purchases.getClosingReason());
                        pstPurchase.setString(COL_CLOSED_BY, purchases.getClosedBy());

			pstPurchase.insert(); 
			purchases.setOID(pstPurchase.getlong(COL_PURCHASE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchase(0),CONException.UNKNOWN); 
		}
		return purchases.getOID();
	}

	public static long updateExc(Purchase purchases) throws CONException{ 
		try{ 
			if(purchases.getOID() != 0){ 
				DbPurchase pstPurchase = new DbPurchase(purchases.getOID());

				pstPurchase.setLong(COL_VENDOR_ID, purchases.getVendorId());
				pstPurchase.setLong(COL_CURRENCY_ID, purchases.getCurrencyId());
				pstPurchase.setString(COL_VENDOR_INVOICE_NUMBER, purchases.getVendorInvoiceNumber());
				pstPurchase.setLong(COL_TERM_OF_PAYMENT_ID, purchases.getTermOfPaymentId());
				pstPurchase.setDate(COL_DATE, purchases.getDate());
				pstPurchase.setDate(COL_TRANS_DATE, purchases.getTransDate());
				pstPurchase.setString(COL_JOURNAL_NUMBER, purchases.getJournalNumber());
				pstPurchase.setString(COL_JOURNAL_PREFIX, purchases.getJournalPrefix());
				pstPurchase.setInt(COL_JOURNAL_COUNTER, purchases.getJournalCounter());
				pstPurchase.setDate(COL_DUE_DATE, purchases.getDueDate());
				pstPurchase.setInt(COL_VAT, purchases.getVat());
				pstPurchase.setString(COL_MEMO, purchases.getMemo());
				pstPurchase.setLong(COL_SHIP_ADDRESS_ID, purchases.getShipAddressId());
				pstPurchase.setString(COL_SHIP_ADDRESS, purchases.getShipAddress());
				pstPurchase.setDouble(COL_DISCOUNT_PERCENT, purchases.getDiscountPercent());
				pstPurchase.setDouble(COL_DISCOUNT, purchases.getDiscount());
				pstPurchase.setDouble(COL_VAT_PERCENT, purchases.getVatPercent());
				pstPurchase.setDouble(COL_VAT_AMOUNT, purchases.getVatAmount());
				pstPurchase.setDouble(COL_TOTAL, purchases.getTotal());
				pstPurchase.setString(COL_STATUS, purchases.getStatus());
                                pstPurchase.setLong(COL_OPERATOR_ID, purchases.getOperatorId());
                                
                                pstPurchase.setString(COL_CLOSING_REASON, purchases.getClosingReason());
                                pstPurchase.setString(COL_CLOSED_BY, purchases.getClosedBy());

				pstPurchase.update(); 
				return purchases.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchase(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPurchase pstPurchase = new DbPurchase(oid);
			pstPurchase.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPurchase(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PURCHASES; 
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
				Purchase purchases = new Purchase();
				resultToObject(rs, purchases);
				lists.add(purchases);
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

	public static void resultToObject(ResultSet rs, Purchase purchases){
		try{
			purchases.setOID(rs.getLong(DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID]));
			purchases.setVendorId(rs.getLong(DbPurchase.colNames[DbPurchase.COL_VENDOR_ID]));
			purchases.setCurrencyId(rs.getLong(DbPurchase.colNames[DbPurchase.COL_CURRENCY_ID]));
			purchases.setVendorInvoiceNumber(rs.getString(DbPurchase.colNames[DbPurchase.COL_VENDOR_INVOICE_NUMBER]));
			purchases.setTermOfPaymentId(rs.getLong(DbPurchase.colNames[DbPurchase.COL_TERM_OF_PAYMENT_ID]));
			purchases.setDate(rs.getDate(DbPurchase.colNames[DbPurchase.COL_DATE]));
			purchases.setTransDate(rs.getDate(DbPurchase.colNames[DbPurchase.COL_TRANS_DATE]));
			purchases.setJournalNumber(rs.getString(DbPurchase.colNames[DbPurchase.COL_JOURNAL_NUMBER]));
			purchases.setJournalPrefix(rs.getString(DbPurchase.colNames[DbPurchase.COL_JOURNAL_PREFIX]));
			purchases.setJournalCounter(rs.getInt(DbPurchase.colNames[DbPurchase.COL_JOURNAL_COUNTER]));
			purchases.setDueDate(rs.getDate(DbPurchase.colNames[DbPurchase.COL_DUE_DATE]));
			purchases.setVat(rs.getInt(DbPurchase.colNames[DbPurchase.COL_VAT]));
			purchases.setMemo(rs.getString(DbPurchase.colNames[DbPurchase.COL_MEMO]));
			purchases.setShipAddressId(rs.getLong(DbPurchase.colNames[DbPurchase.COL_SHIP_ADDRESS_ID]));
			purchases.setShipAddress(rs.getString(DbPurchase.colNames[DbPurchase.COL_SHIP_ADDRESS]));
			purchases.setDiscountPercent(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_DISCOUNT_PERCENT]));
			purchases.setDiscount(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_DISCOUNT]));
			purchases.setVatPercent(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_VAT_PERCENT]));
			purchases.setVatAmount(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_VAT_AMOUNT]));
			purchases.setTotal(rs.getDouble(DbPurchase.colNames[DbPurchase.COL_TOTAL]));
			purchases.setStatus(rs.getString(DbPurchase.colNames[DbPurchase.COL_STATUS]));
                        purchases.setOperatorId(rs.getLong(DbPurchase.colNames[DbPurchase.COL_OPERATOR_ID]));
                        
                        purchases.setClosingReason(rs.getString(DbPurchase.colNames[DbPurchase.COL_CLOSING_REASON]));
                        purchases.setClosedBy(rs.getString(DbPurchase.colNames[DbPurchase.COL_CLOSED_BY]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long purchaseId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PURCHASES + " WHERE " + 
						DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID] + " = " + purchaseId;

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
			String sql = "SELECT COUNT("+ DbPurchase.colNames[DbPurchase.COL_PURCHASE_ID] + ") FROM " + DB_PURCHASES;
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
			  	   Purchase purchases = (Purchase)list.get(ls);
				   if(oid == purchases.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static int getNextCounter(){
                int result = 0;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max(journal_counter) from "+DB_PURCHASES+" where "+
                        " journal_prefix='"+getNumberPrefix()+"' ";
                    
                    System.out.println(sql);
                    
                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while(rs.next()){
                        result = rs.getInt(1);
                    }
                    
                    if(result==0){
                        result = result + 1;
                    }
                    else{
                        result = result + 1;
                    }
                    
                }
                catch(Exception e){
                    
                }
                finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
        }
        
        public static String getNumberPrefix(){
            
                Company sysCompany = DbCompany.getCompany();
                Location sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());

                String code = sysLocation.getCode();//DbSystemProperty.getValueByName("LOCATION_CODE");
                code = code + sysCompany.getPurchaseOrderCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");
                
                code = code + JSPFormater.formatDate(new Date(), "MMyy");
                
                return code;
        }
        
        
        public static String getNextNumber(int ctr){
            
                String code = getNumberPrefix();
                
                if(ctr<10){
                    code = code + "000"+ctr;
                }
                else if(ctr<100){
                    code = code + "00"+ctr;
                }
                else if(ctr<1000){
                    code = code + "0"+ctr;
                }
                else{
                    code = code + ctr;
                }
                
                return code;
                
        }
        
        
        //POSTING ke journal
        public static void postJournal(Purchase cr, Vector details){
                Company comp = DbCompany.getCompany();
                ExchangeRate er = DbExchangeRate.getStandardRate();
                /*if(cr.getOID()!=0 && details!=null && details.size()>0){
                    long oid = DbPurchase.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_CASH_RECEIVE, 
                        cr.getMemo(), cr.getOperatorId(), cr.getOperatorName(), cr.getOID(), "", cr.getTransDate());
                    
                    if(oid!=0){
                        for(int i=0; i<details.size(); i++){
                            PurchaseDetail crd = (PurchaseDetail)details.get(i);
                            //journal credit pada pendapatan
                            DbPurchase.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), crd.getAmount(), 0,             
                                    crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo());
                        }
                        
                        //journal debet pada cash
                        DbPurchase.postJournalDetail(er.getValueIdr(), cr.getCoaId(), 0, cr.getAmount(),             
                                    0, comp.getBookingCurrencyId(), oid, cr.getMemo());
                    }
                }*/
        }
        
        
        public static void checkForClosed(Purchase purchase){
            
            Vector purchaseItems = DbPurchaseItem.list(0,0, "purchase_id="+purchase.getOID(), "");
            
            boolean isClosed = false;
            
            if(purchaseItems!=null && purchaseItems.size()>0){
                for(int i=0; i<purchaseItems.size(); i++){
                    PurchaseItem pi = (PurchaseItem)purchaseItems.get(i);
                    double qtyx = DbInvoiceItem.getItemReceived(pi);
                    
                    if(qtyx!=pi.getQty()){
                        isClosed = false;
                        System.out.println("\nitem status not closed - break\n");
                        break;
                    }
                    else{
                        isClosed = true;
                        System.out.println("\nitem status closed\n");
                    }
                }
            }
            
            if(isClosed){
                purchase.setClosedBy("Auto Closed by System");
                purchase.setClosingReason("All item was received as new invoice claimed");
                purchase.setStatus(I_Project.PURCHASE_STATUS_CLOSED);
            }
            else{
                purchase.setClosedBy("");
                purchase.setClosingReason("");    
                purchase.setStatus(I_Project.PURCHASE_STATUS_OPEN);
            }
            
            try{
                DbPurchase.updateExc(purchase);
            }
            catch(Exception e){
            }
            
        }
        
}
