/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.posmaster;

import com.project.main.entity.*;

/**
 *
 * @author Ngurah Wirata
 */
public class CashMaster extends Entity {

    
    private int cashierNumber;
    private long locationId;

    public int getCashierNumber() {
        return cashierNumber;
    }

    public void setCashierNumber(int cashierNumber) {
        this.cashierNumber = cashierNumber;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }
   
    
   
}
