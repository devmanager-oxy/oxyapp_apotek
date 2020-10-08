package com.project.fms.asset; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.fms.ar.*; 
import com.project.*;
import com.project.util.*;
import com.project.util.lang.I_Language;
import com.project.fms.master.*;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;

public class DbAssetDataExtra extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_ASSET_DATA_EXTRA = "asset_data_extra";

	public static final  int COL_ASSET_DATA_EXTRA_ID = 0;
	public static final  int COL_DATE = 1;
	public static final  int COL_YEAR = 2;
	public static final  int COL_PENGURANG_PEROLEHAN = 3;
	public static final  int COL_PENGURANG_DEPRE = 4;
	public static final  int COL_USER_ID = 5;
	public static final  int COL_ASSET_DATA_ID = 6;

	public static final  String[] colNames = {
		"asset_data_extra_id",
                "date",
                "year",
                "pengurang_perolehan",
                "pengurang_depre",
                "user_id",
                "asset_data_id"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG
	 }; 

	public DbAssetDataExtra(){
	}

	public DbAssetDataExtra(int i) throws CONException { 
		super(new DbAssetDataExtra()); 
	}

	public DbAssetDataExtra(String sOid) throws CONException { 
		super(new DbAssetDataExtra(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbAssetDataExtra(long lOid) throws CONException { 
		super(new DbAssetDataExtra(0)); 
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
		return DB_ASSET_DATA_EXTRA;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbAssetDataExtra().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		AssetDataExtra assetdataextra = fetchExc(ent.getOID()); 
		ent = (Entity)assetdataextra; 
		return assetdataextra.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((AssetDataExtra) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((AssetDataExtra) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static AssetDataExtra fetchExc(long oid) throws CONException{ 
		try{ 
			AssetDataExtra assetdataextra = new AssetDataExtra();
			DbAssetDataExtra pstAssetDataExtra = new DbAssetDataExtra(oid); 
			assetdataextra.setOID(oid);

			assetdataextra.setDate(pstAssetDataExtra.getDate(COL_DATE));
			assetdataextra.setYear(pstAssetDataExtra.getInt(COL_YEAR));
			assetdataextra.setPengurangPerolehan(pstAssetDataExtra.getdouble(COL_PENGURANG_PEROLEHAN));
			assetdataextra.setPengurangDepre(pstAssetDataExtra.getdouble(COL_PENGURANG_DEPRE));
			assetdataextra.setUserId(pstAssetDataExtra.getlong(COL_USER_ID));
			assetdataextra.setAssetDataId(pstAssetDataExtra.getlong(COL_ASSET_DATA_ID));

			return assetdataextra; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetDataExtra(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(AssetDataExtra assetdataextra) throws CONException{ 
		try{ 
			DbAssetDataExtra pstAssetDataExtra = new DbAssetDataExtra(0);

			pstAssetDataExtra.setDate(COL_DATE, assetdataextra.getDate());
			pstAssetDataExtra.setInt(COL_YEAR, assetdataextra.getYear());
			pstAssetDataExtra.setDouble(COL_PENGURANG_PEROLEHAN, assetdataextra.getPengurangPerolehan());
			pstAssetDataExtra.setDouble(COL_PENGURANG_DEPRE, assetdataextra.getPengurangDepre());
			pstAssetDataExtra.setLong(COL_USER_ID, assetdataextra.getUserId());
			pstAssetDataExtra.setLong(COL_ASSET_DATA_ID, assetdataextra.getAssetDataId());

			pstAssetDataExtra.insert(); 
			assetdataextra.setOID(pstAssetDataExtra.getlong(COL_ASSET_DATA_EXTRA_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetDataExtra(0),CONException.UNKNOWN); 
		}
		return assetdataextra.getOID();
	}

	public static long updateExc(AssetDataExtra assetdataextra) throws CONException{ 
		try{ 
			if(assetdataextra.getOID() != 0){ 
				DbAssetDataExtra pstAssetDataExtra = new DbAssetDataExtra(assetdataextra.getOID());

				pstAssetDataExtra.setDate(COL_DATE, assetdataextra.getDate());
				pstAssetDataExtra.setInt(COL_YEAR, assetdataextra.getYear());
				pstAssetDataExtra.setDouble(COL_PENGURANG_PEROLEHAN, assetdataextra.getPengurangPerolehan());
				pstAssetDataExtra.setDouble(COL_PENGURANG_DEPRE, assetdataextra.getPengurangDepre());
				pstAssetDataExtra.setLong(COL_USER_ID, assetdataextra.getUserId());
				pstAssetDataExtra.setLong(COL_ASSET_DATA_ID, assetdataextra.getAssetDataId());

				pstAssetDataExtra.update(); 
				return assetdataextra.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetDataExtra(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbAssetDataExtra pstAssetDataExtra = new DbAssetDataExtra(oid);
			pstAssetDataExtra.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetDataExtra(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_ASSET_DATA_EXTRA; 
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
				AssetDataExtra assetdataextra = new AssetDataExtra();
				resultToObject(rs, assetdataextra);
				lists.add(assetdataextra);
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

	private static void resultToObject(ResultSet rs, AssetDataExtra assetdataextra){
		try{
			assetdataextra.setOID(rs.getLong(DbAssetDataExtra.colNames[DbAssetDataExtra.COL_ASSET_DATA_EXTRA_ID]));
			assetdataextra.setDate(rs.getDate(DbAssetDataExtra.colNames[DbAssetDataExtra.COL_DATE]));
			assetdataextra.setYear(rs.getInt(DbAssetDataExtra.colNames[DbAssetDataExtra.COL_YEAR]));
			assetdataextra.setPengurangPerolehan(rs.getDouble(DbAssetDataExtra.colNames[DbAssetDataExtra.COL_PENGURANG_PEROLEHAN]));
			assetdataextra.setPengurangDepre(rs.getDouble(DbAssetDataExtra.colNames[DbAssetDataExtra.COL_PENGURANG_DEPRE]));
			assetdataextra.setUserId(rs.getLong(DbAssetDataExtra.colNames[DbAssetDataExtra.COL_USER_ID]));
			assetdataextra.setAssetDataId(rs.getLong(DbAssetDataExtra.colNames[DbAssetDataExtra.COL_ASSET_DATA_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long assetDataExtraId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_ASSET_DATA_EXTRA + " WHERE " + 
						DbAssetDataExtra.colNames[DbAssetDataExtra.COL_ASSET_DATA_EXTRA_ID] + " = " + assetDataExtraId;

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
			String sql = "SELECT COUNT("+ DbAssetDataExtra.colNames[DbAssetDataExtra.COL_ASSET_DATA_EXTRA_ID] + ") FROM " + DB_ASSET_DATA_EXTRA;
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
			  	   AssetDataExtra assetdataextra = (AssetDataExtra)list.get(ls);
				   if(oid == assetdataextra.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
