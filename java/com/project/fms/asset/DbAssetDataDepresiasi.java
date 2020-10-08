package com.project.fms.asset; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.fms.ar.*; 
import com.project.*;
import com.project.util.*;
import com.project.util.lang.I_Language;
import com.project.fms.master.*;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Location;
import com.project.general.DbLocation;
import com.project.fms.transaction.*;

public class DbAssetDataDepresiasi extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language { 

	public static final  String DB_ASSET_DATA_DEPRESIASI = "asset_data_depresiasi";

	public static final  int COL_ASSET_DATA_ID = 0;
	public static final  int COL_DATE = 1;
	public static final  int COL_PERIODE_ID = 2;
	public static final  int COL_MTH = 3;
	public static final  int COL_YEAR = 4;
	public static final  int COL_AMOUNT = 5;
	public static final  int COL_USER_ID = 6;
	public static final  int COL_NUMBER = 7;
	public static final  int COL_PREFIX_NUMBER = 8;
	public static final  int COL_COUNTER = 9;
	public static final  int COL_COA_AKUM_DEP_ID = 10;
	public static final  int COL_COA_EXPENSE_DEP_ID = 11;
	public static final  int COL_DEPRE_DATE = 12;
	public static final  int COL_ASSET_DATA_DEPRESIASI_ID = 13;
        public static final  int COL_PENGURANG = 14;

	public static final  String[] colNames = {
		"asset_data_id",
                "date",
                "periode_id",
                "mth",
                "year",
                "amount",
                "user_id",
                "number",
                "prefix_number",
                "counter",
                "coa_akum_dep_id",
                "coa_expense_dep_id",
                "depre_date",
                "asset_data_depresiasi_id",
                "pengurang"

	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG,
		TYPE_INT,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE,
		TYPE_LONG + TYPE_PK + TYPE_ID,
                TYPE_FLOAT
	 }; 

	public DbAssetDataDepresiasi(){
	}

	public DbAssetDataDepresiasi(int i) throws CONException { 
		super(new DbAssetDataDepresiasi()); 
	}

	public DbAssetDataDepresiasi(String sOid) throws CONException { 
		super(new DbAssetDataDepresiasi(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbAssetDataDepresiasi(long lOid) throws CONException { 
		super(new DbAssetDataDepresiasi(0)); 
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
		return DB_ASSET_DATA_DEPRESIASI;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbAssetDataDepresiasi().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		AssetDataDepresiasi assetdatadepresiasi = fetchExc(ent.getOID()); 
		ent = (Entity)assetdatadepresiasi; 
		return assetdatadepresiasi.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((AssetDataDepresiasi) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((AssetDataDepresiasi) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static AssetDataDepresiasi fetchExc(long oid) throws CONException{ 
		try{ 
			AssetDataDepresiasi assetdatadepresiasi = new AssetDataDepresiasi();
			DbAssetDataDepresiasi pstAssetDataDepresiasi = new DbAssetDataDepresiasi(oid); 
			assetdatadepresiasi.setOID(oid);

			assetdatadepresiasi.setAssetDataId(pstAssetDataDepresiasi.getlong(COL_ASSET_DATA_ID));
			assetdatadepresiasi.setDate(pstAssetDataDepresiasi.getDate(COL_DATE));
			assetdatadepresiasi.setPeriodeId(pstAssetDataDepresiasi.getlong(COL_PERIODE_ID));
			assetdatadepresiasi.setMth(pstAssetDataDepresiasi.getInt(COL_MTH));
			assetdatadepresiasi.setYear(pstAssetDataDepresiasi.getInt(COL_YEAR));
			assetdatadepresiasi.setAmount(pstAssetDataDepresiasi.getdouble(COL_AMOUNT));
			assetdatadepresiasi.setUserId(pstAssetDataDepresiasi.getlong(COL_USER_ID));
			assetdatadepresiasi.setNumber(pstAssetDataDepresiasi.getString(COL_NUMBER));
			assetdatadepresiasi.setPrefixNumber(pstAssetDataDepresiasi.getString(COL_PREFIX_NUMBER));
			assetdatadepresiasi.setCounter(pstAssetDataDepresiasi.getInt(COL_COUNTER));
			assetdatadepresiasi.setCoaAkumDepId(pstAssetDataDepresiasi.getlong(COL_COA_AKUM_DEP_ID));
			assetdatadepresiasi.setCoaExpenseDepId(pstAssetDataDepresiasi.getlong(COL_COA_EXPENSE_DEP_ID));
			assetdatadepresiasi.setDepreDate(pstAssetDataDepresiasi.getDate(COL_DEPRE_DATE));
                        
                        assetdatadepresiasi.setPengurang(pstAssetDataDepresiasi.getdouble(COL_PENGURANG));

			return assetdatadepresiasi; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetDataDepresiasi(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(AssetDataDepresiasi assetdatadepresiasi) throws CONException{ 
		try{ 
			DbAssetDataDepresiasi pstAssetDataDepresiasi = new DbAssetDataDepresiasi(0);

			pstAssetDataDepresiasi.setLong(COL_ASSET_DATA_ID, assetdatadepresiasi.getAssetDataId());
			pstAssetDataDepresiasi.setDate(COL_DATE, assetdatadepresiasi.getDate());
			pstAssetDataDepresiasi.setLong(COL_PERIODE_ID, assetdatadepresiasi.getPeriodeId());
			pstAssetDataDepresiasi.setInt(COL_MTH, assetdatadepresiasi.getMth());
			pstAssetDataDepresiasi.setInt(COL_YEAR, assetdatadepresiasi.getYear());
			pstAssetDataDepresiasi.setDouble(COL_AMOUNT, assetdatadepresiasi.getAmount());
			pstAssetDataDepresiasi.setLong(COL_USER_ID, assetdatadepresiasi.getUserId());
			pstAssetDataDepresiasi.setString(COL_NUMBER, assetdatadepresiasi.getNumber());
			pstAssetDataDepresiasi.setString(COL_PREFIX_NUMBER, assetdatadepresiasi.getPrefixNumber());
			pstAssetDataDepresiasi.setInt(COL_COUNTER, assetdatadepresiasi.getCounter());
			pstAssetDataDepresiasi.setLong(COL_COA_AKUM_DEP_ID, assetdatadepresiasi.getCoaAkumDepId());
			pstAssetDataDepresiasi.setLong(COL_COA_EXPENSE_DEP_ID, assetdatadepresiasi.getCoaExpenseDepId());
			pstAssetDataDepresiasi.setDate(COL_DEPRE_DATE, assetdatadepresiasi.getDepreDate());
                        
                        pstAssetDataDepresiasi.setDouble(COL_PENGURANG, assetdatadepresiasi.getPengurang());

			pstAssetDataDepresiasi.insert(); 
			assetdatadepresiasi.setOID(pstAssetDataDepresiasi.getlong(COL_ASSET_DATA_DEPRESIASI_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetDataDepresiasi(0),CONException.UNKNOWN); 
		}
		return assetdatadepresiasi.getOID();
	}

	public static long updateExc(AssetDataDepresiasi assetdatadepresiasi) throws CONException{ 
		try{ 
			if(assetdatadepresiasi.getOID() != 0){ 
				DbAssetDataDepresiasi pstAssetDataDepresiasi = new DbAssetDataDepresiasi(assetdatadepresiasi.getOID());

				pstAssetDataDepresiasi.setLong(COL_ASSET_DATA_ID, assetdatadepresiasi.getAssetDataId());
				pstAssetDataDepresiasi.setDate(COL_DATE, assetdatadepresiasi.getDate());
				pstAssetDataDepresiasi.setLong(COL_PERIODE_ID, assetdatadepresiasi.getPeriodeId());
				pstAssetDataDepresiasi.setInt(COL_MTH, assetdatadepresiasi.getMth());
				pstAssetDataDepresiasi.setInt(COL_YEAR, assetdatadepresiasi.getYear());
				pstAssetDataDepresiasi.setDouble(COL_AMOUNT, assetdatadepresiasi.getAmount());
				pstAssetDataDepresiasi.setLong(COL_USER_ID, assetdatadepresiasi.getUserId());
				pstAssetDataDepresiasi.setString(COL_NUMBER, assetdatadepresiasi.getNumber());
				pstAssetDataDepresiasi.setString(COL_PREFIX_NUMBER, assetdatadepresiasi.getPrefixNumber());
				pstAssetDataDepresiasi.setInt(COL_COUNTER, assetdatadepresiasi.getCounter());
				pstAssetDataDepresiasi.setLong(COL_COA_AKUM_DEP_ID, assetdatadepresiasi.getCoaAkumDepId());
				pstAssetDataDepresiasi.setLong(COL_COA_EXPENSE_DEP_ID, assetdatadepresiasi.getCoaExpenseDepId());
				pstAssetDataDepresiasi.setDate(COL_DEPRE_DATE, assetdatadepresiasi.getDepreDate());
                                
                                pstAssetDataDepresiasi.setDouble(COL_PENGURANG, assetdatadepresiasi.getPengurang());

				pstAssetDataDepresiasi.update(); 
				return assetdatadepresiasi.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetDataDepresiasi(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbAssetDataDepresiasi pstAssetDataDepresiasi = new DbAssetDataDepresiasi(oid);
			pstAssetDataDepresiasi.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAssetDataDepresiasi(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_ASSET_DATA_DEPRESIASI; 
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
				AssetDataDepresiasi assetdatadepresiasi = new AssetDataDepresiasi();
				resultToObject(rs, assetdatadepresiasi);
				lists.add(assetdatadepresiasi);
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

	private static void resultToObject(ResultSet rs, AssetDataDepresiasi assetdatadepresiasi){
		try{
			assetdatadepresiasi.setOID(rs.getLong(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_ASSET_DATA_DEPRESIASI_ID]));
			assetdatadepresiasi.setAssetDataId(rs.getLong(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_ASSET_DATA_ID]));
			assetdatadepresiasi.setDate(rs.getDate(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_DATE]));
			assetdatadepresiasi.setPeriodeId(rs.getLong(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_PERIODE_ID]));
			assetdatadepresiasi.setMth(rs.getInt(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_MTH]));
			assetdatadepresiasi.setYear(rs.getInt(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_YEAR]));
			assetdatadepresiasi.setAmount(rs.getDouble(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_AMOUNT]));
			assetdatadepresiasi.setUserId(rs.getLong(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_USER_ID]));
			assetdatadepresiasi.setNumber(rs.getString(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_NUMBER]));
			assetdatadepresiasi.setPrefixNumber(rs.getString(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_PREFIX_NUMBER]));
			assetdatadepresiasi.setCounter(rs.getInt(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_COUNTER]));
			assetdatadepresiasi.setCoaAkumDepId(rs.getLong(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_COA_AKUM_DEP_ID]));
			assetdatadepresiasi.setCoaExpenseDepId(rs.getLong(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_COA_EXPENSE_DEP_ID]));
			assetdatadepresiasi.setDepreDate(rs.getDate(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_DEPRE_DATE]));
                        
                        assetdatadepresiasi.setPengurang(rs.getDouble(DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_PENGURANG]));

		}catch(Exception e){ }
	}

	/*public static boolean checkOID(long assetDataDepresiasiId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_ASSET_DATA_DEPRESIASI + " WHERE " + 
						DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_ASSET_DATA_ID] + " = " + assetDataId;

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
         */

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbAssetDataDepresiasi.colNames[DbAssetDataDepresiasi.COL_ASSET_DATA_DEPRESIASI_ID] + ") FROM " + DB_ASSET_DATA_DEPRESIASI;
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
			  	   AssetDataDepresiasi assetdatadepresiasi = (AssetDataDepresiasi)list.get(ls);
				   if(oid == assetdatadepresiasi.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static double getTotalDepresiasi(long assetDataId){
            
            String sql = "select sum("+colNames[COL_AMOUNT]+"-"+colNames[COL_PENGURANG]+") from "+DB_ASSET_DATA_DEPRESIASI+
                    " where "+colNames[COL_ASSET_DATA_ID]+"="+assetDataId;

            AssetData ad = new AssetData();
            double result = 0;
            try{
                ad = DbAssetData.fetchExc(assetDataId);
                result = ad.getTotalDepreSebelum();
            }
            catch(Exception e){
            }            
            
            CONResultSet crs = null;            
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    result = result + rs.getDouble(1);
                }
            }
            catch(Exception e){
            
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        
        public static void postJournal(Vector vct){
            
            System.out.println("\n\nin post jurnal ---------");
            
            if(vct!=null && vct.size()>0){
                
                AssetDataDepresiasi add = (AssetDataDepresiasi)vct.get(0);
                
                
                Company comp = DbCompany.getCompany();
            
                Gl gl = new Gl();
                gl.setCurrencyId(comp.getBookingCurrencyId());
                gl.setDate(new Date());
                gl.setTransDate(new Date());
                gl.setActivityStatus(I_Project.STATUS_POSTED);
                gl.setJournalType(I_Project.JOURNAL_TYPE_GENERAL_LEDGER);
                gl.setMemo("Auto generate depresiasi");
                gl.setOperatorId(add.getUserId());
                gl.setOwnerId(0);
                gl.setPeriodId(add.getPeriodeId());
                gl.setRefNumber("-");
                
                gl.setJournalCounter(DbGl.getNextCounter());
                gl.setJournalPrefix(DbGl.getNumberPrefix());
                gl.setJournalNumber(DbGl.getNextNumber(gl.getJournalCounter()));
                
                long oidGl = 0;
                try{
                    oidGl = DbGl.insertExc(gl);
                }
                catch(Exception e){
                    
                }
                
                System.out.println("oidGl : "+oidGl);
                
                if(oidGl!=0){
            
                    for(int i=0; i<vct.size(); i++){
                        AssetDataDepresiasi ass = (AssetDataDepresiasi)vct.get(i);
                        ass.setCounter(gl.getJournalCounter());
                        ass.setPrefixNumber(gl.getJournalPrefix());
                        ass.setNumber(gl.getJournalNumber());

                        //debet expense
                        GlDetail gd = new GlDetail();
                        gd.setBookedRate(1);
                        gd.setCoaId(ass.getCoaExpenseDepId());
                        gd.setDebet(ass.getAmount()-ass.getPengurang());
                        gd.setGlId(oidGl);
                        gd.setForeignCurrencyId(gl.getCurrencyId());
                        gd.setForeignCurrencyAmount(gd.getDebet());
                        gd.setMemo("");
                        
                        long oid1 = 0;
                        try{
                            oid1 = DbGlDetail.insertExc(gd);
                        }
                        catch(Exception e){

                        }
                        
                        //debet akum dep
                        gd = new GlDetail();
                        gd.setBookedRate(1);
                        gd.setCoaId(ass.getCoaAkumDepId());
                        gd.setCredit(ass.getAmount()-ass.getPengurang());
                        gd.setGlId(oidGl);
                        gd.setForeignCurrencyId(gl.getCurrencyId());
                        gd.setForeignCurrencyAmount(gd.getDebet());
                        gd.setMemo("");
                        
                        long oid2 = 0;
                        try{
                            oid2 = DbGlDetail.insertExc(gd);
                        }
                        catch(Exception e){

                        }
                        
                        if(oid1!=0 && oid2!=0){
                            try{
                                DbAssetDataDepresiasi.insertExc(ass);
                            }
                            catch(Exception e){
                                
                            }
                        }
                        
                        System.out.println("    ---> i "+i);

                    }
                    
                    DbGl.optimizeJournal(oidGl);
                }
            }
            
        }
        
        
        public static double getTotalDepreBeforeDate(Date dt, long assetDataId){
            
            String sql = "SELECT sum(ass."+colNames[COL_AMOUNT]+"-ass."+colNames[COL_PENGURANG]+") as total "+
                    " FROM "+DB_ASSET_DATA_DEPRESIASI+" ass "+
                    " inner join "+DbPeriode.DB_PERIODE+" p "+
                    " on p."+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" =  ass."+colNames[COL_PERIODE_ID]+
                    " where p."+DbPeriode.colNames[DbPeriode.COL_END_DATE]+" < '"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"'"+
                    " and ass."+colNames[COL_ASSET_DATA_ID]+"="+assetDataId+
                    " group by ass."+colNames[COL_ASSET_DATA_ID];
            
            double result = 0;
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
        
        public static AssetDataDepresiasi getObjDepreInDate(Date dt, long assetDataId){
            
            String sql = "SELECT ass.*"+
                    " FROM "+DB_ASSET_DATA_DEPRESIASI+" ass "+
                    " inner join "+DbPeriode.DB_PERIODE+" p "+
                    " on p."+DbPeriode.colNames[DbPeriode.COL_PERIODE_ID]+" =  ass."+colNames[COL_PERIODE_ID]+
                    " where ('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"' between p."+DbPeriode.colNames[DbPeriode.COL_START_DATE]+
                    " and p."+DbPeriode.colNames[DbPeriode.COL_END_DATE]+")"+
                    " and ass."+colNames[COL_ASSET_DATA_ID]+"="+assetDataId;
            
            AssetDataDepresiasi ass = new AssetDataDepresiasi();
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    resultToObject(rs, ass);
                }
            }
            catch(Exception e){
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return ass;
            
        }
        
        
        public static AssetDataDepresiasi getDepresiasiByPeriod(long periodeId, long assetDataId){
            
            String where = colNames[COL_PERIODE_ID]+"="+periodeId+" and "+colNames[COL_ASSET_DATA_ID]+"="+assetDataId;
            
            Vector v = list(0,0, where, "");
            
            if(v!=null && v.size()>0){
                return (AssetDataDepresiasi)v.get(0);
            }
            
            return new AssetDataDepresiasi();
            
        }
        
        
        
        
        
}
