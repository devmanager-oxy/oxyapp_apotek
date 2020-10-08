
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
import com.project.*;


public class DbSimpananMember extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_SIMPANAN_MEMBER = "sp_simpanan_member";

	public static final  int COL_SIMPANAN_MEMBER_ID = 0;
	public static final  int COL_MEMBER_ID = 1;
	public static final  int COL_POKOK = 2;
	public static final  int COL_WAJIB = 3;
	public static final  int COL_SUKARELA_SHU = 4;
	public static final  int COL_SUKARELA_TABUNGAN = 5;
	public static final  int COL_POTONGAN_PINJAMAN = 6;
	public static final  int COL_TOTAL = 7;
	public static final  int COL_TANGGAL = 8;
	public static final  int COL_KETERANGAN = 9;
	public static final  int COL_USER_ID = 10;
	public static final  int COL_STATUS = 11;
	public static final  int COL_COUNTER = 12;
	public static final  int COL_PREFIX_NUMBER = 13;
	public static final  int COL_NUMBER = 14;
        public static final  int COL_SIMPANAN_COA_DEBET_ID = 15;
        public static final  int COL_SIMPANAN_COA_CREDIT_ID = 16;
        
        //public static final  int COL_POKOK_COA_ID = 17;
        //public static final  int COL_SUKARELA_COA_ID = 18;
        public static final  int COL_TYPE = 17;
        
        public static final  int COL_SIMPANAN_COA_POKOK_ID = 18;
        public static final  int COL_SIMPANAN_COA_SUKARELA_ID = 19;
        public static final  int COL_SIMPANAN_COA_SHU_ID = 20;
        public static final  int COL_SIMPANAN_COA_DEBET_NSP_ID = 21;
        public static final  int COL_SIMPANAN_COA_WAJIB_ID = 22;

	public static final  String[] colNames = {		
                "simpanan_member_id",
                "member_id",
                "pokok",
                "wajib",
                "sukarela_shu",
                "sukarela_tabungan",
                "potongan_pinjaman",
                "total",
                "tanggal",
                "keterangan",
                "user_id",
                "status",
                "counter",
                "prefix_number",
                "number",
                "simpanan_coa_debet_id",
                "simpanan_coa_credit_id",
                //"pokok_coa_id",
                //"sukarela_coa_id",
                "type",
                "simpanan_coa_pokok_id",
                "simpanan_coa_sukarela_id",
                "simpanan_coa_shu_id",
                "simpanan_coa_debet_nsp_id",
                "simpanan_coa_wajib_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_INT,
		TYPE_INT,
		TYPE_STRING,
		TYPE_STRING,
                TYPE_LONG,
                TYPE_LONG,
                
                //TYPE_LONG,
                //TYPE_LONG,
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	 }; 
         
         
         public static final int STATUS_DRAFT = 0;
         public static final int STATUS_POSTED  = 1;
         
         

	public DbSimpananMember(){
	}

	public DbSimpananMember(int i) throws CONException { 
		super(new DbSimpananMember()); 
	}

	public DbSimpananMember(String sOid) throws CONException { 
		super(new DbSimpananMember(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbSimpananMember(long lOid) throws CONException { 
		super(new DbSimpananMember(0)); 
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
		return DB_SIMPANAN_MEMBER;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbSimpananMember().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		SimpananMember simpananmember = fetchExc(ent.getOID()); 
		ent = (Entity)simpananmember; 
		return simpananmember.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((SimpananMember) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((SimpananMember) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static SimpananMember fetchExc(long oid) throws CONException{ 
		try{ 
			SimpananMember simpananmember = new SimpananMember();
			DbSimpananMember pstSimpananMember = new DbSimpananMember(oid); 
			simpananmember.setOID(oid);

			simpananmember.setMemberId(pstSimpananMember.getlong(COL_MEMBER_ID));
			simpananmember.setPokok(pstSimpananMember.getdouble(COL_POKOK));
			simpananmember.setWajib(pstSimpananMember.getdouble(COL_WAJIB));
			simpananmember.setSukarelaShu(pstSimpananMember.getdouble(COL_SUKARELA_SHU));
			simpananmember.setSukarelaTabungan(pstSimpananMember.getdouble(COL_SUKARELA_TABUNGAN));
			simpananmember.setPotonganPinjaman(pstSimpananMember.getdouble(COL_POTONGAN_PINJAMAN));
			simpananmember.setTotal(pstSimpananMember.getdouble(COL_TOTAL));
			simpananmember.setTanggal(pstSimpananMember.getDate(COL_TANGGAL));
			simpananmember.setKeterangan(pstSimpananMember.getString(COL_KETERANGAN));
			simpananmember.setUserId(pstSimpananMember.getlong(COL_USER_ID));
			simpananmember.setStatus(pstSimpananMember.getInt(COL_STATUS));
			simpananmember.setCounter(pstSimpananMember.getInt(COL_COUNTER));
			simpananmember.setPrefixNumber(pstSimpananMember.getString(COL_PREFIX_NUMBER));
			simpananmember.setNumber(pstSimpananMember.getString(COL_NUMBER));
                        
                        simpananmember.setSimpananCoaCreditId(pstSimpananMember.getlong(COL_SIMPANAN_COA_CREDIT_ID));
                        simpananmember.setSimpananCoaDebetId(pstSimpananMember.getlong(COL_SIMPANAN_COA_DEBET_ID));
                        simpananmember.setSimpananCoaPokokId(pstSimpananMember.getlong(COL_SIMPANAN_COA_POKOK_ID));
                        simpananmember.setSimpananCoaSukarelaId(pstSimpananMember.getlong(COL_SIMPANAN_COA_SUKARELA_ID));
                        simpananmember.setSimpananCoaShuId(pstSimpananMember.getlong(COL_SIMPANAN_COA_SHU_ID));
                        simpananmember.setSimpananCoaDebetNSPId(pstSimpananMember.getlong(COL_SIMPANAN_COA_DEBET_NSP_ID));
                        simpananmember.setSimpananCoaWajibId(pstSimpananMember.getlong(COL_SIMPANAN_COA_WAJIB_ID));

			return simpananmember; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSimpananMember(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(SimpananMember simpananmember) throws CONException{ 
		try{ 
			DbSimpananMember pstSimpananMember = new DbSimpananMember(0);

			pstSimpananMember.setLong(COL_MEMBER_ID, simpananmember.getMemberId());
			pstSimpananMember.setDouble(COL_POKOK, simpananmember.getPokok());
			pstSimpananMember.setDouble(COL_WAJIB, simpananmember.getWajib());
			pstSimpananMember.setDouble(COL_SUKARELA_SHU, simpananmember.getSukarelaShu());
			pstSimpananMember.setDouble(COL_SUKARELA_TABUNGAN, simpananmember.getSukarelaTabungan());
			pstSimpananMember.setDouble(COL_POTONGAN_PINJAMAN, simpananmember.getPotonganPinjaman());
			pstSimpananMember.setDouble(COL_TOTAL, simpananmember.getTotal());
			pstSimpananMember.setDate(COL_TANGGAL, simpananmember.getTanggal());
			pstSimpananMember.setString(COL_KETERANGAN, simpananmember.getKeterangan());
			pstSimpananMember.setLong(COL_USER_ID, simpananmember.getUserId());
			pstSimpananMember.setInt(COL_STATUS, simpananmember.getStatus());
			pstSimpananMember.setInt(COL_COUNTER, simpananmember.getCounter());
			pstSimpananMember.setString(COL_PREFIX_NUMBER, simpananmember.getPrefixNumber());
			pstSimpananMember.setString(COL_NUMBER, simpananmember.getNumber());
                        
                        pstSimpananMember.setLong(COL_SIMPANAN_COA_CREDIT_ID, simpananmember.getSimpananCoaCreditId());
                        pstSimpananMember.setLong(COL_SIMPANAN_COA_DEBET_ID, simpananmember.getSimpananCoaDebetId());
                        pstSimpananMember.setLong(COL_SIMPANAN_COA_POKOK_ID, simpananmember.getSimpananCoaPokokId());
                        pstSimpananMember.setLong(COL_SIMPANAN_COA_SUKARELA_ID, simpananmember.getSimpananCoaSukarelaId());
                        pstSimpananMember.setLong(COL_SIMPANAN_COA_SHU_ID, simpananmember.getSimpananCoaShuId());
                        pstSimpananMember.setLong(COL_SIMPANAN_COA_DEBET_NSP_ID, simpananmember.getSimpananCoaDebetNSPId());
                        pstSimpananMember.setLong(COL_SIMPANAN_COA_WAJIB_ID, simpananmember.getSimpananCoaWajibId());

			pstSimpananMember.insert(); 
			simpananmember.setOID(pstSimpananMember.getlong(COL_SIMPANAN_MEMBER_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSimpananMember(0),CONException.UNKNOWN); 
		}
		return simpananmember.getOID();
	}

	public static long updateExc(SimpananMember simpananmember) throws CONException{ 
		try{ 
			if(simpananmember.getOID() != 0){ 
				DbSimpananMember pstSimpananMember = new DbSimpananMember(simpananmember.getOID());

				pstSimpananMember.setLong(COL_MEMBER_ID, simpananmember.getMemberId());
				pstSimpananMember.setDouble(COL_POKOK, simpananmember.getPokok());
				pstSimpananMember.setDouble(COL_WAJIB, simpananmember.getWajib());
				pstSimpananMember.setDouble(COL_SUKARELA_SHU, simpananmember.getSukarelaShu());
				pstSimpananMember.setDouble(COL_SUKARELA_TABUNGAN, simpananmember.getSukarelaTabungan());
				pstSimpananMember.setDouble(COL_POTONGAN_PINJAMAN, simpananmember.getPotonganPinjaman());
				pstSimpananMember.setDouble(COL_TOTAL, simpananmember.getTotal());
				pstSimpananMember.setDate(COL_TANGGAL, simpananmember.getTanggal());
				pstSimpananMember.setString(COL_KETERANGAN, simpananmember.getKeterangan());
				pstSimpananMember.setLong(COL_USER_ID, simpananmember.getUserId());
				pstSimpananMember.setInt(COL_STATUS, simpananmember.getStatus());
				pstSimpananMember.setInt(COL_COUNTER, simpananmember.getCounter());
				pstSimpananMember.setString(COL_PREFIX_NUMBER, simpananmember.getPrefixNumber());
				pstSimpananMember.setString(COL_NUMBER, simpananmember.getNumber());
                                
                                pstSimpananMember.setLong(COL_SIMPANAN_COA_CREDIT_ID, simpananmember.getSimpananCoaCreditId());
                                pstSimpananMember.setLong(COL_SIMPANAN_COA_DEBET_ID, simpananmember.getSimpananCoaDebetId());
                                pstSimpananMember.setLong(COL_SIMPANAN_COA_POKOK_ID, simpananmember.getSimpananCoaPokokId());
                                pstSimpananMember.setLong(COL_SIMPANAN_COA_SUKARELA_ID, simpananmember.getSimpananCoaSukarelaId());
                                pstSimpananMember.setLong(COL_SIMPANAN_COA_SHU_ID, simpananmember.getSimpananCoaShuId());
                                pstSimpananMember.setLong(COL_SIMPANAN_COA_DEBET_NSP_ID, simpananmember.getSimpananCoaDebetNSPId());
                                pstSimpananMember.setLong(COL_SIMPANAN_COA_WAJIB_ID, simpananmember.getSimpananCoaWajibId());

				pstSimpananMember.update(); 
				return simpananmember.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSimpananMember(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbSimpananMember pstSimpananMember = new DbSimpananMember(oid);
			pstSimpananMember.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbSimpananMember(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_SIMPANAN_MEMBER; 
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
				SimpananMember simpananmember = new SimpananMember();
				resultToObject(rs, simpananmember);
				lists.add(simpananmember);
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

	private static void resultToObject(ResultSet rs, SimpananMember simpananmember){
		try{
			simpananmember.setOID(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_MEMBER_ID]));
			simpananmember.setMemberId(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_MEMBER_ID]));
			simpananmember.setPokok(rs.getDouble(DbSimpananMember.colNames[DbSimpananMember.COL_POKOK]));
			simpananmember.setWajib(rs.getDouble(DbSimpananMember.colNames[DbSimpananMember.COL_WAJIB]));
			simpananmember.setSukarelaShu(rs.getDouble(DbSimpananMember.colNames[DbSimpananMember.COL_SUKARELA_SHU]));
			simpananmember.setSukarelaTabungan(rs.getDouble(DbSimpananMember.colNames[DbSimpananMember.COL_SUKARELA_TABUNGAN]));
			simpananmember.setPotonganPinjaman(rs.getDouble(DbSimpananMember.colNames[DbSimpananMember.COL_POTONGAN_PINJAMAN]));
			simpananmember.setTotal(rs.getDouble(DbSimpananMember.colNames[DbSimpananMember.COL_TOTAL]));
			simpananmember.setTanggal(rs.getDate(DbSimpananMember.colNames[DbSimpananMember.COL_TANGGAL]));
			simpananmember.setKeterangan(rs.getString(DbSimpananMember.colNames[DbSimpananMember.COL_KETERANGAN]));
			simpananmember.setUserId(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_USER_ID]));
			simpananmember.setStatus(rs.getInt(DbSimpananMember.colNames[DbSimpananMember.COL_STATUS]));
			simpananmember.setCounter(rs.getInt(DbSimpananMember.colNames[DbSimpananMember.COL_COUNTER]));
			simpananmember.setPrefixNumber(rs.getString(DbSimpananMember.colNames[DbSimpananMember.COL_PREFIX_NUMBER]));
			simpananmember.setNumber(rs.getString(DbSimpananMember.colNames[DbSimpananMember.COL_NUMBER]));
                        
                        simpananmember.setSimpananCoaCreditId(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_COA_CREDIT_ID]));
                        simpananmember.setSimpananCoaDebetId(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_COA_DEBET_ID]));
                        simpananmember.setSimpananCoaPokokId(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_COA_POKOK_ID]));
                        simpananmember.setSimpananCoaSukarelaId(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_COA_SUKARELA_ID]));
                        simpananmember.setSimpananCoaShuId(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_COA_SHU_ID]));
                        simpananmember.setSimpananCoaDebetNSPId(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_COA_DEBET_NSP_ID]));
                        simpananmember.setSimpananCoaWajibId(rs.getLong(DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_COA_WAJIB_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long simpananMemberId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_SIMPANAN_MEMBER + " WHERE " + 
						DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_MEMBER_ID] + " = " + simpananMemberId;

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
			String sql = "SELECT COUNT("+ DbSimpananMember.colNames[DbSimpananMember.COL_SIMPANAN_MEMBER_ID] + ") FROM " + DB_SIMPANAN_MEMBER;
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
			  	   SimpananMember simpananmember = (SimpananMember)list.get(ls);
				   if(oid == simpananmember.getOID())
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
                    String sql = "select max("+colNames[COL_COUNTER]+") from "+DB_SIMPANAN_MEMBER+" where "+
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
                
                String code = DbSystemProperty.getValueByName("SIMPANAN_CODE");                                
                
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
        
        public static void insertSimpananFromPotongGaji(RekapMain rm, RekapPotonganGaji rpg){
            
            if(rpg.getSimpananPokok()!=0 || rpg.getSimpananSukarela()!=0 || rpg.getSimpananWajib()!=0){
            
                SimpananMember sm = new SimpananMember();
                sm.setCounter(getNextCounter());
                sm.setPrefixNumber(getNumberPrefix());
                sm.setNumber(getNextNumber(sm.getCounter()));
                sm.setMemberId(rpg.getMemberId());
                sm.setPokok(rpg.getSimpananPokok());
                sm.setWajib(rpg.getSimpananWajib());
                sm.setSukarelaTabungan(rpg.getSimpananSukarela());
                sm.setTotal(rpg.getSimpananPokok()+rpg.getSimpananWajib()+rpg.getSimpananSukarela());
                sm.setUserId(rm.getUserId());
                sm.setKeterangan("Auto - posting dari rekap gaji");
                sm.setTanggal(new Date());
                sm.setStatus(STATUS_POSTED);
                sm.setSimpananCoaCreditId(rm.getSimpananCoaCreditId());
                sm.setSimpananCoaDebetId(rm.getSimpananCoaDebetId());
                sm.setSimpananCoaPokokId(rm.getSimpananPokokCoaId());
                sm.setSimpananCoaSukarelaId(rm.getSimpananSukarelaCoaId());
                
                try{
                    DbSimpananMember.insertExc(sm);
                }
                catch(Exception e){
                }
                
            }
            
        }
        
        public static double getTotalSimpanan(long memberId){
            
            double result = 0;
            
            String sql = "select sum("+colNames[COL_POKOK]+"+"+colNames[COL_WAJIB]+"+"+colNames[COL_SUKARELA_SHU]+"+"+colNames[COL_SUKARELA_TABUNGAN]+")"+
                    " from "+DB_SIMPANAN_MEMBER+" where "+colNames[COL_MEMBER_ID]+"="+memberId;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        public static double getSaldoSebelumnya(long memberId, SimpananMember sm){
            
            double result = 0;
            
            String sql = "select sum("+colNames[COL_POKOK]+"+"+colNames[COL_WAJIB]+"+"+colNames[COL_SUKARELA_SHU]+"+"+colNames[COL_SUKARELA_TABUNGAN]+")"+
                    " from "+DB_SIMPANAN_MEMBER+" where "+colNames[COL_MEMBER_ID]+"="+memberId+" and "+colNames[COL_SIMPANAN_MEMBER_ID]+"<"+sm.getOID();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = rs.getDouble(1);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        public static void postJournal(SimpananMember sm){
            
            Company comp = DbCompany.getCompany();
                
            ExchangeRate er = DbExchangeRate.getStandardRate();
            
            Member member = new Member();
            try{
                member =DbMember.fetchExc(sm.getMemberId());
            }
            catch(Exception e){
            }
                
            if(sm.getOID()!=0){
                                    
                    String memo = "Simpanan member, "+member.getNoMember()+"/"+member.getNama();
                    if(sm.getPokok()<0 || sm.getSukarelaTabungan()<0){
                        memo = "Pengambilan , "+member.getNoMember()+"/"+member.getNama();
                    }
                     
                    double x = sm.getPokok() + sm.getSukarelaShu() + sm.getSukarelaTabungan() + sm.getWajib();
                    
                    System.out.println("Simpanan member, "+member.getNoMember()+"/"+member.getNama());
                    System.out.println("total simpanan : "+x);
                    
                    if(true){//x!=0){
                        //jurnal main    
                        long oid = 0;//DbGl.postJournalMain(0, new Date(), sm.getCounter(), sm.getNumber(), sm.getPrefixNumber(), 
                            //I_Project.JOURNAL_TYPE_SIMPANAN_MEMBER, 
                            //memo, 0, "", sm.getOID(), "", sm.getTanggal());

                        if(oid!=0 ){        

                            memo = "";

                            //jurnal simpanan debet credit
                            if(true){//x!=0){
                                //journal debet simpanan                                 
                                //DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaDebetId(), 0, x,              
                                //            x, comp.getBookingCurrencyId(), oid, memo, 0);//non departmenttal item, department id = 0                                
                                
                                //update & jurnal simpanan pokok
                                if(sm.getPokok()!=0){
                                    
                                    System.out.println("post simpanan pokok : "+sm.getPokok());
                                    
                                    if(member.getSimpananPokok()==0){                            
                                        DbMember.updateSimpananPokok(sm.getMemberId(), sm.getPokok());   
                                    }

                                    if(sm.getPokok()>0){
                                        
                                        //debet cash pokok
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaDebetNSPId(), 0, sm.getPokok(),              
                                            sm.getPokok(), comp.getBookingCurrencyId(), oid, "pokok", 0);//non departmenttal item, department id = 0                                
                                
                                        //journal credit pokok                                
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaPokokId(), sm.getPokok(), 0,              
                                                sm.getPokok(), comp.getBookingCurrencyId(), oid, "pokok", 0); //non departmenttal item, department id = 0
                                    }
                                    //pengambilan
                                    else{
                                        //credit cash pokok
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaDebetNSPId(), (sm.getPokok()*-1), 0,              
                                            (sm.getPokok()*-1), comp.getBookingCurrencyId(), oid, "pokok", 0);//non departmenttal item, department id = 0                                
                                
                                        //journal debet pokok                                
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaPokokId(), 0, (sm.getPokok()*-1),              
                                                (sm.getPokok()*-1), comp.getBookingCurrencyId(), oid, "pokok", 0); //non departmenttal item, department id = 0
                                    }
                                }

                                //update & jurnal simpanan wajib
                                if(sm.getWajib()!=0){
                                    
                                    if(sm.getWajib()>0){                                        
                                        //debet cash wajib
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaWajibId(), 0, sm.getWajib(),              
                                            sm.getWajib(), comp.getBookingCurrencyId(), oid, "wajib", 0);//non departmenttal item, department id = 0                                
                                
                                       //journal credit pokok                                
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaCreditId(), sm.getWajib(), 0,              
                                                sm.getWajib(), comp.getBookingCurrencyId(), oid, "wajib", 0); //non departmenttal item, department id = 0
                                    }
                                    //pengambilan
                                    else{
                                        //credit cash wajib
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaWajibId(), (sm.getWajib()*-1), 0,              
                                            (sm.getWajib()*-1), comp.getBookingCurrencyId(), oid, "wajib", 0);//non departmenttal item, department id = 0                                
                                
                                       //journal debet wajib                                
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaCreditId(), 0, (sm.getWajib()*-1),              
                                                (sm.getWajib()*-1), comp.getBookingCurrencyId(), oid, "wajib", 0); //non departmenttal item, department id = 0
                                    }
                                    
                                    System.out.println("post simpanan wajib : "+sm.getWajib());
                                } 

                                //update & jurnal simpanan sukarela
                                if(sm.getSukarelaTabungan()!=0){
                                    
                                    if(sm.getSukarelaTabungan()>0){                                        
                                        //debet cash wajib
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaDebetId(), 0, sm.getSukarelaTabungan(),              
                                            sm.getSukarelaTabungan(), comp.getBookingCurrencyId(), oid, "sukarela tabungan", 0);//non departmenttal item, department id = 0                                
                                    
                                        //journal credit sukarela                                
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaSukarelaId(), sm.getSukarelaTabungan(), 0,              
                                                sm.getSukarelaTabungan(), comp.getBookingCurrencyId(), oid, "sukarela tabungan", 0); //non departmenttal item, department id = 0
                                    }
                                    else{
                                        //credit cash wajib
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaDebetId(), (sm.getSukarelaTabungan()*-1), 0,              
                                            (sm.getSukarelaTabungan()*-1), comp.getBookingCurrencyId(), oid, "sukarela tabungan", 0);//non departmenttal item, department id = 0                                
                                    
                                        //journal debet sukarela                                
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaSukarelaId(), 0, (sm.getSukarelaTabungan()*-1),              
                                                (sm.getSukarelaTabungan()*-1), comp.getBookingCurrencyId(), oid, "sukarela tabungan", 0); //non departmenttal item, department id = 0
                                    }
                                    
                                    System.out.println("post simpanan getSukarelaTabungan : "+sm.getSukarelaTabungan());
                                }  

                                //update & jurnal simpanan sukarela shu
                                if(sm.getSukarelaShu()!=0){
                                    if(sm.getSukarelaShu()>0){
                                        //debet cash shu
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaDebetId(), 0, sm.getSukarelaShu(),              
                                            sm.getSukarelaShu(), comp.getBookingCurrencyId(), oid, "sukarela shu", 0);//non departmenttal item, department id = 0                                
                                        //journal credit shu                                
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaShuId(), sm.getSukarelaShu(), 0,              
                                                sm.getSukarelaShu(), comp.getBookingCurrencyId(), oid, "sukarela shu", 0); //non departmenttal item, department id = 0
                                    }
                                    else{
                                        //credit cash shu
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaDebetId(), (sm.getSukarelaShu()*-1), 0,              
                                            (sm.getSukarelaShu()*-1), comp.getBookingCurrencyId(), oid, "sukarela shu", 0);//non departmenttal item, department id = 0                                
                                        //journal debet shu                                
                                        DbGl.postJournalDetail(er.getValueIdr(), sm.getSimpananCoaShuId(), 0, (sm.getSukarelaShu()*-1),              
                                                (sm.getSukarelaShu()*-1), comp.getBookingCurrencyId(), oid, "sukarela shu", 0); //non departmenttal item, department id = 0
                                    }
                                    System.out.println("post simpanan getSukarelaShu : "+sm.getSukarelaShu());
                                }      


                                
                            }


                        }//end oid == 0
                        
                        //optimalkan, jika akunnya sama digabung    
                        DbGl.optimizeJournal(oid);
                        
                    }
                    
            }
            
        }
        
        
        public static Vector getSaldoSimpanan(){
            
            String sql = "SELECT "+
                        " m."+colNames[COL_MEMBER_ID]+", "+
                        " sum(s."+colNames[COL_POKOK]+") as pokok, " +
                        " sum(s."+colNames[COL_WAJIB]+") as wajib, " +
                        " sum(s."+colNames[COL_SUKARELA_SHU]+") as sukarela_shu, " +
                        " sum(s."+colNames[COL_SUKARELA_TABUNGAN]+") as sukarela_tabungan " +
                        ", m."+DbMember.colNames[DbMember.COL_NO_MEMBER]+
                        ", m."+DbMember.colNames[DbMember.COL_NAMA]+                        
                        //", d."+DbDinas.colNames[DbDinas.COL_NAMA]+
                        //", d."+DbDinas.colNames[DbDinas.COL_DINAS_ID]+
                        ", m."+DbMember.colNames[DbMember.COL_STATUS]+
                        " FROM "+DB_SIMPANAN_MEMBER+" s "+
                        " inner join "+DbMember.DB_MEMBER+" m on "+
                        " m."+DbMember.colNames[DbMember.COL_MEMBER_ID]+
                        " = s."+colNames[COL_MEMBER_ID]+
                        //" inner join "+DbDinas.DB_DINAS+" d on "+
                        //" d."+DbDinas.colNames[DbDinas.COL_DINAS_ID]+
                        "  = m."+DbMember.colNames[DbMember.COL_DINAS_ID]+
                        " group by s."+colNames[COL_MEMBER_ID]+
                        " order by m."+DbMember.colNames[DbMember.COL_DINAS_ID]+
                        //", m."+DbMember.colNames[DbMember.COL_DINAS_UNIT_ID]+
                        ", m."+DbMember.colNames[DbMember.COL_NO_MEMBER];
            
            
            System.out.println(sql);
            
            Vector result = new Vector();
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    SimpananMember sm = new SimpananMember();
                    sm.setMemberId(rs.getLong(1));
                    sm.setPokok(rs.getDouble(2));
                    sm.setWajib(rs.getDouble(3));
                    sm.setSukarelaShu(rs.getDouble(4));
                    sm.setSukarelaTabungan(rs.getDouble(5));
                    
                    Member member = new Member();
                    member.setOID(sm.getMemberId());
                    member.setNoMember(rs.getString(6));
                    member.setNama(rs.getString(7));
                    member.setStatus(rs.getInt(10));
                    
                    //Dinas dinas = new Dinas();
                    //dinas.setOID(rs.getLong(9));
                    //dinas.setNama(rs.getString(8));
                    
                    Vector v = new Vector();
                    v.add(sm);
                    v.add(member);
                    //v.add(dinas);
                    
                    result.add(v);
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
