
package com.project.general; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 

public class DbTelpCharge extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_TELP_CHARGE = "TELP_CHARGE";

	public static final  int COL_TELP_CHARGE_ID = 0;
	public static final  int COL_USER_ID = 1;
	public static final  int COL_CALL_TYPE = 2;
	public static final  int COL_AREA_NAME = 3;
	public static final  int COL_PREFIX_NUMBER = 4;
	public static final  int COL_UNIT_CALL = 5;
	public static final  int COL_CHARGE = 6;

	public static final  String[] colNames = {
		"TELP_CHARGE_ID",
		"USER_ID",
		"CALL_TYPE",
		"AREA_NAME",
		"PREFIX_NUMBER",
		"UNIT_CALL",
		"CHARGE"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_FLOAT
	 }; 

	public DbTelpCharge(){
	}

	public DbTelpCharge(int i) throws CONException { 
		super(new DbTelpCharge()); 
	}

	public DbTelpCharge(String sOid) throws CONException { 
		super(new DbTelpCharge(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbTelpCharge(long lOid) throws CONException { 
		super(new DbTelpCharge(0)); 
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
		return DB_TELP_CHARGE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbTelpCharge().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		TelpCharge telpcharge = fetchExc(ent.getOID()); 
		ent = (Entity)telpcharge; 
		return telpcharge.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((TelpCharge) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((TelpCharge) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static TelpCharge fetchExc(long oid) throws CONException{ 
		try{ 
			TelpCharge telpcharge = new TelpCharge();
			DbTelpCharge pstTelpCharge = new DbTelpCharge(oid); 
			telpcharge.setOID(oid);

			telpcharge.setUserId(pstTelpCharge.getlong(COL_USER_ID));
			telpcharge.setCallType(pstTelpCharge.getString(COL_CALL_TYPE));
			telpcharge.setAreaName(pstTelpCharge.getString(COL_AREA_NAME));
			telpcharge.setPrefixNumber(pstTelpCharge.getString(COL_PREFIX_NUMBER));
			telpcharge.setUnitCall(pstTelpCharge.getInt(COL_UNIT_CALL));
			telpcharge.setCharge(pstTelpCharge.getdouble(COL_CHARGE));

			return telpcharge; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTelpCharge(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(TelpCharge telpcharge) throws CONException{ 
		try{ 
			DbTelpCharge pstTelpCharge = new DbTelpCharge(0);

			pstTelpCharge.setLong(COL_USER_ID, telpcharge.getUserId());
			pstTelpCharge.setString(COL_CALL_TYPE, telpcharge.getCallType());
			pstTelpCharge.setString(COL_AREA_NAME, telpcharge.getAreaName());
			pstTelpCharge.setString(COL_PREFIX_NUMBER, telpcharge.getPrefixNumber());
			pstTelpCharge.setInt(COL_UNIT_CALL, telpcharge.getUnitCall());
			pstTelpCharge.setDouble(COL_CHARGE, telpcharge.getCharge());

			pstTelpCharge.insert(); 
			telpcharge.setOID(pstTelpCharge.getlong(COL_TELP_CHARGE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTelpCharge(0),CONException.UNKNOWN); 
		}
		return telpcharge.getOID();
	}

	public static long updateExc(TelpCharge telpcharge) throws CONException{ 
		try{ 
			if(telpcharge.getOID() != 0){ 
				DbTelpCharge pstTelpCharge = new DbTelpCharge(telpcharge.getOID());

				pstTelpCharge.setLong(COL_USER_ID, telpcharge.getUserId());
				pstTelpCharge.setString(COL_CALL_TYPE, telpcharge.getCallType());
				pstTelpCharge.setString(COL_AREA_NAME, telpcharge.getAreaName());
				pstTelpCharge.setString(COL_PREFIX_NUMBER, telpcharge.getPrefixNumber());
				pstTelpCharge.setInt(COL_UNIT_CALL, telpcharge.getUnitCall());
				pstTelpCharge.setDouble(COL_CHARGE, telpcharge.getCharge());

				pstTelpCharge.update(); 
				return telpcharge.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTelpCharge(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbTelpCharge pstTelpCharge = new DbTelpCharge(oid);
			pstTelpCharge.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTelpCharge(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_TELP_CHARGE; 
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
				TelpCharge telpcharge = new TelpCharge();
				resultToObject(rs, telpcharge);
				lists.add(telpcharge);
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

	private static void resultToObject(ResultSet rs, TelpCharge telpcharge){
		try{
			telpcharge.setOID(rs.getLong(DbTelpCharge.colNames[DbTelpCharge.COL_TELP_CHARGE_ID]));
			telpcharge.setUserId(rs.getLong(DbTelpCharge.colNames[DbTelpCharge.COL_USER_ID]));
			telpcharge.setCallType(rs.getString(DbTelpCharge.colNames[DbTelpCharge.COL_CALL_TYPE]));
			telpcharge.setAreaName(rs.getString(DbTelpCharge.colNames[DbTelpCharge.COL_AREA_NAME]));
			telpcharge.setPrefixNumber(rs.getString(DbTelpCharge.colNames[DbTelpCharge.COL_PREFIX_NUMBER]));
			telpcharge.setUnitCall(rs.getInt(DbTelpCharge.colNames[DbTelpCharge.COL_UNIT_CALL]));
			telpcharge.setCharge(rs.getDouble(DbTelpCharge.colNames[DbTelpCharge.COL_CHARGE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long telpChargeId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_TELP_CHARGE + " WHERE " + 
						DbTelpCharge.colNames[DbTelpCharge.COL_TELP_CHARGE_ID] + " = " + telpChargeId;

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
			String sql = "SELECT COUNT("+ DbTelpCharge.colNames[DbTelpCharge.COL_TELP_CHARGE_ID] + ") FROM " + DB_TELP_CHARGE;
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
			  	   TelpCharge telpcharge = (TelpCharge)list.get(ls);
				   if(oid == telpcharge.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
