/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.pdf;

/**
 *
 * @author gwawan
 */
public class InvoiceUPAL {
    private int invoiceType = 0;
    private String invoiceDesc = "";
    private String invoiceDate = "";
    private String namaBadan = "";
    private String namaKomersil = "";
    private String alamatBadan = "";
    private String npwp = "";
    private String nomor = "";
    private String periode = "";
    private String pNamaBadan = "";
    private String pAlamatBadan = "";
    private String pNamaKomersil = "";
    private String pNPWP = "";
    private double tagihan = 0;
    private String strTagihan = "";
    private String rekening = "";
    private String ttdNama = "";
    private String ttdJabatan = "";
    private double bulanIni = 0;
    private double bulanLalu = 0;
    private double pemakaian = 0;
    private double persenPemakaian = 0;
    private double harga = 0;
    private String noFaktur = "";
    private double ppn = 0;
    
    public static int InvoiceLimbah = 0;
    public static int InvoiceIrigasi = 1;

    public int getInvoiceType() {
        return invoiceType;
    }

    public void setInvoiceType(int invoiceType) {
        this.invoiceType = invoiceType;
    }

    public String getInvoiceDesc() {
        return invoiceDesc;
    }

    public void setInvoiceDesc(String invoiceDesc) {
        this.invoiceDesc = invoiceDesc;
    }

    public String getInvoiceDate() {
        return invoiceDate;
    }

    public void setInvoiceDate(String invoiceDate) {
        this.invoiceDate = invoiceDate;
    }

    public String getAlamatBadan() {
        return alamatBadan;
    }

    public void setAlamatBadan(String alamatBadan) {
        this.alamatBadan = alamatBadan;
    }

    public double getBulanIni() {
        return bulanIni;
    }

    public void setBulanIni(double bulanIni) {
        this.bulanIni = bulanIni;
    }

    public double getBulanLalu() {
        return bulanLalu;
    }

    public void setBulanLalu(double bulanLalu) {
        this.bulanLalu = bulanLalu;
    }

    public double getHarga() {
        return harga;
    }

    public void setHarga(double harga) {
        this.harga = harga;
    }

    public String getNamaBadan() {
        return namaBadan;
    }

    public void setNamaBadan(String namaBadan) {
        this.namaBadan = namaBadan;
    }

    public String getNamaKomersil() {
        return namaKomersil;
    }

    public void setNamaKomersil(String namaKomersil) {
        this.namaKomersil = namaKomersil;
    }

    public String getNomor() {
        return nomor;
    }

    public void setNomor(String nomor) {
        this.nomor = nomor;
    }

    public String getNpwp() {
        return npwp;
    }

    public void setNpwp(String npwp) {
        this.npwp = npwp;
    }

    public String getPAlamatBadan() {
        return pAlamatBadan;
    }

    public void setPAlamatBadan(String pAlamatBadan) {
        this.pAlamatBadan = pAlamatBadan;
    }

    public String getPNPWP() {
        return pNPWP;
    }

    public void setPNPWP(String pNPWP) {
        this.pNPWP = pNPWP;
    }

    public String getPNamaBadan() {
        return pNamaBadan;
    }

    public void setPNamaBadan(String pNamaBadan) {
        this.pNamaBadan = pNamaBadan;
    }

    public String getPNamaKomersil() {
        return pNamaKomersil;
    }

    public void setPNamaKomersil(String pNamaKomersil) {
        this.pNamaKomersil = pNamaKomersil;
    }

    public double getPemakaian() {
        return pemakaian;
    }

    public void setPemakaian(double pemakaian) {
        this.pemakaian = pemakaian;
    }

    public String getPeriode() {
        return periode;
    }

    public void setPeriode(String periode) {
        this.periode = periode;
    }

    public double getPersenPemakaian() {
        return persenPemakaian;
    }

    public void setPersenPemakaian(double persenPemakaian) {
        this.persenPemakaian = persenPemakaian;
    }

    public String getRekening() {
        return rekening;
    }

    public void setRekening(String rekening) {
        this.rekening = rekening;
    }

    public String getStrTagihan() {
        return strTagihan;
    }

    public void setStrTagihan(String strTagihan) {
        this.strTagihan = strTagihan;
    }

    public double getTagihan() {
        return tagihan;
    }

    public void setTagihan(double tagihan) {
        this.tagihan = tagihan;
    }

    public String getTtdJabatan() {
        return ttdJabatan;
    }

    public void setTtdJabatan(String ttdJabatan) {
        this.ttdJabatan = ttdJabatan;
    }

    public String getTtdNama() {
        return ttdNama;
    }

    public void setTtdNama(String ttdNama) {
        this.ttdNama = ttdNama;
    }

    public String getNoFaktur() {
        return noFaktur;
    }

    public void setNoFaktur(String noFaktur) {
        this.noFaktur = noFaktur;
    }

    public double getPpn() {
        return ppn;
    }

    public void setPpn(double ppn) {
        this.ppn = ppn;
    }

}
