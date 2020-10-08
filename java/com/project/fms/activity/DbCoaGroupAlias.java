
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

public class DbCoaGroupAlias extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_COA_GROUP_ALIAS = "coa_group_alias";

	public static final  int COL_COA_GROUP_ALIAS_ID = 0;
	public static final  int COL_NAME = 1;

	public static final  String[] colNames = {
		"coa_group_alias_id",
		"name"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
	 }; 

	public DbCoaGroupAlias(){
	}

	public DbCoaGroupAlias(int i) throws CONException { 
		super(new DbCoaGroupAlias()); 
	}

	public DbCoaGroupAlias(String sOid) throws CONException { 
		super(new DbCoaGroupAlias(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCoaGroupAlias(long lOid) throws CONException { 
		super(new DbCoaGroupAlias(0)); 
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
		return DB_COA_GROUP_ALIAS;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCoaGroupAlias().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		CoaGroupAlias coanatureexpensecategory = fetchExc(ent.getOID()); 
		ent = (Entity)coanatureexpensecategory; 
		return coanatureexpensecategory.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((CoaGroupAlias) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((CoaGroupAlias) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static CoaGroupAlias fetchExc(long oid) throws CONException{ 
		try{ 
			CoaGroupAlias coanatureexpensecategory = new CoaGroupAlias();
			DbCoaGroupAlias pstCoaGroupAlias = new DbCoaGroupAlias(oid); 
			coanatureexpensecategory.setOID(oid);

			coanatureexpensecategory.setName(pstCoaGroupAlias.getString(COL_NAME));

			return coanatureexpensecategory; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaGroupAlias(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(CoaGroupAlias coanatureexpensecategory) throws CONException{ 
		try{ 
			DbCoaGroupAlias pstCoaGroupAlias = new DbCoaGroupAlias(0);

			pstCoaGroupAlias.setString(COL_NAME, coanatureexpensecategory.getName());

			pstCoaGroupAlias.insert(); 
			coanatureexpensecategory.setOID(pstCoaGroupAlias.getlong(COL_COA_GROUP_ALIAS_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaGroupAlias(0),CONException.UNKNOWN); 
		}
		return coanatureexpensecategory.getOID();
	}

	public static long updateExc(CoaGroupAlias coanatureexpensecategory) throws CONException{ 
		try{ 
			if(coanatureexpensecategory.getOID() != 0){ 
				DbCoaGroupAlias pstCoaGroupAlias = new DbCoaGroupAlias(coanatureexpensecategory.getOID());

				pstCoaGroupAlias.setString(COL_NAME, coanatureexpensecategory.getName());

				pstCoaGroupAlias.update(); 
				return coanatureexpensecategory.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaGroupAlias(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCoaGroupAlias pstCoaGroupAlias = new DbCoaGroupAlias(oid);
			pstCoaGroupAlias.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCoaGroupAlias(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_COA_GROUP_ALIAS; 
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
				CoaGroupAlias coanatureexpensecategory = new CoaGroupAlias();
				resultToObject(rs, coanatureexpensecategory);
				lists.add(coanatureexpensecategory);
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

	private static void resultToObject(ResultSet rs, CoaGroupAlias coanatureexpensecategory){
		try{
			coanatureexpensecategory.setOID(rs.getLong(DbCoaGroupAlias.colNames[DbCoaGroupAlias.COL_COA_GROUP_ALIAS_ID]));
			coanatureexpensecategory.setName(rs.getString(DbCoaGroupAlias.colNames[DbCoaGroupAlias.COL_NAME]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long coaNatureExpenseCategoryId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_COA_GROUP_ALIAS + " WHERE " + 
						DbCoaGroupAlias.colNames[DbCoaGroupAlias.COL_COA_GROUP_ALIAS_ID] + " = " + coaNatureExpenseCategoryId;

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
			String sql = "SELECT COUNT("+ DbCoaGroupAlias.colNames[DbCoaGroupAlias.COL_COA_GROUP_ALIAS_ID] + ") FROM " + DB_COA_GROUP_ALIAS;
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
			  	   CoaGroupAlias coanatureexpensecategory = (CoaGroupAlias)list.get(ls);
				   if(oid == coanatureexpensecategory.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
