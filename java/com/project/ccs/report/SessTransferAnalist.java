/*
 * SessIncomingGood.java
 *
 * Created on January 19, 2009, 12:21 AM
 */

package com.project.ccs.report;

import java.util.*;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class SessTransferAnalist extends Entity {
    
    private String transferNumber;
    private long transferId;
    private String locationName;
    private String itemName;
    private long itemMasterId;
    private long toLocationId;
    private double qty;

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public long getToLocationId() {
        return toLocationId;
    }

    public void setToLocationId(long toLocationId) {
        this.toLocationId = toLocationId;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public String getTransferNumber() {
        return transferNumber;
    }

    public void setTransferNumber(String transferNumber) {
        this.transferNumber = transferNumber;
    }

    public long getTransferId() {
        return transferId;
    }

    public void setTransferId(long transferId) {
        this.transferId = transferId;
    }
    
    
    
    
}
