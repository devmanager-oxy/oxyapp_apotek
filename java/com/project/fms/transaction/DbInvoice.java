
package com.project.fms.transaction; 

import java.io.*
;
import java.sql.*
;import java.util.*
;import java.util.Date;
import com.project.util.*;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;

import com.project.fms.transaction.*; 
import com.project.fms.master.*;
import com.project.general.*;
import com.project.*;
import com.project.system.*;
import com.project.general.Currency;
import com.project.general.DbCurrency;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;

public class DbInvoice extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_INVOICE = "invoice";

	public static final  int COL_INVOICE_ID = 0;
	public static final  int COL_DATE = 1;
	public static final  int COL_TRANS_DATE = 2;
	public static final  int COL_MEMO = 3;
	public static final  int COL_JOURNAL_NUMBER = 4;
	public static final  int COL_JOURNAL_PREFIX = 5;
	public static final  int COL_VENDOR_INVOICE_NUMBER = 6;
	public static final  int COL_PURCHASE_ID = 7;
	public static final  int COL_JOURNAL_COUNTER = 8;
	public static final  int COL_VENDOR_ID = 9;
	public static final  int COL_CURRENCY_ID = 10;
	public static final  int COL_STATUS = 11;
	public static final  int COL_OPERATOR_ID = 12;
        public static final  int COL_DUE_DATE    = 13;
        
        public static final  int COL_VAT_AMOUNT    = 14;
        public static final  int COL_VAT_PERCENT    = 15;
        public static final  int COL_APPLY_VAT    = 16;
        public static final  int COL_SUB_TOTAL    = 17;
        public static final  int COL_GRAND_TOTAL    = 18;
        public static final  int COL_ACTIVITY_STATUS = 19;

	public static final  String[] colNames = {
		"invoice_id",
		"date",
		"trans_date",
		"memo",
		"journal_number",
		"journal_prefix",
		"vendor_invoice_number",
		"purchase_id",
		"journal_counter",
		"vendor_id",
		"currency_id",
		"status",
		"operator_id",
                "due_date",
                
                "vat_amount",
                "vat_percent",
                "apply_vat",
                "sub_total",
                "grand_total",
                "activity_status"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_LONG,
                TYPE_DATE,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_STRING
	 }; 

	public DbInvoice(){
	}

	public DbInvoice(int i) throws CONException { 
		super(new DbInvoice()); 
	}

	public DbInvoice(String sOid) throws CONException { 
		super(new DbInvoice(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbInvoice(long lOid) throws CONException { 
		super(new DbInvoice(0)); 
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
		return DB_INVOICE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbInvoice().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Invoice invoice = fetchExc(ent.getOID()); 
		ent = (Entity)invoice; 
		return invoice.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Invoice) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Invoice) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Invoice fetchExc(long oid) throws CONException{ 
		try{ 
			Invoice invoice = new Invoice();
			DbInvoice pstInvoice = new DbInvoice(oid); 
			invoice.setOID(oid);

			invoice.setDate(pstInvoice.getDate(COL_DATE));
			invoice.setTransDate(pstInvoice.getDate(COL_TRANS_DATE));
			invoice.setMemo(pstInvoice.getString(COL_MEMO));
			invoice.setJournalNumber(pstInvoice.getString(COL_JOURNAL_NUMBER));
			invoice.setJournalPrefix(pstInvoice.getString(COL_JOURNAL_PREFIX));
			invoice.setVendorInvoiceNumber(pstInvoice.getString(COL_VENDOR_INVOICE_NUMBER));
			invoice.setPurchaseId(pstInvoice.getlong(COL_PURCHASE_ID));
			invoice.setJournalCounter(pstInvoice.getInt(COL_JOURNAL_COUNTER));
			invoice.setVendorId(pstInvoice.getlong(COL_VENDOR_ID));
			invoice.setCurrencyId(pstInvoice.getlong(COL_CURRENCY_ID));
			invoice.setStatus(pstInvoice.getString(COL_STATUS));
			invoice.setOperatorId(pstInvoice.getlong(COL_OPERATOR_ID));
                        invoice.setDueDate(pstInvoice.getDate(COL_DUE_DATE));
                        
                        invoice.setVatAmount(pstInvoice.getdouble(COL_VAT_AMOUNT));
                        invoice.setVatPercent(pstInvoice.getdouble(COL_VAT_PERCENT));
                        invoice.setApplyVat(pstInvoice.getInt(COL_APPLY_VAT));
                        invoice.setSubTotal(pstInvoice.getdouble(COL_SUB_TOTAL));
                        invoice.setGrandTotal(pstInvoice.getdouble(COL_GRAND_TOTAL));
                        
                        invoice.setActivityStatus(pstInvoice.getString(COL_ACTIVITY_STATUS));

			return invoice; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInvoice(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Invoice invoice) throws CONException{ 
		try{ 
			DbInvoice pstInvoice = new DbInvoice(0);

			pstInvoice.setDate(COL_DATE, invoice.getDate());
			pstInvoice.setDate(COL_TRANS_DATE, invoice.getTransDate());
			pstInvoice.setString(COL_MEMO, invoice.getMemo());
			pstInvoice.setString(COL_JOURNAL_NUMBER, invoice.getJournalNumber());
			pstInvoice.setString(COL_JOURNAL_PREFIX, invoice.getJournalPrefix());
			pstInvoice.setString(COL_VENDOR_INVOICE_NUMBER, invoice.getVendorInvoiceNumber());
			pstInvoice.setLong(COL_PURCHASE_ID, invoice.getPurchaseId());
			pstInvoice.setInt(COL_JOURNAL_COUNTER, invoice.getJournalCounter());
			pstInvoice.setLong(COL_VENDOR_ID, invoice.getVendorId());
			pstInvoice.setLong(COL_CURRENCY_ID, invoice.getCurrencyId());
			pstInvoice.setString(COL_STATUS, invoice.getStatus());
			pstInvoice.setLong(COL_OPERATOR_ID, invoice.getOperatorId());
                        pstInvoice.setDate(COL_DUE_DATE, invoice.getDueDate());
                        
                        pstInvoice.setDouble(COL_VAT_AMOUNT, invoice.getVatAmount());
                        pstInvoice.setDouble(COL_VAT_PERCENT, invoice.getVatPercent());
                        pstInvoice.setInt(COL_APPLY_VAT, invoice.getApplyVat());
                        pstInvoice.setDouble(COL_SUB_TOTAL, invoice.getSubTotal());
                        pstInvoice.setDouble(COL_GRAND_TOTAL, invoice.getGrandTotal());                        
                        pstInvoice.setString(COL_ACTIVITY_STATUS, invoice.getActivityStatus());                        

			pstInvoice.insert(); 
			invoice.setOID(pstInvoice.getlong(COL_INVOICE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInvoice(0),CONException.UNKNOWN); 
		}
		return invoice.getOID();
	}

	public static long updateExc(Invoice invoice) throws CONException{ 
		try{ 
			if(invoice.getOID() != 0){ 
				DbInvoice pstInvoice = new DbInvoice(invoice.getOID());

				pstInvoice.setDate(COL_DATE, invoice.getDate());
				pstInvoice.setDate(COL_TRANS_DATE, invoice.getTransDate());
				pstInvoice.setString(COL_MEMO, invoice.getMemo());
				pstInvoice.setString(COL_JOURNAL_NUMBER, invoice.getJournalNumber());
				pstInvoice.setString(COL_JOURNAL_PREFIX, invoice.getJournalPrefix());
				pstInvoice.setString(COL_VENDOR_INVOICE_NUMBER, invoice.getVendorInvoiceNumber());
				pstInvoice.setLong(COL_PURCHASE_ID, invoice.getPurchaseId());
				pstInvoice.setInt(COL_JOURNAL_COUNTER, invoice.getJournalCounter());
				pstInvoice.setLong(COL_VENDOR_ID, invoice.getVendorId());
				pstInvoice.setLong(COL_CURRENCY_ID, invoice.getCurrencyId());
				pstInvoice.setString(COL_STATUS, invoice.getStatus());
				pstInvoice.setLong(COL_OPERATOR_ID, invoice.getOperatorId());
                                pstInvoice.setDate(COL_DUE_DATE, invoice.getDueDate());
                                
                                pstInvoice.setDouble(COL_VAT_AMOUNT, invoice.getVatAmount());
                                pstInvoice.setDouble(COL_VAT_PERCENT, invoice.getVatPercent());
                                pstInvoice.setInt(COL_APPLY_VAT, invoice.getApplyVat());
                                pstInvoice.setDouble(COL_SUB_TOTAL, invoice.getSubTotal());
                                pstInvoice.setDouble(COL_GRAND_TOTAL, invoice.getGrandTotal());                        
                                pstInvoice.setString(COL_ACTIVITY_STATUS, invoice.getActivityStatus());                        

				pstInvoice.update(); 
				return invoice.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInvoice(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbInvoice pstInvoice = new DbInvoice(oid);
			pstInvoice.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInvoice(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_INVOICE; 
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
				Invoice invoice = new Invoice();
				resultToObject(rs, invoice);
				lists.add(invoice);
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

	public static void resultToObject(ResultSet rs, Invoice invoice){
		try{
			invoice.setOID(rs.getLong(DbInvoice.colNames[DbInvoice.COL_INVOICE_ID]));
			invoice.setDate(rs.getDate(DbInvoice.colNames[DbInvoice.COL_DATE]));
			invoice.setTransDate(rs.getDate(DbInvoice.colNames[DbInvoice.COL_TRANS_DATE]));
			invoice.setMemo(rs.getString(DbInvoice.colNames[DbInvoice.COL_MEMO]));
			invoice.setJournalNumber(rs.getString(DbInvoice.colNames[DbInvoice.COL_JOURNAL_NUMBER]));
			invoice.setJournalPrefix(rs.getString(DbInvoice.colNames[DbInvoice.COL_JOURNAL_PREFIX]));
			invoice.setVendorInvoiceNumber(rs.getString(DbInvoice.colNames[DbInvoice.COL_VENDOR_INVOICE_NUMBER]));
			invoice.setPurchaseId(rs.getLong(DbInvoice.colNames[DbInvoice.COL_PURCHASE_ID]));
			invoice.setJournalCounter(rs.getInt(DbInvoice.colNames[DbInvoice.COL_JOURNAL_COUNTER]));
			invoice.setVendorId(rs.getLong(DbInvoice.colNames[DbInvoice.COL_VENDOR_ID]));
			invoice.setCurrencyId(rs.getLong(DbInvoice.colNames[DbInvoice.COL_CURRENCY_ID]));
			invoice.setStatus(rs.getString(DbInvoice.colNames[DbInvoice.COL_STATUS]));
			invoice.setOperatorId(rs.getLong(DbInvoice.colNames[DbInvoice.COL_OPERATOR_ID]));
                        invoice.setDueDate(rs.getDate(DbInvoice.colNames[DbInvoice.COL_DUE_DATE]));
                        
                        invoice.setVatAmount(rs.getDouble(DbInvoice.colNames[DbInvoice.COL_VAT_AMOUNT]));
                        invoice.setVatPercent(rs.getDouble(DbInvoice.colNames[DbInvoice.COL_VAT_PERCENT]));
                        invoice.setApplyVat(rs.getInt(DbInvoice.colNames[DbInvoice.COL_APPLY_VAT]));
                        invoice.setSubTotal(rs.getDouble(DbInvoice.colNames[DbInvoice.COL_SUB_TOTAL]));
                        invoice.setGrandTotal(rs.getDouble(DbInvoice.colNames[DbInvoice.COL_GRAND_TOTAL]));
                        invoice.setActivityStatus(rs.getString(DbInvoice.colNames[DbInvoice.COL_ACTIVITY_STATUS]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long invoiceId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_INVOICE + " WHERE " + 
						DbInvoice.colNames[DbInvoice.COL_INVOICE_ID] + " = " + invoiceId;

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
			String sql = "SELECT COUNT("+ DbInvoice.colNames[DbInvoice.COL_INVOICE_ID] + ") FROM " + DB_INVOICE;
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
			  	   Invoice invoice = (Invoice)list.get(ls);
				   if(oid == invoice.getOID())
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
                    String sql = "select max(journal_counter) from "+DB_INVOICE+" where "+
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
                code = code + sysCompany.getInvoiceCode();//DbSystemProperty.getValueByName("JOURNAL_RECEIPT_CODE");
                
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
        
        public static long postJournal(Invoice invoice){
                long oid = 0;
                Company comp = DbCompany.getCompany();
                ExchangeRate er = DbExchangeRate.getStandardRate();
                
                //String IDRCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
                String USDCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_USD");
                String EURCODE = DbSystemProperty.getValueByName("CURRENCY_CODE_EUR");
                
                double excRate = er.getValueIdr();
                
                if(invoice.getCurrencyId()!=comp.getBookingCurrencyId()){
                    
                    Currency c = new Currency();
                    try{
                        c = DbCurrency.fetchExc(invoice.getCurrencyId());
                    }
                    catch(Exception e){
                        
                    }
                    
                    if(c.getCurrencyCode().equals(USDCODE)){
                        excRate = er.getValueUsd();
                    }
                    else{
                        excRate = er.getValueEuro();
                    }
                }
                
                Vector susAccounts = DbAccLink.list(0,1, "type='"+I_Project.ACC_LINK_GROUP_SUSPENSE_ACCOUNT+"' and location_id="+comp.getSystemLocation(), "");
                AccLink acSuspense = new AccLink();
                if(susAccounts!=null && susAccounts.size()>0){
                    acSuspense = (AccLink)susAccounts.get(0);
                }
                
                susAccounts = DbAccLink.list(0,1, "type='"+I_Project.ACC_LINK_GROUP_PURCHASING_TAX+"' and location_id="+comp.getSystemLocation(), "");
                AccLink acPpn = new AccLink();
                if(susAccounts!=null && susAccounts.size()>0){
                    acPpn = (AccLink)susAccounts.get(0);
                }
                
                Vector details = DbInvoiceItem.list(0,0, "invoice_id="+invoice.getOID(), "");
                
                if(invoice.getOID()!=0 && details!=null && details.size()>0){
                    oid = DbGl.postJournalMain(0, invoice.getDate(), invoice.getJournalCounter(), invoice.getJournalNumber(), invoice.getJournalPrefix(), I_Project.JOURNAL_TYPE_INVOICE, 
                        invoice.getMemo(), invoice.getOperatorId(), "", invoice.getOID(), "", invoice.getTransDate());
                    
                    if(oid!=0){
                                                
                        //journal debet pada PPN kalau ada
                        /*if(invoice.getVatAmount()>0){
                            if(invoice.getCurrencyId()!=comp.getBookingCurrencyId()){
                                //journal debet inventory (pembelian)
                                DbGl.postJournalDetail(excRate, acPpn.getCoaId(), 0, excRate * invoice.getVatAmount(),             
                                        invoice.getVatAmount(), invoice.getCurrencyId(), oid, invoice.getMemo(), 0);
                            }
                            else{
                                //journal debet inventory (pembelian)
                                DbGl.postJournalDetail(excRate, acPpn.getCoaId(), 0, invoice.getVatAmount(),             
                                        invoice.getVatAmount(), invoice.getCurrencyId(), oid, invoice.getMemo(), 0);
                            }
                        }*/
                        
                        for(int i=0; i<details.size(); i++){
                            InvoiceItem crd = (InvoiceItem)details.get(i);
                            if(invoice.getCurrencyId()!=comp.getBookingCurrencyId()){
                                //journal debet inventory (pembelian)
                                DbGl.postJournalDetail(excRate, crd.getCoaId(), 0, excRate * (crd.getTotal()+(invoice.getVatPercent()*crd.getTotal()/100)),             
                                        (crd.getTotal()+(invoice.getVatPercent()*crd.getTotal()/100)), invoice.getCurrencyId(), oid, crd.getMemo(), crd.getDepartmentId());
                            }
                            else{
                                //journal debet inventory (pembelian)
                                DbGl.postJournalDetail(excRate, crd.getCoaId(), 0, crd.getTotal()+(invoice.getVatPercent()*crd.getTotal()/100),             
                                        crd.getTotal()+(invoice.getVatPercent()*crd.getTotal()/100), invoice.getCurrencyId(), oid, crd.getMemo(), crd.getDepartmentId());
                            }
                            
                        }
                        
                        //journal credit pada suspense account
                        if(invoice.getCurrencyId()!=comp.getBookingCurrencyId()){
                            DbGl.postJournalDetail(excRate, acSuspense.getCoaId(), excRate * invoice.getGrandTotal(), 0,             
                                        invoice.getGrandTotal(), invoice.getCurrencyId(), oid, invoice.getMemo(), 0);
                        }
                        else{
                            DbGl.postJournalDetail(excRate, acSuspense.getCoaId(), invoice.getGrandTotal(), 0,             
                                        invoice.getGrandTotal(), invoice.getCurrencyId(), oid, invoice.getMemo(), 0);
                        }
                    }
                }
                
                return oid;
            //return 10;
        }
        
        
        public static double getInvoiceBalance(long invoiceId){
            double result = 0;
            CONResultSet crs = null;
            try{
                String sql = "select sum("+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT]+") from "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+
                    " where "+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID]+"="+invoiceId;
                
                System.out.println(sql);
                
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
            
            Invoice inv = new Invoice();
            try{
                inv = DbInvoice.fetchExc(invoiceId);
            }
            catch(Exception e){
                
            }
            
            result = inv.getGrandTotal() - result;
            
            return result;
        }
        
        
        public static void postActivityStatus(long oidFlag, long oidInvoice){
            try{
                
                Invoice pp = DbInvoice.fetchExc(oidInvoice);
                if(oidFlag==0){
                    pp.setActivityStatus(I_Project.STATUS_NOT_POSTED);
                }
                else{
                    pp.setActivityStatus(I_Project.STATUS_POSTED);
                }
                
                DbInvoice.updateExc(pp);
                
            }
            catch(Exception e){
                
            }
            
        }
        
        public static void checkForClosed(long bankpoPayementOID, Vector vBPD){
                        
            boolean isClosed = false;
            
            if(vBPD!=null && vBPD.size()>0){
                for(int i=0; i<vBPD.size(); i++){
                    BankpoPaymentDetail pi = (BankpoPaymentDetail)vBPD.get(i);
                    double payInv = DbBankpoPayment.getTotalPaymentByInvoice(pi.getInvoiceId());
                    Invoice inv = new Invoice();
                    try{
                        inv = DbInvoice.fetchExc(pi.getInvoiceId());
                    } catch (Exception e)
                    {
                        System.out.println(e);
                    }
                    double totInv = inv.getGrandTotal();                   
                    System.out.println("payInv = "+payInv);
                    System.out.println("totInv = "+totInv);
                    
                    if(payInv!=totInv){
                        isClosed = false;
                        System.out.println("\nitem status not closed - break\n");
                        
                    }
                    else{
                        isClosed = true;
                        System.out.println("\nitem status closed\n");
                        inv.setStatus(I_Project.PURCHASE_STATUS_CLOSED);
                        try{
                            DbInvoice.updateExc(inv);
                        }
                        catch(Exception e){
                            System.out.println(e);
                        }
                    }
                }
            }
        }

        
}
