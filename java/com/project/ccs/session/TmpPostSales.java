/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.session;

import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class TmpPostSales {

    private long salesId = 0;
    private String number = "";
    private Date date = new Date();
    private int type = 0;
    private String name = "";
    private double total = 0;
    private double discount = 0;
    private double biayaKartu = 0;
    private double diskonKartu = 0;

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

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getBiayaKartu() {
        return biayaKartu;
    }

    public void setBiayaKartu(double biayaKartu) {
        this.biayaKartu = biayaKartu;
    }

    public double getDiskonKartu() {
        return diskonKartu;
    }

    public void setDiskonKartu(double diskonKartu) {
        this.diskonKartu = diskonKartu;
    }
}
