/*
 * RptPoSupplierL.java
 *
 * Created on August 6, 2009, 1:15 PM
 */

package com.project.ccs.report;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class RptITLocationL extends Entity {
    
    /**
     * Holds value of property doc.
     */
    private String doc;
    private String toLocation;
    private String location;
    private int no;
    
    /**
     * Holds value of property totalDoc.
     */
    private double totalDoc;
    
    /** Creates a new instance of RptPoSupplierL */
    public RptITLocationL() {
    }
    
    /**
     * Getter for property doc.
     * @return Value of property doc.
     */
    public String getDoc() {
        return this.doc;
    }
    
    /**
     * Setter for property doc.
     * @param doc New value of property doc.
     */
    public void setDoc(String doc) {
        this.doc = doc;
    }
    
    /**
     * Getter for property supplier.
     * @return Value of property supplier.
     */
    public String getToLocation() {
        return this.toLocation;
    }
    
    /**
     * Setter for property supplier.
     * @param supplier New value of property supplier.
     */
    public void setToLocation(String toLocation) {
        this.toLocation = toLocation;
    }
    
    /**
     * Getter for property totalAmount.
     * @return Value of property totalAmount.
     */
    public String getLocation() {
        return this.location;
    }
    
    /**
     * Setter for property totalAmount.
     * @param totalAmount New value of property totalAmount.
     */
    public void setLocation(String location) {
        this.location = location;
    }
    
    /**
     * Getter for property no.
     * @return Value of property no.
     */
    public int getNo() {
        return this.no;
    }
    
    /**
     * Setter for property no.
     * @param no New value of property no.
     */
    public void setNo(int no) {
        this.no = no;
    }
    
    /**
     * Getter for property totalDoc.
     * @return Value of property totalDoc.
     */
    public double getTotalDoc() {
        return this.totalDoc;
    }
    
    /**
     * Setter for property totalDoc.
     * @param totalDoc New value of property totalDoc.
     */
    public void setTotalDoc(double totalDoc) {
        this.totalDoc = totalDoc;
    }
    
}
