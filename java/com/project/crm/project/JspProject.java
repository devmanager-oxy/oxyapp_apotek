/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  9/29/2008 3:16:36 PM
\***********************************/

package com.project.crm.project;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspProject extends JSPHandler implements I_JSPInterface, I_JSPType {

	private Project project;

	public static final  String JSP_NAME_PROJECT = "project";

	public static final  int JSP_PROJECT_ID = 0;
	public static final  int JSP_DATE = 1;
	public static final  int JSP_NUMBER = 2;
	public static final  int JSP_NUMBER_PREFIX = 3;
	public static final  int JSP_COUNTER = 4;
	public static final  int JSP_NAME = 5;
	public static final  int JSP_CUSTOMER_ID = 6;
	public static final  int JSP_CUSTOMER_PIC = 7;
	public static final  int JSP_CUSTOMER_PIC_PHONE = 8;
	public static final  int JSP_CUSTOMER_ADDRESS = 9;
	public static final  int JSP_START_DATE = 10;
	public static final  int JSP_END_DATE = 11;
	public static final  int JSP_CUSTOMER_PIC_POSITION = 12;
	public static final  int JSP_EMPLOYEE_ID = 13;
	public static final  int JSP_USER_ID = 14;
	public static final  int JSP_EMPLOYEE_HP = 15;
	public static final  int JSP_DESCRIPTION = 16;
	public static final  int JSP_STATUS = 17;
	public static final  int JSP_AMOUNT = 18;
	public static final  int JSP_CURRENCY_ID = 19;
	public static final  int JSP_COMPANY_ID = 20;
	public static final  int JSP_CATEGORY_ID = 21;
        
        public static final  int JSP_DISCOUNT_PERCENT = 22;
        public static final  int JSP_DISCOUNT_AMOUNT = 23;
        public static final  int JSP_VAT = 24;
        public static final  int JSP_DISCOUNT = 25;
        public static final  int JSP_WARRANTY_STATUS = 26;
        public static final  int JSP_WARRANTY_DATE = 27;
        public static final  int JSP_WARRANTY_RECEIVE = 28;        
        public static final  int JSP_MANUAL_STATUS = 29;
        public static final  int JSP_MANUAL_DATE = 30;
        public static final  int JSP_MANUAL_RECEIVE = 31;        
        public static final  int JSP_NOTE_CLOSING = 32;
        public static final  int JSP_BOOKING_RATE = 33;
        public static final  int JSP_EXCHANGE_AMOUNT = 34;
        public static final  int JSP_PROPOSAL_ID = 35;
        public static final  int JSP_UNIT_USAHA_ID = 36;
        public static final  int JSP_PPH_PERCENT = 37;
        public static final  int JSP_PPH_AMOUNT = 38;
        public static final  int JSP_PPH_TYPE = 39;

	public static final  String[] colNames = {
		"x_project_id",
		"x_date",
		"x_number",
		"x_number_prefix",
		"x_counter",
		"x_name",
		"x_customer_id",
		"x_customer_pic",
		"x_customer_pic_phone",
		"x_customer_address",
		"x_start_date",
		"x_end_date",
		"x_customer_pic_position",
		"x_employee_id",
		"x_user_id",
		"x_employee_hp",
		"x_description",
		"x_status",
		"x_amount",
		"x_currency_id",
		"x_company_id",
		"x_category_id",
                
                "x_discount_percent",
                "x_discount_amount",
                "x_vat",
                "x_discount",   
                "x_warranty_status", 
                "x_warranty_date", 
                "x_warranty_receive", 
                "x_manual_status", 
                "x_manual_date", 
                "x_manual_receive",
                "x_note_closing",
                "x_booking_rate",
                "x_exchange_amount",
                "x_proposal_id", 
                "x_unit_usaha_id", 
                "x_pph_percent",
                "x_pph_amount", 
                "x_pph_type"       
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_STRING ,
		TYPE_STRING ,
		TYPE_STRING ,
		TYPE_INT ,
		TYPE_STRING + ENTRY_REQUIRED ,
		TYPE_LONG ,
		TYPE_STRING ,
		TYPE_STRING ,
		TYPE_STRING ,
		TYPE_STRING ,
		TYPE_STRING ,
		TYPE_STRING ,
		TYPE_LONG ,
		TYPE_LONG ,
		TYPE_STRING ,
		TYPE_STRING ,
		TYPE_INT ,
		TYPE_FLOAT + ENTRY_REQUIRED ,
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

	public JspProject(){
	}

	public JspProject(Project project) {
		this.project = project;
	}

	public JspProject(HttpServletRequest request, Project project)
	{
		super(new JspProject(project), request);
		this.project = project;
	}

	public String getFormName() { return JSP_NAME_PROJECT; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public Project getEntityObject(){ return project; }

	public void requestEntityObject(Project project) {
		try{
			this.requestParam();

			project.setDate(JSPFormater.formatDate(getString(JSP_DATE),"dd/MM/yyyy"));
			project.setNumber(getString(JSP_NUMBER));
			project.setNumberPrefix(getString(JSP_NUMBER_PREFIX));
			project.setCounter(getInt(JSP_COUNTER));
			project.setName(getString(JSP_NAME));
			project.setCustomerId(getLong(JSP_CUSTOMER_ID));
			project.setCustomerPic(getString(JSP_CUSTOMER_PIC));
			project.setCustomerPicPhone(getString(JSP_CUSTOMER_PIC_PHONE));
			project.setCustomerAddress(getString(JSP_CUSTOMER_ADDRESS));
			project.setStartDate(JSPFormater.formatDate(getString(JSP_START_DATE),"dd/MM/yyyy"));
			project.setEndDate(JSPFormater.formatDate(getString(JSP_END_DATE),"dd/MM/yyyy"));
			project.setCustomerPicPosition(getString(JSP_CUSTOMER_PIC_POSITION));
			project.setEmployeeId(getLong(JSP_EMPLOYEE_ID));
			project.setUserId(getLong(JSP_USER_ID));
			project.setEmployeeHp(getString(JSP_EMPLOYEE_HP));
			project.setDescription(getString(JSP_DESCRIPTION));
			project.setStatus(getInt(JSP_STATUS));
			project.setAmount(getDouble(JSP_AMOUNT));
			project.setCurrencyId(getLong(JSP_CURRENCY_ID));
			project.setCompanyId(getLong(JSP_COMPANY_ID));
			project.setCategoryId(getLong(JSP_CATEGORY_ID));
                        
                        project.setDiscountPercent(getDouble(JSP_DISCOUNT_PERCENT));
                        project.setDiscountAmount(getDouble(JSP_DISCOUNT_AMOUNT));                    
                        project.setVat(getInt(JSP_VAT));
                        project.setDiscount(getInt(JSP_DISCOUNT));
                        project.setWarrantyStatus(getInt(JSP_WARRANTY_STATUS));
                        project.setWarrantyDate(getDate(JSP_WARRANTY_DATE));
                        project.setWarrantyReceive(getString(JSP_WARRANTY_RECEIVE));
                        project.setManualStatus(getInt(JSP_MANUAL_STATUS));
                        project.setManualDate(getDate(JSP_MANUAL_DATE));
                        project.setNoteClosing(getString(JSP_NOTE_CLOSING));
                        project.setBookingRate(getDouble(JSP_BOOKING_RATE));
                        project.setExchangeAmount(getDouble(JSP_EXCHANGE_AMOUNT));
                        project.setProposalId(getLong(JSP_PROPOSAL_ID));
                        project.setUnitUsahaId(getLong(JSP_UNIT_USAHA_ID));
                        project.setPphPercent(getDouble(JSP_PPH_PERCENT));
                        project.setPphAmount(getDouble(JSP_PPH_AMOUNT));
                        project.setPphType(getInt(JSP_PPH_TYPE));
                        

		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
