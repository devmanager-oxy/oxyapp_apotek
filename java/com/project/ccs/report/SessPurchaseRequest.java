/*
 * SessPurchaseRequest.java
 *
 * Created on January 16, 2009, 9:54 PM
 */

package com.project.ccs.report;

import java.util.*;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class SessPurchaseRequest extends Entity {
    
    /**
     * Holds value of property department.
     */
    private String department;
    
    /**
     * Holds value of property date.
     */
    private Date date;
    
    /**
     * Holds value of property notes.
     */
    private String notes;
    
    /**
     * Holds value of property number.
     */
    private String number;
    
    /** Creates a new instance of SessPurchaseRequest */
    public SessPurchaseRequest() {
    }
    
    /**
     * Getter for property department.
     * @return Value of property department.
     */
    public String getDepartment() {
        return this.department;
    }
    
    /**
     * Setter for property department.
     * @param department New value of property department.
     */
    public void setDepartment(String department) {
        this.department = department;
    }
    
    /**
     * Getter for property date.
     * @return Value of property date.
     */
    public Date getDate() {
        return this.date;
    }
    
    /**
     * Setter for property date.
     * @param date New value of property date.
     */
    public void setDate(Date date) {
        this.date = date;
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
    
}
