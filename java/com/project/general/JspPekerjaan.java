/*
 * JspPekerjaan.java
 *
 * Created on September 17, 2008, 12:16 PM
 */

package com.project.general;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspPekerjaan extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Pekerjaan pekerjaan;

	public static final String JSP_NAME_PEKERJAAN		=  "JSP_NAME_PEKERJAAN" ;

	public static final int JSP_PEKERJAAN_ID	        =  0 ;
	public static final int JSP_KODE			=  1 ;
	public static final int JSP_NAMA			=  2 ;
       

	public static String[] fieldNames = {
		"JSP_PEKERJAAN_ID",
		"JSP_KODE",  
                "JSP_NAMA"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_STRING, 
                TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspPekerjaan(){
	}
	public JspPekerjaan(Pekerjaan pekerjaan){
		this.pekerjaan = pekerjaan;
	}

	public JspPekerjaan(HttpServletRequest request, Pekerjaan pekerjaan){
		super(new JspPekerjaan(pekerjaan), request);
		this.pekerjaan = pekerjaan;
	}

	public String getFormName() { return JSP_NAME_PEKERJAAN; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public Pekerjaan getEntityObject(){ return pekerjaan; }

	public void requestEntityObject(Pekerjaan pekerjaan) {
		try{
			this.requestParam();
			pekerjaan.setKode(getString(JSP_KODE));
			pekerjaan.setNama(getString(JSP_NAMA));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
