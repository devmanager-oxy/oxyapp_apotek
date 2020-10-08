
package com.project.fms.reportform; 


import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.*;

public class DbRptFormatDetailCoa extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_RPT_FORMAT_DETAIL_COA = "rpt_format_detail_coa";

	public static final  int COL_RPT_FORMAT_DETAIL_COA_ID = 0;
	public static final  int COL_RPT_FORMAT_DETAIL_ID = 1;
	public static final  int COL_COA_ID = 2;
	
	public static final  int COL_IS_MINUS = 3;
	public static final  int COL_DEP_LEVEL1_ID = 4;
	public static final  int COL_DEP_LEVEL2_ID = 5;
	public static final  int COL_DEP_LEVEL3_ID = 6;
	public static final  int COL_DEP_LEVEL4_ID = 7;
	public static final  int COL_DEP_LEVEL5_ID = 8;
	public static final  int COL_DEP_ID = 9;

	public static final  String[] colNames = {
		"rpt_format_detail_coa_id",
		"rpt_format_detail_id",
		"coa_id",
		
		"is_minus",
		"dep_level1_id",
		"dep_level2_id",
		"dep_level3_id",
		"dep_level4_id",
		"dep_level5_id",
		"dep_id"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
	 }; 

	public DbRptFormatDetailCoa(){
	}

	public DbRptFormatDetailCoa(int i) throws CONException { 
		super(new DbRptFormatDetailCoa()); 
	}

	public DbRptFormatDetailCoa(String sOid) throws CONException { 
		super(new DbRptFormatDetailCoa(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbRptFormatDetailCoa(long lOid) throws CONException { 
		super(new DbRptFormatDetailCoa(0)); 
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
		return DB_RPT_FORMAT_DETAIL_COA;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbRptFormatDetailCoa().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		RptFormatDetailCoa rptformatdetailcoa = fetchExc(ent.getOID()); 
		ent = (Entity)rptformatdetailcoa; 
		return rptformatdetailcoa.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((RptFormatDetailCoa) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((RptFormatDetailCoa) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static RptFormatDetailCoa fetchExc(long oid) throws CONException{ 
		try{ 
			RptFormatDetailCoa rptformatdetailcoa = new RptFormatDetailCoa();
			DbRptFormatDetailCoa pstRptFormatDetailCoa = new DbRptFormatDetailCoa(oid); 
			rptformatdetailcoa.setOID(oid);

			rptformatdetailcoa.setRptFormatDetailId(pstRptFormatDetailCoa.getlong(COL_RPT_FORMAT_DETAIL_ID));
			rptformatdetailcoa.setCoaId(pstRptFormatDetailCoa.getlong(COL_COA_ID));
			
			rptformatdetailcoa.setIsMinus(pstRptFormatDetailCoa.getInt(COL_IS_MINUS));
			rptformatdetailcoa.setDepLevel1Id(pstRptFormatDetailCoa.getlong(COL_DEP_LEVEL1_ID));
			rptformatdetailcoa.setDepLevel2Id(pstRptFormatDetailCoa.getlong(COL_DEP_LEVEL2_ID));
			rptformatdetailcoa.setDepLevel3Id(pstRptFormatDetailCoa.getlong(COL_DEP_LEVEL3_ID));
			rptformatdetailcoa.setDepLevel4Id(pstRptFormatDetailCoa.getlong(COL_DEP_LEVEL4_ID));
			rptformatdetailcoa.setDepLevel5Id(pstRptFormatDetailCoa.getlong(COL_DEP_LEVEL5_ID));
			rptformatdetailcoa.setDepId(pstRptFormatDetailCoa.getlong(COL_DEP_ID));

			return rptformatdetailcoa; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFormatDetailCoa(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(RptFormatDetailCoa rptformatdetailcoa) throws CONException{ 
		try{ 
			DbRptFormatDetailCoa pstRptFormatDetailCoa = new DbRptFormatDetailCoa(0);

			pstRptFormatDetailCoa.setLong(COL_RPT_FORMAT_DETAIL_ID, rptformatdetailcoa.getRptFormatDetailId());
			pstRptFormatDetailCoa.setLong(COL_COA_ID, rptformatdetailcoa.getCoaId());
			
			pstRptFormatDetailCoa.setInt(COL_IS_MINUS, rptformatdetailcoa.getIsMinus());
			pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL1_ID, rptformatdetailcoa.getDepLevel1Id());
			pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL2_ID, rptformatdetailcoa.getDepLevel2Id());
			pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL3_ID, rptformatdetailcoa.getDepLevel3Id());
			pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL4_ID, rptformatdetailcoa.getDepLevel4Id());
			pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL5_ID, rptformatdetailcoa.getDepLevel5Id());
			pstRptFormatDetailCoa.setLong(COL_DEP_ID, rptformatdetailcoa.getDepId());

			pstRptFormatDetailCoa.insert(); 
			rptformatdetailcoa.setOID(pstRptFormatDetailCoa.getlong(COL_RPT_FORMAT_DETAIL_COA_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFormatDetailCoa(0),CONException.UNKNOWN); 
		}
		return rptformatdetailcoa.getOID();
	}

	public static long updateExc(RptFormatDetailCoa rptformatdetailcoa) throws CONException{ 
		try{ 
			if(rptformatdetailcoa.getOID() != 0){ 
				DbRptFormatDetailCoa pstRptFormatDetailCoa = new DbRptFormatDetailCoa(rptformatdetailcoa.getOID());

				pstRptFormatDetailCoa.setLong(COL_RPT_FORMAT_DETAIL_ID, rptformatdetailcoa.getRptFormatDetailId());
				pstRptFormatDetailCoa.setLong(COL_COA_ID, rptformatdetailcoa.getCoaId());
				
				pstRptFormatDetailCoa.setInt(COL_IS_MINUS, rptformatdetailcoa.getIsMinus());
				pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL1_ID, rptformatdetailcoa.getDepLevel1Id());
				pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL2_ID, rptformatdetailcoa.getDepLevel2Id());
				pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL3_ID, rptformatdetailcoa.getDepLevel3Id());
				pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL4_ID, rptformatdetailcoa.getDepLevel4Id());
				pstRptFormatDetailCoa.setLong(COL_DEP_LEVEL5_ID, rptformatdetailcoa.getDepLevel5Id());
				pstRptFormatDetailCoa.setLong(COL_DEP_ID, rptformatdetailcoa.getDepId());

				pstRptFormatDetailCoa.update(); 
				return rptformatdetailcoa.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFormatDetailCoa(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbRptFormatDetailCoa pstRptFormatDetailCoa = new DbRptFormatDetailCoa(oid);
			pstRptFormatDetailCoa.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFormatDetailCoa(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_RPT_FORMAT_DETAIL_COA; 
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
				RptFormatDetailCoa rptformatdetailcoa = new RptFormatDetailCoa();
				resultToObject(rs, rptformatdetailcoa);
				lists.add(rptformatdetailcoa);
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

	private static void resultToObject(ResultSet rs, RptFormatDetailCoa rptformatdetailcoa){
		try{
			rptformatdetailcoa.setOID(rs.getLong(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_COA_ID]));
			rptformatdetailcoa.setRptFormatDetailId(rs.getLong(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID]));
			rptformatdetailcoa.setCoaId(rs.getLong(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_COA_ID]));
			
			rptformatdetailcoa.setIsMinus(rs.getInt(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_IS_MINUS]));
			rptformatdetailcoa.setDepLevel1Id(rs.getLong(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_DEP_LEVEL1_ID]));
			rptformatdetailcoa.setDepLevel2Id(rs.getLong(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_DEP_LEVEL2_ID]));
			rptformatdetailcoa.setDepLevel3Id(rs.getLong(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_DEP_LEVEL3_ID]));
			rptformatdetailcoa.setDepLevel4Id(rs.getLong(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_DEP_LEVEL4_ID]));
			rptformatdetailcoa.setDepLevel5Id(rs.getLong(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_DEP_LEVEL5_ID]));
			rptformatdetailcoa.setDepId(rs.getLong(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_DEP_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long rptFormatDetailCoaId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_RPT_FORMAT_DETAIL_COA + " WHERE " + 
						DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_COA_ID] + " = " + rptFormatDetailCoaId;

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
			String sql = "SELECT COUNT("+ DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_COA_ID] + ") FROM " + DB_RPT_FORMAT_DETAIL_COA;
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
			  	   RptFormatDetailCoa rptformatdetailcoa = (RptFormatDetailCoa)list.get(ls);
				   if(oid == rptformatdetailcoa.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
	public static void updateList(long oidRptFormatDetail, Vector checkeds){		
		
		deleteByDetail(oidRptFormatDetail);
		
		if(checkeds!=null && checkeds.size()>0){
			for(int i=0; i<checkeds.size(); i++){
				//Long x = Long.parseLong((String)checkeds.get(i));
				
				RptFormatDetailCoa rptc = (RptFormatDetailCoa)checkeds.get(i);
				
				try{					
					rptc.setRptFormatDetailId(oidRptFormatDetail);
					//rptc.setCoaId(x);
					DbRptFormatDetailCoa.insertExc(rptc);
				}
				catch(Exception e){
				
				}
			}
		}		
	}
	
	public static void deleteByDetail(long oidRptFormatDetail){
		try{
			CONHandler.execUpdate("delete from "+DB_RPT_FORMAT_DETAIL_COA+" where "+colNames[COL_RPT_FORMAT_DETAIL_ID]+"="+oidRptFormatDetail);
		}
		catch(Exception e){
		
		}
	}
	
}
