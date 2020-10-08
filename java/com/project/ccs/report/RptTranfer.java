/*
 * RptTranfer.java
 *
 * Created on July 19, 2009, 1:18 PM
 */

package com.project.ccs.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptTranfer extends Entity {
    
    /**
     * Holds value of property number.
     */
    private String number;
    private Date tanggal;
    private String from;
    private String to;
    private String notes;
    private int totalQty;
    private double totalPrices;
    
    /** Creates a new instance of RptTranfer */
    public RptTranfer() {
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
     * Getter for property dari.
     * @return Value of property dari.
     */
    public String getFrom() {
        return this.from;
    }
    
    /**
     * Setter for property dari.
     * @param dari New value of property dari.
     */
    public void setFrom(String from) {
        this.from = from;
    }
    
    /**
     * Getter for property kepada.
     * @return Value of property kepada.
     */
    public String getTo() {
        return this.to;
    }
    
    /**
     * Setter for property kepada.
     * @param kepada New value of property kepada.
     */
    public void setTo(String to) {
        this.to = to;
    }
    
    /**
     * Getter for property catatan.
     * @return Value of property catatan.
     */
    public String getNotes() {
        return this.notes;
    }
    
    /**
     * Setter for property catatan.
     * @param catatan New value of property catatan.
     */
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    /**
     * Getter for property totalQty.
     * @return Value of property totalQty.
     */
    public int getTotalQty() {
        return this.totalQty;
    }
    
    /**
     * Setter for property totalQty.
     * @param totalQty New value of property totalQty.
     */
    public void setTotalQty(int totalQty) {
        this.totalQty = totalQty;
    }
    
    /**
     * Getter for property totalPrices.
     * @return Value of property totalPrices.
     */
    public double getTotalPrices() {
        return this.totalPrices;
    }
    
    /**
     * Setter for property totalPrices.
     * @param totalPrices New value of property totalPrices.
     */
    public void setTotalPrices(double totalPrices) {
        this.totalPrices = totalPrices;
    }
    
}
