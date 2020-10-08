/*
 * RptAnggotaPinjamBank.java
 *
 * Created on July 14, 2009, 2:09 PM
 */

package com.project.fms.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptAnggotaPinjamBank extends Entity {
    
    /**
     * Holds value of property nik.
     */
    private String nik;
    private String peminjam;
    private String bank;
    private Date tanggal;
    private double totalPinjaman;
    private String noRekening;
    private double bungaPinjaman;
    private int lamaAngsuran;
    
    /** Creates a new instance of RptAnggotaPinjamBank */
    public RptAnggotaPinjamBank() {
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
     * Getter for property bank.
     * @return Value of property bank.
     */
    public String getBank() {
        return this.bank;
    }
    
    /**
     * Setter for property bank.
     * @param bank New value of property bank.
     */
    public void setBank(String bank) {
        this.bank = bank;
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
    
}
