
package com.project.coorp.pinjaman;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.general.*;


public class JspSimpananMember extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SimpananMember simpananMember;

	public static final String JSP_NAME_SIMPANANMEMBER		=  "JSP_NAME_SIMPANANMEMBER" ;

	public static final int JSP_SIMPANAN_MEMBER_ID			=  0 ;
	public static final int JSP_MEMBER_ID			=  1 ;
	public static final int JSP_POKOK			=  2 ;
	public static final int JSP_WAJIB			=  3 ;
	public static final int JSP_SUKARELA_SHU			=  4 ;
	public static final int JSP_SUKARELA_TABUNGAN			=  5 ;
	public static final int JSP_POTONGAN_PINJAMAN			=  6 ;
	public static final int JSP_TOTAL			=  7 ;
	public static final int JSP_TANGGAL			=  8 ;
	public static final int JSP_KETERANGAN			=  9 ;
	public static final int JSP_USER_ID			=  10 ;
	public static final int JSP_STATUS			=  11 ;
	public static final int JSP_COUNTER			=  12 ;
	public static final int JSP_PREFIX_NUMBER			=  13 ;
	public static final int JSP_NUMBER			=  14 ;
        
        public static final int JSP_SIMPANAN_COA_DEBET_ID			=  15 ;
        public static final int JSP_SIMPANAN_COA_CREDIT_ID			=  16 ;
        public static final int JSP_SIMPANAN_COA_POKOK_ID			=  17 ;
        public static final int JSP_SIMPANAN_COA_SUKARELA_ID			=  18 ;
        public static final int JSP_SIMPANAN_COA_SHU_ID			=  19 ;
        public static final int JSP_SIMPANAN_COA_DEBET_NSP_ID			=  20 ;
        public static final int JSP_SIMPANAN_COA_WAJIB_ID			=  21 ;

	public static String[] colNames = {
		"JSP_SIMPANAN_MEMBER_ID",  "JSP_MEMBER_ID",
		"JSP_POKOK",  "JSP_WAJIB",
		"JSP_SUKARELA_SHU",  "JSP_SUKARELA_TABUNGAN",
		"JSP_POTONGAN_PINJAMAN",  "JSP_TOTAL",
		"JSP_TANGGAL",  "JSP_KETERANGAN",
		"JSP_USER_ID",  "JSP_STATUS",
		"JSP_COUNTER",  "JSP_PREFIX_NUMBER",
		"JSP_NUMBER", 
                "JSP_SIMPANAN_COA_DEBET_ID", "JSP_SIMPANAN_COA_CREDIT_ID",
                "JSP_SIMPANAN_COA_POKOK_ID", "JSP_SIMPANAN_COA_SUKARELA_ID",
                "JSP_SIMPANAN_COA_SHU_ID", "JSP_SIMPANAN_COA_DEBET_NSP_ID",
                "JSP_SIMPANAN_COA_WAJIB_ID"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG + ENTRY_REQUIRED,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_DATE,  TYPE_STRING,
		TYPE_LONG,  TYPE_INT,
		TYPE_INT,  TYPE_STRING,
		TYPE_STRING,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG, TYPE_LONG,
                TYPE_LONG
	} ;

	public JspSimpananMember(){
	}
	public JspSimpananMember(SimpananMember simpananMember){
		this.simpananMember = simpananMember;
	}

	public JspSimpananMember(HttpServletRequest request, SimpananMember simpananMember){
		super(new JspSimpananMember(simpananMember), request);
		this.simpananMember = simpananMember;
	}

	public String getFormName() { return JSP_NAME_SIMPANANMEMBER; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SimpananMember getEntityObject(){ return simpananMember; }

	public void requestEntityObject(SimpananMember simpananMember) {
		try{
			this.requestParam();
			simpananMember.setMemberId(getLong(JSP_MEMBER_ID));
			simpananMember.setPokok(getDouble(JSP_POKOK));
			simpananMember.setWajib(getDouble(JSP_WAJIB));
			simpananMember.setSukarelaShu(getDouble(JSP_SUKARELA_SHU));
			simpananMember.setSukarelaTabungan(getDouble(JSP_SUKARELA_TABUNGAN));
			simpananMember.setPotonganPinjaman(getDouble(JSP_POTONGAN_PINJAMAN));
			simpananMember.setTotal(getDouble(JSP_TOTAL));
			simpananMember.setTanggal(getDate(JSP_TANGGAL));
			simpananMember.setKeterangan(getString(JSP_KETERANGAN));
			simpananMember.setUserId(getLong(JSP_USER_ID));
			simpananMember.setStatus(getInt(JSP_STATUS));
			simpananMember.setCounter(getInt(JSP_COUNTER));
			simpananMember.setPrefixNumber(getString(JSP_PREFIX_NUMBER));
			simpananMember.setNumber(getString(JSP_NUMBER));
                        
                        simpananMember.setSimpananCoaCreditId(getLong(JSP_SIMPANAN_COA_CREDIT_ID));
                        simpananMember.setSimpananCoaDebetId(getLong(JSP_SIMPANAN_COA_DEBET_ID));
                        simpananMember.setSimpananCoaPokokId(getLong(JSP_SIMPANAN_COA_POKOK_ID));
                        simpananMember.setSimpananCoaSukarelaId(getLong(JSP_SIMPANAN_COA_SUKARELA_ID));
                        simpananMember.setSimpananCoaShuId(getLong(JSP_SIMPANAN_COA_SHU_ID));
                        simpananMember.setSimpananCoaDebetNSPId(getLong(JSP_SIMPANAN_COA_DEBET_NSP_ID));
                        simpananMember.setSimpananCoaWajibId(getLong(JSP_SIMPANAN_COA_WAJIB_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
