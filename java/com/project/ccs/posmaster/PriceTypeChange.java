/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */

public class PriceTypeChange extends Entity {
    
    private long itemMasterId;
    
    private int qtyFrom;
    private int qtyTo;
    private double gol1;
    private double gol2;
    private double gol3;
    private double gol4;
    private double gol5;
    private double gol1_margin;
    private double gol2_margin;
    private double gol3_margin;
    private double gol4_margin;
    private double gol5_margin;
    private double gol1_marginOri;
    private double gol2_marginOri;
    private double gol3_marginOri;
    private double gol4_marginOri;
    private double gol5_marginOri;
    private double gol6;
    private double gol7;
    private double gol8;
    private double gol9;
    private double gol10;
    private double gol6_margin;
    private double gol7_margin;
    private double gol8_margin;
    private double gol9_margin;
    private double gol10_margin;
    private double gol6_marginOri;
    private double gol7_marginOri;
    private double gol8_marginOri;
    private double gol9_marginOri;
    private double gol10_marginOri;
    private long priceTypeId;
    private Date date;
    private Date activeDate;
    private long userId;
    private int status;
    
    private double gol1ori;
    private double gol2ori;
    private double gol3ori;
    private double gol4ori;
    private double gol5ori;
    private double gol6ori;
    private double gol7ori;
    private double gol8ori;
    private double gol9ori;
    private double gol10ori;       
    private Date changeDate;
    private String refNumber; 
    
    private long vendorId; 
    private int type ; 
    private String prefixNumber; 
    private int counter; 
    
    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }
    
    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }
    
    public String getRefNumber() {
        return refNumber;
    }

    public void setRefNumber(String refNumber) {
        this.refNumber = refNumber;
    }
    
    public double getGol1ori() {
        return gol1ori;
    }

    public void setGol1ori(double gol1ori) {
        this.gol1ori = gol1ori;
    }

    public double getGol2ori() {
        return gol2ori;
    }

    public void setGol2ori(double gol2ori) {
        this.gol2ori = gol2ori;
    }

    public double getGol3ori() {
        return gol3ori;
    }

    public void setGol3ori(double gol3ori) {
        this.gol3ori = gol3ori;
    }

    public double getGol4ori() {
        return gol4ori;
    }

    public void setGol4ori(double gol4ori) {
        this.gol4ori = gol4ori;
    }
    
    public double getGol5ori() {
        return gol5ori;
    }

    public void setGol5ori(double gol5ori) {
        this.gol5ori = gol5ori;
    }

    public double getGol6ori() {
        return gol6ori;
    }

    public void setGol6ori(double gol6ori) {
        this.gol6ori = gol6ori;
    }

    public double getGol7ori() {
        return gol7ori;
    }

    public void setGol7ori(double gol7ori) {
        this.gol7ori = gol7ori;
    }

    public double getGol8ori() {
        return gol8ori;
    }

    public void setGol8ori(double gol8ori) {
        this.gol8ori = gol8ori;
    }

    public double getGol9ori() {
        return gol9ori;
    }

    public void setGol9ori(double gol9ori) {
        this.gol9ori = gol9ori;
    }

    public double getGol10ori() {
        return gol10ori;
    }

    public void setGol10ori(double gol10ori) {
        this.gol10ori = gol10ori;
    }
    
    
    
    

    public void setStatus(int status) {
        this.status = status;
    }
    
    public int getStatus() {
        return status;
    }
    
    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
    
    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
    
    public Date getActiveDate() {
        return activeDate;
    }

    public void setActiveDate(Date activeDate) {
        this.activeDate = activeDate;
    }
    
    public long getPriceTypeId() {
        return priceTypeId;
    }

    public void setPriceTypeId(long priceTypeId) {
        this.priceTypeId = priceTypeId;
    }
    
    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public int getQtyFrom() {
        return qtyFrom;
    }

    public void setQtyFrom(int qtyFrom) {
        this.qtyFrom = qtyFrom;
    }

    public int getQtyTo() {
        return qtyTo;
    }

    public void setQtyTo(int qtyTo) {
        this.qtyTo = qtyTo;
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
    
    

    public double getGol1_margin() {
        return gol1_margin;
    }

    public void setGol1_margin(double gol1_margin) {
        this.gol1_margin = gol1_margin;
    }

    public double getGol2_margin() {
        return gol2_margin;
    }

    public void setGol2_margin(double gol2_margin) {
        this.gol2_margin = gol2_margin;
    }

    public double getGol3_margin() {
        return gol3_margin;
    }

    public void setGol3_margin(double gol3_margin) {
        this.gol3_margin = gol3_margin;
    }

    public double getGol4_margin() {
        return gol4_margin;
    }

    public void setGol4_margin(double gol4_margin) {
        this.gol4_margin = gol4_margin;
    }

    public double getGol5_margin() {
        return gol5_margin;
    }

    public void setGol5_margin(double gol5_margin) {
        this.gol5_margin = gol5_margin;
    }
    
    public double getGol1_marginOri() {
        return gol1_marginOri;
    }

    public void setGol1_marginOri(double gol1_marginOri) {
        this.gol1_marginOri = gol1_marginOri;
    }

    public double getGol2_marginOri() {
        return gol2_marginOri;
    }

    public void setGol2_marginOri(double gol2_marginOri) {
        this.gol2_marginOri = gol2_marginOri;
    }

    public double getGol3_marginOri() {
        return gol3_marginOri;
    }

    public void setGol3_marginOri(double gol3_marginOri) {
        this.gol3_marginOri = gol3_marginOri;
    }

    public double getGol4_marginOri() {
        return gol4_marginOri;
    }

    public void setGol4_marginOri(double gol4_marginOri) {
        this.gol4_marginOri = gol4_marginOri;
    }

    public double getGol5_marginOri() {
        return gol5_marginOri;
    }

    public void setGol5_marginOri(double gol5_marginOri) {
        this.gol5_marginOri = gol5_marginOri;
    }

    public double getGol5() {
        return gol5;
    }

    public void setGol5(double gol5) {
        this.gol5 = gol5;
    }

    public Date getChangeDate() {
        return changeDate;
    }

    public void setChangeDate(Date changeDate) {
        this.changeDate = changeDate;
    }

    public double getGol6() {
        return gol6;
    }

    public void setGol6(double gol6) {
        this.gol6 = gol6;
    }

    public double getGol7() {
        return gol7;
    }

    public void setGol7(double gol7) {
        this.gol7 = gol7;
    }

    public double getGol8() {
        return gol8;
    }

    public void setGol8(double gol8) {
        this.gol8 = gol8;
    }

    public double getGol9() {
        return gol9;
    }

    public void setGol9(double gol9) {
        this.gol9 = gol9;
    }

    public double getGol10() {
        return gol10;
    }

    public void setGol10(double gol10) {
        this.gol10 = gol10;
    }

    public double getGol6_margin() {
        return gol6_margin;
    }

    public void setGol6_margin(double gol6_margin) {
        this.gol6_margin = gol6_margin;
    }

    public double getGol7_margin() {
        return gol7_margin;
    }

    public void setGol7_margin(double gol7_margin) {
        this.gol7_margin = gol7_margin;
    }

    public double getGol8_margin() {
        return gol8_margin;
    }

    public void setGol8_margin(double gol8_margin) {
        this.gol8_margin = gol8_margin;
    }

    public double getGol9_margin() {
        return gol9_margin;
    }

    public void setGol9_margin(double gol9_margin) {
        this.gol9_margin = gol9_margin;
    }

    public double getGol10_margin() {
        return gol10_margin;
    }

    public void setGol10_margin(double gol10_margin) {
        this.gol10_margin = gol10_margin;
    }
    
    public double getGol6_marginOri() {
        return gol6_marginOri;
    }

    public void setGol6_marginOri(double gol6_marginOri) {
        this.gol6_marginOri = gol6_marginOri;
    }

    public double getGol7_marginOri() {
        return gol7_marginOri;
    }

    public void setGol7_marginOri(double gol7_marginOri) {
        this.gol7_marginOri = gol7_marginOri;
    }

    public double getGol8_marginOri() {
        return gol8_marginOri;
    }

    public void setGol8_marginOri(double gol8_marginOri) {
        this.gol8_marginOri = gol8_marginOri;
    }

    public double getGol9_marginOri() {
        return gol9_marginOri;
    }

    public void setGol9_marginOri(double gol9_marginOri) {
        this.gol9_marginOri = gol9_marginOri;
    }

    public double getGol10_marginOri() {
        return gol10_marginOri;
    }

    public void setGol10_marginOri(double gol10_marginOri) {
        this.gol10_marginOri = gol10_marginOri;
    }

    public String getPrefixNumber() {
        return prefixNumber;
    }

    public void setPrefixNumber(String prefixNumber) {
        this.prefixNumber = prefixNumber;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }
    
}
