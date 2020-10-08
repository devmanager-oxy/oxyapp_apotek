
package com.project.clinic.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*;  

public class DbInsuranceRelation extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_INSURANCE_RELATION = "CL_INSURANCE_RELATION";

	public static final  int COL_INSURANCE_RELATION_ID = 0;
	public static final  int COL_NAME = 1;

	public static final  String[] colNames = {
		"INSURANCE_RELATION_ID",
		"NAME"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
	 }; 

	public DbInsuranceRelation(){
	}

	public DbInsuranceRelation(int i) throws CONException { 
		super(new DbInsuranceRelation()); 
	}

	public DbInsuranceRelation(String sOid) throws CONException { 
		super(new DbInsuranceRelation(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbInsuranceRelation(long lOid) throws CONException { 
		super(new DbInsuranceRelation(0)); 
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
		return DB_CL_INSURANCE_RELATION;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbInsuranceRelation().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		InsuranceRelation insurancerelation = fetchExc(ent.getOID()); 
		ent = (Entity)insurancerelation; 
		return insurancerelation.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((InsuranceRelation) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((InsuranceRelation) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static InsuranceRelation fetchExc(long oid) throws CONException{ 
		try{ 
			InsuranceRelation insurancerelation = new InsuranceRelation();
			DbInsuranceRelation pstInsuranceRelation = new DbInsuranceRelation(oid); 
			insurancerelation.setOID(oid);

			insurancerelation.setName(pstInsuranceRelation.getString(COL_NAME));

			return insurancerelation; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInsuranceRelation(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(InsuranceRelation insurancerelation) throws CONException{ 
		try{ 
			DbInsuranceRelation pstInsuranceRelation = new DbInsuranceRelation(0);

			pstInsuranceRelation.setString(COL_NAME, insurancerelation.getName());

			pstInsuranceRelation.insert(); 
			insurancerelation.setOID(pstInsuranceRelation.getlong(COL_INSURANCE_RELATION_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInsuranceRelation(0),CONException.UNKNOWN); 
		}
		return insurancerelation.getOID();
	}

	public static long updateExc(InsuranceRelation insurancerelation) throws CONException{ 
		try{ 
			if(insurancerelation.getOID() != 0){ 
				DbInsuranceRelation pstInsuranceRelation = new DbInsuranceRelation(insurancerelation.getOID());

				pstInsuranceRelation.setString(COL_NAME, insurancerelation.getName());

				pstInsuranceRelation.update(); 
				return insurancerelation.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInsuranceRelation(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbInsuranceRelation pstInsuranceRelation = new DbInsuranceRelation(oid);
			pstInsuranceRelation.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInsuranceRelation(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_INSURANCE_RELATION; 
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
				InsuranceRelation insurancerelation = new InsuranceRelation();
				resultToObject(rs, insurancerelation);
				lists.add(insurancerelation);
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

	private static void resultToObject(ResultSet rs, InsuranceRelation insurancerelation){
		try{
			insurancerelation.setOID(rs.getLong(DbInsuranceRelation.colNames[DbInsuranceRelation.COL_INSURANCE_RELATION_ID]));
			insurancerelation.setName(rs.getString(DbInsuranceRelation.colNames[DbInsuranceRelation.COL_NAME]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long insuranceRelationId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_INSURANCE_RELATION + " WHERE " + 
						DbInsuranceRelation.colNames[DbInsuranceRelation.COL_INSURANCE_RELATION_ID] + " = " + insuranceRelationId;

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
			String sql = "SELECT COUNT("+ DbInsuranceRelation.colNames[DbInsuranceRelation.COL_INSURANCE_RELATION_ID] + ") FROM " + DB_CL_INSURANCE_RELATION;
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
			  	   InsuranceRelation insurancerelation = (InsuranceRelation)list.get(ls);
				   if(oid == insurancerelation.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
