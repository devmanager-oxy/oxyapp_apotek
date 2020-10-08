

package com.project.ccs.postransaction.sales;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;

public class DbPayment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

	public static final  String DB_PAYMENT = "pos_payment";

	public static final  int COL_PAYMENT_ID = 0;
	public static final  int COL_SALES_ID = 1;
	public static final  int COL_CURRENCY_ID = 2;
	public static final  int COL_PAY_DATE = 3;
	public static final  int COL_PAY_TYPE= 4;
	public static final  int COL_AMOUNT = 5;
        public static final  int COL_RATE = 6;
	public static final  int COL_COST_CARD_AMOUNT = 7;
	public static final  int COL_COST_CARD_PERCENT = 8;
        public static final  int COL_BANK_ID = 9;
        public static final  int COL_MERCHANT_ID = 10;

	public static final  String[] colNames = {
		"payment_id",
		"sales_id",
		"currency_id",
		"pay_date",
		"pay_type",
		"amount",
                "rate",
                "cost_card_amount",
                "cost_card_percent",
		"bank_id",
                "merchant_id"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_INT,
		TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_LONG
	};
        
        public static final int PAY_TYPE_CASH           = 0;
        public static final int PAY_TYPE_CREDIT_CARD    = 1;
        public static final int PAY_TYPE_DEBIT_CARD     = 2;
        public static final int PAY_TYPE_TRANSFER       = 3;
        public static final int PAY_TYPE_VOUCHER        = 4;
        public static final int PAY_TYPE_ADIRA          = 5;
        public static final int PAY_TYPE_GIRO           = 6;
        public static final int PAY_TYPE_PAY_PAL        = 7;
        public static final int PAY_TYPE_FIF            = 8;
        public static final int PAY_TYPE_CASH_BACK      = 9;
        
	public DbPayment(){
	}

	public DbPayment(int i) throws CONException {
		super(new DbPayment());
	}

	public DbPayment(String sOid) throws CONException {
		super(new DbPayment(0));
		if(!locate(sOid))
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		else
			return;
	}

	public DbPayment(long lOid) throws CONException {
		super(new DbPayment(0));
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
		return DB_PAYMENT;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbPayment().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception {
		Payment payment = fetchExc(ent.getOID());
		ent = (Entity)payment;
		return payment.getOID();
	}

	public long insertExc(Entity ent) throws Exception {
		return insertExc((Payment) ent);
	}

	public long updateExc(Entity ent) throws Exception {
		return updateExc((Payment) ent);
	}

	public long deleteExc(Entity ent) throws Exception {
		if(ent==null){
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		}
			return deleteExc(ent.getOID());
	}

	public static Payment fetchExc(long oid) throws CONException{
		try{
			Payment payment = new Payment();
			DbPayment dbpayment = new DbPayment(oid);
			payment.setOID(oid);

			payment.setSales_id(dbpayment.getlong(COL_SALES_ID));
			payment.setCurrency_id(dbpayment.getlong(COL_CURRENCY_ID)); 
			payment.setPay_date(dbpayment.getDate(COL_PAY_DATE));
			payment.setPay_type(dbpayment.getInt(COL_PAY_TYPE)); 
			payment.setAmount(dbpayment.getdouble(COL_AMOUNT)); 
                        payment.setRate(dbpayment.getdouble(COL_RATE)); 
			payment.setCost_card_amount(dbpayment.getdouble(COL_COST_CARD_AMOUNT)); 		
                        payment.setCost_card_percent(dbpayment.getdouble(COL_COST_CARD_PERCENT)); 
                        payment.setBankId(dbpayment.getlong(COL_BANK_ID)); 
                        payment.setMerchantId(dbpayment.getlong(COL_MERCHANT_ID)); 
                        
			return payment;
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbPayment(0),CONException.UNKNOWN);
		}
	}

	public static long insertExc(Payment payment) throws CONException{
		try{
			DbPayment dbpayment = new DbPayment(0);

			dbpayment.setLong(COL_SALES_ID, payment.getSales_id());
			dbpayment.setLong(COL_CURRENCY_ID, payment.getCurrency_id());
			dbpayment.setDate(COL_PAY_DATE, payment.getPay_date());
			dbpayment.setInt(COL_PAY_TYPE, payment.getPay_type());
			dbpayment.setDouble(COL_AMOUNT, payment.getAmount());
                        dbpayment.setDouble(COL_RATE, payment.getRate());
			dbpayment.setDouble(COL_COST_CARD_AMOUNT, payment.getCost_card_amount());
                        dbpayment.setDouble(COL_COST_CARD_PERCENT, payment.getCost_card_percent());
                        dbpayment.setLong(COL_BANK_ID, payment.getBankId());
                        dbpayment.setLong(COL_MERCHANT_ID, payment.getMerchantId());
                        
                        dbpayment.insert();
			payment.setOID(dbpayment.getlong(COL_PAYMENT_ID));
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbSalesDetail(0),CONException.UNKNOWN);
		}
		return payment.getOID();
	}

	public static long updateExc(Payment payment) throws CONException{
		try{
			if(payment.getOID() != 0){
                            DbPayment dbpayment = new DbPayment(payment.getOID());

                            dbpayment.setLong(COL_SALES_ID, payment.getSales_id());
                            dbpayment.setLong(COL_CURRENCY_ID, payment.getCurrency_id());
                            dbpayment.setDate(COL_PAY_DATE, payment.getPay_date());
                            dbpayment.setInt(COL_PAY_TYPE, payment.getPay_type());
                            dbpayment.setDouble(COL_AMOUNT, payment.getAmount());
                            dbpayment.setDouble(COL_RATE, payment.getRate());
			    dbpayment.setDouble(COL_COST_CARD_AMOUNT, payment.getCost_card_amount());
                            dbpayment.setDouble(COL_COST_CARD_PERCENT, payment.getCost_card_percent());
                            dbpayment.setLong(COL_BANK_ID, payment.getBankId());
                            dbpayment.setLong(COL_MERCHANT_ID, payment.getMerchantId());
                            
                            dbpayment.update();
                            return payment.getOID();

			}
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbPayment(0),CONException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{
		try{
			DbPayment dbPayment = new DbPayment(oid);
			dbPayment.delete();
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbPayment(0),CONException.UNKNOWN);
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
			String sql = "SELECT * FROM " + DB_PAYMENT;
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
				Payment payment = new Payment();
				resultToObject(rs, payment);
				lists.add(payment);
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

	private static void resultToObject(ResultSet rs, Payment payment){
		try{

			payment.setOID(rs.getLong(DbPayment.colNames[DbPayment.COL_PAYMENT_ID]));
			payment.setSales_id(rs.getLong(DbPayment.colNames[DbPayment.COL_SALES_ID]));
			payment.setCurrency_id(rs.getLong(DbPayment.colNames[DbPayment.COL_CURRENCY_ID]));
			payment.setPay_date(rs.getDate(DbPayment.colNames[DbPayment.COL_PAY_DATE]));
			payment.setPay_type(rs.getInt(DbPayment.colNames[DbPayment.COL_PAY_TYPE]));
			payment.setAmount(rs.getDouble(DbPayment.colNames[DbPayment.COL_AMOUNT]));
                        payment.setRate(rs.getDouble(DbPayment.colNames[DbPayment.COL_RATE]));
		        payment.setCost_card_amount(rs.getDouble(DbPayment.colNames[DbPayment.COL_COST_CARD_AMOUNT]));
                        payment.setCost_card_percent(rs.getDouble(DbPayment.colNames[DbPayment.COL_COST_CARD_PERCENT]));
                        payment.setBankId(rs.getLong(DbPayment.colNames[DbPayment.COL_BANK_ID]));
                        payment.setMerchantId(rs.getLong(DbPayment.colNames[DbPayment.COL_MERCHANT_ID]));
                        
		}catch(Exception e){ }
	}

	public static boolean checkOID(long paymentId)
	{
		CONResultSet dbrs = null;
		boolean result = false;
		try
		{
			String sql = "SELECT * FROM " + DB_PAYMENT + " WHERE " + 
			DbPayment.colNames[DbPayment.COL_PAYMENT_ID] + " = " + paymentId;
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
			String sql = "SELECT COUNT("+ DbPayment.colNames[DbPayment.COL_PAYMENT_ID] + ") FROM " + DB_PAYMENT;
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
				SalesDetail salesDetail = (SalesDetail)list.get(ls);
				if(oid == salesDetail.getOID())
					found=true;
				}
			}
		}
		if((start >= size) && (size > 0))
			start = start - recordToGet;

		return start;
	}
}

