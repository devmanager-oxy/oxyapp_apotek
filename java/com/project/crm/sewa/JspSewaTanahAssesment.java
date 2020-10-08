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

public class JspSewaTanahAssesment extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SewaTanahAssesment sewaTanahAssesment;

	public static final String JSP_NAME_SEWATANAHASSESMENT		=  "JSP_NAME_SEWATANAHASSESMENT" ;

	public static final int JSP_MULAI			=  0 ;
	public static final int JSP_SELESAI			=  1 ;
	public static final int JSP_RATE			=  2 ;
	public static final int JSP_UNIT_KONTRAK_ID			=  3 ;
	public static final int JSP_DASAR_PERHITUNGAN			=  4 ;
	public static final int JSP_SEWA_TANAH_ID			=  5 ;
	public static final int JSP_CURRENCY_ID			=  6 ;

	public static String[] colNames = {
		"JSP_MULAI","JSP_SELESAI",  "JSP_RATE",
		"JSP_UNIT_KONTRAK_ID",  "JSP_DASAR_PERHITUNGAN",
		"JSP_SEWA_TANAH_ID", "JSP_CURR_ID",
		
	} ;

	public static int[] fieldTypes = {
		TYPE_STRING, TYPE_STRING,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_INT,
		TYPE_LONG, TYPE_LONG + ENTRY_REQUIRED
	} ;
	
	public JspSewaTanahAssesment(){
	}
	public JspSewaTanahAssesment(SewaTanahAssesment sewaTanahAssesment){
		this.sewaTanahAssesment = sewaTanahAssesment;
	}

	public JspSewaTanahAssesment(HttpServletRequest request, SewaTanahAssesment sewaTanahAssesment){
		super(new JspSewaTanahAssesment(sewaTanahAssesment), request);
		this.sewaTanahAssesment = sewaTanahAssesment;
	}

	public String getFormName() { return JSP_NAME_SEWATANAHASSESMENT; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SewaTanahAssesment getEntityObject(){ return sewaTanahAssesment; }

	public void requestEntityObject(SewaTanahAssesment sewaTanahAssesment) {
		try{
			this.requestParam();			    
			
			sewaTanahAssesment.setMulai(JSPFormater.formatDate(getString(JSP_MULAI), "dd/MM/yyyy"));
			sewaTanahAssesment.setSelesai(JSPFormater.formatDate(getString(JSP_SELESAI), "dd/MM/yyyy"));			
			sewaTanahAssesment.setRate(getDouble(JSP_RATE));
			sewaTanahAssesment.setUnitKontrakId(getLong(JSP_UNIT_KONTRAK_ID));
			sewaTanahAssesment.setDasarPerhitungan(getInt(JSP_DASAR_PERHITUNGAN));
			sewaTanahAssesment.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
			sewaTanahAssesment.setCurrencyId(getLong(JSP_CURRENCY_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
