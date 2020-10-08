/*
 * RptPortofolio.java
 *
 * Created on September 25, 2009, 4:13 PM
 */

package com.project.fms.report;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author  Kyo
 */
public class RptPortofolio extends Entity {
    
    /**
     * Holds value of property periode.
     */
    private Date periode;
    private double totalTargetLaba;
    private double totalTargetLabaSd;
    private double totalTargetLabaBulanIni;
    private double totalPdptSd;
    private double totalBiayaSd;
    private double totalLabaSd;
    private double totalPersenLabaSd;
    private double totalTargetLabaBulanIni2;
    private double totalPdpt;
    private double totalBiaya;
    private double totalLaba;
    private double totalPersenLaba;
    
    /** Creates a new instance of RptPortofolio */
    public RptPortofolio() {
    }
    
    /**
     * Getter for property periode.
     * @return Value of property periode.
     */
    public Date getPeriode() {
        return this.periode;
    }
    
    /**
     * Setter for property periode.
     * @param periode New value of property periode.
     */
    public void setPeriode(Date periode) {
        this.periode = periode;
    }
    
    /**
     * Getter for property tTargetLaba.
     * @return Value of property tTargetLaba.
     */
    public double getTotalTargetLaba() {
        return this.totalTargetLaba;
    }
    
    /**
     * Setter for property tTargetLaba.
     * @param tTargetLaba New value of property tTargetLaba.
     */
    public void setTotalTargetLaba(double totalTargetLaba) {
        this.totalTargetLaba = totalTargetLaba;
    }
    
    /**
     * Getter for property totalTargetLabaSd.
     * @return Value of property totalTargetLabaSd.
     */
    public double getTotalTargetLabaSd() {
        return this.totalTargetLabaSd;
    }
    
    /**
     * Setter for property totalTargetLabaSd.
     * @param totalTargetLabaSd New value of property totalTargetLabaSd.
     */
    public void setTotalTargetLabaSd(double totalTargetLabaSd) {
        this.totalTargetLabaSd = totalTargetLabaSd;
    }
    
    /**
     * Getter for property totalTargetLabaBulanIni.
     * @return Value of property totalTargetLabaBulanIni.
     */
    public double getTotalTargetLabaBulanIni() {
        return this.totalTargetLabaBulanIni;
    }
    
    /**
     * Setter for property totalTargetLabaBulanIni.
     * @param totalTargetLabaBulanIni New value of property totalTargetLabaBulanIni.
     */
    public void setTotalTargetLabaBulanIni(double totalTargetLabaBulanIni) {
        this.totalTargetLabaBulanIni = totalTargetLabaBulanIni;
    }
    
    /**
     * Getter for property totalPdptSd.
     * @return Value of property totalPdptSd.
     */
    public double getTotalPdptSd() {
        return this.totalPdptSd;
    }
    
    /**
     * Setter for property totalPdptSd.
     * @param totalPdptSd New value of property totalPdptSd.
     */
    public void setTotalPdptSd(double totalPdptSd) {
        this.totalPdptSd = totalPdptSd;
    }
    
    /**
     * Getter for property totalBiayaSd.
     * @return Value of property totalBiayaSd.
     */
    public double getTotalBiayaSd() {
        return this.totalBiayaSd;
    }
    
    /**
     * Setter for property totalBiayaSd.
     * @param totalBiayaSd New value of property totalBiayaSd.
     */
    public void setTotalBiayaSd(double totalBiayaSd) {
        this.totalBiayaSd = totalBiayaSd;
    }
    
    /**
     * Getter for property totalLabaSd.
     * @return Value of property totalLabaSd.
     */
    public double getTotalLabaSd() {
        return this.totalLabaSd;
    }
    
    /**
     * Setter for property totalLabaSd.
     * @param totalLabaSd New value of property totalLabaSd.
     */
    public void setTotalLabaSd(double totalLabaSd) {
        this.totalLabaSd = totalLabaSd;
    }
    
    /**
     * Getter for property totalPersenLabaSd.
     * @return Value of property totalPersenLabaSd.
     */
    public double getTotalPersenLabaSd() {
        return this.totalPersenLabaSd;
    }
    
    /**
     * Setter for property totalPersenLabaSd.
     * @param totalPersenLabaSd New value of property totalPersenLabaSd.
     */
    public void setTotalPersenLabaSd(double totalPersenLabaSd) {
        this.totalPersenLabaSd = totalPersenLabaSd;
    }
    
    /**
     * Getter for property totalTargetLabaBulanIni2.
     * @return Value of property totalTargetLabaBulanIni2.
     */
    public double getTotalTargetLabaBulanIni2() {
        return this.totalTargetLabaBulanIni2;
    }
    
    /**
     * Setter for property totalTargetLabaBulanIni2.
     * @param totalTargetLabaBulanIni2 New value of property totalTargetLabaBulanIni2.
     */
    public void setTotalTargetLabaBulanIni2(double totalTargetLabaBulanIni2) {
        this.totalTargetLabaBulanIni2 = totalTargetLabaBulanIni2;
    }
    
    /**
     * Getter for property totalPdpt.
     * @return Value of property totalPdpt.
     */
    public double getTotalPdpt() {
        return this.totalPdpt;
    }
    
    /**
     * Setter for property totalPdpt.
     * @param totalPdpt New value of property totalPdpt.
     */
    public void setTotalPdpt(double totalPdpt) {
        this.totalPdpt = totalPdpt;
    }
    
    /**
     * Getter for property totalBiaya.
     * @return Value of property totalBiaya.
     */
    public double getTotalBiaya() {
        return this.totalBiaya;
    }
    
    /**
     * Setter for property totalBiaya.
     * @param totalBiaya New value of property totalBiaya.
     */
    public void setTotalBiaya(double totalBiaya) {
        this.totalBiaya = totalBiaya;
    }
    
    /**
     * Getter for property totalLaba.
     * @return Value of property totalLaba.
     */
    public double getTotalLaba() {
        return this.totalLaba;
    }
    
    /**
     * Setter for property totalLaba.
     * @param totalLaba New value of property totalLaba.
     */
    public void setTotalLaba(double totalLaba) {
        this.totalLaba = totalLaba;
    }
    
    /**
     * Getter for property totalPersenLaba.
     * @return Value of property totalPersenLaba.
     */
    public double getTotalPersenLaba() {
        return this.totalPersenLaba;
    }
    
    /**
     * Setter for property totalPersenLaba.
     * @param totalPersenLaba New value of property totalPersenLaba.
     */
    public void setTotalPersenLaba(double totalPersenLaba) {
        this.totalPersenLaba = totalPersenLaba;
    }
    
}
