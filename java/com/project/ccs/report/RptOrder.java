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
public class RptOrder extends Entity {
    
    /**
     * Holds value of property doc.
     */
    
    private String code;
    private String barcode;
    private String name;
    private String number;
    private String location;
    private Date date;
    private double qty_order;
    
    
   
    
    /** Creates a new instance of RptPoSupplierL */
    public RptOrder() {
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getQty_order() {
        return qty_order;
    }

    public void setQty_order(double qty_order) {
        this.qty_order = qty_order;
    }
    
    /**
     * Getter for property doc.
     * @return Value of property doc.
     */
   

    

    
    
}
