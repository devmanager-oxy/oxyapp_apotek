/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;

import com.project.main.entity.*;
import java.util.Date;
/**
 *
 * @author Ngurah Wirata
 */
public class StockMinItem extends Entity {
    private long locationId;
    private long itemMasterId;
    private String itemName = "";
    private String code = "";
    private String barcode = "";
    private double minStock;
    private double deliveryUnit;

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

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public double getMinStock() {
        return minStock;
    }

    public void setMinStock(double minStock) {
        this.minStock = minStock;
    }

    public double getDeliveryUnit() {
        return deliveryUnit;
    }

    public void setDeliveryUnit(double deliveryUnit) {
        this.deliveryUnit = deliveryUnit;
    }
    

}
