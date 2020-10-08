/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import java.util.Date;

/**
 *
 * @author Roy
 */
public class CreditMember {
    
    private Date date = new Date();
    private long salesId = 0;
    private String number = "";
    private String customer = "";
    private double total = 0;
    private double paid = 0;
    private double retur = 0;

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

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

    public String getCustomer() {
        return customer;
    }

    public void setCustomer(String customer) {
        this.customer = customer;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public double getPaid() {
        return paid;
    }

    public void setPaid(double paid) {
        this.paid = paid;
    }

    public double getRetur() {
        return retur;
    }

    public void setRetur(double retur) {
        this.retur = retur;
    }

}
