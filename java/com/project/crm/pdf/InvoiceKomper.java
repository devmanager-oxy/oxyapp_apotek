/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.pdf;

/**
 *
 * @author gwawan
 */
public class InvoiceKomper {
    public static final int KOMPER_PERHITUNGAN = 0;
    public static final int KOMPER_INVOICE = 1;
    
    private String invoiceDesc = "";
    private String invoiceDueDate = "";
    private String invoiceDate = "";
    private String periode = "";
    private String namaBadan = "";
    private String namaKomersil = "";
    private String nomor = "";
    private String pNamaBadan = "";
    private String pNamaKomersil = "";
    private String pLot = "";
    private String ttdNama = "";
    private String ttdJabatan = "";
    private String jenisPendapatan = "";
    private String mataUang = "";
    private double pendapatan = 0;
    private double persenPendapatan = 0;
    private String catatan = "";
    private double totalKomin = 0;

    public String getCatatan() {
        return catatan;
    }

    public void setCatatan(String catatan) {
        this.catatan = catatan;
    }

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

    public String getJenisPendapatan() {
        return jenisPendapatan;
    }

    public void setJenisPendapatan(String jenisPendapatan) {
        this.jenisPendapatan = jenisPendapatan;
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

    public String getPeriode() {
        return periode;
    }

    public void setPeriode(String periode) {
        this.periode = periode;
    }

    public double getPersenPendapatan() {
        return persenPendapatan;
    }

    public void setPersenPendapatan(double persenPendapatan) {
        this.persenPendapatan = persenPendapatan;
    }

    public double getTotalKomin() {
        return totalKomin;
    }

    public void setTotalKomin(double totalKomin) {
        this.totalKomin = totalKomin;
    }

    public double getPendapatan() {
        return pendapatan;
    }

    public void setPendapatan(double pendapatan) {
        this.pendapatan = pendapatan;
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
