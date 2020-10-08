/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.property;
import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.util.*;
/**
 *
 * @author Roy Andika
 */
public class DbSewaTanahKomperProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
        public static final  String DB_PROP_SEWA_TANAH_KOMPER = "prop_sewa_tanah_komper";

	public static final  int COL_SEWA_TANAH_KOMPER_ID = 0;
	public static final  int COL_KATEGORI = 1;
	public static final  int COL_PERSENTASE = 2;
	public static final  int COL_SEWA_TANAH_ID = 3;
	
	public static final  String[] colNames = {
		"sewa_tanah_komper_id",
		"kategori",
		"persentase",
		"sewa_tanah_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_LONG
	 }; 

	public DbSewaTanahKomperProp(){
	}

	public DbSewaTanahKomperProp(int i) throws CONException { 
		super(new DbSewaTanahKomperProp()); 
	}

	public DbSewaTanahKomperProp(String sOid) throws CONException { 
		super(new DbSewaTanahKomperProp(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSewaTanahKomperProp(long lOid) throws CONException { 
		super(new DbSewaTanahKomperProp(0)); 
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
		return DB_PROP_SEWA_TANAH_KOMPER;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSewaTanahKomperProp().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SewaTanahKomperProp sewaTanahKomperProp = fetchExc(ent.getOID()); 
		ent = (Entity)sewaTanahKomperProp; 
		return sewaTanahKomperProp.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SewaTanahKomperProp) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SewaTanahKomperProp) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SewaTanahKomperProp fetchExc(long oid) throws CONException{ 
		try{ 
			SewaTanahKomperProp sewaTanahKomperProp = new SewaTanahKomperProp();
			DbSewaTanahKomperProp pstSewaTanahKomperProp = new DbSewaTanahKomperProp(oid); 
			sewaTanahKomperProp.setOID(oid);

			sewaTanahKomperProp.setKategori(pstSewaTanahKomperProp.getInt(COL_KATEGORI));
			sewaTanahKomperProp.setPersentase(pstSewaTanahKomperProp.getdouble(COL_PERSENTASE));
			sewaTanahKomperProp.setSewaTanahId(pstSewaTanahKomperProp.getlong(COL_SEWA_TANAH_ID));
			
			return sewaTanahKomperProp; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomperProp(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SewaTanahKomperProp sewaTanahKomperProp) throws CONException{ 
		try{ 
			DbSewaTanahKomperProp pstSewaTanahKomperProp = new DbSewaTanahKomperProp(0);

			pstSewaTanahKomperProp.setInt(COL_KATEGORI, sewaTanahKomperProp.getKategori());
			pstSewaTanahKomperProp.setDouble(COL_PERSENTASE, sewaTanahKomperProp.getPersentase());
			pstSewaTanahKomperProp.setLong(COL_SEWA_TANAH_ID, sewaTanahKomperProp.getSewaTanahId());
			
			pstSewaTanahKomperProp.insert(); 
			sewaTanahKomperProp.setOID(pstSewaTanahKomperProp.getlong(COL_SEWA_TANAH_KOMPER_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomperProp(0),CONException.UNKNOWN); 
		}
		return sewaTanahKomperProp.getOID();
	}

	public static long updateExc(SewaTanahKomperProp sewaTanahKomperProp) throws CONException{ 
		try{ 
			if(sewaTanahKomperProp.getOID() != 0){ 
				DbSewaTanahKomperProp pstSewaTanahKomperProp = new DbSewaTanahKomperProp(sewaTanahKomperProp.getOID());

				pstSewaTanahKomperProp.setInt(COL_KATEGORI, sewaTanahKomperProp.getKategori());
				pstSewaTanahKomperProp.setDouble(COL_PERSENTASE, sewaTanahKomperProp.getPersentase());
				pstSewaTanahKomperProp.setLong(COL_SEWA_TANAH_ID, sewaTanahKomperProp.getSewaTanahId());
				
				pstSewaTanahKomperProp.update(); 
				return sewaTanahKomperProp.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomperProp(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSewaTanahKomperProp pstSewaTanahKomperProp = new DbSewaTanahKomperProp(oid);
			pstSewaTanahKomperProp.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomperProp(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_KOMPER; 
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
				SewaTanahKomperProp sewaTanahKomperProp = new SewaTanahKomperProp();
				resultToObject(rs, sewaTanahKomperProp);
				lists.add(sewaTanahKomperProp);
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

	private static void resultToObject(ResultSet rs, SewaTanahKomperProp sewaTanahKomperProp){
		try{
			sewaTanahKomperProp.setOID(rs.getLong(DbSewaTanahKomperProp.colNames[DbSewaTanahKomperProp.COL_SEWA_TANAH_KOMPER_ID]));
			sewaTanahKomperProp.setKategori(rs.getInt(DbSewaTanahKomperProp.colNames[DbSewaTanahKomperProp.COL_KATEGORI]));
			sewaTanahKomperProp.setPersentase(rs.getDouble(DbSewaTanahKomperProp.colNames[DbSewaTanahKomperProp.COL_PERSENTASE]));
			sewaTanahKomperProp.setSewaTanahId(rs.getLong(DbSewaTanahKomperProp.colNames[DbSewaTanahKomperProp.COL_SEWA_TANAH_ID]));
			
		}catch(Exception e){ }
	}

	public static boolean checkOID(long sewaTanahKomperId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_KOMPER + " WHERE " + 
						DbSewaTanahKomperProp.colNames[DbSewaTanahKomperProp.COL_SEWA_TANAH_KOMPER_ID] + " = " + sewaTanahKomperId;

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
			String sql = "SELECT COUNT("+ DbSewaTanahKomperProp.colNames[DbSewaTanahKomperProp.COL_SEWA_TANAH_KOMPER_ID] + ") FROM " + DB_PROP_SEWA_TANAH_KOMPER;
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
			  	   SewaTanahKomperProp sewaTanahKomperProp = (SewaTanahKomperProp)list.get(ls);
				   if(oid == sewaTanahKomperProp.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}

}
