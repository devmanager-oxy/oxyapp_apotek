
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

public class DbRptFormat extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_RPT_FORMAT = "rpt_format";

	public static final  int COL_RPT_FORMAT_ID = 0;
	public static final  int COL_NAME = 1;
	public static final  int COL_CREATE_DATE = 2;
	public static final  int COL_INACTIVE_DATE = 3;
	public static final  int COL_STATUS = 4;
	public static final  int COL_REPORT_SCOPE = 5;
	public static final  int COL_REF_ID = 6;
	public static final  int COL_CREATOR_ID = 7;
	public static final  int COL_UPDATE_BY_ID = 8;
	public static final  int COL_UPDATE_DATE = 9;
	public static final  int COL_REPORT_TYPE = 10;
        public static final  int COL_REPORT_TITLE = 11;

	public static final  String[] colNames = {
		"rpt_format_id",
		"name",
		"create_date",
		"inactive_date",
		"status",
		"report_scope",
		"ref_id",
		"creator_id",
		"update_by_id",
		"update_date",
		"report_type",
                "report_title"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_INT,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_INT,
                TYPE_STRING
	 }; 
	 	
	public static final int REPORT_TYPE_BALANCE_SHEET 	= 0;
	public static final int REPORT_TYPE_PROFITLOSS		= 1;
	public static final int REPORT_TYPE_OTHER 		= 2;
	
	public static final String[][] strReportType = {
		{"Balance Sheet", "Profit & Loss Statement", "Other Report"},
		{"Balance Sheet", "Profit & Loss Statement", "Other Report"},
		{"Neraca", "Laba Rugi", "Laporan Lainnya"}
	}; 	

	public DbRptFormat(){
	}

	public DbRptFormat(int i) throws CONException { 
		super(new DbRptFormat()); 
	}

	public DbRptFormat(String sOid) throws CONException { 
		super(new DbRptFormat(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbRptFormat(long lOid) throws CONException { 
		super(new DbRptFormat(0)); 
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
		return DB_RPT_FORMAT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbRptFormat().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		RptFormat rptformat = fetchExc(ent.getOID()); 
		ent = (Entity)rptformat; 
		return rptformat.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((RptFormat) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((RptFormat) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static RptFormat fetchExc(long oid) throws CONException{ 
		try{ 
			RptFormat rptformat = new RptFormat();
			DbRptFormat pstRptFormat = new DbRptFormat(oid); 
			rptformat.setOID(oid);

			rptformat.setName(pstRptFormat.getString(COL_NAME));
			rptformat.setCreateDate(pstRptFormat.getDate(COL_CREATE_DATE));
			rptformat.setInactiveDate(pstRptFormat.getDate(COL_INACTIVE_DATE));
			rptformat.setStatus(pstRptFormat.getInt(COL_STATUS));
			rptformat.setReportScope(pstRptFormat.getInt(COL_REPORT_SCOPE));
			rptformat.setRefId(pstRptFormat.getlong(COL_REF_ID));
			rptformat.setCreatorId(pstRptFormat.getlong(COL_CREATOR_ID));
			rptformat.setUpdateById(pstRptFormat.getlong(COL_UPDATE_BY_ID));
			rptformat.setUpdateDate(pstRptFormat.getDate(COL_UPDATE_DATE));
			rptformat.setReportType(pstRptFormat.getInt(COL_REPORT_TYPE));
                        rptformat.setReportTitle(pstRptFormat.getString(COL_REPORT_TITLE));

			return rptformat; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFormat(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(RptFormat rptformat) throws CONException{ 
		try{ 
			DbRptFormat pstRptFormat = new DbRptFormat(0);

			pstRptFormat.setString(COL_NAME, rptformat.getName());
			pstRptFormat.setDate(COL_CREATE_DATE, rptformat.getCreateDate());
			pstRptFormat.setDate(COL_INACTIVE_DATE, rptformat.getInactiveDate());
			pstRptFormat.setInt(COL_STATUS, rptformat.getStatus());
			pstRptFormat.setInt(COL_REPORT_SCOPE, rptformat.getReportScope());
			pstRptFormat.setLong(COL_REF_ID, rptformat.getRefId());
			pstRptFormat.setLong(COL_CREATOR_ID, rptformat.getCreatorId());
			pstRptFormat.setLong(COL_UPDATE_BY_ID, rptformat.getUpdateById());
			pstRptFormat.setDate(COL_UPDATE_DATE, rptformat.getUpdateDate());
			pstRptFormat.setInt(COL_REPORT_TYPE, rptformat.getReportType());
                        pstRptFormat.setString(COL_REPORT_TITLE, rptformat.getReportTitle());

			pstRptFormat.insert(); 
			rptformat.setOID(pstRptFormat.getlong(COL_RPT_FORMAT_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFormat(0),CONException.UNKNOWN); 
		}
		return rptformat.getOID();
	}

	public static long updateExc(RptFormat rptformat) throws CONException{ 
		try{ 
			if(rptformat.getOID() != 0){ 
				DbRptFormat pstRptFormat = new DbRptFormat(rptformat.getOID());

				pstRptFormat.setString(COL_NAME, rptformat.getName());
				pstRptFormat.setDate(COL_CREATE_DATE, rptformat.getCreateDate());
				pstRptFormat.setDate(COL_INACTIVE_DATE, rptformat.getInactiveDate());
				pstRptFormat.setInt(COL_STATUS, rptformat.getStatus());
				pstRptFormat.setInt(COL_REPORT_SCOPE, rptformat.getReportScope());
				pstRptFormat.setLong(COL_REF_ID, rptformat.getRefId());
				pstRptFormat.setLong(COL_CREATOR_ID, rptformat.getCreatorId());
				pstRptFormat.setLong(COL_UPDATE_BY_ID, rptformat.getUpdateById());
				pstRptFormat.setDate(COL_UPDATE_DATE, rptformat.getUpdateDate());
				pstRptFormat.setInt(COL_REPORT_TYPE, rptformat.getReportType());
                                pstRptFormat.setString(COL_REPORT_TITLE, rptformat.getReportTitle());

				pstRptFormat.update(); 
				return rptformat.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFormat(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbRptFormat pstRptFormat = new DbRptFormat(oid);
			pstRptFormat.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFormat(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_RPT_FORMAT; 
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
				RptFormat rptformat = new RptFormat();
				resultToObject(rs, rptformat);
				lists.add(rptformat);
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

	private static void resultToObject(ResultSet rs, RptFormat rptformat){
		try{
			rptformat.setOID(rs.getLong(DbRptFormat.colNames[DbRptFormat.COL_RPT_FORMAT_ID]));
			rptformat.setName(rs.getString(DbRptFormat.colNames[DbRptFormat.COL_NAME]));
			rptformat.setCreateDate(rs.getDate(DbRptFormat.colNames[DbRptFormat.COL_CREATE_DATE]));
			rptformat.setInactiveDate(rs.getDate(DbRptFormat.colNames[DbRptFormat.COL_INACTIVE_DATE]));
			rptformat.setStatus(rs.getInt(DbRptFormat.colNames[DbRptFormat.COL_STATUS]));
			rptformat.setReportScope(rs.getInt(DbRptFormat.colNames[DbRptFormat.COL_REPORT_SCOPE]));
			rptformat.setRefId(rs.getLong(DbRptFormat.colNames[DbRptFormat.COL_REF_ID]));
			rptformat.setCreatorId(rs.getLong(DbRptFormat.colNames[DbRptFormat.COL_CREATOR_ID]));
			rptformat.setUpdateById(rs.getLong(DbRptFormat.colNames[DbRptFormat.COL_UPDATE_BY_ID]));
			rptformat.setUpdateDate(rs.getDate(DbRptFormat.colNames[DbRptFormat.COL_UPDATE_DATE]));
			rptformat.setReportType(rs.getInt(DbRptFormat.colNames[DbRptFormat.COL_REPORT_TYPE]));
                        rptformat.setReportTitle(rs.getString(DbRptFormat.colNames[DbRptFormat.COL_REPORT_TITLE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long rptFormatId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_RPT_FORMAT + " WHERE " + 
						DbRptFormat.colNames[DbRptFormat.COL_RPT_FORMAT_ID] + " = " + rptFormatId;

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
			String sql = "SELECT COUNT("+ DbRptFormat.colNames[DbRptFormat.COL_RPT_FORMAT_ID] + ") FROM " + DB_RPT_FORMAT;
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
			  	   RptFormat rptformat = (RptFormat)list.get(ls);
				   if(oid == rptformat.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
