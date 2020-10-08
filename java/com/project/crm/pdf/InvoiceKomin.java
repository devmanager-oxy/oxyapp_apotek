/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.pdf;

/**
 *
 * @author gwawan
 */
public class InvoiceKomin {
    private String invoiceDesc = "";
    private String invoiceDueDate = "";
    private String invoiceDate = "";
    private String namaBadan = "";
    private String namaKomersil = "";
    private String nomor = "";
    private String pNamaBadan = "";
    private String pNamaKomersil = "";
    private String pLot = "";
    private String perhitungan = "";
    private String mataUang = "";
    private String periode = "";
    private double tagihan = 0;
    private String masa = "";
    private String ttdNama = "";
    private String ttdJabatan = "";
    private String keterangan = "";

    public String getInvoiceDate() {
        return invoiceDate;
    }

    public void setInvoiceDate(String invoiceDate) {
        this.invoiceDate = invoiceDate;
    }

    public String getInvoiceDesc() {
        return invoiceDesc;
    }

    public void setInvoiceDesc(String invoiceDesc) {
        this.invoiceDesc = invoiceDesc;
    }

    public String getInvoiceDueDate() {
        return invoiceDueDate;
    }

    public void setInvoiceDueDate(String invoiceDueDate) {
        this.invoiceDueDate = invoiceDueDate;
    }

    public String getKeterangan() {
        return keterangan;
    }

    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }

    public String getMasa() {
        return masa;
    }

    public void setMasa(String masa) {
        this.masa = masa;
    }

    public String getMataUang() {
        return mataUang;
    }

    public void setMataUang(String mataUang) {
        this.mataUang = mataUang;
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

    public String getPLot() {
        return pLot;
    }

    public void setPLot(String pLot) {
        this.pLot = pLot;
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

    public String getPerhitungan() {
        return perhitungan;
    }

    public void setPerhitungan(String perhitungan) {
        this.perhitungan = perhitungan;
    }

    public String getPeriode() {
        return periode;
    }

    public void setPeriode(String periode) {
        this.periode = periode;
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
    
}
