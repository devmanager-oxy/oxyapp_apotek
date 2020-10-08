/***********************************\
|  Create by rahde               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  03/11/2011 9:58:07 AM
\***********************************/

package com.project.ccs.postransaction.sales;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;
import com.project.ccs.postransaction.sales.*;


public class DbReturnPayment extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

	public static final  String DB_RETURN_PAYMENT = "pos_return_payment";

	public static final  int COL_RETURN_PAYMENT_ID = 0;
	public static final  int COL_SALES_ID = 1;
	public static final  int COL_CURRENCY_ID = 2;
	public static final  int COL_AMOUNT = 3;
	
	

	public static final  String[] colNames = {
		"return_payment_id",
		"sales_id",
		"currency_id",
		"amount"
		
		
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT
		
	};

	public DbReturnPayment(){
	}

	public DbReturnPayment(int i) throws CONException {
		super(new DbReturnPayment());
	}

	public DbReturnPayment(String sOid) throws CONException {
		super(new DbReturnPayment(0));
		if(!locate(sOid))
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		else
			return;
	}

	public DbReturnPayment(long lOid) throws CONException {
		super(new DbReturnPayment(0));
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
		return DB_RETURN_PAYMENT;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbReturnPayment().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception {
		ReturnPayment returnPayment = fetchExc(ent.getOID());
		ent = (Entity)returnPayment;
		return returnPayment.getOID();
	}

	public long insertExc(Entity ent) throws Exception {
		return insertExc((Payment) ent);
	}

	public long updateExc(Entity ent) throws Exception {
		return updateExc((Payment) ent);
	}

	public long deleteExc(Entity ent) throws Exception {
		if(ent==null){
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		}
			return deleteExc(ent.getOID());
	}

	public static ReturnPayment fetchExc(long oid) throws CONException{
		try{
			ReturnPayment returnPayment = new ReturnPayment();
			DbReturnPayment dbReturnPayment = new DbReturnPayment(oid);
			returnPayment.setOID(oid);

			returnPayment.setSales_id(dbReturnPayment.getlong(COL_SALES_ID));
			returnPayment.setCurrency_id(dbReturnPayment.getlong(COL_CURRENCY_ID)); 
			returnPayment.setAmount(dbReturnPayment.getdouble(COL_AMOUNT)); 
					
                        
			return returnPayment;
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbReturnPayment(0),CONException.UNKNOWN);
		}
	}

	public static long insertExc(ReturnPayment returnPayment) throws CONException{
		try{
			DbReturnPayment dbReturnPayment = new DbReturnPayment(0);

			dbReturnPayment.setLong(COL_SALES_ID, returnPayment.getSales_id());
			dbReturnPayment.setLong(COL_CURRENCY_ID, returnPayment.getCurrency_id());
			dbReturnPayment.setDouble(COL_AMOUNT, returnPayment.getAmount());
					
                        dbReturnPayment.insert();
			returnPayment.setOID(dbReturnPayment.getlong(COL_RETURN_PAYMENT_ID));
                        
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbSalesDetail(0),CONException.UNKNOWN);
		}
		return returnPayment.getOID();
	}

	public static long updateExc(ReturnPayment returnPayment) throws CONException{
		try{
			if(returnPayment.getOID() != 0){
                            DbReturnPayment dbReturnPayment = new DbReturnPayment(returnPayment.getOID());

                            dbReturnPayment.setLong(COL_SALES_ID, returnPayment.getSales_id());
                            dbReturnPayment.setLong(COL_CURRENCY_ID, returnPayment.getCurrency_id());
                            dbReturnPayment.setDouble(COL_AMOUNT, returnPayment.getAmount());
				                                
                            dbReturnPayment.update();
                            return returnPayment.getOID();

			}
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbReturnPayment(0),CONException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{
		try{
			DbReturnPayment dbReturnPayment = new DbReturnPayment(oid);
			dbReturnPayment.delete();
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbReturnPayment(0),CONException.UNKNOWN);
		}
		return oid;
	}

	public static Vector listAll()
	{
		return list(0, 500, "","");
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector();
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_RETURN_PAYMENT ;
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
				ReturnPayment returnPayment = new ReturnPayment();
				resultToObject(rs, returnPayment);
				lists.add(returnPayment);
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

	private static void resultToObject(ResultSet rs, ReturnPayment returnPayment){
		try{
			returnPayment.setOID(rs.getLong(DbReturnPayment.colNames[DbReturnPayment.COL_RETURN_PAYMENT_ID]));
			returnPayment.setSales_id(rs.getLong(DbReturnPayment.colNames[DbReturnPayment.COL_SALES_ID]));
			returnPayment.setCurrency_id(rs.getLong(DbReturnPayment.colNames[DbReturnPayment.COL_CURRENCY_ID]));
			returnPayment.setAmount(rs.getDouble(DbReturnPayment.colNames[DbReturnPayment.COL_AMOUNT]));
		                        
		}catch(Exception e){ }
	}

	public static boolean checkOID(long paymentId)
	{
		CONResultSet dbrs = null;
		boolean result = false;
		try
		{
			String sql = "SELECT * FROM " + DB_RETURN_PAYMENT + " WHERE " + 
			DbReturnPayment.colNames[DbReturnPayment.COL_RETURN_PAYMENT_ID] + " = " + paymentId;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) { result = true; }
			rs.close();
		}
		catch(Exception e)
		{
			System.out.println("err : "+e.toString());
		}
		finally
		{
			CONResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbReturnPayment.colNames[DbReturnPayment.COL_RETURN_PAYMENT_ID] + ") FROM " + DB_RETURN_PAYMENT;
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
				SalesDetail salesDetail = (SalesDetail)list.get(ls);
				if(oid == salesDetail.getOID())
					found=true;
				}
			}
		}
		if((start >= size) && (size > 0))
			start = start - recordToGet;

		return start;
	}

       // public static int getMaxSquence(long salesId){
       //         int result = 0;                
        //        CONResultSet dbrs = null;
        //        try{
         //           String sql = "select max(squence) from "+DB_SALES_DETAIL+" where "+
         //               " sales_id='"+salesId+"' ";
                    
         //           System.out.println(sql);
                    
         //           dbrs = CONHandler.execQueryResult(sql);
          //          ResultSet rs = dbrs.getResultSet();
           //         while(rs.next()){
          //              result = rs.getInt(1);
          //          }                    
           //         if(result==0){
          //              result = result + 1;
           //         }
           //         else{
           //             result = result + 1;
          //          }
                    
          //      }
          //      catch(Exception e){
          //          System.out.println(e);
          //      }
          //      finally{
          //          CONResultSet.close(dbrs);
           //     }
                
          //      return result;
       // }          
        
        /*
        public static double getSubTotalSalesAmount(long proposalId){ 
            double result = 0;
            
            String sql = "select sum("+colNames[COL_TOTAL]+") from "+DB_SALES_DETAIL+
                " where "+colNames[COL_PROPOSAL_ID]+"="+proposalId;
            
            CONResultSet crs = null;    
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
        }
         */
                        
        //public static double getSubTotalSalesAmount(long salesId){ 
        //    double result = 0;
            
        //    String sql = "select sum("+colNames[COL_TOTAL]+") from "+DB_SALES_DETAIL+
        //        " where "+colNames[COL_SALES_ID]+"="+salesId;
        //    
         //   CONResultSet crs = null;    
        //    try{
        //        crs = CONHandler.execQueryResult(sql);
        //        ResultSet rs = crs.getResultSet();
         //       while(rs.next()){
         //           result = rs.getDouble(1);
         //       }
         //   }
         //   catch(Exception e){
        //    }
        //    finally{
        //        CONResultSet.close(crs);
         //   }
            
       //     return result;
       // }
        
       // public static void deleteDocSales(long salesId){
       //     try{
       //         String sql = "delete from "+DB_SALES_DETAIL+" where "+colNames[COL_SALES_ID]+"="+salesId;
       //         CONHandler.execUpdate(sql);
       //     }
       //     catch(Exception e){
                
       //     }
      //  }
        
}
