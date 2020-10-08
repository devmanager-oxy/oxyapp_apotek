
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
import com.project.coorp.member.*;
import com.project.fms.transaction.*;
import com.project.fms.master.*;
import com.project.*;

public class DbTabunganSukarela extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_SP_TABUNGAN_SUKARELA = "sp_tabungan_sukarela";        

	public static final  int COL_TABUNGAN_SUKARELA_ID = 0;
	public static final  int COL_TANGGAL = 1;
	public static final  int COL_JUMLAH = 2;
	public static final  int COL_PENGALI = 3;
	public static final  int COL_TYPE = 4;
	public static final  int COL_NOTE = 5;
	public static final  int COL_USER_ID = 6;
	public static final  int COL_TRANS_DATE = 7;
	public static final  int COL_PERIOD_ID = 8;
	public static final  int COL_POST_STATUS = 9;
	public static final  int COL_SALDO = 10;
        public static final  int COL_SORT_NUM = 11;
        public static final int COL_MEMBER_ID   = 12;
        public static final int COL_DEBET   = 13;
        public static final int COL_CREDIT   = 14;
        public static final int COL_COUNTER   = 15;
        public static final int COL_CASH_BANK_COA_ID   = 16;
        public static final int COL_NUMBER  = 17;

	public static final  String[] colNames = {
		"tabungan_sukarela_id",
                "tanggal",
                "jumlah",
                "pengali",
                "type",
                "note",
                "user_id",
                "trans_date",
                "period_id",
                "post_status",
                "saldo",
                "sort_num",
                "member_id",
                "debet",
                "credit",
                "counter",
                "cash_bank_coa_id",
                "number"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_INT,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_INT,
		TYPE_FLOAT,
                TYPE_INT,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_LONG,
                TYPE_STRING
	 }; 
         
        public static final int TABUNGAN_TYPE_CREDIT = 0;
        public static final int TABUNGAN_TYPE_DEBET = 1;
        public static final int TABUNGAN_TYPE_BUNGA = 2;
        public static final int TABUNGAN_TYPE_ADMIN = 3;
        public static final int TABUNGAN_TYPE_PAJAK = 4;
        
        public static final String[] strType = {"Tabungan", "Penarikan", "Bunga", "Biaya Administrasi", "Biaya Pajak"};
        public static final int[] strTypePengali = { 1, -1, 1, -1};
        
        public static final int IN_TABUNGAN = 1;
        public static final int OUT_TABUNGAN = -1;

	public DbTabunganSukarela(){
	}

	public DbTabunganSukarela(int i) throws CONException { 
		super(new DbTabunganSukarela()); 
	}

	public DbTabunganSukarela(String sOid) throws CONException { 
		super(new DbTabunganSukarela(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbTabunganSukarela(long lOid) throws CONException { 
		super(new DbTabunganSukarela(0)); 
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
		return DB_SP_TABUNGAN_SUKARELA;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbTabunganSukarela().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		TabunganSukarela tabungansukarela = fetchExc(ent.getOID()); 
		ent = (Entity)tabungansukarela; 
		return tabungansukarela.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((TabunganSukarela) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((TabunganSukarela) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static TabunganSukarela fetchExc(long oid) throws CONException{ 
		try{ 
			TabunganSukarela tabungansukarela = new TabunganSukarela();
			DbTabunganSukarela pstTabunganSukarela = new DbTabunganSukarela(oid); 
			tabungansukarela.setOID(oid);

			tabungansukarela.setTanggal(pstTabunganSukarela.getDate(COL_TANGGAL));
			tabungansukarela.setJumlah(pstTabunganSukarela.getdouble(COL_JUMLAH));
			tabungansukarela.setPengali(pstTabunganSukarela.getInt(COL_PENGALI));
			tabungansukarela.setType(pstTabunganSukarela.getInt(COL_TYPE));
			tabungansukarela.setNote(pstTabunganSukarela.getString(COL_NOTE));
			tabungansukarela.setUserId(pstTabunganSukarela.getlong(COL_USER_ID));
			tabungansukarela.setTransDate(pstTabunganSukarela.getDate(COL_TRANS_DATE));
			tabungansukarela.setPeriodId(pstTabunganSukarela.getlong(COL_PERIOD_ID));
			tabungansukarela.setPostStatus(pstTabunganSukarela.getInt(COL_POST_STATUS));
			tabungansukarela.setSaldo(pstTabunganSukarela.getdouble(COL_SALDO));
                        tabungansukarela.setSortNum(pstTabunganSukarela.getInt(COL_SORT_NUM));
                        tabungansukarela.setMemberId(pstTabunganSukarela.getlong(COL_MEMBER_ID));
                        
                        tabungansukarela.setDebet(pstTabunganSukarela.getdouble(COL_DEBET));
                        tabungansukarela.setCredit(pstTabunganSukarela.getdouble(COL_CREDIT));
                        tabungansukarela.setCounter(pstTabunganSukarela.getInt(COL_COUNTER));
                        tabungansukarela.setCashBankCoaId(pstTabunganSukarela.getlong(COL_CASH_BANK_COA_ID));
                        tabungansukarela.setNumber(pstTabunganSukarela.getString(COL_NUMBER));

			return tabungansukarela; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganSukarela(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(TabunganSukarela tabungansukarela) throws CONException{ 
		try{ 
			DbTabunganSukarela pstTabunganSukarela = new DbTabunganSukarela(0);

			pstTabunganSukarela.setDate(COL_TANGGAL, tabungansukarela.getTanggal());
			pstTabunganSukarela.setDouble(COL_JUMLAH, tabungansukarela.getJumlah());
			pstTabunganSukarela.setInt(COL_PENGALI, tabungansukarela.getPengali());
			pstTabunganSukarela.setInt(COL_TYPE, tabungansukarela.getType());
			pstTabunganSukarela.setString(COL_NOTE, tabungansukarela.getNote());
			pstTabunganSukarela.setLong(COL_USER_ID, tabungansukarela.getUserId());
			pstTabunganSukarela.setDate(COL_TRANS_DATE, tabungansukarela.getTransDate());
			pstTabunganSukarela.setLong(COL_PERIOD_ID, tabungansukarela.getPeriodId());
			pstTabunganSukarela.setInt(COL_POST_STATUS, tabungansukarela.getPostStatus());
			pstTabunganSukarela.setDouble(COL_SALDO, tabungansukarela.getSaldo());
                        pstTabunganSukarela.setInt(COL_SORT_NUM, tabungansukarela.getSortNum());
                        pstTabunganSukarela.setLong(COL_MEMBER_ID, tabungansukarela.getMemberId());
                        
                        pstTabunganSukarela.setDouble(COL_DEBET, tabungansukarela.getDebet());
                        pstTabunganSukarela.setDouble(COL_CREDIT, tabungansukarela.getCredit());
                        pstTabunganSukarela.setInt(COL_COUNTER, tabungansukarela.getCounter());
                        pstTabunganSukarela.setLong(COL_CASH_BANK_COA_ID, tabungansukarela.getCashBankCoaId());
                        pstTabunganSukarela.setString(COL_NUMBER, tabungansukarela.getNumber());

			pstTabunganSukarela.insert(); 
			tabungansukarela.setOID(pstTabunganSukarela.getlong(COL_TABUNGAN_SUKARELA_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganSukarela(0),CONException.UNKNOWN); 
		}
		return tabungansukarela.getOID();
	}

	public static long updateExc(TabunganSukarela tabungansukarela) throws CONException{ 
		try{ 
			if(tabungansukarela.getOID() != 0){ 
				DbTabunganSukarela pstTabunganSukarela = new DbTabunganSukarela(tabungansukarela.getOID());

				pstTabunganSukarela.setDate(COL_TANGGAL, tabungansukarela.getTanggal());
				pstTabunganSukarela.setDouble(COL_JUMLAH, tabungansukarela.getJumlah());
				pstTabunganSukarela.setInt(COL_PENGALI, tabungansukarela.getPengali());
				pstTabunganSukarela.setInt(COL_TYPE, tabungansukarela.getType());
				pstTabunganSukarela.setString(COL_NOTE, tabungansukarela.getNote());
				pstTabunganSukarela.setLong(COL_USER_ID, tabungansukarela.getUserId());
				pstTabunganSukarela.setDate(COL_TRANS_DATE, tabungansukarela.getTransDate());
				pstTabunganSukarela.setLong(COL_PERIOD_ID, tabungansukarela.getPeriodId());
				pstTabunganSukarela.setInt(COL_POST_STATUS, tabungansukarela.getPostStatus());
				pstTabunganSukarela.setDouble(COL_SALDO, tabungansukarela.getSaldo());
                                pstTabunganSukarela.setInt(COL_SORT_NUM, tabungansukarela.getSortNum());
                                pstTabunganSukarela.setLong(COL_MEMBER_ID, tabungansukarela.getMemberId());
                                pstTabunganSukarela.setDouble(COL_DEBET, tabungansukarela.getDebet());
                                pstTabunganSukarela.setDouble(COL_CREDIT, tabungansukarela.getCredit());
                                pstTabunganSukarela.setInt(COL_COUNTER, tabungansukarela.getCounter());
                                pstTabunganSukarela.setLong(COL_CASH_BANK_COA_ID, tabungansukarela.getCashBankCoaId());
                                pstTabunganSukarela.setString(COL_NUMBER, tabungansukarela.getNumber());

				pstTabunganSukarela.update(); 
				return tabungansukarela.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganSukarela(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbTabunganSukarela pstTabunganSukarela = new DbTabunganSukarela(oid);
			pstTabunganSukarela.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbTabunganSukarela(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_SP_TABUNGAN_SUKARELA; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			if(limitStart == 0 && recordToGet == 0)
				sql = sql + "";
			else
				sql = sql + " LIMIT " + limitStart + ","+ recordToGet ;
			
                        System.out.println(sql);
                        
                        dbrs = CONHandler.execQueryResult(sql);
                        
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				TabunganSukarela tabungansukarela = new TabunganSukarela();
				resultToObject(rs, tabungansukarela);
				lists.add(tabungansukarela);
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

	private static void resultToObject(ResultSet rs, TabunganSukarela tabungansukarela){
		try{
			tabungansukarela.setOID(rs.getLong(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_TABUNGAN_SUKARELA_ID]));
			tabungansukarela.setTanggal(rs.getDate(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_TANGGAL]));
			tabungansukarela.setJumlah(rs.getDouble(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_JUMLAH]));
			tabungansukarela.setPengali(rs.getInt(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_PENGALI]));
			tabungansukarela.setType(rs.getInt(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_TYPE]));
			tabungansukarela.setNote(rs.getString(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_NOTE]));
			tabungansukarela.setUserId(rs.getLong(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_USER_ID]));
			tabungansukarela.setTransDate(rs.getDate(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_TRANS_DATE]));
			tabungansukarela.setPeriodId(rs.getLong(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_PERIOD_ID]));
			tabungansukarela.setPostStatus(rs.getInt(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_POST_STATUS]));
			tabungansukarela.setSaldo(rs.getDouble(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_SALDO]));
                        tabungansukarela.setSortNum(rs.getInt(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_SORT_NUM]));
                        tabungansukarela.setMemberId(rs.getLong(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_MEMBER_ID]));
                        
                        tabungansukarela.setDebet(rs.getDouble(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_DEBET]));
                        tabungansukarela.setCredit(rs.getDouble(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_CREDIT]));
                        tabungansukarela.setCounter(rs.getInt(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_COUNTER]));
                        tabungansukarela.setCashBankCoaId(rs.getLong(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_CASH_BANK_COA_ID]));
                        tabungansukarela.setNumber(rs.getString(DbTabunganSukarela.colNames[DbTabunganSukarela.COL_NUMBER]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long tabunganSukarelaId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SP_TABUNGAN_SUKARELA + " WHERE " + 
						DbTabunganSukarela.colNames[DbTabunganSukarela.COL_TABUNGAN_SUKARELA_ID] + " = " + tabunganSukarelaId;

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
			String sql = "SELECT COUNT("+ DbTabunganSukarela.colNames[DbTabunganSukarela.COL_TABUNGAN_SUKARELA_ID] + ") FROM " + DB_SP_TABUNGAN_SUKARELA;
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
			  	   TabunganSukarela tabungansukarela = (TabunganSukarela)list.get(ls);
				   if(oid == tabungansukarela.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static TabunganSukarela getLatestTransaction(long memberId){
                Vector v = list(0,1, colNames[COL_MEMBER_ID]+"="+memberId, colNames[COL_COUNTER]+" desc");
                
                if(v!=null && v.size()>0){
                    return (TabunganSukarela)v.get(0);
                }
                return new TabunganSukarela();
        }
        
        public static TabunganSukarela getLatestBunga(long memberId){
                Vector v = list(0,1, colNames[COL_MEMBER_ID]+"="+memberId+" and type="+TABUNGAN_TYPE_BUNGA, colNames[COL_TRANS_DATE]+" desc");
                
                if(v!=null && v.size()>0){
                    return (TabunganSukarela)v.get(0);
                }
                return new TabunganSukarela();
        }
        
        public static int getNextSortNum(){
                
                String sql = "select max("+colNames[COL_SORT_NUM]+") from "+DB_SP_TABUNGAN_SUKARELA;
                CONResultSet crs = null;
                int result = 0;
                
                try{
                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();
                    while(rs.next()){
                        result = rs.getInt(1);
                    }
                }
                catch(Exception e){
                }
                finally{
                    CONResultSet.close(crs);
                }                                
                
                return result + 1;
                
        }
        
        public static String getNextNumber(int type, int counter){
                
                String number = ""+type;
                
                if(counter<10000){
                    number = number+"0000"+counter;
                }
                else if(counter<1000){
                    number = number+"000"+counter;
                }
                else if(counter<100){
                    number = number+"00"+counter;
                }
                else if(counter<10){
                    number = number+"0"+counter;
                }
                else{
                    number = number+""+counter;
                }
                
                return number;
        }
        
        
        public static Vector getAllPenabung(){
            String sql = "select distinct("+colNames[COL_MEMBER_ID]+") from "+DB_SP_TABUNGAN_SUKARELA;
            CONResultSet crs = null;
            Vector result = new Vector();
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result.add(""+rs.getLong(1));
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        public static void postAutoBunga(TabunganSetup ts, long memberId){
            
            //jika buka diaktifkan
            if(ts.getBungaActivate()==1){
                
                //bunga harian
                if(ts.getBungaType()==DbTabunganSetup.DURATION_TYPE_DAILY){
                    
                    TabunganSukarela tsk = getLatestBunga(memberId);
                    if(tsk.getOID()!=0){
                        System.out.println("... in latest bunga : "+tsk.getOID());

                        Date dt = new Date();
                        String s = JSPFormater.formatDate(dt, "dd-MM-yyyy");
                        dt = JSPFormater.formatDate(s, "dd-MM-yyyy");

                        System.out.println("... curr date : "+dt);

                        Date trn = tsk.getTransDate();
                        s = JSPFormater.formatDate(trn, "dd-MM-yyyy");
                        trn = JSPFormater.formatDate(s, "dd-MM-yyyy");

                        System.out.println("... bunga date : "+trn);
                        System.out.println("... dt.after(trn) : "+(dt.after(trn)));

                        if(dt.after(trn)){
                            postBungaHarian(trn, dt, memberId, ts, tsk);
                        }
                    }
                    else{
                        
                        tsk = getLatestTransaction(memberId);
                        
                        System.out.println("... bunga pertama");
                        
                        if(tsk.getOID()!=0){
                            System.out.println("... in latest tran : "+tsk.getOID());

                            Date dt = new Date();
                            String s = JSPFormater.formatDate(dt, "dd-MM-yyyy");
                            dt = JSPFormater.formatDate(s, "dd-MM-yyyy");

                            System.out.println("... curr date : "+dt);

                            Date trn = tsk.getTransDate();
                            s = JSPFormater.formatDate(trn, "dd-MM-yyyy");
                            trn = JSPFormater.formatDate(s, "dd-MM-yyyy");

                            System.out.println("... tran date : "+trn);
                            System.out.println("... dt.after(trn) : "+(dt.after(trn)));

                            if(dt.after(trn)){
                                postBungaHarian(trn, dt, memberId, ts, tsk);
                            }
                        }
                    }
                    
                }
                //bunga bulanan
                else if(ts.getBungaType()==DbTabunganSetup.DURATION_TYPE_MONTHLY){
                    
                }
                //bunga tahunan
                else{
                    
                }
            }
            
        }
        
        
        public static void postBungaHarian(Date trn, Date dt, long memberId, TabunganSetup ts, TabunganSukarela lastTs){
            
            if(ts.getBungaActivate()==1){
                
                Periode per = DbPeriode.getOpenPeriod();
                //lastTs = getLatestTransaction(memberId);
                if(lastTs.getType()==TABUNGAN_TYPE_BUNGA){
                    
                    System.out.println("... post bunga harian ...  bunga terakhir ");
                    
                    boolean goon = true;
                    Date dtx = (Date)trn.clone();
                    while(goon){ 
                        
                        lastTs = getLatestTransaction(memberId);
                        
                        try{
                            dtx.setDate(dtx.getDate()+1);
                            if(dtx.before(dt)){
                                //langsung beri bunga
                                TabunganSukarela tsk = new TabunganSukarela();
                                tsk.setTransDate(dtx);
                                tsk.setTanggal(new Date());
                                double bunga = lastTs.getSaldo()*(ts.getBungaPercent()/100);
                                tsk.setJumlah(bunga);
                                tsk.setCredit(bunga);
                                tsk.setDebet(0);
                                tsk.setType(TABUNGAN_TYPE_BUNGA);
                                tsk.setSaldo(lastTs.getSaldo()+bunga);
                                tsk.setCounter(lastTs.getCounter()+1);
                                tsk.setSortNum(DbTabunganSukarela.getNextSortNum());
                                tsk.setNumber(DbTabunganSukarela.getNextNumber(tsk.getType(), tsk.getSortNum()));
                                tsk.setPeriodId(per.getOID());
                                tsk.setMemberId(memberId);
                                tsk.setNote("Auto");

                                long oid = insertExc(tsk);

                                if(oid!=0){
                                    postJournal(tsk);
                                }

                            }
                            //jika hari sama, cek jika jam sudah sesuai,
                            //jika sudah lewat jam, beri bunga dan stop
                            else{
                                Date dtNow = new Date();   
                                
                                System.out.println("...... dt now jam : "+dtNow.getHours());
                                System.out.println("...... ts.getServiceStartHour() : "+ts.getServiceStartHour());
                                
                                if(dtNow.getHours()>=ts.getServiceStartHour()){
                                    //langsung beri bunga
                                    TabunganSukarela tsk = new TabunganSukarela();
                                    tsk.setTransDate(dtx);
                                    tsk.setTanggal(new Date());
                                    double bunga = lastTs.getSaldo()*(ts.getBungaPercent()/100);
                                    tsk.setJumlah(bunga);
                                    tsk.setCredit(bunga);
                                    tsk.setDebet(0);
                                    tsk.setType(TABUNGAN_TYPE_BUNGA);
                                    tsk.setSaldo(lastTs.getSaldo()+bunga);
                                    tsk.setCounter(lastTs.getCounter()+1);
                                    tsk.setSortNum(DbTabunganSukarela.getNextSortNum());
                                    tsk.setNumber(DbTabunganSukarela.getNextNumber(tsk.getType(), tsk.getSortNum()));
                                    tsk.setPeriodId(per.getOID());
                                    tsk.setMemberId(memberId);
                                    tsk.setNote("Auto");

                                    long oid = insertExc(tsk);

                                    if(oid!=0){
                                        postJournal(tsk);
                                    }
                                }
                                goon = false;
                            }
                        }
                        catch(Exception e){
                            System.out.println("exception 123xx : "+e.toString());
                        }
                    }
                }
                //bukan bunga yang didapat tapi transaksi pertama
                else{
                    
                    System.out.println("... post bunga harian ...  bunga pertama ");
                    
                    boolean goon = true;
                    Date dtx = (Date)trn.clone();
                    while(goon){ 
                        
                        lastTs = getLatestTransaction(memberId);
                        
                        try{
                            
                            if(dtx.before(dt)){
                                //langsung beri bunga
                                TabunganSukarela tsk = new TabunganSukarela();
                                tsk.setTransDate(dtx);
                                tsk.setTanggal(new Date());
                                double bunga = lastTs.getSaldo()*(ts.getBungaPercent()/100);
                                tsk.setJumlah(bunga);
                                tsk.setCredit(bunga);
                                tsk.setDebet(0);
                                tsk.setType(TABUNGAN_TYPE_BUNGA);
                                tsk.setSaldo(lastTs.getSaldo()+bunga);
                                tsk.setCounter(lastTs.getCounter()+1);
                                tsk.setSortNum(DbTabunganSukarela.getNextSortNum());
                                tsk.setNumber(DbTabunganSukarela.getNextNumber(tsk.getType(), tsk.getSortNum()));
                                tsk.setPeriodId(per.getOID());
                                tsk.setMemberId(memberId);
                                tsk.setNote("Auto");

                                long oid = insertExc(tsk);

                                if(oid!=0){
                                    postJournal(tsk);
                                }

                            }
                            //jika hari sama, cek jika jam sudah sesuai,
                            //jika sudah lewat jam, beri bunga dan stop
                            else{
                                Date dtNow = new Date();                            
                                if(dtNow.getHours()>=ts.getServiceStartHour()){
                                    //langsung beri bunga
                                    TabunganSukarela tsk = new TabunganSukarela();
                                    tsk.setTransDate(dtx);
                                    tsk.setTanggal(new Date());
                                    double bunga = lastTs.getSaldo()*(ts.getBungaPercent()/100);
                                    tsk.setJumlah(bunga);
                                    tsk.setCredit(bunga);
                                    tsk.setDebet(0);
                                    tsk.setType(TABUNGAN_TYPE_BUNGA);
                                    tsk.setSaldo(lastTs.getSaldo()+bunga);
                                    tsk.setCounter(lastTs.getCounter()+1);
                                    tsk.setSortNum(DbTabunganSukarela.getNextSortNum());
                                    tsk.setNumber(DbTabunganSukarela.getNextNumber(tsk.getType(), tsk.getSortNum()));
                                    tsk.setPeriodId(per.getOID());
                                    tsk.setMemberId(memberId);
                                    tsk.setNote("Auto");

                                    long oid = insertExc(tsk);

                                    if(oid!=0){
                                        postJournal(tsk);
                                    }
                                }
                                goon = false;
                            }
                            
                            dtx.setDate(dtx.getDate()+1);
                            
                        }
                        catch(Exception e){
                            System.out.println("exception 123xx : "+e.toString());
                        }
                    }
                }
            }            
        }
        
        
        //POSTING ke journal - pengakuan pihutang
        public static void postJournal(TabunganSukarela cr){
                
            String activeFlag = DbSystemProperty.getValueByName("ACTIVATE_TABUNGAN_POSTING_PROCESS");
            
            if(activeFlag.equals("Y")){
                            
                Company comp = DbCompany.getCompany();
                
                ExchangeRate er = DbExchangeRate.getStandardRate();
                
                Member member = new Member();
                try{
                    member = DbMember.fetchExc(cr.getMemberId());
                }
                catch(Exception e){
                }  
                
                TabunganSetup ts = DbTabunganSetup.getTabunganSetup(); 
                
                String memo = "";
                switch(cr.getType()){
                    case TABUNGAN_TYPE_CREDIT :
                        memo = "Tabungan Sukarela : "+member.getNoMember()+"/"+member.getNama();
                        break;
                    case TABUNGAN_TYPE_DEBET :
                        memo = "Penarikan Tabungan Sukarela : "+member.getNoMember()+"/"+member.getNama();
                        break;
                    case TABUNGAN_TYPE_BUNGA :
                        memo = "Bunga Tabungan Sukarela : "+member.getNoMember()+"/"+member.getNama();
                        break;
                    case TABUNGAN_TYPE_ADMIN :
                        memo = "Biaya Admin Tabungan Sukarela : "+member.getNoMember()+"/"+member.getNama();
                        break;
                    case TABUNGAN_TYPE_PAJAK :
                        memo = "Biaya Pajak Tabungan Sukarela : "+member.getNoMember()+"/"+member.getNama();
                        break;
                }
		
                               
                if(cr.getOID()!=0){
                    
                    int counter = DbGl.getNextCounter();
                    String numberPre = DbGl.getNumberPrefix();
                    String number = cr.getNumber();//DbGl.getNextNumber(counter);
                    
                    long oid = DbGl.postJournalMain(0, cr.getTransDate(), counter, number, numberPre, 
                        I_Project.JOURNAL_TYPE_GENERAL_LEDGER, 
                        memo, cr.getUserId(), "", cr.getOID(), "", cr.getTransDate());
                    
                    if(oid!=0){
                        //kasus  
                        switch(cr.getType()){
                            //tabungan
                            case TABUNGAN_TYPE_CREDIT :
                                //debet cash/bank
                                DbGl.postJournalDetail(er.getValueIdr(), cr.getCashBankCoaId(), 0, cr.getJumlah(),             
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);
                                
                                //credit hutang
                                DbGl.postJournalDetail(er.getValueIdr(), ts.getHutangCoaId(), cr.getJumlah(), 0,             
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);
                                
                                break;
                                
                            case TABUNGAN_TYPE_DEBET :
                                //debet hutang
                                DbGl.postJournalDetail(er.getValueIdr(), ts.getHutangCoaId(), 0, cr.getJumlah(),             
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);
                                
                                //credit kas/bank
                                DbGl.postJournalDetail(er.getValueIdr(), cr.getCashBankCoaId(), cr.getJumlah(), 0,             
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);
                                
                                break;
                                
                            case TABUNGAN_TYPE_BUNGA :
                                //debet biaya bunga
                                DbGl.postJournalDetail(er.getValueIdr(), ts.getBungaCoaId(), 0, cr.getJumlah(),             
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);
                                
                                //credit hutang
                                DbGl.postJournalDetail(er.getValueIdr(), ts.getHutangCoaId(), cr.getJumlah(), 0,              
                                    cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);
                                
                                break;
                                
                            case TABUNGAN_TYPE_ADMIN :
                                if(ts.getAdminActivate()==1){
                                    //debet hutang
                                    DbGl.postJournalDetail(er.getValueIdr(), ts.getHutangCoaId(), 0, cr.getJumlah(),             
                                        cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);

                                    //credit pendapatan admin
                                    DbGl.postJournalDetail(er.getValueIdr(), ts.getAdminCoaId(), cr.getJumlah(), 0,              
                                        cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);
                                }
                                break;
                                
                            case TABUNGAN_TYPE_PAJAK :
                                if(ts.getPajakActivate()==1){
                                    //debet hutang
                                    DbGl.postJournalDetail(er.getValueIdr(), ts.getHutangCoaId(), 0, cr.getJumlah(),             
                                        cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);

                                    //credit hutang pajak
                                    DbGl.postJournalDetail(er.getValueIdr(), ts.getPajakCoaId(), cr.getJumlah(), 0,              
                                        cr.getJumlah(), comp.getBookingCurrencyId(), oid, memo, 0);
                                }
                                break;
                        }
                    }
		
                    //optimalkan, jika akunnya sama digabung    
                    //DbGl.optimizeJournal(oid);
                    
                }
                
            }//end if active  
        }
         
        public static Vector getSaldoTabungan(){
            
            String sql = "SELECT m."+DbMember.colNames[DbMember.COL_NAMA]+
                    ", m."+DbMember.colNames[DbMember.COL_NO_MEMBER]+
                    ", s."+colNames[COL_MEMBER_ID]+
                    ", sum(s."+colNames[COL_CREDIT]+")-sum(s."+colNames[COL_DEBET]+") " +
                    " FROM "+DB_SP_TABUNGAN_SUKARELA+" s "+
                    " inner join "+DbMember.DB_MEMBER+" m "+
                    " on m."+DbMember.colNames[DbMember.COL_MEMBER_ID]+
                    " =s."+colNames[COL_MEMBER_ID]+
                    " group by s."+colNames[COL_MEMBER_ID]+
                    " order by m."+DbMember.colNames[DbMember.COL_NAMA];
            
            CONResultSet crs = null;
            Vector result = new Vector();
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Member member = new Member();
                    member.setNama(rs.getString(1));
                    member.setNoMember(rs.getString(2));
                    member.setOID(rs.getLong(3));
                    TabunganSukarela ts = new TabunganSukarela();
                    ts.setSaldo(rs.getDouble(4));
                    Vector temp = new Vector();
                    temp.add(member);
                    temp.add(ts);
                    
                    result.add(temp);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        public static Vector getBungaTabungan(long periodId){
            
            String sql = "SELECT m."+DbMember.colNames[DbMember.COL_NAMA]+
                    ", m."+DbMember.colNames[DbMember.COL_NO_MEMBER]+
                    ", s."+colNames[COL_MEMBER_ID]+
                    ", sum(s."+colNames[COL_CREDIT]+")"+
                    " FROM "+DB_SP_TABUNGAN_SUKARELA+" s "+
                    " inner join "+DbMember.DB_MEMBER+" m "+
                    " on m."+DbMember.colNames[DbMember.COL_MEMBER_ID]+"=s."+colNames[COL_MEMBER_ID]+
                    " where s."+colNames[COL_TYPE]+"="+TABUNGAN_TYPE_BUNGA+
                    " and s."+colNames[COL_PERIOD_ID]+"="+periodId+
                    " group by s."+colNames[COL_MEMBER_ID]+
                    " order by m."+DbMember.colNames[DbMember.COL_NAMA];
            
            CONResultSet crs = null;
            Vector result = new Vector();
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Member member = new Member();
                    member.setNama(rs.getString(1));
                    member.setNoMember(rs.getString(2));
                    member.setOID(rs.getLong(3));
                    TabunganSukarela ts = new TabunganSukarela();
                    ts.setSaldo(rs.getDouble(4));
                    Vector temp = new Vector();
                    temp.add(member);
                    temp.add(ts);
                    
                    result.add(temp);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
}
