package com.project.fms.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 

public class DbUnitUsaha extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String TBL_UNIT_USAHA = "unit_usaha";

	public static final  int FLD_UNIT_USAHA_ID = 0;
	public static final  int FLD_CODE = 1;
	public static final  int FLD_NAME = 2;
	public static final  int FLD_COA_AR_ID = 3;
	public static final  int FLD_COA_AP_ID = 4;
	public static final  int FLD_COA_PPN_ID = 5;
	public static final  int FLD_COA_PPH_ID = 6;
	public static final  int FLD_COA_DISCOUNT_ID = 7;
	public static final  int FLD_LOCATION_ID = 8;

	public static final  String[] colNames = {
		"unit_usaha_id",
                "code",
                "name",
                "coa_ar_id",
                "coa_ap_id",
                "coa_ppn_id",
                "coa_pph_id",
                "coa_discount_id",
                "location_id"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG
	 }; 

	public DbUnitUsaha(){
	}

	public DbUnitUsaha(int i) throws CONException { 
		super(new DbUnitUsaha()); 
	}

	public DbUnitUsaha(String sOid) throws CONException { 
		super(new DbUnitUsaha(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbUnitUsaha(long lOid) throws CONException { 
		super(new DbUnitUsaha(0)); 
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
		return TBL_UNIT_USAHA;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbUnitUsaha().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		UnitUsaha unitusaha = fetchExc(ent.getOID()); 
		ent = (Entity)unitusaha; 
		return unitusaha.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((UnitUsaha) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((UnitUsaha) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static UnitUsaha fetchExc(long oid) throws CONException{ 
		try{ 
			UnitUsaha unitusaha = new UnitUsaha();
			DbUnitUsaha pstUnitUsaha = new DbUnitUsaha(oid); 
			unitusaha.setOID(oid);

			unitusaha.setCode(pstUnitUsaha.getString(FLD_CODE));
			unitusaha.setName(pstUnitUsaha.getString(FLD_NAME));
			unitusaha.setCoaArId(pstUnitUsaha.getlong(FLD_COA_AR_ID));
			unitusaha.setCoaApId(pstUnitUsaha.getlong(FLD_COA_AP_ID));
			unitusaha.setCoaPpnId(pstUnitUsaha.getlong(FLD_COA_PPN_ID));
			unitusaha.setCoaPphId(pstUnitUsaha.getlong(FLD_COA_PPH_ID));
			unitusaha.setCoaDiscountId(pstUnitUsaha.getlong(FLD_COA_DISCOUNT_ID));
			unitusaha.setLocationId(pstUnitUsaha.getlong(FLD_LOCATION_ID));

			return unitusaha; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbUnitUsaha(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(UnitUsaha unitusaha) throws CONException{ 
		try{ 
			DbUnitUsaha pstUnitUsaha = new DbUnitUsaha(0);

			pstUnitUsaha.setString(FLD_CODE, unitusaha.getCode());
			pstUnitUsaha.setString(FLD_NAME, unitusaha.getName());
			pstUnitUsaha.setLong(FLD_COA_AR_ID, unitusaha.getCoaArId());
			pstUnitUsaha.setLong(FLD_COA_AP_ID, unitusaha.getCoaApId());
			pstUnitUsaha.setLong(FLD_COA_PPN_ID, unitusaha.getCoaPpnId());
			pstUnitUsaha.setLong(FLD_COA_PPH_ID, unitusaha.getCoaPphId());
			pstUnitUsaha.setLong(FLD_COA_DISCOUNT_ID, unitusaha.getCoaDiscountId());
			pstUnitUsaha.setLong(FLD_LOCATION_ID, unitusaha.getLocationId());

			pstUnitUsaha.insert(); 
			unitusaha.setOID(pstUnitUsaha.getlong(FLD_UNIT_USAHA_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbUnitUsaha(0),CONException.UNKNOWN); 
		}
		return unitusaha.getOID();
	}

	public static long updateExc(UnitUsaha unitusaha) throws CONException{ 
		try{ 
			if(unitusaha.getOID() != 0){ 
				DbUnitUsaha pstUnitUsaha = new DbUnitUsaha(unitusaha.getOID());

				pstUnitUsaha.setString(FLD_CODE, unitusaha.getCode());
				pstUnitUsaha.setString(FLD_NAME, unitusaha.getName());
				pstUnitUsaha.setLong(FLD_COA_AR_ID, unitusaha.getCoaArId());
				pstUnitUsaha.setLong(FLD_COA_AP_ID, unitusaha.getCoaApId());
				pstUnitUsaha.setLong(FLD_COA_PPN_ID, unitusaha.getCoaPpnId());
				pstUnitUsaha.setLong(FLD_COA_PPH_ID, unitusaha.getCoaPphId());
				pstUnitUsaha.setLong(FLD_COA_DISCOUNT_ID, unitusaha.getCoaDiscountId());
				pstUnitUsaha.setLong(FLD_LOCATION_ID, unitusaha.getLocationId());

				pstUnitUsaha.update(); 
				return unitusaha.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbUnitUsaha(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbUnitUsaha pstUnitUsaha = new DbUnitUsaha(oid);
			pstUnitUsaha.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbUnitUsaha(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + TBL_UNIT_USAHA; 
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
				UnitUsaha unitusaha = new UnitUsaha();
				resultToObject(rs, unitusaha);
				lists.add(unitusaha);
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

	private static void resultToObject(ResultSet rs, UnitUsaha unitusaha){
		try{
			unitusaha.setOID(rs.getLong(DbUnitUsaha.colNames[DbUnitUsaha.FLD_UNIT_USAHA_ID]));
			unitusaha.setCode(rs.getString(DbUnitUsaha.colNames[DbUnitUsaha.FLD_CODE]));
			unitusaha.setName(rs.getString(DbUnitUsaha.colNames[DbUnitUsaha.FLD_NAME]));
			unitusaha.setCoaArId(rs.getLong(DbUnitUsaha.colNames[DbUnitUsaha.FLD_COA_AR_ID]));
			unitusaha.setCoaApId(rs.getLong(DbUnitUsaha.colNames[DbUnitUsaha.FLD_COA_AP_ID]));
			unitusaha.setCoaPpnId(rs.getLong(DbUnitUsaha.colNames[DbUnitUsaha.FLD_COA_PPN_ID]));
			unitusaha.setCoaPphId(rs.getLong(DbUnitUsaha.colNames[DbUnitUsaha.FLD_COA_PPH_ID]));
			unitusaha.setCoaDiscountId(rs.getLong(DbUnitUsaha.colNames[DbUnitUsaha.FLD_COA_DISCOUNT_ID]));
			unitusaha.setLocationId(rs.getLong(DbUnitUsaha.colNames[DbUnitUsaha.FLD_LOCATION_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long unitUsahaId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + TBL_UNIT_USAHA + " WHERE " + 
						DbUnitUsaha.colNames[DbUnitUsaha.FLD_UNIT_USAHA_ID] + " = " + unitUsahaId;

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
			String sql = "SELECT COUNT("+ DbUnitUsaha.colNames[DbUnitUsaha.FLD_UNIT_USAHA_ID] + ") FROM " + TBL_UNIT_USAHA;
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
			  	   UnitUsaha unitusaha = (UnitUsaha)list.get(ls);
				   if(oid == unitusaha.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
