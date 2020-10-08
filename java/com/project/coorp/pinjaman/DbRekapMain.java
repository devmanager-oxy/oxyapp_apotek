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
import com.project.system.*;
import com.project.fms.transaction.*;
import com.project.*;
import com.project.coorp.member.*;

public class DbRekapMain extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_REKAP_MAIN = "sp_rekap_main";

	public static final  int COL_REKAP_MAIN_ID = 0;
	public static final  int COL_DINAS_ID = 1;
	public static final  int COL_DINAS_UNIT_ID = 2;
	public static final  int COL_PERIODE_REKAP_ID = 3;
	public static final  int COL_STATUS = 4;
	public static final  int COL_DATE = 5;
	public static final  int COL_COUNTER = 6;
	public static final  int COL_PREFIX_NUMBER = 7;
	public static final  int COL_NUMBER = 8;
	public static final  int COL_NOTE = 9;
	public static final  int COL_ANGSURAN_COA_DEBET_ID = 10;
	public static final  int COL_ANGSURAN_COA_CREDIT_ID = 11;
	public static final  int COL_BUNGA_COA_DEBET_ID = 12;
	public static final  int COL_BUNGA_COA_CREDIT_ID = 13;
	public static final  int COL_MINIMARKET_COA_DEBET_ID = 14;
	public static final  int COL_MINIMARKET_COA_CREDIT_ID = 15;
	public static final  int COL_FASJABTEL_COA_DEBET_ID = 16;
	public static final  int COL_FASJABTEL_COA_CREDIT_ID = 17;
	public static final  int COL_TITIPAN_COA_DEBET_ID = 18;
	public static final  int COL_TITIPAN_COA_CREDIT_ID = 19;
	public static final  int COL_SIMPANAN_COA_DEBET_ID = 20;
	public static final  int COL_SIMPANAN_COA_CREDIT_ID = 21;
        public static final  int COL_USER_ID = 22;
        public static final  int COL_SIMPANAN_POKOK_COA_ID = 23;
        public static final  int COL_SIMPANAN_SUKARELA_COA_ID = 24;

	public static final  String[] colNames = {
		/*"REKAP_MAIN_ID",
		"DINAS_ID",
		"DINAS_UNIT_ID",
		"PERIODE_REKAP_ID",
		"STATUS",
		"DATE",
		"COUNTER",
		"PREFIX_NUMBER",
		"NUMBER",
		"NOTE",
		"ANGSURAN_COA_DEBET_ID",
		"ANGSURAN_COA_CREDIT_ID",
		"BUNGA_COA_DEBET_ID",
		"BUNGA_COA_CREDIT_ID",
		"MINIMARKET_COA_DEBET_ID",
		"MINIMARKET_COA_CREDIT_ID",
		"FASJABTEL_COA_DEBET_ID",
		"FASJABTEL_COA_CREDIT_ID",
		"TITIPAN_COA_DEBET_ID",
		"TITIPAN_COA_CREDIT_ID",
		"SIMPANAN_COA_DEBET_ID",
		"SIMPANAN_COA_CREDIT_ID"
                 */
                
                "rekap_main_id",
                "dinas_id",
                "dinas_unit_id",
                "periode_rekap_id",
                "status",
                "date",
                "counter",
                "prefix_number",
                "number",
                "note",
                "angsuran_coa_debet_id",
                "angsuran_coa_credit_id",
                "bunga_coa_debet_id",
                "bunga_coa_credit_id",
                "minimarket_coa_debet_id",
                "minimarket_coa_credit_id",
                "fasjabtel_coa_debet_id",
                "fasjabtel_coa_credit_id",
                "titipan_coa_debet_id",
                "titipan_coa_credit_id",
                "simpanan_coa_debet_id",
                "simpanan_coa_credit_id",
                "user_id",
                
                "simpanan_pokok_coa_id",
                "simpanan_sukarela_coa_id"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_INT,
		TYPE_DATE,
		TYPE_INT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
                TYPE_LONG,
                
                TYPE_LONG,
                TYPE_LONG
	 };
         
         
         
         
         public static final int DOCUMENT_STATUS_DRAFT = 0;
         public static final int DOCUMENT_STATUS_POSTED = 1;
         
         public static final String[] docStatus = {
            "DRAFT", "JURNAL POSTED"
         }; 

	public DbRekapMain(){
	}

	public DbRekapMain(int i) throws CONException { 
		super(new DbRekapMain()); 
	}

	public DbRekapMain(String sOid) throws CONException { 
		super(new DbRekapMain(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbRekapMain(long lOid) throws CONException { 
		super(new DbRekapMain(0)); 
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
		return DB_REKAP_MAIN;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbRekapMain().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		RekapMain rekapmain = fetchExc(ent.getOID()); 
		ent = (Entity)rekapmain; 
		return rekapmain.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((RekapMain) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((RekapMain) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static RekapMain fetchExc(long oid) throws CONException{ 
		try{ 
			RekapMain rekapmain = new RekapMain();
			DbRekapMain pstRekapMain = new DbRekapMain(oid); 
			rekapmain.setOID(oid);

			rekapmain.setDinasId(pstRekapMain.getlong(COL_DINAS_ID));
			rekapmain.setDinasUnitId(pstRekapMain.getlong(COL_DINAS_UNIT_ID));
			rekapmain.setPeriodeRekapId(pstRekapMain.getlong(COL_PERIODE_REKAP_ID));
			rekapmain.setStatus(pstRekapMain.getInt(COL_STATUS));
			rekapmain.setDate(pstRekapMain.getDate(COL_DATE));
			rekapmain.setCounter(pstRekapMain.getInt(COL_COUNTER));
			rekapmain.setPrefixNumber(pstRekapMain.getString(COL_PREFIX_NUMBER));
			rekapmain.setNumber(pstRekapMain.getString(COL_NUMBER));
			rekapmain.setNote(pstRekapMain.getString(COL_NOTE));
			rekapmain.setAngsuranCoaDebetId(pstRekapMain.getlong(COL_ANGSURAN_COA_DEBET_ID));
			rekapmain.setAngsuranCoaCreditId(pstRekapMain.getlong(COL_ANGSURAN_COA_CREDIT_ID));
			rekapmain.setBungaCoaDebetId(pstRekapMain.getlong(COL_BUNGA_COA_DEBET_ID));
			rekapmain.setBungaCoaCreditId(pstRekapMain.getlong(COL_BUNGA_COA_CREDIT_ID));
			rekapmain.setMinimarketCoaDebetId(pstRekapMain.getlong(COL_MINIMARKET_COA_DEBET_ID));
			rekapmain.setMinimarketCoaCreditId(pstRekapMain.getlong(COL_MINIMARKET_COA_CREDIT_ID));
			rekapmain.setFasjabtelCoaDebetId(pstRekapMain.getlong(COL_FASJABTEL_COA_DEBET_ID));
			rekapmain.setFasjabtelCoaCreditId(pstRekapMain.getlong(COL_FASJABTEL_COA_CREDIT_ID));
			rekapmain.setTitipanCoaDebetId(pstRekapMain.getlong(COL_TITIPAN_COA_DEBET_ID));
			rekapmain.setTitipanCoaCreditId(pstRekapMain.getlong(COL_TITIPAN_COA_CREDIT_ID));
			rekapmain.setSimpananCoaDebetId(pstRekapMain.getlong(COL_SIMPANAN_COA_DEBET_ID));
			rekapmain.setSimpananCoaCreditId(pstRekapMain.getlong(COL_SIMPANAN_COA_CREDIT_ID));
                        rekapmain.setUserId(pstRekapMain.getlong(COL_USER_ID));
                        
                        rekapmain.setSimpananPokokCoaId(pstRekapMain.getlong(COL_SIMPANAN_POKOK_COA_ID));
                        rekapmain.setSimpananSukarelaCoaId(pstRekapMain.getlong(COL_SIMPANAN_SUKARELA_COA_ID));

			return rekapmain; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRekapMain(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(RekapMain rekapmain) throws CONException{ 
		try{ 
			DbRekapMain pstRekapMain = new DbRekapMain(0);

			pstRekapMain.setLong(COL_DINAS_ID, rekapmain.getDinasId());
			pstRekapMain.setLong(COL_DINAS_UNIT_ID, rekapmain.getDinasUnitId());
			pstRekapMain.setLong(COL_PERIODE_REKAP_ID, rekapmain.getPeriodeRekapId());
			pstRekapMain.setInt(COL_STATUS, rekapmain.getStatus());
			pstRekapMain.setDate(COL_DATE, rekapmain.getDate());
			pstRekapMain.setInt(COL_COUNTER, rekapmain.getCounter());
			pstRekapMain.setString(COL_PREFIX_NUMBER, rekapmain.getPrefixNumber());
			pstRekapMain.setString(COL_NUMBER, rekapmain.getNumber());
			pstRekapMain.setString(COL_NOTE, rekapmain.getNote());
			pstRekapMain.setLong(COL_ANGSURAN_COA_DEBET_ID, rekapmain.getAngsuranCoaDebetId());
			pstRekapMain.setLong(COL_ANGSURAN_COA_CREDIT_ID, rekapmain.getAngsuranCoaCreditId());
			pstRekapMain.setLong(COL_BUNGA_COA_DEBET_ID, rekapmain.getBungaCoaDebetId());
			pstRekapMain.setLong(COL_BUNGA_COA_CREDIT_ID, rekapmain.getBungaCoaCreditId());
			pstRekapMain.setLong(COL_MINIMARKET_COA_DEBET_ID, rekapmain.getMinimarketCoaDebetId());
			pstRekapMain.setLong(COL_MINIMARKET_COA_CREDIT_ID, rekapmain.getMinimarketCoaCreditId());
			pstRekapMain.setLong(COL_FASJABTEL_COA_DEBET_ID, rekapmain.getFasjabtelCoaDebetId());
			pstRekapMain.setLong(COL_FASJABTEL_COA_CREDIT_ID, rekapmain.getFasjabtelCoaCreditId());
			pstRekapMain.setLong(COL_TITIPAN_COA_DEBET_ID, rekapmain.getTitipanCoaDebetId());
			pstRekapMain.setLong(COL_TITIPAN_COA_CREDIT_ID, rekapmain.getTitipanCoaCreditId());
			pstRekapMain.setLong(COL_SIMPANAN_COA_DEBET_ID, rekapmain.getSimpananCoaDebetId());
			pstRekapMain.setLong(COL_SIMPANAN_COA_CREDIT_ID, rekapmain.getSimpananCoaCreditId());
                        pstRekapMain.setLong(COL_USER_ID, rekapmain.getUserId());
                        
                        pstRekapMain.setLong(COL_SIMPANAN_POKOK_COA_ID, rekapmain.getSimpananPokokCoaId());
                        pstRekapMain.setLong(COL_SIMPANAN_SUKARELA_COA_ID, rekapmain.getSimpananSukarelaCoaId());

			pstRekapMain.insert(); 
			rekapmain.setOID(pstRekapMain.getlong(COL_REKAP_MAIN_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRekapMain(0),CONException.UNKNOWN); 
		}
		return rekapmain.getOID();
	}

	public static long updateExc(RekapMain rekapmain) throws CONException{ 
		try{ 
			if(rekapmain.getOID() != 0){ 
				DbRekapMain pstRekapMain = new DbRekapMain(rekapmain.getOID());

				pstRekapMain.setLong(COL_DINAS_ID, rekapmain.getDinasId());
				pstRekapMain.setLong(COL_DINAS_UNIT_ID, rekapmain.getDinasUnitId());
				pstRekapMain.setLong(COL_PERIODE_REKAP_ID, rekapmain.getPeriodeRekapId());
				pstRekapMain.setInt(COL_STATUS, rekapmain.getStatus());
				pstRekapMain.setDate(COL_DATE, rekapmain.getDate());
				pstRekapMain.setInt(COL_COUNTER, rekapmain.getCounter());
				pstRekapMain.setString(COL_PREFIX_NUMBER, rekapmain.getPrefixNumber());
				pstRekapMain.setString(COL_NUMBER, rekapmain.getNumber());
				pstRekapMain.setString(COL_NOTE, rekapmain.getNote());
				pstRekapMain.setLong(COL_ANGSURAN_COA_DEBET_ID, rekapmain.getAngsuranCoaDebetId());
				pstRekapMain.setLong(COL_ANGSURAN_COA_CREDIT_ID, rekapmain.getAngsuranCoaCreditId());
				pstRekapMain.setLong(COL_BUNGA_COA_DEBET_ID, rekapmain.getBungaCoaDebetId());
				pstRekapMain.setLong(COL_BUNGA_COA_CREDIT_ID, rekapmain.getBungaCoaCreditId());
				pstRekapMain.setLong(COL_MINIMARKET_COA_DEBET_ID, rekapmain.getMinimarketCoaDebetId());
				pstRekapMain.setLong(COL_MINIMARKET_COA_CREDIT_ID, rekapmain.getMinimarketCoaCreditId());
				pstRekapMain.setLong(COL_FASJABTEL_COA_DEBET_ID, rekapmain.getFasjabtelCoaDebetId());
				pstRekapMain.setLong(COL_FASJABTEL_COA_CREDIT_ID, rekapmain.getFasjabtelCoaCreditId());
				pstRekapMain.setLong(COL_TITIPAN_COA_DEBET_ID, rekapmain.getTitipanCoaDebetId());
				pstRekapMain.setLong(COL_TITIPAN_COA_CREDIT_ID, rekapmain.getTitipanCoaCreditId());
				pstRekapMain.setLong(COL_SIMPANAN_COA_DEBET_ID, rekapmain.getSimpananCoaDebetId());
				pstRekapMain.setLong(COL_SIMPANAN_COA_CREDIT_ID, rekapmain.getSimpananCoaCreditId());
                                pstRekapMain.setLong(COL_USER_ID, rekapmain.getUserId());
                                
                                pstRekapMain.setLong(COL_SIMPANAN_POKOK_COA_ID, rekapmain.getSimpananPokokCoaId());
                                pstRekapMain.setLong(COL_SIMPANAN_SUKARELA_COA_ID, rekapmain.getSimpananSukarelaCoaId());

				pstRekapMain.update(); 
				return rekapmain.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRekapMain(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbRekapMain pstRekapMain = new DbRekapMain(oid);
			pstRekapMain.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbRekapMain(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_REKAP_MAIN; 
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
				RekapMain rekapmain = new RekapMain();
				resultToObject(rs, rekapmain);
				lists.add(rekapmain);
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

	private static void resultToObject(ResultSet rs, RekapMain rekapmain){
		try{
			rekapmain.setOID(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_REKAP_MAIN_ID]));
			rekapmain.setDinasId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_DINAS_ID]));
			rekapmain.setDinasUnitId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_DINAS_UNIT_ID]));
			rekapmain.setPeriodeRekapId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_PERIODE_REKAP_ID]));
			rekapmain.setStatus(rs.getInt(DbRekapMain.colNames[DbRekapMain.COL_STATUS]));
			rekapmain.setDate(rs.getDate(DbRekapMain.colNames[DbRekapMain.COL_DATE]));
			rekapmain.setCounter(rs.getInt(DbRekapMain.colNames[DbRekapMain.COL_COUNTER]));
			rekapmain.setPrefixNumber(rs.getString(DbRekapMain.colNames[DbRekapMain.COL_PREFIX_NUMBER]));
			rekapmain.setNumber(rs.getString(DbRekapMain.colNames[DbRekapMain.COL_NUMBER]));
			rekapmain.setNote(rs.getString(DbRekapMain.colNames[DbRekapMain.COL_NOTE]));
			rekapmain.setAngsuranCoaDebetId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_ANGSURAN_COA_DEBET_ID]));
			rekapmain.setAngsuranCoaCreditId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_ANGSURAN_COA_CREDIT_ID]));
			rekapmain.setBungaCoaDebetId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_BUNGA_COA_DEBET_ID]));
			rekapmain.setBungaCoaCreditId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_BUNGA_COA_CREDIT_ID]));
			rekapmain.setMinimarketCoaDebetId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_MINIMARKET_COA_DEBET_ID]));
			rekapmain.setMinimarketCoaCreditId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_MINIMARKET_COA_CREDIT_ID]));
			rekapmain.setFasjabtelCoaDebetId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_FASJABTEL_COA_DEBET_ID]));
			rekapmain.setFasjabtelCoaCreditId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_FASJABTEL_COA_CREDIT_ID]));
			rekapmain.setTitipanCoaDebetId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_TITIPAN_COA_DEBET_ID]));
			rekapmain.setTitipanCoaCreditId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_TITIPAN_COA_CREDIT_ID]));
			rekapmain.setSimpananCoaDebetId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_SIMPANAN_COA_DEBET_ID]));
			rekapmain.setSimpananCoaCreditId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_SIMPANAN_COA_CREDIT_ID]));
                        rekapmain.setUserId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_USER_ID]));
                        
                        rekapmain.setSimpananPokokCoaId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_SIMPANAN_POKOK_COA_ID]));
                        rekapmain.setSimpananSukarelaCoaId(rs.getLong(DbRekapMain.colNames[DbRekapMain.COL_SIMPANAN_SUKARELA_COA_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long rekapMainId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_REKAP_MAIN + " WHERE " + 
						DbRekapMain.colNames[DbRekapMain.COL_REKAP_MAIN_ID] + " = " + rekapMainId;

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
			String sql = "SELECT COUNT("+ DbRekapMain.colNames[DbRekapMain.COL_REKAP_MAIN_ID] + ") FROM " + DB_REKAP_MAIN;
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
			  	   RekapMain rekapmain = (RekapMain)list.get(ls);
				   if(oid == rekapmain.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static int getNextCounter(){
                int result = 0;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_REKAP_MAIN+" where "+
                        colNames[COL_PREFIX_NUMBER]+"='"+getNumberPrefix()+"'";
                    
                    System.out.println(sql);
                    
                    dbrs = CONHandler.execQueryResult(sql);
                    ResultSet rs = dbrs.getResultSet();
                    while(rs.next()){
                        result = rs.getInt(1);
                    }
                    
                    if(result==0){
                        result = result + 1;
                    }
                    else{
                        result = result + 1;
                    }
                    
                }
                catch(Exception e){
                    
                }
                finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
        }
        
        public static String getNumberPrefix(){
            
                //Company sysCompany = DbCompany.getCompany();
                
                String code = DbSystemProperty.getValueByName("REKAP_GAJI_CODE");                                
                
                code = code + JSPFormater.formatDate(new Date(), "MMyy");
                
                return code;
        }
        
        
        public static String getNextNumber(int ctr){
            
                String code = getNumberPrefix();
                
                if(ctr<10){
                    code = code + "000"+ctr;
                }
                else if(ctr<100){
                    code = code + "00"+ctr;
                }
                else if(ctr<1000){
                    code = code + "0"+ctr;
                }
                else{
                    code = code + ctr;
                }
                
                return code;
                
        }
        
        
        public static void postJournal(RekapMain rm){
            
            Company comp = DbCompany.getCompany();
                
            ExchangeRate er = DbExchangeRate.getStandardRate();
                
            if(rm.getOID()!=0){
                
                PeriodeRekap pr = new PeriodeRekap();
                try{
                    pr = DbPeriodeRekap.fetchExc(rm.getPeriodeRekapId());
                }
                catch(Exception e){
                }
                
                Vector mbs = DbRekapPotonganGaji.list(0,0, DbRekapPotonganGaji.colNames[DbRekapPotonganGaji.COL_REKAP_MAIN_ID]+"="+rm.getOID(), "");            
                
                String memo = "Rekap potongan gaji, periode "+pr.getName();
                     
                if(mbs!=null && mbs.size()>0){
                    //jurnal main    
                    long oid = 0;//DbGl.postJournalMain(0, new Date(), rm.getCounter(), rm.getNumber(), rm.getPrefixNumber(), 
                        //I_Project.JOURNAL_TYPE_POTONGAN_GAJI, 
                        //memo, 0, "", rm.getOID(), "", rm.getDate());

                    if(oid!=0 ){        
                        
                        memo = "";
                        
                        for(int i=0 ; i<mbs.size(); i++){
                            
                            RekapPotonganGaji rpg = (RekapPotonganGaji)mbs.get(i);
                            
                            //jika bukan titipan
                            if(rpg.getStatus()==DbRekapPotonganGaji.STATUS_APPROVED){
                            
                                //update simpanan pokok
                                if(rpg.getSimpananPokok()>0){
                                    DbMember.updateSimpananPokok(rpg.getMemberId(), rpg.getSimpananPokok());                                     
                                }
                                
                                double x = rpg.getSimpananPokok() + rpg.getSimpananSukarela() + rpg.getSimpananWajib();
                                
                                //jurnal simpanan debet credit
                                if(x>0){
                                    //journal debet simpanan                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getSimpananCoaDebetId(), 0, x,             
                                                x, comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                                    
                                    //journal credit pokok                                
                                    if(rpg.getSimpananPokok()!=0){
                                        
                                        if(rpg.getSimpananPokok()==0){                            
                                            DbMember.updateSimpananPokok(rpg.getMemberId(), rpg.getSimpananPokok());   
                                        }
                                        
                                        DbGl.postJournalDetail(er.getValueIdr(), rm.getSimpananPokokCoaId(), rpg.getSimpananPokok(), 0,             
                                                rpg.getSimpananPokok(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                                    }
                                    
                                    //journal credit wajib                                
                                    if(rpg.getSimpananWajib()!=0){
                                        DbGl.postJournalDetail(er.getValueIdr(), rm.getSimpananCoaCreditId(), rpg.getSimpananWajib(), 0,             
                                                rpg.getSimpananWajib(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                                    }
                                    
                                    //journal credit sukarela                                
                                    if(rpg.getSimpananSukarela()!=0){
                                        DbGl.postJournalDetail(er.getValueIdr(), rm.getSimpananSukarelaCoaId(), rpg.getSimpananSukarela(), 0,             
                                                rpg.getSimpananSukarela(), comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                                    }
                                    
                                    //posting tabungan member
                                    DbSimpananMember.insertSimpananFromPotongGaji(rm, rpg);

                                }

                                //jurnal pokok pinjaman
                                //-------------------------- pembayaran angsuran ---------------------
                                
                                //bayar pinjaman
                                if(rpg.getPinjamanPokok()>0){                                    
                                    DbPinjaman.getPaidForPinjamanByPotongGaji(rpg.getMemberId(), pr.getStartDate(), DbPinjaman.JENIS_BARANG_CASH);
                                }
                                //bayar pinjaman elektronik
                                if(rpg.getElektronikPokok()>0){
                                    DbPinjaman.getPaidForPinjamanByPotongGaji(rpg.getMemberId(), pr.getStartDate(), DbPinjaman.JENIS_BARANG_ELEKTRONIK);
                                }
                                //bayar pinjaman mandiri
                                if(rpg.getMandiri()>0){
                                    DbPinjaman.getPaidTagihanBankByPotongGaji(rpg.getMemberId(), pr.getStartDate());
                                }
                                
                                x = rpg.getPinjamanPokok() + rpg.getElektronikPokok() + rpg.getMandiri();
                                if(x>0){
                                    //journal debet simpanan                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getAngsuranCoaDebetId(), 0, x,             
                                                x, comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                                    //journal credit                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getAngsuranCoaCreditId(), x, 0,             
                                            x, comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                                }

                                //jurnal bunga pinjaman
                                x = rpg.getPinjamanBunga() + rpg.getElektronikBunga() + rpg.getMandiriBunga();
                                if(x>0){
                                    //journal debet simpanan                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getBungaCoaDebetId(), 0, x,             
                                                x, comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                                    //journal credit                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getBungaCoaCreditId(), x, 0,             
                                            x, comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                                }
                                
                                //------------------------- end pembayaran angsuran ---------------------

                                //jurnal minimarket
                                x = rpg.getMinimarket();
                                if(x>0){
                                    //journal debet simpanan                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getMinimarketCoaDebetId(), 0, x,             
                                                x, comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                                    //journal credit                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getMinimarketCoaCreditId(), x, 0,             
                                            x, comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                                }

                                //jurnal fasjabtel
                                x = rpg.getFasjabtel();
                                if(x>0){
                                    //journal debet simpanan                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getFasjabtelCoaDebetId(), 0, x,             
                                                x, comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                                    //journal credit                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getFasjabtelCoaCreditId(), x, 0,             
                                            x, comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0

                                }

                                //jurnal titipan
                                x = rpg.getLainlain();
                                if(x>0){
                                    //journal debet simpanan                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getTitipanCoaDebetId(), 0, x,             
                                                x, comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                                    //journal credit                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getTitipanCoaCreditId(), x, 0,             
                                            x, comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                                    
                                    //posting titipan - tidak di masukkan ke cash receive
                                    //postCashReceive(rm, rpg, x, comp);

                                }
                                
                                
                            }
                            //end if bukan titipan
                            else if(rpg.getStatus()==DbRekapPotonganGaji.STATUS_TITIPAN){
                                
                                //jurnal titipan
                                double x = rpg.getDisetujui()+rpg.getLainlain();
                                if(x>0){
                                    //journal debet simpanan                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getTitipanCoaDebetId(), 0, x,             
                                                x, comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0

                                    //journal credit                                 
                                    DbGl.postJournalDetail(er.getValueIdr(), rm.getTitipanCoaCreditId(), x, 0,             
                                            x, comp.getBookingCurrencyId(), oid, memo, 0); //non departmenttal item, department id = 0
                                    
                                    //posting titipan - tidak di masukkan ke cash receive
                                    //postCashReceive(rm, rpg, x, comp);

                                }
                                
                            }
                            
                        
			}//end for
                        
                    }//end oid == 0
                    
                    //optimalkan, jika akunnya sama digabung    
                    DbGl.optimizeJournal(oid);
                    
                }
            }
            
        }
        
        
        public static void postCashReceive(RekapMain rm, RekapPotonganGaji rpg, double amount, Company comp){
            
            //get member
            Member m = new Member();
            try{
                m = DbMember.fetchExc(rpg.getMemberId());
            }
            catch(Exception e){
                
            }
            
            //get penitip = get vendor
            String where  = DbVendor.colNames[DbVendor.COL_CODE]+"='"+m.getNoMember()+"'"+
                            " and "+DbVendor.colNames[DbVendor.COL_NAME]+"='"+m.getNama()+"'"+
                            " and "+DbVendor.colNames[DbVendor.COL_TYPE]+"="+DbVendor.VENDOR_TYPE_PENITIP;
            
            Vector vnds = DbVendor.list(0,0, where, "");
            Vendor vnd = new Vendor();
            if(vnds!=null && vnds.size()>0){
                vnd = (Vendor)vnds.get(0);
            }
            else{
                //insert baru
                vnd.setCode(m.getNoMember());
                vnd.setName(m.getNama());
                vnd.setAddress(m.getAlamat());
                vnd.setPhone(m.getPhone());
                vnd.setType(DbVendor.VENDOR_TYPE_PENITIP);                
                
                try{
                    DbVendor.insertExc(vnd);
                }
                catch(Exception e){
                }
            }
            
            //buat cash receive
            CashReceive cr = new CashReceive();
            cr.setType(DbCashReceive.TYPE_CASH_LIABILITY);
            cr.setAmount(amount);
            cr.setCustomerId(vnd.getOID());
            cr.setDate(new Date());
            cr.setTransDate(rm.getDate());
            cr.setCoaId(rm.getTitipanCoaDebetId());
            cr.setMemo("Auto Posting - dari rekap potongan gaji, no : "+rm.getNumber());
            cr.setOperatorId(0);
            int cnt = DbCashReceive.getNextCounter(DbCashReceive.TYPE_CASH_LIABILITY);
            cr.setJournalCounter(cnt);
            cr.setJournalPrefix(DbCashReceive.getNumberPrefix(DbCashReceive.TYPE_CASH_LIABILITY));
            cr.setJournalNumber(DbCashReceive.getNextNumber(cnt, DbCashReceive.TYPE_CASH_LIABILITY));
            cr.setReceiveFromId(0);
            cr.setInOut(1);
            
            long oid = 0;
            try{
                oid = DbCashReceive.insertExc(cr);
            }
            catch(Exception e){            
            }
            
            //posting cash receive detail
            CashReceiveDetail crd = new CashReceiveDetail();
            crd.setCashReceiveId(oid);
            crd.setAmount(amount);
            crd.setForeignAmount(amount);
            crd.setMemo("Auto - dari rekap potongan gaji");
            crd.setCoaId(rm.getTitipanCoaCreditId());
            crd.setBookedRate(1);
            crd.setForeignCurrencyId(comp.getBookingCurrencyId());
            
            try{
                oid = DbCashReceiveDetail.insertExc(crd);
            }
            catch(Exception e){            
            }
            
            
        }
        
        
        
        
}
