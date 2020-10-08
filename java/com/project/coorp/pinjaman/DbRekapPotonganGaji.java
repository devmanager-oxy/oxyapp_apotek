
package com.project.coorp.pinjaman; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.util.lang.*;
import com.project.util.*;


public class DbRekapPotonganGaji extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_REKAP_POTONGAN_GAJI = "sp_rekap_potongan_gaji";

	public static final  int COL_PERIODE_REKAP_ID = 0;
	public static final  int COL_REKAP_POTONGAN_GAJI_ID = 1;
	public static final  int COL_MEMBER_ID = 2;
	public static final  int COL_SIMPANAN_POKOK = 3;
	public static final  int COL_SIMPANAN_WAJIB = 4;
	public static final  int COL_SIMPANAN_SUKARELA = 5;
	public static final  int COL_PINJAMAN_POKOK = 6;
	public static final  int COL_PINJAMAN_BUNGA = 7;
	public static final  int COL_MINIMARKET = 8;
	public static final  int COL_ELEKTRONIK_POKOK = 9;
	public static final  int COL_ELEKTRONIK_BUNGA = 10;
	public static final  int COL_MANDIRI = 11;
	public static final  int COL_BNI = 12;
	public static final  int COL_BCA = 13;
	public static final  int COL_LAINLAIN = 14;
	public static final  int COL_STATUS = 15;
	public static final  int COL_APPROVED = 16;
	public static final  int COL_DATE = 17;
	public static final  int COL_USER_ID = 18;
        
        public static final  int COL_FASJABTEL = 19;
        public static final  int COL_NOTE = 20;
        public static final  int COL_STATUS_DOCUMENT = 21;
        public static final  int COL_DISETUJUI = 22;
        
        public static final  int COL_REKAP_MAIN_ID = 23;
        public static final  int COL_MANDIRI_BUNGA = 24;

	public static final  String[] colNames = {
		/*"PERIODE_REKAP_ID",
		"REKAP_POTONGAN_GAJI_ID",
		"MEMBER_ID",
		"SIMPANAN_POKOK",
		"SIMPANAN_WAJIB",
		"SIMPANAN_SUKARELA",
		"PINJAMAN_POKOK",
		"PINJAMAN_BUNGA",
		"MINIMARKET",
		"ELEKTRONIK_POKOK",
		"ELEKTRONIK_BUNGA",
		"MANDIRI",
		"BNI",
		"BCA",
		"LAINLAIN",
		"STATUS",
		"APPROVED",
		"DATE",
		"USER_ID"
                 */
                "periode_rekap_id",
                "rekap_potongan_gaji_id",
                "member_id",
                "simpanan_pokok",
                "simpanan_wajib",
                "simpanan_sukarela",
                "pinjaman_pokok",
                "pinjaman_bunga",
                "minimarket",
                "elektronik_pokok",
                "elektronik_bunga",
                "mandiri",
                "bni",
                "bca",
                "lainlain",
                "status",
                "approved",
                "date",
                "user_id",
                
                "fasjabtel",
                "note",
                "status_document",
                "disetujui",
                "rekap_main_id",
                "mandiri_bunga"

            
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_INT,
		TYPE_DATE,
		TYPE_INT,
                
                TYPE_FLOAT,
                TYPE_STRING,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_FLOAT
	 };
         
         public static final int STATUS_DRAFT = 0;
         public static final int STATUS_APPROVED = 1;
         public static final int STATUS_TITIPAN = 2;
         
         public static final String[] strStatus = {
            "-", "Disetujui", "Titipan"
         };

	public DbRekapPotonganGaji(){
	}

	public DbRekapPotonganGaji(int i) throws CONException { 
		super(new DbRekapPotonganGaji()); 
	}

	public DbRekapPotonganGaji(String sOid) throws CONException { 
		super(new DbRekapPotonganGaji(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbRekapPotonganGaji(long lOid) throws CONException { 
		super(new DbRekapPotonganGaji(0)); 
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
		return DB_REKAP_POTONGAN_GAJI;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbRekapPotonganGaji().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		RekapPotonganGaji rekappotongangaji = fetchExc(ent.getOID()); 
		ent = (Entity)rekappotongangaji; 
		return rekappotongangaji.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((RekapPotonganGaji) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((RekapPotonganGaji) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static RekapPotonganGaji fetchExc(long oid) throws CONException{ 
		try{ 
			RekapPotonganGaji rekappotongangaji = new RekapPotonganGaji();
			DbRekapPotonganGaji pstRekapPotonganGaji = new DbRekapPotonganGaji(oid); 
			rekappotongangaji.setOID(oid);

			rekappotongangaji.setPeriodeRekapId(pstRekapPotonganGaji.getlong(COL_PERIODE_REKAP_ID));
			rekappotongangaji.setMemberId(pstRekapPotonganGaji.getlong(COL_MEMBER_ID));
			rekappotongangaji.setSimpananPokok(pstRekapPotonganGaji.getdouble(COL_SIMPANAN_POKOK));
			rekappotongangaji.setSimpananWajib(pstRekapPotonganGaji.getdouble(COL_SIMPANAN_WAJIB));
			rekappotongangaji.setSimpananSukarela(pstRekapPotonganGaji.getdouble(COL_SIMPANAN_SUKARELA));
			rekappotongangaji.setPinjamanPokok(pstRekapPotonganGaji.getdouble(COL_PINJAMAN_POKOK));
			rekappotongangaji.setPinjamanBunga(pstRekapPotonganGaji.getdouble(COL_PINJAMAN_BUNGA));
			rekappotongangaji.setMinimarket(pstRekapPotonganGaji.getdouble(COL_MINIMARKET));
			rekappotongangaji.setElektronikPokok(pstRekapPotonganGaji.getdouble(COL_ELEKTRONIK_POKOK));
			rekappotongangaji.setElektronikBunga(pstRekapPotonganGaji.getdouble(COL_ELEKTRONIK_BUNGA));
			rekappotongangaji.setMandiri(pstRekapPotonganGaji.getdouble(COL_MANDIRI));
			rekappotongangaji.setBni(pstRekapPotonganGaji.getdouble(COL_BNI));
			rekappotongangaji.setBca(pstRekapPotonganGaji.getdouble(COL_BCA));
			rekappotongangaji.setLainlain(pstRekapPotonganGaji.getdouble(COL_LAINLAIN));
			rekappotongangaji.setStatus(pstRekapPotonganGaji.getInt(COL_STATUS));
			rekappotongangaji.setApproved(pstRekapPotonganGaji.getInt(COL_APPROVED));
			rekappotongangaji.setDate(pstRekapPotonganGaji.getDate(COL_DATE));
			rekappotongangaji.setUserId(pstRekapPotonganGaji.getInt(COL_USER_ID));
                        
                        rekappotongangaji.setFasjabtel(pstRekapPotonganGaji.getdouble(COL_FASJABTEL));
                        rekappotongangaji.setDisetujui(pstRekapPotonganGaji.getdouble(COL_DISETUJUI));
                        rekappotongangaji.setNote(pstRekapPotonganGaji.getString(COL_NOTE));
                        rekappotongangaji.setStatusDocument(pstRekapPotonganGaji.getInt(COL_STATUS_DOCUMENT));
                        rekappotongangaji.setRekapMainId(pstRekapPotonganGaji.getlong(COL_REKAP_MAIN_ID));
                        rekappotongangaji.setMandiriBunga(pstRekapPotonganGaji.getdouble(COL_MANDIRI_BUNGA));

			return rekappotongangaji; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRekapPotonganGaji(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(RekapPotonganGaji rekappotongangaji) throws CONException{ 
		try{ 
			DbRekapPotonganGaji pstRekapPotonganGaji = new DbRekapPotonganGaji(0);

			pstRekapPotonganGaji.setLong(COL_PERIODE_REKAP_ID, rekappotongangaji.getPeriodeRekapId());
			pstRekapPotonganGaji.setLong(COL_MEMBER_ID, rekappotongangaji.getMemberId());
			pstRekapPotonganGaji.setDouble(COL_SIMPANAN_POKOK, rekappotongangaji.getSimpananPokok());
			pstRekapPotonganGaji.setDouble(COL_SIMPANAN_WAJIB, rekappotongangaji.getSimpananWajib());
			pstRekapPotonganGaji.setDouble(COL_SIMPANAN_SUKARELA, rekappotongangaji.getSimpananSukarela());
			pstRekapPotonganGaji.setDouble(COL_PINJAMAN_POKOK, rekappotongangaji.getPinjamanPokok());
			pstRekapPotonganGaji.setDouble(COL_PINJAMAN_BUNGA, rekappotongangaji.getPinjamanBunga());
			pstRekapPotonganGaji.setDouble(COL_MINIMARKET, rekappotongangaji.getMinimarket());
			pstRekapPotonganGaji.setDouble(COL_ELEKTRONIK_POKOK, rekappotongangaji.getElektronikPokok());
			pstRekapPotonganGaji.setDouble(COL_ELEKTRONIK_BUNGA, rekappotongangaji.getElektronikBunga());
			pstRekapPotonganGaji.setDouble(COL_MANDIRI, rekappotongangaji.getMandiri());
			pstRekapPotonganGaji.setDouble(COL_BNI, rekappotongangaji.getBni());
			pstRekapPotonganGaji.setDouble(COL_BCA, rekappotongangaji.getBca());
			pstRekapPotonganGaji.setDouble(COL_LAINLAIN, rekappotongangaji.getLainlain());
			pstRekapPotonganGaji.setInt(COL_STATUS, rekappotongangaji.getStatus());
			pstRekapPotonganGaji.setInt(COL_APPROVED, rekappotongangaji.getApproved());
			pstRekapPotonganGaji.setDate(COL_DATE, rekappotongangaji.getDate());
			pstRekapPotonganGaji.setInt(COL_USER_ID, rekappotongangaji.getUserId());
                        
                        pstRekapPotonganGaji.setDouble(COL_FASJABTEL, rekappotongangaji.getFasjabtel());
                        pstRekapPotonganGaji.setDouble(COL_DISETUJUI, rekappotongangaji.getDisetujui());
                        pstRekapPotonganGaji.setString(COL_NOTE, rekappotongangaji.getNote());
                        pstRekapPotonganGaji.setInt(COL_STATUS_DOCUMENT, rekappotongangaji.getStatusDocument());
                        pstRekapPotonganGaji.setLong(COL_REKAP_MAIN_ID, rekappotongangaji.getRekapMainId());
                        pstRekapPotonganGaji.setDouble(COL_MANDIRI_BUNGA, rekappotongangaji.getMandiriBunga());

			pstRekapPotonganGaji.insert(); 
			rekappotongangaji.setOID(pstRekapPotonganGaji.getlong(COL_REKAP_POTONGAN_GAJI_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRekapPotonganGaji(0),CONException.UNKNOWN); 
		}
		return rekappotongangaji.getOID();
	}

	public static long updateExc(RekapPotonganGaji rekappotongangaji) throws CONException{ 
		try{ 
			if(rekappotongangaji.getOID() != 0){ 
				DbRekapPotonganGaji pstRekapPotonganGaji = new DbRekapPotonganGaji(rekappotongangaji.getOID());

				pstRekapPotonganGaji.setLong(COL_PERIODE_REKAP_ID, rekappotongangaji.getPeriodeRekapId());
				pstRekapPotonganGaji.setLong(COL_MEMBER_ID, rekappotongangaji.getMemberId());
				pstRekapPotonganGaji.setDouble(COL_SIMPANAN_POKOK, rekappotongangaji.getSimpananPokok());
				pstRekapPotonganGaji.setDouble(COL_SIMPANAN_WAJIB, rekappotongangaji.getSimpananWajib());
				pstRekapPotonganGaji.setDouble(COL_SIMPANAN_SUKARELA, rekappotongangaji.getSimpananSukarela());
				pstRekapPotonganGaji.setDouble(COL_PINJAMAN_POKOK, rekappotongangaji.getPinjamanPokok());
				pstRekapPotonganGaji.setDouble(COL_PINJAMAN_BUNGA, rekappotongangaji.getPinjamanBunga());
				pstRekapPotonganGaji.setDouble(COL_MINIMARKET, rekappotongangaji.getMinimarket());
				pstRekapPotonganGaji.setDouble(COL_ELEKTRONIK_POKOK, rekappotongangaji.getElektronikPokok());
				pstRekapPotonganGaji.setDouble(COL_ELEKTRONIK_BUNGA, rekappotongangaji.getElektronikBunga());
				pstRekapPotonganGaji.setDouble(COL_MANDIRI, rekappotongangaji.getMandiri());
				pstRekapPotonganGaji.setDouble(COL_BNI, rekappotongangaji.getBni());
				pstRekapPotonganGaji.setDouble(COL_BCA, rekappotongangaji.getBca());
				pstRekapPotonganGaji.setDouble(COL_LAINLAIN, rekappotongangaji.getLainlain());
				pstRekapPotonganGaji.setInt(COL_STATUS, rekappotongangaji.getStatus());
				pstRekapPotonganGaji.setInt(COL_APPROVED, rekappotongangaji.getApproved());
				pstRekapPotonganGaji.setDate(COL_DATE, rekappotongangaji.getDate());
				pstRekapPotonganGaji.setInt(COL_USER_ID, rekappotongangaji.getUserId());
                                
                                pstRekapPotonganGaji.setDouble(COL_FASJABTEL, rekappotongangaji.getFasjabtel());
                                pstRekapPotonganGaji.setDouble(COL_DISETUJUI, rekappotongangaji.getDisetujui());
                                pstRekapPotonganGaji.setString(COL_NOTE, rekappotongangaji.getNote());
                                pstRekapPotonganGaji.setInt(COL_STATUS_DOCUMENT, rekappotongangaji.getStatusDocument());
                                pstRekapPotonganGaji.setLong(COL_REKAP_MAIN_ID, rekappotongangaji.getRekapMainId());
                                pstRekapPotonganGaji.setDouble(COL_MANDIRI_BUNGA, rekappotongangaji.getMandiriBunga());

				pstRekapPotonganGaji.update(); 
				return rekappotongangaji.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRekapPotonganGaji(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbRekapPotonganGaji pstRekapPotonganGaji = new DbRekapPotonganGaji(oid);
			pstRekapPotonganGaji.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRekapPotonganGaji(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_REKAP_POTONGAN_GAJI; 
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
				RekapPotonganGaji rekappotongangaji = new RekapPotonganGaji();
				resultToObject(rs, rekappotongangaji);
				lists.add(rekappotongangaji);
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

	private static void resultToObject(ResultSet rs, RekapPotonganGaji rekappotongangaji){
		try{
			rekappotongangaji.setOID(rs.getLong(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_REKAP_POTONGAN_GAJI_ID]));
			rekappotongangaji.setPeriodeRekapId(rs.getLong(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_PERIODE_REKAP_ID]));
			rekappotongangaji.setMemberId(rs.getLong(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_MEMBER_ID]));
			rekappotongangaji.setSimpananPokok(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_SIMPANAN_POKOK]));
			rekappotongangaji.setSimpananWajib(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_SIMPANAN_WAJIB]));
			rekappotongangaji.setSimpananSukarela(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_SIMPANAN_SUKARELA]));
			rekappotongangaji.setPinjamanPokok(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_PINJAMAN_POKOK]));
			rekappotongangaji.setPinjamanBunga(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_PINJAMAN_BUNGA]));
			rekappotongangaji.setMinimarket(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_MINIMARKET]));
			rekappotongangaji.setElektronikPokok(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_ELEKTRONIK_POKOK]));
			rekappotongangaji.setElektronikBunga(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_ELEKTRONIK_BUNGA]));
			rekappotongangaji.setMandiri(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_MANDIRI]));
			rekappotongangaji.setBni(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_BNI]));
			rekappotongangaji.setBca(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_BCA]));
			rekappotongangaji.setLainlain(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_LAINLAIN]));
			rekappotongangaji.setStatus(rs.getInt(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_STATUS]));
			rekappotongangaji.setApproved(rs.getInt(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_APPROVED]));
			rekappotongangaji.setDate(rs.getDate(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_DATE]));
			rekappotongangaji.setUserId(rs.getInt(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_USER_ID]));
                        
                        rekappotongangaji.setFasjabtel(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_FASJABTEL]));
                        rekappotongangaji.setDisetujui(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_DISETUJUI]));
                        rekappotongangaji.setNote(rs.getString(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_NOTE]));
                        rekappotongangaji.setStatusDocument(rs.getInt(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_STATUS_DOCUMENT]));
                        rekappotongangaji.setRekapMainId(rs.getLong(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_REKAP_MAIN_ID]));
                        
                        rekappotongangaji.setMandiriBunga(rs.getDouble(DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_MANDIRI_BUNGA]));

		}catch(Exception e){ }
	}

	
	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_REKAP_POTONGAN_GAJI_ID] + ") FROM " + DB_REKAP_POTONGAN_GAJI;
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
			  	   RekapPotonganGaji rekappotongangaji = (RekapPotonganGaji)list.get(ls);
				   if(oid == rekappotongangaji.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static RekapPotonganGaji getRekap(long periodId, long memberId){
            
            Vector v = list(0,0, colNames[COL_PERIODE_REKAP_ID]+"="+periodId+" and "+colNames[COL_MEMBER_ID]+"="+memberId, "");
            if(v!=null && v.size()>0){
                return (RekapPotonganGaji)v.get(0);
            }
            
            return new RekapPotonganGaji();
            
        }
        
        
}
