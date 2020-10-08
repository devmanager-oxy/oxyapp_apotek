
package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
//import com.project.fms.master.*;

public class JspCompany_1 extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Company company;

	public static final String JSP_NAME_COMPANY		=  "JSP_NAME_COMPANY" ;

	public static final int JSP_COMPANY_ID			=  0 ;
	public static final int JSP_NAME			=  1 ;
	public static final int JSP_SERIAL_NUMBER			=  2 ;
	public static final int JSP_ADDRESS			=  3 ;
	public static final int JSP_FISCAL_YEAR			=  4 ;
	public static final int JSP_END_FISCAL_MONTH			=  5 ;
	public static final int JSP_ENTRY_START_MONTH			=  6 ;
	public static final int JSP_NUMBER_OF_PERIOD			=  7 ;
	public static final int JSP_CASH_RECEIVE_CODE			=  8 ;
	public static final int JSP_PETTYCASH_PAYMENT_CODE			=  9 ;
	public static final int JSP_PETTYCASH_REPLACE_CODE			=  10 ;
	public static final int JSP_BANK_DEPOSIT_CODE			=  11 ;
	public static final int JSP_BANK_PAYMENT_PO_CODE			=  12 ;
	public static final int JSP_BANK_PAYMENT_NONPO_CODE			=  13 ;
	public static final int JSP_PURCHASE_ORDER_CODE			=  14 ;
	public static final int JSP_GENERAL_LEDGER_CODE			=  15 ;
	public static final int JSP_MAX_PETTYCASH_REPLENIS			=  16 ;
	public static final int JSP_MAX_PETTYCASH_TRANSACTION			=  17 ;
	public static final int JSP_BOOKING_CURRENCY_CODE			=  18 ;
	public static final int JSP_BOOKING_CURRENCY_ID			=  19 ;
	public static final int JSP_SYSTEM_LOCATION			=  20 ;
	public static final int JSP_ACTIVATION_CODE			=  21 ;
	public static final int JSP_SYSTEM_LOCATION_CODE			=  22 ;
	public static final int JSP_CONTACT			=  23 ;
        public static final int JSP_ADDRESS2			=  24 ;
        
        public static final int JSP_DEPARTMENT_LEVEL			=  25 ;
        public static final int JSP_GOVERNMENT_VAT			=  26 ;

	public static String[] colNames = {
		"JSP_COMPANY_ID",  "JSP_NAME",
		"JSP_SERIAL_NUMBER",  "JSP_ADDRESS",
		"JSP_FISCAL_YEAR",  "JSP_END_FISCAL_MONTH",
		"JSP_ENTRY_START_MONTH",  "JSP_NUMBER_OF_PERIOD",
		"JSP_CASH_RECEIVE_CODE",  "JSP_PETTYCASH_PAYMENT_CODE",
		"JSP_PETTYCASH_REPLACE_CODE",  "JSP_BANK_DEPOSIT_CODE",
		"JSP_BANK_PAYMENT_PO_CODE",  "JSP_BANK_PAYMENT_NONPO_CODE",
		"JSP_PURCHASE_ORDER_CODE",  "JSP_GENERAL_LEDGER_CODE",
		"JSP_MAX_PETTYCASH_REPLENIS",  "JSP_MAX_PETTYCASH_TRANSACTION",
		"JSP_BOOKING_CURRENCY_CODE",  "JSP_BOOKING_CURRENCY_ID",
		"JSP_SYSTEM_LOCATION",  "JSP_ACTIVATION_CODE",
		"JSP_SYSTEM_LOCATION_CODE",  "JSP_CONTACT",
                "JSP_ADDRESS2",
                "JSP_DEPARTMENT_LEVEL", "JSP_GOVERNMENT_VAT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_INT,  TYPE_INT,
		TYPE_INT,  TYPE_INT,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_LONG,
		TYPE_LONG,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
                TYPE_STRING,
                TYPE_INT, TYPE_FLOAT
	} ;

	public JspCompany_1(){
	}
	public JspCompany_1(Company company){
		this.company = company;
	}

	public JspCompany_1(HttpServletRequest request, Company company){
		super(new JspCompany_1(company), request);
		this.company = company;
	}

	public String getFormName() { return JSP_NAME_COMPANY; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Company getEntityObject(){ return company; }

	public void requestEntityObject(Company company) {
		try{
			this.requestParam();
			company.setName(getString(JSP_NAME));
			company.setSerialNumber(getString(JSP_SERIAL_NUMBER));
			company.setAddress(getString(JSP_ADDRESS));
			company.setFiscalYear(getInt(JSP_FISCAL_YEAR));
			company.setEndFiscalMonth(getInt(JSP_END_FISCAL_MONTH));
			company.setEntryStartMonth(getInt(JSP_ENTRY_START_MONTH));
			company.setNumberOfPeriod(getInt(JSP_NUMBER_OF_PERIOD));
			company.setCashReceiveCode(getString(JSP_CASH_RECEIVE_CODE));
			company.setPettycashPaymentCode(getString(JSP_PETTYCASH_PAYMENT_CODE));
			company.setPettycashReplaceCode(getString(JSP_PETTYCASH_REPLACE_CODE));
			company.setBankDepositCode(getString(JSP_BANK_DEPOSIT_CODE));
			company.setBankPaymentPoCode(getString(JSP_BANK_PAYMENT_PO_CODE));
			company.setBankPaymentNonpoCode(getString(JSP_BANK_PAYMENT_NONPO_CODE));
			company.setPurchaseOrderCode(getString(JSP_PURCHASE_ORDER_CODE));
			company.setGeneralLedgerCode(getString(JSP_GENERAL_LEDGER_CODE));
			company.setMaxPettycashReplenis(getDouble(JSP_MAX_PETTYCASH_REPLENIS));
			company.setMaxPettycashTransaction(getDouble(JSP_MAX_PETTYCASH_TRANSACTION));
			company.setBookingCurrencyCode(getString(JSP_BOOKING_CURRENCY_CODE));
			company.setBookingCurrencyId(getLong(JSP_BOOKING_CURRENCY_ID));
			company.setSystemLocation(getLong(JSP_SYSTEM_LOCATION));
			company.setActivationCode(getString(JSP_ACTIVATION_CODE));
			company.setSystemLocationCode(getString(JSP_SYSTEM_LOCATION_CODE));
			company.setContact(getString(JSP_CONTACT));
                        company.setAddress2(getString(JSP_ADDRESS2));
                        
                        company.setDepartmentLevel(getInt(JSP_DEPARTMENT_LEVEL));
                        company.setGovernmentVat(getDouble(JSP_GOVERNMENT_VAT));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
