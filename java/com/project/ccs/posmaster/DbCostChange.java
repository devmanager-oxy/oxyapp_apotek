
package com.project.ccs.posmaster; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*; 

public class DbCostChange extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_COST_CHANGE = "pos_cost_change";

	public static final  int COL_COST_CHANGE_ID = 0;
        public static final  int COL_DATE = 1;
	public static final  int COL_REFERENCE = 2;
        public static final  int COL_ACTIVE_DATE = 3;
        public static final  int COL_STATUS = 4;
        public static final  int COL_VENDOR_ID = 5; 
        public static final  int COL_USER_ID = 6;
        public static final  int COL_APPROVAL_ID = 7;
        public static final  int COL_ITEM_MASTER_ID = 8;
        public static final  int COL_CODE = 9;
        public static final  int COL_BARCODE = 10;
        public static final  int COL_CURRENT_COST = 11;
        public static final  int COL_NEW_COST =12;

	public static final  String[] colNames = {
		"cost_change_id",
                "date",
                "reference",
                "active_date",
                "status",
                "vendor_id",
                "user_id",
                "approval_id",
                "item_master_id",
                "code",
                "barcode",
                "current_cost",
                "new_cost"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
                TYPE_STRING,
                TYPE_DATE,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_FLOAT,
                TYPE_FLOAT,
	 }; 

	public DbCostChange(){
	}

	public DbCostChange(int i) throws CONException { 
		super(new DbCostChange()); 
	}

	public DbCostChange(String sOid) throws CONException { 
		super(new DbCostChange(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCostChange(long lOid) throws CONException { 
		super(new DbCostChange(0)); 
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
		return DB_COST_CHANGE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCostChange().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		CostChange cost = fetchExc(ent.getOID()); 
		ent = (Entity)cost; 
		return cost.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Uom) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Uom) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static CostChange fetchExc(long oid) throws CONException{ 
		try{ 
			CostChange cost = new CostChange();
			DbCostChange dbCostChange = new DbCostChange(oid); 
			cost.setOID(oid);
                        cost.setActiveDate(dbCostChange.getDate(COL_ACTIVE_DATE));
                        cost.setApprovalId(dbCostChange.getlong(COL_APPROVAL_ID));
                        cost.setBarcode(dbCostChange.getString(COL_BARCODE));
                        cost.setCode(dbCostChange.getString(COL_CODE));
                        cost.setCurrentCost(dbCostChange.getdouble(COL_CURRENT_COST));
                        cost.setDate(dbCostChange.getDate(COL_DATE));
                        cost.setItemMasterId(dbCostChange.getlong(COL_ITEM_MASTER_ID));
                        cost.setNewCost(dbCostChange.getdouble(COL_NEW_COST));
                        cost.setReference(dbCostChange.getString(COL_REFERENCE));
                        cost.setStatus(dbCostChange.getString(COL_STATUS));
                        cost.setUserId(dbCostChange.getlong(COL_USER_ID));
                        cost.setVendorId(dbCostChange.getlong(COL_VENDOR_ID));
			return cost; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCostChange(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(CostChange cost) throws CONException{ 
		try{ 
			DbCostChange dbCostChange = new DbCostChange(0);

			dbCostChange.setDate(COL_ACTIVE_DATE , cost.getActiveDate());
                        dbCostChange.setLong(COL_APPROVAL_ID , cost.getApprovalId());
                        dbCostChange.setString(COL_BARCODE , cost.getBarcode());
                        dbCostChange.setString(COL_CODE , cost.getCode());
                        dbCostChange.setDouble(COL_CURRENT_COST , cost.getCurrentCost());
                        dbCostChange.setDate(COL_DATE , cost.getDate());
                        dbCostChange.setLong(COL_ITEM_MASTER_ID , cost.getItemMasterId());
                        dbCostChange.setDouble(COL_NEW_COST , cost.getNewCost());
                        dbCostChange.setString(COL_REFERENCE , cost.getReference());
                        dbCostChange.setString(COL_STATUS , cost.getStatus());
                        dbCostChange.setLong(COL_USER_ID , cost.getUserId());
                        dbCostChange.setLong(COL_VENDOR_ID , cost.getVendorId());
                        
			dbCostChange.insert(); 
			cost.setOID(dbCostChange.getlong(COL_COST_CHANGE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCostChange(0),CONException.UNKNOWN); 
		}
		return cost.getOID();
	}

	public static long updateExc(CostChange cost) throws CONException{ 
		try{ 
			if(cost.getOID() != 0){ 
				DbCostChange dbCostChange = new DbCostChange(cost.getOID());
                                
				dbCostChange.setDate(COL_ACTIVE_DATE , cost.getActiveDate());
                                dbCostChange.setLong(COL_APPROVAL_ID , cost.getApprovalId());
                                dbCostChange.setString(COL_BARCODE , cost.getBarcode());
                                dbCostChange.setString(COL_CODE , cost.getCode());
                                dbCostChange.setDouble(COL_CURRENT_COST , cost.getCurrentCost());
                                dbCostChange.setDate(COL_DATE , cost.getDate());
                                dbCostChange.setLong(COL_ITEM_MASTER_ID , cost.getItemMasterId());
                                dbCostChange.setDouble(COL_NEW_COST , cost.getNewCost());
                                dbCostChange.setString(COL_REFERENCE , cost.getReference());
                                dbCostChange.setString(COL_STATUS , cost.getStatus());
                                dbCostChange.setLong(COL_USER_ID , cost.getUserId());
                                dbCostChange.setLong(COL_VENDOR_ID , cost.getVendorId());

				dbCostChange.update(); 
				return cost.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCostChange(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCostChange pstUom = new DbCostChange(oid);
			pstUom.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCostChange(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_COST_CHANGE; 
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
				CostChange csot = new CostChange();
				resultToObject(rs, csot);
				lists.add(csot);
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

	public static void resultToObject(ResultSet rs, CostChange cost){
		try{
			cost.setOID(rs.getLong(DbCostChange.colNames[DbCostChange.COL_COST_CHANGE_ID]));
                        
			cost.setActiveDate(rs.getDate(DbCostChange.colNames[DbCostChange.COL_ACTIVE_DATE]));
                        cost.setApprovalId(rs.getLong(DbCostChange.colNames[DbCostChange.COL_APPROVAL_ID]));
                        cost.setBarcode(rs.getString(DbCostChange.colNames[DbCostChange.COL_BARCODE]));
                        cost.setCode(rs.getString(DbCostChange.colNames[DbCostChange.COL_CODE]));
                        cost.setCurrentCost(rs.getDouble(DbCostChange.colNames[DbCostChange.COL_CURRENT_COST]));
                        cost.setDate(rs.getDate(DbCostChange.colNames[DbCostChange.COL_DATE]));
                        cost.setItemMasterId(rs.getLong(DbCostChange.colNames[DbCostChange.COL_ITEM_MASTER_ID]));
                        cost.setNewCost(rs.getDouble(DbCostChange.colNames[DbCostChange.COL_NEW_COST]));
                        cost.setReference(rs.getString(DbCostChange.colNames[DbCostChange.COL_REFERENCE]));
                        cost.setStatus(rs.getString(DbCostChange.colNames[DbCostChange.COL_STATUS]));
                        cost.setUserId(rs.getLong(DbCostChange.colNames[DbCostChange.COL_USER_ID]));
                        cost.setVendorId(rs.getLong(DbCostChange.colNames[DbCostChange.COL_VENDOR_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long uomId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_COST_CHANGE + " WHERE " + 
						DbCostChange.colNames[DbCostChange.COL_COST_CHANGE_ID] + " = " + uomId;

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
			String sql = "SELECT COUNT("+ DbCostChange.colNames[DbCostChange.COL_COST_CHANGE_ID] + ") FROM " + DB_COST_CHANGE;
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
			  	   Uom uom = (Uom)list.get(ls);
				   if(oid == uom.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
