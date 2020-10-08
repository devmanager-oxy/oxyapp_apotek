
package com.project.ccs.postransaction.sales;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspSales extends JSPHandler implements I_JSPInterface, I_JSPType {

	private Sales sales;

	public static final  String JSP_NAME_SALES = "sales";

	public static final  int JSP_SALES_ID = 0;
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
        public static final  int JSP_ITEM_GROUP_ID = 37;
        public static final  int JSP_VAT_PERCENT = 38;
        public static final  int JSP_VAT_AMOUNT = 39;
        public static final  int JSP_TYPE = 40;        
        public static final  int JSP_PPH_PERCENT = 41;
        public static final  int JSP_PPH_AMOUNT = 42;
        public static final  int JSP_PPH_TYPE = 43;
        public static final  int JSP_SALES_TYPE = 44;
        public static final  int JSP_MARKETING_ID = 45;
        public static final  int JSP_LOCATION_ID = 46;
        public static final  int JSP_PAYMENT_STATUS = 47;
        public static final  int JSP_CASH_CASHIER_ID = 48;
        public static final  int JSP_SHIFT_ID = 49;
        public static final  int JSP_CASH_MASTER_ID = 50;
        public static final  int JSP_SALES_RETUR_ID = 51;
        
	public static final  String[] colNames = {
		"x_sales_id",
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
                
                "xabc_discount_percent",
                "xabc_discount_amount",
                "xabc_vat",
                "xabc_discount",
                
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
                "x_item_group_id",
                "xx_vat_percent",
                "xx_vat_amount",
                "jsp_type",
                
                "xx_pph_percent",
                "xx_pph_amount",
                "jsp_pph_type",
                "jsp_sales_type",
                "marketing_id",
                "xx_location_id",
                "x_payment_status",
                "x_cash_cashier_id",
                "x_shift_id",
                "x_cash_master_id",
                "x_sales_retur_id"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_DATE ,
		TYPE_STRING ,
		TYPE_STRING ,
		TYPE_INT ,
		TYPE_STRING ,
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
		TYPE_FLOAT,
		TYPE_LONG ,
		TYPE_LONG ,
		TYPE_LONG,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_INT,
                
                TYPE_INT,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_INT,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_LONG,
                
                TYPE_LONG,
                TYPE_LONG,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_INT,
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG
	};

	public JspSales(){
	}

	public JspSales(Sales sales) {
		this.sales = sales;
	}

	public JspSales(HttpServletRequest request, Sales sales)
	{
		super(new JspSales(sales), request);
		this.sales = sales;
	}

	public String getFormName() { return JSP_NAME_SALES; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public Sales getEntityObject(){ return sales; }

	public void requestEntityObject(Sales sales) {
		try{
			this.requestParam();
                        sales.setDate(getDate(JSP_DATE));
			sales.setNumber(getString(JSP_NUMBER));
			sales.setNumberPrefix(getString(JSP_NUMBER_PREFIX));
			sales.setCounter(getInt(JSP_COUNTER));
			sales.setName(getString(JSP_NAME));
			sales.setCustomerId(getLong(JSP_CUSTOMER_ID));
			sales.setCustomerPic(getString(JSP_CUSTOMER_PIC));
			sales.setCustomerPicPhone(getString(JSP_CUSTOMER_PIC_PHONE));
			sales.setCustomerAddress(getString(JSP_CUSTOMER_ADDRESS));
			sales.setStartDate(JSPFormater.formatDate(getString(JSP_START_DATE),"dd/MM/yyyy"));
			sales.setEndDate(JSPFormater.formatDate(getString(JSP_END_DATE),"dd/MM/yyyy"));
			sales.setCustomerPicPosition(getString(JSP_CUSTOMER_PIC_POSITION));
			sales.setEmployeeId(getLong(JSP_EMPLOYEE_ID));
			sales.setUserId(getLong(JSP_USER_ID));
			sales.setEmployeeHp(getString(JSP_EMPLOYEE_HP));
			sales.setDescription(getString(JSP_DESCRIPTION));
			sales.setStatus(getInt(JSP_STATUS));
			sales.setAmount(getDouble(JSP_AMOUNT));
			sales.setCurrencyId(getLong(JSP_CURRENCY_ID));
			sales.setCompanyId(getLong(JSP_COMPANY_ID));
			sales.setCategoryId(getLong(JSP_CATEGORY_ID));
                        
                        sales.setDiscountPercent(getDouble(JSP_DISCOUNT_PERCENT));
                        sales.setDiscountAmount(getDouble(JSP_DISCOUNT_AMOUNT));
                        sales.setVat(getInt(JSP_VAT));
                        sales.setDiscount(getInt(JSP_DISCOUNT));
                        
                        sales.setWarrantyStatus(getInt(JSP_WARRANTY_STATUS));
                        sales.setWarrantyDate(JSPFormater.formatDate(getString(JSP_WARRANTY_DATE),"dd/MM/yyyy"));
                        sales.setWarrantyReceive(getString(JSP_WARRANTY_RECEIVE));
                        sales.setManualStatus(getInt(JSP_MANUAL_STATUS));
                        sales.setManualDate(JSPFormater.formatDate(getString(JSP_MANUAL_DATE),"dd/MM/yyyy"));
                        sales.setManualReceive(getString(JSP_MANUAL_RECEIVE));
                        sales.setNoteClosing(getString(JSP_NOTE_CLOSING));
                        
                        sales.setBookingRate(getDouble(JSP_BOOKING_RATE));
                        sales.setExchangeAmount(getDouble(JSP_EXCHANGE_AMOUNT));
                        sales.setProposalId(getLong(JSP_PROPOSAL_ID));
                        
                        sales.setUnitUsahaId(getLong(JSP_UNIT_USAHA_ID));
                        sales.setItemGroupId(getLong(JSP_ITEM_GROUP_ID));
                        
                        sales.setVatPercent(getDouble(JSP_VAT_PERCENT));
                        sales.setVatAmount(getDouble(JSP_VAT_AMOUNT));
                        sales.setType(getInt(JSP_TYPE));
                        
                        sales.setPphPercent(getDouble(JSP_PPH_PERCENT));
                        sales.setPphAmount(getDouble(JSP_PPH_AMOUNT));
                        sales.setPphType(getInt(JSP_PPH_TYPE));
                        sales.setSalesType(getInt(JSP_SALES_TYPE));
                        sales.setMarketingId(getLong(JSP_MARKETING_ID));
                        sales.setLocation_id(getLong(JSP_LOCATION_ID));
                        
                        sales.setPaymentStatus(getInt(JSP_PAYMENT_STATUS));
                        sales.setCashCashierId(getLong(JSP_CASH_CASHIER_ID));
                        sales.setShift_id(getLong(JSP_SHIFT_ID));
                        sales.setCash_master_id(getLong(JSP_CASH_MASTER_ID));
                        sales.setSalesReturId(getLong(JSP_SALES_RETUR_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
