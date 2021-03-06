
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

public class DbInsurance extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_INSURANCE = "cl_insurance";

	public static final  int COL_INSURANCE_ID = 0;
	public static final  int COL_NAME = 1;
	public static final  int COL_CODE = 2;
        public static final  int COL_PRICE_GROUP = 3;
        public static final  int COL_MEMBER_ID = 4;
        public static final  int COL_DISC_PERCENT = 5;

	public static final  String[] colNames = {
		"insurance_id",
                "name",
                "code",
                "price_group",
                "member_id",
                "disc_percent"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_FLOAT
	 }; 

	public DbInsurance(){
	}

	public DbInsurance(int i) throws CONException { 
		super(new DbInsurance()); 
	}

	public DbInsurance(String sOid) throws CONException { 
		super(new DbInsurance(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbInsurance(long lOid) throws CONException { 
		super(new DbInsurance(0)); 
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
		return DB_CL_INSURANCE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbInsurance().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Insurance insurance = fetchExc(ent.getOID()); 
		ent = (Entity)insurance; 
		return insurance.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Insurance) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Insurance) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Insurance fetchExc(long oid) throws CONException{ 
		try{ 
			Insurance insurance = new Insurance();
			DbInsurance pstInsurance = new DbInsurance(oid); 
			insurance.setOID(oid);

			insurance.setName(pstInsurance.getString(COL_NAME));
			insurance.setCode(pstInsurance.getString(COL_CODE));
                        insurance.setPriceGroup(pstInsurance.getString(COL_PRICE_GROUP));
                        insurance.setMemberId(pstInsurance.getlong(COL_MEMBER_ID));
                        insurance.setDiscPercent(pstInsurance.getdouble(COL_DISC_PERCENT));

			return insurance; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInsurance(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Insurance insurance) throws CONException{ 
		try{ 
			DbInsurance pstInsurance = new DbInsurance(0);

			pstInsurance.setString(COL_NAME, insurance.getName());
			pstInsurance.setString(COL_CODE, insurance.getCode());
                        pstInsurance.setString(COL_PRICE_GROUP, insurance.getPriceGroup());
                        pstInsurance.setLong(COL_MEMBER_ID, insurance.getMemberId());
                        pstInsurance.setDouble(COL_DISC_PERCENT, insurance.getDiscPercent());

			pstInsurance.insert(); 
			insurance.setOID(pstInsurance.getlong(COL_INSURANCE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInsurance(0),CONException.UNKNOWN); 
		}
		return insurance.getOID();
	}

	public static long updateExc(Insurance insurance) throws CONException{ 
		try{ 
			if(insurance.getOID() != 0){ 
				DbInsurance pstInsurance = new DbInsurance(insurance.getOID());

				pstInsurance.setString(COL_NAME, insurance.getName());
				pstInsurance.setString(COL_CODE, insurance.getCode());
                                pstInsurance.setString(COL_PRICE_GROUP, insurance.getPriceGroup());
                                pstInsurance.setLong(COL_MEMBER_ID, insurance.getMemberId());
                                pstInsurance.setDouble(COL_DISC_PERCENT, insurance.getDiscPercent());

				pstInsurance.update(); 
				return insurance.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInsurance(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbInsurance pstInsurance = new DbInsurance(oid);
			pstInsurance.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbInsurance(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_INSURANCE; 
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
				Insurance insurance = new Insurance();
				resultToObject(rs, insurance);
				lists.add(insurance);
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

	private static void resultToObject(ResultSet rs, Insurance insurance){
		try{
			insurance.setOID(rs.getLong(DbInsurance.colNames[DbInsurance.COL_INSURANCE_ID]));
			insurance.setName(rs.getString(DbInsurance.colNames[DbInsurance.COL_NAME]));
			insurance.setCode(rs.getString(DbInsurance.colNames[DbInsurance.COL_CODE]));
                        insurance.setPriceGroup(rs.getString(DbInsurance.colNames[DbInsurance.COL_PRICE_GROUP]));
                        insurance.setMemberId(rs.getLong(DbInsurance.colNames[DbInsurance.COL_MEMBER_ID]));
                        insurance.setDiscPercent(rs.getDouble(DbInsurance.colNames[DbInsurance.COL_DISC_PERCENT]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long insuranceId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_INSURANCE + " WHERE " + 
						DbInsurance.colNames[DbInsurance.COL_INSURANCE_ID] + " = " + insuranceId;

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
			String sql = "SELECT COUNT("+ DbInsurance.colNames[DbInsurance.COL_INSURANCE_ID] + ") FROM " + DB_CL_INSURANCE;
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
			  	   Insurance insurance = (Insurance)list.get(ls);
				   if(oid == insurance.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
