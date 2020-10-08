
package com.project.ccs.posmaster; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.util.lang.I_Language;
import com.project.ccs.posmaster.*; 

public class DbUom extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_UOM = "pos_unit";

	public static final  int COL_UOM_ID = 0;
	public static final  int COL_UNIT = 1;

	public static final  String[] colNames = {
		"uom_id",
		"unit"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING
	 }; 

	public DbUom(){
	}

	public DbUom(int i) throws CONException { 
		super(new DbUom()); 
	}

	public DbUom(String sOid) throws CONException { 
		super(new DbUom(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbUom(long lOid) throws CONException { 
		super(new DbUom(0)); 
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
		return DB_UOM;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbUom().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Uom uom = fetchExc(ent.getOID()); 
		ent = (Entity)uom; 
		return uom.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Uom) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Uom) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Uom fetchExc(long oid) throws CONException{ 
		try{ 
			Uom uom = new Uom();
			DbUom pstUom = new DbUom(oid); 
			uom.setOID(oid);

			uom.setUnit(pstUom.getString(COL_UNIT));

			return uom; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbUom(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Uom uom) throws CONException{ 
		try{ 
			DbUom pstUom = new DbUom(0);

			pstUom.setString(COL_UNIT, uom.getUnit());

			pstUom.insert(); 
			uom.setOID(pstUom.getlong(COL_UOM_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbUom(0),CONException.UNKNOWN); 
		}
		return uom.getOID();
	}

	public static long updateExc(Uom uom) throws CONException{ 
		try{ 
			if(uom.getOID() != 0){ 
				DbUom pstUom = new DbUom(uom.getOID());

				pstUom.setString(COL_UNIT, uom.getUnit());

				pstUom.update(); 
				return uom.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbUom(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbUom pstUom = new DbUom(oid);
			pstUom.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbUom(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_UOM; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
                        
                        switch (CONHandler.CONSVR_TYPE) {
                            case CONHandler.CONSVR_MYSQL:
                                if (limitStart == 0 && recordToGet == 0) {
                                    sql = sql + "";
                                } else {
                                    sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                                }
                                break;

                            case CONHandler.CONSVR_POSTGRESQL:
                                if (limitStart == 0 && recordToGet == 0) {
                                    sql = sql + "";
                                } else {
                                    sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                                }

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
				Uom uom = new Uom();
				resultToObject(rs, uom);
				lists.add(uom);
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

	public static void resultToObject(ResultSet rs, Uom uom){
		try{
			uom.setOID(rs.getLong(DbUom.colNames[DbUom.COL_UOM_ID]));
			uom.setUnit(rs.getString(DbUom.colNames[DbUom.COL_UNIT]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long uomId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_UOM + " WHERE " + 
						DbUom.colNames[DbUom.COL_UOM_ID] + " = " + uomId;

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
			String sql = "SELECT COUNT("+ DbUom.colNames[DbUom.COL_UOM_ID] + ") FROM " + DB_UOM;
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
			  	   Uom uom = (Uom)list.get(ls);
				   if(oid == uom.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
