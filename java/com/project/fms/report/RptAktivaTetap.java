/*
 * RptAktivaTetap.java
 *
 * Created on October 2, 2009, 12:53 PM
 */

package com.project.fms.report;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author  Kyo
 */
public class RptAktivaTetap extends Entity {
    
    /**
     * Holds value of property periode.
     */
    private String periode;
    private Date perolehanSd;
    private Date penyusutanPer;
    private Date penyusutanSaldo1;
    private Date penyusutanSo;
    private Date penyusutanSaldo2;
    private Date penyusutanSaldo3;
    private String title1; 
    private String title2;
    
    /** Creates a new instance of RptAktivaTetap */
    public RptAktivaTetap() {
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
     * Getter for property perolehanSd.
     * @return Value of property perolehanSd.
     */
    public Date getPerolehanSd() {
        return this.perolehanSd;
    }
    
    /**
     * Setter for property perolehanSd.
     * @param perolehanSd New value of property perolehanSd.
     */
    public void setPerolehanSd(Date perolehanSd) {
        this.perolehanSd = perolehanSd;
    }
    
    /**
     * Getter for property penyusutanPer.
     * @return Value of property penyusutanPer.
     */
    public Date getPenyusutanPer() {
        return this.penyusutanPer;
    }
    
    /**
     * Setter for property penyusutanPer.
     * @param penyusutanPer New value of property penyusutanPer.
     */
    public void setPenyusutanPer(Date penyusutanPer) {
        this.penyusutanPer = penyusutanPer;
    }
    
    /**
     * Getter for property penyusutanSaldo1.
     * @return Value of property penyusutanSaldo1.
     */
    public Date getPenyusutanSaldo1() {
        return this.penyusutanSaldo1;
    }
    
    /**
     * Setter for property penyusutanSaldo1.
     * @param penyusutanSaldo1 New value of property penyusutanSaldo1.
     */
    public void setPenyusutanSaldo1(Date penyusutanSaldo1) {
        this.penyusutanSaldo1 = penyusutanSaldo1;
    }
    
    /**
     * Getter for property penyusutanSo.
     * @return Value of property penyusutanSo.
     */
    public Date getPenyusutanSo() {
        return this.penyusutanSo;
    }
    
    /**
     * Setter for property penyusutanSo.
     * @param penyusutanSo New value of property penyusutanSo.
     */
    public void setPenyusutanSo(Date penyusutanSo) {
        this.penyusutanSo = penyusutanSo;
    }
    
    /**
     * Getter for property penyusutanSaldo2.
     * @return Value of property penyusutanSaldo2.
     */
    public Date getPenyusutanSaldo2() {
        return this.penyusutanSaldo2;
    }
    
    /**
     * Setter for property penyusutanSaldo2.
     * @param penyusutanSaldo2 New value of property penyusutanSaldo2.
     */
    public void setPenyusutanSaldo2(Date penyusutanSaldo2) {
        this.penyusutanSaldo2 = penyusutanSaldo2;
    }
    
    /**
     * Getter for property penyusutanSaldo3.
     * @return Value of property penyusutanSaldo3.
     */
    public Date getPenyusutanSaldo3() {
        return this.penyusutanSaldo3;
    }
    
    /**
     * Setter for property penyusutanSaldo3.
     * @param penyusutanSaldo3 New value of property penyusutanSaldo3.
     */
    public void setPenyusutanSaldo3(Date penyusutanSaldo3) {
        this.penyusutanSaldo3 = penyusutanSaldo3;
    }
    
    /**
     * Getter for property title1.
     * @return Value of property title1.
     */
    public String getTitle1() {
        return this.title1;
    }
    
    /**
     * Setter for property title1.
     * @param title1 New value of property title1.
     */
    public void setTitle1(String title1) {
        this.title1 = title1;
    }
    
    /**
     * Getter for property title2.
     * @return Value of property title2.
     */
    public String getTitle2() {
        return this.title2;
    }
    
    /**
     * Setter for property title2.
     * @param title2 New value of property title2.
     */
    public void setTitle2(String title2) {
        this.title2 = title2;
    }
    
}
