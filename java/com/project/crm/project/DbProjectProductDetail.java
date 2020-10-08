/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  10/7/2008 8:34:41 PM
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


public class DbProjectProductDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

	public static final  String DB_PROJECT_PRODUCT_DETAIL = "crm_project_product_detail";

	public static final  int COL_PROJECT_PRODUCT_DETAIL_ID = 0;
	public static final  int COL_PROJECT_ID = 1;
	public static final  int COL_CATEGORY_ID = 2;
	public static final  int COL_ITEM_DESCRIPTION = 3;
	public static final  int COL_SQUENCE = 4;
	public static final  int COL_AMOUNT = 5;
	public static final  int COL_STATUS = 6;
	public static final  int COL_CURRENCY_ID = 7;
	public static final  int COL_COMPANY_ID = 8;

	public static final  String[] colNames = {
		"project_product_detail_id",
		"project_id",
		"category_id",
		"item_description",
		"squence",
		"amount",
		"status",
		"currency_id",
		"company_id"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG
	};

	public DbProjectProductDetail(){
	}

	public DbProjectProductDetail(int i) throws CONException {
		super(new DbProjectProductDetail());
	}

	public DbProjectProductDetail(String sOid) throws CONException {
		super(new DbProjectProductDetail(0));
		if(!locate(sOid))
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		else
			return;
	}

	public DbProjectProductDetail(long lOid) throws CONException {
		super(new DbProjectProductDetail(0));
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
		return DB_PROJECT_PRODUCT_DETAIL;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbProjectProductDetail().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception {
		ProjectProductDetail projectproductdetail = fetchExc(ent.getOID());
		ent = (Entity)projectproductdetail;
		return projectproductdetail.getOID();
	}

	public long insertExc(Entity ent) throws Exception {
		return insertExc((ProjectProductDetail) ent);
	}

	public long updateExc(Entity ent) throws Exception {
		return updateExc((ProjectProductDetail) ent);
	}

	public long deleteExc(Entity ent) throws Exception {
		if(ent==null){
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		}
			return deleteExc(ent.getOID());
	}

	public static ProjectProductDetail fetchExc(long oid) throws CONException{
		try{
			ProjectProductDetail projectproductdetail = new ProjectProductDetail();
			DbProjectProductDetail dbProjectProductDetail = new DbProjectProductDetail(oid);
			projectproductdetail.setOID(oid);

			projectproductdetail.setProjectId(dbProjectProductDetail.getlong(COL_PROJECT_ID));
			projectproductdetail.setCategoryId(dbProjectProductDetail.getlong(COL_CATEGORY_ID));
			projectproductdetail.setItemDescription(dbProjectProductDetail.getString(COL_ITEM_DESCRIPTION));
			projectproductdetail.setSquence(dbProjectProductDetail.getInt(COL_SQUENCE));
			projectproductdetail.setAmount(dbProjectProductDetail.getdouble(COL_AMOUNT));
			projectproductdetail.setStatus(dbProjectProductDetail.getInt(COL_STATUS));
			projectproductdetail.setCurrencyId(dbProjectProductDetail.getlong(COL_CURRENCY_ID));
			projectproductdetail.setCompanyId(dbProjectProductDetail.getlong(COL_COMPANY_ID));

			return projectproductdetail;
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProjectProductDetail(0),CONException.UNKNOWN);
		}
	}

	public static long insertExc(ProjectProductDetail projectproductdetail) throws CONException{
		try{
			DbProjectProductDetail dbProjectProductDetail = new DbProjectProductDetail(0);

			dbProjectProductDetail.setLong(COL_PROJECT_ID, projectproductdetail.getProjectId());
			dbProjectProductDetail.setLong(COL_CATEGORY_ID, projectproductdetail.getCategoryId());
			dbProjectProductDetail.setString(COL_ITEM_DESCRIPTION, projectproductdetail.getItemDescription());
			dbProjectProductDetail.setInt(COL_SQUENCE, projectproductdetail.getSquence());
			dbProjectProductDetail.setDouble(COL_AMOUNT, projectproductdetail.getAmount());
			dbProjectProductDetail.setInt(COL_STATUS, projectproductdetail.getStatus());
			dbProjectProductDetail.setLong(COL_CURRENCY_ID, projectproductdetail.getCurrencyId());
			dbProjectProductDetail.setLong(COL_COMPANY_ID, projectproductdetail.getCompanyId());

			dbProjectProductDetail.insert();
			projectproductdetail.setOID(dbProjectProductDetail.getlong(COL_PROJECT_PRODUCT_DETAIL_ID));
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProjectProductDetail(0),CONException.UNKNOWN);
		}
		return projectproductdetail.getOID();
	}

	public static long updateExc(ProjectProductDetail projectproductdetail) throws CONException{
		try{
			if(projectproductdetail.getOID() != 0){
				DbProjectProductDetail dbProjectProductDetail = new DbProjectProductDetail(projectproductdetail.getOID());

				dbProjectProductDetail.setLong(COL_PROJECT_ID, projectproductdetail.getProjectId());
				dbProjectProductDetail.setLong(COL_CATEGORY_ID, projectproductdetail.getCategoryId());
				dbProjectProductDetail.setString(COL_ITEM_DESCRIPTION, projectproductdetail.getItemDescription());
				dbProjectProductDetail.setInt(COL_SQUENCE, projectproductdetail.getSquence());
				dbProjectProductDetail.setDouble(COL_AMOUNT, projectproductdetail.getAmount());
				dbProjectProductDetail.setInt(COL_STATUS, projectproductdetail.getStatus());
				dbProjectProductDetail.setLong(COL_CURRENCY_ID, projectproductdetail.getCurrencyId());
				dbProjectProductDetail.setLong(COL_COMPANY_ID, projectproductdetail.getCompanyId());

				dbProjectProductDetail.update();
				return projectproductdetail.getOID();

			}
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProjectProductDetail(0),CONException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{
		try{
			DbProjectProductDetail dbProjectProductDetail = new DbProjectProductDetail(oid);
			dbProjectProductDetail.delete();
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProjectProductDetail(0),CONException.UNKNOWN);
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
			String sql = "SELECT * FROM " + DB_PROJECT_PRODUCT_DETAIL;
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
				ProjectProductDetail projectproductdetail = new ProjectProductDetail();
				resultToObject(rs, projectproductdetail);
				lists.add(projectproductdetail);
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

	private static void resultToObject(ResultSet rs, ProjectProductDetail projectproductdetail){
		try{

			projectproductdetail.setOID(rs.getLong(DbProjectProductDetail.colNames[DbProjectProductDetail.COL_PROJECT_PRODUCT_DETAIL_ID]));
			projectproductdetail.setProjectId(rs.getLong(DbProjectProductDetail.colNames[DbProjectProductDetail.COL_PROJECT_ID]));
			projectproductdetail.setCategoryId(rs.getLong(DbProjectProductDetail.colNames[DbProjectProductDetail.COL_CATEGORY_ID]));
			projectproductdetail.setItemDescription(rs.getString(DbProjectProductDetail.colNames[DbProjectProductDetail.COL_ITEM_DESCRIPTION]));
			projectproductdetail.setSquence(rs.getInt(DbProjectProductDetail.colNames[DbProjectProductDetail.COL_SQUENCE]));
			projectproductdetail.setAmount(rs.getDouble(DbProjectProductDetail.colNames[DbProjectProductDetail.COL_AMOUNT]));
			projectproductdetail.setStatus(rs.getInt(DbProjectProductDetail.colNames[DbProjectProductDetail.COL_STATUS]));
			projectproductdetail.setCurrencyId(rs.getLong(DbProjectProductDetail.colNames[DbProjectProductDetail.COL_CURRENCY_ID]));
			projectproductdetail.setCompanyId(rs.getLong(DbProjectProductDetail.colNames[DbProjectProductDetail.COL_COMPANY_ID]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long projectProductDetailId)
	{
		CONResultSet dbrs = null;
		boolean result = false;
		try
		{
			String sql = "SELECT * FROM " + DB_PROJECT_PRODUCT_DETAIL + " WHERE " + 
				DbProjectProductDetail.colNames[DbProjectProductDetail.COL_PROJECT_PRODUCT_DETAIL_ID] + " = " + projectProductDetailId;
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
			String sql = "SELECT COUNT("+ DbProjectProductDetail.colNames[DbProjectProductDetail.COL_PROJECT_PRODUCT_DETAIL_ID] + ") FROM " + DB_PROJECT_PRODUCT_DETAIL;
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
				ProjectProductDetail projectproductdetail = (ProjectProductDetail)list.get(ls);
				if(oid == projectproductdetail.getOID())
					found=true;
				}
			}
		}
		if((start >= size) && (size > 0))
			start = start - recordToGet;

		return start;
	}

}
