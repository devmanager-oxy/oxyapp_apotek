package com.project.ccs.posmaster;

import java.util.Date;
import com.project.main.entity.*;

public class VendorItem extends Entity {

    private long itemMasterId;
    private long vendorId;
    private double lastPrice;
    private double lastDiscount;
    private Date updateDate;
    private double lastDisVal;
    private double regDisPercent;
    private double regDisValue;

    private double realPrice;
    private double marginPrice;

    public double getMarginPrice() {
        return marginPrice;
    }

    public void setMarginPrice(double marginPrice) {
        this.marginPrice = marginPrice;
    }

    public double getRealPrice() {
        return realPrice;
    }

    public void setRealPrice(double realPrice) {
        this.realPrice = realPrice;
    }
    
    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public double getLastPrice() {
        return lastPrice;
    }

    public void setLastPrice(double lastPrice) {
        this.lastPrice = lastPrice;
    }

    public double getLastDiscount() {
        return lastDiscount;
    }

    public void setLastDiscount(double lastDiscount) {
        this.lastDiscount = lastDiscount;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public double getRegDisPercent() {
        return regDisPercent;
    }

    public void setRegDisPercent(double regDisPercent) {
        this.regDisPercent = regDisPercent;
    }

    public double getRegDisValue() {
        return regDisValue;
    }

    public void setRegDisValue(double regDisValue) {
        this.regDisValue = regDisValue;
    }

    public double getLastDisVal() {
        return lastDisVal;
    }

    public void setLastDisVal(double lastDisVal) {
        this.lastDisVal = lastDisVal;
    }
}
