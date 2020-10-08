
package com.project.fms.activity; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 

public class DbActivityPeriodBudget extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_DONOR_ACTIVITY_PERIOD = "activity_period_budget";

	public static final  int COL_ACTIVITY_PERIOD_BUDGET_ID = 0;
	public static final  int COL_ACTIVITY_PERIOD_ID = 1;
	public static final  int COL_BUDGET = 2;
	public static final  int COL_MODULE_ID = 3;

	public static final  String[] colNames = {
		"activity_period_budget_id",
		"activity_period_id",
		"budget",
		"module_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_LONG
	 }; 

	public DbActivityPeriodBudget(){
	}

	public DbActivityPeriodBudget(int i) throws CONException { 
		super(new DbActivityPeriodBudget()); 
	}

	public DbActivityPeriodBudget(String sOid) throws CONException { 
		super(new DbActivityPeriodBudget(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbActivityPeriodBudget(long lOid) throws CONException { 
		super(new DbActivityPeriodBudget(0)); 
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
		return DB_DONOR_ACTIVITY_PERIOD;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbActivityPeriodBudget().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		ActivityPeriodBudget donoractivityperiod = fetchExc(ent.getOID()); 
		ent = (Entity)donoractivityperiod; 
		return donoractivityperiod.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((ActivityPeriodBudget) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((ActivityPeriodBudget) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static ActivityPeriodBudget fetchExc(long oid) throws CONException{ 
		try{ 
			ActivityPeriodBudget donoractivityperiod = new ActivityPeriodBudget();
			DbActivityPeriodBudget dbActivityPeriodBudget = new DbActivityPeriodBudget(oid); 
			donoractivityperiod.setOID(oid);

			donoractivityperiod.setActivityPeriodId(dbActivityPeriodBudget.getlong(COL_ACTIVITY_PERIOD_ID));
			donoractivityperiod.setBudget(dbActivityPeriodBudget.getdouble(COL_BUDGET));
			donoractivityperiod.setModuleId(dbActivityPeriodBudget.getlong(COL_MODULE_ID));

			return donoractivityperiod; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbActivityPeriodBudget(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(ActivityPeriodBudget donoractivityperiod) throws CONException{ 
		try{ 
			DbActivityPeriodBudget dbActivityPeriodBudget = new DbActivityPeriodBudget(0);

			dbActivityPeriodBudget.setLong(COL_ACTIVITY_PERIOD_ID, donoractivityperiod.getActivityPeriodId());
			dbActivityPeriodBudget.setDouble(COL_BUDGET, donoractivityperiod.getBudget());
			dbActivityPeriodBudget.setLong(COL_MODULE_ID, donoractivityperiod.getModuleId());

			dbActivityPeriodBudget.insert(); 
			donoractivityperiod.setOID(dbActivityPeriodBudget.getlong(COL_ACTIVITY_PERIOD_BUDGET_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbActivityPeriodBudget(0),CONException.UNKNOWN); 
		}
		return donoractivityperiod.getOID();
	}

	public static long updateExc(ActivityPeriodBudget donoractivityperiod) throws CONException{ 
		try{ 
			if(donoractivityperiod.getOID() != 0){ 
				DbActivityPeriodBudget dbActivityPeriodBudget = new DbActivityPeriodBudget(donoractivityperiod.getOID());

				dbActivityPeriodBudget.setLong(COL_ACTIVITY_PERIOD_ID, donoractivityperiod.getActivityPeriodId());
				dbActivityPeriodBudget.setDouble(COL_BUDGET, donoractivityperiod.getBudget());
				dbActivityPeriodBudget.setLong(COL_MODULE_ID, donoractivityperiod.getModuleId());

				dbActivityPeriodBudget.update(); 
				return donoractivityperiod.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbActivityPeriodBudget(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbActivityPeriodBudget dbActivityPeriodBudget = new DbActivityPeriodBudget(oid);
			dbActivityPeriodBudget.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbActivityPeriodBudget(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_DONOR_ACTIVITY_PERIOD; 
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
				ActivityPeriodBudget donoractivityperiod = new ActivityPeriodBudget();
				resultToObject(rs, donoractivityperiod);
				lists.add(donoractivityperiod);
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

	private static void resultToObject(ResultSet rs, ActivityPeriodBudget donoractivityperiod){
		try{
			donoractivityperiod.setOID(rs.getLong(DbActivityPeriodBudget.colNames[DbActivityPeriodBudget.COL_ACTIVITY_PERIOD_BUDGET_ID]));
			donoractivityperiod.setActivityPeriodId(rs.getLong(DbActivityPeriodBudget.colNames[DbActivityPeriodBudget.COL_ACTIVITY_PERIOD_ID]));
			donoractivityperiod.setBudget(rs.getDouble(DbActivityPeriodBudget.colNames[DbActivityPeriodBudget.COL_BUDGET]));
			donoractivityperiod.setModuleId(rs.getLong(DbActivityPeriodBudget.colNames[DbActivityPeriodBudget.COL_MODULE_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long donorActivityPeriodId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_DONOR_ACTIVITY_PERIOD + " WHERE " + 
						DbActivityPeriodBudget.colNames[DbActivityPeriodBudget.COL_ACTIVITY_PERIOD_BUDGET_ID] + " = " + donorActivityPeriodId;

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
			String sql = "SELECT COUNT("+ DbActivityPeriodBudget.colNames[DbActivityPeriodBudget.COL_ACTIVITY_PERIOD_BUDGET_ID] + ") FROM " + DB_DONOR_ACTIVITY_PERIOD;
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
			  	   ActivityPeriodBudget donoractivityperiod = (ActivityPeriodBudget)list.get(ls);
				   if(oid == donoractivityperiod.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
