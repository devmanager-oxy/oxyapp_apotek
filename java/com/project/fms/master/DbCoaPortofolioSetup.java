package com.project.fms.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.I_Language;
import com.project.util.*;
import com.project.*;

public class DbCoaPortofolioSetup extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_COA_PORTOFOLIO_SETUP = "coa_portofolio_setup";

	public static final  int COL_PORTOFOLIO_SETUP_ID = 0;
	public static final  int COL_NOTE = 1;
	public static final  int COL_PERIODE_ID = 2;
	public static final  int COL_COA_REVENUE_ID = 3;
	public static final  int COL_COA_EXPENSE_ID = 4;
	public static final  int COL_LEVEL = 5;
	public static final  int COL_COA_REF_ID = 6;
	public static final  int COL_STATUS = 7;
	public static final  int COL_COA_STATUS = 8;
        
        public static final  int COL_TARGET_LABA    = 9;
        public static final  int COL_REAL_SD_PDPT   = 10;
        public static final  int COL_REAL_SD_BIAYA  = 11;
        public static final  int COL_REAL_SD_PERCENT    = 12;
        public static final  int COL_REAL_PDPT          = 13;
        public static final  int COL_REAL_BIAYA         = 14;
        public static final  int COL_REAL_PERCENT       = 15;
        
        public static final  int COL_COA_CODE       = 16;
        public static final  int COL_TYPE       = 17;

	public static final  String[] colNames = {
		"portofolio_setup_id",
                "note",
                "periode_id",
                "coa_revenue_id",
                "coa_expense_id",
                "level",
                "coa_ref_id",
                "status",
                "coa_status",
                
                "target_laba",
                "real_sd_pdpt",
                "real_sd_biaya",
                "real_sd_percent",
                "real_pdpt",
                "real_biaya",
                "real_percent",
                "coa_code",
                "type"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_INT,
		TYPE_LONG,
		TYPE_INT,
		TYPE_STRING,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_STRING,
                TYPE_INT
	 }; 
         
        public static int TYPE_PORTO_INCOME = 0;
        public static int TYPE_PORTO_OTHER_INCOME = 1;
        public static int TYPE_PORTO_OTHER_EXPENSE = 2;
        public static int TYPE_PORTO_GENERAL_EXPENSE = 3;
        public static int TYPE_PORTO_INTEREST_EXPENSE = 4;
        public static int TYPE_PORTO_TAX_EXPENSE = 5;
        
        public static String[] strPortoType = {
            "Income & Expense", "Other Income", "Other Expense", "General Expense", "Interest Expense", "Tax Expense"
        };

	public DbCoaPortofolioSetup(){
	}

	public DbCoaPortofolioSetup(int i) throws CONException { 
		super(new DbCoaPortofolioSetup()); 
	}

	public DbCoaPortofolioSetup(String sOid) throws CONException { 
		super(new DbCoaPortofolioSetup(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCoaPortofolioSetup(long lOid) throws CONException { 
		super(new DbCoaPortofolioSetup(0)); 
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
		return DB_COA_PORTOFOLIO_SETUP;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCoaPortofolioSetup().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		CoaPortofolioSetup coaportofoliosetup = fetchExc(ent.getOID()); 
		ent = (Entity)coaportofoliosetup; 
		return coaportofoliosetup.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((CoaPortofolioSetup) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((CoaPortofolioSetup) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static CoaPortofolioSetup fetchExc(long oid) throws CONException{ 
		try{ 
			CoaPortofolioSetup coaportofoliosetup = new CoaPortofolioSetup();
			DbCoaPortofolioSetup pstCoaPortofolioSetup = new DbCoaPortofolioSetup(oid); 
			coaportofoliosetup.setOID(oid);

			coaportofoliosetup.setNote(pstCoaPortofolioSetup.getString(COL_NOTE));
			coaportofoliosetup.setPeriodeId(pstCoaPortofolioSetup.getlong(COL_PERIODE_ID));
			coaportofoliosetup.setCoaRevenueId(pstCoaPortofolioSetup.getlong(COL_COA_REVENUE_ID));
			coaportofoliosetup.setCoaExpenseId(pstCoaPortofolioSetup.getlong(COL_COA_EXPENSE_ID));
			coaportofoliosetup.setLevel(pstCoaPortofolioSetup.getInt(COL_LEVEL));
			coaportofoliosetup.setCoaRefId(pstCoaPortofolioSetup.getlong(COL_COA_REF_ID));
			coaportofoliosetup.setStatus(pstCoaPortofolioSetup.getInt(COL_STATUS));
			coaportofoliosetup.setCoaStatus(pstCoaPortofolioSetup.getString(COL_COA_STATUS));
                        
                        coaportofoliosetup.setTargetLaba(pstCoaPortofolioSetup.getdouble(COL_TARGET_LABA));
                        coaportofoliosetup.setRealSdPdpt(pstCoaPortofolioSetup.getdouble(COL_REAL_SD_PDPT));
                        coaportofoliosetup.setRealSdBiaya(pstCoaPortofolioSetup.getdouble(COL_REAL_SD_BIAYA));
                        coaportofoliosetup.setRealSdPercent(pstCoaPortofolioSetup.getdouble(COL_REAL_SD_PERCENT));
                        coaportofoliosetup.setRealPdpt(pstCoaPortofolioSetup.getdouble(COL_REAL_PDPT));
                        coaportofoliosetup.setRealBiaya(pstCoaPortofolioSetup.getdouble(COL_REAL_BIAYA));
                        coaportofoliosetup.setRealPercent(pstCoaPortofolioSetup.getdouble(COL_REAL_PERCENT));
                        coaportofoliosetup.setCoaCode(pstCoaPortofolioSetup.getString(COL_COA_CODE));
                        coaportofoliosetup.setType(pstCoaPortofolioSetup.getInt(COL_TYPE));
                        
			return coaportofoliosetup; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaPortofolioSetup(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(CoaPortofolioSetup coaportofoliosetup) throws CONException{ 
		try{ 
			DbCoaPortofolioSetup pstCoaPortofolioSetup = new DbCoaPortofolioSetup(0);

			pstCoaPortofolioSetup.setString(COL_NOTE, coaportofoliosetup.getNote());
			pstCoaPortofolioSetup.setLong(COL_PERIODE_ID, coaportofoliosetup.getPeriodeId());
			pstCoaPortofolioSetup.setLong(COL_COA_REVENUE_ID, coaportofoliosetup.getCoaRevenueId());
			pstCoaPortofolioSetup.setLong(COL_COA_EXPENSE_ID, coaportofoliosetup.getCoaExpenseId());
			pstCoaPortofolioSetup.setInt(COL_LEVEL, coaportofoliosetup.getLevel());
			pstCoaPortofolioSetup.setLong(COL_COA_REF_ID, coaportofoliosetup.getCoaRefId());
			pstCoaPortofolioSetup.setInt(COL_STATUS, coaportofoliosetup.getStatus());
			pstCoaPortofolioSetup.setString(COL_COA_STATUS, coaportofoliosetup.getCoaStatus());
                        
                        pstCoaPortofolioSetup.setDouble(COL_TARGET_LABA, coaportofoliosetup.getTargetLaba());
                        pstCoaPortofolioSetup.setDouble(COL_REAL_SD_BIAYA, coaportofoliosetup.getRealSdBiaya());
                        pstCoaPortofolioSetup.setDouble(COL_REAL_SD_PDPT, coaportofoliosetup.getRealSdPdpt());
                        pstCoaPortofolioSetup.setDouble(COL_REAL_SD_PERCENT, coaportofoliosetup.getRealSdPercent());
                        pstCoaPortofolioSetup.setDouble(COL_REAL_BIAYA, coaportofoliosetup.getRealBiaya());
                        pstCoaPortofolioSetup.setDouble(COL_REAL_PDPT, coaportofoliosetup.getRealPdpt());
                        pstCoaPortofolioSetup.setDouble(COL_REAL_PERCENT, coaportofoliosetup.getRealPercent());
                        pstCoaPortofolioSetup.setString(COL_COA_CODE, coaportofoliosetup.getCoaCode());
                        pstCoaPortofolioSetup.setInt(COL_TYPE, coaportofoliosetup.getType());

			pstCoaPortofolioSetup.insert(); 
			coaportofoliosetup.setOID(pstCoaPortofolioSetup.getlong(COL_PORTOFOLIO_SETUP_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaPortofolioSetup(0),CONException.UNKNOWN); 
		}
		return coaportofoliosetup.getOID();
	}

	public static long updateExc(CoaPortofolioSetup coaportofoliosetup) throws CONException{ 
		try{ 
			if(coaportofoliosetup.getOID() != 0){ 
				DbCoaPortofolioSetup pstCoaPortofolioSetup = new DbCoaPortofolioSetup(coaportofoliosetup.getOID());

				pstCoaPortofolioSetup.setString(COL_NOTE, coaportofoliosetup.getNote());
				pstCoaPortofolioSetup.setLong(COL_PERIODE_ID, coaportofoliosetup.getPeriodeId());
				pstCoaPortofolioSetup.setLong(COL_COA_REVENUE_ID, coaportofoliosetup.getCoaRevenueId());
				pstCoaPortofolioSetup.setLong(COL_COA_EXPENSE_ID, coaportofoliosetup.getCoaExpenseId());
				pstCoaPortofolioSetup.setInt(COL_LEVEL, coaportofoliosetup.getLevel());
				pstCoaPortofolioSetup.setLong(COL_COA_REF_ID, coaportofoliosetup.getCoaRefId());
				pstCoaPortofolioSetup.setInt(COL_STATUS, coaportofoliosetup.getStatus());
				pstCoaPortofolioSetup.setString(COL_COA_STATUS, coaportofoliosetup.getCoaStatus());
                                
                                pstCoaPortofolioSetup.setDouble(COL_TARGET_LABA, coaportofoliosetup.getTargetLaba());
                                pstCoaPortofolioSetup.setDouble(COL_REAL_SD_BIAYA, coaportofoliosetup.getRealSdBiaya());
                                pstCoaPortofolioSetup.setDouble(COL_REAL_SD_PDPT, coaportofoliosetup.getRealSdPdpt());
                                pstCoaPortofolioSetup.setDouble(COL_REAL_SD_PERCENT, coaportofoliosetup.getRealSdPercent());
                                pstCoaPortofolioSetup.setDouble(COL_REAL_BIAYA, coaportofoliosetup.getRealBiaya());
                                pstCoaPortofolioSetup.setDouble(COL_REAL_PDPT, coaportofoliosetup.getRealPdpt());
                                pstCoaPortofolioSetup.setDouble(COL_REAL_PERCENT, coaportofoliosetup.getRealPercent());
                                pstCoaPortofolioSetup.setString(COL_COA_CODE, coaportofoliosetup.getCoaCode());
                                pstCoaPortofolioSetup.setInt(COL_TYPE, coaportofoliosetup.getType());

				pstCoaPortofolioSetup.update(); 
				return coaportofoliosetup.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaPortofolioSetup(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCoaPortofolioSetup pstCoaPortofolioSetup = new DbCoaPortofolioSetup(oid);
			pstCoaPortofolioSetup.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaPortofolioSetup(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_COA_PORTOFOLIO_SETUP; 
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
				CoaPortofolioSetup coaportofoliosetup = new CoaPortofolioSetup();
				resultToObject(rs, coaportofoliosetup);
				lists.add(coaportofoliosetup);
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

	private static void resultToObject(ResultSet rs, CoaPortofolioSetup coaportofoliosetup){
		try{
			coaportofoliosetup.setOID(rs.getLong(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_PORTOFOLIO_SETUP_ID]));
			coaportofoliosetup.setNote(rs.getString(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_NOTE]));
			coaportofoliosetup.setPeriodeId(rs.getLong(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_PERIODE_ID]));
			coaportofoliosetup.setCoaRevenueId(rs.getLong(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_COA_REVENUE_ID]));
			coaportofoliosetup.setCoaExpenseId(rs.getLong(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_COA_EXPENSE_ID]));
			coaportofoliosetup.setLevel(rs.getInt(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_LEVEL]));
			coaportofoliosetup.setCoaRefId(rs.getLong(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_COA_REF_ID]));
			coaportofoliosetup.setStatus(rs.getInt(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_STATUS]));
			coaportofoliosetup.setCoaStatus(rs.getString(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_COA_STATUS]));
                        
                        coaportofoliosetup.setTargetLaba(rs.getDouble(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_TARGET_LABA]));
                        coaportofoliosetup.setRealBiaya(rs.getDouble(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_REAL_BIAYA]));
                        coaportofoliosetup.setRealPdpt(rs.getDouble(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_REAL_PDPT]));
                        coaportofoliosetup.setRealPercent(rs.getDouble(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_REAL_PERCENT]));
                        coaportofoliosetup.setRealSdBiaya(rs.getDouble(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_REAL_SD_BIAYA]));
                        coaportofoliosetup.setRealSdPdpt(rs.getDouble(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_REAL_SD_PDPT]));
                        coaportofoliosetup.setRealSdPercent(rs.getDouble(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_REAL_SD_PERCENT]));
                        coaportofoliosetup.setCoaCode(rs.getString(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_COA_CODE]));
                        coaportofoliosetup.setType(rs.getInt(DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_TYPE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long portofolioSetupId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_COA_PORTOFOLIO_SETUP + " WHERE " + 
						DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_PORTOFOLIO_SETUP_ID] + " = " + portofolioSetupId;

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
			String sql = "SELECT COUNT("+ DbCoaPortofolioSetup.colNames[DbCoaPortofolioSetup.COL_PORTOFOLIO_SETUP_ID] + ") FROM " + DB_COA_PORTOFOLIO_SETUP;
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
			  	   CoaPortofolioSetup coaportofoliosetup = (CoaPortofolioSetup)list.get(ls);
				   if(oid == coaportofoliosetup.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static void setPortofolioValue(long periodeId){
                
                int year = 0;
                Periode periode = new Periode();
                try{
                    periode = DbPeriode.fetchExc(periodeId);
                    Date startDate = new Date();
                    year = startDate.getYear()+1900;
                }
                catch(Exception e){
                }
            
                if(periode.getStatus().equals(I_Project.STATUS_PERIOD_OPEN)){
                    
                    Vector portofolios = list(0,0, colNames[COL_PERIODE_ID]+"="+periodeId, colNames[COL_TYPE]+","+colNames[COL_COA_CODE]);

                    if(portofolios!=null && portofolios.size()>0){
                        
                        for(int i=0; i<portofolios.size(); i++){
                            
                            CoaPortofolioSetup pf = (CoaPortofolioSetup)portofolios.get(i);                            
                            
                            Coa coaIncome = new Coa();
                            Coa coaExpense = new Coa();

                            try{
                                coaIncome = DbCoa.fetchExc(pf.getCoaRevenueId());
                            }
                            catch(Exception e){ ; }

                            try{
                                coaExpense = DbCoa.fetchExc(pf.getCoaExpenseId());
                            }
                            catch(Exception e){ ; }
                            
                            // ========== setup value ============                            
                            pf.setTargetLaba(getTargetLaba(pf, coaIncome, coaExpense, year));
                            
                            System.out.println("\n\n=======================> pendaptan SD");
                            pf.setRealSdPdpt(getPdptSD(pf, coaIncome, periode));
                            System.out.println("\n\n=======================> biaya SD ");
                            pf.setRealSdBiaya(getBiayaSD(pf, coaExpense, periode));
                            System.out.println("\n\n=======================> pendapatan today ");
                            pf.setRealPdpt(getPdptMth(pf, coaIncome, periode));
                            System.out.println("\n\n=======================> biaya today ");
                            pf.setRealBiaya(getBiayaMth(pf, coaExpense, periode));
                            
                            try{
                                DbCoaPortofolioSetup.updateExc(pf);
                            }
                            catch(Exception e){
                            }
                            
                        }
                    }
                }
                
        }
        
        
        public static double getTargetLaba(CoaPortofolioSetup pf, Coa coaIncome, Coa coaExpense, int year){
            
            double result = 0;
            
            if(pf.getType()==TYPE_PORTO_INCOME 
            || pf.getType()==TYPE_PORTO_OTHER_INCOME){                                                    
                
                result = DbCoaBudget.getBudgetRecursif(coaIncome, year);
                result = result - DbCoaBudget.getBudgetRecursif(coaExpense, year); 
                
            }            
            else if(pf.getType()==TYPE_PORTO_OTHER_EXPENSE 
            || pf.getType()==TYPE_PORTO_GENERAL_EXPENSE
            || pf.getType()==TYPE_PORTO_INTEREST_EXPENSE
            || pf.getType()==TYPE_PORTO_TAX_EXPENSE
            ){
                
                result = DbCoaBudget.getBudgetRecursif(coaExpense, year);
                
            }            
            
            return result;
            
        }
        
        
        public static double getPdptSD(CoaPortofolioSetup pf, Coa coaIncome, Periode per){
            
            double result = 0;
            
            if(coaIncome.getOID()!=0){
            //if(pf.getType()==TYPE_PORTO_INCOME 
            //|| pf.getType()==TYPE_PORTO_OTHER_INCOME){                                                    
                
                result = DbCoa.getCoaBalanceYTDRecursif(coaIncome, per, "CD");
                
            //}            
            }
            return result;
            
        }
        
        public static double getBiayaSD(CoaPortofolioSetup pf, Coa coaExpense, Periode per){
            
            double result = 0;
            
            if(coaExpense.getOID()!=0){
            //if(pf.getType()==TYPE_PORTO_OTHER_EXPENSE 
            //|| pf.getType()==TYPE_PORTO_GENERAL_EXPENSE
            //|| pf.getType()==TYPE_PORTO_INTEREST_EXPENSE
            //|| pf.getType()==TYPE_PORTO_TAX_EXPENSE
            //){                                                 
                
                result = DbCoa.getCoaBalanceYTDRecursif(coaExpense, per, "DC");
                
            //}            
            }
            return result;
            
        }
                
        public static double getPdptMth(CoaPortofolioSetup pf, Coa coaIncome, Periode periode){
            
            double result = 0;
            
            if(coaIncome.getOID()!=0){
            //if(pf.getType()==TYPE_PORTO_INCOME 
            //|| pf.getType()==TYPE_PORTO_OTHER_INCOME){                                                    
                
                result = DbCoa.getCoaBalanceMTDRecursif(coaIncome,periode,"CD");
                
            //}  
            }
            return result;
            
        }
        
        public static double getBiayaMth(CoaPortofolioSetup pf, Coa coaExpense, Periode periode){
            
            double result = 0;
            
            if(coaExpense.getOID()!=0){
            //if(pf.getType()==TYPE_PORTO_OTHER_EXPENSE 
            //|| pf.getType()==TYPE_PORTO_GENERAL_EXPENSE
            //|| pf.getType()==TYPE_PORTO_INTEREST_EXPENSE
            //|| pf.getType()==TYPE_PORTO_TAX_EXPENSE
           // ){                                                 
                
                result = DbCoa.getCoaBalanceMTDRecursif(coaExpense,periode,"DC");
                
            //}  
            }
            
            return result;
            
        }
        
        
        public static void copyPreviousSetup(long currPeriodId){
            
            deleteByPeriodId(currPeriodId);
            Periode p = new Periode();
            Date dt = new Date();
            try{
                p = DbPeriode.fetchExc(currPeriodId);
                dt = p.getStartDate();
                dt.setMonth(dt.getMonth()-1);
            }
            catch(Exception e){
            }
            
            Periode prevPeriode = DbPeriode.getPeriodByTransDate(dt);
	    
            Vector v = list(0,0, colNames[COL_PERIODE_ID]+"="+prevPeriode.getOID(), "");
            if(v!=null && v.size()>0){
                for(int i=0; i<v.size(); i++){
                    CoaPortofolioSetup ps = (CoaPortofolioSetup)v.get(i);
                    ps.setPeriodeId(currPeriodId);
                    ps.setRealBiaya(0);
                    ps.setRealPdpt(0);
                    ps.setRealPercent(0);
                    ps.setRealSdBiaya(0);
                    ps.setRealSdPdpt(0);
                    ps.setRealSdPercent(0);
                    try{
                        DbCoaPortofolioSetup.insertExc(ps);
                    }
                    catch(Exception e){
                    }
                }
            }
            
        }
        
        public static void deleteByPeriodId(long periodeId){
            String sql = "delete from "+DB_COA_PORTOFOLIO_SETUP+" where "+colNames[COL_PERIODE_ID]+"="+periodeId;
            try{
                CONHandler.execUpdate(sql);
            }
            catch(Exception e){
            }
        }
        
        
}
