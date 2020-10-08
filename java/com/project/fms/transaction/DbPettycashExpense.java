
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.project.fms.transaction; 

/* package java */ 
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

/* package qdep */
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.fms.transaction.*;

public class DbPettycashExpense extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_PETTYCASH_EXPENSES = "pettycash_expenses";

	public static final  int COL_PETTYCASH_EXPENSE_ID = 0;
	public static final  int COL_PETTYCASH_REPLENISHMENT_ID = 1;
	public static final  int COL_PETTYCASH_PAYMENT_ID = 2;
	public static final  int COL_AMOUNT = 3;

	public static final  String[] colNames = {
		"pettycash_expense_id",		
		"pettycash_replenishment_id",
		"pettycash_payment_id",
		"amount"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT
	 }; 

	public DbPettycashExpense(){
	}

	public DbPettycashExpense(int i) throws CONException { 
		super(new DbPettycashExpense()); 
	}

	public DbPettycashExpense(String sOid) throws CONException { 
		super(new DbPettycashExpense(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbPettycashExpense(long lOid) throws CONException { 
		super(new DbPettycashExpense(0)); 
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
		return DB_PETTYCASH_EXPENSES;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbPettycashExpense().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		PettycashExpense pettycashexpense = fetchExc(ent.getOID()); 
		ent = (Entity)pettycashexpense; 
		return pettycashexpense.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((PettycashExpense) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((PettycashExpense) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static PettycashExpense fetchExc(long oid) throws CONException{ 
		try{ 
			PettycashExpense pettycashexpense = new PettycashExpense();
			DbPettycashExpense pstPettycashExpense = new DbPettycashExpense(oid); 
			pettycashexpense.setOID(oid);

			pettycashexpense.setPettycashReplenishmentId(pstPettycashExpense.getlong(COL_PETTYCASH_REPLENISHMENT_ID));
			pettycashexpense.setPettycashPaymentId(pstPettycashExpense.getlong(COL_PETTYCASH_PAYMENT_ID));
			pettycashexpense.setAmount(pstPettycashExpense.getdouble(COL_AMOUNT));

			return pettycashexpense; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPettycashExpense(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(PettycashExpense pettycashexpense) throws CONException{ 
		try{ 
			DbPettycashExpense pstPettycashExpense = new DbPettycashExpense(0);

			pstPettycashExpense.setLong(COL_PETTYCASH_REPLENISHMENT_ID, pettycashexpense.getPettycashReplenishmentId());
			pstPettycashExpense.setLong(COL_PETTYCASH_PAYMENT_ID, pettycashexpense.getPettycashPaymentId());
			pstPettycashExpense.setDouble(COL_AMOUNT, pettycashexpense.getAmount());

			pstPettycashExpense.insert(); 
			pettycashexpense.setOID(pstPettycashExpense.getlong(COL_PETTYCASH_EXPENSE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPettycashExpense(0),CONException.UNKNOWN); 
		}
		return pettycashexpense.getOID();
	}

	public static long updateExc(PettycashExpense pettycashexpense) throws CONException{ 
		try{ 
			if(pettycashexpense.getOID() != 0){ 
				DbPettycashExpense pstPettycashExpense = new DbPettycashExpense(pettycashexpense.getOID());

				pstPettycashExpense.setLong(COL_PETTYCASH_REPLENISHMENT_ID, pettycashexpense.getPettycashReplenishmentId());
				pstPettycashExpense.setLong(COL_PETTYCASH_PAYMENT_ID, pettycashexpense.getPettycashPaymentId());
				pstPettycashExpense.setDouble(COL_AMOUNT, pettycashexpense.getAmount());

				pstPettycashExpense.update(); 
				return pettycashexpense.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPettycashExpense(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbPettycashExpense pstPettycashExpense = new DbPettycashExpense(oid);
			pstPettycashExpense.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbPettycashExpense(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PETTYCASH_EXPENSES; 
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
				PettycashExpense pettycashexpense = new PettycashExpense();
				resultToObject(rs, pettycashexpense);
				lists.add(pettycashexpense);
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

	private static void resultToObject(ResultSet rs, PettycashExpense pettycashexpense){
		try{
			pettycashexpense.setOID(rs.getLong(DbPettycashExpense.colNames[DbPettycashExpense.COL_PETTYCASH_EXPENSE_ID]));
			pettycashexpense.setPettycashReplenishmentId(rs.getLong(DbPettycashExpense.colNames[DbPettycashExpense.COL_PETTYCASH_REPLENISHMENT_ID]));
			pettycashexpense.setPettycashPaymentId(rs.getLong(DbPettycashExpense.colNames[DbPettycashExpense.COL_PETTYCASH_PAYMENT_ID]));
			pettycashexpense.setAmount(rs.getDouble(DbPettycashExpense.colNames[DbPettycashExpense.COL_AMOUNT]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long pettycashExpenseId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PETTYCASH_EXPENSES + " WHERE " + 
						DbPettycashExpense.colNames[DbPettycashExpense.COL_PETTYCASH_EXPENSE_ID] + " = " + pettycashExpenseId;

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
			String sql = "SELECT COUNT("+ DbPettycashExpense.colNames[DbPettycashExpense.COL_PETTYCASH_EXPENSE_ID] + ") FROM " + DB_PETTYCASH_EXPENSES;
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
			  	   PettycashExpense pettycashexpense = (PettycashExpense)list.get(ls);
				   if(oid == pettycashexpense.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static void insertExpenses(long oid, Vector openPaymants){
            
            if(oid!=0 && openPaymants!=null && openPaymants.size()>0){
                for(int i=0; i<openPaymants.size(); i++){
                    PettycashPayment py = (PettycashPayment)openPaymants.get(i);
                    
                    PettycashExpense pe = new PettycashExpense();
                    pe.setPettycashPaymentId(py.getOID());
                    pe.setAmount(py.getAmount());                    
                    pe.setPettycashReplenishmentId(oid);
                    try{
                        DbPettycashExpense.insertExc(pe);
                    }
                    catch(Exception e){
                        
                    }
                }
            }
            
        }
        
        
}
