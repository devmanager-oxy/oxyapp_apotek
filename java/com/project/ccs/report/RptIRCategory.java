/*
 * RptPoSupplier.java
 *
 * Created on August 6, 2009, 1:14 PM
 */

package com.project.ccs.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptIRCategory extends Entity {
    
    /**
     * Holds value of property location.
     */
    private String location;
    private String supplier;
    private String groupBy;
    private String docStatus;
    private Date requestStart;
    private Date requestEnd;
    private int ignored;
    
    /** Creates a new instance of RptPoSupplier */
    public RptIRCategory() {
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
     * Getter for property supplier.
     * @return Value of property supplier.
     */
    public String getSupplier() {
        return this.supplier;
    }
    
    /**
     * Setter for property supplier.
     * @param supplier New value of property supplier.
     */
    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }
    
    /**
     * Getter for property groupBy.
     * @return Value of property groupBy.
     */
    public String getGroupBy() {
        return this.groupBy;
    }
    
    /**
     * Setter for property groupBy.
     * @param groupBy New value of property groupBy.
     */
    public void setGroupBy(String groupBy) {
        this.groupBy = groupBy;
    }
    
    /**
     * Getter for property docStatus.
     * @return Value of property docStatus.
     */
    public String getDocStatus() {
        return this.docStatus;
    }
    
    /**
     * Setter for property docStatus.
     * @param docStatus New value of property docStatus.
     */
    public void setDocStatus(String docStatus) {
        this.docStatus = docStatus;
    }
    
    /**
     * Getter for property request.
     * @return Value of property request.
     */
    public Date getRequestStart() {
        return this.requestStart;
    }
    
    /**
     * Setter for property request.
     * @param request New value of property request.
     */
    public void setRequestStart(Date requestStart) {
        this.requestStart = requestStart;
    }
    
    /**
     * Getter for property requestEnd.
     * @return Value of property requestEnd.
     */
    public Date getRequestEnd() {
        return this.requestEnd;
    }
    
    /**
     * Setter for property requestEnd.
     * @param requestEnd New value of property requestEnd.
     */
    public void setRequestEnd(Date requestEnd) {
        this.requestEnd = requestEnd;
    }
    
    /**
     * Getter for property ignored.
     * @return Value of property ignored.
     */
    public int getIgnored() {
        return this.ignored;
    }
    
    /**
     * Setter for property ignored.
     * @param ignored New value of property ignored.
     */
    public void setIgnored(int ignored) {
        this.ignored = ignored;
    }
    
}
