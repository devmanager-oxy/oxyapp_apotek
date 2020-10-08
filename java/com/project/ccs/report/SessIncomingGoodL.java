/*
 * SessIncomingGoodL.java
 *
 * Created on January 19, 2009, 12:26 AM
 */

package com.project.ccs.report;

import java.util.*;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class SessIncomingGoodL extends Entity {
    
    /**
     * Holds value of property group.
     */
    private String group;
    
    /**
     * Holds value of property price.
     */
    private double price;
    
    /**
     * Holds value of property qty.
     */
    private double qty;
    
    /**
     * Holds value of property discount.
     */
    private double discount;
    
    /**
     * Holds value of property total.
     */
    private double total;
    
    /**
     * Holds value of property unit.
     */
    private String unit;
    
    /**
     * Holds value of property expiredDate.
     */
    private Date expiredDate;
    
    /** Creates a new instance of SessIncomingGoodL */
    public SessIncomingGoodL() {
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
     * Getter for property price.
     * @return Value of property price.
     */
    public double getPrice() {
        return this.price;
    }
    
    /**
     * Setter for property price.
     * @param price New value of property price.
     */
    public void setPrice(double price) {
        this.price = price;
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
     * Getter for property discount.
     * @return Value of property discount.
     */
    public double getDiscount() {
        return this.discount;
    }
    
    /**
     * Setter for property discount.
     * @param discount New value of property discount.
     */
    public void setDiscount(double discount) {
        this.discount = discount;
    }
    
    /**
     * Getter for property total.
     * @return Value of property total.
     */
    public double getTotal() {
        return this.total;
    }
    
    /**
     * Setter for property total.
     * @param total New value of property total.
     */
    public void setTotal(double total) {
        this.total = total;
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
     * Getter for property expiredDate.
     * @return Value of property expiredDate.
     */
    public Date getExpiredDate() {
        return this.expiredDate;
    }
    
    /**
     * Setter for property expiredDate.
     * @param expiredDate New value of property expiredDate.
     */
    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }
    
}
