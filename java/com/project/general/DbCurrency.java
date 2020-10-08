

package com.project.general; 

/* package java */ 
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.entity.*;
import com.project.main.db.*;

public class DbCurrency extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_CURRENCY = "currency";

	public static final  int COL_CURRENCY_CODE = 0;
	public static final  int COL_DESCRIPTION = 1;
	public static final  int COL_CURRENCY_ID = 2;
        public static final  int COL_RATE = 3;
        public static final  int COL_COA_ID = 4;

	public static final  String[] colNames = {
		"currency_code",
		"description",
		"currency_id",
                "rate",
                "coa_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG + TYPE_PK + TYPE_ID,
                TYPE_FLOAT,
                TYPE_LONG
	 }; 

	public DbCurrency(){
	}

	public DbCurrency(int i) throws CONException { 
		super(new DbCurrency()); 
	}

	public DbCurrency(String sOid) throws CONException { 
		super(new DbCurrency(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbCurrency(long lOid) throws CONException { 
		super(new DbCurrency(0)); 
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
		return DB_CURRENCY;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbCurrency().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Currency currency = fetchExc(ent.getOID()); 
		ent = (Entity)currency;  
		return currency.getOID();  
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Currency) ent);  
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Currency) ent);  
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Currency fetchExc(long oid) throws CONException{ 
		try{ 
			Currency currency = new Currency();
			DbCurrency pstCurrency = new DbCurrency(oid); 
			currency.setOID(oid);

			currency.setCurrencyCode(pstCurrency.getString(COL_CURRENCY_CODE));
			currency.setDescription(pstCurrency.getString(COL_DESCRIPTION));
                        currency.setRate(pstCurrency.getdouble(COL_RATE));
                        currency.setCoaId(pstCurrency.getlong(COL_COA_ID));

			return currency; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCurrency(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Currency currency) throws CONException{ 
		try{ 
			DbCurrency pstCurrency = new DbCurrency(0);

			pstCurrency.setString(COL_CURRENCY_CODE, currency.getCurrencyCode());
			pstCurrency.setString(COL_DESCRIPTION, currency.getDescription());
                        pstCurrency.setDouble(COL_RATE, currency.getRate());                        
                        pstCurrency.setLong(COL_COA_ID, currency.getCoaId());

			pstCurrency.insert(); 
			currency.setOID(pstCurrency.getlong(COL_CURRENCY_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCurrency(0),CONException.UNKNOWN); 
		}
		return currency.getOID();
	}

	public static long updateExc(Currency currency) throws CONException{ 
		try{ 
			if(currency.getOID() != 0){ 
				
                                DbCurrency pstCurrency = new DbCurrency(currency.getOID());
				pstCurrency.setString(COL_CURRENCY_CODE, currency.getCurrencyCode());
				pstCurrency.setString(COL_DESCRIPTION, currency.getDescription());
                                pstCurrency.setDouble(COL_RATE, currency.getRate());
                                pstCurrency.setLong(COL_COA_ID, currency.getCoaId());

				pstCurrency.update(); 
				return currency.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCurrency(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbCurrency pstCurrency = new DbCurrency(oid);
			pstCurrency.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbCurrency(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CURRENCY; 
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
				Currency currency = new Currency();
				resultToObject(rs, currency);
				lists.add(currency);
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

	private static void resultToObject(ResultSet rs, Currency currency){
		try{
			currency.setOID(rs.getLong(DbCurrency.colNames[DbCurrency.COL_CURRENCY_ID]));
			currency.setCurrencyCode(rs.getString(DbCurrency.colNames[DbCurrency.COL_CURRENCY_CODE]));
			currency.setDescription(rs.getString(DbCurrency.colNames[DbCurrency.COL_DESCRIPTION]));
                        currency.setRate(rs.getDouble(DbCurrency.colNames[DbCurrency.COL_RATE]));
                        currency.setCoaId(rs.getLong(DbCurrency.colNames[DbCurrency.COL_COA_ID]));
		}catch(Exception e){ }
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbCurrency.colNames[DbCurrency.COL_CURRENCY_ID] + ") FROM " + DB_CURRENCY;
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
			  	   Currency currency = (Currency)list.get(ls);
				   if(oid == currency.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static Currency getCurrencyByCode(String code){
               Vector v = list(0,0, colNames[COL_CURRENCY_CODE]+"='"+code+"'", ""); 
               if(v!=null && v.size()==1){
                   return (Currency)v.get(0);
               }
               return new Currency();
        }
        
        public static Currency getCurrencyById(long oidCurrency){
            if(oidCurrency!=0){
                try{
                    return fetchExc(oidCurrency);
                }
                catch(Exception e){
                    
                }
            }            
            return new Currency();
        }
        
}
