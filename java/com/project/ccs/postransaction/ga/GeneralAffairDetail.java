/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.ga;

import com.project.main.entity.*;

/**
 *
 * @author Roy
 */
public class GeneralAffairDetail extends Entity {

    private long generalAffairId = 0;
    private long itemMasterId = 0;
    private double qty = 0;
    private double price = 0;
    private double amount = 0;

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public long getGeneralAffairId() {
        return generalAffairId;
    }

    public void setGeneralAffairId(long generalAffairId) {
        this.generalAffairId = generalAffairId;
    }
}
