
package com.project.simprop.property;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspSewaTanahBenefitDetailProp extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp;

	public static final String JSP_NAME_SEWATANAHBENEFITDETAILPROP		=  "JSP_NAME_SEWATANAHBENEFITDETAILPROP" ;

	public static final int JSP_SEWA_TANAH_BENEFIT_DETAIL_ID=  0 ;
	public static final int JSP_SEWA_TANAH_BENEFIT_ID	=  1 ;
	public static final int JSP_SEWA_TANAH_KOMPER_ID	=  2 ;
	public static final int JSP_CURRENCY_ID			=  3 ;
	public static final int JSP_JUMLAH			=  4 ;
	public static final int JSP_KETERANGAN			=  5 ;

	public static String[] colNames = {
		"JSP_SEWA_TANAH_BENEFIT_DETAIL_ID",  "JSP_SEWA_TANAH_BENEFIT_ID",
		"JSP_SEWA_TANAH_KOMPER_ID",  "JSP_CURRENCY_ID",
		"JSP_JUMLAH",  "JSP_KETERANGAN"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_STRING
	} ;

	public JspSewaTanahBenefitDetailProp(){
	}
	public JspSewaTanahBenefitDetailProp(SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp){
		this.sewaTanahBenefitDetailProp = sewaTanahBenefitDetailProp;
	}

	public JspSewaTanahBenefitDetailProp(HttpServletRequest request, SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp){
		super(new JspSewaTanahBenefitDetailProp(sewaTanahBenefitDetailProp), request);
		this.sewaTanahBenefitDetailProp = sewaTanahBenefitDetailProp;
	}

	public String getFormName() { return JSP_NAME_SEWATANAHBENEFITDETAILPROP; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SewaTanahBenefitDetailProp getEntityObject(){ return sewaTanahBenefitDetailProp; }

	public void requestEntityObject(SewaTanahBenefitDetailProp sewaTanahBenefitDetailProp) {
		try{
			this.requestParam();
			sewaTanahBenefitDetailProp.setSewaTanahBenefitId(getLong(JSP_SEWA_TANAH_BENEFIT_ID));
			sewaTanahBenefitDetailProp.setSewaTanahKomperId(getLong(JSP_SEWA_TANAH_KOMPER_ID));
			sewaTanahBenefitDetailProp.setCurrencyId(getLong(JSP_CURRENCY_ID));
			sewaTanahBenefitDetailProp.setJumlah(getDouble(JSP_JUMLAH));
			sewaTanahBenefitDetailProp.setKeterangan(getString(JSP_KETERANGAN));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
