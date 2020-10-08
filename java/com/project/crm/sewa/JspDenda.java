/* 
 * @author  	:  Eka Ds
 * @version  	:  1.0
 */

package com.project.crm.sewa;

import com.project.util.JSPFormater;
import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspDenda extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Denda crmDenda;

	public static final String JSP_NAME_DENDA		=  "JSP_NAME_DENDA" ;

	public static final int JSP_DENDA_ID			=  0 ;
	public static final int JSP_SEWA_TANAH_ID			=  1 ;
	public static final int JSP_LIMBAH_TRANSAKSI_ID			=  2 ;
	public static final int JSP_IRIGASI_TRANSAKSI_ID			=  3 ;
	public static final int JSP_TANGGAL			=  4 ;
	public static final int JSP_ASSESMENT_ID			=  5 ;
	public static final int JSP_CURRENCY_ID			=  6 ;
	public static final int JSP_JUMLAH			=  7 ;
	public static final int JSP_STATUS			=  8 ;
	public static final int JSP_CREATED_BY_ID			=  9 ;
	public static final int JSP_CREATED_DATE			=  10 ;
	public static final int JSP_POSTED_BY_ID			=  11 ;
	public static final int JSP_POSTED_DATE			=  12 ;
	public static final int JSP_COUNTER			=  13 ;
	public static final int JSP_PREFIX_NUMBER			=  14 ;
	public static final int JSP_NUMBER			=  15 ;
	public static final int JSP_KETERANGAN			=  16 ;
	public static final int JSP_NO_FP			=  17 ;
	public static final int JSP_SEWA_TANAH_INVOICE_ID			=  18 ;

	public static String[] colNames = {
		"JSP_DENDA_ID",  "JSP_SEWA_TANAH_ID",
		"JSP_LIMBAH_TRANSAKSI_ID",  "JSP_IRIGASI_TRANSAKSI_ID",
		"JSP_TANGGAL",  "JSP_ASSESMENT_ID",
		"JSP_CURRENCY_ID",  "JSP_JUMLAH",
		"JSP_STATUS",  "JSP_CREATED_BY_ID",
		"JSP_CREATED_DATE",  "JSP_POSTED_BY_ID",
		"JSP_POSTED_DATE",  "JSP_COUNTER",
		"JSP_PREFIX_NUMBER",  "JSP_NUMBER",
		"JSP_KETERANGAN",  "JSP_NO_FP",
		"JSP_SEWA_TANAH_INVOICE_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_DATE,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT,
		TYPE_STRING,  TYPE_LONG,
		TYPE_DATE,  TYPE_LONG,
		TYPE_DATE,  TYPE_INT,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_LONG
	} ;

	public JspDenda(){
	}
	public JspDenda(Denda crmDenda){
		this.crmDenda = crmDenda;
	}

	public JspDenda(HttpServletRequest request, Denda crmDenda){
		super(new JspDenda(crmDenda), request);
		this.crmDenda = crmDenda;
	}

	public String getFormName() { return JSP_NAME_DENDA; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Denda getEntityObject(){ return crmDenda; }

	public void requestEntityObject(Denda crmDenda) {
		try{
			this.requestParam();
			crmDenda.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
			crmDenda.setLimbahTransaksiId(getLong(JSP_LIMBAH_TRANSAKSI_ID));
			crmDenda.setIrigasiTransaksiId(getLong(JSP_IRIGASI_TRANSAKSI_ID));
			crmDenda.setTanggal(getDate(JSP_TANGGAL));
			crmDenda.setAssesmentId(getLong(JSP_ASSESMENT_ID));
			crmDenda.setCurrencyId(getLong(JSP_CURRENCY_ID));
			crmDenda.setJumlah(getDouble(JSP_JUMLAH));
			crmDenda.setStatus(getString(JSP_STATUS));
			crmDenda.setCreatedById(getLong(JSP_CREATED_BY_ID));
			crmDenda.setCreatedDate(getDate(JSP_CREATED_DATE));
			crmDenda.setPostedById(getLong(JSP_POSTED_BY_ID));
			crmDenda.setPostedDate(getDate(JSP_POSTED_DATE));
			crmDenda.setCounter(getInt(JSP_COUNTER));
			crmDenda.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
			crmDenda.setNumber(getString(JSP_NUMBER));
			crmDenda.setKeterangan(getString(JSP_KETERANGAN));
			crmDenda.setNoFp(getString(JSP_NO_FP));
			crmDenda.setSewaTanahInvoiceId(getLong(JSP_SEWA_TANAH_INVOICE_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
