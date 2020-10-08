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

public class JspSewaTanahKomin extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SewaTanahKomin sewaTanahKomin;

	public static final String JSP_NAME_SEWATANAHKOMIN		=  "JSP_NAME_SEWATANAHKOMIN" ;

	public static final int JSP_SEWA_TANAH_KOMIN_ID			=  0 ;
	public static final int JSP_NAMA			=  1 ;
	public static final int JSP_TYPE			=  2 ;
	public static final int JSP_MULAI			=  3 ;
	public static final int JSP_SELESAI			=  4 ;
	public static final int JSP_RATE			=  5 ;
	public static final int JSP_UNIT_KONTRAK_ID		=  6 ;
	public static final int JSP_KETERANGAN			=  7 ;
	public static final int JSP_SEWA_TANAH_ID		=  8 ;
        public static final int JSP_DASAR_PERHITUNGAN = 9;

	public static String[] colNames = {
		"JSP_SEWA_TANAH_KOMIN_ID",  
                "JSP_NAMA",
		"JSP_TYPE",  
                "JSP_MULAI",
		"JSP_SELESAI",  
                "JSP_RATE",
		"JSP_UNIT_KONTRAK_ID",  
                "JSP_KETERANGAN",
		"JSP_SEWA_TANAH_ID",
                "JSP_DASAR_PERHITUNGAN"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  
                TYPE_STRING + ENTRY_REQUIRED,
		TYPE_INT,  
                TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,  
                TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  
                TYPE_STRING,
		TYPE_LONG + ENTRY_REQUIRED,
                TYPE_INT + ENTRY_REQUIRED
	} ;

	public JspSewaTanahKomin(){
	}
        
	public JspSewaTanahKomin(SewaTanahKomin sewaTanahKomin){
		this.sewaTanahKomin = sewaTanahKomin;
	}

	public JspSewaTanahKomin(HttpServletRequest request, SewaTanahKomin sewaTanahKomin){
		super(new JspSewaTanahKomin(sewaTanahKomin), request);
		this.sewaTanahKomin = sewaTanahKomin;
	}

	public String getFormName() { return JSP_NAME_SEWATANAHKOMIN; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SewaTanahKomin getEntityObject(){ return sewaTanahKomin; }

	public void requestEntityObject(SewaTanahKomin sewaTanahKomin) {
		try{
			this.requestParam();
			sewaTanahKomin.setNama(getString(JSP_NAMA));
			sewaTanahKomin.setType(getInt(JSP_TYPE));
			sewaTanahKomin.setMulai(JSPFormater.formatDate(getString(JSP_MULAI),"dd/MM/yyyy"));                        
			sewaTanahKomin.setSelesai(JSPFormater.formatDate(getString(JSP_SELESAI),"dd/MM/yyyy"));
			sewaTanahKomin.setRate(getDouble(JSP_RATE));                        
			sewaTanahKomin.setUnitKontrakId(getLong(JSP_UNIT_KONTRAK_ID));
			sewaTanahKomin.setKeterangan(getString(JSP_KETERANGAN));
			sewaTanahKomin.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));                        
                        sewaTanahKomin.setDasarPerhitungan(getInt(JSP_DASAR_PERHITUNGAN));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
