package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;
import com.project.coorp.pinjaman.*;

public class JspTabunganSukarela extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private TabunganSukarela tabunganSukarela;

	public static final String JSP_NAME_TABUNGANSUKARELA		=  "JSP_NAME_TABUNGANSUKARELA" ;

	public static final int JSP_TABUNGAN_SUKARELA_ID			=  0 ;
	public static final int JSP_TANGGAL			=  1 ;
	public static final int JSP_JUMLAH			=  2 ;
	public static final int JSP_PENGALI			=  3 ;
	public static final int JSP_TYPE			=  4 ;
	public static final int JSP_NOTE			=  5 ;
	public static final int JSP_USER_ID			=  6 ;
	public static final int JSP_TRANS_DATE			=  7 ;
	public static final int JSP_PERIOD_ID			=  8 ;
	public static final int JSP_POST_STATUS			=  9 ;
	public static final int JSP_SALDO			=  10 ;
        public static final int JSP_MEMBER_ID			=  11 ;
        public static final int JSP_CASH_BANK_COA_ID			=  12 ;

	public static String[] colNames = {
		"JSP_TABUNGAN_SUKARELA_ID",  "JSP_TANGGAL",
		"JSP_JUMLAH",  "JSP_PENGALI",
		"JSP_TYPE",  "JSP_NOTE",
		"JSP_USER_ID",  "JSP_TRANS_DATE",
		"JSP_PERIOD_ID",  "JSP_POST_STATUS",
		"JSP_SALDO", "JSP_MEMBER_ID",
                "JSP_CASH_BANK_COA_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_DATE,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_INT,
		TYPE_INT,  TYPE_STRING,
		TYPE_LONG,  TYPE_DATE + ENTRY_REQUIRED,
		TYPE_LONG,  TYPE_INT,
		TYPE_FLOAT, TYPE_LONG + ENTRY_REQUIRED,
                TYPE_FLOAT
	} ;
        
        

	public JspTabunganSukarela(){
	}
	public JspTabunganSukarela(TabunganSukarela tabunganSukarela){
		this.tabunganSukarela = tabunganSukarela;
	}

	public JspTabunganSukarela(HttpServletRequest request, TabunganSukarela tabunganSukarela){
		super(new JspTabunganSukarela(tabunganSukarela), request);
		this.tabunganSukarela = tabunganSukarela;
	}

	public String getFormName() { return JSP_NAME_TABUNGANSUKARELA; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public TabunganSukarela getEntityObject(){ return tabunganSukarela; }

	public void requestEntityObject(TabunganSukarela tabunganSukarela) {
		try{
			this.requestParam();
			//tabunganSukarela.setTanggal(new Date());//getDate(JSP_TANGGAL));
			tabunganSukarela.setJumlah(getDouble(JSP_JUMLAH));
			tabunganSukarela.setPengali(getInt(JSP_PENGALI));
			tabunganSukarela.setType(getInt(JSP_TYPE));
			tabunganSukarela.setNote(getString(JSP_NOTE));
			tabunganSukarela.setUserId(getLong(JSP_USER_ID));
			tabunganSukarela.setTransDate(getDate(JSP_TRANS_DATE));
			//tabunganSukarela.setPeriodId(getLong(JSP_PERIOD_ID));
			tabunganSukarela.setPostStatus(getInt(JSP_POST_STATUS));
                        tabunganSukarela.setCashBankCoaId(getLong(JSP_CASH_BANK_COA_ID));
			//tabunganSukarela.setSaldo(getDouble(JSP_SALDO));
                        tabunganSukarela.setMemberId(getLong(JSP_MEMBER_ID));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
