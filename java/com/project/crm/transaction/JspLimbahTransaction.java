
package com.project.crm.transaction;

import com.project.crm.transaction.LimbahTransaction;
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.fms.master.*;

public class JspLimbahTransaction extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private LimbahTransaction limbahTransaction;

	public static final String JSP_NAME_LIMBAH_TRANSACTION		=  "JSP_NAME_LIMBAH_TRANSACTION" ;

	public static final  int JSP_CUSTOMER_ID = 0;
	public static final  int JSP_MASTER_LIMBAH_ID = 1;
	public static final  int JSP_PERIOD_ID = 2;
	public static final  int JSP_BULAN_INI  = 3;
	public static final  int JSP_BULAN_LALU  = 4;
	public static final  int JSP_PERCENTAGE_USED  = 5;
	public static final  int JSP_HARGA  = 6;
	public static final  int JSP_POSTED_STATUS  = 7;
	public static final  int JSP_KETERANGAN  = 8;
		
	public static String[] colNames = {	
		"JSP_CUSTOMER_ID",
		"JSP_MASTER_LIMBAH_ID",
		"JSP_PERIOD_ID",
		"JSP_BULAN_INI",
		"JSP_BULAN_LALU",
		"JSP_PERCENTAGE_USED",
		"JSP_HARGA",
		"JSP_POSTED_STATUS",
		"JSP_KETERANGAN"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_LONG,
		TYPE_LONG,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_STRING
	};

	public JspLimbahTransaction(){
	}
	public JspLimbahTransaction(LimbahTransaction limbahTransaction){
		this.limbahTransaction = limbahTransaction;
	}

	public JspLimbahTransaction(HttpServletRequest request, LimbahTransaction limbahTransaction){
		super(new JspLimbahTransaction(limbahTransaction), request);
		this.limbahTransaction = limbahTransaction;
	}

	public String getFormName() { return JSP_NAME_LIMBAH_TRANSACTION; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public LimbahTransaction getEntityObject(){ return limbahTransaction; }

	public void requestEntityObject(LimbahTransaction limbahTransaction) {
		try{
			this.requestParam();
			
			limbahTransaction.setCustomerId(getLong(JSP_CUSTOMER_ID));
			limbahTransaction.setMasterLimbahId(getLong(JSP_MASTER_LIMBAH_ID));
			limbahTransaction.setPeriodId(getLong(JSP_PERIOD_ID));
			limbahTransaction.setBulanIni(getFloat(JSP_BULAN_INI));
			limbahTransaction.setBulanLalu(getFloat(JSP_BULAN_LALU));
			limbahTransaction.setPercentageUsed(getFloat(JSP_PERCENTAGE_USED));
			limbahTransaction.setHarga(getFloat(JSP_HARGA));
			limbahTransaction.setPostedStatus(getInt(JSP_POSTED_STATUS));
			limbahTransaction.setKeterangan(getString(JSP_KETERANGAN));
									            
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
