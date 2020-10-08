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
public class RptItemMasterL extends Entity {
    
    /**
     * Holds value of property doc.
     */
    
    private String code;
    private String barcode;
    private String name;
    private String vendor;
    private double gol1;
    private double gol2;
    private double gol3;
    private double gol4;
    private double gol5;
    private double lastPrice;
    private double mGol1;
    private double mGol2;
    private double mGol3;
    private double mGol4;
    private double mGol5;
    
    private Date date;
    
   
    
    /** Creates a new instance of RptPoSupplierL */
    public RptItemMasterL() {
    }
    
    /**
     * Getter for property doc.
     * @return Value of property doc.
     */
   

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
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

    public double getGol1() {
        return gol1;
    }

    public void setGol1(double gol1) {
        this.gol1 = gol1;
    }

    public double getGol2() {
        return gol2;
    }

    public void setGol2(double gol2) {
        this.gol2 = gol2;
    }

    public double getGol3() {
        return gol3;
    }

    public void setGol3(double gol3) {
        this.gol3 = gol3;
    }

    public double getGol4() {
        return gol4;
    }

    public void setGol4(double gol4) {
        this.gol4 = gol4;
    }

    public double getGol5() {
        return gol5;
    }

    public void setGol5(double gol5) {
        this.gol5 = gol5;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public double getLastPrice() {
        return lastPrice;
    }

    public void setLastPrice(double lastPrice) {
        this.lastPrice = lastPrice;
    }

    public double getMGol1() {
        return mGol1;
    }

    public void setMGol1(double mGol1) {
        this.mGol1 = mGol1;
    }

    public double getMGol2() {
        return mGol2;
    }

    public void setMGol2(double mGol2) {
        this.mGol2 = mGol2;
    }

    public double getMGol3() {
        return mGol3;
    }

    public void setMGol3(double mGol3) {
        this.mGol3 = mGol3;
    }

    public double getMGol4() {
        return mGol4;
    }

    public void setMGol4(double mGol4) {
        this.mGol4 = mGol4;
    }

    public double getMGol5() {
        return mGol5;
    }

    public void setMGol5(double mGol5) {
        this.mGol5 = mGol5;
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }

   
    

    
    
}
