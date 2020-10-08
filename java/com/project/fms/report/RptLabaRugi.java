/*
 * RptLabaRugi.java
 *
 * Created on September 27, 2009, 1:13 AM
 */

package com.project.fms.report;

import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptLabaRugi extends Entity {
    
    /**
     * Holds value of property periode.
     */
    private String periode;
    
    /**
     * Holds value of property tahun.
     */
    private int tahun;
    
    /** Creates a new instance of RptLabaRugi */
    public RptLabaRugi() {
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
