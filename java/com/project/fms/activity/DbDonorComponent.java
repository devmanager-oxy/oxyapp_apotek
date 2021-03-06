
package com.project.fms.activity; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;

public class DbDonorComponent extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_DONOR_COMPONENT = "donor_component";

	public static final  int COL_DONOR_COMPONENT_ID = 0;
	public static final  int COL_DONOR_ID = 1;
	public static final  int COL_CODE = 2;
	public static final  int COL_NAME = 3;
	public static final  int COL_DESCRIPTION = 4;
	public static final  int COL_DONOR_NAME = 5;

	public static final  String[] colNames = {
		"donor_component_id",
		"donor_id",
		"code",
		"name",
		"description",
		"donor_name"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbDonorComponent(){
	}

	public DbDonorComponent(int i) throws CONException { 
		super(new DbDonorComponent()); 
	}

	public DbDonorComponent(String sOid) throws CONException { 
		super(new DbDonorComponent(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbDonorComponent(long lOid) throws CONException { 
		super(new DbDonorComponent(0)); 
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
		return DB_DONOR_COMPONENT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbDonorComponent().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		DonorComponent donorcomponent = fetchExc(ent.getOID()); 
		ent = (Entity)donorcomponent; 
		return donorcomponent.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((DonorComponent) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((DonorComponent) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static DonorComponent fetchExc(long oid) throws CONException{ 
		try{ 
			DonorComponent donorcomponent = new DonorComponent();
			DbDonorComponent dbDonorComponent = new DbDonorComponent(oid); 
			donorcomponent.setOID(oid);

			donorcomponent.setDonorId(dbDonorComponent.getlong(COL_DONOR_ID));
			donorcomponent.setCode(dbDonorComponent.getString(COL_CODE));
			donorcomponent.setName(dbDonorComponent.getString(COL_NAME));
			donorcomponent.setDescription(dbDonorComponent.getString(COL_DESCRIPTION));
			donorcomponent.setDonorName(dbDonorComponent.getString(COL_DONOR_NAME));

			return donorcomponent; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDonorComponent(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(DonorComponent donorcomponent) throws CONException{ 
		try{ 
			DbDonorComponent dbDonorComponent = new DbDonorComponent(0);

			dbDonorComponent.setLong(COL_DONOR_ID, donorcomponent.getDonorId());
			dbDonorComponent.setString(COL_CODE, donorcomponent.getCode());
			dbDonorComponent.setString(COL_NAME, donorcomponent.getName());
			dbDonorComponent.setString(COL_DESCRIPTION, donorcomponent.getDescription());
			dbDonorComponent.setString(COL_DONOR_NAME, donorcomponent.getDonorName());

			dbDonorComponent.insert(); 
			donorcomponent.setOID(dbDonorComponent.getlong(COL_DONOR_COMPONENT_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDonorComponent(0),CONException.UNKNOWN); 
		}
		return donorcomponent.getOID();
	}

	public static long updateExc(DonorComponent donorcomponent) throws CONException{ 
		try{ 
			if(donorcomponent.getOID() != 0){ 
				DbDonorComponent dbDonorComponent = new DbDonorComponent(donorcomponent.getOID());

				dbDonorComponent.setLong(COL_DONOR_ID, donorcomponent.getDonorId());
				dbDonorComponent.setString(COL_CODE, donorcomponent.getCode());
				dbDonorComponent.setString(COL_NAME, donorcomponent.getName());
				dbDonorComponent.setString(COL_DESCRIPTION, donorcomponent.getDescription());
				dbDonorComponent.setString(COL_DONOR_NAME, donorcomponent.getDonorName());

				dbDonorComponent.update(); 
				return donorcomponent.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDonorComponent(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbDonorComponent dbDonorComponent = new DbDonorComponent(oid);
			dbDonorComponent.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDonorComponent(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_DONOR_COMPONENT; 
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
				DonorComponent donorcomponent = new DonorComponent();
				resultToObject(rs, donorcomponent);
				lists.add(donorcomponent);
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

	private static void resultToObject(ResultSet rs, DonorComponent donorcomponent){
		try{
			donorcomponent.setOID(rs.getLong(DbDonorComponent.colNames[DbDonorComponent.COL_DONOR_COMPONENT_ID]));
			donorcomponent.setDonorId(rs.getLong(DbDonorComponent.colNames[DbDonorComponent.COL_DONOR_ID]));
			donorcomponent.setCode(rs.getString(DbDonorComponent.colNames[DbDonorComponent.COL_CODE]));
			donorcomponent.setName(rs.getString(DbDonorComponent.colNames[DbDonorComponent.COL_NAME]));
			donorcomponent.setDescription(rs.getString(DbDonorComponent.colNames[DbDonorComponent.COL_DESCRIPTION]));
			donorcomponent.setDonorName(rs.getString(DbDonorComponent.colNames[DbDonorComponent.COL_DONOR_NAME]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long donorComponentId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_DONOR_COMPONENT + " WHERE " + 
						DbDonorComponent.colNames[DbDonorComponent.COL_DONOR_COMPONENT_ID] + " = " + donorComponentId;

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
			String sql = "SELECT COUNT("+ DbDonorComponent.colNames[DbDonorComponent.COL_DONOR_COMPONENT_ID] + ") FROM " + DB_DONOR_COMPONENT;
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
			  	   DonorComponent donorcomponent = (DonorComponent)list.get(ls);
				   if(oid == donorcomponent.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
      
}
