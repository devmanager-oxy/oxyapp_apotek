/*
 * RptStockOpnameL.java
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
public class RptStockOpnameL extends Entity {
    
    /**
     * Holds value of property name.
     */
    private String name;
    
    private double qtySystem;
    private double qtyReal;
    private String barcode;
    
    /** Creates a new instance of RptStockOpnameL */
    public RptStockOpnameL() {
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
    
    /**
     * Getter for property qtySystem.
     * @return Value of property qtySystem.
     */
    public double getQtySystem() {
        return this.qtySystem;
    }
    
    /**
     * Setter for property qtySystem.
     * @param qtySystem New value of property qtySystem.
     */
    public void setQtySystem(double qtySystem) {
        this.qtySystem = qtySystem;
    }
    
    /**
     * Getter for property qtyReal.
     * @return Value of property qtyReal.
     */
    public double getQtyReal() {
        return this.qtyReal;
    }
    
    /**
     * Setter for property qtyReal.
     * @param qtyReal New value of property qtyReal.
     */
    public void setQtyReal(double qtyReal) {
        this.qtyReal = qtyReal;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }
    
}
