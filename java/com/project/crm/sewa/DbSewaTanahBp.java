

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

public class DbSewaTanahBp extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_CRM_SEWA_TANAH_BP = "crm_sewa_tanah_bp";

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

        
        
	public DbSewaTanahBp(){
	}

	public DbSewaTanahBp(int i) throws CONException { 
		super(new DbSewaTanahBp()); 
	}

	public DbSewaTanahBp(String sOid) throws CONException { 
		super(new DbSewaTanahBp(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSewaTanahBp(long lOid) throws CONException { 
		super(new DbSewaTanahBp(0)); 
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
		return DB_CRM_SEWA_TANAH_BP;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSewaTanahBp().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SewaTanahBp sewatanahbp = fetchExc(ent.getOID()); 
		ent = (Entity)sewatanahbp; 
		return sewatanahbp.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SewaTanahBp) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SewaTanahBp) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SewaTanahBp fetchExc(long oid) throws CONException{ 
		try{ 
			SewaTanahBp sewatanahbp = new SewaTanahBp();
			DbSewaTanahBp pstSewaTanahBp = new DbSewaTanahBp(oid); 
			sewatanahbp.setOID(oid);

			sewatanahbp.setTanggal(pstSewaTanahBp.getDate(COL_TANGGAL));
			sewatanahbp.setKeterangan(pstSewaTanahBp.getString(COL_KETERANGAN));
			sewatanahbp.setRefnumber(pstSewaTanahBp.getString(COL_REFNUMBER));
			sewatanahbp.setMem(pstSewaTanahBp.getString(COL_MEM));
			sewatanahbp.setDebet(pstSewaTanahBp.getdouble(COL_DEBET));
			sewatanahbp.setCredit(pstSewaTanahBp.getdouble(COL_CREDIT));
			sewatanahbp.setSewaTanahId(pstSewaTanahBp.getlong(COL_SEWA_TANAH_ID));
			sewatanahbp.setSewaTanahInvId(pstSewaTanahBp.getlong(COL_SEWA_TANAH_INV_ID));
                        sewatanahbp.setMataUangId(pstSewaTanahBp.getlong(COL_MATA_UANG_ID));
                        sewatanahbp.setCustomerId(pstSewaTanahBp.getlong(COL_CUSTOMER_ID));
                        sewatanahbp.setLimbahTransactionId(pstSewaTanahBp.getlong(COL_LIMBAH_TRANSACTION_ID));
                        sewatanahbp.setIrigasiTransactionId(pstSewaTanahBp.getlong(COL_IRIGASI_TRANSACTION_ID));

			return sewatanahbp; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBp(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SewaTanahBp sewatanahbp) throws CONException{ 
		try{ 
			DbSewaTanahBp pstSewaTanahBp = new DbSewaTanahBp(0);

			pstSewaTanahBp.setDate(COL_TANGGAL, sewatanahbp.getTanggal());
			pstSewaTanahBp.setString(COL_KETERANGAN, sewatanahbp.getKeterangan());
			pstSewaTanahBp.setString(COL_REFNUMBER, sewatanahbp.getRefnumber());
			pstSewaTanahBp.setString(COL_MEM, sewatanahbp.getMem());
			pstSewaTanahBp.setDouble(COL_DEBET, sewatanahbp.getDebet());
			pstSewaTanahBp.setDouble(COL_CREDIT, sewatanahbp.getCredit());
			pstSewaTanahBp.setLong(COL_SEWA_TANAH_ID, sewatanahbp.getSewaTanahId());
			pstSewaTanahBp.setLong(COL_SEWA_TANAH_INV_ID, sewatanahbp.getSewaTanahInvId());
                        pstSewaTanahBp.setLong(COL_MATA_UANG_ID, sewatanahbp.getMataUangId());
                        pstSewaTanahBp.setLong(COL_CUSTOMER_ID, sewatanahbp.getCustomerId());
                        pstSewaTanahBp.setLong(COL_LIMBAH_TRANSACTION_ID, sewatanahbp.getLimbahTransactionId());
                        pstSewaTanahBp.setLong(COL_IRIGASI_TRANSACTION_ID, sewatanahbp.getIrigasiTransactionId());

			pstSewaTanahBp.insert(); 
			sewatanahbp.setOID(pstSewaTanahBp.getlong(COL_SEWA_TANAH_BP_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBp(0),CONException.UNKNOWN); 
		}
		return sewatanahbp.getOID();
	}

	public static long updateExc(SewaTanahBp sewatanahbp) throws CONException{ 
		try{ 
			if(sewatanahbp.getOID() != 0){ 
				DbSewaTanahBp pstSewaTanahBp = new DbSewaTanahBp(sewatanahbp.getOID());

				pstSewaTanahBp.setDate(COL_TANGGAL, sewatanahbp.getTanggal());
				pstSewaTanahBp.setString(COL_KETERANGAN, sewatanahbp.getKeterangan());
				pstSewaTanahBp.setString(COL_REFNUMBER, sewatanahbp.getRefnumber());
				pstSewaTanahBp.setString(COL_MEM, sewatanahbp.getMem());
				pstSewaTanahBp.setDouble(COL_DEBET, sewatanahbp.getDebet());
				pstSewaTanahBp.setDouble(COL_CREDIT, sewatanahbp.getCredit());
				pstSewaTanahBp.setLong(COL_SEWA_TANAH_ID, sewatanahbp.getSewaTanahId());
				pstSewaTanahBp.setLong(COL_SEWA_TANAH_INV_ID, sewatanahbp.getSewaTanahInvId());
                                pstSewaTanahBp.setLong(COL_MATA_UANG_ID, sewatanahbp.getMataUangId());
                                pstSewaTanahBp.setLong(COL_CUSTOMER_ID, sewatanahbp.getCustomerId());
                                pstSewaTanahBp.setLong(COL_LIMBAH_TRANSACTION_ID, sewatanahbp.getLimbahTransactionId());
                                pstSewaTanahBp.setLong(COL_IRIGASI_TRANSACTION_ID, sewatanahbp.getIrigasiTransactionId());

				pstSewaTanahBp.update(); 
				return sewatanahbp.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBp(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSewaTanahBp pstSewaTanahBp = new DbSewaTanahBp(oid);
			pstSewaTanahBp.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSewaTanahBp(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_BP; 
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
				SewaTanahBp sewatanahbp = new SewaTanahBp();
				resultToObject(rs, sewatanahbp);
				lists.add(sewatanahbp);
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

	private static void resultToObject(ResultSet rs, SewaTanahBp sewatanahbp){
		try{
			sewatanahbp.setOID(rs.getLong(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_SEWA_TANAH_BP_ID]));
			sewatanahbp.setTanggal(rs.getDate(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_TANGGAL]));
			sewatanahbp.setKeterangan(rs.getString(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_KETERANGAN]));
			sewatanahbp.setRefnumber(rs.getString(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_REFNUMBER]));
			sewatanahbp.setMem(rs.getString(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_MEM]));
			sewatanahbp.setDebet(rs.getDouble(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_DEBET]));
			sewatanahbp.setCredit(rs.getDouble(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_CREDIT]));
			sewatanahbp.setSewaTanahId(rs.getLong(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_SEWA_TANAH_ID]));
			sewatanahbp.setSewaTanahInvId(rs.getLong(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_SEWA_TANAH_INV_ID]));
                        sewatanahbp.setMataUangId(rs.getLong(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_MATA_UANG_ID]));
                        sewatanahbp.setCustomerId(rs.getLong(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_CUSTOMER_ID]));
                        sewatanahbp.setLimbahTransactionId(rs.getLong(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_LIMBAH_TRANSACTION_ID]));
                        sewatanahbp.setIrigasiTransactionId(rs.getLong(DbSewaTanahBp.colNames[DbSewaTanahBp.COL_IRIGASI_TRANSACTION_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long sewaTanahBpId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_CRM_SEWA_TANAH_BP + " WHERE " + 
						DbSewaTanahBp.colNames[DbSewaTanahBp.COL_SEWA_TANAH_BP_ID] + " = " + sewaTanahBpId;

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
			String sql = "SELECT COUNT("+ DbSewaTanahBp.colNames[DbSewaTanahBp.COL_SEWA_TANAH_BP_ID] + ") FROM " + DB_CRM_SEWA_TANAH_BP;
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
			  	   SewaTanahBp sewatanahbp = (SewaTanahBp)list.get(ls);
				   if(oid == sewatanahbp.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
	
        /**
         * by gwawan 20110919
         * @param idCustomer
         * @return
         */
        public static int getCountByCustomer(long idCustomer){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT(bp."+ colNames[COL_SEWA_TANAH_BP_ID] + ") FROM " + DB_CRM_SEWA_TANAH_BP + " bp " +
                                " INNER JOIN " + DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE + " sti " +
                                " ON bp." + colNames[COL_SEWA_TANAH_INV_ID] + " = " + 
                                DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID];
			if(idCustomer != 0)
				sql = sql + " WHERE sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + " = " + idCustomer;

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
        
        /**
         * by gwawan 20110919
         * @param limitStart
         * @param recordToGet
         * @param idCustomer
         * @param order
         * @return
         */
        public static Vector listByCustomer(int limitStart,int recordToGet, long idCustomer, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT bp.* FROM " + DB_CRM_SEWA_TANAH_BP + " bp " +
                                " INNER JOIN " + DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE + " sti " +
                                " ON bp." + colNames[COL_SEWA_TANAH_INV_ID] + " = " + 
                                DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID];
                        
			if(idCustomer != 0)
				sql = sql + " WHERE sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SARANA_ID] + " = " + idCustomer;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				SewaTanahBp sewatanahbp = new SewaTanahBp();
				resultToObject(rs, sewatanahbp);
				lists.add(sewatanahbp);
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
}
