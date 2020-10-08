
package com.project.fms.activity; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 

public class DbCoaActivity extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_COA_ACTIVITY = "coa_activity";

	public static final  int COL_COA_ACTIVITY_ID = 0;
	public static final  int COL_COA_ID = 1;
	public static final  int COL_MODULE_ID = 2;
        public static final  int COL_DEPARTMENT_ID = 3;
        public static final  int COL_SECTION_ID = 4;

	public static final  String[] colNames = {
		"coa_activity_id",
		"coa_id",
		"module_id",
                "department_id",
                "section_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	 }; 

	public DbCoaActivity(){
	}

	public DbCoaActivity(int i) throws CONException { 
		super(new DbCoaActivity()); 
	}

	public DbCoaActivity(String sOid) throws CONException { 
		super(new DbCoaActivity(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCoaActivity(long lOid) throws CONException { 
		super(new DbCoaActivity(0)); 
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
		return DB_COA_ACTIVITY;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCoaActivity().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		CoaActivity coaactivity = fetchExc(ent.getOID()); 
		ent = (Entity)coaactivity; 
		return coaactivity.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((CoaActivity) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((CoaActivity) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static CoaActivity fetchExc(long oid) throws CONException{ 
		try{ 
			CoaActivity coaactivity = new CoaActivity();
			DbCoaActivity dbCoaActivity = new DbCoaActivity(oid); 
			coaactivity.setOID(oid);

			coaactivity.setCoaId(dbCoaActivity.getlong(COL_COA_ID));
			coaactivity.setModuleId(dbCoaActivity.getlong(COL_MODULE_ID));
                        coaactivity.setDepartmentId(dbCoaActivity.getlong(COL_DEPARTMENT_ID));
                        coaactivity.setSectionId(dbCoaActivity.getlong(COL_SECTION_ID));

			return coaactivity; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivity(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(CoaActivity coaactivity) throws CONException{ 
		try{ 
			DbCoaActivity dbCoaActivity = new DbCoaActivity(0);

			dbCoaActivity.setLong(COL_COA_ID, coaactivity.getCoaId());
			dbCoaActivity.setLong(COL_MODULE_ID, coaactivity.getModuleId());
                        dbCoaActivity.setLong(COL_DEPARTMENT_ID, coaactivity.getDepartmentId());
                        dbCoaActivity.setLong(COL_SECTION_ID, coaactivity.getSectionId());

			dbCoaActivity.insert(); 
			coaactivity.setOID(dbCoaActivity.getlong(COL_COA_ACTIVITY_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivity(0),CONException.UNKNOWN); 
		}
		return coaactivity.getOID();
	}

	public static long updateExc(CoaActivity coaactivity) throws CONException{ 
		try{ 
			if(coaactivity.getOID() != 0){ 
				DbCoaActivity dbCoaActivity = new DbCoaActivity(coaactivity.getOID());

				dbCoaActivity.setLong(COL_COA_ID, coaactivity.getCoaId());
				dbCoaActivity.setLong(COL_MODULE_ID, coaactivity.getModuleId());
                                dbCoaActivity.setLong(COL_DEPARTMENT_ID, coaactivity.getDepartmentId());
                                dbCoaActivity.setLong(COL_SECTION_ID, coaactivity.getSectionId());

				dbCoaActivity.update(); 
				return coaactivity.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivity(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCoaActivity dbCoaActivity = new DbCoaActivity(oid);
			dbCoaActivity.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaActivity(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_COA_ACTIVITY; 
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
				CoaActivity coaactivity = new CoaActivity();
				resultToObject(rs, coaactivity);
				lists.add(coaactivity);
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

	private static void resultToObject(ResultSet rs, CoaActivity coaactivity){
		try{
			coaactivity.setOID(rs.getLong(DbCoaActivity.colNames[DbCoaActivity.COL_COA_ACTIVITY_ID]));
			coaactivity.setCoaId(rs.getLong(DbCoaActivity.colNames[DbCoaActivity.COL_COA_ID]));
			coaactivity.setModuleId(rs.getLong(DbCoaActivity.colNames[DbCoaActivity.COL_MODULE_ID]));
                        coaactivity.setDepartmentId(rs.getLong(DbCoaActivity.colNames[DbCoaActivity.COL_DEPARTMENT_ID]));
                        coaactivity.setSectionId(rs.getLong(DbCoaActivity.colNames[DbCoaActivity.COL_SECTION_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long coaActivityId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_COA_ACTIVITY + " WHERE " + 
						DbCoaActivity.colNames[DbCoaActivity.COL_COA_ACTIVITY_ID] + " = " + coaActivityId;

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
			String sql = "SELECT COUNT("+ DbCoaActivity.colNames[DbCoaActivity.COL_COA_ACTIVITY_ID] + ") FROM " + DB_COA_ACTIVITY;
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
			  	   CoaActivity coaactivity = (CoaActivity)list.get(ls);
				   if(oid == coaactivity.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
     
        
}
