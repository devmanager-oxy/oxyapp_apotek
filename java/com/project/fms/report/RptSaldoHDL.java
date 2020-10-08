/*
 * RptSaldoHDL.java
 *
 * Created on September 21, 2009, 1:58 PM
 */

package com.project.fms.report;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author  Kyo
 */
public class RptSaldoHDL extends Entity {
    
    /**
     * Holds value of property uraian.
     */
    private String uraian;
    
    /**
     * Holds value of property saldoTitipan.
     */
    private double saldoTitipan;
    
    /**
     * Holds value of property unitBYMHD.
     */
    private String unitBYMHD;
    
    /**
     * Holds value of property saldoBYMHD.
     */
    private double saldoBYMHD;
    
    /** Creates a new instance of RptSaldoHDL */
    public RptSaldoHDL() {
    }
    
    /**
     * Getter for property uraian.
     * @return Value of property uraian.
     */
    public String getUraian() {
        return this.uraian;
    }
    
    /**
     * Setter for property uraian.
     * @param uraian New value of property uraian.
     */
    public void setUraian(String uraian) {
        this.uraian = uraian;
    }
    
    /**
     * Getter for property saldoTitipan.
     * @return Value of property saldoTitipan.
     */
    public double getSaldoTitipan() {
        return this.saldoTitipan;
    }
    
    /**
     * Setter for property saldoTitipan.
     * @param saldoTitipan New value of property saldoTitipan.
     */
    public void setSaldoTitipan(double saldoTitipan) {
        this.saldoTitipan = saldoTitipan;
    }
    
    /**
     * Getter for property unit.
     * @return Value of property unit.
     */
    public String getUnitBYMHD() {
        return this.unitBYMHD;
    }
    
    /**
     * Setter for property unit.
     * @param unit New value of property unit.
     */
    public void setUnitBYMHD(String unitBYMHD) {
        this.unitBYMHD = unitBYMHD;
    }
    
    /**
     * Getter for property saldoBYMHD.
     * @return Value of property saldoBYMHD.
     */
    public double getSaldoBYMHD() {
        return this.saldoBYMHD;
    }
    
    /**
     * Setter for property saldoBYMHD.
     * @param saldoBYMHD New value of property saldoBYMHD.
     */
    public void setSaldoBYMHD(double saldoBYMHD) {
        this.saldoBYMHD = saldoBYMHD;
    }
    
}
