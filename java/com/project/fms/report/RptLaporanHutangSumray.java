/*
 * RptLaporanHutangSumrayL.java
 *
 * Created on July 15, 2009, 11:35 AM
 */

package com.project.fms.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptLaporanHutangSumray extends Entity {
    
    /**
     * Holds value of property totalPinjaman.
     */
    private double totalPinjaman;
    private double totalAngsuran;
    private double saldoPiutang;
    
    /** Creates a new instance of RptLaporanHutangSumrayL */
    public RptLaporanHutangSumray() {
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
