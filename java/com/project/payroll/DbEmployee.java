
package com.project.payroll; 

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;

public class DbEmployee extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String CON_EMPLOYEE = "employee";

	public static final  int COL_EMPLOYEE_ID = 0;
	public static final  int COL_DEPARTMENT_ID = 1;
	public static final  int COL_SECTION_ID = 2;
	public static final  int COL_NAME = 3;
	public static final  int COL_ADDRESS = 4;
	public static final  int COL_CITY = 5;
	public static final  int COL_STATE = 6;
	public static final  int COL_COUNTRY_NAME = 7;
	public static final  int COL_EMP_NUM = 8;
	public static final  int COL_PHONE = 9;
	public static final  int COL_HP = 10;
	public static final  int COL_MARITAL_STATUS = 11;
	public static final  int COL_DOB = 12;
	public static final  int COL_COMMENCING_DATE = 13;
	public static final  int COL_JAMSOSTEK = 14;
	public static final  int COL_EMP_STATUS = 15;
	public static final  int COL_ID_NUMBER = 16;
	public static final  int COL_ID_TYPE = 17;
	public static final  int COL_JAMSOSTEK_ID = 18;
	public static final  int COL_COUNTRY_ID = 19;
	public static final  int COL_NATIONALITY_ID = 20;
	public static final  int COL_NATIONALITY_NAME = 21;        
        public static final  int COL_EMP_TYPE = 22;
        public static final  int COL_RESIGN_DATE = 23;
        public static final  int COL_RESIGN_REASON = 24;
        public static final  int COL_RESIGN_NOTE = 25;
        public static final  int COL_CONTRACT_END = 26;   
        public static final  int COL_IGNORE_BIRTH = 27;  
        public static final  int COL_LOCATION_ID = 28;  
        public static final  int COL_POSITION = 29;  	
        public static final  int COL_CAN_TAKE_ADVANCE = 30;  
        public static final  int COL_IS_SALES = 31;  

	public static final  String[] colNames = {
		"employee_id",
		"department_id",
		"section_id",
		"name",
		"address",
		"city",
		"state",
		"country_name",
		"emp_num",
		"phone",
		"hp",
		"marital_status",
		"dob",
		"commencing_date",
		"jamsostek",
		"emp_status",
		"id_number",
		"ID_TYPE",
		"jamsostek_id",
		"country_id",
		"nationality_id",
		"nationality_name",                
                "emp_type",
                "resign_date",
                "resign_reason",
                "resign_note",
                "contract_end",
                "ignore_birth",
                "location_id",
                "position",
                "can_take_advance",
                "is_sales",
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_DATE,
		TYPE_DATE,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_STRING,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_STRING,                
                TYPE_STRING,
                TYPE_DATE,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_DATE,
                TYPE_INT,
                TYPE_LONG,
                TYPE_STRING,
                TYPE_INT,
                TYPE_INT
	 }; 

        public static final int CAN_NOT_TAKE_ADVANCE    = 0;  
        public static final int CAN_TAKE_ADVANCE        = 1;  
        
        public static final int IS_SALES        = 0;  
        public static final int IS_NOT_SALES    = 1;  
                
	public DbEmployee(){
	}

	public DbEmployee(int i) throws CONException { 
		super(new DbEmployee()); 
	}

	public DbEmployee(String sOid) throws CONException { 
		super(new DbEmployee(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbEmployee(long lOid) throws CONException { 
		super(new DbEmployee(0)); 
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
		return CON_EMPLOYEE;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbEmployee().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Employee employee = fetchExc(ent.getOID()); 
		ent = (Entity)employee; 
		return employee.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Employee) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Employee) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Employee fetchExc(long oid) throws CONException{ 
		try{ 
			Employee employee = new Employee();
			DbEmployee pstEmployee = new DbEmployee(oid); 
			employee.setOID(oid);

			employee.setDepartmentId(pstEmployee.getlong(COL_DEPARTMENT_ID));
			employee.setSectionId(pstEmployee.getlong(COL_SECTION_ID));
			employee.setName(pstEmployee.getString(COL_NAME));
			employee.setAddress(pstEmployee.getString(COL_ADDRESS));
			employee.setCity(pstEmployee.getString(COL_CITY));
			employee.setState(pstEmployee.getString(COL_STATE));
			employee.setCountryName(pstEmployee.getString(COL_COUNTRY_NAME));
			employee.setEmpNum(pstEmployee.getString(COL_EMP_NUM));
			employee.setPhone(pstEmployee.getString(COL_PHONE));
			employee.setHp(pstEmployee.getString(COL_HP));
			employee.setMaritalStatus(pstEmployee.getString(COL_MARITAL_STATUS));
			employee.setDob(pstEmployee.getDate(COL_DOB));
			employee.setCommencingDate(pstEmployee.getDate(COL_COMMENCING_DATE));
			employee.setJamsostek(pstEmployee.getString(COL_JAMSOSTEK));
			employee.setEmpStatus(pstEmployee.getString(COL_EMP_STATUS));
			employee.setIdNumber(pstEmployee.getString(COL_ID_NUMBER));
			employee.setIdType(pstEmployee.getString(COL_ID_TYPE));
			employee.setJamsostekId(pstEmployee.getString(COL_JAMSOSTEK_ID));
			employee.setCountryId(pstEmployee.getlong(COL_COUNTRY_ID));
			employee.setNationalityId(pstEmployee.getlong(COL_NATIONALITY_ID));
			employee.setNationalityName(pstEmployee.getString(COL_NATIONALITY_NAME));                        
                        employee.setEmpType(pstEmployee.getString(COL_EMP_TYPE));
                        employee.setResignDate(pstEmployee.getDate(COL_RESIGN_DATE));
                        employee.setResignReason(pstEmployee.getString(COL_RESIGN_REASON));
                        employee.setResignNote(pstEmployee.getString(COL_RESIGN_NOTE));
                        employee.setContractEnd(pstEmployee.getDate(COL_CONTRACT_END));
                        employee.setIgnoreBirth(pstEmployee.getInt(COL_IGNORE_BIRTH));
                        employee.setLocationId(pstEmployee.getlong(COL_LOCATION_ID));
                        employee.setPosition(pstEmployee.getString(COL_POSITION));
                        employee.setCanTakeAdvance(pstEmployee.getInt(COL_CAN_TAKE_ADVANCE));
                        employee.setIsSales(pstEmployee.getInt(COL_IS_SALES));

			return employee; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbEmployee(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Employee employee) throws CONException{ 
		try{ 
			DbEmployee pstEmployee = new DbEmployee(0);

			pstEmployee.setLong(COL_DEPARTMENT_ID, employee.getDepartmentId());
			pstEmployee.setLong(COL_SECTION_ID, employee.getSectionId());
			pstEmployee.setString(COL_NAME, employee.getName());
			pstEmployee.setString(COL_ADDRESS, employee.getAddress());
			pstEmployee.setString(COL_CITY, employee.getCity());
			pstEmployee.setString(COL_STATE, employee.getState());
			pstEmployee.setString(COL_COUNTRY_NAME, employee.getCountryName());
			pstEmployee.setString(COL_EMP_NUM, employee.getEmpNum());
			pstEmployee.setString(COL_PHONE, employee.getPhone());
			pstEmployee.setString(COL_HP, employee.getHp());
			pstEmployee.setString(COL_MARITAL_STATUS, employee.getMaritalStatus());
			pstEmployee.setDate(COL_DOB, employee.getDob());
			pstEmployee.setDate(COL_COMMENCING_DATE, employee.getCommencingDate());
			pstEmployee.setString(COL_JAMSOSTEK, employee.getJamsostek());
			pstEmployee.setString(COL_EMP_STATUS, employee.getEmpStatus());
			pstEmployee.setString(COL_ID_NUMBER, employee.getIdNumber());
			pstEmployee.setString(COL_ID_TYPE, employee.getIdType());
			pstEmployee.setString(COL_JAMSOSTEK_ID, employee.getJamsostekId());
			pstEmployee.setLong(COL_COUNTRY_ID, employee.getCountryId());
			pstEmployee.setLong(COL_NATIONALITY_ID, employee.getNationalityId());
			pstEmployee.setString(COL_NATIONALITY_NAME, employee.getNationalityName());                        
                        pstEmployee.setString(COL_EMP_TYPE, employee.getEmpType());
                        pstEmployee.setDate(COL_RESIGN_DATE, employee.getResignDate());
                        pstEmployee.setString(COL_RESIGN_REASON, employee.getResignReason());
                        pstEmployee.setString(COL_RESIGN_NOTE, employee.getResignNote());
                        pstEmployee.setDate(COL_CONTRACT_END, employee.getContractEnd());
                        pstEmployee.setInt(COL_IGNORE_BIRTH, employee.getIgnoreBirth());
                        pstEmployee.setLong(COL_LOCATION_ID, employee.getLocationId());
                        pstEmployee.setString(COL_POSITION, employee.getPosition());
                        pstEmployee.setInt(COL_CAN_TAKE_ADVANCE, employee.getCanTakeAdvance());
                        pstEmployee.setInt(COL_IS_SALES, employee.getIsSales());

			pstEmployee.insert(); 
			employee.setOID(pstEmployee.getlong(COL_EMPLOYEE_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbEmployee(0),CONException.UNKNOWN); 
		}
		return employee.getOID();
	}

	public static long updateExc(Employee employee) throws CONException{ 
		try{ 
			if(employee.getOID() != 0){ 
				DbEmployee pstEmployee = new DbEmployee(employee.getOID());

				pstEmployee.setLong(COL_DEPARTMENT_ID, employee.getDepartmentId());
				pstEmployee.setLong(COL_SECTION_ID, employee.getSectionId());
				pstEmployee.setString(COL_NAME, employee.getName());
				pstEmployee.setString(COL_ADDRESS, employee.getAddress());
				pstEmployee.setString(COL_CITY, employee.getCity());
				pstEmployee.setString(COL_STATE, employee.getState());
				pstEmployee.setString(COL_COUNTRY_NAME, employee.getCountryName());
				pstEmployee.setString(COL_EMP_NUM, employee.getEmpNum());
				pstEmployee.setString(COL_PHONE, employee.getPhone());
				pstEmployee.setString(COL_HP, employee.getHp());
				pstEmployee.setString(COL_MARITAL_STATUS, employee.getMaritalStatus());
				pstEmployee.setDate(COL_DOB, employee.getDob());
				pstEmployee.setDate(COL_COMMENCING_DATE, employee.getCommencingDate());
				pstEmployee.setString(COL_JAMSOSTEK, employee.getJamsostek());
				pstEmployee.setString(COL_EMP_STATUS, employee.getEmpStatus());
				pstEmployee.setString(COL_ID_NUMBER, employee.getIdNumber());
				pstEmployee.setString(COL_ID_TYPE, employee.getIdType());
				pstEmployee.setString(COL_JAMSOSTEK_ID, employee.getJamsostekId());
				pstEmployee.setLong(COL_COUNTRY_ID, employee.getCountryId());
				pstEmployee.setLong(COL_NATIONALITY_ID, employee.getNationalityId());
				pstEmployee.setString(COL_NATIONALITY_NAME, employee.getNationalityName());                                
                                pstEmployee.setString(COL_EMP_TYPE, employee.getEmpType());
                                pstEmployee.setDate(COL_RESIGN_DATE, employee.getResignDate());
                                pstEmployee.setString(COL_RESIGN_REASON, employee.getResignReason());
                                pstEmployee.setString(COL_RESIGN_NOTE, employee.getResignNote());
                                pstEmployee.setDate(COL_CONTRACT_END, employee.getContractEnd());
                                pstEmployee.setInt(COL_IGNORE_BIRTH, employee.getIgnoreBirth());
                                pstEmployee.setLong(COL_LOCATION_ID, employee.getLocationId());
                                pstEmployee.setString(COL_POSITION, employee.getPosition());
                                pstEmployee.setInt(COL_CAN_TAKE_ADVANCE, employee.getCanTakeAdvance());
                                pstEmployee.setInt(COL_IS_SALES, employee.getIsSales());

				pstEmployee.update(); 
				return employee.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbEmployee(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbEmployee pstEmployee = new DbEmployee(oid);
			pstEmployee.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbEmployee(0),CONException.UNKNOWN); 
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
			String sql = "SELECT * FROM " + CON_EMPLOYEE; 
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
				Employee employee = new Employee();
				resultToObject(rs, employee);
				lists.add(employee);
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

	private static void resultToObject(ResultSet rs, Employee employee){
		try{
			employee.setOID(rs.getLong(DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID]));
			employee.setDepartmentId(rs.getLong(DbEmployee.colNames[DbEmployee.COL_DEPARTMENT_ID]));
			employee.setSectionId(rs.getLong(DbEmployee.colNames[DbEmployee.COL_SECTION_ID]));
			employee.setName(rs.getString(DbEmployee.colNames[DbEmployee.COL_NAME]));
			employee.setAddress(rs.getString(DbEmployee.colNames[DbEmployee.COL_ADDRESS]));
			employee.setCity(rs.getString(DbEmployee.colNames[DbEmployee.COL_CITY]));
			employee.setState(rs.getString(DbEmployee.colNames[DbEmployee.COL_STATE]));
			employee.setCountryName(rs.getString(DbEmployee.colNames[DbEmployee.COL_COUNTRY_NAME]));
			employee.setEmpNum(rs.getString(DbEmployee.colNames[DbEmployee.COL_EMP_NUM]));
			employee.setPhone(rs.getString(DbEmployee.colNames[DbEmployee.COL_PHONE]));
			employee.setHp(rs.getString(DbEmployee.colNames[DbEmployee.COL_HP]));
			employee.setMaritalStatus(rs.getString(DbEmployee.colNames[DbEmployee.COL_MARITAL_STATUS]));
			employee.setDob(rs.getDate(DbEmployee.colNames[DbEmployee.COL_DOB]));
			employee.setCommencingDate(rs.getDate(DbEmployee.colNames[DbEmployee.COL_COMMENCING_DATE]));
			employee.setJamsostek(rs.getString(DbEmployee.colNames[DbEmployee.COL_JAMSOSTEK]));
			employee.setEmpStatus(rs.getString(DbEmployee.colNames[DbEmployee.COL_EMP_STATUS]));
			employee.setIdNumber(rs.getString(DbEmployee.colNames[DbEmployee.COL_ID_NUMBER]));
			employee.setIdType(rs.getString(DbEmployee.colNames[DbEmployee.COL_ID_TYPE]));
			employee.setJamsostekId(rs.getString(DbEmployee.colNames[DbEmployee.COL_JAMSOSTEK_ID]));
			employee.setCountryId(rs.getLong(DbEmployee.colNames[DbEmployee.COL_COUNTRY_ID]));
			employee.setNationalityId(rs.getLong(DbEmployee.colNames[DbEmployee.COL_NATIONALITY_ID]));
			employee.setNationalityName(rs.getString(DbEmployee.colNames[DbEmployee.COL_NATIONALITY_NAME]));                        
                        employee.setEmpType(rs.getString(DbEmployee.colNames[DbEmployee.COL_EMP_TYPE]));
                        employee.setResignDate(rs.getDate(DbEmployee.colNames[DbEmployee.COL_RESIGN_DATE]));
                        employee.setResignReason(rs.getString(DbEmployee.colNames[DbEmployee.COL_RESIGN_REASON]));
                        employee.setResignNote(rs.getString(DbEmployee.colNames[DbEmployee.COL_RESIGN_NOTE]));
                        employee.setContractEnd(rs.getDate(DbEmployee.colNames[DbEmployee.COL_CONTRACT_END]));
                        employee.setIgnoreBirth(rs.getInt(DbEmployee.colNames[DbEmployee.COL_IGNORE_BIRTH]));
                        employee.setLocationId(rs.getLong(DbEmployee.colNames[DbEmployee.COL_LOCATION_ID]));
                        employee.setPosition(rs.getString(DbEmployee.colNames[DbEmployee.COL_POSITION]));
                        employee.setCanTakeAdvance(rs.getInt(DbEmployee.colNames[DbEmployee.COL_CAN_TAKE_ADVANCE]));
                        employee.setIsSales(rs.getInt(DbEmployee.colNames[DbEmployee.COL_IS_SALES]));

		}catch(Exception e){ }
	}

	public static boolean checkOID(long employeeId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + CON_EMPLOYEE + " WHERE " + 
						DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID] + " = " + employeeId;

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
			String sql = "SELECT COUNT("+ DbEmployee.colNames[DbEmployee.COL_EMPLOYEE_ID] + ") FROM " + CON_EMPLOYEE;
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
			  	   Employee employee = (Employee)list.get(ls);
				   if(oid == employee.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
}

