
package com.project.fms.master; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.transaction.*;
import com.project.*;

public class DbAccLink extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_ACC_LINK = "acc_link";

	public static final  int COL_ACC_LINK_ID = 0;
	public static final  int COL_COA_ID = 1;
	public static final  int COL_DEPARTMENT_ID = 2;
	public static final  int COL_TYPE = 3;
	public static final  int COL_COA_NAME = 4;
	public static final  int COL_COA_CODE = 5;
	public static final  int COL_DEPARTMENT_NAME = 6;
	public static final  int COL_USER_ID = 7;
        public static final  int COL_LOCATION_ID = 8;
        
        public static final  int COL_COMPANY_ID = 9;

	public static final  String[] colNames = {
		"acc_link_id",
		"coa_id",
		"department_id",
		"type",
		"coa_name",
		"coa_code",
		"department_name",
		"user_id",
                "location_id",
                "company_id"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	 }; 

	public DbAccLink(){
	}

	public DbAccLink(int i) throws CONException { 
		super(new DbAccLink()); 
	}

	public DbAccLink(String sOid) throws CONException { 
		super(new DbAccLink(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbAccLink(long lOid) throws CONException { 
		super(new DbAccLink(0)); 
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
		return DB_ACC_LINK;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbAccLink().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		AccLink acclink = fetchExc(ent.getOID()); 
		ent = (Entity)acclink; 
		return acclink.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((AccLink) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((AccLink) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static AccLink fetchExc(long oid) throws CONException{ 
		try{ 
			AccLink acclink = new AccLink();
			DbAccLink dbAccLink = new DbAccLink(oid); 
			acclink.setOID(oid);

			acclink.setCoaId(dbAccLink.getlong(COL_COA_ID));
			acclink.setDepartmentId(dbAccLink.getlong(COL_DEPARTMENT_ID));
			acclink.setType(dbAccLink.getString(COL_TYPE));
			acclink.setCoaName(dbAccLink.getString(COL_COA_NAME));
			acclink.setCoaCode(dbAccLink.getString(COL_COA_CODE));
			acclink.setDepartmentName(dbAccLink.getString(COL_DEPARTMENT_NAME));
			acclink.setUserId(dbAccLink.getlong(COL_USER_ID));
                        acclink.setLocationId(dbAccLink.getlong(COL_LOCATION_ID));
                        
                        acclink.setCompanyId(dbAccLink.getlong(COL_COMPANY_ID));
                        

			return acclink; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAccLink(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(AccLink acclink) throws CONException{ 
		try{ 
			DbAccLink dbAccLink = new DbAccLink(0);

			dbAccLink.setLong(COL_COA_ID, acclink.getCoaId());
			dbAccLink.setLong(COL_DEPARTMENT_ID, acclink.getDepartmentId());
			dbAccLink.setString(COL_TYPE, acclink.getType());
			dbAccLink.setString(COL_COA_NAME, acclink.getCoaName());
			dbAccLink.setString(COL_COA_CODE, acclink.getCoaCode());
			dbAccLink.setString(COL_DEPARTMENT_NAME, acclink.getDepartmentName());
			dbAccLink.setLong(COL_USER_ID, acclink.getUserId());
                        dbAccLink.setLong(COL_LOCATION_ID, acclink.getLocationId());
                        
                        dbAccLink.setLong(COL_COMPANY_ID, acclink.getCompanyId());
                        

			dbAccLink.insert(); 
			acclink.setOID(dbAccLink.getlong(COL_ACC_LINK_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAccLink(0),CONException.UNKNOWN); 
		}
		return acclink.getOID();
	}

	public static long updateExc(AccLink acclink) throws CONException{ 
		try{ 
			if(acclink.getOID() != 0){ 
				DbAccLink dbAccLink = new DbAccLink(acclink.getOID());

				dbAccLink.setLong(COL_COA_ID, acclink.getCoaId());
				dbAccLink.setLong(COL_DEPARTMENT_ID, acclink.getDepartmentId());
				dbAccLink.setString(COL_TYPE, acclink.getType());
				dbAccLink.setString(COL_COA_NAME, acclink.getCoaName());
				dbAccLink.setString(COL_COA_CODE, acclink.getCoaCode());
				dbAccLink.setString(COL_DEPARTMENT_NAME, acclink.getDepartmentName());
				dbAccLink.setLong(COL_USER_ID, acclink.getUserId());
                                dbAccLink.setLong(COL_LOCATION_ID, acclink.getLocationId());
                                
                                dbAccLink.setLong(COL_COMPANY_ID, acclink.getCompanyId());
                                

				dbAccLink.update(); 
				return acclink.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAccLink(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbAccLink dbAccLink = new DbAccLink(oid);
			dbAccLink.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbAccLink(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_ACC_LINK; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			
                        switch (CONHandler.CONSVR_TYPE) {
                            case CONHandler.CONSVR_MYSQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                                break;

                            case CONHandler.CONSVR_POSTGRESQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;

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
				AccLink acclink = new AccLink();
				resultToObject(rs, acclink);
				lists.add(acclink);
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

	private static void resultToObject(ResultSet rs, AccLink acclink){
		try{
			acclink.setOID(rs.getLong(DbAccLink.colNames[DbAccLink.COL_ACC_LINK_ID]));
			acclink.setCoaId(rs.getLong(DbAccLink.colNames[DbAccLink.COL_COA_ID]));
			acclink.setDepartmentId(rs.getLong(DbAccLink.colNames[DbAccLink.COL_DEPARTMENT_ID]));
			acclink.setType(rs.getString(DbAccLink.colNames[DbAccLink.COL_TYPE]));
			acclink.setCoaName(rs.getString(DbAccLink.colNames[DbAccLink.COL_COA_NAME]));
			acclink.setCoaCode(rs.getString(DbAccLink.colNames[DbAccLink.COL_COA_CODE]));
			acclink.setDepartmentName(rs.getString(DbAccLink.colNames[DbAccLink.COL_DEPARTMENT_NAME]));
			acclink.setUserId(rs.getLong(DbAccLink.colNames[DbAccLink.COL_USER_ID]));
                        acclink.setLocationId(rs.getLong(DbAccLink.colNames[DbAccLink.COL_LOCATION_ID]));
                        
                        acclink.setCompanyId(rs.getLong(DbAccLink.colNames[DbAccLink.COL_COMPANY_ID]));
                        

		}catch(Exception e){ }
	}

	public static boolean checkOID(long accLinkId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_ACC_LINK + " WHERE " + 
						DbAccLink.colNames[DbAccLink.COL_ACC_LINK_ID] + " = " + accLinkId;

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
			String sql = "SELECT COUNT("+ DbAccLink.colNames[DbAccLink.COL_ACC_LINK_ID] + ") FROM " + DB_ACC_LINK;
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
			  	   AccLink acclink = (AccLink)list.get(ls);
				   if(oid == acclink.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static Vector getPettyCashAccountBalance(Vector accLinks){
            
                Periode openPeriod = DbPeriode.getOpenPeriod();
                Vector result = new Vector();
                if(accLinks!=null && accLinks.size()>0){
                    for(int i=0; i<accLinks.size(); i++){
                        AccLink acclink = (AccLink)accLinks.get(i);
                        
                        double openingBalance = DbCoaOpeningBalance.getOpeningBalance(openPeriod, acclink.getCoaId());
                        double payment = DbPettycashPayment.getPaymentByPeriod(openPeriod, acclink.getCoaId());
                        double replacement = DbPettycashReplenishment.getReplenishmentByPeriod(openPeriod, acclink.getCoaId());
                        
                        
                        Coa coa = new Coa();
                        coa.setOID(acclink.getCoaId());
                        try{
                            coa = DbCoa.fetchExc(coa.getOID());
                        }
                        catch(Exception e){
                        }
                        
                        coa.setOpeningBalance(openingBalance-payment+replacement);
                        result.add(coa);
                        
                        
                        if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                            
                            System.out.println("\n\n==== ********* not postable ---> get recursif ------");
                            
                            Vector vx = getBalanceRecursif(coa);
                            if(vx!=null && vx.size()>0){
                                result.addAll(vx);
                            }
                        }
                        
                    }
                }
                    
                return result;
                
        }
        
        
        public static Vector getBalanceRecursif(Coa coa){
            
            System.out.println("===> in recursif");
            
            Vector result = new Vector();
            Vector v = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID]+"="+coa.getOID(), "");
            if(v!=null && v.size()>0){
                for(int i=0; i<v.size(); i++){
                    Coa coax = (Coa)v.get(i);
                    if(!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                        Vector vx = getBalanceRecursif(coax);
                        if(vx!=null && vx.size()>0){
                            result.add(vx);
                        }
                    }
                    else{
                        double x = DbCoa.getCoaBalance(coax.getOID());
                        coax.setOpeningBalance(x);
                        result.add(coax);
                    }
                }
            }
            
            return result;
        }
        
        public static Vector getBalanceRecursif(Vector result, Coa coa){
            
            System.out.println("===> in recursif");
            
            //Vector result = new Vector();
            Vector v = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_ACC_REF_ID]+"="+coa.getOID(), "");
            if(v!=null && v.size()>0){
                for(int i=0; i<v.size(); i++){
                    Coa coax = (Coa)v.get(i);
                    if(!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                        result = getBalanceRecursif(result, coax);
                        //if(vx!=null && vx.size()>0){
                        //    result.add(vx);
                        //}
                    }
                    else{
                        double x = DbCoa.getCoaBalance(coax.getOID());
                        coax.setOpeningBalance(x);
                        result.add(coax);
                    }
                }
            }
            
            return result;
        }
        
        public static Vector getBankAccountBalance(Vector accLinks,long periodeId){
                
                Periode openPeriod = new Periode();
                
                if(periodeId != 0){
                    try{
                        openPeriod = DbPeriode.fetchExc(periodeId);
                    }catch(Exception e){}
                }else{
                    openPeriod = DbPeriode.getOpenPeriod();
                }
                
                Vector result = new Vector();
                if(accLinks!=null && accLinks.size()>0){
                    for(int i=0; i<accLinks.size(); i++){
                        AccLink acclink = (AccLink)accLinks.get(i);
                        
                        double openingBalance = DbCoaOpeningBalance.getOpeningBalance(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("openingBalance : "+openingBalance);
                        
                        double payment = DbPettycashReplenishment.getBankReplenishmentByPeriod(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("\npayment 1 : "+payment);
                        
                        payment = payment + DbBanknonpoPayment.getPaymentByPeriod(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("\npayment 2 : "+payment);
                        
                        payment = payment + DbBankpoPayment.getPaymentByPeriod(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("\npayment 2 : "+payment);
                        
                        double deposit = DbBankDeposit.getDeposiByPeriod(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("\ndeposit : "+deposit);
                        
                        Coa coa = new Coa();
                        coa.setOID(acclink.getCoaId());
                        coa.setOpeningBalance(openingBalance-payment+deposit);
                        result.add(coa);
                        
                        if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                            
                            System.out.println("\n\n==== ********* not postable ---> get recursif ------");
                            
                            //Vector vx = getBalanceRecursif(coa);
                            //if(vx!=null && vx.size()>0){
                            //    result.addAll(vx);
                            //}
                            
                            result = getBalanceRecursif(result, coa);
                            
                        }
                    }
                }
                    
                return result;
                
        }
        
        
        public static Vector getBankAccountBalance(Vector accLinks){
            
                Periode openPeriod = DbPeriode.getOpenPeriod();
                Vector result = new Vector();
                if(accLinks!=null && accLinks.size()>0){
                    for(int i=0; i<accLinks.size(); i++){
                        AccLink acclink = (AccLink)accLinks.get(i);
                        
                        double openingBalance = DbCoaOpeningBalance.getOpeningBalance(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("openingBalance : "+openingBalance);
                        
                        double payment = DbPettycashReplenishment.getBankReplenishmentByPeriod(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("\npayment 1 : "+payment);
                        
                        payment = payment + DbBanknonpoPayment.getPaymentByPeriod(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("\npayment 2 : "+payment);
                        
                        payment = payment + DbBankpoPayment.getPaymentByPeriod(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("\npayment 2 : "+payment);
                        
                        double deposit = DbBankDeposit.getDeposiByPeriod(openPeriod, acclink.getCoaId());
                        
                        //System.out.println("\ndeposit : "+deposit);
                        
                        Coa coa = new Coa();
                        coa.setOID(acclink.getCoaId());
                        coa.setOpeningBalance(openingBalance-payment+deposit);
                        result.add(coa);
                        
                        if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
                            
                            System.out.println("\n\n==== ********* not postable ---> get recursif ------");
                            
                            //Vector vx = getBalanceRecursif(coa);
                            //if(vx!=null && vx.size()>0){
                            //    result.addAll(vx);
                            //}
                            
                            result = getBalanceRecursif(result, coa);
                            
                        }
                    }
                }
                    
                return result;
                
        }
        
        
        public static Vector getLinkCoas(String type, long locationId){
            CONResultSet crs = null;
            Vector result = new Vector();
            try{
                String sql = " SELECT c.* FROM "+DB_ACC_LINK+" a "+
                             " inner join "+DbCoa.DB_COA+" c on c."+DbCoa.colNames[DbCoa.COL_COA_ID]+"=a."+colNames[COL_COA_ID]+
                             " where a."+colNames[COL_TYPE]+"='"+type+"'";
                             
                
                if(locationId != 0){
                    sql = sql + " and (a."+colNames[COL_LOCATION_ID]+"="+locationId +" or a."+colNames[COL_LOCATION_ID]+"=0)";
                }
                
                sql = sql + " order by c."+DbCoa.colNames[DbCoa.COL_CODE];
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    Coa coa = new Coa();
                    DbCoa.resultToObject(rs, coa);
                    result.add(coa);
                }
                                
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return result;
            
        }
        
        public static void deleteAllByType(String type){
            try{
                String sql = "delete from "+DB_ACC_LINK+" where "+colNames[COL_TYPE]+"='"+type+"'";
                CONHandler.execUpdate(sql);
            }
            catch(Exception e){
                
            }
        }
        
        public static void resetData(String type, String group){
            
            deleteAllByType(type);
            
            Vector coas = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_STATUS]+"='POSTABLE' "+
                " and "+DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP]+"='"+group+"'", DbCoa.colNames[DbCoa.COL_CODE]);
            
            if(coas!=null && coas.size()>0){
                for(int i=0; i<coas.size(); i++){
                    Coa coa = (Coa)coas.get(i);
                    AccLink al = new AccLink();
                    al.setCoaCode(coa.getCode());
                    al.setCoaId(coa.getOID());
                    al.setCoaName(coa.getName());
                    al.setType(type);
                    //al.set
                    try{
                        DbAccLink.insertExc(al);
                    }
                    catch(Exception e){
                        
                    }                    
                }
            }
            
        }
        
}
