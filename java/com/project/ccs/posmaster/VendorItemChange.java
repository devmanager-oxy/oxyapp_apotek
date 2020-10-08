package com.project.ccs.posmaster;

import java.util.Date;
import com.project.main.entity.*;

public class VendorItemChange extends Entity {

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
    
    private long vendorItemId;
    private Date date;
    private Date activeDate;
    private long userId;
    private int status;
    private double lastPriceOri;
    
    private String refNumber = "";
    private int counter;
    private String prefixNumber = "";
    
    public int getCounter() {
        return counter;
    }
    
    public void setCounter(int counter) {
        this.counter = counter;
    }
    
    
    public void setRefNumber(String refNumber) {
        this.refNumber = refNumber;
    }
    
    public String getRefNumber() {
        return refNumber;
    }
    
    public void setPrefixNumber(String prefixNumber) {
        this.prefixNumber = prefixNumber;
    }
    
    public String getPrefixNumber() {
        return prefixNumber;
    }
    
    public void setLastPriceOri(double lastPriceOri) {
        this.lastPriceOri = lastPriceOri;
    }
    
    public double getLastPriceOri() {
        return lastPriceOri;
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
    
    public long getVendorItemId() {
        return vendorItemId;
    }

    public void setVendorItemId(long vendorItemId) {
        this.vendorItemId = vendorItemId;
    }

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
