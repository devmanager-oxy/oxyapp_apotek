
package com.project.clinic.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*; 

public class DbDeseas extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CL_DESEASE = "CL_DESEASE";

	public static final  int COL_DESEASE_ID = 0;
	public static final  int COL_NAME = 1;

	public static final  String[] colNames = {
		"DESEASE_ID",
		"NAME"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
	 }; 

	public DbDeseas(){
	}

	public DbDeseas(int i) throws CONException { 
		super(new DbDeseas()); 
	}

	public DbDeseas(String sOid) throws CONException { 
		super(new DbDeseas(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbDeseas(long lOid) throws CONException { 
		super(new DbDeseas(0)); 
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
		return DB_CL_DESEASE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbDeseas().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Deseas deseas = fetchExc(ent.getOID()); 
		ent = (Entity)deseas; 
		return deseas.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Deseas) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Deseas) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Deseas fetchExc(long oid) throws CONException{ 
		try{ 
			Deseas deseas = new Deseas();
			DbDeseas pstDeseas = new DbDeseas(oid); 
			deseas.setOID(oid);

			deseas.setName(pstDeseas.getString(COL_NAME));

			return deseas; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDeseas(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Deseas deseas) throws CONException{ 
		try{ 
			DbDeseas pstDeseas = new DbDeseas(0);

			pstDeseas.setString(COL_NAME, deseas.getName());

			pstDeseas.insert(); 
			deseas.setOID(pstDeseas.getlong(COL_DESEASE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDeseas(0),CONException.UNKNOWN); 
		}
		return deseas.getOID();
	}

	public static long updateExc(Deseas deseas) throws CONException{ 
		try{ 
			if(deseas.getOID() != 0){ 
				DbDeseas pstDeseas = new DbDeseas(deseas.getOID());

				pstDeseas.setString(COL_NAME, deseas.getName());

				pstDeseas.update(); 
				return deseas.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDeseas(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbDeseas pstDeseas = new DbDeseas(oid);
			pstDeseas.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbDeseas(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CL_DESEASE; 
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
				Deseas deseas = new Deseas();
				resultToObject(rs, deseas);
				lists.add(deseas);
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

	private static void resultToObject(ResultSet rs, Deseas deseas){
		try{
			deseas.setOID(rs.getLong(DbDeseas.colNames[DbDeseas.COL_DESEASE_ID]));
			deseas.setName(rs.getString(DbDeseas.colNames[DbDeseas.COL_NAME]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long deseaseId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CL_DESEASE + " WHERE " + 
						DbDeseas.colNames[DbDeseas.COL_DESEASE_ID] + " = " + deseaseId;

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
			String sql = "SELECT COUNT("+ DbDeseas.colNames[DbDeseas.COL_DESEASE_ID] + ") FROM " + DB_CL_DESEASE;
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
			  	   Deseas deseas = (Deseas)list.get(ls);
				   if(oid == deseas.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
