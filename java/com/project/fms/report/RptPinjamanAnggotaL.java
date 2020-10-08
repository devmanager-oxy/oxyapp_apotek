/*
 * RptPinjamanAnggotaL.java
 *
 * Created on July 13, 2009, 10:41 PM
 */

package com.project.fms.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptPinjamanAnggotaL extends Entity {
    
    /**
     * Holds value of property angPokok.
     */
    private double angPokok;
    private int angsuran;
    private double bunga;
    private double totalAngsuran;
    private double saldo;
    private Date tglJatuhTempo;
    
    /**
     * Holds value of property tglBayar.
     */
    private String tglBayar;
    
    /**
     * Holds value of property bayarPinjaman.
     */
    private double bayarPinjaman;
    
    /** Creates a new instance of RptPinjamanAnggotaL */
    public RptPinjamanAnggotaL() {
    }
    
    /**
     * Getter for property angPokok.
     * @return Value of property angPokok.
     */
    public double getAngPokok() {
        return this.angPokok;
    }
    
    /**
     * Setter for property angPokok.
     * @param angPokok New value of property angPokok.
     */
    public void setAngPokok(double angPokok) {
        this.angPokok = angPokok;
    }
    
    /**
     * Getter for property angsuran.
     * @return Value of property angsuran.
     */
    public int getAngsuran() {
        return this.angsuran;
    }
    
    /**
     * Setter for property angsuran.
     * @param angsuran New value of property angsuran.
     */
    public void setAngsuran(int angsuran) {
        this.angsuran = angsuran;
    }
    
    /**
     * Getter for property bunga.
     * @return Value of property bunga.
     */
    public double getBunga() {
        return this.bunga;
    }
    
    /**
     * Setter for property bunga.
     * @param bunga New value of property bunga.
     */
    public void setBunga(double bunga) {
        this.bunga = bunga;
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
     * Getter for property saldo.
     * @return Value of property saldo.
     */
    public double getSaldo() {
        return this.saldo;
    }
    
    /**
     * Setter for property saldo.
     * @param saldo New value of property saldo.
     */
    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }
    
    /**
     * Getter for property tglJatuhTempo.
     * @return Value of property tglJatuhTempo.
     */
    public Date getTglJatuhTempo() {
        return this.tglJatuhTempo;
    }
    
    /**
     * Setter for property tglJatuhTempo.
     * @param tglJatuhTempo New value of property tglJatuhTempo.
     */
    public void setTglJatuhTempo(Date tglJatuhTempo) {
        this.tglJatuhTempo = tglJatuhTempo;
    }
    
    /**
     * Getter for property tglBayar.
     * @return Value of property tglBayar.
     */
    public String getTglBayar() {
        return this.tglBayar;
    }
    
    /**
     * Setter for property tglBayar.
     * @param tglBayar New value of property tglBayar.
     */
    public void setTglBayar(String tglBayar) {
        this.tglBayar = tglBayar;
    }
    
    /**
     * Getter for property bayarPinjaman.
     * @return Value of property bayarPinjaman.
     */
    public double getBayarPinjaman() {
        return this.bayarPinjaman;
    }
    
    /**
     * Setter for property bayarPinjaman.
     * @param bayarPinjaman New value of property bayarPinjaman.
     */
    public void setBayarPinjaman(double bayarPinjaman) {
        this.bayarPinjaman = bayarPinjaman;
    }
    
}
