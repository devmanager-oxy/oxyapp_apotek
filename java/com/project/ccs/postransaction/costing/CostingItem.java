package com.project.ccs.postransaction.costing;

import com.project.main.entity.*;

public class CostingItem extends Entity {

    private long costingId;
    private long itemMasterId;
    private double qty = 0;
    private double price = 0;
    private double amount = 0;

    public long getCostingId() {
        return costingId;
    }

    public void setCostingId(long costingId) {
        this.costingId = costingId;
    }

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
}
