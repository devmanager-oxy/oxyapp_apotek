

package com.project.general; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 

public class DbCountry extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_COUNTRY = "country";

	public static final  int COL_COUNTY_ID = 0;
	public static final  int COL_NAME = 1;
	public static final  int COL_NATIONALITY = 2;
	public static final  int COL_CONTINENT = 3;
	public static final  int COL_HUB = 4;

	public static final  String[] colNames = {
		"country_id",
		"name",
		"nationality",
		"continent",
		"hub"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbCountry(){
	}

	public DbCountry(int i) throws CONException { 
		super(new DbCountry()); 
	}

	public DbCountry(String sOid) throws CONException { 
		super(new DbCountry(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCountry(long lOid) throws CONException { 
		super(new DbCountry(0)); 
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
		return DB_COUNTRY;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCountry().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Country country = fetchExc(ent.getOID()); 
		ent = (Entity)country; 
		return country.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Country) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Country) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Country fetchExc(long oid) throws CONException{ 
		try{ 
			Country country = new Country();
			DbCountry pstCountry = new DbCountry(oid); 
			country.setOID(oid);

			country.setName(pstCountry.getString(COL_NAME));
			country.setNationality(pstCountry.getString(COL_NATIONALITY));
			country.setContinent(pstCountry.getString(COL_CONTINENT));
			country.setHub(pstCountry.getString(COL_HUB));

			return country; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCountry(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Country country) throws CONException{ 
		try{ 
			DbCountry pstCountry = new DbCountry(0);

			pstCountry.setString(COL_NAME, country.getName());
			pstCountry.setString(COL_NATIONALITY, country.getNationality());
			pstCountry.setString(COL_CONTINENT, country.getContinent());
			pstCountry.setString(COL_HUB, country.getHub());

			pstCountry.insert(); 
			country.setOID(pstCountry.getlong(COL_COUNTY_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCountry(0),CONException.UNKNOWN); 
		}
		return country.getOID();
	}

	public static long updateExc(Country country) throws CONException{ 
		try{ 
			if(country.getOID() != 0){ 
				DbCountry pstCountry = new DbCountry(country.getOID());

				pstCountry.setString(COL_NAME, country.getName());
				pstCountry.setString(COL_NATIONALITY, country.getNationality());
				pstCountry.setString(COL_CONTINENT, country.getContinent());
				pstCountry.setString(COL_HUB, country.getHub());

				pstCountry.update(); 
				return country.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCountry(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCountry pstCountry = new DbCountry(oid);
			pstCountry.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCountry(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_COUNTRY; 
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
				Country country = new Country();
				resultToObject(rs, country);
				lists.add(country);
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

	private static void resultToObject(ResultSet rs, Country country){
		try{
			country.setOID(rs.getLong(DbCountry.colNames[DbCountry.COL_COUNTY_ID]));
			country.setName(rs.getString(DbCountry.colNames[DbCountry.COL_NAME]));
			country.setNationality(rs.getString(DbCountry.colNames[DbCountry.COL_NATIONALITY]));
			country.setContinent(rs.getString(DbCountry.colNames[DbCountry.COL_CONTINENT]));
			country.setHub(rs.getString(DbCountry.colNames[DbCountry.COL_HUB]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long countyId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_COUNTRY + " WHERE " + 
						DbCountry.colNames[DbCountry.COL_COUNTY_ID] + " = " + countyId;

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

	public static boolean checkNegara(long countyId, String negara){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_COUNTRY + " WHERE " + 
						DbCountry.colNames[DbCountry.COL_COUNTY_ID] + " != " + countyId+
						" and "	+ DbCountry.colNames[DbCountry.COL_NAME] + " ='" + negara + "'";

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
			String sql = "SELECT COUNT("+ DbCountry.colNames[DbCountry.COL_COUNTY_ID] + ") FROM " + DB_COUNTRY;
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
			  	   Country country = (Country)list.get(ls);
				   if(oid == country.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
