
package com.project.fms.ar;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.fms.master.*;
import com.project.fms.transaction.*;
import com.project.I_Project;
import com.project.admin.*;
import com.project.crm.project.*;
import com.project.crm.I_Crm;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;


public class DbArPayment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

	public static final  String DB_AR_PAYMENT = "ar_payment";

	public static final  int COL_AR_PAYMENT_ID = 0;
	public static final  int COL_AR_INVOICE_ID = 1;
	public static final  int COL_CURRENCY_ID = 2;
	public static final  int COL_EXCHANGE_RATE = 3;
	public static final  int COL_AMOUNT = 4;
	public static final  int COL_CUSTOMER_ID = 5;
	public static final  int COL_DATE = 6;
	public static final  int COL_NOTES = 7;
	public static final  int COL_AR_CURRENCY_AMOUNT = 8;
	public static final  int COL_COMPANY_ID = 9;
	public static final  int COL_JOURNAL_NUMBER = 10;
	public static final  int COL_JOURNAL_NUMBER_PREFIX = 11;
	public static final  int COL_COUNTER = 12;
	public static final  int COL_PROJECT_ID = 13;
	public static final  int COL_PROJECT_TERM_ID = 14;
	public static final  int COL_AR_ACCOUNT_ID = 15;
	public static final  int COL_RECEIPT_ACCOUNT_ID = 16;
	public static final  int COL_BANK_TRANSFER_NUMBER = 17;        
	public static final  int COL_TRANSACTION_DATE = 18;
	public static final  int COL_OPERATOR_ID = 19;        
        public static final  int COL_REF_ID = 20;        
        public static final  int COL_CREDIT_PAYMENT_ID = 21;       
        
	public static final  String[] colNames = {
		"ar_payment_id",
		"ar_invoice_id",
		"currency_id",
		"exchange_rate",
		"amount",
		"customer_id",
		"date",
		"notes",
		"ar_currency_amount",
		"company_id",
		"journal_number",
		"journal_number_prefix",
		"counter",
		"project_id",
		"project_term_id",
		"ar_account_id",
		"receipt_account_id",
		"bank_transfer_number",                
                "transaction_date",
                "operator_id",
                "ref_id",
                "credit_payment_id"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,                
                TYPE_DATE,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	};

	public DbArPayment(){
	}

	public DbArPayment(int i) throws CONException {
		super(new DbArPayment());
	}

	public DbArPayment(String sOid) throws CONException {
		super(new DbArPayment(0));
		if(!locate(sOid))
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		else
			return;
	}

	public DbArPayment(long lOid) throws CONException {
		super(new DbArPayment(0));
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
		return DB_AR_PAYMENT;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbArPayment().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception {
		ArPayment arpayment = fetchExc(ent.getOID());
		ent = (Entity)arpayment;
		return arpayment.getOID();
	}

	public long insertExc(Entity ent) throws Exception {
		return insertExc((ArPayment) ent);
	}

	public long updateExc(Entity ent) throws Exception {
		return updateExc((ArPayment) ent);
	}

	public long deleteExc(Entity ent) throws Exception {
		if(ent==null){
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		}
			return deleteExc(ent.getOID());
	}

	public static ArPayment fetchExc(long oid) throws CONException{
		try{
			ArPayment arpayment = new ArPayment();
			DbArPayment dbArPayment = new DbArPayment(oid);
			arpayment.setOID(oid);

			arpayment.setArInvoiceId(dbArPayment.getlong(COL_AR_INVOICE_ID));
			arpayment.setCurrencyId(dbArPayment.getlong(COL_CURRENCY_ID));
			arpayment.setExchangeRate(dbArPayment.getdouble(COL_EXCHANGE_RATE));
			arpayment.setAmount(dbArPayment.getdouble(COL_AMOUNT));
			arpayment.setCustomerId(dbArPayment.getlong(COL_CUSTOMER_ID));
			arpayment.setDate(dbArPayment.getDate(COL_DATE));
			arpayment.setNotes(dbArPayment.getString(COL_NOTES));
			arpayment.setArCurrencyAmount(dbArPayment.getdouble(COL_AR_CURRENCY_AMOUNT));
			arpayment.setCompanyId(dbArPayment.getlong(COL_COMPANY_ID));
			arpayment.setJournalNumber(dbArPayment.getString(COL_JOURNAL_NUMBER));
			arpayment.setJournalNumberPrefix(dbArPayment.getString(COL_JOURNAL_NUMBER_PREFIX));
			arpayment.setCounter(dbArPayment.getInt(COL_COUNTER));
			arpayment.setProjectId(dbArPayment.getlong(COL_PROJECT_ID));
			arpayment.setProjectTermId(dbArPayment.getlong(COL_PROJECT_TERM_ID));
			arpayment.setArAccountId(dbArPayment.getlong(COL_AR_ACCOUNT_ID));
			arpayment.setReceiptAccountId(dbArPayment.getlong(COL_RECEIPT_ACCOUNT_ID));
			arpayment.setBankTransferNumber(dbArPayment.getString(COL_BANK_TRANSFER_NUMBER));                        
                        arpayment.setTransactionDate(dbArPayment.getDate(COL_TRANSACTION_DATE));
                        arpayment.setOperatorId(dbArPayment.getlong(COL_OPERATOR_ID));
                        arpayment.setRefId(dbArPayment.getlong(COL_REF_ID));
                        arpayment.setCreditPaymentId(dbArPayment.getlong(COL_CREDIT_PAYMENT_ID));

			return arpayment;
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbArPayment(0),CONException.UNKNOWN);
		}
	}

	public static long insertExc(ArPayment arpayment) throws CONException{
		try{
			DbArPayment dbArPayment = new DbArPayment(0);

			dbArPayment.setLong(COL_AR_INVOICE_ID, arpayment.getArInvoiceId());
			dbArPayment.setLong(COL_CURRENCY_ID, arpayment.getCurrencyId());
			dbArPayment.setDouble(COL_EXCHANGE_RATE, arpayment.getExchangeRate());
			dbArPayment.setDouble(COL_AMOUNT, arpayment.getAmount());
			dbArPayment.setLong(COL_CUSTOMER_ID, arpayment.getCustomerId());
			dbArPayment.setDate(COL_DATE, arpayment.getDate());
			dbArPayment.setString(COL_NOTES, arpayment.getNotes());
			dbArPayment.setDouble(COL_AR_CURRENCY_AMOUNT, arpayment.getArCurrencyAmount());
			dbArPayment.setLong(COL_COMPANY_ID, arpayment.getCompanyId());
			dbArPayment.setString(COL_JOURNAL_NUMBER, arpayment.getJournalNumber());
			dbArPayment.setString(COL_JOURNAL_NUMBER_PREFIX, arpayment.getJournalNumberPrefix());
			dbArPayment.setInt(COL_COUNTER, arpayment.getCounter());
			dbArPayment.setLong(COL_PROJECT_ID, arpayment.getProjectId());
			dbArPayment.setLong(COL_PROJECT_TERM_ID, arpayment.getProjectTermId());
			dbArPayment.setLong(COL_AR_ACCOUNT_ID, arpayment.getArAccountId());
			dbArPayment.setLong(COL_RECEIPT_ACCOUNT_ID, arpayment.getReceiptAccountId());
			dbArPayment.setString(COL_BANK_TRANSFER_NUMBER, arpayment.getBankTransferNumber());                        
                        dbArPayment.setDate(COL_TRANSACTION_DATE, arpayment.getTransactionDate());
                        dbArPayment.setLong(COL_OPERATOR_ID, arpayment.getOperatorId());
                        dbArPayment.setLong(COL_REF_ID, arpayment.getRefId());
                        dbArPayment.setLong(COL_CREDIT_PAYMENT_ID, arpayment.getCreditPaymentId());

			dbArPayment.insert();
			arpayment.setOID(dbArPayment.getlong(COL_AR_PAYMENT_ID));
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbArPayment(0),CONException.UNKNOWN);
		}
		return arpayment.getOID();
	}

	public static long updateExc(ArPayment arpayment) throws CONException{
		try{
			if(arpayment.getOID() != 0){
				DbArPayment dbArPayment = new DbArPayment(arpayment.getOID());

				dbArPayment.setLong(COL_AR_INVOICE_ID, arpayment.getArInvoiceId());
				dbArPayment.setLong(COL_CURRENCY_ID, arpayment.getCurrencyId());
				dbArPayment.setDouble(COL_EXCHANGE_RATE, arpayment.getExchangeRate());
				dbArPayment.setDouble(COL_AMOUNT, arpayment.getAmount());
				dbArPayment.setLong(COL_CUSTOMER_ID, arpayment.getCustomerId());
				dbArPayment.setDate(COL_DATE, arpayment.getDate());
				dbArPayment.setString(COL_NOTES, arpayment.getNotes());
				dbArPayment.setDouble(COL_AR_CURRENCY_AMOUNT, arpayment.getArCurrencyAmount());
				dbArPayment.setLong(COL_COMPANY_ID, arpayment.getCompanyId());
				dbArPayment.setString(COL_JOURNAL_NUMBER, arpayment.getJournalNumber());
				dbArPayment.setString(COL_JOURNAL_NUMBER_PREFIX, arpayment.getJournalNumberPrefix());
				dbArPayment.setInt(COL_COUNTER, arpayment.getCounter());
				dbArPayment.setLong(COL_PROJECT_ID, arpayment.getProjectId());
				dbArPayment.setLong(COL_PROJECT_TERM_ID, arpayment.getProjectTermId());
				dbArPayment.setLong(COL_AR_ACCOUNT_ID, arpayment.getArAccountId());
				dbArPayment.setLong(COL_RECEIPT_ACCOUNT_ID, arpayment.getReceiptAccountId());
				dbArPayment.setString(COL_BANK_TRANSFER_NUMBER, arpayment.getBankTransferNumber());
                                dbArPayment.setDate(COL_TRANSACTION_DATE, arpayment.getTransactionDate());
                                dbArPayment.setLong(COL_OPERATOR_ID, arpayment.getOperatorId());
                                dbArPayment.setLong(COL_REF_ID, arpayment.getRefId());
                                dbArPayment.setLong(COL_CREDIT_PAYMENT_ID, arpayment.getCreditPaymentId());
                                
				dbArPayment.update();
				return arpayment.getOID();

			}
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbArPayment(0),CONException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{
		try{
			DbArPayment dbArPayment = new DbArPayment(oid);
			dbArPayment.delete();
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbArPayment(0),CONException.UNKNOWN);
		}
		return oid;
	}

	public static Vector listAll()
	{
		return list(0, 500, "","");
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector();
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_AR_PAYMENT;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;

						switch (CONHandler.CONSVR_TYPE) {
							case CONHandler.CONSVR_MYSQL:
								if (limitStart == 0 && recordToGet == 0)
									sql = sql + "";
								else
									sql = sql + " LIMIT " + limitStart + "," + recordToGet;
								break;

							case CONHandler.CONSVR_POSTGRESQL:
								if (limitStart == 0 && recordToGet == 0)
									sql = sql + "";
								else
									sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
								break;

							case CONHandler.CONSVR_SYBASE:
								break;

							case CONHandler.CONSVR_ORACLE:
								break;

							case CONHandler.CONSVR_MSSQL:
								break;

							default:
								break;
						}

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				ArPayment arpayment = new ArPayment();
				resultToObject(rs, arpayment);
				lists.add(arpayment);
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

	public static void resultToObject(ResultSet rs, ArPayment arpayment){
		try{

			arpayment.setOID(rs.getLong(DbArPayment.colNames[DbArPayment.COL_AR_PAYMENT_ID]));
			arpayment.setArInvoiceId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_AR_INVOICE_ID]));
			arpayment.setCurrencyId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_CURRENCY_ID]));
			arpayment.setExchangeRate(rs.getDouble(DbArPayment.colNames[DbArPayment.COL_EXCHANGE_RATE]));
			arpayment.setAmount(rs.getDouble(DbArPayment.colNames[DbArPayment.COL_AMOUNT]));
			arpayment.setCustomerId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_CUSTOMER_ID]));
			arpayment.setDate(rs.getDate(DbArPayment.colNames[DbArPayment.COL_DATE]));
			arpayment.setNotes(rs.getString(DbArPayment.colNames[DbArPayment.COL_NOTES]));
			arpayment.setArCurrencyAmount(rs.getDouble(DbArPayment.colNames[DbArPayment.COL_AR_CURRENCY_AMOUNT]));
			arpayment.setCompanyId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_COMPANY_ID]));
			arpayment.setJournalNumber(rs.getString(DbArPayment.colNames[DbArPayment.COL_JOURNAL_NUMBER]));
			arpayment.setJournalNumberPrefix(rs.getString(DbArPayment.colNames[DbArPayment.COL_JOURNAL_NUMBER_PREFIX]));
			arpayment.setCounter(rs.getInt(DbArPayment.colNames[DbArPayment.COL_COUNTER]));
			arpayment.setProjectId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_PROJECT_ID]));
			arpayment.setProjectTermId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_PROJECT_TERM_ID]));
			arpayment.setArAccountId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_AR_ACCOUNT_ID]));
			arpayment.setReceiptAccountId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_RECEIPT_ACCOUNT_ID]));
			arpayment.setBankTransferNumber(rs.getString(DbArPayment.colNames[DbArPayment.COL_BANK_TRANSFER_NUMBER]));                        
                        arpayment.setTransactionDate(rs.getDate(DbArPayment.colNames[DbArPayment.COL_TRANSACTION_DATE]));
                        arpayment.setOperatorId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_OPERATOR_ID]));
                        arpayment.setRefId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_REF_ID]));
                        arpayment.setCreditPaymentId(rs.getLong(DbArPayment.colNames[DbArPayment.COL_CREDIT_PAYMENT_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long arPaymentId)
	{
		CONResultSet dbrs = null;
		boolean result = false;
		try
		{
			String sql = "SELECT * FROM " + DB_AR_PAYMENT + " WHERE " + 
				DbArPayment.colNames[DbArPayment.COL_AR_PAYMENT_ID] + " = " + arPaymentId;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) { result = true; }
			rs.close();
		}
		catch(Exception e)
		{
			System.out.println("err : "+e.toString());
		}
		finally
		{
			CONResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbArPayment.colNames[DbArPayment.COL_AR_PAYMENT_ID] + ") FROM " + DB_AR_PAYMENT;
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
				ArPayment arpayment = (ArPayment)list.get(ls);
				if(oid == arpayment.getOID())
					found=true;
				}
			}
		}
		if((start >= size) && (size > 0))
			start = start - recordToGet;

		return start;
	}

        public static int getNextCounter(long systemCompanyId){
                int result = 0;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max(counter) from "+DB_AR_PAYMENT+" where "+
                        " journal_number_prefix='"+getNumberPrefix(systemCompanyId)+"' ";
                    
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
                    System.out.println(e);
                }
                finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
        }
        
        public static String getNumberPrefix(long systemCompanyId){
                
                Company sysCompany = new Company();
                try {
                    sysCompany  = DbCompany.fetchExc(systemCompanyId);
                }catch(Exception e){
                    System.out.println(e);
                }

                Location sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());                
                String code = sysLocation.getCode();
                code = code + sysCompany.getPaymentCode();
                code = code + JSPFormater.formatDate(new Date(), "MMyy");
                
                return code;
        }

        public static String getNextNumber(int ctr, long systemCompanyId){
            
                String code = getNumberPrefix(systemCompanyId);
                
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

        
        //posting ke journal
        public static void postJournal(long arPaymentId){
               
            ArPayment arPay = new ArPayment();
            try{
                arPay = DbArPayment.fetchExc(arPaymentId);
            }
            catch(Exception e){
                System.out.println(e);
            }
            
            //Load Customer
            Customer cust = new Customer();
            try{
                cust = DbCustomer.fetchExc(arPay.getCustomerId());
            }catch (Exception e){
                System.out.println(e);
            }
            
            //Load Project
            Project proj = new Project();
            try{
                proj = DbProject.fetchExc(arPay.getProjectId());
            }catch(Exception e){
                System.out.println(e);
            }

            // Load AR Invoice
            ARInvoice arInv = new ARInvoice();
            try{
                arInv = DbARInvoice.fetchExc(arPay.getArInvoiceId());
            }catch (Exception e){
                System.out.println(e);
            }
            
            // load Company
            Company comp = new Company();
            try{
                comp = DbCompany.fetchExc(arPay.getCompanyId());
            }catch(Exception e){
                System.out.println(e);
            }
            
            //Load User
            User u = new User();
            try{
                u = DbUser.fetch(arPay.getOperatorId());
            }catch(Exception e){
                System.out.println(e);
            }

            if(arPay.getOID()!=0){

                long oid = 0;//DbGl.postJournalMain(0, arPay.getDate(), arPay.getCounter(), arPay.getJournalNumber(), arPay.getJournalNumberPrefix(), I_Project.JOURNAL_TYPE_SALES, 
                    //"Payment from "+ cust.getCode()+"/"+cust.getName()+" for Project Number : "+ proj.getNumber()+" and Invoice Number : "+ arInv.getInvoiceNumber(), arPay.getOperatorId(), u.getFullName(), arPay.getOID(), "", arPay.getTransactionDate());
                    
                // Format Memo : Payment from + Customer Code + Customer Name + for Project Number + Invoice Number
                if(oid!=0){

                   //Debet Cash
                   //DbGl.postJournalDetail(arPay.getExchangeRate(), arPay.getReceiptAccountId(), 0, arPay.getArCurrencyAmount(),             
                    //            arPay.getAmount(), comp.getBookingCurrencyId(), oid, "Payment from "+ cust.getCode()+"/"+cust.getName()+" for Project Number : "+ proj.getNumber()+" and Invoice Number : "+ arInv.getInvoiceNumber(), 0);
                

                    //Credit AR
                   // DbGl.postJournalDetail(arPay.getExchangeRate(), arPay.getArAccountId(), arPay.getArCurrencyAmount(), 0,             
                    //            arPay.getAmount(), comp.getBookingCurrencyId(), oid, "Payment from "+ cust.getCode()+"/"+cust.getName()+" for Project Number : "+ proj.getNumber()+" and Invoice Number : "+ arInv.getInvoiceNumber(), 0);
                }
            }
        }
        
        public static void postStatusInvoice(long arPaymentId){
            //Load AR Payment
            ArPayment arPay = new ArPayment();
            try{
                arPay = DbArPayment.fetchExc(arPaymentId);
            }catch(Exception e){
                System.out.println();
            }
            
            //Load Invoice
            ARInvoice arInv = new ARInvoice();
            try{
                arInv = DbARInvoice.fetchExc(arPay.getArInvoiceId());
            }catch (Exception e){
                System.out.println(e);
            }
            
            //Load Invoice Detail
            Vector vArDetailInvoice = new Vector(1,1);
            vArDetailInvoice = DbARInvoiceDetail.list(0, 0, DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID]+"="+arInv.getOID(),"");            
            double totalInvoice = getTotalDetailInvoice(vArDetailInvoice); 
            //System.out.println(totalInvoice);
            
            //Load Payment Detail
            Vector vArDetailPayment = new Vector(1,1);
            vArDetailPayment = DbArPayment.list(0, 0, DbArPayment.colNames[DbArPayment.COL_AR_INVOICE_ID]+"="+arInv.getOID(),"");            
            double totalPayment = getTotalDetailPayment(vArDetailPayment); 
            //System.out.println(totalPayment);
            
            ProjectTerm projectTerm = new ProjectTerm();
            try{
                projectTerm = DbProjectTerm.fetchExc(arInv.getProjectTermId());                                
            }catch(Exception e){
                System.out.println(e);
            }
            
            if(totalPayment>=totalInvoice){
                arInv.setStatus(I_Project.INV_STATUS_FULL_PAID);
                projectTerm.setStatus(I_Crm.TERM_STATUS_FULL_PAID);
            }else{
                arInv.setStatus(I_Project.INV_STATUS_PARTIALY_PAID);
                projectTerm.setStatus(I_Crm.TERM_STATUS_PARTIALY_PAID);
            }
            
            arInv.setLastPaymentAmount(arPay.getArCurrencyAmount());
            arInv.setLastPaymentDate(arPay.getTransactionDate());
            
            //Update Invoice Status
            long oid = 0;
            try{                
                oid = DbARInvoice.updateExc(arInv);
            }catch(Exception e){
                System.out.println(e);
            }
            
            //Update Project Term
            try{
                DbProjectTerm.updateExc(projectTerm);                        
            }catch(Exception e){
                System.out.println(e);
            }
        }
        
        public static double getTotalDetailPayment(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ArPayment arPayment = (ArPayment)listx.get(i);
				result = result + (arPayment.getArCurrencyAmount());
			}
		}
		return result;
	}
        
        public static double getTotalDetailPayment(Vector listx,String formNumbComp){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ArPayment arPayment = (ArPayment)listx.get(i);
                                if (formNumbComp.equals("#,##0")) { // di bulatkan
                                    result = result + Math.round(arPayment.getArCurrencyAmount());
                                }else{
                                    result = result + (arPayment.getArCurrencyAmount());
                                }
			}
		}
		return result;
	}

        public static double getTotalDetailInvoice(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ARInvoiceDetail arInvoiceDetail = (ARInvoiceDetail)listx.get(i);
				result = result + (arInvoiceDetail.getTotalAmount());
			}
		}
		return result;
	}
        
        public static double getTotalInvoicePayment(long invoiceId){
            
            String sql = "select sum("+DbArPayment.colNames[DbArPayment.COL_AMOUNT]+") from "+
                DB_AR_PAYMENT+" where "+colNames[COL_AR_INVOICE_ID]+"= "+invoiceId;
            
            CONResultSet crs =null;
            double result = 0;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
        }
        
        public synchronized static int getCountData(long arInvoiceId){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbArPayment.colNames[DbArPayment.COL_AR_PAYMENT_ID] + ") FROM " + DB_AR_PAYMENT +" WHERE "+DbArPayment.colNames[DbArPayment.COL_AR_INVOICE_ID]+" = "+arInvoiceId;

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
        
}
