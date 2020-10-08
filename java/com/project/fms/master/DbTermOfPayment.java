
package com.project.fms.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 

public class DbTermOfPayment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_TERM_OF_PAYMENT = "term_of_payment";

	public static final  int CL_TERM_OF_PAYMENT_ID = 0;
	public static final  int CL_DESCRIPTION = 1;
	public static final  int CL_DUE = 2;
	public static final  int CL_QTY_DISC = 3;
	public static final  int CL_DISC_PERCENT = 4;

	public static final  String[] colNames = {
		"term_of_payment_id",
		"description",
		"due",
		"qty_disc",
		"disc_percent"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_INT,
		TYPE_INT,
		TYPE_INT
	 }; 

	public DbTermOfPayment(){
	}

	public DbTermOfPayment(int i) throws CONException { 
		super(new DbTermOfPayment()); 
	}

	public DbTermOfPayment(String sOid) throws CONException { 
		super(new DbTermOfPayment(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbTermOfPayment(long lOid) throws CONException { 
		super(new DbTermOfPayment(0)); 
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
		return DB_TERM_OF_PAYMENT;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbTermOfPayment().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		TermOfPayment termofpayment = fetchExc(ent.getOID()); 
		ent = (Entity)termofpayment; 
		return termofpayment.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((TermOfPayment) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((TermOfPayment) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static TermOfPayment fetchExc(long oid) throws CONException{ 
		try{ 
			TermOfPayment termofpayment = new TermOfPayment();
			DbTermOfPayment pstTermOfPayment = new DbTermOfPayment(oid); 
			termofpayment.setOID(oid);

			termofpayment.setDescription(pstTermOfPayment.getString(CL_DESCRIPTION));
			termofpayment.setDue(pstTermOfPayment.getInt(CL_DUE));
			termofpayment.setQtyDisc(pstTermOfPayment.getInt(CL_QTY_DISC));
			termofpayment.setDiscPercent(pstTermOfPayment.getInt(CL_DISC_PERCENT));

			return termofpayment; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTermOfPayment(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(TermOfPayment termofpayment) throws CONException{ 
		try{ 
			DbTermOfPayment pstTermOfPayment = new DbTermOfPayment(0);

			pstTermOfPayment.setString(CL_DESCRIPTION, termofpayment.getDescription());
			pstTermOfPayment.setInt(CL_DUE, termofpayment.getDue());
			pstTermOfPayment.setInt(CL_QTY_DISC, termofpayment.getQtyDisc());
			pstTermOfPayment.setInt(CL_DISC_PERCENT, termofpayment.getDiscPercent());

			pstTermOfPayment.insert(); 
			termofpayment.setOID(pstTermOfPayment.getlong(CL_TERM_OF_PAYMENT_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTermOfPayment(0),CONException.UNKNOWN); 
		}
		return termofpayment.getOID();
	}

	public static long updateExc(TermOfPayment termofpayment) throws CONException{ 
		try{ 
			if(termofpayment.getOID() != 0){ 
				DbTermOfPayment pstTermOfPayment = new DbTermOfPayment(termofpayment.getOID());

				pstTermOfPayment.setString(CL_DESCRIPTION, termofpayment.getDescription());
				pstTermOfPayment.setInt(CL_DUE, termofpayment.getDue());
				pstTermOfPayment.setInt(CL_QTY_DISC, termofpayment.getQtyDisc());
				pstTermOfPayment.setInt(CL_DISC_PERCENT, termofpayment.getDiscPercent());

				pstTermOfPayment.update(); 
				return termofpayment.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTermOfPayment(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbTermOfPayment pstTermOfPayment = new DbTermOfPayment(oid);
			pstTermOfPayment.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTermOfPayment(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_TERM_OF_PAYMENT; 
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
				TermOfPayment termofpayment = new TermOfPayment();
				resultToObject(rs, termofpayment);
				lists.add(termofpayment);
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

	private static void resultToObject(ResultSet rs, TermOfPayment termofpayment){
		try{
			termofpayment.setOID(rs.getLong(DbTermOfPayment.colNames[DbTermOfPayment.CL_TERM_OF_PAYMENT_ID]));
			termofpayment.setDescription(rs.getString(DbTermOfPayment.colNames[DbTermOfPayment.CL_DESCRIPTION]));
			termofpayment.setDue(rs.getInt(DbTermOfPayment.colNames[DbTermOfPayment.CL_DUE]));
			termofpayment.setQtyDisc(rs.getInt(DbTermOfPayment.colNames[DbTermOfPayment.CL_QTY_DISC]));
			termofpayment.setDiscPercent(rs.getInt(DbTermOfPayment.colNames[DbTermOfPayment.CL_DISC_PERCENT]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long termOfPaymentId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_TERM_OF_PAYMENT + " WHERE " + 
						DbTermOfPayment.colNames[DbTermOfPayment.CL_TERM_OF_PAYMENT_ID] + " = " + termOfPaymentId;

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
			String sql = "SELECT COUNT("+ DbTermOfPayment.colNames[DbTermOfPayment.CL_TERM_OF_PAYMENT_ID] + ") FROM " + DB_TERM_OF_PAYMENT;
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
			  	   TermOfPayment termofpayment = (TermOfPayment)list.get(ls);
				   if(oid == termofpayment.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
      
        
}
