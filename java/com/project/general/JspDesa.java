/*
 * JspDesa.java
 *
 * Created on September 17, 2008, 12:25 PM
 */

package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspDesa extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Desa desa;

	public static final String JSP_NAME_DESA		=  "JSP_NAME_DESA" ;

	public static final int JSP_DESA_ID	        =  0 ;
	public static final int JSP_KECAMATAN_ID		=  1 ;
	public static final int JSP_KODE			=  2 ;
	public static final int JSP_NAMA			=  3 ;

	public static String[] fieldNames = {
		"JSP_DESA_ID", 
                "JSP_KECAMATAN_ID",
		"JSP_KODE",  
                "JSP_NAMA"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  
                TYPE_LONG + ENTRY_REQUIRED,
		TYPE_STRING, 
                TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspDesa(){
	}
	public JspDesa(Desa desa){
		this.desa = desa;
	}

	public JspDesa(HttpServletRequest request, Desa desa){
		super(new JspDesa(desa), request);
		this.desa = desa;
	}

	public String getFormName() { return JSP_NAME_DESA; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public Desa getEntityObject(){ return desa; }

	public void requestEntityObject(Desa desa) {
		try{
			this.requestParam();
			desa.setKecamatanId(getLong(JSP_KECAMATAN_ID));
			desa.setKode(getString(JSP_KODE));
			desa.setNama(getString(JSP_NAMA));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
