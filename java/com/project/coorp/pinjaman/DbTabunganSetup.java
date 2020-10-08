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

public class DbTabunganSetup extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_SP_TABUNGAN_SETUP = "sp_tabungan_setup";

	public static final  int COL_TABUNGAN_SETUP_ID = 0;
	public static final  int COL_BUNGA_PERCENT = 1;
	public static final  int COL_BUNGA_TYPE = 2;
	public static final  int COL_BUNGA_ACTIVATE = 3;
	public static final  int COL_ADMIN_AMOUNT = 4;
	public static final  int COL_ADMIN_TYPE = 5;
	public static final  int COL_ADMIN_ACTIVATE = 6;
	public static final  int COL_SERVICE_START_HOUR = 7;
	public static final  int COL_SERVICE_START_MINUTE = 8;
	public static final  int COL_PAJAK_PERCENT = 9;
	public static final  int COL_PAJAK_TYPE = 10;
	public static final  int COL_PAJAK_ACTIVATE = 11;
	public static final  int COL_HUTANG_COA_ID = 12;
	public static final  int COL_PAJAK_COA_ID = 13;
	public static final  int COL_ADMIN_COA_ID = 14;
	public static final  int COL_BUNGA_COA_ID = 15;

	public static final  String[] colNames = {
            "tabungan_setup_id",
            "bunga_percent",
            "bunga_type",
            "bunga_activate",
            "admin_amount",
            "admin_type",
            "admin_activate",
            "service_start_hour",
            "service_start_minute",
            "pajak_percent",
            "pajak_type",
            "pajak_activate",
            "hutang_coa_id",
            "pajak_coa_id",
            "admin_coa_id",
            "bunga_coa_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_INT,
		TYPE_INT,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG
	 }; 
         
         public static int DURATION_TYPE_DAILY = 0;
         public static int DURATION_TYPE_MONTHLY = 1;
         public static int DURATION_TYPE_YEARLY = 2;
         
         public static String[] strDuration = {"Daily", "Monthly", "Yearly"};

	public DbTabunganSetup(){
	}

	public DbTabunganSetup(int i) throws CONException { 
		super(new DbTabunganSetup()); 
	}

	public DbTabunganSetup(String sOid) throws CONException { 
		super(new DbTabunganSetup(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbTabunganSetup(long lOid) throws CONException { 
		super(new DbTabunganSetup(0)); 
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
		return DB_SP_TABUNGAN_SETUP;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbTabunganSetup().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		TabunganSetup tabungansetup = fetchExc(ent.getOID()); 
		ent = (Entity)tabungansetup; 
		return tabungansetup.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((TabunganSetup) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((TabunganSetup) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static TabunganSetup fetchExc(long oid) throws CONException{ 
		try{ 
			TabunganSetup tabungansetup = new TabunganSetup();
			DbTabunganSetup pstTabunganSetup = new DbTabunganSetup(oid); 
			tabungansetup.setOID(oid);

			tabungansetup.setBungaPercent(pstTabunganSetup.getdouble(COL_BUNGA_PERCENT));
			tabungansetup.setBungaType(pstTabunganSetup.getInt(COL_BUNGA_TYPE));
			tabungansetup.setBungaActivate(pstTabunganSetup.getInt(COL_BUNGA_ACTIVATE));
			tabungansetup.setAdminAmount(pstTabunganSetup.getdouble(COL_ADMIN_AMOUNT));
			tabungansetup.setAdminType(pstTabunganSetup.getInt(COL_ADMIN_TYPE));
			tabungansetup.setAdminActivate(pstTabunganSetup.getInt(COL_ADMIN_ACTIVATE));
			tabungansetup.setServiceStartHour(pstTabunganSetup.getInt(COL_SERVICE_START_HOUR));
			tabungansetup.setServiceStartMinute(pstTabunganSetup.getInt(COL_SERVICE_START_MINUTE));
			tabungansetup.setPajakPercent(pstTabunganSetup.getdouble(COL_PAJAK_PERCENT));
			tabungansetup.setPajakType(pstTabunganSetup.getInt(COL_PAJAK_TYPE));
			tabungansetup.setPajakActivate(pstTabunganSetup.getInt(COL_PAJAK_ACTIVATE));
			tabungansetup.setHutangCoaId(pstTabunganSetup.getlong(COL_HUTANG_COA_ID));
			tabungansetup.setPajakCoaId(pstTabunganSetup.getlong(COL_PAJAK_COA_ID));
			tabungansetup.setAdminCoaId(pstTabunganSetup.getlong(COL_ADMIN_COA_ID));
			tabungansetup.setBungaCoaId(pstTabunganSetup.getlong(COL_BUNGA_COA_ID));

			return tabungansetup; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganSetup(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(TabunganSetup tabungansetup) throws CONException{ 
		try{ 
			DbTabunganSetup pstTabunganSetup = new DbTabunganSetup(0);

			pstTabunganSetup.setDouble(COL_BUNGA_PERCENT, tabungansetup.getBungaPercent());
			pstTabunganSetup.setInt(COL_BUNGA_TYPE, tabungansetup.getBungaType());
			pstTabunganSetup.setInt(COL_BUNGA_ACTIVATE, tabungansetup.getBungaActivate());
			pstTabunganSetup.setDouble(COL_ADMIN_AMOUNT, tabungansetup.getAdminAmount());
			pstTabunganSetup.setInt(COL_ADMIN_TYPE, tabungansetup.getAdminType());
			pstTabunganSetup.setInt(COL_ADMIN_ACTIVATE, tabungansetup.getAdminActivate());
			pstTabunganSetup.setInt(COL_SERVICE_START_HOUR, tabungansetup.getServiceStartHour());
			pstTabunganSetup.setInt(COL_SERVICE_START_MINUTE, tabungansetup.getServiceStartMinute());
			pstTabunganSetup.setDouble(COL_PAJAK_PERCENT, tabungansetup.getPajakPercent());
			pstTabunganSetup.setInt(COL_PAJAK_TYPE, tabungansetup.getPajakType());
			pstTabunganSetup.setInt(COL_PAJAK_ACTIVATE, tabungansetup.getPajakActivate());
			pstTabunganSetup.setLong(COL_HUTANG_COA_ID, tabungansetup.getHutangCoaId());
			pstTabunganSetup.setLong(COL_PAJAK_COA_ID, tabungansetup.getPajakCoaId());
			pstTabunganSetup.setLong(COL_ADMIN_COA_ID, tabungansetup.getAdminCoaId());
			pstTabunganSetup.setLong(COL_BUNGA_COA_ID, tabungansetup.getBungaCoaId());

			pstTabunganSetup.insert(); 
			tabungansetup.setOID(pstTabunganSetup.getlong(COL_TABUNGAN_SETUP_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganSetup(0),CONException.UNKNOWN); 
		}
		return tabungansetup.getOID();
	}

	public static long updateExc(TabunganSetup tabungansetup) throws CONException{ 
		try{ 
			if(tabungansetup.getOID() != 0){ 
				DbTabunganSetup pstTabunganSetup = new DbTabunganSetup(tabungansetup.getOID());

				pstTabunganSetup.setDouble(COL_BUNGA_PERCENT, tabungansetup.getBungaPercent());
				pstTabunganSetup.setInt(COL_BUNGA_TYPE, tabungansetup.getBungaType());
				pstTabunganSetup.setInt(COL_BUNGA_ACTIVATE, tabungansetup.getBungaActivate());
				pstTabunganSetup.setDouble(COL_ADMIN_AMOUNT, tabungansetup.getAdminAmount());
				pstTabunganSetup.setInt(COL_ADMIN_TYPE, tabungansetup.getAdminType());
				pstTabunganSetup.setInt(COL_ADMIN_ACTIVATE, tabungansetup.getAdminActivate());
				pstTabunganSetup.setInt(COL_SERVICE_START_HOUR, tabungansetup.getServiceStartHour());
				pstTabunganSetup.setInt(COL_SERVICE_START_MINUTE, tabungansetup.getServiceStartMinute());
				pstTabunganSetup.setDouble(COL_PAJAK_PERCENT, tabungansetup.getPajakPercent());
				pstTabunganSetup.setInt(COL_PAJAK_TYPE, tabungansetup.getPajakType());
				pstTabunganSetup.setInt(COL_PAJAK_ACTIVATE, tabungansetup.getPajakActivate());
				pstTabunganSetup.setLong(COL_HUTANG_COA_ID, tabungansetup.getHutangCoaId());
				pstTabunganSetup.setLong(COL_PAJAK_COA_ID, tabungansetup.getPajakCoaId());
				pstTabunganSetup.setLong(COL_ADMIN_COA_ID, tabungansetup.getAdminCoaId());
				pstTabunganSetup.setLong(COL_BUNGA_COA_ID, tabungansetup.getBungaCoaId());

				pstTabunganSetup.update(); 
				return tabungansetup.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganSetup(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbTabunganSetup pstTabunganSetup = new DbTabunganSetup(oid);
			pstTabunganSetup.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganSetup(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_SP_TABUNGAN_SETUP; 
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
				TabunganSetup tabungansetup = new TabunganSetup();
				resultToObject(rs, tabungansetup);
				lists.add(tabungansetup);
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

	private static void resultToObject(ResultSet rs, TabunganSetup tabungansetup){
		try{
			tabungansetup.setOID(rs.getLong(DbTabunganSetup.colNames[DbTabunganSetup.COL_TABUNGAN_SETUP_ID]));
			tabungansetup.setBungaPercent(rs.getDouble(DbTabunganSetup.colNames[DbTabunganSetup.COL_BUNGA_PERCENT]));
			tabungansetup.setBungaType(rs.getInt(DbTabunganSetup.colNames[DbTabunganSetup.COL_BUNGA_TYPE]));
			tabungansetup.setBungaActivate(rs.getInt(DbTabunganSetup.colNames[DbTabunganSetup.COL_BUNGA_ACTIVATE]));
			tabungansetup.setAdminAmount(rs.getDouble(DbTabunganSetup.colNames[DbTabunganSetup.COL_ADMIN_AMOUNT]));
			tabungansetup.setAdminType(rs.getInt(DbTabunganSetup.colNames[DbTabunganSetup.COL_ADMIN_TYPE]));
			tabungansetup.setAdminActivate(rs.getInt(DbTabunganSetup.colNames[DbTabunganSetup.COL_ADMIN_ACTIVATE]));
			tabungansetup.setServiceStartHour(rs.getInt(DbTabunganSetup.colNames[DbTabunganSetup.COL_SERVICE_START_HOUR]));
			tabungansetup.setServiceStartMinute(rs.getInt(DbTabunganSetup.colNames[DbTabunganSetup.COL_SERVICE_START_MINUTE]));
			tabungansetup.setPajakPercent(rs.getDouble(DbTabunganSetup.colNames[DbTabunganSetup.COL_PAJAK_PERCENT]));
			tabungansetup.setPajakType(rs.getInt(DbTabunganSetup.colNames[DbTabunganSetup.COL_PAJAK_TYPE]));
			tabungansetup.setPajakActivate(rs.getInt(DbTabunganSetup.colNames[DbTabunganSetup.COL_PAJAK_ACTIVATE]));
			tabungansetup.setHutangCoaId(rs.getLong(DbTabunganSetup.colNames[DbTabunganSetup.COL_HUTANG_COA_ID]));
			tabungansetup.setPajakCoaId(rs.getLong(DbTabunganSetup.colNames[DbTabunganSetup.COL_PAJAK_COA_ID]));
			tabungansetup.setAdminCoaId(rs.getLong(DbTabunganSetup.colNames[DbTabunganSetup.COL_ADMIN_COA_ID]));
			tabungansetup.setBungaCoaId(rs.getLong(DbTabunganSetup.colNames[DbTabunganSetup.COL_BUNGA_COA_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long tabunganSetupId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SP_TABUNGAN_SETUP + " WHERE " + 
						DbTabunganSetup.colNames[DbTabunganSetup.COL_TABUNGAN_SETUP_ID] + " = " + tabunganSetupId;

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
			String sql = "SELECT COUNT("+ DbTabunganSetup.colNames[DbTabunganSetup.COL_TABUNGAN_SETUP_ID] + ") FROM " + DB_SP_TABUNGAN_SETUP;
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
			  	   TabunganSetup tabungansetup = (TabunganSetup)list.get(ls);
				   if(oid == tabungansetup.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static TabunganSetup getTabunganSetup(){
            Vector v = list(0,1, "", "");
            if(v!=null && v.size()>0){
                return (TabunganSetup)v.get(0);
            }
            return new TabunganSetup();
        }
        
}
