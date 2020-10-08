package com.project.coorp.member;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;
import com.project.coorp.member.*;
import com.project.util.*;

public class JspMember extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private Member customer;

	public static final String JSP_NAME_MEMBER		=  "jsp_member" ;
        
                public static final  int JSP_MEMBER_ID        = 0;
                public static final  int JSP_NAMA               = 1;
                public static final  int JSP_ALAMAT             = 2;
                public static final  int JSP_KOTA_ID            = 3;
                public static final  int JSP_NOTE               = 4;
                public static final  int JSP_PEKERJAAN_ID          = 5;


                public static final  int JSP_PHONE              = 6;
                public static final  int JSP_HP                 = 7;
                public static final  int JSP_FAX                = 8;
                public static final  int JSP_EMAIL              = 9;

                public static final  int JSP_PHONE_AREA         = 10;
                public static final  int JSP_PHONE_PERUSAHAAN   = 11;
                public static final  int JSP_KABUPATEN_ID       = 12;
                public static final  int JSP_KECAMATAN_ID       = 13;
                public static final  int JSP_DESA_ID            = 14;
                public static final  int JSP_NO_MEMBER          = 15;
                public static final  int JSP_ZIP_CODE           = 16;
                public static final  int JSP_TGL_LAHIR          = 17;

                public static final  int JSP_NAMA_PERUSAHAAN    = 18;
                public static final  int JSP_ALAMAT_PERUSAHAAN  = 19;
                public static final  int JSP_STATUS             = 20;

                public static final  int JSP_AGAMA              = 21;
                public static final  int JSP_NAMA_AHLI_WARIS    = 22;
                public static final  int JSP_NAMA_PENANGGUNG    = 23;
                public static final  int JSP_PENDIDIKAN         = 24;

                public static final  int JSP_SIBUHAR            = 25;
                public static final  int JSP_SIMPLE             = 26;
                public static final  int JSP_SIRAYA             = 27;
                public static final  int JSP_SIMAPAN            = 28;
                public static final  int JSP_SIMP_RENCANA       = 29;
                public static final  int JSP_SISUKA             = 30;

                public static final  int JSP_KUK                = 31;
                public static final  int JSP_KMP                = 32;
                public static final  int JSP_KIP                = 33;
                public static final  int JSP_KTM                = 34;
                public static final  int JSP_KPP                = 35;
                public static final  int JSP_KIPERUM            = 36;
                public static final  int JSP_KHUSUS             = 37;
                public static final  int JSP_JENIS_KELAMIN      = 38;
                public static final  int JSP_KIPER              = 39;
                
                public static final  int JSP_TGL_MASUK          = 40;
                public static final  int JSP_TGL_KELUAR         = 41;
                public static final  int JSP_TGL_PENDIDIKAN     = 42;
                
                public static final  int JSP_STATUS_PEGAWAI     = 43;
                public static final  int JSP_DINAS_ID           = 44;
                public static final  int JSP_DINAS_UNIT_ID      = 45;
                

	public static String[] fieldNames = {
		"JSP_MEMBER_ID",
		"JSP_NAMA",
		"JSP_ALAMAT",
		"JSP_KOTA_ID",
		"JSP_NOTE",
		"JSP_PEKERJAAN_ID",
                
                "JSP_PHONE",
                "JSP_HP",
                "JSP_FAX",
                "JSP_EMAIL",
                
                "JSP_PHONE_AREA",
                "JSP_PHONE_PERUSAHAAN",
                "JSP_KABUPATEN_ID",
                "JSP_KECAMATAN_ID",
                "JSP_DESA_ID",
                "JSP_NO_MEMBER",
                "JSP_ZIP_CODE",
                "JSP_TGL_LAHIR",
                
                "JSP_NAMA_PERUSAHAAN",
                "JSP_ALAMAT_PERUSAHAAN",
                "JSP_STATUS",
                
                "JSP_AGAMA",
                "JSP_NAMA_AHLI_WARIS",
                "JSP_NAMA_PENANGGUNG",
                "JSP_PENDIDIKAN",

                "JSP_SIBUHAR",
                "JSP_SIMPLE",
                "JSP_SIRAYA",
                "JSP_SIMAPAN",
                "JSP_SIMP_RENCANA",
                "JSP_SISUKA",

                "JSP_KUK",
                "JSP_KMP",
                "JSP_KIP",
                "JSP_KTM",
                "JSP_KPP",
                "JSP_KIPERUM",
                "JSP_KHUSUS",
                "JSP_JENIS_KELAMIN",
                "JSP_KIPER",
                
                "JSP_TGL_MASUK",
                "JSP_TGL_KELUAR",
                "JSP_TGL_PENDIDIKAN",
                
                "JSP_STATUS_PEGAWAI",
                "JSP_DINAS",
                "JSP_DINAS_UNIT"
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,
		TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING + ENTRY_REQUIRED,
		TYPE_LONG,
		TYPE_STRING,
		TYPE_LONG,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_LONG,
                TYPE_STRING + ENTRY_REQUIRED,
                TYPE_STRING,
                TYPE_STRING,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_INT,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,

                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,

                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                TYPE_INT,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG
	} ;

	public JspMember(){
	}
	public JspMember(Member customer){
		this.customer = customer;
	}

	public JspMember(HttpServletRequest request, Member customer){
		super(new JspMember(customer), request);
		this.customer = customer;
	}

	public String getFormName() { return JSP_NAME_MEMBER; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return fieldNames; } 

	public int getFieldSize() { return fieldNames.length; } 

	public Member getEntityObject(){ return customer; }

	public void requestEntityObject(Member customer) {
		try{
			this.requestParam();
			customer.setNama(getString(JSP_NAMA));
			customer.setAlamat(getString(JSP_ALAMAT));                       
			customer.setKotaId(getLong(JSP_KOTA_ID));
			customer.setNote(getString(JSP_NOTE));
			customer.setPekerjaanId(getLong(JSP_PEKERJAAN_ID));
                        
                        customer.setZipCode(getString(JSP_ZIP_CODE));
                        customer.setPhone(getString(JSP_PHONE));
                        customer.setFax(getString(JSP_FAX));
                        customer.setHp(getString(JSP_HP));
                        customer.setEmail(getString(JSP_EMAIL));
                        
                        customer.setPhoneArea(getString(JSP_PHONE_AREA));
                        customer.setPhonePerusahaan(getString(JSP_PHONE_PERUSAHAAN));
                        customer.setKabupatenId(getLong(JSP_KABUPATEN_ID));
                        customer.setKecamatanId(getLong(JSP_KECAMATAN_ID));
                        customer.setDesaId(getLong(JSP_DESA_ID));
                        customer.setNoMember(getString(JSP_NO_MEMBER));
                        customer.setZipCode(getString(JSP_ZIP_CODE));
                        customer.setTglLahir(JSPFormater.formatDate(getString(JSP_TGL_LAHIR), "dd/MM/yyyy"));

                        customer.setNamaPerusahaan(getString(JSP_NAMA_PERUSAHAAN));
                        customer.setAlamatPerusahaan(getString(JSP_ALAMAT_PERUSAHAAN));
                        customer.setStatus(getInt(JSP_STATUS));   
                        
                        //penambahan
                        customer.setAgama(getString(JSP_AGAMA));
                        customer.setNamaAhliWaris(getString(JSP_NAMA_AHLI_WARIS));
                        customer.setNamaPenanggung(getString(JSP_NAMA_PENANGGUNG));
                        customer.setPendidikan(getString(JSP_PENDIDIKAN));

                        customer.setSibuhar(getInt(JSP_SIBUHAR));
                        customer.setSimple(getInt(JSP_SIMPLE));
                        customer.setSiraya(getInt(JSP_SIRAYA));
                        customer.setSimapan(getInt(JSP_SIMAPAN));
                        customer.setSimpRencana(getInt(JSP_SIMP_RENCANA));
                        customer.setSisuka(getInt(JSP_SISUKA));

                        customer.setKuk(getInt(JSP_KUK));
                        customer.setKmp(getInt(JSP_KMP));
                        customer.setKip(getInt(JSP_KIP));
                        customer.setKtm(getInt(JSP_KTM));
                        customer.setKpp(getInt(JSP_KPP));
                        customer.setKiperum(getInt(JSP_KIPERUM));
                        customer.setKhusus(getInt(JSP_KHUSUS));
                        customer.setJenisKelamin(getInt(JSP_JENIS_KELAMIN));
                        customer.setKiper(getInt(JSP_KIPER));
                        
                        customer.setTglMasuk(JSPFormater.formatDate(getString(JSP_TGL_MASUK), "dd/MM/yyyy"));
                        customer.setTglKeluar(JSPFormater.formatDate(getString(JSP_TGL_KELUAR), "dd/MM/yyyy"));
                        customer.setTglPendidikan(JSPFormater.formatDate(getString(JSP_TGL_PENDIDIKAN), "dd/MM/yyyy"));
                        
                        customer.setStatusPegawai(getInt(JSP_STATUS_PEGAWAI));
                        customer.setDinasId(getLong(JSP_DINAS_ID));
                        customer.setDinasUnitId(getLong(JSP_DINAS_UNIT_ID));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
