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

public class JspSewaTanahKomper extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SewaTanahKomper sewaTanahKomper;

	public static final String JSP_NAME_SEWATANAHKOMPER		=  "JSP_NAME_SEWATANAHKOMPER" ;

	public static final int JSP_KATEGORI			=  0 ;
	public static final int JSP_PERSENTASE			=  1 ;
	public static final int JSP_SEWA_TANAH_ID		=  2 ;

	public static String[] colNames = {  
		"JSP_KATEGORI",
		"JSP_PERSENTASE",
		"JSP_SEWA_TANAH_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_INT,
		TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_LONG
	} ;

	public JspSewaTanahKomper(){
	}
	public JspSewaTanahKomper(SewaTanahKomper sewaTanahKomper){
		this.sewaTanahKomper = sewaTanahKomper;
	}

	public JspSewaTanahKomper(HttpServletRequest request, SewaTanahKomper sewaTanahKomper){
		super(new JspSewaTanahKomper(sewaTanahKomper), request);
		this.sewaTanahKomper = sewaTanahKomper;
	}

	public String getFormName() { return JSP_NAME_SEWATANAHKOMPER; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SewaTanahKomper getEntityObject(){ return sewaTanahKomper; }

	public void requestEntityObject(SewaTanahKomper sewaTanahKomper) {
		try{
			this.requestParam();
			sewaTanahKomper.setKategori(getInt(JSP_KATEGORI));
			sewaTanahKomper.setPersentase(getDouble(JSP_PERSENTASE));
			sewaTanahKomper.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
