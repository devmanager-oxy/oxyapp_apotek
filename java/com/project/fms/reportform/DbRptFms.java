/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.reportform;

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.*;
/**
 *
 * @author Roy Andika
 */
public class DbRptFms extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
        public static final  String DB_RPT_FMS = "rpt_fms";

	public static final  int COL_RPT_FMS_ID         = 0;
        public static final  int COL_TYPE_REPORT        = 1;
        public static final  int COL_USER_ID            = 2;
        public static final  int COL_REPORT_DATE        = 3;        
        public static final  int COL_PERIOD_SEARCH_ID   = 4;
        public static final  int COL_LOCATION_ID        = 5;
        public static final  int COL_LOCATION_NAME      = 6;
        public static final  int COL_ALL_COA            = 7;

	public static final  String[] colNames = {
		"rpt_fms_id",
		"type_report",
		"user_id",
		"report_date",                
                "period_search_id",
                "location_id",
                "location_name",
                "all_coa"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_INT,
		TYPE_LONG,
		TYPE_DATE,
                
                TYPE_LONG,
                TYPE_LONG,
                TYPE_STRING,
                TYPE_INT
	 }; 
	 	
	public static final int REPORT_TYPE_NERACA                      = 0;
	public static final int REPORT_TYPE_PROFITLOSS_YTD		= 1;
	public static final int REPORT_TYPE_PROFITLOSS_YTD_PERIOD	= 2;
        public static final int REPORT_TYPE_PROFITLOSS_MTD              = 3;
        public static final int REPORT_TYPE_PROFITLOSS_MTD_PERIOD	= 4;
	public static final int REPORT_TYPE_PROFITLOSS_MTD_PERIOD_CUSTOM= 5;

	public DbRptFms(){
	}

	public DbRptFms(int i) throws CONException { 
		super(new DbRptFms()); 
	}

	public DbRptFms(String sOid) throws CONException { 
		super(new DbRptFms(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbRptFms(long lOid) throws CONException { 
		super(new DbRptFms(0)); 
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
		return DB_RPT_FMS;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbRptFms().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		RptFms rptFms = fetchExc(ent.getOID()); 
		ent = (Entity)rptFms; 
		return rptFms.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((RptFms) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((RptFms) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static RptFms fetchExc(long oid) throws CONException{ 
		try{ 
			RptFms rptFms = new RptFms();
			DbRptFms pstRptFms = new DbRptFms(oid); 
			rptFms.setOID(oid);
                        
			rptFms.setTypeReport(pstRptFms.getInt(COL_TYPE_REPORT));
                        rptFms.setUserId(pstRptFms.getlong(COL_USER_ID));
                        rptFms.setReportDate(pstRptFms.getDate(COL_REPORT_DATE));
                        
                        rptFms.setPeriodSearchId(pstRptFms.getlong(COL_PERIOD_SEARCH_ID));
                        rptFms.setLocationId(pstRptFms.getlong(COL_LOCATION_ID));
                        rptFms.setLocationName(pstRptFms.getString(COL_LOCATION_NAME));
                        rptFms.setAllCoa(pstRptFms.getInt(COL_ALL_COA));
                        
			return rptFms; 
                        
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFms(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(RptFms rptFms) throws CONException{ 
		try{ 
			DbRptFms pstRptFms = new DbRptFms(0);
                        
			pstRptFms.setInt(COL_TYPE_REPORT, rptFms.getTypeReport());
                        pstRptFms.setLong(COL_USER_ID, rptFms.getUserId());
                        pstRptFms.setDate(COL_REPORT_DATE, rptFms.getReportDate());
                        
                        pstRptFms.setLong(COL_PERIOD_SEARCH_ID, rptFms.getPeriodSearchId());
                        pstRptFms.setLong(COL_LOCATION_ID, rptFms.getLocationId());
                        pstRptFms.setString(COL_LOCATION_NAME, rptFms.getLocationName());
                        pstRptFms.setInt(COL_ALL_COA, rptFms.getAllCoa());
                        
			pstRptFms.insert(); 
			rptFms.setOID(pstRptFms.getlong(COL_RPT_FMS_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFms(0),CONException.UNKNOWN); 
		}
		return rptFms.getOID();
	}

	public static long updateExc(RptFms rptFms) throws CONException{ 
		try{ 
			if(rptFms.getOID() != 0){ 
				DbRptFms pstRptFms = new DbRptFms(rptFms.getOID());

				pstRptFms.setInt(COL_TYPE_REPORT, rptFms.getTypeReport());
                                pstRptFms.setLong(COL_USER_ID, rptFms.getUserId());
                                pstRptFms.setDate(COL_REPORT_DATE, rptFms.getReportDate());
                                
                                pstRptFms.setLong(COL_PERIOD_SEARCH_ID, rptFms.getPeriodSearchId());
                                pstRptFms.setLong(COL_LOCATION_ID, rptFms.getLocationId());
                                pstRptFms.setString(COL_LOCATION_NAME, rptFms.getLocationName());
                                pstRptFms.setInt(COL_ALL_COA, rptFms.getAllCoa());

				pstRptFms.update(); 
				return rptFms.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFms(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbRptFms pstRptFms = new DbRptFms(oid);
			pstRptFms.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFms(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_RPT_FMS; 
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
				RptFms rptFms = new RptFms();
				resultToObject(rs, rptFms);
				lists.add(rptFms);
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

	private static void resultToObject(ResultSet rs, RptFms rptFms){
		try{
			rptFms.setOID(rs.getLong(DbRptFms.colNames[DbRptFms.COL_RPT_FMS_ID]));
                        rptFms.setTypeReport(rs.getInt(DbRptFms.colNames[DbRptFms.COL_TYPE_REPORT]));
                        rptFms.setUserId(rs.getLong(DbRptFms.colNames[DbRptFms.COL_USER_ID]));
                        rptFms.setReportDate(rs.getDate(DbRptFms.colNames[DbRptFms.COL_REPORT_DATE]));                            
                        rptFms.setPeriodSearchId(rs.getLong(DbRptFms.colNames[DbRptFms.COL_PERIOD_SEARCH_ID]));    
                        rptFms.setLocationId(rs.getLong(DbRptFms.colNames[DbRptFms.COL_LOCATION_ID]));    
                        rptFms.setLocationName(rs.getString(DbRptFms.colNames[DbRptFms.COL_LOCATION_NAME]));    
                        rptFms.setAllCoa(rs.getInt(DbRptFms.colNames[DbRptFms.COL_ALL_COA]));    
                        
		}catch(Exception e){ }
	}

	public static boolean checkOID(long rptFmsId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_RPT_FMS + " WHERE " + 
						DbRptFms.colNames[DbRptFms.COL_RPT_FMS_ID] + " = " + rptFmsId;

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
			String sql = "SELECT COUNT("+ DbRptFms.colNames[DbRptFms.COL_RPT_FMS_ID] + ") FROM " + DB_RPT_FMS;
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
			  	   RptFms rptFms = (RptFms)list.get(ls);
				   if(oid == rptFms.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static void delReportFms(int typeReport,long userId,long periodId,int typeCoa){
            CONResultSet dbrs = null;
            try{
                String sql = "delete from "+DbRptFms.DB_RPT_FMS+
                        " where "+DbRptFms.colNames[DbRptFms.COL_USER_ID]+" = "+userId+" and "+
                        DbRptFms.colNames[DbRptFms.COL_TYPE_REPORT]+" = "+typeReport+" and "+
                        DbRptFms.colNames[DbRptFms.COL_PERIOD_SEARCH_ID]+" = "+periodId+" and "+
                        DbRptFms.colNames[DbRptFms.COL_ALL_COA]+" = "+typeCoa;
                
                long oid = CONHandler.execUpdate(sql);                
                DbRptFmsDetail.delReportFmsDetail(oid);
                        
            }catch(Exception e){}
            finally{
                CONResultSet.close(dbrs);
            }
        }
        
        public static boolean getReport(int typeReport,long periodId,int priviewType,long userId){
            CONResultSet dbrs = null;
            try{
                String sql = "select * from "+DbRptFms.DB_RPT_FMS+" where "+
                        DbRptFms.colNames[DbRptFms.COL_USER_ID]+" = "+userId+" and "+
                        DbRptFms.colNames[DbRptFms.COL_TYPE_REPORT]+" = "+typeReport+" and "+
                        DbRptFms.colNames[DbRptFms.COL_PERIOD_SEARCH_ID]+" = "+periodId+" and "+
                        DbRptFms.colNames[DbRptFms.COL_ALL_COA]+" = "+priviewType;
                
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
		
                while(rs.next()) { 
                    return true;
                }       
            }catch(Exception e){}
            finally{
                CONResultSet.close(dbrs);
            }
            
            return false;
        }
        
}
