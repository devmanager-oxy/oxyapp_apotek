
package com.project.coorp.pinjaman; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.*;
import com.project.util.*;
import com.project.system.*;
import com.project.coorp.member.*;
import com.project.fms.transaction.*;
import com.project.*;

public class DbTabunganService extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_SP_TABUNGAN_SERVICE = "sp_tabungan_service";

	public static final  int COL_TABUNGAN_SERVICE_ID = 0;
	public static final  int COL_PROCEED_DATE = 1;

	public static final  String[] colNames = {
		"tabungan_service_id",
		"proceed_date"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE
	 }; 

	public DbTabunganService(){
	}

	public DbTabunganService(int i) throws CONException { 
		super(new DbTabunganService()); 
	}

	public DbTabunganService(String sOid) throws CONException { 
		super(new DbTabunganService(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbTabunganService(long lOid) throws CONException { 
		super(new DbTabunganService(0)); 
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
		return DB_SP_TABUNGAN_SERVICE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbTabunganService().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		TabunganService tabunganservice = fetchExc(ent.getOID()); 
		ent = (Entity)tabunganservice; 
		return tabunganservice.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((TabunganService) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((TabunganService) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static TabunganService fetchExc(long oid) throws CONException{ 
		try{ 
			TabunganService tabunganservice = new TabunganService();
			DbTabunganService pstTabunganService = new DbTabunganService(oid); 
			tabunganservice.setOID(oid);

			tabunganservice.setProceedDate(pstTabunganService.getDate(COL_PROCEED_DATE));

			return tabunganservice; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganService(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(TabunganService tabunganservice) throws CONException{ 
		try{ 
			DbTabunganService pstTabunganService = new DbTabunganService(0);

			pstTabunganService.setDate(COL_PROCEED_DATE, tabunganservice.getProceedDate());

			pstTabunganService.insert(); 
			tabunganservice.setOID(pstTabunganService.getlong(COL_TABUNGAN_SERVICE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganService(0),CONException.UNKNOWN); 
		}
		return tabunganservice.getOID();
	}

	public static long updateExc(TabunganService tabunganservice) throws CONException{ 
		try{ 
			if(tabunganservice.getOID() != 0){ 
				DbTabunganService pstTabunganService = new DbTabunganService(tabunganservice.getOID());

				pstTabunganService.setDate(COL_PROCEED_DATE, tabunganservice.getProceedDate());

				pstTabunganService.update(); 
				return tabunganservice.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganService(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbTabunganService pstTabunganService = new DbTabunganService(oid);
			pstTabunganService.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganService(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_SP_TABUNGAN_SERVICE; 
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
				TabunganService tabunganservice = new TabunganService();
				resultToObject(rs, tabunganservice);
				lists.add(tabunganservice);
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

	private static void resultToObject(ResultSet rs, TabunganService tabunganservice){
		try{
			tabunganservice.setOID(rs.getLong(DbTabunganService.colNames[DbTabunganService.COL_TABUNGAN_SERVICE_ID]));
			tabunganservice.setProceedDate(rs.getDate(DbTabunganService.colNames[DbTabunganService.COL_PROCEED_DATE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long tabunganServiceId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SP_TABUNGAN_SERVICE + " WHERE " + 
						DbTabunganService.colNames[DbTabunganService.COL_TABUNGAN_SERVICE_ID] + " = " + tabunganServiceId;

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
			String sql = "SELECT COUNT("+ DbTabunganService.colNames[DbTabunganService.COL_TABUNGAN_SERVICE_ID] + ") FROM " + DB_SP_TABUNGAN_SERVICE;
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
			  	   TabunganService tabunganservice = (TabunganService)list.get(ls);
				   if(oid == tabunganservice.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
