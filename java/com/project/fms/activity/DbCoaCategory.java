
package com.project.fms.activity; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.fms.master.*;

public class DbCoaCategory extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_COA_CATEGORY = "coa_category";

	public static final  int COL_COA_CATEGORY_ID = 0;
	public static final  int COL_NAME = 1;
        public static final  int COL_COMPANY_ID = 2;
        public static final  int COL_USER_ID = 3;
        public static final  int COL_TYPE = 4;

	public static final  String[] colNames = {
		"coa_category_id",
		"name",
                "company_id",
                "user_id",
                "type"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_INT
	 }; 
         
         
         public static final int TYPE_INCOME = 0;
         public static final int TYPE_COGS = 1;
         public static final int TYPE_GENERAL_EXPENSE = 2;
         public static final int TYPE_DEPRECIATION = 3;
         public static final int TYPE_INTEREST_EXPENSE = 4;
         public static final int TYPE_TAX_EXPENSE = 5;
         
         public static final String[] strType = {
            "INCOME", "COST OF SALES", "GENERAL EXPENSE", "DEPRECIATION", "INTEREST EXPENSE", "TAX EXPENSE"
         };
         

	public DbCoaCategory(){
	}

	public DbCoaCategory(int i) throws CONException { 
		super(new DbCoaCategory()); 
	}

	public DbCoaCategory(String sOid) throws CONException { 
		super(new DbCoaCategory(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCoaCategory(long lOid) throws CONException { 
		super(new DbCoaCategory(0)); 
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
		return DB_COA_CATEGORY;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCoaCategory().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		CoaCategory coacategory = fetchExc(ent.getOID()); 
		ent = (Entity)coacategory; 
		return coacategory.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((CoaCategory) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((CoaCategory) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static CoaCategory fetchExc(long oid) throws CONException{ 
		try{ 
			CoaCategory coacategory = new CoaCategory();
			DbCoaCategory pstCoaCategory = new DbCoaCategory(oid); 
			coacategory.setOID(oid);

			coacategory.setName(pstCoaCategory.getString(COL_NAME));
                        coacategory.setCompanyId(pstCoaCategory.getlong(COL_COMPANY_ID));
                        coacategory.setUserId(pstCoaCategory.getlong(COL_USER_ID));
                        coacategory.setType(pstCoaCategory.getInt(COL_TYPE));

			return coacategory; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaCategory(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(CoaCategory coacategory) throws CONException{ 
		try{ 
			DbCoaCategory pstCoaCategory = new DbCoaCategory(0);

			pstCoaCategory.setString(COL_NAME, coacategory.getName());
                        pstCoaCategory.setLong(COL_COMPANY_ID, coacategory.getCompanyId());
                        pstCoaCategory.setLong(COL_USER_ID, coacategory.getUserId());
                        pstCoaCategory.setInt(COL_TYPE, coacategory.getType());

			pstCoaCategory.insert(); 
			coacategory.setOID(pstCoaCategory.getlong(COL_COA_CATEGORY_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaCategory(0),CONException.UNKNOWN); 
		}
		return coacategory.getOID();
	}

	public static long updateExc(CoaCategory coacategory) throws CONException{ 
		try{ 
			if(coacategory.getOID() != 0){ 
				DbCoaCategory pstCoaCategory = new DbCoaCategory(coacategory.getOID());

				pstCoaCategory.setString(COL_NAME, coacategory.getName());
                                pstCoaCategory.setLong(COL_COMPANY_ID, coacategory.getCompanyId());
                                pstCoaCategory.setLong(COL_USER_ID, coacategory.getUserId());
                                pstCoaCategory.setInt(COL_TYPE, coacategory.getType());

				pstCoaCategory.update(); 
				return coacategory.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaCategory(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCoaCategory pstCoaCategory = new DbCoaCategory(oid);
			pstCoaCategory.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaCategory(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_COA_CATEGORY; 
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
				CoaCategory coacategory = new CoaCategory();
				resultToObject(rs, coacategory);
				lists.add(coacategory);
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

	private static void resultToObject(ResultSet rs, CoaCategory coacategory){
		try{
			coacategory.setOID(rs.getLong(DbCoaCategory.colNames[DbCoaCategory.COL_COA_CATEGORY_ID]));
			coacategory.setName(rs.getString(DbCoaCategory.colNames[DbCoaCategory.COL_NAME]));
                        coacategory.setCompanyId(rs.getLong(DbCoaCategory.colNames[DbCoaCategory.COL_COMPANY_ID]));
                        coacategory.setUserId(rs.getLong(DbCoaCategory.colNames[DbCoaCategory.COL_USER_ID]));
                        coacategory.setType(rs.getInt(DbCoaCategory.colNames[DbCoaCategory.COL_TYPE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long coaCoaCategoryId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_COA_CATEGORY + " WHERE " + 
						DbCoaCategory.colNames[DbCoaCategory.COL_COA_CATEGORY_ID] + " = " + coaCoaCategoryId;

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
			String sql = "SELECT COUNT("+ DbCoaCategory.colNames[DbCoaCategory.COL_COA_CATEGORY_ID] + ") FROM " + DB_COA_CATEGORY;
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
			  	   CoaCategory coacategory = (CoaCategory)list.get(ls);
				   if(oid == coacategory.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static double getCoaBalance(CoaCategory cat, Periode periode){
            
            Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_COA_CATEGORY_ID]+"="+cat.getOID(), "");
            
            double result = 0;
            
            if(coas!=null && coas.size()>0){
                
                for(int i=0; i<coas.size(); i++){
                    Coa coa = (Coa)coas.get(i);
                    //jika income
                    if(cat.getType()==TYPE_INCOME){
                        //jika sd month
                        if(periode.getOID()==0){                            
                            result = result + DbCoa.getCoaBalanceCDRecursif(coa);                            
                        }
                        //jika bulan ini
                        else{
                            result = result + DbCoa.getCoaBalanceRecursif(coa,periode,"CD");
                        }
                    }
                    //jika expense
                    else{
                        //jika sd month
                        if(periode.getOID()==0){                            
                            result = result + DbCoa.getCoaBalanceRecursif(coa);                            
                        }
                        //jika bulan ini
                        else{
                            result = result + DbCoa.getCoaBalanceRecursif(coa,periode,"DC");
                        }
                        
                    }
                }
                
            }
            
            return result;
            
        }
        
        
        public static double getCoaBalanceYTD(CoaCategory cat, Periode periode){
            
            Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_COA_CATEGORY_ID]+"="+cat.getOID(), "");
            
            double result = 0; 
            
            if(coas!=null && coas.size()>0){
                
                for(int i=0; i<coas.size(); i++){
                    Coa coa = (Coa)coas.get(i);
                    //jika income
                    if(cat.getType()==TYPE_INCOME){
                        //jika sd month
                        result = result + DbCoa.getCoaBalanceYTDRecursif(coa, periode, "CD");                            
                        
                    }
                    //jika expense
                    else{
                        //jika sd month
                        result = result + DbCoa.getCoaBalanceYTDRecursif(coa, periode, "DC");
                        
                    }
                }
                
            }
            
            return result;
            
        }
        
        public static double getCoaBalanceMTD(CoaCategory cat, Periode periode){
            
            Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_COA_CATEGORY_ID]+"="+cat.getOID(), "");
            
            double result = 0; 
            
            if(coas!=null && coas.size()>0){
                
                for(int i=0; i<coas.size(); i++){
                    Coa coa = (Coa)coas.get(i);
                    //jika income
                    if(cat.getType()==TYPE_INCOME){
                        //jika sd month
                        result = result + DbCoa.getCoaBalanceMTDRecursif(coa, periode, "CD");                            
                        
                    }
                    //jika expense
                    else{
                        //jika sd month
                        result = result + DbCoa.getCoaBalanceMTDRecursif(coa, periode, "DC");
                        
                    }
                }
                
            }
            
            return result;
            
        }
        
        
        public static double getCoaBudget(CoaCategory cat, Periode periode){
            
            Date dt = new Date();
            dt = periode.getStartDate();
            int year = dt.getYear()+1900;
            
            Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_COA_CATEGORY_ID]+"="+cat.getOID(), "");
            
            double result = 0;
            
            if(coas!=null && coas.size()>0){
                
                for(int i=0; i<coas.size(); i++){
                    Coa coa = (Coa)coas.get(i);
                    CoaBudget cb = DbCoaBudget.getBudget(coa.getOID(),  year);
                    result = result + cb.getAmount();
                }
                
            }
            
            return result;
            
        }
        
}
