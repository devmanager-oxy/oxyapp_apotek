/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.report;

import java.util.Date;

/**
 *
 * @author Roy Andika
 */


public class Arsip {
    
    private long pembayaranId = 0;
    private int typePembayaran = 0;
    private String noInvoice = "";
    private String noPembayaran = ""; //bkm
    private long customerId ;
    private Date tglMulai;
    private Date tglSelesai;
    private Date tanggal;
    private String customer = "";
    private String kwitansi = "";   
    private int transaction_source = 0;   
    private long mataUangId;
    private double jumlahPembayaran;
    private long irigasiId;
    private long limbahId;

    public int getTypePembayaran() {
        return typePembayaran;
    }

    public void setTypePembayaran(int typePembayaran) {
        this.typePembayaran = typePembayaran;
    }

    public String getNoInvoice() {
        return noInvoice;
    }

    public void setNoInvoice(String noInvoice) {
        this.noInvoice = noInvoice;
    }

    public String getNoPembayaran() {
        return noPembayaran;
    }

    public void setNoPembayaran(String noPembayaran) {
        this.noPembayaran = noPembayaran;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public Date getTglMulai() {
        return tglMulai;
    }

    public void setTglMulai(Date tglMulai) {
        this.tglMulai = tglMulai;
    }

    public Date getTglSelesai() {
        return tglSelesai;
    }

    public void setTglSelesai(Date tglSelesai) {
        this.tglSelesai = tglSelesai;
    }

    public long getPembayaranId() {
        return pembayaranId;
    }

    public void setPembayaranId(long pembayaranId) {
        this.pembayaranId = pembayaranId;
    }

    public String getCustomer() {
        return customer;
    }

    public void setCustomer(String customer) {
        this.customer = customer;
    }

    public String getKwitansi() {
        return kwitansi;
    }

    public void setKwitansi(String kwitansi) {
        this.kwitansi = kwitansi;
    }

    public Date getTanggal() {
        return tanggal;
    }

    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }

    public int getTransaction_source() {
        return transaction_source;
    }

    public void setTransaction_source(int transaction_source) {
        this.transaction_source = transaction_source;
    }

    public long getMataUangId() {
        return mataUangId;
    }

    public void setMataUangId(long mataUangId) {
        this.mataUangId = mataUangId;
    }

    public double getJumlahPembayaran() {
        return jumlahPembayaran;
    }

    public void setJumlahPembayaran(double jumlahPembayaran) {
        this.jumlahPembayaran = jumlahPembayaran;
    }

    public long getIrigasiId() {
        return irigasiId;
    }

    public void setIrigasiId(long irigasiId) {
        this.irigasiId = irigasiId;
    }

    public long getLimbahId() {
        return limbahId;
    }

    public void setLimbahId(long limbahId) {
        this.limbahId = limbahId;
    }
    
}
