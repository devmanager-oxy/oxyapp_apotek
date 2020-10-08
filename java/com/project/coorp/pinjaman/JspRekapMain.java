package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspRekapMain extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private RekapMain rekapMain;

	public static final String JSP_NAME_REKAPMAIN		=  "JSP_NAME_REKAPMAIN" ;

	public static final int JSP_REKAP_MAIN_ID			=  0 ;
	public static final int JSP_DINAS_ID			=  1 ;
	public static final int JSP_DINAS_UNIT_ID			=  2 ;
	public static final int JSP_PERIODE_REKAP_ID			=  3 ;
	public static final int JSP_STATUS			=  4 ;
	public static final int JSP_DATE			=  5 ;
	public static final int JSP_COUNTER			=  6 ;
	public static final int JSP_PREFIX_NUMBER			=  7 ;
	public static final int JSP_NUMBER			=  8 ;
	public static final int JSP_NOTE			=  9 ;
	public static final int JSP_ANGSURAN_COA_DEBET_ID			=  10 ;
	public static final int JSP_ANGSURAN_COA_CREDIT_ID			=  11 ;
	public static final int JSP_BUNGA_COA_DEBET_ID			=  12 ;
	public static final int JSP_BUNGA_COA_CREDIT_ID			=  13 ;
	public static final int JSP_MINIMARKET_COA_DEBET_ID			=  14 ;
	public static final int JSP_MINIMARKET_COA_CREDIT_ID			=  15 ;
	public static final int JSP_FASJABTEL_COA_DEBET_ID			=  16 ;
	public static final int JSP_FASJABTEL_COA_CREDIT_ID			=  17 ;
	public static final int JSP_TITIPAN_COA_DEBET_ID			=  18 ;
	public static final int JSP_TITIPAN_COA_CREDIT_ID			=  19 ;
	public static final int JSP_SIMPANAN_COA_DEBET_ID			=  20 ;
	public static final int JSP_SIMPANAN_COA_CREDIT_ID			=  21 ;
        public static final int JSP_USER_ID			=  22 ;
        
        public static final int JSP_SIMPANAN_POKOK_COA_ID			=  23 ;
        public static final int JSP_SIMPANAN_SUKARELA_COA_ID			=  24 ;

	public static String[] colNames = {
		"JSP_REKAP_MAIN_ID",  "JSP_DINAS_ID",
		"JSP_DINAS_UNIT_ID",  "JSP_PERIODE_REKAP_ID",
		"JSP_STATUS",  "JSP_DATE",
		"JSP_COUNTER",  "JSP_PREFIX_NUMBER",
		"JSP_NUMBER",  "JSP_NOTE",
		"JSP_ANGSURAN_COA_DEBET_ID",  "JSP_ANGSURAN_COA_CREDIT_ID",
		"JSP_BUNGA_COA_DEBET_ID",  "JSP_BUNGA_COA_CREDIT_ID",
		"JSP_MINIMARKET_COA_DEBET_ID",  "JSP_MINIMARKET_COA_CREDIT_ID",
		"JSP_FASJABTEL_COA_DEBET_ID",  "JSP_FASJABTEL_COA_CREDIT_ID",
		"JSP_TITIPAN_COA_DEBET_ID",  "JSP_TITIPAN_COA_CREDIT_ID",
		"JSP_SIMPANAN_COA_DEBET_ID",  "JSP_SIMPANAN_COA_CREDIT_ID",
                "JSP_USER_ID", "JSP_SIMPANAN_POKOK_COA_ID",
                "JSP_SIMPANAN_SUKARELA_COA_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_INT,  TYPE_DATE,
		TYPE_INT,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG
	} ;

	public JspRekapMain(){
	}
	public JspRekapMain(RekapMain rekapMain){
		this.rekapMain = rekapMain;
	}

	public JspRekapMain(HttpServletRequest request, RekapMain rekapMain){
		super(new JspRekapMain(rekapMain), request);
		this.rekapMain = rekapMain;
	}

	public String getFormName() { return JSP_NAME_REKAPMAIN; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public RekapMain getEntityObject(){ return rekapMain; }

	public void requestEntityObject(RekapMain rekapMain) {
		try{
			this.requestParam();
			//rekapMain.setDinasId(getLong(JSP_DINAS_ID));
			//rekapMain.setDinasUnitId(getLong(JSP_DINAS_UNIT_ID));
			//rekapMain.setPeriodeRekapId(getLong(JSP_PERIODE_REKAP_ID));
			//rekapMain.setStatus(getInt(JSP_STATUS));
			//rekapMain.setDate(getDate(JSP_DATE));
			//rekapMain.setCounter(getInt(JSP_COUNTER));
			//rekapMain.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
			//rekapMain.setNumber(getString(JSP_NUMBER));
			rekapMain.setNote(getString(JSP_NOTE));
			rekapMain.setAngsuranCoaDebetId(getLong(JSP_ANGSURAN_COA_DEBET_ID));
			rekapMain.setAngsuranCoaCreditId(getLong(JSP_ANGSURAN_COA_CREDIT_ID));
			rekapMain.setBungaCoaDebetId(getLong(JSP_BUNGA_COA_DEBET_ID));
			rekapMain.setBungaCoaCreditId(getLong(JSP_BUNGA_COA_CREDIT_ID));
			rekapMain.setMinimarketCoaDebetId(getLong(JSP_MINIMARKET_COA_DEBET_ID));
			rekapMain.setMinimarketCoaCreditId(getLong(JSP_MINIMARKET_COA_CREDIT_ID));
			rekapMain.setFasjabtelCoaDebetId(getLong(JSP_FASJABTEL_COA_DEBET_ID));
			rekapMain.setFasjabtelCoaCreditId(getLong(JSP_FASJABTEL_COA_CREDIT_ID));
			rekapMain.setTitipanCoaDebetId(getLong(JSP_TITIPAN_COA_DEBET_ID));
			rekapMain.setTitipanCoaCreditId(getLong(JSP_TITIPAN_COA_CREDIT_ID));
			rekapMain.setSimpananCoaDebetId(getLong(JSP_SIMPANAN_COA_DEBET_ID));
			rekapMain.setSimpananCoaCreditId(getLong(JSP_SIMPANAN_COA_CREDIT_ID));
                        rekapMain.setUserId(getLong(JSP_USER_ID));
                        
                        rekapMain.setSimpananPokokCoaId(getLong(JSP_SIMPANAN_POKOK_COA_ID));
                        rekapMain.setSimpananSukarelaCoaId(getLong(JSP_SIMPANAN_SUKARELA_COA_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
