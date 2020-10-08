/*
 * RptRasio.java
 *
 * Created on September 27, 2009, 5:32 PM
 */

package com.project.fms.report;

import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptRasio extends Entity {
    
    /**
     * Holds value of property periode.
     */
    private String periode;
    
    /**
     * Holds value of property tahun1.
     */
    private int tahun1;
    
    /**
     * Holds value of property tahun2.
     */
    private int tahun2;
    
    /** Creates a new instance of RptRasio */
    public RptRasio() {
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
     * Getter for property tahun1.
     * @return Value of property tahun1.
     */
    public int getTahun1() {
        return this.tahun1;
    }
    
    /**
     * Setter for property tahun1.
     * @param tahun1 New value of property tahun1.
     */
    public void setTahun1(int tahun1) {
        this.tahun1 = tahun1;
    }
    
    /**
     * Getter for property tahun2.
     * @return Value of property tahun2.
     */
    public int getTahun2() {
        return this.tahun2;
    }
    
    /**
     * Setter for property tahun2.
     * @param tahun2 New value of property tahun2.
     */
    public void setTahun2(int tahun2) {
        this.tahun2 = tahun2;
    }
    
}
