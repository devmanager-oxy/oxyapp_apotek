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
import com.project.fms.master.*;
import com.project.util.*;
import com.project.*;
import com.project.crm.transaction.DbPembayaran;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.interfaces.I_FmsCrmInsertUpdate;


public class DbBankDeposit extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language, I_FmsCrmInsertUpdate { 

	public static final  String DB_BANK_DEPOSIT = "bank_deposit";

	public static final  int COL_BANK_DEPOSIT_ID = 0;
	public static final  int COL_MEMO = 1;
	public static final  int COL_DATE = 2;
	public static final  int COL_TRANS_DATE = 3;
	public static final  int COL_OPERATOR_ID = 4;
	public static final  int COL_OPERATOR_NAME = 5;
	public static final  int COL_JOURNAL_NUMBER = 6;
	public static final  int COL_JOURNAL_PREFIX = 7;
	public static final  int COL_JOURNAL_COUNTER = 8;
	public static final  int COL_COA_ID = 9;
	public static final  int COL_AMOUNT = 10;
	public static final  int COL_CURRENCY_ID = 11;
        
    //add by Roy Andika
    public static final  int COL_POSTED_STATUS = 12;
    public static final  int COL_POSTED_BY_ID = 13;
    public static final  int COL_POSTED_DATE = 14;
    public static final  int COL_EFFECTIVE_DATE = 15;    
    public static final  int COL_CUSTOMER_ID = 16; 
    
    //eka    	
    public static final int COL_SEGMENT1_ID = 17;
    public static final int COL_SEGMENT2_ID = 18;
    public static final int COL_SEGMENT3_ID = 19;
    public static final int COL_SEGMENT4_ID = 20;
    public static final int COL_SEGMENT5_ID = 21;
    public static final int COL_SEGMENT6_ID = 22;
    public static final int COL_SEGMENT7_ID = 23;
    public static final int COL_SEGMENT8_ID = 24;
    public static final int COL_SEGMENT9_ID = 25;
    public static final int COL_SEGMENT10_ID = 26;
    public static final int COL_SEGMENT11_ID = 27;
    public static final int COL_SEGMENT12_ID = 28;
    public static final int COL_SEGMENT13_ID = 29;
    public static final int COL_SEGMENT14_ID = 30;
    public static final int COL_SEGMENT15_ID = 31;    	   
    
    public static final int COL_PERIODE_ID = 32;   
    public static final int COL_RECEIVE_FROM = 33;

	public static final  String[] colNames = {
		"bank_deposit_id",
                "memo",
                "date",
                "trans_date",
                "operator_id",
                "operator_name",
                "journal_number",
                "journal_prefix",
                "journal_counter",
                "coa_id",
                "amount",
                "currency_id",
                
                "posted_status",
                "posted_by_id",
                "posted_date",
                "effective_date",
                "customer_id",
        
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
                "periode_id",
                "receive_from"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_LONG,
                        
                TYPE_INT,
                TYPE_LONG,
                TYPE_DATE,
                TYPE_DATE,
                TYPE_LONG,
        
        //segment
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
                TYPE_STRING
	 }; 

	public DbBankDeposit(){
	}

	public DbBankDeposit(int i) throws CONException { 
		super(new DbBankDeposit()); 
	}

	public DbBankDeposit(String sOid) throws CONException { 
		super(new DbBankDeposit(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbBankDeposit(long lOid) throws CONException { 
		super(new DbBankDeposit(0)); 
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
		return DB_BANK_DEPOSIT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbBankDeposit().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		BankDeposit bankdeposit = fetchExc(ent.getOID()); 
		ent = (Entity)bankdeposit; 
		return bankdeposit.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((BankDeposit) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((BankDeposit) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static BankDeposit fetchExc(long oid) throws CONException{ 
		try{ 
			BankDeposit bankdeposit = new BankDeposit();
			DbBankDeposit pstBankDeposit = new DbBankDeposit(oid); 
			bankdeposit.setOID(oid);

			bankdeposit.setMemo(pstBankDeposit.getString(COL_MEMO));
			bankdeposit.setDate(pstBankDeposit.getDate(COL_DATE));
			bankdeposit.setTransDate(pstBankDeposit.getDate(COL_TRANS_DATE));
			bankdeposit.setOperatorId(pstBankDeposit.getlong(COL_OPERATOR_ID));
			bankdeposit.setOperatorName(pstBankDeposit.getString(COL_OPERATOR_NAME));
			bankdeposit.setJournalNumber(pstBankDeposit.getString(COL_JOURNAL_NUMBER));
			bankdeposit.setJournalPrefix(pstBankDeposit.getString(COL_JOURNAL_PREFIX));
			bankdeposit.setJournalCounter(pstBankDeposit.getInt(COL_JOURNAL_COUNTER));
			bankdeposit.setCoaId(pstBankDeposit.getlong(COL_COA_ID));
			bankdeposit.setAmount(pstBankDeposit.getdouble(COL_AMOUNT));
			bankdeposit.setCurrencyId(pstBankDeposit.getlong(COL_CURRENCY_ID));
                        
                        bankdeposit.setPostedStatus(pstBankDeposit.getInt(COL_POSTED_STATUS));
                        bankdeposit.setPostedById(pstBankDeposit.getlong(COL_POSTED_BY_ID));
                        bankdeposit.setPostedDate(pstBankDeposit.getDate(COL_POSTED_DATE));
                        bankdeposit.setEffectiveDate(pstBankDeposit.getDate(COL_EFFECTIVE_DATE));
                        bankdeposit.setCustomerId(pstBankDeposit.getlong(COL_CUSTOMER_ID));
                        
            bankdeposit.setSegment1Id(pstBankDeposit.getlong(COL_SEGMENT1_ID));
            bankdeposit.setSegment2Id(pstBankDeposit.getlong(COL_SEGMENT2_ID));
            bankdeposit.setSegment3Id(pstBankDeposit.getlong(COL_SEGMENT3_ID));
            bankdeposit.setSegment4Id(pstBankDeposit.getlong(COL_SEGMENT4_ID));
            bankdeposit.setSegment5Id(pstBankDeposit.getlong(COL_SEGMENT5_ID));
            bankdeposit.setSegment6Id(pstBankDeposit.getlong(COL_SEGMENT6_ID));
            bankdeposit.setSegment7Id(pstBankDeposit.getlong(COL_SEGMENT7_ID));
            bankdeposit.setSegment8Id(pstBankDeposit.getlong(COL_SEGMENT8_ID));
            bankdeposit.setSegment9Id(pstBankDeposit.getlong(COL_SEGMENT9_ID));
            bankdeposit.setSegment10Id(pstBankDeposit.getlong(COL_SEGMENT10_ID));
            bankdeposit.setSegment11Id(pstBankDeposit.getlong(COL_SEGMENT11_ID));
            bankdeposit.setSegment12Id(pstBankDeposit.getlong(COL_SEGMENT12_ID));
            bankdeposit.setSegment13Id(pstBankDeposit.getlong(COL_SEGMENT13_ID));
            bankdeposit.setSegment14Id(pstBankDeposit.getlong(COL_SEGMENT14_ID));
            bankdeposit.setSegment15Id(pstBankDeposit.getlong(COL_SEGMENT15_ID));            
            bankdeposit.setPeriodeId(pstBankDeposit.getlong(COL_PERIODE_ID));           
            bankdeposit.setReceiveFrom(pstBankDeposit.getString(COL_RECEIVE_FROM));  

			return bankdeposit; 
                        
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBankDeposit(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(BankDeposit bankdeposit) throws CONException{ 
		try{ 
			DbBankDeposit pstBankDeposit = new DbBankDeposit(0);

			pstBankDeposit.setString(COL_MEMO, bankdeposit.getMemo());
			pstBankDeposit.setDate(COL_DATE, bankdeposit.getDate());
			pstBankDeposit.setDate(COL_TRANS_DATE, bankdeposit.getTransDate());
			pstBankDeposit.setLong(COL_OPERATOR_ID, bankdeposit.getOperatorId());
			pstBankDeposit.setString(COL_OPERATOR_NAME, bankdeposit.getOperatorName());
			pstBankDeposit.setString(COL_JOURNAL_NUMBER, bankdeposit.getJournalNumber());
			pstBankDeposit.setString(COL_JOURNAL_PREFIX, bankdeposit.getJournalPrefix());
			pstBankDeposit.setInt(COL_JOURNAL_COUNTER, bankdeposit.getJournalCounter());
			pstBankDeposit.setLong(COL_COA_ID, bankdeposit.getCoaId());
			pstBankDeposit.setDouble(COL_AMOUNT, bankdeposit.getAmount());
			pstBankDeposit.setLong(COL_CURRENCY_ID, bankdeposit.getCurrencyId());
                        
                        pstBankDeposit.setInt(COL_POSTED_STATUS, bankdeposit.getPostedStatus());
                        pstBankDeposit.setLong(COL_POSTED_BY_ID, bankdeposit.getPostedById());
                        pstBankDeposit.setDate(COL_POSTED_DATE, bankdeposit.getPostedDate());
                        pstBankDeposit.setDate(COL_EFFECTIVE_DATE, bankdeposit.getEffectiveDate());
                        pstBankDeposit.setLong(COL_CUSTOMER_ID, bankdeposit.getCustomerId());
            
            pstBankDeposit.setLong(COL_SEGMENT1_ID, bankdeposit.getSegment1Id());
            pstBankDeposit.setLong(COL_SEGMENT2_ID, bankdeposit.getSegment2Id());
            pstBankDeposit.setLong(COL_SEGMENT3_ID, bankdeposit.getSegment3Id());
            pstBankDeposit.setLong(COL_SEGMENT4_ID, bankdeposit.getSegment4Id());
            pstBankDeposit.setLong(COL_SEGMENT5_ID, bankdeposit.getSegment5Id());
            pstBankDeposit.setLong(COL_SEGMENT6_ID, bankdeposit.getSegment6Id());
            pstBankDeposit.setLong(COL_SEGMENT7_ID, bankdeposit.getSegment7Id());
            pstBankDeposit.setLong(COL_SEGMENT8_ID, bankdeposit.getSegment8Id());
            pstBankDeposit.setLong(COL_SEGMENT9_ID, bankdeposit.getSegment9Id());
            pstBankDeposit.setLong(COL_SEGMENT10_ID, bankdeposit.getSegment10Id());
            pstBankDeposit.setLong(COL_SEGMENT11_ID, bankdeposit.getSegment11Id());
            pstBankDeposit.setLong(COL_SEGMENT12_ID, bankdeposit.getSegment12Id());
            pstBankDeposit.setLong(COL_SEGMENT13_ID, bankdeposit.getSegment13Id());
            pstBankDeposit.setLong(COL_SEGMENT14_ID, bankdeposit.getSegment14Id());
            pstBankDeposit.setLong(COL_SEGMENT15_ID, bankdeposit.getSegment15Id());            
            
            pstBankDeposit.setLong(COL_PERIODE_ID, bankdeposit.getPeriodeId());     
            pstBankDeposit.setString(COL_RECEIVE_FROM, bankdeposit.getReceiveFrom()); 

			pstBankDeposit.insert(); 
			bankdeposit.setOID(pstBankDeposit.getlong(COL_BANK_DEPOSIT_ID));
                        
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBankDeposit(0),CONException.UNKNOWN); 
		}
		return bankdeposit.getOID();
	}

	public static long updateExc(BankDeposit bankdeposit) throws CONException{ 
		try{ 
			if(bankdeposit.getOID() != 0){ 
				DbBankDeposit pstBankDeposit = new DbBankDeposit(bankdeposit.getOID());

				pstBankDeposit.setString(COL_MEMO, bankdeposit.getMemo());
				pstBankDeposit.setDate(COL_DATE, bankdeposit.getDate());
				pstBankDeposit.setDate(COL_TRANS_DATE, bankdeposit.getTransDate());
				pstBankDeposit.setLong(COL_OPERATOR_ID, bankdeposit.getOperatorId());
				pstBankDeposit.setString(COL_OPERATOR_NAME, bankdeposit.getOperatorName());
				pstBankDeposit.setString(COL_JOURNAL_NUMBER, bankdeposit.getJournalNumber());
				pstBankDeposit.setString(COL_JOURNAL_PREFIX, bankdeposit.getJournalPrefix());
				pstBankDeposit.setInt(COL_JOURNAL_COUNTER, bankdeposit.getJournalCounter());
				pstBankDeposit.setLong(COL_COA_ID, bankdeposit.getCoaId());
				pstBankDeposit.setDouble(COL_AMOUNT, bankdeposit.getAmount());
				pstBankDeposit.setLong(COL_CURRENCY_ID, bankdeposit.getCurrencyId());
                                
                                pstBankDeposit.setInt(COL_POSTED_STATUS, bankdeposit.getPostedStatus());
                                pstBankDeposit.setLong(COL_POSTED_BY_ID, bankdeposit.getPostedById());
                                pstBankDeposit.setDate(COL_POSTED_DATE, bankdeposit.getPostedDate());                
                                pstBankDeposit.setDate(COL_EFFECTIVE_DATE, bankdeposit.getEffectiveDate());
                                pstBankDeposit.setLong(COL_CUSTOMER_ID, bankdeposit.getCustomerId());
                                
                pstBankDeposit.setLong(COL_SEGMENT1_ID, bankdeposit.getSegment1Id());
	            pstBankDeposit.setLong(COL_SEGMENT2_ID, bankdeposit.getSegment2Id());
	            pstBankDeposit.setLong(COL_SEGMENT3_ID, bankdeposit.getSegment3Id());
	            pstBankDeposit.setLong(COL_SEGMENT4_ID, bankdeposit.getSegment4Id());
	            pstBankDeposit.setLong(COL_SEGMENT5_ID, bankdeposit.getSegment5Id());
	            pstBankDeposit.setLong(COL_SEGMENT6_ID, bankdeposit.getSegment6Id());
	            pstBankDeposit.setLong(COL_SEGMENT7_ID, bankdeposit.getSegment7Id());
	            pstBankDeposit.setLong(COL_SEGMENT8_ID, bankdeposit.getSegment8Id());
	            pstBankDeposit.setLong(COL_SEGMENT9_ID, bankdeposit.getSegment9Id());
	            pstBankDeposit.setLong(COL_SEGMENT10_ID, bankdeposit.getSegment10Id());
	            pstBankDeposit.setLong(COL_SEGMENT11_ID, bankdeposit.getSegment11Id());
	            pstBankDeposit.setLong(COL_SEGMENT12_ID, bankdeposit.getSegment12Id());
	            pstBankDeposit.setLong(COL_SEGMENT13_ID, bankdeposit.getSegment13Id());
	            pstBankDeposit.setLong(COL_SEGMENT14_ID, bankdeposit.getSegment14Id());
	            pstBankDeposit.setLong(COL_SEGMENT15_ID, bankdeposit.getSegment15Id());                
                    
                    pstBankDeposit.setLong(COL_PERIODE_ID, bankdeposit.getPeriodeId());     
                    pstBankDeposit.setString(COL_RECEIVE_FROM, bankdeposit.getReceiveFrom());  

				pstBankDeposit.update(); 
				return bankdeposit.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBankDeposit(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbBankDeposit pstBankDeposit = new DbBankDeposit(oid);
			pstBankDeposit.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbBankDeposit(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_BANK_DEPOSIT; 
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
				BankDeposit bankdeposit = new BankDeposit();
				resultToObject(rs, bankdeposit);
				lists.add(bankdeposit);
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

	private static void resultToObject(ResultSet rs, BankDeposit bankdeposit){
		try{
			bankdeposit.setOID(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_BANK_DEPOSIT_ID]));
			bankdeposit.setMemo(rs.getString(DbBankDeposit.colNames[DbBankDeposit.COL_MEMO]));
			bankdeposit.setDate(rs.getDate(DbBankDeposit.colNames[DbBankDeposit.COL_DATE]));
			bankdeposit.setTransDate(rs.getDate(DbBankDeposit.colNames[DbBankDeposit.COL_TRANS_DATE]));
			bankdeposit.setOperatorId(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_OPERATOR_ID]));
			bankdeposit.setOperatorName(rs.getString(DbBankDeposit.colNames[DbBankDeposit.COL_OPERATOR_NAME]));
			bankdeposit.setJournalNumber(rs.getString(DbBankDeposit.colNames[DbBankDeposit.COL_JOURNAL_NUMBER]));
			bankdeposit.setJournalPrefix(rs.getString(DbBankDeposit.colNames[DbBankDeposit.COL_JOURNAL_PREFIX]));
			bankdeposit.setJournalCounter(rs.getInt(DbBankDeposit.colNames[DbBankDeposit.COL_JOURNAL_COUNTER]));
			bankdeposit.setCoaId(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_COA_ID]));
			bankdeposit.setAmount(rs.getDouble(DbBankDeposit.colNames[DbBankDeposit.COL_AMOUNT]));
			bankdeposit.setCurrencyId(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_CURRENCY_ID]));
                        
                        bankdeposit.setPostedStatus(rs.getInt(DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS]));
                        bankdeposit.setPostedById(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_BY_ID]));
                        bankdeposit.setPostedDate(rs.getDate(DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_DATE]));
                        bankdeposit.setEffectiveDate(rs.getDate(DbBankDeposit.colNames[DbBankDeposit.COL_EFFECTIVE_DATE]));
                        bankdeposit.setCustomerId(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_CUSTOMER_ID]));
                        
            bankdeposit.setSegment1Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT1_ID]));
            bankdeposit.setSegment2Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT2_ID]));
            bankdeposit.setSegment3Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT3_ID]));
            bankdeposit.setSegment4Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT4_ID]));
            bankdeposit.setSegment5Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT5_ID]));
            bankdeposit.setSegment6Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT6_ID]));
            bankdeposit.setSegment7Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT7_ID]));
            bankdeposit.setSegment8Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT8_ID]));
            bankdeposit.setSegment9Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT9_ID]));
            bankdeposit.setSegment10Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT10_ID]));
            bankdeposit.setSegment11Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT11_ID]));
            bankdeposit.setSegment12Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT12_ID]));
            bankdeposit.setSegment13Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT13_ID]));
            bankdeposit.setSegment14Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT14_ID]));
            bankdeposit.setSegment15Id(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_SEGMENT15_ID]));           
            bankdeposit.setPeriodeId(rs.getLong(DbBankDeposit.colNames[DbBankDeposit.COL_PERIODE_ID]));    
            bankdeposit.setReceiveFrom(rs.getString(DbBankDeposit.colNames[DbBankDeposit.COL_RECEIVE_FROM]));    

		}catch(Exception e){ 
                    System.out.println("[exception] "+e.toString());
                }
	}

	public static boolean checkOID(long bankDepositId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_BANK_DEPOSIT + " WHERE " + 
						DbBankDeposit.colNames[DbBankDeposit.COL_BANK_DEPOSIT_ID] + " = " + bankDepositId;

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
			String sql = "SELECT COUNT("+ DbBankDeposit.colNames[DbBankDeposit.COL_BANK_DEPOSIT_ID] + ") FROM " + DB_BANK_DEPOSIT;
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
			  	   BankDeposit bankdeposit = (BankDeposit)list.get(ls);
				   if(oid == bankdeposit.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static double getDeposiByPeriod(Periode openPeriod, long coaId){
                double result = 0;
                CONResultSet crs = null;
                try{
                    String sql = "select sum("+colNames[COL_AMOUNT]+") from "+DB_BANK_DEPOSIT+
                        " where ("+colNames[COL_TRANS_DATE]+" between '"+JSPFormater.formatDate(openPeriod.getStartDate(), "yyyy-MM-dd")+"'"+
                        " and '"+JSPFormater.formatDate(openPeriod.getEndDate(), "yyyy-MM-dd")+"')"+
                        " and "+colNames[COL_COA_ID]+"="+coaId;                        
                    
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
        
        public static int getNextCounter(long oid){
                int result = 0;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max(journal_counter) from "+DB_BANK_DEPOSIT+" where "+
                        " journal_prefix='"+getNumberPrefix(oid)+"' ";
                    
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
        
        public static String getNumberPrefix(long oid){
            
                Company sysCompany = DbCompany.getCompany();
                Location sysLocation = DbLocation.getLocationById(sysCompany.getSystemLocation());
                
                Coa coa = new Coa();
                try{
                    coa = DbCoa.fetchExc(oid);
                }
                catch(Exception e){                    
                }

                String code = sysLocation.getCode();
                
                if(coa.getIsNeedExtra()==1){
                    code = code + coa.getDebetPrefixCode();
                }else{
                    code = code + sysCompany.getBankDepositCode();
                }
                
                code = code + JSPFormater.formatDate(new Date(), "MMyy");
                
                return code;
        }
        
        
        public static String getNextNumber(int ctr, long oid){
            
                String code = getNumberPrefix(oid);
                
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
        public static void postJournal(BankDeposit cr, Vector details, long userId){
            
                Company comp = DbCompany.getCompany();
                ExchangeRate er = DbExchangeRate.getStandardRate();
                
                try{
                    cr = DbBankDeposit.fetchExc(cr.getOID());
                }catch(Exception e){
                    System.out.println("[exception] "+e.toString());
                }
                
                Periode periode = new Periode();
                try {
                    periode = DbPeriode.fetchExc(cr.getPeriodeId());
                } catch (Exception e) {}
                
                
                if(periode.getOID() != 0 && periode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0 && cr.getOID()!=0 && details!=null && details.size()>0){
                    
                    long oid = DbGl.postJournalMain(0, cr.getDate(), cr.getJournalCounter(), cr.getJournalNumber(), cr.getJournalPrefix(), I_Project.JOURNAL_TYPE_BANK_DEPOSIT, 
                        cr.getMemo(), userId, "", cr.getOID(), "", cr.getTransDate(), cr.getPeriodeId());
                    
                    if(oid!=0){
                        
                        for(int i=0; i<details.size(); i++){
                            
                            BankDepositDetail crd = (BankDepositDetail)details.get(i);
                            
                            if(crd.getAmount()!=0){ 
                                //journal credit pada pendapatan
                                DbGl.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), crd.getAmount(), 0,             
                                    crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo(), 0,
			                        crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
			                        crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
			                        crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
			                        crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), crd.getDepartmentId()
                                );
                            }else{
                                DbGl.postJournalDetail(crd.getBookedRate(), crd.getCoaId(), 0, crd.getCreditAmount(),             
                                    crd.getForeignAmount(), crd.getForeignCurrencyId(), oid, crd.getMemo(), 0,
			                        crd.getSegment1Id(), crd.getSegment2Id(), crd.getSegment3Id(), crd.getSegment4Id(),
			                        crd.getSegment5Id(), crd.getSegment6Id(), crd.getSegment7Id(), crd.getSegment8Id(),
			                        crd.getSegment9Id(), crd.getSegment10Id(), crd.getSegment11Id(), crd.getSegment12Id(),
			                        crd.getSegment13Id(), crd.getSegment14Id(), crd.getSegment15Id(), crd.getDepartmentId()
                                );
                            }
                        }
                        
                        //journal debet pada cash
                        DbGl.postJournalDetail(er.getValueIdr(), cr.getCoaId(), 0, cr.getAmount(),             
                                    0, comp.getBookingCurrencyId(), oid, cr.getMemo(), 0,
			                        cr.getSegment1Id(), cr.getSegment2Id(), cr.getSegment3Id(), cr.getSegment4Id(),
			                        cr.getSegment5Id(), cr.getSegment6Id(), cr.getSegment7Id(), cr.getSegment8Id(),
			                        cr.getSegment9Id(), cr.getSegment10Id(), cr.getSegment11Id(), cr.getSegment12Id(),
			                        cr.getSegment13Id(), cr.getSegment14Id(), cr.getSegment15Id(), 0
                        	);
                        
                    }
                    
                    //update status
                    if(oid!=0){
                    	try{
	                    	cr.setPostedStatus(1);
	                    	cr.setPostedById(userId);
	                    	cr.setPostedDate(new Date());
	                    	
	                    	Date dt = new Date();
	                    	String where = "'"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"' between "+
	                    		DbPeriode.colNames[DbPeriode.COL_START_DATE] +" and "+
	                    		DbPeriode.colNames[DbPeriode.COL_END_DATE];
	                    		
	                    	Vector temp = DbPeriode.list(0,0, where, "");	
	                    	
                                if(temp!=null && temp.size()>0){
                                    cr.setEffectiveDate(new Date());
	                    	}else{                    
                                    Periode per = DbPeriode.getOpenPeriod();
                                    if(cr.getPeriodeId() !=0 ){
                                        try{
                                            per = DbPeriode.fetchExc(cr.getPeriodeId());
                                        }catch(Exception e){}
                                    }
                                    cr.setEffectiveDate(per.getEndDate());
	                    	}                                   	
	                    	
	                    	DbBankDeposit.updateExc(cr);
                    	}
                    	catch(Exception e){
                    		System.out.println("[exception] "+e.toString());
                    	}
                    }
                }
        }
        
        public static void updateAmount(BankDeposit bankDeposit){
            String sql = "";
            CONResultSet crs = null;
            double amount = 0;
            try{
                sql = "SELECT sum("+DbBankDepositDetail.colNames[DbBankDepositDetail.COL_AMOUNT]+") FROM "+
                      DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL+" p where "+
                      DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID]+"="+bankDeposit.getOID();                
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    amount = rs.getDouble(1);
                }
                                
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            
            try{
                bankDeposit.setAmount(amount);
                DbBankDeposit.updateExc(bankDeposit);
            }
            catch(Exception e){
                
            }
        }

    public long insertBKM(Entity ent) throws Exception {
        return insertBKM((CrmPost) ent);
    }

    public long updateBKM(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    /**
     * @author gwawan
     * @param crmPost
     * @return
     * 
     * Fungsi untuk melakukan posting data pembayaran agar terbentuk BKM
     */
    public long insertBKM(CrmPost crmPost) {
        try {
            BankDeposit bankDeposit = new BankDeposit();
            Customer customer = DbCustomer.fetchExc(crmPost.getSaranaId());
            
            //proses main cash receive
            bankDeposit.setCoaId(crmPost.getPaymentAccountId());
            bankDeposit.setJournalNumber(crmPost.getJournalNumber());
            bankDeposit.setJournalCounter(crmPost.getJournalCounter());
            bankDeposit.setJournalPrefix(crmPost.getJournalPrefix());
            bankDeposit.setDate(crmPost.getDate());
            bankDeposit.setTransDate(crmPost.getDateTransaction());
            bankDeposit.setMemo(crmPost.getMemo());
            bankDeposit.setAmount(crmPost.getAmount());
            bankDeposit.setCustomerId(customer.getOID());
            bankDeposit.setReceiveFrom(customer.getName());
            bankDeposit.setPeriodeId(crmPost.getPeriodeId());
            bankDeposit.setOperatorId(crmPost.getPostedById());
            long oidBankDeposit = DbBankDeposit.insertExc(bankDeposit);
            
            //proses detail cash receive
            if(oidBankDeposit != 0) {
                BankDepositDetail bankDepositDetail = new BankDepositDetail();
                
                bankDepositDetail.setBankDepositId(oidBankDeposit);
                
                if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_LIMBAH) {
                    bankDepositDetail.setCoaId(crmPost.getLimbahDebetAccountId());
                } else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_IRIGASI) {
                    bankDepositDetail.setCoaId(crmPost.getIrigasiDebetAccountId());
                } else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_ASSESMENT) {
                    bankDepositDetail.setCoaId(crmPost.getAssesmentDebetAccountId());
                } else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMIN) {
                    bankDepositDetail.setCoaId(crmPost.getKominDebetAccountId());
                } else if (crmPost.getTransactionSource() == DbPembayaran.PAYMENT_SOURCE_KOMPER) {
                    bankDepositDetail.setCoaId(crmPost.getKomperDebetAccountId());
                }
                
                bankDepositDetail.setForeignCurrencyId(crmPost.getForeignCurrencyId());
                bankDepositDetail.setForeignAmount(crmPost.getForeignAmount());
                bankDepositDetail.setBookedRate(crmPost.getBookedRate());
                bankDepositDetail.setAmount(crmPost.getAmount());
                bankDepositDetail.setMemo(crmPost.getMemo());
                bankDepositDetail.setDepartmentId(crmPost.getDepartmentId());
                DbBankDepositDetail.insertExc(bankDepositDetail);
                
            }
            
            DbApprovalDoc.initiateApprovalDetail(I_Project.TYPE_APPROVAL_BKM_BANK, oidBankDeposit, bankDeposit.getAmount(), bankDeposit.getOperatorId());
            
            return oidBankDeposit;
            
        } catch(Exception e) {
            return 0;
        }
    }
    
    /**
     * Modul untuk mencari jumlah transaksi dari menu pencarian di dashboard
     * create by gwawan 201209
     * @param sNumber
     * @param sNote
     * @param sAmount
     * @param sCoa
     * @return
     */
    public static int getCountDashboard(String sNumber, String sNote, String sAmount, String sCoa) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(DISTINCT " + DB_BANK_DEPOSIT + "." + colNames[COL_BANK_DEPOSIT_ID] + ")" +
                    " FROM " + DB_BANK_DEPOSIT + " INNER JOIN " + DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL +
                    " ON " + DB_BANK_DEPOSIT + "." + colNames[COL_BANK_DEPOSIT_ID] +
                    " = " + DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL + "." + DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID] +
                    " INNER JOIN " + DbCoa.DB_COA +
                    " ON " + DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL + "." + DbBankDepositDetail.colNames[DbBankDepositDetail.COL_COA_ID] +
                    " = " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_COA_ID];
            
            String whereClause = "";
            
            if(sNumber != null && sNumber.length() > 0) {
                whereClause = DB_BANK_DEPOSIT + "." + colNames[COL_JOURNAL_NUMBER] + " LIKE '%" + sNumber + "%'";
            }
            
            if(sNote != null && sNote.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DB_BANK_DEPOSIT + "." + colNames[COL_MEMO] + " LIKE '%" + sNote + "%'" +
                        " OR " + DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL + "." + DbBankDepositDetail.colNames[DbBankDepositDetail.COL_MEMO] + " LIKE '%" + sNote + "%')";
            }
            
            if(sAmount != null && sAmount.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += DB_BANK_DEPOSIT + "." + colNames[COL_AMOUNT] + " LIKE '%" + sAmount + "%'";
            }
            
            if(sCoa != null && sCoa.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_CODE] + " LIKE '%" + sCoa + "%'" +
                        " OR " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_NAME] + " LIKE '%" + sCoa + "%')";
            }
            
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    /**
     * Modul untuk mencari daftar transaksi dari menu pencarian di dashboard
     * create by gwawan 201209
     * @param limitStart
     * @param recordToGet
     * @param sNumber
     * @param sNote
     * @param sAmount
     * @param sCoa
     * @param order
     * @return
     */
    public static Vector listDashboard(int limitStart, int recordToGet, String sNumber, String sNote, String sAmount, String sCoa, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT DISTINCT " + DB_BANK_DEPOSIT + ".*" +
                    " FROM " + DB_BANK_DEPOSIT + " INNER JOIN " + DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL +
                    " ON " + DB_BANK_DEPOSIT + "." + colNames[COL_BANK_DEPOSIT_ID] +
                    " = " + DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL + "." + DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID] +
                    " INNER JOIN " + DbCoa.DB_COA +
                    " ON " + DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL + "." + DbBankDepositDetail.colNames[DbBankDepositDetail.COL_COA_ID] +
                    " = " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_COA_ID];
            
            String whereClause = "";
            
            if(sNumber != null && sNumber.length() > 0) {
                whereClause = DB_BANK_DEPOSIT + "." + colNames[COL_JOURNAL_NUMBER] + " LIKE '%" + sNumber + "%'";
            }
            
            if(sNote != null && sNote.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DB_BANK_DEPOSIT + "." + colNames[COL_MEMO] + " LIKE '%" + sNote + "%'" +
                        " OR " + DbBankDepositDetail.DB_BANK_DEPOSIT_DETAIL + "." + DbBankDepositDetail.colNames[DbBankDepositDetail.COL_MEMO] + " LIKE '%" + sNote + "%')";
            }
            
            if(sAmount != null && sAmount.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += DB_BANK_DEPOSIT + "." + colNames[COL_AMOUNT] + " LIKE '%" + sAmount + "%'";
            }
            
            if(sCoa != null && sCoa.length() > 0) {
                if(whereClause != null && whereClause.length() > 0) {
                    whereClause += " AND ";
                }
                whereClause += "(" + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_CODE] + " LIKE '%" + sCoa + "%'" +
                        " OR " + DbCoa.DB_COA + "." + DbCoa.colNames[DbCoa.COL_NAME] + " LIKE '%" + sCoa + "%')";
            }
            
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                sql = sql + " LIMIT " + limitStart + "," + recordToGet;
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while (rs.next()) {
                BankDeposit bankdeposit = new BankDeposit();
                resultToObject(rs, bankdeposit);
                lists.add(bankdeposit);
            }
            
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }
    
    /**
     * Fungsi untuk mengambil total penerimaan bank yang masih dalam proses (DRAFT)
     * by gwawan 201212
     * @param selectedDate
     * @param oidCoa
     * @return
     */
    public static double getTotalBankDepositDraft(Date selectedDate, long oidCoa) {
        double openingBalance = 0;
        CONResultSet crs = null;
        String sql = "";
        try {
            sql = "SELECT SUM("+ colNames[COL_AMOUNT] +") FROM "+ DB_BANK_DEPOSIT+
                    " WHERE "+ colNames[COL_TRANS_DATE] +" < " +
                    " '"+ JSPFormater.formatDate(selectedDate, "yyyy-MM-dd") +"' "+
                    " AND "+ colNames[COL_COA_ID] +" = "+ oidCoa+
                    " AND "+ colNames[COL_POSTED_STATUS] +"="+ DbGl.NOT_POSTED;
            
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()) {
                openingBalance = rs.getDouble(1);
            }
            
        } catch(Exception e) {
            System.out.println("Exception on getBankDepositDraft(#,#) : "+sql);
        } finally {
            CONResultSet.close(crs);
        }
        return openingBalance;
    }
    
    /**
     * Fungsi untuk mengambil penerimaan bank yang masih dalam proses (DRAFT).
     * Untuk penerimaan bank yang POSTED, data sudah menjadi satu di GL.
     * by gwawan 201212
     * @param userId
     * @param coaId
     * @param date
     * @return
     */
    public static Vector getBankRegister(long userId, long coaId, Date date) {
        Vector result = new Vector();
        try {
            String where = "(TO_DAYS("+ colNames[COL_TRANS_DATE] +") = TO_DAYS('"+ JSPFormater.formatDate(date, "yyyy-MM-dd") +"'))"+
                    " AND "+ colNames[COL_COA_ID] +" = "+ coaId+" AND "+ colNames[COL_POSTED_STATUS] +"="+ DbGl.NOT_POSTED;
            
            Vector list = list(0, 0, where, "");
            
            if(list != null && list.size() > 0) {
                for(int i=0; i<list.size(); i++) {
                    BankDeposit bankDeposit = (BankDeposit)list.get(i);
                    
                    BankRegister bankRegister = new BankRegister();
                    bankRegister.setOID(bankDeposit.getOID());
                    bankRegister.setUserId(userId);
                    bankRegister.setDocNumber(bankDeposit.getJournalNumber());
                    bankRegister.setTransDate(bankDeposit.getTransDate());
                    bankRegister.setCheckBGNumber("");
                    bankRegister.setName(bankDeposit.getReceiveFrom());
                    bankRegister.setDescription(bankDeposit.getMemo());
                    bankRegister.setDebet(bankDeposit.getAmount());
                    bankRegister.setCredit(0);
                    bankRegister.setStatus(bankDeposit.getPostedStatus());
                    
                    result.add(bankRegister);
                }
            }
        }catch(Exception e) {
            System.out.println("[Exception] while getBankRegister(#,#,#) "+ e.toString());
        }
        return result;
    }
    
}
