/*
 * RptPinjamanAnggota.java
 *
 * Created on July 13, 2009, 10:40 PM
 */

package com.project.fms.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptPinjamanAnggota extends Entity {
    
    /**
     * Holds value of property peminjam.
     */
    private String peminjam;
    private String nik;
    private double bungaPinjaman;
    private int lamaAngsuran;
    private String noRekening;
    private Date tanggal;
    private double totalPinjaman;
    
    /** Creates a new instance of RptPinjamanAnggota */
    public RptPinjamanAnggota() {
    }
    
    /**
     * Getter for property peminjam.
     * @return Value of property peminjam.
     */
    public String getPeminjam() {
        return this.peminjam;
    }
    
    /**
     * Setter for property peminjam.
     * @param peminjam New value of property peminjam.
     */
    public void setPeminjam(String peminjam) {
        this.peminjam = peminjam;
    }
    
    /**
     * Getter for property nik.
     * @return Value of property nik.
     */
    public String getNik() {
        return this.nik;
    }
    
    /**
     * Setter for property nik.
     * @param nik New value of property nik.
     */
    public void setNik(String nik) {
        this.nik = nik;
    }
    
    /**
     * Getter for property bungaPinjaman.
     * @return Value of property bungaPinjaman.
     */
    public double getBungaPinjaman() {
        return this.bungaPinjaman;
    }
    
    /**
     * Setter for property bungaPinjaman.
     * @param bungaPinjaman New value of property bungaPinjaman.
     */
    public void setBungaPinjaman(double bungaPinjaman) {
        this.bungaPinjaman = bungaPinjaman;
    }
    
    /**
     * Getter for property lamaAngsuran.
     * @return Value of property lamaAngsuran.
     */
    public int getLamaAngsuran() {
        return this.lamaAngsuran;
    }
    
    /**
     * Setter for property lamaAngsuran.
     * @param lamaAngsuran New value of property lamaAngsuran.
     */
    public void setLamaAngsuran(int lamaAngsuran) {
        this.lamaAngsuran = lamaAngsuran;
    }
    
    /**
     * Getter for property noRekening.
     * @return Value of property noRekening.
     */
    public String getNoRekening() {
        return this.noRekening;
    }
    
    /**
     * Setter for property noRekening.
     * @param noRekening New value of property noRekening.
     */
    public void setNoRekening(String noRekening) {
        this.noRekening = noRekening;
    }
    
    /**
     * Getter for property tanggal.
     * @return Value of property tanggal.
     */
    public Date getTanggal() {
        return this.tanggal;
    }
    
    /**
     * Setter for property tanggal.
     * @param tanggal New value of property tanggal.
     */
    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }
    
    /**
     * Getter for property totalPinjaman.
     * @return Value of property totalPinjaman.
     */
    public double getTotalPinjaman() {
        return this.totalPinjaman;
    }
    
    /**
     * Setter for property totalPinjaman.
     * @param totalPinjaman New value of property totalPinjaman.
     */
    public void setTotalPinjaman(double totalPinjaman) {
        this.totalPinjaman = totalPinjaman;
    }
    
}
