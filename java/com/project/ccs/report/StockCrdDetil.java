/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.report;

import java.util.Date;

/**
 *
 * @author Administrator
 */
public class StockCrdDetil {
    private String code;
    private String itemName;
    private double opening;
    private double qtyIn;
    private double qtyOut;
    private double saldo;
    private long locationId;
    
    private String locationName;
    private long itemMasterId;
    private Date date;        
    private String docNumber;
    private String status;
    private int type;
    private long vendorId;
    private int type_repack;
    

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

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getDocNumber() {
        return docNumber;
    }

    public void setDocNumber(String docNumber) {
        this.docNumber = docNumber;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public int getType_repack() {
        return type_repack;
    }

    public void setType_repack(int type_repack) {
        this.type_repack = type_repack;
    }

    
    
    
}
