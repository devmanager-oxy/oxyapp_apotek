

package com.project.fms.activity; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*; 
import com.project.fms.master.*; 
import com.project.*;
import com.project.util.*;

public class DbActivityPeriod extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_ACTIVITY_PERIOD = "activity_period";

	public static final  int COL_ACTIVITY_PERIOD_ID = 0;
	public static final  int COL_START_DATE = 1;
	public static final  int COL_END_DATE = 2;
	public static final  int COL_STATUS = 3;
	public static final  int COL_NAME = 4;

	public static final  String[] colNames = {
		"activity_period_id",
		"start_date",
		"end_date",
		"status",
		"name"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING
	 }; 

	public DbActivityPeriod(){
	}

	public DbActivityPeriod(int i) throws CONException { 
		super(new DbActivityPeriod()); 
	}

	public DbActivityPeriod(String sOid) throws CONException { 
		super(new DbActivityPeriod(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbActivityPeriod(long lOid) throws CONException { 
		super(new DbActivityPeriod(0)); 
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
		return DB_ACTIVITY_PERIOD;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbActivityPeriod().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		ActivityPeriod activityperiod = fetchExc(ent.getOID()); 
		ent = (Entity)activityperiod; 
		return activityperiod.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((ActivityPeriod) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((ActivityPeriod) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static ActivityPeriod fetchExc(long oid) throws CONException{ 
		try{ 
			ActivityPeriod activityperiod = new ActivityPeriod();
			DbActivityPeriod dbActivityPeriod = new DbActivityPeriod(oid); 
			activityperiod.setOID(oid);

			activityperiod.setStartDate(dbActivityPeriod.getDate(COL_START_DATE));
			activityperiod.setEndDate(dbActivityPeriod.getDate(COL_END_DATE));
			activityperiod.setStatus(dbActivityPeriod.getString(COL_STATUS));
			activityperiod.setName(dbActivityPeriod.getString(COL_NAME));

			return activityperiod; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbActivityPeriod(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(ActivityPeriod activityperiod) throws CONException{ 
		try{ 
			DbActivityPeriod dbActivityPeriod = new DbActivityPeriod(0);

			dbActivityPeriod.setDate(COL_START_DATE, activityperiod.getStartDate());
			dbActivityPeriod.setDate(COL_END_DATE, activityperiod.getEndDate());
			dbActivityPeriod.setString(COL_STATUS, activityperiod.getStatus());
			dbActivityPeriod.setString(COL_NAME, activityperiod.getName());

			dbActivityPeriod.insert(); 
			activityperiod.setOID(dbActivityPeriod.getlong(COL_ACTIVITY_PERIOD_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbActivityPeriod(0),CONException.UNKNOWN); 
		}
		return activityperiod.getOID();
	}

	public static long updateExc(ActivityPeriod activityperiod) throws CONException{ 
		try{ 
			if(activityperiod.getOID() != 0){ 
				DbActivityPeriod dbActivityPeriod = new DbActivityPeriod(activityperiod.getOID());

				dbActivityPeriod.setDate(COL_START_DATE, activityperiod.getStartDate());
				dbActivityPeriod.setDate(COL_END_DATE, activityperiod.getEndDate());
				dbActivityPeriod.setString(COL_STATUS, activityperiod.getStatus());
				dbActivityPeriod.setString(COL_NAME, activityperiod.getName());

				dbActivityPeriod.update(); 
				return activityperiod.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbActivityPeriod(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbActivityPeriod dbActivityPeriod = new DbActivityPeriod(oid);
			dbActivityPeriod.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbActivityPeriod(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + DB_ACTIVITY_PERIOD; 
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
				ActivityPeriod activityperiod = new ActivityPeriod();
				resultToObject(rs, activityperiod);
				lists.add(activityperiod);
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

	private static void resultToObject(ResultSet rs, ActivityPeriod activityperiod){
		try{
			activityperiod.setOID(rs.getLong(DbActivityPeriod.colNames[DbActivityPeriod.COL_ACTIVITY_PERIOD_ID]));
			activityperiod.setStartDate(rs.getDate(DbActivityPeriod.colNames[DbActivityPeriod.COL_START_DATE]));
			activityperiod.setEndDate(rs.getDate(DbActivityPeriod.colNames[DbActivityPeriod.COL_END_DATE]));
			activityperiod.setStatus(rs.getString(DbActivityPeriod.colNames[DbActivityPeriod.COL_STATUS]));
			activityperiod.setName(rs.getString(DbActivityPeriod.colNames[DbActivityPeriod.COL_NAME]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long activityPeriodId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_ACTIVITY_PERIOD + " WHERE " + 
						DbActivityPeriod.colNames[DbActivityPeriod.COL_ACTIVITY_PERIOD_ID] + " = " + activityPeriodId;

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
			String sql = "SELECT COUNT("+ DbActivityPeriod.colNames[DbActivityPeriod.COL_ACTIVITY_PERIOD_ID] + ") FROM " + DB_ACTIVITY_PERIOD;
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
			  	   ActivityPeriod activityperiod = (ActivityPeriod)list.get(ls);
				   if(oid == activityperiod.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        
        public static ActivityPeriod getOpenPeriod(){
            Vector v = DbActivityPeriod.list(0,0, "status='"+I_Project.STATUS_PERIOD_OPEN+"'", "");
            if(v!=null && v.size()>0){
                return (ActivityPeriod)v.get(0);
            }
            return new ActivityPeriod();
        }
        
        public static String closePeriod(ActivityPeriod newAp, int transModule, Vector listModule, int transExpense, Vector listCoa){
            
            newAp.setStatus(I_Project.STATUS_PERIOD_OPEN);
            
            String strStartDate = "'"+JSPFormater.formatDate(newAp.getStartDate(), "yyyy-MM-dd")+"'";
            String strEndDate = "'"+JSPFormater.formatDate(newAp.getEndDate(), "yyyy-MM-dd")+"'";
            
            String where = "(start_date between "+strStartDate+" and "+strEndDate + ") or (end_date between "+strStartDate+" and "+strEndDate+")";
            
            Vector v = DbActivityPeriod.list(0,0, where, "");
            
            if(v!=null && v.size()>0){
                return "Period date overlap existing date period";
            }
            else{
                long oid = 0;
                
                //close open period
                ActivityPeriod ap = getOpenPeriod();
                
                try{
                    if(ap.getOID()!=0){
                        
                        ap.setStatus(I_Project.STATUS_PERIOD_CLOSED);                                                                    
                        oid = DbActivityPeriod.updateExc(ap);
                        
                        if(oid!=0){
                            oid = DbActivityPeriod.insertExc(newAp);
                            //insert module
                            if(oid!=0 && transModule==1){
                                
                                Vector vx = new Vector();
                                if(listModule!=null && listModule.size()>0){		
                                    for(int i=0; i<listModule.size(); i++){			
                                        Module pi = (Module)listModule.get(i);
                                        if(pi.getLevel().equals(I_Project.ACTIVITY_CODE_M)){													
                                            vx.add(pi);
                                        }
                                    }
                                }
                                
                                if(vx!=null && vx.size()>0){
                                    
                                    for(int x=0; x<vx.size(); x++){
                                        try{
                                            System.out.println("\nx : "+x);
                                            
                                            Module m = (Module)vx.get(x);
                                            long oldMOID = m.getOID();
                                            m.setActivityPeriodId(oid);
                                            long newMOID = DbModule.insertExc(m);
                                            
                                            insertModule(newMOID, oldMOID, oid, listModule);
                                        }
                                        catch(Exception ee){
                                            System.out.println(ee.toString());
                                        }
                                    }
                                    
                                }
                                
                            }
                            //insert Expense budget
                            if(oid!=0 && transExpense==1){
                                if(listCoa!=null && listCoa.size()>0){
                                    for(int i=0; i<listCoa.size(); i++){
                                        Coa coaX = (Coa)listCoa.get(i);         
                                        try{ 
                                            String whereX = "activity_period_id="+ap.getOID()+" and coa_id="+coaX.getOID(); 
                                            Vector vx = DbCoaActivityBudget.list(0,0, whereX, "");
                                            CoaActivityBudget cxx = new CoaActivityBudget();
                                            if(vx!=null && vx.size()>0){
                                                cxx = (CoaActivityBudget)vx.get(0);
                                                cxx.setActivityPeriodId(oid);
                                                DbCoaActivityBudget.insertExc(cxx);
                                            }
                                        }catch(Exception e){
                                            System.out.println(e);
                                        }
                                    }
                                }
                            }                            
                        }
                    }
                }
                catch(Exception e){
                    System.out.println(e.toString());
                }
            }
            
            return "";
            
        }
        
        public static void insertModule(long newMOID, long oldParentId, long  newPeriodId, Vector listModule){
            //Vector vx = DbModule.list(0,0, "level='"+I_Project.ACTIVITY_CODE_S+"' and parent_id="+oldParentId,  "");
            Vector vx = new Vector();
            if(listModule!=null && listModule.size()>0){		
                for(int i=0; i<listModule.size(); i++){			
                    Module pi = (Module)listModule.get(i);
                    if(pi.getLevel().equals(I_Project.ACTIVITY_CODE_S) && pi.getParentId()==oldParentId){
                        vx.add(pi);
                    }
                }
            }
                                                                
            System.out.println("\n-----------***************--- vx : "+vx);

            if(vx!=null && vx.size()>0){

                for(int x=0; x<vx.size(); x++){
                    try{
                        System.out.println("\nx : "+x);

                        Module m = (Module)vx.get(x);
                        long oldSOID = m.getOID();
                        m.setActivityPeriodId(newPeriodId);
                        m.setParentId(newMOID);
                        long newSOID = DbModule.insertExc(m);
                        
                        insertHeader(newSOID, oldSOID, newPeriodId, listModule);
                        insertActivity(newSOID, oldSOID, newPeriodId, listModule);
                    }
                    catch(Exception ee){
                        System.out.println(ee.toString());
                    }
                }

            }
        }
        
        public static void insertHeader(long newSOID, long oldParentId, long  newPeriodId, Vector listModule){
            //Vector vx = DbModule.list(0,0, "level='"+I_Project.ACTIVITY_CODE_H+"' and parent_id="+oldParentId,  "");
            Vector vx = new Vector();
            if(listModule!=null && listModule.size()>0){		
                for(int i=0; i<listModule.size(); i++){			
                    Module pi = (Module)listModule.get(i);
                    if(pi.getLevel().equals(I_Project.ACTIVITY_CODE_H) && pi.getParentId()==oldParentId){
                        vx.add(pi);
                    }
                }
            }
                                                                
            System.out.println("\n-----------***************--- vx : "+vx);

            if(vx!=null && vx.size()>0){

                for(int x=0; x<vx.size(); x++){
                    try{
                        System.out.println("\nx : "+x);

                        Module m = (Module)vx.get(x);
                        long oldHOID = m.getOID();
                        m.setActivityPeriodId(newPeriodId);
                        m.setParentId(newSOID);
                        long newHOID = DbModule.insertExc(m);
                        
                        insertActivity(newHOID, oldHOID, newPeriodId, listModule);
                    }
                    catch(Exception ee){
                        System.out.println(ee.toString());
                    }
                }

            }
        }
        
        public static void insertActivity(long newSOID, long oldParentId, long  newPeriodId, Vector listModule){
            //Vector vx = DbModule.list(0,0, "level='"+I_Project.ACTIVITY_CODE_A+"' and parent_id="+oldParentId,  "");
            Vector vx = new Vector();
            if(listModule!=null && listModule.size()>0){		
                for(int i=0; i<listModule.size(); i++){			
                    Module pi = (Module)listModule.get(i);
                    if(pi.getLevel().equals(I_Project.ACTIVITY_CODE_A) && pi.getParentId()==oldParentId){
                        vx.add(pi);
                    }
                }
            }
                                                                
            System.out.println("\n-----------***************--- vx : "+vx);

            if(vx!=null && vx.size()>0){

                for(int x=0; x<vx.size(); x++){
                    try{
                        System.out.println("\nx : "+x);

                        Module m = (Module)vx.get(x);
                        long oldAOID = m.getOID();
                        m.setActivityPeriodId(newPeriodId);
                        m.setParentId(newSOID);
                        long newAOID = DbModule.insertExc(m);
                        
                        insertSubActivity(newAOID, oldAOID, newPeriodId, listModule);
                    }
                    catch(Exception ee){
                        System.out.println(ee.toString());
                    }
                }

            }
        }
        
        
        public static void insertSubActivity(long newAOID, long oldParentId, long  newPeriodId, Vector listModule){
            //Vector vx = DbModule.list(0,0, "level='"+I_Project.ACTIVITY_CODE_SA+"' and parent_id="+oldParentId,  "");
            Vector vx = new Vector();
            if(listModule!=null && listModule.size()>0){		
                for(int i=0; i<listModule.size(); i++){			
                    Module pi = (Module)listModule.get(i);
                    if(pi.getLevel().equals(I_Project.ACTIVITY_CODE_SA) && pi.getParentId()==oldParentId){
                        vx.add(pi);
                    }
                }
            }
                                                                
            System.out.println("\n-----------***************--- vx : "+vx);

            if(vx!=null && vx.size()>0){

                for(int x=0; x<vx.size(); x++){
                    try{
                        System.out.println("\nx : "+x);

                        Module m = (Module)vx.get(x);
                        long oldSAOID = m.getOID();
                        m.setActivityPeriodId(newPeriodId);
                        m.setParentId(newAOID);
                        long newSAOID = DbModule.insertExc(m);
                        
                        insertSubSubActivity(newSAOID, oldSAOID, newPeriodId, listModule);
                    }
                    catch(Exception ee){
                        System.out.println(ee.toString());
                    }
                }

            }
        }
        
        public static void insertSubSubActivity(long newSAOID, long oldParentId, long  newPeriodId, Vector listModule){
            //Vector vx = DbModule.list(0,0, "level='"+I_Project.ACTIVITY_CODE_SSA+"' and parent_id="+oldParentId,  "");
            Vector vx = new Vector();
            if(listModule!=null && listModule.size()>0){		
                for(int i=0; i<listModule.size(); i++){			
                    Module pi = (Module)listModule.get(i);
                    if(pi.getLevel().equals(I_Project.ACTIVITY_CODE_SSA) && pi.getParentId()==oldParentId){
                        vx.add(pi);
                    }
                }
            }

                                                                
            System.out.println("\n-----------***************--- vx : "+vx);

            if(vx!=null && vx.size()>0){

                for(int x=0; x<vx.size(); x++){
                    try{
                        System.out.println("\nx : "+x);

                        Module m = (Module)vx.get(x);
                        m.setActivityPeriodId(newPeriodId);
                        m.setParentId(newSAOID);
                        long newSSAOID = DbModule.insertExc(m);
                    }
                    catch(Exception ee){
                        System.out.println(ee.toString());
                    }
                }

            }
        }
        
        public static ActivityPeriod getPeriodAktif(int year){
            CONResultSet dbrs = null;
            
            try{
               
                String sql = "select * from "+DbActivityPeriod.DB_ACTIVITY_PERIOD+
                        " where year("+DbActivityPeriod.colNames[DbActivityPeriod.COL_START_DATE]+") = "+year; 
                        
                dbrs = CONHandler.execQueryResult(sql);
		ResultSet rs = dbrs.getResultSet();
		while(rs.next()) {
                    ActivityPeriod activityperiod = new ActivityPeriod();
                    resultToObject(rs, activityperiod);
                    return activityperiod;
		}
		rs.close();
			
            }catch(Exception e) {
                System.out.println(e);
            }finally {
                CONResultSet.close(dbrs);
            }
            
            return null;
        }
        
}
