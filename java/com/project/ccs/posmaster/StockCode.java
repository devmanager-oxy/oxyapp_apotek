/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.posmaster;

import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */
public class StockCode extends Entity {

    private String code = "";
    private long locationId;
    private long itemMasterId;
    private int inOut;
    private int type;
    private long receiveId;
    private long returId;
    private long transferId;
    private double qty;
    private int status;
    private long receiveItemId;
    private long transferItemId;
    private long returItemId; 
    private int type_item;
    private long salesId;
    private long salesDetailId;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public int getInOut() {
        return inOut;
    }

    public void setInOut(int inOut) {
        this.inOut = inOut;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getReceiveId() {
        return receiveId;
    }

    public void setReceiveId(long receiveId) {
        this.receiveId = receiveId;
    }

    public long getReturId() {
        return returId;
    }

    public void setReturId(long returId) {
        this.returId = returId;
    }

    public long getTransferId() {
        return transferId;
    }

    public void setTransferId(long transferId) {
        this.transferId = transferId;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public long getReceiveItemId() {
        return receiveItemId;
    }

    public void setReceiveItemId(long receiveItemId) {
        this.receiveItemId = receiveItemId;
    }

    public long getTransferItemId() {
        return transferItemId;
    }

    public void setTransferItemId(long transferItemId) {
        this.transferItemId = transferItemId;
    }

    public long getReturItemId() {
        return returItemId;
    }

    public void setReturItemId(long returItemId) {
        this.returItemId = returItemId;
    }

    public int getType_item() {
        return type_item;
    }

    public void setType_item(int type_item) {
        this.type_item = type_item;
    }

    public long getSalesId() {
        return salesId;
    }

    public void setSalesId(long salesId) {
        this.salesId = salesId;
    }

    public long getSalesDetailId() {
        return salesDetailId;
    }

    public void setSalesDetailId(long salesDetailId) {
        this.salesDetailId = salesDetailId;
    }
}
