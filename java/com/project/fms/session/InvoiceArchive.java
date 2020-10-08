/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;

import java.util.Date;

/**
 *
 * @author Roy
 */
public class InvoiceArchive {
    
    private String nomorInoice = "";
    private String nomorDo = "";
    private Date tanggal;
    private Date batasPembayaran;
    private String vendor = "";
    private long vendorId = 0;
    private double hutang = 0;
    private double terbayar = 0;
    private int status = 0;

    public String getNomorInoice() {
        return nomorInoice;
    }

    public void setNomorInoice(String nomorInoice) {
        this.nomorInoice = nomorInoice;
    }

    public String getNomorDo() {
        return nomorDo;
    }

    public void setNomorDo(String nomorDo) {
        this.nomorDo = nomorDo;
    }

    public Date getTanggal() {
        return tanggal;
    }

    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }

    public Date getBatasPembayaran() {
        return batasPembayaran;
    }

    public void setBatasPembayaran(Date batasPembayaran) {
        this.batasPembayaran = batasPembayaran;
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public double getHutang() {
        return hutang;
    }

    public void setHutang(double hutang) {
        this.hutang = hutang;
    }

    public double getTerbayar() {
        return terbayar;
    }

    public void setTerbayar(double terbayar) {
        this.terbayar = terbayar;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
