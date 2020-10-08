/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  10/6/2008 3:12:12 PM
\***********************************/

package com.project.crm.project;

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.lang.I_Language;


public class DbProjectTerm extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

	public static final  String DB_PROJECT_TERM = "crm_project_term";

	public static final  int COL_PROJECT_TERM_ID = 0;
	public static final  int COL_PROJECT_ID = 1;
	public static final  int COL_SQUENCE = 2;
	public static final  int COL_TYPE = 3;
	public static final  int COL_DESCRIPTION = 4;
	public static final  int COL_STATUS = 5;
	public static final  int COL_AMOUNT = 6;
	public static final  int COL_CURRENCY_ID = 7;
	public static final  int COL_COMPANY_ID = 8;
	public static final  int COL_DUE_DATE = 9;

	public static final  String[] colNames = {
		"project_term_id",
		"project_id",
		"squence",
		"type",
		"description",
		"status",
		"amount",
		"currency_id",
		"company_id",
		"due_date"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_INT,
		TYPE_INT,
		TYPE_STRING,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_DATE
	};

        public static int TYPE_DP = 0;
        public static int TYPE_PAYMENT = 1;         
        public static String[] strType = {"Down Payment", "Payment"};
        
        public static int STATUS_INV = 0;
        public static int STATUS_DRAFT = 1;         
        public static String[] strStatus = {"Ready to Invoice", "Draft"};

	public DbProjectTerm(){
	}

	public DbProjectTerm(int i) throws CONException {
		super(new DbProjectTerm());
	}

	public DbProjectTerm(String sOid) throws CONException {
		super(new DbProjectTerm(0));
		if(!locate(sOid))
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		else
			return;
	}

	public DbProjectTerm(long lOid) throws CONException {
		super(new DbProjectTerm(0));
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
		return DB_PROJECT_TERM;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbProjectTerm().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception {
		ProjectTerm projectterm = fetchExc(ent.getOID());
		ent = (Entity)projectterm;
		return projectterm.getOID();
	}

	public long insertExc(Entity ent) throws Exception {
		return insertExc((ProjectTerm) ent);
	}

	public long updateExc(Entity ent) throws Exception {
		return updateExc((ProjectTerm) ent);
	}

	public long deleteExc(Entity ent) throws Exception {
		if(ent==null){
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		}
			return deleteExc(ent.getOID());
	}

	public static ProjectTerm fetchExc(long oid) throws CONException{
		try{
			ProjectTerm projectterm = new ProjectTerm();
			DbProjectTerm dbProjectTerm = new DbProjectTerm(oid);
			projectterm.setOID(oid);

			projectterm.setProjectId(dbProjectTerm.getlong(COL_PROJECT_ID));
			projectterm.setSquence(dbProjectTerm.getInt(COL_SQUENCE));
			projectterm.setType(dbProjectTerm.getInt(COL_TYPE));
			projectterm.setDescription(dbProjectTerm.getString(COL_DESCRIPTION));
			projectterm.setStatus(dbProjectTerm.getInt(COL_STATUS));
			projectterm.setAmount(dbProjectTerm.getdouble(COL_AMOUNT));
			projectterm.setCurrencyId(dbProjectTerm.getlong(COL_CURRENCY_ID));
			projectterm.setCompanyId(dbProjectTerm.getlong(COL_COMPANY_ID));
			projectterm.setDueDate(dbProjectTerm.getDate(COL_DUE_DATE));

			return projectterm;
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProjectTerm(0),CONException.UNKNOWN);
		}
	}

	public static long insertExc(ProjectTerm projectterm) throws CONException{
		try{
			DbProjectTerm dbProjectTerm = new DbProjectTerm(0);

			dbProjectTerm.setLong(COL_PROJECT_ID, projectterm.getProjectId());
			dbProjectTerm.setInt(COL_SQUENCE, projectterm.getSquence());
			dbProjectTerm.setInt(COL_TYPE, projectterm.getType());
			dbProjectTerm.setString(COL_DESCRIPTION, projectterm.getDescription());
			dbProjectTerm.setInt(COL_STATUS, projectterm.getStatus());
			dbProjectTerm.setDouble(COL_AMOUNT, projectterm.getAmount());
			dbProjectTerm.setLong(COL_CURRENCY_ID, projectterm.getCurrencyId());
			dbProjectTerm.setLong(COL_COMPANY_ID, projectterm.getCompanyId());
			dbProjectTerm.setDate(COL_DUE_DATE, projectterm.getDueDate());

			dbProjectTerm.insert();
			projectterm.setOID(dbProjectTerm.getlong(COL_PROJECT_TERM_ID));
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProjectTerm(0),CONException.UNKNOWN);
		}
		return projectterm.getOID();
	}

	public static long updateExc(ProjectTerm projectterm) throws CONException{
		try{
			if(projectterm.getOID() != 0){
				DbProjectTerm dbProjectTerm = new DbProjectTerm(projectterm.getOID());

				dbProjectTerm.setLong(COL_PROJECT_ID, projectterm.getProjectId());
				dbProjectTerm.setInt(COL_SQUENCE, projectterm.getSquence());
				dbProjectTerm.setInt(COL_TYPE, projectterm.getType());
				dbProjectTerm.setString(COL_DESCRIPTION, projectterm.getDescription());
				dbProjectTerm.setInt(COL_STATUS, projectterm.getStatus());
				dbProjectTerm.setDouble(COL_AMOUNT, projectterm.getAmount());
				dbProjectTerm.setLong(COL_CURRENCY_ID, projectterm.getCurrencyId());
				dbProjectTerm.setLong(COL_COMPANY_ID, projectterm.getCompanyId());
				dbProjectTerm.setDate(COL_DUE_DATE, projectterm.getDueDate());

				dbProjectTerm.update();
				return projectterm.getOID();

			}
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProjectTerm(0),CONException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{
		try{
			DbProjectTerm dbProjectTerm = new DbProjectTerm(oid);
			dbProjectTerm.delete();
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProjectTerm(0),CONException.UNKNOWN);
		}
		return oid;
	}

	public static Vector listAll()
	{
		return list(0, 500, "","");
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector();
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_PROJECT_TERM;
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
				ProjectTerm projectterm = new ProjectTerm();
				resultToObject(rs, projectterm);
				lists.add(projectterm);
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

	public static void resultToObject(ResultSet rs, ProjectTerm projectterm){
		try{

			projectterm.setOID(rs.getLong(DbProjectTerm.colNames[DbProjectTerm.COL_PROJECT_TERM_ID]));
			projectterm.setProjectId(rs.getLong(DbProjectTerm.colNames[DbProjectTerm.COL_PROJECT_ID]));
			projectterm.setSquence(rs.getInt(DbProjectTerm.colNames[DbProjectTerm.COL_SQUENCE]));
			projectterm.setType(rs.getInt(DbProjectTerm.colNames[DbProjectTerm.COL_TYPE]));
			projectterm.setDescription(rs.getString(DbProjectTerm.colNames[DbProjectTerm.COL_DESCRIPTION]));
			projectterm.setStatus(rs.getInt(DbProjectTerm.colNames[DbProjectTerm.COL_STATUS]));
			projectterm.setAmount(rs.getDouble(DbProjectTerm.colNames[DbProjectTerm.COL_AMOUNT]));
			projectterm.setCurrencyId(rs.getLong(DbProjectTerm.colNames[DbProjectTerm.COL_CURRENCY_ID]));
			projectterm.setCompanyId(rs.getLong(DbProjectTerm.colNames[DbProjectTerm.COL_COMPANY_ID]));
			projectterm.setDueDate(rs.getDate(DbProjectTerm.colNames[DbProjectTerm.COL_DUE_DATE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long projectTermId)
	{
		CONResultSet dbrs = null;
		boolean result = false;
		try
		{
			String sql = "SELECT * FROM " + DB_PROJECT_TERM + " WHERE " + 
				DbProjectTerm.colNames[DbProjectTerm.COL_PROJECT_TERM_ID] + " = " + projectTermId;
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) { result = true; }
			rs.close();
		}
		catch(Exception e)
		{
			System.out.println("err : "+e.toString());
		}
		finally
		{
			CONResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbProjectTerm.colNames[DbProjectTerm.COL_PROJECT_TERM_ID] + ") FROM " + DB_PROJECT_TERM;
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
				ProjectTerm projectterm = (ProjectTerm)list.get(ls);
				if(oid == projectterm.getOID())
					found=true;
				}
			}
		}
		if((start >= size) && (size > 0))
			start = start - recordToGet;

		return start;
	}

        public static int getMaxSquence(long projectId){
                int result = 0;                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max(squence) from "+DB_PROJECT_TERM+" where "+
                        " project_id='"+projectId+"' ";
                    
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
                    System.out.println(e);
                }
                finally{
                    CONResultSet.close(dbrs);
                }
                
                return result;
        }

}
