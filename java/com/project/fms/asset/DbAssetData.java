
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

public class DbAssetData extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_ASSET_DATA = "asset_data";

	public static final  int COL_ASSET_DATA_ID = 0;
	public static final  int COL_ITEM_GROUP_ID = 1;
	public static final  int COL_ITEM_CATEGORY_ID = 2;
	public static final  int COL_ITEM_MASTER_ID = 3;
	public static final  int COL_TYPE = 4;
	public static final  int COL_LOCATION_ID = 5;
	public static final  int COL_DEPRESIASI_PERCENT = 6;
	public static final  int COL_QTY = 7;
	public static final  int COL_TGL_PEROLEHAN = 8;
	public static final  int COL_AMOUNT_PEROLEHAN = 9;
	public static final  int COL_BULAN_MULAI_DEPRESIASI = 10;
	public static final  int COL_YEAR_PEROLEHAN = 11;
	public static final  int COL_RESIDU = 12;
	public static final  int COL_YEARLY_DEPRESIASI = 13;
	public static final  int COL_MTH_DEPRESIASI = 14;
	public static final  int COL_COA_AKUM_DEP_ID = 15;
	public static final  int COL_COA_EXPENSE_DEP_ID = 16;
	public static final  int COL_USER_ID = 17;
	public static final  int COL_DATE = 18;
        
        public static final  int COL_TOTAL_DEPRE_SEBELUM = 19;
        public static final  int COL_TGL_DEPRE_TERAKHIR = 20;

	public static final  String[] colNames = {
		"asset_data_id",
                "item_group_id",
                "item_category_id",
                "item_master_id",
                "type",
                "location_id",
                "depresiasi_percent",
                "qty",
                "tgl_perolehan",
                "amount_perolehan",
                "bulan_mulai_depresiasi",
                "year_perolehan",
                "residu",
                "yearly_depresiasi",
                "mth_depresiasi",
                "coa_akum_dep_id",
                "coa_expense_dep_id",
                "user_id",
                "date",
                "total_depre_sebelum",
                "tgl_depre_terakhir"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_INT,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_DATE,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
                TYPE_FLOAT,
                TYPE_DATE
	 }; 

	public DbAssetData(){
	}

	public DbAssetData(int i) throws CONException { 
		super(new DbAssetData()); 
	}

	public DbAssetData(String sOid) throws CONException { 
		super(new DbAssetData(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbAssetData(long lOid) throws CONException { 
		super(new DbAssetData(0)); 
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
		return DB_ASSET_DATA;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbAssetData().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		AssetData assetdata = fetchExc(ent.getOID()); 
		ent = (Entity)assetdata; 
		return assetdata.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((AssetData) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((AssetData) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static AssetData fetchExc(long oid) throws CONException{ 
		try{ 
			AssetData assetdata = new AssetData();
			DbAssetData pstAssetData = new DbAssetData(oid); 
			assetdata.setOID(oid);

			assetdata.setItemGroupId(pstAssetData.getlong(COL_ITEM_GROUP_ID));
			assetdata.setItemCategoryId(pstAssetData.getlong(COL_ITEM_CATEGORY_ID));
			assetdata.setItemMasterId(pstAssetData.getlong(COL_ITEM_MASTER_ID));
			assetdata.setType(pstAssetData.getInt(COL_TYPE));
			assetdata.setLocationId(pstAssetData.getlong(COL_LOCATION_ID));
			assetdata.setDepresiasiPercent(pstAssetData.getdouble(COL_DEPRESIASI_PERCENT));
			assetdata.setQty(pstAssetData.getdouble(COL_QTY));
			assetdata.setTglPerolehan(pstAssetData.getDate(COL_TGL_PEROLEHAN));
			assetdata.setAmountPerolehan(pstAssetData.getdouble(COL_AMOUNT_PEROLEHAN));
			assetdata.setBulanMulaiDepresiasi(pstAssetData.getInt(COL_BULAN_MULAI_DEPRESIASI));
			assetdata.setYearPerolehan(pstAssetData.getInt(COL_YEAR_PEROLEHAN));
			assetdata.setResidu(pstAssetData.getdouble(COL_RESIDU));
			assetdata.setYearlyDepresiasi(pstAssetData.getdouble(COL_YEARLY_DEPRESIASI));
			assetdata.setMthDepresiasi(pstAssetData.getdouble(COL_MTH_DEPRESIASI));
			assetdata.setCoaAkumDepId(pstAssetData.getlong(COL_COA_AKUM_DEP_ID));
			assetdata.setCoaExpenseDepId(pstAssetData.getlong(COL_COA_EXPENSE_DEP_ID));
			assetdata.setUserId(pstAssetData.getlong(COL_USER_ID));
			assetdata.setDate(pstAssetData.getDate(COL_DATE));
                        
                        assetdata.setTotalDepreSebelum(pstAssetData.getdouble(COL_TOTAL_DEPRE_SEBELUM));
                        assetdata.setTglDepreTerakhir(pstAssetData.getDate(COL_TGL_DEPRE_TERAKHIR));

			return assetdata; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetData(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(AssetData assetdata) throws CONException{ 
		try{ 
			DbAssetData pstAssetData = new DbAssetData(0);

			pstAssetData.setLong(COL_ITEM_GROUP_ID, assetdata.getItemGroupId());
			pstAssetData.setLong(COL_ITEM_CATEGORY_ID, assetdata.getItemCategoryId());
			pstAssetData.setLong(COL_ITEM_MASTER_ID, assetdata.getItemMasterId());
			pstAssetData.setInt(COL_TYPE, assetdata.getType());
			pstAssetData.setLong(COL_LOCATION_ID, assetdata.getLocationId());
			pstAssetData.setDouble(COL_DEPRESIASI_PERCENT, assetdata.getDepresiasiPercent());
			pstAssetData.setDouble(COL_QTY, assetdata.getQty());
			pstAssetData.setDate(COL_TGL_PEROLEHAN, assetdata.getTglPerolehan());
			pstAssetData.setDouble(COL_AMOUNT_PEROLEHAN, assetdata.getAmountPerolehan());
			pstAssetData.setInt(COL_BULAN_MULAI_DEPRESIASI, assetdata.getBulanMulaiDepresiasi());
			pstAssetData.setInt(COL_YEAR_PEROLEHAN, assetdata.getYearPerolehan());
			pstAssetData.setDouble(COL_RESIDU, assetdata.getResidu());
			pstAssetData.setDouble(COL_YEARLY_DEPRESIASI, assetdata.getYearlyDepresiasi());
			pstAssetData.setDouble(COL_MTH_DEPRESIASI, assetdata.getMthDepresiasi());
			pstAssetData.setLong(COL_COA_AKUM_DEP_ID, assetdata.getCoaAkumDepId());
			pstAssetData.setLong(COL_COA_EXPENSE_DEP_ID, assetdata.getCoaExpenseDepId());
			pstAssetData.setLong(COL_USER_ID, assetdata.getUserId());
			pstAssetData.setDate(COL_DATE, assetdata.getDate());
                        
                        pstAssetData.setDouble(COL_TOTAL_DEPRE_SEBELUM, assetdata.getTotalDepreSebelum());
                        pstAssetData.setDate(COL_TGL_DEPRE_TERAKHIR, assetdata.getTglDepreTerakhir());

			pstAssetData.insert(); 
			assetdata.setOID(pstAssetData.getlong(COL_ASSET_DATA_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetData(0),CONException.UNKNOWN); 
		}
		return assetdata.getOID();
	}

	public static long updateExc(AssetData assetdata) throws CONException{ 
		try{ 
			if(assetdata.getOID() != 0){ 
				DbAssetData pstAssetData = new DbAssetData(assetdata.getOID());

				pstAssetData.setLong(COL_ITEM_GROUP_ID, assetdata.getItemGroupId());
				pstAssetData.setLong(COL_ITEM_CATEGORY_ID, assetdata.getItemCategoryId());
				pstAssetData.setLong(COL_ITEM_MASTER_ID, assetdata.getItemMasterId());
				pstAssetData.setInt(COL_TYPE, assetdata.getType());
				pstAssetData.setLong(COL_LOCATION_ID, assetdata.getLocationId());
				pstAssetData.setDouble(COL_DEPRESIASI_PERCENT, assetdata.getDepresiasiPercent());
				pstAssetData.setDouble(COL_QTY, assetdata.getQty());
				pstAssetData.setDate(COL_TGL_PEROLEHAN, assetdata.getTglPerolehan());
				pstAssetData.setDouble(COL_AMOUNT_PEROLEHAN, assetdata.getAmountPerolehan());
				pstAssetData.setInt(COL_BULAN_MULAI_DEPRESIASI, assetdata.getBulanMulaiDepresiasi());
				pstAssetData.setInt(COL_YEAR_PEROLEHAN, assetdata.getYearPerolehan());
				pstAssetData.setDouble(COL_RESIDU, assetdata.getResidu());
				pstAssetData.setDouble(COL_YEARLY_DEPRESIASI, assetdata.getYearlyDepresiasi());
				pstAssetData.setDouble(COL_MTH_DEPRESIASI, assetdata.getMthDepresiasi());
				pstAssetData.setLong(COL_COA_AKUM_DEP_ID, assetdata.getCoaAkumDepId());
				pstAssetData.setLong(COL_COA_EXPENSE_DEP_ID, assetdata.getCoaExpenseDepId());
				pstAssetData.setLong(COL_USER_ID, assetdata.getUserId());
				pstAssetData.setDate(COL_DATE, assetdata.getDate());
                                
                                pstAssetData.setDouble(COL_TOTAL_DEPRE_SEBELUM, assetdata.getTotalDepreSebelum());
                                pstAssetData.setDate(COL_TGL_DEPRE_TERAKHIR, assetdata.getTglDepreTerakhir());

				pstAssetData.update(); 
				return assetdata.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetData(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbAssetData pstAssetData = new DbAssetData(oid);
			pstAssetData.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetData(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_ASSET_DATA; 
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
				AssetData assetdata = new AssetData();
				resultToObject(rs, assetdata);
				lists.add(assetdata);
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

	private static void resultToObject(ResultSet rs, AssetData assetdata){
		try{
			assetdata.setOID(rs.getLong(DbAssetData.colNames[DbAssetData.COL_ASSET_DATA_ID]));
			assetdata.setItemGroupId(rs.getLong(DbAssetData.colNames[DbAssetData.COL_ITEM_GROUP_ID]));
			assetdata.setItemCategoryId(rs.getLong(DbAssetData.colNames[DbAssetData.COL_ITEM_CATEGORY_ID]));
			assetdata.setItemMasterId(rs.getLong(DbAssetData.colNames[DbAssetData.COL_ITEM_MASTER_ID]));
			assetdata.setType(rs.getInt(DbAssetData.colNames[DbAssetData.COL_TYPE]));
			assetdata.setLocationId(rs.getLong(DbAssetData.colNames[DbAssetData.COL_LOCATION_ID]));
			assetdata.setDepresiasiPercent(rs.getDouble(DbAssetData.colNames[DbAssetData.COL_DEPRESIASI_PERCENT]));
			assetdata.setQty(rs.getDouble(DbAssetData.colNames[DbAssetData.COL_QTY]));
			assetdata.setTglPerolehan(rs.getDate(DbAssetData.colNames[DbAssetData.COL_TGL_PEROLEHAN]));
			assetdata.setAmountPerolehan(rs.getDouble(DbAssetData.colNames[DbAssetData.COL_AMOUNT_PEROLEHAN]));
			assetdata.setBulanMulaiDepresiasi(rs.getInt(DbAssetData.colNames[DbAssetData.COL_BULAN_MULAI_DEPRESIASI]));
			assetdata.setYearPerolehan(rs.getInt(DbAssetData.colNames[DbAssetData.COL_YEAR_PEROLEHAN]));
			assetdata.setResidu(rs.getDouble(DbAssetData.colNames[DbAssetData.COL_RESIDU]));
			assetdata.setYearlyDepresiasi(rs.getDouble(DbAssetData.colNames[DbAssetData.COL_YEARLY_DEPRESIASI]));
			assetdata.setMthDepresiasi(rs.getDouble(DbAssetData.colNames[DbAssetData.COL_MTH_DEPRESIASI]));
			assetdata.setCoaAkumDepId(rs.getLong(DbAssetData.colNames[DbAssetData.COL_COA_AKUM_DEP_ID]));
			assetdata.setCoaExpenseDepId(rs.getLong(DbAssetData.colNames[DbAssetData.COL_COA_EXPENSE_DEP_ID]));
			assetdata.setUserId(rs.getLong(DbAssetData.colNames[DbAssetData.COL_USER_ID]));
			assetdata.setDate(rs.getDate(DbAssetData.colNames[DbAssetData.COL_DATE]));
                        
                        assetdata.setTotalDepreSebelum(rs.getDouble(DbAssetData.colNames[DbAssetData.COL_TOTAL_DEPRE_SEBELUM]));
                        assetdata.setTglDepreTerakhir(rs.getDate(DbAssetData.colNames[DbAssetData.COL_TGL_DEPRE_TERAKHIR]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long assetDataId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_ASSET_DATA + " WHERE " + 
						DbAssetData.colNames[DbAssetData.COL_ASSET_DATA_ID] + " = " + assetDataId;

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
			String sql = "SELECT COUNT("+ DbAssetData.colNames[DbAssetData.COL_ASSET_DATA_ID] + ") FROM " + DB_ASSET_DATA;
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
			  	   AssetData assetdata = (AssetData)list.get(ls);
				   if(oid == assetdata.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
                
}
