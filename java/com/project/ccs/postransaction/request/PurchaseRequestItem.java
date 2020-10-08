/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.request;

import com.project.main.entity.Entity;

public class PurchaseRequestItem extends Entity {

    private long purchaseRequestId = 0;
    private long itemMasterId = 0;
    private double qty = 0;
    private long uomId = 0;
    private String status = "";
    private int itemStatus = -1;
    private int processQty = 0;

    public int getItemStatus() {
        return itemStatus;
    } 

    public void setItemStatus(int itemStatus) {
        this.itemStatus = itemStatus;
    }

    public int getProcessQty() {
        return processQty;
    }

    public void setProcessQty(int processQty) {
        this.processQty = processQty;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public long getPurchaseRequestId() {
        return purchaseRequestId;
    }

    public void setPurchaseRequestId(long purchaseRequestId) {
        this.purchaseRequestId = purchaseRequestId;
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

    public long getUomId() {
        return uomId;
    }

    public void setUomId(long uomId) {
        this.uomId = uomId;
    }
}
