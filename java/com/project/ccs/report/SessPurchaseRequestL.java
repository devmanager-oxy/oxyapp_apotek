/*
 * SessPurchaseRequestL.java
 *
 * Created on January 16, 2009, 10:00 PM
 */

package com.project.ccs.report;

import java.util.*;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class SessPurchaseRequestL extends Entity {
    
    /**
     * Holds value of property product.
     */
    private String product;
    
    /**
     * Holds value of property group.
     */
    private String group;
    
    /**
     * Holds value of property category.
     */
    private String category;
    
    /**
     * Holds value of property qty.
     */
    private double qty;
    
    /**
     * Holds value of property unit.
     */
    private String unit;
    
    /**
     * Holds value of property poStatus.
     */
    private int poStatus;
    
    /** Creates a new instance of SessPurchaseRequestL */
    public SessPurchaseRequestL() {
    }
    
    /**
     * Getter for property product.
     * @return Value of property product.
     */
    public String getProduct() {
        return this.product;
    }
    
    /**
     * Setter for property product.
     * @param product New value of property product.
     */
    public void setProduct(String product) {
        this.product = product;
    }
    
    /**
     * Getter for property group.
     * @return Value of property group.
     */
    public String getGroup() {
        return this.group;
    }
    
    /**
     * Setter for property group.
     * @param group New value of property group.
     */
    public void setGroup(String group) {
        this.group = group;
    }
    
    /**
     * Getter for property category.
     * @return Value of property category.
     */
    public String getCategory() {
        return this.category;
    }
    
    /**
     * Setter for property category.
     * @param category New value of property category.
     */
    public void setCategory(String category) {
        this.category = category;
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
     * Getter for property unit.
     * @return Value of property unit.
     */
    public String getUnit() {
        return this.unit;
    }
    
    /**
     * Setter for property unit.
     * @param unit New value of property unit.
     */
    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    /**
     * Getter for property poStatus.
     * @return Value of property poStatus.
     */
    public int getPoStatus() {
        return this.poStatus;
    }
    
    /**
     * Setter for property poStatus.
     * @param poStatus New value of property poStatus.
     */
    public void setPoStatus(int poStatus) {
        this.poStatus = poStatus;
    }
    
}
