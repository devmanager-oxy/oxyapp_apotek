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
public class RptITSubCategoryL extends Entity {
    
    /**
     * Holds value of property doc.
     */
    private String doc;
    private String category;
    private double totalAmount;
    private int no;
    private double qty;
    
    /** Creates a new instance of RptPoSupplierL */
    public RptITSubCategoryL() {
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
    public String getCategory() {
        return this.category;
    }
    
    /**
     * Setter for property supplier.
     * @param supplier New value of property supplier.
     */
    public void setCategory(String category) {
        this.category = category;
    }
    
    /**
     * Getter for property totalAmount.
     * @return Value of property totalAmount.
     */
    public double getTotalAmount() {
        return this.totalAmount;
    }
    
    /**
     * Setter for property totalAmount.
     * @param totalAmount New value of property totalAmount.
     */
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
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
     * Getter for property qty.
     * @return Value of property qty.
     */
    public double getQty() {
        return this.qty;
    }
    
    /**
     * Setter for property qty.
     * @param qty New value of property qty.
     */
    public void setQty(double qty) {
        this.qty = qty;
    }
    
}
