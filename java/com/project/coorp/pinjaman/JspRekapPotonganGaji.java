package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;

public class JspRekapPotonganGaji extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private RekapPotonganGaji rekapPotonganGaji;

	public static final String JSP_NAME_REKAPPOTONGANGAJI		=  "JSP_NAME_REKAPPOTONGANGAJI" ;

	public static final int JSP_PERIODE_REKAP_ID			=  0 ;
	public static final int JSP_REKAP_POTONGAN_GAJI_ID			=  1 ;
	public static final int JSP_MEMBER_ID			=  2 ;
	public static final int JSP_SIMPANAN_POKOK			=  3 ;
	public static final int JSP_SIMPANAN_WAJIB			=  4 ;
	public static final int JSP_SIMPANAN_SUKARELA			=  5 ;
	public static final int JSP_PINJAMAN_POKOK			=  6 ;
	public static final int JSP_PINJAMAN_BUNGA			=  7 ;
	public static final int JSP_MINIMARKET			=  8 ;
	public static final int JSP_ELEKTRONIK_POKOK			=  9 ;
	public static final int JSP_ELEKTRONIK_BUNGA			=  10 ;
	public static final int JSP_MANDIRI			=  11 ;
	public static final int JSP_BNI			=  12 ;
	public static final int JSP_BCA			=  13 ;
	public static final int JSP_LAINLAIN			=  14 ;
	public static final int JSP_STATUS			=  15 ;
	public static final int JSP_APPROVED			=  16 ;
	public static final int JSP_DATE			=  17 ;
	public static final int JSP_USER_ID			=  18 ;
        
        public static final int JSP_FASJABTEL			=  19 ;
        public static final int JSP_DISETUJUI			=  20 ;
        public static final int JSP_NOTE			=  21 ;
        public static final int JSP_STATUS_DOCUMENT			=  22 ;
        public static final int JSP_MANDIRI_BUNGA			=  23 ;
        

	public static String[] colNames = {
		"JSP_PERIODE_REKAP_ID",  "JSP_REKAP_POTONGAN_GAJI_ID",
		"JSP_MEMBER_ID",  "JSP_SIMPANAN_POKOK",
		"JSP_SIMPANAN_WAJIB",  "JSP_SIMPANAN_SUKARELA",
		"JSP_PINJAMAN_POKOK",  "JSP_PINJAMAN_BUNGA",
		"JSP_MINIMARKET",  "JSP_ELEKTRONIK_POKOK",
		"JSP_ELEKTRONIK_BUNGA",  "JSP_MANDIRI",
		"JSP_BNI",  "JSP_BCA",
		"JSP_LAINLAIN",  "JSP_STATUS",
		"JSP_APPROVED",  "JSP_DATE",
		"JSP_USER_ID", 
                
                "JSP_FASJABTEL", "JSP_DISETUJUI",
                "JSP_NOTE", "JSP_STATUS_DOCUMENT",
                "JSP_MANDIRI_BUNGA"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_INT,
		TYPE_INT,  TYPE_DATE,
		TYPE_INT,
                
                TYPE_FLOAT, TYPE_FLOAT,
                TYPE_STRING, TYPE_INT,
                TYPE_FLOAT
	} ;

	public JspRekapPotonganGaji(){
	}
	public JspRekapPotonganGaji(RekapPotonganGaji rekapPotonganGaji){
		this.rekapPotonganGaji = rekapPotonganGaji;
	}

	public JspRekapPotonganGaji(HttpServletRequest request, RekapPotonganGaji rekapPotonganGaji){
		super(new JspRekapPotonganGaji(rekapPotonganGaji), request);
		this.rekapPotonganGaji = rekapPotonganGaji;
	}

	public String getFormName() { return JSP_NAME_REKAPPOTONGANGAJI; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public RekapPotonganGaji getEntityObject(){ return rekapPotonganGaji; }

	public void requestEntityObject(RekapPotonganGaji rekapPotonganGaji) {
		try{
			this.requestParam();
			rekapPotonganGaji.setPeriodeRekapId(getLong(JSP_PERIODE_REKAP_ID));
			rekapPotonganGaji.setMemberId(getLong(JSP_MEMBER_ID));
			rekapPotonganGaji.setSimpananPokok(getDouble(JSP_SIMPANAN_POKOK));
			rekapPotonganGaji.setSimpananWajib(getDouble(JSP_SIMPANAN_WAJIB));
			rekapPotonganGaji.setSimpananSukarela(getDouble(JSP_SIMPANAN_SUKARELA));
			rekapPotonganGaji.setPinjamanPokok(getDouble(JSP_PINJAMAN_POKOK));
			rekapPotonganGaji.setPinjamanBunga(getDouble(JSP_PINJAMAN_BUNGA));
			rekapPotonganGaji.setMinimarket(getDouble(JSP_MINIMARKET));
			rekapPotonganGaji.setElektronikPokok(getDouble(JSP_ELEKTRONIK_POKOK));
			rekapPotonganGaji.setElektronikBunga(getDouble(JSP_ELEKTRONIK_BUNGA));
			rekapPotonganGaji.setMandiri(getDouble(JSP_MANDIRI));
			rekapPotonganGaji.setBni(getDouble(JSP_BNI));
			rekapPotonganGaji.setBca(getDouble(JSP_BCA));
			rekapPotonganGaji.setLainlain(getDouble(JSP_LAINLAIN));
			rekapPotonganGaji.setStatus(getInt(JSP_STATUS));
			rekapPotonganGaji.setApproved(getInt(JSP_APPROVED));
			rekapPotonganGaji.setDate(getDate(JSP_DATE));
			rekapPotonganGaji.setUserId(getInt(JSP_USER_ID));
                        
                        rekapPotonganGaji.setFasjabtel(getDouble(JSP_FASJABTEL));
                        rekapPotonganGaji.setDisetujui(getDouble(JSP_DISETUJUI));
                        rekapPotonganGaji.setNote(getString(JSP_NOTE));
                        rekapPotonganGaji.setStatusDocument(getInt(JSP_STATUS_DOCUMENT));
                        rekapPotonganGaji.setMandiriBunga(getDouble(JSP_MANDIRI_BUNGA));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
