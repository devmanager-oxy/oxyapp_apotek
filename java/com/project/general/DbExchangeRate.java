

package com.project.general; 

/* package java */ 
import com.project.I_Project;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.DbGlDetail;
import com.project.fms.transaction.Gl;
import com.project.fms.transaction.GlDetail;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.system.DbSystemProperty;

public class DbExchangeRate extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String TBL_EXCHANGERATE = "exchangerate";

	public static final  int FLD_EXCHANGERATE_ID = 0;
	public static final  int FLD_DATE = 1;
	public static final  int FLD_VALUE_USD = 2;
        public static final  int FLD_VALUE_IDR = 3;
        public static final  int FLD_VALUE_EURO = 4;
	public static final  int FLD_STATUS = 5;	
	public static final  int FLD_USER_ID = 6;
        
        public static final  int FLD_CURRENCY_IDR_ID = 7;
        public static final  int FLD_CURRENCY_USD_ID = 8;
        public static final  int FLD_CURRENCY_EURO_ID = 9;
        
        public static final  int FLD_VALUE_YEN = 10;        
        public static final  int FLD_CURRENCY_YEN_ID = 11;        
        public static final  int FLD_VALUE_ASD = 12;        
        public static final  int FLD_CURRENCY_ASD_ID = 13;

	public static final  String[] fieldNames = {
		"exchangerate_id",
		"date",
		"value_usd",
                "value_idr",
                "value_euro",
		"status",		
		"user_id",
                "currency_idr_id",
                "currency_usd_id",
                "currency_euro_id",
                
                "value_yen",
                "currency_yen_id",
                "value_asd",
                "currency_asd_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
		TYPE_INT,		
		TYPE_LONG,                
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_LONG
	 }; 

	public DbExchangeRate(){
	}

	public DbExchangeRate(int i) throws CONException { 
		super(new DbExchangeRate()); 
	}

	public DbExchangeRate(String sOid) throws CONException { 
		super(new DbExchangeRate(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbExchangeRate(long lOid) throws CONException { 
		super(new DbExchangeRate(0)); 
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
		return fieldNames.length; 
	}

	public String getTableName(){ 
		return TBL_EXCHANGERATE;
	}

	public String[] getFieldNames(){ 
		return fieldNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbExchangeRate().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		ExchangeRate exchangerate = fetchExc(ent.getOID()); 
		ent = (Entity)exchangerate; 
		return exchangerate.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((ExchangeRate) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((ExchangeRate) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static ExchangeRate fetchExc(long oid) throws CONException{ 
		try{ 
			ExchangeRate exchangerate = new ExchangeRate();
			DbExchangeRate pstExchangeRate = new DbExchangeRate(oid); 
			exchangerate.setOID(oid);

			exchangerate.setDate(pstExchangeRate.getDate(FLD_DATE));
			exchangerate.setValueUsd(pstExchangeRate.getdouble(FLD_VALUE_USD));
			exchangerate.setValueIdr(pstExchangeRate.getdouble(FLD_VALUE_IDR));
                        exchangerate.setValueEuro(pstExchangeRate.getdouble(FLD_VALUE_EURO));
			exchangerate.setStatus(pstExchangeRate.getInt(FLD_STATUS));			
			exchangerate.setUserId(pstExchangeRate.getlong(FLD_USER_ID));
                        
                        exchangerate.setCurrencyEuroId(pstExchangeRate.getlong(FLD_CURRENCY_EURO_ID));
                        exchangerate.setCurrencyIdrId(pstExchangeRate.getlong(FLD_CURRENCY_IDR_ID));
                        exchangerate.setCurrencyUsdId(pstExchangeRate.getlong(FLD_CURRENCY_USD_ID));
                        
                        exchangerate.setValueYen(pstExchangeRate.getdouble(FLD_VALUE_YEN));
                        exchangerate.setCurrencyYenId(pstExchangeRate.getlong(FLD_CURRENCY_YEN_ID));
                        exchangerate.setValueAsd(pstExchangeRate.getdouble(FLD_VALUE_ASD));
                        exchangerate.setCurrencyAsdId(pstExchangeRate.getlong(FLD_CURRENCY_ASD_ID));
                        
			return exchangerate; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbExchangeRate(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(ExchangeRate exchangerate) throws CONException{ 
		try{ 
			DbExchangeRate pstExchangeRate = new DbExchangeRate(0);

			pstExchangeRate.setDate(FLD_DATE, exchangerate.getDate());
			pstExchangeRate.setDouble(FLD_VALUE_USD, exchangerate.getValueUsd());
                        pstExchangeRate.setDouble(FLD_VALUE_IDR, exchangerate.getValueIdr());
                        pstExchangeRate.setDouble(FLD_VALUE_EURO, exchangerate.getValueEuro());
			pstExchangeRate.setInt(FLD_STATUS, exchangerate.getStatus());
			
			pstExchangeRate.setLong(FLD_USER_ID, exchangerate.getUserId());
                        
                        pstExchangeRate.setLong(FLD_CURRENCY_EURO_ID, exchangerate.getCurrencyEuroId());
                        pstExchangeRate.setLong(FLD_CURRENCY_IDR_ID, exchangerate.getCurrencyIdrId());
                        pstExchangeRate.setLong(FLD_CURRENCY_USD_ID, exchangerate.getCurrencyUsdId());
                        
                        pstExchangeRate.setDouble(FLD_VALUE_YEN, exchangerate.getValueYen());
                        pstExchangeRate.setLong(FLD_CURRENCY_YEN_ID, exchangerate.getCurrencyYenId());
                        pstExchangeRate.setDouble(FLD_VALUE_ASD, exchangerate.getValueAsd());
                        pstExchangeRate.setLong(FLD_CURRENCY_ASD_ID, exchangerate.getCurrencyAsdId());

			pstExchangeRate.insert(); 
			exchangerate.setOID(pstExchangeRate.getlong(FLD_EXCHANGERATE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbExchangeRate(0),CONException.UNKNOWN); 
		}
		return exchangerate.getOID();
	}

	public static long updateExc(ExchangeRate exchangerate) throws CONException{ 
		try{ 
			if(exchangerate.getOID() != 0){ 
				DbExchangeRate pstExchangeRate = new DbExchangeRate(exchangerate.getOID());

				pstExchangeRate.setDate(FLD_DATE, exchangerate.getDate());
				pstExchangeRate.setDouble(FLD_VALUE_USD, exchangerate.getValueUsd());
                                pstExchangeRate.setDouble(FLD_VALUE_IDR, exchangerate.getValueIdr());
                                pstExchangeRate.setDouble(FLD_VALUE_EURO, exchangerate.getValueEuro());
				pstExchangeRate.setInt(FLD_STATUS, exchangerate.getStatus());				
				pstExchangeRate.setLong(FLD_USER_ID, exchangerate.getUserId());
                                
                                pstExchangeRate.setLong(FLD_CURRENCY_EURO_ID, exchangerate.getCurrencyEuroId());
                                pstExchangeRate.setLong(FLD_CURRENCY_IDR_ID, exchangerate.getCurrencyIdrId());
                                pstExchangeRate.setLong(FLD_CURRENCY_USD_ID, exchangerate.getCurrencyUsdId());
                                
                                pstExchangeRate.setDouble(FLD_VALUE_YEN, exchangerate.getValueYen());
                                pstExchangeRate.setLong(FLD_CURRENCY_YEN_ID, exchangerate.getCurrencyYenId());
                                pstExchangeRate.setDouble(FLD_VALUE_ASD, exchangerate.getValueAsd());
                                pstExchangeRate.setLong(FLD_CURRENCY_ASD_ID, exchangerate.getCurrencyAsdId());

				pstExchangeRate.update(); 
				return exchangerate.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbExchangeRate(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbExchangeRate pstExchangeRate = new DbExchangeRate(oid);
			pstExchangeRate.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbExchangeRate(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + TBL_EXCHANGERATE; 
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
				ExchangeRate exchangerate = new ExchangeRate();
				resultToObject(rs, exchangerate);
				lists.add(exchangerate);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e.toString());
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}

	public static void resultToObject(ResultSet rs, ExchangeRate exchangerate){
		try{
			exchangerate.setOID(rs.getLong(DbExchangeRate.fieldNames[DbExchangeRate.FLD_EXCHANGERATE_ID]));                        
			exchangerate.setValueUsd(rs.getDouble(DbExchangeRate.fieldNames[DbExchangeRate.FLD_VALUE_USD]));
                        exchangerate.setValueIdr(rs.getDouble(DbExchangeRate.fieldNames[DbExchangeRate.FLD_VALUE_IDR]));
                        exchangerate.setValueEuro(rs.getDouble(DbExchangeRate.fieldNames[DbExchangeRate.FLD_VALUE_EURO]));
			exchangerate.setStatus(rs.getInt(DbExchangeRate.fieldNames[DbExchangeRate.FLD_STATUS]));
			exchangerate.setUserId(rs.getLong(DbExchangeRate.fieldNames[DbExchangeRate.FLD_USER_ID]));
                        
                        exchangerate.setCurrencyEuroId(rs.getLong(DbExchangeRate.fieldNames[DbExchangeRate.FLD_CURRENCY_EURO_ID]));
                        exchangerate.setCurrencyIdrId(rs.getLong(DbExchangeRate.fieldNames[DbExchangeRate.FLD_CURRENCY_IDR_ID]));
                        exchangerate.setCurrencyUsdId(rs.getLong(DbExchangeRate.fieldNames[DbExchangeRate.FLD_CURRENCY_USD_ID]));
                        
                        Date dt = rs.getDate(DbExchangeRate.fieldNames[DbExchangeRate.FLD_DATE]);
                        Date time = rs.getTime(DbExchangeRate.fieldNames[DbExchangeRate.FLD_DATE]);                        
			exchangerate.setDate(dt);
                        exchangerate.setTime(time);
                        
                        exchangerate.setValueYen(rs.getDouble(DbExchangeRate.fieldNames[DbExchangeRate.FLD_VALUE_YEN]));
                        exchangerate.setValueAsd(rs.getDouble(DbExchangeRate.fieldNames[DbExchangeRate.FLD_VALUE_ASD]));                        
                        exchangerate.setCurrencyYenId(rs.getLong(DbExchangeRate.fieldNames[DbExchangeRate.FLD_CURRENCY_YEN_ID]));
                        exchangerate.setCurrencyAsdId(rs.getLong(DbExchangeRate.fieldNames[DbExchangeRate.FLD_CURRENCY_ASD_ID]));

		}catch(Exception e){
                        System.out.println(e.toString());
                }
	}

	public static boolean checkOID(long exchangerateId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + TBL_EXCHANGERATE + " WHERE " + 
						DbExchangeRate.fieldNames[DbExchangeRate.FLD_EXCHANGERATE_ID] + " = " + exchangerateId;

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
			String sql = "SELECT COUNT("+ DbExchangeRate.fieldNames[DbExchangeRate.FLD_EXCHANGERATE_ID] + ") FROM " + TBL_EXCHANGERATE;
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
			  	   ExchangeRate exchangerate = (ExchangeRate)list.get(ls);
				   if(oid == exchangerate.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static ExchangeRate getStandardRate(){
                ExchangeRate er = new ExchangeRate();
                Vector v = list(0,1, "status=0", "date desc");
                if(v!=null && v.size()>0){
                    er = (ExchangeRate)v.get(0);
                }
                return er;
        }
        
        public static ExchangeRate getStandardRate(long companyId){
                ExchangeRate er = new ExchangeRate();
                Vector v = list(0,1, "status=0 and company_id="+companyId, "date desc");
                if(v!=null && v.size()>0){
                    er = (ExchangeRate)v.get(0);
                }
                return er;
        }
        
        /**
         * Fungsi untuk melakukan proses AUTO REVERSE terhadap CoA yang terkena dampak perubahan KURS.
         * oidCoALoss adalah OID dari CoA yang sudah ditetapkan di SysProp, yang digunakan sebagai LAWAN dari CoA AUTO REVERSE.
         * 
         * OVERVIEW PROCESS
         * 
31 Des 2010 > BNI $100 @ Rp 8.900 = Rp 890.000

31 Jan 2011 > terjadi perubahan rate menjadi Rp 9.000
BNI$ $100 @ Rp 9.000 = Rp 900.000
1) BNI$ pada GAINLOSS (Rp 9.000 - Rp 8.900) * $100 = Rp 100 * $100 = Rp 10.000

28 Feb 2011 > terjadi perubahan rate menjadi Rp 9.100
BNI$ $100 @ Rp 9.100 = Rp 910.000
1) GAINLOSS pada BNI$ (Rp 9.000 - Rp 8.900) * $100 = Rp 10.000
2) BNI$ pada GAINLOSS (Rp 9.100 - Rp 8.900) * $100 = Rp 20.000

3 Mar terjadi transaksi BNI$ debet $50

31 Mar 2011 > terjadi perubahan rate menjadi Rp 9.250
BNI$ $100 @ Rp 9.250 = Rp 925.000
1) GAINLOSS pada BNI$ (Rp 9.100 - Rp 8.900) * $150 = Rp 200 & $150 = Rp 30.000
2) BNI$ pada GAINLOSS (Rp 9.250 - Rp 8.900) * $150 = Rp 52.500

30 Apr 2011 > terjadi perubahan rate menjadi Rp 9.200
BNI$ $100 @ Rp 9.200 = Rp 920.000
1) GAINLOSS pada BNI$ (Rp 9.250 - Rp 8.900) * $150 = Rp 350 * $150 = Rp 52.500
2) BNI$ pada GAINLOSS (Rp 9.200 - Rp 8.900) * $150 = Rp 45.000

31 Mei 2011 > terjadi perubahan rate menjadi Rp 9.150
BNI$ $100 @ Rp 9.150 = Rp 915.000
1) GAINLOSS pada BNI$ (Rp 9.200 - Rp 8.900) * $150 = Rp 45.000
2) BNI$ pada GAINLOSS (Rp 9.150 - Rp 8.900) * $150 = Rp 37.500
         * 
         * by gwawan 20110902
         * @param 
         * @return Process status
         */
        public static boolean generateAutoReverseGL(long exchangeRateId) {
            try {
                Periode openPeriode = DbPeriode.getOpenPeriod();
                
                Periode prevPeriode = DbPeriode.getPrevPeriode(openPeriode);
                if(!prevPeriode.getStatus().equals(I_Project.STATUS_PERIOD_CLOSED)) return false;
                
                String ID_GAIN_LOSS_ACCOUNT = DbSystemProperty.getValueByName("ID_GAIN_LOSS_ACCOUNT");
                if(ID_GAIN_LOSS_ACCOUNT.equals("Not initialized")) return false;
                long idGainLossAccount = Long.parseLong(ID_GAIN_LOSS_ACCOUNT);
                Coa xcoa = DbCoa.fetchExc(idGainLossAccount);
                if(xcoa.getOID() == 0) return false;
                
                String CURRENCY_CODE_IDR = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
                if(CURRENCY_CODE_IDR.equals("Not initialized")) return false;
                Currency currency = DbCurrency.getCurrencyByCode(CURRENCY_CODE_IDR);
                if(currency.getOID() == 0) return false;
                
                if(exchangeRateId == 0) return false;
                ExchangeRate exchangeRate = fetchExc(exchangeRateId);
                
                //get auto reverse coa
                Vector listCoA = DbCoa.listAutoReverseCoA(openPeriode.getOID());
                
                for(int i = 0; i < listCoA.size(); i++) {
                    Coa coa = (Coa)listCoA.get(i);
                    /**
                     * 1. cek, apakah sebelumnya sudah memiliki journal auto reverse, cek di history
                     * 2. jika belum, buat jurnal gainloss
                     * 3. jika sudah, buat jurnal pembalik dari jurnal gainloss sebelumnya, terus buat jurnal gainloss baru
                     * 4. buat history
                     */
                    Gl objGl = new Gl();
                    GlDetail objGlDetail = new GlDetail();
                    Date glDate = new Date();
                    long glOid = 0;
                    double amount = 0;
                    int counter = DbGl.getNextCounter();
                    
                    //get coa opening rate
                    double openingRate = getCoAOpeningRate(coa.getOID(), openPeriode.getOID());
                    
                    //get coa balance
                    double balance = DbGlDetail.getClosingBalance(coa.getOID(), openPeriode);
                    
                    //get last auto reverse history
                    AutoReverseHistory objHistory = DbAutoReverseHistory.getLatsHistory(coa.getOID());
                    
                    if(objHistory.getOID() != 0) {
                        //get coa last exchange rate
                        ExchangeRate lastRate = DbExchangeRate.fetchExc(objHistory.getExchangeRateId());
                        
                        //jurnal pembalik
                        amount = (lastRate.getValueUsd() - openingRate) * balance;
                        
                        objGl = new Gl();
                        objGl.setOID(0);
                        objGl.setJournalCounter(counter);
                        objGl.setPeriodId(openPeriode.getOID());
                        objGl.setJournalPrefix(DbGl.getNumberPrefix());
                        objGl.setJournalNumber(DbGl.getNextNumber(counter));
                        objGl.setRefNumber(DbGl.getNextNumber(counter));
                        objGl.setOperatorId(exchangeRate.getUserId());
                        objGl.setCurrencyId(currency.getOID());
                        objGl.setDate(glDate);
                        objGl.setTransDate(glDate);
                        objGl.setEffectiveDate(glDate);
                        objGl.setReversalType(I_Project.JOURNAL_TYPE_AUTO_REVERSE_BY_EXCHANGERATE);
                        glOid = DbGl.insertExc(objGl);
                        
                        if(amount > 0) {
                            objGlDetail = new GlDetail();
                            objGlDetail.setGlId(glOid);
                            objGlDetail.setCoaId(idGainLossAccount);
                            objGlDetail.setDebet(amount);
                            objGlDetail.setCredit(0);
                            objGlDetail.setForeignCurrencyId(currency.getOID());
                            objGlDetail.setForeignCurrencyAmount(amount);
                            objGlDetail.setBookedRate(1);
                            objGlDetail.setMemo("Auto reverse journal");
                            DbGlDetail.insertExc(objGlDetail);
                            
                            objGlDetail = new GlDetail();
                            objGlDetail.setGlId(glOid);
                            objGlDetail.setCoaId(coa.getOID());
                            objGlDetail.setDebet(0);
                            objGlDetail.setCredit(amount);
                            objGlDetail.setForeignCurrencyId(currency.getOID());
                            objGlDetail.setForeignCurrencyAmount(amount);
                            objGlDetail.setBookedRate(1);
                            objGlDetail.setMemo("Auto reverse journal");
                            DbGlDetail.insertExc(objGlDetail);
                            
                        } else {
                            objGlDetail = new GlDetail();
                            objGlDetail.setGlId(glOid);
                            objGlDetail.setCoaId(coa.getOID());
                            objGlDetail.setDebet(amount*(-1));
                            objGlDetail.setCredit(0);
                            objGlDetail.setForeignCurrencyId(currency.getOID());
                            objGlDetail.setForeignCurrencyAmount(amount*(-1));
                            objGlDetail.setBookedRate(1);
                            objGlDetail.setMemo("Auto reverse journal");
                            DbGlDetail.insertExc(objGlDetail);
                            
                            objGlDetail = new GlDetail();
                            objGlDetail.setGlId(glOid);
                            objGlDetail.setCoaId(idGainLossAccount);
                            objGlDetail.setDebet(0);
                            objGlDetail.setCredit(amount*(-1));
                            objGlDetail.setForeignCurrencyId(currency.getOID());
                            objGlDetail.setForeignCurrencyAmount(amount*(-1));
                            objGlDetail.setBookedRate(1);
                            objGlDetail.setMemo("Auto reverse journal");
                            DbGlDetail.insertExc(objGlDetail);
                        }
                    }
                    
                    //jurnal gainloss baru
                    amount = (exchangeRate.getValueUsd() - openingRate) * balance;
                    counter = DbGl.getNextCounter();
                    
                    objGl = new Gl();
                    objGl.setOID(0);
                    objGl.setJournalCounter(counter);
                    objGl.setPeriodId(openPeriode.getOID());
                    objGl.setJournalPrefix(DbGl.getNumberPrefix());
                    objGl.setJournalNumber(DbGl.getNextNumber(counter));
                    objGl.setRefNumber(DbGl.getNextNumber(counter));
                    objGl.setOperatorId(exchangeRate.getUserId());
                    objGl.setCurrencyId(currency.getOID());
                    objGl.setDate(glDate);
                    objGl.setTransDate(glDate);
                    objGl.setEffectiveDate(glDate);
                    objGl.setReversalType(I_Project.JOURNAL_TYPE_AUTO_REVERSE_BY_EXCHANGERATE);
                    glOid = DbGl.insertExc(objGl);
                    
                    if (amount > 0) {
                        objGlDetail = new GlDetail();
                        objGlDetail.setGlId(glOid);
                        objGlDetail.setCoaId(coa.getOID());
                        objGlDetail.setDebet(amount);
                        objGlDetail.setCredit(0);
                        objGlDetail.setForeignCurrencyId(currency.getOID());
                        objGlDetail.setForeignCurrencyAmount(amount);
                        objGlDetail.setBookedRate(1);
                        objGlDetail.setMemo("Auto reverse journal [NEW]");
                        DbGlDetail.insertExc(objGlDetail);

                        objGlDetail = new GlDetail();
                        objGlDetail.setGlId(glOid);
                        objGlDetail.setCoaId(idGainLossAccount);
                        objGlDetail.setDebet(0);
                        objGlDetail.setCredit(amount);
                        objGlDetail.setForeignCurrencyId(currency.getOID());
                        objGlDetail.setForeignCurrencyAmount(amount);
                        objGlDetail.setBookedRate(1);
                        objGlDetail.setMemo("Auto reverse journal [NEW]");
                        DbGlDetail.insertExc(objGlDetail);

                    } else {
                        objGlDetail = new GlDetail();
                        objGlDetail.setGlId(glOid);
                        objGlDetail.setCoaId(idGainLossAccount);
                        objGlDetail.setDebet(amount*(-1));
                        objGlDetail.setCredit(0);
                        objGlDetail.setForeignCurrencyId(currency.getOID());
                        objGlDetail.setForeignCurrencyAmount(amount*(-1));
                        objGlDetail.setBookedRate(1);
                        objGlDetail.setMemo("Auto reverse journal [NEW]");
                        DbGlDetail.insertExc(objGlDetail);

                        objGlDetail = new GlDetail();
                        objGlDetail.setGlId(glOid);
                        objGlDetail.setCoaId(coa.getOID());
                        objGlDetail.setDebet(0);
                        objGlDetail.setCredit(amount*(-1));
                        objGlDetail.setForeignCurrencyId(currency.getOID());
                        objGlDetail.setForeignCurrencyAmount(amount*(-1));
                        objGlDetail.setBookedRate(1);
                        objGlDetail.setMemo("Auto reverse journal [NEW]");
                        DbGlDetail.insertExc(objGlDetail);
                    }
                    
                    //create history
                    AutoReverseHistory newHistory = new AutoReverseHistory();
                    newHistory.setGlId(glOid);
                    newHistory.setGlDate(glDate);
                    newHistory.setExchangeRateId(exchangeRate.getOID());
                    newHistory.setCoaId(coa.getOID());
                    DbAutoReverseHistory.insertExc(newHistory);
                }
            } catch(Exception e) {
                System.out.println("Exception on generateAutoReverseGL : "+e.toString());
                return false;
            }
            return true;
        }
        
        /**
         * Fungsi untuk mendapatkan opening rate dari sebuah account yg auto reverse
         * by gwawan 20110906
         * @return
         */
        public static double getCoAOpeningRate(long coaId, long periodId) {
            double openingRate = 0;
            CONResultSet dbrs = null;
            
            try {
                String sql = "SELECT gld.booked_rate" +
                        " FROM gl INNER JOIN gl_detail gld ON gl.gl_id = gld.gl_id" +
                        " INNER JOIN coa ON gld.coa_id = coa.coa_id" +
                        " WHERE coa.auto_reverse = " + DbCoa.AUTO_REVERSE + 
                        " AND coa.coa_id = '" + coaId + "'" +
                        " AND gl.reversal_type != " + I_Project.JOURNAL_TYPE_AUTO_REVERSE_BY_EXCHANGERATE +
                        " AND gl.posted_status = " + DbGl.POSTED +
                        " AND gl."+ DbGl.colNames[DbGl.COL_PERIOD_ID] +" = "+ periodId +
                        " ORDER BY date ASC LIMIT 1";
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                
                while(rs.next()) {
                    openingRate = rs.getDouble("gld.booked_rate");
                }
            } catch(Exception e) {
                System.out.println("Exception getOpeningRateCoA : "+e.toString());
            }
            return openingRate;
        }
}
