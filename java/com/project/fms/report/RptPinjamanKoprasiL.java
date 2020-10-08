/*
 * RptPinjamanKoprasiL.java
 *
 * Created on July 10, 2009, 2:52 PM
 */

package com.project.fms.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptPinjamanKoprasiL extends Entity {
    
    /**
     * Holds value of property angsuran.
     */
    private int angsuran;
    private double angPokok;
    private double bunga;
    private double kwjbAngsuran;
    private double saldo;
    private Date tglJatuhTempo;
    
    /** Creates a new instance of RptPinjamanKoprasiL */
    public RptPinjamanKoprasiL() {
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
     * Getter for property kwjbAngsuran.
     * @return Value of property kwjbAngsuran.
     */
    public double getKwjbAngsuran() {
        return this.kwjbAngsuran;
    }
    
    /**
     * Setter for property kwjbAngsuran.
     * @param kwjbAngsuran New value of property kwjbAngsuran.
     */
    public void setKwjbAngsuran(double kwjbAngsuran) {
        this.kwjbAngsuran = kwjbAngsuran;
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
    
}
