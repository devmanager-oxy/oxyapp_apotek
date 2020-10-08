
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

public class DbCoaActivityBudget extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_COA_ACTIVITY_BUDGET = "coa_activity_budget";

	public static final  int COL_TYPE = 0;
	public static final  int COL_COA_ACTIVITY_BUDGET_ID = 1;
	public static final  int COL_COA_ID = 2;
	public static final  int COL_ADMIN_PERCENT = 3;
	public static final  int COL_LOGISTIC_PERCENT = 4;
	public static final  int COL_MEMO = 5;
        public static final  int COL_ACTIVITY_PERIOD_ID = 6;
        public static final  int COL_COA_EXPENSE_CATEGORY_ID = 7;
        public static final  int COL_COA_NATURE_EXPENSE_CATEGORY_ID = 8;

	public static final  String[] colNames = {
		"type",
		"coa_activity_budget_id",
		"coa_id",
		"admin_percent",
		"logistic_percent",
		"memo",
                "activity_period_id",
                
                "coa_expense_category_id",
                "coa_nature_expense_category_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_INT,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_STRING,
                TYPE_LONG,
                
                TYPE_LONG,
                TYPE_LONG
	 }; 

	public DbCoaActivityBudget(){
	}

	public DbCoaActivityBudget(int i) throws CONException { 
		super(new DbCoaActivityBudget()); 
	}

	public DbCoaActivityBudget(String sOid) throws CONException { 
		super(new DbCoaActivityBudget(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCoaActivityBudget(long lOid) throws CONException { 
		super(new DbCoaActivityBudget(0)); 
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
		return DB_COA_ACTIVITY_BUDGET;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCoaActivityBudget().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		CoaActivityBudget coaactivitybudget = fetchExc(ent.getOID()); 
		ent = (Entity)coaactivitybudget; 
		return coaactivitybudget.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((CoaActivityBudget) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((CoaActivityBudget) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static CoaActivityBudget fetchExc(long oid) throws CONException{ 
		try{ 
			CoaActivityBudget coaactivitybudget = new CoaActivityBudget();
			DbCoaActivityBudget pstCoaActivityBudget = new DbCoaActivityBudget(oid); 
			coaactivitybudget.setOID(oid);

			coaactivitybudget.setType(pstCoaActivityBudget.getInt(COL_TYPE));
			coaactivitybudget.setCoaId(pstCoaActivityBudget.getlong(COL_COA_ID));
			coaactivitybudget.setAdminPercent(pstCoaActivityBudget.getdouble(COL_ADMIN_PERCENT));
			coaactivitybudget.setLogisticPercent(pstCoaActivityBudget.getdouble(COL_LOGISTIC_PERCENT));
			coaactivitybudget.setMemo(pstCoaActivityBudget.getString(COL_MEMO));
                        coaactivitybudget.setActivityPeriodId(pstCoaActivityBudget.getlong(COL_ACTIVITY_PERIOD_ID));
                        
                        coaactivitybudget.setCoaExpenseCategoryId(pstCoaActivityBudget.getlong(COL_COA_EXPENSE_CATEGORY_ID));
                        coaactivitybudget.setCoaNatureExpenseCategoryId(pstCoaActivityBudget.getlong(COL_COA_NATURE_EXPENSE_CATEGORY_ID));

			return coaactivitybudget; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivityBudget(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(CoaActivityBudget coaactivitybudget) throws CONException{ 
		try{ 
			DbCoaActivityBudget pstCoaActivityBudget = new DbCoaActivityBudget(0);

			pstCoaActivityBudget.setInt(COL_TYPE, coaactivitybudget.getType());
			pstCoaActivityBudget.setLong(COL_COA_ID, coaactivitybudget.getCoaId());
			pstCoaActivityBudget.setDouble(COL_ADMIN_PERCENT, coaactivitybudget.getAdminPercent());
			pstCoaActivityBudget.setDouble(COL_LOGISTIC_PERCENT, coaactivitybudget.getLogisticPercent());
			pstCoaActivityBudget.setString(COL_MEMO, coaactivitybudget.getMemo());
                        pstCoaActivityBudget.setLong(COL_ACTIVITY_PERIOD_ID, coaactivitybudget.getActivityPeriodId());
                        
                        pstCoaActivityBudget.setLong(COL_COA_EXPENSE_CATEGORY_ID, coaactivitybudget.getCoaExpenseCategoryId());
                        pstCoaActivityBudget.setLong(COL_COA_NATURE_EXPENSE_CATEGORY_ID, coaactivitybudget.getCoaNatureExpenseCategoryId());
                        

			pstCoaActivityBudget.insert(); 
			coaactivitybudget.setOID(pstCoaActivityBudget.getlong(COL_COA_ACTIVITY_BUDGET_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivityBudget(0),CONException.UNKNOWN); 
		}
		return coaactivitybudget.getOID();
	}

	public static long updateExc(CoaActivityBudget coaactivitybudget) throws CONException{ 
		try{ 
			if(coaactivitybudget.getOID() != 0){ 
				DbCoaActivityBudget pstCoaActivityBudget = new DbCoaActivityBudget(coaactivitybudget.getOID());

				pstCoaActivityBudget.setInt(COL_TYPE, coaactivitybudget.getType());
				pstCoaActivityBudget.setLong(COL_COA_ID, coaactivitybudget.getCoaId());
				pstCoaActivityBudget.setDouble(COL_ADMIN_PERCENT, coaactivitybudget.getAdminPercent());
				pstCoaActivityBudget.setDouble(COL_LOGISTIC_PERCENT, coaactivitybudget.getLogisticPercent());
				pstCoaActivityBudget.setString(COL_MEMO, coaactivitybudget.getMemo());
                                pstCoaActivityBudget.setLong(COL_ACTIVITY_PERIOD_ID, coaactivitybudget.getActivityPeriodId());
                                
                                pstCoaActivityBudget.setLong(COL_COA_EXPENSE_CATEGORY_ID, coaactivitybudget.getCoaExpenseCategoryId());
                                pstCoaActivityBudget.setLong(COL_COA_NATURE_EXPENSE_CATEGORY_ID, coaactivitybudget.getCoaNatureExpenseCategoryId());

				pstCoaActivityBudget.update(); 
				return coaactivitybudget.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivityBudget(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCoaActivityBudget pstCoaActivityBudget = new DbCoaActivityBudget(oid);
			pstCoaActivityBudget.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivityBudget(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_COA_ACTIVITY_BUDGET; 
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
				CoaActivityBudget coaactivitybudget = new CoaActivityBudget();
				resultToObject(rs, coaactivitybudget);
				lists.add(coaactivitybudget);
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

	public static void resultToObject(ResultSet rs, CoaActivityBudget coaactivitybudget){
		try{
			coaactivitybudget.setOID(rs.getLong(DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_COA_ACTIVITY_BUDGET_ID]));
			coaactivitybudget.setType(rs.getInt(DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_TYPE]));
			coaactivitybudget.setCoaId(rs.getLong(DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_COA_ID]));
			coaactivitybudget.setAdminPercent(rs.getDouble(DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_ADMIN_PERCENT]));
			coaactivitybudget.setLogisticPercent(rs.getDouble(DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_LOGISTIC_PERCENT]));
			coaactivitybudget.setMemo(rs.getString(DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_MEMO]));
                        coaactivitybudget.setActivityPeriodId(rs.getLong(DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_ACTIVITY_PERIOD_ID]));
                        
                        coaactivitybudget.setCoaExpenseCategoryId(rs.getLong(DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_COA_EXPENSE_CATEGORY_ID]));
                        coaactivitybudget.setCoaNatureExpenseCategoryId(rs.getLong(DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_COA_NATURE_EXPENSE_CATEGORY_ID]));

		}catch(Exception e){ }
	}

	/*public static boolean checkOID(long coaActivityBudgetId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_COA_ACTIVITY_BUDGET + " WHERE " + 
						DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_TYPE] + " = " + type;

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
         */

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbCoaActivityBudget.colNames[DbCoaActivityBudget.COL_COA_ACTIVITY_BUDGET_ID] + ") FROM " + DB_COA_ACTIVITY_BUDGET;
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
			  	   CoaActivityBudget coaactivitybudget = (CoaActivityBudget)list.get(ls);
				   if(oid == coaactivitybudget.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static void processData(CoaActivityBudget cab){
            
            Vector v = DbCoaActivityBudget.list(0,0, "activity_period_id="+cab.getActivityPeriodId()+" and coa_id="+cab.getCoaId(), "");
            
            long oid = 0;
            //update data
            if(v!=null && v.size()>0){
                CoaActivityBudget c = (CoaActivityBudget)v.get(0);
                cab.setOID(c.getOID());
                try{
                    oid = DbCoaActivityBudget.updateExc(cab);
                }
                catch(Exception e){
                    
                }
            }
            //insert data new
            else{
                try{
                    oid = DbCoaActivityBudget.insertExc(cab);
                }
                catch(Exception e){
                    
                }
            }            
            
            DbCoaActivityBudgetDetail.processDetails(cab.getDetails(), oid);
        }
        
        public static void deleteFromBudget(CoaActivityBudget cab){
            
            Vector v = DbCoaActivityBudget.list(0,0, "activity_period_id="+cab.getActivityPeriodId()+" and coa_id="+cab.getCoaId(), "");
            
            long oid = 0;
            //update data
            if(v!=null && v.size()>0){
                try{
                    CoaActivityBudget c = (CoaActivityBudget)v.get(0);
                    DbCoaActivityBudgetDetail.deleteByBudgetId(c.getOID());
                    DbCoaActivityBudget.deleteExc(c.getOID());
                }
                catch(Exception e){
                    System.out.println(e.toString());
                }
            }
        }
        
        
        public static boolean pettyCashPredefined(long pettyCashPaymentId){
            ActivityPeriod ap = DbActivityPeriod.getOpenPeriod();
            String sql = "SELECT count("+colNames[COL_COA_ACTIVITY_BUDGET_ID]+") FROM coa_activity_budget cab "+
                " inner join pettycash_payment_detail ppd on ppd.coa_id = cab.coa_id "+
                " where cab.activity_period_id="+ap.getOID()+" and ppd.pettycash_payment_id="+pettyCashPaymentId;
            
            boolean result = false;
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                int cnt = 0;
                while(rs.next()){
                    cnt = rs.getInt(1);
                }
                
                if(cnt>0){
                    result = true;
                }
            }
            catch(Exception e){
                
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                        
        }
        
        
        public static boolean bankNonpoPredefined(long bankNonpoPaymentId){
            ActivityPeriod ap = DbActivityPeriod.getOpenPeriod();
            String sql = "SELECT count("+colNames[COL_COA_ACTIVITY_BUDGET_ID]+") FROM coa_activity_budget cab "+
                " inner join banknonpo_payment_detail ppd on ppd.coa_id = cab.coa_id "+
                " where cab.activity_period_id="+ap.getOID()+" and ppd.banknonpo_payment_id="+bankNonpoPaymentId;
            
            boolean result = false;
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                int cnt = 0;
                while(rs.next()){
                    cnt = rs.getInt(1);
                }
                
                if(cnt>0){
                    result = true;
                }
            }
            catch(Exception e){
                
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                        
        }
        
        public static boolean invoicePredefined(long invoiceId){
            ActivityPeriod ap = DbActivityPeriod.getOpenPeriod();
            String sql = "SELECT count("+colNames[COL_COA_ACTIVITY_BUDGET_ID]+") FROM coa_activity_budget cab "+
                " inner join invoice_item ppd on ppd.coa_id = cab.coa_id "+
                " where cab.activity_period_id="+ap.getOID()+" and ppd.invoice_id="+invoiceId;
            
            boolean result = false;
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                int cnt = 0;
                while(rs.next()){
                    cnt = rs.getInt(1);
                }
                
                if(cnt>0){
                    result = true;
                }
            }
            catch(Exception e){
                
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                        
        }
        
        public static boolean glPredefined(long glId){
            ActivityPeriod ap = DbActivityPeriod.getOpenPeriod();
            String sql = "SELECT count("+colNames[COL_COA_ACTIVITY_BUDGET_ID]+") FROM coa_activity_budget cab "+
                " inner join gl_detail ppd on ppd.coa_id = cab.coa_id "+
                " where cab.activity_period_id="+ap.getOID()+" and ppd.gl_id="+glId;
            
            boolean result = false;
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                int cnt = 0;
                while(rs.next()){
                    cnt = rs.getInt(1);
                }
                
                if(cnt>0){
                    result = true;
                }
            }
            catch(Exception e){
                
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
                        
        }
        
        public static Vector getActivityCoaByPeriod(long periodId){
            String sql = " select c.* from coa_activity_budget cab "+
                         " inner join coa c on c.coa_id = cab.coa_id "+
                         " where cab.activity_period_id="+periodId;
            
            Vector result = new Vector();
            CONResultSet crs = null;
            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Coa coa = new Coa();
                    DbCoa.resultToObject(rs, coa); 
                    result.add(coa);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
        }
        
        
}
