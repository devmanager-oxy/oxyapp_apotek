/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  9/29/2008 3:16:36 PM
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
import com.project.util.*;
import com.project.util.lang.I_Language;
import com.project.general.Company;
import com.project.general.DbCompany;


public class DbProject extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

	public static final  String DB_PROJECT = "crm_project";

	public static final  int COL_PROJECT_ID = 0;
	public static final  int COL_DATE = 1;
	public static final  int COL_NUMBER = 2;
	public static final  int COL_NUMBER_PREFIX = 3;
	public static final  int COL_COUNTER = 4;
	public static final  int COL_NAME = 5;
	public static final  int COL_CUSTOMER_ID = 6;
	public static final  int COL_CUSTOMER_PIC = 7;
	public static final  int COL_CUSTOMER_PIC_PHONE = 8;
	public static final  int COL_CUSTOMER_ADDRESS = 9;
	public static final  int COL_START_DATE = 10;
	public static final  int COL_END_DATE = 11;
	public static final  int COL_CUSTOMER_PIC_POSITION = 12;
	public static final  int COL_EMPLOYEE_ID = 13;
	public static final  int COL_USER_ID = 14;
	public static final  int COL_EMPLOYEE_HP = 15;
	public static final  int COL_DESCRIPTION = 16;
	public static final  int COL_STATUS = 17;
	public static final  int COL_AMOUNT = 18;
	public static final  int COL_CURRENCY_ID = 19;
	public static final  int COL_COMPANY_ID = 20;
	public static final  int COL_CATEGORY_ID = 21;
        
        public static final  int COL_DISCOUNT_PERCENT = 22;
        public static final  int COL_DISCOUNT_AMOUNT = 23;
        public static final  int COL_VAT = 24;
        public static final  int COL_DISCOUNT = 25;
        public static final  int COL_WARRANTY_STATUS = 26;
        public static final  int COL_WARRANTY_DATE = 27;
        public static final  int COL_WARRANTY_RECEIVE = 28;        
        public static final  int COL_MANUAL_STATUS = 29;
        public static final  int COL_MANUAL_DATE = 30;
        public static final  int COL_MANUAL_RECEIVE = 31;        
        public static final  int COL_NOTE_CLOSING = 32;
        public static final  int COL_BOOKING_RATE = 33;
        public static final  int COL_EXCHANGE_AMOUNT = 34;
        public static final  int COL_PROPOSAL_ID = 35;
        public static final  int COL_UNIT_USAHA_ID = 36;
        public static final  int COL_PPH_PERCENT = 37;
        public static final  int COL_PPH_AMOUNT = 38;
        public static final  int COL_PPH_TYPE = 39;

	public static final  String[] colNames = {
		"project_id",
		"date",
		"number",
		"number_prefix",
		"counter",
		"name",
		"customer_id",
		"customer_pic",
		"customer_pic_phone",
		"customer_address",
		"start_date",
		"end_date",
		"customer_pic_position",
		"employee_id",
		"user_id",
		"employee_hp",
		"description",
		"status",
		"amount",
		"currency_id",
		"company_id",
		"category_id",
                "discount_percent",
                "discount_amount",
                "vat",
                "discount",   
                "warranty_status", 
                "warranty_date", 
                "warranty_receive", 
                "manual_status", 
                "manual_date", 
                "manual_receive",
                "note_closing",
                "booking_rate",
                "exchange_amount",
                "proposal_id", 
                "unit_usaha_id", 
                "pph_percent",
                "pph_amount", 
                "pph_type"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
                
                TYPE_FLOAT,
                TYPE_FLOAT,                
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_DATE,
                TYPE_STRING,
                TYPE_INT,                
                TYPE_DATE,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_FLOAT,                
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT
	};

	public DbProject(){
	}

	public DbProject(int i) throws CONException {
		super(new DbProject());
	}

	public DbProject(String sOid) throws CONException {
		super(new DbProject(0));
		if(!locate(sOid))
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		else
			return;
	}

	public DbProject(long lOid) throws CONException {
		super(new DbProject(0));
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
		return DB_PROJECT;
	}

	public String[] getFieldNames(){
		return colNames;
	}

	public int[] getFieldTypes(){
		return fieldTypes;
	}

	public String getPersistentName(){
		return new DbProject().getClass().getName();
	}

	public long fetchExc(Entity ent) throws Exception {
		Project project = fetchExc(ent.getOID());
		ent = (Entity)project;
		return project.getOID();
	}

	public long insertExc(Entity ent) throws Exception {
		return insertExc((Project) ent);
	}

	public long updateExc(Entity ent) throws Exception {
		return updateExc((Project) ent);
	}

	public long deleteExc(Entity ent) throws Exception {
		if(ent==null){
			throw new CONException(this,CONException.RECORD_NOT_FOUND);
		}
			return deleteExc(ent.getOID());
	}

	public static Project fetchExc(long oid) throws CONException{
		try{
			Project project = new Project();
			DbProject dbProject = new DbProject(oid);
			project.setOID(oid);

			project.setDate(dbProject.getDate(COL_DATE));
			project.setNumber(dbProject.getString(COL_NUMBER));
			project.setNumberPrefix(dbProject.getString(COL_NUMBER_PREFIX));
			project.setCounter(dbProject.getInt(COL_COUNTER));
			project.setName(dbProject.getString(COL_NAME));
			project.setCustomerId(dbProject.getlong(COL_CUSTOMER_ID));
			project.setCustomerPic(dbProject.getString(COL_CUSTOMER_PIC));
			project.setCustomerPicPhone(dbProject.getString(COL_CUSTOMER_PIC_PHONE));
			project.setCustomerAddress(dbProject.getString(COL_CUSTOMER_ADDRESS));
			project.setStartDate(dbProject.getDate(COL_START_DATE));
			project.setEndDate(dbProject.getDate(COL_END_DATE));
			project.setCustomerPicPosition(dbProject.getString(COL_CUSTOMER_PIC_POSITION));
			project.setEmployeeId(dbProject.getlong(COL_EMPLOYEE_ID));
			project.setUserId(dbProject.getlong(COL_USER_ID));
			project.setEmployeeHp(dbProject.getString(COL_EMPLOYEE_HP));
			project.setDescription(dbProject.getString(COL_DESCRIPTION));
			project.setStatus(dbProject.getInt(COL_STATUS));
			project.setAmount(dbProject.getdouble(COL_AMOUNT));
			project.setCurrencyId(dbProject.getlong(COL_CURRENCY_ID));
			project.setCompanyId(dbProject.getlong(COL_COMPANY_ID));
			project.setCategoryId(dbProject.getlong(COL_CATEGORY_ID));
                        
                        project.setDiscountPercent(dbProject.getdouble(COL_DISCOUNT_PERCENT));
                        project.setDiscountAmount(dbProject.getdouble(COL_DISCOUNT_AMOUNT));                    
                        project.setVat(dbProject.getInt(COL_VAT));
                        project.setDiscount(dbProject.getInt(COL_DISCOUNT));
                        project.setWarrantyStatus(dbProject.getInt(COL_WARRANTY_STATUS));
                        project.setWarrantyDate(dbProject.getDate(COL_WARRANTY_DATE));
                        project.setWarrantyReceive(dbProject.getString(COL_WARRANTY_RECEIVE));
                        project.setManualStatus(dbProject.getInt(COL_MANUAL_STATUS));
                        project.setManualDate(dbProject.getDate(COL_MANUAL_DATE));
                        project.setNoteClosing(dbProject.getString(COL_NOTE_CLOSING));
                        project.setBookingRate(dbProject.getdouble(COL_BOOKING_RATE));
                        project.setExchangeAmount(dbProject.getdouble(COL_EXCHANGE_AMOUNT));
                        project.setProposalId(dbProject.getlong(COL_PROPOSAL_ID));
                        project.setUnitUsahaId(dbProject.getlong(COL_UNIT_USAHA_ID));
                        project.setPphPercent(dbProject.getdouble(COL_PPH_PERCENT));
                        project.setPphAmount(dbProject.getdouble(COL_PPH_AMOUNT));
                        project.setPphType(dbProject.getInt(COL_PPH_TYPE));

			return project;
                        
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProject(0),CONException.UNKNOWN);
		}
	}

	public static long insertExc(Project project) throws CONException{
		try{
			DbProject dbProject = new DbProject(0);

			dbProject.setDate(COL_DATE, project.getDate());
			dbProject.setString(COL_NUMBER, project.getNumber());
			dbProject.setString(COL_NUMBER_PREFIX, project.getNumberPrefix());
			dbProject.setInt(COL_COUNTER, project.getCounter());
			dbProject.setString(COL_NAME, project.getName());
			dbProject.setLong(COL_CUSTOMER_ID, project.getCustomerId());
			dbProject.setString(COL_CUSTOMER_PIC, project.getCustomerPic());
			dbProject.setString(COL_CUSTOMER_PIC_PHONE, project.getCustomerPicPhone());
			dbProject.setString(COL_CUSTOMER_ADDRESS, project.getCustomerAddress());
			dbProject.setDate(COL_START_DATE, project.getStartDate());
			dbProject.setDate(COL_END_DATE, project.getEndDate());
			dbProject.setString(COL_CUSTOMER_PIC_POSITION, project.getCustomerPicPosition());
			dbProject.setLong(COL_EMPLOYEE_ID, project.getEmployeeId());
			dbProject.setLong(COL_USER_ID, project.getUserId());
			dbProject.setString(COL_EMPLOYEE_HP, project.getEmployeeHp());
			dbProject.setString(COL_DESCRIPTION, project.getDescription());
			dbProject.setInt(COL_STATUS, project.getStatus());
			dbProject.setDouble(COL_AMOUNT, project.getAmount());
			dbProject.setLong(COL_CURRENCY_ID, project.getCurrencyId());
			dbProject.setLong(COL_COMPANY_ID, project.getCompanyId());
			dbProject.setLong(COL_CATEGORY_ID, project.getCategoryId());
                        
                        dbProject.setDouble(COL_DISCOUNT_PERCENT,project.getDiscountPercent());
                        dbProject.setDouble(COL_DISCOUNT_AMOUNT,project.getDiscountAmount());                    
                        dbProject.setInt(COL_VAT, project.getVat());
                        dbProject.setInt(COL_DISCOUNT,project.getDiscount());
                        dbProject.setInt(COL_WARRANTY_STATUS,project.getWarrantyStatus());
                        dbProject.setDate(COL_WARRANTY_DATE,project.getWarrantyDate());
                        dbProject.setString(COL_WARRANTY_RECEIVE,project.getWarrantyReceive());
                        dbProject.setInt(COL_MANUAL_STATUS,project.getManualStatus());
                        dbProject.setDate(COL_MANUAL_DATE,project.getManualDate());
                        dbProject.setString(COL_NOTE_CLOSING,project.getNoteClosing());
                        dbProject.setDouble(COL_BOOKING_RATE,project.getBookingRate());
                        dbProject.setDouble(COL_EXCHANGE_AMOUNT,project.getExchangeAmount());
                        dbProject.setLong(COL_PROPOSAL_ID,project.getProposalId());
                        dbProject.setLong(COL_UNIT_USAHA_ID,project.getUnitUsahaId());
                        dbProject.setDouble(COL_PPH_PERCENT,project.getPphPercent());
                        dbProject.setDouble(COL_PPH_AMOUNT,project.getPphAmount());
                        dbProject.setInt(COL_PPH_TYPE,project.getPphType());

			dbProject.insert();
			project.setOID(dbProject.getlong(COL_PROJECT_ID));
                        
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProject(0),CONException.UNKNOWN);
		}
		return project.getOID();
	}

	public static long updateExc(Project project) throws CONException{
		try{
			if(project.getOID() != 0){
				DbProject dbProject = new DbProject(project.getOID());

				dbProject.setDate(COL_DATE, project.getDate());
				dbProject.setString(COL_NUMBER, project.getNumber());
				dbProject.setString(COL_NUMBER_PREFIX, project.getNumberPrefix());
				dbProject.setInt(COL_COUNTER, project.getCounter());
				dbProject.setString(COL_NAME, project.getName());
				dbProject.setLong(COL_CUSTOMER_ID, project.getCustomerId());
				dbProject.setString(COL_CUSTOMER_PIC, project.getCustomerPic());
				dbProject.setString(COL_CUSTOMER_PIC_PHONE, project.getCustomerPicPhone());
				dbProject.setString(COL_CUSTOMER_ADDRESS, project.getCustomerAddress());
				dbProject.setDate(COL_START_DATE, project.getStartDate());
				dbProject.setDate(COL_END_DATE, project.getEndDate());
				dbProject.setString(COL_CUSTOMER_PIC_POSITION, project.getCustomerPicPosition());
				dbProject.setLong(COL_EMPLOYEE_ID, project.getEmployeeId());
				dbProject.setLong(COL_USER_ID, project.getUserId());
				dbProject.setString(COL_EMPLOYEE_HP, project.getEmployeeHp());
				dbProject.setString(COL_DESCRIPTION, project.getDescription());
				dbProject.setInt(COL_STATUS, project.getStatus());
				dbProject.setDouble(COL_AMOUNT, project.getAmount());
				dbProject.setLong(COL_CURRENCY_ID, project.getCurrencyId());
				dbProject.setLong(COL_COMPANY_ID, project.getCompanyId());
				dbProject.setLong(COL_CATEGORY_ID, project.getCategoryId());
                                
                                dbProject.setDouble(COL_DISCOUNT_PERCENT,project.getDiscountPercent());
                                dbProject.setDouble(COL_DISCOUNT_AMOUNT,project.getDiscountAmount());                    
                                dbProject.setInt(COL_VAT, project.getVat());
                                dbProject.setInt(COL_DISCOUNT,project.getDiscount());
                                dbProject.setInt(COL_WARRANTY_STATUS,project.getWarrantyStatus());
                                dbProject.setDate(COL_WARRANTY_DATE,project.getWarrantyDate());
                                dbProject.setString(COL_WARRANTY_RECEIVE,project.getWarrantyReceive());
                                dbProject.setInt(COL_MANUAL_STATUS,project.getManualStatus());
                                dbProject.setDate(COL_MANUAL_DATE,project.getManualDate());
                                dbProject.setString(COL_NOTE_CLOSING,project.getNoteClosing());
                                dbProject.setDouble(COL_BOOKING_RATE,project.getBookingRate());
                                dbProject.setDouble(COL_EXCHANGE_AMOUNT,project.getExchangeAmount());
                                dbProject.setLong(COL_PROPOSAL_ID,project.getProposalId());
                                dbProject.setLong(COL_UNIT_USAHA_ID,project.getUnitUsahaId());
                                dbProject.setDouble(COL_PPH_PERCENT,project.getPphPercent());
                                dbProject.setDouble(COL_PPH_AMOUNT,project.getPphAmount());
                                dbProject.setInt(COL_PPH_TYPE,project.getPphType());

				dbProject.update();
				return project.getOID();

			}
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProject(0),CONException.UNKNOWN);
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{
		try{
			DbProject dbProject = new DbProject(oid);
			dbProject.delete();
		}catch(CONException dbe){
			throw dbe;
		}catch(Exception e){
			throw new CONException(new DbProject(0),CONException.UNKNOWN);
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
			String sql = "SELECT * FROM " + DB_PROJECT;
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
				Project project = new Project();
				resultToObject(rs, project);
				lists.add(project);
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

	public static void resultToObject(ResultSet rs, Project project){
		try{

			project.setOID(rs.getLong(DbProject.colNames[DbProject.COL_PROJECT_ID]));
			project.setDate(rs.getDate(DbProject.colNames[DbProject.COL_DATE]));
			project.setNumber(rs.getString(DbProject.colNames[DbProject.COL_NUMBER]));
			project.setNumberPrefix(rs.getString(DbProject.colNames[DbProject.COL_NUMBER_PREFIX]));
			project.setCounter(rs.getInt(DbProject.colNames[DbProject.COL_COUNTER]));
			project.setName(rs.getString(DbProject.colNames[DbProject.COL_NAME]));
			project.setCustomerId(rs.getLong(DbProject.colNames[DbProject.COL_CUSTOMER_ID]));
			project.setCustomerPic(rs.getString(DbProject.colNames[DbProject.COL_CUSTOMER_PIC]));
			project.setCustomerPicPhone(rs.getString(DbProject.colNames[DbProject.COL_CUSTOMER_PIC_PHONE]));
			project.setCustomerAddress(rs.getString(DbProject.colNames[DbProject.COL_CUSTOMER_ADDRESS]));
			project.setStartDate(rs.getDate(DbProject.colNames[DbProject.COL_START_DATE]));
			project.setEndDate(rs.getDate(DbProject.colNames[DbProject.COL_END_DATE]));
			project.setCustomerPicPosition(rs.getString(DbProject.colNames[DbProject.COL_CUSTOMER_PIC_POSITION]));
			project.setEmployeeId(rs.getLong(DbProject.colNames[DbProject.COL_EMPLOYEE_ID]));
			project.setUserId(rs.getLong(DbProject.colNames[DbProject.COL_USER_ID]));
			project.setEmployeeHp(rs.getString(DbProject.colNames[DbProject.COL_EMPLOYEE_HP]));
			project.setDescription(rs.getString(DbProject.colNames[DbProject.COL_DESCRIPTION]));
			project.setStatus(rs.getInt(DbProject.colNames[DbProject.COL_STATUS]));
			project.setAmount(rs.getDouble(DbProject.colNames[DbProject.COL_AMOUNT]));
			project.setCurrencyId(rs.getLong(DbProject.colNames[DbProject.COL_CURRENCY_ID]));
			project.setCompanyId(rs.getLong(DbProject.colNames[DbProject.COL_COMPANY_ID]));
			project.setCategoryId(rs.getLong(DbProject.colNames[DbProject.COL_CATEGORY_ID]));
                        
                        project.setDiscountPercent(rs.getDouble(DbProject.colNames[DbProject.COL_DISCOUNT_PERCENT]));                        
                        project.setDiscountAmount(rs.getDouble(DbProject.colNames[DbProject.COL_DISCOUNT_AMOUNT]));  
                        project.setVat(rs.getInt(DbProject.colNames[DbProject.COL_VAT]));
                        project.setDiscount(rs.getInt(DbProject.colNames[DbProject.COL_DISCOUNT]));
                        project.setWarrantyStatus(rs.getInt(DbProject.colNames[DbProject.COL_WARRANTY_STATUS]));
                        project.setWarrantyDate(rs.getDate(DbProject.colNames[DbProject.COL_WARRANTY_DATE]));
                        project.setWarrantyReceive(rs.getString(DbProject.colNames[DbProject.COL_WARRANTY_RECEIVE]));
                        project.setManualStatus(rs.getInt(DbProject.colNames[DbProject.COL_MANUAL_STATUS]));
                        project.setManualDate(rs.getDate(DbProject.colNames[DbProject.COL_MANUAL_DATE]));
                        project.setNoteClosing(rs.getString(DbProject.colNames[DbProject.COL_NOTE_CLOSING]));
                        project.setBookingRate(rs.getDouble(DbProject.colNames[DbProject.COL_BOOKING_RATE]));
                        project.setExchangeAmount(rs.getDouble(DbProject.colNames[DbProject.COL_EXCHANGE_AMOUNT]));
                        project.setProposalId(rs.getLong(DbProject.colNames[DbProject.COL_PROPOSAL_ID]));
                        project.setUnitUsahaId(rs.getLong(DbProject.colNames[DbProject.COL_UNIT_USAHA_ID]));
                        project.setPphPercent(rs.getDouble(DbProject.colNames[DbProject.COL_PPH_PERCENT]));
                        project.setPphAmount(rs.getDouble(DbProject.colNames[DbProject.COL_PPH_AMOUNT]));
                        project.setPphType(rs.getInt(DbProject.colNames[DbProject.COL_PPH_TYPE]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long projectId)
	{
		CONResultSet dbrs = null;
		boolean result = false;
		try
		{
			String sql = "SELECT * FROM " + DB_PROJECT + " WHERE " + 
				DbProject.colNames[DbProject.COL_PROJECT_ID] + " = " + projectId;
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
			String sql = "SELECT COUNT("+ DbProject.colNames[DbProject.COL_PROJECT_ID] + ") FROM " + DB_PROJECT;
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
				Project project = (Project)list.get(ls);
				if(oid == project.getOID())
					found=true;
				}
			}
		}
		if((start >= size) && (size > 0))
			start = start - recordToGet;

		return start;
	}

        
                public static int getNextCounter(long systemCompanyId){
                int result = 0;
                
                CONResultSet dbrs = null;
                try{
                    String sql = "select max(counter) from "+DB_PROJECT+" where "+
                        " number_prefix='"+getNumberPrefix(systemCompanyId)+"' ";
                    
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
        
        public static String getNumberPrefix(long systemCompanyId){
            
                //Company sysCompany = DbCompany.getCompany();
                Company sysCompany = new Company();
                try {
                    sysCompany  = DbCompany.fetchExc(systemCompanyId);
                }catch(Exception e){
                    System.out.println(e);
                }

                String code = "PPJ/PNCI/";//sysCompany.getProjectCode();
               
                //System.out.println(code);
                
                code = code + JSPFormater.formatDate(new Date(), "MMyy");
                
                return code;
        }

        public static String getNextNumber(int ctr, long systemCompanyId){
            
                String code = getNumberPrefix(systemCompanyId);
                
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
        
}
