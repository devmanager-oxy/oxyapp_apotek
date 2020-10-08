/* 
 * @author  	:  Eka Ds
 * @version  	:  1.0
 */

package com.project.crm.sewa;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.util.JSPFormater;

public class JspSewaTanahBp extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SewaTanahBp sewaTanahBp;

	public static final String JSP_NAME_SEWATANAHBP		=  "JSP_NAME_SEWATANAHBP" ;

	public static final int JSP_TANGGAL			=  0 ;
	public static final int JSP_KETERANGAN			=  1 ;
	public static final int JSP_REFNUMBER			=  2 ;
	public static final int JSP_MEM                         =  3 ;
	public static final int JSP_DEBET			=  4 ;
	public static final int JSP_CREDIT			=  5 ;
	public static final int JSP_SEWA_TANAH_ID		=  6 ;
	public static final int JSP_SEWA_TANAH_INV_ID           =  7 ;
        public static final int JSP_MATA_UANG_ID                =  8 ;
        public static final int JSP_CUSTOMER_ID                 =  9 ;
        public static final int JSP_LIMBAH_TRANSACTION_ID       =  10 ;
        public static final int JSP_IRIGASI_TRANSACTION_ID      =  11 ;

	public static String[] colNames = {
		"JSP_TANGGAL",
		"JSP_KETERANGAN",  
		"JSP_REFNUMBER",
		"JSP_MEM",
		"JSP_DEBET",
		"JSP_CREDIT",  
		"JSP_SEWA_TANAH_ID",
		"JSP_SEWA_TANAH_INV_ID",
                "JSP_MATA_UANG_ID",
                "JSP_CUSTOMER_ID",
                "JSP_LIMBAH_TRANSACTION_ID",
                "JSP_CUSTOMER_ID",
	} ;

	public static int[] fieldTypes = {
		TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  
		TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_LONG,
		TYPE_LONG,   TYPE_LONG,
                TYPE_LONG,   TYPE_LONG,
                TYPE_LONG
	} ;

	public JspSewaTanahBp(){
	}
	public JspSewaTanahBp(SewaTanahBp sewaTanahBp){
		this.sewaTanahBp = sewaTanahBp;
	}

	public JspSewaTanahBp(HttpServletRequest request, SewaTanahBp sewaTanahBp){
		super(new JspSewaTanahBp(sewaTanahBp), request);
		this.sewaTanahBp = sewaTanahBp;
	}

	public String getFormName() { return JSP_NAME_SEWATANAHBP; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SewaTanahBp getEntityObject(){ return sewaTanahBp; }

	public void requestEntityObject(SewaTanahBp sewaTanahBp) { 
		try{
			this.requestParam();
			sewaTanahBp.setTanggal(JSPFormater.formatDate(getString(JSP_TANGGAL), "dd/MM/yyyy"));
			sewaTanahBp.setKeterangan(getString(JSP_KETERANGAN));
			sewaTanahBp.setRefnumber(getString(JSP_REFNUMBER));
			sewaTanahBp.setMem(getString(JSP_MEM));
			sewaTanahBp.setDebet(getDouble(JSP_DEBET));
			sewaTanahBp.setCredit(getDouble(JSP_CREDIT));
			sewaTanahBp.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
			sewaTanahBp.setSewaTanahInvId(getLong(JSP_SEWA_TANAH_INV_ID));
                        sewaTanahBp.setMataUangId(getLong(JSP_MATA_UANG_ID));
                        sewaTanahBp.setCustomerId(getLong(JSP_CUSTOMER_ID));                        
                        sewaTanahBp.setLimbahTransactionId(getLong(JSP_LIMBAH_TRANSACTION_ID));
                        sewaTanahBp.setIrigasiTransactionId(getLong(JSP_IRIGASI_TRANSACTION_ID));                        
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
