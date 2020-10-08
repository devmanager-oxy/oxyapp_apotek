
package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspBayarPinjaman extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private BayarPinjaman bayarPinjaman;

	public static final String JSP_NAME_BAYARPINJAMAN		=  "JSP_NAME_BAYARPINJAMAN" ;

	public static final int JSP_MEMBER_ID			=  0 ;
	public static final int JSP_PINJAMAN_ID			=  1 ;
	public static final int JSP_PINJAMAN_DETAIL_ID			=  2 ;
	public static final int JSP_BAYAR_PINJAMAN_ID			=  3 ;
	public static final int JSP_TANGGAL			=  4 ;
	public static final int JSP_AMOUNT			=  5 ;
	public static final int JSP_BUNGA			=  6 ;
	public static final int JSP_DENDA			=  7 ;
	public static final int JSP_STATUS			=  8 ;
	public static final int JSP_TYPE			=  9 ;
	public static final int JSP_CICILAN_KE			=  10 ;
	public static final int JSP_PINALTI			=  11 ;
	public static final int JSP_NO_TRANSAKSI			=  12 ;
	public static final int JSP_COUNTER			=  13 ;
	public static final int JSP_PREFIX_NUMBER			=  14 ;
        public static final int JSP_USER_ID			=  15 ;
        public static final int JSP_TYPE_PINJAMAN			=  16 ;
        
        public static final  int JSP_COA_POKOK_DEBET_ID = 17;
        public static final  int JSP_COA_POKOK_CREDIT_ID = 18;
        public static final  int JSP_COA_BUNGA_DEBET_ID = 19;
        public static final  int JSP_COA_BUNGA_CREDIT_ID = 20;
        public static final  int JSP_COA_DENDA_DEBET_ID = 21;
        public static final  int JSP_COA_DENDA_CREDIT_ID = 22;
        public static final  int JSP_COA_PINALTI_DEBET_ID = 23;
        public static final  int JSP_COA_PINALTI_CREDIT_ID = 24;

	public static String[] colNames = {
		"JSP_MEMBER_ID",  "JSP_PINJAMAN_ID",
		"JSP_PINJAMAN_DETAIL_ID",  "JSP_BAYAR_PINJAMAN_ID",
		"JSP_TANGGAL",  "JSP_AMOUNT",
		"JSP_BUNGA",  "JSP_DENDA",
		"JSP_STATUS",  "JSP_TYPE",
		"JSP_CICILAN_KE",  "JSP_PINALTI",
		"JSP_NO_TRANSAKSI",  "JSP_COUNTER",
		"JSP_PREFIX_NUMBER", "JSP_USER_ID",
                "JSP_TYPE_PINJAMAN",
                
                "JSP_COA_POKOK_DEBET_ID", "JSP_COA_POKOK_CREDIT_ID",
                "JSP_COA_BUNGA_DEBET_ID", "JSP_COA_BUNGA_CREDIT_ID",
                "JSP_COA_DENDA_DEBET_ID", "JSP_COA_DENDA_CREDIT_ID",
                "JSP_COA_PINALTI_DEBET_ID", "JSP_COA_PINALTI_CREDIT_ID"
                
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_STRING,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_INT,  TYPE_INT,
		TYPE_INT,  TYPE_FLOAT,
		TYPE_STRING,  TYPE_INT,
		TYPE_STRING, TYPE_LONG,
                TYPE_INT,
                
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG
	} ;

	public JspBayarPinjaman(){
	}
	public JspBayarPinjaman(BayarPinjaman bayarPinjaman){
		this.bayarPinjaman = bayarPinjaman;
	}

	public JspBayarPinjaman(HttpServletRequest request, BayarPinjaman bayarPinjaman){
		super(new JspBayarPinjaman(bayarPinjaman), request);
		this.bayarPinjaman = bayarPinjaman;
	}

	public String getFormName() { return JSP_NAME_BAYARPINJAMAN; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public BayarPinjaman getEntityObject(){ return bayarPinjaman; }

	public void requestEntityObject(BayarPinjaman bayarPinjaman) {
		try{
			this.requestParam();
			bayarPinjaman.setMemberId(getLong(JSP_MEMBER_ID));
			bayarPinjaman.setPinjamanId(getLong(JSP_PINJAMAN_ID));
			bayarPinjaman.setPinjamanDetailId(getLong(JSP_PINJAMAN_DETAIL_ID));
			bayarPinjaman.setTanggal(JSPFormater.formatDate(getString(JSP_TANGGAL),"dd/MM/yyyy"));
			bayarPinjaman.setAmount(getDouble(JSP_AMOUNT));
			bayarPinjaman.setBunga(getDouble(JSP_BUNGA));
			bayarPinjaman.setDenda(getDouble(JSP_DENDA));
			bayarPinjaman.setStatus(getInt(JSP_STATUS));
			bayarPinjaman.setType(getInt(JSP_TYPE));
			bayarPinjaman.setCicilanKe(getInt(JSP_CICILAN_KE));
			bayarPinjaman.setPinalti(getDouble(JSP_PINALTI));
			bayarPinjaman.setNoTransaksi(getString(JSP_NO_TRANSAKSI));
                        bayarPinjaman.setUserId(getLong(JSP_USER_ID));
                        bayarPinjaman.setTypePinjaman(getInt(JSP_TYPE_PINJAMAN));
			//bayarPinjaman.setCounter(getInt(JSP_COUNTER));
			//bayarPinjaman.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
                        
                        bayarPinjaman.setCoaPokokDebetId(getLong(JSP_COA_POKOK_DEBET_ID));
                        bayarPinjaman.setCoaPokokCreditId(getLong(JSP_COA_POKOK_CREDIT_ID));
                        bayarPinjaman.setCoaBungaDebetId(getLong(JSP_COA_BUNGA_DEBET_ID));
                        bayarPinjaman.setCoaBungaCreditId(getLong(JSP_COA_BUNGA_CREDIT_ID));
                        bayarPinjaman.setCoaDendaDebetId(getLong(JSP_COA_DENDA_DEBET_ID));
                        bayarPinjaman.setCoaDendaCreditId(getLong(JSP_COA_DENDA_CREDIT_ID));
                        bayarPinjaman.setCoaPinaltiDebetId(getLong(JSP_COA_PINALTI_DEBET_ID));
                        bayarPinjaman.setCoaPinaltiCreditId(getLong(JSP_COA_PINALTI_CREDIT_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
