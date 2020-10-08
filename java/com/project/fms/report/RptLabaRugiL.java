/*
 * RptLabaRugiL.java
 *
 * Created on September 27, 2009, 12:10 AM
 */

package com.project.fms.report;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author  Kyo
 */
public class RptLabaRugiL extends Entity {
    
    /**
     * Holds value of property keterangan.
     */
    private String keterangan;
    private double pertahun;
    private double targetSd;
    private double targetBulanIni;
    private double realSd;
    private double realBulanIni;
    private int type;
    
    /** Creates a new instance of RptLabaRugiL */
    public RptLabaRugiL() {
    }
    
    /**
     * Getter for property keterangan.
     * @return Value of property keterangan.
     */
    public String getKeterangan() {
        return this.keterangan;
    }
    
    /**
     * Setter for property keterangan.
     * @param keterangan New value of property keterangan.
     */
    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }
    
    /**
     * Getter for property pertahun.
     * @return Value of property pertahun.
     */
    public double getPertahun() {
        return this.pertahun;
    }
    
    /**
     * Setter for property pertahun.
     * @param pertahun New value of property pertahun.
     */
    public void setPertahun(double pertahun) {
        this.pertahun = pertahun;
    }
    
    /**
     * Getter for property targetSd.
     * @return Value of property targetSd.
     */
    public double getTargetSd() {
        return this.targetSd;
    }
    
    /**
     * Setter for property targetSd.
     * @param targetSd New value of property targetSd.
     */
    public void setTargetSd(double targetSd) {
        this.targetSd = targetSd;
    }
    
    /**
     * Getter for property targetBulanIni.
     * @return Value of property targetBulanIni.
     */
    public double getTargetBulanIni() {
        return this.targetBulanIni;
    }
    
    /**
     * Setter for property targetBulanIni.
     * @param targetBulanIni New value of property targetBulanIni.
     */
    public void setTargetBulanIni(double targetBulanIni) {
        this.targetBulanIni = targetBulanIni;
    }
    
    /**
     * Getter for property realSd.
     * @return Value of property realSd.
     */
    public double getRealSd() {
        return this.realSd;
    }
    
    /**
     * Setter for property realSd.
     * @param realSd New value of property realSd.
     */
    public void setRealSd(double realSd) {
        this.realSd = realSd;
    }
    
    /**
     * Getter for property realBulanIni.
     * @return Value of property realBulanIni.
     */
    public double getRealBulanIni() {
        return this.realBulanIni;
    }
    
    /**
     * Setter for property realBulanIni.
     * @param realBulanIni New value of property realBulanIni.
     */
    public void setRealBulanIni(double realBulanIni) {
        this.realBulanIni = realBulanIni;
    }
    
    /**
     * Getter for property type.
     * @return Value of property type.
     */
    public int getType() {
        return this.type;
    }
    
    /**
     * Setter for property type.
     * @param type New value of property type.
     */
    public void setType(int type) {
        this.type = type;
    }
    
}
