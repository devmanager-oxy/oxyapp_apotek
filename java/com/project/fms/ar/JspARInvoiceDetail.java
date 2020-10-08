
package com.project.fms.ar;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspARInvoiceDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ARInvoiceDetail aRInvoiceDetail;

	public static final String JSP_NAME_ARINVOICEDETAIL		=  "JSP_NAME_ARINVOICEDETAIL" ;

	public static final int JSP_AR_INVOICE_ID		=  0 ;
	public static final int JSP_AR_INVOICE_DETAIL_ID	=  1 ;
	public static final int JSP_ITEM_NAME			=  2 ;
	public static final int JSP_COA_ID			=  3 ;
	public static final int JSP_QTY                         =  4 ;
	public static final int JSP_PRICE			=  5 ;
	public static final int JSP_DISCOUNT			=  6 ;
	public static final int JSP_TOTAL_AMOUNT		=  7 ;
	public static final int JSP_DEPARTMENT_ID		=  8 ;
	public static final int JSP_COMPANY_ID			=  9 ;
        public static final int JSP_MEMO			=  10 ;

	public static String[] colNames = {
		"JSP_AR_INVOICE_ID",  "JSP_AR_INVOICE_DETAIL_ID",
		"JSP_ITEM_NAME",  "JSP_COA_ID",
		"JSP_QTY",  "JSP_PRICE",
		"JSP_DISCOUNT",  "JSP_TOTAL_AMOUNT",
		"JSP_DEPARTMENT_ID",  "JSP_COMPANY_ID",
                "JSP_XMEMO"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_LONG,
		TYPE_INT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_LONG,  TYPE_LONG,
                TYPE_STRING
	} ;

	public JspARInvoiceDetail(){
	}
	public JspARInvoiceDetail(ARInvoiceDetail aRInvoiceDetail){
		this.aRInvoiceDetail = aRInvoiceDetail;
	}

	public JspARInvoiceDetail(HttpServletRequest request, ARInvoiceDetail aRInvoiceDetail){
		super(new JspARInvoiceDetail(aRInvoiceDetail), request);
		this.aRInvoiceDetail = aRInvoiceDetail;
	}

	public String getFormName() { return JSP_NAME_ARINVOICEDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ARInvoiceDetail getEntityObject(){ return aRInvoiceDetail; }

	public void requestEntityObject(ARInvoiceDetail aRInvoiceDetail) {
		try{
			this.requestParam();
			aRInvoiceDetail.setArInvoiceId(getLong(JSP_AR_INVOICE_ID));
			aRInvoiceDetail.setItemName(getString(JSP_ITEM_NAME));
			aRInvoiceDetail.setCoaId(getLong(JSP_COA_ID));
			aRInvoiceDetail.setQty(getInt(JSP_QTY));
			aRInvoiceDetail.setPrice(getDouble(JSP_PRICE));
			aRInvoiceDetail.setDiscount(getDouble(JSP_DISCOUNT));
			aRInvoiceDetail.setTotalAmount(getDouble(JSP_TOTAL_AMOUNT));
			aRInvoiceDetail.setDepartmentId(getLong(JSP_DEPARTMENT_ID));
			aRInvoiceDetail.setCompanyId(getLong(JSP_COMPANY_ID));
                        aRInvoiceDetail.setMemo(getString(JSP_MEMO));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
