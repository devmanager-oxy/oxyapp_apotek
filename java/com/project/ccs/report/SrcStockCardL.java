/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.report;

/**
 *
 * @author Administrator
 */
public class SrcStockCardL {
    private String code;
    private String itemName;
    private double opening;
    private double qtyIn;
    private double qtyOut;
    private double saldo;
    private long locationId;
    private String locationName;
    private long itemMasterId;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getOpening() {
        return opening;
    }

    public void setOpening(double opening) {
        this.opening = opening;
    }

    public double getQtyIn() {
        return qtyIn;
    }

    public void setQtyIn(double qtyIn) {
        this.qtyIn = qtyIn;
    }

    public double getQtyOut() {
        return qtyOut;
    }

    public void setQtyOut(double qtyOut) {
        this.qtyOut = qtyOut;
    }

    public double getSaldo() {
        return saldo;
    }

    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }
    
    
}
