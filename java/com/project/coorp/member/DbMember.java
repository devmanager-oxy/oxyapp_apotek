package com.project.coorp.member; 

import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.coorp.member.*; 

public class DbMember extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc { 

	public static final  String DB_MEMBER = "member";

	public static final  int COL_MEMBER_ID        = 0;
	public static final  int COL_NAMA               = 1;
	public static final  int COL_ALAMAT             = 2;
	public static final  int COL_KOTA_ID            = 3;
	public static final  int COL_NOTE               = 4;
	public static final  int COL_PEKERJAAN_ID       = 5;
        
        
        public static final  int COL_PHONE              = 6;
        public static final  int COL_HP                 = 7;
        public static final  int COL_FAX                = 8;
        public static final  int COL_EMAIL              = 9;
        
        public static final  int COL_PHONE_AREA         = 10;
        public static final  int COL_PHONE_PERUSAHAAN   = 11;
        public static final  int COL_KABUPATEN_ID       = 12;
        public static final  int COL_KECAMATAN_ID       = 13;
        public static final  int COL_DESA_ID            = 14;
        public static final  int COL_NO_MEMBER          = 15;
        public static final  int COL_ZIP_CODE           = 16;
        public static final  int COL_TGL_LAHIR          = 17;
        
        public static final  int COL_NAMA_PERUSAHAAN    = 18;
        public static final  int COL_ALAMAT_PERUSAHAAN  = 19;
        public static final  int COL_STATUS             = 20;
        
        public static final  int COL_AGAMA              = 21;
        public static final  int COL_NAMA_AHLI_WARIS    = 22;
        public static final  int COL_NAMA_PENANGGUNG    = 23;
        public static final  int COL_PENDIDIKAN      = 24;
        
        public static final  int COL_SIBUHAR            = 25;
        public static final  int COL_SIMPLE             = 26;
        public static final  int COL_SIRAYA             = 27;
        public static final  int COL_SIMAPAN            = 28;
        public static final  int COL_SIMP_RENCANA       = 29;
        public static final  int COL_SISUKA             = 30;
        
        public static final  int COL_KUK                = 31;
        public static final  int COL_KMP                = 32;
        public static final  int COL_KIP                = 33;
        public static final  int COL_KTM                = 34;
        public static final  int COL_KPP                = 35;
        public static final  int COL_KIPERUM            = 36;
        public static final  int COL_KHUSUS             = 37;
        public static final  int COL_JENIS_KELAMIN      = 38;
        public static final  int COL_KIPER              = 39;
        
        public static final  int COL_TGL_MASUK          = 40;
        public static final  int COL_TGL_KELUAR         = 41;
        public static final  int COL_TGL_PENDIDIKAN     = 42;
        public static final  int COL_SIMPANAN_POKOK     = 43;
        
        public static final  int COL_STATUS_PEGAWAI     = 44;
        public static final  int COL_DINAS_ID     = 45;
        public static final  int COL_DINAS_UNIT_ID     = 46;
        
        public static final  int COL_SHU_JAN     = 47;
        public static final  int COL_SHU_FEB     = 48;
        public static final  int COL_SHU_MAR     = 49;
        public static final  int COL_SHU_APR     = 50;
        public static final  int COL_SHU_MAY     = 51;
        public static final  int COL_SHU_JUN     = 52;
        public static final  int COL_SHU_JUL     = 53;
        public static final  int COL_SHU_AUG     = 54;
        public static final  int COL_SHU_SEP     = 55;
        public static final  int COL_SHU_OCT     = 56;
        public static final  int COL_SHU_NOV     = 57;
        public static final  int COL_SHU_DEC     = 58;

	public static final  String[] colNames = {
		"member_id",
		"nama",
		"alamat",
		"kota_id",
		"note",
		"pekerjaan_id",
                
                "phone",
                "hp",
                "fax",
                "email",
                
                "phone_area",
                "phone_perusahaan",
                "kabupaten_id",
                "kecamatan_id",
                "desa_id",
                "no_member",
                "zip_code",
                "tgl_lahir",
                
                "nama_perusahaan",
                "alamat_perusahaan",
                "status",
                
                "agama",
                "nama_ahli_waris",
                "nama_penanggung",
                "pendidikan",

                "sibuhar",
                "simple",
                "siraya",
                "simapan",
                "simp_rencana",
                "sisuka",

                "kuk",
                "kmp",
                "kip",
                "ktm",
                "kpp",
                "kiperum",
                "khusus",
                "jenis_kelamin",
                "kiper",
                
                "tgl_masuk",
                "tgl_keluar",
                "tgl_pendidikan",
                "simpanan_pokok",
                
                "status_pegawai",
                "dinas_id",
                "dinas_unit_id",
                
                "shu_jan",
                "shu_feb",
                "shu_mar",
                "shu_apr",
                "shu_may",
                "shu_jun",
                "shu_jul",
                "shu_aug",
                "shu_sep",
                "shu_oct",
                "shu_nov",
                "shu_dec"
	 }; 

	public static final  int[] fieldTypes = {
		TYPE_LONG + TYPE_PK + TYPE_ID,
		TYPE_STRING,
		TYPE_STRING,
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
                TYPE_STRING,
                TYPE_STRING,
                TYPE_DATE,
                
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
                
                TYPE_DATE,
                TYPE_DATE,
                TYPE_DATE,
                TYPE_FLOAT,
                
                TYPE_INT,
                TYPE_LONG,
                TYPE_LONG,
                
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                TYPE_FLOAT
	 }; 
         
         //gender----
        public static final int Pria 	= 0;
        public static final int Wanita 	= 1;

        public static final String[] sexKey = {"Pria","Wanita"};
        public static final int[] sexValue = {0,1};
        
        //agama
        public static final int Hindu = 0;
        public static final int Islam = 1;
        public static final int Bhuda = 2;
        public static final int Katolik = 3;
        public static final int Protestan = 4;
        
        public static final String[] agamaKey = {
            "Hindu",
            "Islam",
            "Bhuda",
            "Kristen Katolik",
            "Kristen Protestan",
        };
        
        //status aktif untuk tanda pada query di sessmember
        public static final int STATUS_TIDAK_AKTIF = 0;
        public static final int STATUS_AKTIF       = 1;
        public static final int STATUS_PASIF       = 2;
        
        //status 
        public static final int TIDAK_AKTIF = 0;
        public static final int AKTIF = 1;
        public static final int PASIF = 2;
        
        public static final String[] status = {
            "TIDAK AKTIF",
            "AKTIF",
            "PASIF"
        };
        
        
        public static final int STATUS_PEGAWAI_AKTIF = 0;
        public static final int STATUS_PEGAWAI_PENSIUNAN = 1;
        public static final int STATUS_PEGAWAI_OTHER = 2;
        
        public static final String[] statusPegawai ={
            "Pegawai Aktif", "Pensiunan", "-"
        };
       
        

	public DbMember(){
	}

	public DbMember(int i) throws CONException { 
		super(new DbMember()); 
	}

	public DbMember(String sOid) throws CONException { 
		super(new DbMember(0)); 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	}

	public DbMember(long lOid) throws CONException { 
		super(new DbMember(0)); 
		String sOid = "0"; 
		try { 
			sOid = String.valueOf(lOid); 
		}catch(Exception e) { 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		if(!locate(sOid)) 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		else 
			return; 
	} 

	public int getFieldSize(){ 
		return colNames.length; 
	}

	public String getTableName(){ 
		return DB_MEMBER;
	}

	public String[] getFieldNames(){ 
		return colNames; 
	}

	public int[] getFieldTypes(){ 
		return fieldTypes; 
	}

	public String getPersistentName(){ 
		return new DbMember().getClass().getName(); 
	}

	public long fetchExc(Entity ent) throws Exception{ 
		Member member = fetchExc(ent.getOID()); 
		ent = (Entity)member; 
		return member.getOID(); 
	}

	public long insertExc(Entity ent) throws Exception{ 
		return insertExc((Member) ent); 
	}

	public long updateExc(Entity ent) throws Exception{ 
		return updateExc((Member) ent); 
	}

	public long deleteExc(Entity ent) throws Exception{ 
		if(ent==null){ 
			throw new CONException(this,CONException.RECORD_NOT_FOUND); 
		} 
		return deleteExc(ent.getOID()); 
	}

	public static Member fetchExc(long oid) throws CONException{ 
		try{ 
			Member member = new Member();
			DbMember pstMember = new DbMember(oid); 
			member.setOID(oid);
			
			member.setNama(pstMember.getString(COL_NAMA));
			member.setAlamat(pstMember.getString(COL_ALAMAT));                       
			member.setKotaId(pstMember.getlong(COL_KOTA_ID));
			member.setNote(pstMember.getString(COL_NOTE));
			member.setPekerjaanId(pstMember.getlong(COL_PEKERJAAN_ID));
                        
                        member.setZipCode(pstMember.getString(COL_ZIP_CODE));
                        member.setPhone(pstMember.getString(COL_PHONE));
                        member.setFax(pstMember.getString(COL_FAX));
                        member.setHp(pstMember.getString(COL_HP));
                        member.setEmail(pstMember.getString(COL_EMAIL));
                        
                        member.setPhoneArea(pstMember.getString(COL_PHONE_AREA));
                        member.setPhonePerusahaan(pstMember.getString(COL_PHONE_PERUSAHAAN));
                        member.setKabupatenId(pstMember.getlong(COL_KABUPATEN_ID));
                        member.setKecamatanId(pstMember.getlong(COL_KECAMATAN_ID));
                        member.setDesaId(pstMember.getlong(COL_DESA_ID));
                        member.setNoMember(pstMember.getString(COL_NO_MEMBER));
                        member.setZipCode(pstMember.getString(COL_ZIP_CODE));
                        member.setTglLahir(pstMember.getDate(COL_TGL_LAHIR));

                        member.setNamaPerusahaan(pstMember.getString(COL_NAMA_PERUSAHAAN));
                        member.setAlamatPerusahaan(pstMember.getString(COL_ALAMAT_PERUSAHAAN));
                        member.setStatus(pstMember.getInt(COL_STATUS));   
                        
                        //penambahan
                        member.setAgama(pstMember.getString(COL_AGAMA));
                        member.setNamaAhliWaris(pstMember.getString(COL_NAMA_AHLI_WARIS));
                        member.setNamaPenanggung(pstMember.getString(COL_NAMA_PENANGGUNG));
                        member.setPendidikan(pstMember.getString(COL_PENDIDIKAN));

                        member.setSibuhar(pstMember.getInt(COL_SIBUHAR));
                        member.setSimple(pstMember.getInt(COL_SIMPLE));
                        member.setSiraya(pstMember.getInt(COL_SIRAYA));
                        member.setSimapan(pstMember.getInt(COL_SIMAPAN));
                        member.setSimpRencana(pstMember.getInt(COL_SIMP_RENCANA));
                        member.setSisuka(pstMember.getInt(COL_SISUKA));

                        member.setKuk(pstMember.getInt(COL_KUK));
                        member.setKmp(pstMember.getInt(COL_KMP));
                        member.setKip(pstMember.getInt(COL_KIP));
                        member.setKtm(pstMember.getInt(COL_KTM));
                        member.setKpp(pstMember.getInt(COL_KPP));
                        member.setKiperum(pstMember.getInt(COL_KIPERUM));
                        member.setKhusus(pstMember.getInt(COL_KHUSUS));
                        member.setJenisKelamin(pstMember.getInt(COL_JENIS_KELAMIN));
                        member.setKiper(pstMember.getInt(COL_KIPER));
                        
                        member.setTglMasuk(pstMember.getDate(COL_TGL_MASUK));
                        member.setTglKeluar(pstMember.getDate(COL_TGL_KELUAR));
                        member.setTglPendidikan(pstMember.getDate(COL_TGL_PENDIDIKAN));
                        member.setSimpananPokok(pstMember.getdouble(COL_SIMPANAN_POKOK));
                        
                        member.setStatusPegawai(pstMember.getInt(COL_STATUS_PEGAWAI));
                        member.setDinasId(pstMember.getlong(COL_DINAS_ID));
                        member.setDinasUnitId(pstMember.getlong(COL_DINAS_UNIT_ID));
                        
                        member.setShuJan(pstMember.getdouble(COL_SHU_JAN));
                        member.setShuFeb(pstMember.getdouble(COL_SHU_FEB));
                        member.setShuMar(pstMember.getdouble(COL_SHU_MAR));
                        member.setShuApr(pstMember.getdouble(COL_SHU_APR));
                        member.setShuMay(pstMember.getdouble(COL_SHU_MAY));
                        member.setShuJun(pstMember.getdouble(COL_SHU_JUN));
                        member.setShuJul(pstMember.getdouble(COL_SHU_JUL));
                        member.setShuAug(pstMember.getdouble(COL_SHU_AUG));                        
                        member.setShuSep(pstMember.getdouble(COL_SHU_SEP));
                        member.setShuOct(pstMember.getdouble(COL_SHU_OCT));
                        member.setShuNov(pstMember.getdouble(COL_SHU_NOV));
                        member.setShuDec(pstMember.getdouble(COL_SHU_DEC));
                        
			return member; 
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMember(0),CONException.UNKNOWN); 
		} 
	}

	public static long insertExc(Member member) throws CONException{ 
		try{ 
			DbMember pstMember = new DbMember(0);
			
			pstMember.setString(COL_NAMA, member.getNama());
			pstMember.setString(COL_ALAMAT, member.getAlamat());
			pstMember.setLong(COL_KOTA_ID, member.getKotaId());
			pstMember.setString(COL_NOTE, member.getNote());
			pstMember.setLong(COL_PEKERJAAN_ID, member.getPekerjaanId());
                       
                        pstMember.setString(COL_ZIP_CODE, member.getZipCode());
                        pstMember.setString(COL_PHONE, member.getPhone());
                        pstMember.setString(COL_FAX, member.getFax());
                        pstMember.setString(COL_HP, member.getHp());
                        pstMember.setString(COL_EMAIL, member.getEmail());
                        
                        pstMember.setString(COL_PHONE_AREA, member.getPhoneArea());
                        pstMember.setString(COL_PHONE_PERUSAHAAN, member.getPhonePerusahaan());
                        
                        pstMember.setLong(COL_KABUPATEN_ID, member.getKabupatenId());
                        pstMember.setLong(COL_KECAMATAN_ID, member.getKecamatanId());
                        pstMember.setLong(COL_DESA_ID, member.getDesaId());
                        pstMember.setString(COL_NO_MEMBER, member.getNoMember());
                        pstMember.setString(COL_ZIP_CODE, member.getZipCode());
                        pstMember.setDate(COL_TGL_LAHIR, member.getTglLahir());

                        pstMember.setString(COL_NAMA_PERUSAHAAN, member.getNamaPerusahaan());
                        pstMember.setString(COL_ALAMAT_PERUSAHAAN, member.getAlamatPerusahaan());
                        pstMember.setInt(COL_STATUS, member.getStatus());   
                        
                        //penambahan
                        pstMember.setString(COL_AGAMA, member.getAgama());
                        pstMember.setString(COL_NAMA_AHLI_WARIS, member.getNamaAhliWaris());
                        pstMember.setString(COL_NAMA_PENANGGUNG, member.getNamaPenanggung());
                        pstMember.setString(COL_PENDIDIKAN, member.getPendidikan());

                        pstMember.setInt(COL_SIBUHAR, member.getSibuhar());
                        pstMember.setInt(COL_SIMPLE, member.getSimple());
                        pstMember.setInt(COL_SIRAYA, member.getSiraya());
                        pstMember.setInt(COL_SIMAPAN, member.getSimapan());
                        pstMember.setInt(COL_SIMP_RENCANA, member.getSimpRencana());
                        pstMember.setInt(COL_SISUKA, member.getSisuka());

                        pstMember.setInt(COL_KUK, member.getKuk());
                        pstMember.setInt(COL_KMP, member.getKmp());
                        pstMember.setInt(COL_KIP, member.getKip());
                        pstMember.setInt(COL_KTM, member.getKtm());
                        pstMember.setInt(COL_KPP, member.getKpp());
                        pstMember.setInt(COL_KIPERUM, member.getKiperum());
                        pstMember.setInt(COL_KHUSUS, member.getKhusus());
                        pstMember.setInt(COL_JENIS_KELAMIN, member.getJenisKelamin());
                        pstMember.setInt(COL_KIPER, member.getKiper());
                        
                        pstMember.setDate(COL_TGL_MASUK, member.getTglMasuk());
                        pstMember.setDate(COL_TGL_KELUAR, member.getTglKeluar());
                        pstMember.setDate(COL_TGL_PENDIDIKAN, member.getTglPendidikan());
                        pstMember.setDouble(COL_SIMPANAN_POKOK, member.getSimpananPokok());
                        
                        pstMember.setInt(COL_STATUS_PEGAWAI, member.getStatusPegawai());
                        pstMember.setLong(COL_DINAS_ID, member.getDinasId());
                        pstMember.setLong(COL_DINAS_UNIT_ID, member.getDinasUnitId());
                        
                        pstMember.setDouble(COL_SHU_JAN, member.getShuJan());
                        pstMember.setDouble(COL_SHU_FEB, member.getShuFeb());
                        pstMember.setDouble(COL_SHU_MAR, member.getShuMar());
                        pstMember.setDouble(COL_SHU_APR, member.getShuApr());
                        pstMember.setDouble(COL_SHU_MAY, member.getShuMay());
                        pstMember.setDouble(COL_SHU_JUN, member.getShuJun());
                        pstMember.setDouble(COL_SHU_JUL, member.getShuJul());
                        pstMember.setDouble(COL_SHU_AUG, member.getShuAug());
                        pstMember.setDouble(COL_SHU_SEP, member.getShuSep());
                        pstMember.setDouble(COL_SHU_OCT, member.getShuOct());
                        pstMember.setDouble(COL_SHU_NOV, member.getShuNov());
                        pstMember.setDouble(COL_SHU_DEC, member.getShuDec());

			pstMember.insert(); 
			member.setOID(pstMember.getlong(COL_MEMBER_ID));
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMember(0),CONException.UNKNOWN); 
		}
		return member.getOID();
	}

	public static long updateExc(Member member) throws CONException{ 
		try{ 
			if(member.getOID() != 0){ 
				DbMember pstMember = new DbMember(member.getOID());

				pstMember.setString(COL_NAMA, member.getNama());
                                pstMember.setString(COL_ALAMAT, member.getAlamat());
                                pstMember.setLong(COL_KOTA_ID, member.getKotaId());
                                pstMember.setString(COL_NOTE, member.getNote());
                                pstMember.setLong(COL_PEKERJAAN_ID, member.getPekerjaanId());

                                pstMember.setString(COL_ZIP_CODE, member.getZipCode());
                                pstMember.setString(COL_PHONE, member.getPhone());
                                pstMember.setString(COL_FAX, member.getFax());
                                pstMember.setString(COL_HP, member.getHp());
                                pstMember.setString(COL_EMAIL, member.getEmail());

                                pstMember.setString(COL_PHONE_AREA, member.getPhoneArea());
                                pstMember.setString(COL_PHONE_PERUSAHAAN, member.getPhonePerusahaan());

                                pstMember.setLong(COL_KABUPATEN_ID, member.getKabupatenId());
                                pstMember.setLong(COL_KECAMATAN_ID, member.getKecamatanId());
                                pstMember.setLong(COL_DESA_ID, member.getDesaId());
                                pstMember.setString(COL_NO_MEMBER, member.getNoMember());
                                pstMember.setString(COL_ZIP_CODE, member.getZipCode());
                                pstMember.setDate(COL_TGL_LAHIR, member.getTglLahir());

                                pstMember.setString(COL_NAMA_PERUSAHAAN, member.getNamaPerusahaan());
                                pstMember.setString(COL_ALAMAT_PERUSAHAAN, member.getAlamatPerusahaan());
                                pstMember.setInt(COL_STATUS, member.getStatus());   

                                //penambahan
                                pstMember.setString(COL_AGAMA, member.getAgama());
                                pstMember.setString(COL_NAMA_AHLI_WARIS, member.getNamaAhliWaris());
                                pstMember.setString(COL_NAMA_PENANGGUNG, member.getNamaPenanggung());
                                pstMember.setString(COL_PENDIDIKAN, member.getPendidikan());

                                pstMember.setInt(COL_SIBUHAR, member.getSibuhar());
                                pstMember.setInt(COL_SIMPLE, member.getSimple());
                                pstMember.setInt(COL_SIRAYA, member.getSiraya());
                                pstMember.setInt(COL_SIMAPAN, member.getSimapan());
                                pstMember.setInt(COL_SIMP_RENCANA, member.getSimpRencana());
                                pstMember.setInt(COL_SISUKA, member.getSisuka());

                                pstMember.setInt(COL_KUK, member.getKuk());
                                pstMember.setInt(COL_KMP, member.getKmp());
                                pstMember.setInt(COL_KIP, member.getKip());
                                pstMember.setInt(COL_KTM, member.getKtm());
                                pstMember.setInt(COL_KPP, member.getKpp());
                                pstMember.setInt(COL_KIPERUM, member.getKiperum());
                                pstMember.setInt(COL_KHUSUS, member.getKhusus());
                                pstMember.setInt(COL_JENIS_KELAMIN, member.getJenisKelamin());
                                pstMember.setInt(COL_KIPER, member.getKiper());
                                
                                pstMember.setDate(COL_TGL_MASUK, member.getTglMasuk());
                                pstMember.setDate(COL_TGL_KELUAR, member.getTglKeluar());
                                pstMember.setDate(COL_TGL_PENDIDIKAN, member.getTglPendidikan());
                                pstMember.setDouble(COL_SIMPANAN_POKOK, member.getSimpananPokok());
                                
                                pstMember.setInt(COL_STATUS_PEGAWAI, member.getStatusPegawai());
                                pstMember.setLong(COL_DINAS_ID, member.getDinasId());
                                pstMember.setLong(COL_DINAS_UNIT_ID, member.getDinasUnitId());    
                                
                                pstMember.setDouble(COL_SHU_JAN, member.getShuJan());
                                pstMember.setDouble(COL_SHU_FEB, member.getShuFeb());
                                pstMember.setDouble(COL_SHU_MAR, member.getShuMar());
                                pstMember.setDouble(COL_SHU_APR, member.getShuApr());
                                pstMember.setDouble(COL_SHU_MAY, member.getShuMay());
                                pstMember.setDouble(COL_SHU_JUN, member.getShuJun());
                                pstMember.setDouble(COL_SHU_JUL, member.getShuJul());
                                pstMember.setDouble(COL_SHU_AUG, member.getShuAug());
                                pstMember.setDouble(COL_SHU_SEP, member.getShuSep());
                                pstMember.setDouble(COL_SHU_OCT, member.getShuOct());
                                pstMember.setDouble(COL_SHU_NOV, member.getShuNov());
                                pstMember.setDouble(COL_SHU_DEC, member.getShuDec());

				pstMember.update(); 
				return member.getOID();

			}
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMember(0),CONException.UNKNOWN); 
		}
		return 0;
	}

	public static long deleteExc(long oid) throws CONException{ 
		try{ 
			DbMember pstMember = new DbMember(oid);
			pstMember.delete();
		}catch(CONException dbe){ 
			throw dbe; 
		}catch(Exception e){ 
			throw new CONException(new DbMember(0),CONException.UNKNOWN); 
		}
		return oid;
	}

	public static Vector listAll(){ 
		return list(0, 500, "",""); 
	}

	public static Vector list(int limitStart,int recordToGet, String whereClause, String order){
		Vector lists = new Vector(); 
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT * FROM " + DB_MEMBER; 
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;
			if(order != null && order.length() > 0)
				sql = sql + " ORDER BY " + order;
			
                        switch (CONHandler.CONSVR_TYPE) {
                            case CONHandler.CONSVR_MYSQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                                break;

                            case CONHandler.CONSVR_POSTGRESQL:
                                if (limitStart == 0 && recordToGet == 0)
                                    sql = sql + "";
                                else
                                    sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;

                                break;

                            case CONHandler.CONSVR_SYBASE:
                                break;

                            case CONHandler.CONSVR_ORACLE:
                                break;

                            case CONHandler.CONSVR_MSSQL:
                                break;

                            default:
                                break;
                        }
                        
                        System.out.println("sql : "+sql);
                        
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();
			while(rs.next()) {
				Member member = new Member();
				resultToObject(rs, member);
				lists.add(member);
			}
			rs.close();
			return lists;

		}catch(Exception e) {
			System.out.println(e);
		}finally {
			CONResultSet.close(dbrs);
		}
			return new Vector();
	}

	public static void resultToObject(ResultSet rs, Member member){
		try{
			member.setOID(rs.getLong(DbMember.colNames[DbMember.COL_MEMBER_ID]));
			member.setNama(rs.getString(DbMember.colNames[DbMember.COL_NAMA]));
			member.setAlamat(rs.getString(DbMember.colNames[DbMember.COL_ALAMAT]));
			member.setKotaId(rs.getLong(DbMember.colNames[DbMember.COL_KOTA_ID]));
			member.setNote(rs.getString(DbMember.colNames[DbMember.COL_NOTE]));
			member.setPekerjaanId(rs.getLong(DbMember.colNames[DbMember.COL_PEKERJAAN_ID]));
			
                        member.setZipCode(rs.getString(DbMember.colNames[DbMember.COL_ZIP_CODE]));
                        member.setPhone(rs.getString(DbMember.colNames[DbMember.COL_PHONE]));
                        member.setFax(rs.getString(DbMember.colNames[DbMember.COL_FAX]));
                        member.setHp(rs.getString(DbMember.colNames[DbMember.COL_HP]));
                        member.setEmail(rs.getString(DbMember.colNames[DbMember.COL_EMAIL]));
                        
                        member.setPhoneArea(rs.getString(DbMember.colNames[DbMember.COL_PHONE_AREA]));
                        member.setPhonePerusahaan(rs.getString(DbMember.colNames[DbMember.COL_PHONE_PERUSAHAAN]));
                        member.setKabupatenId(rs.getLong(DbMember.colNames[DbMember.COL_KABUPATEN_ID]));
                        member.setKecamatanId(rs.getLong(DbMember.colNames[DbMember.COL_KECAMATAN_ID]));
                        member.setDesaId(rs.getLong(DbMember.colNames[DbMember.COL_DESA_ID]));
                        member.setNoMember(rs.getString(DbMember.colNames[DbMember.COL_NO_MEMBER]));
                        member.setZipCode(rs.getString(DbMember.colNames[DbMember.COL_ZIP_CODE]));
                        member.setTglLahir(rs.getDate(DbMember.colNames[DbMember.COL_TGL_LAHIR]));

                        member.setNamaPerusahaan(rs.getString(DbMember.colNames[DbMember.COL_NAMA_PERUSAHAAN]));
                        member.setAlamatPerusahaan(rs.getString(DbMember.colNames[DbMember.COL_ALAMAT_PERUSAHAAN]));
                        member.setStatus(rs.getInt(DbMember.colNames[DbMember.COL_STATUS]));   
                        
                        //penambahan
                        member.setAgama(rs.getString(DbMember.colNames[DbMember.COL_AGAMA]));
                        member.setNamaAhliWaris(rs.getString(DbMember.colNames[DbMember.COL_NAMA_AHLI_WARIS]));
                        member.setNamaPenanggung(rs.getString(DbMember.colNames[DbMember.COL_NAMA_PENANGGUNG]));
                        member.setPendidikan(rs.getString(DbMember.colNames[DbMember.COL_PENDIDIKAN]));

                        member.setSibuhar(rs.getInt(DbMember.colNames[DbMember.COL_SIBUHAR]));
                        member.setSimple(rs.getInt(DbMember.colNames[DbMember.COL_SIMPLE]));
                        member.setSiraya(rs.getInt(DbMember.colNames[DbMember.COL_SIRAYA]));
                        member.setSimapan(rs.getInt(DbMember.colNames[DbMember.COL_SIMAPAN]));
                        member.setSimpRencana(rs.getInt(DbMember.colNames[DbMember.COL_SIMP_RENCANA]));
                        member.setSisuka(rs.getInt(DbMember.colNames[DbMember.COL_SISUKA]));

                        member.setKuk(rs.getInt(DbMember.colNames[DbMember.COL_KUK]));
                        member.setKmp(rs.getInt(DbMember.colNames[DbMember.COL_KMP]));
                        member.setKip(rs.getInt(DbMember.colNames[DbMember.COL_KIP]));
                        member.setKtm(rs.getInt(DbMember.colNames[DbMember.COL_KTM]));
                        member.setKpp(rs.getInt(DbMember.colNames[DbMember.COL_KPP]));
                        member.setKiperum(rs.getInt(DbMember.colNames[DbMember.COL_KIPERUM]));
                        member.setKhusus(rs.getInt(DbMember.colNames[DbMember.COL_KHUSUS]));
                        member.setJenisKelamin(rs.getInt(DbMember.colNames[DbMember.COL_JENIS_KELAMIN]));
                        member.setKiper(rs.getInt(DbMember.colNames[DbMember.COL_KIPER]));
                        
                        member.setTglMasuk(rs.getDate(DbMember.colNames[DbMember.COL_TGL_MASUK]));
                        member.setTglKeluar(rs.getDate(DbMember.colNames[DbMember.COL_TGL_KELUAR]));
                        member.setTglPendidikan(rs.getDate(DbMember.colNames[DbMember.COL_TGL_PENDIDIKAN]));
                        member.setSimpananPokok(rs.getDouble(DbMember.colNames[DbMember.COL_SIMPANAN_POKOK]));
                        
                        member.setStatusPegawai(rs.getInt(DbMember.colNames[DbMember.COL_STATUS_PEGAWAI]));
                        member.setDinasId(rs.getLong(DbMember.colNames[DbMember.COL_DINAS_ID]));
                        member.setDinasUnitId(rs.getLong(DbMember.colNames[DbMember.COL_DINAS_UNIT_ID]));
                       
                        member.setShuJan(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_JAN]));
                        member.setShuFeb(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_FEB]));
                        member.setShuMar(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_MAR]));
                        member.setShuApr(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_APR]));
                        member.setShuMay(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_MAY]));
                        member.setShuJun(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_JUN]));
                        member.setShuJul(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_JUL]));
                        member.setShuAug(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_AUG]));
                        member.setShuSep(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_SEP]));
                        member.setShuOct(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_OCT]));
                        member.setShuNov(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_NOV]));
                        member.setShuDec(rs.getDouble(DbMember.colNames[DbMember.COL_SHU_DEC]));

		}catch(Exception e){ 
                    System.out.println(e.toString());
                }
	}

	public static boolean checkOID(long memberId){
		CONResultSet dbrs = null;
		boolean result = false;
		try{
			String sql = "SELECT * FROM " + DB_MEMBER + " WHERE " + 
						DbMember.colNames[DbMember.COL_MEMBER_ID] + " = " + memberId;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			while(rs.next()) { result = true; }
			rs.close();
		}catch(Exception e){
			System.out.println("err : "+e.toString());
		}finally{
			CONResultSet.close(dbrs);
			return result;
		}
	}

	public static int getCount(String whereClause){
		CONResultSet dbrs = null;
		try {
			String sql = "SELECT COUNT("+ DbMember.colNames[DbMember.COL_MEMBER_ID] + ") FROM " + DB_MEMBER;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;

			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			int count = 0;
			while(rs.next()) { count = rs.getInt(1); }

			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
	}


	/* This method used to find current data */
	public static int findLimitStart( long oid, int recordToGet, String whereClause){
		String order = "";
		int size = getCount(whereClause);
		int start = 0;
		boolean found =false;
		for(int i=0; (i < size) && !found ; i=i+recordToGet){
			 Vector list =  list(i,recordToGet, whereClause, order); 
			 start = i;
			 if(list.size()>0){
			  for(int ls=0;ls<list.size();ls++){ 
			  	   Member member = (Member)list.get(ls);
				   if(oid == member.getOID())
					  found=true;
			  }
		  }
		}
		if((start >= size) && (size > 0))
		    start = start - recordToGet;

		return start;
	}
        
        public static long getMemberId(String whereClause){
		CONResultSet dbrs = null; 
		try {
			String sql = "SELECT "+ DbMember.colNames[DbMember.COL_MEMBER_ID] + " FROM " + DB_MEMBER;
			if(whereClause != null && whereClause.length() > 0)
				sql = sql + " WHERE " + whereClause;                       
                        
			dbrs = CONHandler.execQueryResult(sql);
			ResultSet rs = dbrs.getResultSet();

			long count = 0;
			while(rs.next()) { 
                            count = rs.getLong(1); 
                        }
			rs.close();
			return count;
		}catch(Exception e) {
			return 0;
		}finally {
			CONResultSet.close(dbrs);
		}
	}
        
       public static void updateSimpananPokok(long memberId, double amount){
            
           try{
               Member m = new Member();
               m = DbMember.fetchExc(memberId);
               m.setSimpananPokok(amount);
               DbMember.updateExc(m);
           }
           catch(Exception e){
               
           }
            
       }
       
       public static final String[] injectString = {"=", "<", ">", "?", "&", "|", "!", "/", "%", " ", "#", "@", "*", "(", ")", "+"};
    
        public static String removeInjection(String str){

            boolean injection = false;
            String s = "";
            String result = "";
            for(int i=0; i<str.length(); i++){

                 injection = false;
                 s = ""+str.charAt(i);

                 for(int x=0; x<injectString.length; x++){
                     if(injectString[x].equals(s)){
                         injection = true;
                         break;
                     }
                 }

                 if(!injection)
                     result = result + s;
            }

            return result;

        }
   
       
       public static Member doLogin(String userId, String password){
            
           userId = removeInjection(userId);            
           password = removeInjection(password);
           
           Member member  = new Member();
           
           if(userId.length()>0 && password.length()>0){
               String where = colNames[COL_NO_MEMBER]+"='"+userId+"' and "+colNames[COL_NO_MEMBER]+"='"+password+"'";
               Vector v = list(0,0,where, "");
               if(v!=null && v.size()>0){
                   member = (Member)v.get(0);
               }
           }
           
           return member;           
           
       }
       
        
}
