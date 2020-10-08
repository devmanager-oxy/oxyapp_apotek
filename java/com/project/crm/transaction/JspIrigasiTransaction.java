package com.project.crm.transaction;

import com.project.crm.transaction.*;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspIrigasiTransaction extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private IrigasiTransaction irigasiTransaction;

	public static final String JSP_NAME_IRIGASITRANSACTION		=  "JSP_NAME_IRIGASITRANSACTION" ;

	public static final int JSP_FIELD_IRIGASI_TRANSACTION_ID	=  0 ;
	public static final int JSP_FIELD_CUSTOMER_ID			=  1 ;
	public static final int JSP_FIELD_MASTER_IRIGASI_ID		=  2 ;
	public static final int JSP_FIELD_PERIOD_ID			=  3 ;
	public static final int JSP_FIELD_BULAN_INI                     =  4 ;
	public static final int JSP_FIELD_BULAN_LALU			=  5 ;
	public static final int JSP_FIELD_HARGA                         =  6 ;
    public static final int JSP_FIELD_POSTED_STATUS			=  7 ;
    public static final int JSP_FIELD_KETERANGAN			=  8 ;

	public static String[] colNames = {
		"JSP_FIELD_IRIGASI_TRANSACTION_ID",  "JSP_FIELD_CUSTOMER_ID",
		"JSP_FIELD_MASTER_IRIGASI_ID",  "JSP_FIELD_PERIOD_ID",
		"JSP_FIELD_BULAN_INI",  "JSP_FIELD_BULAN_LALU",
		"JSP_FIELD_HARGA", "JSP_FIELD_POSTED_STATUS",
		"JSP_FIELD_KETERANGAN"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT, TYPE_INT,
		TYPE_STRING
	} ;

	public JspIrigasiTransaction(){
	}
	public JspIrigasiTransaction(IrigasiTransaction irigasiTransaction){
		this.irigasiTransaction = irigasiTransaction;
	}

	public JspIrigasiTransaction(HttpServletRequest request, IrigasiTransaction irigasiTransaction){
		super(new JspIrigasiTransaction(irigasiTransaction), request);
		this.irigasiTransaction = irigasiTransaction;
	}

	public String getFormName() { return JSP_NAME_IRIGASITRANSACTION; }

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public IrigasiTransaction getEntityObject(){ return irigasiTransaction; }

	public void requestEntityObject(IrigasiTransaction irigasiTransaction) {
		try{
			this.requestParam();
			irigasiTransaction.setCustumerId(getLong(JSP_FIELD_CUSTOMER_ID));
			irigasiTransaction.setMasterIrigasiId(getLong(JSP_FIELD_MASTER_IRIGASI_ID));
			irigasiTransaction.setPeriodId(getLong(JSP_FIELD_PERIOD_ID));
			irigasiTransaction.setBulanIni(getDouble(JSP_FIELD_BULAN_INI));
			irigasiTransaction.setBulanLalu(getDouble(JSP_FIELD_BULAN_LALU));
			irigasiTransaction.setHarga(getDouble(JSP_FIELD_HARGA));
            irigasiTransaction.setPostStatus(getInt(JSP_FIELD_POSTED_STATUS));
            irigasiTransaction.setKeterangan(getString(JSP_FIELD_KETERANGAN));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
