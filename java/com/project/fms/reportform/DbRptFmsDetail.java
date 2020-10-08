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

public class DbRptFmsDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
        public static final  String DB_RPT_FMS_DETAIL = "rpt_fms_detail";
        
	public static final  int COL_RPT_FMS_DETAIL_ID  = 0;
        public static final  int COL_RPT_FMS_ID         = 1;
        public static final  int COL_PERIOD_ID          = 2;
        public static final  int COL_SQUENCE            = 3;
        public static final  int COL_COA_ID             = 4;
        public static final  int COL_AMOUNT             = 5;
        public static final  int COL_TYPE               = 6;
        public static final  int COL_LEVEL              = 7;
        public static final  int COL_DESCRIPTION        = 8;
        public static final  int COL_TYPE_DOC           = 9;
        public static final  int COL_STATUS             = 10;
        public static final  int COL_CURRENT_PERIOD     = 11;

	public static final  String[] colNames = {
		"rpt_fms_detail_id",
                "rpt_fms_id",
		"period_id",
		"squence",
		"coa_id",                
                "amount",
                "type",
                "level",
                "description",
                "type_doc",
                "status",
                "current_period"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
                TYPE_LONG,
		TYPE_LONG,
		TYPE_INT,
		TYPE_LONG,                
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_INT,
                TYPE_STRING,
                TYPE_INT,
                TYPE_STRING,
                TYPE_INT
	 }; 
        
        public static final int DOC_TYPE_HEADER     = 0;
	public static final int DOC_TYPE_DATA       = 1;
        public static final int DOC_TYPE_SUMMARY    = 2;
        
        public static final int TYPE_AKTIVA     = 0;
        public static final int TYPE_PASIVA     = 1;
        
        public static final int PERIOD_PREVIOUS     = 0;
        public static final int PERIOD_CURRENT      = 1;

	public DbRptFmsDetail(){
	}

	public DbRptFmsDetail(int i) throws CONException { 
		super(new DbRptFmsDetail()); 
	}

	public DbRptFmsDetail(String sOid) throws CONException { 
		super(new DbRptFmsDetail(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbRptFmsDetail(long lOid) throws CONException { 
		super(new DbRptFmsDetail(0)); 
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
		return DB_RPT_FMS_DETAIL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbRptFmsDetail().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		RptFmsDetail rptFmsDetail = fetchExc(ent.getOID()); 
		ent = (Entity)rptFmsDetail; 
		return rptFmsDetail.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((RptFmsDetail) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((RptFmsDetail) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static RptFmsDetail fetchExc(long oid) throws CONException{ 
		try{ 
			RptFmsDetail rptFmsDetail = new RptFmsDetail();
			DbRptFmsDetail pstRptFmsDetail = new DbRptFmsDetail(oid); 
			rptFmsDetail.setOID(oid);
                        rptFmsDetail.setRptFmsId(pstRptFmsDetail.getlong(COL_RPT_FMS_ID));
			rptFmsDetail.setPeriodId(pstRptFmsDetail.getlong(COL_PERIOD_ID));
                        rptFmsDetail.setSquence(pstRptFmsDetail.getInt(COL_SQUENCE));
                        rptFmsDetail.setCoaId(pstRptFmsDetail.getlong(COL_COA_ID));
                        rptFmsDetail.setAmount(pstRptFmsDetail.getdouble(COL_AMOUNT));
                        rptFmsDetail.setType(pstRptFmsDetail.getInt(COL_TYPE));
                        rptFmsDetail.setLevel(pstRptFmsDetail.getInt(COL_LEVEL));
                        rptFmsDetail.setDescription(pstRptFmsDetail.getString(COL_DESCRIPTION));
                        rptFmsDetail.setTypeDoc(pstRptFmsDetail.getInt(COL_TYPE_DOC));
                        rptFmsDetail.setStatus(pstRptFmsDetail.getString(COL_STATUS));                        
                        rptFmsDetail.setCurrentPeriod(pstRptFmsDetail.getInt(COL_CURRENT_PERIOD));
                        
			return rptFmsDetail; 
                        
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFmsDetail(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(RptFmsDetail rptFmsDetail) throws CONException{ 
		try{ 
			DbRptFmsDetail pstRptFmsDetail = new DbRptFmsDetail(0);
                        pstRptFmsDetail.setLong(COL_RPT_FMS_ID, rptFmsDetail.getRptFmsId());
			pstRptFmsDetail.setLong(COL_PERIOD_ID, rptFmsDetail.getPeriodId());
                        pstRptFmsDetail.setInt(COL_SQUENCE, rptFmsDetail.getSquence());
                        pstRptFmsDetail.setLong(COL_COA_ID, rptFmsDetail.getCoaId());
                        pstRptFmsDetail.setDouble(COL_AMOUNT, rptFmsDetail.getAmount());
                        pstRptFmsDetail.setInt(COL_TYPE, rptFmsDetail.getType());
                        pstRptFmsDetail.setInt(COL_LEVEL, rptFmsDetail.getLevel());
                        pstRptFmsDetail.setString(COL_DESCRIPTION, rptFmsDetail.getDescription());
                        pstRptFmsDetail.setInt(COL_TYPE_DOC, rptFmsDetail.getTypeDoc());                        
                        pstRptFmsDetail.setString(COL_STATUS, rptFmsDetail.getStatus());
                        pstRptFmsDetail.setInt(COL_CURRENT_PERIOD, rptFmsDetail.getCurrentPeriod());
                        
			pstRptFmsDetail.insert(); 
			rptFmsDetail.setOID(pstRptFmsDetail.getlong(COL_RPT_FMS_DETAIL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFmsDetail(0),CONException.UNKNOWN); 
		}
		return rptFmsDetail.getOID();
	}

	public static long updateExc(RptFmsDetail rptFmsDetail) throws CONException{ 
		try{ 
			if(rptFmsDetail.getOID() != 0){ 
				DbRptFmsDetail pstRptFmsDetail = new DbRptFmsDetail(rptFmsDetail.getOID());
                                pstRptFmsDetail.setLong(COL_RPT_FMS_ID, rptFmsDetail.getRptFmsId());
				pstRptFmsDetail.setLong(COL_PERIOD_ID, rptFmsDetail.getPeriodId());
                                pstRptFmsDetail.setInt(COL_SQUENCE, rptFmsDetail.getSquence());
                                pstRptFmsDetail.setLong(COL_COA_ID, rptFmsDetail.getCoaId());
                                pstRptFmsDetail.setDouble(COL_AMOUNT, rptFmsDetail.getAmount());
                                pstRptFmsDetail.setInt(COL_TYPE, rptFmsDetail.getType());
                                pstRptFmsDetail.setInt(COL_LEVEL, rptFmsDetail.getLevel());
                                pstRptFmsDetail.setString(COL_DESCRIPTION, rptFmsDetail.getDescription());
                                pstRptFmsDetail.setInt(COL_TYPE_DOC, rptFmsDetail.getTypeDoc());
                                pstRptFmsDetail.setString(COL_STATUS, rptFmsDetail.getStatus());
                                pstRptFmsDetail.setInt(COL_CURRENT_PERIOD, rptFmsDetail.getCurrentPeriod());
				pstRptFmsDetail.update(); 
				return rptFmsDetail.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFmsDetail(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbRptFmsDetail pstRptFmsDetail = new DbRptFmsDetail(oid);
			pstRptFmsDetail.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRptFmsDetail(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_RPT_FMS_DETAIL; 
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
				RptFmsDetail rptFmsDetail = new RptFmsDetail();
				resultToObject(rs, rptFmsDetail);
				lists.add(rptFmsDetail);
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

	private static void resultToObject(ResultSet rs, RptFmsDetail rptFmsDetail){
		try{
			rptFmsDetail.setOID(rs.getLong(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_RPT_FMS_DETAIL_ID]));
                        rptFmsDetail.setRptFmsId(rs.getLong(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_RPT_FMS_ID]));
                        rptFmsDetail.setPeriodId(rs.getLong(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_PERIOD_ID]));
                        rptFmsDetail.setSquence(rs.getInt(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_SQUENCE]));
                        rptFmsDetail.setCoaId(rs.getLong(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_COA_ID]));
                        rptFmsDetail.setAmount(rs.getDouble(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_AMOUNT]));
                        rptFmsDetail.setType(rs.getInt(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_TYPE]));
                        rptFmsDetail.setLevel(rs.getInt(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_LEVEL]));
                        rptFmsDetail.setDescription(rs.getString(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_DESCRIPTION]));                        
                        rptFmsDetail.setTypeDoc(rs.getInt(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_TYPE_DOC]));                        
                        rptFmsDetail.setStatus(rs.getString(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_STATUS]));                        
                        rptFmsDetail.setCurrentPeriod(rs.getInt(DbRptFmsDetail.colNames[DbRptFmsDetail.COL_CURRENT_PERIOD]));
		}catch(Exception e){ }
	}

	public static boolean checkOID(long rptFmsDetailId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_RPT_FMS_DETAIL + " WHERE " + 
						DbRptFmsDetail.colNames[DbRptFmsDetail.COL_RPT_FMS_DETAIL_ID] + " = " + rptFmsDetailId;

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
			String sql = "SELECT COUNT("+ DbRptFmsDetail.colNames[DbRptFmsDetail.COL_RPT_FMS_DETAIL_ID] + ") FROM " + DB_RPT_FMS_DETAIL;
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
			  	   RptFmsDetail rptFmsDetail = (RptFmsDetail)list.get(ls);
				   if(oid == rptFmsDetail.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static void delReportFmsDetail(long reportFmsId){
            CONResultSet dbrs = null;
            try{
               String sql = "delete from "+DbRptFmsDetail.DB_RPT_FMS_DETAIL+" where "+
                       DbRptFmsDetail.colNames[DbRptFmsDetail.COL_RPT_FMS_ID]+" = "+reportFmsId;
                        
                CONHandler.execUpdate(sql);
                        
            }catch(Exception e){}
            finally{
                CONResultSet.close(dbrs);
            }
        }
}
