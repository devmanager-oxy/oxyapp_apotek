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
public class RptChangePriceL extends Entity {
    
    /**
     * Holds value of property doc.
     */
    
    private String code;
    private String barcode;
    private String name;
    private double gol1;
    private double gol2;
    private double gol3;
    private double gol4;
    private double gol5;
    private double gol6;
    private double gol7;
    private double gol8;
    private double gol9;
    private double gol10;
    private double gol11;
    private Date date;
    private String refNumber;
    
    public String getRefNumber() {
        return refNumber;
    }

    public void setRefNumber(String refNumber) {
        this.refNumber = refNumber;
    }
    
    public void setGol9(double gol9) {
        this.gol9 = gol9;
    }

    public double getGol9() {
        return gol9;
    }
    
    public void setGol10(double gol10) {
        this.gol10 = gol10;
    }

    public double getGol10() {
        return gol10;
    }
    
    public void setGol8(double gol8) {
        this.gol8 = gol8;
    }

    public double getGol8() {
        return gol8;
    }
    
    public void setGol7(double gol7) {
        this.gol7 = gol7;
    }

    public double getGol7() {
        return gol7;
    }
    
    public void setGol6(double gol6) {
        this.gol6 = gol6;
    }

    public double getGol6() {
        return gol6;
    }
    
    /** Creates a new instance of RptPoSupplierL */
    public RptChangePriceL() {
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

    public double getGol11() {
        return gol11;
    }

    public void setGol11(double gol11) {
        this.gol11 = gol11;
    }

   
    

    
    
}
