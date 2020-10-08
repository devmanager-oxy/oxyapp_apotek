

package com.project.coorp.member; 
 
import java.util.Date;
import com.project.main.entity.*;

public class Member extends Entity { 
	private String nama = "";
	private String alamat = "";
	private String kecamatan = "";
	private String kabupaten = "";
	private String note = "";
        private String phoneArea = "";
        private String phonePerusahaan = "";
        private String middle_nama = "";
        private String phone = "";
        private String hp = "";
        private String fax = "";
        private String zipCode = "";
        private String email = "";
        private String noMember;        
        
        /**
         * Holds value of property kabupatenId.
         */
        private long kabupatenId;
        
        /**
         * Holds value of property kecamatanId.
         */
        private long kecamatanId;
        
        /**
         * Holds value of property desaId.
         */
        private long desaId;
        
        /**
         * Holds value of property kotaId.
         */
        private long kotaId;
        
        /**
         * Holds value of property alamatPerusahaan.
         */
        private String alamatPerusahaan;
        
        /**
         * Holds value of property namaPerusahaan.
         */
        private String namaPerusahaan;
        
        /**
         * Holds value of property tglLahir.
         */
        private Date tglLahir;
        
        /**
         * Holds value of property status.
         */
        private int status;
        
        /**
         * Holds value of property jenisKelamin.
         */
        private int jenisKelamin;
        
        /**
         * Holds value of property agama.
         */
        private String agama;
        
        /**
         * Holds value of property namaAhliWaris.
         */
        private String namaAhliWaris;
        
        /**
         * Holds value of property namaPenanggung.
         */
        private String namaPenanggung;
        
        /**
         * Holds value of property pendidikan.
         */
        private String pendidikan;
        
        /**
         * Holds value of property sibuhar.
         */
        private int sibuhar;
        
        /**
         * Holds value of property simple.
         */
        private int simple;
        
        /**
         * Holds value of property siraya.
         */
        private int siraya;
        
        /**
         * Holds value of property simapan.
         */
        private int simapan;
        
        /**
         * Holds value of property simpRencana.
         */
        private int simpRencana;
        
        /**
         * Holds value of property sisuka.
         */
        private int sisuka;
        
        /**
         * Holds value of property kuk.
         */
        private int kuk;
        
        /**
         * Holds value of property kmp.
         */
        private int kmp;
        
        /**
         * Holds value of property kip.
         */
        private int kip;
        
        /**
         * Holds value of property ktm.
         */
        private int ktm;
        
        /**
         * Holds value of property kpp.
         */
        private int kpp;
        
        /**
         * Holds value of property kiperum.
         */
        private int kiperum;
        
        /**
         * Holds value of property khusus.
         */
        private int khusus;
        
        /**
         * Holds value of property kiper.
         */
        private int kiper;
        
        /**
         * Holds value of property pekerjaanId.
         */
        private long pekerjaanId;
        
        /**
         * Holds value of property tglMasuk.
         */
        private Date tglMasuk;
        
        /**
         * Holds value of property tglKeluar.
         */
        private Date tglKeluar;
        
        /**
         * Holds value of property tglPendidikan.
         */
        private Date tglPendidikan;
        
        /**
         * Holds value of property simpananPokok.
         */
        private double simpananPokok;
        
        /**
         * Holds value of property statusPegawai.
         */
        private int statusPegawai;
        
        /**
         * Holds value of property dinasId.
         */
        private long dinasId;
        
        /**
         * Holds value of property dinasUnitId.
         */
        private long dinasUnitId;
        
        /**
         * Holds value of property shuJan.
         */
        private double shuJan;
        
        /**
         * Holds value of property shuFeb.
         */
        private double shuFeb;
        
        /**
         * Holds value of property shuMar.
         */
        private double shuMar;
        
        /**
         * Holds value of property shuApr.
         */
        private double shuApr;
        
        /**
         * Holds value of property shuMay.
         */
        private double shuMay;
        
        /**
         * Holds value of property shuJun.
         */
        private double shuJun;
        
        /**
         * Holds value of property shuJul.
         */
        private double shuJul;
        
        /**
         * Holds value of property shuAug.
         */
        private double shuAug;
        
        /**
         * Holds value of property shuSep.
         */
        private double shuSep;
        
        /**
         * Holds value of property shuOct.
         */
        private double shuOct;
        
        /**
         * Holds value of property shuNov.
         */
        private double shuNov;
        
        /**
         * Holds value of property shuDec.
         */
        private double shuDec;
        
	public String getNama(){ 
		return nama; 
	} 

	public void setNama(String nama){ 
		if ( nama == null ) {
			nama = ""; 
		} 
		this.nama = nama; 
	} 

	public String getAlamat(){ 
		return alamat; 
	} 

	public void setAlamat(String alamat){ 
		if ( alamat == null ) {
			alamat = ""; 
		} 
		this.alamat = alamat; 
	} 

	public String getNote(){
            return note;
        } 

	public void setNote(String note){ 
		if ( note == null ) {
			note = ""; 
		} 
		this.note = note; 
	} 

        /**
         * Getter for property phone.
         * @return Value of property phone.
         */
        public String getPhone() {
            return this.phone;
        }
        
        /**
         * Setter for property phone.
         * @param phone New value of property phone.
         */
        public void setPhone(String phone) {
            this.phone = phone;
        }
        
        /**
         * Getter for property hp.
         * @return Value of property hp.
         */
        public String getHp() {
            return this.hp;
        }
        
        /**
         * Setter for property hp.
         * @param hp New value of property hp.
         */
        public void setHp(String hp) {
            this.hp = hp;
        }
        
        /**
         * Getter for property fax.
         * @return Value of property fax.
         */
        public String getFax() {
            return this.fax;
        }
        
        /**
         * Setter for property fax.
         * @param fax New value of property fax.
         */
        public void setFax(String fax) {
            this.fax = fax;
        }
        
        /**
         * Getter for property zipCode.
         * @return Value of property zipCode.
         */
        public String getZipCode() {
            return this.zipCode;
        }
        
        /**
         * Setter for property zipCode.
         * @param zipCode New value of property zipCode.
         */
        public void setZipCode(String zipCode) {
            this.zipCode = zipCode;
        }
        
        /**
         * Getter for property email.
         * @return Value of property email.
         */
        public String getEmail() {
            return this.email;
        }
        
        /**
         * Setter for property email.
         * @param email New value of property email.
         */
        public void setEmail(String email) {
            this.email = email;
        }
        
        /**
         * Getter for property phoneArea.
         * @return Value of property phoneArea.
         */
        public String getPhoneArea() {
            return this.phoneArea;
        }
        
        /**
         * Setter for property phoneArea.
         * @param phoneArea New value of property phoneArea.
         */
        public void setPhoneArea(String phoneArea) {
            this.phoneArea = phoneArea;
        }
        
        /**
         * Getter for property faxArea.
         * @return Value of property faxArea.
         */
        public String getPhonePerusahaan() {
            return this.phonePerusahaan;
        }
        
        /**
         * Setter for property faxArea.
         * @param faxArea New value of property faxArea.
         */
        public void setPhonePerusahaan(String phonePerusahaan) {
            this.phonePerusahaan = phonePerusahaan;
        }
        
        /**
         * Getter for property noMember.
         * @return Value of property noMember.
         */
        public String getNoMember() {
            return this.noMember;
        }
        
        /**
         * Setter for property noMember.
         * @param noMember New value of property noMember.
         */
        public void setNoMember(String noMember) {
            this.noMember = noMember;
        }
        
        /**
         * Getter for property kabupatenId.
         * @return Value of property kabupatenId.
         */
        public long getKabupatenId() {
            return this.kabupatenId;
        }
        
        /**
         * Setter for property kabupatenId.
         * @param kabupatenId New value of property kabupatenId.
         */
        public void setKabupatenId(long kabupatenId) {
            this.kabupatenId = kabupatenId;
        }
        
        /**
         * Getter for property kecamatanId.
         * @return Value of property kecamatanId.
         */
        public long getKecamatanId() {
            return this.kecamatanId;
        }
        
        /**
         * Setter for property kecamatanId.
         * @param kecamatanId New value of property kecamatanId.
         */
        public void setKecamatanId(long kecamatanId) {
            this.kecamatanId = kecamatanId;
        }
        
        /**
         * Getter for property desaId.
         * @return Value of property desaId.
         */
        public long getDesaId() {
            return this.desaId;
        }
        
        /**
         * Setter for property desaId.
         * @param desaId New value of property desaId.
         */
        public void setDesaId(long desaId) {
            this.desaId = desaId;
        }
        
        /**
         * Getter for property kotaId.
         * @return Value of property kotaId.
         */
        public long getKotaId() {
            return this.kotaId;
        }
        
        /**
         * Setter for property kotaId.
         * @param kotaId New value of property kotaId.
         */
        public void setKotaId(long kotaId) {
            this.kotaId = kotaId;
        }
        
        /**
         * Getter for property alamatPerusahaan.
         * @return Value of property alamatPerusahaan.
         */
        public String getAlamatPerusahaan() {
            return this.alamatPerusahaan;
        }
        
        /**
         * Setter for property alamatPerusahaan.
         * @param alamatPerusahaan New value of property alamatPerusahaan.
         */
        public void setAlamatPerusahaan(String alamatPerusahaan) {
            this.alamatPerusahaan = alamatPerusahaan;
        }
        
        /**
         * Getter for property namaPerusahaan.
         * @return Value of property namaPerusahaan.
         */
        public String getNamaPerusahaan() {
            return this.namaPerusahaan;
        }
        
        /**
         * Setter for property namaPerusahaan.
         * @param namaPerusahaan New value of property namaPerusahaan.
         */
        public void setNamaPerusahaan(String namaPerusahaan) {
            this.namaPerusahaan = namaPerusahaan;
        }
        
        /**
         * Getter for property tglRegistrasi.
         * @return Value of property tglRegistrasi.
         */
        public Date getTglLahir() {
            return this.tglLahir;
        }
        
        /**
         * Setter for property tglRegistrasi.
         * @param tglRegistrasi New value of property tglRegistrasi.
         */
        public void setTglLahir(Date tglLahir) {
            this.tglLahir = tglLahir;
        }
        
        /**
         * Getter for property status.
         * @return Value of property status.
         */
        public int getStatus() {
            return this.status;
        }
        
        /**
         * Setter for property status.
         * @param status New value of property status.
         */
        public void setStatus(int status) {
            this.status = status;
        }
        
        /**
         * Getter for property jenisKelamin.
         * @return Value of property jenisKelamin.
         */
        public int getJenisKelamin() {
            return this.jenisKelamin;
        }
        
        /**
         * Setter for property jenisKelamin.
         * @param jenisKelamin New value of property jenisKelamin.
         */
        public void setJenisKelamin(int jenisKelamin) {
            this.jenisKelamin = jenisKelamin;
        }
        
        /**
         * Getter for property agama.
         * @return Value of property agama.
         */
        public String getAgama() {
            return this.agama;
        }
        
        /**
         * Setter for property agama.
         * @param agama New value of property agama.
         */
        public void setAgama(String agama) {
            this.agama = agama;
        }
        
        /**
         * Getter for property namaAhliWaris.
         * @return Value of property namaAhliWaris.
         */
        public String getNamaAhliWaris() {
            return this.namaAhliWaris;
        }
        
        /**
         * Setter for property namaAhliWaris.
         * @param namaAhliWaris New value of property namaAhliWaris.
         */
        public void setNamaAhliWaris(String namaAhliWaris) {
            this.namaAhliWaris = namaAhliWaris;
        }
        
        /**
         * Getter for property namaPenanggung.
         * @return Value of property namaPenanggung.
         */
        public String getNamaPenanggung() {
            return this.namaPenanggung;
        }
        
        /**
         * Setter for property namaPenanggung.
         * @param namaPenanggung New value of property namaPenanggung.
         */
        public void setNamaPenanggung(String namaPenanggung) {
            this.namaPenanggung = namaPenanggung;
        }
        
        /**
         * Getter for property pendidikan.
         * @return Value of property pendidikan.
         */
        public String getPendidikan() {
            return this.pendidikan;
        }
        
        /**
         * Setter for property pendidikan.
         * @param pendidikan New value of property pendidikan.
         */
        public void setPendidikan(String pendidikan) {
            this.pendidikan = pendidikan;
        }
        
        /**
         * Getter for property sibuhar.
         * @return Value of property sibuhar.
         */
        public int getSibuhar() {
            return this.sibuhar;
        }
        
        /**
         * Setter for property sibuhar.
         * @param sibuhar New value of property sibuhar.
         */
        public void setSibuhar(int sibuhar) {
            this.sibuhar = sibuhar;
        }
        
        /**
         * Getter for property simple.
         * @return Value of property simple.
         */
        public int getSimple() {
            return this.simple;
        }
        
        /**
         * Setter for property simple.
         * @param simple New value of property simple.
         */
        public void setSimple(int simple) {
            this.simple = simple;
        }
        
        /**
         * Getter for property siraya.
         * @return Value of property siraya.
         */
        public int getSiraya() {
            return this.siraya;
        }
        
        /**
         * Setter for property siraya.
         * @param siraya New value of property siraya.
         */
        public void setSiraya(int siraya) {
            this.siraya = siraya;
        }
        
        /**
         * Getter for property simapan.
         * @return Value of property simapan.
         */
        public int getSimapan() {
            return this.simapan;
        }
        
        /**
         * Setter for property simapan.
         * @param simapan New value of property simapan.
         */
        public void setSimapan(int simapan) {
            this.simapan = simapan;
        }
        
        /**
         * Getter for property simpRencana.
         * @return Value of property simpRencana.
         */
        public int getSimpRencana() {
            return this.simpRencana;
        }
        
        /**
         * Setter for property simpRencana.
         * @param simpRencana New value of property simpRencana.
         */
        public void setSimpRencana(int simpRencana) {
            this.simpRencana = simpRencana;
        }
        
        /**
         * Getter for property sisuka.
         * @return Value of property sisuka.
         */
        public int getSisuka() {
            return this.sisuka;
        }
        
        /**
         * Setter for property sisuka.
         * @param sisuka New value of property sisuka.
         */
        public void setSisuka(int sisuka) {
            this.sisuka = sisuka;
        }
        
        /**
         * Getter for property kuk.
         * @return Value of property kuk.
         */
        public int getKuk() {
            return this.kuk;
        }
        
        /**
         * Setter for property kuk.
         * @param kuk New value of property kuk.
         */
        public void setKuk(int kuk) {
            this.kuk = kuk;
        }
        
        /**
         * Getter for property kmp.
         * @return Value of property kmp.
         */
        public int getKmp() {
            return this.kmp;
        }
        
        /**
         * Setter for property kmp.
         * @param kmp New value of property kmp.
         */
        public void setKmp(int kmp) {
            this.kmp = kmp;
        }
        
        /**
         * Getter for property kip.
         * @return Value of property kip.
         */
        public int getKip() {
            return this.kip;
        }
        
        /**
         * Setter for property kip.
         * @param kip New value of property kip.
         */
        public void setKip(int kip) {
            this.kip = kip;
        }
        
        /**
         * Getter for property ktm.
         * @return Value of property ktm.
         */
        public int getKtm() {
            return this.ktm;
        }
        
        /**
         * Setter for property ktm.
         * @param ktm New value of property ktm.
         */
        public void setKtm(int ktm) {
            this.ktm = ktm;
        }
        
        /**
         * Getter for property kpp.
         * @return Value of property kpp.
         */
        public int getKpp() {
            return this.kpp;
        }
        
        /**
         * Setter for property kpp.
         * @param kpp New value of property kpp.
         */
        public void setKpp(int kpp) {
            this.kpp = kpp;
        }
        
        /**
         * Getter for property kiperum.
         * @return Value of property kiperum.
         */
        public int getKiperum() {
            return this.kiperum;
        }
        
        /**
         * Setter for property kiperum.
         * @param kiperum New value of property kiperum.
         */
        public void setKiperum(int kiperum) {
            this.kiperum = kiperum;
        }
        
        /**
         * Getter for property khusus.
         * @return Value of property khusus.
         */
        public int getKhusus() {
            return this.khusus;
        }
        
        /**
         * Setter for property khusus.
         * @param khusus New value of property khusus.
         */
        public void setKhusus(int khusus) {
            this.khusus = khusus;
        }
        
        /**
         * Getter for property kiper.
         * @return Value of property kiper.
         */
        public int getKiper() {
            return this.kiper;
        }
        
        /**
         * Setter for property kiper.
         * @param kiper New value of property kiper.
         */
        public void setKiper(int kiper) {
            this.kiper = kiper;
        }
        
        /**
         * Getter for property pekerjaanId.
         * @return Value of property pekerjaanId.
         */
        public long getPekerjaanId() {
            return this.pekerjaanId;
        }
        
        /**
         * Setter for property pekerjaanId.
         * @param pekerjaanId New value of property pekerjaanId.
         */
        public void setPekerjaanId(long pekerjaanId) {
            this.pekerjaanId = pekerjaanId;
        }
        
        /**
         * Getter for property tglMasuk.
         * @return Value of property tglMasuk.
         */
        public Date getTglMasuk() {
            return this.tglMasuk;
        }
        
        /**
         * Setter for property tglMasuk.
         * @param tglMasuk New value of property tglMasuk.
         */
        public void setTglMasuk(Date tglMasuk) {
            this.tglMasuk = tglMasuk;
        }
        
        /**
         * Getter for property tglKeluar.
         * @return Value of property tglKeluar.
         */
        public Date getTglKeluar() {
            return this.tglKeluar;
        }
        
        /**
         * Setter for property tglKeluar.
         * @param tglKeluar New value of property tglKeluar.
         */
        public void setTglKeluar(Date tglKeluar) {
            this.tglKeluar = tglKeluar;
        }
        
        /**
         * Getter for property tglPendidikan.
         * @return Value of property tglPendidikan.
         */
        public Date getTglPendidikan() {
            return this.tglPendidikan;
        }
        
        /**
         * Setter for property tglPendidikan.
         * @param tglPendidikan New value of property tglPendidikan.
         */
        public void setTglPendidikan(Date tglPendidikan) {
            this.tglPendidikan = tglPendidikan;
        }
        
        /**
         * Getter for property simpananPokok.
         * @return Value of property simpananPokok.
         */
        public double getSimpananPokok() {
            return this.simpananPokok;
        }
        
        /**
         * Setter for property simpananPokok.
         * @param simpananPokok New value of property simpananPokok.
         */
        public void setSimpananPokok(double simpananPokok) {
            this.simpananPokok = simpananPokok;
        }
        
        /**
         * Getter for property statusPegawai.
         * @return Value of property statusPegawai.
         */
        public int getStatusPegawai() {
            return this.statusPegawai;
        }
        
        /**
         * Setter for property statusPegawai.
         * @param statusPegawai New value of property statusPegawai.
         */
        public void setStatusPegawai(int statusPegawai) {
            this.statusPegawai = statusPegawai;
        }
        
        /**
         * Getter for property dinasId.
         * @return Value of property dinasId.
         */
        public long getDinasId() {
            return this.dinasId;
        }
        
        /**
         * Setter for property dinasId.
         * @param dinasId New value of property dinasId.
         */
        public void setDinasId(long dinasId) {
            this.dinasId = dinasId;
        }
        
        /**
         * Getter for property dinasUnitId.
         * @return Value of property dinasUnitId.
         */
        public long getDinasUnitId() {
            return this.dinasUnitId;
        }
        
        /**
         * Setter for property dinasUnitId.
         * @param dinasUnitId New value of property dinasUnitId.
         */
        public void setDinasUnitId(long dinasUnitId) {
            this.dinasUnitId = dinasUnitId;
        }
        
        /**
         * Getter for property shuJan.
         * @return Value of property shuJan.
         */
        public double getShuJan() {
            return this.shuJan;
        }
        
        /**
         * Setter for property shuJan.
         * @param shuJan New value of property shuJan.
         */
        public void setShuJan(double shuJan) {
            this.shuJan = shuJan;
        }
        
        /**
         * Getter for property shuFeb.
         * @return Value of property shuFeb.
         */
        public double getShuFeb() {
            return this.shuFeb;
        }
        
        /**
         * Setter for property shuFeb.
         * @param shuFeb New value of property shuFeb.
         */
        public void setShuFeb(double shuFeb) {
            this.shuFeb = shuFeb;
        }
        
        /**
         * Getter for property shuMar.
         * @return Value of property shuMar.
         */
        public double getShuMar() {
            return this.shuMar;
        }
        
        /**
         * Setter for property shuMar.
         * @param shuMar New value of property shuMar.
         */
        public void setShuMar(double shuMar) {
            this.shuMar = shuMar;
        }
        
        /**
         * Getter for property shuApr.
         * @return Value of property shuApr.
         */
        public double getShuApr() {
            return this.shuApr;
        }
        
        /**
         * Setter for property shuApr.
         * @param shuApr New value of property shuApr.
         */
        public void setShuApr(double shuApr) {
            this.shuApr = shuApr;
        }
        
        /**
         * Getter for property shuMay.
         * @return Value of property shuMay.
         */
        public double getShuMay() {
            return this.shuMay;
        }
        
        /**
         * Setter for property shuMay.
         * @param shuMay New value of property shuMay.
         */
        public void setShuMay(double shuMay) {
            this.shuMay = shuMay;
        }
        
        /**
         * Getter for property shuJun.
         * @return Value of property shuJun.
         */
        public double getShuJun() {
            return this.shuJun;
        }
        
        /**
         * Setter for property shuJun.
         * @param shuJun New value of property shuJun.
         */
        public void setShuJun(double shuJun) {
            this.shuJun = shuJun;
        }
        
        /**
         * Getter for property shuJul.
         * @return Value of property shuJul.
         */
        public double getShuJul() {
            return this.shuJul;
        }
        
        /**
         * Setter for property shuJul.
         * @param shuJul New value of property shuJul.
         */
        public void setShuJul(double shuJul) {
            this.shuJul = shuJul;
        }
        
        /**
         * Getter for property shuAug.
         * @return Value of property shuAug.
         */
        public double getShuAug() {
            return this.shuAug;
        }
        
        /**
         * Setter for property shuAug.
         * @param shuAug New value of property shuAug.
         */
        public void setShuAug(double shuAug) {
            this.shuAug = shuAug;
        }
        
        /**
         * Getter for property shuSep.
         * @return Value of property shuSep.
         */
        public double getShuSep() {
            return this.shuSep;
        }
        
        /**
         * Setter for property shuSep.
         * @param shuSep New value of property shuSep.
         */
        public void setShuSep(double shuSep) {
            this.shuSep = shuSep;
        }
        
        /**
         * Getter for property shuOct.
         * @return Value of property shuOct.
         */
        public double getShuOct() {
            return this.shuOct;
        }
        
        /**
         * Setter for property shuOct.
         * @param shuOct New value of property shuOct.
         */
        public void setShuOct(double shuOct) {
            this.shuOct = shuOct;
        }
        
        /**
         * Getter for property shuNov.
         * @return Value of property shuNov.
         */
        public double getShuNov() {
            return this.shuNov;
        }
        
        /**
         * Setter for property shuNov.
         * @param shuNov New value of property shuNov.
         */
        public void setShuNov(double shuNov) {
            this.shuNov = shuNov;
        }
        
        /**
         * Getter for property shuDec.
         * @return Value of property shuDec.
         */
        public double getShuDec() {
            return this.shuDec;
        }
        
        /**
         * Setter for property shuDec.
         * @param shuDec New value of property shuDec.
         */
        public void setShuDec(double shuDec) {
            this.shuDec = shuDec;
        }
        
}
