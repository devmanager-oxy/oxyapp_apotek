
package com.project.fms.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 

public class DbDonor extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_DONOR = "donor";

	public static final  int COL_DONOR_ID = 0;
	public static final  int COL_NAME = 1;
	public static final  int COL_ADDRESS = 2;
	public static final  int COL_CITY = 3;
	public static final  int COL_STATE = 4;
	public static final  int COL_COUNTRY_NAME = 5;
	public static final  int COL_DESCRIPTION = 6;
	public static final  int COL_COUNTRY_ID = 7;
	public static final  int COL_PHONE = 8;
	public static final  int COL_FAX = 9;
	public static final  int COL_HP = 10;
	public static final  int COL_CODE = 11;
        public static final  int COL_CONTACT_PERSON = 12;

	public static final  String[] colNames = {
		"donor_id",
		"name",
		"address",
		"city",
		"state",
		"country_name",
		"description",
		"country_id",
		"phone",
		"fax",
		"hp",
		"code",
                "contact_person"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
                TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbDonor(){
	}

	public DbDonor(int i) throws CONException { 
		super(new DbDonor()); 
	}

	public DbDonor(String sOid) throws CONException { 
		super(new DbDonor(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbDonor(long lOid) throws CONException { 
		super(new DbDonor(0)); 
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
		return DB_DONOR;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbDonor().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Donor donor = fetchExc(ent.getOID()); 
		ent = (Entity)donor; 
		return donor.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Donor) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Donor) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Donor fetchExc(long oid) throws CONException{ 
		try{ 
			Donor donor = new Donor();
			DbDonor dbDonor = new DbDonor(oid); 
			donor.setOID(oid);

			donor.setName(dbDonor.getString(COL_NAME));
			donor.setAddress(dbDonor.getString(COL_ADDRESS));
			donor.setCity(dbDonor.getString(COL_CITY));
			donor.setState(dbDonor.getString(COL_STATE));
			donor.setCountryName(dbDonor.getString(COL_COUNTRY_NAME));
			donor.setDescription(dbDonor.getString(COL_DESCRIPTION));
			donor.setCountryId(dbDonor.getlong(COL_COUNTRY_ID));
			donor.setPhone(dbDonor.getString(COL_PHONE));
			donor.setFax(dbDonor.getString(COL_FAX));
			donor.setHp(dbDonor.getString(COL_HP));
			donor.setCode(dbDonor.getString(COL_CODE));
                        donor.setContactPerson(dbDonor.getString(COL_CONTACT_PERSON));
			return donor; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDonor(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Donor donor) throws CONException{ 
		try{ 
			DbDonor dbDonor = new DbDonor(0);

			dbDonor.setString(COL_NAME, donor.getName());
			dbDonor.setString(COL_ADDRESS, donor.getAddress());
			dbDonor.setString(COL_CITY, donor.getCity());
			dbDonor.setString(COL_STATE, donor.getState());
			dbDonor.setString(COL_COUNTRY_NAME, donor.getCountryName());
			dbDonor.setString(COL_DESCRIPTION, donor.getDescription());
			dbDonor.setLong(COL_COUNTRY_ID, donor.getCountryId());
			dbDonor.setString(COL_PHONE, donor.getPhone());
			dbDonor.setString(COL_FAX, donor.getFax());
			dbDonor.setString(COL_HP, donor.getHp());
			dbDonor.setString(COL_CODE, donor.getCode());
                        dbDonor.setString(COL_CONTACT_PERSON, donor.getContactPerson());

			dbDonor.insert(); 
			donor.setOID(dbDonor.getlong(COL_DONOR_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDonor(0),CONException.UNKNOWN); 
		}
		return donor.getOID();
	}

	public static long updateExc(Donor donor) throws CONException{ 
		try{ 
			if(donor.getOID() != 0){ 
				DbDonor dbDonor = new DbDonor(donor.getOID());

				dbDonor.setString(COL_NAME, donor.getName());
				dbDonor.setString(COL_ADDRESS, donor.getAddress());
				dbDonor.setString(COL_CITY, donor.getCity());
				dbDonor.setString(COL_STATE, donor.getState());
				dbDonor.setString(COL_COUNTRY_NAME, donor.getCountryName());
				dbDonor.setString(COL_DESCRIPTION, donor.getDescription());
				dbDonor.setLong(COL_COUNTRY_ID, donor.getCountryId());
				dbDonor.setString(COL_PHONE, donor.getPhone());
				dbDonor.setString(COL_FAX, donor.getFax());
				dbDonor.setString(COL_HP, donor.getHp());
				dbDonor.setString(COL_CODE, donor.getCode());
                                dbDonor.setString(COL_CONTACT_PERSON, donor.getContactPerson());

				dbDonor.update(); 
				return donor.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDonor(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbDonor dbDonor = new DbDonor(oid);
			dbDonor.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDonor(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_DONOR; 
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
				Donor donor = new Donor();
				resultToObject(rs, donor);
				lists.add(donor);
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

	private static void resultToObject(ResultSet rs, Donor donor){
		try{
			donor.setOID(rs.getLong(DbDonor.colNames[DbDonor.COL_DONOR_ID]));
			donor.setName(rs.getString(DbDonor.colNames[DbDonor.COL_NAME]));
			donor.setAddress(rs.getString(DbDonor.colNames[DbDonor.COL_ADDRESS]));
			donor.setCity(rs.getString(DbDonor.colNames[DbDonor.COL_CITY]));
			donor.setState(rs.getString(DbDonor.colNames[DbDonor.COL_STATE]));
			donor.setCountryName(rs.getString(DbDonor.colNames[DbDonor.COL_COUNTRY_NAME]));
			donor.setDescription(rs.getString(DbDonor.colNames[DbDonor.COL_DESCRIPTION]));
			donor.setCountryId(rs.getLong(DbDonor.colNames[DbDonor.COL_COUNTRY_ID]));
			donor.setPhone(rs.getString(DbDonor.colNames[DbDonor.COL_PHONE]));
			donor.setFax(rs.getString(DbDonor.colNames[DbDonor.COL_FAX]));
			donor.setHp(rs.getString(DbDonor.colNames[DbDonor.COL_HP]));
			donor.setCode(rs.getString(DbDonor.colNames[DbDonor.COL_CODE]));
                        donor.setContactPerson(rs.getString(DbDonor.colNames[DbDonor.COL_CONTACT_PERSON]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long donorId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_DONOR + " WHERE " + 
						DbDonor.colNames[DbDonor.COL_DONOR_ID] + " = " + donorId;

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
			String sql = "SELECT COUNT("+ DbDonor.colNames[DbDonor.COL_DONOR_ID] + ") FROM " + DB_DONOR;
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
			  	   Donor donor = (Donor)list.get(ls);
				   if(oid == donor.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
      
        
}
