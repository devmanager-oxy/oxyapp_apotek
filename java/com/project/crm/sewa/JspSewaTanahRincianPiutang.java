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

public class JspSewaTanahRincianPiutang extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private SewaTanahRincianPiutang sewaTanahRincianPiutang;

	public static final String JSP_NAME_SEWATANAHRINCIANPIUTANG		=  "JSP_NAME_SEWATANAHRINCIANPIUTANG" ;

	public static final int JSP_SEWA_TANAH_RINCIAN_PIUTANG_ID			=  0 ;
	public static final int JSP_SARANA_ID			=  1 ;
	public static final int JSP_INVESTOR_ID			=  2 ;
	public static final int JSP_SEWA_TANAH_ID			=  3 ;
	public static final int JSP_LUAS_LAHAN			=  4 ;
	public static final int JSP_MULAI_SEWA			=  5 ;
	public static final int JSP_LOT_ID			=  6 ;
	public static final int JSP_KOMIN_CURRENCY_ID			=  7 ;
	public static final int JSP_PERIODE_TAHUN			=  8 ;
	public static final int JSP_NILAI_KOMIN_TH			=  9 ;
	public static final int JSP_MASA_KOMIN_ID			=  10 ;
	public static final int JSP_MASA_KOMIN_JML_BULAN			=  11 ;
	public static final int JSP_MASA_ASSES_ID			=  12 ;
	public static final int JSP_MASA_ASSES_JML_BULAN			=  13 ;
	public static final int JSP_NILAI_ASSES_TH			=  14 ;
	public static final int JSP_PERHITUNGAN_ASSES_NOTE			=  15 ;
	public static final int JSP_PERHITUNGAN_KOMIN_NOTE			=  16 ;
	public static final int JSP_ASSES_CURRENCY_ID			=  17 ;
	public static final int JSP_KETERANGAN			=  18 ;
	public static final int JSP_PERHITUNGAN_ASSES1			=  19 ;
	public static final int JSP_PERHITUNGAN_ASSES2			=  20 ;
	public static final int JSP_PERHITUNGAN_KOMIN1			=  21 ;
	public static final int JSP_PERHITUNGAN_KOMIN2			=  22 ;

	public static String[] colNames = {
		"JSP_SEWA_TANAH_RINCIAN_PIUTANG_ID",  "JSP_SARANA_ID",
		"JSP_INVESTOR_ID",  "JSP_SEWA_TANAH_ID",
		"JSP_LUAS_LAHAN",  "JSP_MULAI_SEWA",
		"JSP_LOT_ID",  "JSP_KOMIN_CURRENCY_ID",
		"JSP_PERIODE_TAHUN",  "JSP_NILAI_KOMIN_TH",
		"JSP_MASA_KOMIN_ID",  "JSP_MASA_KOMIN_JML_BULAN",
		"JSP_MASA_ASSES_ID",  "JSP_MASA_ASSES_JML_BULAN",
		"JSP_NILAI_ASSES_TH",  "JSP_PERHITUNGAN_ASSES_NOTE",
		"JSP_PERHITUNGAN_KOMIN_NOTE",  "JSP_ASSES_CURRENCY_ID",
		"JSP_KETERANGAN",  "JSP_PERHITUNGAN_ASSES1",
		"JSP_PERHITUNGAN_ASSES2",  "JSP_PERHITUNGAN_KOMIN1",
		"JSP_PERHITUNGAN_KOMIN2"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_LONG,
		TYPE_LONG,  TYPE_LONG,
		TYPE_FLOAT,  TYPE_DATE,
		TYPE_LONG,  TYPE_LONG,
		TYPE_INT,  TYPE_FLOAT,
		TYPE_LONG,  TYPE_INT,
		TYPE_LONG,  TYPE_INT,
		TYPE_FLOAT,  TYPE_STRING,
		TYPE_STRING,  TYPE_LONG,
		TYPE_STRING,  TYPE_FLOAT,
		TYPE_FLOAT,  TYPE_FLOAT,
		TYPE_FLOAT
	} ;

	public JspSewaTanahRincianPiutang(){
	}
	public JspSewaTanahRincianPiutang(SewaTanahRincianPiutang sewaTanahRincianPiutang){
		this.sewaTanahRincianPiutang = sewaTanahRincianPiutang;
	}

	public JspSewaTanahRincianPiutang(HttpServletRequest request, SewaTanahRincianPiutang sewaTanahRincianPiutang){
		super(new JspSewaTanahRincianPiutang(sewaTanahRincianPiutang), request);
		this.sewaTanahRincianPiutang = sewaTanahRincianPiutang;
	}

	public String getFormName() { return JSP_NAME_SEWATANAHRINCIANPIUTANG; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public SewaTanahRincianPiutang getEntityObject(){ return sewaTanahRincianPiutang; }

	public void requestEntityObject(SewaTanahRincianPiutang sewaTanahRincianPiutang) {
		try{
			this.requestParam();
			sewaTanahRincianPiutang.setSaranaId(getLong(JSP_SARANA_ID));
			sewaTanahRincianPiutang.setInvestorId(getLong(JSP_INVESTOR_ID));
			sewaTanahRincianPiutang.setSewaTanahId(getLong(JSP_SEWA_TANAH_ID));
			sewaTanahRincianPiutang.setLuasLahan(getDouble(JSP_LUAS_LAHAN));
			sewaTanahRincianPiutang.setMulaiSewa(getDate(JSP_MULAI_SEWA));
			sewaTanahRincianPiutang.setLotId(getLong(JSP_LOT_ID));
			sewaTanahRincianPiutang.setKominCurrencyId(getLong(JSP_KOMIN_CURRENCY_ID));
			sewaTanahRincianPiutang.setPeriodeTahun(getInt(JSP_PERIODE_TAHUN));
			sewaTanahRincianPiutang.setNilaiKominTh(getDouble(JSP_NILAI_KOMIN_TH));
			sewaTanahRincianPiutang.setMasaKominId(getLong(JSP_MASA_KOMIN_ID));
			sewaTanahRincianPiutang.setMasaKominJmlBulan(getInt(JSP_MASA_KOMIN_JML_BULAN));
			sewaTanahRincianPiutang.setMasaAssesId(getLong(JSP_MASA_ASSES_ID));
			sewaTanahRincianPiutang.setMasaAssesJmlBulan(getInt(JSP_MASA_ASSES_JML_BULAN));
			sewaTanahRincianPiutang.setNilaiAssesTh(getDouble(JSP_NILAI_ASSES_TH));
			sewaTanahRincianPiutang.setPerhitunganAssesNote(getString(JSP_PERHITUNGAN_ASSES_NOTE));
			sewaTanahRincianPiutang.setPerhitunganKominNote(getString(JSP_PERHITUNGAN_KOMIN_NOTE));
			sewaTanahRincianPiutang.setAssesCurrencyId(getLong(JSP_ASSES_CURRENCY_ID));
			sewaTanahRincianPiutang.setKeterangan(getString(JSP_KETERANGAN));
			sewaTanahRincianPiutang.setPerhitunganAsses1(getDouble(JSP_PERHITUNGAN_ASSES1));
			sewaTanahRincianPiutang.setPerhitunganAsses2(getDouble(JSP_PERHITUNGAN_ASSES2));
			sewaTanahRincianPiutang.setPerhitunganKomin1(getDouble(JSP_PERHITUNGAN_KOMIN1));
			sewaTanahRincianPiutang.setPerhitunganKomin2(getDouble(JSP_PERHITUNGAN_KOMIN2));
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
