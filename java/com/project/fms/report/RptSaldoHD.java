/*
 * RptSalodHD.java
 *
 * Created on September 21, 2009, 1:46 PM
 */

package com.project.fms.report;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author  Kyo
 */
public class RptSaldoHD extends Entity {
    
    /**
     * Holds value of property unit.
     */
    private String unit;
    
    /**
     * Holds value of property uraian.
     */
    private String uraian;
    
    /**
     * Holds value of property totalTitipan.
     */
    private double totalTitipan;
    
    /**
     * Holds value of property totalBYMHD.
     */
    private double totalBYMHD;
    
    /**
     * Holds value of property periode.
     */
    private String periode;
    
    /**
     * Holds value of property account.
     */
    private String account;
    
    /**
     * Holds value of property name.
     */
    private String name;
    
    /** Creates a new instance of RptSalodHD */
    public RptSaldoHD() {
    }
    
    /**
     * Getter for property unit.
     * @return Value of property unit.
     */
    public String getUnit() {
        return this.unit;
    }
    
    /**
     * Setter for property unit.
     * @param unit New value of property unit.
     */
    public void setUnit(String unit) {
        this.unit = unit;
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
     * Getter for property totalTitipan.
     * @return Value of property totalTitipan.
     */
    public double getTotalTitipan() {
        return this.totalTitipan;
    }
    
    /**
     * Setter for property totalTitipan.
     * @param totalTitipan New value of property totalTitipan.
     */
    public void setTotalTitipan(double totalTitipan) {
        this.totalTitipan = totalTitipan;
    }
    
    /**
     * Getter for property totalBYMHD.
     * @return Value of property totalBYMHD.
     */
    public double getTotalBYMHD() {
        return this.totalBYMHD;
    }
    
    /**
     * Setter for property totalBYMHD.
     * @param totalBYMHD New value of property totalBYMHD.
     */
    public void setTotalBYMHD(double totalBYMHD) {
        this.totalBYMHD = totalBYMHD;
    }
    
    /**
     * Getter for property periode.
     * @return Value of property periode.
     */
    public String getPeriode() {
        return this.periode;
    }
    
    /**
     * Setter for property periode.
     * @param periode New value of property periode.
     */
    public void setPeriode(String periode) {
        this.periode = periode;
    }
    
    /**
     * Getter for property account.
     * @return Value of property account.
     */
    public String getAccount() {
        return this.account;
    }
    
    /**
     * Setter for property account.
     * @param account New value of property account.
     */
    public void setAccount(String account) {
        this.account = account;
    }
    
    /**
     * Getter for property name.
     * @return Value of property name.
     */
    public String getName() {
        return this.name;
    }
    
    /**
     * Setter for property name.
     * @param name New value of property name.
     */
    public void setName(String name) {
        this.name = name;
    }
    
}
