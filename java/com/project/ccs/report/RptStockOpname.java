/*
 * RptStockOpname.java
 *
 * Created on July 21, 2009, 11:14 AM
 */

package com.project.ccs.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptStockOpname extends Entity {
    
    /**
     * Holds value of property number.
     */
    private String number;
    private String location;
    private Date tanggal;
    private double totalQtySystem;
    private double totalQtyReal;
    
    /**
     * Holds value of property notes.
     */
    private String notes;
    
    /** Creates a new instance of RptStockOpname */
    public RptStockOpname() {
    }
    
    /**
     * Getter for property number.
     * @return Value of property number.
     */
    public String getNumber() {
        return this.number;
    }
    
    /**
     * Setter for property number.
     * @param number New value of property number.
     */
    public void setNumber(String number) {
        this.number = number;
    }
    
    /**
     * Getter for property location.
     * @return Value of property location.
     */
    public String getLocation() {
        return this.location;
    }
    
    /**
     * Setter for property location.
     * @param location New value of property location.
     */
    public void setLocation(String location) {
        this.location = location;
    }
    
    /**
     * Getter for property tanggal.
     * @return Value of property tanggal.
     */
    public Date getTanggal() {
        return this.tanggal;
    }
    
    /**
     * Setter for property tanggal.
     * @param tanggal New value of property tanggal.
     */
    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }
    
    /**
     * Getter for property totalQtySystem.
     * @return Value of property totalQtySystem.
     */
    public double getTotalQtySystem() {
        return this.totalQtySystem;
    }
    
    /**
     * Setter for property totalQtySystem.
     * @param totalQtySystem New value of property totalQtySystem.
     */
    public void setTotalQtySystem(double totalQtySystem) {
        this.totalQtySystem = totalQtySystem;
    }
    
    /**
     * Getter for property totalQtyReal.
     * @return Value of property totalQtyReal.
     */
    public double getTotalQtyReal() {
        return this.totalQtyReal;
    }
    
    /**
     * Setter for property totalQtyReal.
     * @param totalQtyReal New value of property totalQtyReal.
     */
    public void setTotalQtyReal(double totalQtyReal) {
        this.totalQtyReal = totalQtyReal;
    }
    
    /**
     * Getter for property notes.
     * @return Value of property notes.
     */
    public String getNotes() {
        return this.notes;
    }
    
    /**
     * Setter for property notes.
     * @param notes New value of property notes.
     */
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
}
