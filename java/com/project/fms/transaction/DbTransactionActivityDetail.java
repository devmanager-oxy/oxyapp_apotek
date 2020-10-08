

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
import com.project.fms.transaction.*;
import com.project.util.lang.*;
import com.project.fms.activity.*;
import com.project.*;
import com.project.fms.master.*;
import com.project.util.*;

public class DbTransactionActivityDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_TRANSACTION_ACTIVITY_DETAIL = "transaction_activity_detail";

	public static final  int COL_TRANSACTION_ACTIVITY_DETAIL_ID = 0;
	public static final  int COL_PERCENT            = 1;
	public static final  int COL_AMOUNT             = 2;
	public static final  int COL_TRANSACTION_ID     = 3;
	public static final  int COL_IS_DIRECT          = 4;
	public static final  int COL_COA_ID             = 5;
	public static final  int COL_TYPE               = 6;
	public static final  int COL_MODULE_ID          = 7;
	public static final  int COL_MEMO               = 8;
        public static final  int COL_DONOR_ID           = 9;
        
        public static final  int COL_COA_EXPENSE_CATEGOTY_ID           = 10;
        public static final  int COL_COA_NATURE_EXPENSE_CATEGORY_ID           = 11;
        public static final  int COL_ACTIVITY_PERIOD_ID           = 12;
        public static final  int COL_TRANS_DATE           = 13;

	public static final  String[] colNames = {
		"transaction_activity_detail_id",
		"percent",
		"amount",
		"transaction_id",
		"is_direct",
		"coa_id",
		"type",
		"module_id",
		"memo",
                "donor_id",
                "coa_expense_category_id",
                "coa_nature_expense_category_id",
                "activity_period_id",
                "trans_date"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,		
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_INT,
		TYPE_LONG,
		TYPE_INT,
		TYPE_LONG,		
                TYPE_STRING,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_DATE
	 }; 
         
         public static final int ACTIVITY_TYPE_FA = 0;
         public static final int ACTIVITY_TYPE_LOG = 1;
         public static final int ACTIVITY_TYPE_MODULE = 2;
         
         public static final String[] activities = {"F&A", "Logistic", "Activity Module"};

	public DbTransactionActivityDetail(){
	}

	public DbTransactionActivityDetail(int i) throws CONException { 
		super(new DbTransactionActivityDetail()); 
	}

	public DbTransactionActivityDetail(String sOid) throws CONException { 
		super(new DbTransactionActivityDetail(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbTransactionActivityDetail(long lOid) throws CONException { 
		super(new DbTransactionActivityDetail(0)); 
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
		return DB_TRANSACTION_ACTIVITY_DETAIL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbTransactionActivityDetail().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		TransactionActivityDetail transactionactivitydetail = fetchExc(ent.getOID()); 
		ent = (Entity)transactionactivitydetail; 
		return transactionactivitydetail.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((TransactionActivityDetail) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((TransactionActivityDetail) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static TransactionActivityDetail fetchExc(long oid) throws CONException{ 
		try{ 
			TransactionActivityDetail transactionactivitydetail = new TransactionActivityDetail();
			DbTransactionActivityDetail pstTransactionActivityDetail = new DbTransactionActivityDetail(oid); 
			transactionactivitydetail.setOID(oid);

			transactionactivitydetail.setPercent(pstTransactionActivityDetail.getdouble(COL_PERCENT));
			transactionactivitydetail.setAmount(pstTransactionActivityDetail.getdouble(COL_AMOUNT));
			transactionactivitydetail.setTransactionId(pstTransactionActivityDetail.getlong(COL_TRANSACTION_ID));
			transactionactivitydetail.setIsDirect(pstTransactionActivityDetail.getInt(COL_IS_DIRECT));
			transactionactivitydetail.setCoaId(pstTransactionActivityDetail.getlong(COL_COA_ID));
			transactionactivitydetail.setType(pstTransactionActivityDetail.getInt(COL_TYPE));
			transactionactivitydetail.setModuleId(pstTransactionActivityDetail.getlong(COL_MODULE_ID));
			transactionactivitydetail.setMemo(pstTransactionActivityDetail.getString(COL_MEMO));
                        transactionactivitydetail.setDonorId(pstTransactionActivityDetail.getlong(COL_DONOR_ID));
                        
                        transactionactivitydetail.setCoaExpenseCategoryId(pstTransactionActivityDetail.getlong(COL_COA_EXPENSE_CATEGOTY_ID));
                        transactionactivitydetail.setCoaNatureExpenseCategoryId(pstTransactionActivityDetail.getlong(COL_COA_NATURE_EXPENSE_CATEGORY_ID));
                        
                        transactionactivitydetail.setActivityPeriodId(pstTransactionActivityDetail.getlong(COL_ACTIVITY_PERIOD_ID));
                        transactionactivitydetail.setTransDate(pstTransactionActivityDetail.getDate(COL_TRANS_DATE));
                        

			return transactionactivitydetail; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTransactionActivityDetail(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(TransactionActivityDetail transactionactivitydetail) throws CONException{ 
		try{ 
			DbTransactionActivityDetail pstTransactionActivityDetail = new DbTransactionActivityDetail(0);

			pstTransactionActivityDetail.setDouble(COL_PERCENT, transactionactivitydetail.getPercent());
			pstTransactionActivityDetail.setDouble(COL_AMOUNT, transactionactivitydetail.getAmount());
			pstTransactionActivityDetail.setLong(COL_TRANSACTION_ID, transactionactivitydetail.getTransactionId());
			pstTransactionActivityDetail.setInt(COL_IS_DIRECT, transactionactivitydetail.getIsDirect());
			pstTransactionActivityDetail.setLong(COL_COA_ID, transactionactivitydetail.getCoaId());
			pstTransactionActivityDetail.setInt(COL_TYPE, transactionactivitydetail.getType());			
			pstTransactionActivityDetail.setLong(COL_MODULE_ID, transactionactivitydetail.getModuleId());			
                        pstTransactionActivityDetail.setString(COL_MEMO, transactionactivitydetail.getMemo());
                        pstTransactionActivityDetail.setLong(COL_DONOR_ID, transactionactivitydetail.getDonorId());
                        
                        pstTransactionActivityDetail.setLong(COL_COA_EXPENSE_CATEGOTY_ID, transactionactivitydetail.getCoaExpenseCategoryId());
                        pstTransactionActivityDetail.setLong(COL_COA_NATURE_EXPENSE_CATEGORY_ID, transactionactivitydetail.getCoaNatureExpenseCategoryId());
                        
                        pstTransactionActivityDetail.setLong(COL_ACTIVITY_PERIOD_ID, transactionactivitydetail.getActivityPeriodId());
                        pstTransactionActivityDetail.setDate(COL_TRANS_DATE, transactionactivitydetail.getTransDate());

			pstTransactionActivityDetail.insert(); 
			transactionactivitydetail.setOID(pstTransactionActivityDetail.getlong(COL_TRANSACTION_ACTIVITY_DETAIL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTransactionActivityDetail(0),CONException.UNKNOWN); 
		}
		return transactionactivitydetail.getOID();
	}

	public static long updateExc(TransactionActivityDetail transactionactivitydetail) throws CONException{ 
		try{ 
			if(transactionactivitydetail.getOID() != 0){ 
				DbTransactionActivityDetail pstTransactionActivityDetail = new DbTransactionActivityDetail(transactionactivitydetail.getOID());

				pstTransactionActivityDetail.setDouble(COL_PERCENT, transactionactivitydetail.getPercent());
                                pstTransactionActivityDetail.setDouble(COL_AMOUNT, transactionactivitydetail.getAmount());
                                pstTransactionActivityDetail.setLong(COL_TRANSACTION_ID, transactionactivitydetail.getTransactionId());
                                pstTransactionActivityDetail.setInt(COL_IS_DIRECT, transactionactivitydetail.getIsDirect());
                                pstTransactionActivityDetail.setLong(COL_COA_ID, transactionactivitydetail.getCoaId());
                                pstTransactionActivityDetail.setInt(COL_TYPE, transactionactivitydetail.getType());			
                                pstTransactionActivityDetail.setLong(COL_MODULE_ID, transactionactivitydetail.getModuleId());			
                                pstTransactionActivityDetail.setString(COL_MEMO, transactionactivitydetail.getMemo());
                                pstTransactionActivityDetail.setLong(COL_DONOR_ID, transactionactivitydetail.getDonorId());
                                
                                pstTransactionActivityDetail.setLong(COL_COA_EXPENSE_CATEGOTY_ID, transactionactivitydetail.getCoaExpenseCategoryId());
                                pstTransactionActivityDetail.setLong(COL_COA_NATURE_EXPENSE_CATEGORY_ID, transactionactivitydetail.getCoaNatureExpenseCategoryId());
                                
                                pstTransactionActivityDetail.setLong(COL_ACTIVITY_PERIOD_ID, transactionactivitydetail.getActivityPeriodId());
                                pstTransactionActivityDetail.setDate(COL_TRANS_DATE, transactionactivitydetail.getTransDate()); 

				pstTransactionActivityDetail.update(); 
				return transactionactivitydetail.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTransactionActivityDetail(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbTransactionActivityDetail pstTransactionActivityDetail = new DbTransactionActivityDetail(oid);
			pstTransactionActivityDetail.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTransactionActivityDetail(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_TRANSACTION_ACTIVITY_DETAIL; 
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
				TransactionActivityDetail transactionactivitydetail = new TransactionActivityDetail();
				resultToObject(rs, transactionactivitydetail);
				lists.add(transactionactivitydetail);
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

	private static void resultToObject(ResultSet rs, TransactionActivityDetail transactionactivitydetail){
		try{
			transactionactivitydetail.setOID(rs.getLong(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_TRANSACTION_ACTIVITY_DETAIL_ID]));
			transactionactivitydetail.setPercent(rs.getDouble(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_PERCENT]));	
			transactionactivitydetail.setAmount(rs.getDouble(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_AMOUNT]));			
			transactionactivitydetail.setTransactionId(rs.getLong(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_TRANSACTION_ID]));
			transactionactivitydetail.setIsDirect(rs.getInt(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_IS_DIRECT]));
			transactionactivitydetail.setCoaId(rs.getLong(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_COA_ID]));
			transactionactivitydetail.setType(rs.getInt(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_TYPE]));			
			transactionactivitydetail.setModuleId(rs.getLong(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_MODULE_ID]));			
                        transactionactivitydetail.setMemo(rs.getString(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_MEMO]));
                        transactionactivitydetail.setDonorId(rs.getLong(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_DONOR_ID]));
                        
                        transactionactivitydetail.setCoaExpenseCategoryId(rs.getLong(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_COA_EXPENSE_CATEGOTY_ID]));
                        transactionactivitydetail.setCoaNatureExpenseCategoryId(rs.getLong(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_COA_NATURE_EXPENSE_CATEGORY_ID]));
                        
                        transactionactivitydetail.setActivityPeriodId(rs.getLong(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_ACTIVITY_PERIOD_ID]));
                        transactionactivitydetail.setTransDate(rs.getDate(DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_TRANS_DATE]));
                        

		}catch(Exception e){ }
	}

	public static boolean checkOID(long transactionActivityDetailId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_TRANSACTION_ACTIVITY_DETAIL + " WHERE " + 
						DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_TRANSACTION_ACTIVITY_DETAIL_ID] + " = " + transactionActivityDetailId;

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
			String sql = "SELECT COUNT("+ DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_TRANSACTION_ACTIVITY_DETAIL_ID] + ") FROM " + DB_TRANSACTION_ACTIVITY_DETAIL;
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
			  	   TransactionActivityDetail transactionactivitydetail = (TransactionActivityDetail)list.get(ls);
				   if(oid == transactionactivitydetail.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static long saveAllDetail(long oidTransaction, Vector listActivityDetail){
            
            long oid = 0;
            
            ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();
            
            deleteActivityByTransactionId(oidTransaction);
            
            if(listActivityDetail!=null && listActivityDetail.size()>0){
                
                for(int i=0; i<listActivityDetail.size(); i++){
                    
                    TransactionActivityDetail crd = (TransactionActivityDetail)listActivityDetail.get(i);
                                        
                    Coa coa = new Coa();
                    try{
                        coa = DbCoa.fetchExc(crd.getCoaId());
                    }
                    catch(Exception e){
                        
                    }
                    
                    //crd.setCoaExpenseCategoryId(coa.getCoaExpenseCategoryId());
                    //crd.setCoaNatureExpenseCategoryId(coa.getAccountGroup());
                    crd.setTransactionId(oidTransaction);
                    crd.setActivityPeriodId(openAp.getOID());
                    crd.setTransDate(new Date());
                    
                    //jika dia indirect tapi 
                    if(crd.getIsDirect()==0){
                        if(crd.getModuleId()!=0){
                            Module module = new Module();
                            try{
                                module = DbModule.fetchExc(crd.getModuleId());
                                
                                if(module.getLevel().equals(I_Project.ACTIVITY_CODE_M)){
                                    crd.setType(DbTransactionActivityDetail.ACTIVITY_TYPE_FA);
                                    crd.setCoaId(0);
                                    crd.setModuleId(0);
                                }                                
                                else if(!module.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
                                    boolean stop = false;
                                    long moduleId = module.getParentId();
                                    while(!stop){
                                        Module m = new Module();
                                        try{
                                            m = DbModule.fetchExc(moduleId);
                                            if(m.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
                                                crd.setModuleId(m.getOID());
                                                stop = true;
                                            }
                                            if(m.getParentId()==0){
                                                stop = true;
                                            }
                                        }
                                        catch(Exception e){
                                            
                                        }
                                    }
                                }
                                
                            }
                            catch(Exception e){
                            }
                        }
                    }
                    
                    try{
                        oid = DbTransactionActivityDetail.insertExc(crd);
                    }
                    catch(Exception e){
                        System.out.println(e.toString());
                        oid = 0;
                    }
                }               
                
            }
            
            return oid;
        }
        
        public static void deleteActivityByTransactionId(long transOID){
            try{                
                CONHandler.execUpdate("delete from "+DB_TRANSACTION_ACTIVITY_DETAIL+" where "+colNames[COL_TRANSACTION_ID]+"="+transOID);
            }
            catch(Exception e){
                System.out.println(e.toString());    
            }            
        }
        
        public static void insertNonModularActivityDetail(long ownerId, int type, double amount, double percent){
            
            if(amount>0){
                
                ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();    
                
                TransactionActivityDetail ta = new TransactionActivityDetail();
                ta.setTransactionId(ownerId);
                ta.setAmount(amount);
                ta.setType(type);
                ta.setIsDirect(1);
                ta.setPercent(percent);
                
                ta.setActivityPeriodId(openAp.getOID());
                ta.setTransDate(new Date());

                try{
                    DbTransactionActivityDetail.insertExc(ta);
                }
                catch(Exception e){

                }
                
            }
            
        }
        
        public static void insertModularActivityDetail(long ownerId, int type, double amount, double percent, CoaActivityBudget cab, CoaActivityBudgetDetail cabd, long moduleId){
            
            if(amount>0){
                
                ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();    
                
                TransactionActivityDetail ta = new TransactionActivityDetail();
                ta.setTransactionId(ownerId);
                ta.setAmount(amount);
                ta.setType(type);
                ta.setIsDirect(1);
                ta.setPercent(percent);
                ta.setModuleId(moduleId);
                ta.setCoaId(cab.getCoaId());  
                
                ta.setActivityPeriodId(openAp.getOID());
                ta.setTransDate(new Date());

                try{
                    DbTransactionActivityDetail.insertExc(ta);
                }
                catch(Exception e){

                }
                
            }
        }
        
        
        public static double getTotalFA(long activityPeriodId){
            double result = 0;
            CONResultSet crs = null;            
            try{                
                String sql  = "SELECT sum(amount) FROM transaction_activity_detail t where activity_period_id="+activityPeriodId+" and type="+ACTIVITY_TYPE_FA;
                
                System.out.println(sql);
                
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
        
        public static double getTotalLog(long activityPeriodId){
            double result = 0;
            CONResultSet crs = null;            
            try{                
                String sql  = "SELECT sum(amount) FROM transaction_activity_detail t where activity_period_id="+activityPeriodId+" and type="+ACTIVITY_TYPE_LOG;
                
                System.out.println(sql);
                
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
        
        public static double getTotalDirectActivity(long activityPeriodId, long oidModule){
            double result = 0;
            CONResultSet crs = null;            
            try{ 
                
                //harus recursif
                Vector temp = DbModule.list(0,0, "parent_id="+oidModule, "");
                if(temp!=null && temp.size()>0){
                    result = getDirectRecursifAmount(temp, activityPeriodId);
                }
                else{
                    //this is an a or sa
                    Module m = DbModule.fetchExc(oidModule);
                    temp = new Vector();
                    temp.add(m);
                    result = getDirectRecursifAmount(temp, activityPeriodId);
                }
                
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            return result;
        }
        
        //ini recursif
        public static double getDirectRecursifAmount(Vector v, long activityPeriodId){
            
            double result = 0;
            
            for(int i=0; i<v.size(); i++){
                
                Module m = (Module)v.get(i);
                
                if(m.getLevel().equals(I_Project.ACTIVITY_CODE_A) || m.getLevel().equals(I_Project.ACTIVITY_CODE_SA) || m.getLevel().equals(I_Project.ACTIVITY_CODE_SSA)){
                    
                    if(m.getLevel().equals(I_Project.ACTIVITY_CODE_SSA)){
                        
                        CONResultSet crs = null;
                        
                        try{

                            String sql  = "SELECT sum(amount) FROM transaction_activity_detail t where activity_period_id="+activityPeriodId+
                                          " and type="+ACTIVITY_TYPE_MODULE+" and module_id="+m.getOID()+" and is_direct=1";

                            System.out.println(sql);

                            crs = CONHandler.execQueryResult(sql);
                            ResultSet rs = crs.getResultSet();
                            while(rs.next()){
                                result = result + rs.getDouble(1);
                            }

                        }
                        catch(Exception e){

                        }
                        finally{
                            CONResultSet.close(crs);
                        }
                        
                    }
                    else{
                        Vector temp = DbModule.list(0,0, DbModule.colNames[DbModule.COL_PARENT_ID]+"="+m.getOID(), "");
                        if(temp!=null && temp.size()>0){
                            result = result + getDirectRecursifAmount(temp, activityPeriodId);
                        }
                        else{
                            CONResultSet crs = null;
                        
                            try{

                                String sql  = "SELECT sum(amount) FROM transaction_activity_detail t where activity_period_id="+activityPeriodId+
                                              " and type="+ACTIVITY_TYPE_MODULE+" and module_id="+m.getOID()+" and is_direct=1";

                                System.out.println(sql);

                                crs = CONHandler.execQueryResult(sql);
                                ResultSet rs = crs.getResultSet();
                                while(rs.next()){
                                    result = result + rs.getDouble(1);
                                }

                            }
                            catch(Exception e){

                            }
                            finally{
                                CONResultSet.close(crs);
                            }
                            
                        }
                    }                   
                }
                else{
                    Vector temp = DbModule.list(0,0, DbModule.colNames[DbModule.COL_PARENT_ID]+"="+m.getOID(), "");
                    if(temp!=null && temp.size()>0){
                        result = result + getDirectRecursifAmount(temp, activityPeriodId);
                    }
                }
                
            }
            
            return result;
            
        }
        
        //ini recursif
        public static double getInDirectRecursifAmount(Vector v, long activityPeriodId){
            
            double result = 0;
            
            for(int i=0; i<v.size(); i++){
                
                Module m = (Module)v.get(i);
                
                if(m.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
                    
                    CONResultSet crs = null;

                    try{

                        String sql  = "SELECT sum(amount) FROM transaction_activity_detail t where activity_period_id="+activityPeriodId+
                                      " and type="+ACTIVITY_TYPE_MODULE+" and module_id="+m.getOID()+" and is_direct=0";

                        //System.out.println(sql);

                        crs = CONHandler.execQueryResult(sql);
                        ResultSet rs = crs.getResultSet();
                        while(rs.next()){
                            result = result + rs.getDouble(1);
                        }

                    }
                    catch(Exception e){

                    }
                    finally{
                        CONResultSet.close(crs);
                    }

                }
                else{
                    Vector temp = DbModule.list(0,0, DbModule.colNames[DbModule.COL_PARENT_ID]+"="+m.getOID(), "");
                    if(temp!=null && temp.size()>0){
                        result = result + getInDirectRecursifAmount(temp, activityPeriodId);
                    }
                }
                
            }
            
            return result;
            
        }
        
        
        public static double getTotalInDirectActivity(long activityPeriodId, long oidModule){
            
            double result = 0;
            
            if(oidModule!=0){
                try{
                    Module m = DbModule.fetchExc(oidModule);
                    if(m.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
                                                
                        CONResultSet crs = null;            
                        try{                
                            String sql  = "SELECT sum(amount) FROM transaction_activity_detail t where activity_period_id="+activityPeriodId+
                                          " and type="+ACTIVITY_TYPE_MODULE+" and module_id="+oidModule+" and is_direct=0";

                            //System.out.println(sql);

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
                        
                    }
                    else{
                        Vector v = DbModule.list(0,0,  DbModule.colNames[DbModule.COL_PARENT_ID]+"="+oidModule,"");
                        if(v!=null && v.size()>0){
                            result = getInDirectRecursifAmount(v, activityPeriodId);
                        }
                    }
                }
                catch(Exception e){
                    
                }
            }
                        
            return result;
        }
        
        //in direct activity grand total
        public static double getGrandTotalInDirectActivity(long activityPeriodId, Vector modules){
            
            double result = 0;
            
            if(modules!=null && modules.size()>0){  
                for(int i=0; i<modules.size(); i++){
                    Module m = (Module)modules.get(i);
                    if(m.getLevel().equals(I_Project.ACTIVITY_CODE_M)){
                        
                        Vector temp = DbModule.list(0,0, DbModule.colNames[DbModule.COL_PARENT_ID]+"="+m.getOID(), "");
                        if(temp!=null && temp.size()>0){
                            result = result + getInDirectRecursifAmount(temp, activityPeriodId);
                        }
                                                
                    }
                }
            }
                        
            return result;
        }
        
        //direct activity grand total
        public static double getGrandTotalDirectActivity(long activityPeriodId, Vector modules){
            
            double result = 0;
            
            if(modules!=null && modules.size()>0){  
                for(int i=0; i<modules.size(); i++){
                    Module m = (Module)modules.get(i);
                    if(m.getLevel().equals(I_Project.ACTIVITY_CODE_M)){
                        
                        Vector temp = DbModule.list(0,0, DbModule.colNames[DbModule.COL_PARENT_ID]+"="+m.getOID(), "");
                        if(temp!=null && temp.size()>0){
                            result = result + getDirectRecursifAmount(temp, activityPeriodId);
                        }
                                                
                    }
                }
            }
                        
            return result;
        }
        
        
        public static double getTotalByCategory(long caOID, long periodId){
        
            double result = 0;
            CONResultSet crs = null;
            
            try{
                //String sql = "SELECT sum(amount) FROM transaction_activity_detail t where coa_expense_category_id="+caOID+
                //    " and activity_period_id="+periodId+" and coa_id<>0";
                
                String sql = "select sum(amount) from "+DB_TRANSACTION_ACTIVITY_DETAIL+" ta "+
                        " inner join "+DbCoa.DB_COA+" c on c."+DbCoa.colNames[DbCoa.COL_COA_ID]+
                        " = ta."+colNames[COL_COA_ID]+
                        " where ta."+colNames[COL_ACTIVITY_PERIOD_ID]+" = "+periodId+
                        " and c."+DbCoa.colNames[DbCoa.COL_COA_CATEGORY_ID]+" = "+caOID;
                
                System.out.println(sql);
                
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
        
        public static double getTotalCategoryByPeriod(long periodId){
        
            double result = 0;
            CONResultSet crs = null;
            
            try{
                
                //String sql = "SELECT sum(amount) FROM transaction_activity_detail t where "+
                //    " activity_period_id="+periodId+" and coa_id<>0";
                
                String sql = "select sum(amount) from "+DB_TRANSACTION_ACTIVITY_DETAIL+" ta "+
                        " inner join "+DbCoa.DB_COA+" c on c."+DbCoa.colNames[DbCoa.COL_COA_ID]+" = ta."+colNames[COL_COA_ID]+
                        " where ta."+colNames[COL_ACTIVITY_PERIOD_ID]+" = "+periodId;
                
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
        
        public static double getGrandTotalByPeriod(long periodId){
        
            double result = 0;
            CONResultSet crs = null;
            
            try{
                
                //String sql = "SELECT sum(amount) FROM transaction_activity_detail t where "+
                //    " activity_period_id="+periodId+" and coa_id<>0";
                
                String sql = "select sum(amount) from "+DB_TRANSACTION_ACTIVITY_DETAIL+" ta "+
                        " where ta."+colNames[COL_ACTIVITY_PERIOD_ID]+" = "+periodId;
                
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
        
        
        public static Vector getAmountByDetailGroup(long periodId, long groupId){
            
            CONResultSet crs = null;
            Vector result = new Vector();
            try{
                String sql = " SELECT sum(d.amount), c.* FROM transaction_activity_detail d "+
                    " inner join coa c on c.coa_id = d.coa_id where c.account_group="+groupId+
                    " and d.coa_id<>0 and d.activity_period_id="+periodId+" group by d.coa_id";
                
                System.out.println(sql);
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Vector temp = new Vector();
                    Coa coa = new Coa();
                    DbCoa.resultToObject(rs, coa); 
                    temp.add(coa);
                    temp.add(""+rs.getDouble(1));
                    result.add(temp);
                }
                
            }
            catch(Exception e){
                
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
        }
        
        
        public static Vector getDetailGroupCoaList(long groupId, long activitiPeriodId){
            
            CONResultSet crs = null;
            Vector result = new Vector(1,1);
            try{
                String sql = "select distinct c."+DbCoa.colNames[DbCoa.COL_COA_ID]+", c."+DbCoa.colNames[DbCoa.COL_CODE]+", c."+DbCoa.colNames[DbCoa.COL_NAME]+
                             ", sum(dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_AMOUNT]+") as totalamount from "+DbCoa.DB_COA+" c "+
                             " inner join "+DbTransactionActivityDetail.DB_TRANSACTION_ACTIVITY_DETAIL+" dt "+
                             " on dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_COA_ID]+"=c."+DbCoa.colNames[DbCoa.COL_COA_ID]+
                             " where dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_ACTIVITY_PERIOD_ID]+"="+activitiPeriodId+
                             " and c."+DbCoa.colNames[DbCoa.COL_COA_GROUP_ALIAS_ID]+"="+groupId+
                             " group by dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_COA_ID]+
                             " order by c."+DbCoa.colNames[DbCoa.COL_CODE];
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Coa coa = new Coa();
                    String s = rs.getString(DbCoa.colNames[DbCoa.COL_CODE]);
                    coa.setOID(rs.getLong(DbCoa.colNames[DbCoa.COL_COA_ID]));
                    coa.setCode(s);
                    s = rs.getString(DbCoa.colNames[DbCoa.COL_NAME]);
                    coa.setName(s);
                    
                    double d = rs.getDouble("totalamount");
                    coa.setOpeningBalance(d);
                    result.add(coa);
                }
                
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            return result;
            
        }
        
        
        public static double getAmountByGroupId(long groupId, long activitiPeriodId){
            
            CONResultSet crs = null;
            double result = 0;//new Vector(1,1);
            try{
                String sql = "select sum(dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_AMOUNT]+") as totalamount from "+DbCoa.DB_COA+" c "+
                             " inner join "+DbTransactionActivityDetail.DB_TRANSACTION_ACTIVITY_DETAIL+" dt "+
                             " on dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_COA_ID]+"=c."+DbCoa.colNames[DbCoa.COL_COA_ID]+
                             " where dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_ACTIVITY_PERIOD_ID]+"="+activitiPeriodId+
                             " and c."+DbCoa.colNames[DbCoa.COL_COA_GROUP_ALIAS_ID]+"="+groupId;
                                             
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                    result = rs.getDouble("totalamount");
                    
                }
                
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            return result;
            
        }
        
        
        public static double getTotalAmountByGroup(long activitiPeriodId){
            
            CONResultSet crs = null;
            double result = 0;//new Vector(1,1);
            try{
                String sql = "select sum(dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_AMOUNT]+") as totalamount from "+DbCoa.DB_COA+" c "+
                             " inner join "+DbTransactionActivityDetail.DB_TRANSACTION_ACTIVITY_DETAIL+" dt "+
                             " on dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_COA_ID]+"=c."+DbCoa.colNames[DbCoa.COL_COA_ID]+
                             " where dt."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_ACTIVITY_PERIOD_ID]+"="+activitiPeriodId;                             
                                             
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                    result = rs.getDouble("totalamount");
                    
                }
                
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            return result;
            
        }
                
        //digunakan saat proses singkronisasi data dilakukan
        public static void synchActivityPeriodId(){
        
            CONResultSet crs = null;
            TransactionActivityDetail tad = new TransactionActivityDetail();
            try{
                String sql = " select * from "+DbTransactionActivityDetail.DB_TRANSACTION_ACTIVITY_DETAIL+" g "+
                             " where g."+DbTransactionActivityDetail.colNames[DbTransactionActivityDetail.COL_ACTIVITY_PERIOD_ID]+
                             " not in (select p."+DbActivityPeriod.colNames[DbActivityPeriod.COL_ACTIVITY_PERIOD_ID]+
                             " from "+DbActivityPeriod.DB_ACTIVITY_PERIOD+" p) limit 0,1";
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){                    
                    DbTransactionActivityDetail.resultToObject(rs, tad);                    
                }                
                
                if(tad.getOID()!=0){
                    updateSynchActivityPeriodId(tad);
                    synchActivityPeriodId();
                }
                
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            
        }
        
        public static void updateSynchActivityPeriodId(TransactionActivityDetail tad){
            
            Date trDate = tad.getTransDate();
            String where = " to_days("+DbActivityPeriod.colNames[DbActivityPeriod.COL_START_DATE]+")<=to_days('"+JSPFormater.formatDate(trDate, "yyyy-MM-dd")+"')"+
                           " and to_days("+DbActivityPeriod.colNames[DbActivityPeriod.COL_END_DATE]+")>=to_days('"+JSPFormater.formatDate(trDate, "yyyy-MM-dd")+"')";
            
            Vector v = DbActivityPeriod.list(0,0,  where, "");
            if(v!=null && v.size()>0){
                ActivityPeriod p = (ActivityPeriod)v.get(0);
                String sql = " update "+DbTransactionActivityDetail.DB_TRANSACTION_ACTIVITY_DETAIL+
                             " set "+colNames[COL_ACTIVITY_PERIOD_ID]+"="+p.getOID()+" where "+colNames[COL_ACTIVITY_PERIOD_ID]+"="+tad.getActivityPeriodId();
                try{
                    CONHandler.execUpdate(sql);
                }
                catch(Exception e){
                    
                }
            }            
            
        }
        
        
}
