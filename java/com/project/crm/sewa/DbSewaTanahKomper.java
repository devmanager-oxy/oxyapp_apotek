
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */

package com.project.crm.sewa; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.util.lang.I_Language;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.ccs.posmaster.*;
import com.project.*;
import com.project.fms.transaction.*;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.AccLink;
import com.project.fms.master.DbAccLink;
import com.project.fms.transaction.*;
import com.project.general.*;
import com.project.util.*;

public class DbSewaTanahKomper extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CRM_SEWA_TANAH_KOMPER = "crm_sewa_tanah_komper";

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

	public DbSewaTanahKomper(){
	}

	public DbSewaTanahKomper(int i) throws CONException { 
		super(new DbSewaTanahKomper()); 
	}

	public DbSewaTanahKomper(String sOid) throws CONException { 
		super(new DbSewaTanahKomper(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSewaTanahKomper(long lOid) throws CONException { 
		super(new DbSewaTanahKomper(0)); 
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
		return DB_CRM_SEWA_TANAH_KOMPER;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSewaTanahKomper().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SewaTanahKomper sewatanahkomper = fetchExc(ent.getOID()); 
		ent = (Entity)sewatanahkomper; 
		return sewatanahkomper.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SewaTanahKomper) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SewaTanahKomper) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SewaTanahKomper fetchExc(long oid) throws CONException{ 
		try{ 
			SewaTanahKomper sewatanahkomper = new SewaTanahKomper();
			DbSewaTanahKomper pstSewaTanahKomper = new DbSewaTanahKomper(oid); 
			sewatanahkomper.setOID(oid);

			sewatanahkomper.setKategori(pstSewaTanahKomper.getInt(COL_KATEGORI));
			sewatanahkomper.setPersentase(pstSewaTanahKomper.getdouble(COL_PERSENTASE));
			sewatanahkomper.setSewaTanahId(pstSewaTanahKomper.getlong(COL_SEWA_TANAH_ID));
			
			return sewatanahkomper; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomper(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SewaTanahKomper sewatanahkomper) throws CONException{ 
		try{ 
			DbSewaTanahKomper pstSewaTanahKomper = new DbSewaTanahKomper(0);

			pstSewaTanahKomper.setInt(COL_KATEGORI, sewatanahkomper.getKategori());
			pstSewaTanahKomper.setDouble(COL_PERSENTASE, sewatanahkomper.getPersentase());
			pstSewaTanahKomper.setLong(COL_SEWA_TANAH_ID, sewatanahkomper.getSewaTanahId());
			
			pstSewaTanahKomper.insert(); 
			sewatanahkomper.setOID(pstSewaTanahKomper.getlong(COL_SEWA_TANAH_KOMPER_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomper(0),CONException.UNKNOWN); 
		}
		return sewatanahkomper.getOID();
	}

	public static long updateExc(SewaTanahKomper sewatanahkomper) throws CONException{ 
		try{ 
			if(sewatanahkomper.getOID() != 0){ 
				DbSewaTanahKomper pstSewaTanahKomper = new DbSewaTanahKomper(sewatanahkomper.getOID());

				pstSewaTanahKomper.setInt(COL_KATEGORI, sewatanahkomper.getKategori());
				pstSewaTanahKomper.setDouble(COL_PERSENTASE, sewatanahkomper.getPersentase());
				pstSewaTanahKomper.setLong(COL_SEWA_TANAH_ID, sewatanahkomper.getSewaTanahId());
				
				pstSewaTanahKomper.update(); 
				return sewatanahkomper.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomper(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSewaTanahKomper pstSewaTanahKomper = new DbSewaTanahKomper(oid);
			pstSewaTanahKomper.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahKomper(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_KOMPER; 
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
				SewaTanahKomper sewatanahkomper = new SewaTanahKomper();
				resultToObject(rs, sewatanahkomper);
				lists.add(sewatanahkomper);
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

	private static void resultToObject(ResultSet rs, SewaTanahKomper sewatanahkomper){
		try{
			sewatanahkomper.setOID(rs.getLong(DbSewaTanahKomper.colNames[DbSewaTanahKomper.COL_SEWA_TANAH_KOMPER_ID]));
			sewatanahkomper.setKategori(rs.getInt(DbSewaTanahKomper.colNames[DbSewaTanahKomper.COL_KATEGORI]));
			sewatanahkomper.setPersentase(rs.getDouble(DbSewaTanahKomper.colNames[DbSewaTanahKomper.COL_PERSENTASE]));
			sewatanahkomper.setSewaTanahId(rs.getLong(DbSewaTanahKomper.colNames[DbSewaTanahKomper.COL_SEWA_TANAH_ID]));
			
		}catch(Exception e){ }
	}

	public static boolean checkOID(long sewaTanahKomperId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_KOMPER + " WHERE " + 
						DbSewaTanahKomper.colNames[DbSewaTanahKomper.COL_SEWA_TANAH_KOMPER_ID] + " = " + sewaTanahKomperId;

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
			String sql = "SELECT COUNT("+ DbSewaTanahKomper.colNames[DbSewaTanahKomper.COL_SEWA_TANAH_KOMPER_ID] + ") FROM " + DB_CRM_SEWA_TANAH_KOMPER;
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
			  	   SewaTanahKomper sewatanahkomper = (SewaTanahKomper)list.get(ls);
				   if(oid == sewatanahkomper.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
