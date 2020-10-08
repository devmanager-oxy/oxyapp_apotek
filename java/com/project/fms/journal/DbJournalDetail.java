
package com.project.fms.journal; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.journal.*;  
import com.project.util.lang.*;

public class DbJournalDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_JOURNAL_DETAIL = "journal_detail";

	public static final  int CL_JOURNAL_ID = 0;
	public static final  int CL_JOURNAL_DETAIL_ID = 1;
	public static final  int CL_COA_ID = 2;
	public static final  int CL_AMOUNT = 3;
	public static final  int CL_DEPARTMENT_ID = 4;
	public static final  int CL_SECTION_ID = 5;
	public static final  int CL_PERIODE_ID = 6;
	public static final  int CL_EXCHANGE_RATE = 7;
	public static final  int CL_CURRENCY = 8;
	public static final  int CL_USER_ID = 9;
	public static final  int CL_STATUS = 10;
	public static final  int CL_IS_DEBET = 11;
	public static final  int CL_DEBET = 12;
	public static final  int CL_CREDIT = 13;

	public static final  String[] colNames = {
		"journal_id",
		"journal_detail_id",
		"coa_id",
		"amount",
		"department_id",
		"section_id",
		"periode_id",
		"exchange_rate",
		"currency",
		"user_id",
		"status",
		"is_debet",
		"debet",
		"credit"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_FLOAT
	 }; 

	public DbJournalDetail(){
	}

	public DbJournalDetail(int i) throws CONException { 
		super(new DbJournalDetail()); 
	}

	public DbJournalDetail(String sOid) throws CONException { 
		super(new DbJournalDetail(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbJournalDetail(long lOid) throws CONException { 
		super(new DbJournalDetail(0)); 
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
		return DB_JOURNAL_DETAIL;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbJournalDetail().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		JournalDetail journaldetail = fetchExc(ent.getOID()); 
		ent = (Entity)journaldetail; 
		return journaldetail.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((JournalDetail) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((JournalDetail) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static JournalDetail fetchExc(long oid) throws CONException{ 
		try{ 
			JournalDetail journaldetail = new JournalDetail();
			DbJournalDetail pstJournalDetail = new DbJournalDetail(oid); 
			journaldetail.setOID(oid);

			journaldetail.setJournalId(pstJournalDetail.getlong(CL_JOURNAL_ID));
			journaldetail.setCoaId(pstJournalDetail.getlong(CL_COA_ID));
			journaldetail.setAmount(pstJournalDetail.getdouble(CL_AMOUNT));
			journaldetail.setDepartmentId(pstJournalDetail.getlong(CL_DEPARTMENT_ID));
			journaldetail.setSectionId(pstJournalDetail.getlong(CL_SECTION_ID));
			journaldetail.setPeriodeId(pstJournalDetail.getlong(CL_PERIODE_ID));
			journaldetail.setExchangeRate(pstJournalDetail.getdouble(CL_EXCHANGE_RATE));
			journaldetail.setCurrency(pstJournalDetail.getString(CL_CURRENCY));
			journaldetail.setUserId(pstJournalDetail.getlong(CL_USER_ID));
			journaldetail.setStatus(pstJournalDetail.getString(CL_STATUS));
			journaldetail.setIsDebet(pstJournalDetail.getInt(CL_IS_DEBET));
			journaldetail.setDebet(pstJournalDetail.getdouble(CL_DEBET));
			journaldetail.setCredit(pstJournalDetail.getdouble(CL_CREDIT));

			return journaldetail; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbJournalDetail(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(JournalDetail journaldetail) throws CONException{ 
		try{ 
			DbJournalDetail pstJournalDetail = new DbJournalDetail(0);

			pstJournalDetail.setLong(CL_JOURNAL_ID, journaldetail.getJournalId());
			pstJournalDetail.setLong(CL_COA_ID, journaldetail.getCoaId());
			pstJournalDetail.setDouble(CL_AMOUNT, journaldetail.getAmount());
			pstJournalDetail.setLong(CL_DEPARTMENT_ID, journaldetail.getDepartmentId());
			pstJournalDetail.setLong(CL_SECTION_ID, journaldetail.getSectionId());
			pstJournalDetail.setLong(CL_PERIODE_ID, journaldetail.getPeriodeId());
			pstJournalDetail.setDouble(CL_EXCHANGE_RATE, journaldetail.getExchangeRate());
			pstJournalDetail.setString(CL_CURRENCY, journaldetail.getCurrency());
			pstJournalDetail.setLong(CL_USER_ID, journaldetail.getUserId());
			pstJournalDetail.setString(CL_STATUS, journaldetail.getStatus());
			pstJournalDetail.setInt(CL_IS_DEBET, journaldetail.getIsDebet());
			pstJournalDetail.setDouble(CL_DEBET, journaldetail.getDebet());
			pstJournalDetail.setDouble(CL_CREDIT, journaldetail.getCredit());

			pstJournalDetail.insert(); 
			journaldetail.setOID(pstJournalDetail.getlong(CL_JOURNAL_DETAIL_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbJournalDetail(0),CONException.UNKNOWN); 
		}
		return journaldetail.getOID();
	}

	public static long updateExc(JournalDetail journaldetail) throws CONException{ 
		try{ 
			if(journaldetail.getOID() != 0){ 
				DbJournalDetail pstJournalDetail = new DbJournalDetail(journaldetail.getOID());

				pstJournalDetail.setLong(CL_JOURNAL_ID, journaldetail.getJournalId());
				pstJournalDetail.setLong(CL_COA_ID, journaldetail.getCoaId());
				pstJournalDetail.setDouble(CL_AMOUNT, journaldetail.getAmount());
				pstJournalDetail.setLong(CL_DEPARTMENT_ID, journaldetail.getDepartmentId());
				pstJournalDetail.setLong(CL_SECTION_ID, journaldetail.getSectionId());
				pstJournalDetail.setLong(CL_PERIODE_ID, journaldetail.getPeriodeId());
				pstJournalDetail.setDouble(CL_EXCHANGE_RATE, journaldetail.getExchangeRate());
				pstJournalDetail.setString(CL_CURRENCY, journaldetail.getCurrency());
				pstJournalDetail.setLong(CL_USER_ID, journaldetail.getUserId());
				pstJournalDetail.setString(CL_STATUS, journaldetail.getStatus());
				pstJournalDetail.setInt(CL_IS_DEBET, journaldetail.getIsDebet());
				pstJournalDetail.setDouble(CL_DEBET, journaldetail.getDebet());
				pstJournalDetail.setDouble(CL_CREDIT, journaldetail.getCredit());

				pstJournalDetail.update(); 
				return journaldetail.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbJournalDetail(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbJournalDetail pstJournalDetail = new DbJournalDetail(oid);
			pstJournalDetail.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbJournalDetail(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_JOURNAL_DETAIL; 
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
				JournalDetail journaldetail = new JournalDetail();
				resultToObject(rs, journaldetail);
				lists.add(journaldetail);
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

	private static void resultToObject(ResultSet rs, JournalDetail journaldetail){
		try{
			journaldetail.setOID(rs.getLong(DbJournalDetail.colNames[DbJournalDetail.CL_JOURNAL_DETAIL_ID]));
			journaldetail.setJournalId(rs.getLong(DbJournalDetail.colNames[DbJournalDetail.CL_JOURNAL_ID]));
			journaldetail.setCoaId(rs.getLong(DbJournalDetail.colNames[DbJournalDetail.CL_COA_ID]));
			journaldetail.setAmount(rs.getDouble(DbJournalDetail.colNames[DbJournalDetail.CL_AMOUNT]));
			journaldetail.setDepartmentId(rs.getLong(DbJournalDetail.colNames[DbJournalDetail.CL_DEPARTMENT_ID]));
			journaldetail.setSectionId(rs.getLong(DbJournalDetail.colNames[DbJournalDetail.CL_SECTION_ID]));
			journaldetail.setPeriodeId(rs.getLong(DbJournalDetail.colNames[DbJournalDetail.CL_PERIODE_ID]));
			journaldetail.setExchangeRate(rs.getDouble(DbJournalDetail.colNames[DbJournalDetail.CL_EXCHANGE_RATE]));
			journaldetail.setCurrency(rs.getString(DbJournalDetail.colNames[DbJournalDetail.CL_CURRENCY]));
			journaldetail.setUserId(rs.getLong(DbJournalDetail.colNames[DbJournalDetail.CL_USER_ID]));
			journaldetail.setStatus(rs.getString(DbJournalDetail.colNames[DbJournalDetail.CL_STATUS]));
			journaldetail.setIsDebet(rs.getInt(DbJournalDetail.colNames[DbJournalDetail.CL_IS_DEBET]));
			journaldetail.setDebet(rs.getDouble(DbJournalDetail.colNames[DbJournalDetail.CL_DEBET]));
			journaldetail.setCredit(rs.getDouble(DbJournalDetail.colNames[DbJournalDetail.CL_CREDIT]));

		}catch(Exception e){ }
	}

	/*public static boolean checkOID(long journalDetailId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_JOURNAL_DETAIL + " WHERE " + 
						DbJournalDetail.colNames[DbJournalDetail.CL_JOURNAL_ID] + " = " + journalId;

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
         */

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbJournalDetail.colNames[DbJournalDetail.CL_JOURNAL_DETAIL_ID] + ") FROM " + DB_JOURNAL_DETAIL;
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
			  	   JournalDetail journaldetail = (JournalDetail)list.get(ls);
				   if(oid == journaldetail.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
      
        
}
