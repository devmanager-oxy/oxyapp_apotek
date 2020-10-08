/*
 * SessPoReturnL.java
 *
 * Created on January 17, 2009, 9:29 AM
 */

package com.project.ccs.report;

import java.util.*;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class SessPoReturL extends Entity {
    
    /**
     * Holds value of property group.
     */
    private String group;
    
    /**
     * Holds value of property receive.
     */
    private double receive;
    
    /**
     * Holds value of property prevRetur.
     */
    private double prevRetur;
    
    /**
     * Holds value of property retur.
     */
    private double retur;
    
    /**
     * Holds value of property price.
     */
    private double price;
    
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
    
    /** Creates a new instance of SessPoReturnL */
    public SessPoReturL() {
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
     * Getter for property receive.
     * @return Value of property receive.
     */
    public double getReceive() {
        return this.receive;
    }
    
    /**
     * Setter for property receive.
     * @param receive New value of property receive.
     */
    public void setReceive(double receive) {
        this.receive = receive;
    }
    
    /**
     * Getter for property prevReturn.
     * @return Value of property prevReturn.
     */
    public double getPrevRetur() {
        return this.prevRetur;
    }
    
    /**
     * Setter for property prevReturn.
     * @param prevReturn New value of property prevReturn.
     */
    public void setPrevRetur(double prevRetur) {
        this.prevRetur = prevRetur;
    }
    
    /**
     * Getter for property retur.
     * @return Value of property retur.
     */
    public double getRetur() {
        return this.retur;
    }
    
    /**
     * Setter for property retur.
     * @param retur New value of property retur.
     */
    public void setRetur(double retur) {
        this.retur = retur;
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
    
}
