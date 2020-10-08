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

public class JspSewaTanahBenefitDetail extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SewaTanahBenefitDetail sewaTanahBenefitDetail;

	public static final String JSP_NAME_SEWATANAHBENEFITDETAIL		=  "JSP_NAME_SEWATANAHBENEFITDETAIL" ;

	public static final int JSP_SEWA_TANAH_BENEFIT_DETAIL_ID			=  0 ;
	public static final int JSP_SEWA_TANAH_BENEFIT_ID			=  1 ;
	public static final int JSP_SEWA_TANAH_KOMPER_ID			=  2 ;
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

	public JspSewaTanahBenefitDetail(){
	}
	public JspSewaTanahBenefitDetail(SewaTanahBenefitDetail sewaTanahBenefitDetail){
		this.sewaTanahBenefitDetail = sewaTanahBenefitDetail;
	}

	public JspSewaTanahBenefitDetail(HttpServletRequest request, SewaTanahBenefitDetail sewaTanahBenefitDetail){
		super(new JspSewaTanahBenefitDetail(sewaTanahBenefitDetail), request);
		this.sewaTanahBenefitDetail = sewaTanahBenefitDetail;
	}

	public String getFormName() { return JSP_NAME_SEWATANAHBENEFITDETAIL; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SewaTanahBenefitDetail getEntityObject(){ return sewaTanahBenefitDetail; }

	public void requestEntityObject(SewaTanahBenefitDetail sewaTanahBenefitDetail) {
		try{
			this.requestParam();
			sewaTanahBenefitDetail.setSewaTanahBenefitId(getLong(JSP_SEWA_TANAH_BENEFIT_ID));
			sewaTanahBenefitDetail.setSewaTanahKomperId(getLong(JSP_SEWA_TANAH_KOMPER_ID));
			sewaTanahBenefitDetail.setCurrencyId(getLong(JSP_CURRENCY_ID));
			sewaTanahBenefitDetail.setJumlah(getDouble(JSP_JUMLAH));
			sewaTanahBenefitDetail.setKeterangan(getString(JSP_KETERANGAN));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
