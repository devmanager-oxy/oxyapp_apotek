/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  11/14/2008 9:58:08 AM
\***********************************/

package com.project.ccs.postransaction.sales;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;


public class JspSalesDetail extends JSPHandler implements I_JSPInterface, I_JSPType {

	private SalesDetail salesDetail;

	public static final  String JSP_NAME_SALES_DETAIL = "jsp_sales_detail";

	public static final  int JSP_SALES_DETAIL_ID = 0;
	public static final  int JSP_SALES_ID = 1;
	public static final  int JSP_PRODUCT_MASTER_ID = 2;
	public static final  int JSP_SQUENCE = 3;
	public static final  int JSP_COGS = 4;
	public static final  int JSP_SELLING_PRICE = 5;
	public static final  int JSP_STATUS = 6;
	public static final  int JSP_CURRENCY_ID = 7;
	public static final  int JSP_COMPANY_ID = 8;
	public static final  int JSP_QTY = 9;
	public static final  int JSP_TOTAL = 10;
        
        public static final  int JSP_DISCOUNT_PERCENT = 11;
        public static final  int JSP_DISCOUNT_AMOUNT = 12;
        public static final  int JSP_PROPOSAL_ID = 13;
        public static final  int JSP_SALES_TYPE = 14;
        public static final  int JSP_SERIAL_NUMBER = 15;
	public static final  String[] colNames = {
		"x_jsp_sales_detail_id",
		"x_sales_id",
		"x_product_master_id",
		"x_squence",
		"x_cogs",
		"x_selling_price",
		"x_status",
		"x_currency_id",
		"x_company_id",
		"x_qty",
		"x_total",
                
                "x_discount_percent",
                "x_discount_amount",
                "proposal_id",
                "x_jsp_sales_type",
                "x_jsp_serial_number"
	};

	public static final  int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG + ENTRY_REQUIRED,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_LONG,
                TYPE_INT, 
                TYPE_STRING
                        
	};

	public JspSalesDetail(){
	}

	public JspSalesDetail(SalesDetail salesDetail) {
		this.salesDetail = salesDetail;
	}

	public JspSalesDetail(HttpServletRequest request, SalesDetail salesDetail)
	{
		super(new JspSalesDetail(salesDetail), request);
		this.salesDetail = salesDetail;
	}

	public String getFormName() { return JSP_NAME_SALES_DETAIL; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; }

	public int getFieldSize() { return colNames.length; }

	public SalesDetail getEntityObject(){ return salesDetail; }

	public void requestEntityObject(SalesDetail salesDetail) {
		try{
			this.requestParam();

			salesDetail.setSalesId(getLong(JSP_SALES_ID));
                        salesDetail.setProposalId(getLong(JSP_PROPOSAL_ID));
                        
			salesDetail.setProductMasterId(getLong(JSP_PRODUCT_MASTER_ID));
			salesDetail.setSquence(getInt(JSP_SQUENCE));
			salesDetail.setCogs(getDouble(JSP_COGS));
			salesDetail.setSellingPrice(getDouble(JSP_SELLING_PRICE));
			salesDetail.setStatus(getInt(JSP_STATUS));
			salesDetail.setCurrencyId(getLong(JSP_CURRENCY_ID));
			salesDetail.setCompanyId(getLong(JSP_COMPANY_ID));
			salesDetail.setQty(getDouble(JSP_QTY));
			salesDetail.setTotal(getDouble(JSP_TOTAL));
                        
                        salesDetail.setDiscountPercent(getDouble(JSP_DISCOUNT_PERCENT));  
                        salesDetail.setDiscountAmount(getDouble(JSP_DISCOUNT_AMOUNT));
                        salesDetail.setSalesType(getInt(JSP_SALES_TYPE));
                        salesDetail.setSerial_number(getString(JSP_SERIAL_NUMBER));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}

}
