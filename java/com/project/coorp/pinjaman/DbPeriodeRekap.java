
package com.project.coorp.pinjaman; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*; 
import com.project.*;
import com.project.util.*;

public class DbPeriodeRekap extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_PERIODE = "sp_periode_rekap";

	public static final  int COL_PERIODE_ID = 0;
	public static final  int COL_START_DATE = 1;
	public static final  int COL_END_DATE = 2;
	public static final  int COL_STATUS = 3;
	public static final  int COL_NAME = 4;
        public static final  int COL_INPUT_TOLERANCE = 5;

	public static final  String[] colNames = {
		"periode_id",
		"start_date",
		"end_date",
		"status",
		"name",
                "input_tolerance"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING,
                TYPE_DATE
	 }; 

	public DbPeriodeRekap(){
	}

	public DbPeriodeRekap(int i) throws CONException { 
		super(new DbPeriodeRekap()); 
	}

	public DbPeriodeRekap(String sOid) throws CONException { 
		super(new DbPeriodeRekap(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPeriodeRekap(long lOid) throws CONException { 
		super(new DbPeriodeRekap(0)); 
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
		return DB_PERIODE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPeriodeRekap().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PeriodeRekap periode = fetchExc(ent.getOID()); 
		ent = (Entity)periode; 
		return periode.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PeriodeRekap) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PeriodeRekap) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PeriodeRekap fetchExc(long oid) throws CONException{ 
		try{ 
			PeriodeRekap periode = new PeriodeRekap();
			DbPeriodeRekap dbPeriodeRekap = new DbPeriodeRekap(oid); 
			periode.setOID(oid);

			periode.setStartDate(dbPeriodeRekap.getDate(COL_START_DATE));
			periode.setEndDate(dbPeriodeRekap.getDate(COL_END_DATE));
			periode.setStatus(dbPeriodeRekap.getString(COL_STATUS));
			periode.setName(dbPeriodeRekap.getString(COL_NAME));
                        periode.setInputTolerance(dbPeriodeRekap.getDate(COL_INPUT_TOLERANCE));

			return periode; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPeriodeRekap(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PeriodeRekap periode) throws CONException{ 
		try{ 
			DbPeriodeRekap dbPeriodeRekap = new DbPeriodeRekap(0);

			dbPeriodeRekap.setDate(COL_START_DATE, periode.getStartDate());
			dbPeriodeRekap.setDate(COL_END_DATE, periode.getEndDate());
			dbPeriodeRekap.setString(COL_STATUS, periode.getStatus());
			dbPeriodeRekap.setString(COL_NAME, periode.getName());
                        dbPeriodeRekap.setDate(COL_INPUT_TOLERANCE, periode.getInputTolerance());

			dbPeriodeRekap.insert(); 
			periode.setOID(dbPeriodeRekap.getlong(COL_PERIODE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPeriodeRekap(0),CONException.UNKNOWN); 
		}
		return periode.getOID();
	}

	public static long updateExc(PeriodeRekap periode) throws CONException{ 
		try{ 
			if(periode.getOID() != 0){ 
				DbPeriodeRekap dbPeriodeRekap = new DbPeriodeRekap(periode.getOID());

				dbPeriodeRekap.setDate(COL_START_DATE, periode.getStartDate());
				dbPeriodeRekap.setDate(COL_END_DATE, periode.getEndDate());
				dbPeriodeRekap.setString(COL_STATUS, periode.getStatus());
				dbPeriodeRekap.setString(COL_NAME, periode.getName());
                                dbPeriodeRekap.setDate(COL_INPUT_TOLERANCE, periode.getInputTolerance());

				dbPeriodeRekap.update(); 
				return periode.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPeriodeRekap(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPeriodeRekap dbPeriodeRekap = new DbPeriodeRekap(oid);
			dbPeriodeRekap.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPeriodeRekap(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PERIODE; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			
                        switch (CONHandler.CONSVR_TYPE) {
                            case CONHandler.CONSVR_MYSQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                                break;

                            case CONHandler.CONSVR_POSTGRESQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;

                                break;

                            case CONHandler.CONSVR_SYBASE:
                                break;

                            case CONHandler.CONSVR_ORACLE:
                                break;

                            case CONHandler.CONSVR_MSSQL:
                                break;

                            default:
                                break;
                        }
                        
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				PeriodeRekap periode = new PeriodeRekap();
				resultToObject(rs, periode);
				lists.add(periode);
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

	private static void resultToObject(ResultSet rs, PeriodeRekap periode){
		try{
			periode.setOID(rs.getLong(DbPeriodeRekap.colNames[DbPeriodeRekap.COL_PERIODE_ID]));
			periode.setStartDate(rs.getDate(DbPeriodeRekap.colNames[DbPeriodeRekap.COL_START_DATE]));
			periode.setEndDate(rs.getDate(DbPeriodeRekap.colNames[DbPeriodeRekap.COL_END_DATE]));
			periode.setStatus(rs.getString(DbPeriodeRekap.colNames[DbPeriodeRekap.COL_STATUS]));
			periode.setName(rs.getString(DbPeriodeRekap.colNames[DbPeriodeRekap.COL_NAME]));
                        periode.setInputTolerance(rs.getDate(DbPeriodeRekap.colNames[DbPeriodeRekap.COL_INPUT_TOLERANCE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long periodeId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PERIODE + " WHERE " + 
						DbPeriodeRekap.colNames[DbPeriodeRekap.COL_PERIODE_ID] + " = " + periodeId;

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
			String sql = "SELECT COUNT("+ DbPeriodeRekap.colNames[DbPeriodeRekap.COL_PERIODE_ID] + ") FROM " + DB_PERIODE;
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
			  	   PeriodeRekap periode = (PeriodeRekap)list.get(ls);
				   if(oid == periode.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static PeriodeRekap getOpenPeriod(){
               Vector v = list(0,0, "status='"+I_Project.STATUS_PERIOD_OPEN+"'", "start_date desc");
               if(v!=null && v.size()>0){
                   return (PeriodeRekap)v.get(0);
               }
               return new PeriodeRekap();
        }
        
        public static PeriodeRekap getPeriodByTransDate(Date dt){
                String where = "'"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"' between start_date and end_date ";

                Vector v = DbPeriodeRekap.list(0,0, where, "");
                
                if(v!=null && v.size()>0){
                    return (PeriodeRekap)v.get(0);    
                }
            
                return new PeriodeRekap();
        }

             
}
