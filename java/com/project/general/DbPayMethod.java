

package com.project.general; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

import com.project.main.entity.*;
import com.project.main.db.*;

import com.project.general.*; 

public class DbPayMethod extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc{ 

	public static final  String DB_PAYMETHOD = "paymethod";

	public static final  int COL_PAY_METHOD = 0;
	public static final  int COL_DESCRIPTION = 1;
	public static final  int COL_PAY_METHOD_ID = 2;

	public static final  String[] colNames = {
		"pay_method",
		"description",
		"pay_method_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG + TYPE_PK + TYPE_ID
	 }; 

	public DbPayMethod(){
	}

	public DbPayMethod(int i) throws CONException { 
		super(new DbPayMethod()); 
	}

	public DbPayMethod(String sOid) throws CONException { 
		super(new DbPayMethod(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPayMethod(long lOid) throws CONException { 
		super(new DbPayMethod(0)); 
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
		return DB_PAYMETHOD;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPayMethod().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PayMethod paymethod = fetchExc(ent.getOID()); 
		ent = (Entity)paymethod; 
		return paymethod.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PayMethod) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PayMethod) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PayMethod fetchExc(long oid) throws CONException{ 
		try{ 
			PayMethod paymethod = new PayMethod();
			DbPayMethod pstPayMethod = new DbPayMethod(oid); 
			paymethod.setOID(oid);

			paymethod.setPayMethod(pstPayMethod.getString(COL_PAY_METHOD));
			paymethod.setDescription(pstPayMethod.getString(COL_DESCRIPTION));

			return paymethod; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPayMethod(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PayMethod paymethod) throws CONException{ 
		try{ 
			DbPayMethod pstPayMethod = new DbPayMethod(0);

			pstPayMethod.setString(COL_PAY_METHOD, paymethod.getPayMethod());
			pstPayMethod.setString(COL_DESCRIPTION, paymethod.getDescription());

			pstPayMethod.insert(); 
			paymethod.setOID(pstPayMethod.getlong(COL_PAY_METHOD_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPayMethod(0),CONException.UNKNOWN); 
		}
		return paymethod.getOID();
	}

	public static long updateExc(PayMethod paymethod) throws CONException{ 
		try{ 
			if(paymethod.getOID() != 0){ 
				DbPayMethod pstPayMethod = new DbPayMethod(paymethod.getOID());

				pstPayMethod.setString(COL_PAY_METHOD, paymethod.getPayMethod());
				pstPayMethod.setString(COL_DESCRIPTION, paymethod.getDescription());

				pstPayMethod.update(); 
				return paymethod.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPayMethod(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPayMethod pstPayMethod = new DbPayMethod(oid);
			pstPayMethod.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPayMethod(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PAYMETHOD; 
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
				PayMethod paymethod = new PayMethod();
				resultToObject(rs, paymethod);
				lists.add(paymethod);
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

	private static void resultToObject(ResultSet rs, PayMethod paymethod){
		try{
			paymethod.setOID(rs.getLong(DbPayMethod.colNames[DbPayMethod.COL_PAY_METHOD_ID]));
			paymethod.setPayMethod(rs.getString(DbPayMethod.colNames[DbPayMethod.COL_PAY_METHOD]));
			paymethod.setDescription(rs.getString(DbPayMethod.colNames[DbPayMethod.COL_DESCRIPTION]));

		}catch(Exception e){ }
	}

	

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbPayMethod.colNames[DbPayMethod.COL_PAY_METHOD_ID] + ") FROM " + DB_PAYMETHOD;
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
			  	   PayMethod paymethod = (PayMethod)list.get(ls);
				   if(oid == paymethod.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
