
package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspPinjamanDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private PinjamanDetail pinjamanDetail;

	public static final String JSP_NAME_PINJAMANDETAIL		=  "JSP_NAME_PINJAMANDETAIL" ;

	public static final int JSP_MEMBER_ID			=  0 ;
	public static final int JSP_PINJAMAN_ID			=  1 ;
	public static final int JSP_PINJAMAN_DETAIL_ID			=  2 ;
	public static final int JSP_AMOUNT			=  3 ;
	public static final int JSP_BUNGA			=  4 ;
	public static final int JSP_CICILAN_KE			=  5 ;
	public static final int JSP_JATUH_TEMPO			=  6 ;
	public static final int JSP_STATUS			=  7 ;

	public static String[] colNames = {
		"JSP_MEMBER_ID",  "JSP_PINJAMAN_ID",
		"JSP_PINJAMAN_DETAIL_ID",  "JSP_AMOUNT",
		"JSP_BUNGA",  "JSP_CICILAN_KE",
		"JSP_JATUH_TEMPO",  "JSP_STATUS"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_INT + ENTRY_REQUIRED,
		TYPE_DATE,  TYPE_INT
	} ;

	public JspPinjamanDetail(){
	}
	public JspPinjamanDetail(PinjamanDetail pinjamanDetail){
		this.pinjamanDetail = pinjamanDetail;
	}

	public JspPinjamanDetail(HttpServletRequest request, PinjamanDetail pinjamanDetail){
		super(new JspPinjamanDetail(pinjamanDetail), request);
		this.pinjamanDetail = pinjamanDetail;
	}

	public String getFormName() { return JSP_NAME_PINJAMANDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public PinjamanDetail getEntityObject(){ return pinjamanDetail; }

	public void requestEntityObject(PinjamanDetail pinjamanDetail) {
		try{
			this.requestParam();
			pinjamanDetail.setMemberId(getLong(JSP_MEMBER_ID));
			pinjamanDetail.setPinjamanId(getLong(JSP_PINJAMAN_ID));
			pinjamanDetail.setAmount(getDouble(JSP_AMOUNT));
			pinjamanDetail.setBunga(getDouble(JSP_BUNGA));
			pinjamanDetail.setCicilanKe(getInt(JSP_CICILAN_KE));
			pinjamanDetail.setJatuhTempo(getDate(JSP_JATUH_TEMPO));
			pinjamanDetail.setStatus(getInt(JSP_STATUS));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
