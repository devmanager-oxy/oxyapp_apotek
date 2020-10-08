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
import com.project.general.*;
import com.project.util.*;
/**
 *
 * @author Roy Andika
 */
public class DbSewaTanahBpProp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {
    
        public static final  String DB_PROP_SEWA_TANAH_BP = "prop_sewa_tanah_bp";

	public static final  int COL_SEWA_TANAH_BP_ID = 0;
	public static final  int COL_TANGGAL = 1;
	public static final  int COL_KETERANGAN = 2;
	public static final  int COL_REFNUMBER = 3;
	public static final  int COL_MEM = 4;
	public static final  int COL_DEBET = 5;
	public static final  int COL_CREDIT = 6;
	public static final  int COL_SEWA_TANAH_ID = 7;
	public static final  int COL_SEWA_TANAH_INV_ID = 8;
        public static final  int COL_MATA_UANG_ID = 9;        
        public static final  int COL_CUSTOMER_ID = 10;
        public static final  int COL_LIMBAH_TRANSACTION_ID = 11;
        public static final  int COL_IRIGASI_TRANSACTION_ID = 12;

	public static final  String[] colNames = {
		"sewa_tanah_bp_id",
		"tanggal",
		"keterangan",
		"refnumber",
		"mem",
		"debet",
		"credit",
		"sewa_tanah_id",
		"sewa_tanah_inv_id",
                "mata_uang_id",
                "customer_id",
                "limbah_transaction_id",
                "irigasi_transaction_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	 }; 

        
        
	public DbSewaTanahBpProp(){
	}

	public DbSewaTanahBpProp(int i) throws CONException { 
		super(new DbSewaTanahBpProp()); 
	}

	public DbSewaTanahBpProp(String sOid) throws CONException { 
		super(new DbSewaTanahBpProp(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSewaTanahBpProp(long lOid) throws CONException { 
		super(new DbSewaTanahBpProp(0)); 
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
		return DB_PROP_SEWA_TANAH_BP;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSewaTanahBpProp().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SewaTanahBpProp sewaTanahBpProp = fetchExc(ent.getOID()); 
		ent = (Entity)sewaTanahBpProp; 
		return sewaTanahBpProp.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SewaTanahBpProp) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SewaTanahBpProp) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SewaTanahBpProp fetchExc(long oid) throws CONException{ 
		try{ 
			SewaTanahBpProp sewaTanahBpProp = new SewaTanahBpProp();
			DbSewaTanahBpProp pstSewaTanahBp = new DbSewaTanahBpProp(oid); 
			sewaTanahBpProp.setOID(oid);

			sewaTanahBpProp.setTanggal(pstSewaTanahBp.getDate(COL_TANGGAL));
			sewaTanahBpProp.setKeterangan(pstSewaTanahBp.getString(COL_KETERANGAN));
			sewaTanahBpProp.setRefnumber(pstSewaTanahBp.getString(COL_REFNUMBER));
			sewaTanahBpProp.setMem(pstSewaTanahBp.getString(COL_MEM));
			sewaTanahBpProp.setDebet(pstSewaTanahBp.getdouble(COL_DEBET));
			sewaTanahBpProp.setCredit(pstSewaTanahBp.getdouble(COL_CREDIT));
			sewaTanahBpProp.setSewaTanahId(pstSewaTanahBp.getlong(COL_SEWA_TANAH_ID));
			sewaTanahBpProp.setSewaTanahInvId(pstSewaTanahBp.getlong(COL_SEWA_TANAH_INV_ID));
                        sewaTanahBpProp.setMataUangId(pstSewaTanahBp.getlong(COL_MATA_UANG_ID));
                        sewaTanahBpProp.setCustomerId(pstSewaTanahBp.getlong(COL_CUSTOMER_ID));
                        sewaTanahBpProp.setLimbahTransactionId(pstSewaTanahBp.getlong(COL_LIMBAH_TRANSACTION_ID));
                        sewaTanahBpProp.setIrigasiTransactionId(pstSewaTanahBp.getlong(COL_IRIGASI_TRANSACTION_ID));

			return sewaTanahBpProp; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBpProp(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SewaTanahBpProp sewaTanahBpProp) throws CONException{ 
		try{ 
			DbSewaTanahBpProp pstSewaTanahBp = new DbSewaTanahBpProp(0);

			pstSewaTanahBp.setDate(COL_TANGGAL, sewaTanahBpProp.getTanggal());
			pstSewaTanahBp.setString(COL_KETERANGAN, sewaTanahBpProp.getKeterangan());
			pstSewaTanahBp.setString(COL_REFNUMBER, sewaTanahBpProp.getRefnumber());
			pstSewaTanahBp.setString(COL_MEM, sewaTanahBpProp.getMem());
			pstSewaTanahBp.setDouble(COL_DEBET, sewaTanahBpProp.getDebet());
			pstSewaTanahBp.setDouble(COL_CREDIT, sewaTanahBpProp.getCredit());
			pstSewaTanahBp.setLong(COL_SEWA_TANAH_ID, sewaTanahBpProp.getSewaTanahId());
			pstSewaTanahBp.setLong(COL_SEWA_TANAH_INV_ID, sewaTanahBpProp.getSewaTanahInvId());
                        pstSewaTanahBp.setLong(COL_MATA_UANG_ID, sewaTanahBpProp.getMataUangId());
                        pstSewaTanahBp.setLong(COL_CUSTOMER_ID, sewaTanahBpProp.getCustomerId());
                        pstSewaTanahBp.setLong(COL_LIMBAH_TRANSACTION_ID, sewaTanahBpProp.getLimbahTransactionId());
                        pstSewaTanahBp.setLong(COL_IRIGASI_TRANSACTION_ID, sewaTanahBpProp.getIrigasiTransactionId());
			pstSewaTanahBp.insert(); 
			sewaTanahBpProp.setOID(pstSewaTanahBp.getlong(COL_SEWA_TANAH_BP_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBpProp(0),CONException.UNKNOWN); 
		}
		return sewaTanahBpProp.getOID();
	}

	public static long updateExc(SewaTanahBpProp sewaTanahBpProp) throws CONException{ 
		try{ 
			if(sewaTanahBpProp.getOID() != 0){ 
				DbSewaTanahBpProp pstSewaTanahBp = new DbSewaTanahBpProp(sewaTanahBpProp.getOID());

				pstSewaTanahBp.setDate(COL_TANGGAL, sewaTanahBpProp.getTanggal());
				pstSewaTanahBp.setString(COL_KETERANGAN, sewaTanahBpProp.getKeterangan());
				pstSewaTanahBp.setString(COL_REFNUMBER, sewaTanahBpProp.getRefnumber());
				pstSewaTanahBp.setString(COL_MEM, sewaTanahBpProp.getMem());
				pstSewaTanahBp.setDouble(COL_DEBET, sewaTanahBpProp.getDebet());
				pstSewaTanahBp.setDouble(COL_CREDIT, sewaTanahBpProp.getCredit());
				pstSewaTanahBp.setLong(COL_SEWA_TANAH_ID, sewaTanahBpProp.getSewaTanahId());
				pstSewaTanahBp.setLong(COL_SEWA_TANAH_INV_ID, sewaTanahBpProp.getSewaTanahInvId());
                                pstSewaTanahBp.setLong(COL_MATA_UANG_ID, sewaTanahBpProp.getMataUangId());
                                pstSewaTanahBp.setLong(COL_CUSTOMER_ID, sewaTanahBpProp.getCustomerId());
                                pstSewaTanahBp.setLong(COL_LIMBAH_TRANSACTION_ID, sewaTanahBpProp.getLimbahTransactionId());
                                pstSewaTanahBp.setLong(COL_IRIGASI_TRANSACTION_ID, sewaTanahBpProp.getIrigasiTransactionId());

				pstSewaTanahBp.update(); 
				return sewaTanahBpProp.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBpProp(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSewaTanahBpProp pstSewaTanahBp = new DbSewaTanahBpProp(oid);
			pstSewaTanahBp.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBpProp(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_BP; 
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
				SewaTanahBpProp sewaTanahBpProp = new SewaTanahBpProp();
				resultToObject(rs, sewaTanahBpProp);
				lists.add(sewaTanahBpProp);
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

	private static void resultToObject(ResultSet rs, SewaTanahBpProp sewaTanahBpProp){
		try{
			sewaTanahBpProp.setOID(rs.getLong(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_SEWA_TANAH_BP_ID]));
			sewaTanahBpProp.setTanggal(rs.getDate(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_TANGGAL]));
			sewaTanahBpProp.setKeterangan(rs.getString(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_KETERANGAN]));
			sewaTanahBpProp.setRefnumber(rs.getString(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_REFNUMBER]));
			sewaTanahBpProp.setMem(rs.getString(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_MEM]));
			sewaTanahBpProp.setDebet(rs.getDouble(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_DEBET]));
			sewaTanahBpProp.setCredit(rs.getDouble(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_CREDIT]));
			sewaTanahBpProp.setSewaTanahId(rs.getLong(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_SEWA_TANAH_ID]));
			sewaTanahBpProp.setSewaTanahInvId(rs.getLong(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_SEWA_TANAH_INV_ID]));
                        sewaTanahBpProp.setMataUangId(rs.getLong(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_MATA_UANG_ID]));
                        sewaTanahBpProp.setCustomerId(rs.getLong(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_CUSTOMER_ID]));
                        sewaTanahBpProp.setLimbahTransactionId(rs.getLong(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_LIMBAH_TRANSACTION_ID]));
                        sewaTanahBpProp.setIrigasiTransactionId(rs.getLong(DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_IRIGASI_TRANSACTION_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long sewaTanahBpId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_PROP_SEWA_TANAH_BP + " WHERE " + 
						DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_SEWA_TANAH_BP_ID] + " = " + sewaTanahBpId;

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
			String sql = "SELECT COUNT("+ DbSewaTanahBpProp.colNames[DbSewaTanahBpProp.COL_SEWA_TANAH_BP_ID] + ") FROM " + DB_PROP_SEWA_TANAH_BP;
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
			  	   SewaTanahBpProp sewaTanahBpProp = (SewaTanahBpProp)list.get(ls);
				   if(oid == sewaTanahBpProp.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}
