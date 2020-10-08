/*
 * RptLaporanHutangDetail.java
 *
 * Created on July 15, 2009, 11:38 AM
 */

package com.project.fms.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptLaporanHutangDetail extends Entity {
    
    /**
     * Holds value of property bank.
     */
    private String bank;
    private String noRekening;
    private Date tanggal;
    private double totalPinjaman;
    private double totalAngsuran;
    private double saldoPiutang;
    
    /** Creates a new instance of RptLaporanHutangDetail */
    public RptLaporanHutangDetail() {
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
     * Getter for property saldoPiutang.
     * @return Value of property saldoPiutang.
     */
    public double getSaldoPiutang() {
        return this.saldoPiutang;
    }
    
    /**
     * Setter for property saldoPiutang.
     * @param saldoPiutang New value of property saldoPiutang.
     */
    public void setSaldoPiutang(double saldoPiutang) {
        this.saldoPiutang = saldoPiutang;
    }
    
}
