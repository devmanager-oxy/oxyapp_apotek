
package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;
import com.project.coorp.pinjaman.*;

public class JspTabunganSetup extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private TabunganSetup tabunganSetup;

	public static final String JSP_NAME_TABUNGANSETUP		=  "JSP_NAME_TABUNGANSETUP" ;

	public static final int JSP_TABUNGAN_SETUP_ID			=  0 ;
	public static final int JSP_BUNGA_PERCENT			=  1 ;
	public static final int JSP_BUNGA_TYPE			=  2 ;
	public static final int JSP_BUNGA_ACTIVATE			=  3 ;
	public static final int JSP_ADMIN_AMOUNT			=  4 ;
	public static final int JSP_ADMIN_TYPE			=  5 ;
	public static final int JSP_ADMIN_ACTIVATE			=  6 ;
	public static final int JSP_SERVICE_START_HOUR			=  7 ;
	public static final int JSP_SERVICE_START_MINUTE			=  8 ;
	public static final int JSP_PAJAK_PERCENT			=  9 ;
	public static final int JSP_PAJAK_TYPE			=  10 ;
	public static final int JSP_PAJAK_ACTIVATE			=  11 ;
	public static final int JSP_HUTANG_COA_ID			=  12 ;
	public static final int JSP_PAJAK_COA_ID			=  13 ;
	public static final int JSP_ADMIN_COA_ID			=  14 ;
	public static final int JSP_BUNGA_COA_ID			=  15 ;

	public static String[] colNames = {
		"JSP_TABUNGAN_SETUP_ID",  "JSP_BUNGA_PERCENT",
		"JSP_BUNGA_TYPE",  "JSP_BUNGA_ACTIVATE",
		"JSP_ADMIN_AMOUNT",  "JSP_ADMIN_TYPE",
		"JSP_ADMIN_ACTIVATE",  "JSP_SERVICE_START_HOUR",
		"JSP_SERVICE_START_MINUTE",  "JSP_PAJAK_PERCENT",
		"JSP_PAJAK_TYPE",  "JSP_PAJAK_ACTIVATE",
		"JSP_HUTANG_COA_ID",  "JSP_PAJAK_COA_ID",
		"JSP_ADMIN_COA_ID",  "JSP_BUNGA_COA_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_INT,  TYPE_INT,
		TYPE_FLOAT,  TYPE_INT,
		TYPE_INT,  TYPE_INT,
		TYPE_INT,  TYPE_FLOAT,
		TYPE_INT,  TYPE_INT,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_LONG + ENTRY_REQUIRED,  TYPE_LONG + ENTRY_REQUIRED
	} ;

	public JspTabunganSetup(){
	}
	public JspTabunganSetup(TabunganSetup tabunganSetup){
		this.tabunganSetup = tabunganSetup;
	}

	public JspTabunganSetup(HttpServletRequest request, TabunganSetup tabunganSetup){
		super(new JspTabunganSetup(tabunganSetup), request);
		this.tabunganSetup = tabunganSetup;
	}

	public String getFormName() { return JSP_NAME_TABUNGANSETUP; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public TabunganSetup getEntityObject(){ return tabunganSetup; }

	public void requestEntityObject(TabunganSetup tabunganSetup) {
		try{
			this.requestParam();
			tabunganSetup.setBungaPercent(getDouble(JSP_BUNGA_PERCENT));
			tabunganSetup.setBungaType(getInt(JSP_BUNGA_TYPE));
			tabunganSetup.setBungaActivate(getInt(JSP_BUNGA_ACTIVATE));
			tabunganSetup.setAdminAmount(getDouble(JSP_ADMIN_AMOUNT));
			tabunganSetup.setAdminType(getInt(JSP_ADMIN_TYPE));
			tabunganSetup.setAdminActivate(getInt(JSP_ADMIN_ACTIVATE));
			tabunganSetup.setServiceStartHour(getInt(JSP_SERVICE_START_HOUR));
			tabunganSetup.setServiceStartMinute(getInt(JSP_SERVICE_START_MINUTE));
			tabunganSetup.setPajakPercent(getDouble(JSP_PAJAK_PERCENT));
			tabunganSetup.setPajakType(getInt(JSP_PAJAK_TYPE));
			tabunganSetup.setPajakActivate(getInt(JSP_PAJAK_ACTIVATE));
			tabunganSetup.setHutangCoaId(getLong(JSP_HUTANG_COA_ID));
			tabunganSetup.setPajakCoaId(getLong(JSP_PAJAK_COA_ID));
			tabunganSetup.setAdminCoaId(getLong(JSP_ADMIN_COA_ID));
			tabunganSetup.setBungaCoaId(getLong(JSP_BUNGA_COA_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
