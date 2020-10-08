package com.project.fms.activity; 

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.*;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.Periode;
import com.project.fms.reportform.DbRptFormatDetailCoa;
import com.project.fms.reportform.RptFormatDetailCoa;
import com.project.util.lang.*;

public class DbModuleBudget extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_MODULE_BUDGET = "module_budget";

	public static final  int COL_MODULE_BUDGET_ID = 0;
	public static final  int COL_COA_ID = 1;
	public static final  int COL_DESCRIPTION = 2;
	public static final  int COL_AMOUNT = 3;
	public static final  int COL_CURRENCY_ID = 4;
	public static final  int COL_MODULE_ID = 5;
	public static final  int COL_AMOUNT_USED = 6;
        public static final  int COL_STATUS = 7;
        public static final  int COL_REF_HISTORY_ID = 8;
        public static final  int COL_USER_UPDATE_ID = 9;
        public static final  int COL_UPDATE_DATE = 10;

	public static final  String[] colNames = {
		"module_budget_id",
		"coa_id",
		"description",
		"amount",
		"currency_id",
		"module_id",
		"amount_used",
                "status",
                "ref_history_id",
                "user_update_id",
                "update_date"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_DATE
	 }; 
        
        public static final int DOC_NOT_HISTORY     = 0;
        public static final int DOC_HISTORY         = 1;        

	public DbModuleBudget(){
	}

	public DbModuleBudget(int i) throws CONException { 
		super(new DbModuleBudget()); 
	}

	public DbModuleBudget(String sOid) throws CONException { 
		super(new DbModuleBudget(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbModuleBudget(long lOid) throws CONException { 
		super(new DbModuleBudget(0)); 
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
		return DB_MODULE_BUDGET;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbModuleBudget().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		ModuleBudget modulebudget = fetchExc(ent.getOID()); 
		ent = (Entity)modulebudget; 
		return modulebudget.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((ModuleBudget) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((ModuleBudget) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static ModuleBudget fetchExc(long oid) throws CONException{ 
		try{ 
			ModuleBudget modulebudget = new ModuleBudget();
			DbModuleBudget pstModuleBudget = new DbModuleBudget(oid); 
			modulebudget.setOID(oid);

			modulebudget.setCoaId(pstModuleBudget.getlong(COL_COA_ID));
			modulebudget.setDescription(pstModuleBudget.getString(COL_DESCRIPTION));
			modulebudget.setAmount(pstModuleBudget.getdouble(COL_AMOUNT));
			modulebudget.setCurrencyId(pstModuleBudget.getlong(COL_CURRENCY_ID));
			modulebudget.setModuleId(pstModuleBudget.getlong(COL_MODULE_ID));
			modulebudget.setAmountUsed(pstModuleBudget.getdouble(COL_AMOUNT_USED));
                        modulebudget.setStatus(pstModuleBudget.getInt(COL_STATUS));
                        
                        modulebudget.setRefHistoryId(pstModuleBudget.getlong(COL_REF_HISTORY_ID));
                        modulebudget.setUserUpdateId(pstModuleBudget.getlong(COL_USER_UPDATE_ID));
                        modulebudget.setUpdateDate(pstModuleBudget.getDate(COL_UPDATE_DATE));

			return modulebudget; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbModuleBudget(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(ModuleBudget modulebudget) throws CONException{ 
		try{ 
			DbModuleBudget pstModuleBudget = new DbModuleBudget(0);

			pstModuleBudget.setLong(COL_COA_ID, modulebudget.getCoaId());
			pstModuleBudget.setString(COL_DESCRIPTION, modulebudget.getDescription());
			pstModuleBudget.setDouble(COL_AMOUNT, modulebudget.getAmount());
			pstModuleBudget.setLong(COL_CURRENCY_ID, modulebudget.getCurrencyId());
			pstModuleBudget.setLong(COL_MODULE_ID, modulebudget.getModuleId());
			pstModuleBudget.setDouble(COL_AMOUNT_USED, modulebudget.getAmountUsed());
                        pstModuleBudget.setInt(COL_STATUS, modulebudget.getStatus());                        
                        pstModuleBudget.setLong(COL_REF_HISTORY_ID, modulebudget.getRefHistoryId());
                        pstModuleBudget.setLong(COL_USER_UPDATE_ID, modulebudget.getUserUpdateId());
                        pstModuleBudget.setDate(COL_UPDATE_DATE, modulebudget.getUpdateDate());
			pstModuleBudget.insert(); 
			modulebudget.setOID(pstModuleBudget.getlong(COL_MODULE_BUDGET_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbModuleBudget(0),CONException.UNKNOWN); 
		}
		return modulebudget.getOID();
	}

	public static long updateExc(ModuleBudget modulebudget) throws CONException{ 
		try{ 
			if(modulebudget.getOID() != 0){ 
				DbModuleBudget pstModuleBudget = new DbModuleBudget(modulebudget.getOID());

				pstModuleBudget.setLong(COL_COA_ID, modulebudget.getCoaId());
				pstModuleBudget.setString(COL_DESCRIPTION, modulebudget.getDescription());
				pstModuleBudget.setDouble(COL_AMOUNT, modulebudget.getAmount());
				pstModuleBudget.setLong(COL_CURRENCY_ID, modulebudget.getCurrencyId());
				pstModuleBudget.setLong(COL_MODULE_ID, modulebudget.getModuleId());
				pstModuleBudget.setDouble(COL_AMOUNT_USED, modulebudget.getAmountUsed());
                                pstModuleBudget.setInt(COL_STATUS, modulebudget.getStatus());
                                pstModuleBudget.setLong(COL_REF_HISTORY_ID, modulebudget.getRefHistoryId());
                                pstModuleBudget.setLong(COL_USER_UPDATE_ID, modulebudget.getUserUpdateId());
                                pstModuleBudget.setDate(COL_UPDATE_DATE, modulebudget.getUpdateDate());

				pstModuleBudget.update(); 
				return modulebudget.getOID();
			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbModuleBudget(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbModuleBudget pstModuleBudget = new DbModuleBudget(oid);
			pstModuleBudget.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbModuleBudget(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_MODULE_BUDGET; 
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
				ModuleBudget modulebudget = new ModuleBudget();
				resultToObject(rs, modulebudget);
				lists.add(modulebudget);
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

	private static void resultToObject(ResultSet rs, ModuleBudget modulebudget){
		try{
			modulebudget.setOID(rs.getLong(DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_BUDGET_ID]));
			modulebudget.setCoaId(rs.getLong(DbModuleBudget.colNames[DbModuleBudget.COL_COA_ID]));
			modulebudget.setDescription(rs.getString(DbModuleBudget.colNames[DbModuleBudget.COL_DESCRIPTION]));
			modulebudget.setAmount(rs.getDouble(DbModuleBudget.colNames[DbModuleBudget.COL_AMOUNT]));
			modulebudget.setCurrencyId(rs.getLong(DbModuleBudget.colNames[DbModuleBudget.COL_CURRENCY_ID]));
			modulebudget.setModuleId(rs.getLong(DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID]));
			modulebudget.setAmountUsed(rs.getDouble(DbModuleBudget.colNames[DbModuleBudget.COL_AMOUNT_USED]));
                        modulebudget.setStatus(rs.getInt(DbModuleBudget.colNames[DbModuleBudget.COL_STATUS]));
                        
                        modulebudget.setRefHistoryId(rs.getLong(DbModuleBudget.colNames[DbModuleBudget.COL_REF_HISTORY_ID]));
                        modulebudget.setUserUpdateId(rs.getLong(DbModuleBudget.colNames[DbModuleBudget.COL_USER_UPDATE_ID]));
                        modulebudget.setUpdateDate(rs.getDate(DbModuleBudget.colNames[DbModuleBudget.COL_UPDATE_DATE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long moduleBudgetId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_MODULE_BUDGET + " WHERE " + 
						DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_BUDGET_ID] + " = " + moduleBudgetId;

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
			String sql = "SELECT COUNT("+ DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_BUDGET_ID] + ") FROM " + DB_MODULE_BUDGET;
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
			  	   ModuleBudget modulebudget = (ModuleBudget)list.get(ls);
				   if(oid == modulebudget.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
	public static void updateBudgetUsed(long moduleId, long coaId, double amount){
		
		String where = colNames[COL_COA_ID]+"="+coaId+" and "+colNames[COL_MODULE_ID]+"="+moduleId;
		Vector temp = list(0,0, where, "");
		if(temp!=null && temp.size()>0){
			ModuleBudget mb = (ModuleBudget)temp.get(0);
			try{
				mb.setAmountUsed(mb.getAmountUsed()+amount);
				long oid = updateExc(mb);
				if(oid!=0){
					DbModule.updateBudgetUsedRecursif(moduleId, amount);
				}
			}
			catch(Exception e){
			
			}
		}
	}
        
        public static double getAmountInPeriod(long periodId, long coaId){

            double result = 0;

            Periode periode = new Periode();

            if (periodId == 0 || coaId == 0) {
                return 0;
            }

            try {
                periode = DbPeriode.fetchExc(periodId);
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            String sql = "";
            int year = periode.getEndDate().getYear() + 1900;
            ActivityPeriod activityPeriod = DbActivityPeriod.getPeriodAktif(year);
            
            if(activityPeriod.getOID() == 0)
                return 0;
            
            sql = "select sum(MDB."+DbModuleBudget.colNames[DbModuleBudget.COL_AMOUNT]+") FROM "+
                    DbModule.DB_MODULE+" MD inner join "+DbModuleBudget.DB_MODULE_BUDGET+" MDB on  MD."+
                    DbModule.colNames[DbModule.COL_MODULE_ID]+" = MDB."+DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID]+
                    " WHERE MD."+DbModule.colNames[DbModule.COL_ACTIVITY_PERIOD_ID]+" = "+activityPeriod.getOID()+" and MDB."+
                    DbModuleBudget.colNames[DbModuleBudget.COL_COA_ID]+" = "+coaId;

            CONResultSet crs = null;
        
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            } finally {
                CONResultSet.close(crs);
            }
            return result;

        }   
        
        
         public static double getAmountInPeriod(long periodId, long coaId,String whereSd){

            double result = 0;

            Periode periode = new Periode();

            if (periodId == 0 || coaId == 0) {
                return 0;
            }

            try {
                periode = DbPeriode.fetchExc(periodId);
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            String sql = "";
            int year = periode.getEndDate().getYear() + 1900;
            ActivityPeriod activityPeriod = DbActivityPeriod.getPeriodAktif(year);
            
            if(activityPeriod.getOID() == 0)
                return 0;
            
            sql = "select sum(MDB."+DbModuleBudget.colNames[DbModuleBudget.COL_AMOUNT]+") FROM "+
                    DbModule.DB_MODULE+" MD inner join "+DbModuleBudget.DB_MODULE_BUDGET+" MDB on  gd."+
                    DbModule.colNames[DbModule.COL_MODULE_ID]+" = MDB."+DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID]+
                    " WHERE gd."+DbModule.colNames[DbModule.COL_ACTIVITY_PERIOD_ID]+" = "+activityPeriod.getOID()+" and MDB."+
                    DbModuleBudget.colNames[DbModuleBudget.COL_COA_ID]+" = "+coaId+" and "+whereSd;

            CONResultSet crs = null;
        
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            } finally {
                CONResultSet.close(crs);
            }
            return result;

        }   
        
     public static double getRealisasiCurrentYear(long rptDetailId, Periode period,String whereSd){        
        double result = 0;
        Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptDetailId, "");

        if (temp != null && temp.size() > 0){
            for (int i = 0; i < temp.size(); i++) {
                RptFormatDetailCoa rdc = (RptFormatDetailCoa) temp.get(i);
                result = result + getAmountInPeriod(period.getOID(), rdc.getCoaId(),whereSd);
            }
        }
        return result;
    }
}
