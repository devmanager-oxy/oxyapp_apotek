/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.posmaster;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author Ngurah Wirata
 */
public class CashCashier extends Entity {

    private long cashMasterId;
    private long userId;
    private long shiftId;
    private Date dateOpen;
    private long currencyIdOpen;
    private double rateOpen;
    private double amountOpen;
    private Date dateClosing;
    private long currencyIdClosing;
    private double rateClosing;
    private double amountClosing;
    private int status;
    
    public long getCashMasterId() {
        return cashMasterId;
    }

    public void setCashMasterId(long cashMasterId) {
        this.cashMasterId = cashMasterId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getShiftId() {
        return shiftId;
    }

    public void setShiftId(long shiftId) {
        this.shiftId = shiftId;
    }

    public long getCurrencyIdOpen() {
        return currencyIdOpen;
    }

    public void setCurrencyIdOpen(long currencyIdOpen) {
        this.currencyIdOpen = currencyIdOpen;
    }

    public double getRateOpen() {
        return rateOpen;
    }

    public void setRateOpen(double rateOpen) {
        this.rateOpen = rateOpen;
    }

    public double getAmountOpen() {
        return amountOpen;
    }

    public void setAmountOpen(double amountOpen) {
        this.amountOpen = amountOpen;
    }

    public long getCurrencyIdClosing() {
        return currencyIdClosing;
    }

    public void setCurrencyIdClosing(long currencyIdClosing) {
        this.currencyIdClosing = currencyIdClosing;
    }

    public double getRateClosing() {
        return rateClosing;
    }

    public void setRateClosing(double rateClosing) {
        this.rateClosing = rateClosing;
    }

    public double getAmountClosing() {
        return amountClosing;
    }

    public void setAmountClosing(double amountClosing) {
        this.amountClosing = amountClosing;
    }

    public Date getDateOpen() {
        return dateOpen;
    }

    public void setDateOpen(Date dateOpen) {
        this.dateOpen = dateOpen;
    }

    public Date getDateClosing() {
        return dateClosing;
    }

    public void setDateClosing(Date dateClosing) {
        this.dateClosing = dateClosing;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

   
    
   
}
