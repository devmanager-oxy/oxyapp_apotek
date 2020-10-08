
package com.project.ccs.postransaction.stock; 


import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.*;
import com.project.util.*;

public class DbStockPeriode extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_PERIODE = "stock_stockPeriode";

	public static final  int COL_STOCK_PERIODE_ID = 0;
	public static final  int COL_START_DATE = 1;
	public static final  int COL_END_DATE = 2;
	public static final  int COL_STATUS = 3;
	public static final  int COL_NAME = 4;
       

	public static final  String[] colNames = {
		"stockPeriode_id",
		"start_date",
		"end_date",
		"status",
		"name"
                
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING
                
	 };
	 
	public static int TYPE_PERIOD_REGULAR = 0;
	public static int TYPE_PERIOD13 = 1;  
	public static int TYPE_PERIOD_PRECLOSED = 2;	

	public DbStockPeriode(){
	}

	public DbStockPeriode(int i) throws CONException { 
		super(new DbStockPeriode()); 
	}

	public DbStockPeriode(String sOid) throws CONException { 
		super(new DbStockPeriode(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbStockPeriode(long lOid) throws CONException { 
		super(new DbStockPeriode(0)); 
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
		return new DbStockPeriode().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		StockPeriode stockPeriode = fetchExc(ent.getOID()); 
		ent = (Entity)stockPeriode; 
		return stockPeriode.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((StockPeriode) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((StockPeriode) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static StockPeriode fetchExc(long oid) throws CONException{ 
		try{ 
			StockPeriode stockPeriode = new StockPeriode();
			DbStockPeriode dbPeriode = new DbStockPeriode(oid); 
			stockPeriode.setOID(oid);

			stockPeriode.setStartDate(dbPeriode.getDate(COL_START_DATE));
			stockPeriode.setEndDate(dbPeriode.getDate(COL_END_DATE));
			stockPeriode.setStatus(dbPeriode.getString(COL_STATUS));
			stockPeriode.setName(dbPeriode.getString(COL_NAME));
            

			return stockPeriode; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStockPeriode(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(StockPeriode stockPeriode) throws CONException{ 
		try{ 
			DbStockPeriode dbPeriode = new DbStockPeriode(0);

			dbPeriode.setDate(COL_START_DATE, stockPeriode.getStartDate());
			dbPeriode.setDate(COL_END_DATE, stockPeriode.getEndDate());
			dbPeriode.setString(COL_STATUS, stockPeriode.getStatus());
			dbPeriode.setString(COL_NAME, stockPeriode.getName());
            

			dbPeriode.insert(); 
			stockPeriode.setOID(dbPeriode.getlong(COL_STOCK_PERIODE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStockPeriode(0),CONException.UNKNOWN); 
		}
		return stockPeriode.getOID();
	}

	public static long updateExc(StockPeriode stockPeriode) throws CONException{ 
		try{ 
			if(stockPeriode.getOID() != 0){ 
				DbStockPeriode dbPeriode = new DbStockPeriode(stockPeriode.getOID());

				dbPeriode.setDate(COL_START_DATE, stockPeriode.getStartDate());
				dbPeriode.setDate(COL_END_DATE, stockPeriode.getEndDate());
				dbPeriode.setString(COL_STATUS, stockPeriode.getStatus());
				dbPeriode.setString(COL_NAME, stockPeriode.getName());
                

				dbPeriode.update(); 
				return stockPeriode.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStockPeriode(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbStockPeriode dbPeriode = new DbStockPeriode(oid);
			dbPeriode.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbStockPeriode(0),CONException.UNKNOWN); 
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
				StockPeriode stockPeriode = new StockPeriode();
				resultToObject(rs, stockPeriode);
				lists.add(stockPeriode);
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

	private static void resultToObject(ResultSet rs, StockPeriode stockPeriode){
		try{
			stockPeriode.setOID(rs.getLong(DbStockPeriode.colNames[DbStockPeriode.COL_STOCK_PERIODE_ID]));
			stockPeriode.setStartDate(rs.getDate(DbStockPeriode.colNames[DbStockPeriode.COL_START_DATE]));
			stockPeriode.setEndDate(rs.getDate(DbStockPeriode.colNames[DbStockPeriode.COL_END_DATE]));
			stockPeriode.setStatus(rs.getString(DbStockPeriode.colNames[DbStockPeriode.COL_STATUS]));
			stockPeriode.setName(rs.getString(DbStockPeriode.colNames[DbStockPeriode.COL_NAME]));
            

		}catch(Exception e){ }
	}

	public static boolean checkOID(long periodeId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PERIODE + " WHERE " + 
						DbStockPeriode.colNames[DbStockPeriode.COL_STOCK_PERIODE_ID] + " = " + periodeId;

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
			String sql = "SELECT COUNT("+ DbStockPeriode.colNames[DbStockPeriode.COL_STOCK_PERIODE_ID] + ") FROM " + DB_PERIODE;
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
			  	   StockPeriode stockPeriode = (StockPeriode)list.get(ls);
				   if(oid == stockPeriode.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
       
        
      
        
        
        
//        public static Date getOpenPeriodLastYear(){
//            
//            StockPeriode stockPeriode = getOpenPeriod();
//            
//            Date opnPeriode = stockPeriode.getStartDate();
//            
//            int dt = opnPeriode.getDate();
//            int mnth = opnPeriode.getMonth()+1;
//            int year = opnPeriode.getYear()+1900-1;
//            
//            String date = ""+year+"-"+mnth+"-"+dt;
//            
//            Date dt_date = JSPFormater.formatDate(date,"yyyy-MM-dd");
//            
//            if(dt_date != null ){
//                return dt_date;
//            }else{            
//                return null;
//            }
//        }
        
        
//        public static StockPeriode getOpnPeriodLastYear(){
//            
//            StockPeriode stockPeriode = getOpenPeriod();
//            
//            Date opnPeriode = stockPeriode.getStartDate();
//            
//            int dt = opnPeriode.getDate();
//            int mnth = opnPeriode.getMonth()+1;
//            int year = opnPeriode.getYear()+1900-1;
//            
//            String date = ""+year+"-"+mnth+"-"+dt;
//            
//            String where = DbStockPeriode.colNames[DbStockPeriode.COL_START_DATE]+" = '"+date+"'";
//            
//            Vector v = DbStockPeriode.list(0,0, where, "");
//                
//            if(v!=null && v.size()>0){
//                return (StockPeriode)v.get(0);    
//            }
//            
//            return null;
//            
//        }
//        
        
      
        
        
      
        
       
       
        
        public static StockPeriode getPreClosedPeriod(){
        	
        	Vector temp = list(0,0, colNames[COL_STATUS]+"='"+I_Project.STATUS_PERIOD_PRE_CLOSED+"'", "");
        	if(temp!=null && temp.size()>0){        	
        		return (StockPeriode)temp.get(0);	
        	}
        	
        	return new StockPeriode();
        	
        }
        
		
		/* close period bisa handle, stockPeriode yang di pre-setup (jan-des dibuat dahulu dengan memberi 
		 * status STATUS_PERIOD_PREPARED_OPEN, ketika closing stockPeriode, system akan mencari stockPeriode 
		 * dengan STATUS_PERIOD_PREPARED_OPEN untuk diupdate statusnya ke OPEN, dan mengupdate status
		 * stockPeriode lama ke CLOSED.
		 * tetapi apabila customer tidak melakukan pre-setup stockPeriode (stockPeriode dibuat saat close stockPeriode
		 * dilakukan, maka system akan membuat stockPeriode baru ketika pencarian stockPeriode dengan status
		 * STATUS_PERIOD_PREPARED_OPEN tidak ditemukan.		 
		 **/
        
        	
        	
        /* close period bisa handle, stockPeriode yang di pre-setup (jan-des dibuat dahulu dengan memberi 
		 * status STATUS_PERIOD_PREPARED_OPEN, ketika closing stockPeriode, system akan mencari stockPeriode 
		 * dengan STATUS_PERIOD_PREPARED_OPEN untuk diupdate statusnya ke OPEN, dan mengupdate status
		 * stockPeriode lama ke CLOSED.
		 * tetapi apabila customer tidak melakukan pre-setup stockPeriode (stockPeriode dibuat saat close stockPeriode
		 * dilakukan, maka system akan membuat stockPeriode baru ketika pencarian stockPeriode dengan status
		 * STATUS_PERIOD_PREPARED_OPEN tidak ditemukan.		 
		 **/
         	
        
       
        	  
        
        public static StockPeriode getPrevPeriode(StockPeriode stockPeriode){
            
            Date startDate = stockPeriode.getStartDate();
            Date xDate = (Date)startDate.clone();
            xDate.setDate(xDate.getDate()-10);
            
            String where = "('"+JSPFormater.formatDate(xDate, "yyyy-MM-dd")+"' between " +
                colNames[COL_START_DATE]+" and "+colNames[COL_END_DATE];
            
            Vector v = DbStockPeriode.list(0,0, where, "");
            if(v!=null && v.size()>0){
                return (StockPeriode)v.get(0);
            }
            
            return new StockPeriode();
            
        }
        
        public static StockPeriode getNextPeriode(StockPeriode openPeriod){
            
            Date endDate = openPeriod.getEndDate();
            Date xDate = (Date)endDate.clone();
            xDate.setDate(xDate.getDate()+10);
            
            String where = "('" + JSPFormater.formatDate(xDate, "yyyy-MM-dd")+"' BETWEEN " + colNames[COL_START_DATE]+" AND "+colNames[COL_END_DATE] + ")" +
                " AND " + colNames[COL_STATUS] + " = '" + I_Project.STATUS_PERIOD_PREPARED_OPEN + "'";
            System.out.println("getNextPeriode(#) where: "+where);
            Vector v = DbStockPeriode.list(0,0, where, "");
            if(v!=null && v.size()>0){
                return (StockPeriode)v.get(0);
            }
            
            return new StockPeriode();
            
        }
        
        /**
         * @Author  Roy Andika
         * @param   stockPeriode
         * @return
         */
        public static StockPeriode getLastYearOpenPeriod(StockPeriode stockPeriode){
            
            int date = stockPeriode.getStartDate().getDate() + 1;
            int month = stockPeriode.getStartDate().getMonth() + 1;
            int year = stockPeriode.getStartDate().getYear() + 1900 - 1;
            
            try{
                
                String str_previous_stockPeriode = ""+year+"-"+month+"-"+date;
                
                String where = DbStockPeriode.colNames[DbStockPeriode.COL_START_DATE]+" = '"+str_previous_stockPeriode+"'";
                
                Vector list_period_lastYear = DbStockPeriode.list(0, 1, where, null);
                
                if(list_period_lastYear != null && list_period_lastYear.size() > 0){
                    
                    StockPeriode objPeriode = (StockPeriode)list_period_lastYear.get(0);
                    return objPeriode;
                    
                }
                
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }
            
            return null;
        }
        
        
}

