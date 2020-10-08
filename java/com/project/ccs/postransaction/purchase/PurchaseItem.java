/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.purchase;
import com.project.main.entity.Entity;
import java.util.Date;

public class PurchaseItem extends Entity {

    private long purchaseId;
    private long itemMasterId;
    private double qty;
    private long uomId;
    private String status;
    private double amount;
    private double totalAmount;
    private double totalDiscount;
    private Date deliveryDate;
    private double lastDisPercent;
    private double regDisVal;
    private double regDisPercent;

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getDeliveryDate() {
        return deliveryDate;
    }

    public void setDeliveryDate(Date deliveryDate) {
        this.deliveryDate = deliveryDate;
    } 

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public long getPurchaseId() {
        return purchaseId;
    }

    public void setPurchaseId(long purchaseId) {
        this.purchaseId = purchaseId;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getTotalDiscount() {
        return totalDiscount;
    }

    public void setTotalDiscount(double totalDiscount) {
        this.totalDiscount = totalDiscount;
    }

    public long getUomId() {
        return uomId;
    }

    public void setUomId(long uomId) {
        this.uomId = uomId;
    }

   

    public double getRegDisVal() {
        return regDisVal;
    }

    public void setRegDisVal(double regDisVal) {
        this.regDisVal = regDisVal;
    }

    public double getRegDisPercent(){
        return regDisPercent;
    }

    public void setRegDisPercent(double regDisPercent){
        this.regDisPercent = regDisPercent;
    }

    public double getLastDisPercent() {
        return lastDisPercent;
    }

    public void setLastDisPercent(double lastDisPercent) {
        this.lastDisPercent = lastDisPercent;
    }
}
