/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;

import com.project.main.entity.*;
import java.util.Date;
/**
 *
 * @author Roy Andika
 */
public class StockDays extends Entity {

    private long locationId = 0;
    private long itemGroupId = 0;    
    
    private int month =0;
    private int year = 0;
    
    private long userId = 0;
    private Date updateDate;
    
    private double stockDaysEOD = 0; // stock days end of month
    private int days = 0;
    private double dayaBeli = 0;

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getItemGroupId() {
        return itemGroupId;
    }

    public void setItemGroupId(long itemGroupId) {
        this.itemGroupId = itemGroupId;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public double getStockDaysEOD() {
        return stockDaysEOD;
    }

    public void setStockDaysEOD(double stockDaysEOD) {
        this.stockDaysEOD = stockDaysEOD;
    }

   

    public double getDayaBeli() {
        return dayaBeli;
    }

    public void setDayaBeli(double dayaBeli) {
        this.dayaBeli = dayaBeli;
    }

    public int getDays() {
        return days;
    }

    public void setDays(int days) {
        this.days = days;
    }
}
