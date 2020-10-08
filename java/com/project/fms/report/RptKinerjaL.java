/*
 * RptKinerjaL.java
 *
 * Created on September 26, 2009, 1:26 PM
 */

package com.project.fms.report;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author  Kyo
 */
public class RptKinerjaL extends Entity {
    
    /**
     * Holds value of property targetTahun.
     */
    private double targetTahun;
    private double targetSd;
    private double targetBulanIni;
    private double realSd;
    private double realBulanIni;
    private double targetTahun2;
    private double realBulanIni2;
    private double realSd2;
    private double targetBulanIni2;
    private double targetSd2;
    private double realBulanIni3;
    private double realSd3;
    private double targetBulanIni3;
    private double targetSd3;
    private double targetTahun3;
    private double realBulanIni4;
    private double realSd4;
    private double targetBulanIni4;
    private double targetSd4;
    private double targetTahun4;
    
    /**
     * Holds value of property periode.
     */
    private String periode;
    
    /**
     * Holds value of property tahun.
     */
    private int tahun;
    
    /** Creates a new instance of RptKinerjaL */
    public RptKinerjaL() {
    }
    
    /**
     * Getter for property targetTahun.
     * @return Value of property targetTahun.
     */
    public double getTargetTahun() {
        return this.targetTahun;
    }
    
    /**
     * Setter for property targetTahun.
     * @param targetTahun New value of property targetTahun.
     */
    public void setTargetTahun(double targetTahun) {
        this.targetTahun = targetTahun;
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
     * Getter for property targetTahun2.
     * @return Value of property targetTahun2.
     */
    public double getTargetTahun2() {
        return this.targetTahun2;
    }
    
    /**
     * Setter for property targetTahun2.
     * @param targetTahun2 New value of property targetTahun2.
     */
    public void setTargetTahun2(double targetTahun2) {
        this.targetTahun2 = targetTahun2;
    }
    
    /**
     * Getter for property realBulanIni2.
     * @return Value of property realBulanIni2.
     */
    public double getRealBulanIni2() {
        return this.realBulanIni2;
    }
    
    /**
     * Setter for property realBulanIni2.
     * @param realBulanIni2 New value of property realBulanIni2.
     */
    public void setRealBulanIni2(double realBulanIni2) {
        this.realBulanIni2 = realBulanIni2;
    }
    
    /**
     * Getter for property realSd2.
     * @return Value of property realSd2.
     */
    public double getRealSd2() {
        return this.realSd2;
    }
    
    /**
     * Setter for property realSd2.
     * @param realSd2 New value of property realSd2.
     */
    public void setRealSd2(double realSd2) {
        this.realSd2 = realSd2;
    }
    
    /**
     * Getter for property targetBulanIni2.
     * @return Value of property targetBulanIni2.
     */
    public double getTargetBulanIni2() {
        return this.targetBulanIni2;
    }
    
    /**
     * Setter for property targetBulanIni2.
     * @param targetBulanIni2 New value of property targetBulanIni2.
     */
    public void setTargetBulanIni2(double targetBulanIni2) {
        this.targetBulanIni2 = targetBulanIni2;
    }
    
    /**
     * Getter for property targetSd2.
     * @return Value of property targetSd2.
     */
    public double getTargetSd2() {
        return this.targetSd2;
    }
    
    /**
     * Setter for property targetSd2.
     * @param targetSd2 New value of property targetSd2.
     */
    public void setTargetSd2(double targetSd2) {
        this.targetSd2 = targetSd2;
    }
    
    /**
     * Getter for property realBulanIni3.
     * @return Value of property realBulanIni3.
     */
    public double getRealBulanIni3() {
        return this.realBulanIni3;
    }
    
    /**
     * Setter for property realBulanIni3.
     * @param realBulanIni3 New value of property realBulanIni3.
     */
    public void setRealBulanIni3(double realBulanIni3) {
        this.realBulanIni3 = realBulanIni3;
    }
    
    /**
     * Getter for property realSd3.
     * @return Value of property realSd3.
     */
    public double getRealSd3() {
        return this.realSd3;
    }
    
    /**
     * Setter for property realSd3.
     * @param realSd3 New value of property realSd3.
     */
    public void setRealSd3(double realSd3) {
        this.realSd3 = realSd3;
    }
    
    /**
     * Getter for property targetBulanIni3.
     * @return Value of property targetBulanIni3.
     */
    public double getTargetBulanIni3() {
        return this.targetBulanIni3;
    }
    
    /**
     * Setter for property targetBulanIni3.
     * @param targetBulanIni3 New value of property targetBulanIni3.
     */
    public void setTargetBulanIni3(double targetBulanIni3) {
        this.targetBulanIni3 = targetBulanIni3;
    }
    
    /**
     * Getter for property targetSd3.
     * @return Value of property targetSd3.
     */
    public double getTargetSd3() {
        return this.targetSd3;
    }
    
    /**
     * Setter for property targetSd3.
     * @param targetSd3 New value of property targetSd3.
     */
    public void setTargetSd3(double targetSd3) {
        this.targetSd3 = targetSd3;
    }
    
    /**
     * Getter for property targetTahun3.
     * @return Value of property targetTahun3.
     */
    public double getTargetTahun3() {
        return this.targetTahun3;
    }
    
    /**
     * Setter for property targetTahun3.
     * @param targetTahun3 New value of property targetTahun3.
     */
    public void setTargetTahun3(double targetTahun3) {
        this.targetTahun3 = targetTahun3;
    }
    
    /**
     * Getter for property realBulanIni4.
     * @return Value of property realBulanIni4.
     */
    public double getRealBulanIni4() {
        return this.realBulanIni4;
    }
    
    /**
     * Setter for property realBulanIni4.
     * @param realBulanIni4 New value of property realBulanIni4.
     */
    public void setRealBulanIni4(double realBulanIni4) {
        this.realBulanIni4 = realBulanIni4;
    }
    
    /**
     * Getter for property realSd4.
     * @return Value of property realSd4.
     */
    public double getRealSd4() {
        return this.realSd4;
    }
    
    /**
     * Setter for property realSd4.
     * @param realSd4 New value of property realSd4.
     */
    public void setRealSd4(double realSd4) {
        this.realSd4 = realSd4;
    }
    
    /**
     * Getter for property targetBulanIni4.
     * @return Value of property targetBulanIni4.
     */
    public double getTargetBulanIni4() {
        return this.targetBulanIni4;
    }
    
    /**
     * Setter for property targetBulanIni4.
     * @param targetBulanIni4 New value of property targetBulanIni4.
     */
    public void setTargetBulanIni4(double targetBulanIni4) {
        this.targetBulanIni4 = targetBulanIni4;
    }
    
    /**
     * Getter for property targetSd4.
     * @return Value of property targetSd4.
     */
    public double getTargetSd4() {
        return this.targetSd4;
    }
    
    /**
     * Setter for property targetSd4.
     * @param targetSd4 New value of property targetSd4.
     */
    public void setTargetSd4(double targetSd4) {
        this.targetSd4 = targetSd4;
    }
    
    /**
     * Getter for property targetTahun4.
     * @return Value of property targetTahun4.
     */
    public double getTargetTahun4() {
        return this.targetTahun4;
    }
    
    /**
     * Setter for property targetTahun4.
     * @param targetTahun4 New value of property targetTahun4.
     */
    public void setTargetTahun4(double targetTahun4) {
        this.targetTahun4 = targetTahun4;
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
     * Getter for property tahun.
     * @return Value of property tahun.
     */
    public int getTahun() {
        return this.tahun;
    }
    
    /**
     * Setter for property tahun.
     * @param tahun New value of property tahun.
     */
    public void setTahun(int tahun) {
        this.tahun = tahun;
    }
    
}
