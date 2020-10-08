/*
 * SessPurchaseOrderL.java
 *
 * Created on January 17, 2009, 10:01 AM
 */

package com.project.ccs.report;
import java.util.*;
import com.project.main.entity.*;
/**
 *
 * @author  offices
 */
public class SessDirectReturL extends Entity {
    
    /**
     * Holds value of property group.
     */
    private String group;
    private String barcode;
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
     * Holds value of property deliveryDate.
     */
    private Date deliveryDate;
    
    /** Creates a new instance of SessPurchaseOrderL */
    public SessDirectReturL() {
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
     * Getter for property deliveryDate.
     * @return Value of property deliveryDate.
     */
    public Date getDeliveryDate() {
        return this.deliveryDate;
    }
    
    /**
     * Setter for property deliveryDate.
     * @param deliveryDate New value of property deliveryDate.
     */
    public void setDeliveryDate(Date deliveryDate) {
        this.deliveryDate = deliveryDate;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }
    
}
