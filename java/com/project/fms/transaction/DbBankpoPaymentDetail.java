

package com.project.fms.transaction; 

/* package java */ 
import com.project.I_Project;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.DbReceiveItem;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.receiving.ReceiveItem;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.fms.activity.*;
import com.project.util.JSPFormater;

public class DbBankpoPaymentDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_BANKPO_PAYMENT_DETAIL = "bankpo_payment_detail";

	public static final  int COL_BANKPO_PAYMENT_ID = 0;
	public static final  int COL_BANKPO_PAYMENT_DETAIL_ID = 1;
	public static final  int COL_COA_ID = 2;	
	public static final  int COL_MEMO = 3;
	public static final  int COL_INVOICE_ID = 4;
	public static final  int COL_CURRENCY_ID = 5;
	public static final  int COL_BOOKED_RATE = 6;
	public static final  int COL_PAYMENT_BY_INV_CURRENCY_AMOUNT = 7;
	public static final  int COL_PAYMENT_AMOUNT = 8;		
        public static final int COL_SEGMENT1_ID = 9;
        public static final int COL_SEGMENT2_ID = 10;
        public static final int COL_SEGMENT3_ID = 11;
        public static final int COL_SEGMENT4_ID = 12;
        public static final int COL_SEGMENT5_ID = 13;
        public static final int COL_SEGMENT6_ID = 14;        
        public static final int COL_SEGMENT7_ID = 15;
        public static final int COL_SEGMENT8_ID = 16;
        public static final int COL_SEGMENT9_ID = 17;
        public static final int COL_SEGMENT10_ID = 18;
        public static final int COL_SEGMENT11_ID = 19;
        public static final int COL_SEGMENT12_ID = 20;
        public static final int COL_SEGMENT13_ID = 21;
        public static final int COL_SEGMENT14_ID = 22;
        public static final int COL_SEGMENT15_ID = 23;
        public static final int COL_MODULE_ID = 24;
        public static final int COL_DEDUCTION = 25;
        public static final int COL_ARAP_MEMO_ID = 26;
        public static final int COL_VENDOR_ID = 27;
        
	public static final  String[] colNames = {
		"bankpo_payment_id",		
		"bankpo_payment_detail_id",
		"coa_id",
		"memo",
		"invoice_id",
		"currency_id",
		"booked_rate",
		"payment_by_inv_currency_amount",
		"payment_amount",        
                "segment1_id",
                "segment2_id",
                "segment3_id",
                "segment4_id",
                "segment5_id",
                "segment6_id",
                "segment7_id",
                "segment8_id",
                "segment9_id",
                "segment10_id",
                "segment11_id",
                "segment12_id",
                "segment13_id",
                "segment14_id",
                "segment15_id",
                "module_id",
                "deduction",
                "arap_memo_id",
                "vendor_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,                        
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_LONG
	 }; 

	public DbBankpoPaymentDetail(){
	}

	public DbBankpoPaymentDetail(int i) throws CONException { 
		super(new DbBankpoPaymentDetail()); 
	}

	public DbBankpoPaymentDetail(String sOid) throws CONException { 
		super(new DbBankpoPaymentDetail(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbBankpoPaymentDetail(long lOid) throws CONException { 
		super(new DbBankpoPaymentDetail(0)); 
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
		return DB_BANKPO_PAYMENT_DETAIL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbBankpoPaymentDetail().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		BankpoPaymentDetail bankpopaymentdetail = fetchExc(ent.getOID()); 
		ent = (Entity)bankpopaymentdetail; 
		return bankpopaymentdetail.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((BankpoPaymentDetail) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((BankpoPaymentDetail) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static BankpoPaymentDetail fetchExc(long oid) throws CONException{ 
		try{ 
			BankpoPaymentDetail bankpopaymentdetail = new BankpoPaymentDetail();
			DbBankpoPaymentDetail pstBankpoPaymentDetail = new DbBankpoPaymentDetail(oid); 
			bankpopaymentdetail.setOID(oid);

			bankpopaymentdetail.setBankpoPaymentId(pstBankpoPaymentDetail.getlong(COL_BANKPO_PAYMENT_ID));
			bankpopaymentdetail.setCoaId(pstBankpoPaymentDetail.getlong(COL_COA_ID));
			bankpopaymentdetail.setMemo(pstBankpoPaymentDetail.getString(COL_MEMO));
			bankpopaymentdetail.setInvoiceId(pstBankpoPaymentDetail.getlong(COL_INVOICE_ID));
			bankpopaymentdetail.setCurrencyId(pstBankpoPaymentDetail.getlong(COL_CURRENCY_ID));
			bankpopaymentdetail.setBookedRate(pstBankpoPaymentDetail.getdouble(COL_BOOKED_RATE));
			bankpopaymentdetail.setPaymentByInvCurrencyAmount(pstBankpoPaymentDetail.getdouble(COL_PAYMENT_BY_INV_CURRENCY_AMOUNT));
			bankpopaymentdetail.setPaymentAmount(pstBankpoPaymentDetail.getdouble(COL_PAYMENT_AMOUNT));			
			bankpopaymentdetail.setSegment1Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT1_ID));
                        bankpopaymentdetail.setSegment2Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT2_ID));
                        bankpopaymentdetail.setSegment3Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT3_ID));
                        bankpopaymentdetail.setSegment4Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT4_ID));
                        bankpopaymentdetail.setSegment5Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT5_ID));
                        bankpopaymentdetail.setSegment6Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT6_ID));
                        bankpopaymentdetail.setSegment7Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT7_ID));
                        bankpopaymentdetail.setSegment8Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT8_ID));
                        bankpopaymentdetail.setSegment9Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT9_ID));
                        bankpopaymentdetail.setSegment10Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT10_ID));
                        bankpopaymentdetail.setSegment11Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT11_ID));
                        bankpopaymentdetail.setSegment12Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT12_ID));
                        bankpopaymentdetail.setSegment13Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT13_ID));
                        bankpopaymentdetail.setSegment14Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT14_ID));
                        bankpopaymentdetail.setSegment15Id(pstBankpoPaymentDetail.getlong(COL_SEGMENT15_ID));            
                        bankpopaymentdetail.setModuleId(pstBankpoPaymentDetail.getlong(COL_MODULE_ID));
                        bankpopaymentdetail.setDeduction(pstBankpoPaymentDetail.getdouble(COL_DEDUCTION));
                        bankpopaymentdetail.setArapMemoId(pstBankpoPaymentDetail.getlong(COL_ARAP_MEMO_ID));
                        bankpopaymentdetail.setVendorId(pstBankpoPaymentDetail.getlong(COL_VENDOR_ID));

			return bankpopaymentdetail; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBankpoPaymentDetail(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(BankpoPaymentDetail bankpopaymentdetail) throws CONException{ 
		try{ 
			DbBankpoPaymentDetail pstBankpoPaymentDetail = new DbBankpoPaymentDetail(0);

			pstBankpoPaymentDetail.setLong(COL_BANKPO_PAYMENT_ID, bankpopaymentdetail.getBankpoPaymentId());
			pstBankpoPaymentDetail.setLong(COL_COA_ID, bankpopaymentdetail.getCoaId());
			pstBankpoPaymentDetail.setString(COL_MEMO, bankpopaymentdetail.getMemo());
			pstBankpoPaymentDetail.setLong(COL_INVOICE_ID, bankpopaymentdetail.getInvoiceId());
			pstBankpoPaymentDetail.setLong(COL_CURRENCY_ID, bankpopaymentdetail.getCurrencyId());
			pstBankpoPaymentDetail.setDouble(COL_BOOKED_RATE, bankpopaymentdetail.getBookedRate());
			pstBankpoPaymentDetail.setDouble(COL_PAYMENT_BY_INV_CURRENCY_AMOUNT, bankpopaymentdetail.getPaymentByInvCurrencyAmount());
			pstBankpoPaymentDetail.setDouble(COL_PAYMENT_AMOUNT, bankpopaymentdetail.getPaymentAmount());			
			pstBankpoPaymentDetail.setLong(COL_SEGMENT1_ID, bankpopaymentdetail.getSegment1Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT2_ID, bankpopaymentdetail.getSegment2Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT3_ID, bankpopaymentdetail.getSegment3Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT4_ID, bankpopaymentdetail.getSegment4Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT5_ID, bankpopaymentdetail.getSegment5Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT6_ID, bankpopaymentdetail.getSegment6Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT7_ID, bankpopaymentdetail.getSegment7Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT8_ID, bankpopaymentdetail.getSegment8Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT9_ID, bankpopaymentdetail.getSegment9Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT10_ID, bankpopaymentdetail.getSegment10Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT11_ID, bankpopaymentdetail.getSegment11Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT12_ID, bankpopaymentdetail.getSegment12Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT13_ID, bankpopaymentdetail.getSegment13Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT14_ID, bankpopaymentdetail.getSegment14Id());
                        pstBankpoPaymentDetail.setLong(COL_SEGMENT15_ID, bankpopaymentdetail.getSegment15Id());            
                        pstBankpoPaymentDetail.setLong(COL_MODULE_ID, bankpopaymentdetail.getModuleId());
                        pstBankpoPaymentDetail.setDouble(COL_DEDUCTION, bankpopaymentdetail.getDeduction());
                        pstBankpoPaymentDetail.setLong(COL_ARAP_MEMO_ID, bankpopaymentdetail.getArapMemoId());
                        pstBankpoPaymentDetail.setLong(COL_VENDOR_ID, bankpopaymentdetail.getVendorId());
                        
			pstBankpoPaymentDetail.insert(); 
			bankpopaymentdetail.setOID(pstBankpoPaymentDetail.getlong(COL_BANKPO_PAYMENT_DETAIL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBankpoPaymentDetail(0),CONException.UNKNOWN); 
		}
		return bankpopaymentdetail.getOID();
	}

	public static long updateExc(BankpoPaymentDetail bankpopaymentdetail) throws CONException{ 
		try{ 
			if(bankpopaymentdetail.getOID() != 0){ 
				DbBankpoPaymentDetail pstBankpoPaymentDetail = new DbBankpoPaymentDetail(bankpopaymentdetail.getOID());

				pstBankpoPaymentDetail.setLong(COL_BANKPO_PAYMENT_ID, bankpopaymentdetail.getBankpoPaymentId());
				pstBankpoPaymentDetail.setLong(COL_COA_ID, bankpopaymentdetail.getCoaId());
				pstBankpoPaymentDetail.setString(COL_MEMO, bankpopaymentdetail.getMemo());
				pstBankpoPaymentDetail.setLong(COL_INVOICE_ID, bankpopaymentdetail.getInvoiceId());
				pstBankpoPaymentDetail.setDouble(COL_CURRENCY_ID, bankpopaymentdetail.getCurrencyId());
				pstBankpoPaymentDetail.setDouble(COL_BOOKED_RATE, bankpopaymentdetail.getBookedRate());
				pstBankpoPaymentDetail.setDouble(COL_PAYMENT_BY_INV_CURRENCY_AMOUNT, bankpopaymentdetail.getPaymentByInvCurrencyAmount());
				pstBankpoPaymentDetail.setDouble(COL_PAYMENT_AMOUNT, bankpopaymentdetail.getPaymentAmount());				
				pstBankpoPaymentDetail.setLong(COL_SEGMENT1_ID, bankpopaymentdetail.getSegment1Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT2_ID, bankpopaymentdetail.getSegment2Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT3_ID, bankpopaymentdetail.getSegment3Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT4_ID, bankpopaymentdetail.getSegment4Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT5_ID, bankpopaymentdetail.getSegment5Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT6_ID, bankpopaymentdetail.getSegment6Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT7_ID, bankpopaymentdetail.getSegment7Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT8_ID, bankpopaymentdetail.getSegment8Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT9_ID, bankpopaymentdetail.getSegment9Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT10_ID, bankpopaymentdetail.getSegment10Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT11_ID, bankpopaymentdetail.getSegment11Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT12_ID, bankpopaymentdetail.getSegment12Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT13_ID, bankpopaymentdetail.getSegment13Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT14_ID, bankpopaymentdetail.getSegment14Id());
                                pstBankpoPaymentDetail.setLong(COL_SEGMENT15_ID, bankpopaymentdetail.getSegment15Id());	            
                                pstBankpoPaymentDetail.setLong(COL_MODULE_ID, bankpopaymentdetail.getModuleId());
                                pstBankpoPaymentDetail.setDouble(COL_DEDUCTION, bankpopaymentdetail.getDeduction());
                                pstBankpoPaymentDetail.setLong(COL_ARAP_MEMO_ID, bankpopaymentdetail.getArapMemoId());
                                pstBankpoPaymentDetail.setLong(COL_VENDOR_ID, bankpopaymentdetail.getVendorId());
                                
				pstBankpoPaymentDetail.update(); 
				return bankpopaymentdetail.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBankpoPaymentDetail(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbBankpoPaymentDetail pstBankpoPaymentDetail = new DbBankpoPaymentDetail(oid);
			pstBankpoPaymentDetail.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBankpoPaymentDetail(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_BANKPO_PAYMENT_DETAIL; 
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
				BankpoPaymentDetail bankpopaymentdetail = new BankpoPaymentDetail();
				resultToObject(rs, bankpopaymentdetail);
				lists.add(bankpopaymentdetail);
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

	private static void resultToObject(ResultSet rs, BankpoPaymentDetail bankpopaymentdetail){
		try{
			bankpopaymentdetail.setOID(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_DETAIL_ID]));
			bankpopaymentdetail.setBankpoPaymentId(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]));
			bankpopaymentdetail.setCoaId(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_COA_ID]));
			bankpopaymentdetail.setMemo(rs.getString(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_MEMO]));
			bankpopaymentdetail.setInvoiceId(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID]));
			bankpopaymentdetail.setCurrencyId(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_CURRENCY_ID]));
			bankpopaymentdetail.setBookedRate(rs.getDouble(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BOOKED_RATE]));
			bankpopaymentdetail.setPaymentByInvCurrencyAmount(rs.getDouble(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT]));
			bankpopaymentdetail.setPaymentAmount(rs.getDouble(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]));			
			bankpopaymentdetail.setSegment1Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT1_ID]));
                        bankpopaymentdetail.setSegment2Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT2_ID]));
                        bankpopaymentdetail.setSegment3Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT3_ID]));
                        bankpopaymentdetail.setSegment4Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT4_ID]));
                        bankpopaymentdetail.setSegment5Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT5_ID]));
                        bankpopaymentdetail.setSegment6Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT6_ID]));
                        bankpopaymentdetail.setSegment7Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT7_ID]));
                        bankpopaymentdetail.setSegment8Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT8_ID]));
                        bankpopaymentdetail.setSegment9Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT9_ID]));
                        bankpopaymentdetail.setSegment10Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT10_ID]));
                        bankpopaymentdetail.setSegment11Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT11_ID]));
                        bankpopaymentdetail.setSegment12Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT12_ID]));
                        bankpopaymentdetail.setSegment13Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT13_ID]));
                        bankpopaymentdetail.setSegment14Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT14_ID]));
                        bankpopaymentdetail.setSegment15Id(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_SEGMENT15_ID]));             	
                        bankpopaymentdetail.setModuleId(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_MODULE_ID])); 	
                        bankpopaymentdetail.setDeduction(rs.getDouble(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_DEDUCTION])); 	
                        bankpopaymentdetail.setArapMemoId(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_ARAP_MEMO_ID])); 
                        bankpopaymentdetail.setVendorId(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID])); 
                        
		}catch(Exception e){ }
	}

	public static boolean checkOID(long bankpoPaymentDetailId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_BANKPO_PAYMENT_DETAIL + " WHERE " + 
						DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " = " + bankpoPaymentDetailId;

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
			String sql = "SELECT COUNT("+ DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_DETAIL_ID] + ") FROM " + DB_BANKPO_PAYMENT_DETAIL;
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
			  	   BankpoPaymentDetail bankpopaymentdetail = (BankpoPaymentDetail)list.get(ls);
				   if(oid == bankpopaymentdetail.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static Vector getInvoice(long bankpoPaymentOID){
            Vector list = new Vector();
            CONResultSet dbrs = null;
            try{
                String sql = "select "+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_DETAIL_ID]+","+
                        DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID]+","+
                        DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" from "+
                        DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" where "+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = "+
                        bankpoPaymentOID;
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
                while(rs.next()) {
                    BankpoPaymentDetail bpd = new BankpoPaymentDetail();
                    bpd.setBankpoPaymentId(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]));
                    bpd.setInvoiceId(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID]));
                    bpd.setOID(rs.getLong(DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_DETAIL_ID]));
                    list.add(bpd);
                }
                
            }catch(Exception e) {			
            }finally {
                CONResultSet.close(dbrs);
            }
            return list;
        }
        
        public static void releaseStatus(long bankpoPaymentOID){
            
            Vector vbpd = new Vector();            
            vbpd = getInvoice(bankpoPaymentOID);
            
            if(vbpd != null && vbpd.size() > 0){
                for(int i = 0; i < vbpd.size() ; i++){
                    BankpoPaymentDetail bpd = (BankpoPaymentDetail)vbpd.get(i);                        
                    double totInv =  DbReceive.getTotInvoice(bpd.getInvoiceId());
                    double pTot = DbBankpoPayment.getTotalPaymentByInvoiceFin(bpd.getInvoiceId(),bpd.getOID());
                    int status = 0;
                    if(pTot == 0){
                        status = I_Project.INV_STATUS_DRAFT;
                    }else{                    
                        if(totInv > 0){                    
                            if(pTot >= totInv){
                                status = I_Project.INV_STATUS_FULL_PAID;                                
                            }else{
                                status = I_Project.INV_STATUS_PARTIALY_PAID;                                
                            }   
                        }else{
                            if(pTot <= totInv){
                                status = I_Project.INV_STATUS_FULL_PAID;                                                                
                            }else{
                                status = I_Project.INV_STATUS_PARTIALY_PAID;                                
                            }   
                        }
                    }
                    updatePaidPayment(bpd.getInvoiceId(),status); 
                }
            }
        }
        
        public static double getTotInvoice(long recOID){
            double result = 0;
            
            Receive r = new Receive();
            try{
                r = DbReceive.fetchExc(recOID);
                
                String where = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+" = "+recOID+ " and "+DbReceiveItem.colNames[DbReceiveItem.COL_IS_BONUS]+" = "+DbReceiveItem.NON_BONUS;
                Vector vRD = DbReceiveItem.list(0, 0, where, null);
                
                if(vRD != null && vRD.size() > 0){
                    
                    double subTotal = DbReceiveItem.getTotalReceiveAmount(recOID);
                    
                    for(int i = 0 ; i < vRD.size() ; i++){
                        ReceiveItem ri = new ReceiveItem();
                        ri = (ReceiveItem)vRD.get(i);
                        double summary = 0;
                        summary = ri.getTotalAmount();
                        
                        if(r.getDiscountTotal() > 0 ){
                            summary = ri.getTotalAmount() - ((ri.getTotalAmount()/subTotal) * r.getDiscountTotal());
                        }                        
                        result = result + summary;
                    }
                    
                    result = result + r.getTotalTax();
                }
                
            }
            catch(Exception e){}
            
            return result;
            
        }
        
        
        public static void insertItems(long bankpoPayementOID, Vector vInvEdit){
            if(bankpoPayementOID != 0){
                releaseStatus(bankpoPayementOID);                     
                deleteByInvoiceId(bankpoPayementOID);
            }
            
            if(vInvEdit!=null && vInvEdit.size()>0){ 
                
                double totAmount = 0;
                
                for(int i=0; i<vInvEdit.size(); i++){
                    BankpoPaymentDetail ii = (BankpoPaymentDetail)vInvEdit.get(i); 
                    
                    if(i==0){                                
                        try{
                            BankpoPayment bpp = new BankpoPayment();
                            bpp = DbBankpoPayment.fetchExc(bankpoPayementOID);
                            bpp.setSegment1Id(ii.getSegment1Id());
                            DbBankpoPayment.updateExc(bpp);
                        }catch(Exception e){}
                    }
                    
                    try{
                        ii.setBankpoPaymentId(bankpoPayementOID);
                        int status =  getDoubleInvoice(bankpoPayementOID,ii.getInvoiceId());
                            
                        if(status <= 0){ // untuk menghindari input  double
                            long oid = DbBankpoPaymentDetail.insertExc(ii);
                            if(oid != 0){
                                totAmount = totAmount + ii.getPaymentAmount();
                                try{                                    
                                    Receive inv = DbReceive.fetchExc(ii.getInvoiceId());                                         
                                    double total = DbReceive.getTotInvoice(inv.getOID());
                                    double balanceTotal = DbBankpoPayment.getTotalPaymentByInvoice(inv.getOID());
                                    int statusPayment = 0;
                                        
                                    if(total > 0){                    
                                        if(balanceTotal == 0){
                                            statusPayment = I_Project.INV_STATUS_DRAFT;
                                        }else{
                                            if(balanceTotal >= total){
                                                statusPayment = I_Project.INV_STATUS_FULL_PAID;                                                
                                            }else{
                                                statusPayment = I_Project.INV_STATUS_PARTIALY_PAID;                                                
                                            }                                        
                                        }                                        
                                    }else{
                                        if(balanceTotal == 0){
                                            statusPayment = I_Project.INV_STATUS_DRAFT;
                                        }else{
                                            if(balanceTotal <= total){
                                                statusPayment = I_Project.INV_STATUS_FULL_PAID;                                                
                                            }else{
                                                statusPayment = I_Project.INV_STATUS_PARTIALY_PAID;
                                            }    
                                        } 
                                    }    
                                    updatePayment(ii.getInvoiceId(),statusPayment);                    
                                    }catch(Exception e){
                                        System.out.println("[exception] "+e.toString());
                                    }                                
                                }
                            }
                        }
                        catch(Exception e){
                            System.out.println(e.toString());
                        }
                }
                try{
                    updateAmount(bankpoPayementOID,totAmount);                    
                }catch(Exception e){} 
            }else{
                try{
                    updateAmount(bankpoPayementOID,0);                    
                }catch(Exception e){}
            }
        }
        
        public static void updateAmount(long bankpoPaymentId,double amount){
            CONResultSet dbrs = null;
            try{
                String sql = "update "+DbBankpoPayment.DB_BANKPO_PAYMENT+" set "+
                        DbBankpoPayment.colNames[DbBankpoPayment.COL_AMOUNT]+" = "+amount+" where "+
                        DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = "+bankpoPaymentId;
                CONHandler.execUpdate(sql);
            }
            catch(Exception e) {			
            }finally {
                CONResultSet.close(dbrs);
            }
            
        }
        
        
        
        public static int getDoubleInvoice(long bankpoPaymentId,long invoiceId){
            CONResultSet dbrs = null;
            try{
                String sql = "select count(*) from "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" where "+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = "+bankpoPaymentId+
                        " and "+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID]+" = "+invoiceId;
                
                dbrs = CONHandler.execQueryResult(sql);
	        ResultSet rs = dbrs.getResultSet();

		while(rs.next()) { 
                    return rs.getInt(1);
                }
            }catch(Exception e) {
                return 0;
            }finally {
                CONResultSet.close(dbrs);
            }
            return 0;
        }    
        
        public static void updateStatusPaymentPosted(long bankpoPaymentId){            
            try{            
                Vector vBankpoPaymentDetail = new Vector();
                vBankpoPaymentDetail = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = "+bankpoPaymentId, null);
                if(vBankpoPaymentDetail != null && vBankpoPaymentDetail.size() > 0){                    
                    
                    for(int i = 0; i < vBankpoPaymentDetail.size() ; i++){
                        
                        BankpoPaymentDetail bpd = (BankpoPaymentDetail)vBankpoPaymentDetail.get(i);
                        try{
                            Receive receive = DbReceive.fetchExc(bpd.getInvoiceId());
                            double total = DbReceive.getTotInvoice(receive.getOID());
                            double balanceTotal = getTotalPaymentPosted(receive.getOID());
                            int statusPayment = 0;
                            
                            if(total > 0){
                                if(balanceTotal >= total){
                                    statusPayment = DbReceive.STATUS_FULL_PAID_POSTED;
                                }else{
                                    statusPayment = DbReceive.STATUS_PARTIAL_PAID_POSTED;
                                }                                        
                            }else{
                                if(balanceTotal <= total){
                                    statusPayment = DbReceive.STATUS_FULL_PAID_POSTED;                                    
                                }else{
                                    statusPayment = DbReceive.STATUS_PARTIAL_PAID_POSTED;                                     
                                }
                            }
                            updatePostedPayment(receive.getOID(),statusPayment);
                        }catch(Exception e){}
                        
                    }
                }
            }catch(Exception e){}
        }
        
        public static void updatePayment(long receiveId,int status){
            CONResultSet crs = null;
            try{
                String sql = "update "+DbReceive.DB_RECEIVE+" set "+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+" = "+status+
                        " where "+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" = "+receiveId;
                CONHandler.execUpdate(sql);
                
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }
        
        public static void updatePaidPayment(long receiveId,int status){
            CONResultSet crs = null;
            try{
                String sql = "update "+DbReceive.DB_RECEIVE+" set "+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS]+" = "+status+
                        " where "+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" = "+receiveId;
                CONHandler.execUpdate(sql);
                
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }
        
        public static void updatePostedPayment(long receiveId,int status){
            CONResultSet crs = null;
            try{
                String sql = "update "+DbReceive.DB_RECEIVE+" set "+DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS_POSTED]+" = "+status+
                        " where "+DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+" = "+receiveId;
                CONHandler.execUpdate(sql);
                
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }
        }
        
        
        public static double getTotalPaymentPosted(long invoiceId) {
            double result = 0;
            CONResultSet crs = null;
            try {
                String sql = "select sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] + ") "+                    
                    " from " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL +" bpd inner join "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp on "+
                    " bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+
                    " where bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + "=" + invoiceId+" and bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS]+
                    " = '"+DbBankpoPayment.STATUS_PAID+"' ";

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }

            return result;
        }   
        
        public static double getTotalPaymentPosted(long invoiceId,Date endDate,int ignore){
            double result = 0;
            CONResultSet crs = null;
            try {
                String sql = "select sum(bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_BY_INV_CURRENCY_AMOUNT] +") "+
                    " from " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL +" bpd inner join "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp on "+
                    " bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+
                    " inner join "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bpp on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_REF_ID]+
                    " where bpd." + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_INVOICE_ID] + "=" + invoiceId+" and bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS]+
                    " = '"+DbBankpoPayment.STATUS_PAID+"' ";
                
                if(ignore == 0){
                    sql = sql +" and to_days(bpp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_DATE]+") <= to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
                }

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {                    
                    result = rs.getDouble(1);                    
                }
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }

            return result;
        }   
        
        
        
        public static double getTotalPaymentByArapMemo(long arapMemoId) {
            double result = 0;
            CONResultSet crs = null;
            try {
                String sql = "select sum(" + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_DEDUCTION] + ") from " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL +
                    " where " + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_ARAP_MEMO_ID] + "=" + arapMemoId;

                System.out.println(sql);

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }

            return result;
        }
        
        public static Vector getGroupVendor(long bankpoPaymentId) {
            Vector vx = new Vector();
            CONResultSet crs = null;
            try {
                String sql = "select DISTINCT " + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_VENDOR_ID] + " from " + DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL +
                    " where " + DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + "=" + bankpoPaymentId;

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    long result = 0;
                    result = rs.getLong(1);
                    vx.add(""+result);
                }
                return vx;
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }

            return vx;
        }
        
        public static void deleteByInvoiceId(long bankpoPayementOID){
            try{
                String str = "delete from "+DB_BANKPO_PAYMENT_DETAIL+" where "+colNames[COL_BANKPO_PAYMENT_ID]+"="+ bankpoPayementOID;
                CONHandler.execUpdate(str);
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
        }
        
        public static Vector getActivityPredefined(long paymentOID){
            Vector result = new Vector();
            ActivityPeriod ap = DbActivityPeriod.getOpenPeriod();
            CONResultSet crs = null;
            try{
                String sql = "SELECT c.*, pd.* FROM coa_activity_budget c inner join bankpo_payment_detail pd on pd.coa_id=c.coa_id "+
                    " where pd.bankpo_payment_id="+paymentOID+" and c.activity_period_id = "+ap.getOID();
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    CoaActivityBudget cab = new CoaActivityBudget();
                    BankpoPaymentDetail ppd = new BankpoPaymentDetail();
                    DbCoaActivityBudget.resultToObject(rs, cab);
                    DbBankpoPaymentDetail.resultToObject(rs, ppd);
                    Vector v = new Vector();
                    v.add(cab);
                    v.add(ppd);
                    result.add(v);
                }
                
            }
            catch(Exception e){
                
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
        }
        
        
        public static double getSumDeduction(long bankpoPaymentId){
                       
            CONResultSet crs = null;
            
            try{
                String sql = "SELECT SUM("+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_DEDUCTION]+") FROM "+
                        DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" WHERE "+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]
                        +" = "+bankpoPaymentId;
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                double total = 0;
                while(rs.next()){
                    total = rs.getDouble(1);
                    return total;
                }
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }finally{
                CONResultSet.close(crs);
            }
            return 0;
        }
        
        
        public static Vector getAmount(long bankpoPaymentId){
            
            try{
                
                Vector vbpd = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+"="+bankpoPaymentId, null);
                if(vbpd != null && vbpd.size() > 0){
                    double purchase = 0;
                    double deduction = 0;
                    for(int i= 0; i < vbpd.size(); i++){
                        BankpoPaymentDetail bpd = (BankpoPaymentDetail)vbpd.get(i);
                        if(bpd.getPaymentByInvCurrencyAmount() > 0){
                            purchase = purchase + bpd.getPaymentByInvCurrencyAmount();
                        }else{                            
                            deduction = deduction + (bpd.getPaymentByInvCurrencyAmount()*-1);
                        }
                    }
                    Vector value = new Vector();
                    value.add(""+purchase);
                    value.add(""+deduction);
                    return value;
                }
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }
            return null;
        }
        
        public static double getTotalPayment(long bankpoPaymentId){
            double total = 0;
            CONResultSet crs = null;
            try{
                String sql = "select sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd "+
                        " on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" where bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_REF_ID]+" = "+bankpoPaymentId+" and "+
                        " bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE]+" = "+DbBankpoPayment.TYPE_PEMBAYARAN_BANK;
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();                
                while(rs.next()){
                    total = rs.getDouble(1);
                    return total;
                }
                
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }finally{
                CONResultSet.close(crs);
            }
            
            return total;
        }
        
        public static void statusPembayaran(long bankpoPaymentId){
            
            double total = 0;
            CONResultSet crs = null;
            try{
                String sql = "select sum(bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_PAYMENT_AMOUNT]+") from "+DbBankpoPayment.DB_BANKPO_PAYMENT+" bp inner join "+DbBankpoPaymentDetail.DB_BANKPO_PAYMENT_DETAIL+" bpd "+
                        " on bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = bpd."+DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" where bp."+DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = "+bankpoPaymentId;
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();                
                while(rs.next()){
                    total = rs.getDouble(1);
                }
                
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }finally{
                CONResultSet.close(crs);
            }
            
            double payment = getTotalPayment(bankpoPaymentId);
            
            if(payment != 0){
                if(payment >= total){
                    updateStatusPembayaran(bankpoPaymentId,DbBankpoPayment.STATUS_PAID);
                }else{
                    updateStatusPembayaran(bankpoPaymentId,DbBankpoPayment.STATUS_PARTIALY_PAID);
                }
            }
        }
        
        public static void updateStatusPembayaran(long bankpoPaymentId,String status){
            CONResultSet crs = null;
            try{
                String sql = "update "+DbBankpoPayment.DB_BANKPO_PAYMENT+" set "+DbBankpoPayment.colNames[DbBankpoPayment.COL_STATUS]+" = '"+status+"' where "+
                         DbBankpoPayment.colNames[DbBankpoPayment.COL_BANKPO_PAYMENT_ID]+" = "+bankpoPaymentId;
                 
                CONHandler.execUpdate(sql);
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }finally{
                CONResultSet.close(crs);
            }
             
        }
        
        
}
