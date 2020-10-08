
package com.project.simprop.property;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspDendaProp extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private DendaProp dendaProp;

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

	public JspDendaProp(){
	}
	public JspDendaProp(DendaProp dendaProp){
		this.dendaProp = dendaProp;
	}

	public JspDendaProp(HttpServletRequest request, DendaProp dendaProp){
		super(new JspDendaProp(dendaProp), request);
		this.dendaProp = dendaProp;
	}

	public String getFormName() { return JSP_NAME_DENDA; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public DendaProp getEntityObject(){ return dendaProp; }

	public void requestEntityObject(DendaProp dendaProp) {
		try{
			this.requestParam();
			dendaProp.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
			dendaProp.setLimbahTransaksiId(getLong(JSP_LIMBAH_TRANSAKSI_ID));
			dendaProp.setIrigasiTransaksiId(getLong(JSP_IRIGASI_TRANSAKSI_ID));
			dendaProp.setTanggal(getDate(JSP_TANGGAL));
			dendaProp.setAssesmentId(getLong(JSP_ASSESMENT_ID));
			dendaProp.setCurrencyId(getLong(JSP_CURRENCY_ID));
			dendaProp.setJumlah(getDouble(JSP_JUMLAH));
			dendaProp.setStatus(getString(JSP_STATUS));
			dendaProp.setCreatedById(getLong(JSP_CREATED_BY_ID));
			dendaProp.setCreatedDate(getDate(JSP_CREATED_DATE));
			dendaProp.setPostedById(getLong(JSP_POSTED_BY_ID));
			dendaProp.setPostedDate(getDate(JSP_POSTED_DATE));
			dendaProp.setCounter(getInt(JSP_COUNTER));
			dendaProp.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
			dendaProp.setNumber(getString(JSP_NUMBER));
			dendaProp.setKeterangan(getString(JSP_KETERANGAN));
			dendaProp.setNoFp(getString(JSP_NO_FP));
			dendaProp.setSewaTanahInvoiceId(getLong(JSP_SEWA_TANAH_INVOICE_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
