/*
 * InvoiceSrc.java
 *
 * Created on January 16, 2008, 1:34 PM
 */

package com.project.fms.transaction;

import java.util.Date;

/**
 *
 * @author  Valued Customer
 */
public class InvoiceSrc {
    
    /**
     * Holds value of property vendorId.
     */
    private long vendorId;
    
    /**
     * Holds value of property poNumber.
     */
    private String poNumber;
    
    /**
     * Holds value of property vndInvNumber.
     */
    private String vndInvNumber;
    
    /**
     * Holds value of property dueDate.
     */
    private Date dueDate;
    
    /**
     * Holds value of property overDue.
     */
    private int overDue;
    
    /** Creates a new instance of InvoiceSrc */
    
    private int statusOverdue = 0;
    
    private String locationId = "";
    
    private String invNumber = "";
    
    public InvoiceSrc() {
    }
    
    /**
     * Getter for property vendorId.
     * @return Value of property vendorId.
     */
    public long getVendorId() {
        return this.vendorId;
    }
    
    /**
     * Setter for property vendorId.
     * @param vendorId New value of property vendorId.
     */
    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }
    
    /**
     * Getter for property poNumber.
     * @return Value of property poNumber.
     */
    public String getPoNumber() {
        return this.poNumber;
    }
    
    /**
     * Setter for property poNumber.
     * @param poNumber New value of property poNumber.
     */
    public void setPoNumber(String poNumber) {
        this.poNumber = poNumber;
    }
    
    /**
     * Getter for property vndInvNumber.
     * @return Value of property vndInvNumber.
     */
    public String getVndInvNumber() {
        return this.vndInvNumber;
    }
    
    /**
     * Setter for property vndInvNumber.
     * @param vndInvNumber New value of property vndInvNumber.
     */
    public void setVndInvNumber(String vndInvNumber) {
        this.vndInvNumber = vndInvNumber;
    }
    
    /**
     * Getter for property dueDate.
     * @return Value of property dueDate.
     */
    public Date getDueDate() {
        return this.dueDate;
    }
    
    /**
     * Setter for property dueDate.
     * @param dueDate New value of property dueDate.
     */
    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }
    
    /**
     * Getter for property overDue.
     * @return Value of property overDue.
     */
    public int getOverDue() {
        return this.overDue;
    }
    
    /**
     * Setter for property overDue.
     * @param overDue New value of property overDue.
     */
    public void setOverDue(int overDue) {
        this.overDue = overDue;
    }

    public int getStatusOverdue() {
        return statusOverdue;
    }

    public void setStatusOverdue(int statusOverdue) {
        this.statusOverdue = statusOverdue;
    }

    public String getLocationId() {
        return locationId;
    }

    public void setLocationId(String locationId) {
        this.locationId = locationId;
    }

    public String getInvNumber() {
        return invNumber;
    }

    public void setInvNumber(String invNumber) {
        this.invNumber = invNumber;
    }
    
}
