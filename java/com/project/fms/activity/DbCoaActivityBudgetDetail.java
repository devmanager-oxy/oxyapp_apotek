
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

public class DbCoaActivityBudgetDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_COA_ACTIVITY_BUDGET_DETAIL = "coa_activity_budget_detail";

	public static final  int COL_COA_ACTIVITY_BUDGET_ID = 0;
	public static final  int COL_COA_ACTIVITY_BUDGET_DETAIL_ID = 1;
	public static final  int COL_PERCENT = 2;
	public static final  int COL_MODULE_ID = 3;

	public static final  String[] colNames = {
		"coa_activity_budget_id",
		"coa_activity_budget_detail_id",
		"percent",
		"module_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_FLOAT,
		TYPE_LONG
	 }; 

	public DbCoaActivityBudgetDetail(){
	}

	public DbCoaActivityBudgetDetail(int i) throws CONException { 
		super(new DbCoaActivityBudgetDetail()); 
	}

	public DbCoaActivityBudgetDetail(String sOid) throws CONException { 
		super(new DbCoaActivityBudgetDetail(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCoaActivityBudgetDetail(long lOid) throws CONException { 
		super(new DbCoaActivityBudgetDetail(0)); 
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
		return DB_COA_ACTIVITY_BUDGET_DETAIL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCoaActivityBudgetDetail().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		CoaActivityBudgetDetail coaactivitybudgetdetail = fetchExc(ent.getOID()); 
		ent = (Entity)coaactivitybudgetdetail; 
		return coaactivitybudgetdetail.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((CoaActivityBudgetDetail) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((CoaActivityBudgetDetail) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static CoaActivityBudgetDetail fetchExc(long oid) throws CONException{ 
		try{ 
			CoaActivityBudgetDetail coaactivitybudgetdetail = new CoaActivityBudgetDetail();
			DbCoaActivityBudgetDetail pstCoaActivityBudgetDetail = new DbCoaActivityBudgetDetail(oid); 
			coaactivitybudgetdetail.setOID(oid);

			coaactivitybudgetdetail.setCoaActivityBudgetId(pstCoaActivityBudgetDetail.getlong(COL_COA_ACTIVITY_BUDGET_ID));
			coaactivitybudgetdetail.setPercent(pstCoaActivityBudgetDetail.getdouble(COL_PERCENT));
			coaactivitybudgetdetail.setModuleId(pstCoaActivityBudgetDetail.getlong(COL_MODULE_ID));

			return coaactivitybudgetdetail; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivityBudgetDetail(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(CoaActivityBudgetDetail coaactivitybudgetdetail) throws CONException{ 
		try{ 
			DbCoaActivityBudgetDetail pstCoaActivityBudgetDetail = new DbCoaActivityBudgetDetail(0);

			pstCoaActivityBudgetDetail.setLong(COL_COA_ACTIVITY_BUDGET_ID, coaactivitybudgetdetail.getCoaActivityBudgetId());
			pstCoaActivityBudgetDetail.setDouble(COL_PERCENT, coaactivitybudgetdetail.getPercent());
			pstCoaActivityBudgetDetail.setLong(COL_MODULE_ID, coaactivitybudgetdetail.getModuleId());

			pstCoaActivityBudgetDetail.insert(); 
			coaactivitybudgetdetail.setOID(pstCoaActivityBudgetDetail.getlong(COL_COA_ACTIVITY_BUDGET_DETAIL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivityBudgetDetail(0),CONException.UNKNOWN); 
		}
		return coaactivitybudgetdetail.getOID();
	}

	public static long updateExc(CoaActivityBudgetDetail coaactivitybudgetdetail) throws CONException{ 
		try{ 
			if(coaactivitybudgetdetail.getOID() != 0){ 
				DbCoaActivityBudgetDetail pstCoaActivityBudgetDetail = new DbCoaActivityBudgetDetail(coaactivitybudgetdetail.getOID());

				pstCoaActivityBudgetDetail.setLong(COL_COA_ACTIVITY_BUDGET_ID, coaactivitybudgetdetail.getCoaActivityBudgetId());
				pstCoaActivityBudgetDetail.setDouble(COL_PERCENT, coaactivitybudgetdetail.getPercent());
				pstCoaActivityBudgetDetail.setLong(COL_MODULE_ID, coaactivitybudgetdetail.getModuleId());

				pstCoaActivityBudgetDetail.update(); 
				return coaactivitybudgetdetail.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivityBudgetDetail(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCoaActivityBudgetDetail pstCoaActivityBudgetDetail = new DbCoaActivityBudgetDetail(oid);
			pstCoaActivityBudgetDetail.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivityBudgetDetail(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_COA_ACTIVITY_BUDGET_DETAIL; 
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
				CoaActivityBudgetDetail coaactivitybudgetdetail = new CoaActivityBudgetDetail();
				resultToObject(rs, coaactivitybudgetdetail);
				lists.add(coaactivitybudgetdetail);
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

	private static void resultToObject(ResultSet rs, CoaActivityBudgetDetail coaactivitybudgetdetail){
		try{
			coaactivitybudgetdetail.setOID(rs.getLong(DbCoaActivityBudgetDetail.colNames[DbCoaActivityBudgetDetail.COL_COA_ACTIVITY_BUDGET_DETAIL_ID]));
			coaactivitybudgetdetail.setCoaActivityBudgetId(rs.getLong(DbCoaActivityBudgetDetail.colNames[DbCoaActivityBudgetDetail.COL_COA_ACTIVITY_BUDGET_ID]));
			coaactivitybudgetdetail.setPercent(rs.getDouble(DbCoaActivityBudgetDetail.colNames[DbCoaActivityBudgetDetail.COL_PERCENT]));
			coaactivitybudgetdetail.setModuleId(rs.getLong(DbCoaActivityBudgetDetail.colNames[DbCoaActivityBudgetDetail.COL_MODULE_ID]));

		}catch(Exception e){ }
	}

	/*public static boolean checkOID(long coaActivityBudgetDetailId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_COA_ACTIVITY_BUDGET_DETAIL + " WHERE " + 
						DbCoaActivityBudgetDetail.colNames[DbCoaActivityBudgetDetail.COL_COA_ACTIVITY_BUDGET_ID] + " = " + coaActivityBudgetId;

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
			String sql = "SELECT COUNT("+ DbCoaActivityBudgetDetail.colNames[DbCoaActivityBudgetDetail.COL_COA_ACTIVITY_BUDGET_DETAIL_ID] + ") FROM " + DB_COA_ACTIVITY_BUDGET_DETAIL;
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
			  	   CoaActivityBudgetDetail coaactivitybudgetdetail = (CoaActivityBudgetDetail)list.get(ls);
				   if(oid == coaactivitybudgetdetail.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static void processDetails(Vector v, long oid){
            
            DbCoaActivityBudgetDetail.deleteByBudgetId(oid);
            
            if(v!=null && v.size()>0){
                for(int i=0; i<v.size(); i++){
                    CoaActivityBudgetDetail cabd = (CoaActivityBudgetDetail)v.get(i);
                    cabd.setCoaActivityBudgetId(oid);
                    
                    Vector t = DbCoaActivityBudgetDetail.list(0,0, "module_id="+cabd.getModuleId()+" and coa_activity_budget_id="+cabd.getCoaActivityBudgetId(), "");
                    //update
                    if(t!=null && t.size()>0){
                        CoaActivityBudgetDetail cx = (CoaActivityBudgetDetail)t.get(0);
                        cabd.setOID(cx.getOID());
                        try{
                            DbCoaActivityBudgetDetail.updateExc(cabd);
                        }
                        catch(Exception e){
                            
                        }
                    }
                    //insert
                    else{                        
                        try{
                            DbCoaActivityBudgetDetail.insertExc(cabd);
                        }
                        catch(Exception e){
                            
                        }
                    }
                }
            }
        }
        
        
        public static void deleteByBudgetId(long mainOid){
            String sql = "delete from "+DB_COA_ACTIVITY_BUDGET_DETAIL+" where "+colNames[COL_COA_ACTIVITY_BUDGET_ID]+"="+mainOid;
            try{
                CONHandler.execUpdate(sql);
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
        }        
        
}
