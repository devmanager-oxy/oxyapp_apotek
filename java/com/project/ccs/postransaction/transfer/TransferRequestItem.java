/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.transfer;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */
public class TransferRequestItem extends Entity {

    private long transferRequestId = 0;
    private long itemMasterId = 0;
    private Date date;    
    private double qty = 0;        
    private long userId = 0; 
    private String itemBarcode= "";

    public long getTransferRequestId() {
        return transferRequestId;
    }

    public void setTransferRequestId(long transferRequestId) {
        this.transferRequestId = transferRequestId;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }


    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }


    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getItemBarcode() {
        return itemBarcode;
    }

    public void setItemBarcode(String itemBarcode) {
        this.itemBarcode = itemBarcode;
    }
}
