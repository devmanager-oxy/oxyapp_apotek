/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.sales;

import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class SalesPaymentCredit {

    //table pos_sales
    private long salesId;
    private String number = "";
    private Date date;
    private String name = "";
    private double amount;
    private long locationId;
    private long userId;
    private int counter;
    private String numberPrefix = "";
    private long customerId;    
    private int status;
    //table pos_credit_payment
    private long creditPaymentId;
    private Date paymentDateTime;
    private double amountCredit;

    public long getSalesId() {
        return salesId;
    }

    public void setSalesId(long salesId) {
        this.salesId = salesId;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getCreditPaymentId() {
        return creditPaymentId;
    }

    public void setCreditPaymentId(long creditPaymentId) {
        this.creditPaymentId = creditPaymentId;
    }

    public Date getPaymentDateTime() {
        return paymentDateTime;
    }

    public void setPaymentDateTime(Date paymentDateTime) {
        this.paymentDateTime = paymentDateTime;
    }

    public double getAmountCredit() {
        return amountCredit;
    }

    public void setAmountCredit(double amountCredit) {
        this.amountCredit = amountCredit;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public String getNumberPrefix() {
        return numberPrefix;
    }

    public void setNumberPrefix(String numberPrefix) {
        this.numberPrefix = numberPrefix;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
    
    //select sl.sales_id,cr.credit_payment_id,sl.number,sl.date,sl.name,sl.amount,location_id,cr.pay_datetime,cr.amount from pos_sales sl inner join pos_credit_payment cr on sl.sales_id = cr.sales_id order by sl.sales_id;
    
}
