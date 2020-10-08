/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.session;

import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class PlafonBank {
    
    private long salesDataId;
    private String salesNumber = "";
    private String name = "";
    private Date dateTransaction;
    private double finalPrice;

    public long getSalesDataId() {
        return salesDataId;
    }

    public void setSalesDataId(long salesDataId) {
        this.salesDataId = salesDataId;
    }

    public String getSalesNumber() {
        return salesNumber;
    }

    public void setSalesNumber(String salesNumber) {
        this.salesNumber = salesNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getDateTransaction() {
        return dateTransaction;
    }

    public void setDateTransaction(Date dateTransaction) {
        this.dateTransaction = dateTransaction;
    }

    public double getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(double finalPrice) {
        this.finalPrice = finalPrice;
    }

}
