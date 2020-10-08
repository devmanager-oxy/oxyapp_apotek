/*
 * RptLaporanPiutangDetail.java
 *
 * Created on July 15, 2009, 1:04 PM
 */

package com.project.fms.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptLaporanPiutangDetail extends Entity {
    
    /**
     * Holds value of property nik.
     */
    private String nik;
    private String nama;
    private String noRekening;
    private Date tanggal;
    private double totalPinjaman;
    private double totalAngsuran;
    private double totalSaldo;
    
    /** Creates a new instance of RptLaporanPiutangDetail */
    public RptLaporanPiutangDetail() {
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
     * Getter for property nama.
     * @return Value of property nama.
     */
    public String getNama() {
        return this.nama;
    }
    
    /**
     * Setter for property nama.
     * @param nama New value of property nama.
     */
    public void setNama(String nama) {
        this.nama = nama;
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
    
    /**
     * Getter for property totalAngsuran.
     * @return Value of property totalAngsuran.
     */
    public double getTotalAngsuran() {
        return this.totalAngsuran;
    }
    
    /**
     * Setter for property totalAngsuran.
     * @param totalAngsuran New value of property totalAngsuran.
     */
    public void setTotalAngsuran(double totalAngsuran) {
        this.totalAngsuran = totalAngsuran;
    }
    
    /**
     * Getter for property totalSaldo.
     * @return Value of property totalSaldo.
     */
    public double getTotalSaldo() {
        return this.totalSaldo;
    }
    
    /**
     * Setter for property totalSaldo.
     * @param totalSaldo New value of property totalSaldo.
     */
    public void setTotalSaldo(double totalSaldo) {
        this.totalSaldo = totalSaldo;
    }
    
}
