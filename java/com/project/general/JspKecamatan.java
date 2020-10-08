/*
 * JspKecamatan.java
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

public class JspKecamatan extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Kecamatan kabupaten;

	public static final String JSP_NAME_KECAMATAN		=  "JSP_NAME_KECAMATAN" ;

	public static final int JSP_KECAMATAN_ID	        =  0 ;
	//public static final int JSP_KABUPATEN_ID		=  1 ;
	public static final int JSP_KODE			=  1 ;
	public static final int JSP_NAMA			=  2 ;

	public static String[] fieldNames = {
		"JSP_KECAMATAN_ID", 
                //"JSP_KABUPATEN_ID",
		"JSP_KODE",  
                "JSP_NAMA"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  
                //TYPE_LONG + ENTRY_REQUIRED,
		TYPE_STRING, 
                TYPE_STRING + ENTRY_REQUIRED
	} ;

	public JspKecamatan(){
	}
	public JspKecamatan(Kecamatan kabupaten){
		this.kabupaten = kabupaten;
	}

	public JspKecamatan(HttpServletRequest request, Kecamatan kabupaten){
		super(new JspKecamatan(kabupaten), request);
		this.kabupaten = kabupaten;
	}

	public String getFormName() { return JSP_NAME_KECAMATAN; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public Kecamatan getEntityObject(){ return kabupaten; }

	public void requestEntityObject(Kecamatan kabupaten) {
		try{
			this.requestParam();
			//kabupaten.setKabupatenId(getLong(JSP_KABUPATEN_ID));
			kabupaten.setKode(getString(JSP_KODE));
			kabupaten.setNama(getString(JSP_NAMA));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
