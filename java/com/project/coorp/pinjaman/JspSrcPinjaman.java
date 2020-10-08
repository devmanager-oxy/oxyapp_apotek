

package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;
import com.project.coorp.pinjaman.*;

public class JspSrcPinjaman extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SrcPinjaman srcPinjaman;

	public static final String JSP_NAME_PINJAMAN		=  "JSP_NAME_PINJAMAN" ;

	public static final int JSP_AMOUNT_TO			=  0 ;
	public static final int JSP_BANK_ID			=  1 ;
	public static final int JSP_END_DATE			=  2 ;
	public static final int JSP_IGNORE_AMOUNT			=  3 ;
	public static final int JSP_IGNORE_DATE			=  4 ;
	public static final int JSP_JENIS_PINJAMAN			=  5 ;
	public static final int JSP_NAMA_ANGGOTA			=  6 ;
	public static final int JSP_NO_ANGGOTA			=  7 ;
	public static final int JSP_NO_REKENING			=  8 ;
	public static final int JSP_START_AMOUNT			=  9 ;
	public static final int JSP_START_DATE			=  10 ;
	public static final int JSP_STATUS			=  11 ;
        public static final int JSP_TYPE			=  12 ;
	

	public static String[] colNames = {
		"JSP_AMOUNT_TO",  "JSP_BANK_ID",
		"JSP_END_DATE",  "JSP_IGNORE_AMOUNT",
		"JSP_IGNORE_DATE",  "JSP_JENIS_PINJAMAN",
                "JSP_NAMA_ANGGOTA", "JSP_NO_ANGGOTA",  
                "JSP_NO_REKENING", "JSP_START_AMOUNT",  
                "JSP_START_DATE", "JSP_STATUS",
                "JSP_TYPE"
	} ;

	public static int[] fieldTypes = {
		TYPE_FLOAT,  TYPE_LONG,
		TYPE_STRING,  TYPE_INT,
		TYPE_INT, TYPE_INT,
                TYPE_STRING, TYPE_STRING,  
                TYPE_STRING, TYPE_FLOAT,  
                TYPE_STRING, TYPE_INT,
                TYPE_INT
	} ;

	public JspSrcPinjaman(){
	}
	public JspSrcPinjaman(SrcPinjaman srcPinjaman){
		this.srcPinjaman = srcPinjaman;
	}

	public JspSrcPinjaman(HttpServletRequest request, SrcPinjaman srcPinjaman){
		super(new JspSrcPinjaman(srcPinjaman), request);
		this.srcPinjaman = srcPinjaman;
	}

	public String getFormName() { return JSP_NAME_PINJAMAN; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SrcPinjaman getEntityObject(){ return srcPinjaman; }

	public void requestEntityObject(SrcPinjaman srcPinjaman) {
		try{
			this.requestParam();
			srcPinjaman.setAmountTo(getDouble(JSP_AMOUNT_TO));
			srcPinjaman.setBankId(getLong(JSP_BANK_ID));
			srcPinjaman.setEndDate(JSPFormater.formatDate(getString(JSP_END_DATE),"dd/MM/yyyy"));
			srcPinjaman.setIgnoreAmount(getInt(JSP_IGNORE_AMOUNT));
			srcPinjaman.setIgnoreDate(getInt(JSP_IGNORE_DATE));
			srcPinjaman.setJenisPinjaman(getInt(JSP_JENIS_PINJAMAN));
			srcPinjaman.setNamaAnggota(getString(JSP_NAMA_ANGGOTA));
			srcPinjaman.setNoAnggota(getString(JSP_NO_ANGGOTA));
			srcPinjaman.setNoRekening(getString(JSP_NO_REKENING));
			srcPinjaman.setStartAmount(getDouble(JSP_START_AMOUNT));
			srcPinjaman.setStartDate(JSPFormater.formatDate(getString(JSP_START_DATE),"dd/MM/yyyy"));
			srcPinjaman.setStatus(getInt(JSP_STATUS));
                        srcPinjaman.setType(getInt(JSP_TYPE));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
        
        
        
        
}
