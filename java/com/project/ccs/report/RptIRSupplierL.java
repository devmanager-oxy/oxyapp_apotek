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
public class RptIRSupplierL extends Entity {
    
    /**
     * Holds value of property doc.
     */
    private String doc;
    private String supplier;
    private double totalAmount;
    private int no;
    private double amount;
    private String recLocation;
    private double tax;
    private double discount;
    private Date date;
    
   
    
    /** Creates a new instance of RptPoSupplierL */
    public RptIRSupplierL() {
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

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getRecLocation() {
        return recLocation;
    }

    public void setRecLocation(String recLocation) {
        this.recLocation = recLocation;
    }

    public double getTax() {
        return tax;
    }

    public void setTax(double tax) {
        this.tax = tax;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

   
    

    
    
}
