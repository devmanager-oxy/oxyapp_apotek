/*
 * RptLaporanPiutangSumray.java
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
public class RptLaporanPiutangSumray {
    
    /**
     * Holds value of property nik.
     */
    private String nik;
    private String nama;
    private double totalAngsuran;
    private double totalPinjaman;
    private double totalSaldo;
    
    /** Creates a new instance of RptLaporanPiutangSumray */
    public RptLaporanPiutangSumray() {
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
