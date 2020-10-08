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
public class RptIRItemL extends Entity {
    
    /**
     * Holds value of property noPo.
     */
    private String noPo;
    private String name;
    private double totalAmount;
    private int no;
    private double qty;
    private String code;
    
    /** Creates a new instance of RptPoSupplierL */
    public RptIRItemL() {
    }
    
    /**
     * Getter for property doc.
     * @return Value of property doc.
     */
    public String getNoPo() {
        return this.noPo;
    }
    
    /**
     * Setter for property doc.
     * @param doc New value of property doc.
     */
    public void setNoPo(String noPo) {
        this.noPo = noPo;
    }
    
    /**
     * Getter for property supplier.
     * @return Value of property supplier.
     */
    public String getName() {
        return this.name;
    }
    
    /**
     * Setter for property supplier.
     * @param supplier New value of property supplier.
     */
    public void setName(String name) {
        this.name = name;
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
    
    /**
     * Getter for property code.
     * @return Value of property code.
     */
    public String getCode() {
        return this.code;
    }
    
    /**
     * Setter for property code.
     * @param code New value of property code.
     */
    public void setCode(String code) {
        this.code = code;
    }
    
}
