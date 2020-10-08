

package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;
import com.project.util.*;

public class JspPinjaman extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Pinjaman pinjaman;

	public static final String JSP_NAME_PINJAMAN		=  "JSP_NAME_PINJAMAN" ;

	public static final int JSP_MEMBER_ID			=  0 ;
	public static final int JSP_PINJAMAN_ID			=  1 ;
	public static final int JSP_COUNTER			=  2 ;
	public static final int JSP_PREFIX_NUMBER			=  3 ;
	public static final int JSP_NUMBER			=  4 ;
	public static final int JSP_DATE			=  5 ;
	public static final int JSP_NOTE			=  6 ;
	public static final int JSP_TOTAL_PINJAMAN			=  7 ;
	public static final int JSP_BUNGA			=  8 ;
	public static final int JSP_STATUS			=  9 ;
	public static final int JSP_USER_ID			=  10 ;
	public static final int JSP_BIAYA_ADMINISTRASI			=  11 ;
	public static final int JSP_JENIS_BARANG			=  12 ;
	public static final int JSP_DETAIL_JENIS_BARANG			=  13 ;
	public static final int JSP_LAMA_CICILAN			=  14 ;
	public static final int JSP_TYPE			=  15 ;
	public static final int JSP_BANK_ID			=  16 ;
        public static final int JSP_TANGGAL_JATUH_TEMPO			=  17 ;
        public static final int JSP_APPROVE_BY_ID			=  18 ;
        public static final int JSP_BUNGA_BANK			=  19 ;
        
        public static final int JSP_PROVISI			=  20 ;
        public static final int JSP_ASURANSI			=  21 ;
        public static final int JSP_CICILAN			=  22 ;
        public static final int JSP_JENIS_CICILAN			=  23 ;
        
        public static final int JSP_COA_AR_DEBET_ID			=  24 ;
        public static final int JSP_COA_AR_CREDIT_ID			=  25 ;
        public static final int JSP_COA_ADMIN_DEBET_ID			=  26 ;
        public static final int JSP_COA_ADMIN_CREDIT_ID			=  27 ;
        public static final int JSP_COA_PROVISI_DEBET_ID			=  28 ;
        public static final int JSP_COA_PROVISI_CREDIT_ID			=  29 ;
        public static final int JSP_COA_ASURANSI_DEBET_ID			=  30 ;
        public static final int JSP_COA_ASURANSI_CREDIT_ID			=  31 ;
        public static final int JSP_COA_TITIPAN_DEBET_ID			=  32 ;
        public static final int JSP_COA_TITIPAN_CREDIT_ID			=  33 ;
        public static final int JSP_ANGSURAN_TERAKHIR   			=  34 ;

	public static String[] colNames = {
		"JSP_MEMBER_ID",  "JSP_PINJAMAN_ID",
		"JSP_COUNTER",  "JSP_PREFIX_NUMBER",
		"JSP_NUMBER",  "JSP_DATE",
		"JSP_NOTE",  "JSP_TOTAL_PINJAMAN",
		"JSP_BUNGA",  "JSP_STATUS",
		"JSP_USER_ID",  "JSP_BIAYA_ADMINISTRASI",
		"JSP_JENIS_BARANG",  "JSP_DETAIL_JENIS_BARANG",
		"JSP_LAMA_CICILAN",  "JSP_TYPE",
		"JSP_BANK_ID", "JSP_TANGGAL_JATUH_TEMPO",
                "JSP_APPROVE_BY", "JSP_BUNGA_BANK",
                
                "JSP_PROVISI", "JSP_ASURANSI",
                "JSP_CICILAN", "JSP_JENIS_CICILAN",
                
                "JSP_COA_AR_DEBET_ID", "JSP_COA_AR_CREDIT_ID",
                "JSP_COA_ADMIN_DEBET_ID", "JSP_COA_ADMIN_CREDIT_ID",
                "JSP_COA_PROVISI_DEBET_ID", "JSP_COA_PROVISI_CREDIT_ID",
                "JSP_COA_ASURANSI_DEBET_ID", "JSP_COA_ASURANSI_CREDIT_ID",
                "JSP_COA_TITIPAN_DEBET_ID", "JSP_COA_TITIPAN_CREDIT_ID",
                "JSP_ANGSURAN_TERAKHIR"
                
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_INT,  TYPE_STRING,
		TYPE_STRING,  TYPE_STRING,
		TYPE_STRING,  TYPE_FLOAT + ENTRY_REQUIRED,
		TYPE_FLOAT + ENTRY_REQUIRED,  TYPE_INT,
		TYPE_LONG,  TYPE_FLOAT,
		TYPE_INT,  TYPE_STRING,
		TYPE_INT + ENTRY_REQUIRED,  TYPE_INT,
		TYPE_LONG, TYPE_INT + ENTRY_REQUIRED,
                TYPE_LONG, TYPE_FLOAT,
                
                TYPE_FLOAT, TYPE_FLOAT,
                TYPE_FLOAT, TYPE_INT,
                
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_INT
                
	} ;

	public JspPinjaman(){
	}
	public JspPinjaman(Pinjaman pinjaman){
		this.pinjaman = pinjaman;
	}

	public JspPinjaman(HttpServletRequest request, Pinjaman pinjaman){
		super(new JspPinjaman(pinjaman), request);
		this.pinjaman = pinjaman;
	}

	public String getFormName() { return JSP_NAME_PINJAMAN; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public Pinjaman getEntityObject(){ return pinjaman; }

	public void requestEntityObject(Pinjaman pinjaman) {
		try{
			this.requestParam();
			pinjaman.setMemberId(getLong(JSP_MEMBER_ID));
			//pinjaman.setCounter(getInt(JSP_COUNTER));
			//pinjaman.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
			pinjaman.setNumber(getString(JSP_NUMBER));
			pinjaman.setDate(JSPFormater.formatDate(getString(JSP_DATE),"dd/MM/yyyy"));
			pinjaman.setNote(getString(JSP_NOTE));
			pinjaman.setTotalPinjaman(getDouble(JSP_TOTAL_PINJAMAN));
			pinjaman.setBunga(getDouble(JSP_BUNGA));
			pinjaman.setStatus(getInt(JSP_STATUS));
			pinjaman.setUserId(getLong(JSP_USER_ID));
			pinjaman.setBiayaAdministrasi(getDouble(JSP_BIAYA_ADMINISTRASI));
			pinjaman.setJenisBarang(getInt(JSP_JENIS_BARANG));
			pinjaman.setDetailJenisBarang(getString(JSP_DETAIL_JENIS_BARANG));
			pinjaman.setLamaCicilan(getInt(JSP_LAMA_CICILAN));
			pinjaman.setType(getInt(JSP_TYPE));
			pinjaman.setBankId(getLong(JSP_BANK_ID));
                        pinjaman.setTanggalJatuhTempo(getInt(JSP_TANGGAL_JATUH_TEMPO));
                        pinjaman.setApproveById(getLong(JSP_APPROVE_BY_ID));
                        pinjaman.setBungaBank(getDouble(JSP_BUNGA_BANK));
                        
                        pinjaman.setProvisi(getDouble(JSP_PROVISI));
                        pinjaman.setAsuransi(getDouble(JSP_ASURANSI));
                        pinjaman.setCicilan(getDouble(JSP_CICILAN));
                        pinjaman.setJenisCicilan(getInt(JSP_JENIS_CICILAN));
                        
                        pinjaman.setCoaArDebetId(getLong(JSP_COA_AR_DEBET_ID));
                        pinjaman.setCoaArCreditId(getLong(JSP_COA_AR_CREDIT_ID));
                        pinjaman.setCoaAdminDebetId(getLong(JSP_COA_ADMIN_DEBET_ID));
                        pinjaman.setCoaAdminCreditId(getLong(JSP_COA_ADMIN_CREDIT_ID));
                        pinjaman.setCoaProvisiDebetId(getLong(JSP_COA_PROVISI_DEBET_ID));
                        pinjaman.setCoaProvisiCreditId(getLong(JSP_COA_PROVISI_CREDIT_ID));
                        pinjaman.setCoaAsuransiDebetId(getLong(JSP_COA_ASURANSI_DEBET_ID));
                        pinjaman.setCoaAsuransiCreditId(getLong(JSP_COA_ASURANSI_CREDIT_ID));
                        pinjaman.setCoaTitipanDebetId(getLong(JSP_COA_TITIPAN_DEBET_ID));
                        pinjaman.setCoaTitipanCreditId(getLong(JSP_COA_TITIPAN_CREDIT_ID));
                        pinjaman.setAngsuranTerakhir(getInt(JSP_ANGSURAN_TERAKHIR));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
