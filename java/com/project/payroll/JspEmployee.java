package com.project.payroll; 

import java.io.*;
import java.sql.*;
import java.util.*;
import com.project.util.*;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class JspEmployee extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Employee employee;

	public static final String JSP_NAME_EMPLOYEE		=  "frmemployee" ;

	public static final int JSP_EMPLOYEE_ID			=  0 ;
	public static final int JSP_DEPARTMENT_ID		=  1 ;
	public static final int JSP_SECTION_ID			=  2 ;
	public static final int JSP_NAME			=  3 ;
	public static final int JSP_ADDRESS			=  4 ;
	public static final int JSP_CITY			=  5 ;
	public static final int JSP_STATE			=  6 ;
	public static final int JSP_COUNTRY_NAME		=  7 ;
	public static final int JSP_EMP_NUM			=  8 ;
	public static final int JSP_PHONE			=  9 ;
	public static final int JSP_HP                          =  10 ;
	public static final int JSP_MARITAL_STATUS		=  11 ;
	public static final int JSP_DOB                         =  12 ;
	public static final int JSP_COMMENCING_DATE		=  13 ;
	public static final int JSP_JAMSOSTEK			=  14 ;
	public static final int JSP_EMP_STATUS			=  15 ;
	public static final int JSP_ID_NUMBER			=  16 ;
	public static final int JSP_ID_TYPE			=  17 ;
	public static final int JSP_JAMSOSTEK_ID		=  18 ;
	public static final int JSP_COUNTRY_ID			=  19 ;
	public static final int JSP_NATIONALITY_ID		=  20 ;
	public static final int JSP_NATIONALITY_NAME		=  21 ;        
        public static final int JSP_EMP_TYPE                    =  22;
        public static final int JSP_RESIGN_DATE                 =  23;
        public static final int JSP_RESIGN_REASON               =  24;
        public static final int JSP_RESIGN_NOTE                 =  25;
        public static final int JSP_CONTRACT_END                =  26;  
        public static final int JSP_IGNORE_BIRTH                =  27;  
        public static final int JSP_LOCATION_ID                 =  28;  
        public static final int JSP_POSITION                    =  29;  
        public static final int JSP_CAN_TAKE_ADVANCE            =  30;  
        public static final int JSP_IS_SALES                    =  31;  

	public static String[] colNames = {
		"x_empid",  "x_depid",
		"x_secid",  "x_name",
		"x_address",  "x_city",
		"x_state",  "x_ctrname",
		"x_empnum",  "x_phone",
		"x_hp",  "x_marital",
		"x_dob",  "x_commencing",
		"x_jamsostek",  "x_empstatus",
		"x_idnumber",  "x_idtype",
		"x_jamsosteknum",  "x_countryid",
		"x_nationalid",  "x_nationalname",                
                "x_emptype","x_resdate",
                "x_resreason","x_resnote",
                "x_conend", "x_ignore",
                "xlocation_id",
                "x_position","x_can_take_advance",
                "x_is_sales"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING + ENTRY_REQUIRED,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_STRING,                
                TYPE_STRING, TYPE_STRING,
                TYPE_STRING, TYPE_STRING,
                TYPE_STRING, TYPE_INT,
                TYPE_LONG,
                TYPE_STRING,TYPE_INT,
                TYPE_INT
	} ;

	public JspEmployee(){
	}
	public JspEmployee(Employee employee){
		this.employee = employee;
	}

	public JspEmployee(HttpServletRequest request, Employee employee){
		super(new JspEmployee(employee), request);
		this.employee = employee;
	}

	public String getFormName() { return JSP_NAME_EMPLOYEE; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Employee getEntityObject(){ return employee; }

	public void requestEntityObject(Employee employee) {
		try{
			this.requestParam();
			employee.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
			employee.setSectionId(getLong(JSP_SECTION_ID));
			employee.setName(getString(JSP_NAME));
			employee.setAddress(getString(JSP_ADDRESS));
			employee.setCity(getString(JSP_CITY));
			employee.setState(getString(JSP_STATE));
			employee.setCountryName(getString(JSP_COUNTRY_NAME));
			employee.setEmpNum(getString(JSP_EMP_NUM));
			employee.setPhone(getString(JSP_PHONE));
			employee.setHp(getString(JSP_HP));
			employee.setMaritalStatus(getString(JSP_MARITAL_STATUS));
			employee.setDob(JSPFormater.formatDate(getString(JSP_DOB), "dd/MM/yyyy"));
			employee.setCommencingDate(JSPFormater.formatDate(getString(JSP_COMMENCING_DATE), "dd/MM/yyyy"));
			employee.setJamsostek(getString(JSP_JAMSOSTEK));
			employee.setEmpStatus(getString(JSP_EMP_STATUS));
			employee.setIdNumber(getString(JSP_ID_NUMBER));
			employee.setIdType(getString(JSP_ID_TYPE));
			employee.setJamsostekId(getString(JSP_JAMSOSTEK_ID));
			employee.setCountryId(getLong(JSP_COUNTRY_ID));
			employee.setNationalityId(getLong(JSP_NATIONALITY_ID));
			employee.setNationalityName(getString(JSP_NATIONALITY_NAME));                        
                        employee.setEmpType(getString(JSP_EMP_TYPE));
                        employee.setResignDate(JSPFormater.formatDate(getString(JSP_RESIGN_DATE), "dd/MM/yyyy"));
                        employee.setResignReason(getString(JSP_RESIGN_REASON));
                        employee.setResignNote(getString(JSP_RESIGN_NOTE));
                        employee.setContractEnd(JSPFormater.formatDate(getString(JSP_CONTRACT_END), "dd/MM/yyyy"));
                        employee.setIgnoreBirth(getInt(JSP_IGNORE_BIRTH));
                        employee.setLocationId(getLong(JSP_LOCATION_ID));
                        employee.setPosition(getString(JSP_POSITION));
                        employee.setCanTakeAdvance(getInt(JSP_CAN_TAKE_ADVANCE));
                        employee.setIsSales(getInt(JSP_IS_SALES));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
